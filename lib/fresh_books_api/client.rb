module FreshBooksApi
  class ApiError < StandardError; end

  class Client
    attr_reader :api_url, :auth_token, :client

    def initialize(api_url, auth_token)
      @api_url    = api_url
      @auth_token = auth_token
      @client     = FreshBooks::Client.new @api_url, @auth_token
    end

    def list_get_all(method, plural_key, singular_key, options = {})
      plural_key   = plural_key.to_s
      singular_key = singular_key.to_s

      all_pages(method, plural_key, singular_key, options).flatten
    end

    private

    def all_pages(method, plural_key, singular_key, options)
      list            = client.send(method).list(options)[plural_key]
      return [] unless list && list[singular_key]

      results         = [list[singular_key]]
      number_of_pages = list['pages'].to_i

      (2..number_of_pages).each do |page|
        page_options = { page: page }
        list         = client.send(method).list(options.merge(page_options))
        results << list[plural_key][singular_key]
      end

      results
    end

    def respond(res)
      if res['error']
        fail FreshBooksApi::ApiError, "#{res['code']}: #{res['error']}"
      end
      res
    end
  end
end
