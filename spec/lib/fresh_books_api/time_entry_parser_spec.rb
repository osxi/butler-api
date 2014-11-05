require 'rails_helper'

describe FreshBooksApi::TimeEntryParser do
  context '#card_id' do
    context 'with card id' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello (GyMwvpq9)') }

      its(:card_id) { should eql 'GyMwvpq9' }
    end

    context 'without card id' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello') }

      its(:card_id) { should eql :no_card_id_found }
    end
  end

  context '#update_hours_in_name' do
    context 'with hours' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello (GyMwvpq9)') }

      its(:card_id) { should eql 'GyMwvpq9' }
    end

    context 'without hours' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello') }

      its(:card_id) { should eql :no_card_id_found }
    end

  end
end
