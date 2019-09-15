import sys
import hashlib
import os
import subprocess
from models.error import Error
from utils import config, consoleLog, resume


def calculateFileSha1sum(__filePath):
    sha1sum = hashlib.sha1()
    with open(__filePath, 'rb') as source:
        block = source.read(2**16)
        while len(block) != 0:
            sha1sum.update(block)
            block = source.read(2**16)
    return sha1sum.hexdigest()


def createFolder(__folderPath):
    if os.path.isdir(__folderPath):
        return 0
    os.mkdir(__folderPath)


def executeBashCommand(__command):
    process = subprocess.Popen(__command.split())
    output, error = process.communicate()
    if error:
        return Error(error)
    return output


def prepareSetup():
    consoleLog(
        'Cleaning extracted iso mountpoint %s' % (config['pathCustomIso']),
        'warn')
    executeBashCommand('rm -rf %s' % config['pathCustomIso'])
