require 'rails_helper'

describe TimeEntry, type: :model do
  it { should respond_to(:update_from_freshbooks) }

  context '#update_from_freshbooks', :vcr do
    let(:api_url) { ENV['FB_API_URL'] }
    let(:auth_token) { ENV['FB_AUTH_TOKEN'] }
    let(:client) { FreshBooksApi::TimeEntries.new(api_url, auth_token) }
    let(:time_entry) do
      TimeEntry.create(
        notes:  'Incorrect',
        fb_id:  '70926',
        hours:  2.3
      )
    end

    it 'should update card info to match freshbooks' do
      expect(time_entry.notes).to eql 'Incorrect'
      expect(time_entry.hours).to eql 2.3

      time_entry.update_from_freshbooks(client)

      expect(time_entry.notes).to eql 'Did something cool'
      expect(time_entry.hours).to eql 0.5
    end
  end
end
