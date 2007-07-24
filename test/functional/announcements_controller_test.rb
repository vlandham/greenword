require File.dirname(__FILE__) + '/../test_helper'
require 'announcements_controller'

# Re-raise errors caught by the controller.
class AnnouncementsController; def rescue_action(e) raise e end; end

class AnnouncementsControllerTest < Test::Unit::TestCase
  def setup
    @controller = AnnouncementsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
