class UserMailer < ApplicationMailer

  def user_invite(user, creator)
    @user = user
    @creator = creator
    mail to: user.email, subject: 'Welcome to Clock Tower App - Lighthouse Labs'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Clock Tower Password Reset'
  end

  def statement_created(user, statement)
    @user = user
    @statement = statement
    mail to: user.email, subject: "Clocktower statement for #{@statement.from.to_s(:humanly)} - #{@statement.to.to_s(:humanly)}"
  end

end
