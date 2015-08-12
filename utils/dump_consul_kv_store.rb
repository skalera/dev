#!/usr/bin/env ruby

# Copyright 2015 Skalera Corporation
# All Rights Reserved

# make sure the program is invoked through bundle exec
exec('bundle', 'exec', $PROGRAM_NAME, *ARGV) unless ENV['BUNDLE_GEMFILE']

require 'diplomat'

def configure_consul(consul)
  Diplomat.configuration.url = ("http://#{consul}:8500")
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
configure_consul(consul)
entries = Diplomat::Kv.get('/', recurse: true)
output(entries) unless entries.length < 1
