# Lifespan

[![Build Status](https://travis-ci.org/gendosu/lifespan.svg?branch=master)](https://travis-ci.org/gendosu/lifespan)

This +lifespan+ extension provides filtering of record at the start_at and end_at.<br/>
Automatically adding to default_scope.<br/>
without_lifespan method a good job.<br/>
It is not erased only default_scope itself has added.

## Installation

Add this line to your application's Gemfile:

TODO: It is scheduled to be able to support rubygem install

```ruby
gem 'lifespan'
```
or
```ruby
gem 'lifespan', github: 'gendosu/lifespan'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lifespan

## Usage

```Ruby
class Article < ActiveRecord::Base
  lifespan start_at_column: "start_on"
end
```

How to use:

```shell
Article.all
=> SELECT
    `articles`.*
  FROM
    `articles`
  WHERE
    (`articles`.`start_at` <= '2115-03-31 15:00:00.000072') AND
    (`articles`.`end_at` > '2115-03-31 15:00:00.000072' OR `articles`.`end_at` IS NULL);
```

## Development

TODO

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
