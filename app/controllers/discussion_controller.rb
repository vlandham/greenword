# This controller manages the discussion forum.
#
# Both the Gallery and the Discussion utilize the same underlying classes(models): topics and posts.  In the Discussion controller, posts and topics work pretty much how you would expect in a forum.  Discussion acts as a single forum.  It can have multiple topics and each topic has multiple posts.
#
# Much of this and topics and posts are brought over from Beast  
class DiscussionController < ApplicationController
  before_filter :admin_login_required, :only => [:new, :create, :update]
  append_before_filter :set_semester
  append_before_filter :find_forum_and_topic
  append_before_filter :redirect_if_not_right_topic, :only => [:show]
  append_before_filter :block_locked, :except => [:show,:index]

# Shows all the current topics for the forum - (Discussion).  Only admins can create new topics.
  def index
    conditions = "section_id = #{current_user.course.section.id}" unless admin?
    @topics = @forum.topics.find(:all, :order => "created_at DESC", :conditions => conditions)
  end
  
# Page for inputing data for new topic. 
  def new
    @topic = Topic.new
  end
  
# show all posts for a particular topic.  Posts are paginated at 15 posts per page.  Beast implemented a rss version, but this is unused as of now.
  def show
    respond_to do |format|
      format.html do
        # see notes in application.rb on how this works
        update_last_seen_at
        # keep track of when we last viewed this topic for activity indicators
        # (session[:topics] ||= {})[@topic.id] = Time.now.utc
        # authors of topics don't get counted towards total hits
        @topic.hit! unless logged_in? and @topic.user == current_user
        
        @post_pages, @posts = paginate(:posts, :per_page => 15, :order => 'posts.created_at', :include => :user,
                              :conditions => ['posts.topic_id = ?', params[:id]])
        @post   = Post.new
      end
      format.xml do
        render :xml => @topic.to_xml
      end
      format.rss do
        @posts = @topic.posts.find(:all, :order => 'created_at desc', :limit => 15)
        render :action => 'show.rxml', :layout => false
      end
    end
  end
  
# Actually creates the new topic.  In the new topic page, theere is a drop down menu for which section the topic should be made for.  Each topic has a section associated with it so as to limit visibility of the topics based on sections which is in turn based on courses.  If that section to make a topic for comes back as -1, then a new topic will be made for all sections of the semester.  This is performed in the first part of the function.  If the section is not -1, then a topic is only created for one specific section.
#
# A topic only has a title, it also requires that a post be created at the same time which contains the content of the topic. That is why the transaction is used, so that the topic is created only if the post is a valid one.
  def create  
    cur_section_id = params[:topic].delete("section_id")
    #This is a hack so that it will create a new topic for all sections
    if cur_section_id.to_i == -1
      sections = @semester.sections.find(:all)
      sections.each do |section|
        Topic.transaction do
          @topic  = @forum.topics.build(params[:topic])
          @topic.section_id = section.id
          assign_protected
          @post   = @topic.posts.build(params[:topic])
          @post.topic=@topic
          @post.user = current_user
          # only save topic if post is valid so in the view topic will be a new record if there was an error
          # @topic.save! if @post.valid?
          # @post.save! 
          if @post.valid?
            @topic.save
            @post.save
          else
            flash[:notice] = "Information invalid or missing"
            redirect_to :action => :new and return
          end
        end
      end
    else
      Topic.transaction do
        @topic  = @forum.topics.build(params[:topic])
        @topic.section_id = cur_section_id
        assign_protected
        @post   = @topic.posts.build(params[:topic])
        @post.topic=@topic
        @post.user = current_user
        # only save topic if post is valid so in the view topic will be a new record if there was an error
        # @topic.save! if @post.valid?
        # @post.save! 
        if @post.valid?
          @topic.save
          @post.save
        else
          flash[:notice] = "Information invalid or missing"
          redirect_to :action => :new and return
        end
      end
    end
    respond_to do |format|
       format.html { redirect_to :action => :index, :controller => :discussion }
      # format.xml  { head :created, :location => formatted_topic_url(:forum_id => @forum, :id => @topic, :format => :xml) }
    end
  end
#   Allows for updating of topic attributes. I don't believe this is used anywhere.
  def update
    @topic.attributes = params[:topic]
    assign_protected
    @topic.save!
    respond_to do |format|
      format.html { redirect_to :action => :show, :id => @topic }
      format.xml  { head 200 }
    end
  end
  
# Deletes topic and all associated posts.
  def destroy
    @topic.destroy
    flash[:notice] = "Topic '#{@topic.title}' was deleted."
    respond_to do |format|
      format.html { redirect_to home_path }
      format.xml  { head 200 }
    end
  end
  
   
  
  protected
#  Used in the create method, this assigns attributes to the topic that should not be accessible to the view - i.e. user, sticky, and forum_id 
    def assign_protected
      @topic.user     = current_user if @topic.new_record?
      # admins and moderators can sticky and lock topics
      return unless admin?
      @topic.sticky, @topic.locked = params[:topic][:sticky], params[:topic][:locked] 
      # only admins can move
      return unless admin?
      @topic.forum_id = params[:topic][:forum_id] if params[:topic][:forum_id]
    end
    
#  Finds the forum (which should always be the discussion for the particular semester) and topic (if using the show method) and assigns them to the variables @forum and @topic
    def find_forum_and_topic
      @forum = @semester.forums.find_discussion
      @topic = @forum.topics.find(params[:id]) if params[:id]
    end

#   Returns to the index if student tries to access a topic that is in the wrong section. Used as a before filter
    def redirect_if_not_right_topic
      redirect_to( :action => :index) unless admin? || current_user.course.section.id == @topic.section_id
    end

#  If the current semester is locked, then return to index.  Used as a before filter on everything except index and show
    def block_locked
      redirect_to :action => :index and return if @semester.locked?
    end
    
end
