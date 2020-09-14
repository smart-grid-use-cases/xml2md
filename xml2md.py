import xmltodict
import chevron
import json
import sys, os
from datetime import date
from collections.abc import Mapping

def removeEndl(text, render):
    stringWithEndl = render(text)
    stringWithoutEndl = stringWithEndl.replace('\n', ' ')
    return stringWithoutEndl

def extractText(text, render):
    drawingObject = json.loads(render(text).replace("'", '"'))
    if '#text' in drawingObject:
        name = os.path.basename(drawingObject['#text'])
        filename = name.rfind('\\')
        return name[filename+1:]
    return ""

def printMarkdown(dataObj, filename):
    dataObj['extractText'] = extractText
    dataObj['removeEndl'] = removeEndl
    with open(filename) as template:
        args = { "template": template,
                 "data":     dataObj }
        print(chevron.render(**args))

def addIfExists(elemName, dest, src):
    if elemName in src:
        dest[elemName] = src[elemName]

def addLibraryObjects(dest, src, rootNode):
    print(src, dest, rootNode)
    addIfExists('AreaLibrary', dest, src[rootNode])
    addIfExists('ActorLibrary', dest, src[rootNode])
    addIfExists('BusinessObjectLibrary', dest, src[rootNode])
    addIfExists('RequirementLibrary', dest, src[rootNode])
    addIfExists('CommonTermLibrary', dest, src[rootNode])
    return dest

def main():
    for filename in sys.argv[1:]:
        mtime = date.fromtimestamp(os.path.getmtime(filename)).isoformat()
        with open(filename) as xmlfile:
            usecase = None
            xmlobj = xmltodict.parse(xmlfile.read(), dict_constructor=dict)

            rootNode = None
            if 'UC:UseCaseRepository' in xmlobj:
                rootNode = 'UC:UseCaseRepository'
            elif 'UseCaseRepository' in xmlobj:
                rootNode = 'UseCaseRepository'
            elif 'UseCase' in xmlobj:
                rootNode = 'UseCase'

            if rootNode == 'UseCaseRepository' or rootNode == 'UC:UseCaseRepository':
                otherUseCases = []
                theUseCase = None
                if 'UseCase' in xmlobj[rootNode]['UseCaseLibrary']:
                    if type(xmlobj[rootNode]['UseCaseLibrary']['UseCase']) is list:
                        for usecase in xmlobj[rootNode]['UseCaseLibrary']['UseCase']:
                            if 'scope' in usecase:
                                theUseCase = addLibraryObjects(usecase, xmlobj, rootNode)
                            else:
                                otherUseCases.append(usecase)
                    elif isinstance(xmlobj[rootNode]['UseCaseLibrary']['UseCase'], Mapping):
                        if 'scope' in xmlobj[rootNode]['UseCaseLibrary']['UseCase']:
                            usecase = xmlobj[rootNode]['UseCaseLibrary']['UseCase']
                            theUseCase = addLibraryObjects(usecase, xmlobj, rootNode)
                if theUseCase:
                    theUseCase['otherUseCases'] = otherUseCases
                    theUseCase['date'] = mtime
                    printMarkdown(theUseCase, "UseCaseRepository.mustache")
            elif rootNode == 'UseCase':
                xmlobj['UseCase']['date'] = mtime
                printMarkdown(xmlobj['UseCase'], "UseCase.mustache")
            else:
                print("Cannot idenitify root node.")
                sys.exit(1)

            xmlfile.close()

if __name__ == "__main__":
    main()



   
