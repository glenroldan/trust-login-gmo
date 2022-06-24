class AddGroupToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :group, foreign_key: true, after: :company_id
  end
end
