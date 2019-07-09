defmodule Mix.Tasks.Base62Id.Install do
  @shortdoc "generates create_base62id_generator migration file for your database"

  use Mix.Task

  import Macro, only: [underscore: 1]
  import Mix.Generator

  def run(_args) do
    path = Path.relative_to("priv/repo/migrations", Mix.Project.app_path())
    file = Path.join(path, "#{timestamp()}_#{underscore(CreateBase62IdGenerator)}.exs")
    create_directory(path)

    create_file(file, """
    defmodule Repo.Migrations.CreateBase62IdGenerator do
      use Ecto.Migration

      def up do
        execute "CREATE SEQUENCE global_id_sequence;"

        execute \"\"\"
          CREATE OR REPLACE FUNCTION id_generator(OUT result bigint) AS $$
          DECLARE
              our_epoch bigint := 1496675741352;
              seq_id bigint;
              now_millis bigint;
              shard_id int := 1;
          BEGIN
              SELECT nextval('global_id_sequence') % 1024 INTO seq_id;

              SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
              result := (now_millis - our_epoch) << 23;
              result := result | (shard_id << 10);
              result := result | (seq_id);
          END;
          $$ LANGUAGE PLPGSQL;
        \"\"\"

        execute "SELECT id_generator();"
      end
    end
    """)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end
