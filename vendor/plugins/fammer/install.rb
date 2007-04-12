require 'fileutils'
FileUtils.cp "#{File.dirname __FILE__}/script/famfamfam", "#{File.dirname __FILE__}/../../../script/famfamfam"
FileUtils.chmod 0755, "#{File.dirname __FILE__}/../../../script/famfamfam"