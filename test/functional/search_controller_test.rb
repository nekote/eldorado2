require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < Test::Unit::TestCase
  fixtures :all
  
  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_should_get_index
    login_as :trevor
    get :index
    assert_response :success
  end
  
  def test_should_accept_searches
    login_as :trevor
    get :index, :type => 'articles', :query => 'test'
    assert_response :success
    get :index, :type => 'avatars', :query => 'test'
    assert_response :success
    get :index, :type => 'events', :query => 'test'
    assert_response :success
    get :index, :type => 'files', :query => 'test'
    assert_response :success
    get :index, :type => 'headers', :query => 'test'
    assert_response :success
    get :index, :type => 'messages', :query => 'test'
    assert_response :success
    get :index, :type => 'posts', :query => 'test'
    assert_response :success
    get :index, :type => 'topics', :query => 'test'
    assert_response :success
    get :index, :type => 'users', :query => 'test'
    assert_response :success
  end
  
  def test_avatars_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
  def test_events_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end

  def test_files_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
  def test_headers_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
  def test_posts_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
  def test_topics_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
  def test_avatars_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
  def test_users_search
    # login_as :trevor
    # get :index, :type => 'avatars', :query => 'test'
    # assert_response :success
    # assert_select "span#reply"
  end
  
end
