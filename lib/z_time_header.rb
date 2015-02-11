# This is a base for ScheduledResource classes (see below) for timezone-aware time
# headers.  The timezone is specified by the last component of the resource id
# (rid).  Eg, for 'Day_-8' the timezone is ActiveSupport::TimeZone.new(-8)


class ZTimeHeader

  # (For ScheduledResource protocol)  This method lets us set display attributes
  # on the instance in a way specific to the resource-class and rid.
  # 
  # ==== Parameters
  # * <tt>rsrc</tt> - A ScheduledResource instance. 
  def self.decorate_resource( rsrc )
    rid = rsrc.sub_id

    rsrc.label = 'Time'   # Overridden, presumably
    rsrc.title = rid
  end

end
