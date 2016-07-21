require 'spec_helper'

RSpec.describe CountdownLatch do
  it 'has a version number' do
    expect(CountdownLatch::VERSION).not_to be nil
  end

  it 'requires a non negative integer as an argument' do
    latch = CountdownLatch::CountdownLatch.new(3)
    expect(latch.count).to eq(3)
  end

  it 'raises an argument error for negative numbers' do
    expect { CountdownLatch::CountdownLatch.new(-1) }.to raise_error(ArgumentError)
  end

  describe '#count_down' do
    let(:latch) { CountdownLatch::CountdownLatch.new(3) }

    it 'will decrease count' do
      latch.count_down
      expect(latch.count).to eq 2
    end

    it 'will not decrese bellow zero' do
      4.times { latch.count_down }
      expect(latch.count).to eq 0
    end
  end

  describe '#await' do
    it 'will wait for a thread to finish its work' do
      latch = CountdownLatch::CountdownLatch.new(1)

      Thread.new do
        latch.count_down
      end

      latch.await
      expect(latch.count).to be_zero
    end
  end
end
