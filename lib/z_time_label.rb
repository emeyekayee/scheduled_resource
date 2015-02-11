# For ScheduledResource protocol.  This is a base UseBlock class for ZTimeHeader
# use-block subclasses.  These are timezone-aware time headers (rows) and labels
# (use-blocks).  The timezone is specified by the last component of the resource
# id (rid).  Eg, for '-8' the timezone is ActiveSupport::TimeZone.new(-8)

class ZTimeLabel
  attr_accessor :starttime, :endtime, :css_classes, :title

  class_attribute :label, :format, :t_block # t_block (if used) set by subclass

  # Parameters are TimeWithZone or similar
  def initialize( starttime, endtime )
    @starttime, @endtime = starttime, endtime
  end


  # (ScheduledResource protocol) Returns a hash where each key is an
  # <tt>rid</tt> and the value is an array of ZTimeLabels (use
  # blocks) in the interval <tt>t1...t2</tt>, ordered by
  # <tt>starttime</tt>.
  #
  # What <em>in</em> means depends on *inc*.  If inc(remental) is
  # nil/false, client is building the interval from scratch.  If "hi", it is
  # an addition to an existing interval on the high side.  Similarly
  # for "lo".  This is to avoid re-transmitting blocks that span the
  # current time boundaries on the client.
  #
  # Here the resource is a ZTimeHeader and the use-blocks are ZTimeLabels.
  #
  # ==== Parameters
  # * <tt>rids</tt> - A list of schedules resource ids (strings).
  # * <tt>t1</tt>   - Start time.
  # * <tt>t2</tt>   - End time.
  # * <tt>inc</tt>  - One of nil, "lo", "hi" (See above).
  #
  # ==== Returns
  # * <tt>Hash</tt> - Each key is a <tt>rid</tt> such as Hour0
  # and the value is an array of Timelabels in the interval, ordered by
  # <tt>starttime</tt>.
  def self.get_all_blocks(ids, t1, t2, inc)
    h = {}
    ids.each{|id| h[id] = get_timeblocks(id, t1, t2, inc)}
    h
  end


  def self.get_timeblocks(id, t1, t2, inc)
    tz = tz_from_rid( id )
    
    t1 = floor( tz.at(t1) )
    t1 = end_for_start(t1)  if inc == 'hi'

    t2 = tz.at(t2)
    t2 = floor( t2 ) - 1    if inc == 'lo'

    enum_for( :time_blocks_starting_through, t1, t2 ).to_a
  end

 
  def self.time_blocks_starting_through( starttime, limit )
    while starttime <= limit do  # Hmm... I would have guessed '<' over '<='...
      endtime = end_for_start starttime
      yield new( starttime, endtime )
      starttime = endtime
    end
  end


  TZ_INT_MAP = {
    -8 => ActiveSupport::TimeZone.new('Pacific Time (US & Canada)' ), # P
    -7 => ActiveSupport::TimeZone.new('Mountain Time (US & Canada)'), # M
    -6 => ActiveSupport::TimeZone.new('Central Time (US & Canada)' ), # C
    -5 => ActiveSupport::TimeZone.new('Eastern Time (US & Canada)' ), # E
                }

  def self.tz_from_rid( rid )
    # ActiveSupport::TimeZone.new offset_from_rid(rid)
    TZ_INT_MAP[ offset_from_rid(rid) ] || TZ_INT_MAP[-8]
  end

  def self.offset_from_rid( rid )
    (rid.split('_').last || '').to_i
  end

  def self.end_for_start(t) t + 1 end  # Overridden.
  def self.floor(t)         t     end  # Overridden.

end
