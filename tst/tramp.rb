# TODO Find some Vagrant voodoo (symlinks as last resort) to allow
#      the vagrant command itself to be run on a tramp provisioning
#        (then the suspend and destroy commands will always return a 0 status)

# TODO Add verification that only the build tools necessary are installed
#        (so rake for Rakefile projects, etc.)

def __(method)
	method.to_s.sub( /^test_\d*_/, '' )
end

def sh(command, captured: false)

	lines = ''

	IO.popen command do |io|
		while line = io.gets
			puts line
			lines << line if captured
		end
	end

	return $?.exitstatus, lines

end

def specify_sh(root, spec)

	command = spec[:when]

	specify "When Command is `#{command}`" do

		puts "\n\e[1;2m#{ __ name } ...\e[0m"

		expected = spec[:expect]
		command = command.sub( /^tramp\b/, "#{root}/bin/tramp" )
		captured = ( not expected.nil? )

		status, output = ( sh command, captured: captured )
		status.must_equal 0
		output.must_equal expected[:output] if captured

	end
end

describe 'tramp' do

	# I'd only suck if I created or restored a VM for every test
	i_suck_and_my_tests_are_order_dependent!

	root = "#{__dir__}/.."

	fixtures = {

		wd: {
			'Empty' =>   nil,
			'Rake'  => { given: '.' },
			'Make'  => { given: 'tst/fxt/make' }
		},

		vm: {
			'Uncreated' =>   nil,
			'Suspended' => { given: 'vagrant suspend' },
			'Running'   =>   nil
		}

	}

	steps = [{
		when:   'tramp'
	}, {
		when:   'tramp install'
	}, {
		when:   'tramp type tramp?',
		expect: { output: "tramp is /usr/local/bin/tramp\r\n" }
	}]

	fixtures[:wd].each do |wd_desc, wd|

		specify "Given WD is #{wd_desc} project" do

			puts "\n\e[1;2;4m#{ __ name }\e[0m"

			# /tmp should be used to ensure their are no parent Vagrantfiles
			temp = Dir.mktmpdir nil, '/tmp'

			if not wd.nil?
				Dir.chdir root
				FileUtils.cp_r ( Dir.glob "#{wd[:given]}/*" ), temp
			end

			Dir.chdir temp

		end

		fixtures[:vm].each do |vm_desc, vm|

			specify "Given VM is #{vm_desc}" do

				puts "\n\e[1;2;4m#{ __ name }\e[0m"

				if not vm.nil?
					status, _ = ( sh vm[:given] )
					status.must_equal 0
				end

			end

			steps.each do |step|
				specify_sh root, step
			end

		end

		specify_sh root, { when: 'vagrant destroy -f' }

	end

end
