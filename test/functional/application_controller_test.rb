require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  fixtures :users

  def setup
    @controller.send :reset_session
    @controller.send :'response=', @response
    @controller.send :'request=', @request
  end

  test 'current user session' do
    assert_nil @controller.send(:current_user_session)

    UserSession.create(users(:admin))

    assert_not_nil @controller.send(:current_user_session)
  end

  test 'current user' do
    assert_nil @controller.send(:current_user)

    UserSession.create(users(:admin))

    assert_not_nil @controller.send(:current_user)
    assert_equal users(:admin).id, @controller.send(:current_user).id
  end

  test 'require user' do
    assert !@controller.send(:require_user)
    assert_redirected_to admin_url
    assert_equal I18n.t('messages.must_be_logged_in'),
      @controller.send(:flash)[:notice]

    UserSession.create(users(:admin))
    assert_not_equal false, @controller.send(:require_user)
  end

  test 'require no user' do
    assert @controller.send(:require_no_user)

    UserSession.create(users(:admin))
    assert !@controller.send(:require_no_user)
    assert_redirected_to apps_url
    assert_equal I18n.t('messages.must_be_logged_out'),
      @controller.send(:flash)[:notice]
  end

  test 'store location' do
    assert_nil @controller.send(:session)[:return_to]
    assert @controller.send(:store_location)
    assert_not_nil @controller.send(:session)[:return_to]
  end

  test 'redirect to back of default' do
    @controller.send(:redirect_back_or_default, new_user_session_url)

    assert_redirected_to new_user_session_url
  end
end