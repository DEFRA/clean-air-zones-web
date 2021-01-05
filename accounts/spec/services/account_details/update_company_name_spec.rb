# frozen_string_literal: true

require 'rails_helper'

describe AccountDetails::UpdateCompanyName do
  subject { described_class.call(account_id: account_id, company_name: company_name) }

  let(:company_name) { 'Company Name' }
  let(:account_id) { @uuid }
  let(:valid) { true }
  let(:errors) { [] }
  let(:url) { "/accounts/#{account_id}" }

  context 'when api returns correct response' do
    before do
      allow(Organisations::CompanyNameForm)
        .to receive(:new)
        .and_return(instance_double(Organisations::CompanyNameForm, valid?: valid))
      allow(AccountsApi::Accounts).to receive(:update_company_name).and_return(true)
    end

    it 'calls Organisations::CompanyNameForm with proper params' do
      expect(Organisations::CompanyNameForm).to receive(:new).with(company_name: company_name)
      subject
    end

    it 'calls AccountsApi::Accounts.create_account with proper params' do
      expect(AccountsApi::Accounts)
        .to receive(:update_company_name)
        .with(account_id: account_id, company_name: company_name)
      subject
    end
  end

  context 'when params are not valid' do
    let(:company_name_form_instance) do
      instance_double(Organisations::CompanyNameForm,
                      valid?: valid,
                      errors: errors,
                      first_error_message: 'test')
    end
    let(:valid) { false }
    let(:errors) { ActiveModel::Errors.new(['Some error']) }

    before { allow(Organisations::CompanyNameForm).to receive(:new).and_return(company_name_form_instance) }

    it 'raises `InvalidCompanyNameException` exception' do
      expect { subject }.to raise_error(InvalidCompanyNameException)
    end
  end

  context 'when api returns 422 status' do
    let(:error_code) { 'duplicate' }

    before do
      allow(Organisations::CompanyNameForm).to receive(:new).and_return(
        instance_double(Organisations::CompanyNameForm, valid?: valid)
      )

      stub_request(:patch, /#{url}/).to_return(
        status: 422,
        body: {
          "message": 'Submitted parameters are invalid',
          "errorCode": error_code
        }.to_json
      )
    end

    context 'when company name is not unique' do
      it 'raises `UnableToCreateAccountException` exception' do
        expect { subject }.to raise_error(
          UnableToCreateAccountException, I18n.t('company_name.errors.duplicate_alternative')
        )
      end
    end

    context 'when company name has profanity term' do
      let(:error_code) { 'profanity' }

      it 'raises `UnableToCreateAccountException` exception' do
        expect { subject }.to raise_error(
          UnableToCreateAccountException, I18n.t('company_name.errors.profanity')
        )
      end
    end

    context 'when company name has abusive term' do
      let(:error_code) { 'abuse' }

      it 'raises `UnableToCreateAccountException` exception' do
        expect { subject }.to raise_error(UnableToCreateAccountException, I18n.t('company_name.errors.abuse'))
      end
    end

    context 'when unknown code returns' do
      let(:error_code) { 'unknown code' }

      it 'raises `UnableToCreateAccountException` exception' do
        expect { subject }.to raise_error(UnableToCreateAccountException, 'Something went wrong')
      end
    end
  end
end
