Sequel.migration do
  change do
    alter_table(:users) do
      add_column :trello_name, String
    end
  end 
end
