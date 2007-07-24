module AdminHelper

# Creates icon for the gallery link. 
  def link_to_gallery
    link_to "Go to Gallery "+icon("images"), :controller => :gallery, :action => :index
  end
  
# Creates icon for the Discussion link.  
  def link_to_discussion
     link_to "Go to Discussion "+icon("comments"), :controller => :discussion, :action => :index
  end

# Currently not used
#
# Was meant for searching 
  def excerpt_all_words(text, phrase, radius = 100, excerpt_string = "...")
    phrase_array = phrase.split(' ')
 
    phrase_array.each_with_index do |word, index|
      excerpt(text,phrase_array[index],radius,excerpt_string) 
    end
  end
  
# Used in the search section to highlight multiple occurances of the word.
  def highlight_all_words(text, phrase, highlighter = '<strong class="highlight">\1</strong>')
        phrase_array = phrase.split(' ')
        phrase_array.each do |phrase_piece|
            text =highlight(text,phrase_piece, highlighter)
        end
        text
  end
  
end
