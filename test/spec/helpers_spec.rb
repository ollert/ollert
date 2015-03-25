require_relative 'spec_helper'

describe OllertApp::Helpers do
  let(:helper) { Class.new { extend OllertApp::Helpers } }

  context '#title_for' do
    it 'is empty if nothing is provided' do
      expect(helper.title_for).to be_nil
    end

    it 'prefixes a hyphen with whatever is passed in' do
      expect(helper.title_for 'expected').to eq '- expected'
    end
  end
end