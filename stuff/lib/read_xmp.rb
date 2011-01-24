require 'rubygems'
require 'nokogiri'
class XMPFile
  
  MIN_CHUNK = 30000
  XMP_CLOSETAG= '</xpacket>'
  
  attr_accessor :file_name, :content, :attributes, :xml
  
  def initialize(filename)
    @file_name = filename
    sample = File.open(filename, 'rb').read(MIN_CHUNK)
    s0 = sample.index(/\<\?xpacket.*?\>/)
    m1 = sample.match(/\<\?xpacket end.*?\>/)
    s1 = sample.index(m1[0]) if m1
    if s0 && s1
      @content = sample[s0..s1+XMP_CLOSETAG.length]
      @attributes = @content.to_s.scan(/(\w+)\="(.+?)"/).uniq.inject({}){|hash, val|
        hash[val[0]] = val[1]
        hash
      }
    end
    
    @xml = Nokogiri::XML(@content)
  end
  
  def attr(str) 
    #accepts symbols and underscored attributes
  #  str.to_s.gsub(/_([a-z])/, "#{"#{'\1'}"}")
    @attributes[str.to_s.gsub(/(\b|_)([a-z])/){$2.upcase}]
  end
  
  #convenince methods
  def date_created
    Date.parse(@attributes['DateCreated'])
  end
  
  def keywords
    @xml.elements.xpath("//rdf:Bag/rdf:li", {'rdf'=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#"}).to_a.inject([]){|arr, txt| arr << txt.text.split('|')}.flatten.uniq
  end
  
  def rating
    @attributes['Rating'].to_f
  end
  
  
  def temperature
    @attributes['Temperature'].to_f
  end
end
