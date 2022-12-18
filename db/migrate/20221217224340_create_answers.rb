class CreateAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :answers do |t|
      t.string :input
      t.string :output

      t.timestamps
    end
    add_index :answers, :input, unique: true
  end
end
