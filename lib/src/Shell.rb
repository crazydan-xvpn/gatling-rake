module RakeGatling
	class Shell
		def execute(command)
			puts `#{command}`
		end
	end
end