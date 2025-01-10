extends Node

var file_dialog: FileDialog
var filename

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	if(file_dialog == null):
		file_dialog = FileDialog.new()
		file_dialog.access = FileDialog.ACCESS_FILESYSTEM
		file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		add_child(file_dialog)
		file_dialog.popup_centered_ratio(0.33)
		file_dialog.position.x = 380
		file_dialog.position.y = 150
		file_dialog.size.x = 400
		file_dialog.size.y = 300
		
	file_dialog.visible = true
	await file_dialog.file_selected
	filename = file_dialog.current_path
	$Sprite2D.texture = load(filename)
	var img = Image.new()
	var err = img.load(filename)
	if err != OK:
		print("File open faild");
		img.free()
		return
	
	var farr = filename.split(".")[-1]
	var imgdir = filename.left(-farr.length()-1)
	cut_pixels(img, imgdir,int($hx.text), int($zx.text))
	return
	
func cut_pixels(image: Image, imgdir: String, wn: int, hn: int):
	DirAccess.make_dir_absolute(imgdir)
	var t = 1
	var width = image.get_width()
	var height = image.get_height()
	var imgw = int(width/wn)
	var imgh = int(height/hn)
	#var frames = []
	for y in range(0, height, imgh):
		for x in range(0, width, imgw):
			print("x: "+str(x)+"--y: "+str(y))
			var frame_image = Image.new()
			frame_image = Image.create_empty(imgw, imgh, false, image.get_format())
			## 确保不超出图片边界
			var rect = Rect2(x, y, imgw, imgh)
			#print(rect)
			rect = rect.intersection(Rect2(0, 0, imgw, imgh))
			#print(rect)
			#print(str(t)+":---------------------------")
			
			#
			frame_image.blit_rect(image, Rect2(x, y, width, height), Vector2(0, 0))
			frame_image.save_png(imgdir+"/"+str(t)+".png")
			t += 1
			#
			var texture := ImageTexture.create_from_image(frame_image)
			#
			## 这里可以根据需要将纹理添加到场景中
			## 例如，创建一个Sprite实例并设置纹理
			var sprite = Sprite2D.new()
			sprite.texture = texture
			sprite.position.x = x + 100
			sprite.position.y = y + 100
			add_child(sprite)
	
