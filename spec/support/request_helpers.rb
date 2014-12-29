module Requests
  module JsonHelpers
    include AuthHelpers

    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
