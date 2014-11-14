require 'rails_helper'

describe Trello::CardActualsUpdater do
  let(:client) { TrelloApi.new(ENV['TRELLO_KEY'], ENV['TRELLO_TOKEN']) }
  subject { Trello::CardActualsUpdater.new(client) }

  context '#update_card' do
    before do
      TimeEntry.create(trello_card_id: '28Pjr2dK', hours: 0.5)
    end

    it 'updates the card with total hours in db' do
      spy = spy('subject.trello_client')
      subject.trello_client = spy

      subject.update_card('28Pjr2dK')

      expect(spy).to have_received(:update_card_hours).with('28Pjr2dK', 0.5)
    end

    it 'logs a comment to trello when updates card hours' do
      spy = spy('subject.trello_client')
      subject.trello_client = spy

      expect(subject).to receive(:comment_total_hours).with('28Pjr2dK', 0.5).and_call_original

      subject.update_card('28Pjr2dK')

      expect(spy).to have_received(:create_comment).with('28Pjr2dK',  'Actual hours changed to 0.5')
    end

    it 'doesn\'t log a comment to trello when not updated' do
      spy = spy('subject.trello_client')
      subject.trello_client = spy

      expect(spy).to receive(:update_card_hours).and_return(false)
      expect(subject).to_not receive(:comment_total_hours)

      subject.update_card('28Pjr2dK')
    end
  end

  context '#update_cards' do
    before do
      TimeEntry.create(trello_card_id: '28Pjr2dK', hours: 0.5)
      TimeEntry.create(trello_card_id: 'abc12345', hours: 1.5)
    end

    it 'updates the cards with total hours in db' do
      spy = spy('subject.trello_client')
      subject.trello_client = spy

      subject.update_cards('28Pjr2dK', 'abc12345')

      expect(spy).to have_received(:update_card_hours).with('28Pjr2dK', 0.5)
      expect(spy).to have_received(:update_card_hours).with('abc12345', 1.5)
      expect(spy).to have_received(:update_card_hours).twice
    end
  end
end
