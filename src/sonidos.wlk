import juegoConfig.*
import personajes.*
import wollok.game.*


class SonidoDisparos {
	const empezarDisparo = game.sound("./sounds/shot2.mp3")
	
	method ejecutarDisparo() {
		empezarDisparo.volume(0.5)
		empezarDisparo.play()
	}
}


class SonidoRecargas {
	const empezarRecarga = game.sound("./sounds/reload.mp3")
	
	method ejecutarRecarga() {
		empezarRecarga.volume(0.5)
		empezarRecarga.play()
	}
}


class Musica {
	method hayMusica() = true
	method musicaDeFondo(musica) {
		musica.volume(0.5)
		game.schedule(200, {musica.play()})
	}	
	method sacarMusica(musica) {musica.stop()}
}


class MusicaDeJuego inherits Musica {
	const property musicGame = game.sound("./sounds/intro.mp3")
}


class MusicaFinal inherits Musica {
	const property finalMusic = game.sound("./sounds/gameOver.mp3")
	
}


class MusicaNivelDos inherits Musica {
	const property musicGame = game.sound("./sounds/segundoNivel2.mp3")
}


object musicaDeInicio inherits Musica {
	const property musicIntro = game.sound("./sounds/levelStart.mp3")
	
	override method musicaDeFondo(musica) {
		super(musica)
		musica.shouldLoop(true)
	}
}