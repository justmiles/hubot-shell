# hubot-shell
   Attaches node's child_process module to hubot for easy interaction with the host. Useful for a wide range of
     troubleshooting.

# Installation:
   hubot-slack - Currently only configured to work with the hubot-slack adapter

# Optional Dependencies:
   hubot-auth - Required to specify role for bash users. Defaults to allow anyone shell access.

# Configuration:
   SHELL_ROLE - Role authorized to execute bash commands from hubot. Requires hubot-auth
   SHELL_ROOM - Limit shell commands to a specific room. Useful to peer review of actions

# Commands:
    `hubot shell <command>` - Executes a subprocess and sends stdout upon completion. Waits for command to complete before responding.
    `hubot spawn shell <command>` -  Spawns a subprocess and streams stdout back to chat. Useful for viewing stdout in real-time.

# Usage:

```
justmiles> pawn ping 8.8.8.8 -c 4

hubot> PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
hubot> 64 bytes from 8.8.8.8: icmp_seq=1 ttl=43 time=7.31 ms

hubot> 64 bytes from 8.8.8.8: icmp_seq=2 ttl=43 time=9.50 ms

hubot> 64 bytes from 8.8.8.8: icmp_seq=3 ttl=43 time=14.0 ms

hubot> 64 bytes from 8.8.8.8: icmp_seq=4 ttl=43 time=7.27 ms

hubot> 
    --- 8.8.8.8 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3011ms
    rtt min/avg/max/mdev = 7.276/9.526/14.015/2.744 ms
```