require 'rails_helper'

describe 'Staff' do
  describe 'get' do
    it 'returns a list of staff', :vcr do
      get '/api/v1/staff',
          api_url: ENV['FB_API_URL'],
          auth_token: ENV['FB_AUTH_TOKEN']

      expect(response).to be_success
      expect(json['staff'].length).to be > 0
    end
  end
end
