class Api::ReportsController < Api::BaseController
skip_before_action :authenticate_user_from_token!, only: [:daily_signups]

  def daily_signups

    @event = Event.friendly.find(params[:id])

    sql = "select to_char(u.created_at, 'YYYY-MM-DD') AS order_date, count(u.id) AS user_count, sum(cost) as total_cost from users u inner join events_users eu on u.id = eu.user_id left outer join orders o on o.events_user_id = eu.id left outer join order_items oi on oi.order_id = o.id where eu.event_id = #{@event.id} group by to_char(u.created_at, 'YYYY-MM-DD') order by to_char(u.created_at, 'YYYY-MM-DD')"

    @data = ActiveRecord::Base.connection.execute(sql)

  end

end
