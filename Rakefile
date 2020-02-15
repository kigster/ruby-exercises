# frozen_string_literal: true

# vim: ft=ruby
require 'rake'
require 'colored2'

namespace :solutions do
  desc 'Run RSpecs for all solutions'
  task :specs do
    code = 0
    STDOUT.sync = true
    Dir.glob('[a-z]*').each do |entry|
      next unless File.directory?(entry)
      next if File.exist?("#{entry}/.skip")

      puts "———————————————————————————————————————————————————".cyan
      puts "Testing Solution: #{entry.to_s.bold.green}"

      Dir.chdir(entry) do
        begin
          system '( bundle check || bundle install ) && bundle exec rspec'
          code += ($? == 0) ? 0 : 1
        rescue StandardError => e
          code += 1
          STDERR.puts "Error running #{entry.to_s.red}: #{e.inspect.red.bold}"
        end
      end
    end

    puts "———————————————————————————————————————————————————".yellow
    puts "  Total of #{code} errors.".bold.blue
    puts "———————————————————————————————————————————————————".yellow
  end
end

task default: 'solutions:specs'
