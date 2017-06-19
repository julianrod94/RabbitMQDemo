import pip
def install(package):
    pip.main(['install', package])

install('pika')
exec(open('get-pip.py').read())
