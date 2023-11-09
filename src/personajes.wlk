import juegoConfig.*
import sonidos.*
import wollok.game.*


object arma {
	var property balas = 5
	var property position = game.center()

	method balas() = balas
	method position() = position
	method image() = "./images/crosshair1.png"
	method esPato() = false
	method esPatoDorado() = false
	method agregarDosBalas() {balas = 6.min(balas + 2)}
	method sonidoDisparoSiHayBalas() {if (balas > 0) {new SonidoDisparos().ejecutarDisparo()}}
	method terminarJuego() {if (balas == 0) {juego.finDelJuego()}}
	method disparar() {
		self.sonidoDisparoSiHayBalas()
		if(balas > 0) {			
			game.colliders(self).forEach{pato => pato.matar(10)}
		}
		balas = 0.max(balas - 1)
		perro.avisoBalasTotales()
		game.schedule(1000, {self.terminarJuego()})
	}
	method recargarYDisparar() {
		new SonidoRecargas().ejecutarRecarga()
		game.schedule(200, {self.disparar()})
	}
}


object balas {
  	var property position = game.at(0, 0)

	method esPato() = false
	method esPatoDorado() = false
  	method matar(score) {}
  	method image() {
    	if (arma.balas() == 5) {return "./images/5Balas.png"}
    	else if (arma.balas() == 4) {return "./images/4Balas.png"}
    	else if (arma.balas() == 3) {return "./images/3Balas.png"}
    	else if (arma.balas() == 2) {return "./images/2Balas.png"}
    	else if (arma.balas() == 1) {return "./images/1Balas.png"}
    	else {return "./images/0Balas.png"}
  	}
}


object cuadroPuntos {
  	var property position = game.at(5, 0)

	method esPato() = false
	method esPatoDorado() = false
  	method matar(score) {}
  	method image() = "./images/score.png"
}


object perro {
	var property position = game.at(1, 1)
	
	method esPato() = false
	method esPatoDorado() = false
	method image() = "./images/clue.png"
	method avisoBalasTotales() {game.say(self, "Te quedan " + arma.balas().toString() + " bala/s!")}
	method avisoBalasExtra() {game.say(self, "Se sumaron 2 balas extra!")}
	method matar(score) {}
	method removerVisual() {}
}


class Patos {
	var position
	const sonidoDePato = game.sound("./sounds/cuack.mp3")
	
	method graznidoPato() {
	 	sonidoDePato.volume(0.5)
		sonidoDePato.play()
	}
	method position() = position
	method image() = "./images/pato1.png" 
	method esPato() = true
	method esPatoDorado() = false
	method removerVisual() {game.removeVisual(self)}
	method eliminarPatoSiEsta(patoAca) {
		if (game.hasVisual(patoAca)) {
			patoAca.removerVisual()
		}
	}
	method matar(score) {
		self.removerVisual()
		puntaje.sumarPuntos(score)		
	}
} 


class PatosDorados inherits Patos {
	override method esPato() = !super()
	override method esPatoDorado() = !super()
	override method image() = "./images/patoDorado1.png" 
	override method matar(score) {
		super(score + 20)
		arma.agregarDosBalas() 
		perro.avisoBalasExtra()	
	}
}