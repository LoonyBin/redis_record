class Domain < RedisRecord
  attr_accessible :id
  attr_accessible :hidden, :liked

  string    :id # name
  boolean   :hidden, :default => false
  boolean   :liked, :default => false

  create_filter :numbers do |domain|
    !!domain.id.match(/[0-9]/)
  end
  create_filter :hyphenated do |domain|
    !!domain.id.match(/-/)
  end
  create_filter :tld do |domain|
    domain.id.split('.').last
  end

  create_filter :hidden
  create_filter :liked

  sortable :length do |domain|
    domain.id.length
  end

end
