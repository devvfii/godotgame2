extends CustomControl



func _on_button_pressed():
	$"..".generate(7)


func _on_button_2_pressed():
	$"..".generate(10)


func _on_button_3_pressed():
	$"..".generate(13)


func _on_button_4_pressed():
	if $"../Nodes".visible:
		$"..".hide_map_only()
	else:
		$"..".show_map_only()
