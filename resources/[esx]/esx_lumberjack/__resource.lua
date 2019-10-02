resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Lumberjack'

version '1.0.0'

server_scripts {
	'@es_extended/locale.lua',
	'locales/es.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/es.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'esx_addonaccount',
	'skinchanger',
	'esx_skin'
}