/*
Apache License 2.0

Copyright 2024-2025 MIDILLI Tech

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/**
 * MIDIEngine is a singleton object that provides an interface for interacting with the Web MIDI API.
 * It allows initialization of MIDI access, enumeration of input/output ports, opening/closing ports,
 * sending MIDI messages, and handling incoming MIDI messages via a callback.
 *
 * @namespace MIDIEngine
 *
 * @property {function(): Promise<void>} init
 *   Initializes MIDI access and populates input/output port lists.
 *   @returns {Promise<void>} Resolves when MIDI access is granted or logs error if denied.
 *
 * @property {function(): void} refresh_devices
 *   Refreshes the list of available MIDI input and output devices.
 *
 * @property {function(): number} get_input_port_count
 *   Returns the number of available MIDI input ports.
 *   @returns {number}
 *
 * @property {function(number): string} get_input_port_name
 *   Returns the name of the MIDI input port at the specified index.
 *   @param {number} index - Index of the input port.
 *   @returns {string}
 *
 * @property {function(): string} get_input_port_names
 *   Returns a JSON string array of all MIDI input port names.
 *   @returns {string}
 *
 * @property {function(number): void} open_input_port
 *   Opens the MIDI input port at the specified index and assigns a message callback.
 *   @param {number} index - Index of the input port to open.
 *
 * @property {function(): void} close_input_port
 *   Closes the currently open MIDI input port.
 *
 * @property {function(number): boolean} is_input_port_open
 *   Checks if the MIDI input port at the specified index is connected.
 *   @param {number} index - Index of the input port.
 *   @returns {boolean}
 *
 * @property {function(): number} get_output_port_count
 *   Returns the number of available MIDI output ports.
 *   @returns {number}
 *
 * @property {function(number): string} get_output_port_name
 *   Returns the name of the MIDI output port at the specified index.
 *   @param {number} index - Index of the output port.
 *   @returns {string}
 *
 * @property {function(): string} get_output_port_names
 *   Returns a JSON string array of all MIDI output port names.
 *   @returns {string}
 *
 * @property {function(number): void} open_output_port
 *   Opens the MIDI output port at the specified index.
 *   @param {number} index - Index of the output port to open.
 *
 * @property {function(): void} close_output_port
 *   Closes the currently open MIDI output port.
 *
 * @property {function(number): boolean} is_output_port_open
 *   Checks if the MIDI output port at the specified index is connected.
 *   @param {number} index - Index of the output port.
 *   @returns {boolean}
 *
 * @property {function(Array<number>): void} send_message
 *   Sends a MIDI message (array of bytes) to the currently open output port.
 *   @param {Array<number>} dataArray - MIDI message bytes to send.
 *
 * @example
 * await MIDIEngine.init();
 * const inputNames = JSON.parse(MIDIEngine.get_input_port_names());
 * MIDIEngine.open_input_port(0);
 * MIDIEngine.send_message([144, 60, 127]); // Note on, middle C, velocity 127
 */
var MIDIEngine = (function () {
  let midiAccess = null;
  let midiInputs = [];
  let midiOutputs = [];
  let currentInput = null;
  let currentOutput = null;

  function init() {
    return navigator.requestMIDIAccess({ sysex: true }).then((access) => {
      console.log("✅ MIDI access granted");
      midiAccess = access;
      midiInputs = Array.from(midiAccess.inputs.values());
      midiOutputs = Array.from(midiAccess.outputs.values());
      console.log("🎹 Inputs:", midiInputs.map(i => i.name));
      console.log("📤 Outputs:", midiOutputs.map(o => o.name));
    }, (err) => {
      console.error("❌ MIDI access DENIED:", err);
    });
  }

  // Refreshes the list of MIDI input and output devices
  function refresh_devices() {
    if (midiAccess) {
      midiInputs = Array.from(midiAccess.inputs.values());
      midiOutputs = Array.from(midiAccess.outputs.values());
      console.log("🔄 Devices refreshed.");
      console.log("🎹 Inputs:", midiInputs.map(i => i.name));
      console.log("📤 Outputs:", midiOutputs.map(o => o.name));
    } else {
      console.warn("MIDI access not initialized. Call init() first.");
    }
  }

  // INPUT FUNCTIONS
  
  function get_input_port_count() {
    return midiInputs.length;
  }

  function get_input_port_name(index) {
    return midiInputs[index]?.name || "";
  }

  function get_input_port_names() {
    return JSON.stringify(midiInputs.map((input) => input.name));
  }

  function open_input_port(index) {
    currentInput = midiInputs[index] || null;
    if (currentInput) {
      console.log("📤 Assigned callback");

      currentInput.onmidimessage = (event) => {
        // const dataArray = Array.from(event.data);  // e.g.: [176, 15, 0]

        // console.log("🎵 Incoming MIDI:", dataArray);

        if (typeof window._midi_callback === "function") {
          // Send to Callback as JSON string
          window._midi_callback(JSON.stringify({
            index: index,
            data: Array.from(event.data)
          }));
        } else {
          console.warn("❗️ _midi_callback function is not defined!");
        }
      };
    }
  }

  function close_input_port() {
    if (currentInput) {
      currentInput.onmidimessage = null;
      currentInput = null;
    }
  }

  // OUTPUT FUNCTIONS
  function get_output_port_count() {
    return midiOutputs.length;
  }

  function get_output_port_name(index) {
    return midiOutputs[index]?.name || "";
  }

  function get_output_port_names() {
    return JSON.stringify(midiOutputs.map((output) => output.name));
  }

  function open_output_port(index) {
    currentOutput = midiOutputs[index] || null;
  }

  function close_output_port() {
    currentOutput = null;
  }

  function is_input_port_open(index) {
    if (midiInputs[index]) {
  	  return midiInputs[index].state === "connected";
    }
    return false;
  }
  
  function is_output_port_open(index) {
    if (midiOutputs[index]) {
  	  return midiOutputs[index].state === "connected";
    }
    return false;
  }

  function send_message(dataArray) {
    if (currentOutput && typeof currentOutput.send === 'function') {
      currentOutput.send(dataArray);
    } else {
      console.log("Output port is not open or not valid.");
    }
  }

  // Deinitialize MIDI: close ports and release references
  // Need to init() again to reinitialize MIDI access
  function deinit() {
    close_input_port();
    close_output_port();
    midiInputs = [];
    midiOutputs = [];
    midiAccess = null;
    console.log("🛑 MIDI deinitialized and devices released.");
  }

  return {
    // Input
    init,
    get_input_port_count,
    get_input_port_name,
    get_input_port_names,
    open_input_port,
    is_input_port_open,
    close_input_port,
    // Output
    get_output_port_count,
    get_output_port_name,
    get_output_port_names,
    open_output_port,
    close_output_port,
    is_output_port_open,
    send_message,
    // refresh_devices
    refresh_devices,
    // Deinitialize
    deinit
  };
})();
