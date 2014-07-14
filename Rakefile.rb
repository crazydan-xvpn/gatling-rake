require_relative './lib/GatlingRake'

task :default => [:dependencies, :test, :commit]

desc 'Load dependencies with bundler'
task :dependencies do
	system "bundle update"
end

desc 'Run unit tests'
task :test do
	require 'peach'
	TEST_FILE_PATTERN = 'tests/**/*.rb'
	Dir[TEST_FILE_PATTERN].peach do | test_file_name |
		puts ">> Running tests on: #{test_file_name}"
		sh "bundle exec ruby #{test_file_name}"
	end
end

puts Dir.pwd

desc 'Integration test.. requires gatling installed in ../../gatling'
gatling :integration do | config |
	config.results_directory = "#{Dir.pwd}/results"
	config.gatling_file_location = '../../gatling/bin/gatling.sh'
	config.load_test_root = './test-load-tests'
	config.simulation = 'Test.GetGoogleSimulation'
	config.simulation_description = 'simulation'
end

desc 'Committing and Pushing to Git :)'
task :commit do	
	require 'git_repository'
	commit_message = ENV["m"] || 'refactoring'	
	git = GitRepository.new
	git.add
	git.commit(:message => commit_message,:options => "-a")
	git.push	
end

task :gem_publish do 
	`rm *.gem`
	`gem build gatling-rake.gemspec`
	gem_files = FileList.new('*.gem')
	result = `gem push #{gem_files[0]}`
	puts result
end
