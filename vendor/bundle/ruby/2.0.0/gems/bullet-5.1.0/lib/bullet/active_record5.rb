module Bullet
  module SaveWithBulletSupport
    def save(*args)
      was_new_record = new_record?
      super(*args).tap do |result|
        Bullet::Detector::NPlusOneQuery.add_impossible_object(self) if result && was_new_record
      end
    end

    def save!(*args)
      was_new_record = new_record?
      super(*args).tap do |result|
        Bullet::Detector::NPlusOneQuery.add_impossible_object(self) if result && was_new_record
      end
    end
  end

  module ActiveRecord
    def self.enable
      require 'active_record'
      ::ActiveRecord::Base.class_eval do
        class <<self
          alias_method :origin_find, :find
          def find(*args)
            result = origin_find(*args)
            if Bullet.start?
              if result.is_a? Array
                Bullet::Detector::NPlusOneQuery.add_possible_objects(result)
                Bullet::Detector::CounterCache.add_possible_objects(result)
              elsif result.is_a? ::ActiveRecord::Base
                Bullet::Detector::NPlusOneQuery.add_impossible_object(result)
                Bullet::Detector::CounterCache.add_impossible_object(result)
              end
            end
            result
          end
        end
      end

      ::ActiveRecord::Base.prepend(SaveWithBulletSupport)

      ::ActiveRecord::Relation.class_eval do
        alias_method :origin_to_a, :to_a
        # if select a collection of objects, then these objects have possible to cause N+1 query.
        # if select only one object, then the only one object has impossible to cause N+1 query.
        def to_a
          records = origin_to_a
          if Bullet.start?
            if records.first.class.name !~ /^HABTM_/
              if records.size > 1
                Bullet::Detector::NPlusOneQuery.add_possible_objects(records)
                Bullet::Detector::CounterCache.add_possible_objects(records)
              elsif records.size == 1
                Bullet::Detector::NPlusOneQuery.add_impossible_object(records.first)
                Bullet::Detector::CounterCache.add_impossible_object(records.first)
              end
            end
          end
          records
        end
      end

      ::ActiveRecord::Associations::Association.class_eval do
        alias_method :origin_initialize, :initialize
        def initialize(owner, reflection)
          origin_initialize(owner, reflection)
          reflection.set_owner owner
        end
      end

      ::ActiveRecord::Associations::Preloader.class_eval do
        alias_method :origin_preloaders_on, :preloaders_on

        def preloaders_on(association, records, scope)
          if Bullet.start?
            records.compact!
            if records.first.class.name !~ /^HABTM_/
              records.each do |record|
                Bullet::Detector::Association.add_object_associations(record, association)
              end
              Bullet::Detector::UnusedEagerLoading.add_eager_loadings(records, association)
            end
          end
          origin_preloaders_on(association, records, scope)
        end
      end

      ::ActiveRecord::FinderMethods.class_eval do
        # add includes in scope
        alias_method :origin_find_with_associations, :find_with_associations
        def find_with_associations
          return origin_find_with_associations { |r| yield r } if block_given?
          records = origin_find_with_associations
          if Bullet.start?
            associations = (eager_load_values + includes_values).uniq
            records.each do |record|
              Bullet::Detector::Association.add_object_associations(record, associations)
            end
            Bullet::Detector::UnusedEagerLoading.add_eager_loadings(records, associations)
          end
          records
        end
      end

      ::ActiveRecord::Associations::JoinDependency.class_eval do
        alias_method :origin_instantiate, :instantiate
        alias_method :origin_construct_model, :construct_model

        def instantiate(result_set, aliases)
          @bullet_eager_loadings = {}
          records = origin_instantiate(result_set, aliases)

          if Bullet.start?
            @bullet_eager_loadings.each do |klazz, eager_loadings_hash|
              objects = eager_loadings_hash.keys
              Bullet::Detector::UnusedEagerLoading.add_eager_loadings(objects, eager_loadings_hash[objects.first].to_a)
            end
          end
          records
        end

        # call join associations
        def construct_model(record, node, row, model_cache, id, aliases)
          result = origin_construct_model(record, node, row, model_cache, id, aliases)

          if Bullet.start?
            associations = node.reflection.name
            Bullet::Detector::Association.add_object_associations(record, associations)
            Bullet::Detector::NPlusOneQuery.call_association(record, associations)
            @bullet_eager_loadings[record.class] ||= {}
            @bullet_eager_loadings[record.class][record] ||= Set.new
            @bullet_eager_loadings[record.class][record] << associations
          end

          result
        end
      end

      ::ActiveRecord::Associations::CollectionAssociation.class_eval do
        # call one to many associations
        alias_method :origin_load_target, :load_target
        def load_target
          records = origin_load_target

          if Bullet.start?
            Bullet::Detector::NPlusOneQuery.call_association(@owner, @reflection.name) unless @inversed
            if records.first.class.name !~ /^HABTM_/
              if records.size > 1
                Bullet::Detector::NPlusOneQuery.add_possible_objects(records)
                Bullet::Detector::CounterCache.add_possible_objects(records)
              elsif records.size == 1
                Bullet::Detector::NPlusOneQuery.add_impossible_object(records.first)
                Bullet::Detector::CounterCache.add_impossible_object(records.first)
              end
            end
          end
          records
        end

        alias_method :origin_empty?, :empty?
        def empty?
          if Bullet.start? && !@reflection.has_cached_counter?
            Bullet::Detector::NPlusOneQuery.call_association(@owner, @reflection.name)
          end
          origin_empty?
        end

        alias_method :origin_include?, :include?
        def include?(object)
          if Bullet.start?
            Bullet::Detector::NPlusOneQuery.call_association(@owner, @reflection.name)
          end
          origin_include?(object)
        end
      end

      ::ActiveRecord::Associations::SingularAssociation.class_eval do
        # call has_one and belongs_to associations
        alias_method :origin_reader, :reader
        def reader(force_reload = false)
          result = origin_reader(force_reload)
          if Bullet.start?
            if @owner.class.name !~ /^HABTM_/ && !@inversed
              Bullet::Detector::NPlusOneQuery.call_association(@owner, @reflection.name)
              if Bullet::Detector::NPlusOneQuery.impossible?(@owner)
                Bullet::Detector::NPlusOneQuery.add_impossible_object(result) if result
              else
                Bullet::Detector::NPlusOneQuery.add_possible_objects(result) if result
              end
            end
          end
          result
        end
      end

      ::ActiveRecord::Associations::HasManyAssociation.class_eval do
        alias_method :origin_many_empty?, :empty?
        def empty?
          Thread.current[:bullet_collection_empty] = true
          result = origin_many_empty?
          Thread.current[:bullet_collection_empty] = nil
          if Bullet.start? && !@reflection.has_cached_counter?
            Bullet::Detector::NPlusOneQuery.call_association(@owner, @reflection.name)
          end
          result
        end
      end

      ::ActiveRecord::Reflection::AbstractReflection.class_eval do
        def set_owner(owner)
          @owner = owner
        end

        alias_method :origin_has_cached_counter?, :has_cached_counter?
        def has_cached_counter?
          result = origin_has_cached_counter?
          if Bullet.start? && !result && !Thread.current[:bullet_collection_empty]
            Bullet::Detector::CounterCache.add_counter_cache(@owner, @name)
          end
          result
        end
      end
    end
  end
end
