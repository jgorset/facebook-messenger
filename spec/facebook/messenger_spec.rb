require 'spec_helper'

describe Facebook::Messenger do
  let(:providers) { Facebook::Messenger::Configuration::Providers }

  describe '#configure' do
    let(:provider) { providers::Environment }

    it 'sets correct configuration' do
      Facebook::Messenger.configure do |config|
        config.provider = provider
      end

      expect(Facebook::Messenger.config.provider).to eql(provider)
    end
  end
end
