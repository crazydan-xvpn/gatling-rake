require_relative 'ShellCommand'

module RakeGatling
	module Commands
		class RemoveDirectoryCommand < ShellCommand
			def execute(directory_name)
				@shell.remove_directory(directory_name)
			end
		end
	end
end