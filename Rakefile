require 'rspec/core/rake_task'

# load version from file
version = '1.1.1'

task default: [:build, :validate, :upload, :release]

desc 'build the VM using packer'
task :build do
  sh 'packer build dev.json'
  # rename skalera-dev.ovf
  # FileUtils.mv('skalera-dev.box', file)
end

desc 'validate VM functionality'
task :validate do
  box_name = 'skalera/dev-validate'
  ENV['BOX_NAME'] = box_name
  sh 'vagrant box list'
  # TODO: check for skalera/dev-validate
  begin
    sh "vagrant box add --name #{box_name} skalera-dev.box"
    begin
      sh 'vagrant up'
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
  fail 'can only be run in a vagrant box' unless %x[hostname].chomp == 'dev'
end

desc 'upload VM to S3'
task :upload do
  sh "s3cmd --acl-public put #{file} s3://skalera/vagrant/"
end

desc 'release new box version'
task :release do
  # TBW
end
