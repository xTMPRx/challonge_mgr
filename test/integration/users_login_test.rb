require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:willow)
    end

    test "Log in with invalid credentials" do
        get login_path
        assert_response :success
        assert_template "sessions/new"

        post login_path, params: { session: { user_name: "foo", password: "bar" } }
        assert_template "sessions/new"
        assert_not flash.empty?
        assert_not is_logged_in?

        get root_path
        assert_response :success
        assert flash.empty?
    end

    test "Log in with valid credentials, then log out" do
        get login_path
        assert_response :success
        assert_template "sessions/new"

        post login_path, params: { session: { user_name: @user.user_name,
                                              password: "password" } }

        # We don't follow this redirect, because it will contact Challonge.
        assert_redirected_to user_tournaments_refresh_path(@user)
        assert is_logged_in?

        delete logout_path
        assert_not is_logged_in?
        assert_redirected_to root_url
    end
end
