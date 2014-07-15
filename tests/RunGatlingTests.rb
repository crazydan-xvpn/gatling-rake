require 'test/unit'
require 'rspec-expectations'
require_relative '../lib/src/Gatling'

class RunGatlingTests < Test::Unit::TestCase	
	include RakeGatling
	private 
	attr_reader :commands, :directory_removed

	public 
	def test_that_previous_results_directory_is_removed
		@directory_removed = nil
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell).start(results_directory: results_directory)
		@directory_removed.should eql(results_directory)
	end

	def test_that_gatling_is_run_from_correct_location
		@commands = []
		gatling_file_location = "aPlace/#{rand(4)}/gatling.bat"
		mockShell = self
		Gatling.new(mockShell).start(gatling_file_location: gatling_file_location)
		gatling_command = commands[0]
		gatling_command.should match(/^#{gatling_file_location}/)
	end

	def test_that_gatling_is_run_with_request_bodies_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell).start(load_test_root: load_test_root)
		gatling_command = commands[0]
		gatling_command.should match(/ -bf #{load_test_root}\/request-bodies/)
	end

	def test_that_gatling_is_run_with_simulations_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell).start(load_test_root: load_test_root)
		gatling_command = commands[0]
		gatling_command.should match(/ -sf #{load_test_root}\/simulations/)
	end

	def test_that_gatling_is_run_with_data_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell).start(load_test_root: load_test_root)
		gatling_command = commands[0]
		gatling_command.should match(/ -df #{load_test_root}\/data/)
	end

	def test_that_gatling_is_run_with_results_folder_specified
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell).start(results_directory: results_directory)
		gatling_command = commands[0]
		gatling_command.should match(/ -rf #{results_directory}/)
	end

	def test_that_gatling_is_run_with_against_the_correct_simulation
		@commands = []
		simulation = "ARandom.#{rand(6)}.simulation"
		mockShell = self
		Gatling.new(mockShell).start(simulation: simulation)
		gatling_command = commands[0]
		gatling_command.should match(/ -s #{simulation}/)
	end

	def test_that_gatling_is_run_with_with_simulation_description
		@commands = []
		simulation_description = "#{rand(6)}simulation"
		mockShell = self
		Gatling.new(mockShell).start(simulation_description: simulation_description)
		gatling_command = commands[0]
		gatling_command.should match(/ -sd "#{simulation_description}"/)
	end

	def execute(command)
		@commands.push(command)
	end

	def remove_directory(directory_name)
		@directory_removed = directory_name
	end
end

