class AddUserIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :questions, :user
  end
end
