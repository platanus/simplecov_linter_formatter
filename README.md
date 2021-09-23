# SimpleCov Linter Formatter

[![Gem Version](https://badge.fury.io/rb/simplecov_linter_formatter.svg)](https://badge.fury.io/rb/simplecov_linter_formatter)
[![CircleCI](https://circleci.com/gh/platanus/simplecov_linter_formatter.svg?style=shield)](https://app.circleci.com/pipelines/github/platanus/simplecov_linter_formatter)

Linter formatter for SimpleCov code coverage tool

## Installation

```bash
$ gem install simplecov_linter_formatter
```

Or add to your Gemfile:

```ruby
gem "simplecov_linter_formatter"
```

```bash
bundle install
```

## Usage

TODO

## Testing

To run the specs you need to execute, **in the root path of the gem**, the following command:

```bash
bundle exec guard
```

You need to put **all your tests** in the `/my_gem/spec/` directory.

## Publishing

On master/main branch...

1. Change `VERSION` in `lib/simplecov_linter_formatter/version.rb`.
2. Change `Unreleased` title to current version in `CHANGELOG.md`.
3. Run `bundle install`.
4. Commit new release. For example: `Releasing v0.1.0`.
5. Create tag. For example: `git tag v0.1.0`.
6. Push tag. For example: `git push origin v0.1.0`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/simplecov_linter_formatter/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

SimpleCov Linter Formatter is maintained by [platanus](http://platan.us).

## License

SimpleCov Linter Formatter is © 2021 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
