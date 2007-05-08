class Post < ActiveRecord::Base
  acts_as_ferret :fields => {
           :body => {:store => :yes}, 
           :body_html => {:store => :yes}
           }
  belongs_to :forum, :counter_cache => true
  belongs_to :user,  :counter_cache => true
  belongs_to :topic, :counter_cache => true

  format_attribute :body
  before_create { |r| r.forum_id = r.topic.forum_id }
  after_create  { |r| Topic.update_all(['replied_at = ?, replied_by = ?, last_post_id = ?', r.created_at, r.user_id, r.id], ['id = ?', r.topic_id]) }
  after_destroy { |r| t = Topic.find(r.topic_id) ; Topic.update_all(['replied_at = ?, replied_by = ?, last_post_id = ?', t.posts.last.created_at, t.posts.last.user_id, t.posts.last.id], ['id = ?', t.id]) if t.posts.last }

  validates_presence_of :user_id, :body, :topic
  attr_accessible :body
  
  def editable_by?(user)
    user && (user.id == user_id || user.admin? )
  end
  
  def self.find_discussion_posts(user_id)
     find_by_sql ["SELECT * FROM posts, forums WHERE posts.forum_id = forums.id AND forums.forum_type = 'dis' AND posts.user_id = ?", user_id]
   end
   
   def self.find_gallery_posts(user_id)
      find_by_sql ["SELECT * FROM posts, forums WHERE posts.forum_id = forums.id AND forums.forum_type = 'pho' AND posts.user_id = ?", user_id]
    end
    
    def self.find_english_posts
      find_by_sql ["SELECT * FROM posts, forums, users WHERE posts.forum_id = forums.id AND posts.user_id = users.id AND users.language = 'en'"]
    end
    
    
    def self.find_recent
      find(:all, :limit => 10, :order => "created_at DESC")
    end
  
  def to_xml(options = {})
    options[:except] ||= []
    options[:except] << :topic_title << :forum_name
    super
  end
  
  def forum_controller
    forum_type =""
    if(forum.forum_type == 'pho')
      forum_type = "gallery"
    else
      forum_type = "discussion"
    end
    forum_type
  end
  
  def size
    post = body.split(' ').size
  end
  
  def self.find_storage_by_contents(query, options = {})
    index = self.ferret_index # Get the index that acts_as_ferret created for us
    results = []

    # search_each is the core search function from Ferret, which Acts_as_ferret hides
    total_hits = index.search_each(query, options) do |doc, score| 
      result = {}

      # Store each field in a hash which we can reference in our views
      result[:body] = index.highlight(query, doc,
                      :field => :body, 
                      :pre_tag => "<strong>", 
                      :post_tag => "</strong>",
                      :num_excerpts => 1)
      result[:body_html] = index.highlight(query, doc,
                      :field => :body_html, 
                      :pre_tag => "<strong>", 
                      :post_tag => "</strong>",
                      :num_excerpts => 1)
      result[:score] = score   # We can even put the score in the hash, nice!

      results.push result
    end
    return block_given? ? total_hits : [total_hits, results]
  end
  
end
