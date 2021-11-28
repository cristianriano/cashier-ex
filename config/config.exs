import Config

config :cashier,
  products_file: "config/assets/products.yml",
  rules_file: "config/assets/rules.yml"

import_config "#{config_env()}.exs"
