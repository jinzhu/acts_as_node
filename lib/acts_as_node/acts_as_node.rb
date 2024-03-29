module Acts
  class AsNode < Rails::Engine
    module Base
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_node(options={})
          return if instance_variable_get("@acts_as_node_loaded")
          instance_variable_set("@acts_as_node_loaded", true)
          options = {:name => 'node', :foreign_key => 'node_id'}.merge(options)
          instance_variable_set("@acts_as_node_options", options)

          belongs_to options[:name], :class_name => 'Node'

          compatible_default_scope %(where("/* SOFT_DELETE_DEFAULT_SCOPE */ `#{self.table_name}`.`#{options[:foreign_key]}` = ?", ::Node.current))

          before_save :_assign_node_id
          define_method "_assign_node_id" do |*opts|
            self.send("#{options[:foreign_key]}=", ::Node.current.id) if self.send(options[:foreign_key]).blank?
          end
        end

        def compatible_default_scope(scope_str)
          if Rails.version >= "3.1.0"
            if public_methods.include?(:default_scope)
              original_method_name = "_#{rand.object_id.abs}_#{self.name.underscore.gsub('/', '__')}_default_scope"
              class_eval <<-SCOPE
                class << self
                  alias :#{original_method_name} :default_scope
                  def default_scope
                    #{original_method_name}.#{scope_str}
                  end
                end
              SCOPE
            else
              class_eval <<-SCOPE
                def self.default_scope
                  #{scope_str}
                end
              SCOPE
            end
          else
            class_eval <<-SCOPE
              default_scope #{scope_str}
            SCOPE
          end
        end
      end
    end

    initializer :insert_acts_as_node, :before => :load_config_initializers do
      ActiveRecord::Base.send :include, ::Acts::AsNode::Base
    end
  end
end
