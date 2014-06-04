require 'data_mapper'
require 'dm-mysql-adapter'
require 'dm-timestamps'

username = ENV['PALYIO_USERNAME']
password = ENV['PALYIO_PASSWORD']
host     = ENV['PALYIO_HOST']
database = ENV['PALYIO_DATABASE']

DataMapper.setup :default, "mysql://#{username}:#{password}@#{host}/#{database}"

class Link
  include DataMapper::Resource

  property :id, Serial
  property :shortkey, String, :unique => true
  property :url, Text
  property :hits, Integer, :default => 0

  has n, :hit_objs, 'Hit'

  def hit_count
    hits + hit_objs.count
  end
end

class Hit
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime

  belongs_to :link
end

DataMapper.finalize
DataMapper.auto_upgrade!
