# frozen_string_litral: true

require 'rails_helper'

RSpec.describe Inboxes::UpdateUnread, type: :services do
  let(:doctor) { User.create(is_doctor: true) }
  let(:patient) { User.create(is_patient: true)}
  let(:inbox) { Inbox.create(user: doctor) }
  let(:outbox) { Outbox.create(user: patient) }

  subject { described_class.call(inbox) }

  context 'unread count updation' do
    context 'increment count' do
      before do
        Message.create(inbox: inbox, outbox: outbox, body: 'Message one', read: false)
        Message.create(inbox: inbox, outbox: outbox, body: 'Message two', read: false)
      end

      it 'increment count by 1' do
        expect { subject }.to change { inbox.reload.unread }.from(0).to(2)
      end
    end

    context 'decrement count' do
      before do
        Message.create(inbox: inbox, outbox: outbox, body: 'Message one', read: true)
        Message.create(inbox: inbox, outbox: outbox, body: 'Message two', read: false)
      end

      it 'increment count by 1' do
        expect { subject }.to change { inbox.reload.unread }.from(0).to(1)
      end
    end
  end
end
