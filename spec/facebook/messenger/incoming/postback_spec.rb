require 'spec_helper'

describe Facebook::Messenger::Incoming::Postback do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'postback' => {
        'payload' => 'USER_DEFINED_PAYLOAD',
        'referral' => {
          'ref' => 'my-ref-value',
          'source' => 'SHORTLINK',
          'type' => 'OPEN_THREAD'
        }
      }
    }
  end

  subject { Facebook::Messenger::Incoming::Postback.new(payload) }

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
    it 'returns when the postback was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.payload' do
    it 'returns the payload of the postback' do
      expect(subject.payload).to eq(payload['postback']['payload'])
    end
  end

  describe '.referral' do
    it 'returns the ref value' do
      expect(subject.referral.ref).to eq(payload['postback']['referral']['ref'])
    end

    it 'returns the source value' do
      expect(subject.referral.source).to eq(
        payload['postback']['referral']['source']
      )
    end

    it 'returns the type value' do
      expect(subject.referral.type).to eq(
        payload['postback']['referral']['type']
      )
    end

    context 'when referral is not set' do
      let :payload do
        {
          'sender' => {
            'id' => '3'
          },
          'recipient' => {
            'id' => '3'
          },
          'timestamp' => 145_776_419_762_7,
          'postback' => {
            'payload' => 'USER_DEFINED_PAYLOAD'
          }
        }
      end

      it 'returns nil' do
        expect(subject.referral).to be_nil
      end
    end
  end
end
