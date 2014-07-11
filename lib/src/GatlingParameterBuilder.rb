module RakeGatling
	module Commands
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
	end
end