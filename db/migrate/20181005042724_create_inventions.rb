class CreateInventions < ActiveRecord::Migration[5.2]
  def change
    create_table :inventions do |t|
      t.string :title, :null => false, limit: 255
      t.text :description, :null => false
      t.string :user_name, limit: 255
      t.string :user_email, limit: 255
      t.text :bits, array:true, default: [], :null => false
      t.text :materials

      t.timestamps
    end
    add_index :inventions, :title, unique: true
    add_index :inventions, :user_email
  end
end
