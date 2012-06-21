module Mongoid
  module Random

    extend ActiveSupport::Concern

    included do
      field :_randomization_key, type: Float
      before_create :generate_mongoid_random_key

      index_options = { _randomization_key: 1 }
      index_options.merge!(deleted_at: 1) if include?(Mongoid::Paranoia)
      index index_options
    end


    module ClassMethods

      def random(count=1, random_key=rand)
        if where(:_randomization_key => { '$gte' => random_key }).count >= count
          where(:_randomization_key => { '$gte' => random_key })
        elsif where(:_randomization_key => { '$lte' => random_key }).count >= count
          where(:_randomization_key => { '$lte' => random_key })
        else
          where(:_randomization_key.ne => nil)
        end.order_by([ [ [ :_id, :_randomization_key ].sample, [ :asc, :desc ].sample ] ]).limit(count)
      end

    end

  protected

    def generate_mongoid_random_key
      self._randomization_key = rand
    end


  end
end
