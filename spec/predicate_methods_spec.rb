require 'spec_helper'

describe "default behavior of flexible_enum" do
  it "adds default predicates that indicate the current value" do
    register = CashRegister.new
    register.status = CashRegister::ACTIVE
    expect(register).to_not be_unknown
    expect(register).to_not be_not_active
    expect(register).to be_active
  end

  it "adds predicates that indicate the negation of the current value" do
    register = CashRegister.new
    register.status = CashRegister::UNKNOWN
    expect(register).to be_unknown
    expect(register).to_not be_known
    register.status = CashRegister::NOT_ACTIVE
    expect(register).to_not be_unknown
    expect(register).to be_known
  end

  it "does not set a default value" do
    default = CashRegister.new
    expect(default.status).to be_nil
    expect(default).to_not be_unknown
    expect(default).to_not be_not_active
    expect(default).to_not be_active
  end

  it "adds predicates that indicate the current value when namespaced" do
    register = CashRegister.new
    register.drawer_position = CashRegister::DrawerPositions::OPENED
    expect(register).to be_opened
    expect(register).to_not be_closed
    register.drawer_position = CashRegister::DrawerPositions::CLOSED
    expect(register).to_not be_opened
    expect(register).to be_closed
  end
end
