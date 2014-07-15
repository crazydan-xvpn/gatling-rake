require_relative 'GatlingCommand'

module RakeGatling
	class Gatling 
		include Commands
		def initialize(shell)
			@shell = shell
			@run_gatling = GatlingCommand.new(shell)
		end

		def start(parameters)
			@shell.remove_directory(parameters[:results_directory])
			@run_gatling.execute(parameters)
			@shell.move_directory_contents_up(parameters[:results_directory])
		end
	end
end