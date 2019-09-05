class Api::ResourcesController < Api::BaseController
  skip_before_action :authenticate_user_from_token!, only: [:index, :create]

  def index
    if params[:resource_type_id]
      @resources = Resource.where("id != 0 AND private = false AND resource_type_id = ?", params[:resource_type_id])
    else
      @resources = Resource.where("id != 0 AND private = false")
    end
    @current_user = get_user!
  end

  def create
    resource = Resource.new(resource_params["resource"])
    resource.price ||= 0
    resource.private = false

    return unless save(resource)

    if resource_params["tier"]
      tier_resource = TierResource.new
      tier_resource.tier_id = resource_params["tier"]["tier_id"]
      tier_resource.resource_id = resource.id
      tier_resource.price = resource.price
      return unless save(tier_resource)

      @tier_resource = tier_resource
    end

    @resource = resource


  end

  def destroy
    tier_id = params[:tier_id]
    resource_id = params[:resource_id]
    event = Event.joins([{tiers: :tier_resources}])
                  .where("tier_resources.resource_id = ? AND tier_resources.tier_id = ?", resource_id, tier_id)
                  .friendly.find(params[:id])

    if (event && event.created_by == @current_user.id) || @current_user.admin
      begin
        ActiveRecord::Base.transaction do
          tier_resource_count = TierResource.where(:tier_id => tier_id).count

          if tier_resource_count <= 1
            raise "You cannot delete the last resource.  Please add another and delete this one."
          else
            tr = TierResource.where("resource_id = ? AND tier_id = ?", resource_id, tier_id).first
            tr.destroy unless tr.blank?

            r = Resource.where("id <> 0 AND private = TRUE AND id = ?", resource_id).first
             r.destroy unless r.blank?
          end
        end
      rescue ActiveRecord::RecordInvalid => ex
        # Note: RecordInvalid returns the invalid object in ex.record so we use
        # render_errors to render the validation errors. 
        render_errors ex.record, 400
        return
      end

    else
      raise "You don't have access to perform this action"
    end

  end

  private

  def resource_params
    params.permit(resource: [:name, :description, :price, :resource_type_id], tier:[:tier_id])
  end

end
