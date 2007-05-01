class Post < ActiveRecord::Base
  acts_as_ferret
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
end
