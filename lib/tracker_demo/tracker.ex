defmodule TrackerDemo.Tracker do
  use Phoenix.Tracker

  @tracker Application.get_env(:tracker_demo, Phoenix.Tracker)
  @pubsub Application.get_env(:tracker_demo, Phoenix.PubSub)

  ## API

  def track(pid, topic, name, meta) do
    @tracker.track(__MODULE__, pid, topic, name, meta)
  end

  ## Genserver shit

  def start_link(opts) do
    opts = Keyword.merge([name: __MODULE__], opts)
    @tracker.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    server = Keyword.fetch!(opts, :pubsub_server)
    {:ok, %{pubsub_server: server, node_name: @pubsub.node_name(server)}}
  end

  def handle_diff(diff, state) do
    for {topic, {joins, leaves}} <- diff do
      for {key, meta} <- joins do
        msg = {:join, key, meta}
        @pubsub.direct_broadcast!(state.node_name, state.pubsub_server, topic, msg)
      end

      for {key, meta} <- leaves do
        msg = {:leave, key, meta}
        @pubsub.direct_broadcast!(state.node_name, state.pubsub_server, topic, msg)
      end
    end

    {:ok, state}
  end
end
