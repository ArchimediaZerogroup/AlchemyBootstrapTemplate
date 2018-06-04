module ResourceControllerDec

  extend ActiveSupport::Concern

  included do


    protected

    # Returns a translated +flash[:notice]+.
    # The key should look like "Modelname successfully created|updated|destroyed."
    def flash_notice_for_resource_action(action = params[:action])

      case action.to_sym
        when :create
          verb = "created"
        when :update
          verb = "updated"
        when :destroy
          verb = "removed"
      end

      if resource_instance_variable.errors.any?
        flash[:error] = Alchemy.t("#{resource_handler.resource_name.classify} unsuccessfully #{verb}", default: Alchemy.t("Unsuccessfully #{verb}")) +
            ", #{resource_instance_variable.errors.full_messages.join(", ")}"

      else
        flash[:notice] = Alchemy.t("#{resource_handler.resource_name.classify} successfully #{verb}", default: Alchemy.t("Successfully #{verb}"))

      end
    end

  end
end