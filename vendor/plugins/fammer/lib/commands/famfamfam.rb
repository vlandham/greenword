require 'open-uri'
require 'fileutils'

name = ARGV.shift
begin
  data = URI.parse("http://www.famfamfam.com/lab/icons/silk/icons/#{name}.png").read 
  FileUtils.mkdir_p "#{RAILS_ROOT}/public/images/icons"
  puts "-- #{name}.png added to public/images/icons/"
  puts "-- Go say thanks to Mark James for his wonderful free icons: http://www.famfamfam.com/about/"

  open("#{RAILS_ROOT}/public/images/icons/#{name}.png", 'w') do |f|
    f.write data
  end
  
rescue
  puts "!! #{name}.png not found."
end
