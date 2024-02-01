defmodule TrackerDemo.PubSub do
  @pubsub Application.compile_env(:tracker_demo, Phoenix.PubSub)

  def subscribe(topic) do
    @pubsub.subscribe(__MODULE__, topic)
  end
end
