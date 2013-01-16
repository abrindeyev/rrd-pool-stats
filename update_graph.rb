#!/usr/bin/env ruby

require 'rubygems'
require 'RRD'

hostname = ENV['JOB_NAME'].gsub(/-pool-stats/, '')
rrdfile = "#{hostname}.rrd"

# Mapping between RRDTool datasource variables and pool statuses
pool_map = {
  "cleanup"  => "Cleaning up",
  "leased" => "Leased",
  "ready"  => "Ready"
}

now = Time.now.to_i

RRD.graph(
           "#{hostname}_last_hour.png",
           "--start", now - 60*60,
           "--end", now,
           "--vertical-label", "VMs",
           "DEF:cleanup=#{hostname}.rrd:cleanup:AVERAGE",
           "DEF:leased=#{hostname}.rrd:leased:AVERAGE",
           "DEF:ready=#{hostname}.rrd:ready:AVERAGE",
           "AREA:leased#FF0000:'Leased'",
           "STACK:cleanup#00FF00:'Cleaning up'",
           "STACK:ready#0000FF:'Ready'"
)
