class SectionController < ApplicationController
  before_filter :admin_login_required
  layout "admin"
  before_filter :set_semester
  scaffold :section
   
  
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
  
  def index
     @sections = @semester.sections.find(:all)
  end
  
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
