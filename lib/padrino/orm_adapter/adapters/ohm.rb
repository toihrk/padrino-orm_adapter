require 'ohm'

module Padrino
  module OrmAdapter
    class Ohm < Base
      # get a list of column names for a given class
      def column_names
        klass.attributes
      end

      # @see OrmAdapter::Base#get!
      def get!(id)
        self.get(id) || fail(Ohm::RecordNotFound)
      end

      # @see OrmAdapter::Base#get
      def get(id)
        klass[wrap_key(id)]
      end

      # @see OrmAdapter::Base#find_first
      def find_first(options = {})
        construct_query(options).first
      end

      # @see OrmAdapter::Base#find_all
      def find_all(options = {})
        construct_query(options).all
      end

      # @see OrmAdapter::Base#create!
      def create!(attributes = {})
        klass.create(attributes)
      end

      # @see OrmAdapter::Base#destroy
      def destroy(object)
      end

      protected
      def construct_query(options)
        conditions, order, limit, offset = extract_conditions!(options)
        #order = order_clause(order)
        
        query = klass.find(conditions)
        #query = query.order(*order) if order
        #query = query.limit(limit) if limit
        #query = query.offset(offset) if offset
        query
      end

    end
  end
end

module Ohm
  class RecordNotFound < Ohm::Error; end

  class Model
    extend Padrino::OrmAdapter::ToAdapter
    self::OrmAdapter = Padrino::OrmAdapter::Ohm

    def to_key
      [self.id.to_s]
    end
  end

end
