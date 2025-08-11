@tool
extends EditorExportPlugin
class_name MIDIWebExportPlugin

signal export_warning
const MIDI_JS = "midi.js"

func _get_name() -> String:
	return "MIDIWebExportPlugin"

func _supports_platform(platform) -> bool:
	# Uncomment to debug platform support
	# emit_signal("export_warning", "Checking platform support: %s" % str(platform))
	if platform is EditorExportPlatformWeb:
		return true
	return false

func _get_export_options_overrides(platform) -> Dictionary:
	emit_signal("export_warning", "Added midi.js include.")
	return {
		"html/head_include": '<script src="%s"></script>' % MIDI_JS,
	}

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	emit_signal("export_warning", "Export started")
	if features.has("web"):

		# Get the export directory path
		var export_dir = ProjectSettings.globalize_path(path.get_base_dir())
		emit_signal("export_warning", "Exporting midi.js to " + export_dir)
		# Source path for midi.js
		var source_path = "res://addons/midiweb/%s" % MIDI_JS
		
		# Target path in the export directory
		var target_path = export_dir + "/" + MIDI_JS
		
		# Copy the file
		var dir = DirAccess.open("res://")
		if dir:
			var source_file_path = ProjectSettings.globalize_path(source_path)
			#emit_signal("export_warning", "Copying from " + source_file_path + " to " + target_path)
			var result = dir.copy(source_file_path, target_path)
			if result == OK:
				emit_signal("export_warning", "midi.js successfully copied to export directory: " + target_path)
			else:
				emit_signal("export_warning", "Error copying midi.js: " + str(result))
		else:
			emit_signal("export_warning", "Directory access error")
