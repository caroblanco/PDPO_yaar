class BarcoPirata{
	var mision
	const tripulantes = []
	const capacidad
	
	method cambiarMision(nuevaM){
		mision = nuevaM
		tripulantes.removeAllSuchThat({unTripulante => not nuevaM.esUtil(unTripulante)})  //!!!!!!!!!!!!!!!!!!!!!!!
	}
	
	method aniadirTripulante(tripulante){
		if(mision.esUtil(tripulante)){
			tripulantes.add(tripulante)	
		}else{
			self.error("no se puede agregar al pirata")
		}
	}
	
	method esTemible() = mision.puedeRealizarse(self) 
	
	method cantidadTripulantes() = tripulantes.size()
	
	method suficienteTripulacion() = self.cantidadTripulantes() >= capacidad * 0.9
	
	method alMenosUnoTiene(item) = tripulantes.any({unTripulante => unTripulante.tiene(item)})
	
	method puedeFormarParte(unPirata) = self.hayLugarParaUnoMas() && mision.esUtil(unPirata)
	
	method hayLugarParaUnoMas() = self.cantidadTripulantes() < capacidad
	
	method esVulnerablea(otroBarco) = self.cantidadTripulantes() <= otroBarco.cantidadTripulantes()/2
	
	method todosPasadosDeGrog() = tripulantes.forAll({unTripulante => unTripulante.pasadoDeGrog()})
	
	method pirataMasEbrio() = tripulantes.max({unTripulante => unTripulante.nivelEbriedad()})
	
	method anclarEnCiudadCostera(ciudad){
		tripulantes.forEach({unTrip => unTrip.tomarTrago()})
		self.perderAlMasEbrio(ciudad)
	}
	
	method perderAlMasEbrio(ciudad){
		tripulantes.remove(self.pirataMasEbrio())
		ciudad.agregarHabitante(self.pirataMasEbrio())
	}
	
	method pasados() = tripulantes.filter({unTrip => unTrip.pasadoDeGrog()})
	
	method cuantosPasados() = self.pasados().size()
	
	method itemsPasados(){
		const itemsPasados = self.pasados().flatMap({unPirata => unPirata.items()})
		return itemsPasados.size()
	}
	
	method tripulantePasadoMasDinero() = self.pasados().max({unPir => unPir.monedas()})
	
	method tripulanteQInvitoAMas() = tripulantes.max({unPir => unPir.cantInvitados()})
	
	method puedeSerSaqueadoPor(pirata) = pirata.pasadoDeGrog()
}

class Pirata{
	const items = []
	var nivelDeEbriedad
	var property monedas
	const invitoA = []	
	
	method cantInvitados() = invitoA.size()
	
	method tiene10Items() = items.size() >=10
	
	method items() = items
	
	method ebriedadAlMenos50() = nivelDeEbriedad >= 50

	method nivelEbriedad() = nivelDeEbriedad
	
	method tomarTrago(){
		nivelDeEbriedad += 5
		monedas -= 1
	}
	
	method tiene(item) = items.contains(item)
	
	method seAnimaASaquear(vistima) = vistima.puedeSerSaqueadoPor(self)
	
	method pasadoDeGrog() = nivelDeEbriedad >=90
}

class EspiaCorona inherits Pirata{
	override method pasadoDeGrog() = false
	
	override method seAnimaASaquear(vistima) = super(vistima) && self.tiene("permiso de la corona")
}
////////////////////////////////////////////////////////////////////////////////////////////////////////

class Mision{
	method esUtil()
	
	method puedeRealizarse(barco) = barco.suficienteTripulacion()
}

class BusquedaTesoro inherits Mision{
	const items = ["brujula", "mapa", "botella"]
	
	method esUtil(unPirata) = items.any({unItem=> unPirata.tiene(unItem)}) && unPirata.monedas() <= 5
	
	override method puedeRealizarse(barco) = super(barco) && barco.alMenosUnoTiene("llave")

}

class ConvertirseEnLeyenda inherits Mision{
	var itemEspecial
	
	method esUtil(unPirata) = unPirata.tiene10Items() && unPirata.tiene(itemEspecial)
}

class Saqueo inherits Mision{
	const property victima
	var limMonedas
	
	
	method esUtil(unPirata) = unPirata.monedas() < limMonedas && unPirata.seAnimaASaquear(victima)
	
	override method puedeRealizarse(barco) = super(barco) && victima.esVulnerableA(barco)
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

class CiudadCostera{
	const habitantes = []
	
	method esVulnerableA(barco) = barco.cantidadTripulantes() >= 0.4 * habitantes.size() || barco.todosPasadosDeGrog()
	
	method agregarHabitante(hab){
		habitantes.add(hab)
	}
	
	method puedeSerSaqueadoPor(pirata) = pirata.ebriedadAlMenos50()
	
	
}



