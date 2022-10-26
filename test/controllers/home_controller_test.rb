require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    assert_response :success
  end

  test "should create a url shortener" do
    assert_difference("Url.count") do
      post shortener_path(
        url: {
          link: "https://www.youtube.com/watch?v=UQSb2kbgJy4"
        }
      )
      assert_response :success
    end
  end

  test "should update url shortener existent" do
    assert_no_difference("Url.count") do
      post shortener_path(
        url: {
          link: "https://mail.google.com"
        }
      )
      assert_response :success
      assert_select "a", "#{request.base_url}/#{urls(:gmail).shortener}"
    end
  end

  test "should create url shortener with link invalid" do
    assert_no_difference("Url.count") do
      post shortener_path(
        url: {
          link: "sdacwqeom"
        }
      )
      assert_response :unprocessable_entity
    end
  end

  test "should create a url shortener with format turbo stream" do
    assert_difference("Url.count") do
      post shortener_path(
        url: {
          link: "https://www.youtube.com/watch?v=UQSb2kbgJy4"
        }, format: :turbo_stream
      )
      assert_response :success
    end
  end

  test "should update url shortener existent with format turbo stream" do
    assert_no_difference("Url.count") do
      post shortener_path(
        url: {
          link: "https://instagram.com"
        }, format: :turbo_stream
      )
      assert_response :success
    end
  end

  test "should not update url shortener existent with format turbo stream" do
    assert_no_difference("Url.count") do
      post shortener_path(
        url: {
          link: "https://guides.rubyonrails.org/testing.html#testing-action-cable"
        }, format: :turbo_stream
      )
      assert_response :success
      assert_select "a", "#{request.base_url}/#{urls(:rails_testing_action_cable).shortener}"
    end
  end

  test "should create url shortener with link invalid with format turbo stream" do
    assert_no_difference("Url.count") do
      post shortener_path(
        url: {
          link: "sdacwqeom"
        }, format: :turbo_stream
      )
      assert_response :unprocessable_entity
    end
  end

  test "should redirect to link with url shortener" do
    url = urls(:gmail)

    get url_shortener_path(url.shortener)

    assert_redirected_to url.link 
  end

  test "should not redirect with url shortener expired" do
    url = urls(:google)

    get url_shortener_path(url.shortener)

    assert_response :not_found
    assert_select "h1", "The url shortener is expired."
  end

  test "should not redirect with url shortener nonexistent" do
    url = "sdpaiohdaos"

    get url_shortener_path(url)

    assert_response :not_found
    assert_select "h1", "The page you were looking for doesn't exist."
  end
end
