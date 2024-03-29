require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  fixtures :all
  
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_should_get_index
    get :index
    assert_response :success
  end
  
  def test_should_get_index_when_logged_in
    login_as :trevor
    get :index
    assert_response :success
  end
  
  def test_should_get_index_when_not_logged_in
    get :index
    assert_response :success
  end
  
  def test_should_redirect_to_login_if_site_is_private_and_not_logged_in
    private_site
    get :index
    assert_redirected_to login_path
  end
  
  def test_should_get_index_if_site_is_private_and_logged_in
    login_as :trevor
    private_site
    get :index
    assert_response :success
  end
  
  def test_initial_setup_should_work
    User.destroy_all
    Setting.destroy_all
    get :index
    assert_redirected_to new_user_path
    assert_equal 'UTC', Setting.first.time_zone
  end

  def test_should_not_update_session_online_at
    # if current_user HAS been active in the last 10 minutes
  end

  def test_should_update_session_online_at
    # if current_user HASN'T been active in the last 10 minutes
  end

  def test_should_have_correct_online_at
    # if current_user just logged in, save they're online_at from the db for use in session
  end

  def test_should_catch_request_with_cgi_in_path
    # e.g. http://localhost:3000/topics.cgi?topic=1
    get :index, :format => 'cgi'
    assert_redirected_to root_path
  end
    
end
