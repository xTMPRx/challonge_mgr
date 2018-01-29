require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
        @user = users(:willow)
        @other_user = users(:buffy)
    end

    test "Show a user" do
        log_in_as(@user)
        assert is_logged_in?

        get user_url(@user)
        assert_response :success
    end

    test "Try to show a different user" do
        log_in_as(@user)
        assert is_logged_in?

        get user_url(@other_user)
        assert_response :forbidden
    end

    test "Try to show a user without logging in" do
        get user_url(@user)
        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Get the edit user page" do
        log_in_as(@user)
        assert is_logged_in?

        get edit_user_url(@user)
        assert_response :success
    end

    test "Try to get the edit user page for a different user" do
        log_in_as(@user)
        assert is_logged_in?

        get edit_user_url(@other_user)
        assert_response :forbidden
    end

    test "Try to get the edit user page without logging in" do
        get edit_user_url(@user)
        assert_redirected_to login_url
        assert_not flash.empty?
    end

    test "Update a user" do
        log_in_as(@user)
        assert is_logged_in?

        params = { user: { api_key: @user.api_key, user_name: @user.user_name,
                           password: "password", password_confirmation: "password" } }

        patch user_url(@user), params: params

        assert_redirected_to user_url(@user)
    end

    test "Try to update a different user" do
        log_in_as(@user)
        assert is_logged_in?

        params = { user: { api_key: @user.api_key, user_name: @user.user_name,
                           password: "password", password_confirmation: "password" } }

        patch user_url(@other_user), params: params
        assert_response :forbidden
    end

    test "Try to update a user without logging in" do
        patch user_url(@user), params: { user: { api_key: @user.api_key, user_name: @user.user_name,
                                                 password: "password",
                                                 password_confirmation: "password" } }

        assert_redirected_to login_url
        assert_not flash.empty?
    end
end
