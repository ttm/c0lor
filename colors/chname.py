import os

files = os.listdir('.')

for afile in files:
    if not afile.startswith('zz'):
        os.system('mv ' + afile + ' zz' + afile)

