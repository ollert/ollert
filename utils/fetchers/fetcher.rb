module Util
  module Fetcher
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
        break if page.count != options[:limit]
        options[:before] = page.last.date.to_s
      end
      results
    end

    def project(result, cls)
      return [] if result.nil?
      (cls && result.json_into(cls)) || JSON.parse(result)
    end
  end
end
