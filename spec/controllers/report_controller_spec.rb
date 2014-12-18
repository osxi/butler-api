require 'rails_helper'

RSpec.describe ReportController, type: :controller do
  describe 'GET daily' do
    it 'returns http success' do
      get :daily
      expect(response).to have_http_status(:success)
    end

    context '@total_hours' do
      it 'correctly calculates all hours' do
        entry_one = FactoryGirl.create(:time_entry, date: Time.now, user_id: 1)
        entry_two = FactoryGirl.create(:time_entry, date: Time.now, user_id: 2)
        total     = entry_one.hours + entry_two.hours

        get :daily, date: Time.now.strftime('%m/%d/%Y')

        expect(controller.instance_variable_get(:@total_hours)).to eq(total)
      end

      it 'correctly calculates hours for one entry' do
        entry_one = FactoryGirl.create(:time_entry, date: Time.now, user_id: 1)
        total     = entry_one.hours

        get :daily, date: Time.now.strftime('%m/%d/%Y')

        expect(controller.instance_variable_get(:@total_hours)).to eq(total)
      end

      it 'correctly calculates absence of hours' do
        get :daily, date: (Time.now + 1.day).strftime('%m/%d/%Y')
        expect(controller.instance_variable_get(:@total_hours)).to eq(0.0)
      end
    end
  end

  describe 'GET user' do
    it 'returns http success' do
      get :user
      expect(response).to have_http_status(:success)
    end
  end

end
