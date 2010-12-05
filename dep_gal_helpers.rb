require 'fileutils'

class Object  
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end


class Logger
  class Formatter
    def call(severity, time, progname, msg)
     "#{severity}\t#{format_datetime(time)}\tfoo: #{caller[-4]}\t# #{msg}\n"
    end
  end
end

class Hash
  def dig(*path)
    path.inject(self) do |location, key|
      location.respond_to?(:keys) ? location[key] : nil
    end
  end
end


def fuf_find_uniq_filename(str)
  
   if File.exists?str
      str_p = str.split('.', 2)
      count = 1
      while File.exists?(str_p.join('.'))
        str_p[0] = "#{str_p[0]}_#{(count)}"
        count +=1
      end
      str = str_p.join('.')
    end
    str
end

def fuf_maked_dirs(dirstrs)
  # creates the directories, or an incremented number of it if it exists
  return false unless dirstrs.is_a?(String) || dirstrs.is_a?(Array)
  dirstrs=[dirstrs].flatten  
  dirstrs.each do |str|
    FileUtils.makedirs(str)    
  end  
  return dirstrs
end

def fuf_glob_all_set(dir, set)
  Dir.glob("#{dir}/**/*.{#{set.join(',')}}")
end

def fuf_glob_all_dirs(dir)
  Dir.glob('#{dir}/**/')
end

