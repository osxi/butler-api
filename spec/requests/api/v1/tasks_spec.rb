require 'rails_helper'

describe 'Tasks' do
  describe 'get' do
    it 'returns a list of tasks', :vcr do
      get '/api/v1/tasks',
          api_url: ENV['FB_API_URL'],
          auth_token: ENV['FB_AUTH_TOKEN']

      expect(response).to be_success
      expect(json['tasks'].length).to be > 0
    end
  end
end
