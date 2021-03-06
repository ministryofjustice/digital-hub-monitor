#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'httparty'
require 'ap'

#
### Global Config
#
# httptimeout => Number in seconds for HTTP Timeout. Set to ruby default of 60 seconds.
# ping_count => Number of pings to perform for the ping method
#
httptimeout = 60
ping_count = 10

#
# Check whether a server is Responding you can set a server to
# check via http request or ping
#
# Server Options
#   name
#       => The name of the Server Status Tile to Update
#   url
#       => Either a website url or an IP address. Do not include https:// when using ping method.
#   method
#       => http
#       => ping
#
# Notes:
#   => If the server you're checking redirects (from http to https for example)
#      the check will return false
#
servers = [
    {
      name: 'hub-staging',
      url: 'https://pfs-stage-hub-1.uksouth.cloudapp.azure.com/health',
      method: 'https'
    },
    {
      name: 'hub-berwyn',
      url: 'https://digital-hub.bwi.dpn.gov.uk/health',
      method: 'https'
    },
    {
      name: 'hub-wayland',
      url: 'https://digital-hub.wli.dpn.gov.uk/health',
      method: 'https'
    },
]


def gather_health_data(server)
    puts "requesting #{server[:url]}..."
    begin
      server_response = HTTParty.get(server[:url], headers: { 'Accept' => 'application/json' }, timeout: 5, :verify => false)
      return JSON.parse(server_response.body)
    rescue HTTParty::Error => expectation
      ap expectation.inspect
      return { status: 'error', error: expectation.class, buildNumber: 'N/A', dependencies: { hub: "NA", matomo: "N/A" } }
    rescue StandardError => expectation
      ap expectation.inspect
      return { status: 'error', error: expectation.class, buildNumber: 'N/A', dependencies: { hub: "NA", matomo: "N/A" } }
    end
end

SCHEDULER.every '60s', first_in: 0 do
    servers.each do |server|
      result = gather_health_data(server)
      send_event(server[:name], result: result)
    end
end
