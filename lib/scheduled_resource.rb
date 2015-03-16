# scheduled_resource.rb
# Copyright (c) 2008-2015 Mike Cannon (michael.j.cannon@gmail.com)
#   (http://github.com/emeyekayee/scheduled_resource)
# MIT License.
#

require 'scheduled_resource/version'
require 'scheduled_resource/resource_use_block'
require 'scheduled_resource/helper'
require 'scheduled_resource/config'

require 'z_time_header'
require 'z_time_header_day'
require 'z_time_header_hour'
require 'z_time_label'
require 'z_time_label_day'
require 'z_time_label_hour'

# A "scheduled resource" is something that can be used for one thing at a time.
#
# Example: A Room (resource) is scheduled for a meeting (resource use block)
# titled "Weekly Staff Meeting" tomorrow from 9am to 11am.
#
# Class ScheduledResource manages class names, id's and labels for a
# schedule.  An instance ties together:
#
#  1. A resource class (eg Room),
#  2. An id (string), and
#  3. Strings / html snippets (eg, label, title) for the DOM.
#
# The id (2 above) is used to
#
# a) select a resource <em>instance</em> and
#
# b) select instances of the <em>resource use block</em> class (eg Meeting).
#
# The id <em>may</em> be a database id but need not be.
# It is used by class methods
# <tt>get_all_blocks()</tt> of model use-block classes.
# Not tying this to a database id allows a little extra flexibility in
# configuration.
#
# Items 1 and 2 are are combined (with a '_') to form "tags" (ids) for the DOM.
#
# See also:              ResourceUseBlock, Config.
#
# When queried with an array of ids and a time interval, the class
# method <tt>get_all_blocks(ids, t1, t2)</tt> of a <em>resource use</em>
# model returns a list of "use blocks", each with a starttime, endtime
# and descriptions of that use.
#
# This method invokes that method on each of the <em>resource use</em>
# classes.  It returns a hash where:
#   Key     is a Resource (rsrc);
#   Value   is an array of use-block instances (rubs).
#
class ScheduledResource

  class_attribute :rsrc_of_tag
  self.rsrc_of_tag = {}

  class << self
    # (ScheduledResource protocol) Returns a hash where each key is an
    # <tt>rid</tt> and the value is an array of resource use
    # blocks in the interval <tt>t1...t2</tt>, ordered by
    # <tt>starttime</tt>.
    #
    # What <em>in</em> means depends on <em>inc</em>.  If inc(remental) is
    # false, the client is building the interval from scratch.  If "hi", it is
    # an addition to an existing interval on the high side.  Similarly
    # for "lo".  This is to avoid re-transmitting blocks that span the
    # current time boundaries on the client.
    #
    # Here the resource is a channel and the use blocks are programs.
    #
    # ==== Parameters
    # * <tt>config</tt> - A configuration instance.
    # * <tt>t1</tt>     - Start time.
    # * <tt>t2</tt>     - End time.
    # * <tt>inc</tt>    - One of nil, "lo", "hi" (See above).
    #
    # ==== Returns
    # * <tt>Hash</tt> - Each key is an <tt>rid</tt>; value is a list of blocks.
    def get_all_blocks(config, t1, t2, inc)
      blockss = {}

      config.rsrcs_by_kind.each do |kind, rsrcs|
        rub_class = config.block_class_for_resource_name kind
        rids      = rsrcs.map{ |r| r.sub_id }
        ru_blkss  = rub_class.get_all_blocks rids, t1, t2, inc

        add_rubs_of_kind kind, ru_blkss, blockss
      end

      blockss
    end

    def compose_tag( kind, sub_id ); "#{kind}_#{sub_id}" end

    def make_resource_of_kind( klass, rid )
      klass = klass.constantize if klass.is_a? String # ToDo: Trim this.
      get_for( klass.name, rid )
    end


    private
    # A caching one-of-each-sort constructor.
    #
    # ==== Parameters
    # * <tt>kind</tt> - Class name (string) of a scheduled resource.
    # * <tt>rid</tt>  - Id (string), selecting a resource instance.  The two are combined and used as a unique tag in the DOM as id and class attributes as well as in server code.
    def get_for( kind, rid )
      tag = compose_tag( kind, rid )
      # config[:rsrc_of_tag][ tag ] || self.new( kind, rid )
      rsrc_of_tag[ tag ] || new( kind, rid )
    end

    def add_rubs_of_kind( kind, ru_blkss, blockss )
      ru_blkss.each do |rid, blks|
        rsrc = get_for( kind, rid )
        rubs = blks.map{ |blk| ResourceUseBlock.new rsrc, blk }
        blockss[ rsrc ] = rubs
      end
    end

  end


  public

  # Instance methods
  def initialize( kind, rid ) # :nodoc:
    # @tag = self.class.send( :compose_tag, kind, rid )
    @tag = self.class.compose_tag( kind, rid )
    @label = @title = nil
    self.class.rsrc_of_tag[@tag] = self
  end

  # ==== Returns
  # * <tt>String</tt> - The class name of the scheduled resource.
  def kind()    @tag.sub( /_.*/, '' )          end

  # ==== Returns
  # * <tt>String</tt> - The <tt>rid</tt> (abstract id) of the ScheduledResource.
  def sub_id()  @tag.sub( /.*_/, '' )          end

  def to_s() # :nodoc:
    @tag
  end

  def inspect() # :nodoc:
    "<#ScheduledResource \"#{@tag}\">"
  end

  attr_writer :label, :title
  def label();     @label || @tag end
  def title();     @title || @tag end


  # ==== Returns
  # * <tt>String</tt> - CSS classes automatically generated for the DOM row representing this SchedResource.
  def css_classes_for_row(); "rsrcRow #{self.kind}row #{@tag}row #{self.kind}Row #{@tag}Row" end # Row + row -- really?
end
