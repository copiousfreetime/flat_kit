require 'test_helper'

class TestEventEmitter < ::Minitest::Test
  class Pub
    include ::FlatKit::EventEmitter
  end

  class Sub
    attr_reader :name
    attr_reader :data
    attr_reader :meta

    def initialize
      @name = nil
      @data = nil
      @meta = nil
    end

    def byte_count
      meta[:byte_count]
    end

    def record_count
      meta[:record_count]
    end

    def on_event(name:, data:, meta:)
      @name = name
      @data = data
      @meta = meta
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

    meta = {
      record_count: 42,
      byte_count: 4242
    }
    @emitter.notify_listeners(name: :notification, data: "DATA!", meta: meta)

    assert_equal(:notification, @receiver.name)
    assert_equal(:notification, @receiver_2.name)

    assert_equal("DATA!", @receiver.data)
    assert_equal("DATA!", @receiver_2.data)

    assert_equal(4242, @receiver.byte_count)
    assert_equal(4242, @receiver_2.byte_count)

    assert_equal(42, @receiver.record_count)
    assert_equal(42, @receiver_2.record_count)
  end
end
