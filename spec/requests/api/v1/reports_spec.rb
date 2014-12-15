require 'rails_helper'

describe 'Reports' do
  describe '/freshbooks/time_entries' do
    describe 'get', :vcr do
      before do
        get '/api/v1/reports/freshbooks/time_entries', {
          project_ids: [3020],
          start_date: Date.iso8601('2014-12-15T00:00:00.213Z'),
          end_date:   Date.iso8601('2014-12-15T23:59:00.213Z')
        }.merge(auth_params)
      end

      it 'should be success' do
        expect(response).to be_success
      end

      it 'returns a list' do
        expect(json['time_entries'].length).to be > 0
      end
    end

    it 'must be authenticated' do
      get '/api/v1/reports/freshbooks/time_entries', {
        project_ids: [3020],
        start_date: Date.iso8601('2014-12-15T00:00:00.213Z'),
        end_date:   Date.iso8601('2014-12-15T23:59:00.213Z')
      }

      expect(response.status).to eq 401
    end
  end

  describe '/trello/cards' do
    describe 'get', :vcr do
      before do
        get '/api/v1/reports/trello/cards', {
          board_ids: ['wusd8mr6']
        }.merge(auth_params)
      end

      it 'should be success' do
        expect(response).to be_success
      end

      it 'returns a list' do
        expect(json['cards'].length).to be > 0
      end
    end

    it 'must be authenticated' do
      get '/api/v1/reports/trello/cards', {
        board_ids: ['wusd8mr6']
      }

      expect(response.status).to eq 401
    end
  end
end
