class UserDataRegistrationMailer < ApplicationMailer


  def notify_registration(r)
    @rec = r
    mail(to: r.emails_recipient, subject: 'Nuova registrazione Sito')
  end

end