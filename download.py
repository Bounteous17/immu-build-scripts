import urllib.request
import os.path
from utils import shortConfig, config, consoleLog, resume


def getIso():
    os.chdir(config['downloadsFolder'])
    if os.path.isfile(shortConfig['archIsoFileName']):
        consoleLog(
            "Downloaded iso already found on '%s', avoiding to download again"
            % (config['downloadsFolder']), 'info')
        return 0
    file_name = shortConfig['archIsoFileName']
    u = urllib.request.urlopen(shortConfig['urlPathIso'])
    f = open(file_name, 'wb')
    meta = u.info()
    file_size = int(meta.get("Content-Length")[0])
    consoleLog(
        "Downloading -> %s \nFrom -> %s" % (file_name, config['urlMirrorIso']),
        'info')
    consoleLog(
        "You can change the download mirror from file: config.json -> urlMirrorIso",
        'warn')

    file_size_dl = 0
    block_sz = 8192
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break

        file_size_dl += len(buffer)
        f.write(buffer)
        status = r"%10d  [%3.2f%%]" % (file_size_dl,
                                       file_size_dl * 100. / file_size)
        status = status + chr(8) * (len(status) + 1)
        consoleLog(status, 'min_info')

    f.close()
