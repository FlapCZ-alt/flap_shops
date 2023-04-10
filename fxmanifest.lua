--------------------------------------------------
------------- JOIN OUR DISCORD SERVER ------------
--------- https://discord.gg/7gbCD9Fzct ----------
--------------------------------------------------
--------------- DEVELOPED BY FLAP ----------------
-------------------- WITH 💜 ---------------------
--------------------------------------------------


fx_version 'adamant'
game 'gta5'

description 'Shop system'
version '1.0.0'
author 'Flap'
lua54 'yes'

ui_page "client/ui/html.html"

shared_scripts {
	'@es_extended/imports.lua',
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'config/*.lua',
	'server/*.lua'
}

files {
    "client/ui/html.html",
    "client/ui/css.css",
    "client/ui/js.js"
}

escrow_ignore {
	'client/*.lua',
	'config/*.lua',
	'server/*.lua',
	"client/ui/html.html",
    "client/ui/css.css",
    "client/ui/js.js"
}

dependency 'es_extended'
