module ApplicationHelper
  def flash_helper
    content_tag :div, class: "flash" do
      flash.map do |key, value| 
        content_tag :div, value, class: "alert alert-#{key}" 
      end.join.html_safe
    end
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
