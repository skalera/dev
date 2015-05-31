require 'spec_helper'

describe 'docker' do
  it 'should have eight containers running' do
    docker = `docker ps -q`.split("\n")
    expect(docker.size).to eq(8)
  end
end
