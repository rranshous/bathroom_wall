require 'sinatra'
require 'sinatra/sequel'
require 'json'
require 'pry'

migration "create graffiti table" do
  database.create_table :graffitis do
    primary_key :id
    text        :body
    text        :url
    timestamp   :created_at

    index :url, :unique => false
  end
end

migration "store headers on graffiti" do
  database.alter_table :graffitis do
    add_column :headers, :text
  end
end

class Graffiti < Sequel::Model
  def to_h
    { body: body,
      headers: headers,
      url: url,
      timestamp: created_at.to_i }
  end
end

get '/' do
  content_type :json
  Graffiti.all.map(&:to_h).to_json
end

post '/:url' do
  content_type :json
  request.body.rewind
  body = request.body.read
  headers = request_headers.to_json
  url = params[:url]
  g = Graffiti.new(url: url, headers: headers, body: body, created_at: Time.now)
  g.save
  g.to_h.to_json
end

get '/:url' do
  content_type :json
  url = params[:url]
  Graffiti.filter(:url => url).all.map(&:to_h).to_json
end


helpers do
  def request_headers
    env.inject({}){|acc, (k,v)| acc[$1] = v if k =~ /^http_(.*)/i; acc}
  end
end

