module RedisRecord::Relations
  extend ActiveSupport::Concern

  class_methods do
    def belongs_to(relation)
      #string "#{relation}_id".to_sym
      relation = relation.to_s.singularize
      klass = relation.classify.constantize
      column_name = "#{relation}_id"
      attribute column_name, type: klass.attributes[:id][:type]

      define_method relation do
        id = send column_name
        klass.find id
      end

      define_method "#{relation}=" do |obj|
        send "#{column_name}=", obj.id
      end
    end

    def has_many(relation)
      define_method relation do
      end
    end
  end
end
