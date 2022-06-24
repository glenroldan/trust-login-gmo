require 'rails_helper'

describe Api::Company::GroupsController, type: :request do
  let!(:company) { create(:company) }

  describe "POST /companies/:company_id/groups" do
    subject { post api_company_groups_path(company.id), params: params }

    context "with valid parameters" do
      let(:params) { { name: 'test' } }

      it "creates a new Group" do
        expect { subject }.to change(Group, :count).by(1)
      end

      it "renders a JSON response with the new group" do
        subject
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)).to include params.as_json
      end
    end

    context "with invalid parameters" do
      context "when name is blank" do
        let(:params) { { name: nil } }

        it "does not create a new Group" do
          expect { subject }.to change(Group, :count).by(0)
        end

        it "renders a JSON response with errors for the new group" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to eq({ name: ["can't be blank"] }.to_json)
        end
      end

      context "when name is too long" do
        let(:params) { { name: 'a' * 101 } }

        it "does not create a new Group" do
          expect { subject }.to change(Group, :count).by(0)
        end

        it "renders a JSON response with errors for the new group" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to eq({ name: ["is too long (maximum is 100 characters)"] }.to_json)
        end
      end

      context "when name is already taken" do
        context "when same company" do
          let(:params) { { name: 'test' } }
          before { create(:group, company: company, name: 'test') }

          it "does not create a new Group" do
            expect { subject }.to change(Group, :count).by(0)
          end

          it "renders a JSON response with errors for the new group" do
            subject
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to match(a_string_including("application/json"))
            expect(response.body).to eq({ name: ["has already been taken"] }.to_json)
          end
        end
      end
    end
  end

  describe "GET /companies/:company_id/groups" do
    subject { get api_company_groups_path(company.id) }

    context "with group" do
      let(:group) { create(:group, company: company) }

      before { create_list(:user, 2, company: company, group: group) }

      it "renders a JSON response with the groups" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to eq [{
          id: group.id,
          name: group.name,
          users_count: 2
        }].to_json
      end
    end

    context "with no group exists" do
      it "renders a JSON response with an empty array" do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response.body).to eq [].to_json
      end
    end
  end
end
