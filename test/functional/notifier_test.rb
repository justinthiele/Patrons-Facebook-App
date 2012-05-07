require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "new_pledge_artist" do
    mail = Notifier.new_pledge_artist
    assert_equal "New pledge artist", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
