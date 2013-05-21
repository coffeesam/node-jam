#!/usr/bin/env node
require('shelljs/global')

DrumMachine = require './drum_machine'

midi  = require 'midi'
midiOut = new midi.output

try
  midiOut.openPort(0)
catch error
  midiOut.openVirtualPort ''

exec 'sox -d ./output/jam.mp3 trim 0 00:20', (code, output) ->
  process.exit()

dm = new DrumMachine(midiOut)
dm.bpm = 120

# dm.set <instrument>, <step nos> (, <velocity>)
dm.set 'hihat', [1, 3, 5, 7, 9, 11, 13, 15], 100
dm.set 'hihat', [2, 4, 6, 8, 10, 12, 14, 16], 39
dm.set 'kick', [1, 4, 7, 11]
dm.set 'snare', [5, 13]

# extra bits added for fun
dm.set 'cowbell', [2, 4, 7, 12], 20
dm.set 'cowbell', [3, 5, 8, 13], 80
dm.set 'crash', [15], 20
dm.set 'clap', [5, 13], 80
dm.set 'clap', [16], 50

dm.play()

process.addListener "SIGTERM", ->
  dm.stop
  midiOut.closePort()