require "rails_helper"

describe Api::UsersController, type: :routing do
  describe "routing" do
    it "routes to #assign_group" do
      expect(post: "/api/users/1/group/1").to route_to("api/users#assign_group", user_id: "1", group_id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/users").to route_to("api/users#create")
    end
  end
end
