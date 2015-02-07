require_relative '../../spec_helper'

class FakeFetcher
  extend Util::Fetcher

  attr_reader :id, :date

  def initialize(fields={})
    @id = fields['id']
    @date = fields['date']
    @date = Date.parse(date) if date.is_a? String
  end

  def ==(other)
    id == other.id && date == other.date
  end
end

describe Util::Fetcher do
  let(:client) { double Trello::Client }
  let(:_) { anything }

  it 'uses the correct url' do
    expect(client).to receive(:get).with('/some/resource', _)
    FakeFetcher.all client, '/some/resource'
  end

  context 'defaults' do
    it 'fetches 1000 at a time' do
      expect(client).to receive(:get).with(_, hash_including(limit: 1000))
      FakeFetcher.all client, _
    end

    it 'allows overriding' do
      expect(client).to receive(:get).with(_, hash_including(limit: 50, fields: 'someThings'))
      FakeFetcher.all client, _, limit: 50, fields: 'someThings'
    end
  end

  context 'projection' do
    before(:each) do
      expect(client).to receive(:get).and_return '[{"id": "12345"}]'
    end

    it 'projects to a Hash by default' do
      expect(FakeFetcher.all client, _).to eq([{'id' => '12345'}])
    end

    it 'projects into a desired class' do
      expect(FakeFetcher.all(client, _, result_to: FakeFetcher).first.id).to eq('12345')
    end
  end

  context 'paging' do
    let(:page_size) { 5 }
    let(:the_result) { FakeFetcher.all client, _, result_to: FakeFetcher, limit: page_size }

    it 'handles less than a full page' do
      expected = setup_items 4
      expect(the_result).to eq(expected)
    end

    it 'handles when there is more than one page worth' do
      expected = setup_items 27
      expect(the_result).to eq(expected)
    end

    it 'can page through hashes as well' do
      setup_items(11, is_hash: true)
      expect(FakeFetcher.all(client, _, limit: page_size).count).to eq(11)
    end

    def setup_items(how_many, option={})
      all = how_many.times.map {|n| FakeFetcher.new('id' =>  n, 'date' =>  Date.new(1998, 9, n + 1))}.reverse

      to_json = ->(p) { 
        ((option[:is_hash] && p.map {|a| {'id' => a.id, 'date' => a.date}}) || p).to_json
      }

      page_number = 1
      all.each_slice(page_size) do |page|

        case
          when page_number == 1
            expect(client).to receive(:get).with(_, hash_including(before: nil)).and_return to_json.call(page)
          else
            previous_page_date = page.first.date + 1
            expect(client).to receive(:get).with(_, hash_including(before: previous_page_date.to_s)).and_return to_json.call(page)
        end
        page_number += 1
      end

      all
    end
  end
end

