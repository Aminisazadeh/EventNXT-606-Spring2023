class EventsController < ApplicationController
  def index
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    #render json: {event: event}
    if @event.save
      redirect_to @event
    end
    #render_valid(event)
  end

  def update
  end

  private
  def event_params
    params.permit(:title, :address, :datetime, :image, :description, :box_office, :last_modified, :user_id)
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