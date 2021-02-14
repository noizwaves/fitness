class CreateExercises < ActiveRecord::Migration[6.1]
  def change
    create_table :exercises do |t|
      t.string :name, null: false, index: { unique: true}
      t.text :instructions, null: false

      t.timestamps
    end
  end
end
