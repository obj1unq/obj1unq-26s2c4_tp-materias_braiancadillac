object porOrdenDeLlegada {

  method prioritario(estudiantesEnEspera) {
    return estudiantesEnEspera.head()
  }

}

object elitista {

  method prioritario(estudiantesEnEspera) {
    return estudiantesEnEspera.max({estudiante => estudiante.promedio()})
  }

}

object gradoDeAvance {

  method prioritario(estudiantesEnEspera) {
    return estudiantesEnEspera.max({estudiante => estudiante.cantidadMateriasAprobadas()})
  }

}

object creditos {


  method requerimiento(estudiante, materia, carrera){
    return estudiante.aprobaciones().sum({materiaActual => materiaActual.creditos()}) >= materia.creditosNecesarios()
  }
}
class Correlativa {

  const property correlativas = #{}

  method requerimiento(estudiante, materia, carrera) {
    return correlativas.all({correlativa => estudiante.tieneAprobado(correlativa)})
  }
}

object anio {

  method requerimiento (estudiante, materia, carrera){
    return self.materiasAprobadasDelAnioAnterior(estudiante, materia) == self.totalDeMateriasDelAnioAnterior(carrera, materia)
  }

  method materiasAprobadasDelAnioAnterior(estudiante, materia){
    return estudiante.aprobaciones().filter({materiaActual => materiaActual.anio() == materia.anio() - 1}).size()
  }

  method totalDeMateriasDelAnioAnterior(carrera, materia){
    return carrera.materias().filter({materiaActual => materiaActual.anio() == materia.anio() - 1}).size()
  }
}

object nada {
  method requerimiento(estudiante, materia, carrera) {
    return true
  }
}


class Carrera {
  const materias

  method materias(){
    return materias
  }
}


class Materia {

  const carrera
  var property requisito        
  var property capacidad
  const anio
  var property creditos
  var property creditosNecesarios
  const property estudiantes         = #{}
  const property estudiantesEnEspera = []
  const estrategiaDeEspera
  
  method anio(){
    return anio
  }
  
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
    if(not self.requisito().requerimiento(estudiante, self, carrera)){
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
    estudiante.materiasInscripto().remove(self)
    self.obtenerLugarEnMateria()
  }

  method validarBaja(estudiante){
    if(not estudiantes.contains(estudiante)){
      self.error("El estudiante no se encuentra en la materia")
    }
  }

  method obtenerLugarEnMateria(){
  if(estudiantesEnEspera.size() > 0){
    var estudiante = estrategiaDeEspera.prioritario(estudiantesEnEspera)
    estudiantes.add(estudiante)
    estudiante.materiasInscripto().add(self)
    estudiantesEnEspera.remove(estudiante)
  }
}

  method tieneCupo(){
    return estudiantes.size() < capacidad
  }

  method puedeInscribirse(estudiante){
    return estudiante.materias().contains(self) and not estudiante.materiasInscripto().contains(self) and not estudiante.tieneAprobado(self) and self.requisito().requerimiento(estudiante, self, carrera)
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
  method materias(carrera){
    self.validarCarrera(carrera)
    return carrera.materias().filter({materia => materia.puedeInscribirse(self)})
  }
  
  method validarCarrera(carrera){
    if(not carreras.contains(carrera)){
      self.error("No está inscripto en la carrera")
    }
  }
}