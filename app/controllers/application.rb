# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base 
  include AuthenticatedSystem
  before_filter :set_semester  
  before_filter :login_required, :except => [:login, :signup, :thankyou]

  after_filter :set_page

 # Determines the current semester for the application.  The @semester variable is used everywhere in the app to limit the effects of actions.  Currently this @semester is set using a value in the Settings which is controlled by the 'settings' plugin. Currently this is the only variable controlled by the settings plugin.  
 #
 # Future plans for this method involve having it determine its value by checking the first part of the url.  So, if the url was something like fall06.greenword.net then the semester would be set to the the one with the url value of 'fall06'
 def set_semester  
   @semester
   unless(Settings.current_semester.nil?)
     @semester = Semester.find(Settings.current_semester) 
   else
      @semester =  Semester.find(:first)
   end
   @semester
 end
 
 # Used to set the locale based on the users language preference. This is used in the Globalize plugin system.
 #
 #  See the writeup in the translation method of the admin_controller for details on Globalize 
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
 
 # Used in the forums to determin paginate settings.  Originally written in the Beast app.
 def pages_for(size, options = {})
   default_options = {:per_page => 10}
   options = default_options.merge options
   pages = Paginator.new self, size, options[:per_page], (params[:page]||1)
   return pages
 end
 
 # Also used in the forums.  Written by Beast
 def set_page
   request.session[:prev_page] = request.request_uri
 end
 
# determines if the user is an admin or not. Not sure if this is currently used 
 def admin?
   logged_in? && current_user.admin?
 end
  
  
end