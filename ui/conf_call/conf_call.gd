extends Control

var contact_names: Array[String] = [
"Ciara Clary",
"Lexis Reyes",
"Jaidyn Tanner",
"Shelby Godfrey",
"Jocelynn Branch",
"Eliezer Hutchings",
"Braeden Burden",
"Matteo Parris",
"Jacklyn Cronin",
"Deion Hite",
"Brant Coffey",
"Moises Bratcher",
"Johnson Berger",
"Ammon Castro",
"Lamar Christensen",
"Reese Adam",
"Donavan Dickey",
"Samira Dempsey",
"Marcello Crowder",
"Luiz Guinn",
"Alisha South",
"Vladimir Quinones",
"Mason Huston",
"Anton Rowley",
"Alfonso Hedrick",
"Slade Harding",
"Colin Mansfield",
"Auston Noel",
"Duncan Douglass",
"Aimee Diamond",
"Sarina Whitley",
"Moses Kuykendall",
"Annette Belcher",
"Jadyn Borders",
"Treyvon Flores",
"Brookelyn Paine",
"Cyrus Choate",
"Jayme Rader",
"Farrah Nowak",
"Jarvis Joiner",
"Makaela Richards",
"Destinee Cathey",
"Fred Ulrich",
"Madisen Douglass",
"Genesis Bachman",
"Camron Stern",
"Delilah Vidal",
"Samaria Higgins",
"Sterling Fullerton",
"Violet Zapata",
"Armand Lindquist",
"Taylor Sapp",
"Marjorie Roberson",
"Milan Parrish",
"Gage Whittaker",
"Tyrek South",
"Devontae Moriarty",
"Lewis Olson",
"Alma Avalos",
"Perry Moreau",
"Aaron Culver",
"Tyra Morin",
"Jonah Atkins",
"Kate Toro",
"Harley Matos",
"Grace Peck",
"Bridger Kimbrough",
"Stephanie Osorio",
"Aracely Kirsch",
"Derrick McPherson",
"Duane Dion",
"Aria Rinehart",
"Harlie Kroll",
"Magaly Rose",
"Sahara Mitchell",
"Eva Raines",
"Theo Ryder",
"London Voss",
"Keith Reiter",
"Kimberly Ferrara",
"Colby France",
"Justice Bunch",
"Anders Moua",
"Seamus Porras",
"Britton Waters",
"Cordell Weaver",
"Brannon Carranza",
"Harris Bergman",
"Shelton Breaux",
"Nehemiah Gilbert",
"Ismael Ragan",
"Roland Kerr",
"Sommer Weir",
"Delaney Holly",
"Berenice Hudson",
"Kya Locklear",
"Leonel Sapp"]


@onready var contact_container: VBoxContainer = $ContactList/ScrollContainer/VBoxContainer
@onready var contact_container_title: Label = $ContactList/TitlePanel/Label
@onready var call_panel: Panel = $ConfCameraPanel/CallPanel
@onready var call_panel_label: Label = $ConfCameraPanel/CallPanel/Label
@onready var call_panel_close_button: TextureButton = $ConfCameraPanel/CallPanel/CloseButton
@onready var call_panel_call_button: TextureButton = $ConfCameraPanel/CallPanel/CallButton
@onready var anim_player = $ConfCameraPanel/ConfCamera/AnimationPlayer

var contact_scene = preload("./contact/contact.tscn")
var selected_contact: String = ""

func _ready() -> void:
	call_panel_close_button.pressed.connect(_on_call_panel_close_pressed)
	call_panel_call_button.pressed.connect(_on_call_panel_call_pressed)
	contact_names.sort()
	contact_names.push_front("Boss")
	contact_container_title.text += " (" + str(contact_names.size()) + ")"
	for n in contact_names:
		var contact = contact_scene.instantiate()
		contact_container.add_child(contact)
		contact.set_contact_name(n)
		contact.contact_pressed.connect(_on_contact_pressed)

func _on_contact_pressed(contact_name: String) -> void:
		call_panel.show()
		call_panel_label.text = contact_name
		selected_contact = contact_name

func _on_call_panel_close_pressed() -> void:
	call_panel.hide()

func _on_call_panel_call_pressed() -> void:
	if not DialogueController.is_playing():
		call_panel.hide()
		if selected_contact == "Boss":
			if _boss_union_call():
				anim_player.play("FadeInBossUnion")
			else:
				anim_player.play("FadeInBoss")
			anim_player.animation_finished.connect(_on_boss_called, CONNECT_ONE_SHOT)
		elif selected_contact == "Luiz Guinn":
			anim_player.play("FadeInUnion")
			anim_player.animation_finished.connect(_on_union_called, CONNECT_ONE_SHOT)
		else:
			var line = DialogueLine.new("PLAYER", "No response...\nI should really call the boss.")
			DialogueController.push_dialogue(line)
			DialogueController.play_queue()

func _get_sp() -> String:
	var sp = SaveCookieController.retrieve_savepoint()
	return sp

func _boss_union_call() -> bool:
	return _get_sp() == "run1" and Story.has_talked_to_union

func _on_union_called(_name: String):
	if _get_sp() == "run1":
		$UnionCalledSequence.play()
		Story.has_talked_to_union = true
	else:
		$UnionCalledFailedSequence.play()
	DialogueController.queue_finished.connect(func():
		anim_player.play("FadeOut"), CONNECT_ONE_SHOT)

func _on_boss_called(_name: String):
	if _boss_union_call():
		$UnionBossSequence.play()
	else:
		if _get_sp() == "run4":
			print("demander webcam")
			$BossCallSequenceRun4.play()
		else:
			$BossCalledSequence.play()
