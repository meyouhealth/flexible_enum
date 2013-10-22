require 'spec_helper'

describe "humanized values" do
  it "retrieves the human name of the current value" do
    register = CashRegister.new
    register.status = CashRegister::UNKNOWN
    expect(register.human_status).to eq("Unknown")
    register.status = CashRegister::NOT_ACTIVE
    expect(register.human_status).to eq("Not active")
  end

  it "retrieves human names for available options" do
    expect(CashRegister.human_status(CashRegister::UNKNOWN)).to eq("Unknown")
    expect(CashRegister.human_status(CashRegister::NOT_ACTIVE)).to eq("Not active")
  end

  it "retrieves custom human names when provided" do
    expect(CashRegister.human_status(CashRegister::ALARM)).to eq("Help I'm being robbed!")
  end

  it "retrieves the human name of the current value of namespaced attributes" do
    opened_register = CashRegister.new.tap {|r| r.drawer_position = CashRegister::DrawerPositions::OPENED }
    closed_register = CashRegister.new.tap {|r| r.drawer_position = CashRegister::DrawerPositions::CLOSED }
    expect(opened_register.human_drawer_position).to eq("Opened")
    expect(closed_register.human_drawer_position).to eq("Closed")
  end

  it "retrieves human names for known constants of namespaced attributes" do
    expect(CashRegister.human_drawer_position(CashRegister::DrawerPositions::OPENED)).to eq("Opened")
    expect(CashRegister.human_drawer_position(CashRegister::DrawerPositions::CLOSED)).to eq("Closed")
  end
end
