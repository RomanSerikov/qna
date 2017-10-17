class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def index
    @users = User.where.not(id: current_resource_owner)
    respond_with @users
  end
end
