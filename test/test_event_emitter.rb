require 'test_helper'

class TestEventEmitter < ::Minitest::Test
  class Pub
    include ::FlatKit::EventEmitter
  end

  class Sub
    attr_reader :name
    attr_reader :data
    attr_reader :byte_count
    attr_reader :record_count

    def initialize
      @name = nil
      @data = nil
      @byte_count = nil
      @record_count = nil
    end

    def on_event(name:, data:, byte_count: nil, record_count: nil)
      @name = name
      @data = data
      @byte_count = byte_count
      @record_count = record_count
    end
  end

  class BadSub; end

  def setup
    @emitter = Pub.new
    @receiver = Sub.new
  end

  def test_counts_no_listeners_before_adding_one
    assert_equal(0, @emitter.count_listeners)
  end

  def test_adds_listener
    @emitter.add_listener(@receiver)
    assert_equal(1, @emitter.count_listeners)
  end

  def test_removes_listener
    @emitter.add_listener(@receiver)
    assert_equal(1, @emitter.count_listeners)

    @emitter.remove_listener(@receiver)
    assert_equal(0, @emitter.count_listeners)
  end

  def test_only_adds_an_listener_once
    @emitter.add_listener(@receiver)
    assert_equal(1, @emitter.count_listeners)

    @emitter.add_listener(@receiver)
    assert_equal(1, @emitter.count_listeners)
  end

  def test_verifies_reciever_responds_t_observed
    assert_raises(::NoMethodError) { @emitter.add_listener(BadSub.new) }
  end

  def test_listeners_get_notified
    @receiver_2 = Sub.new
    @emitter.add_listener(@receiver)
    @emitter.add_listener(@receiver_2)

    @emitter.notify_listeners(name: :notification, data: "DATA!", byte_count: 42, record_count: 12)

    assert_equal(:notification, @receiver.name)
    assert_equal(:notification, @receiver_2.name)

    assert_equal("DATA!", @receiver.data)
    assert_equal("DATA!", @receiver_2.data)

    assert_equal(42, @receiver.byte_count)
    assert_equal(42, @receiver_2.byte_count)

    assert_equal(12, @receiver.record_count)
    assert_equal(12, @receiver_2.record_count)
  end
end
