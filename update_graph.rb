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
           "last_hour.png",
           "--start", now - 60*60,
           "--end", now,
           "--title", "Last hour",
           "--vertical-label", "VMs",
           "--lower-limit", 0,
           "DEF:cleanup=#{hostname}.rrd:cleanup:AVERAGE",
           "DEF:leased=#{hostname}.rrd:leased:AVERAGE",
           "DEF:ready=#{hostname}.rrd:ready:AVERAGE",
           "AREA:leased#FF0000:Leased",
           "STACK:cleanup#0000FF:Cleaning up",
           "STACK:ready#00FF00:Ready"
)

RRD.graph(
           "last_day.png",
           "--start", now - 24*60*60,
           "--end", now,
           "--title", "Last day",
           "--vertical-label", "VMs",
           "--lower-limit", 0,
           "DEF:cleanup=#{hostname}.rrd:cleanup:AVERAGE",
           "DEF:leased=#{hostname}.rrd:leased:AVERAGE",
           "DEF:ready=#{hostname}.rrd:ready:AVERAGE",
           "AREA:leased#FF0000:Leased",
           "STACK:cleanup#0000FF:Cleaning up",
           "STACK:ready#00FF00:Ready"
)

RRD.graph(
           "last_week.png",
           "--start", now - 7*24*60*60,
           "--end", now,
           "--title", "Last week",
           "--vertical-label", "VMs",
           "--lower-limit", 0,
           "DEF:cleanup=#{hostname}.rrd:cleanup:AVERAGE",
           "DEF:leased=#{hostname}.rrd:leased:AVERAGE",
           "DEF:ready=#{hostname}.rrd:ready:AVERAGE",
           "AREA:leased#FF0000:Leased",
           "STACK:cleanup#0000FF:Cleaning up",
           "STACK:ready#00FF00:Ready"
)

RRD.graph(
           "last_month.png",
           "--start", now - 31*24*60*60,
           "--end", now,
           "--title", "Last month",
           "--vertical-label", "VMs",
           "--lower-limit", 0,
           "DEF:cleanup=#{hostname}.rrd:cleanup:AVERAGE",
           "DEF:leased=#{hostname}.rrd:leased:AVERAGE",
           "DEF:ready=#{hostname}.rrd:ready:AVERAGE",
           "AREA:leased#FF0000:Leased",
           "STACK:cleanup#0000FF:Cleaning up",
           "STACK:ready#00FF00:Ready"
)
