module FlatKit
  # A simplified Observable class for use internally
  #
  module Observable
    def add_observer(observer)
      raise ::NoMethodError, "#{observer} does not resond to #observed" unless observer.respond_to?(:observed)
      self._observers ||= []
      self._observers << observer unless _observers.include?(observer)
    end

    def count_observers
      _observers.size
    end

    def delete_observer(observer)
      _observers.delete(observer)
    end

    def delete_observers
      _observers.clear
    end

    def notify_observers(*args)
      _observers.each do |o|
        o.observed(*args)
      end
    end

    private

    def _observers
      @_observers ||= Array.new
    end
  end
end
