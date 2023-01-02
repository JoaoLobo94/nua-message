class PaymentProviderFactory
  def self.provider
    @provider ||= Provider.new
  end
end

class Provider
  def debit_card(user) end;
end
