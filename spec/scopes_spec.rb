require 'spec_helper'

describe "scopes" do
  it "builds scopes for each element" do
    CashRegister.should_receive(:where).with(status: 0).and_return("unknowns")
    CashRegister.should_receive(:where).with(status: 10).and_return("not actives")
    CashRegister.should_receive(:where).with(status: 20).and_return("actives")
    CashRegister.should_receive(:where).with(status: 21).and_return("alarms")
    expect(CashRegister.unknown).to eq("unknowns")
    expect(CashRegister.not_active).to eq("not actives")
    expect(CashRegister.active).to eq("actives")
    expect(CashRegister.alarm).to eq("alarms")
  end

  it "builds scopes with prefixed names for each namespaced element" do
    CashRegister.should_receive(:where).with(drawer_position: 0).and_return("openeds")
    CashRegister.should_receive(:where).with(drawer_position: 1).and_return("closeds")
    expect(CashRegister.drawer_position_opened).to eq("openeds")
    expect(CashRegister.drawer_position_closed).to eq("closeds")
  end
end
