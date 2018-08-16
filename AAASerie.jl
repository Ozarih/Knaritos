#module AAASERIE

try
    @everywhere    function regyProSerie(lisCurrentEvents,lisFutureEvents,durAlm,matProcessedEvents,eisConfigEvents)
        _matA=find(map(x->x<=durAlm,lisCurrentEvents[:,4]))
        _iA=size(_matA)[1]
        if  _iA>0
            matProcessedEvents=MenordurAlm(lisCurrentEvents,matProcessedEvents,durAlm,eisConfigEvents,_matA)
        end

        return matProcessedEvents,lisCurrentEvents
    end
catch
    print("Error en Registro y procesamiento Serie")
end

@everywhere    function MenordurAlm(lisCurrentEvents,matProcessedEvents,durAlm,eisConfigEvents,_matA)

    for i=1:size(_matA)[1]
            matProcessedEvents=Registro(lisCurrentEvents,matProcessedEvents,_matA[i],eisConfigEvents)
        end
    lisCurrentEvents=EliminaFilas(lisCurrentEvents,_matA)
    return matProcessedEvents,lisCurrentEvents
end

    @everywhere    function Registro(lisCurrentEvents,matProcessedEvents,i,eisConfigEvents)
        _matAux=Array{Any}(1,6)
        _matAux[1]=lisCurrentEvents[i,1]
        _matAux[2]=lisCurrentEvents[i,2]
        _matAux[3]=lisCurrentEvents[i,3]
        _matAux[4]=matProcessedEvents[size(matProcessedEvents)[1],4]
        _matAux[5]=_matAux[4]+lisCurrentEvents[i,5]
        _matAux[6]=BusquedaPCAP(eisConfigEvents,_matAux[3])
        return [matProcessedEvents;_matAux]
    end

        @everywhere    function BusquedaPCAP(eisConfigEvents,idEv)
            uu=map(x->x==idEv,eisConfigEvents[:,1])
            u=find(uu)[1]
            perdidacapacidad=eisConfigEvents[u,15]

            return perdidacapacidad
        end


        @everywhere    function EliminaFilas(_matRes,_matA)
            _matRes=_matRes[find(map(x->prod(x.!=_matA),1:size(_matRes)[1])),:];
            return _matRes
        end
