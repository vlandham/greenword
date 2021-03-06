
require 'rubygems'
Gem.manage_gems
gem = Gem.cache.search('ferret').sort_by { |g| g.version }.last
if gem.autorequire
  require gem.autorequire
else
  require_options = ["ferret"]
  unless require_options.find do |path|
      begin
        require path 
      rescue MissingSourceFile 
        nil
      end
    end
    puts msg = "ERROR: Please update #{File.expand_path __FILE__} with the require path for linked RubyGem ferret"
    exit
  end
end

