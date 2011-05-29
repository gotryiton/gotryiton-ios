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
  desc "build features scheme"
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
  
  desc "run features"
  task :run do
    features_built_path = File.read('features/features_built_path')
    status = Open4::popen4("cucumber") do |pid, stdin, stdout, stderr|
      stdout.each_line do | line |
        puts line
      end
    end
  end
end

desc "Run features"
task :features => ['features:build', 'features:run']

desc "Run all specs"
task :specs => ['uispec:all']

desc "Run all specs and features"
task :default => ['uispec:all', 'features']

desc "Generate documentation via appledoc"
task :docs => 'docs:generate'

# Documentation

def apple_doc_command
  "Libraries/appledoc/appledoc -t Libraries/appledoc/Templates -o Docs -p GTIO -c \"Two Toasters\" --company-id org.GTIO --warn-undocumented-object " +
  "--warn-undocumented-member  --warn-empty-description  --warn-unknown-directive --warn-invalid-crossref --warn-missing-arg --no-repeat-first-par "
end

def run(command)
  puts "Executing: `#{command}`"
  system(command)
  if $? != 0
    puts "[!] Failed with exit code #{$?} while running: `#{command}`"
    exit($?)
  end
end

namespace :docs do
  task :generate do
    command = apple_doc_command << " --no-create-docset --keep-intermediate-files --create-html Code/"
    run(command)
    puts "Generated HTML documentationa at Docs/API/html"
  end
  
  desc "Check that documentation can be built from the source code via appledoc successfully."
  task :check do
    command = apple_doc_command << " --no-create-html Code/"
    run(command)
    if $? != 0
      puts "Documentation failed to generate with exit code #{$?}"
      exit($?)
    else
      puts "Documentation processing with appledoc was successful."
    end
  end
  
  desc "Generate & install a docset into Xcode from the current sources"
  task :install do
    command = apple_doc_command << " --install-docset Code/"
    run(command)
  end
  
  desc "Build and upload the documentation set to the remote server"
  task :upload do
    version = ENV['VERSION'] || File.read("VERSION").chomp
    puts "Generating RestKit docset for version #{version}..."
    command = apple_doc_command <<
            " --keep-intermediate-files" <<
            " --docset-feed-name \"RestKit #{version} Documentation\"" <<
            " --docset-feed-url http://restkit.org/api/%DOCSETATOMFILENAME" <<
            " --docset-package-url http://restkit.org/api/%DOCSETPACKAGEFILENAME --publish-docset Code/"
    run(command)
    if $? == 0
      puts "Uploading docset to restkit.org..."
      command = "rsync -rvpPe ssh --delete Docs/API/html/ restkit.org:/var/www/public/restkit.org/public/api/#{version}"
      run(command)
      
      if $? == 0
        command = "rsync -rvpPe ssh Docs/API/publish/ restkit.org:/var/www/public/restkit.org/public/api/"
        run(command)
      end
    end
  end
end


