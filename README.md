# hubot-shell
Attaches node's child_process module to hubot for easy interaction with the host. Useful for a wide range of troubleshooting.

## Optional Dependencies:
 - hubot-auth - Required to specify role for shell users. Defaults to allow anyone shell access. This is an obvious security risk so its recommended you use [hubot-auth](https://github.com/hubot-scripts/hubot-auth) and specify a role for shell access with `SHELL_ROLE`. As an alternative, at least restrict shell actions to a peer reviewed chat room by defining `SHELL_ROOM`.

## Configuration:
 - SHELL_ROLE - Role authorized to execute shell commands from hubot. Requires hubot-auth
 - SHELL_ROOM - Limit shell commands to a specific room. Useful to peer review of actions

## Commands:
 - hubot shell `command` - Executes a subprocess and sends stdout upon completion. Waits for command to complete before responding.
 - hubot spawn shell `command` -  Spawns a subprocess and streams stdout back to chat. Useful for viewing stdout in real-time.

## Usage:

```bash
justmiles> shell ping 8.8.8.8 -c 3

hubot> PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=43 time=8.22 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=43 time=8.12 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=43 time=8.27 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2010ms
rtt min/avg/max/mdev = 8.129/8.212/8.278/0.062 ms


justmiles> spawn ping 8.8.8.8 -c 4

hubot> PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.

hubot> 64 bytes from 8.8.8.8: icmp_seq=1 ttl=43 time=7.31 ms

hubot> 64 bytes from 8.8.8.8: icmp_seq=2 ttl=43 time=9.50 ms

hubot> 64 bytes from 8.8.8.8: icmp_seq=3 ttl=43 time=14.0 ms

hubot> 64 bytes from 8.8.8.8: icmp_seq=4 ttl=43 time=7.27 ms

hubot> --- 8.8.8.8 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3011ms
    rtt min/avg/max/mdev = 7.276/9.526/14.015/2.744 ms
```