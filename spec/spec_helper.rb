require 'flexible_enum'
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table "cash_registers" do |t|
    t.integer  "status"
    t.datetime "emptied_at"
    t.datetime "emptied_on"
    t.datetime "fill_at"
    t.string   "manufacturer"
    t.integer  "drawer_position"
  end
end

class CashRegister < ActiveRecord::Base
  flexible_enum :status do
    unknown    0,  :inverse => :known
    not_active 10, :my_custom_option => "Nothing to see here"
    active     20
    alarm      21, :human_name => "Help I'm being robbed!"
    fill       22
    empty      23, :timestamp_attribute => :emptied
  end

  flexible_enum :drawer_position, :namespace => "DrawerPositions" do
    opened 0, :setter => :open!
    closed 1, :setter => :close!
  end

  flexible_enum :manufacturer do
    honeywell "HON"
    sharp "SHCAY"
  end
end
