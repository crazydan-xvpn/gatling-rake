require_relative './src/Gatling'
require_relative './src/Shell'
require_relative './src/ResultsRepository'
include Rake::DSL

def gatling(*args, &block)
	gatling_wrapper = GatlingWrapper.new(&block)
	task = Proc.new { gatling_wrapper.run }
	Rake::Task.define_task(*args, &task)
end	

class GatlingWrapper
	include RakeGatling

	def initialize(&block)
		@block = block;
		@shell = Shell.new
	end

	def run()			
		configuration = GatlingConfiguration.new
		@block.call(configuration)
		results_repository = ResultsRepository.new(configuration.results_directory)
		Gatling.new(@shell, results_repository).start(
			results_directory: configuration.results_directory,
			gatling_file_location: configuration.gatling_file_location,
			load_test_root: configuration.load_test_root,
			simulation: configuration.simulation,
			simulation_description: configuration.simulation_description
		)
	end
end

class GatlingConfiguration
	attr_accessor 	:results_directory,
					:gatling_file_location,
					:load_test_root,
					:simulation,
					:simulation_description
end