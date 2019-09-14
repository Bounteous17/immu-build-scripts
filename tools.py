import sys
import hashlib

def calculateFileSha1sum(__filePath):
    sha1sum = hashlib.sha1()
    with open(__filePath, 'rb') as source:
        block = source.read(2**16)
        while len(block) != 0:
            sha1sum.update(block)
            block = source.read(2**16)
    return sha1sum.hexdigest()