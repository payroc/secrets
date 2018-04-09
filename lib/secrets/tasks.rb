desc 'Load environment settings from aws sm'
task :secrets do
  require 'secrets'
  Secrets.load
end

task environment: :secrets
