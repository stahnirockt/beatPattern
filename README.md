# beatPattern

These are some functions to parse a string like 'x-x-(hc)-[xx:2]-' into a ring of samples, (nested) rings or (nested) arrays to create a nice beat. This is inspired by [foxdot](https://github.com/Qirky/FoxDot).

## How to install
1. (recommended but optional) Download the samples fom [foxdot](https://github.com/Qirky/FoxDot/tree/master/FoxDot/snd) or
create an own sample library. Therefor you have to design the folder structure like 'ownsounds/letter/lower_or_upper/soundfiles' e.g. /soundlibrary/a/lower/bd.wav

2. Open a Buffer in SonicPi and type
```ruby
require 'path/to/beatPattern.rb' # hit run
```

## How to use
### Prepare the beat

setup a beat e.g.
```ruby
beat = setBeat('x-[x:3x](-h[-:3-]h:2)',
sample_path: 'path/to/foxdot_snd/') #necessary if you want to use the foxdot samples
```
you can store the path to the foxdot samples in a variable and use it e.g.
```ruby
foxdot = 'path/to/foxdot_snd'
beat = setBeat('x-[x:3x](-h[-:3-]h:2)', sample_path: foxdot)
```

### special functions for the pattern
() - choose alternating element every passing

[] - play elements inside the brackets in one count

or just play the element

### play/use the beat in SonicPi

create a live_loop and call the samplePattern function and hit run e.g.
```ruby
live_loop :foo do
  samplePattern(beat)
end
```

### example
```ruby
require '/path/to/beatPattern.rb'

# example for a beatString
beat = setBeat('X[--]x:6(s[-s])')
live_loop :beat do
  samplePattern(beat)
end

# example how to play a melody
mel = (ring 60, [65, 65], ring(72, 67), 72)
live_loop :play_mel do
  samplePattern(mel, mode: :notes, release: 0.2)
end
```

## Usefull to know
### Important parameters for setBeat()
* first Parameter is a beatString --> it's required
* optional you can pass the path to your soundfiles with `sample_path: 'path/to'file/'`

### Important parameters for samplePattern
* first Parameter is a ring with sample_values (e.g. a parsed String) or notes--> it's required
Following paramters can also be set.
* `mode:` `:notes`, `:samples` or `:midis` | standard is `:samples`
* `beat_duration: value` | standard is 1.0/ring.length()
* `position: value` | standard is simple `tick` but you can use numbers or something like tick(:value)
* `brak: 1` | standard is false => Brake "[m]ake a pattern sound a bit like a breakbeat. It does this by every other cycle, squashing the pattern to fit half a cycle, and offsetting it by a quarter of a cycle." (https://tidalcycles.org/functions.html, 11.10.2018)  
* other arguments from sample or play like `rate:` or `amp:`

Because the first parameter is a ring you can:
* reverse a beat by e.g. `beat.reverse`
* shuffle a beat by e.g. `beat.shuffle`
* rotate a beat by e.g. `beat.rotate(i)` -> see ruby docs for rotate
* create a palindrome by e.g. `beat.palindrome`

## To-Do
* improve use of Soundlibrary (assignment) for SonicPi built-in sounds with regexp

--> this part of code in beatParser.rb
```ruby
#use regexp to select included sonic-pi sounds
@sounds = {:a => /ambi/,
           :b => /bass_dnb|bass_hit|bass.+_hit/,
           :e => /elec/,
           :m => /mehackit_/,
           :p => /perc|cowbell/,
           :s => /snare|sn_/,
           :t => /tom/,
           :v => /vinyl/,
           :x => /bd_/,
           :B => /bass_drop|bass_hard_c|bass_thick|bass_voxy_c|bass_woodsy/,
           :G => /guit/,
           :H => /glitch/,
           :L => /loop/,
           :M => /misc/,
           :T => /tabla/,
           :X => /drum_bass|drum_heavy_kick/,
           :hyphen => /drum_cymbal/,
           :whitespace => 'silent'}
```
