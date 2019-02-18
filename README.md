# OptimisticallyStale

[![Build Status: master](https://travis-ci.com/XPBytes/optimistically_stale.svg)](https://travis-ci.com/XPBytes/optimistically_stale)
[![Gem Version](https://badge.fury.io/rb/optimistically_stale.svg)](https://badge.fury.io/rb/optimistically_stale)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

:small_blue_diamond: micro gem to validate updatability enforcing optimistic locking using `+`lock_version`, before you
hit the Database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'optimistically_stale'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install optimistically_stale

## Usage


```ruby
# @example Check a record before updating
class UpdateBook
  include Command
 
  def call(book:, attributes:)
    book.update(attributes)
  end
  
  def valid?(book:, attributes:)
    valid_for_update?(record: :book, attributes: attributes)
  end
end

# ...

book = Book.first
attributes = { lock_version: book.lock_version, title: 'new book title' }
result = UpdateBook.call(book: book, attributes: attributes)

result.successful? # => true
book.title # => 'new book title'

# @example Because the book version has changed, another update fails
attributes[:title] = 'another title'
result = UpdateBook.call(book: book, attributes: attributes)
# => throws ActiveRecord::StaleObjectError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [XPBytes/optimistically_stale](https://github.com/XPBytes/optimistically_stale).
