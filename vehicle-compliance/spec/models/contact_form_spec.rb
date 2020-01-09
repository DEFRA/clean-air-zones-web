# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactForm, type: :model do
  subject(:form) { described_class.new(params) }

  let(:first_name) { 'James' }
  let(:last_name) { 'Smith' }
  let(:email) { 'test@example.com' }
  let(:email_confirmation) { 'test@example.com' }
  let(:type_of_enquiry) { 'Compliance' }
  let(:message) { 'Test message' }

  let(:params) do
    {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'email_confirmation': email_confirmation,
      'type_of_enquiry': type_of_enquiry,
      'message': message
    }
  end

  context 'with proper params' do
    before { form.valid? }

    it { is_expected.to be_valid }

    it 'has an empty hash as error_object' do
      expect(form.errors.messages).to eq({})
    end

    context 'when first_name contains space' do
      let(:first_name) { 'Wojciech Bogdan' }

      it { is_expected.to be_valid }
    end

    context 'when last_name contains space' do
      let(:last_name) { 'Wojciech Bogdan' }

      it { is_expected.to be_valid }
    end
  end

  context 'with invalid params' do
    before { form.valid? }

    context 'when first_name is empty' do
      let(:first_name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:first_name])
          .to include('First name is required')
      end
    end

    context 'when first_name is too long' do
      let(:first_name) { SecureRandom.alphanumeric(46) }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:first_name])
          .to include('First name is too long (maximum is 45 characters)')
      end
    end

    context 'when invalid first_name format' do
      context 'when first_name has special signs' do
        let(:first_name) { 'FirstName$%' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(form.errors.messages[:first_name])
            .to include('First name is in an invalid format')
        end
      end

      context 'when first_name has numbers' do
        let(:first_name) { 'FirstName9' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(form.errors.messages[:first_name])
            .to include('First name is in an invalid format')
        end
      end
    end

    context 'when last_name is empty' do
      let(:last_name) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:last_name])
          .to include('Last name is required')
      end
    end

    context 'when last_name is too long' do
      let(:last_name) { SecureRandom.alphanumeric(46) }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:last_name])
          .to include('Last name is too long (maximum is 45 characters)')
      end
    end

    context 'when invalid last_name format' do
      context 'when last_name has special signs' do
        let(:last_name) { 'LastName$%' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(form.errors.messages[:last_name])
            .to include('Last name is in an invalid format')
        end
      end

      context 'when first_name has numbers' do
        let(:last_name) { 'LastName9' }

        it { is_expected.not_to be_valid }

        it 'has a proper error message' do
          expect(form.errors.messages[:last_name])
            .to include('Last name is in an invalid format')
        end
      end
    end

    context 'when email is empty' do
      let(:email) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email])
          .to include('Email is required', 'Email and email address confirmation must be the same')
      end
    end

    context 'when invalid email format' do
      let(:email) { 'user.example.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email])
          .to include('Email is in an invalid format')
      end
    end

    context 'when email is too long' do
      let(:email) { "#{SecureRandom.alphanumeric(36)}@email.com" }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email])
          .to include('Email is too long (maximum is 45 characters)')
      end
    end

    context 'when email_confirmation is empty' do
      let(:email_confirmation) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email_confirmation])
          .to include(
            'Email confirmation is required',
            'Email and email address confirmation must be the same'
          )
      end
    end

    context 'when email_confirmation is too long' do
      let(:email_confirmation) { "#{SecureRandom.alphanumeric(36)}@email.com" }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:email_confirmation])
          .to include('Email confirmation is too long (maximum is 45 characters)')
      end
    end

    context 'when email and email_confirmation is not same' do
      let(:email_confirmation) { 'another_email@example.com' }

      it { is_expected.not_to be_valid }

      it 'has a proper email error message' do
        expect(form.errors.messages[:email])
          .to include(
            'Email and email address confirmation must be the same'
          )
      end

      it 'has a proper email_confirmation error message' do
        expect(form.errors.messages[:email_confirmation])
          .to include(
            'Email and email address confirmation must be the same'
          )
      end
    end

    context 'when type_of_enquiry is empty' do
      let(:type_of_enquiry) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:type_of_enquiry])
          .to include(
            'Type of enquiry is required'
          )
      end
    end

    context 'when message is empty' do
      let(:message) { '' }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:message])
          .to include(
            'Message is required'
          )
      end
    end

    context 'when message is too long' do
      let(:message) { 'Aaa' * 700 }

      it { is_expected.not_to be_valid }

      it 'has a proper error message' do
        expect(form.errors.messages[:message])
          .to include('Message is too long (maximum is 2000 characters)')
      end
    end
  end
end
