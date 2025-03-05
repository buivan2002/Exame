class CreateCharts < ActiveRecord::Migration[7.0]
  def change
    create_table :charts do |t|
      t.string :name
      t.string :email
      t.integer :age

      t.timestamps
    end
  end
end
