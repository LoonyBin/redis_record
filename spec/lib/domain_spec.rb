require 'spec_helper'
require 'fixtures/domain'

describe Domain do
  before(:each) do
    (0..4).each { |i| Domain.create id: "#{i}.com", status: 'Pre-release' }
  end

  it "should return all the records" do
    expect(Domain.count).to eq 5
    expect(Domain.all.map(&:id)).to eq %w[0.com 1.com 2.com 3.com 4.com]
  end

  it "should return only 'limit' number of records" do
    expect(Domain.limit(2).all.map(&:id)).to eq %w[0.com 1.com]
  end

  it "should return only records starting from 'offset'" do
    expect(Domain.offset(3).all.map(&:id)).to eq %w[3.com 4.com]
  end

  it "should return only 'limit' records starting from 'offset'" do
    expect(Domain.offset(2).limit(2).all.map(&:id)).to eq %w[2.com 3.com]

    # in any order
    expect(Domain.limit(2).offset(2).all.map(&:id)).to eq %w[2.com 3.com]
  end

  it "should not return more records than existing" do
    expect(Domain.offset(3).limit(3).all.map(&:id)).to eq %w[3.com 4.com]
  end

  it "should not display hidden records" do
    Domain.first.update_attributes hidden: true

    expect(Domain.filter(:hidden, false).count).to eq 4
    expect(Domain.filter(:hidden, false).all.map(&:id)).to eq %w[1.com 2.com 3.com 4.com]
  end

end
