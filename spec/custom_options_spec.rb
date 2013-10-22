require 'spec_helper'

describe "custom options" do
  it "records unknown options for client recall" do
    expect(CashRegister.statuses[1][:my_custom_option]).to eq("Nothing to see here")
  end
end
