# Base62Id

Base62Id Ecto type

## Usage

Create migration for id generation:

```
mix base62id.install
```

Migrate:

```
mix ecto.migrate
```

In migration:

```elixir
create_if_not_exists table(:products, primary_key: false) do
  add :id, :bigint, primary_key: true, default: fragment("id_generator()")
  # ...
end
```

In model schema:

```elixir
@primary_key {:id, Ecto.Base62Id, read_after_writes: true}
```
