require 'test/unit'
require 'rspec-expectations'

class RunGatlingTests < Test::Unit::TestCase	
	private 
	attr_reader :commands

	public 
	def test_that_previous_result_directory_is_removed
		@commands = []
		result_directory = "Random/#{rand(6)}"
		mockShell = self
		Gatling.new(mockShell).start(result_directory: result_directory)
		commands[0].should eql("rmdir /s /q #{result_directory}")
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
		gatling_command.should match(/-bf #{load_test_root}\/request-bodies/)
	end

# %GATLING_DIR%\\gatling.bat -bf load-tests\request-bodies -sf load-tests\simulations -df load-tests\data -rf %teamcity.build.checkoutDir%\load-testing-results -s FlavaIt.FlavaItSimulation -sd "Flava-It load tests"
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
		@remove_directory.execute(parameters[:result_directory])
		@run_gatling.execute(
			gatling_file_location: parameters[:gatling_file_location],
			load_test_root: parameters[:load_test_root]
		)
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
			'-bf' => "#{load_test_root}/request-bodies"
		}
		gatling_parameter_string = gatling_parameters.map{ 
			| key , value |	"#{key} #{value}"}.join
	end
end