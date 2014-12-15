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

  context '#get_estimate' do
    context 'with hours' do
      subject { Trello::CardParser.new('(0.5) Hello').get_estimate }

      it { is_expected.to eql 0.5 }
    end

    context 'with hours and actual' do
      subject { Trello::CardParser.new('(0.5) Hello [0.3]').get_estimate }

      it { is_expected.to eql 0.5 }
    end

    context 'without hours' do
      subject { Trello::CardParser.new('Hello').get_estimate }

      it { is_expected.to eql 0.0 }
    end
  end

  context '#get_actual' do
    context 'with actual' do
      subject { Trello::CardParser.new('Hello [0.35]').get_actual }

      it { is_expected.to eql 0.35 }
    end

    context 'with actual and estimate' do
      subject { Trello::CardParser.new('(0.5) Hello [0.35]').get_actual }

      it { is_expected.to eql 0.35 }
    end

    context 'without hours' do
      subject { Trello::CardParser.new('Hello').get_actual }

      it { is_expected.to eql 0.0 }
    end

    context 'without hours / with estimate' do
      subject { Trello::CardParser.new('(0.5) Hello').get_actual }

      it { is_expected.to eql 0.0 }
    end
  end
end
