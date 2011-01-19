require 'lib/ragmag/dep_gal_helpers.rb'
require 'lib/ragmag/rag_image.rb'

require 'pp'


namespace :seed do	  
    desc "Testing the rake command"
    task(:helloworld) do 
      puts 'hello world'
    end
    
    task(:import_filedata=>:environment) do |t, args|
      puts 'import files'
      is_test = args.testing == 'false' ? false : true
      if is_test
        puts "Just testing"
      else
        puts 'For reals'
      end  
      
      source_dir = File.expand_path(APP_CONFIG['source']['dir'])
      image_filenames = fuf_glob_all_set(source_dir, ['jpg','JPG'])
      
      puts %{\n
        Source files in #{source_dir}
        Images: #{image_filenames.length}\n\n
      }
      
      image_filenames.each do |image_f|
        i = Image.new(:title=>File.basename(image_f), :source_path=>image_f)
        unless is_test
          if i.save
            puts "#{i.id} created:\t #{i.name}\n"
            pp i
          else
            puts "Did not save #{i.name}"
          end
        end
      end
      
    end
end


namespace :seed do
  task(:create_image_files=>:environment) do |t, args|
    do_overwrite = args.overwrite=='true' ? true : true
    is_test = args.testing == 'false' ? false : true
    
    Image.all.each do |image|
#      puts "#{image.id} #{image.name}\n\t#{image.storage_dir}"

      rimg = RagImage.new(image.source_path) if !is_test
      Image.styles.each do |style|
        puts "\t\t#{style}:\t #{image.style_path(style, {:abs=>true})}"
        
        if !is_test
          FileUtils.makedirs(image.style_dir(style, {:abs=>true})) 
          rimg.write_image(image.style_path(style, {:abs=>true}), IMAGE_STYLES[style].symbolize_keys)
        end  
      end
    end
    
  end
end

namespace :unseed do
  task(:clear=>:environment) do |t, args|
    puts "Deleting #{Image.count} files"
   # sql = ActiveRecord::Base.connection()
    Image.destroy_all
  end
end