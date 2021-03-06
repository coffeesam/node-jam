// Generated by CoffeeScript 1.3.3
(function() {
  var DrumMachine;

  DrumMachine = (function() {

    function DrumMachine(midi) {
      var i;
      this.midi = midi;
      this.playing = false;
      this.bpm = 160;
      this.currentStep = 1;
      this.totalSteps = 16;
      this.steps = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 1; _i <= 64; i = ++_i) {
          _results.push([]);
        }
        return _results;
      })();
    }

    DrumMachine.prototype.instruments = {
      kick: 36,
      hihat: 42,
      clap: 39,
      snare: 40,
      cowbell: 56,
      crash: 49
    };

    DrumMachine.prototype.barDuration = function() {
      return 60000 / this.bpm * 4;
    };

    DrumMachine.prototype.stopNote = function(note) {
      return this.midi.sendMessage([128, note, 0]);
    };

    DrumMachine.prototype.playNote = function(note, velocity, duration) {
      var _this = this;
      if (!this.playing) {
        return;
      }
      velocity += Math.floor(Math.random() * 20) - 10;
      if (velocity < 0) {
        velocity = 0;
      }
      if (velocity > 127) {
        velocity = 127;
      }
      this.midi.sendMessage([144, this.instruments[note], velocity]);
      return setTimeout(function() {
        return _this.stopNote(note);
      }, duration);
    };

    DrumMachine.prototype.playStep = function(step) {
      var note, _i, _len, _ref, _results;
      _ref = this.steps[step];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        note = _ref[_i];
        _results.push(this.playNote(note[0], note[1], 40));
      }
      return _results;
    };

    DrumMachine.prototype.play = function() {
      var lp,
        _this = this;
      this.playing = true;
      return lp = setInterval(function() {
        _this.playStep(_this.currentStep - 1);
        _this.currentStep++;
        if (_this.currentStep === _this.totalSteps + 1) {
          _this.currentStep = 1;
        }
        if (!_this.playing) {
          return clearInterval(lp);
        }
      }, this.barDuration() / this.totalSteps);
    };

    DrumMachine.prototype.set = function(instrument, steps, velocity) {
      var step, _i, _len, _results;
      if (velocity == null) {
        velocity = 127;
      }
      _results = [];
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        step = steps[_i];
        _results.push(this.steps[step - 1].push([instrument, velocity]));
      }
      return _results;
    };

    DrumMachine.prototype.pause = function() {
      return this.playing = false;
    };

    DrumMachine.prototype.stop = function() {
      this.pause();
      this.currentStep = 1;
      this.midi.sendMessage([252, 0, 0]);
      return this.midi.sendMessage([176, 123, 0]);
    };

    return DrumMachine;

  })();

  module.exports = DrumMachine;

}).call(this);
