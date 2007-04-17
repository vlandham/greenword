class Image < ActiveRecord::Base
  belongs_to :forum
  belongs_to :user
  belongs_to :topic
  
  attr_writer :body
  attr_writer :title
  attr_writer :sticky
  
  has_attachment :content_type => :image, 
                   :storage => :file_system, 
                   :max_size => 900.kilobytes,
                   :resize_to => '700x450>',
                   :thumbnails => { :thumb => '100x75>', :medium => '500x375>' }

    validates_as_attachment
end
