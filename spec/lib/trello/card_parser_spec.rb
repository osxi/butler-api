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

  context '#estimate' do
    context 'with hours' do
      subject { Trello::CardParser.new('(0.5) Hello').estimate }

      it { is_expected.to eql 0.5 }
    end

    context 'with hours and actual' do
      subject { Trello::CardParser.new('(0.5) Hello [0.3]').estimate }

      it { is_expected.to eql 0.5 }
    end

    context 'without hours' do
      subject { Trello::CardParser.new('Hello').estimate }

      it { is_expected.to eql 0.0 }
    end
  end

  context '#actual' do
    context 'with actual' do
      subject { Trello::CardParser.new('Hello [0.35]').actual }

      it { is_expected.to eql 0.35 }
    end

    context 'with actual and estimate' do
      subject { Trello::CardParser.new('(0.5) Hello [0.35]').actual }

      it { is_expected.to eql 0.35 }
    end

    context 'without hours' do
      subject { Trello::CardParser.new('Hello').actual }

      it { is_expected.to eql 0.0 }
    end

    context 'without hours / with estimate' do
      subject { Trello::CardParser.new('(0.5) Hello').actual }

      it { is_expected.to eql 0.0 }
    end
  end
end
