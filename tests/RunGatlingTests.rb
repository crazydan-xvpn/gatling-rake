require 'test/unit'
require 'rspec-expectations'
require_relative '../lib/src/Gatling'

class RunGatlingTests < Test::Unit::TestCase	
	include RakeGatling
	private 
	attr_reader :commands, :directory_removed, :moved_location

	public 
	def test_that_previous_results_directory_is_removed
		@directory_removed = nil
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(results_directory: results_directory)
		@directory_removed.should eql(results_directory)
	end

	def test_that_gatling_is_run_from_correct_location
		@commands = []
		gatling_file_location = "aPlace/#{rand(4)}/gatling.bat"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(gatling_file_location: gatling_file_location)
		gatling_command = commands[0]
		gatling_command.should match(/^#{gatling_file_location}/)
	end

	def test_that_gatling_is_run_with_request_bodies_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(load_test_root: load_test_root)
		gatling_command = commands[0]
		gatling_command.should match(/ -bf #{load_test_root}\/request-bodies/)
	end

	def test_that_gatling_is_run_with_simulations_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(load_test_root: load_test_root)
		gatling_command = commands[0]
		gatling_command.should match(/ -sf #{load_test_root}\/simulations/)
	end

	def test_that_gatling_is_run_with_data_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(load_test_root: load_test_root)
		gatling_command = commands[0]
		gatling_command.should match(/ -df #{load_test_root}\/data/)
	end

	def test_that_gatling_is_run_with_results_folder_specified
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(results_directory: results_directory)
		gatling_command = commands[0]
		gatling_command.should match(/ -rf #{results_directory}/)
	end

	def test_that_gatling_is_run_with_against_the_correct_simulation
		@commands = []
		simulation = "ARandom.#{rand(6)}.simulation"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(simulation: simulation)
		gatling_command = commands[0]
		gatling_command.should match(/ -s #{simulation}/)
	end

	def test_that_results_directory_is_moved_up_to_results_root
		@moved_location = nil
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell, FakeResultsRepository.new).start(results_directory: results_directory)
		@moved_location.should eql(results_directory)
	end

	def test_that_when_results_contain_kos_then_error_is_thrown
		@commands = []
		mockShell = self
		error_results = {
			"name" => "Global Information",
			"numberOfRequests" => {"total"=>50, "ok"=>49, "ko"=>1},
			"minResponseTime" => {"total"=>56,"ok"=>56, "ko"=>0}
		}
		results_repository = FakeResultsRepository.new
		results_repository.set(error_results)
		gatling = Gatling.new(mockShell, results_repository)
		expect{gatling.start(results_directory: "aDir")}.to raise_error("Gatling results contain one or more KOs")
	end

	def test_that_when_results_do_not_contain_kos_then_error_is_not_thrown
		@commands = []
		mockShell = self
		error_results = {
			"name" => "Global Information",
			"numberOfRequests" => {"total"=>50, "ok"=>50, "ko"=>0},
			"minResponseTime" => {"total"=>56,"ok"=>56, "ko"=>0}
		}
		results_repository = FakeResultsRepository.new
		results_repository.set(error_results)
		gatling = Gatling.new(mockShell, results_repository)
		expect{gatling.start(results_directory: "aDir")}.to_not raise_error
	end

	def test_that_when_results_contain_minRepsonseTime_kos_then_error_is_thrown
		@commands = []
		mockShell = self
		error_results = {
			"name" => "Global Information",
			"numberOfRequests" => {"total"=>50, "ok"=>50, "ko"=>0},
			"minResponseTime" => {"total"=>56,"ok"=>55, "ko"=>1}
		}
		results_repository = FakeResultsRepository.new
		results_repository.set(error_results)
		gatling = Gatling.new(mockShell, results_repository)
		expect{gatling.start(results_directory: "aDir")}.to raise_error("Gatling results contain one or more KOs")
	end

	def execute(command)
		@commands.push(command)
	end

	def remove_directory(directory_name)
		@directory_removed = directory_name
	end

	def move_directory_contents_up(location)
		@moved_location = location
	end
end

class FakeResultsRepository
	def initialize 
		@results = Hash.new
	end

	def get
		@results
	end

	def set(results)
		@results = results
	end
end


