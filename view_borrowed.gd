extends Control

@onready var books_container: VBoxContainer = $Vertical/ScrollContainer/Books;
var book_res: PackedScene = preload("res://borrowed_book_listing.tscn");



func _ready():
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	var people = config.get_section_keys("users");
	for person in people:
		var uname = config.get_value("users", person);
		var books_string: String = config.get_value("borrowed", person, "");
		print("Books string for " + uname + ": " + books_string);
		var books = books_string.split(",", false);
		
		for book in books:
			var b_title: String = config.get_value("book_titles", book);
			var b_author: String = config.get_value("book_authors", book);
			
			var node = book_res.instantiate();
			node.get_node("Stacker/Title").text = b_title;
			node.get_node("Stacker/Author").text = b_author;
			node.get_node("Stacker/Borrower").text = "Borrowed by " + uname;
			
			books_container.add_child(node);
			print(b_title + " is borrowed by " + uname);


func _on_button_pressed():
	get_tree().change_scene_to_file("res://home.tscn");
