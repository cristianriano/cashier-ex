import Config

priv_folder = :code.priv_dir(:cashier)

config :cashier,
  products_file: Path.join(priv_folder, "assets/products.yml"),
  rules_file: Path.join(priv_folder, "assets/rules.yml")
