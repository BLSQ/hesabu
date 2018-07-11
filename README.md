[![Gem](https://img.shields.io/gem/v/hesabu.svg)](https://rubygems.org/gems/hesabu)
[![Maintainability](https://api.codeclimate.com/v1/badges/f2643a76ea031525ed1f/maintainability)](https://codeclimate.com/github/BLSQ/hesabu/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f2643a76ea031525ed1f/test_coverage)](https://codeclimate.com/github/BLSQ/hesabu/test_coverage)
[![Build Status](https://travis-ci.org/BLSQ/hesabu.svg?branch=master)](https://travis-ci.org/BLSQ/hesabu)

# Hesabu

Hesabu : equations solver relies on https://github.com/BLSQ/go-hesabu to solve equations

Hesabu is swahili word for arithmetic.


## sample usage
```ruby
    solver = Hesabu::Solver.new
    solver.add("c", "a + b")
    solver.add("a", "10")
    solver.add("b", "10 + a")

    solution = solver.solve!

    expect(solution).to eq("a" => 10, "b" => 20, "c" => 30)
```

The solver will deduce the correct order and find the values of a,b and c.

The expressions can be more complex (excel like), see the supported functions [here](https://github.com/BLSQ/hesabu/blob/master/spec/lib/hesabu/various_expressions_spec.rb#L12)

When parsing or solving, things can go wrong, here are various [cases](https://github.com/BLSQ/hesabu/blob/master/spec/lib/hesabu/errors_spec.rb)

Currently the solver : 
 - is case sensitive.
 - and fast (32000 equations in 3 seconds)

## Alternatives

* https://github.com/rubysolo/dentaku more complete, currently less performant.

# Development

## Running the tests

```
# only the fast
bundle exec rspec --tag ~slow
# all with integration test, expect around 30-40 seconds depending on your machine
bundle exec rspec
```

## deployment to rubygems.org

one time setup

```
gem install gem-release
curl -u rubygemaccount https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials
chmod 0600 ~/.gem/credentials

```


```
gem bump --tag --release
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
