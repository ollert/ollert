require_relative '../../spec_helper'
require 'base64'
require 'chronic'

describe Utils::Analyzers::TimeTracker do
  let(:three_days_ago) { Date.today - 3 }
  let(:one_day_ago) { Date.today - 1 }
  let(:last_monday) { Chronic.parse 'a week ago last Monday' }
  let(:last_friday) { Chronic.parse 'a week ago last Friday' }
  let(:card_id) { 1 }

  it 'created cards have only been in their original list' do
    actions = ActionBuilder.create_card(:backlog, three_days_ago).actions

    time_tracked_for(actions)

    expect(time_in('backlog').total_days).to eq(3)
  end

  it 'handles when there has only been one movement' do
    time_tracked_for ActionBuilder
      .create_card(:backlog, one_day_ago)
      .move_card(:development)
      .actions

    expect(time_in('backlog').total_days).to eq(1)
    expect(time_in('development').total_days).to eq(0)
  end

  it 'does the best it can when the createCard action is missing' do
    time_tracked_for ActionBuilder
      .fake_missing_create(:development, :backlog, three_days_ago)
      .move_card(:qa)
      .actions

    expect(time_in('development').total_days).to eq(1)
    expect(time_in('qa').total_days).to eq(2)
  end

  it 'handles multiple movements' do
    time_tracked_for ActionBuilder.create_card(:backlog, last_monday)
      .move_card(:development)
      .move_card(:qa)
      .move_card(:failed)
      .move_card(:development)
      .move_card(:passed)
      .actions

    expect(time_in('backlog').total_days).to eq(1)
    expect(time_in('qa').total_days).to eq(1)
    expect(time_in('failed').total_days).to eq(1)
    expect(time_in('development').total_days).to eq(2)
  end

  it 'handles if the actions are out of chronological order' do
    reversed_actions = ActionBuilder.create_card(:backlog, last_monday)
      .move_card(:development, 3)
      .move_card(:qa)
      .actions.reverse

    time_tracked_for(reversed_actions)

    expect(time_in('backlog').total_days).to eq(3)
  end

  it 'additionally tracks business days as well' do
    time_tracked_for(ActionBuilder.create_card(:backlog, last_friday)
      .move_card(:development, 3) # monday
      .actions)

    backlog_times = time_in('backlog')
    expect(backlog_times.total_days).to eq(3)
    expect(backlog_times.business_days).to eq(1) # Friday --> Monday
  end

  it 'exposes the times' do
    time_tracked_for ActionBuilder.create_card(:backlog, three_days_ago)
      .move_card(:development)
      .move_card(:passed)
      .actions

    actual_lists = times_for(:card_id).times.keys.map {|l| Base64.decode64 l}
    expect(actual_lists).to eq(['backlog', 'development', 'passed'])
  end

  it 'breaks multiple cards up' do
    time_tracked_for ActionBuilder.create_card(:backlog, three_days_ago)
      .move_card(:development)
      .create_card(:backlog, last_friday, 2)
      .actions

    expect(@time_tracked.map(&:card_id)).to eq([1, 2])
  end

  it '#to_json' do
    time_tracked_for ActionBuilder.create_card(:backlog, last_friday)
      .move_card(:development, 3)
      .actions

    dev_time = time_in('development')

    expected_json = [{
      card_id: 1,
      times: {
        id_for('backlog') => {total_days: 3, business_days: 1},
        id_for('development') => {total_days: dev_time.total_days, business_days: dev_time.business_days}
      }
    }].to_json

    expect(@time_tracked.to_json).to eq(expected_json)
  end

  def time_tracked_for(actions)
    @time_tracked = Utils::Analyzers::TimeTracker.by_card(actions)
  end

  def times_for(card_id=1)
    @time_tracked.find {|t| t.card_id === 1}
  end

  def time_in(list)
    times_for(1).in id_for(list)
  end

  def id_for(list)
    Base64.encode64 list
  end

  class ActionBuilder
    attr_reader :actions

    def initialize(list, date, card_id)
      @actions = []
      @card_id = card_id
      next_action(list, date.to_time, 'createCard')
    end

    def self.create_card(list, date=Date.today, card_id=1)
      ActionBuilder.new list, date, card_id
    end

    def create_card(list, date=Date.today, card_id)
      @card_id = card_id
      next_action(list, date.to_time, 'createCard')
      self
    end

    def self.fake_missing_create(list, previous, date=Date.today, card_id=1)
      builder = ActionBuilder.new list, date, card_id
      action = builder.actions.first
      action.instance_variable_set(:@before, previous.to_s)
      action.instance_variable_set(:@before_id, Base64.encode64(previous.to_s))
      builder
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
      fields['data']['card'] = {'id' => @card_id}

      (@actions << Utils::ListAction.new(fields)).last
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
