require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "matches" do
    mail = UserMailer.matches
    assert_equal "Matches", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
