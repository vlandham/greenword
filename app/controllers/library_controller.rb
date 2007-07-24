# The library is a place to store documents and links for students to access.  This controller handles manipulations for both document and link models.  Student access to the library is controlled by the student_controller
#
# The naming scheme is a bit non-intuative as orignally only documents were park of the library, and links were added later.  Thus, the basic CRUD actions with single word names apply to documents.  Link CRUD actions have a 'link' suffix
class LibraryController < ApplicationController
  before_filter :admin_login_required
  before_filter :set_locale
  before_filter :set_semester
  layout 'admin'

# display all documents and links for a semester
   def index
     @documents = @semester.documents.find(:all, :order => "created_on DESC")
     @links = @semester.links.find(:all, :order => "created_on DESC")
   end

# Allows for creation of new document
   def new
     @document = Document.new
   end

# Allows for creation of new link
   def new_link
      @link = Link.new
    end

# Actually creates the new Document.  The document model uses the attachment_fu plugin to manage the details of the document.
#
# Only admins should be able to create new documents
   def create
     if request.post?
       @document  = @semester.documents.build(params[:document])
       @document.user_id = @current_user.id
       if @document.save
         flash[:notice] = "#{@document.title} created"
         redirect_to :action => :index
       else
         render :action => :new
       end
     end
   end
   
#  Actually creates the new Link.  Links are just strings with a few other attributes associated with them.  
#
#  Only admins should be able to create new links
   def create_link
     if request.post?
       @link  = @semester.links.build(params[:link])
       @link.user_id = @current_user.id
       if @link.save
         flash[:notice] = "#{@link.title} created"
         redirect_to :action => :index
       else
         render :action => :new
       end
     end
   end
   
# Gathers document information based on id to allow editing 
   def edit
     @document = @semester.documents.find(params[:id])
   end
   
# Gathers link information based on id to allow editing   
   def edit_link
     @link = @semester.links.find(params[:id])
   end
   
# Actually updates the document.  
   def update
     if request.post?
       @document = @semester.documents.find(params[:id])
       unless(@document.nil?)

         if(@document.update_attributes(params[:document]))
           flash[:notice] = "#{@document.title} updated"
           redirect_to :action => :index
         else
           render :action => :edit, :id => @document.id
         end
       end
     end
   end

#  Actually updates the link
   def update_link
     if request.post?
       @link = @semester.links.find(params[:id])
       unless(@link.nil?)

         if(@link.update_attributes(params[:link]))
           flash[:notice] = "#{@link.title} updated"
           redirect_to :action => :index
         else
           render :action => :edit, :id => @link.id
         end
       end
     end
   end
   
#  Deletes a document
   def destroy
     if request.post?
       @document = @semester.documents.find(params[:id])
       flash[:notice] = "#{@document.title} deleted"
       @document.destroy
       redirect_to :action => :index
     end
   end

#  Deletes a link
   def destroy_link
     if request.post?
       @link = @semester.links.find(params[:id])
       flash[:notice] = "#{@link.title} deleted"
       @link.destroy
       redirect_to :action => :index
     end
   end
   
end
