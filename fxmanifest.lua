fx_version 'cerulean'
game 'gta5'

name 'nf-multicharacters'
description 'Multicharacters'
author 'nafing'
version '1.0.0'

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua'
}

-- ui_page 'http://localhost:5173/'

ui_page 'html/index.html'
files {
	'html/*.*',
	'html/**/*.*',
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'
