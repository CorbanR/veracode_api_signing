# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "yard"

YARD::Rake::YardocTask.new

namespace :brakeman do
  desc "Run Brakeman"
  task :run, :output_files do |_t, args|
    require "brakeman"

    files = args[:output_files].split if args[:output_files]
    Brakeman.run app_path: ".", output_files: files, print_report: true, run_all_checks: true, force_scan: true
  end
end

multitask mytasks: %i[spec rubocop yard brakeman:run]

task default: %i[mytasks]
