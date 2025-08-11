# Copyright 2025 MIDILLI Tech
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
@tool
extends EditorPlugin

const EXPORT_SCRIPT = preload("res://addons/midiweb/export_plugin.gd")
var export_plugin = null

func _enter_tree():
	export_plugin = MIDIWebExportPlugin.new()
	if export_plugin == null:
		push_error("MIDIWebExport plugin error!")
		return
	add_export_plugin(export_plugin)
	export_plugin.connect("export_warning", _on_export_warning)

func _on_export_warning(msg):
	print(msg)

func _exit_tree():
	if export_plugin != null:
		remove_export_plugin(export_plugin)
		export_plugin = null
	print("Removing MIDI Web plugin.")
