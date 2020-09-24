Sequel.migration do
  up do
    create_table(:todos) do
      Integer :id, primary_key: true, autoincrement: true
      String :description, null: false
      TrueClass :completed, null: false
    end
  end
  
  down do
    drop_table(:todos)
  end
end