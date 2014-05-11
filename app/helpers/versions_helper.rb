module VersionsHelper
  def subpaths_to path, &block
    path.split('/').reject(&:blank?).inject("") do |path, component|
      path << "/" unless path.blank?
      path << component
      yield component, path
      path
    end
  end

  def render_markup(name, data)
    tag(:span, class: "glyphicon glyphicon-link")
    raw GitHub::Markup.render(name, data)
  end
end
