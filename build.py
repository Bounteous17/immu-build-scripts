import download
import security


def startBuild():
    download.getIso()
    security.verifyIso()


startBuild()