require_relative 'GatlingCommand'
require_relative 'ResultMonitor'

module RakeGatling
	class Gatling 
		include Commands
		def initialize(shell, results_repository)
			@shell = shell
			@run_gatling = GatlingCommand.new(shell)
			@result_monitor = ResultMonitor.new(results_repository)
		end

		def start(parameters)
			@shell.remove_directory(parameters[:results_directory])
			@run_gatling.execute(parameters)
			@shell.move_directory_contents_up(parameters[:results_directory])
			@result_monitor.check_for_failures
		end
	end
end