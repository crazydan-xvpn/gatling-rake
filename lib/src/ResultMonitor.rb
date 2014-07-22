module RakeGatling
	class ResultMonitor
		ERROR_MESSAGE = "Gatling results contain one or more KOs"

		def initialize(results_repository)
			@results_repository = results_repository
		end

		def check_for_failures
			results = @results_repository.get
			results.keys.each do |record_key|
				record = results[record_key]
				ko = record['ko']
				raise KOsError, ERROR_MESSAGE if !ko.nil? && ko > 0
			end
		end
	end

	class KOsError < StandardError
	end
end