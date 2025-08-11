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
class_name MidiOutWeb
extends Node

var opened_output_id = -1

func open_port(index : int):
	JavaScriptBridge.eval("MIDIEngine.open_output_port(" + str(index) + ");")
	opened_output_id = index

func is_port_open() -> bool:
	var is_open = JavaScriptBridge.eval("MIDIEngine.is_output_port_open(" + str(opened_output_id) + ");")
	return is_open

func get_port_names() -> PackedStringArray:
	var names_json = JavaScriptBridge.eval("MIDIEngine.get_output_port_names();")
	var names = JSON.parse_string(names_json)
	return names

func get_port_name(index : int) -> String:
	var name = JavaScriptBridge.eval("MIDIEngine.get_output_port_name(" + str(index) + ");")
	return name

func get_port_count() -> int:
	var port_count = JavaScriptBridge.eval("MIDIEngine.get_output_port_count();")
	return port_count

func send_message(message : Array):
	var js_call = "MIDIEngine.send_message([" + ",".join(message) + "]);"
	JavaScriptBridge.eval(js_call)
