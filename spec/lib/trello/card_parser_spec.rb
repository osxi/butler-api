require 'rails_helper'

describe Trello::CardParser do
  context '#update_hours_in_name' do
    context 'with hours' do
      subject { Trello::CardParser.new('Hello [0.5]').update_hours_in_name(1.0) }

      it { is_expected.to eql 'Hello [1.0]' }
    end

    context 'without hours' do
      subject { Trello::CardParser.new('Hello').update_hours_in_name(1.0) }

      it { is_expected.to eql 'Hello [1.0]' }
    end
  end
end
