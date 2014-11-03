module FreshBooksApi
  class ApiError < StandardError; end

  class Client
    attr_reader :api_url, :auth_token

    def initialize(api_url, auth_token)
      @api_url = api_url
      @auth_token = auth_token
      client
    end

    def list_get_all(method, plural_key, singular_key)
      plural_key   = plural_key.to_s
      singular_key = singular_key.to_s

      all_pages(method, plural_key, singular_key).flatten
    end

    private

    def all_pages(method, plural_key, singular_key)
      list            = client.send(method).list[plural_key]
      results         = [list[singular_key]]
      number_of_pages = list['pages'].to_i

      (2..number_of_pages).each do |page|
        options = { page: page }
        list    = client.send(method).list(options)
        results << list[plural_key][singular_key]
      end

      results
    end

    def client
      @client ||= FreshBooks::Client.new @api_url, @auth_token
    end
  end
end
