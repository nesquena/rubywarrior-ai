class Decider
  include Awareness

  attr_reader :warrior
  
  @@decisions = []
  @@actions = {}
  def initialize(warrior)
    @warrior = warrior
  end
  
  def self.decide(action, &block)
    @@decisions << action
    define_method("should_#{action}?", &block)
  end
  
  def self.action(name, &block)
    @@actions[name] = block
  end
  
  def execute
    @@decisions.find do |action|
      @@actions[action] ? action_block.call(warrior) : warrior.send("#{action}!") if self.send("should_#{action}?")
    end
  end
end
