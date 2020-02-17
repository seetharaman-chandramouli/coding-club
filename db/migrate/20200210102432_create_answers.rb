class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
    	t.integer :ques_id 
		t.string :answer 
		t.integer :user_id
		t.integer :vote_count, default: 0
		t.integer :vote
		t.timestamps
    end
  end
end
