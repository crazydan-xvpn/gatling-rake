module RakeGatling
	class Shell
		def execute(command)
			puts `#{command}`
		end

		def remove_directory(directory_name)
			rm_rf directory_name
		end

		def move_directory_contents_up(location)
			directories = Dir.glob("#{location}/*")
			Dir.glob("#{location}/*/*") {
				|folder_object| mv File.expand_path(folder_object), location
			}
			directories.each do | directory |
				rm_rf File.expand_path(directory)
			end
		end
	end
end