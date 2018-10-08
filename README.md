# beatPattern

These are some functions to parse a string like 'x-x-(hc)-[xx:2]-' into a ring of samples, (nested) rings or (nested) arrays to create a nice beat. This is inspired by [foxdot](https://github.com/Qirky/FoxDot).

## How to install
1. Download the samples fom [foxdot](https://github.com/Qirky/FoxDot/tree/master/FoxDot/snd) or
create an own sample library. Therefor you have to design the folder structure like 'ownsounds/letter/lower_or_upper/soundfiles' e.g. /soundlibrary/a/lower/bd.wav
2. (optional) - Edit the first line in beatParser.rb and change '/path/to/foxdot_snd' into your real path
3. Open a Buffer in SonicPi and type
```ruby
require 'path/to/beatPattern.rb'
```
then hit "run".
