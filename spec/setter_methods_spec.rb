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

    before do
      Time.stub(:now).and_return(now)
      register.stub(:update_attributes) { |attributes| updates << attributes }
    end

    it "immediately dispatches a validation-free update" do
      register.active!
      register.close!
      expect(updates).to eq([{status: 20}, {drawer_position: 1}])
    end

    it "updates matching timestamp columns with the current date and time" do
      register.fill!
      register.empty!
      expect(updates).to eq([{ status: 22, fill_at: now.utc }, { status: 23, emptied_on: now.utc.to_date, emptied_at: now.utc }])
    end
  end
end
