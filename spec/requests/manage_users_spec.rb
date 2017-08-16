require 'rails_helper'

RSpec.describe 'Manage users', type: :request do
  fixtures :users
  let(:user) { users(:normal) }
  let(:admin_user) { users(:admin) }
    
  context 'logged in as admin user' do
    it 'all users page shows all users in a table' do
      sign_in(admin_user)
      get(users_path)
      assert_select 'title', 'Reformation | users'
      assert_select 'table.table-striped' do
        assert_select "a[href='#{user_path(admin_user)}']", admin_user.name
        User.all.each do |u|
          assert_select 'td', u.name
          assert_select 'td', u.email
          assert_select 'td', u.token
          assert_select "a[href='#{user_path(admin_user)}']", 'Delete'
        end
      end
    end
  end
end
