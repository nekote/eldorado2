class SearchController < ApplicationController    
  def index
    u_cond = " "  # no additional conditional AND clause(s) added is default
    st_cond = " "
    et_cond = " "

    if admin?     # only admins, for the time being
      if params[:lnames] && !params[:lnames].blank? then
        uid = []
        unf = []
        ulist = params[:lnames].split(",").each {|l| l.strip!}
        ulist.each do |u|
          @user = User.find_by_login(u)
#          @user = User.find(:all, :conditions => ['login LIKE ?', '%' + u + '%'], :order => 'login ASC')
          if @user
            uid += [@user.id]
          else
            unf += [u]
          end
          flash[:notice] = 'These user name(s) were not found "' + unf.join('", "') + '"' if !unf.empty?
        end
        if uid.empty?      # none of the non-blank :lnames field were found
          u_cond = " "
        else
          u_cond = ' AND user_id IN(' + uid.join(",") + ') '
        end
      end

      if !params[:interval].nil? && params[:interval].downcase != 'all'
        if params[:interval].to_i >= 1 && params[:interval].to_i <=15000   # .to_i returns 0 if error
          stime = Time.now.utc - 86400 * params[:interval].to_i
        else
          flash[:notice] = 'Interval "' + params[:interval].to_s + '" is not >=1 and <= 15000 days.  1 day substituted for Interval'
          stime = Time.now.utc - 86400
        end
        st_cond = " AND created_at >= '" + stime.strftime('%F') + "' " if stime != " "
      end

      if !params[:start_time].blank? && params[:start_time].downcase != 'all'  # last if over rides 'interval'
        st_cond = " AND created_at >= '" + params[:start_time] + "' "
      end

      if !params[:end_time].blank? && params[:end_time].downcase != 'now'
        et_cond = " AND created_at <= '" + params[:end_time] + "' "
      end
    else
    end

    snf = true   # search not found - no records retrieved
    if params[:type].blank?
      snf = false    # don't flash extra note if :type is blank, for admin version search
      render :template => 'search/index'
#      flash[:notice] = 'Search category blank.  No search done.' if admin?
    elsif params[:query].blank?
      snf = false    # don't flash extra note if :query is blank, for admin version search
      render :template => 'search/index'
#      flash[:notice] = 'No search performed.  Query field for category "' + params[:type] + '" blank.  Consider %% for all?' if admin?
    elsif params[:type] == 'articles'
      @articles = Article.all(:include => :user, :order => 'created_at desc', :conditions => ['(title LIKE ? OR body LIKE ?)' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%'+params[:query]+'%', '%'+params[:query]+'%'])
      snf = @articles.empty?
      render :template => 'articles/archives'
    elsif params[:type] == 'avatars'
      @avatars = Avatar.paginate(:page => params[:page], :include => :user, :order => 'avatars.created_at desc', :conditions => ['filename LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @avatars.empty?
      render :template => 'avatars/index'
    elsif params[:type] == 'events'
      @events = Event.paginate(:page => params[:page], :include => :user, :order => 'events.created_at desc', :conditions => ['title LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @events.empty?
      render :template => 'events/index'
    elsif params[:type] == 'files'
      @uploads = Upload.paginate(:page => params[:page], :include => :user, :order => 'uploads.created_at desc', :conditions => ['filename LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @uploads.empty?
      render :template => 'uploads/index'
    elsif params[:type] == 'headers'
      @headers = Header.paginate(:page => params[:page], :include => :user, :order => 'headers.created_at desc', :conditions => ['filename LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @headers.empty?
      render :template => 'headers/index'
    elsif params[:type] == 'messages'
      @messages = Message.paginate(:page => params[:page], :include => :user, :order => 'messages.created_at desc', :conditions => ['body LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @messages.empty?
      render :template => 'search/messages'
    elsif params[:type] == 'posts'
      @posts = Post.paginate(:page => params[:page], :include => [:user, :topic], :order => 'posts.created_at desc', :conditions => ['body LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @posts.empty?
      render :template => 'topics/show'
    elsif params[:type] == 'topics'
      @topics = Topic.paginate(:page => params[:page], :include => [:user, :last_poster], :order => 'sticky desc, last_post_at desc', :conditions => ['title LIKE ?' + u_cond.to_s + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])
      snf = @topics.empty?
      render :template => 'topics/index'
    elsif params[:type] == 'users'
      @users = User.paginate(:page => params[:page], :order => 'created_at desc', :conditions => ['login LIKE ?' + st_cond.to_s + et_cond.to_s, '%' + params[:query] + '%'])        
      snf = @users.empty?
      render :template => 'users/index'
    end
#    flash[:notice] = "Search found no records.  Possibly the Interval time period is too narrow?  Forgot the %% for all?" if snf && admin?
  end  
end
