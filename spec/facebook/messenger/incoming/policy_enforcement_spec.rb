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
      'policy_enforcement' => {
        'action' => 'block',
        'reason' => <<-REASON
          The bot violated our Platform Policies
          (https://developers.facebook.com/policy/#messengerplatform).
          Common violations include sending out excessive spammy
          messages or being non-functional.
        REASON
      }
    }
  end

  let(:policy_enforcement) { payload['policy_enforcement'] }

  subject { described_class.new(payload) }

  describe '.action' do
    specify { expect(subject.action).to eq(policy_enforcement['action']) }
  end

  describe '.reason' do
    specify { expect(subject.reason).to eq(policy_enforcement['reason']) }
  end
end
