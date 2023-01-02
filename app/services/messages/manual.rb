module Messages
  class Manual < Base
    def body
      params[:body]
    end

    def inbox
      if User.current.inbox.messages.last.created_at.between?((Date.today - 7.days).beginning_of_day,
                                                              Date.today.end_of_day)
        return User.default_doctor.inbox
      end

      User.default_admin.inbox
    end
  end
end
