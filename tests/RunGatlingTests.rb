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
		gatling_command = commands[1].split(' ')
		gatling_command[0].should eql(gatling_file_location)
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
		@run_gatling.execute(parameters[:gatling_file_location])
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
	def execute(gatling_file_location)
		@shell.execute(gatling_file_location)
	end
end