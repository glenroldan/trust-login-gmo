require "rails_helper"

describe Api::CompaniesController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/companies").to route_to("api/companies#create")
    end
  end
end
