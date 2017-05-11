colors = require 'colors'

initCommands = (program)->

	program
		.command('cyta')
		.description('CYTA Telephone Network related utilities')
		.option('--show-sum', 'Show amount due')
		.action (options) ->

			CYTA = require('./cyta')

			Helpers.configurator().then((res)->

				Helpers.loadConfig({ config: "cyta" })

				if options.showSum
					CYTA.showSum({

				      username : config.cyta.username
				      password : config.cyta.password

					}).then(console.log).catch(console.log)

			)

module.exports = initCommands