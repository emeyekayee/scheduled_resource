#ScheduledResource

This gem is for displaying how things are used
over time -- a schedule for a set of resources.  It
provides a way to describe what is being displayed,
along with utilities and protocols to connect them:

 - Configuration (specification and management),
 - Query interfaces (a REST-like API and internal protocols to query the models), and
 - A basic Rails controller implementation.

So we have a way to configure the schedule, internal
methods to generate the data, and a way to retrieve
data from the client.  But the gem is largely
view-framework agnostic.  We could use a variety of
client-side packages or even more traditional Rails
view templates to generate HTML.

In any case, to get a the most from a display like this
we need some client-side code.  The gem includes
client-side modules to:

 - Manage <b>time and display geometries</b> with "infinite" scroll along the time axis.
 - <b>Format display cells</b> in ways specific to the resource models.
 - <b>Update text justification</b> as the display is scrolled horizontally.


## Configuration Management

A **scheduled resource** is something that can be
used for one thing at a time.  Say "Rocky & Bullwinkle"
is on channel 3 from 10am to 11am on Saturday.  Then
'channel 3' is the <u>resource</u> and that showing of
the is a <u>resource-use block</u>.  Resources and 
use-blocks are typically Rails models.  Each resource
and its use-blocks get one row in the display.  That
row has a label to the left with some timespan visible
on the rest of the row.

The <b>ScheduledResource</b> class manages resource and
use-block class names, id's and labels for a schedule.
A ScheduledResource instance ties together:

 1. A resource class (eg TvStation),
 2. An id (a channel number in this example), and
 3. Strings and other assets that will go into the DOM.

The id is used to
  - select a resource <em>instance</em> and
  - select instances of the <em>resource use block</em> class (eg Program instances).

The id <em>could</em> be a database id but more
often is something a little more suited to human use
in the configuration.  In any case it is used by model
class method
<tt>(resource_use_block_class).get_all_blocks()</tt>
to select the right use-blocks for the resource.
A resource class name and id are are joined with
a '_' to form a tag that also serves as an id for the DOM.

Something else you would expect see in a schedule
would be headers and labels -- perhaps one row with
the date and another row with the hour.  Headers and
labels also fit the model of resources and use_blocks.
Basic timezone-aware classes (ZTime*) for those are
included in this gem.


### Configuration File

The schedule configuration comes from
<tt>config/resource_schedule.yml</tt> which has
three top-level sections:

- ResourceKinds:  A hash where the key is a Resource and the value is a UseBlock. (Both are class names),
- Resources:  A list where each item is a Resource Class followed by one or more resource ids, and
- visibleTime:  The visible timespan of the schedule in seconds.

The example file <tt>config/resource_schedule.yml</tt>
(installed when you run <tt>schedulize</tt>) should be
enough to display a two-row schedule with just the date
above and the hour below.  Of course you can monkey-patch
or subclass these classes for your own needs.


### The schedule API

The endpoint uses parameters <tt>t1</tt> and
<tt>t2</tt> to specify a time interval for the request.
A third parameter <tt>inc</tt> allows an initial time
window to be expanded without repeating blocks that
span those boundaries.  The time parameters _plus the
configured resources_ define the data to be returned.


### More About Configuration Management

Once the configuration yaml is loaded that data is
maintained in the session structure.  Of course having
a single configuration file limits the application's
usefulness.  A more general approach would be to
have a user model with login and configuration would
be associated with the user.






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

1. Fork it ( https://github.com/emeyekayee/scheduled_resource/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
