<!-- TODO: Add keybindings for easier editor/terminal switching -->

# VS Code Settings

> As a warning, these settings are the most volatile of my dotfiles, since I change my editor configuration almost daily. Often this is just switching themes, fonts, or turning extension settings on/off, but sometimes there may be unexpected breaking changes.

## Core Settings

These settings mostly cover editor behavior and general aesthetics, arranged (mostly) alphabetically. Many settings are tied either to extensions or other overrides, so it's worth going through these carefully if you're adopting them for yourself.

### Fonts & Typography

I have fonts I prefer listed here and grouped by whether or not they include support for ligatures, with all but the current active font commented out. This makes switching back and forth easier when I get tired of a given font's look. If you plan to use any of the fonts listed in the settings, make sure you either have them downloaded and configured locally and/or have proper licenses for using them.

### Intellisense & Autocomplete

Often I've experienced issues with accepting Intellisense suggestions with the <kbd>Enter</kbd>/<kbd>Tab</kbd> keys. The settings here, along with a couple custom keybindings, ensure behavior that's predictable, while also being compatible with the [TabOut](https://marketplace.visualstudio.com/items?itemName=albert.TabOut) extension.

### Color & Theme

I mainly switch between two themes: [In Bed By 7pm](https://marketplace.visualstudio.com/items?itemName=sdras.inbedby7pm) and [Everforest](https://marketplace.visualstudio.com/items?itemName=sainnhe.everforest), with the latter having a _ton_ of overrides I've set up to customize a lot of nuances in the editor, explorer, workbench, etc. Finding and customizing elements are often done with the CodeUI extension, then manually added here for a higher degree of control.

### Language Rules

Mostly self-explanatory; often these are just to specify the default formatter.

## Extension Settings

These are arranged alphabetically by Extension name, and are mostly self-explanatory. There are a few inactive or uninstalled extension settings here I keep for reference, or when I decide to toggle something on and off.

Note that the current list of extensions I use can also be found in [extensions.txt](extensions.txt), which thanks to a githook with Husky updates each time the repo is changed (see the script in this repo's package.json).
