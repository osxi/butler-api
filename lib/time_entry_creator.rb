class TimeEntryCreator
  attr_accessor :api_url, :auth_token, :trello_key, :trello_token, :time_entry

  def initialize(api_url:, auth_token:, trello_key:nil, trello_token:nil, time_entry:)
    @api_url      = api_url
    @auth_token   = auth_token
    @trello_key   = trello_key
    @trello_token = trello_token
    @time_entry   = time_entry
  end

  def create
    create_on_freshbooks
    save_locally
    update_trello_card
    time_entry
  end

  private

  def create_on_freshbooks
    fb_client = FreshBooksApi::TimeEntries.new(api_url, auth_token)

    fb_entry           = fb_client.create(time_entry)
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
  end

  def update_trello_card
    update_stored_entries
  end

  def update_stored_entries
  end
end
