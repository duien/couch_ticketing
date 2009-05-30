require 'rubygems'
require 'sinatra'
require 'erb'
require 'couchrest'

# let's not worry about logging in for right now

@@db = CouchRest.new("http://127.0.0.1:5984").database('ticketing')
set :environment, :development
set :app_file, __FILE__
set :reload, true

helpers do
  def cycle(values) # you can only have one cycle going at a time
    @count ||= 0
    @count = (@count + 1)%values.length
    values[@count-1]
  end
end

get '/' do
  redirect '/tickets/?status=open'
end

get '/tickets/?' do
  if params[:status]
    @tickets = @@db.view('tickets/by_status', :key => params[:status])['rows']
  else
    @tickets = @@db.view('tickets/by_status')['rows']
  end
  erb :'tickets/index'
end

get '/tickets/:id' do
  @ticket = @@db.get(params[:id])
  erb :'tickets/show'
end

get '/tickets/:id/edit' do
  @ticket = @@db.get(params[:id])
  raw_field_values = @@db.view('schema/values_for_field', :group => true)['rows']
  @field_values = {}
  raw_field_values.each { |hash| @field_values[hash['key']] = hash['value'] }
  erb :'tickets/edit'
end