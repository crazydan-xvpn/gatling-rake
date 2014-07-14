module RakeGatling
	class Shell
		def execute(command)
			puts command
			puts `#{command}`
		end
	end
end