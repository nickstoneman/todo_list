require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry-byebug'

get '/' do 
  redirect to ('/items')
end

get '/items' do
  sql = 'select * from items'
  @items = run_sql(sql)
  erb :index
end

get '/items/new' do
  erb :new
end

post '/items' do
  sql = "insert into items (item, details) values ('#{params[:item]}', '#{params[:details]}')"
  run_sql(sql)
  redirect to('/items')
end

get '/items/:id' do
  sql = "select * from items where id = #{params[:id]}"
  @item = run_sql(sql).first
  erb :show
end

get '/items/:id/edit' do
   sql = "select * from items where id = #{params[:id]}"
   @item = run_sql(sql).first
   erb :edit
end

post '/items/:id' do
  sql = "update items set item = '#{params[:item]}', details = '#{params[:details]}' where id = #{params[:id]}"
  run_sql(sql)
  redirect to("/items/#{params[:id]}")
end

delete '/items/:id/delete' do
  sql = "delete from items where id = #{params[:id]}"
  run_sql(sql)
  redirect to('/items')
end


private

def run_sql(sql)
  conn = PG.connect(dbname: 'todo', host: 'localhost')
  begin
    result = conn.exec(sql)
  ensure
    conn.close
  end
  result
end

