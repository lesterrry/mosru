# Mosru
With mosru authorizing at [mos.ru](https://mos.ru) website & retrieving cookies is as simple as that:

```ruby
cookies = Mosru::Auth::perform("my_login", "my_password")
```

## Installation
1. [Authenticate](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry#authenticating-to-github-packages) to GitHub Packages

2. Add these lines to your application's Gemfile:
```ruby
source "https://rubygems.pkg.github.com/lesterrry" do
  gem "mosru"
end
```

And then execute:

    $ bundle install

## Usage
See `examples` folder for usage examples.

## Development
After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Important notes
Please note that library is in beta and may stop working at any time.\
This software is a proof of concept.

## Uptime 
|   Date   |   Status   |
|   ----   |    ----    |
| 01.06.22 | Functional |