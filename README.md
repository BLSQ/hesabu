[![Gem](https://img.shields.io/gem/v/hesabu.svg)](https://rubygems.org/gems/hesabu)
[![Maintainability](https://api.codeclimate.com/v1/badges/f2643a76ea031525ed1f/maintainability)](https://codeclimate.com/github/BLSQ/hesabu/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f2643a76ea031525ed1f/test_coverage)](https://codeclimate.com/github/BLSQ/hesabu/test_coverage)
[![Build Status](https://travis-ci.org/BLSQ/hesabu.svg?branch=master)](https://travis-ci.org/BLSQ/hesabu)

# Hesabu

Hesabu : equation solver based on parslet.


## deployment to rubygems.org

one time setup

```
gem install gem-release
curl -u rubygemaccount https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials
chmod 0600 ~/.gem/credentials

```


```
gem bump
gem build hesabu.gemspec
gem push hesabu-x.x.x.gem

```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
