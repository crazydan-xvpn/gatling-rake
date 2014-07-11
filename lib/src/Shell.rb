module RakeGatling
	module IO 
		class Shell
			def execute(command)
				puts `#{command}`
			end
		end
	end
end