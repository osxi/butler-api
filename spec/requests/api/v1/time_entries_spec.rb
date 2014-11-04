require 'rails_helper'

describe 'TimeEntries' do
  describe 'post' do
    it 'creates a time entry on freshbooks', :vcr do
      post '/api/v1/time_entries',
           api_url: ENV['FB_API_URL'],
           auth_token: ENV['FB_AUTH_TOKEN'],
           time_entry: {
             project_id: 3020,
             task_id: 46_805,
             staff_id: 1,
             hours: 0.5,
             notes: 'Did something cool',
             date: Date.iso8601('2014-10-31T20:47:38.213Z')
           }

      expect(response).to be_success
      expect(json['fb_id']).to be_present
    end

    describe 'with card_id', :vcr do
      it 'create on freshbooks and updates on trello', :vcr do
        post '/api/v1/time_entries',
             api_url:      ENV['FB_API_URL'],
             auth_token:   ENV['FB_AUTH_TOKEN'],
             trello_key:   ENV['TRELLO_KEY'],
             trello_token: ENV['TRELLO_TOKEN'],
             time_entry: {
               project_id: 3020,
               task_id: 46_805,
               staff_id: 1,
               hours: 0.5,
               notes: 'Did something cool',
               date: Date.iso8601('2014-10-31T20:47:38.213Z'),
               card_id: 'FzLuqJAu'
             }

        expect(response).to be_success
        expect(json['fb_id']).to be_present
      end
    end
  end
end
