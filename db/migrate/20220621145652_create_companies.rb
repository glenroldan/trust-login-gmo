class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :code, null: false, index: true, unique: true, limit: 50
      t.timestamps
    end
  end
end
