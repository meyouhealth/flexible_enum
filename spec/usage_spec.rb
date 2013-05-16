require 'spec_helper'

class CashRegister
  include FlexibleEnum::Mixin

  attr_accessor :status, :drawer_position

  flexible_enum :status do
    unknown    0,  :inverse => :known
    not_active 10, :my_custom_option => "Nothing to see here"
    active     20
    alarm      21, :human_name => "Help I'm being robbed!"
  end

  flexible_enum :drawer_position, :namespace => "DrawerPositions" do
    opened 0, :setter => :open!
    closed 1, :setter => :close!
  end
end

class NotACashRegister
  include FlexibleEnum::Mixin

  attr_accessor :status

  flexible_enum :status do
    unknown    12
  end
end

describe "the usage of flexible_enum without a namespace" do
  it "should set constants for each element" do
    CashRegister::UNKNOWN.should    == 0
    CashRegister::NOT_ACTIVE.should == 10
    CashRegister::ACTIVE.should     == 20
    CashRegister::ALARM.should      == 21
  end

  it "should retrieve the human name of the current value" do
    CashRegister.new.tap {|r| r.status = CashRegister::UNKNOWN    }.human_status.should == "Unknown"
    CashRegister.new.tap {|r| r.status = CashRegister::NOT_ACTIVE }.human_status.should == "Not active"
    CashRegister.new.tap {|r| r.status = CashRegister::ACTIVE     }.human_status.should == "Active"
    CashRegister.new.tap {|r| r.status = CashRegister::ALARM      }.human_status.should == "Help I'm being robbed!"
  end

  it "should retrieve human names for known constants" do
    CashRegister.human_status(CashRegister::UNKNOWN).should    == "Unknown"
    CashRegister.human_status(CashRegister::NOT_ACTIVE).should == "Not active"
    CashRegister.human_status(CashRegister::ACTIVE).should     == "Active"
    CashRegister.human_status(CashRegister::ALARM).should      == "Help I'm being robbed!"
  end

  it "should respond to questions" do
    unknown    = CashRegister.new.tap {|r| r.status = CashRegister::UNKNOWN }
    not_active = CashRegister.new.tap {|r| r.status = CashRegister::NOT_ACTIVE }
    active     = CashRegister.new.tap {|r| r.status = CashRegister::ACTIVE }
    alarm      = CashRegister.new.tap {|r| r.status = CashRegister::ALARM }

    unknown.should        be_unknown
    unknown.should_not    be_known
    unknown.should_not    be_not_active
    unknown.should_not    be_active
    unknown.should_not    be_alarm

    not_active.should_not be_unknown
    not_active.should     be_known
    not_active.should     be_not_active
    not_active.should_not be_active
    not_active.should_not be_alarm

    active.should_not     be_unknown
    active.should         be_known
    active.should_not     be_not_active
    active.should         be_active
    active.should_not     be_alarm

    alarm.should_not      be_unknown
    alarm.should          be_known
    alarm.should_not      be_not_active
    alarm.should_not      be_active
    alarm.should          be_alarm
  end

  it "should have bang setters" do
    CashRegister.new.tap {|r| r.should_receive(:update_attribute).with(:status, 0)  }.unknown!
    CashRegister.new.tap {|r| r.should_receive(:update_attribute).with(:status, 10) }.not_active!
    CashRegister.new.tap {|r| r.should_receive(:update_attribute).with(:status, 20) }.active!
    CashRegister.new.tap {|r| r.should_receive(:update_attribute).with(:status, 21) }.alarm!
  end

  it "should build scopes for each element" do
    CashRegister.should_receive(:where).with(:status => 0).and_return("unknowns")
    CashRegister.should_receive(:where).with(:status => 10).and_return("not actives")
    CashRegister.should_receive(:where).with(:status => 20).and_return("actives")
    CashRegister.should_receive(:where).with(:status => 21).and_return("alarms")
    CashRegister.unknown.should == "unknowns"
    CashRegister.not_active.should == "not actives"
    CashRegister.active.should == "actives"
    CashRegister.alarm.should == "alarms"
  end

  it "should return a list of possible elements" do
    CashRegister.statuses[0].tap do |unknown_element|
      unknown_element.name.should       == "unknown"
      unknown_element.human_name.should == "Unknown"
      unknown_element.value.should      == 0
    end
    CashRegister.statuses[1].tap do |not_active_element|
      not_active_element.name.should       == "not_active"
      not_active_element.human_name.should == "Not active"
      not_active_element.value.should      == 10
    end
    CashRegister.statuses[2].tap do |active_element|
      active_element.name.should       == "active"
      active_element.human_name.should == "Active"
      active_element.value.should      == 20
    end
    CashRegister.statuses[3].tap do |alarm_element|
      alarm_element.name.should       == "alarm"
      alarm_element.human_name.should == "Help I'm being robbed!"
      alarm_element.value.should      == 21
    end
  end

  it "should store and provide access to any custom options that are passed in during creation" do
    CashRegister.statuses[1][:my_custom_option].should == "Nothing to see here"
  end 
