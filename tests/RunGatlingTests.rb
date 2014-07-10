require 'test/unit'
require 'rspec-expectations'

class RunGatlingTests < Test::Unit::TestCase	
	private 
	attr_reader :commands

	public 
	def test_that_previous_results_directory_is_removed
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell).start(results_directory: results_directory)
		commands[0].should eql("rmdir /s /q #{results_directory}")
	end

	def test_that_gatling_is_run_from_correct_location
		@commands = []
		gatling_file_location = "aPlace/#{rand(4)}/gatling.bat"
		mockShell = self
		Gatling.new(mockShell).start(gatling_file_location: gatling_file_location)
		gatling_command = commands[1]
		gatling_command.should match(/^#{gatling_file_location}/)
	end

	def test_that_gatling_is_run_with_request_bodies_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell).start(load_test_root: load_test_root)
		gatling_command = commands[1]
		gatling_command.should match(/ -bf #{load_test_root}\/request-bodies/)
	end

	def test_that_gatling_is_run_with_simulations_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell).start(load_test_root: load_test_root)
		gatling_command = commands[1]
		gatling_command.should match(/ -sf #{load_test_root}\/simulations/)
	end

	def test_that_gatling_is_run_with_data_folder_specified
		@commands = []
		load_test_root = "aPlace/#{rand(4)}/"
		mockShell = self
		Gatling.new(mockShell).start(load_test_root: load_test_root)
		gatling_command = commands[1]
		gatling_command.should match(/ -df #{load_test_root}\/data/)
	end

	def test_that_gatling_is_run_with_results_folder_specified
		@commands = []
		results_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell).start(results_directory: results_directory)
		gatling_command = commands[1]
		gatling_command.should match(/ -rf #{results_directory}/)
	end

	def test_that_gatling_is_run_with_against_the_correct_simulation
		@commands = []
		simulation = "ARandom.#{rand(6)}.simulation"
		mockShell = self
		Gatling.new(mockShell).start(simulation: simulation)
		gatling_command = commands[1]
		gatling_command.should match(/ -s #{simulation}/)
	end

	def test_that_gatling_is_run_with_with_simulation_description
		@commands = []
		simulation_description = "#{rand(6)}simulation"
		mockShell = self
		Gatling.new(mockShell).start(simulation_description: simulation_description)
		gatling_command = commands[1]
		gatling_command.should match(/ -sd "#{simulation_description}"/)
	end

	def execute(command)
		@commands.push(command)
	end
end

class Gatling 
	def initialize(shell)
		@shell = shell
		@remove_directory = RemoveDirectoryCommand.new(shell)
		@run_gatling = GatlingCommand.new(shell)
	end

	def start(parameters)
		@remove_directory.execute(parameters[:results_directory])
		@run_gatling.execute(parameters)
	end
end

class ShellCommand
	def initialize(shell)
		@shell = shell
	end
end

class RemoveDirectoryCommand < ShellCommand
	def execute(directory_name)
		@shell.execute("rmdir /s /q #{directory_name}")
	end
end

class GatlingCommand < ShellCommand
	def initialize(shell)
		super
		@parameter_builder = GatlingParameterBuilder.new
	end

	def execute(parameters)
		gatling_parameters = @parameter_builder.buildFrom(parameters)		
		gatling_file_location = parameters[:gatling_file_location]
		@shell.execute("#{gatling_file_location} #{gatling_parameters}")
	end
end

class GatlingParameterBuilder
	def buildFrom(parameters)
		load_test_root = parameters[:load_test_root]
		gatling_parameters = {
			'-bf' => "#{load_test_root}/request-bodies",
			'-sf' => "#{load_test_root}/simulations",
			'-df' => "#{load_test_root}/data",
			'-rf' => parameters[:results_directory],
			'-s' => parameters[:simulation],
			'-sd' => "\"#{parameters[:simulation_description]}\""
		}
		gatling_parameter_string = gatling_parameters.map{ 
			| key , value |	"#{key} #{value}"}.join(' ')
	end
end