import Config

config :cashier,
  products_file: "config/assets/products.yml"

import_config "#{config_env()}.exs"
