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

	def execute(command)
		@commands.push(command)
	end
end

class Gatling 
	def initialize(shell)
		@remove_directory = RemoveDirectoryCommand.new(shell)
	end

	def start(parameters)
		@remove_directory.execute(parameters[:result_directory])
	end
end

class RemoveDirectoryCommand
	def initialize(shell)
		@shell = shell
	end

	def execute(directory_name)
		@shell.execute("rmdir /s /q #{directory_name}")
	end
end