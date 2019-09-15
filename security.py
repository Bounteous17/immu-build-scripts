import sys
from tools import calculateFileSha1sum
from utils import shortConfig, config, consoleLog, resume


def verifyIso():
    consoleLog('Verifying integrity %s' % (shortConfig['archIsoFileName']),
               'info')
    calculatedHash = calculateFileSha1sum(shortConfig['archIsoFileName'])
    consoleLog("Calculated hash: %s" % (calculatedHash), 'under')
    if calculatedHash == config['sha1Iso']:
        consoleLog('The sha1sum matches, continuing ...', 'info')
        return 0
    consoleLog('The sha1sum do not matches, exiting ...', 'err')
    sys.exit(1)