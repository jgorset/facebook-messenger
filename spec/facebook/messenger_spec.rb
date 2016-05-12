require 'spec_helper'

describe Facebook::Messenger do
  describe '#configure' do
    before do
      Facebook::Messenger.config = Facebook::Messenger::Configuration.new
    end

    it 'sets correct configuration' do
      Facebook::Messenger.configure do |config|
        config.access_token = 'access_token'
        config.app_secret = 'app_secret'
        config.verify_token = 'verify_token'
      end

      expect(Facebook::Messenger.config.access_token).to eql('access_token')
      expect(Facebook::Messenger.config.app_secret).to eql('app_secret')
      expect(Facebook::Messenger.config.verify_token).to eq('verify_token')
    end
  end
end
