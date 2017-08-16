module ApplicationHelper
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
end
