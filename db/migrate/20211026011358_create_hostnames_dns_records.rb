class CreateHostnamesDnsRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :dns_records_hostnames do |t|
      t.belongs_to :dns_record, index: true, foreign_key: true
      t.belongs_to :hostname, index: true, foreign_key: true

      t.timestamps
    end
  end
end
