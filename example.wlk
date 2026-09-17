object programacion {
  const materias = #{elementosDeProgramacion ,matematica1, objetos1 ,objetos2 ,objetos3 ,trabajoFinal, basesDeDatos}

  method materias(){
    return materias
  }
}
object medicina {
  const materias = #{quimica ,biologia1, biologia2, anatomiaGeneral}

  method materias(){
    return materias
  }
}
object derecho {
  const materias = #{latin, derechoRomano, historiaDerechoArgentino, derechoPenal1, derechoPenal2}
  
  method materias(){
    return materias
  }
}

class Materia {
  const carrera
  const property requisitos          = #{}
  var property capacidad
  const property estudiantes         = #{}
  const property estudiantesEnEspera = []
  
  method validarInscripcion(estudiante){
    self.validarMateriaEnCarrera(estudiante)
    estudiante.validarAprobacion(self)
    self.validarMateriaEnMateriasInscripto(estudiante)
    self.validarMateriaEnRequisitos(estudiante)
  }
  /*- la materia debe corresponder a alguna de las carreras que esté cursando el estudiante,*/
  method validarMateriaEnCarrera(estudiante){
    if(not estudiante.materias().contains(self)){
      self.error("La materia no se encuentra en las carreras inscripto")
    }
  }
  /*- el estudiante no debe estar estar ya inscripto en esa materia,*/
  method validarMateriaEnMateriasInscripto(estudiante){
    if(estudiante.materiasInscripto().contains(self)){
      self.error("Ya está inscripto en la materia")
    }
  }
  /*- el estudiante debe tener aprobadas todas las materias que se declaran como _requisitos_ de la materia a la que se quiere inscribir.*/
  method validarMateriaEnRequisitos(estudiante){
    if(not self.requisitos().all({requisito => estudiante.tieneAprobado(requisito)})){
      self.error("No cuentas con todos los requisitos de la materia para inscribir")
    }
  }
  /*1. Inscribir un estudiante a una materia, verificando las condiciones de inscripción de la materia. Si no se cumplen las condiciones, lanzar un error.  
Además, cada materia tiene un “cupo”, es decir, una cantidad máxima de estudiantes que se pueden inscribir. Para manejar el exceso en los cupos, las materias tienen una lista de espera, de estudiantes que quisieran cursar pero no tienen lugar 
(ver punto 5).
O sea, como resultado de la inscripción, el estudiante puede, o bien quedar confirmado, o bien quedar en lista de espera.  
No se requiere que el sistema conteste nada con respecto al resultado de la inscripción.*/
  method inscribirEstudiante(estudiante){
    if(estudiantes.size() < capacidad){
      estudiantes.add(estudiante)
    }
    else{
      estudiantesEnEspera.add(estudiante)
    }
  }
  /*1. Dar de baja un estudiante de una materia. En caso de haber estudiantes en lista de espera, el primer estudiante de la lista debe obtener su lugar en la materia.*/
  method bajaEstudiante(estudiante){
    self.validarBaja(estudiante)
    estudiantes.remove(estudiante)
    self.obtenerLugarEnMateria()
  }
  method validarBaja(estudiante){
    if(not estudiantes.contains(estudiante)){
      self.error("El estudiante no se encuentra en la materia")
    }
  }
  method obtenerLugarEnMateria(){
    if(estudiantesEnEspera.size() > 0){
      estudiantes.add(estudiantesEnEspera.head())
      estudiantesEnEspera.remove(estudiantesEnEspera.head())
    }
  }
}

class Aprobacion {
  const materia
  const nota

  method materia(){
    return materia
  }

  method nota(){
    return nota
  }
}
class Estudiante {
  const materiasAprobadas = #{}
  const carreras          = #{}
  const materiasInscripto = #{}

  method materiasAprobadas(){ //get para testear las materias aprobadas
    return materiasAprobadas
  } 

  method registrarAprobacion(registrarMateria, registrarNota){
    self.validarAprobacion(registrarMateria)
    materiasAprobadas.add(new Aprobacion(materia = registrarMateria, nota = registrarNota))

  }
  /*- el estudiante no puede haber aprobado la materia previamente,*/
  method validarAprobacion(materia){
    if (self.tieneAprobado(materia)){
      self.error("La materia ya está registrada como aprobada")
    }
  }

  method tieneAprobado(materia){
    return self.aprobaciones().contains(materia)
  }

  method aprobaciones(){
    return materiasAprobadas.map({aprobacion => aprobacion.materia()})
  }

  method cantidadMateriasAprobadas(){
    return materiasAprobadas.size()
  }
  method promedio(){
    return if(self.cantidadMateriasAprobadas() > 0) {materiasAprobadas.sum({aprobacion => aprobacion.nota()}) / self.cantidadMateriasAprobadas()} else {self.error("El estudiante no tiene materias aprobadas")}
  }
  method inscribirCarrera(carrera){
    carreras.add(carrera)
  }
  method materias(){
    return carreras.map({carrera => carrera.materias()}).flatten()
  }
 
  method inscribirMateria(materia){
    materia.validarInscripcion(self)
    self.inscripcion(materia)   
  }

  method inscripcion(materia){
    materiasInscripto.add(materia)   
    materia.inscribirEstudiante(self)
  }
  method materiasInscripto(){ //get para testear
    return materiasInscripto
  }
}

//Instanciamos a roque
var roque = new Estudiante()
var daniela = new Estudiante()
//PROGRAMACION
var elementosDeProgramacion = new Materia(carrera = programacion, capacidad = 40)
var matematica1             = new Materia(carrera = programacion, capacidad = 20)
var objetos1                = new Materia(carrera = programacion, capacidad = 1)
var objetos2                = new Materia(carrera = programacion, capacidad = 10)
var objetos3                = new Materia(carrera = programacion, capacidad = 10)
var trabajoFinal            = new Materia(carrera = programacion, capacidad = 5)
var basesDeDatos            = new Materia(carrera = programacion, capacidad = 30)

//MEDICINA
var quimica         = new Materia(carrera = medicina, capacidad = 15)
var biologia1       = new Materia(carrera = medicina, capacidad = 15)
var biologia2       = new Materia(carrera = medicina, capacidad = 15)
var anatomiaGeneral = new Materia(carrera = medicina, capacidad = 15)

//DERECHO
var latin                    = new Materia(carrera = derecho, capacidad = 15)
var derechoRomano            = new Materia(carrera = derecho, capacidad = 15)
var historiaDerechoArgentino = new Materia(carrera = derecho, capacidad = 35)
var derechoPenal1            = new Materia(carrera = derecho, capacidad = 20)
var derechoPenal2            = new Materia(carrera = derecho, capacidad = 20)