require 'spec_helper'

describe "inheritance in target class" do
  it "allows calling super from overwritten methods" do
    register = CashRegister.new
    register.honeywell!

    def register.sharp!
      before = manufacturer
      super
      [before, manufacturer]
    end

    expect(register.sharp!).to eq(["HON", "SHCAY"])
  end
end
