require 'spec_helper'
require 'fixtures/domain'

describe Domain do
  before(:each) do
    (0..4).each { |i| Domain.create id: "#{i}.com" }
  end

  it "should return all the records" do
    Domain.count.should eq 5
    Domain.all.map(&:id).should eq %w[0.com 1.com 2.com 3.com 4.com]
  end

  it "should return only 'limit' number of records" do
    Domain.limit(2).all.map(&:id).should eq %w[0.com 1.com]
  end

  it "should return only records starting from 'offset'" do
    Domain.offset(3).all.map(&:id).should eq %w[3.com 4.com]
  end

  it "should return only 'limit' records starting from 'offset'" do
    Domain.offset(2).limit(2).all.map(&:id).should eq %w[2.com 3.com]

    # in any order
    Domain.limit(2).offset(2).all.map(&:id).should eq %w[2.com 3.com]
  end

  it "should not return more records than existing" do
    Domain.offset(3).limit(3).all.map(&:id).should eq %w[3.com 4.com]
  end

end
