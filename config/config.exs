import Config

config :tracker_demo, Phoenix.PubSub, Phoenix.PubSub
config :tracker_demo, Phoenix.Tracker, Phoenix.Tracker

if config_env() == :test do
  config :tracker_demo, Phoenix.PubSub, Multiverses.PubSub
  config :tracker_demo, Phoenix.Tracker, Multiverses.Tracker
end