require 'dep_gal'
include DepGal

namespace :rdo do	  
  desc "Testing the rake command"
  task(:helloworld) do 
    puts 'hello world'
  end
  
  task :create_project, :source_dir, :project_dir do |t, args|
    project_dir = args.project_dir.nil? ? "ragmag_project" : args.project_dir
    source_dir = args.source_dir.nil? ? "photos" : args.source_dir
    
    puts "Rake: Attempting to reating project using photos in \"#{source_dir}\". Project will be in \"#{project_dir}\""
    DepGal::create_project(source_dir, project_dir)
    
  end
end



