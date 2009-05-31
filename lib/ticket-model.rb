require File.join( File.dirname(__FILE__), 'couch-model' )

class Ticket < CouchModel
  database 
  
end

t = Ticket.new
puts t.inspect