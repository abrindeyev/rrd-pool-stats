#!/usr/bin/env ruby

require 'rubygems'
require 'rest-client'
require 'json'
require 'RRD'

hostname = ENV['JOB_NAME'].gsub(/-pool-stats/, '')
rrdfile = "#{hostname}.rrd"

# Mapping between RRDTool datasource variables and pool statuses
pool_map = {
  "cleanup"  => "Cleaning up",
  "leased" => "Leased",
  "ready"  => "Ready"
}

unless File.exists?(rrdfile)
  start = Time.now.to_i
  ti = 60 # time interval, in seconds

  all_data = pool_map.keys.sort.map{|val| "DS:#{val}:GAUGE:#{ti * 2}:0:U" }
  archives = [
    "RRA:LAST:0.5:1:#{86400 / ti}",
    "RRA:AVERAGE:0.5:#{5*60 / ti}:#{7*24*60}",
    "RRA:MAX:0.5:#{5*60 / ti}:#{7*24*60}",
    "RRA:AVERAGE:0.5:#{60*60 / ti}:#{183*24}",
    "RRA:MAX:0.5:#{60*60 / ti}:#{183*24}"
  ]
  all_data.concat(archives)
  RRD.create(
             rrdfile,
             "--start", "#{start - 1}",
             "--step",  ti, # seconds
             *all_data
  )
end

# Query pool stats
request = {
  "version" => 1
}.to_json
url = "http://#{hostname}/pool/list?params=#{URI.escape(request)}"

result = RestClient.get url
pool_stats = JSON.parse(result)

values = Hash.new;
pool_map.keys.map{|val| values[val] = 0 }

if pool_stats['status'] == 'success'
  pool_stats['result']['nodes'].map { |s| values[ pool_map.invert[ s['status'] ] ] += 1 }
end

template_ds = pool_map.keys
updated_data = template_ds.map { |k| values[k] }.unshift(Time.now.to_i).join(':')

RRD.update(
           rrdfile,
           "--template", template_ds.join(':'),
           updated_data
)
