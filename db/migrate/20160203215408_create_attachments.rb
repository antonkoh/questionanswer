class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :question_id, index:true

      t.timestamps null: false
    end
  end
end
