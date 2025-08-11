# MIDI Web - Godot Plugin

A Godot 4.x plugin that enables MIDI functionality for web exports by automatically including `midi.js` in your HTML5 builds.

## rtmidi Compatibility

This plugin is a one-to-one implementation of [rtmidi](https://github.com/thestk/rtmidi) for MIDI on the web.
If you are using Godot's [rtmidi](https://github.com/NullMember/godot-rtmidi) for your desktop exports, it should work by simply instancing the corresponding class (e.g., `MidiInWeb` or `MidiOutWeb`) in your Godot project.
Check the documentation of rtmidi here:  
https://caml.music.mcgill.ca/~gary/rtmidi/

## Features

- 🎹 **MIDI Input/Output Support**: Handle MIDI devices in web browsers
- 🚀 **Automatic Integration**: Seamlessly integrates `midi.js` into your web exports
- 🔧 **Easy Setup**: Simple plugin installation and configuration
- 🌐 **Web Compatible**: Works with Godot's HTML5 export platform

## Installation

### Install via AssetLib

1. Search for "MIDILLI MIDI Web" in the AssetLib.
2. Download and install the plugin.
3. Then continue with step 2 below.

### Manual Installation

1. Copy the `addons/midiweb` folder to your Godot project's `addons` directory.
2. Enable the plugin in Project Settings → Plugins → "MIDILLI MIDI Web".
3. The plugin will automatically add MIDI support to your web exports.

## How It Works

The plugin uses an `EditorExportPlugin` that:
- Detects when you're exporting to the web platform
- Automatically includes `midi.js` in the HTML head section
- Copies the `midi.js` file to your export directory

## Quick Usage

1. **Install and Enable Plugin**: Install via AssetLib or manually copy `addons/midiweb`, then enable "MIDILLI MIDI Web" in Project Settings → Plugins.
2. **Select Example Scene**: Set `example.tscn` as your main scene in Project Settings → Application → Run → Main Scene (or right-click on the file and set as main scene).
3. **Export to Web**: Export your project to the HTML5 platform.
4. **Connect a MIDI Device**: Plug in your MIDI device and open the exported project in a supported browser.
5. **View Incoming Messages**: All incoming MIDI messages will be shown in the browser's Inspector/Console (open with Ctrl+F11).

<img width="1512" height="412" alt="image" src="https://github.com/user-attachments/assets/e4c67aeb-ac72-4e92-b03a-0974ba81b9cb" />
Screenshot of example application.

## Usage

### Init MIDI on Godot:

```gdscript
# Connect midi.js with Godot via JavaScriptBridge.
JavaScriptBridge.eval("MIDIEngine.init().then(() => { console.log('MIDI Ready!'); });")
```

### MIDI Input
```gdscript
# Use the provided MIDI input class
var midi_in : MidiInWeb = MidiInWeb.new() # MIDI In
```

### MIDI Output
```gdscript
# Use the provided MIDI output class
var midi_out : MidiOutWeb= MidiOutWeb.new() # MIDI Out
```

## Files Included

- `midi_in.gd` - MIDI input handling
- `midi_out.gd` - MIDI output handling
- `midi.js` - JavaScript MIDI library
- `example.gd` & `example.tscn` - Usage examples

## Requirements

- Godot 4.x
- Web export platform
- Modern web browser with MIDI support

## Notes

- Checking whether the project is running on "Web" must be done manually. This can simply be done via `if OS.get_name() == "Web":`

## Browser Compatibility

This plugin works with browsers that support the Web MIDI API:
- Chrome/Chromium-based browsers
- Edge
- Opera

Check support status here: [https://caniuse.com/midi](https://caniuse.com/midi)

## Development

**Author**: [MIDILLI Tech](https://midilli.tech)
**Version**: 1.0  
**License**: Apache 2.0

## Known Issues

* ``ignore_types(sysex: bool, time: bool, sense: bool)`` -> not supported. All messages are enabled.


## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this plugin.

## Support

For questions or support, please create an issue in this repository.

---

*This plugin makes MIDI integration with Godot web exports simple and automatic!*
