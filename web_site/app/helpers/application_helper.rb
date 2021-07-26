module ApplicationHelper


  def show_svg(path)
    File.open(Rails.root.join('app', 'assets', 'images', path)) do |file|
      raw file.read
    end
  end

  def homepage_path
    home_page = Alchemy::Page.language_root_for(Alchemy::Language.current)
    show_alchemy_page_path(home_page)
  end

  def toolbar(options = {})
    defaults = {
      buttons: [],
      search: true
    }
    options = defaults.merge(options)
    content_for(:toolbar) do
      content = <<-CONTENT.strip_heredoc
            #{options[:buttons].map { |button_options| toolbar_button(button_options) }.join}
            #{render('alchemy/admin/partials/search_form', url: options[:search_url]) if options[:search]}
      CONTENT
      content.html_safe
    end
  end

end
