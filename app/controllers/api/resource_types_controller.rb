class Api::ResourceTypesController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:index]

  def index
    @resource_types = ResourceType.where.not(id: 0).all
  end

  def create
  end
end
