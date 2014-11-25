require 'rails_helper'

describe SlackApi::Chat do
  let(:slack) { SlackApi::Chat.new(ENV['SLACK_API_TOKEN']) }

  it 'can successfully send a message', vcr: true do
    req = slack.post_message(channel: '#snitch', text: 'chat_spec.rb running.',
                             username: 'RSpec')
    expect(req.response.code).to eq('200')
  end
end
