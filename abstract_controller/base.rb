class AbstractController::Base

  # Define before_render.
  # It is a new callback executed just after an action in a controller before rendering any view.
  # You may use it the same way you use before_filter. It accepts the sama options and even a block.
  #
  # Ex: class MyController < ApplicationController
  #       before_render :log_action, :only => [:show]
  #
  #       def show
  #         ...
  #       end
  #
  #       # more action definitions
  #
  #       private
  #         def log_action
  #           Rails.logger "Executed action: #{controller.name}-#{action_name}"
  #         end
  #
  def self.before_render_filter(*names, &blk)
    _insert_callbacks(names, blk) do |name, options|
      set_callback(:render, :before, name, options)
    end
  end

  instance_eval do
    alias :before_render :before_render_filter
  end
end

