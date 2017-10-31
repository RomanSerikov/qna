class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question_id: params[:question])
    respond_with(@subscription)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    respond_with(@subscription.destroy)
  end
end
