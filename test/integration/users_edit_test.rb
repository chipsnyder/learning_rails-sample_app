require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lyra)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user:{
        name:"",
        email:"user@invalid",
        password:"foo",
        password_confirmation:"bar"
      }
    }

    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user:{
        name:name,
        email:email,
        password:"",
        password_confirmation:""
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  test "successful edit with friendly forwarding" do

    get edit_user_url(@user)
    assert_not_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
      user:{
        name:name,
        email:email,
        password:"",
        password_confirmation:""
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
    assert_nil session[:forwarding_url]
  end

end
