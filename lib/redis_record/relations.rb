module RedisRecord::Relations
  extend ActiveSupport::Concern

  class_methods do
    def belongs_to(relation)
      #string "#{relation}_id".to_sym
      relation = relation.to_s.singularize
      klass = relation.classify.constantize
      column_name = "#{relation}_id"

      attribute column_name, type: klass.attributes[:id][:type]
      create_filter column_name

      define_method relation do
        id = send column_name
        klass.find id
      end

      define_method "#{relation}=" do |obj|
        write_attribute column_name, obj.id
      end
    end

    def has_many(relation, proc=nil, opts={})
      if proc.is_a? Hash
        opts = proc
        proc = nil
      end

      relation = relation.to_s
      column_name = "#{self.name.underscore}_id"

      #klass.create_filter column_name

      define_method relation do
        klass = relation.singularize.classify.constantize

        scope = klass.filter column_name, id

        scope = scope.instance_exec &proc if proc
        scope
      end

      define_method "#{relation}=" do |enum|
        enum.each { |obj| obj.update_attributes column_name => id }
      end

      if opts[:dependent] == :destroy
        set_callback :destroy do |record|
          record.send(relation).each &:destroy
        end
      end
    end
  end
end
