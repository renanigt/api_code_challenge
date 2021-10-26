class CreateDnsRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_records do |t|
      t.string :ip, index: { unique: true }

      t.timestamps
    end
  end
end
