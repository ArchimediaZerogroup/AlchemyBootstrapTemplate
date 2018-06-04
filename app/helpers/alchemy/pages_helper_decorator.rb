Alchemy::PagesHelper.module_eval do

  def page_title(options = {})
    return "" if !@custom_element.nil? and @custom_element.respond_to? :meta_title and
        @custom_element.meta_title.presence and @page.title.blank?
    options = {
        prefix: "",
        separator: ""
    }.update(options)
    title_parts = [options[:prefix]]
    if response.status == 200
      if !@custom_element.nil? and @custom_element.respond_to? :meta_title
        title_parts << (@custom_element.meta_title.presence || "#{@page.title}  #{@custom_element.ui_title}")
      else
        title_parts << @page.title
      end
    else
      title_parts << response.status
    end
    title_parts.join(options[:separator]).html_safe
  end


  def meta_description
    if !@custom_element.nil? and @custom_element.respond_to? :meta_description
      return @custom_element.meta_description.presence || "#{@page.meta_description} #{@custom_element.ui_title.presence}"
    else
      return @page.meta_description.presence || Alchemy::Language.current_root_page.try(:meta_description)
    end
  end

  def meta_keywords
    if !@custom_element.nil? and @custom_element.respond_to? :meta_keywords
      return @custom_element.meta_keywords.presence || "#{@page.meta_keywords} #{@custom_element.ui_title.presence}"
    else
      return (!@custom_element.nil? and @custom_element.meta_keywords) || @page.meta_keywords.presence || Alchemy::Language.current_root_page.try(:meta_keywords)
    end
  end

  def meta_robots
    if !@custom_element.nil? and @custom_element.respond_to? :robot_index? and @custom_element.respond_to? :robot_follow?
      "#{(@custom_element.robot_index?.presence or @page.robot_index?) ? '' : 'no'}index, #{(@custom_element.robot_follow?.presence || @page.robot_follow?) ? '' : 'no'}follow"
    else
      "#{ @page.robot_index? ? '' : 'no'}index, #{@page.robot_follow? ? '' : 'no'}follow"

    end
  end



end

