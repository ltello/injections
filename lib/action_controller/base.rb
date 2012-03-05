class ActionController::Base

  # Method executed after an explicit or implicit call to render in a controller.
  # It is really a wrap of the render Rails method:
  #  1.- Execute first callbacks of type :render
  #  2.- Execute known Rails render.
  def render_with_before_render_filter(*opts, &blk)
    run_callbacks :render, action_name do
      render_without_before_render_filter(*opts, &blk)
    end
  end

  # Calls to render are derived to render_with_before_render_filter
  alias_method_chain :render, :before_render_filter

  # Define callbacks of type :render
  define_callbacks :render
end
