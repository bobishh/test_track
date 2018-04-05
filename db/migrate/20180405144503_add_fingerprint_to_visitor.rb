class AddFingerprintToVisitor < ActiveRecord::Migration[5.0]
  def change
    add_column :visitors, :fingerprint, :string, index: true
  end
end
