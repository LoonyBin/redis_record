module RedisRecord::Base
  extend ActiveSupport::Concern

  included do
    extend ActiveSupport::Callbacks

    define_callbacks :save
    define_callbacks :destroy
    attr_accessor :persisted
    attr_accessor :original_attributes
  end

  def save
    success = nil
    run_callbacks :save do
      success = RedisRecord.REDIS.mapped_hmset(key, attributes)
    end
    self.persisted = (success == "OK")
  end
  alias save! save

  def destroy
    success = nil
    run_callbacks :destroy do
      success = RedisRecord.REDIS.del key
    end
    success == 1 ? self : nil
  end
  alias destroy! destroy

  def update_attributes(attrs)
    assign_attributes attrs
    save
  end

  def key
    self.class.key(id)
  end

end
