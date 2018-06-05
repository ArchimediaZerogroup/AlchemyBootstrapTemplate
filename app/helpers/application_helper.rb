module ApplicationHelper

  def custom_model_path obj
    alchemy.show_page_path(Alchemy::Language.current.language_code,
                           "#{obj.try(:to_url) ||
                               obj.class.to_s.demodulize.parameterize.underscore}/#{obj.send(obj.class.try(:friendly_id_config).try(:slug_column)) ||
                               obj.id}")
  end

  def custom_model_url obj
    alchemy.show_page_url(Alchemy::Language.current.language_code,
                          "#{obj.try(:to_url) ||
                              obj.class.to_s.demodulize.parameterize.underscore}/#{obj.send(obj.class.try(:friendly_id_config).try(:slug_column)) ||
                              obj.id}")
  end


  def search_result_page
    @search_result_page ||= begin
      page = Alchemy::Page.published.find_by(
          page_layout: search_result_page_layout['name'],
          language_id: Alchemy::Language.current.id
      )
      if page.nil?
        logger.warn "\n++++++\nNo published search result page found. Please create one or publish your search result page.\n++++++\n"
      end
      page
    end
  end

  def search_result_page_layout
    page_layout = Alchemy::PageLayout.get_all_by_attributes(searchresults: true).first
    if page_layout.nil?
      raise "No searchresults page layout found. Please add page layout with `searchresults: true` into your `page_layouts.yml` file."
    end
    page_layout
  end

  def show_svg(path)
    File.open(path) do |file|
      raw file.read
    end
  end

  def print_breadcrumbs separator = nil
    bf = ActiveSupport::SafeBuffer.new
    separator = content_tag(:span, separator, class: "brd-separator")
    index_page = Alchemy::Language.current.pages.find_by page_layout: "home_page"

    bf << link_to(show_alchemy_page_path(index_page), class: [dom_class(@page.site), :root], id: dom_id(@page.site)) do
      @page.site.name
    end
    bf << separator
    @page.ancestors.each do |pg|
      #se è la pagina consideata home apge la salto poichè nel breadcrumb è sostituita dal site
      next if pg == Alchemy::Page.root or pg == @page.get_language_root or
          pg == index_page or pg == Alchemy::Language.current.pages.find_by(page_layout: "index")
      bf << link_to(show_alchemy_page_path(pg), id: dom_id(pg), class: [dom_class(pg), :ancestor]) do
        pg.name
      end
      bf << separator
    end

    current_page_layout = Alchemy::PageLayout.get(@page.page_layout)

    if current_page_layout["custom_model_action"].blank? or current_page_layout["custom_model_action"] == "index"
      bf << content_tag(:span, @page.name, id: dom_id(@page), class: [dom_class(@page), :current])
    else
      unless @custom_element.nil?
        bf << content_tag(:span, @custom_element.breadcrumb_name, id: dom_id(@custom_element), class: [dom_class(@custom_element), :current])
      end
    end

    bf

  end
end
