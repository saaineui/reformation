module ApplicationHelper
  def page_title(controller)
    return 'login' if controller.controller_name.eql?('sessions')
    words = [page_title_verb(controller), page_title_noun(controller)].reject(&:empty?)
    words.join(' ').tr('_', ' ')
  end
  
  def btn_group_btn(text, icon_name, href, extra_class = '', extra_options = {})
    options = { class: btn_class(extra_class) }.merge(extra_options)
    inner_content = link_to(glyphicon_span(icon_name) + ' ' + text, href, options)
    tag.div(inner_content, class: 'btn-group', role: 'group')
  end
  
  def btn_class(extra_class = '')
    base_class = extra_class[0..3].eql?('btn-') ? 'btn ' : 'btn btn-default '
    base_class + extra_class
  end
  
  def glyphicon_span(icon_name)
    tag.span('', class: "glyphicon glyphicon-#{icon_name}")
  end
  
  def panel_body_class(action)
    case action
    when 'submissions', 'index'
      ''
    when 'new', 'edit'
      'col-md-8 col-md-offset-2'
    else
      'col-md-10 col-md-offset-1'
    end
  end
  
  def delete_with_confirm(resource)
    label = resource.respond_to?(:name) ? resource.name : 'this ' + resource.class.to_s.downcase
    
    link_to(
      'Delete', 
      resource, 
      method: :delete, 
      data: { confirm: "Are you sure you want to delete #{label} permanently?" }
    )
  end
  
  def formatted_errors(errors) 
    return [] if errors.empty?
    errors.full_messages.map { |msg| tag.div(msg, class: 'alert alert-warning') }
  end
  
  def embed_input(field)
    output = "<input type='text' name='web_form_field_#{field.id}' placeholder='#{field.name}' "
    output += field.required? ? 'required />' : '/>'
    output
  end
    
  private
  
  def page_title_noun(controller)
    return '' if controller.controller_name.eql?('landing')
    
    if instance_page?(controller)
      resource = class_from_controller(controller).find(params[:id])
      return resource.name if resource.respond_to?(:name)
    end
    
    if controller.action_name.eql?('index')
      controller.controller_name
    else
      controller.controller_name.singularize
    end
  end

  def page_title_verb(controller)
    case controller.action_name
    when 'index', 'show', nil
      ''
    when 'embed_code', 'submissions'
      controller.action_name + ' >'
    else
      controller.action_name
    end
  end
  
  def instance_page?(controller)
    return false unless params[:id]
    resource = class_from_controller(controller)
    resource && resource.exists?(params[:id])
  end
  
  def class_from_controller(controller)
    Object.const_get(controller.controller_name.singularize.titleize.gsub(/\s/, ''))
  rescue
    false
  end
end
