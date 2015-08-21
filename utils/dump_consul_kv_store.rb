#!/usr/bin/env ruby

# Copyright 2015 Skalera Corporation
# All Rights Reserved

# make sure the program is invoked through bundle exec
exec('bundle', 'exec', $PROGRAM_NAME, *ARGV) unless ENV['BUNDLE_GEMFILE']

require 'diplomat'

def configure_consul(consul, acl_token)
  Diplomat.configuration.url = ("http://#{consul}:8500")
  # Diplomat.configuration.acl_token='c55c2a45-b0c7-149e-92c3-d5f9c368583a' # TEST
  Diplomat.configuration.acl_token = ("#{acl_token}")
  rescue Faraday::ConnectionFailed
    STDERR.puts("ERROR: could not lookup host #{consul}")
    exit(1)
end

def output(kvlist)
  message = "KV dump from #{Diplomat.configuration.url}"
  puts message
  message.length.times { print '*' }
  puts "\n"
  kvlist.each do |entry|
    puts entry[:key] + ' ' + entry[:value]
  end
end

consul = ENV['CONSUL'] || 'consul'
acl_token = ENV['CONSUL_KV_KEY'] || fail('Please configure CONSUL_KV_KEY with a valid key..')
configure_consul(consul, acl_token)
begin
  entries = Diplomat::Kv.get('/', recurse: true)
  rescue Diplomat::UnknownStatus
    STDERR.puts('ERROR: probably wrong access key...')
    exit(1)
end
output(entries) unless entries.length < 1
