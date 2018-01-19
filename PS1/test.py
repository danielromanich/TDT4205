import re

reg = '[A-Za-z]*((e+n*)|((r|v|q|c|n)+u*i+))t+o+s*$'
rhyme = re.compile(reg)

stuff = ['Cheetos', 'Magneto', 'Momento', 'Magento', 'Burriiiiiitttttooooo', 'Devito', 'Mosquito', 'Canoncito', 'Incognito', 'Pocitoooooaaaa']

for i in range(0, len(stuff)):
    if rhyme.match(stuff[i]):
        print("Matched(" + str(i) + "): " + stuff[i])