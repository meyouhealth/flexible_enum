require 'spec_helper'

describe "identity values" do
  it "retrieves the details for the current value" do
    register = CashRegister.new
    register.status = CashRegister::NOT_ACTIVE

    expect(register.status_details).to eq(my_custom_option: "Nothing to see here", value: 10)
  end

  it "retrieves the name for the current value" do
    register = CashRegister.new
    register.status = CashRegister::UNKNOWN
    expect(register.status_name).to eq("unknown")
    register.status = CashRegister::NOT_ACTIVE
    expect(register.status_name).to eq("not_active")
    register.status = nil
    expect(register.status_name).to be_nil
  end

  it "retrieves the human name of the current value" do
    register = CashRegister.new
    register.status = CashRegister::UNKNOWN
    expect(register.human_status).to eq("Unknown")
    register.status = CashRegister::NOT_ACTIVE
    expect(register.human_status).to eq("Not active")
    register.status = nil
    expect(register.human_status).to be_nil
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
