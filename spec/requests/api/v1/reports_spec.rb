require 'rails_helper'

describe 'Reports' do
  describe '/freshbooks/time_entries' do
    describe 'get', :vcr do
      before do
        get '/api/v1/reports/freshbooks/time_entries',
          project_ids: [3020],
          start_date: Date.iso8601('2014-12-15T00:00:00.213Z'),
          end_date:   Date.iso8601('2014-12-15T23:59:00.213Z')
      end

      it 'should be success' do
        expect(response).to be_success
      end

      it 'returns a list' do
        expect(json['time_entries'].length).to be > 0
      end
    end
  end
end
