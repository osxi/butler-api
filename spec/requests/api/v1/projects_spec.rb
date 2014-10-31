require 'rails_helper'

describe 'Projects' do
  describe 'get' do
    it 'returns a list of projects', :vcr do
      get '/api/v1/projects',
          api_url: ENV['FB_API_URL'],
          auth_token: ENV['FB_AUTH_TOKEN']

      expect(response).to be_success
      expect(json['projects'].length).to be > 0
    end
  end
end
