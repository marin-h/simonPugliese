extends Node2D

var patron = ['C1', 'D#1', 'A1']
var currentPosicion = 0
var patronTocado = []

func _ready():
	deshabilitarInput(true)
	conectarTeclado()

func conectarTeclado():
	for octava in get_node("teclado").get_children():
		for boton in octava.get_children():
			boton.connect("apretado", self, "boton_apretado" )

func boton_apretado(quien):
	patronTocado.append( str(quien.get_name()) )
	if ( checkPatronTocado() ):
		if patronTocado.size() == currentPosicion + 1:
			currentPosicion += 1
			 
			if currentPosicion == patron.size():
				get_node("error/panel/Label").set_text("ganaste!")
				get_node("error/anim").play("mostrar")
				yield( get_node("error/anim"), "finished" )
				get_tree().change_scene("res://laberinto.tscn")
				return
				
			deshabilitarInput(true)
			get_node("timerRespuesta").start()
			yield( get_node("timerRespuesta"), "timeout" )
			continuarPatron()
	else:
		deshabilitarInput(true)
		get_node("error/anim").play("mostrar")
		yield( get_node("error/anim"), "finished" )
		patronTocado = [] 
		continuarPatron()
	
func checkPatronTocado():
	for i in range(patronTocado.size()):
		if str(patronTocado[i]) != str(patron[i]):
			return false
	return true

func _on_btnEmpezar_pressed():
	get_node("teclado/sonidos_ui").play("click")
	currentPosicion = 0
	get_node("btnEmpezar/anim").play("ocultar")
	yield(get_node("btnEmpezar/anim"), "finished")
	get_node("timerCortito").start()
	yield( get_node("timerCortito"), "timeout" )
	continuarPatron()

func continuarPatron():
	patronTocado = []
	for i in range(0,currentPosicion+1):
		var nombreBoton = patron[i]
		var nombreOctava = "octava" + str(nombreBoton[-1])
		var boton = get_node("teclado/"+nombreOctava+"/" + nombreBoton )
		boton.apretar()
		yield( boton, "finApretado")
	deshabilitarInput(false)
	
func deshabilitarInput(booleano):
	for octava in get_node("teclado").get_children():
		for boton in octava.get_children():
			get_node("teclado/"+octava.get_name()+"/"+boton.get_name()+"/boton-lb").set_disabled(booleano)