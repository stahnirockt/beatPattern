def setSounds(soundpath_string = false) #path to /foxdot_snd - folder
  if soundpath_string
    @path = soundpath_string
    @sounds = {:a => @path+'a/lower/',
               :b => @path+'b/lower/',
               :c => @path+'c/lower/',
               :d => @path+'d/lower/',
               :e => @path+'e/lower/',
               :f => @path+'f/lower/',
               :g => @path+'g/lower/',
               :h => @path+'h/lower/',
               :i => @path+'i/lower/',
               :j => @path+'j/lower/',
               :k => @path+'k/lower/',
               :l => @path+'l/lower/',
               :m => @path+'m/lower/',
               :n => @path+'n/lower/',
               :o => @path+'o/lower/',
               :p => @path+'p/lower/',
               :q => @path+'q/lower/',
               :r => @path+'r/lower/',
               :s => @path+'s/lower/',
               :t => @path+'t/lower/',
               :u => @path+'u/lower/',
               :v => @path+'v/lower/',
               :w => @path+'w/lower/',
               :x => @path+'x/lower/',
               :y => @path+'y/lower/',
               :z => @path+'z/lower/',
               :A => @path+'a/upper/',
               :B => @path+'b/upper/',
               :C => @path+'c/upper/',
               :D => @path+'d/upper/',
               :E => @path+'e/upper/',
               :F => @path+'f/upper/',
               :G => @path+'g/upper/',
               :H => @path+'h/upper/',
               :I => @path+'i/upper/',
               :J => @path+'j/upper/',
               :K => @path+'k/upper/',
               :L => @path+'l/upper/',
               :M => @path+'m/upper/',
               :N => @path+'n/upper/',
               :O => @path+'o/upper/',
               :P => @path+'p/upper/',
               :Q => @path+'q/upper/',
               :R => @path+'r/upper/',
               :S => @path+'s/upper/',
               :T => @path+'t/upper/',
               :U => @path+'u/upper/',
               :V => @path+'v/upper/',
               :W => @path+'w/upper/',
               :X => @path+'x/upper/',
               :Y => @path+'y/upper/',
               :Z => @path+'z/upper/',
               :hyphen => @path+'_/hyphen/',
               :whitespace => 'silent'}
  else
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
  end
end

#check every stringelement and create rings or arrays using recursive functions
def checkStringElement(scanner, pattern)
  if scanner.scan(/(\w\:\d+)/) # e.g. "c:23"
    soundBank = scanner[0].scan(/\w+/) # soundBank is an array [letter, number] as string
    pattern << (sample_paths @sounds[soundBank[0].to_sym])[soundBank[1].to_i]
  elsif scanner.scan(/\w/) # one letter e.g. "a"
    pattern << @sounds[scanner[0].to_sym]
  elsif scanner.scan(/\-\:\d+/) # e.g. "-:23"
    soundBank = scanner[0].scan(/\d+/) # soundBank is just a number
    pattern << (sample_paths @sounds[:hyphen])[soundBank[0].to_i]
  elsif scanner.scan(/\-/)
    pattern << @sounds[:hyphen]
  elsif scanner.scan(/\ /)
    pattern << @sounds[:whitespace]
  elsif scanner.scan(/\[/)
    arryResult = createArray(scanner) # call function to create an array
    pattern << arryResult
  elsif scanner.scan(/\(/) != nil
    arryResult = createArray(scanner) # call function to create an array
    pattern << arryResult.ring        # convert result to a ring
  else
    scanner.scan(/./)
  end
end

# recursive funtion to create arrays for the beatpattern
def createArray(scanner)
  pattern = []
  until scanner.scan(/\]/) or scanner.scan(/\)/)
    checkStringElement(scanner, pattern)
  end
  return pattern
end

# function to parse the string with checkstring
# return a ring containing elements, rings or/and arrays
def parseBeatString(str)
  pattern = []
  scanner = StringScanner.new(str)
  until scanner.pos == str.length
    checkStringElement(scanner, pattern)
  end
  pattern.ring
end
