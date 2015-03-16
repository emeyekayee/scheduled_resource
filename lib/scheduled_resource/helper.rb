# Using ScheduledResource as a module here for namespacing (in transition).
class ScheduledResource

  module Helper

    def ensure_schedule_config   # fka :config_from_yaml : :ensure_config
      meth = params[:reset] ? :from_base : :ensure
      @config = ScheduledResource::Config.send( meth, session )
    end

    def default_time_param
      t_now = Time.now
      t_now.change :min => (t_now.min/15) * 15
    end

    def set_schedule_query_params(p = params)
      @t1 = p[:t1] || default_time_param
      @t2 = p[:t2] || @t1 + @config.visible_time # ScheduledResource.visible_time
      @inc= p[:inc]
    end

    # Set up instance variables for render templates or returned json
    #  params:  @t1:      time-inverval start
    #           @t2:      time-inverval end
    #           @inc:     incremental update?  One of: nil, 'lo', 'hi'
    #
    #  creates: @rsrcs    ordered resource list
    #           @blockss: lists of use-blocks, keyed by resource
    def get_data_for_time_span()
      set_schedule_query_params

      @t1 = Time.at(@t1.to_i)
      @t2 = Time.at(@t2.to_i)

      @rsrcs   = @config.resource_list   # ScheduledResource.resource_list

      @blockss = ScheduledResource.get_all_blocks(@config, @t1, @t2, @inc)

      json_adjustments
    end

    def min_time;  @config.time_range_min.to_i end # ScheduledResource.config[:time_range_min]
    def max_time;  @config.time_range_max.to_i end # ScheduledResource.config[:time_range_max]

    # Always send starttime/endtime attributes as Integer values (UTC)
    # -- they are used to size and place the use_blocks.  Timezone is
    # configured separately in the ZTime* classes
    # (config/resource_schedule.yml).
    def json_adjustments
      @blockss.each do |rsrc, blocks|
        blocks.each do |block|
          block.starttime =  block.starttime.to_i
          block.endtime   =  block.endtime.to_i
        end
      end
      @blockss['meta'] = {
        rsrcs: @rsrcs, min_time: min_time, max_time: max_time,
        t1: @t1.to_i, t2: @t2.to_i, inc: @inc,
      }
    end

  end

end
