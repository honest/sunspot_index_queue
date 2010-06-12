require 'rubygems'
require File.expand_path('../../lib/sunspot_index_queue', __FILE__)

module Sunspot
  class IndexQueue
    module Test
      class DataAccessor < Sunspot::Adapters::DataAccessor
        def load (id)
          Searchable.new(id)
        end
      end
      
      class InstanceAdapter < Sunspot::Adapters::InstanceAdapter
        def id
          @instance.id
        end
      end
      
      class Searchable
        attr_reader :id
        def initialize (id)
          @id = id
        end
        
        class Subclass < Searchable
          def self.base_class
            Searchable
          end
        end
      end
      
      Sunspot::Adapters::InstanceAdapter.register(InstanceAdapter, Searchable)
      Sunspot::Adapters::DataAccessor.register(DataAccessor, Searchable)
    end
    
    module Entry
      class MockImpl
        include Entry
        
        attr_reader :record_class_name, :record_id
        
        def initialize (options = {})
          if options[:record]
            @record_class_name = options[:record].class.name
            @record_id = options[:record].id.to_s
          else
            @record_class_name = options[:record_class_name]
            @record_id = options[:record_id].to_s
          end
          @operation = options[:operation] || :update
        end
        
        def update?
          @operation == :update
        end
        
        def delete?
          @operation == :delete
        end
        
        def id
          object_id
        end
      end
    end
  end
end

