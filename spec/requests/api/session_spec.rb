require 'swagger_helper'

RSpec.describe 'api/session', type: :request do
  describe 'Login API' do
    path '/login' do
      post 'Authenticates an existing user account' do
        tags 'User'
        consumes 'application/json'
        parameter name: 'user', in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                email: { type: :string },
                password: { type: :string }
              },
              required: [ 'email', 'password' ]
            }
          },
          required: [ 'user' ]
        }

        request_body_example(
          value: {
            user: {
              email: 'teste@dev.dev',
              password: 'password'
            }
          },
          name: 'valid_login',
          summary: 'Valid payload from login'
        )

        let!(:registered_user) { create(:user) }

        response '200', 'authenticated user' do
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

          example 'application/json', :login_sucess, {
            status: {
              code: 200,
              message: 'Logged in sucessfully.'
            },
            data: {
              id: 1,
              email: 'test@dev.com',
              created_at: '2026-05-22T17:54:05.335Z',
              created_date: '22 05, 2026'
            }
          }

          let(:user) do
            {
              user: {
                email: registered_user.email,
                password: registered_user.password
              }
            }
          end
          run_test!
        end

        response '401', 'invalid password' do
          schema type: :string

          example 'text/plain', :invalid_password, "Invalid email or password."

          let(:user) do
            {
              user: {
                email: registered_user.email,
                password: 'password1234'
              }
            }
          end
          run_test! do |response|
            expect(response).to have_http_status(401)
            expect(response.body).to include("Invalid email or password.")
          end
        end
      end
    end

    path "/logout" do
      delete "Log out an authenticated user" do
        tags 'User'
        produces 'application/json'
        parameter name: :Authorization,
              in: :header,
              type: :string,
              required: true,
              description: 'Bearer JWT token'

        let!(:registered_user) { create(:user) }

        response '200', 'Logged out sucessfully' do
          schema type: :object,
            properties: {
              status: {
                type: :object,
                properties: {
                  code: { type: :integer },
                  message: { type: :string }
                },
                required: [ 'code', 'message' ]
              }
            },
            required: [ 'status' ]

          example 'application/json', :logout_sucess, {
              status: {
                code: 200,
                message: "logged out successfully"
              }
            }

          let(:Authorization) do
            post '/login', params: {
              user: {
                email: registered_user.email,
                password: registered_user.password
              }
            }

            response.headers['Authorization']
          end

        run_test!
        end

        response '401', 'missing authorization token in request' do
          schema type: :object,
            properties: {
              status: {
                type: :object,
                properties: {
                  code: { type: :integer },
                  message: { type: :string }
                },
                required: [ 'code', 'message' ]
              }
            },
            required: [ 'status' ]

          example 'application/json', :logout_sucess, {
              status: {
                code: 401,
                message: "Couldn't find an active session."
              }
            }

          let(:Authorization) { nil }

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body).to have_key('status')
            expect(body['status']['message']).to include("Couldn't find an active session.")
          end
        end
      end
    end

    path '/current_user' do
      get 'Retrives current authenticated user' do
        tags 'User'
        produces 'application/json'
        parameter name: :Authorization,
              in: :header,
              type: :string,
              required: true,
              description: 'Bearer JWT token'

        let!(:registered_user) { create(:user) }

        response '200', 'Logged out sucessfully' do
          schema type: :object,
            properties: {
                  id: { type: :integer },
                  email: { type: :string },
                  created_at: { type: :string, format: :'date-time' },
                  created_date: { type: :string }
                },
                required: [ 'id', 'email', 'created_at', 'created_date' ]

          example 'application/json', :current_user, {
              id: 1,
              email: 'test@dev.com',
              created_at: '2026-05-22T17:54:05.335Z',
              created_date: '22 05, 2026'
            }

          let(:Authorization) do
            post '/login', params: {
              user: {
                email: registered_user.email,
                password: registered_user.password
              }
            }

            response.headers['Authorization']
          end

        run_test!
        end

        response '401', 'missing authorization token in request' do
          schema type: :string

          example 'text/plain', :missing_token, "You need to sign in or sign up before continuing."

          let(:Authorization) { nil }

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body).to have_key('status')
            expect(body['status']['message']).to include("You need to sign in or sign up before continuing.")
          end
        end
      end
    end
  end
end
