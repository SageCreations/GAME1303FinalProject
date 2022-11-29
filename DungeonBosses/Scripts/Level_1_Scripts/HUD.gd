extends CanvasLayer

var screen_coord = get_parent().get_viewport_transform() * (get_global_transform() * local_pos)
