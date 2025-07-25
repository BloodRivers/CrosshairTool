@tool
class_name CrosshairTool
extends Control

const SAVE_PATH: String = "user://crosshair_config.json"
const OUTLINE_COLOR: Color = Color(0, 0, 0)

@export_group("Lines", "lines")
@export var lines_show: bool = true:
	set(value):
		lines_show = value
		queue_redraw()

@export_range(0.5, 20.0, 0.5) var lines_length: float = 4.0:
	set(value):
		lines_length = value
		queue_redraw()

@export_range(0.5, 10.0, 0.5) var lines_thickness: float = 1.0:
	set(value):
		lines_thickness = value
		queue_redraw()

@export_range(0.0, 20.0, 0.5) var lines_gap: float = 5.5:
	set(value):
		lines_gap = value
		queue_redraw()

@export var lines_rounded: bool = true:
	set(value):
		lines_rounded = value
		queue_redraw()

@export_range(0, 8, 1.0) var lines_corner_detail: float = 8:
	set(value):
		lines_corner_detail = value
		queue_redraw()

@export var lines_color: Color = Color.WHITE:
	set(value):
		lines_color = value
		queue_redraw()

@export_subgroup("Outline", "lines_outline")
@export var lines_outline_enabled: bool = true:
	set(value):
		lines_outline_enabled = value
		queue_redraw()

@export_range(0.5, 2.0, 0.5) var lines_outline_thickness: float = 0.5:
	set(value):
		lines_outline_thickness = value
		queue_redraw()

@export_group("Center Dot", "center_dot")
@export var center_dot_show: bool = true:
	set(value):
		center_dot_show = value
		queue_redraw()

@export_range(0.5, 5.0, 0.5) var center_dot_size: float = 0.5:
	set(value):
		center_dot_size = value
		queue_redraw()

@export var center_dot_rounded: bool = true:
	set(value):
		center_dot_rounded = value
		queue_redraw()

@export var center_dot_color: Color = Color.WHITE:
	set(value):
		center_dot_color = value
		queue_redraw()

@export_subgroup("Outline", "center_dot_outline")
@export var center_dot_outline_enabled: bool = true:
	set(value):
		center_dot_outline_enabled = value
		queue_redraw()

@export_range(0.5, 2.0, 0.5) var center_dot_outline_thickness: float = 0.5:
	set(value):
		center_dot_outline_thickness = value
		queue_redraw()


@export_tool_button("Show Config") var show_config_action: Callable = func() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))


func _ready() -> void:
	queue_redraw()
	load_config(SAVE_PATH)


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAW:
		_update_crosshair()
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		save_config(SAVE_PATH)


func _update_crosshair() -> void:
	if not is_inside_tree():
		return
	if size == Vector2.ZERO:
		return

	var center: Vector2 = size / 2
	
	if lines_show:
		_draw_crosshair_lines(center)
	if center_dot_show:
		_draw_center_dot(center)


func _create_crosshair_lines_stylebox() -> StyleBoxFlat:
	@warning_ignore_start("narrowing_conversion")

	var stylebox: StyleBoxFlat = StyleBoxFlat.new()

	stylebox.bg_color = lines_color
	stylebox.anti_aliasing = false

	if lines_rounded:
		stylebox.corner_radius_top_left = lines_thickness
		stylebox.corner_radius_top_right = lines_thickness
		stylebox.corner_radius_bottom_left = lines_thickness
		stylebox.corner_radius_bottom_right = lines_thickness
		stylebox.corner_detail = lines_corner_detail

	return stylebox


func _draw_crosshair_lines(center: Vector2) -> void:
	var sb: StyleBoxFlat = _create_crosshair_lines_stylebox()
	var half_thickness: float = lines_thickness / 2

	var lines: Array[Rect2] = [
		# Left
		Rect2(
			center.x - lines_gap - lines_length,
			center.y - half_thickness,
			lines_length,
			lines_thickness
		),
		# Right
		Rect2(
			center.x + lines_gap,
			center.y - half_thickness,
			lines_length,
			lines_thickness
		),
		# Top
		Rect2(
			center.x - half_thickness,
			center.y - lines_gap - lines_length,
			lines_thickness,
			lines_length
		),
		# Bottom
		Rect2(
			center.x - half_thickness,
			center.y + lines_gap,
			lines_thickness,
			lines_length
		)
	]

	if lines_outline_enabled:
		_draw_crosshair_lines_outline(lines)

	for line: Rect2 in lines:
		sb.draw(get_canvas_item(), line)


