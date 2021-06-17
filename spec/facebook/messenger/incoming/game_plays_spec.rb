require 'spec_helper'

describe Facebook::Messenger::Incoming::GamePlay do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'game_play' => {
        'game_id' => '<GAME-APP-ID>',
        'player_id' => '<PLAYER-ID>',
        'context_type' => '<CONTEXT-TYPE:SOLO|THREAD>',
        'context_id' => '<CONTEXT-ID>', # If a Messenger Thread context
        'score' => 100, # If a classic score based game
        'payload' => '<PAYLOAD>' # If a rich game
      }
    }
  end

  subject { Facebook::Messenger::Incoming::GamePlay.new(payload) }

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

  describe '.game_play' do
    it 'returns the payload of the webhook' do
      expect(subject.game_play).to eq(payload['game_play'])
    end
  end

  describe '.payload' do
    it 'returns the payload of the game played' do
      expect(subject.payload).to eq(payload['game_play']['payload'])
    end
  end

  describe '.score' do
    it 'returns the score of the game played' do
      expect(subject.score).to eq(payload['game_play']['score'])
    end
  end

  describe '.game' do
    it 'returns the id of game played' do
      expect(subject.game).to eq(payload['game_play']['game_id'])
    end
  end

  describe '.player' do
    it 'returns the id of player played' do
      expect(subject.player).to eq(payload['game_play']['player_id'])
    end
  end

  describe '.context' do
    it 'returns the social context information' do
      expected = {
        context_id: payload['game_play']['context_id'],
        context_type: payload['game_play']['context_type']
      }

      expect(subject.context).to eq(expected)
    end
  end
end
