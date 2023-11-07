extends Control

@onready var books_container: VBoxContainer = $Vertical/ScrollContainer/Books;
@onready var return_confirm_dialog: ConfirmationDialog = $ReturnConfirmDialog;
var book_res: PackedScene = preload("res://borrow_book_listing.tscn");
var loaded_books: Array = [];


func _ready():
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	# Borrowed books
	var books_string: String = config.get_value("borrowed", Global.current_user, "");
	var books = books_string.split(",", false);
	
	for book in books:
		var b_title: String = config.get_value("book_titles", book);
		var b_author: String = config.get_value("book_authors", book);
		var b_year: String = config.get_value("book_years", book);
		var b_desc: String = config.get_value("book_desc", book);
		
		loaded_books.append({
			id = book,
			title = b_title,
			author = b_author,
			year = b_year,
			desc = b_desc
		});
		
		var object = book_res.instantiate();
		books_container.add_child(object);
		
		object.get_node("TextAligner/Title").text = b_title;
		object.get_node("TextAligner/Desc").text = "Author: " + b_author + "\nYear: " + b_year + "\n" + b_desc;
		object.pressed.connect(return_book.bind(book));


func get_book_name_from_id(id: String):
	for book in loaded_books:
		if book.id == id:
			return book.title;
	return null;


func return_book(id: String):
	return_confirm_dialog.dialog_text = "Are you sure you would like to return " + get_book_name_from_id(id) + "?";
	return_confirm_dialog.get_ok_button().pressed.connect(return_confirmed.bind(id));
	return_confirm_dialog.visible = true;


func return_confirmed(id: String):
	var config: ConfigFile = ConfigFile.new();
	config.load("user://lib.cfg");
	
	var existing_borrowed: String = config.get_value("borrowed", Global.current_user, "");
	existing_borrowed = existing_borrowed.replace(id + ",", "");
	config.set_value("borrowed", Global.current_user, existing_borrowed);
	
	config.save("user://lib.cfg");
	get_tree().change_scene_to_file("res://home.tscn");


func _on_back_pressed():
	get_tree().change_scene_to_file("res://home.tscn");
