module Admin
  class ArgumentsController < BaseResourceProxerController

    include FriendlyLoader

    def resource_handler
      @_resource_handler ||= ArgumentResource.new(controller_path, alchemy_module)
    end

    private

    def switch_lang_path
      switch_language_admin_arguments_path
    end

    def switch_lang_redirect
      admin_arguments_path
    end
  end
end