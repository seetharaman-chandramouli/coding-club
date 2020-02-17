class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
    	t.integer :following_id
    	t.integer :follower_id
    end
  end
end
