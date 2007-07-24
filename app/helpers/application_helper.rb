# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 
# creates image based on famfamfam 
  def icon(icon, options={:class => "icon"})
     image_tag "icons/#{icon}.png", options
  end

# creates flage image.  Used in the forum
  def flag(country, options={})
    image_tag "flags/#{country}.gif", options
  end

# Doesn't work very well - uses session info to create a back link
  def link_to_back
    link_to "Back", session[:prev_page]
  end

# Displays correct flag for user
  def avatar_for(user, size=32)
    options = {}
    if user.admin == 1
      options[:class] = "teacher-avatar" 
    end
    case(user.language)
    when 'en'
      flag("us",options)
    when 'es'
      flag("cr",options)
    end
  end

# Checks current user if they are admin
  def admin?
    if(@current_user)
      @current_user.admin?
    end
  end
  
# Shouldn't be used anymore
  def toggler
    render :update do |page|
      page['help'].toggle
      # page << "if($('toggler').innerHTML == 'help'){"
      # page <<   "$('toggler').innerHTML = ' ';"
      # page << "}else{"
      # page <<   "$('toggler').innerHTML = 'help';"
      # page << "};return false;"
    end
  end 

  
# creates nice spinner icon
  def ajax_spinner_for(id, spinner="spinner.gif")
    "<img src='/images/#{spinner}' style='display:none; vertical-align:middle;' id='#{id.to_s}_spinner'> "
  end

# used in forum.  Copied from Beast  
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
  
    case distance_in_minutes
      when 0..1           then (distance_in_minutes==0) ? 'a few seconds ago' : '1 minute ago'
      when 2..59          then "#{distance_in_minutes} minutes ago"
      when 60..90         then "1 hour ago"
      when 90..1440       then "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      when 1440..2160     then '1 day ago' # 1 day to 1.5 days
      when 2160..2880     then "#{(distance_in_minutes.to_f / 1440.0).round} days ago" # 1.5 days to 2 days
      else from_time.strftime("%b %e, %Y  %l:%M%p").gsub(/([AP]M)/) { |x| x.downcase }
    end
  end
   
end
