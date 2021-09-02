# BrainfuckRuby

A brainfuck interpreter written in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'brainfuck_ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install brainfuck_ruby

## Usage

```rb
hello_world_in_brainfuck = <<~BRAINFUCK
+++++ +++
[
    > ++++
    [
        > ++
        > +++
        > +++
        > +
        <<<< -
    ]
    > +
    > +
    > -
    >> +
    [
        <
    ]
    < -
]
>> .
> --- . +++++ ++ . . +++ .
>> .
< - .
< . +++ . ----- - . ----- --- .
>> + .
> ++ .
BRAINFUCK

BrainfuckRuby::Interpreter.new(hello_world_in_brainfuck).execute!
# Hello World!
# => nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kjleitz/brainfuck_ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
