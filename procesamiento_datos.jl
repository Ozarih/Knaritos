@everywhere function procesamiento(func,inputs...)
    #maximum para maximo
    #sum para suma
    Matriz_Procesamiento=Lectura_Datos_Entrada(inputs...)
    #Tiempo=vcat(Matriz_Procesamiento[:,1],Matriz_Procesamiento[:,2])
    #Tiempo=append!(Matriz_Procesamiento[:,1],Matriz_Procesamiento[:,2])
    #La funcion escogida abajo es más rapida para la concatenación
    Tiempo=[Matriz_Procesamiento[:,1];Matriz_Procesamiento[:,2]]
    Tiempo=SortAndDelete(Tiempo)#ordena de menor a mayor y elimina vectores repetidos
    Matriz_Resultados=Operacion12(Tiempo)# instaciacion matriz de resultados con operacion12
    Matriz_Resultados=Llenado_Matriz_Resultados(Matriz_Resultados,Matriz_Procesamiento,func)
end
function Lectura_Datos_Entrada(inputs...)
    if typeof(inputs...)==Vector{Any}
        aux=vcat(inputs...)
        if length(aux)>1#Rutina para el manejo de arreglos con Any
            Matriz_Procesamiento=aux[1]
            for i=2:length(aux)
                Matriz_Procesamiento=[Matriz_Procesamiento ; aux[i]]
            end
        else
            Matriz_Procesamiento=aux
        end
    else
        Matriz_Procesamiento=vcat(inputs...)
    end
    return Matriz_Procesamiento
end
function SortAndDelete(vec)
    sort!(vec)#Ordena el vector Tiempo
   #Rutina para borrar elementos repetidos en un vector ordenado
    i=1;
    while i<length(vec)
        if vec[i+1]==vec[i]
            deleteat!(vec,i+1)
        else
            i+=1;
        end
    end
    return vec
end
function Operacion12(vec)
    #Realiza una transformacion de una linea de tiempo a una matriz de rangos
    Matriz_Resultados=[0 vec[1] 0];
    for i=1:length(vec)-1
        Matriz_Resultados=[Matriz_Resultados;[vec[i] vec[i+1] 0]]
    end
    if vec[1]<=0
        Matriz_Resultados=Matriz_Resultados[2:end,:] #Elimina primer elemento ya que existe un cero
    end
    return Matriz_Resultados
end
function extraccion_datos(Rango,Matriz)
    #Retorna los valores de la matriz que este en TOD0 el rango
    datos=[]
    for i=1:size(Matriz)[1]
        if Rango[1]>=Matriz[i,1] && Rango[2]<=Matriz[i,2]
            push!(datos,Matriz[i,3])
        end
    end
    return datos
end
function Llenado_Matriz_Resultados(Matriz_Resultados,Matriz_Procesamiento,func)
    Contador_capacidad=1;#creacion del contador
    while Contador_capacidad<=size(Matriz_Resultados)[1]#Ya se proceso la matriz de resultados
        Rango_Analisis=Matriz_Resultados[Contador_capacidad,1:2]#T inicio y T final en la posicion contador
        Perdidas_Capacidades=extraccion_datos(Rango_Analisis,Matriz_Procesamiento)#Perdidas de capacidad en el rango de Rango_Analisis
        if isempty(Perdidas_Capacidades)#Si no hay perdidas examine el siguiente rango de analisis
            Contador_capacidad+=1
        else
            Matriz_Resultados[Contador_capacidad,3]=func(Perdidas_Capacidades)#Realice la funcion solicitada
            Contador_capacidad+=1
        end
    end
    return Matriz_Resultados
end
