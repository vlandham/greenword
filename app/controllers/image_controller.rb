# Simple hack to take care of saving images.  
#
# Shouldn't be used anymore
class ImageController < ApplicationController
  before_filter :set_locale
  before_filter :set_semester
  
# new image
  def new
    @image = Image.new
  end
  
# creates the new image
  def create
    @image = Image.new(params[:image])
    @image.user_id = @current_user.id
    
    if @image.save
      flash[:notice] = 'Image was successfully created.'
      redirect_to :controller => :student, :action => :index     
    else
      render :action => :new
    end
  end
end
