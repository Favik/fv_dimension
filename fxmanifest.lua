fx_version 'bodacious'
game 'gta5'
author 'Favik - <favik@favik.cz>'
description 'fv_script template'

shared_script '@es_extended/imports.lua'

client_script {
    '@es_extended/locale.lua',
    'config.lua',
    'client/*.lua',
}

server_script {
    '@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'config.lua',
    'server/*.lua',
}

ui_page 'html/ui.html'

files {
    'html/css/*.css',
    'html/js/*.js',
	'html/*.html',
}
