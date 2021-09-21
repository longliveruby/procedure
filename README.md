# Procedure

<p align="center">
  <img src="./logo.png" />
</p>

When you check multiple conditions, allow for some action only when all requirements are met and need feedback which conditions were not met in the opposite case, **the procedure gem is for you**.

Examples:

* https://longliveruby.com/articles/rails-procedure-design-pattern

## Installation

Add the gem to your `Gemfile`:

```shell
bundle add procedure
```

## Usage

Let's assume that we have the following user:

```ruby
User = Struct.new(:first_name, :country, :age, keyword_init: true)
user = User.new(
  first_name: 'John',
  country: 'USA',
  age: 20
)
```

We would allow him to enter the system only if he satisfies the following requirements:

* `first_name` is present
* `age` is greater than 25
* `country` is Finland

If one of the requirements is not met, we would like to know about it. So we want to build the procedure with three steps:

```ruby
# Verify first name
class VerifyFirstName
  include Procedure::Step

  def passed?
    !context.user.first_name.nil?
  end

  def failure_message
    'First name is blank'
  end
end

# Verify age
class VerifyAge
  include Procedure::Step

  def passed?
    context.user.age > 25
  end

  def failure_message
    'The user is not old enough'
  end
end

# Verify country
class VerifyCountry
  include Procedure::Step

  def passed?
    context.user.country == 'Finland'
  end

  def failure_message
    'The user is not from Finland'
  end
end
```

The last thing we need to do is to create an organizer, class that will perform the procedure with the all the steps we defined:

```ruby
class UserProcedure
  include Procedure::Organizer

  steps VerifyFirstName, VerifyAge, VerifyCountry
end
```

We can now test the procedure:

```ruby
outcome = UserProcedure.call(context: { user: user })
outcome.success? # => false
outcome.failure_messages # => ["The user is not old enough"]
```

By the default, the procedure would stop when one of the steps would not pass the verification. If you would like to continue the procedure to get the full feedback, you have to pass the `fail_fast` option explicitly:

```ruby
outcome = UserProcedure.call(context: { user: user }, options: { fail_fast: false })
outcome.success? # => false
outcome.failure_messages # => ["The user is not old enough", "The user is not from Finland"] 
```
