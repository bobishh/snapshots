require 'rake'
require_relative 'db/setup'

task default: %w[setup_db]

task :setup_db do
  DB::Setup.run!
end
