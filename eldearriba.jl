include("procesamiento_datos.jl")
@everywhere function conteo_capacidad_iteracion(Matriz_Eventos_Procesados)#Id en tres columnas, Tinicio,Tfinal,Informacion
    Matriz_Perdidas_capacidades=Eventos_Equipos(Matriz_Eventos_Procesados)
    for i=2:size(Matriz_Perdidas_capacidades)[1]
        Matriz_Perdidas_capacidades[i,2]=procesamiento(sum,Matriz_Perdidas_capacidades[i,2])
    end
    Matriz_Perdidas_capacidades=procesamiento(maximo_cota_100,Matriz_Perdidas_capacidades[:,2])#serie
    return Matriz_Perdidas_capacidades
end
function Eventos_Equipos(MatrizIn)
    #Dice los eventos a cada superequipo
    aux=SortAndDelete(MatrizIn[:,1])#Aisla la cantidad de superequipos
    MatrizOut=[aux Array{Any}(length(aux))]
    for i=1:length(aux)
        MatrizOut[i,2]=Busqueda_Eventos(aux[i],MatrizIn[:,1],MatrizIn[:,4:end])#LLena los eventos
    end
    return MatrizOut
end
function Busqueda_Eventos(indice_busqueda,Matrindex,Matriz_Info)
    #Funcion de busqueda y asociacion de eventos con ciertos indices
    MatrizOut=[0 0 0]
    for i=1:size(Matriz_Info)[1]
        if indice_busqueda==Matrindex[i]
            MatrizOut=[MatrizOut; Matriz_Info[i,:]']
        end
    end
    return MatrizOut[2:end,:]
end
function maximo_cota_100(inputs...)
    out=maximum(inputs...)
    if out>100
        out=100
    end
    return out
end
