require 'spec_helper'

describe Facebook::Messenger::Incoming::PassThreadControl do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 1_458_692_752_478,
      'pass_thread_control' => {
        'new_owner_app_id' => '123456789',
        'metadata' => 'Additional content that the caller wants to set'
      }
    }
  end

  subject { described_class.new(payload) }

  describe '.new_owner_app_id' do
    it 'returns the new owner app id' do
      expect(subject.new_owner_app_id).to eq(
        payload['pass_thread_control']['new_owner_app_id']
      )
    end
  end

  describe '.metadata' do
    it 'returns the metadata' do
      expect(subject.metadata).to eq(
        payload['pass_thread_control']['metadata']
      )
    end
  end
end
