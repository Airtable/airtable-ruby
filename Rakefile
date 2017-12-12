require 'bundler'
Bundler.setup
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc 'Run all tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = %w[-w]
end

desc 'Run RuboCop on the lib directory'
task :rubocop do
  sh 'bundle exec rubocop lib'
end

task default: %i[spec rubocop]
