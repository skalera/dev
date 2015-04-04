require 'spec_helper'
require 'redis'

describe 'redis' do
  it 'should be working' do
    redis_config = Diplomat::Service.get('redis')
    redis = Redis.new(host: redis_config.Address, port: redis_config.ServicePort)
    redis.set('foobar', 'foobar')
    foobar = redis.get('foobar')
    expect(foobar).to eq('foobar')
    redis.del('foobar')
  end
end
