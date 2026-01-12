extends StaticBody2D

func interact(_player: CharacterBody2D):
	get_tree().get_first_node_in_group('Carta').show()
