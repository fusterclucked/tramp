$:.unshift File.expand_path 'lib', __dir__

require 'tramp/setup'

require 'bundler/gem_tasks'

task :default => :build

task :test do

	require 'minitest/pride'
	require 'minitest/autorun'
	require './tst/tramp'

end
