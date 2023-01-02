module IssuingScripts
  class Create
    class << self
      def call
        ActiveRecord::Base.transaction do
          Messages::Automatic.new.call
          Payments::PaymentProviderFactory::Create.call
          Payments::Create.call
        end
      end
    end
  end
end
