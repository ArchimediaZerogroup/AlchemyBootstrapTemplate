module PreventPageNil

  extend ActiveSupport::Concern

  included do
    before_action :set_global_page
    before_action :redirect_to_root, if: ->{ @page.nil?}


    private

    def set_global_page
      @page = Alchemy::Page.with_language(Alchemy::Language.current.id).find_by page_layout: "restricted_area"
    end

    def redirect_to_root
      redirect_to root_path
    end

  end
end