end

describe "the usage of flexible_enum when specifying a namespace" do
  it "should set constants for each element" do
    CashRegister::DrawerPositions::OPENED.should == 0
    CashRegister::DrawerPositions::CLOSED.should == 1
  end

  it "should retrieve the human name of the current value" do
    CashRegister.new.tap {|r| r.drawer_position = CashRegister::DrawerPositions::OPENED }.human_drawer_position.should == "Opened"
    CashRegister.new.tap {|r| r.drawer_position = CashRegister::DrawerPositions::CLOSED }.human_drawer_position.should == "Closed"
  end

  it "should retrieve human names for known constants" do
    CashRegister.human_drawer_position(CashRegister::DrawerPositions::OPENED).should == "Opened"
    CashRegister.human_drawer_position(CashRegister::DrawerPositions::CLOSED).should == "Closed"
  end

  it "should respond to questions" do
    CashRegister.new.tap {|r| r.drawer_position = CashRegister::DrawerPositions::OPENED }.should be_opened
    CashRegister.new.tap {|r| r.drawer_position = CashRegister::DrawerPositions::CLOSED }.should be_closed
  end

  it "should have bang setters" do
    CashRegister.new.tap {|r| r.should_receive(:update_attribute).with(:drawer_position, 0) }.open!
    CashRegister.new.tap {|r| r.should_receive(:update_attribute).with(:drawer_position, 1) }.close!
  end

  it "should build scopes with prefixed names for each element" do
    CashRegister.should_receive(:where).with(:drawer_position => 0).and_return("openeds")
    CashRegister.should_receive(:where).with(:drawer_position => 1).and_return("closeds")
    CashRegister.drawer_position_opened.should == "openeds"
    CashRegister.drawer_position_closed.should == "closeds"
  end

  it "should return a list of possible elements" do
    CashRegister.drawer_positions[0].tap do |opened_element|
      opened_element.name.should       == "opened"
      opened_element.human_name.should == "Opened"
      opened_element.value.should      == 0
    end
    CashRegister.drawer_positions[1].tap do |closed_element|
      closed_element.name.should       == "closed"
      closed_element.human_name.should == "Closed"
      closed_element.value.should      == 1
    end
  end

  it "should return a hash of possible elements" do
    CashRegister.drawer_positions_by_sym[:opened].tap do |opened_element|
      opened_element.name.should       == "opened"
      opened_element.human_name.should == "Opened"
      opened_element.value.should      == 0 
    end
    CashRegister.drawer_positions_by_sym[:closed].tap do |closed_element|
      closed_element.name.should       == "closed"
      closed_element.human_name.should == "Closed"
      closed_element.value.should      == 1
    end
  end

  it "should return the constant for a given symbol, string, or integer" do
    CashRegister.status_const_for(:active).should == CashRegister::ACTIVE
    CashRegister.status_const_for("active").should == CashRegister::ACTIVE
    CashRegister.status_const_for("ACTIVE").should == CashRegister::ACTIVE
    CashRegister.status_const_for(CashRegister::ACTIVE).should == CashRegister::ACTIVE
    expect { CashRegister.status_const_for(:bad_symbol) }.to raise_error("Unknown enumeration element: bad_symbol")
    CashRegister.drawer_position_const_for(:opened).should == CashRegister::DrawerPositions::OPENED
  end
end
