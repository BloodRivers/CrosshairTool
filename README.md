# CrosshairTool for Godot 4

A customizable crosshair tool for Godot Engine 4 games with extensive configuration options and persistence.

## Features

- **Highly customizable** crosshair with multiple style options
- **Two main components**:
  - Adjustable crosshair lines (top, bottom, left, right)
  - Central dot with size control
- **Visual customization**:
  - Colors for both elements
  - Outline options for better visibility
  - Rounded or square styles
- **Automatic saving/loading** of configuration
- **Editor integration** with real-time preview

## Installation

1. Copy the `CrosshairTool.gd` script to your project
2. Add `CrosshairTool` node to your scene
3. You are all set!

## Configuration

All properties are exposed in the Godot editor inspector for easy adjustment.

### Line Settings
- **Show**: Toggle visibility of crosshair lines
- **Length**: Length of each crosshair line (0.5-20.0)
- **Thickness**: Width of lines (0.5-10.0)
- **Gap**: Distance from center (0.0-20.0)
- **Rounded**: Round the line ends
- **Corner Detail**: Quality of rounded corners (0-8)
- **Color**: Line color

#### Line Outline
- **Enabled**: Toggle line outlines
- **Thickness**: Outline thickness (0.5-2.0)

### Center Dot Settings
- **Show**: Toggle center dot visibility
- **Size**: Dot diameter (0.5-5.0)
- **Rounded**: Make dot circular (false for square)
- **Color**: Dot color

#### Dot Outline
- **Enabled**: Toggle dot outline
- **Thickness**: Outline thickness (0.5-2.0)

## Usage

### In-Game
The crosshair will automatically appear when added to your UI scene.

### Editor
- Changes in the inspector update the crosshair in real-time
- Configuration automatically saves when the scene is saved
- Click "Show Config" button to view the saved configuration file

## Persistence

Crosshair settings are automatically saved to:
`user://crosshair_config.json`

This ensures player preferences persist between game sessions.

## Customization Example

```gdscript
# To change crosshair properties programmatically:
$CrosshairTool.lines_color = Color.RED
$CrosshairTool.center_dot_show = false
$CrosshairTool.lines_length = 8.0
