defmodule CharacterGenerator.Application do
  use Application

  def start(_type, _args) do
    {:ok, pid} = Task.Supervisor.start_link()
    main_task(pid)
    {:ok, pid}
  end

  def main_task(pid), do: Task.Supervisor.async(pid, __MODULE__, :main, [args])

  def main(args) do
    Mix.Project.get.project[:escript][:main_module].main(args)
  end

  def args(), do: :init.get_plain_arguments |> Enum.map(&to_string/1)
end

