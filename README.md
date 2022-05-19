# VeracodeApiSigning

![tests](https://github.com/CorbanR/veracode_api_signing/actions/workflows/tests.yml/badge.svg)

Library which uses HMAC to generate signed requests for Veracode API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'veracode_api_signing'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install veracode_api_signing

## Usage

Similarly to the [veracode-api-signing](https://pypi.org/project/veracode-api-signing/) python gem, this gem is meant to help you make
API calls to veracode. [See veracode docs](https://docs.veracode.com/r/t_install_api_authen) for some example usage, as well as this projects `./examples/*` folder.


Documentation can be found at [https://www.raunco.co/veracode_api_signing/](https://www.raunco.co/veracode_api_signing/)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Nix development
If you have [nix](https://nixos.org/download.html) installed, you can run
- `nix-shell`
- `gem install bundler`
- `bundle install`
- `bundle exec rspec`

Optional tools
- [direnv](https://direnv.net/)
- [lorri](https://github.com/target/lorri)

**NOTE:** At some point [nix flakes](https://nixos.wiki/wiki/Flakes) will become stable, and, if you choose to use something like `lorri`, you can just use `nix` with `direnv`!

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/CorbanR/veracode_api_signing](https://github.com/CorbanR/veracode_api_signing)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
