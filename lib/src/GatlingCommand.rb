require_relative 'GatlingParameterBuilder'

module RakeGatling
	module Commands
		class GatlingCommand
			def initialize(shell)
				@shell = shell
				@parameter_builder = GatlingParameterBuilder.new
			end

			def execute(parameters)
				gatling_parameters = @parameter_builder.buildFrom(parameters)		
				gatling_file_location = parameters[:gatling_file_location]
				@shell.execute("#{gatling_file_location} #{gatling_parameters}")
			end
		end
	end
end