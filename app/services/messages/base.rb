module Messages
  class Base
    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def call
      if create_message
        Inboxes::UpdateUnread.call(inbox)
      end
    end

    private

    def create_message
      Message.create!(body: body, outbox: outbox, inbox: inbox)
    end

    def outbox
      User.current.outbox
    end
  end
end
