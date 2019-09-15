import json


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def __config():
    return json.load(open('config.json', 'r'))


def consoleLog(__str, __type):
    color = bcolors.HEADER
    newLine = True
    if __type == 'info':
        color = bcolors.OKBLUE
    if __type == 'min_info':
        newLine = False
        color = bcolors.OKBLUE
    if __type == 'warn':
        color = bcolors.WARNING
    if __type == 'err':
        color = bcolors.FAIL
    if __type == 'under':
        color = bcolors.UNDERLINE

    if newLine:
        __str = __str + "\n"

    print(color + __str + bcolors.ENDC)


config = __config()

shortConfig = {
    "urlPathIso":
    config['urlMirrorIso'] + config['urlArchIso'],
    "archIsoFileName":
    config['urlArchIso'].split('/')[-1],
    "isoPath":
    config['downloadsFolder'] + '/' + config['urlArchIso'].split('/')[-1]
}

# If resume is enabled you can resume operations (recommended only for development)
resume = False