require 'spec_helper'

describe "reflection of attribute options" do
  it "returns a list of possible elements" do
    expect(CashRegister.drawer_positions.collect(&:name)).to eq(["opened", "closed"])
    expect(CashRegister.drawer_positions.collect(&:human_name)).to eq(["Opened", "Closed"])
    expect(CashRegister.drawer_positions.collect(&:value)).to eq([0, 1])
  end

  it "finds the element metadata for the option provided by symbol" do
    opened = CashRegister.drawer_positions_by_sym[:opened]
    expect(opened.name).to       eq("opened")
    expect(opened.human_name).to eq("Opened")
    expect(opened.value).to      eq(0)

    closed = CashRegister.drawer_positions_by_sym[:closed]
    expect(closed.name).to       eq("closed")
    expect(closed.human_name).to eq("Closed")
    expect(closed.value).to      eq(1)
  end

  it "finds the value corresponding to the option provided by its value" do
    expect(CashRegister.status_value_for(CashRegister::ACTIVE)).to eq(CashRegister::ACTIVE)
  end

  it "finds the value corresponding to the option name provided as a string" do
    expect(CashRegister.status_value_for("active")).to eq(CashRegister::ACTIVE)
    expect(CashRegister.status_value_for("ACTIVE")).to eq(CashRegister::ACTIVE)
    expect(CashRegister.manufacturer_value_for("honeywell")).to eq("HON")
  end

  it "finds the value for a given option name provided as a symbol" do
    expect(CashRegister.status_value_for(:active)).to eq(CashRegister::ACTIVE)
    expect(CashRegister.drawer_position_value_for(:opened)).to eq(CashRegister::DrawerPositions::OPENED)
  end

  it "raises an exception for invalid options" do
    expect { CashRegister.status_value_for(666) }.to raise_error("Unknown enumeration element: 666")
    expect { CashRegister.status_value_for("bad_string") }.to raise_error("Unknown enumeration element: bad_string")
    expect { CashRegister.status_value_for(:bad_symbol) }.to raise_error("Unknown enumeration element: bad_symbol")
  end
end
