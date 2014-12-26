require 'spec_helper'
class ModelWithScope < RedisRecord
  string :id
  create_filter :id

  scope :zero_id do
    filter :id, 0
  end
end

describe 'Scopes' do
  before do
    2.times {|i| ModelWithScope.create id: i}
  end

  it "should make scope methods available" do
    expect(ModelWithScope.scoped.zero_id.to_a).to match_array [ModelWithScope.find(0)]
  end

  it "should make scope methods available directly on class" do
    expect(ModelWithScope.zero_id.to_a).to match_array [ModelWithScope.find(0)]
  end
end
