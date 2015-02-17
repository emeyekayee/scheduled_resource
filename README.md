#ScheduledResource

This gem is for displaying how things are used over time -- a schedule for a
set of resources.  It provides a way to describe what is being displayed, along
with utilities and protocols to connect them:

 - Configuration (specification and management).
 - Query interfaces (RESTlike API and protocols to query the models).
 - A basic Rails controller implementation.

We have outlined how to model and generate the data, and how to retrieve it
from the client.  At this point we could say the gem is largely view-agnostic.
But to get a satisfying client-side experience the gem includes client-side
modules to:

 - Manage <b>time and display geometries</b> with "infinite" scrolling along the time axis.
 - <b>Format display cells</b> in ways specific to the resource models.
 - <b>Update text justification</b> as the display is scrolled horizontally.


### Configuration Management

A _scheduled resource_ is something that can be used for one thing at a time.
Say "Rocky & Bullwinkle" is on channel 3 from 10am to 11am on Saturday.  Then
'channel 3' is the <u>resource</u> and that showing is a <u>resource-use block</u>.
Resources and use-blocks are typically Rails models.  Each resource and its
use-blocks get one row in the display.

The schedule configuration comes from <tt>config/resource_schedule.yml</tt>

The <b>ScheduledResource</b> class manages resource and use_block class names, id's and labels for a schedule.  A ScheduledResource instance ties together:

 1. A resource class (eg Station),
 2. An id, and
 3. Strings and other assets that will go into the DOM.

The id is used to
  - select a resource <em>instance</em> and
  - select instances of the <em>resource use block</em> class (eg Program).

The id <em>could</em> be a database id but more often is something a
little more suited to human use in the configuration.  In any case
it is used by model class method
<tt>ResourceUseBlock.get_all_blocks()</tt> to select the right blocks
for the resource.

Resource class name and ids are are combined (with a '_') to form tags that also
serve as ids for the DOM.



## Configuration File

Configuration is loaded from config/resource_schedule.yml which has three
top-level sections:
 - ResourceKinds:  A hash where the key is a Resource and the value is a UseBlock. (Both class names)
 - Resources:  A list where each item is a resource Class followed by one or more resource ids.
 - visibleTime:  The visible timespan of the schedule (seconds).





Something else you would see in a schedule would be headers and labels
-- perhaps one row with the date and another row with the hour.
Headers with labels also fit the model of resources and use_blocks.
Basic timezone-aware classes (ZTime*) for those are included in this gem.






### More About Configuration Management







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
