function append_collected_at(tag, timestamp, record)
  datetime = os.date("%Y-%m-%dT%H:%M:%S", timestamp)
  ms = math.floor((timestamp - math.floor(timestamp)) * 1000)
  timezone = os.date("%z", timestamp)
  record["collected_at"] = string.format("%s.%03d%s", datetime, ms, timezone)

  return 1, timestamp, record
end