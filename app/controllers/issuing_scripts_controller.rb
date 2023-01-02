class IssuingScriptsController < ApplicationController
  def create
    IssuingScripts::Create.call

    redirect_to :messages, notice: 'Success.'
  end
end
