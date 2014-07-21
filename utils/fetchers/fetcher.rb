module Fetcher

  protected

  def self.merge_date_option!(options, parameters)
    if parameters.key?(:date_from)
      date_from_s = parameters[:date_from].to_s
      options.merge!({since: date_from_s})
    end

    if parameters.key?(:date_to)
      date_to_s = parameters[:date_to].to_s
      options.merge!({before: date_to_s})
    end
  end
end
