require 'active_attr'
require 'active_support'
require 'redis'

class RedisRecord
	def self.inherited(subclass)
		subclass.const_set 'Scope', Class.new(RedisScope)
	end

	Dir[File.expand_path("../redis_record/**/*.rb", __FILE__)].each {|f| require f}

  include ActiveAttr::Model
  include DataTypes
  include Base
  include Sorting
  include Filters
	include Relations

  @@REDIS = nil

  def self.REDIS
    @@REDIS ||= Redis.new
  end
  def self.REDIS=(client)
    @@REDIS = client
  end

  class_attribute :defined_sorts, :defined_filters
  self.defined_sorts = {id: nil}
  self.defined_filters = {}

  ActiveSupport.run_load_hooks :redis_record, self

end
