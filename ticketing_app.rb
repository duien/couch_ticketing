require 'rubygems'
require 'sinatra'
require 'erb'
require 'couchrest'
#require 'yaml'

# let's not worry about logging in for right now

configure :development do
  set :environment, :development
  set :app_file, __FILE__
  set :reload, true
end

configure do
  @@config = YAML.load(File.open( 'config.yml' ))
  @@db = CouchRest.database(@@config['database'])
end

# Load all helpers from the lib directory
load 'lib/helper.rb'
Dir["lib/*-helper.rb"].each { |f| load f }

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