func _draw_crosshair_lines_outline(lines: Array[Rect2]) -> void:
	var outline_sb: StyleBoxFlat = StyleBoxFlat.new()
	outline_sb.bg_color = OUTLINE_COLOR
	outline_sb.anti_aliasing = false

	if lines_rounded:
		outline_sb.corner_radius_top_left = lines_thickness + lines_outline_thickness
		outline_sb.corner_radius_top_right = lines_thickness + lines_outline_thickness
		outline_sb.corner_radius_bottom_left = lines_thickness + lines_outline_thickness
		outline_sb.corner_radius_bottom_right = lines_thickness + lines_outline_thickness
		outline_sb.corner_detail = lines_corner_detail

	for line: Rect2 in lines:
		var outline_rect: Rect2 = Rect2(
			line.position.x - lines_outline_thickness,
			line.position.y - lines_outline_thickness,
			line.size.x + lines_outline_thickness * 2.0,
			line.size.y + lines_outline_thickness * 2.0
		)
		outline_sb.draw(get_canvas_item(), outline_rect)


func _draw_center_dot(center: Vector2) -> void:
	if center_dot_outline_enabled:
		_draw_center_dot_outline(center)
	if center_dot_rounded:
		draw_circle(center, center_dot_size, center_dot_color)
	else:
		var rect_size: float = center_dot_size * 2.0
		var rect: Rect2 = Rect2(
			center.x - center_dot_size,
			center.y - center_dot_size,
			rect_size,
			rect_size
		)
		draw_rect(rect, center_dot_color)


func _draw_center_dot_outline(center: Vector2) -> void:
	if center_dot_rounded:
		draw_circle(
			center,
			center_dot_size + center_dot_outline_thickness,
			OUTLINE_COLOR
		)
	else:
		var outline_size: float = (center_dot_size + center_dot_outline_thickness) * 2.0
		var outline_rect: Rect2 = Rect2(
			center.x - center_dot_size - center_dot_outline_thickness,
			center.y - center_dot_size - center_dot_outline_thickness,
			outline_size,
			outline_size
		)
		draw_rect(outline_rect, OUTLINE_COLOR)


func save_config(path: String) -> void:
	var config := {
		"lines": {
			"show": lines_show,
			"length": lines_length,
			"thickness": lines_thickness,
			"gap": lines_gap,
			"rounded": lines_rounded,
			"corner_detail": lines_corner_detail,
			"color": lines_color.to_html(),
			"outline": {
				"enabled": lines_outline_enabled,
				"thickness": lines_outline_thickness,
				"color": OUTLINE_COLOR.to_html()
			}
		},
		"center_dot": {
			"show": center_dot_show,
			"size": center_dot_size,
			"rounded": center_dot_rounded,
			"color": center_dot_color.to_html(),
			"outline": {
				"enabled": center_dot_outline_enabled,
				"thickness": center_dot_outline_thickness,
				"color": OUTLINE_COLOR.to_html()
			}
		}
	}
	
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(config, "\t"))
		file.close()


func load_config(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to load crosshair config: ", path, " File doesn't exist!")
		return
	
	var json := JSON.new()
	var error := json.parse(file.get_as_text())
	if error != OK:
		push_error("JSON parse error: ", json.get_error_message())
		return
	
	var config: Dictionary = json.get_data()

	var lines: Dictionary = config.get("lines", {})
	lines_show = lines.get("show", lines_show)
	lines_length = lines.get("length", lines_length)
	lines_thickness = lines.get("thickness", lines_thickness)
	lines_gap = lines.get("gap", lines_gap)
	lines_rounded = lines.get("rounded", lines_rounded)
	lines_corner_detail = lines.get("corner_detail", lines_corner_detail)
	if lines.has("color"):
		lines_color = Color.from_string(lines["color"], lines_color)
	
	var lines_outline: Dictionary = lines.get("outline", {})
	lines_outline_enabled = lines_outline.get("enabled", lines_outline_enabled)
	lines_outline_thickness = lines_outline.get("thickness", lines_outline_thickness)
	
	var center_dot: Dictionary = config.get("center_dot", {})
	center_dot_show = center_dot.get("show", center_dot_show)
	center_dot_size = center_dot.get("size", center_dot_size)
	center_dot_rounded = center_dot.get("rounded", center_dot_rounded)
	if center_dot.has("color"):
		center_dot_color = Color.from_string(center_dot["color"], center_dot_color)
	
	var center_dot_outline: Dictionary = center_dot.get("outline", {})
	center_dot_outline_enabled = center_dot_outline.get("enabled", center_dot_outline_enabled)
	center_dot_outline_thickness = center_dot_outline.get("thickness", center_dot_outline_thickness)

	queue_redraw()
