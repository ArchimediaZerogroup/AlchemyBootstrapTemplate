module Admin
  class BaseResourceProxerController < Alchemy::Admin::ResourcesController

    helper_method :switch_lang_path

    before_action :load_languages

    def update
      resource_instance_variable.alchemy_element.update_contents(contents_params)
      super
    end


    def switch_language
      set_alchemy_language(params[:language_id])
      Rails.logger.debug {"Lingua i18n: #{I18n.locale}"}
      Rails.logger.debug {"Lingua Alchemy: #{Alchemy::Language.current.language_code}"}
      redirect_to switch_lang_redirect
    end

    private
    def contents_params
      params.fetch(:contents, {}).permit!
    end


    def load_languages
      @languages = Alchemy::Language.on_current_site

      # Only if globalize gem loaded
      # Globalize.locale = Alchemy::Language.current.language_code
    end

    def switch_lang_path
      raise "Override"
    end

    def switch_lang_redirect
      raise "Override"
    end

  end
end