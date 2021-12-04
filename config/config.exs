import Config

config :cashier,
  products_file: "priv/assets/products.yml",
  rules_file: "priv/assets/rules.yml"

import_config "#{config_env()}.exs"
