module Admin
  class AdvicesController < BaseResourceProxerController

    # Only if friendly_id gem loaded
    # include FriendlyLoader

    def resource_handler
      @_resource_handler ||= AdviceResource.new(controller_path, alchemy_module)
    end

    private

    def switch_lang_path
      switch_language_admin_advices_path
    end

    def switch_lang_redirect
      admin_advices_path
    end
  end
end