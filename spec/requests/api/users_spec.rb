require 'rails_helper'

describe Api::UsersController, type: :request do
  let!(:company) { create(:company) }

  describe "POST /users" do
    let(:first_name) { Faker::Name.first_name }
    let(:last_name) { Faker::Name.last_name }
    let(:age) { Faker::Number.between(from: 18, to: 65) }
    let(:email) { Faker::Internet.email }
    let(:company_id) { company.id }
    let(:params) do
      {
        first_name: first_name,
        last_name: last_name,
        age: age,
        email: email,
        company_id: company_id,
      }
    end

    subject { post api_users_path, params: { user: params } }

    context "with valid parameters" do
      it "creates a new User" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "renders a JSON response with the new user" do
        subject
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)).to include params.as_json
      end
    end

    context "with invalid parameters" do
      context "when first_name is not present" do
        let(:first_name) { nil }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "first_name" => ["can't be blank"]
        end
      end

      context "when first_name is too long" do
        let(:first_name) { "a" * 51 }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "first_name" => ["is too long (maximum is 50 characters)"]
        end
      end

      context "when last_name is not present" do
        let(:last_name) { nil }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "last_name" => ["can't be blank"]
        end
      end

      context "when last_name is too long" do
        let(:last_name) { "a" * 51 }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "last_name" => ["is too long (maximum is 50 characters)"]
        end
      end

      context "when age is not present" do
        let(:age) { nil }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "age" => ["can't be blank", "is not a number"]
        end
      end

      context "when age is less than 18" do
        let(:age) { Faker::Number.between(from: 0, to: 17) }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "age" => ["must be greater than 17"]
        end
      end

      context "when email is not present" do
        let(:email) { nil }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "email" => ["can't be blank", "is invalid"]
        end
      end

      context "when email is invalid" do
        let(:email) { "invalid_email" }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "email" => ["is invalid"]
        end
      end

      context "when company_id is not present" do
       let(:company_id) { nil }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "company" => ["must exist"]
        end
      end

      context "when company have already 10 users" do
        before { create_list(:user, 10, company: company) }

        it "does not create a new User" do
          expect { subject }.not_to change(User, :count)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "company" => ["cannot have more than 10 users."]
        end
      end
    end
  end

  describe "POST /users/:user_id/groups/:group_id" do
    let!(:group) { create(:group, company: company) }
    let!(:user) { create(:user, company: company) }

    subject { post assign_api_user_group_path(user_id: user.id, group_id: group.id) }

    context "with valid parameters" do
      it "assigns the user to the group" do
        expect { subject }.to change { group.users.count }.by(1)
          .and change { user.reload.group}.to(group)
      end

      it "renders a JSON response with the user" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["group_id"]).to eq group.id
      end
    end

    context "with invalid parameters" do
      context "when group is on another company" do
        let(:group) { create(:group) }

        it "does not assign the user to the group" do
          expect { subject }.not_to change { group.users.count }
          expect { subject }.not_to change { user.reload.group}.from(nil)
        end

        it "renders a JSON response with errors" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(JSON.parse(response.body)).to include "group" => "not found"
        end
      end
    end
  end
end
