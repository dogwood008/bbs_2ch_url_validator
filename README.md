# Bbs2chUrlValidator

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/bbs_2ch_url_validator`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bbs_2ch_url_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bbs_2ch_url_validator

## Usage

```ruby
b = Bbs2chUrlValidator::URL.parse('http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/')
# => #<Bbs2chUrlValidator::UrlInfo:0x007f7a0901c950 @server_name="viper", @is_open=false, @tld="sc", @board_name="news4vip", @thread_key="9990000001", @is_dat=false, @is_subject=false, @is_setting=false, @built_url="http://viper.2ch.sc/test/read.cgi/news4vip/9990000001/">
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dogwood008/bbs_2ch_url_validator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## History

- v0.1.5 Ignore res number(s) on URL  (e.g.) http://toro.open2ch.net/test/read.cgi/tech/1371956681/l50
- v0.1.4 Fix bugs of these: #dat?, #subject?, #setting?, #open? and override UrlInfo#to_s
- v0.1.3 Add Bbs2chUrlValidator::URL#subject, #dat, #setting, #dat?, #subject?, #setting?, #open?
- v0.1.2 Put #build_url into instance variable 'built_url'
- v0.1.1 Add UrlInfo#build_url
- v0.1.0 first release
