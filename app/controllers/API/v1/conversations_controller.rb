# frozen_string_literal: true

module API
  module V1
    class ConversationsController < API::BaseController # :nodoc:
      def index
        conversations = Conversation.order(:started_at => :desc)
        conversations = conversations.where('created_at >= ?', params[:since]) if params[:since]
        conversations = conversations.where('created_at <= ?', params[:to]) if params[:to]

        render_jsonapi_collection_response conversations
      end

      def show
        conversation = Conversation.find(params[:id])
        render_jsonapi_response(conversation)
      end

      def create
        # Conversations cannot be created via API, they are initiated via phone/chat/etc.
        head :forbidden
      end

      def update
        conversation = Conversation.find(params[:id])

        if ConversationPolicy.new(current_user, conversation).update?
          conversation.update!(params.require(:conversation).permit(:conversation_category_id, :notes))

          conversation.tag_groups.each do |tg|
            tg.tag_instances.each do |ti|
              ti.delete
            end
            tg.delete
          end

          if params[:conversation][:tag_groups].present?
            params[:conversation][:tag_groups].each do |group|
              if group[:tags].present?
                tg = TagGroup.new
                tg.conversation_id = conversation.id
                tg.save!

                group[:tags].each do |tag|
                  ti = TagInstance.new
                  ti.tag_id = tag
                  ti.tag_group = tg
                  ti.save!
                end
              end
            end
          end
          
          render_jsonapi_response(conversation)
        else
          head :unauthorized
        end
      end

      def unlogged
        conversations = Conversation.eager_load(:contact).order(:created_at => :desc).unlogged
        render_jsonapi_collection_response(conversations)
      end

      def recent
        conversations = Conversation.eager_load(:contact).order(:updated_at => :desc).recent.logged
        render_jsonapi_collection_response(conversations)
      end

      def by_day
        if params[:since].present?
          since = params[:since]
        else
          since = DateTime.now - 1.month
        end
        if params[:to].present?
          to = params[:to]
        else
          to = DateTime.now
        end

        conversations = Conversation.find_by_sql(["SELECT conversations.created_at::date, COUNT(*) AS all_conversations, COUNT(DISTINCT(contact_id)) AS distinct_contacts FROM conversations LEFT JOIN contact_phones ON conversations.contact_phone_id = contact_phones.id WHERE conversations.created_at >= ? AND conversations.created_at <= ? GROUP BY conversations.created_at::date ORDER BY conversations.created_at::date", since, to])
        render json: conversations
      end

      def by_dow
        if params[:since].present?
          since = params[:since]
        else
          since = DateTime.now - 1.month
        end
        if params[:to].present?
          to = params[:to]
        else
          to = DateTime.now
        end

        conversations = Conversation.find_by_sql(["SELECT EXTRACT(isodow FROM started_at)::INTEGER AS dow, COUNT(*) as all_conversations, COUNT(DISTINCT(contact_id)) AS distinct_contacts FROM conversations LEFT JOIN contact_phones ON conversations.contact_phone_id = contact_phones.id WHERE started_at >= ? AND started_at <= ? GROUP BY 1 ORDER BY 1;", since, to])
        conversations.each do |c|
          if c.dow == 1
            c.dow = 'Sunday'
          elsif c.dow == 2
            c.dow = 'Monday'
          elsif c.dow == 3
            c.dow = 'Tuesday'
          elsif c.dow == 4
            c.dow = 'Wednesday'
          elsif c.dow == 5
            c.dow = 'Thursday'
          elsif c.dow == 6
            c.dow = 'Friday'
          elsif c.dow == 7
            c.dow = 'Saturday'
          end
        end

        render json: conversations
      end

      def by_time_of_day
        if params[:since].present?
          since = params[:since]
        else
          since = DateTime.now - 1.month
        end
        if params[:to].present?
          to = params[:to]
        else
          to = DateTime.now
        end
        
        daysofweek = []

        (1..7).each do |n|
          n = n.to_s
          daysofweek << n.to_s unless params[:dow].present? && params[:dow][n].present? && params[:dow][n].to_i == 0
        end

        if daysofweek.count > 0
          dow_str = "AND EXTRACT(isodow FROM started_at)::INTEGER IN (" + daysofweek.join(', ') + ")"
        else
          dow_str = ""
        end

        if params[:cat].present?
          categories_filter = 'AND conversation_category_id IN ('
          categories_list = []
          params[:cat].each do |k,v|
            if (v == "1")
              categories_list << k
            end
          end
          categories_filter = categories_filter + categories_list.join(', ') + ')'
        else
          categories_filter = ''
        end

        conversations = Conversation.find_by_sql(["WITH series AS (     SELECT generate_series(0, 18, 6) as r_from   ),   range AS (SELECT (r_from || ':00:00') AS r_from, ((r_from + 5)::TEXT || ':59:59'::TEXT) AS r_to FROM series)      SELECT  (   SELECT count(*) FROM conversations WHERE started_at::TIME BETWEEN r_from::TIME AND r_to::TIME AND started_at >= ? AND started_at <= ?  #{dow_str} #{categories_filter} ) AS all_conversations,    (   SELECT COUNT(distinct(contact_id)) FROM conversations LEFT JOIN contact_phones ON conversations.contact_phone_id = contact_phones.id WHERE started_at::TIME BETWEEN r_from::TIME AND r_to::TIME AND started_at >= ? AND started_at <= ? #{dow_str}  ) AS distinct_contacts,  (    SELECT CASE    WHEN r_from = '0:00:00' THEN 'Night'    WHEN r_from = '6:00:00' THEN 'Morning'    WHEN r_from = '12:00:00' THEN 'Afternoon'    WHEN r_from = '18:00:00' THEN 'Evening'    END    ) AS period_label         FROM range;", since, to, since, to])

        render json: conversations
      end

      def by_category
        if params[:since].present?
          since = params[:since]
        else
          since = DateTime.now - 1.month
        end
        if params[:to].present?
          to = params[:to]
        else
          to = DateTime.now
        end

        if params[:cat].present?
          categories_filter = 'AND conversation_category_id IN ('
          categories_list = []
          params[:cat].each do |k,v|
            if (v == "1")
              categories_list << k
            end
          end
          categories_filter = categories_filter + categories_list.join(', ') + ')'
        else
          categories_filter = ''
        end

        conversations = Conversation.find_by_sql(["SELECT conversations.created_at::date, COUNT(*) AS all_conversations, COUNT(DISTINCT(contact_id)) AS distinct_contacts FROM conversations LEFT JOIN contact_phones ON conversations.contact_phone_id = contact_phones.id WHERE conversations.created_at >= ? AND conversations.created_at <= ? #{categories_filter} GROUP BY conversations.created_at::date ORDER BY conversations.created_at::date", since, to])
        render json: conversations
      end
    end
  end
end
