require_relative 'beatParser.rb'


class ::SonicPi::Core::RingVector
  # extend function for ringvector to create a palindrome of a ring
  # e.g. (ring 1,2,3,4).palindrome => (ring 1,2,3,4,4,3,2,1)
  def palindrome()
    self+self.reverse
  end
end


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

   element = pattern[position] #select actual element
   passing = position/pattern.length() #calculate passing

   if args_h[:beat_duration]
     sleep_time = args_h.delete(:beat_duration)
   else
     sleep_time = 1.0/pattern.length()
   end

   #calculate new sleep_time if brak-mode
   #Brak: "Make a pattern sound a bit like a breakbeat. It does this by every other cycle, squashing the pattern to fit half a cycle, and offsetting it by a quarter of a cycle." (https://tidalcycles.org/functions.html)
   if args_h[:brak]
     args_h.delete(:brak)
     sleep_time = getBrakSleep(pattern.length(), passing, position, sleep_time)
   end

   if args_h[:mode]
     mode = args_h.delete(:mode)
   else
     mode = :samples
   end

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

def getBrakSleep(pattern_length, passing, position, sleep_time)
  pattern_duration = pattern_length*sleep_time
  if passing % 2 == 0 and position % pattern_length == pattern_length-1
    braksleep = sleep_time+pattern_duration*0.25
  elsif passing % 2 == 1 and position % pattern_length == pattern_length-1
    braksleep = sleep_time*0.5+pattern_duration*0.25
  elsif passing % 2 == 1
    braksleep = sleep_time*0.5
  else
    braksleep = sleep_time
  end
  return braksleep
end

def setBeat(beat_string, sample_path: false)
  if sample_path
    setSounds(sample_path)
  else
    setSounds()
  end
  return parseBeatString(beat_string)
end
