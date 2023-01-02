module Payments
  class Create
    class << self
      def call
        create_payment
      end

      private

      def create_payment
        Payment.create!(user: User.current)
      end
    end
  end
end
