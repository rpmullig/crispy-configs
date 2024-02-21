# Neovim Configuration

## Explanation of structure

This uses the easy to use programming language of lua to setup neovim.
- `init.lua` is the main folder, think of it as index.html
    - this currently just has one line `require("theprimagean")` which is found in `./lua/theprimeagen/`
- `/lua/` is the dir that lua looks to next as required, and contains theprimeagen dir
- `/after/plugin` is all the remappings for the plugins for use in neovim
- `/plugin/` is the location where Mason compiles the neovim plugins
- `/lua/theprimeagen/` has all the main code for the Configuration
    - `init.lua` another "index" file, mainly points to `./set.lua` and `./remap.lua`
    - `set.lua` small configurations for curser and tabs
    - `remap.lua` all the main remaps for non-plugins, to help use vim better
    - `packer.lua` this has all the plugins and you can call `:MasonSync` to install plugins.
        - To add/remove plugins, you'd do them here.
        - These are the plugins that are remapped in the `./after/plugin/*` dir
