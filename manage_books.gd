extends Control

@onready var title: TextEdit = $Vertical/Horizontal/AddBook/Title;
@onready var author: TextEdit = $Vertical/Horizontal/AddBook/Author;
@onready var year: TextEdit = $Vertical/Horizontal/AddBook/Year;
@onready var desc: TextEdit = $Vertical/Horizontal/AddBook/Desc;

var book_res: PackedScene = preload("res://admin_book_listing.tscn");
@onready var books_container: VBoxContainer = $Vertical/Horizontal/ViewBooks/ScrollContainer/Books;


func _ready():
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	var books = config.get_section_keys("book_titles");
	
	for book in books:
		# book is the id
		var b_title: String = config.get_value("book_titles", book);
		var b_author: String = config.get_value("book_authors", book);
		var b_year: String = config.get_value("book_years", book);
		var b_desc: String = config.get_value("book_desc", book);
		
		create_book_object(b_title, b_author, b_year, b_desc, book);


func create_book_object(b_title: String, b_author: String, b_year: String, b_desc: String, id: String):
	var object = book_res.instantiate();
	books_container.add_child(object);
	
	object.get_node("Id").text = id;
	object.get_node("TextAligner/Title").text = b_title;
	object.get_node("TextAligner/Desc").text = "Author: " + b_author + "\nYear: " + b_year + "\n" + b_desc;
	object.get_node("TextAligner/Delete").pressed.connect(delete_book.bind(id));


func delete_book(id: String):
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	config.erase_section_key("book_titles", id);
	config.erase_section_key("book_authors", id);
	config.erase_section_key("book_years", id);
	config.erase_section_key("book_desc", id);
	
	config.save("user://lib.cfg");
	
	# Remove entry
	for child in books_container.get_children():
		var c_id = child.get_node("Id").text;
		if c_id != id:
			continue;
		books_container.remove_child(child);


func _on_submit_pressed():
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	var id_int = int(config.get_value("state", "current_book_id", "0")) + 1;
	var id = str(id_int);
	
	var b_title: String = title.text;
	var b_author: String = author.text;
	var b_year: String = year.text;
	var b_desc: String = desc.text;
	
	config.set_value("book_titles", id, b_title);
	config.set_value("book_authors", id, b_author);
	config.set_value("book_years", id, b_year);
	config.set_value("book_desc", id, b_desc);
	
	config.set_value("state", "current_book_id", id);
	config.save("user://lib.cfg");
	
	title.text = "";
	author.text = "";
	year.text = "";
	desc.text = "";
	
	create_book_object(b_title, b_author, b_year, b_desc, id);


func _on_back_pressed():
	get_tree().change_scene_to_file("res://home.tscn");
