extends Node

func play(example):
    # Duplicates the example AudioStreamPlayer as a child to a new node, do not use for positional sounds
    var nsound = example.duplicate()
    add_child(nsound)
    nsound.play()
    nsound.connect("finished", nsound, "queue_free")
