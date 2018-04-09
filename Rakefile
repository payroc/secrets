#!/usr/bin/env rake

require "bundler/gem_helper"

namespace "secrets" do
  Bundler::GemHelper.install_tasks name: "secrets"
end

namespace "secrets-rails" do
  class SecretsRailsGemHelper < Bundler::GemHelper
    def guard_already_tagged; end # noop

    def tag_version; end # noop
  end

  SecretsRailsGemHelper.install_tasks name: "secrets-rails"
end

task build: ["secrets:build", "secrets-rails:build"]
task install: ["secrets:install", "secrets-rails:install"]
task release: ["secrets:release", "secrets-rails:release"]

require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--color)
  t.verbose = false
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

task default: [:spec, :rubocop]
