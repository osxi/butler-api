require 'rails_helper'

RSpec.describe Team, :type => :model do
  let(:team) { FactoryGirl.create(:team) }
  context 'has many' do
    it 'users' do
      expect(team).to have_many(:users)
    end

    it 'time_entries' do
      expect(team).to have_many(:time_entries)
    end
  end
end
