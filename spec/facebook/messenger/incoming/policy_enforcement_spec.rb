require 'spec_helper'

describe Facebook::Messenger::Incoming::PolicyEnforcement do
  let :payload do
    {
      'sender' => {
        'id' => '3'
      },
      'recipient' => {
        'id' => '3'
      },
      'timestamp' => 145_776_419_762_7,
      'policy-enforcement' => {
        'action' => 'block',
        'reason' => 'The bot violated our Platform Policies (https://developers.facebook.com/policy/#messengerplatform). Common violations include sending out excessive spammy messages or being non-functional.'
      }
    }
  end

  subject { described_class.new(payload) }

  describe '.action' do
    specify { expect(subject.action).to eq(payload['policy-enforcement']['action']) }
  end

  describe '.reason' do
    specify {  expect(subject.reason).to eq(payload['policy-enforcement']['reason']) }
  end
end
