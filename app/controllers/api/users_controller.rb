class Api::UsersController < Api::ApplicationController
  # POST /users
  def create
    user = User.new(user_params)

    return render json: user, status: :created if user.save

    if user.errors[:age].present? && user.errors.map(&:type).include?(:greater_than)
      render json: { age: user.errors[:age] }, status: :bad_request
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # POST /users/:user_id/groups/:group_id
  def assign_group
    user = User.find(params[:user_id])
    group = user.company.groups.find_by(id: params[:group_id])

    return render json: { group: "not found" }, status: :unprocessable_entity unless group

    user.group = group

    if user.save
      render json: user, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:company_id, :first_name, :last_name, :age, :email)
    end
end
