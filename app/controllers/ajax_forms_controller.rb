class AjaxFormsController < Alchemy::BaseController


    def create
      @object = base_class.new permitted_resource_attributes
      if (verify_recaptcha(model: @object) or Rails.application.secrets.recaptcha[:simulate]) && @object.valid?
        #registro dati, invio email
        @object.save
        @object.mailer.deliver
        # registro il successo dell'esecuzione
        @object.sended!
        render formats: :json
      else
        render formats: :json, status: :not_acceptable
      end
    end


    private


    def permitted_resource_attributes
      params.require(base_class.to_s.demodulize.underscore).permit!
    end

  def base_class
    controller_name.classify.constantize
  end


  end