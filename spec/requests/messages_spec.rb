# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesController, type: :request do
  describe '#create' do
    before do
      patient = User.create!(is_patient: true, first_name: 'Dyan', last_name: 'Carra')
      doctor = User.create!(is_doctor: true, first_name: 'Joao', last_name: 'Rudemar')
      patient_inbox = Inbox.create!(user: patient)
      inbox = Inbox.create!(user: doctor)
      outbox = Outbox.create!(user: patient)

      Message.create!(body: 'Existent', inbox: patient_inbox, outbox: outbox)
    end

    subject { post messages_path, params: { message: { body: 'New message' } } }

    context 'when success' do
      it 'creates a message with correct data' do
        subject
        expect(Message.last.body).to eq 'New message'
        expect(Message.last.read).to be_falsy
        expect(Message.last.inbox).to eq User.default_doctor.inbox
        expect(Message.last.outbox).to eq User.current.outbox
      end
    end
  end

  describe '#index' do
    before do
      patient = User.create!(is_patient: true, first_name: 'Dyan', last_name: 'Carra')
      doctor = User.create!(is_doctor: true, first_name: 'Joao', last_name: 'Rudemar')
      patient_inbox = Inbox.create!(user: patient)
      inbox = Inbox.create!(user: doctor)
      outbox = Outbox.create!(user: patient)
      admin = User.create!(is_admin: true, first_name: 'Ruan', last_name: 'Capra')
      admin_inbox = Inbox.create!(user: admin)
      Message.create!(body: 'Existent', inbox: patient_inbox, outbox: outbox)
      Message.create!(body: 'Existent', inbox: inbox, outbox: Outbox.last)
      Message.create!(body: 'Existent', inbox: admin_inbox, outbox: Outbox.last)
    end

    context 'when user searches for patient messages' do
      it 'returns correct number of patient messages' do
        get messages_path, params: { user_type: 'Patient' }
        expect(controller.instance_variable_get(:@messages).count).to eq 1
      end
    end
    context 'when user searches for admin messages' do
      it 'returns correct number of admin messages' do
        get messages_path, params: { user_type: 'Admin' }
        expect(controller.instance_variable_get(:@messages).count).to eq 1
      end
    end
    context 'when user searches for doctor messages' do
      it 'returns correct number of doctor messages' do
        get messages_path, params: { user_type: 'Doctor' }
        expect(controller.instance_variable_get(:@messages).count).to eq 1
      end
    end
  end

  describe '#show' do
    before do
      patient = User.create!(is_patient: true, first_name: 'Dyan', last_name: 'Carra')
      doctor = User.create!(is_doctor: true, first_name: 'Joao', last_name: 'Rudemar')
      patient_inbox = Inbox.create!(user: patient)
      inbox = Inbox.create!(user: doctor)
      outbox = Outbox.create!(user: patient)

      message = Message.create!(body: 'Existent', inbox: patient_inbox, outbox: outbox, read: false)
    end

    it 'returns message' do
        get message_path(Message.last)
        expect(controller.instance_variable_get(:@message)).to eq Message.last
    end
    it 'updates read attribute' do
        get message_path(Message.last)
        expect(controller.instance_variable_get(:@message).read).to be_truthy
    end
  end
end
