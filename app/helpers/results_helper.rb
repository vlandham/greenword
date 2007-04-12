module ResultsHelper
  
  def switcher(word, type)
    if !word.visible?
      link_to_remote icon("accept"), :url => {:controller => "results", :action =>"toggle_"+type, 
                                     :id => word.id}, :html => {:method => "post"} 
      
    else
      link_to_remote icon("cancel"), :url => {:controller => "results", :action =>"toggle_"+type, 
                                     :id => word.id}, :html => {:method => "post"}
      # link_to_remote image_tag("icons/cancel.png"), :action => "hide_"+type, :id => word
    end
  end
  
end
