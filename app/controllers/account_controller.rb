# Controls the logging in, logging out, and signing up processes for students

class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead.
  # If you want "remember me" functionality, add this before_filter to Application Controller.

  before_filter :set_semester
  before_filter :set_locale, :only => [:thankyou]
  before_filter :check_enrollable, :only => [:signup]
  
  
  # Automatically redirects the user to the signup page unless they are already logged in
  def index
    redirect_to(:controller => 'account', :action => 'signup') unless logged_in? || User.count > 0
  end

  # If authorized (meaning they are an admin) then after a sucessful log in they are redirected to the admin index.
  # If the logged in user is admitted then they are redirected to the student index.
  # If neither, but still logged in successfully (meaning the account has been created) then they are sent to the thank you page,
  # as the administrator has not yet admitted them.
  def login
    return unless request.post?
    self.current_user = @semester.users.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token, 
                                 :expires => self.current_user.remember_token_expires_at }
      end
      if authorized?
        # flash[:notice] = "Admin Logged in"
        redirect_to :controller => "admin", :action => "index"
        return
      else
        if admitted?
          # flash[:notice] = "admitted logged in"
          redirect_to :controller => '/student', :action => "index"
          return
        end
      end
      redirect_to(:controller => '/account', :action => 'thankyou')
      # flash[:notice] = ""
      else
       flash[:notice] = "Error in Login or Password"
       redirect_to :controller => "/account", :action => "login"
    end 
  end
  
  # does both the new and create actions to generate a new user.  
  def signup
    @user = User.new(params[:user])
    @user.semester_id = @semester.id
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_to(:controller => '/account', :action => 'thankyou')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  # just plain text so no model interaction is needed.
  def thankyou  
  end
  
  def no_access
  end
  
  # resets the session and deletes the cookie for that user.
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
  
  # this is used as a before_filter to check to see if the admin has turned on enrolment for this semester.
  def check_enrollable
    render :action => :no_access and return unless @semester.enrollable? 
  end
  
  
end
