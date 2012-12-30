module RedisRecord::Sorting
  extend ActiveSupport::Concern

  included do
    set_callback :destroy, :after, :remove_from_sort_lists
    set_callback :save, :after, :add_to_sort_lists
  end

protected
  def add_to_sort_lists
    defined_sorts.each do |name, block|
      score = 0
      if block
        if block.respond_to? :call
          score = block.call self
        else
          score = self.send block
        end
      end
      RedisRecord.REDIS.zadd self.class.meta_key(name), score, id
    end
  end

  def remove_from_sort_lists
    defined_sorts.each do |name, _|
      RedisRecord.REDIS.zrem self.class.meta_key(name), id
    end
  end

end
