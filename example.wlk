object programacion {}
object medicina {}
object derecho {}

class Materia {
  const carrera
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


  method registrarAprobacion(registrarMateria, registrarNota){
    self.validarAprobacion(registrarMateria)
    materiasAprobadas.add(new Aprobacion(materia = registrarMateria, nota = registrarNota))

  }
  method validarAprobacion(materia){
    if (materiasAprobadas.map({materiaActual => materiaActual.materia()}).contains(materia)){
      self.error("La materia ya está registrada")
    }
  }

  method tieneAprobado(materia){
    return (materiasAprobadas.map({aprobacion => aprobacion.materia()}).contains(materia))
  }
  method cantidadMateriasAprobadas(){
    return materiasAprobadas.size()
  }
  method promedio(){
    return if(self.cantidadMateriasAprobadas() == 0) { self.error("El estudiante no tiene materias aprobadas") } else {materiasAprobadas.sum({aprobacion => aprobacion.nota()}) / self.cantidadMateriasAprobadas()}
  }
}

//Instanciamos a roque
var roque = new Estudiante()

//PROGRAMACION
var elementosDeProgramacion = new Materia(carrera = programacion)
var matematica1 = new Materia(carrera = programacion)
var objetos1 = new Materia(carrera = programacion)
var objetos2 = new Materia(carrera = programacion)
var objetos3 = new Materia(carrera = programacion)
var trabajoFinal = new Materia(carrera = programacion)
var basesDeDatos = new Materia(carrera = programacion)

//MEDICINA
var quimica = new Materia(carrera = medicina)
var biologia1 = new Materia(carrera = medicina)
var biologia2 = new Materia(carrera = medicina)
var anatomiaGeneral = new Materia(carrera = medicina)

//DERECHO
var latin = new Materia(carrera = derecho)
var derechoRomano = new Materia(carrera = derecho)
var historiaDerechoArgentino = new Materia(carrera = derecho)
var derechoPenal1 = new Materia(carrera = derecho)
var derechoPenal2 = new Materia(carrera = derecho)