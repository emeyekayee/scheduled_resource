#ScheduledResource

This gem is for displaying how something is used over periods of time.
It began life as a Rails/Ajax TV schedule but over time I've used it for
other things and found it useful.

A _scheduled resource_ is something that can be used for one thing at a time.  Say a TV station
(resource) is scheduled to show "Mr Ed" from 10am to 11am on Saturday.  That showing is a _resource use block_.  
Resources and use_blocks are often models in a Rails app.  Each resource gets one row in the display.

The schedule configuration comes from <tt>config/resource_schedule.yml</tt>




The <b>ScheduledResource</b> class manages resource and use_block class names, id's and labels for a schedule.  A ScheduledResource instance ties together:

 1. A resource class (eg Station),
 2. An id, and
 3. Strings and other assets that will go into the DOM.

The id (2 above) is used to
  - select a resource <em>instance</em> and
  - select instances of the <em>resource use block</em> class (eg Program).

The id <em>could</em> be a database id but more often is something a little more suited to human use configuration.  
In any case it is used by model class method
<tt>ResourceUseBlock.get_all_blocks()</tt> to select the right blocks for a resource.

Items 1 and 2 above are are combined (with a '_') to form "tags" -- ids for the DOM.

See also:              ResourceUseBlock.



Configuration is loaded from config/resource_schedule.yml:
 - all_resources::      Resources in display order.
 - rsrcs_by_kind::      A hash with resources grouped by kind (resource class).
 - rsrc_of_tag::        Indexed by text tag: kind_subid.
 - \visible_time::       Span of time window.
+


This method invokes that method on each of the <em>resource use</em>
classes.  It returns a hash where:
  Key     is a Resource (rsrc);
  Value   is an array of use-block instances (rubs).


Something else you would see in a schedule would be headers and labels
-- perhaps one row with the date and another row with the hour.
Headers with labels also fit the model of resources and use_blocks.
Basic classes for those are included in this gem.




## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scheduled_resource'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scheduled_resource

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scheduled_resource/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
