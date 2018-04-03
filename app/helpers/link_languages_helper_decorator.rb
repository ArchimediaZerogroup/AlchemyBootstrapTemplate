module LinkLanguagesHelper
  def language_links_by_page(current_page)
    r = []
    Alchemy::Language.on_current_site.published.with_root_page.collect { |lang|
      page= Alchemy::Page.published.with_language(lang.id).where(name: current_page.name).first
      if not page.nil? and lang!=Alchemy::Language.current
        url_page = show_page_path_params(page).merge(locale: lang.code)
        r << content_tag(:link, nil, href: url_page[:locale] + '/' + url_page[:urlname], hreflang: lang.code, rel: "alternate")
      end
    }
    r.join().html_safe
  end
end
Alchemy::PagesHelper.include LinkLanguagesHelper