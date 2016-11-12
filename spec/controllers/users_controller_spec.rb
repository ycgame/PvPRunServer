require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'POST /users', autodoc: true do
    it 'Create user' do
      post :create, token: 'dummy'
      expect(response).to have_http_status(403)
    end
  end

  describe 'POST /users', autodoc: true do
    it 'Update name' do
      user = User.create(token: 'dummy')
      post :update_name, token: 'dummy', id: 1, name: 'OK'
      expect(response).to have_http_status(200)
    end
  end
end
