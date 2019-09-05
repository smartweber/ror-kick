module TimeHelper
  def get_time_in_time_zone(time_to_convert, time_zone_offset, additional_offset=0)
    ActiveSupport::TimeZone[ time_zone_offset ].parse(time_to_convert.strftime("%Y-%m-%d %I:%M%p"))
  end
end
