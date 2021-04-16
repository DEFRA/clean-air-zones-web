# frozen_string_literal: true

##
# Helper module for handling time zone differences
module TimeZoneHelper
  # Parses UTC date string to UTC Time object
  def parse_utc_date(date)
    Time.find_zone('UTC').parse(date)
  end
end
