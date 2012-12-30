require 'spec_helper'
require 'fixtures/domain'

describe Domain do
  context "with filters" do
    before(:each) do
      ('a'..'b').each { |i| Domain.create id: "#{i}.com", status: 'Pre-release' }
      ('5'..'6').each { |i| Domain.create id: "#{i}-.net", status: 'Pre-release' }
      ('a'..'b').each { |i| Domain.create id: "#{i}.org", status: 'Pre-release' }
    end

    it "shouldn't allow undefined filters" do
      expect{Domain.filter(:blah)}.to raise_error NameError
    end

    it "should return only records with the given filter applied" do
      Domain.filter(:numbers).all.map(&:id).should eq %w[5-.net 6-.net]
    end

    it "should return only records matching all the filters" do
      Domain.filter(:numbers).filter(:hyphenated).all.map(&:id).should eq %w[5-.net 6-.net]
    end

    it "should list out all the available values for a given filter" do
      Domain.values_for_filter(:tld).should eq %w[com net org]
    end

    it "should return records with the filter matching a custom value" do
      Domain.filter(:tld, 'net').map(&:id).should eq %w[5-.net 6-.net]
    end

    it "should return records with the filter matching any of the custom values" do
      Domain.filter(:tld, ['net', 'org']).map(&:id).should eq %w[5-.net 6-.net a.org b.org]
    end

    it "should sort and select records even when filters are applied" do
      (1..4).each {|i| Domain.create id: ('a' * i), status: 'Pre-release'}
      Domain.filter(:numbers, false).sort(:length).min(2).max(4).map(&:id).should eq %w[aa aaa aaaa]
    end

    it "should allow defining filters on attributes without block" do
      Domain.first.update_attributes hidden: true

      Domain.filter(:hidden, false).count.should eq 5
      Domain.filter(:hidden, false).all.map(&:id).should eq %w[6-.net a.com a.org b.com b.org]
    end
  end
end
