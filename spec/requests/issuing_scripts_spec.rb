# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuingScriptsController, type: :request do
  describe '#create' do
    before do
      patient = User.create!(is_patient: true, first_name: 'Dyan', last_name: 'Carra')
      admin = User.create!(is_admin: true, first_name: 'Ruan', last_name: 'Capra')

      Inbox.create!(user: admin)
      Outbox.create!(user: patient)
    end

    subject { post issuing_scripts_path }

    context 'when success' do
      it 'sends a message to admin requesting a new script' do
        expect { subject }.to change { Message.count }.by(1)
      end

      it 'sends a message with correct values' do
        subject
        expect(Message.last.body).to eq 'The patient Dyan Carra is requesting a new script.'
        expect(Message.last.inbox).to eq User.default_admin.inbox
        expect(Message.last.outbox).to eq User.current.outbox
      end

      it 'calls payment provider' do
        expect(PaymentProviderFactory).to receive_message_chain(:provider, :debit_card)
                                            .with(User.current)
        subject
      end

      it 'creates payment record' do
        expect { subject }.to change { Payment.count }.by(1)
      end
    end

    context 'when fails' do
      before do
        expect(PaymentProviderFactory).to receive_message_chain(:provider, :debit_card)
                                            .and_raise(Exception)
      end

      it 'does not send message' do
        expect { subject }.to change { Message.count }.by(0)
      end

      it 'does not create payment record' do
        expect { subject }.to change { Payment.count }.by(0)
      end
    end
  end
end
