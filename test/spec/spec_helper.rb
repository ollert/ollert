$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../..', 'utils', 'fetchers'))

RSpec.shared_examples 'a fetcher' do
  it 'raises error on nil client' do
    expect {described_class.fetch(nil, "fsadfj823w")}.to raise_error(Trello::Error)
  end

  it 'raises error on nil member token' do
    expect {described_class.fetch(double(Trello::Client), nil)}.to raise_error(Trello::Error)
  end

  it 'raises error on empty member token' do
    expect {described_class.fetch(double(Trello::Client), "")}.to raise_error(Trello::Error)
  end
end
