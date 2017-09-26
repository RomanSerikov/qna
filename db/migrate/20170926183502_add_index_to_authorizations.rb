class AddIndexToAuthorizations < ActiveRecord::Migration[5.1]
  def change
    add_index :authorizations, [:provider, :uid]
  end
end
