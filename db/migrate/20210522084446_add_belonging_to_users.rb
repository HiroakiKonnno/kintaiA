class AddBelongingToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :belonging, :string
  end
end
