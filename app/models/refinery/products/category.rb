module Refinery
  module Products
    class Category < Refinery::Core::BaseModel
      extend FriendlyId

      translates :title, :slug

      friendly_id :friendly_id_source, :use => [:slugged, :globalize]

      validates :title, :presence => true, :uniqueness => true

      acts_as_indexed :fields => [:title]

      # If title changes tell friendly_id to regenerate slug when
      # saving record
      def should_generate_new_friendly_id?
        title_changed?
      end

      def friendly_id_source
        title
      end

    end
  end
end
