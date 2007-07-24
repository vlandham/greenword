# This controller is used to manage the annoucement system.  Announcements are created and edited by the admin and are displayed to the student.  The announcement class has a boolean that indicates if it should be displayed on the main page of the student_controller.  If this is not checked, then it will only be displayed in the announcements page in the student section.  This student-only announcement page was not included in this controller so as to simplify the url for the students.
#
# all the actions in this controller are pretty standard CRUD actions.
class AnnouncementsController < ApplicationController
  before_filter :admin_login_required
  before_filter :set_locale
  before_filter :set_semester
  layout "admin"
  
  # Displays all announcements for the semester.  Icon allows the toggling of the announcement from front-page to non-front-page via the action toggle
  def index
    @announcements = @semester.announcements.find(:all)
  end
  
  # set-up to create a new announcement
  def new
    @announcement = Announcement.new
  end
  
  # actual announcement creation.  
  def create
    if request.post?
      @announcement  = @semester.announcements.build(params[:announcement])
      @announcement.user_id = @current_user.id
      if @announcement.save
        flash[:notice] = "#{@announcement.title} created"
        redirect_to :action => :index
      else
        render :action => :new
      end
    end
  end
  
  # allows admin editing of announcement
  def edit
    @announcement = @semester.announcements.find(params[:id])
  end
  
  # does the actual update of the announcement object
  def update
    if request.post?
      @announcement = @semester.announcements.find(params[:id])
      unless(@announcement.nil?)

        if(@announcement.update_attributes(params[:announcement]))
          flash[:notice] = "#{@announcement.title} updated"
          redirect_to :action => :index
        else
          render :action => :edit, :id => @announcement.id
        end
      end
    end
  end
  
  # delete an announcement
  def destroy
    if request.post?
      @announcement = @semester.announcements.find(params[:id])
      flash[:notice] = "#{@announcement.title} deleted"
      @announcement.destroy
      redirect_to :action => :index
    end
  end
  
  # Toggles an announcement from displaying on the index page of the student_controller.  I believe this is much more wordy then it needs to be, but it gets the job done.  After the update, the partial holding the updated announcement is updated to reflect the change in an ajaxy way.
  def toggle
    if request.post?
      announcement = Announcement.find(params[:id])
      if announcement.front_page?
        announcement.front_page = false
      else
        announcement.front_page = true
      end
      if(announcement.save)
        render :update do |page|
           page.replace  "announcement-#{params[:id]}", :partial => 'announcement', :object => announcement
           page.visual_effect :highlight, "announcement-#{params[:id]}"
        end
      else
        render :update do |page|
          page.visual_effect :shake, 'head'
        end
      end
      
    end
  end
  
end
