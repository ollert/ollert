Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :email
      String :password
      String :member_token
    end

    create_table(:boards) do
      primary_key :id
      foreign_key :user_id, :users, :null=>false, :key=>[:id]
      String :trello_id
    end
  end
end
