Sequel.migration do
  change do
    alter_table(:users) do
      add_column :membership_type, String
    end
  end 
end
