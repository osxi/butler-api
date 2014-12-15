module FreshBooksApi
  class TimeEntries < Client
    TIME_FORMAT = '%Y-%m-%d'

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

      entries = all(date_from: from.strftime(TIME_FORMAT),
                    date_to:   to.strftime(TIME_FORMAT))

      entries.map do |fb_entry|
        trello_card_id = get_trello_card_id(fb_entry['notes'])

        find_and_update_entry(fb_entry, trello_card_id)
      end
    end

    def report(project_ids:, from:, to:)
      from = from.strftime(TIME_FORMAT)
      to   = to.strftime(TIME_FORMAT)

      project_ids.inject([]) do |res, project_id|
        entries = all(project_id: project_id, date_from: from, date_to: to)
        res.concat(entries)
      end
    end

    private

    def find_and_update_entry(fb_entry, trello_card_id)
      query      = { fb_id: fb_entry['time_entry_id'] }
      time_entry = TimeEntry.find_or_initialize_by(query)

      update_properties(time_entry, fb_entry, trello_card_id)
    end

    def update_properties(time_entry, entry, trello_card_id)
      time_entry.update_attributes({
        hours:           entry['hours'],
        date:            entry['date'],
        notes:           entry['notes'],
        trello_card_id:  trello_card_id,
        project: Project.find_or_initialize_by(fb_project_id: entry['project_id']),
        task:    Task.find_or_initialize_by(fb_task_id: entry['task_id']),
        user:    User.find_or_initialize_by(fb_staff_id: entry['staff_id'])
      })
      time_entry
    end

    def get_trello_card_id(notes)
      card_id = FreshBooksApi::TimeEntryParser.new(notes).card_id

      return nil if card_id == :no_card_id_found

      card_id
    end
  end
end
