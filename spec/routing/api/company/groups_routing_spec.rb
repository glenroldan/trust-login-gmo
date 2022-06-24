require "rails_helper"

describe Api::Company::GroupsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/companies/1/groups").to route_to("api/company/groups#index", company_id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/companies/1/groups").to route_to("api/company/groups#create", company_id: "1")
    end
  end
end
