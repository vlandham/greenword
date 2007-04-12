class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # If you want "remember me" functionality, add this before_filter to Application Controller
  # before_filter :login_from_cookie
  before_filter :set_semester
  before_filter :set_locale, :only => [:thankyou]
  
  

  def index
    redirect_to(:controller => 'account', :action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token, 
                                 :expires => self.current_user.remember_token_expires_at }
      end
      if authorized?
        flash[:notice] = "Admin Logged in"
        redirect_to :controller => "admin", :action => "index"
        return
      else
        if admitted?
          flash[:notice] = "admitted logged in"
          redirect_to :controller => '/student', :action => "index"
          return
        end
      end
      redirect_to(:controller => '/account', :action => 'thankyou')
      flash[:notice] = ""
      else
       flash[:notice] = "Error in Login or Password"
       redirect_to :controller => "/account", :action => "login"
    end 
  end

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
  
  def thankyou  
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
  
  
  
end
