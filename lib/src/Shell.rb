module RakeGatling
	class Shell
		def execute(command)
			puts `#{command}`
		end

		def remove_directory(directory_name)
			rm_rf directory_name
		end
	end
end