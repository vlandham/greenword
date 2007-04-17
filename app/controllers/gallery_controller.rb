class GalleryController < ApplicationController
  before_filter :set_semester
  before_filter :find_forum_and_topic
  

#  before_filter :update_last_seen_at, :only => :show

  def index
    @topics = @forum.topics.find(:all)
  end

  def new
    @topic = Topic.new
  end
  
  def show
    respond_to do |format|
      format.html do
        # see notes in application.rb on how this works
        update_last_seen_at
        # keep track of when we last viewed this topic for activity indicators
        # (session[:topics] ||= {})[@topic.id] = Time.now.utc
        # authors of topics don't get counted towards total hits
        @topic.hit! unless logged_in? and @topic.user == current_user
        @post_pages, @posts = paginate(:posts, :per_page => 25, :order => 'posts.created_at', :include => :user, :conditions => ['posts.topic_id = ?', params[:id]])
        @post   = Post.new
      end
      format.xml do
        render :xml => @topic.to_xml
      end
      format.rss do
        @posts = @topic.posts.find(:all, :order => 'created_at desc', :limit => 25)
        render :action => 'show.rxml', :layout => false
      end
    end
  end
  
  def create
    # this is icky - move the topic/first post workings into the topic model?
    Topic.transaction do
      @topic  = @forum.topics.build(params[:topic])
 
      assign_protected
      @post   = @topic.posts.build(params[:topic])
      @post.topic=@topic
      @post.user = current_user
      
      @image = @topic.build_image(params[:topic])
      @image.topic_id = @topic.id
      @image.user_id = @current_user.id
      # only save topic if post is valid so in the view topic will be a new record if there was an error
      # @topic.save! if @post.valid?
      # @post.save! 
      if @post.valid? &&  @image.valid?
        @topic.save
        @post.save
        @image.save
      else
        flash[:notice] = "Information invalid or missing"
        redirect_to :action => :new, :controller => "gallery" and return
      end
    end
    respond_to do |format|
      format.html { redirect_to :action => :index, :controller => :gallery }
      format.xml  { head :created, :location => formatted_topic_url(:forum_id => @forum, :id => @topic, :format => :xml) }
    end
  end
  
  def update
    @topic.attributes = params[:topic]
    assign_protected
    @topic.save!
    respond_to do |format|
      format.html { redirect_to topic_path(@topic) }
      format.xml  { head 200 }
    end
  end
  
  def destroy
    @topic.destroy
    flash[:notice] = "Topic '#{@topic.title}' was deleted."
    respond_to do |format|
      format.html { redirect_to home_path }
      format.xml  { head 200 }
    end
  end
  
   
  
  protected
    def assign_protected
      @topic.user     = current_user if @topic.new_record?
      # admins and moderators can sticky and lock topics
      return unless admin? or current_user.moderator_of?(@topic.forum)
      @topic.sticky, @topic.locked = params[:topic][:sticky], params[:topic][:locked] 
      # only admins can move
      return unless admin?
      @topic.forum_id = params[:topic][:forum_id] if params[:topic][:forum_id]
    end
    
    
    def find_forum_and_topic
      @forum = @semester.forums.find_photo
      @topic = @forum.topics.find(params[:id]) if params[:id]
    end
    
    def authorized?
      %w(new create).include?(action_name) || @topic.editable_by?(current_user)
    end
    
end
