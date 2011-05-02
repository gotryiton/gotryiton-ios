require 'rubygems'

begin
  gem 'uispecrunner'
  require 'uispecrunner'
  require 'uispecrunner/options'
rescue LoadError => error
  puts "Unable to load UISpecRunner: #{error}"
end

namespace :uispec do
  desc "Run all specs"
  task :all do
    options = UISpecRunner::Options.from_file('uispec.opts') rescue {}
    uispec_runner = UISpecRunner.new(options)
    uispec_runner.run_all!
  end
  
  desc "Run all unit specs (those that implement UISpecUnit)"
  task :units do
    options = UISpecRunner::Options.from_file('uispec.opts') rescue {}
    uispec_runner = UISpecRunner.new(options)
    uispec_runner.run_protocol!('UISpecUnit')
  end
  
  desc "Run all integration specs (those that implement UISpecIntegration)"
  task :integration do
    options = UISpecRunner::Options.from_file('uispec.opts') rescue {}
    uispec_runner = UISpecRunner.new(options)
    uispec_runner.run_protocol!('UISpecIntegration')
  end
end

namespace :features do
  task :build do
    cmd = "xcodebuild -workspace GTIO.xcodeproj/project.xcworkspace -scheme Features -sdk iphonesimulator4.3"
    features_built_path = nil
    status = Open4::popen4(cmd) do |pid, stdin, stdout, stderr|
      stdout.each_line do | line |
        puts line
        result = line.match("touch -c (.*)$")
        features_built_path ||= result[1] if result
      end
    end
    `echo "#{features_built_path}" > features/features_built_path`
    puts "Features Built Path: '#{features_built_path}'"
  end
  
  task :run do
    features_built_path = File.read('features/features_built_path')
    status = Open4::popen4("cucumber") do |pid, stdin, stdout, stderr|
      stdout.each_line do | line |
        puts line
      end
    end
  end
end

desc "Run all specs"
task :default => 'uispec:all'
