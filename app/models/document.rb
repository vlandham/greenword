# Documents can be pdfs, Word documents, or plain text.  
#
# Uses attachment_fu to validate
class Document < ActiveRecord::Base
  belongs_to :semester
  
  has_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain'],
                 :storage => :file_system, 
                 :path_prefix => 'public/files'

  validates_as_attachment
end
