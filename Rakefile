begin
  require 'rspec/core/rake_task'
rescue LoadError
  puts('have you forgotten to run "bundle"?')
  exit(1)
end

# TODO: load version from file
version = '1.5.0'

task default: [:build, :validate, :upload, :release]

desc 'build the VM using packer'
task :build do
  # TODO: make rake refuse to run when the packer version is out of date
  sh 'packer build dev.json'
  FileUtils.mv('skalera-dev.box', "skalera-dev-#{version}.box")
  # FileUtils.mv('skalera-dev.ovf', "skalera-dev-#{version}.ovf")
end

desc 'validate VM functionality'
task :validate do
  box_name = 'skalera/dev-validate'
  ENV['BOX_NAME'] = box_name
  sh 'vagrant box list'
  # TODO: check for skalera/dev-validate
  begin
    sh "vagrant box add --name #{box_name} skalera-dev-#{version}.box"
    begin
      sh 'vagrant up'
      sleep(5) # git it some time to start all docker containers
      sh 'vagrant ssh -c "cd /vagrant && bundle && bundle exec rake rspec"'
    ensure
      sh 'vagrant destroy -f'
    end
  ensure
    sh "vagrant box remove -f #{box_name}"
  end
end

desc 'run rspec validation in VM'
RSpec::Core::RakeTask.new(:rspec) do
  fail 'can only be run in a vagrant box' unless `hostname`.chomp == 'dev'
end

desc 'upload VM to S3'
task :upload do
  sh "s3cmd --acl-public put skalera-dev-#{version}.box s3://skalera/vagrant/skalera-dev-#{version}.box"
end

desc 'release new box version'
task :release do
  # TBW
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new
