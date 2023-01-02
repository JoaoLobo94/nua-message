class MessagesController < ApplicationController
  def index
    @messages = case params[:user_type]
                when 'Doctor'
                  User.default_doctor.inbox.messages.where(read: read).paginate(page: params[:page], per_page: 2)
                when 'Admin'
                  User.default_admin.inbox.messages.where(read: read).paginate(page: params[:page], per_page: 2)
                when 'Patient'
                  User.current.inbox.messages.where(read: read).paginate(page: params[:page], per_page: 2)
                else
                  Message.all.paginate(page: params[:page], per_page: 2)
                end
  end

  def show
    @message = Message.find(params[:id])
    @message.update(read: true)
    Inboxes::UpdateUnread.call(@message.inbox)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Messages::Manual.new(message_params).call

    redirect_to :messages if @message
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def read
    params[:read] == 'Read'
  end
end
