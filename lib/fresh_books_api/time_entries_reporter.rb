module FreshBooksApi
  class TimeEntriesReporter < TimeEntries
    def report(project_ids:, from:, to:, only_billable:true)
      entries = project_ids.inject([]) do |res, project_id|
        entries = all(project_id: project_id,
                      date_from: from.strftime(TIME_FORMAT),
                      date_to: to.strftime(TIME_FORMAT))
        res.concat(entries)
      end

      format_entries entries, only_billable
    end

    private

    def format_entries(entries, only_billable)
      entries = add_non_default_fields entries
      entries = filter_entries entries, only_billable
      entries = remove_unwanted_fields entries
      entries
    end

    def filter_entries(entries, only_billable)
      entries = filter_non_billable entries if only_billable
      entries
    end

    def filter_non_billable(rows)
      rows.select { |row| row['billable'] }
    end

    def remove_unwanted_fields(time_entries)
      time_entries.map do |entry|
        entry.except('time_entry_id', 'project_id', 'task_id', 'staff_id',
                     'billable')
      end
    end

    def add_non_default_fields(time_entries)
      time_entries.map do |entry|
        entry = add_card_id(entry)
        entry = add_staff_name(entry)
        entry = add_billable(entry)
        entry
      end
    end

    def add_billable(entry)
      task = Task.find_by(fb_task_id: entry['task_id'])
      entry['billable'] = task.try(:billable?) || false
      entry
    end

    def add_card_id(entry)
      entry['trello_card_id'] = get_trello_card_id(entry['notes'])
      entry
    end

    def add_staff_name(entry)
      entry['staff_name'] = User.try_name_from_fb_staff_id(entry['staff_id'])
      entry
    end
  end
end
