require 'rails_helper'

describe TimeEntryCreator do
  context 'creates time entry record', :vcr do
    let(:creator) do
      TimeEntryCreator.new(
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
        date: Date.iso8601('2014-10-31T20:47:38.213Z')
      }
      )
    end

    subject { creator.create }

    it { should be_an_instance_of(TimeEntry) }
    its(:fb_project_id) { should eq 3020 }
    its(:fb_task_id) { should eq 46_805 }
    its(:fb_staff_id) { should eq 1 }
    its(:hours) { should eq 0.5 }
    its(:notes) { should eq 'Did something cool' }
    its(:date) { should eq Date.iso8601('2014-10-31T20:47:38.213Z') }
  end

  context 'updates trello card', :vcr do
    let(:creator) do
      TimeEntryCreator.new(
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
        card_id: 'ARcjkdiv'
      }
      )
    end

    it 'updates trello card' do
      expect(creator).to receive(:update_trello_card).and_call_original
      expect(creator).to receive(:update_stored_entries).and_call_original

      creator.create
    end
  end
end
