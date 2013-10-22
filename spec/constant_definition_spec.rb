require 'spec_helper'

describe "constant definition" do
  it "sets constants for each value choice" do
    expect(CashRegister::UNKNOWN).to    eq(0)
    expect(CashRegister::NOT_ACTIVE).to eq(10)
    expect(CashRegister::ACTIVE).to     eq(20)
    expect(CashRegister::HONEYWELL).to  eq("HON")
    expect(CashRegister::SHARP).to      eq("SHCAY")
  end

  it "sets constants for each namespaced attribute value choice" do
    expect(CashRegister::DrawerPositions::OPENED).to eq(0)
    expect(CashRegister::DrawerPositions::CLOSED).to eq(1)
  end
end
