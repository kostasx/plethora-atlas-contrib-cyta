request = require 'request'
cheerio = require 'cheerio'

CYTA =

  showSum: (options)->

    new Promise((resolve,reject)->

      # Let's build a callback hell pyramid, shall we?
      req = request.defaults(
        jar                : true
        rejectUnauthorized : false 
        followAllRedirects : true   
      )

      username  = options.username
      password  = options.password
      userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'

      req.get({
        url     : "https://my.cyta.gr/",
        headers : { 'User-Agent': userAgent }
        }, (err, res, body)->
        
        req.post({
        
          headers : { 'User-Agent': userAgent, 'content-type' : 'application/x-www-form-urlencoded' }
          url     : 'https://my.cyta.gr/'
          form  : { username: username, password: password }
        
        }, (err, res, body)->
        
          req.get({
          
            url     : 'https://my.cyta.gr/index.php?id=22&tab=1'
            headers : { 'User-Agent': userAgent }
          
          }, (err, res, body)->

            $ = cheerio.load(body)
            tabUrl = $("#"+$("[id^=tab0]").attr("id")).attr("href")
            req.get({

              url     : tabUrl
              headers : { 'User-Agent': userAgent }

            }, (err, res, body)->

              if err then return console.log "Error:", err

              $             = cheerio.load(body)
              $tableTR      = $("table").eq(0).find("tr")
              tableTRLength = $tableTR.length 
              lastTr        = $tableTR[tableTRLength-1]
              total         = $(lastTr).find("td").eq(0).text() # Σύνολο Οφειλών:
              totalSum      = $(lastTr).find("td").eq(1).text() # 0
              resolve({ msg: total.trim() + totalSum.trim(), sum: totalSum.trim() }) 

            )

          )

        )

      )

    )

module.exports = CYTA