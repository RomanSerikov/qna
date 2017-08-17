module ApplicationHelper
  def flash_helper
    content_tag :div, class: "flash" do
      flash.map do |key, value| 
        content_tag :div, value, class: key 
      end.join.html_safe
    end
  end
end
