require_relative 'beatParser.rb'

def samplePattern(pattern, *args)
  args_h = resolve_synth_opts_hash_or_array(args)

  # check if position, beat_duration and mode are set,
  # if set --> set variable and delete value from hash
  # otherwise set standart values for position, beat_duration and mode

  if args_h[:position]
    position = args_h.delete(:position)
  else
    position = tick
  end

  if args_h[:beat_duration]
    sleep_time = args_h.delete(:beat_duration)
  else
    sleep_time = 1.0/pattern.length()
  end

  if args_h[:mode]
    mode = args_h.delete(:mode)
  else
    mode = :samples
  end

  element = pattern[position] #select actual element
  passing = position/pattern.length() #calculate passing

  #check the element and decide
  if element.kind_of?(Array)
    playNestedArray(element, sleep_time, passing, mode, args_h)
  elsif element.kind_of?(SonicPi::Core::RingVector)
    alternateRingElement(element, sleep_time, passing, mode, args_h)
  else
    #element is just a sample or note
    handleElement(element, mode, args_h)
    sleep sleep_time
  end
end

def playNestedArray(pattern, toplevel_sleep, toplevel_passing, mode, args_h)
  sleep_time = toplevel_sleep*1.0/pattern.length() # set new time to sleep depending on toplevel_sleep and length of the array
  pattern.each do |element|
    if element.kind_of?(Array)
      playNestedArray(element, sleep_time, toplevel_passing, mode, args_h)
    elsif element.kind_of?(SonicPi::Core::RingVector)
      alternateRingElement(element, sleep_time, toplevel_passing, mode, args_h)
    else
      handleElement(element, mode, args_h)
      sleep sleep_time
    end
  end
end


def alternateRingElement(ring_pattern, toplevel_sleep, toplevel_passing, mode, args_h)
  ring_passing = toplevel_passing/ring_pattern.length()
  element = ring_pattern[toplevel_passing]
  if element.kind_of?(SonicPi::Core::RingVector)
    alternateRingElement(element, toplevel_sleep ,ring_passing, mode ,args_h)
  elsif element.kind_of?(Array)
    playNestedArray(element, toplevel_sleep, ring_passing, mode, args_h)
  else
    handleElement(element, mode, args_h)
    sleep toplevel_sleep
  end
end

def handleElement(element, mode, args_h)
  case mode
  when :samples
    sample element, args_h
  when :notes
    play element, args_h
  when :midis
    midi element, args_h
  end
end

def setupBeat(beat_string, sample_path: false)
  if sample_path
    setSounds(sample_path)
  else
    setSounds()
  end
  return parseBeatString(beat_string)
end
