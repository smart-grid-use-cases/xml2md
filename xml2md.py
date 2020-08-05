import xmltodict
import chevron
import sys, os
from collections import Mapping

def basename(text, render):
    path = render(text)
    return os.path.basename(path)

def printMarkdown(dataObj, filename):
    dataObj['basename'] = basename
    with open(filename) as template:
        args = { "template": template,
                 "data":     dataObj }
        print(chevron.render(**args))
 
def main():
    for filename in sys.argv[1:]:
        with open(filename) as xmlfile:
            usecase = None
            xmlobj=xmltodict.parse(xmlfile.read())

            if 'UC:UseCaseRepository' in xmlobj:
                otherUseCases = []
                theUseCase = None
                if 'UseCase' in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']:
                    if type(xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']) is list:
                        for usecase in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']:
                            if 'scope' in usecase:
                                usecase['AreaLibrary'] = xmlobj['UC:UseCaseRepository']['AreaLibrary']
                                usecase['ActorLibrary'] = xmlobj['UC:UseCaseRepository']['ActorLibrary']
                                usecase['BusinessObjectLibrary'] = xmlobj['UC:UseCaseRepository']['BusinessObjectLibrary']
                                usecase['RequirementLibrary'] = xmlobj['UC:UseCaseRepository']['RequirementLibrary']
                                usecase['CommonTermLibrary'] = xmlobj['UC:UseCaseRepository']['CommonTermLibrary']
                                theUseCase = usecase
                            else:
                                otherUseCases.append(usecase)
                    elif isinstance(xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase'], Mapping):
                        if 'scope' in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']:
                            usecase = xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']
                            usecase['AreaLibrary'] = xmlobj['UC:UseCaseRepository']['AreaLibrary']
                            theUseCase = usecase
                if theUseCase:
                    theUseCase['otherUseCases'] = otherUseCases
                    printMarkdown(usecase, "UseCaseRepository.mustache")

            else:
                printMarkdown(xmlobj['UseCase'], "UseCase.mustache")

            xmlfile.close()

if __name__ == "__main__":
    main()



   
