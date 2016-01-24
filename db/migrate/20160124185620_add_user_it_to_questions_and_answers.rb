class AddUserItToQuestionsAndAnswers < ActiveRecord::Migration
  def change
    change_table :answers  do |t|
      t.belongs_to :user, index:true, foreign_key: true
    end
    change_table :questions do |t|
      t.belongs_to :user, index:true, foreign_key: true
    end
  end
end
