# encoding: utf-8
# copyright: 2018, The Authors

title 'PostgreSQL Installation Verification'

POSTGRES_DATA = attribute(
  'postgres_data',
  description: 'define the postgresql data directory',
  default: '/var/opt/rh/rh-postgresql96/lib/pgsql'
)

USER = attribute(
  'user',
  description: 'define the postgresql user to access the database',
  default: 'postgres'
)

control 'Temporal Tables extension' do                        
  impact 0.7                               
  title 'Temporal Tables extension'        
  desc 'Temporal Tables extension'
  describe file('/opt/rh/rh-postgresql96/root/usr/share/pgsql/extension/temporal_tables.control') do
    it { should exist  }
  end
end

control 'IsPostgres Running' do
  impact 1.0
  title 'Postgresql should be running'
  desc 'Postgresql should be running.'
  case os[:name]
  when 'redhat', 'centos'
    case os[:release]
    when /6\./
      describe command('/etc/rc.d/init.d/rh-postgresql96-postgresql status') do
        its('stdout') { should include 'running' }
      end
    when /7\./
      describe command('ps aux | awk /\'bin\/postgres\'/ | wc -l') do
        its('stdout') { should include '1' }
       end
    end
  end
end

control 'Postgres Version' do
  impact 1.0
  title 'Checking PostgreSQL version'
  desc 'Checking PostgreSQL version'
  describe command('psql -V') do
    its('stdout') { should match(/^psql\s\(PostgreSQL\)\s9.6*/) }
  end
end

control 'PostgreSQL database account' do
  impact 1.0
  title 'The PostgreSQL "data_directory" should be assigned exclusively to the database account (such as "postgres").'
  desc 'If file permissions on data are not property defined, other users may read, modify or delete those files.'
  find_command = 'find ' + POSTGRES_DATA.to_s + ' -user ' + USER + ' -group ' + USER + ' -perm /go=rwx'
  describe command(find_command) do
    its('stdout') { should eq '' }
  end
end
