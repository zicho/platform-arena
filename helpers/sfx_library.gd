extends Node

func play(sfx):
	if sfx:
		get_node(sfx).play()
	else:
		print("ERROR: Sound '%s' not located" % sfx)
		
func play_with_pitch_up(sfx, pitch):
	if sfx:
		var sfx_node = get_node(sfx)
		sfx_node.pitch_scale = 1 + pitch
		sfx_node.play()