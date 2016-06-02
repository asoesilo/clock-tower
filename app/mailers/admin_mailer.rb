class AdminMailer < ApplicationMailer

  def locked_statements_notify(statements)
    @statements = statements
    mail subject: "#{statements.length} Statements Locked", to: User.admins_accepting_emails.pluck(:email)
  end

  def legacy_statements_notify(statements)
    @statements = statements
    mail subject: "#{statements.length} Statements legacy locked", to: User.admins_accepting_emails.pluck(:email)
  end
end
