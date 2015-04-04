require 'spec_helper'

describe 'docker' do
  it 'should have at least seven containers running' do
    docker = `docker ps -q`.split("\n")
    expect(docker.size).to eq(7)
  end
end
