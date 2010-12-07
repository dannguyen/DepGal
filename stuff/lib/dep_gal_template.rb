require 'erb'

class String
  def html_safe
    # to be implemented later
    self
  end
  
  def quote
    # from MYSQL
    self.gsub(/([\0\n\r\032\'\"\\])/) do
      case $1
      when "\0" then "\\0"
      when "\n" then "\\n"
      when "\r" then "\\r"
      when "\032" then "\\Z"
      else "\\"+$1
      end
    end
  end
  
end

module DepGal
  
  
  class Template
    @@TEMPLATE_DIR='template'
    @@ERB_DIR = 'erb'
    
    attr_accessor :template_hash
    
    def initialize(opt={})
      @template_hash = opt
      @template_hash[:css_dir] = 'template/css' if @template_hash[:css_dir].blank?
      @template_hash[:js_dir]  =  'template/js' if @template_hash[:js_dir].blank?
    end
    
    def get_binding
      binding
    end
    
    
    def Template.make_gallery_page(dep_image_hashes, opt={})
      temp = Template.new(opt)
      page = temp.make_erb('head', opt[:head]) 
      thumbs = dep_image_hashes.inject(''){|str, image|
        str << temp.make_erb('thumbnail', image)
      }
      page << temp.make_erb('gallery', {:thumbnails=>thumbs})
      page << temp.make_erb('footer', opt[:footer])
      page
    end
    
    def make_erb(erb_name, temp_vars={})
      file = File.open("#{@@TEMPLATE_DIR}/#{@@ERB_DIR}/#{erb_name}.erb", 'r')
      template = %{#{file.readlines.join("\n")}/}
      rhtml = ERB.new(template)
      rhtml.run(self.get_binding)
    end
    
    
    # copied from ActionPack
    
   
    
    def image_tag(source, options = {})
      options.symbolize_keys!

      src = options[:src] = path_to_image(source)

      unless src =~ /^cid:/
        options[:alt] = options.fetch(:alt){ File.basename(src, '.*').capitalize }
      end

      if size = options.delete(:size)
        options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
      end

      tag("img", options)
    end
    
    def tag(name, options = nil, open = false, escape = true)
      "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}".html_safe
    end
    
    def tag_options(options, escape = true)
      unless options.blank?
        attrs = []
        options.each_pair do |key, value|
          if BOOLEAN_ATTRIBUTES.include?(key)
            attrs << %(#{key}="#{key}") if value
          elsif !value.nil?
            final_value = value.is_a?(Array) ? value.join(" ") : value
            final_value = html_escape(final_value) if escape
            attrs << %(#{key}="#{final_value}")
          end
        end
        " #{attrs.sort * ' '}".html_safe unless attrs.empty?
      end
    end
    

  end
end