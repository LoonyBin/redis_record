require 'active_support/core_ext/module/delegation'

module RedisRecord::Base
  module ClassMethods

    def scoped(*args)
      self::Scope.new self, *args
    end

    delegate :filter, :where, :sort, :min, :max, :limit, :offset, :to => :scoped
    delegate :all, :each, :map, :count, :first, :last, :to => :scoped

    def create(*args)
      new(*args).tap &:save
    end

    def find(id)
      find_by_key key id
    end

    def scope(name, prc=nil, &block)
      prc ||= block
      self::Scope.send :define_method, name, &prc
      self.define_singleton_method name do
        scoped.send name
      end
    end

    def find_or_initialize_by_id(id)
      find(id) || self.new(:id => id)
    end

    def create_filter(name, &block)
      self.defined_filters = self.defined_filters.merge name.to_sym => block
    end

    def sortable(name, &block)
      self.defined_sorts = self.defined_sorts.merge name.to_sym => block
    end

    def values_for_filter(name)
      RedisRecord.REDIS.zrange filter_key('_Values', name), 0, -1
    end

    def meta_key(attr)
      ['Meta', model_name, attr].join ':'
    end

    def filter_key(name, value)
      meta_key "Filter:#{name}:#{value}"
    end

    def key(id)
      [model_name, id].join ':'
    end

  private
    def find_by_key(key)
      attributes = RedisRecord.REDIS.mapped_hmget(key, *attribute_names)
      attributes['id'] && self.new(attributes).tap { |r|
        r.persisted = true
        r.original_attributes = attributes
      }
    end
  end
end
