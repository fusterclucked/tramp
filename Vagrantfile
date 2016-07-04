Vagrant.configure(2) do |config|

	vm = config.vm

	vm.box = 'boxcutter/debian82'

	# workaround for 'stdin: is not a tty' message
	#   original issue (with many suggestions):
	#     https://github.com/mitchellh/vagrant/issues/1673
	#   best workaround:
	#     https://github.com/Mirantis/solar/pull/418#issuecomment-163175966
	vm.provision :shell, privileged: false, inline: %{
		sudo sed -i 's/^mesg n$/tty -s \\&\\& \\0/' /root/.profile
	}

	vm.provision :shell, inline: 'apt-get update'

end
