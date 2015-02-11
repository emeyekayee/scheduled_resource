
class ZTimeHeaderDay < ZTimeHeader

  # (For ScheduledResource protocol)  This method lets us set display attributes
  # on the instance in a way specific to the resource-class and rid.
  # 
  # ==== Parameters
  # * <tt>rsrc</tt> - A ScheduledResource instance. 
  def self.decorate_resource( rsrc )
    rid = rsrc.sub_id

    rsrc.label = "Day"
    rsrc.title = rid
  end

end
