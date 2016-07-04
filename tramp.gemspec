Gem::Specification.new do |spec|

	spec.name        = 'tramp'
	spec.version     = '0.0.0'
	spec.license     = 'MIT'

	spec.summary     = 'Automation infrastruture automated'
	spec.description = 'Standardized development workflows using the best of Vagrant, Make, and Rake'

	spec.authors     = [ 'Ken Merthe' ]
	spec.homepage    = 'http://tramp.io'

	spec.executables = [ 'tramp' ]
	spec.files       = [ 'Gemfile', 'tramp.gemspec', 'Vagrantfile' ]
	spec.files      += ( Dir.glob 'lib/**/*' ).select { |f| File.file? f }

end
