# Kvserver

TCP echo server, broadcasting to all connected clients.

Start server:
```
$ iex -S mix
```

In another window:

```
$ telnet localhost 4040
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
foobar
foobar
```

`foobar` is echoed back.

In a third window:

```
$ telnet localhost 4040
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Broadcast it
Broadcast it
```

Back in the "foobar" window, we now see:

```
$ telnet localhost 4040
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
foobar
foobar
Broadcast it
```

Typing `foo2` in that "foobar" window, we see it in the "Broadcast it" window:

```
$ telnet localhost 4040
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Broadcast it
Broadcast it
foo2
```

In the iex window:

```
iex(1)> MessageAgent.get_clients()
[#Port<0.8>, #Port<0.7>]
iex(2)> 
```

In the "foobar" window, quit telnet (control-esc and "quit"):

```aidl
$ telnet localhost 4040
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
foobar
foobar
Broadcast it
foo2
foo2
^]
telnet> quit
Connection closed.
```

We see it gone from the client list:

```
iex(2)> MessageAgent.get_clients()
[#Port<0.8>]
```

Typing another message in the remaing telnet session echoes it back as expected:

```
$ telnet localhost 4040
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Broadcast it
Broadcast it
foo2
foo3
foo3
```