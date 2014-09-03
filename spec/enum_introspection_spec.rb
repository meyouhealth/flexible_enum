require "spec_helper"

describe "target class exposing flexible_enums" do
  it "allows consumers to find all defined flexible_enums" do
    expect(CashRegister.flexible_enums[:status].keys).to eq([:unknown, :not_active, :active, :alarm, :fill, :empty])
    expect(CashRegister.flexible_enums[:drawer_position].keys).to eq([:opened, :closed])
    expect(CashRegister.flexible_enums[:manufacturer].keys).to eq([:honeywell, :sharp])
  end
end
