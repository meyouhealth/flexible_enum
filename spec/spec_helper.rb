require 'flexible_enum'

class FakeActiveRecord
  include FlexibleEnum::Mixin

  def update_attributes(attributes)
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  class << self
    alias_method :attribute_method?, :method_defined?
  end
end

class CashRegister < FakeActiveRecord
  attr_accessor :status, :drawer_position, :fill_at, :emptied_at, :emptied_on, :manufacturer

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
