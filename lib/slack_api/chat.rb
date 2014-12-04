module SlackApi
  class Chat < Client
    def post_message(opts = {})
      self.class.get('/chat.postMessage',  query: @options[:query].merge(opts))
    end
  end
end
