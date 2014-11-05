class TimeEntryCreator
  attr_reader :api_url, :auth_token, :trello_key, :trello_token, :time_entry,
              :fb_client, :trello_client

  def initialize(api_url:, auth_token:, trello_key:nil, trello_token:nil,
                 time_entry:)
    @api_url      = api_url
    @auth_token   = auth_token
    @trello_key   = trello_key
    @trello_token = trello_token
    @time_entry   = time_entry
    @fb_client    = FreshBooksApi::TimeEntries.new(api_url, auth_token)

    return unless trello_key && trello_token

    @trello_client = TrelloApi.new(trello_key, trello_token)
  end

  def create
    create_on_freshbooks
    save_locally
    update_trello_card
    time_entry
  end

  private

  def create_on_freshbooks
    fb_entry           = fb_client.create(time_entry.except(:card_id))
    time_entry[:fb_id] = fb_entry['time_entry_id']
  end

  def save_locally
    format_time_entry_for_creation
    @time_entry = TimeEntry.create!(time_entry)
  end

  def format_time_entry_for_creation
    [:project_id, :task_id, :staff_id].each do |key|
      time_entry[('fb_' + key.to_s).to_sym] = time_entry[key]
      time_entry.delete key
    end

    time_entry[:trello_card_id] = time_entry[:card_id]
    time_entry.delete :card_id
  end

  def update_trello_card
    return unless time_entry[:trello_card_id] && trello_client

    # TODO: This method would be better within the CardActualsUpdater. We'd have
    # to pass in the fb_client instance which seems weird though. Like we're
    # breaking SRP
    update_stored_entries

    updater = Trello::CardActualsUpdater.new(trello_client)
    updater.update_card(time_entry[:trello_card_id])
  end

  def update_stored_entries
    records_for_card.each do |entry|
      entry.update_from_freshbooks(fb_client)
    end
  end

  def records_for_card
    TimeEntry.where(trello_card_id: time_entry[:trello_card_id])
  end
end
