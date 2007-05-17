# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required, :except => [:login, :signup, :thankyou]
    after_filter :set_page
  
 def set_semester
   
   @semester
   unless(Settings.current_semester.nil?)
     @semester = Semester.find(Settings.current_semester) 
   else
      @semester =  Semester.find(:first)
   end
   @semester

 end
 
 def set_locale
  if(logged_in?)
    user = @current_user
    locale = user.language
    if(locale == 'es')
      Locale.set("es-CR")
    else
      Locale.set("en-US")
    end
  end
 end
 
 def set_page
   request.session[:prev_page] = request.request_uri
 end
 
 # Need a way to prevent users from retaking questions after they have taken it
 def set_test_position
   
 end
 
 def admin?
   logged_in? && current_user.admin?
 end
  
  
end