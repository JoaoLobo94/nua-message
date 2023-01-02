module Inboxes
  class UpdateUnread
    class << self
      def call(inbox)
        inbox.update(unread: count_unread_messages(inbox))
      end

      private

      def count_unread_messages(inbox)
        inbox.messages.unread.count
      end
    end
  end
end
