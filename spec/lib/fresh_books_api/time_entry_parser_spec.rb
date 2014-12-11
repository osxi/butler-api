require 'rails_helper'

describe FreshBooksApi::TimeEntryParser do
  context '#card_id' do
    context 'with card id' do
      context 'expected' do
        subject { FreshBooksApi::TimeEntryParser.new('Hello (trello:GyMwvpq9)') }

        its(:card_id) { should eql 'GyMwvpq9' }
      end

      context 'CAPS' do
        subject { FreshBooksApi::TimeEntryParser.new('Hello (TRELLO:GyMwvpq9)') }

        its(:card_id) { should eql 'GyMwvpq9' }
      end

      context 'extra whitespace' do
        subject { FreshBooksApi::TimeEntryParser.new(' Hello (trello:GyMwvpq9) ') }

        its(:card_id) { should eql 'GyMwvpq9' }
      end

      context 'with space between trello and card' do
        subject { FreshBooksApi::TimeEntryParser.new('Hello (trello: GyMwvpq9)') }

        its(:card_id) { should eql 'GyMwvpq9' }
      end

      context 'with space between parens' do
        subject { FreshBooksApi::TimeEntryParser.new('Hello ( trello: GyMwvpq9 )') }

        its(:card_id) { should eql 'GyMwvpq9' }
      end
    end

    context 'without card id' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello') }

      its(:card_id) { should eql :no_card_id_found }
    end

    context 'without card id - nil (bugfix)' do
      subject { FreshBooksApi::TimeEntryParser.new(nil) }

      its(:card_id) { should eql :no_card_id_found }
    end
  end

  context '#update_hours_in_name' do
    context 'with hours' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello (trello:GyMwvpq9)') }

      its(:card_id) { should eql 'GyMwvpq9' }
    end

    context 'without hours' do
      subject { FreshBooksApi::TimeEntryParser.new('Hello') }

      its(:card_id) { should eql :no_card_id_found }
    end

  end
end
