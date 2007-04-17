class Forum < ActiveRecord::Base
  acts_as_list
  belongs_to :semester
  validates_presence_of :name
  
  has_many :images
  
  FORUM_TYPES = [
       ["Photo", "pho"],
       ["Discussion", "dis"]
     ]

  # has_many :moderatorships, :dependent => :destroy
  # has_many :moderators, :through => :moderatorships, :source => :user, :order => 'users.login'

  validates_inclusion_of :forum_type, :in => FORUM_TYPES.map {|disp,value| value}

  has_many :topics, :order => 'sticky desc, replied_at desc', :dependent => :destroy do
    def first
      @first_topic ||= find(:first)
    end
  end

  # this is used to see if a forum is "fresh"... we can't use topics because it puts
  # stickies first even if they are not the most recently modified
  has_many :recent_topics, :class_name => 'Topic', :order => 'replied_at desc' do 
    def first 
      @first_recent_topic ||= find(:first) 
    end 
  end

  has_many :posts, :order => 'posts.created_at desc' do
    def last
      @last_post ||= find(:first, :include => :user)
    end
  end
  
  def self.find_discussion
     find(:first, :conditions => ["forum_type = ?", "dis"]) 
  end
  
  def self.find_photo
    find(:first, :conditions => ["forum_type = ?", "pho"])
  end
  # format_attribute :description
end
