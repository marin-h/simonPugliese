extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_personaje_chocando(colisionador):
	if(colisionador == get_node("meta")):
		get_node("ganaste/Panel/anim").play("mostrar")