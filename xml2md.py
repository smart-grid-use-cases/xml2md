import xmltodict
import chevron
import getopt, sys

def printMarkdown(dataObj, filename):
    with open(filename) as template:
        print(chevron.render(template, dataObj))
 
def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hf:v", ["help", "filename="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    filename = None
    verbose = False
    for o, a in opts:
        if o == "-v":
            verbose = True
        elif o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-f", "--filename"):
            filename = a
        else:
            assert False, "unhandled option"

    with open(filename) as xmlfile:
        usecase = None
        xmlobj=xmltodict.parse(xmlfile.read())

        if 'UC:UseCaseRepository' in xmlobj:
            print ("UseCaseRepository version")
            otherUseCases = []
            theUseCase = None
            for usecase in xmlobj['UC:UseCaseRepository']['UseCaseLibrary']['UseCase']:
                if 'scope' in usecase:
                    #print(usecase)
                    usecase['AreaLibrary'] = xmlobj['UC:UseCaseRepository']['AreaLibrary']
                    usecase['ActorLibrary'] = xmlobj['UC:UseCaseRepository']['ActorLibrary']
                    theUseCase = usecase
                else:
                    otherUseCases.append(usecase)
            if theUseCase:
                theUseCase['otherUseCases'] = otherUseCases
                printMarkdown(usecase, "UseCaseRepository.mustache")

        else:
            print ("UseCase version")
            print(xmlobj)
            printMarkdown(xmlobj['UseCase'], "UseCase.mustache")
    
        xmlfile.close()

if __name__ == "__main__":
    main()



   
