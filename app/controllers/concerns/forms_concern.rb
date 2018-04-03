require 'active_support/concern'

module FormsConcern
  extend ActiveSupport::Concern

  included do

    before_action :form_newlsetter_register
    before_action :contact_form_register


    private

    # Si occupa di ricevere i valori dell'invio della registrazione della newsletter
    def form_newlsetter_register

      if params[:form_newsletter]

        @form_newsletter = FormNewsletter.new(params.require(:form_newsletter).permit(:email, :check_privacy,:alcm_element))
        if (verify_recaptcha(model: @form_newsletter) or Rails.application.secrets.recaptcha[:simulate]) && @form_newsletter.valid?
          #registro dati, invio email
          @form_newsletter.save
          @form_newsletter.mailer.deliver

          # registro il successo dell'esecuzione
          @form_newsletter.sended!
        end

      end

    end

    def contact_form_register

      if params[:contact_form]

        @form_contatti = ContactForm.new(params.require(:contact_form).permit(
          :email,
          :check_privacy,
          :first_name,
          :last_name,
          :address,
          :city,
          :telephone,
          :message,
          :alcm_element
        ))
        if (verify_recaptcha(model: @form_contatti) or Rails.application.secrets.recaptcha[:simulate]) && @form_contatti.valid?
          #registro dati, invio email
          @form_contatti.save
          @form_contatti.mailer.deliver

          # registro il successo dell'esecuzione
          @form_contatti.sended!
        end

      end
    end
  end
end