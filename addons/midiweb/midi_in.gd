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
class_name MidiInWeb
extends Node

signal midi_message(data)
var callback = JavaScriptBridge.create_callback(_on_midi)
var opened_input_id = -1


func open_port(index : int):
	JavaScriptBridge.eval("MIDIEngine.open_input_port(" + str(index) + ");")
	opened_input_id = index
	var window = JavaScriptBridge.get_interface("window")
	window._midi_callback = callback

func is_port_open() -> bool:
	var is_open = JavaScriptBridge.eval("MIDIEngine.is_input_port_open(" + str(opened_input_id) + ");")
	return is_open

func get_port_names() -> PackedStringArray:
	var names_json = JavaScriptBridge.eval("MIDIEngine.get_input_port_names();")
	var names = JSON.parse_string(names_json)
	return names

## Not implemented yet
func ignore_types(midi_sysex : bool, midi_time : bool, midi_sense : bool):
	pass

func get_port_name(index : int) -> String:
	var name = JavaScriptBridge.eval("MIDIEngine.get_input_port_name(" + str(index) + ");")
	return name

func get_port_count() -> int:
	var port_count = JavaScriptBridge.eval("MIDIEngine.get_input_port_count();")
	return port_count

func _on_midi(data):
	var parsed = JSON.parse_string(data[0])
	var midi = []
	for n in parsed["data"]:
		midi.append(int(n))
	emit_signal("midi_message", midi)
