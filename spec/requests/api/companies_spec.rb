require 'rails_helper'

describe Api::CompaniesController, type: :request do
  describe "POST /companies" do
    subject { post api_companies_path, params: { company: params } }

    context "with valid parameters" do
      let(:params) { { code: 'test' } }

      it "creates a new Company" do
        expect { subject }.to change(Company, :count).by(1)
      end

      it "renders a JSON response with the new company" do
        subject
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)).to include params.as_json
      end
    end

    context "with invalid parameters" do
      context "when code is blank" do
        let(:params) { { code: nil } }

        it "does not create a new Company" do
          expect { subject }.to change(Company, :count).by(0)
        end

        it "renders a JSON response with errors for the new company" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to eq({ code: ["can't be blank", "is invalid"] }.to_json)
        end
      end

      context "when code is already taken" do
        let(:params) { { code: 'test' } }
        before { create(:company, code: 'test') }

        it "does not create a new Company" do
          expect { subject }.to change(Company, :count).by(0)
        end

        it "renders a JSON response with errors for the new company" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to eq({ code: ["has already been taken"] }.to_json)
        end
      end

      context "when code is too long" do
        let(:params) { { code: 'a' * 51 } }

        it "does not create a new Company" do
          expect { subject }.to change(Company, :count).by(0)
        end

        it "renders a JSON response with errors for the new company" do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
          expect(response.body).to eq({ code: ["is too long (maximum is 50 characters)"] }.to_json)
        end
      end
    end
  end

  describe "DELETE /companies/1" do
    let(:company) { create(:company) }

    before do
      create(:user, company: company)
      create(:group, company: company)
    end

    subject { delete api_company_path(company) }

    it "destroys the company" do
      expect { subject }.to change(Company, :count).by(-1)
    end

    it "renders a JSON response with the destroyed company" do
      subject
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to match(a_string_including("application/json"))
      expect(JSON.parse(response.body)).to include company.as_json
    end

    it "destroys the company's employees and groups" do
      subject
      expect(company.employees).to be_empty
      expect(company.groups).to be_empty
    end
  end
end
