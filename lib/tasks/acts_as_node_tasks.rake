desc "Explaining what the task does"
namespace :acts_as_node do
  task :migrate => [:environment] do
    models_path = File.join(Rails.root, 'app', 'models/')
    engines_path = Rails::Application::Railties.respond_to?(:engines) ? Rails::Application::Railties.engines.map {|e| e.config.eager_load_paths.select {|x| x =~ /models$/ }} : []

    [models_path, engines_path].flatten.map do |path|
      Dir[File.join(path,'**','*.rb')].map {|f| require f }
    end

    ::ActiveRecord::Base.descendants.select {|x| x.instance_variable_get("@acts_as_node_loaded") }.map do |model|
      foreign_key = model.instance_variable_get("@acts_as_node_options")[:foreign_key]
      ActiveRecord::Migration.add_column(model.table_name, foreign_key, :integer) unless model.column_names.include?(foreign_key)
    end
  end
end
