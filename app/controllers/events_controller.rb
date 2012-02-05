class EventsController < ApplicationController
  
  before_filter :require_login, :except => [:index, :show]
  before_filter :can_edit, :only => [:edit, :update, :destroy]
  
  def index
#
# Check to see if supplied date is out of range
#
    yeartest = params[:date].nil? ? Time.now.utc.strftime("%Y-%m-%d") : params[:date]
    if yeartest[0..3] < '1902' || yeartest[0..3] > '2037'
       flash[:notice] = "32 bit limitation issue requires date >1901 and <2038 ... See http://en.wikipedia.org/wiki/Year_2038_problem"
       yeartest =  Time.now.utc.strftime("%Y-%m-%d")
    end
    @date = Time.parse(yeartest)
    @events = Event.find(:all, :conditions => ['date between ? and ?', @date.strftime("%Y-%m") + '-01', @date.next_month.strftime("%Y-%m") + '-01'])
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
  end

  def create
    @event = current_user.events.build(params[:event])
    if @event.save
      redirect_to @event and return true
    else
      render :action => "new"
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to @event
    else
      render :action => "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url
  end
end
