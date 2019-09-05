class Api::EventsController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:index, :show, :search, :calendar]
  before_action :process_avatar, only: [:create, :update]

  include TimeHelper

  def process_avatar
    if params && params[:header_img].present?
      p "**********"
      # p json_data['data'].split(',')[1]
      # p json_data['name']
      p "**********"
      if params[:header_img][:_values] != "no_upload"
        json_data = JSON.parse(params[:header_img][:_values])
        data = StringIO.new(Base64.decode64(json_data['data'].split(',')[1]))
        data.class.class_eval { attr_accessor :original_filename, :content_type }
        data.original_filename = json_data['name']
      # data.content_type = "image/jpeg" # json_data['type'] # params[:header_img][:_values]['type']
        p data
        params[:header_img] = data
      else
        params.delete :header_img
      end
    end
  end

  def search
    lat = params[:location_lat]
    lng = params[:location_lng]

    @current_user = get_user!

    current_user_id = @current_user ? @current_user.id : 0

    search_fields = [:name, :description, :key, :slug, :created_by_first_name, :created_by_last_name]
    where_clause = {
      start: {gt: Time.now},
      or: [[{status: 1}, {created_by_id: current_user_id}, {attendees: current_user_id}]]
    }
    order_by = {
      _score: :desc, created_at: {order: :desc, ignore_unmapped: true}
    }
    if (lat.blank? || lng.blank?)
      @events = Event.search params[:search_term], where: where_clause, order: order_by, fields: search_fields
    else
      @events = Event.search params[:search_term], where: where_clause, order: order_by, fields: search_fields, boost_by_distance: {field: :location, origin: {lat: lat, lon: lng}}
    end

  end

  def index
    time_to_check = Time.now

    @current_user = get_user!

    if @current_user.blank?
      @events = Event.where(status: 1).where("start >= ?", time_to_check ).order(created_at: :desc)
    else
      @events = Event.joins("LEFT OUTER JOIN events_users AS attendees ON events.id = attendees.event_id")
        .where("events.status = 1 OR events.created_by = ? OR attendees.user_id = ?", @current_user.id, @current_user.id)
        .where("start >= ?", time_to_check )
        .order(created_at: :desc)
        .distinct
    end
  end

  def show
    @event = Event.friendly.find(params[:id])
    @current_user = get_user!
    attendees = @event.attendee_list
    orders = EventsUser.users_orders(@event.id)
    @contributed = 0;

    #calculate all money contributed so far
    if orders != nil
      for attendee in attendees
        if orders[attendee.id] != nil
          @contributed += orders[attendee.id]['order_sum'].to_f.round(2)
        end
      end
    end

  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def destroy
    @event = Event.friendly.find(params[:id])

    if @event && (@current_user.admin || (@current_user.id == @event.created_by))
      ActiveRecord::Base.transaction do
        tier_resources = TierResource.where(tier_id: @event.tiers.ids)
        tier_resources_ids = tier_resources.collect(&:resource_id)
        tier_resources.destroy_all

        Resource.where(id: tier_resources_ids).where(private: true).where.not(id: 0).destroy_all

        Tier.where(id: @event.tiers.ids).destroy_all

        EventsUser.where(event_id: @event.id).each do |events_user|
          Order.where(events_user_id: events_user.id).each do |order|
            OrderItem.where(order_id: order.id).destroy_all
            order.destroy
          end

          attendee = User.find(events_user.user_id)
          EventDeletedMailer.event_delete(attendee, @event).deliver_later

          events_user.destroy
        end

        Post.where(event_id: @event.id).destroy_all

        @event.destroy
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  def update
    begin
      @event = Event.friendly.find(params[:id])

      if @event && @event.isHost(@current_user)
        @event.update_attributes(event_params)
      else
        head :unauthorized
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    rescue ActionController::ParameterMissing => e
      render json: { error: e }, status: :bad_request
    end
  end

  def update_resources
    @event = Event.friendly.find(params[:id])
    @resources = params[:resources]

    # tier_resources = TierResource.where(tier_id: @event.tiers.ids)
    # tier_resources_ids = tier_resources.collect(&:resource_id)

    # @event_resources = Resource.where(resource_type_id: tier_resources_ids).where(private: true).where.not(id: 0)

    @resources.each do |r|
      resource = Resource.new
      resource[:id] = r[:resource_id]
      resource[:name] = r[:name]
      resource[:description] = r[:description]
      resource[:price] = r[:price]
      resource[:resource_type_id] = r[:resource_type_id]
      p "RESOURCE___"
      p resource
      resource.save!
      # @event['resources'][0] = resource
    end

    @event.save!
    # @event['resources'][0] = resource
  end

  def create
    begin
      Event.transaction do
        @event = Event.new(event_params)
        @event.created_by = @current_user.id
        @event.key = rand(36**10).to_s(36) # http://stackoverflow.com/a/3572953/105562
        @event.save!

        attendee = EventsUser.new
        attendee.user_id = @current_user.id
        attendee.event_id = @event.id
        attendee.status = 1
        attendee.relation = 1
        attendee.save!
      end

      if Rails.env.production?
        SlackNotify.notification("New Event! #{@event.name} by #{@current_user.first_name} #{@current_user.last_name}: #{@event.short_url_link}")
        SendSms.send_sms("+14157809000", "New Event! #{@event.name} by #{@current_user.first_name} #{@current_user.last_name}: " + @event.short_url_link)
      end

    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    rescue ActionController::ParameterMissing => e
      render json: { error: e }, status: :bad_request
    end
  end

  def calendar
    cal = Icalendar::Calendar.new
    event = Event.friendly.find(params[:id])
    filename = "cal"


    if params[:format] == 'vcs'
      cal.prodid = '-//Microsoft Corporation//Outlook MIMEDIR//EN'
      cal.version = '1.0'
      filename += '.vcs'
    else # ical
      cal.prodid = '-//Acme Widgets, Inc.//NONSGML ExportToCalendar//EN'
      cal.version = '2.0'
      filename += '.ics'
    end

    cal.event do |e|
      tzid = get_time_in_time_zone( event.start, (event.timezone_offset/60) ).strftime("%Z")
      e.dtstart     = Icalendar::Values::DateTime.new( get_time_in_time_zone( event.start, (event.timezone_offset/60) ), tzid: tzid )
      e.dtend       = Icalendar::Values::DateTime.new( get_time_in_time_zone( event.end, (event.timezone_offset/60) ), tzid: tzid )
      e.summary     = event.name
      e.description = Rails::Html::FullSanitizer.new.sanitize(event.description)
      e.url         = ENV["BASE_URL"] + "/events/" + event.slug
      e.location    = event.location_address
    end

      send_data(cal.to_ical, :filename=>filename, :disposition=>"inline; " + filename, :type=>"text/calendar")

  rescue ActiveRecord::RecordNotFound => e
    head :not_found
  end

  private

  def event_params
    params.permit(
        :name,
        :description,
        :profile_img,
        :header_img,
        :slug,
        :location_name,
        :location_address,
        :location_lat,
        :location_lng,
        :status,
        :contact_email,
        :contact_phone,
        :start,
        :end,
        :deadline,
        :timezone_offset,
        :timezone_name,
        :event_type_id,
        :location_city,
        :location_state,
        :location_country,
        :kick_by,
        :header_img,
        tiers_attributes: [
          :id,
          :base_cost,
          :min_attendee_count,
          :max_attendee_count,
          :contribution,
          :contribution_note,
          :cost_per_attendee,
          :calculation_method,
          resources_attributes: [
            :id,
            :resource_id,
            :name,
            :description,
            :price,
            :private,
            :resource_type_id
          ]
        ])
  end

  def resource_params
    params.permit(
    :id,
    tiers: [
      :base_cost,
      :calculation_method,
      :cost_per_attendee
    ],
    resources: [
      :name,
      :description,
      :price,
      :resource_type_id
    ]
    )
  end
end
