require 'spec_helper'

describe 'gvm' do
  xit 'should work' do
    version = 'Go Version Manager v1.0.22 installed at /home/vagrant/.gvm'
    expect(`gvm version`.chomp).to eq(version)
  end
end
