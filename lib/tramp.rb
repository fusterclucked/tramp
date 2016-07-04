include Vagrant::Errors

module Tramp
	class Command < Vagrant.plugin( 2, :command )

		def execute

			OptionParser.new do |cli|
				cli.banner = "Usage: tramp [options] [targets] [-- extra targets] \n\n"
				cli.on '-?', '-h', '--help', 'Print this help.' do
					puts cli.help
					puts "\nTargets:"
					puts '    <name>           builds automation system targets'
					puts '    <commands>?      executes arbitrary shell commands'
					exit
				end
			end .parse!

			begin

				with_target_vms do |vm|

					vm.action :ssh_run,
						ssh_opts: vm.ssh_info,
						ssh_run_command: (
							( @argv.length > 0 and @argv.last.end_with? '?' ) ?
								@argv.tap {
									|argv| argv[-1] = argv[-1].chomp '?'
								} : ( File.file? 'Makefile' ) ? [
									'pushd /vagrant >/dev/null',
									"&& sudo make #{ @argv * ' ' }"
								] : [
									'command -v rake >/dev/null',
									'|| sudo apt-get install -y rake bundler',
									'&& pushd /vagrant >/dev/null',
									"&& sudo rake #{ @argv * ' ' }"
								]
						) * ' '

				end

			rescue VMNotCreatedError, VMNotRunningError

				with_target_vms do |vm|
					vm.action :up
				end

				retry

			end

		end

	end
end
