module Messages
  class Automatic < Base
    def body
      "The patient #{User.current.full_name} is requesting a new script."
    end

    def inbox
      User.default_admin.inbox
    end
  end
end
