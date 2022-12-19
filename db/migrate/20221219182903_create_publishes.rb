class CreatePublishes < ActiveRecord::Migration[7.0]
  def change
    create_table :publishes do |t|
      t.string :title
      t.text :content
      t.timestamp :published_at
      t.integer :likes, :default => 0
      t.integer :dislikes, :default => 0
      t.references :user, null: false, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
