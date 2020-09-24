require 'sequel'
require 'sinatra/base'
require 'sinatra/reloader'
require 'yaml/store'
require 'byebug'

class TodoApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  
  Sequel.extension :migration
  DB = Sequel.connect('sqlite://development.db')
  Sequel::Migrator.run(DB, 'db/migrations', use_transactions: true)
  
  require './models/todo'
  Dir['./models/*.rb'].each { |f| require f }
  
  get '/' do
    # Render main page
    @title = "Todo List"
    @todos = Todo.find(completed: false)
    erb :index
  end
  
  get '/api/v1/todo' do
    Todo.all.to_json
  end
  
  put '/api/v1/todo' do
    data = JSON.parse request.body.read
    Todo.create(data).to_json
  end
  
  post '/api/v1/todo/:id' do |id|
    data = JSON.parse request.body.read
    (Todo[id.to_i]&.update(data) || {}).to_json
  end
  
  delete '/api/v1/todo/:id' do |id|
    (Todo[id.to_i]&.delete || {}).to_json
  end
end