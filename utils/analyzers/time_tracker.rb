require 'business_time'

module Utils
  module Analyzers
    class TimeTracker
      attr_reader :card, :times

      def initialize(card, actions)
        @actions = actions ? actions.sort_by(&:date) : []
        @card = card
        @times = {}

        @actions.reduce(nil) do |last_date, action|
          span_for(action.before_id).add last_date, action.date if last_date
          action.date
        end

        last = @actions.last
        span_for(last.after_id).add last.date, DateTime.now.utc.to_date if last
      end

      def in(list)
        @times[list]
      end

      def as_json(opts={})
        {
          card: card,
          times: times
        }
      end

      def self.by_card(cards:, actions:)
        grouped_actions = actions.group_by(&:card_id)
        cards.map { |c| TimeTracker.new c, grouped_actions[c.id] }
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
          start_day = start_time.to_datetime.utc.to_date
          end_day = end_time.to_datetime.utc.to_date

          @total_days += (end_day - start_day).numerator
          @business_days += start_day.business_days_until end_day
        end

        def as_json(options={})
          {
            total_days: total_days,
            business_days: business_days
          }
        end
      end
    end
  end
end
