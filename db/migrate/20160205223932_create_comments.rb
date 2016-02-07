class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.belongs_to :commentable, index: true
      t.string :commentable_type
      t.timestamps null: false
    end
  end
end
