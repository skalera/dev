require 'spec_helper'

require 'net/http'
require 'uri'

describe 'influxdb' do
  it 'should respond to ping' do
    uri = URI.parse('http://localhost:8086/ping')
    response = Net::HTTP.get_response(uri)
    expect(response).to be_an_instance_of(Net::HTTPNoContent)
  end

  it 'should allow creating a database' do
    uri = URI.parse('http://localhost:8086/query?db=&q=create+database+test')
    response = Net::HTTP.get_response(uri)
    expect(response).to be_an_instance_of(Net::HTTPOK)
    uri = URI.parse('http://localhost:8086/query?db=&q=drop+database+test')
    Net::HTTP.get_response(uri)
  end
end
