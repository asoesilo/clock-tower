class UserMailer < ApplicationMailer

  default from: ENV['EMAIL_SENDER'], bcc: ENV['SUPER_ADMIN_EMAIL']

  def user_invite(user, creator)
    @user = user
    @creator = creator
    mail to: user.email, subject: 'Welcome to Clock Tower App - Lighthouse Labs'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Clock Tower Password Reset'
  end

end
