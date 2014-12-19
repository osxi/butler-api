require 'rails_helper'

describe Snitch do
  let(:snitch)   { Snitch.new(ENV['SLACK_API_TOKEN'], Date.iso8601('2014-12-17T00:00:00.213Z')) }
  let!(:user)    { FactoryGirl.create(:user) }
  let!(:manager) { FactoryGirl.create(:user, manager: true) }

  context '#user' do
    it 'includes everyone', :vcr do
      expect(snitch.send_deficient_hours_report).to include(user, manager)
    end
  end

  describe '#manager', :vcr do
    it 'operates on managers' do
      expect(snitch.send_manager_report).to include(manager)
    end

    it 'ignores non-managers' do
      expect(snitch.send_manager_report).to_not include(user)
    end
  end
end
