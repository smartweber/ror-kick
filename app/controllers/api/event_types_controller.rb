class Api::EventTypesController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:index]

  def index
    @event_types = EventType.where.not(id: 0).all
  end
end
