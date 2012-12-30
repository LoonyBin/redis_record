module RedisRecord::Filters
  extend ActiveSupport::Concern

  included do
    set_callback :save, :after, :add_to_filter_lists
    set_callback :save, :before, :remove_from_filter_lists
    set_callback :destroy, :before, :remove_from_filter_lists
  end

protected
  def filter_key(name, block)
    value = block ? block.call(self) : self.send(name)
    RedisRecord.REDIS.zincrby self.class.filter_key('_Values', name), 1, value
    self.class.filter_key(name, value)
  end

private
  def remove_from_filter_lists
    return unless original_attributes

    old_dog = self.class.new(original_attributes)
    defined_filters.each do |name, block|
      RedisRecord.REDIS.srem old_dog.filter_key(name, block), id
    end
  end

  def add_to_filter_lists
    defined_filters.each do |name, block|
      RedisRecord.REDIS.sadd filter_key(name, block), id
    end
  end

end
