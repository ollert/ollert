require_relative '../../spec_helper'
require 'base64'
require 'chronic'

describe Util::Analyzers::TimeSpent do
  let(:three_days_ago) { Date.today - 3 }
  let(:one_day_ago) { Date.today - 1 }
  let(:last_monday) { Chronic.parse 'a week ago last Monday' }
  let(:last_friday) { Chronic.parse 'a week ago last Friday' }

  it 'created cards have only been in their original list' do
    actions = ActionBuilder.create_card(:backlog, three_days_ago).actions

    time_spent = time_spent(actions)

    expect(time_spent.in('backlog').total_days).to eq(3)
  end

  it 'handles when there has only been one movement' do
    time_spent = time_spent ActionBuilder
      .create_card(:backlog, one_day_ago)
      .move_card(:development)
      .actions

    expect(time_spent.in('backlog').total_days).to eq(1)
    expect(time_spent.in('development').total_days).to eq(0)
  end

  it 'handles multiple movements' do
    time_spent = time_spent ActionBuilder.create_card(:backlog, last_monday)
      .move_card(:development)
      .move_card(:qa)
      .move_card(:failed)
      .move_card(:development)
      .move_card(:passed)
      .actions

    expect(time_spent.in('backlog').total_days).to eq(1)
    expect(time_spent.in('qa').total_days).to eq(1)
    expect(time_spent.in('failed').total_days).to eq(1)
    expect(time_spent.in('development').total_days).to eq(2)
  end

  it 'handles if the actions are out of chronological order' do
    reversed_actions = ActionBuilder.create_card(:backlog, last_monday)
      .move_card(:development, 3)
      .move_card(:qa)
      .actions.reverse

    time_spent = time_spent(reversed_actions)

    expect(time_spent.in('backlog').total_days).to eq(3)
  end

  it 'additionally tracks business days as well' do
    backlog_times  = time_spent(ActionBuilder.create_card(:backlog, last_friday)
      .move_card(:development, 3) # monday
      .actions).in('backlog')

    expect(backlog_times.total_days).to eq(3)
    expect(backlog_times.business_days).to eq(1) # Friday --> Monday
  end

  it 'exposes the times' do
    time_spent = time_spent ActionBuilder.create_card(:backlog, three_days_ago)
      .move_card(:development)
      .move_card(:passed)
      .actions

    expect(time_spent.times.keys).to eq(['backlog', 'development', 'passed'])
  end

  it '#to_json' do
    time_spent = time_spent ActionBuilder.create_card(:backlog, last_friday)
      .move_card(:development, 3)
      .actions

    dev_time = time_spent.in('development')

    expected_json = {
      backlog: {total_days: 3, business_days: 1},
      development: {total_days: dev_time.total_days, business_days: dev_time.business_days}
    }.to_json

    expect(time_spent.to_json).to eq(expected_json)
  end

  def time_spent(actions)
    Util::Analyzers::TimeSpent.from actions
  end

  class ActionBuilder
    attr_reader :actions

    def initialize(list, date)
      @actions = []
      next_action(list, date.to_time, 'createCard')
    end

    def self.create_card(list, date=Date.today)
      ActionBuilder.new list, date
    end

    def move_card(new_list, days_later=1)
      next_action(new_list, (previous_date + days_later).to_time, 'updateCard')
      self
    end

    private
    def next_action(list, date, type)
      fields = {
        'id' => Base64.encode64(Time.now.to_s),
        'date' => date.iso8601,
        'type' => type
      }

      fields['data'] = case type
                       when 'createCard'
                         {'list' => to_list(list)}
                       else
                         {
                           'listBefore' =>  previous_list,
                           'listAfter' =>  to_list(list)
                         }
                       end

      (@actions << Util::ListAction.new(fields)).last
    end

    def to_list(list)
      {'name' => list.to_s, 'id' => Base64.encode64(list.to_s)}
    end

    def previous_list
      last_action = actions.last
      data = last_action.data
      (last_action.type == 'createCard' && data['list']) || data['listAfter']
    end

    def previous_date
      actions.last.date.to_date
    end

  end
end
