class AdminMailer < ApplicationMailer

  def locked_statements_notify(statements)
    @statements = statements
    mail subject: "#{statements.length} Statements Locked", to: User.admins_accepting_emails.pluck(:email)
  end
end
