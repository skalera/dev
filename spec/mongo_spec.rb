require 'spec_helper'
require 'mongo'

describe 'mongo' do
  it 'should work' do
    Mongo::Logger.logger.level = Logger::INFO
    mongo_config = Diplomat::Service.get('mongo')
    mongo = Mongo::Client.new(["#{mongo_config.Address}:#{mongo_config.ServicePort}"], database: 'test')
    result = mongo[:foobar].insert_one(name: 'foobar')
    expect(result.n).to eq(1)
    result = mongo[:foobar].find(name: 'foobar')
    result = result.delete_many
    expect(result.n).to_not eq(0)
  end
end
