class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.string :email
      t.string :kind
      t.integer :number

      t.timestamps
    end
  end
end
