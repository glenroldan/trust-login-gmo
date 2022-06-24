class Api::Company::GroupsController < Api::ApplicationController
  # GET /companies/:company_id/groups
  def index
    company = Company.find(params[:company_id])
    json = company.groups.includes(:users).as_json(
      only: [:id, :name],
      methods: [:users_count]
    )

    render json: json, status: :ok
  end

  # POST /companies/:company_id/groups
  def create
    group = Group.new(group_params)

    if group.save
      render json: group, status: :created
    else
      render json: group.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def group_params
      params.permit(:company_id, :name)
    end
end
