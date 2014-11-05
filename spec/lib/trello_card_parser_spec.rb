require 'rails_helper'

describe TrelloCardParser do
  context '#update_hours_in_name' do
    context 'with hours' do
      subject { TrelloCardParser.new('Hello [0.5]').update_hours_in_name(1.0) }

      it { is_expected.to eql 'Hello [1.0]' }
    end

    context 'without hours' do
      subject { TrelloCardParser.new('Hello').update_hours_in_name(1.0) }

      it { is_expected.to eql 'Hello [1.0]' }
    end
  end
end
