module Bagpipes
  module Models
    module Topic
      def self.included(base)
        base.class_eval do
          validates_presence_of :title
          validates_presence_of :forum_id
          validates_presence_of :forum_type

          has_many :messages, :dependent => :destroy
          belongs_to :forum, :polymorphic => true

          named_scope :by_title, :order => 'title ASC'
        end
      end

      def last_message
        @last_message ||= messages.by_recency.first || self
      end
    end
  end
end
