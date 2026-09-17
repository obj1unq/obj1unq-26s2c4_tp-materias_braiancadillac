object programacion {
  const materias = #{elementosDeProgramacion ,matematica1, objetos1 ,objetos2 ,objetos3 ,trabajoFinal, basesDeDatos, programacionConcurrente}

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

  method validarMateriaEnCarrera(estudiante){
    if(not estudiante.materias().contains(self)){
      self.error("La materia no se encuentra en las carreras inscripto")
    }
  }

  method validarMateriaEnMateriasInscripto(estudiante){
    if(estudiante.materiasInscripto().contains(self)){
      self.error("Ya está inscripto en la materia")
    }
  }

  method validarMateriaEnRequisitos(estudiante){
    if(not self.requisitos().all({requisito => estudiante.tieneAprobado(requisito)})){
      self.error("No cuentas con todos los requisitos de la materia para inscribir")
    }
  }
  
  method inscribirEstudiante(estudiante){
    if(self.tieneCupo()){
      estudiantes.add(estudiante)
      estudiante.materiasInscripto().add(self)
    }
    else{
      estudiantesEnEspera.add(estudiante)
    }
  }

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
      estudiantesEnEspera.head().materiasInscripto().add(self)
      estudiantesEnEspera.remove(estudiantesEnEspera.head())
    }
  }

  method tieneCupo(){
    return estudiantes.size() < capacidad
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
  const materiasAprobadas          = #{}
  const carreras                   = #{}
  const property materiasInscripto = #{}

  method materiasAprobadas(){ //get para testear las materias aprobadas
    return materiasAprobadas
  } 

  method registrarAprobacion(registrarMateria, registrarNota){
    self.validarAprobacion(registrarMateria)
    materiasAprobadas.add(new Aprobacion(materia = registrarMateria, nota = registrarNota))

  }

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
    materia.inscribirEstudiante(self)
  }

  method inscripcionesEnEspera(){
    return self.materias().filter({materia => materia.estudiantesEnEspera().contains(self)})
  }
  /*1. Más información sobre une estudiante: dada una carrera, conocer todas las materias de esa carrera a las que se puede inscribir. Sólo vale si el estudiante está cursando esa carrera.*/
  method materiasConCupos(carrera){
    self.validarCarrera(carrera)
    return carrera.materias().filter({materia => materia.tieneCupo()})
  }
  
  method validarCarrera(carrera){
    if(not carreras.contains(carrera)){
      self.error("No está inscripto en la carrera")
    }
  }
}

//Instanciamos a roque y otrxs
var roque   = new Estudiante()
var daniela = new Estudiante()

var luisa  = new Estudiante()
var romina = new Estudiante()
var alicia = new Estudiante()
var ana    = new Estudiante()

//PROGRAMACION
var elementosDeProgramacion = new Materia(carrera = programacion, capacidad = 40)
var matematica1             = new Materia(carrera = programacion, capacidad = 1) /*capacidad 1 para testear*/
var objetos1                = new Materia(carrera = programacion, capacidad = 1)
var objetos2                = new Materia(carrera = programacion, capacidad = 3)
var objetos3                = new Materia(carrera = programacion, capacidad = 10)
var trabajoFinal            = new Materia(carrera = programacion, capacidad = 5)
var basesDeDatos            = new Materia(carrera = programacion, capacidad = 30)
var programacionConcurrente = new Materia(carrera = programacion, capacidad = 15)

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