class SearchResult

  def initialize result
    @searched_element = result.searchable
  end

  def page_url
    unless page.nil?
      if element.proxed_element_id.blank?
        page.urlname
      else
        instance = custom_model_element
        slug_column = instance.class.try(:friendly_id_config).try(:slug_column)
        slug = instance.send(slug_column) unless slug_column.nil?
        id = slug || element.proxed_element_id
        "#{custom_model_page.urlname}/#{id}"
      end
    end
  end

  def page_title
    if element.proxed_element_id.blank?
      return page.title
    else
      return custom_model_element.try(:meta_title) || custom_model_page.title
    end
  end

  def description
    desc = content.essence.try(:body)
  end

  def page
    if element.proxed_element_id.blank?
      return @searched_element.page
    else
      return get_page_by_layout_attribute(custom_model: element.proxed_element_type)
    end
  end

  def element
    @searched_element.element
  end

  def content
    @searched_element.content
  end

  def is_from_page?
    if element.proxed_element_id.blank?
      return true
    else
      return false
    end
  end

  def is_from_custom_model?
    !is_from_page?
  end

  def custom_model
    if is_from_custom_model?
      element.proxed_element_type.constantize
    end
  end

  def custom_model_instance
    custom_model_element
  end

  private

  def get_page_by_layout_attribute attributes
    alchemy_layout = Alchemy::PageLayout.get_all_by_attributes(attributes).first
    Alchemy::Page.from_current_site.find_by(page_layout: alchemy_layout["name"])
  end

  def custom_model_element
    klass = element.proxed_element_type.constantize
    klass.find element.proxed_element_id
  end

  def custom_model_page
    alchemy_page = get_page_by_layout_attribute(custom_model: element.proxed_element_type)
    raise "You have to set a page for resource show" if alchemy_page.nil?
    alchemy_page.parent
  end

end