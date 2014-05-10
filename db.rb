require 'data_mapper'
require 'dm-mysql-adapter'

username = ENV['PALYIO_USERNAME']
password = ENV['PALYIO_PASSWORD']
host     = ENV['PALYIO_HOST']
database = ENV['PALYIO_DATABASE']

DataMapper.setup(:default, "mysql://#{username}:#{password}@#{host}/#{database}")

class Link
  include DataMapper::Resource

  property :id, Serial
  property :shortkey, String
  property :url, Text
end

DataMapper.finalize
DataMapper.auto_upgrade!
