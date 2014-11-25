module FreshBooksApi
  class TimeEntries < Client
    def create(attributes)
      attributes[:date] = Date.today unless attributes[:date].present?
      respond client.time_entry.create(time_entry: attributes.to_h)
    end

    def get(id)
      respond client.time_entry.get(time_entry_id: id)
    end

    def all(options = {})
      list_get_all(:time_entry, :time_entries, :time_entry, options)
    end

    def import_all(from:nil, to:nil)
      from = DateTime.now - 1.days unless from.present?
      to   = DateTime.now unless to.present?

      time_format = '%Y-%m-%d'
      entries = all(date_from: from.strftime(time_format),
                    date_to:   to.strftime(time_format))

      entries.map do |fb_entry|
        trello_card_id = get_trello_card_id(fb_entry['notes'])

        time_entry = find_and_update_entry(fb_entry, trello_card_id)

        time_entry.save
        time_entry
      end
    end

    def get_freshbooks_staff_name(staff_id)
      res = respond client.staff.get(staff_id: staff_id)
      res['staff']['first_name'] + ' ' + res['staff']['last_name']
    end

    def get_freshbooks_project_name(project_id)
      res = respond client.project.get(project_id: project_id)
      res['project']['name']
    end

    def get_freshbooks_task_name(task_id)
      res = respond client.task.get(task_id: task_id)
      res['task']['name']
    end

    private

    def find_and_update_entry(fb_entry, trello_card_id)
      query      = { fb_id: fb_entry['time_entry_id'] }
      time_entry = TimeEntry.find_or_initialize_by(query)

      update_properties(time_entry, fb_entry, trello_card_id)
    end

    def update_properties(time_entry, entry, trello_card_id)
      time_entry.fb_staff_id    = entry['staff_id']
      time_entry.fb_project_id  = entry['project_id']
      time_entry.fb_task_id     = entry['task_id']
      time_entry.hours          = entry['hours']
      time_entry.date           = entry['date']
      time_entry.notes          = entry['notes']
      time_entry.trello_card_id = trello_card_id
      time_entry.name           = get_freshbooks_staff_name(entry['staff_id'])
      time_entry.project_name   = get_freshbooks_project_name(entry['project_id'])
      time_entry.task_name      = get_freshbooks_task_name(entry['task_id'])
      time_entry.user           = User.find_by(fb_staff_id: entry['staff_id'])
      time_entry
    end

    def get_trello_card_id(notes)
      card_id = FreshBooksApi::TimeEntryParser.new(notes).card_id

      return nil if card_id == :no_card_id_found

      card_id
    end
  end
end
