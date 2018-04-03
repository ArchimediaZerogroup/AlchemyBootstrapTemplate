class Admin::UserSiteRegistrationsController < Alchemy::Admin::ResourcesController

  def resource_handler
    @_resource_handler ||= ::UserSiteResource.new(controller_path, alchemy_module)
  end

end