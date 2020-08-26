# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/matches
  def matches
    user = User.last

    UserMailer.with(user: user).matches
  end
end
