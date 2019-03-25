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

proxy = URI(ENV["QUOTAGUARDSTATIC_URL"])
$options = {
  http_proxyaddr: proxy.host,
  http_proxyport: proxy.port,
  http_proxyuser: proxy.user,
  http_proxypass: proxy.password,
  headers: { 'Accept' => 'application/json' },
  timeout: 5
}

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
      url: 'https://digital-hub-stage.hmpps.dsd.io/health',
      method: 'https'
    },
    {
      name: 'hub-berwyn',
      url: 'http://bli.prod.admin.hub.service.hmpps.dsd.io/health',
      method: 'http'
    },
    {
      name: 'hub-wayland',
      url: 'http://wli.prod.admin.hub.service.hmpps.dsd.io/health',
      method: 'http'
    },
]


def gather_health_data(server)
    puts "requesting #{server[:url]}..."
    begin
      server_response = HTTParty.get(server[:url], $options)
      ap server_response.inspect
      return JSON.parse(server_response.parsed_response)
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
