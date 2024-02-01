count =
  if System.get_env("MANY", "") == "true" do
    7
  else
    0
  end

for index <- 0..count do
  defmodule :"Elixir.TrackerDemoTest#{index}" do
    use ExUnit.Case, async: true

    setup do
      Multiverses.shard(Phoenix.PubSub)
    end

    test "presence" do
      name = "foo-#{unquote(index)}"
      # we're gonna move this to TrackerDemo.PubSub
      TrackerDemo.PubSub.subscribe("my room")

      # we're gonna move this to TrackerDemo.Tracker
      TrackerDemo.Tracker.track(self(), "my room", name, %{name: "John"})

      assert_receive {:join, ^name, %{name: "John"}}
      refute_receive _
    end
  end
end
