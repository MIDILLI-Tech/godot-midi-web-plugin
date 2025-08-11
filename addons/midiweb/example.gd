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
extends Control

func _ready():
	if OS.get_name() == "Web": # Check if project is running on Web.
		# Init MIDI Web
		JavaScriptBridge.eval("MIDIEngine.init().then(() => { console.log('MIDI Ready!'); });")

		# Wait for devices to be ready
		await get_tree().create_timer(1.0).timeout
		
		var midi_in : MidiInWeb = MidiInWeb.new() # MIDI In
		var midi_out : MidiOutWeb= MidiOutWeb.new() # MIDI Out
		midi_in.midi_message.connect(received) # Callback on receive
		
		print(midi_in.get_port_names()) # List MIDI Ins
		print(midi_out.get_port_names()) # List MIDI Outs
		
		midi_in.open_port(0)
		# Open output port as well
		# midi_out.open_port(0)
		# print("Is output port open: ", midi_out.is_port_open())
		# midi_out.send_message([144, 80, 77])
	else:
		print("This can only be used in the Web export!")

func received(data):
	print("Received: ", data)
