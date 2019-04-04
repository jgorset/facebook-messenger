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

  describe '.app_secret_proof_for with app_secret_proof_disabled' do
    let(:page_id) { '123' }

    subject { described_class.new.app_secret_proof_for(page_id) }
    before { ENV['APP_SECRET_PROOF_ENABLED'] = 'false' }

    it { is_expected.to eq(nil) }
  end

  describe '.app_secret_proof_for with app_secret_proof enabled' do
    let(:page_id) { '123' }
    let(:access_token) { 'ABC' }
    let(:app_secret) { 'ABsecret' }
    let(:app_secret_proof) { 'proof' }

    subject { described_class.new }
    before { ENV['ACCESS_TOKEN'] = access_token }
    before { ENV['APP_SECRET'] = app_secret }
    before { ENV['APP_SECRET_PROOF_ENABLED'] = 'true' }

    it 'calculates the app_secret_proof' do
      expect(Facebook::Messenger::Configuration::AppSecretProofCalculator)
        .to(
          receive(:call)
            .once
            .with(app_secret, access_token)
            .and_return(app_secret_proof)
        )
      expect(subject.app_secret_proof_for(page_id)).to eq(app_secret_proof)
      # call twice to test that we have cached correctly so we don't
      # call calculate_app_secret_proof twice
      expect(subject.app_secret_proof_for(page_id)).to eq(app_secret_proof)
    end
  end
end
