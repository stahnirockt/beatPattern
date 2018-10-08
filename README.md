# beatPattern

These are some functions to parse a string like 'x-x-(hc)-[xx:2]-' into a ring of samples, (nested) rings or (nested) arrays to create a nice beat. This is inspired by [foxdot](https://github.com/Qirky/FoxDot).

## How to install
1. Download the samples fom [foxdot](https://github.com/Qirky/FoxDot/tree/master/FoxDot/snd) or
create an own sample library. Therefor you have to design the folder structure like 'ownsounds/letter/lower_or_upper/soundfiles' e.g. /soundlibrary/a/lower/bd.wav

2. (optional) - Edit the first line in beatParser.rb and change '/path/to/foxdot_snd' into your real path

3. Open a Buffer in SonicPi and type
```ruby
require 'path/to/beatPattern.rb' # hit run
```

## How to use
1. setup a beat e.g.
```ruby
beat = setupBeat('x-[x:3x](-h[-:3-]h:2)',
sample_path: 'path/to/foxdot_snd/') #only necessary if you skip step 2 during installation
```

2. create a live_loop and call the samplePattern function and hit run e.g.
```ruby
live_loop :foo do
  samplePattern(beat)
end
```

## How it works
### important parameters for setupBeat
* first Parameter is a beatString --> it's required
* optional you can pass the path to your soundfiles with `sample_path: 'path/to'file/'`

### important parameters for samplePattern
* first Parameter is a ring with sample_values (e.g. a parsed String) or notes--> it's required
Following paramters can also be set.
* `mode:` `:notes` or `:samples` | standard is `:samples`
* `beat_duration: value` | standard is 1.0/ring.length()
* `position: tick(:value)` | standard is simple `tick`
* other arguments from sample or play like `rate:` or `amp:`
