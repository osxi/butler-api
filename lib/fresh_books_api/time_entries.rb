module FreshBooksApi
  class TimeEntries < Client
    def create(attributes)
      attributes[:date] = Date.today unless attributes[:date].present?
      res = client.time_entry.create(time_entry: attributes.to_h)

      if res['error']
        fail FreshBooksApi::ApiError, "#{res['code']}: #{res['error']}"
      end

      res
    end
  end
end
