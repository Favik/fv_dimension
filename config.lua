Config = {}

Config.ESXnotify = true                  -- If set to false mythic_notify is used for notifications and if set to true ESX notifications are used.

Config.UseItem  = false                  -- If set to false only the command can be used
Config.Item = 'dimension_tablet'         -- Item name (👆 Config.UseItem must be set to true)

Config.Animation = true                  -- Animation with tablet in hands

Config.Command = 'dimension'             -- Open menu | TriggerClientEvent("fv_dimension:menu")
Config.CommandCheck = 'dimensioncheck'   -- Check player current dimension id

Config.CreatePrice = 5000

Config.Locale = 'cs'                     -- Language settings / Translation
Locales['cs'] = {
    ['dim_create'] = 'Připojil jsi se do své dimenzi.',
    ['dim_connect'] = 'Připojil jsi se k dimenzi',
    ['dim_leave'] = 'Opustil jsi dimenzi',
    ['not_connect'] = 'Nejsi v žádné dimenzi',
    ['error'] = 'Něco jsi nejspíše nevyplnil.....',
    ['check_dimension'] = 'Dimension ID:',
    ['reset_dimension'] = 'Nastavena základní dimenze.',
    ['id_exist'] = 'Tohle ID je již obsazené...',
    ['wrong_pass'] = 'Špatné heslo k dimenzi.',
    ['in_dimension'] = 'Musíš prvně opustit aktuální dimenzi.',
    ['wrong_id'] = 'Špatné ID dimenze.',
    ['standard_dim'] = 'Nejsi připojen k žádné dimenzi.',
    ['dimension_owned'] = 'Již už máš jednu dimenzi vytvořenou..',
    ['dimension_null'] = 'ID musí být v rozmezí 1 - 1000..',
    ['restart'] = 'Restarting resource',
    ['no_money'] = 'Nedostatek peněz k vytvoření dimenze..'
}
