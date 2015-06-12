gatling-rake
============

rake task for running gatling scenarios

##Installation

```
  gem install gatling-rake
```

...or include gatling-rake into your bundler Gemfile.

##Usage

```ruby
require 'GatlingRake'

gatling :load_tests do | config |
	config.results_directory = "#{Dir.pwd}/results"
	config.gatling_file_location = '../../gatling/bin/gatling.sh'
	config.load_test_root = './test-load-tests'
	config.simulation = 'Test.GetGoogleSimulation'
end
```
