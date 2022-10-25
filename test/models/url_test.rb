require "test_helper"

class UrlTest < ActiveSupport::TestCase
  def setup
    @url = Url.new(link: "https://guides.rubyonrails.org.com")
  end

  test "should be valid" do
    assert @url.valid?
  end

  test "should not be valid without link" do
    @url.link = ""
    assert @url.invalid?
  end

  test "should not be valid with link invalid" do
    @url.link = "sapdipojhas908d"
    assert @url.invalid?
  end

  test "should save" do
    assert_difference("Url.count") do
      assert @url.save
    end
  end

  test "should update shortener" do
    url = urls(:google)
    old_shortener = url.shortener
    url.update_shortener
    new_shortener = url.shortener

    assert_not_equal old_shortener, new_shortener
  end

  test "should update shortener e expiration after expiration" do
    url = urls(:instagram)
    old_shortener = url.shortener
    old_expiration_time = url.expiration_time
    url.update_if_expired
    new_shortener = url.shortener
    new_expiration_time = url.expiration_time

    assert_not_equal old_shortener, new_shortener
    assert_not_equal old_expiration_time, new_expiration_time
  end

  test "should not update shortener e expiration before expiration" do
    url = urls(:gmail)
    old_shortener = url.shortener
    old_expiration_time = url.expiration_time
    url.update_if_expired
    new_shortener = url.shortener
    new_expiration_time = url.expiration_time

    assert_equal old_shortener, new_shortener
    assert_equal old_expiration_time, new_expiration_time
  end

  test "should delete" do
    urls.each do |url|
      assert_difference("Url.count", -1) do
        assert url.destroy
      end
    end
  end
end
