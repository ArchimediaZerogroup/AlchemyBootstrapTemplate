module Admin
  class ContactFormsController < UserSiteRegistrationsController

    def resource_handler
      @_resource_handler ||= ::ContactFormResource.new(controller_path, alchemy_module)
    end
  end
end