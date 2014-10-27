module Refinery
  module Products
    class Category < Refinery::Core::BaseModel
      extend FriendlyId

      translates :title, :slug

      friendly_id :friendly_id_source, :use => [:slugged, :globalize]

      validates :title, :presence => true, :uniqueness => true

      # To enable admin searching, add acts_as_indexed on searchable fields, for example:
      #
      #   acts_as_indexed :fields => [:title]

    end
  end
end
