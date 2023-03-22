class EventsController < ApplicationController
  #before_action :set_event, only: [:show, :edit, :update, :destroy]   # added by AMIN ISAZADEH to associate event and user
  before_action :authenticate_user!, except: [:index, :show]          # added by AMIN ISAZADEH to associate event and user
  before_action :correct_user, only: [:edit, :update, :destroy]       # added by AMIN ISAZADEH to associate event and user

  
  def index
    @events = Event.all       # uncommented by AMIN ISAZADEH to associate event and user
    #@events = Event.where(user_id: 64) # hardcoded needs to be as some type of param   # commented by AMIN ISAZADEH to associate event and user
  end

  def show
    @event = Event.find(params[:id])         # commented by AMIN ISAZADEH to associate event and user
    @event_id = params[:id]
    @seats = Seat.where(event_id: params[:id])
    @guests = Guest.where(event_id: params[:id])
    @res = Seat.left_joins(:guest_seat_tickets, :guests)
              .joins("LEFT JOIN boxoffice_seats ON boxoffice_seats.seat_section = seats.category")
              .select('seats.category,price,total_count,'\
                      'sum(coalesce(committed,0)) as total_committed,'\
                      'sum(coalesce(allotted,0)) as total_allotted,'\
                      'total_count - sum(coalesce(committed,0)) - sum(coalesce(boxoffice_seats.booked_count,0)) as remaining,'\
                      'count(*) filter(where "booked") as total_booked,'\
                      'count(*) filter (where not "booked") as total_not_booked,'\
                      'count(distinct(guest_id)) filter(where "allotted" > 0) as total_guests ,'\
                      'sum(coalesce(committed,0)) * price as balance, '\
                      'sum(coalesce(boxoffice_seats.booked_count,0)) as boxoffice_booked')
              .group('seats.id')
              .where(seats: {event_id: @event.id}, boxoffice_seats: {event_id: @event.id})
    @boxoffice_seats = BoxofficeSeat.where(event_id: params[:id])
  end

  def new
    #@event = Event.new                 # commented by AMIN ISAZADEH to associate event and user
    @event = current_user.events.build  # added by AMIN ISAZADEH to associate event and user
  end
  
  
  
  
  # ========================================================= #
  # Following function is commented by AMIN ISAZADEH #
  
  # def create
  #   par = event_params.to_h
  #   if doorkeeper_token
  #     par[:user_id] = doorkeeper_token[:resource_owner_id]
  #   else
  #     par[:user_id] = warden.authenticate(scope: :public)
  #   end
  
  #   #@event = Event.new(par)                          # commented by AMIN ISAZADEH to associate event and user
  #   @event = current_user.events.build(event_params)  # added by AMIN ISAZADEH to associate event and user
  
  #   #render json: {event: event}
  #   if @event.save
  #     redirect_to @event
  #   end
  #   #render_valid(event)
  # end
  
  # ========================================================= #
  # ========================================================= #




  # ========================================================= #
  # Following function is created by AMIN ISAZADEH #
  
  def create
    @event = current_user.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # ========================================================= #
  # ========================================================= #



  def edit
    @event = Event.find(params[:id])   # commented by AMIN ISAZADEH to associate event and user
  end
  
  
  
  
  
  
  # ========================================================= #
  # Following function is commented by AMIN ISAZADEH #
  
  # def update
  #   @event = Event.find(params[:id])

  #   if @event.update(event_params)
  #     redirect_to @event
  #   else
  #     render :edit
  #   end
  # end
  
  # ========================================================= #
  # ========================================================= #
  
  
  
  # ========================================================= #
  # Following function is created by AMIN ISAZADEH #
  
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # ========================================================= #
  # ========================================================= #
  
  
  
  
  
  # ========================================================= #
  # Following function is commented by AMIN ISAZADEH #
  
  # def destroy
  #   @event = Event.find(params[:id])
  #   @event.destroy

  #   redirect_to root_path
  # end

  # ========================================================= #
  # ========================================================= #  
  
  
  
  
  
  
  # ========================================================= #
  # Following function is created by AMIN ISAZADEH #
  
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  # ========================================================= #
  # ========================================================= #
  
  
  
  
  
  

  def import_new_spreadsheet
    if !params[:file]
      redirect_to root_path
    end
    
    @event = Event.import(params[:file])
    redirect_to @event
  end

  def summary
    res = GuestSeatTicket.joins(:seat, :guest)
              .select('category,price,total_count,'\
                      'sum(committed) as total_committed,'\
                      'sum(allotted) as total_allotted,'\
                      'total_count - sum(committed) as remaining,'\
                      'count(*) filter(where "booked") as total_booked,'\
                      'count(*) filter (where not "booked") as total_not_booked,'\
                      'count(distinct(guest_id)) filter(where "allotted" > 0) as total_guests ,'\
                      'sum(committed) * price as balance')
              .group('seats.id')
              .where(seats: {event_id: params[:event_id]})
    render json: res.to_json, except: [:id]
  end
  
  
  
  
  
  
  
  
  # ========================================================= #
  # Following function is added by AMIN ISAZADEH #
  
  def correct_user
    @event = current_user.event.find_by(id: params[:id])
    redirect_to events_path, notice: "Not Authorized To Edit This Event" if @event.nil?
  end
  
  # ========================================================= #
  # ========================================================= #



  
  

  private
  
  
  
  # ========================================================= #
  # Following function is added by AMIN ISAZADEH #
  
  # Use callbacks to share common setup or constraints between actions.
  
  # def set_event
  #   @event = Event.find(params[:user_id])
  # end
  
  # ========================================================= #
  # ========================================================= #
  
  
  
  
  
  
  def event_params
    #params.permit(:title, :address, :datetime, :image, :description, :last_modified, :box_office, :user_id, :token)                  # commented by AMIN ISAZADEH
    params.require(:event).permit(:title, :address, :datetime, :image, :description, :last_modified, :box_office, :user_id, :token)   # added by AMIN ISAZADEH
  end





  def render_valid(event)
    @event = event
    if event.valid?
      event.image.attach(params[:image]) if params[:image].present?
      event.box_office.attach(params[:image]) if params[:box_office].present?
      #head :ok
      #render json: {event: event, params: params}
      params[:id] = event.id
      @event
    else
      render json: {errors: event.errors.full_messages}, status: :unprocessable_entity
    end
  end
end
