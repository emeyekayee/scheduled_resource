#ScheduledResource

This gem is for displaying how something is used over periods of time.
It began life as a Rails/Ajax TV schedule but over time I've used it for
other things and found it useful.

A _scheduled resource_ is something that can be used for one thing at a time.  Say a TV station
(resource) is scheduled to show "Mr Ed" from 10am to 11am on Saturday.  That showing is a _resource use block_.
Each resource gets one row in the display.

Resources and use_blocks are often models in a Rails app.  
The schedule configuration comes from <tt>config/resource_schedule.yml</tt>



The <b>ScheduledResource</b> class manages resource and use_block class names, id's and labels for a schedule.  A ScheduledResource instance ties together:

 1. A resource class (eg Station),
 2. An id, and
 3. Strings and other assets that will go into the DOM.

The id is used to
  - select a resource <em>instance</em> and
  - select instances of the <em>resource use block</em> class (eg Program).

The id <em>could</em> be a database id but more often is something a
little more suited to human use in the configuration file.  In any case
it is used by class methods
<tt>ResourceUseBlock.get_all_blocks()</tt> to select the right blocks
for the resource.

Resource class name and ids are are combined (with a '_') to form tags that also
serve as ids for the DOM.



## Configuration 

Configuration is loaded from config/resource_schedule.yml which has three
top-level sections:
 - ResourceKinds:  A hash where the key is a Resource and the value is a UseBlock. (Both class names)
 - Resources:  A list where each item is a resource Class followed by one or more resource ids.
 - visibleTime:  The visible timespan of the schedule (seconds).



Something else you would see in a schedule would be headers and labels
-- perhaps one row with the date and another row with the hour.
Headers with labels also fit the model of resources and use_blocks.
Basic timezone-aware classes (ZTime*) for those are included in this gem.




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

To Do: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/scheduled_resource/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
