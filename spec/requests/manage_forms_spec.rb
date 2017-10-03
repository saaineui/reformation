require 'rails_helper'

RSpec.describe 'Manage web forms', type: :request do
  fixtures :submissions, :submissions_entries, :web_forms, :web_form_fields, :users
  let(:user) { users(:normal) }
  let(:form) { web_forms(:to_hire) }
  let(:submission) { form.submissions.first }
    
  context 'logged in as regular user' do
    it 'homepage shows all and only forms owned by user' do
      sign_in(user)
      get('/')
      assert_select 'title', 'Reformation | home'
      assert_select '.home-forms-index' do
        assert_select '.btn-group-justified', 1
        assert_select "a[href='#{web_form_path(form)}']", 'To Hire'
        assert_select "a[href='#{submissions_path(form)}']", 'Submissions (1)'
        assert_select "a[href='#{form_embed_path(form)}']", 'Embed'
        assert_select "a[href='#{edit_web_form_path(form)}']", 'Edit'
      end
    end

    it 'profile page shows all forms of user and new form button' do
      sign_in(user)
      get user_path(user)
      assert_select 'title', 'Reformation | Ms. Normal'
      assert_select '.web-form-list' do
        assert_select "a[href='#{web_form_path(form)}']", 'To Hire'
      end
      assert_select "a[href='#{new_web_form_path}']", 'New Form'
    end

    it 'form summary page shows all fields' do
      sign_in(user)
      get web_form_path(form)
      assert_select 'title', 'Reformation | To Hire'
      assert_select 'table' do
        form.web_form_fields.each_with_index do |field, index|
          assert_select "tr:nth-child(#{index + 1}) td:first-child", field.id.to_s
          assert_select "tr:nth-child(#{index + 1}) td:nth-child(2)", field.name
          if field.required?
            assert_select "tr:nth-child(#{index + 1}) td:last-child", 'Required'
          else
            assert_select "tr:nth-child(#{index + 1}) td:last-child", 'No'
          end
        end
      end
    end

    it 'submissions page shows all submissions with delete buttons' do
      sign_in(user)
      get submissions_path(form)
      assert_select 'title', 'Reformation | submissions > To Hire'
      assert_select 'tr', form.submissions.count + 1
      assert_select 'td', 'Joe Smith'
      assert_select 'td', 'joe@smith.com'
      assert_select 'td', 'one.com'
      assert_select "a[href='#{submission_path(submission)}']", 'Delete'
    end

    it 'embed code page shows code for form in a well' do
      sign_in(user)
      get form_embed_path(form)
      assert_select 'title', 'Reformation | embed code > To Hire'
      assert_select 'pre', "
<form id='reformation-form' action='http://www.example.com/api/submissions/#{form.id}' method='post'>
    <input type='hidden' name='token' value='G4JsokU2slUr7SkK93nVMg45' />
    <input type='hidden' name='source' value='YOUR-WEBSITE.com' />

      <input type='text' name='web_form_field_425721112' placeholder='Name' />
      <input type='text' name='web_form_field_500841876' placeholder='Email' required />

    <button id='reformation-submit-btn'>Send</button>
</form>
"
    end
    
    it 'edit form page displays form with existing data' do
      sign_in(user)
      get edit_web_form_path(form)
      assert_select 'title', 'Reformation | edit To Hire'
      assert_select 'form.edit_web_form' do
        assert_select 'input[type=text]', 11
        assert_select 'input[type=checkbox]', 20
        assert_select 'input[value="To Hire"]', 1
        assert_select 'input[value="Name"]', 1
        assert_select 'input[value="Email"]', 1
        assert_select 'input[checked]', 1
      end
    end
    
    it 'new form page displays blank form' do
      sign_in(user)
      get new_web_form_path
      assert_select 'title', 'Reformation | new web form'
      assert_select 'form#new_web_form' do
        assert_select 'input[type=text]', 9
        assert_select 'input[type=checkbox]', 16
        assert_select 'input[checked]', 0
      end
    end
  end
end
