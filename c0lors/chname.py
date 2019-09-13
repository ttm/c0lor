import os

files = os.listdir('.')

for afile in files:
    if afile.startswith('zz'):
        os.system('mv ' + afile + ' ' + afile.replace('zz', ''))

