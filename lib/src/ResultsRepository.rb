require 'json'

module RakeGatling
	class ResultsRepository
		def initialize(results_directory)
			@results_file = "#{results_directory}/js/global_stats.json"
		end

		def get
			JSON.parse( IO.read(@results_file) )
		end
	end
end