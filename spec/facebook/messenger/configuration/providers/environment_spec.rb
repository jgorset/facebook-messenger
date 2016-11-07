require 'spec_helper'

describe Facebook::Messenger::Configuration::Providers::Environment do
  describe '.valid_verify_token?' do
    let(:valid_verify_token) { 'verify token' }
    let(:invalid_verify_token) { 'invalid verify token' }

    subject { described_class.new.valid_verify_token?(valid_verify_token) }

    context 'with a valid verify token' do
      before { ENV['VERIFY_TOKEN'] = valid_verify_token }

      it { is_expected.to be(true) }
    end

    context 'with an invalid verify token' do
      before { ENV['VERIFY_TOKEN'] = invalid_verify_token }

      it { is_expected.to be(false) }
    end
  end

  describe '.app_secret_for' do
    let(:page_id) { '123' }
    let(:app_secret) { 'ABC' }

    subject { described_class.new.app_secret_for(page_id) }
    before { ENV['APP_SECRET'] = app_secret }

    it { is_expected.to eq(app_secret) }
  end

  describe '.access_token_for' do
    let(:page_id) { '123' }
    let(:access_token) { 'ABC' }

    subject { described_class.new.app_secret_for(page_id) }
    before { ENV['ACCESS_TOKEN'] = access_token }

    it { is_expected.to eq(access_token) }
  end
end
