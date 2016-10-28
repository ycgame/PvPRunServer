require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'POST /users', autodoc: true do
    it 'Create user' do
      post :create, name: 'test1'
      expect(response).to have_http_status(200)
    end
  end
end
