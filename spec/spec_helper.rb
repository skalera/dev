require 'diplomat'

ifconfig = `ifconfig eth1`
ip = ifconfig.match(/addr:([0-9\.]+)\s+Bcast/)[1]

Diplomat.configuration.url = ("http://#{ip}:8500")

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
