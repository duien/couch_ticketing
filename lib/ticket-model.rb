require 'rubygems'
require 'couchrest'

class Ticket
  
  def initialize(params_hash={})
    puts self.inspect
    self.class.setup
    @params = params_hash
    @params['type'] = 'ticket'
    @params['status'] = 'new' unless @params['status']
  end
  
  def save(params_hash={})
    #new_params = @params.merge(params_hash)
    #if @@db.save_doc(new_params)
    #  @params = new_params
    #end
    
    # New revision of existing ticket:
    # >> t.save('status' => 'open')
    # => {"rev"=>"2-3997887851", "id"=>"cea60c44dced5359d88c0e35f290c0fb", "ok"=>true}
    
    # Saving new ticket:
    # >> t2.save({})
    # => {"rev"=>"1-3081226305", "id"=>"1cbd098c5bc7c8f966019cb376677167", "ok"=>true}
    
    # Saving ticket modified elsewhere:
    # >> t2.save('subject' => 'Testing bad response')
    # RestClient::RequestFailed: HTTP status code 409
    
    @params = @@db.save_doc( @params.merge(params_hash) )
  end
  
  def self.find(id)
    puts self.inspect
    self.setup
    new(@@db.get(id))
  end
  
  private
  def self.setup
    base_dir = File.join( File.dirname(__FILE__), '..' )
    @@config ||= YAML.load( File.open( File.join( base_dir, 'config.yml') ) )
    @@db ||= CouchRest.database(@@config['database'])
  end
  
end