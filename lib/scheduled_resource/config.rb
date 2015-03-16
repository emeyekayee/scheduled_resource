class ScheduledResource # Think module 

  # Config is loaded from config/schedule.yml:
  # ResourceKinds::   A list of string pairs: [ resource class, use_block class ]
  # Resources::       A list of: [ ResourceKind resource_id... ] 
  # visibleTime::     Span of time window (seconds).
  # timeRangeMin::
  # timeRangeMax::

  # Schedule configuration data itself is fairly brief and generally
  # can be kept in the session.  An instance of this class (though
  # reflecting the same information) isn't suitable for session
  # storage.  It is more useful for processing a request and also
  # mediates (later) changes to the configuration.
  class Config
    
    attr_reader :visible_time, :time_range_min, :time_range_max
    attr_reader :resource_list

    # For now we have a single, static configuration...
    CONFIG_FILE = "config/resource_schedule.yml"
    #--
    # Restore configuration from session or base as needed.
    #
    # When we depend on data in the configuration to satisfy a query we are not
    # being RESTful.  On the other hand we are not maintaining changeable state
    # here -- it's just a cache.  If there <em>were</em> changeable state it
    # would likely be kept, eg, in a per-user table in the database.
    #++
    def self.ensure( session )              # fka ensure_config
      yml_string = session[:schedule_config]
      return new( YAML.load(yml_string) ) if yml_string

      from_base( session )
    end


    # ToDo: Generalize this so configuration can be loaded on per-user.
    def self.from_base( session )           # fka config_from_yaml1
      yml = YAML.load_file CONFIG_FILE
      session[:schedule_config] = yml.to_yaml
      new( yml )
    end


    # (hi-lock-face-buffer "yml\\[.*\\]" 'hi-yellow)
    # A Hash, as from a yml file.
    def initialize( yml )                   # fka config_from_yaml
      @yml = yml
      @resource_list                 = []   # fka :all_resources
      @block_class_for_resource_kind = {}
      
      yml['ResourceKinds'].each do |key, val| # {"Channel" => "Program"...}
        @block_class_for_resource_kind[key] = val # class name (string)
      end

      do_resource_kind_lists( yml['Resources'] || [] )


      # Eval is FAR TOO DANGEROUS for user input.  Rather, parse a string
      # into (number).(unit) (maybe a couple of other patterns) to sanitize.
      vt = yml['visibleTime']
      @visible_time   = vt ? (eval vt) : 3.hours

      t0 = yml['timeRangeMin']
      @time_range_min = t0 ? (eval t0) : (Time.now - 1.week)

      tn = yml['timeRangeMax']
      @time_range_max = tn ? (eval tn) : (Time.now + 1.week)


      rsrcs_by_kind.each do |kind, rsrcs|   # fka config_from_yaml2
        klass = kind.constantize
        rsrcs.each {|rsrc| klass.decorate_resource rsrc }
      end
    end


    # Resource Kind Lists,
    # Each line (in yml format) is a ResourceKind followed by rids
    # such as  "Channel   702 703 ..."
    def do_resource_kind_lists( rkls )
      rkls.each do |rkl|
        rkl   = rkl.split(/[, ]+/)   # ["Channel",  "702", "703" ...]
        rk    = rkl.shift
        rsrcs = rkl.map{|rid| ScheduledResource.make_resource_of_kind(rk, rid)}

        add_resources rsrcs
      end
    end


    # Hmm... DOM Row uniqueness vs resource (tag) uniqueness.
    def add_resources(rsrcs)
      rsrcs.each do |rsrc| 
        @resource_list << rsrc unless @resource_list.include? rsrc 
      end
    end

    def rsrcs_by_kind
      @resource_list.group_by{ |r| r.kind }
    end

    # ==== Parameters
    # * <tt>name</tt>  - The class name (string) of a schedule resource.
    #
    # ==== Returns
    # * <tt>Class</tt> - The class representing the <em>use</em> of that resource for an interval of time.
    def block_class_for_resource_name( name )
      @block_class_for_resource_kind[name].constantize
    end

  end

end
