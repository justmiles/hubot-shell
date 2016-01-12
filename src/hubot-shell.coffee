# Description:
#   Attaches node's child_process module to hubot for easy interaction with the host. Useful for a wide range of
#     troubleshooting.
#
# Dependencies:
#   hubot-slack - Currently only configured to work with the hubot-slack adapter
#
# Optional Dependencies:
#   hubot-auth - Required to specify role for bash users. Defaults to allow anyone shell access.
#
# Configuration:
#   SHELL_ROLE - Role authorized to execute bash commands from hubot. Requires hubot-auth
#   SHELL_ROOM - Limit shell commands to a specific room. Useful to peer review of actions
#
# Commands:
#   hubot shell <command>  = Executes a subprocess and sends stdout upon completion. Waits for command to complete before responding.
#   hubot spawn shell <command> = Spawns a subprocess and streams stdout back to chat. Useful for viewing stdout in real-time.
#
# Author:
#  justmiles

cp = require 'child_process'

respond = (msg, str, wrap = '```') ->
  len = 3000
  _size = Math.ceil(str.length / len)
  _ret = new Array(_size)
  _offset = undefined
  _i = 0
  while _i < _size
    _offset = _i * len
    _ret[_i] = str.substring(_offset, _offset + len)
    _i++


  msg.send "#{wrap}#{_ret[0]}#{wrap}"
  unless _ret.length == 1
    x = 1
    setInterval (->
      msg.send "#{wrap}#{x+1} of #{_ret.length}\n#{_ret[x]}#{wrap}"
      if _ret.length == x+1
        clearInterval this
      else
        x++
    ), 2000

class SlackShell

  spawnCommand : (command, msg) ->
    args = command.split(' ')
    process = args.splice(0, 1)
    @spawnCommandArgs process[0], args, msg

  spawnCommandArgs : (command, args, msg) ->
    stdout = undefined
    runonce = false

    spawn = cp.spawn(command, args)
    return msg.send "Error executing command `#{command}`." unless spawn.pid

    timeOutId = setTimeout (->
      msg.send "You've spawned a long running process. \n PID: `#{spawn.pid}`  \nCommand: `#{command} #{args.join(' ')}`"
    ), 10000

    intervalId = setInterval (->
      if stdout
        respond msg, stdout
        stdout = undefined
    ), 1000

    spawn.stdout.on 'data', (data) ->
      respond msg, data.toString() unless runonce
      return runonce = true unless runonce
      stdout or= ''
      stdout += data

    spawn.stderr.on 'data', (data) ->
      respond msg, data.toString()
      clearTimeout timeOutId

    spawn.on 'close', (code) ->
      clearTimeout timeOutId
      setTimeout (->
        clearInterval intervalId
      ), 2000

      if code != 0
        msg.reply "Command `#{command}` exited with exit code `#{code}`"

  execCommand : (command, msg) ->
    cp.exec command, (error, stdout, stderr) ->

      if stdout? && stdout != ''
        respond msg, stdout

      if stderr? && stderr != ''
        msg.send "`STDERR`"
        respond msg, stderr

module.exports = (robot) ->
  shell = new SlackShell()
  authorized = (msg) ->
    return true unless process.env.SHELL_ROLE? or process.env.SHELL_ROOM?

    if process.env.SHELL_ROLE?
      unless robot.auth?.hasRole(msg.envelope.user, process.env.SHELL_ROLE)
        msg.send "Forbidden - Shell actions can only be performed by users with the `#{process.env.SHELL_ROLE}` role"
        return false

    if process.env.SHELL_ROOM?
      unless msg.envelope.room == process.env.SHELL_ROOM
        msg.send "Forbidden - Shell actions can only be performed in ##{process.env.SHELL_ROOM}"
        return false

    return true

  robot.respond /(sh|spawn shell) (.*)/i, (msg) ->
    return unless authorized(msg)
    shell.spawnCommand msg.match[2], msg

  robot.respond /(shell|bash|exec) (.*)/i, (msg) ->
    return unless authorized(msg)
    shell.execCommand msg.match[2], msg
