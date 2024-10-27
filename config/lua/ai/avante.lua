require('avante_lib').load()
local keymaps = require('editor/keymappings')
local avante = require('avante')

avante.setup({})

keymaps.ai_complete(function() avante.get_suggestion() end)
