require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  fixtures :users, :web_form_fields
  let(:user) { users(:normal) }
  let(:field) { web_form_fields(:to_hire_name) }

  describe '#btn_group_btn' do
    let(:delete_btn) { btn_group_btn('Delete', 'remove', 'http://example.com', 'navbar-btn', { method: :delete }) }
    let(:delete_btn_source) { '<div class="btn-group" role="group"><a class="btn btn-default navbar-btn" rel="nofollow" data-method="delete" href="http://example.com"><span class="glyphicon glyphicon-remove"></span> Delete</a></div>' }
    let(:plain_delete_btn_source) { delete_btn_source.sub('navbar-btn" rel="nofollow" data-method="delete', '') }
    
    it 'returns a Bootstrap button group button' do
      expect(delete_btn).to eq(delete_btn_source)
      expect(btn_group_btn('Delete', 'remove', 'http://example.com')).to eq(plain_delete_btn_source)
    end
  end
  
  describe '#btn_class' do
    it 'appends extra classes to the default string' do
      expect(btn_class('fake-class')).to eq('btn btn-default fake-class')
    end
    
    it 'appends extra classes to the default string and overrides btn class' do
      expect(btn_class('btn-warning fake-class')).to eq('btn btn-warning fake-class')
    end
    
    it 'returns default string if no extra_class' do
      expect(btn_class).to eq('btn btn-default ')
    end
  end
  
  describe '#glyphicon_span' do
    it 'returns glyphicon element of type specified' do
      expect(glyphicon_span('plus')).to eq('<span class="glyphicon glyphicon-plus"></span>')
    end
  end
  
  describe '#panel_body_class' do
    it 'returns grid class as default' do
      expect(helper.panel_body_class('show')).to eq('col-md-10 col-md-offset-1')
    end
    
    it 'returns empty string if index or submissions page' do
      expect(helper.panel_body_class('index')).to eq('')
    end
  end

  describe '#delete_with_confirm' do
    let(:delete_link_source) { '<a data-confirm="Are you sure you want to delete Ms. Normal permanently?" rel="nofollow" data-method="delete" href="/users/' + user.id.to_s + '">Delete</a>' }
    
    it 'returns link tag to delete with confirmation' do
      expect(delete_with_confirm(user)).to eq(delete_link_source)
    end
  end
  
  describe '#formatted_errors' do
    let(:messy_user) { User.create(name: 'Messy User') }
    
    it 'returns error messages as an array of Bootstrap alert elements' do
      expect(formatted_errors(messy_user.errors)).to eq(['<div class="alert alert-warning">Email can&#39;t be blank</div>', '<div class="alert alert-warning">Email is invalid</div>', '<div class="alert alert-warning">Password can&#39;t be blank</div>'])
    end
  end
  
  describe '#escaped_input' do
    let(:input) { "<input type='text' name='web_form_field_#{field.id}' placeholder='#{field.name}' />" }
    
    it 'returns escaped html input tag for WebFormField' do
      expect(embed_input(field)).to eq(input)
    end
  end
end
