class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :commenter
      t.text :body
      t.integer :likes, :default => 0
      t.references :user, foreign_key: { to_table: 'users' }
      t.references :publish, foreign_key: { to_table: 'publishes' }

      t.timestamps
    end
  end
end
