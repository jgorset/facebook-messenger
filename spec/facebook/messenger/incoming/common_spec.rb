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

  describe '.sent_at' do
    it 'returns when the message was sent' do
      expect(subject.sent_at).to eq(Time.at(payload['timestamp'] / 1000))
    end
  end

  describe '.typing_on' do
    let(:access_token) { 'access_token' }

    it 'sends a typing indicator to the sender' do
      expect(Facebook::Messenger.config.provider).to receive(:access_token_for)
        .with(subject.recipient)
        .and_return(access_token)

      expect(Facebook::Messenger::Bot).to receive(:deliver)
        .with({
                recipient: subject.sender,
                sender_action: 'typing_on'
              }, access_token: access_token)

      subject.typing_on
    end
  end

  describe '.typing_off' do
    let(:access_token) { 'access_token' }

    it 'sends a typing off indicator to the sender' do
      expect(Facebook::Messenger.config.provider).to receive(:access_token_for)
        .with(subject.recipient)
        .and_return(access_token)

      expect(Facebook::Messenger::Bot).to receive(:deliver)
        .with({
                recipient: subject.sender,
                sender_action: 'typing_off'
              }, access_token: access_token)

      subject.typing_off
    end
  end

  describe '.mark_seen' do
    let(:access_token) { 'access_token' }

    it 'sends a typing off indicator to the sender' do
      expect(Facebook::Messenger.config.provider).to receive(:access_token_for)
        .with(subject.recipient)
        .and_return(access_token)

      expect(Facebook::Messenger::Bot).to receive(:deliver)
        .with({
                recipient: subject.sender,
                sender_action: 'mark_seen'
              }, access_token: access_token)

      subject.mark_seen
    end
  end

  describe '.reply' do
    let(:access_token) { 'access_token' }

    it 'replies to the sender with the default message type' do
      expect(Facebook::Messenger.config.provider).to receive(:access_token_for)
        .with(subject.recipient)
        .and_return(access_token)

      expect(Facebook::Messenger::Bot).to receive(:deliver)
        .with({
                recipient: subject.sender,
                message: { text: 'Hello, human' },
                message_type: Facebook::Messenger::Bot::MessageType::RESPONSE
              }, access_token: access_token)

      subject.reply(text: 'Hello, human')
    end
  end
end
