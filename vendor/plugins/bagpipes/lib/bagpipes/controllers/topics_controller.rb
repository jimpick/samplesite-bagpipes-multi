module Bagpipes
  module Controllers
    module TopicsController
      def self.included(base)
        base.class_eval do
          before_filter :require_member_admin, :only => [:new, :create]

          layout 'bagpipes'
        end
      end

      # TODO: optionally, paginate
      def index
        @topics = Topic.by_title.find(:all, :conditions => {
            :forum_id => current_forum.id,
            :forum_type => current_forum.class.to_s
          })
      end

      def new
        @topic = Topic.new
        @topic.forum = current_forum
      end

      def create
        @topic = Topic.new(params[:topic])
        @topic.forum = current_forum

        if @topic.save
          flash[:notice] = "The topic \"#{@topic.title}\" has been created"
          redirect_to topics_path
        else
          flash[:form_error] = @topic
          render :action => 'new'
        end
      end

      include FlashErrorsHelper
      protected :grab_errors_from_object
      protected :grab_errors_for_flash

      private
      def require_member_admin
        unless logged_in? && current_user.member && current_user.member.administrator?
          flash[:error] = "You must be a forum administrator to do that"
          redirect_to topics_path
        end
      end
    end
  end
end
