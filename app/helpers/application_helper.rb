module ApplicationHelper
  def full_title(page_title)
    base_title = 'Фрей написал.'
    if page_title.empty?
      base_title
    else
      "#{page_title}, #{base_title}"
    end
  end

  def markdown(source)
    Kramdown::Document.new(source).to_html.html_safe
  end
end
