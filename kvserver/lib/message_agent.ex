defmodule MessageAgent do
    use Agent

    def start_link(_) do
      Agent.start_link(fn -> [] end, name: :agent)
    end

    def get_clients() do
      Agent.get(:agent, fn clients -> clients end)
    end

    def add_client(client) do
      Agent.update(:agent, fn clients -> [client | clients] end)
    end

    def send(msg) do
      Agent.get(:agent, fn clients -> clients end)
      |> Enum.each(fn client ->
        :ok = :gen_tcp.send(client, msg)
      end)
    end

    def remove_client(client) do
      Agent.get_and_update(:agent, fn state ->
        new = state -- [client]

        {state, new}
      end)
    end
end
