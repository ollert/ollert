Sequel.migration do
  up do
    drop_table :boards
  end

  down do
    create_table(:boards) do
      primary_key :id
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      String :trello_id
    end
  end
end
