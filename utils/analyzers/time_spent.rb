require 'business_time'

module Util
  module Analyzers
    class TimeSpent
      attr_reader :times

      def initialize(actions)
        @actions = actions.sort_by(&:date)
        @times = {}

        @actions.reduce(nil) do |last_date, action|
          span_for(action.before).add last_date, action.date if action.before
          action.date
        end

        last = @actions.last
        span_for(last.after).add last.date, Date.today
      end

      def in(list)
        @times[list]
      end

      def to_json(options={})
        times.to_json
      end

      def self.from(actions)
        TimeSpent.new actions
      end

      private
      def span_for(action)
        @times[action] ||= Span.new
      end

      class Span
        attr_reader :total_days, :business_days

        def initialize
          @total_days, @business_days = [0, 0]
        end

        def add(start_time, end_time)
          start_day = start_time.to_date
          end_day = end_time.to_date

          @total_days += (end_day - start_day).numerator
          @business_days += start_day.business_days_until end_day
        end

        def to_json(options={})
          {total_days: total_days, business_days: business_days}.to_json
        end
      end
    end
  end
end
