require 'spec_helper'
require 'fixtures/domain'

describe Domain do
  context 'with sorting' do
    before(:each) do
      (1..4).each {|i| Domain.create id: ('a' * i), status: 'Pre-release'}
    end

    it "should sort by given attribute" do
      expect(Domain.sort(:length).map(&:id)).to eq %w[a aa aaa aaaa]
    end

    it "should filter for min and max on the sort" do
      expect(Domain.sort(:length).min(3).map(&:id)).to eq %w[aaa aaaa]
      expect(Domain.sort(:length).max(4).map(&:id)).to eq %w[a aa aaa aaaa]
      expect(Domain.sort(:length).min(2).max(4).map(&:id)).to eq %w[aa aaa aaaa]
    end
  end
end
