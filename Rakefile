# frozen_string_literal: true

require "rake"
require "rake/testtask"
require "rake/clean"

task default: "test"

Rake::TestTask.new("test") do |t|
  t.warning = true
  t.verbose = true
  t.test_files = FileList["test/**/test_*.rb"]
end
