fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Error420 Developments'
description 'QBCore Butcher Job - Error420 Developments'

client_script {
    'client/*.lua',
    'shared/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
	'shared/*.lua',
    '@ox_lib/init.lua'
}

dependencies {
    'qb-core',
    'ox_lib'
}