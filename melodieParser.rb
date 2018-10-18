def parseMelodieString(melodie_string)
  melodiePattern = []
  scanner = StringScanner.new(melodie_string)
  until scanner.pos == melodie_string.length
    checkMelodyStringElement(scanner, melodiePattern)
  end
  melodiePattern.ring
end

#check every stringelement and create rings or arrays using recursive functions
def checkMelodyStringElement(scanner, pattern)
  if scanner.scan(/\d+/) # one letter e.g. "a"
    pattern << scanner[0].to_i
  elsif scanner.scan(/\w+/)
  pattern << scanner[0].to_sym
  elsif scanner.scan(/r|\-/) # one letter e.g. "a"
    pattern << :r
  elsif scanner.scan(/\[/)
    arryResult = createMelodieArray(scanner) # call function to create an array
    pattern << arryResult
  elsif scanner.scan(/\(/) != nil
    arryResult = createMelodieArray(scanner) # call function to create an array
    pattern << arryResult.ring        # convert result to a ring
  elsif scanner.scan(/\{/) != nil
    arryResult = createRandomMelodieArray(scanner) # call function to create an array
    pattern << arryResult
  else
    scanner.scan(/./)
  end
end

# recursive funtion to create arrays for the beatpattern
def createMelodieArray(scanner)
  pattern = []
  until scanner.scan(/\]/) or scanner.scan(/\)/)
    checkMelodyStringElement(scanner, pattern)
  end
  return pattern
end

def createRandomMelodieArray(scanner)
  pattern = []
  until scanner.scan(/\]/) or scanner.scan(/\)/) or scanner.scan(/\}/)
    checkMelodyStringElement(scanner, pattern)
  end
  return RandomArray.new(pattern)
end
