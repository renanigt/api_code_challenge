class CreateHostnames < ActiveRecord::Migration[6.1]
  def change
    create_table :hostnames do |t|
      t.string :hostname, index: { unique: true }

      t.timestamps
    end
  end
end
