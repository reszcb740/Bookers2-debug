class RemoveUsrIdFromBookComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :book_comments, :usr_id, :integer
  end
end
