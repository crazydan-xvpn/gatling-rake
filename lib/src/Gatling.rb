require_relative 'GatlingCommand'
require_relative 'RemoveDirectoryCommand'

module RakeGatling
	class Gatling 
		include Commands
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
end