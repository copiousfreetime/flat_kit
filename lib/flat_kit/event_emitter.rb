module FlatKit
  # A simplified Observable class for use internally
  #
  module EventEmitter
    def add_listener(listener)
      raise ::NoMethodError, "#{listener} does not resond to #on_event" unless listener.respond_to?(:on_event)
      self._listeners ||= []
      self._listeners << listener unless _listeners.include?(listener)
    end

    def count_listeners
      _listeners.size
    end

    def remove_listener(listener)
      _listeners.delete(listener)
    end

    def remove_listeners
      _listeners.clear
    end

    def notify_listeners(name:, data:, meta: nil)
      _listeners.each do |l|
        l.on_event(name: name, data: data, meta: meta)
      end
    end

    def _listeners
      @_listeners ||= Array.new
    end
  end
end
