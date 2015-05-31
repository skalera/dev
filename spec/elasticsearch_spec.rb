require 'spec_helper'

require 'net/http'
require 'uri'

describe 'elasticsearch' do
  it 'should respond to GET' do
    uri = URI.parse('http://localhost:9200')
    response = Net::HTTP.get_response(uri)
    expect(response).to be_an_instance_of(Net::HTTPOK)
  end
end
