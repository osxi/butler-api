require 'rails_helper'

describe ReportController, type: :controller do
  describe 'GET daily' do
    DATE_FORMAT = '%m/%d/%Y'

    def formatted_today
      Time.now.strftime(DATE_FORMAT)
    end

    def formatted_tomorrow
      Time.now.strftime(DATE_FORMAT)
    end

    it 'finds team based on params' do
      team = FactoryGirl.create(:team)

      get :daily, date: Time.now.strftime('%m/%d/%Y'), team: team.name

      expect(controller.instance_variable_get(:@team)).to eq team
    end

    context 'all @total_hours' do
      it 'correctly calculates all hours' do
        entry_one = FactoryGirl.create(:time_entry, date: Time.now)
        entry_two = FactoryGirl.create(:time_entry, date: Time.now)
        total     = entry_one.hours + entry_two.hours

        get :daily, date: formatted_today

        expect(controller.instance_variable_get(:@total_hours)).to eq(total)
      end

      it 'correctly calculates hours for one entry' do
        entry_one = FactoryGirl.create(:time_entry, date: Time.now)
        total     = entry_one.hours

        get :daily, date: formatted_today

        expect(controller.instance_variable_get(:@total_hours)).to eq(total)
      end

      it 'correctly calculates absence of hours' do
        get :daily, date: formatted_tomorrow
        expect(controller.instance_variable_get(:@total_hours)).to eq(0.0)
      end
    end

    context 'team @total_hours' do
      it 'correctly calculates all hours' do
        user    = FactoryGirl.create(:user)
        entries = FactoryGirl.create_list(:time_entry, 2, date: Time.now, user: user)
        total   = entries.map(&:hours).sum

        get :daily, date: formatted_today, team: user.team.name

        expect(controller.instance_variable_get(:@total_hours)).to eq(total)
      end

      it 'correctly calculates hours for one entry' do
        entry = FactoryGirl.create(:time_entry, date: Time.now)
        total = entry.hours

        get :daily, date: formatted_today, team: entry.user.team.name

        expect(controller.instance_variable_get(:@total_hours)).to eq(total)
      end

      it 'correctly calculates absence of hours' do
        team = FactoryGirl.create(:team)

        get :daily, date: formatted_tomorrow, team: team.name

        expect(controller.instance_variable_get(:@total_hours)).to eq(0.0)
      end
    end
  end
end
