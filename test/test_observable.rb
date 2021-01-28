require 'test_helper'

class TestObservable < ::Minitest::Test
  class Pub
    include ::FlatKit::Observable

    attr_reader :tick

    def blast(item)
      notify_observers(item)
    end
  end

  class Sub
    attr_reader :received

    def initialize
      @received = nil
    end

    def observed(item)
      @received = item
    end
  end

  class BadSub; end

  def setup
    @observable = Pub.new
    @receiver = Sub.new
  end

  def test_counts_no_observers_before_adding_one
    assert_equal(0, @observable.count_observers)
  end

  def test_adds_observer
    @observable.add_observer(@receiver)
    assert_equal(1, @observable.count_observers)
  end

  def test_deletes_observer
    @observable.add_observer(@receiver)
    assert_equal(1, @observable.count_observers)

    @observable.delete_observer(@receiver)
    assert_equal(0, @observable.count_observers)
  end

  def test_only_adds_an_observer_once
    @observable.add_observer(@receiver)
    assert_equal(1, @observable.count_observers)

    @observable.add_observer(@receiver)
    assert_equal(1, @observable.count_observers)
  end

  def test_verifies_reciever_responds_t_observed
    assert_raises(::NoMethodError) { @observable.add_observer(BadSub.new) }
  end

  def test_observers_get_notified
    @receiver_2 = Sub.new
    @observable.add_observer(@receiver)
    @observable.add_observer(@receiver_2)

    @observable.blast(:notification)

    assert_equal(:notification, @receiver.received)
    assert_equal(:notification, @receiver_2.received)
  end
end
