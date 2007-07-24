# Simple class to manage images used in the Gallery.
#
# attr_writers are a hack to facilitate attachment_fu to work properly.
class Image < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  belongs_to :topic
  
  attr_writer :body
  attr_writer :title
  attr_writer :sticky
  
  has_attachment :content_type => :image, 
                   :storage => :file_system, 
                   :max_size => 1000.kilobytes,
                   :resize_to => '800x600>',
                   :thumbnails => { :thumb => '100x100>', :medium => '500x375>' }

    validates_as_attachment
end
