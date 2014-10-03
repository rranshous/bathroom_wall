require 'sinatra'
require 'sinatra/sequel'
require 'json'

migration "create graffiti table" do
  database.create_table :graffitis do
    primary_key :id
    text        :body
    text        :url
    timestamp   :created_at

    index :url, :unique => false
  end
end

class Graffiti < Sequel::Model
  def to_json
    JSON.dump(
      body: body
    )
  end
end

post '/:url' do
  request.body.rewind
  body = request.body.read
  url = params[:url]
  g = Graffiti.new(url: url, body: body, created_at: Time.now)
  g.save
  g.to_json
end

get '/:url' do
  content_type :json
  url = params[:url]
  Graffiti.filter(:url => url).all.map(&:to_json).to_json
end
