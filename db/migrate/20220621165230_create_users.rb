class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.references :company, null: false, foreign_key: true
      t.string :email, null: false
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.integer :age, null: false
      t.timestamps
    end

    add_index :users, [:company_id, :email], unique: true
  end
end
