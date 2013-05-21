# Simple 16 step drum machine experiment with Node and CoffeeScript
#   by Peter Cooper - @peterc
#
#   Inspired by Giles Bowkett's screencast at
#   http://gilesbowkett.blogspot.com/2012/02/making-music-with-javascript-is-easy.html
#
#   Screencast demo of this code at http://www.youtube.com/watch?v=qWKkEaKL6DQ
#
# Required:
#   node, npm and coffee-script installed
#
# To run:
#   npm install midi
#   run up Garageband
#   create a software instrument (ideally a "drum kit")
#   run this script with "coffee [filename]"
#   ctrl+c to exit
#   customize the drum steps at the footer of this file
#
#   Yeah, not great OOD for real, but just a fun Sunday night
#   project for now :-)
#
#   P.S. This is my first CoffeeScript in > 1 year so I have NO IDEA
#   if I'm even vaguely doing it right. But it works. Please leave
#   comments with code improvements to help me learn!

 
class DrumMachine
  constructor: (@midi) ->
    @playing = false
    @bpm = 160
    @currentStep = 1
    @totalSteps = 16                # changeable for different time signatures
    @steps = ([] for i in [1..64])
  
  instruments:
    kick: 36
    hihat: 42
    clap: 39
    snare: 40
    cowbell: 56
    crash: 49
    
  barDuration: ->
    60000 / @bpm * 4
    
  stopNote: (note) ->
    @midi.sendMessage [128, note, 0]
    
  playNote: (note, velocity, duration) ->
    return unless @playing
    velocity += Math.floor(Math.random() * 20) - 10
    velocity = 0 if velocity < 0
    velocity = 127 if velocity > 127
    #console.log "#{note}\t#{("*" for x in [0..(velocity / 7)]).join('')}"
    @midi.sendMessage [144, @instruments[note], velocity]
    setTimeout =>
      @stopNote note
    , duration
  
  playStep: (step) ->
    @playNote(note[0], note[1], 40) for note in @steps[step]
    
  play: ->
    @playing = true
    lp = setInterval =>
      @playStep @currentStep - 1
      @currentStep++
      @currentStep = 1 if @currentStep == @totalSteps + 1
      clearInterval lp unless @playing
    , (this.barDuration() / @totalSteps)
      
  set: (instrument, steps, velocity = 127) ->
    @steps[step - 1].push [instrument, velocity] for step in steps
    
  pause: ->
    @playing = false
  
  stop: ->
    @pause()
    @currentStep = 1
    @midi.sendMessage [252, 0, 0]
    @midi.sendMessage [176, 123, 0]

module.exports = DrumMachine
