class ApplicationMailer < ActionMailer::Base
  default from: ENV['EMAIL_SENDER'], bcc: ENV['SUPER_ADMIN_EMAIL']

  layout 'mailer'
end
