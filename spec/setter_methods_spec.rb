require 'spec_helper'

describe "setter methods" do
  subject(:register) { CashRegister.new }

  it "adds default bang methods for setting a new value" do
    expect(register.status).to be_nil
    register.active!
    expect(register.status).to eq(20)
    register.not_active!
    expect(register.status).to eq(10)
  end

  it "adds custom bang methods for setting a new value" do
    expect(register.drawer_position).to be_nil
    register.open!
    expect(register.drawer_position).to eq(0)
    register.close!
    expect(register.drawer_position).to eq(1)
  end

  describe "updating database" do
    let!(:now) { Time.now }
    let(:updates) { [] }

    before { allow(Time).to receive(:now).and_return(now) }

    it "immediately dispatches a validation-free update" do
      register.active!
      register.close!

      expect(register).to be_active
      expect(register).to be_closed
    end

    it "updates default timestamp columns with the current date and time" do
      register.fill!
      expect(register).to be_full
      expect(register.full_at).to eq(now)
    end

    it "updates custom timestamp columns with the current date and time" do
      register.empty!
      expect(register).to be_empty
      expect(register.emptied_at).to eq(now)
    end
  end
end
