require 'spec_helper'

describe Facebook::Messenger::Incoming::Delivery do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'delivery' => {
        'mids' => [
          'mid.1457764197618:41d102a3e1ae206a38',
          'mid.1458668856218:ed81099e15d3f4f233'
        ],
        'watermark' => 145_866_885_625_3,
        'seq' => 37
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Delivery.new(payload) }

  describe '.messaging' do
    it 'returns the original payload' do
      expect(subject.messaging).to eq(payload)
    end
  end

  describe '.ids' do
    it 'returns the message ids' do
      expect(subject.ids).to eq(payload['delivery']['mids'])
    end
  end

  describe '.sender' do
    it 'returns the sender' do
      expect(subject.sender).to eq(payload['sender'])
    end
  end

  describe '.recipient' do
    it 'returns the recipient' do
      expect(subject.recipient).to eq(payload['recipient'])
    end
  end

  describe '.seq' do
    it 'returns the message sequence number' do
      expect(subject.seq).to eq(payload['delivery']['seq'])
    end
  end

  describe '.at' do
    it 'returns a Time' do
      expect(subject.at).to eq(
        Time.at(payload['delivery']['watermark'] / 1000)
      )
    end
  end
end
