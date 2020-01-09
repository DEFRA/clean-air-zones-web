# frozen_string_literal: true

require 'rails_helper'

describe ContactFormsController, type: :request do
  describe 'GET #contact_form' do
    subject(:http_request) { get contact_forms_path }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #validate_contact_form' do
    subject(:http_request) do
      post contact_forms_path, params: { 'contact_form' => params }
    end

    let(:user_email) { 'test@example.com' }

    context 'when the form is valid' do
      before do
        allow(Sqs::JaquMessage).to receive(:call).and_return(sqs_response)
        allow(Sqs::UserMessage).to receive(:call).and_return(sqs_response)
      end

      let(:params) do
        {
          email: user_email,
          email_confirmation: user_email,
          first_name: 'James',
          last_name: 'Smith',
          type_of_enquiry: 'Compliance',
          message: 'Test message'
        }
      end
      let(:sqs_response) { SecureRandom.uuid }

      it 'redirects to :result' do
        http_request
        expect(response).to redirect_to(result_contact_forms_path)
      end

      it 'has not an alert set to true' do
        http_request
        expect(request.flash[:alert]).to be_nil
      end

      it 'calls Sqs::JaquMessage' do
        expect(Sqs::JaquMessage).to receive(:call).with(contact_form: instance_of(ContactForm))
        http_request
      end

      it 'calls Sqs::UserMessage' do
        expect(Sqs::UserMessage).to receive(:call).with(contact_form: instance_of(ContactForm))
        http_request
      end

      context 'when SQS call fails' do
        let(:sqs_response) { false }

        before { http_request }

        it 'redirects to :result' do
          expect(response).to redirect_to(result_contact_forms_path)
        end

        it 'has an alert set to true' do
          expect(request.flash[:alert]).to be_truthy
        end
      end
    end

    context 'when the form is invalid' do
      let(:params) { { email: '' } }

      it 'returns a success response' do
        http_request
        expect(response).to have_http_status(:success)
      end

      it 'renders :index' do
        expect(http_request).to render_template(:index)
      end

      it "doesn't call SQS Jaqu message" do
        expect(Sqs::JaquMessage).not_to receive(:call)
        http_request
      end

      it "doesn't call SQS user message" do
        expect(Sqs::UserMessage).not_to receive(:call)
        http_request
      end
    end
  end

  describe 'GET #contact_form_result' do
    subject(:http_request) { get result_contact_forms_path }

    it 'returns a success response' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end
end
