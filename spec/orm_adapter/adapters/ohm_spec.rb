require 'spec_helper'
require 'orm_adapter/example_app_shared'

if !defined?(Ohm) || !(Ohm.redis.call "INFO" rescue nil)
  puts "** require 'ohm' and start redis to run the specs in #{__FILE__}"
else
  module OhmOrmSpec
    class User < Ohm::Model
      attribute  :name
      attribute  :rating
      collection :notes, :Note

      index :name
      index :rating
    end

    class Note < Ohm::Model
      attribute :body
      reference :owner, :User

      index :body
    end

    describe Padrino::OrmAdapter::Ohm do
      before do
        User.all.each(&:delete)
        Note.all.each(&:delete)
      end

      it_should_behave_like "example app with orm_adapter" do
        let(:user_class) { User }
        let(:note_class) { Note }

        def create_model(klass, attrs = {})
          klass.create(attrs)
        end

        def reload_model(model)
          model.class[model.id]
        end
      end
    end
  end
end
