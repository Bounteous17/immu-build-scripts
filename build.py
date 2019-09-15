import download
import security
import tools
import setup
import utils


def startBuild():
    if not utils.resume:
        tools.prepareSetup()
        download.getIso()
        security.verifyIso()
        setup.mountIso()
    setup.unsquashIso()
    setup.genIso()


startBuild()