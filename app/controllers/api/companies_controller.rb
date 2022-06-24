class Api::CompaniesController < Api::ApplicationController
  # POST /companies
  def create
    company = Company.new(company_params)

    if company.save
      render json: company, status: :created
    else
      render json: company.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    company = Company.find(params[:id])

    # physical deletion of its users and groups
    company.employees.destroy_all
    company.groups.destroy_all
    company.destroy

    render json: company, status: :ok
  end

  private
    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:code)
    end
end
