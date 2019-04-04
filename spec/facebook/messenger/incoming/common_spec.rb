require 'spec_helper'

class Dummy
  include Facebook::Messenger::Incoming::Common
end

describe Dummy do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'message' => {
        'is_echo' => false,
        'mid' => 'mid.1457764197618:41d102a3e1ae206a38',
        'seq' => 73,
        'text' => 'Hello, bot!',
        'quick_reply' => {
          'payload' => 'Hi, I am a quick reply!'
        },
        'attachments' => [{
          'type' => 'image',
          'payload' => {
            'url' => 'https://www.example.com/1.jpg'
          }
        }]
      },
      'prior_message' => {
        'source' => 'checkbox_plugin',
        'identifier' => '903dac41-0976-467f-805e-ed58dc23a783'
      }
    }
  end

  subject { described_class.new(payload) }

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

  describe '.prior_message' do
    it 'returns the message' do
      expect(subject.prior_message).to eq(payload['prior_message'])
    end
  end

  describe '.sent_at' do
    it 'returns when the message was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe 'responding to message' do
    let(:access_token) { 'access_token' }
    let(:app_secret_proof) { 'app_secret_proof' }
    before do
      allow(Facebook::Messenger.config.provider).to(
        receive(:access_token_for)
          .with(subject.recipient).and_return(access_token)
      )
      allow(Facebook::Messenger.config.provider).to(
        receive(:app_secret_proof_for)
          .with(subject.recipient).and_return(app_secret_proof)
      )
    end
    shared_examples_for 'payload delivery' do |delivery_method|
      shared_examples_for 'request execution' do
        it 'delivers the payload' do
          expect(Facebook::Messenger::Bot).to receive(:deliver)
            .with(
              payload,
              access_token: access_token,
              app_secret_proof: app_secret_proof
            )
          subject.public_send(delivery_method)
        end
      end

      context 'when app secret proof enabled' do
        include_examples 'request execution'
      end
      context 'when app secret proof disabled' do
        let(:app_secret_proof) { nil }
        include_examples 'request execution'
      end
      it_behaves_like 'payload delivery', :typing_on do
        let(:payload) do
          {
            recipient: subject.sender,
            sender_action: 'typing_on'
          }
        end
      end
      it_behaves_like 'payload delivery', :typing_off do
        let(:payload) do
          {
            recipient: subject.sender,
            sender_action: 'typing_off'
          }
        end
      end
      it_behaves_like 'payload delivery', :mark_seen do
        let(:payload) do
          {
            recipient: subject.sender,
            sender_action: 'mark_seen'
          }
        end
      end
      it_behaves_like 'payload_delivery', :reply do
        let(:payload) do
          {
            recipient: subject.sender,
            message: { text: 'Hello, human' },
            message_type: Facebook::Messenger::Bot::MessageType::RESPONSE
          }
        end
      end
    end
  end
end
