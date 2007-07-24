# Controls sections, which are known as 'groups' the views.  Each Section can contain zero or more courses (classes) and are used to limit visibility of forums.
class SectionController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  before_filter :set_semester
  scaffold :section
   
# Creates and saves new section.  
  def new
      @section = Section.new(params[:section])
      return unless request.post?
      @section.save!     
      redirect_to(:controller => 'section', :action => 'index')
      flash[:notice] = "New section created"
    rescue ActiveRecord::RecordInvalid
      flash[:notice] = "Error in Section Creation"
      render :action => 'new'
  end
  
# Displays all sections for the semester.
#
# See course_controller for another view of sections in which courses are paired with sections in an ajaxy way.
  def index
     @sections = @semester.sections.find(:all)
  end
  
# Allows changing of name of a particular section.
  def edit
    @section = @semester.sections.find(params[:id])
    return unless request.post?
    if(@section.update_attributes(params[:section]))
      flash[:notice] = "Section edited"
      redirect_to(:controller => 'section', :action => 'index')
    else
      flash[:notice] = "Error in Section Edit"
      render :action => 'edit'
    end
  end
 
end
