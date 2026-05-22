require 'swagger_helper'

RSpec.describe 'api/registration', type: :request do
  describe 'Signup API' do
    path '/signup' do
      post 'Creates a user account' do
        tags 'User'
        consumes 'application/json'
        parameter name: 'user', in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string },
                password_confirmation: { type: :string }
              },
              required: [ 'email', 'password', 'password_confirmation' ]
            }
          },
          required: [ 'user' ]
        }

        request_body_example(
          value: {
            user: {
              email: 'test@dev.dev',
              password: 'password',
              password_confirmation: 'password'
            }
          },
          name: 'valid_signup',
          summary: 'Valid payload from create user login'
        )

        response '200', 'created user' do
          schema type: :object,
            properties: {
              status: {
                type: :object,
                properties: {
                  code: { type: :integer },
                  message: { type: :string }
                },
                required: [ 'code', 'message' ]
              },
              data: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  email: { type: :string },
                  created_at: { type: :string, format: :'date-time' },
                  created_date: { type: :string }
                },
                required: [ 'id', 'email', 'created_at', 'created_date' ]
              }
            },
            required: [ 'status', 'data' ]

          example 'application/json', :created_user, {
            status: {
              code: 200,
              message: 'Signed up sucessfully.'
            },
            data: {
              id: 1,
              email: 'test@dev.com',
              created_at: '2026-05-22T17:54:05.335Z',
              created_date: '22 05, 2026'
            }
          }

          let(:user) { { user: attributes_for(:user) } }
          run_test!
        end

        response '422', 'email already exists' do
          schema type: :object,
            properties: {
              status: {
                type: :object,
                properties: {
                  message: { type: :string }
                },
                required: [ 'message' ]
              }
            },
            required: [ 'status' ]

            example 'application/json', :invalid_email, {
            status: {
              message: "User couldn't be created successfully. Email has already been taken"
            }
          }

          let(:existing_user) { create(:user) }
          let!(:user) { { user: attributes_for(:user, email: existing_user.email) } }
          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body).to have_key('status')
            expect(body['status']['message']).to include("Email has already been taken")
          end
        end
      end
    end
  end
end
