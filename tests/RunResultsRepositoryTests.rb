require 'test/unit'
require 'rspec-expectations'
require 'json'
require_relative '../lib/src/ResultsRepository'

class RunGatlingTests < Test::Unit::TestCase	
	include RakeGatling
	RESULTS_DIRECTORY = "#{File.dirname(__FILE__)}/data"
	FILE_NAME = "#{RESULTS_DIRECTORY}/js/global_stats.json"
	
	def test_that_it_returns_the_stats_from_the_specified_result_file
		expected_results = JSON.parse( IO.read(FILE_NAME) )
		results = ResultsRepository.new(RESULTS_DIRECTORY).get()
		results.should eql(expected_results)
	end
end