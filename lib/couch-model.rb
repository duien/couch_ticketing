require 'rubygems'
require 'couchrest'

# to get revision numbers for a document
# >> db.get( id, :revs => true )

# to get revision numbers and availability
# >> db.get( id, :revs_info => true )

# to get a specific revision
# >> db.get( id, :rev => rev )

# when saving a document
# >> db.save_doc( doc )
# => { 'ok' => 'true', '_id' => '...', '_rev' => '...' }

class CouchModel
  
  def self.included(base)
    puts "I was included! (#{base})"
  end
  
  def initialize(keys={})
    #super
    keys.each do |k,v|
      self[k.to_s] = v
    end if keys
  end
  
  def self.create(keys={})
    self.new(keys).save
  end
  
  def self.get
    
  end
  
  def save
    
  end
  
  def self.delete
    
  end
  
  # always make keys into strings
  def []= key, value
    super(key.to_s, value)
  end
  
  def [] key
    super(key.to_s)
  end
  
end