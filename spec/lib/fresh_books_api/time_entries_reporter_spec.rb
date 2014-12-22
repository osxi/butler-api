
require 'rails_helper'

describe FreshBooksApi::TimeEntriesReporter do
  let(:client) do
    FreshBooksApi::TimeEntriesReporter.new(ENV['FB_API_URL'], ENV['FB_AUTH_TOKEN'])
  end

  context '#report', :vcr do
    before do
      create(:task, fb_task_id: 46805, billable: true)
      create(:task, fb_task_id: 46807, billable: false)
    end

    let(:from) { Date.iso8601('2014-12-15T00:00:00.213Z') }
    let(:to)   { Date.iso8601('2014-12-15T23:59:59.213Z') }

    def run_report(only_billable: true)
      client.report(project_ids: [3020], from: from, to: to,
                    only_billable: only_billable)
    end

    it 'should have correct keys' do
      entries = run_report
      expect(entries.first.keys).to eq(['hours', 'date', 'notes', 'billed',
                                        'trello_card_id', 'staff_name'])
    end

    context 'only_billable = true' do
      it 'should have filtered the non-billable task' do
        entries = run_report(only_billable: true)
        expect(entries.length).to eq 1
      end
    end

    context 'only_billable = false' do
      it 'should not filter the non-billable task' do
        entries = run_report(only_billable: false)
        expect(entries.length).to eq 2
      end
    end
  end
end
