# TDT4205 Compiler Construction Assignment 1
# This is the python file to identify rhyming words per verse
# per verse

import re

out_file = open('rhymes_per_verse.txt', 'w')
out_file2 = open('aliens.txt', 'w')

## insert the regular expression
## using the usual notation
## within the inverted commas
##

regexr = '[A-Za-z]*((e+n*)|((r|v|q|c|n)*u*i+))t+o+s*'  # input the appropriate regular expression here
rhyme = re.compile(regexr)

filepath = 'parody_verse.txt'

verse_count = 0

verses_output = ['None ', 'One ', 'Two ', 'Three ', 'Four ', '']
alien_commands = ['\n', 'One ', 'Two ', 'Three ', 'Four ', '']

with open(filepath) as fp:
    for cnt, line in enumerate(fp):
        print(line)
        if not (re.match('s*\r?\n', line)):
            print("Linedddd {}: {}".format(cnt, line.strip()))
            if rhyme.findall(line.split()[-1]):
                verse_count += 1
            print("At verse: " + line.split()[-1] + "Matches: " + str(rhyme.match(line.split()[-1])))
            print verse_count
        else:
            rhymes = verses_output[verse_count]
            alien_spell = alien_commands[verse_count]
            print rhymes
            out_file.write(rhymes)
            out_file2.write(alien_spell)
            print "Empty"
            verse_count = 0

out_file2.write('Stop')

out_file.close()
out_file2.close()
