module AdminHelper
  
  def link_to_gallery
    link_to icon("images"), :controller => :gallery, :action => :index
  end
  
  def link_to_discussion
     link_to icon("comments"), :controller => :discussion, :action => :index
   end
  
end
