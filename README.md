# Tinny

Tinny is a simple connection manager which makes it easier to configure, setup and asynchronously stream data from multiple serial/CANBUS connections.

It has a dead simple data handler class to implement in order to allow custom data handling on streamed data!

----

Tinny is currently under active development and may be unstable and not production ready.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tinny'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tinny

## Usage

```ruby
serial_data = [{
    connection: 'serial_port_connection',
    config: {
        mount_point: '/dev/ttyACM5',
        baud_rate: 9600,
        data_bits: 8,
        stop_bits: 1,
        data_handler: Tinny::DataHandler::TemperatureHandler.new, # Example data handler
        seconds_between_poll: 5
    }
}, {
    ...
}]

tinny = Tinny::Control.new(tasks_config)
tinny.start
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/william-inf/tinny. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tinny project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/william-inf/tinny/blob/master/CODE_OF_CONDUCT.md).
