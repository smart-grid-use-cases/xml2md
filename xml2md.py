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

def addLibraryObjects(usecase, xmlobj):
    usecase['AreaLibrary'] = xmlobj['UC:UseCaseRepository']['AreaLibrary']
    usecase['ActorLibrary'] = xmlobj['UC:UseCaseRepository']['ActorLibrary']
    usecase['BusinessObjectLibrary'] = xmlobj['UC:UseCaseRepository']['BusinessObjectLibrary']
    usecase['RequirementLibrary'] = xmlobj['UC:UseCaseRepository']['RequirementLibrary']
    usecase['CommonTermLibrary'] = xmlobj['UC:UseCaseRepository']['CommonTermLibrary']
    return usecase

def main():
    for filename in sys.argv[1:]:
        mtime = date.fromtimestamp(os.path.getmtime(filename)).isoformat()
        with open(filename) as xmlfile:
            usecase = None
            xmlobj = xmltodict.parse(xmlfile.read(), dict_constructor=dict)

            if 'UC:UseCaseRepository' in xmlobj:
                otherUseCases = []
                theUseCase = None
                if 'UseCase' in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']:
                    if type(xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']) is list:
                        for usecase in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']:
                            if 'scope' in usecase:
                                theUseCase = addLibraryObjects(usecase, xmlobj)
                            else:
                                otherUseCases.append(usecase)
                    elif isinstance(xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase'], Mapping):
                        if 'scope' in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']:
                            usecase = xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']
                            theUseCase = addLibraryObjects(usecase, xmlobj)
                if theUseCase:
                    theUseCase['otherUseCases'] = otherUseCases
                    theUseCase['date'] = mtime
                    printMarkdown(theUseCase, "UseCaseRepository.mustache")
            else:
                xmlobj['UseCase']['date'] = mtime
                printMarkdown(xmlobj['UseCase'], "UseCase.mustache")
            xmlfile.close()

if __name__ == "__main__":
    main()



   
