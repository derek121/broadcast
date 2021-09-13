defmodule KVServer do
  require Logger

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    {:ok, listening_socket} = :gen_tcp.listen(port,
      [:binary, packet: :line, active: true, reuseaddr: true])

    Logger.info "Accepting connections on port #{port}"

    loop_acceptor(listening_socket)
  end

  defp loop_acceptor(listening_socket) do
    {:ok, client} = :gen_tcp.accept(listening_socket)
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> serve() end)
    :ok = :gen_tcp.controlling_process(client, pid)

    MessageAgent.add_client(client)

    loop_acceptor(listening_socket)
  end

  defp serve() do
    read_line()
    |> write_line()

    serve()
  end

  defp read_line() do
    msg =
      receive do
        {:tcp, _port, msg} ->
          msg

        {:tcp_closed, port} ->
          MessageAgent.remove_client(port)
          nil
      end

    msg
  end

  defp write_line(nil) do
    nil
  end

  defp write_line(msg) do
    MessageAgent.send(msg)
  end
end
