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
				|f| mv File.expand_path(f), location
			}
			directories.each do | f |
				rm_rf File.expand_path(f)
			end
		end
	end
end