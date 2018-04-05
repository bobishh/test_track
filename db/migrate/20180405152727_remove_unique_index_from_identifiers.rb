class RemoveUniqueIndexFromIdentifiers < ActiveRecord::Migration[5.0]
  def up
    remove_index :identifiers, name: :index_identifiers_on_value_and_identifier_type_id
    add_index :identifiers, :value, name: :index_identifiers_on_value
  end

  def down
    add_index :identifiers,
                 [:value, :identifier_type_id],
                 name: :index_identifiers_on_value_and_identifier_type_id
  end
end
