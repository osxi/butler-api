module SlackApi
  class Client
    include HTTParty
    base_uri 'https://slack.com/api'
    # debug_output $stdout

    def initialize(token)
      @options = { query: {token: token} }
    end
  end
end