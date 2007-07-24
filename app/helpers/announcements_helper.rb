module AnnouncementsHelper
# Creates icon that allows displaying / hiding announcement on the student home page  
  def switcher(announcement)
     if !announcement.front_page?
       link_to_remote "show "+icon("accept"), :url => {:controller => "announcements", :action =>"toggle", 
                                      :id => announcement.id}, :html => {:method => "post"} 

     else
       link_to_remote "hide "+icon("cancel"), :url => {:controller => "announcements", :action =>"toggle", 
                                      :id => announcement.id}, :html => {:method => "post"}
       # link_to_remote image_tag("icons/cancel.png"), :action => "hide_"+type, :id => announcement
     end
   end
end
