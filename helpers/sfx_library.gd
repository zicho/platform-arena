extends Node

func play(sfx):
	if sfx:
		get_node(sfx).play()
	else:
		print("ERROR: Sound '%s' not located" % sfx)
