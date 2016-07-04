begin

	# Bootstrap implicit dependencies from Vagrant installation
	Dir.foreach( root = '/opt/vagrant/embedded/gems/gems' ) do |name|
		$:.unshift "#{root}/#{name}/lib"
	end

rescue
end
