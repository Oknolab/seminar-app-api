class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password

      t.timestamps
    end

    add_index :users, :email, unique: true #emailの重複を許さない
  end
end
