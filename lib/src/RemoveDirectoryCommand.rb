require_relative 'ShellCommand'

module RakeGatling
	module Commands
		class RemoveDirectoryCommand < ShellCommand
			def execute(directory_name)
				@shell.execute("rmdir /s /q #{directory_name}")
			end
		end
	end
end