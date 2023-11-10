import personajes.*
import sonidos.*
import wollok.game.*

	
object juego {
	method inicio() {
        game.addVisual(fondoReglas)
		musicaDeInicio.musicaDeFondo(musicaDeInicio.musicIntro())
        keyboard.enter().onPressDo{self.iniciarJuego()}
	}
	method iniciarJuego() {
    	game.clear()
		const instanciaSonidoJuego = new MusicaDeJuego()
		musicaDeInicio.sacarMusica(musicaDeInicio.musicIntro())
		instanciaSonidoJuego.musicaDeFondo(instanciaSonidoJuego.musicGame())
        self.configurarTeclas()
        self.agregarVisualesJuego()
		self.spawnPatos(1600, 1100)
    }
    method iniciarNivelDos() {
    	game.clear()
		const instanciaSonidoNivelDos = new MusicaNivelDos()		
		instanciaSonidoNivelDos.musicaDeFondo(instanciaSonidoNivelDos.musicGame())
		game.addVisual(fondoNivelDificil)
		game.addVisual(cuadroPuntos)
		game.addVisual(puntaje)
		game.addVisual(perro)
		game.addVisual(balas)
		game.addVisualCharacter(arma)
        self.configurarTeclas()
		game.schedule(500, {self.spawnPatos(1250, 500)})
    }
    method finDelJuego() {
    	game.clear()
    	const instanciaSonidoFinal = new MusicaFinal()
		instanciaSonidoFinal.musicaDeFondo(instanciaSonidoFinal.finalMusic())
        game.addVisual(fondoFinal)
        game.addVisual(cuadroPuntos)
        game.addVisual(puntaje)
        keyboard.r().onPressDo{self.reiniciarJuego()}
	}
	method reiniciarJuego() {
		game.clear()
		const instanciaSonidoJuego = new MusicaDeJuego()
		instanciaSonidoJuego.musicaDeFondo(instanciaSonidoJuego.musicGame())
        self.agregarVisualesJuego()
		self.spawnPatos(1300, 1100)
		self.configurarTeclas()
		arma.balas(5)
		puntaje.puntos(0)
	}
	method configurarTeclas() {
    var recargaEnCurso = false
    keyboard.space().onPressDo {
        if (!recargaEnCurso) {
            arma.recargarYDisparar()
            recargaEnCurso = true
            game.schedule(625, {recargaEnCurso = false })
        	}
    	}
	}
	method posicionAleatoria() {
        const posicionRandom =  game.at(0.randomUpTo(game.width()), 2.randomUpTo(game.height()))
        return 
        	if(game.getObjectsIn(posicionRandom).isEmpty()) {posicionRandom}
       		else {self.posicionAleatoria()}
	} 
	method agregarVisualPato(ticksRemove) {
		const generacionPato = new Patos(position = self.posicionAleatoria())
		game.addVisual(generacionPato)
		generacionPato.graznidoPato()
		game.schedule([ticksRemove*2,ticksRemove*3,ticksRemove*4].anyOne(), {generacionPato.eliminarPatoSiEsta(generacionPato)})
	}
	method agregarVisualPatoDorado(ticksRemove) {
		const generacionPatoDorado = new PatosDorados(position = self.posicionAleatoria())
		game.addVisual(generacionPatoDorado)
		generacionPatoDorado.graznidoPato()
		game.schedule([ticksRemove,ticksRemove*1.5,ticksRemove*2].anyOne(), {generacionPatoDorado.eliminarPatoSiEsta(generacionPatoDorado)})
	}
 	method spawnPatos(ticksSpawn, ticksRemove) {
		game.onTick([ticksSpawn*2, ticksSpawn*3].anyOne(), "pato",{self.agregarVisualPato(ticksRemove)})
		game.onTick([ticksSpawn*8, ticksSpawn*10].anyOne(), "patoDorado",{self.agregarVisualPatoDorado(ticksRemove)})
	}
	method agregarVisualesJuego() {
		game.addVisual(fondoJuego)
		game.addVisual(cuadroPuntos)
		game.addVisual(puntaje)
		game.addVisual(perro)
		game.addVisual(balas)
		game.addVisualCharacter(arma)
	}
}


object puntaje {
	var property puntos = 0

	method esPato() = false
	method esPatoDorado() = false
	method puntos() = puntos
	method position() = game.at(game.width() - 1, game.height() - 4)
	method text() = self.puntos().toString()
	method matar(score) {}
	method sumarPuntos(cantidad) {puntos += cantidad}
}


object fondoReglas {
	const property image = "./images/pantallaReglas.jpg"
	const property position = game.at(0,0)
	
	method esPato() = false
	method esPatoDorado() = false
	method matar(score) {}
}


object fondoJuego {
	const property image = "./images/background.jpeg"
	const property position = game.at(0,0)
	
	method esPato() = false
	method esPatoDorado() = false
	method matar(score) {}
}


object fondoNivelDificil {
	const property image = "./images/background2.png"
	const property position = game.at(0,0)
	
	method esPato() = false
	method esPatoDorado() = false
	method matar(score) {}
}


object fondoFinal {
	const property image = "./images/pantallaFinal.jpg"
	const property position = game.at(0,0)
	
	method esPato() = false
	method esPatoDorado() = false
	method matar(score) {}
}