module GlobalizeLocale
  extend ActiveSupport::Concern

  included do

    around_action :switch_globalize_locale
    before_action :load_object, except: :index

    def switch_globalize_locale(&action)
      locale = Alchemy::Language.current.locale.to_sym
      Globalize.with_locale(locale, &action)
    end

  end
end