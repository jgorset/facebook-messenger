require 'spec_helper'

describe Facebook::Messenger::Incoming::TakeThreadControl do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 1_458_692_752_478,
      'take_thread_control' => {
        'previous_owner_app_id' => '123456789',
        'metadata' => 'sample-metadata'
      }
    }
  end

  subject { Facebook::Messenger::Incoming::TakeThreadControl.new(payload) }

  describe '.messaging' do
    it 'returns the original payload' do
      expect(subject.messaging).to eq(payload)
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

  describe '.sent_at' do
    it 'returns when the message was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.thread_control' do
    it 'returns the previous_owner_app_id value' do
      expect(subject.thread_control.previous_owner_app_id)
        .to eq(payload['take_thread_control']['previous_owner_app_id'])
    end

    it 'returns the metadata value' do
      expect(subject.thread_control.metadata)
        .to eq(payload['take_thread_control']['metadata'])
    end
  end
end
