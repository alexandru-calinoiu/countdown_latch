require 'countdown_latch/version'
require 'thread'

module CountdownLatch
  class CountdownLatch
    def initialize(count)
      guard(count)

      @count = count
      @condition = ConditionVariable.new
      @mutex = Mutex.new
    end

    def count_down
      @mutex.synchronize do
        @count -= 1 unless @count.zero?

        if @count.zero?
          @condition.broadcast
        end
      end
    end

    def await
      @mutex.synchronize do
        @condition.wait(@mutex)
      end
    end

    def count
      @mutex.synchronize do
        @count
      end
    end

    private

      def guard(count)
        raise ArgumentError.new('Count needs to be an positive integer') if count < 0
      end
  end
end
