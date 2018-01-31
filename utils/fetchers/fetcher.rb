module Utils
  module Fetcher
    HARD_CAP = 10000 # TODO: We will be replacing a hard fetch cap with a date-based cap eventually

    def all(client, path, overrides={})
      projection = overrides.delete(:result_to)
      options = {limit: 1000, before: nil}.merge(overrides)

      action = -> { client.get(path, options) }

      page_through_results(action, options, projection)
    end

    private
    def page_through_results(action, options, projection)
      results = []
      loop do
        page = project(action.call, projection)
        results.concat page
        break if page.count != options[:limit] || results.count > HARD_CAP
        options[:before] = oldest_date_for page.last
      end
      results
    end

    def project(result, cls)
      return [] if result.nil?
      (cls && cls.from_response(result)) || JSON.parse(result)
    end

    def oldest_date_for(page)
      case page
        when Hash
          page['date'].to_s
        else
          page.date.to_s
        end
    end
  end
end
