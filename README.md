# FlexibleEnum

Give Ruby enum-like powers.

## Installation

Add this line to your application's Gemfile:

    gem "flexible_enum",     git: 'git@github.com:meyouhealth/flexible_enum.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flexible_enum

## Basic Usage

The `flexible_enum` class method is mixed into ActiveRecord::Base. Call it to add enum-like powers to any number of existing attributes on a target class.
You must provide the name of the attribute and a list of available options. Options consist of a name, value, and optional hash of configuration parameters.

```ruby
class User < ActiveRecord::Base
  flexible_enum :status do
    active    0
    disabled  1
    pending   2
  end
end
```

Option values may be any type.

```ruby
class Product < ActiveRecord::Base
  flexible_enum :manufacturer do
    honeywell "HON"
    sharp "SHCAY"
  end
end
```

## Working with Values

Available options for each attribute are defined as constants on the target class. The classes above would have defined:

```ruby
User::ACTIVE        # => 0
User::DISABLED      # => 1
User::PENDING       # => 2
Product::HONEYWELL  # => "HON"
Product::SHARP      # => "SHCAY"
```

## Setter Methods

FlexibleEnum adds convenience methods for changing the current value of an attribute and immediately saving it to the database. By default, bang methods are added for each option:

```ruby
u = User.new
u.active!   # Calls update_attributes(status: 0)
u.disabled! # Calls update_attributes(status: 1)
```

The name of the setter method can be changed using option configuration parameters:

```ruby
class Post < ActiveRecord::Base
  flexible_enum :visibility do
    invisible 0, setter: :hide!
    visible   1, setter: :show!
  end
end

p = Post.new
p.show! # Calls update_attributes(visibility: 1)
p.hide! # Calls update_attributes(visibility: 0)
```

### Timestamps

If the target class defines a date and/or time attribute corresponding to the flexible enum option being set it will be updated with the current date/time when using setter methods. For example, Post#show! above will set `visibility = 1`, `visibile_at = Time.now.utc`, and `visible_on = Time.now.utc.to_date` if those columns exist. The existance of columns is checked using ActiveRecord's `attribute_method?` method.

Use the `:timestamp_attribute` option configuration parameter to change the columns used:

```ruby
flexible_enum :status do
  unknown  0
  active   1, timestamp_attribute: :actived
  disabled 2, timestamp_attribute: :disabled
end
```

Calling `active!` will now attempt to set `actived_at` and `actived_on`.

## Predicate Methods

FlexibleEnum adds convenience methods for checking whether an option's value is also the attribute's current value.

```ruby
p = Post.new
p.show!
p.visible?   # => true
p.invisible? # => false
```

Inverse predicate methods can be added by setting the :inverse configuration parameter. Inverse predicate methods have the reverse logic:

```ruby
class Car < ActiveRecord::Base
  flexible_enum :fuel_type do
    gasoline 0
    diesel   1
    electric 2, inverse: :carbon_emitter
  end
end

c = Car.new
c.gasoline!
c.carbon_emitter? # => true
c.diesel!
c.carbon_emitter? # => true
c.electric!
c.carbon_emitter? # => false
```

## Humanized Values

Humanized versions of attributes are available. This is convenient for displaying the current value on screen (see "Option Reflection" for rendering drop down lists).

```ruby
c = Car.new(fuel_type: Car::DIESEL)
c.human_fuel_type = "Diesel"
Car.human_fuel_type(0) # => "Gasoline"
Car.fuel_types.collect(&:human_name) # => ["Gasoline", "Diesel", "Electric"]
```

If the flexible enum value is `nil`, the humanized name will also be `nil`:

```ruby
c = Car.new(fuel_type: nil)
c.human_fuel_type # => nil
```

## Name Method

The name of the attribute value is available. This allows you to grab the stringified version of the name of the value.

```ruby
c = Car.new(fuel_type: Car::CARBON_EMITTER)
c.fuel_type_name # => "carbon_emitter"
```

If the flexible enum value is `nil`, the name will also be `nil`:

```ruby
c = Car.new(fuel_type: nil)
c.fuel_type_name # => nil
```

## Namespaced Attributes

FlexibleEnum attributes may be namespaced. Adding the namespace option to `flexible_enum` results in constants being defined in a new module.

```ruby
class CashRegister < ActiveRecord::Base
  flexible_enum :drawer_position, namespace: "DrawerPositions" do
    opened 0
    closed 1
  end
end

# Constants are defined in a new module
CashRegister::DrawerPositions::OPENED # => 0
CashRegister::DrawerPositions::CLOSED # => 1

# Convenience methods are not affected by namespace
r = CashRegister.new
r.opened!
r.closed!
```

## Scopes

FlexibleEnum adds ActiveRecord scopes for each attribute option:

```ruby
User.active   # => User.where(status: 0)
User.disabled # => User.where(status: 1)
User.pending  # => User.where(status: 2)
```

When an attribute is namespaced a prefix is added to scope names. The prefix is the singularized namespace name (using Active Support):

```ruby
CashRegister.drawer_position_opened # => CashRegister.where(drawer_position: 0)
CashRegister.drawer_position_closed # => CashRegister.where(drawer_position: 1)
```

## Custom Options

Configuration parameters passed to attribute options are saved even if they are unknown. Getting at custom configuration parameters is a little clumsy at the moment but this can still be useful in some cases:

```ruby
class EmailEvent < ActiveRecord::Base
  flexible_enum :event_type do
    bounce    1, processor_class: RejectedProcessor
    dropped   2, processor_class: RejectedProcessor
    opened    3, processor_class: EmailOpenedProcessor
    delivered 4, processor_class: DeliveryProcessor
  end

  def process
    class.event_types[event_type][:processor_class].new(self).process
  end
end
```

## Option Introspection

You may introspect on available options and their configuration parameters:

```ruby
ary = EmailEvent.event_types
ary.collect(&:name)       # => ["bounce", "dropped", "opened", "delivered"]
ary.collect(&:human_name) # => ["Bounce", "Dropped", "Opened", "Delivered"]
ary.collect(&:value)      # => [1, 2, 3, 4]
```

This works particularly well with ActionView:

```ruby
f.collection_select(:event_type, EmailEvent.event_types, :value, :human_name)
```

## Enum Introspection

You may retrieve a list of all defined `flexible_enum`s on a particular class:

```ruby
class Car < ActiveRecord::Base
  flexible_enum :status do
    new  1
    used 2
  end

  flexible_enum :car_type do
    gas      1
    hybrid   2
    electric 3
  end
end

Car.flexible_enums # => { status: Car.statuses, car_type: Car.car_types }
```

## Overriding Methods

You may override any method defined on the target class by FlexibleEnum. In version 0.0.1, `super` behaved as it would without FlexibleEnum being present, you could not call a FlexibleEnum method implementation from an overriding method. As of version 0.0.2, `super` instead references the FlexibleEnum implementation of a method when overriding a FlexibleEnum-defined method.

```ruby
class Item < ActiveRecord::Base
  flexible_enum :availability do
    discontinued 0
    backorder    1
    in_stock     2
  end

  # Version 0.0.1
  # Calling super would throw NoMethodError so we'd have to reimplement the method.
  def in_stock!
    BackInStockNotifier.new(self).queue if backorder?
    update_attribute!(status: IN_STOCK)
  end

  # Version 0.0.2
  # Calling super works and is preferred.
  def in_stock!
    BackInStockNotifier.new(self).queue if backorder?
    super
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run the tests (`appraisal rspec`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
