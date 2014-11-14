
require 'rails_helper'

describe FreshBooksApi::TimeEntries do
  let(:client) do
    FreshBooksApi::TimeEntries.new(ENV['FB_API_URL'], ENV['FB_AUTH_TOKEN'])
  end

  context '#import', :vcr do
    let(:from) { Date.iso8601('2014-11-04T00:00:00.213Z') }
    let(:to)   { Date.iso8601('2014-11-04T23:59:59.213Z') }

    subject { client.import_all(from: from, to: to) }

    it 'creates new records' do
      expect(TimeEntry.count).to eql 0
      subject # this makes it actually import since subject is lazy
      expect(TimeEntry.count).to_not eql 0
    end

    it { is_expected.to be_an_instance_of(Array) }

    its(:first) { is_expected.to be_an_instance_of(TimeEntry) }
  end
end
