include Rake::DSL
include RakeGatling

def gatling(*args, &block)
	gatling_wrapper = GatlingWrapper.new(&block)
	task = Proc.new { gatling_wrapper.run }
	Rake::Task.define_task(*args, &task)
end	

class GatlingWrapper
	include IO 

	def initialize(&block)
		@block = block;
		@shell = Shell.new
	end

	def run()			
		configuration = GatlingConfiguration.new
		@block.call(configuration)
		Gatling.new(@shell).start(
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