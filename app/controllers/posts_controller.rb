# posts_controller handles CRUD operations for posts.  Posts are associated with a particular topic in a forum (either Gallery or Discussion).  All users can create posts. Only admins can edit / delete posts. 
#
# Most was copied over from Beast
#
# The redirect_to actions require the forum id, and so modifications were made to check which forum (Gallery or Discussion) we are posting from
class PostsController < ApplicationController
  before_filter :find_post,      :except => [:index, :create, :monitored, :search]
  before_filter :login_required, :except => [:index, :monitored, :search, :show]
  @@query_options = { :per_page => 25, :select => 'posts.*, topics.title as topic_title, forums.name as forum_name', :joins => 'inner join topics on posts.topic_id = topics.id inner join forums on topics.forum_id = forums.id', :order => 'posts.created_at desc' }

# Displays posts.  Usually the show method of the discussion / gallery controllers will handle this operation
  def index
    conditions = []
    [:user_id, :forum_id].each { |attr| conditions << Post.send(:sanitize_sql, ["posts.#{attr} = ?", params[attr]]) if params[attr] }
    conditions = conditions.any? ? conditions.collect { |c| "(#{c})" }.join(' AND ') : nil
    @post_pages, @posts = paginate(:posts, @@query_options.merge(:conditions => conditions))
    @users = User.find(:all, :select => 'distinct *', :conditions => ['id in (?)', @posts.collect(&:user_id).uniq]).index_by(&:id)
    render_posts_or_xml
  end

# Search is not used in this application
  def search
    conditions = params[:q].blank? ? nil : Post.send(:sanitize_sql, ['LOWER(posts.body) LIKE ?', "%#{params[:q]}%"])
    @post_pages, @posts = paginate(:posts, @@query_options.merge(:conditions => conditions))
    @users = User.find(:all, :select => 'distinct *', :conditions => ['id in (?)', @posts.collect(&:user_id).uniq]).index_by(&:id)
    render_posts_or_xml :index
  end

# monitorship is not currently used in this application
  def monitored
    @user = User.find params[:user_id]
    options = @@query_options.merge(:conditions => ['monitorships.user_id = ? and posts.user_id != ?', params[:user_id], @user.id])
    options[:joins] += ' inner join monitorships on monitorships.topic_id = topics.id'
    @post_pages, @posts = paginate(:posts, options)
    render_posts_or_xml
  end

# Shows a particular post
  def show
    @forum = @post.topic.forum
    controller = :discussion
    case @forum.forum_type
    when 'dis'
      controller = :discussion
    when 'pho'
      controller = :gallery
    end
    respond_to do |format|
      format.html { redirect_to :controller => controller, 
        :action => :show, :id => params[:topic_id] }
      format.xml  { render :xml => @post.to_xml }
    end
  end

# Creates new post.  Redirection is based off of where the new post request came from.  Cannot create new posts for a locked topic
  def create     
    @topic = Topic.find_by_id(params[:topic_id])
    if @topic.locked?
      respond_to do |format|
        format.html do
          flash[:notice] = 'This topic is locked.'
          redirect_to(topic_path( :id => params[:topic_id]))
        end
        format.xml do
          render :text => 'This topic is locked.', :status => 400
        end
      end
      return
    end
    @forum = @topic.forum
    @post  = @topic.posts.build(params[:post])
    @post.user = current_user
     controller = :discussion
      case @forum.forum_type
      when 'dis'
        controller = :discussion
      when 'pho'
        controller = :gallery
      end
    @post.save!
    respond_to do |format|
     
      format.html do
          redirect_to :controller => controller, :action => :show, :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || '1'
        # redirect_to topic_path( :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || '1')
      end
      format.xml { head :created, :location => formatted_post_url( :topic_id => params[:topic_id], :id => @post, :format => :xml) }
    end
  rescue ActiveRecord::RecordInvalid
    flash[:bad_reply] = 'Please post something at least...'
    respond_to do |format|
      format.html do
        # redirect_to topic_path( :id => params[:topic_id], :anchor => 'reply-form', :page => params[:page] || '1')
     redirect_to :controller => controller, :action => :show, 
      :id => params[:topic_id], :anchor => @post.dom_id, :page => params[:page] || 1
      end
      format.xml { render :xml => @post.errors.to_xml, :status => 400 }
    end
  end

# Edit page for a post - has an rjs file associated with it in the view  
  def edit
    respond_to do |format| 
      format.html
      format.js
    end
  end

# Actually updates the post.  Redirection was removed, as only admins can update a post and admins will have javascript running
#
# Probably should be cleaned up a bit  
  def update
    @post.attributes = params[:post]
    # controller = :discussion
    #       case @forum.forum_type
    #       when 'dis'
    #         controller = :discussion
    #       when 'pho'
    #         controller = :gallery
    #       end
    @post.save!
  rescue ActiveRecord::RecordInvalid
    flash[:notice] = 'An error occurred'
  ensure
    respond_to do |format|
      format.html do
        # redirect_to topic_path(:id => params[:topic_id], :anchor => @post.id, :page => params[:page] || '1')
        # redirect_to :action => :show, :id => params[:topic_id]
      end
      format.js
      format.xml { head 200 }
    end
  end

# Deletes a post an returns to the proper forum
  def destroy
    @forum = @post.topic.forum
    controller = :discussion
    case @forum.forum_type
    when 'dis'
      controller = :discussion
    when 'pho'
      controller = :gallery
    end    
    @post.destroy
    flash[:notice] = "Post of '#{CGI::escapeHTML @post.topic.title}' was deleted."
     
    # check for posts_count == 1 because its cached and counting the currently deleted post
    if( @post.topic.posts_count == 1)
       @post.topic.destroy and redirect_to( :controller => controller, :action => :index)  and return
    else
      respond_to do |format|
        format.html do
           redirect_to( :controller => controller, :action => :show, 
              :id => params[:topic_id], :page => params[:page]) unless performed?
        end
        format.xml { head 200 }
      end
    end
  end

  protected
#  Check if user is authorized to perform a function
#
#   editable_by is in the post model
    def authorized?
      action_name == 'create' || @post.editable_by?(current_user)
    end

#  finds a post based on id and topic id from url
    def find_post
      @post = Post.find_by_id_and_topic_id(params[:id], params[:topic_id]) || raise(ActiveRecord::RecordNotFound)
    end
    
    def render_posts_or_xml(template_name = action_name)
      respond_to do |format|
        format.html { render :action => "#{template_name}.rhtml" }
        format.rss  { render :action => "#{template_name}.rxml", :layout => false }
        format.xml  { render :xml => @posts.to_xml }
      end
    end
    
end
