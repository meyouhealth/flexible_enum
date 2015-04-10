require 'spec_helper'

describe "scopes" do
  it "builds scopes for each element" do
    actives = CashRegister.create!(status: CashRegister::ACTIVE)
    alarms = CashRegister.create!(status: CashRegister::ALARM)

    expect(CashRegister.active).to contain_exactly(actives)
    expect(CashRegister.alarm).to contain_exactly(alarms)
    expect(CashRegister.unknown).to be_empty
  end

  it "builds scopes with prefixed names for each namespaced element" do
    opened = CashRegister.new.tap(&:open!)
    closed = CashRegister.new.tap(&:close!)

    expect(CashRegister.drawer_position_opened).to contain_exactly(opened)
    expect(CashRegister.drawer_position_closed).to contain_exactly(closed)
  end
end
