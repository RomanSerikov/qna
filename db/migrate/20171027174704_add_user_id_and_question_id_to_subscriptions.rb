class AddUserIdAndQuestionIdToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :subscriptions, :user, index: true
    add_belongs_to :subscriptions, :question, index: true
  end
end
