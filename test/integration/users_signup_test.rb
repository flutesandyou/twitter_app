require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
		ActionMailer::Base.deliveries.clear
	end

  test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, user: { name: "",
										           email: "user@invalid",
		                           password:              "foo",
		                           password_confirmation: "bar" }
		end
		assert_template 'users/new'
		assert_select 'div#error_explanation'
		assert_select 'div.field_with_errors'
	end

	test "valid signup information with account activation" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, user: { name:  "Example User",
															 email: "user@example.com",
															 password:              "password",
															 password_confirmation: "password"}
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		# Try to log in before activation.
		log_in_as(user)
		assert_not is_logged_in?
		# Index page
		# Log in as valid user.
		log_in_as(users(:michael))
		# Unactivated user is on the second page
		get users_path, page: 2
		assert_no_match user.name, response.body
		# Profile page
		get user_path(user)
		assert_redirected_to root_url
		# Log out valid user.
		delete logout_path
		# Invalid activation token
		get edit_account_activation_path("invalid token")
		assert_not is_logged_in?
		# Valid token, wrong email
		get edit_account_activation_path(user.activation_token, email: 'wrong')
		assert_not is_logged_in?
		# Valid activation token
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template 'users/show'
		assert_not flash.nil?
		assert is_logged_in?
	end
end
