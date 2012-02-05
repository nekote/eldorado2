class MessagesController < ApplicationController
  
  before_filter :redirect_home, :only => [:new, :edit, :update]
  before_filter :require_login, :only => [:create]
  before_filter :can_edit, :only => [:destroy]
  skip_filter :update_online_at, :get_layout_vars, :only => [:create, :more, :refresh, :refresh_chatters]
  
  def index
    @messages = Message.get(session[:online_at])
    current_user.update_attribute('chatting_at', Time.now.utc) if logged_in?

      Pusher.app_id = '5290'
      Pusher.key = '558c123ff5b757fa50bf'
      Pusher.secret = '3b8557c777ac565a0350'
      if [1799,1944,1945,1946,1947,1948].include?(current_user.id)
        Pusher['TheEEStory'].trigger('public_chat', 
        { :type => 'member_present', :logged_in => 1, 
          :culogin => current_user.login, :cuid => current_user.id
        })
      end

    @chatters = User.chatting
    unless @messages.empty?
      session[:message_id] = @messages.map(&:id).max
      @last_message = @messages.map(&:id).min
    end
  end
  
  def show
    @message = Message.find(params[:id])
  end
  
  def create
    @message = current_user.messages.build(params[:message])
    if @message.save
      Pusher.app_id = '5290'
      Pusher.key = '558c123ff5b757fa50bf'
      Pusher.secret = '3b8557c777ac565a0350'
      Pusher['TheEEStory'].trigger('public_chat', 
      { :message => (render :partial => @message), :musr => @message.user_id, 
        :mid => @message.id, :mutc => @message.created_at.to_i,
#        :cuoffset => @message.created_at.utc_offset,   # maybe show poster's TZ - but .nil blows utc_offset
        :type => 'msg'
      })
      if [1799,1944,1945,1946,1947,1948].include?(current_user.id)
        Pusher['TheEEStory'].trigger('public_chat', 
        { :type => 'tester_posted', :logged_in => 1, 
          :culogin => current_user.login, :cuid => current_user.id
        })
      end
    else
      render :nothing => true
    end
  end
  
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to chat_url
  end
  
  def more
    @messages = Message.more(params[:id])
    @last_message = @messages.map(&:id).min unless @messages.empty?
    render :update do |page|
      page.insert_html :bottom, 'messages-index', :partial => 'messages', :object => @messages
      page.replace_html 'messages-more', :partial => 'more', :object => @last_message
      page.remove 'messages-more' if @messages.size < 100
    end
  end
  
  def refresh
    render :nothing => true # deprecated
  end
  
  def refresh_chatters
    current_user.update_attribute('chatting_at', Time.now.utc) if logged_in?
    @chatters = User.chatting
    if @chatters
      render :update do |page|
        page.redirect_to logout_path if logged_in? && current_user.logged_out?
        page.replace_html 'chatters', :partial => 'chatters', :object => @chatters
      end
    end
  end  
end