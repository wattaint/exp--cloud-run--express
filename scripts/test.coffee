axios = require 'axios'

authen = ->
  false
  #https://stackoverflow.com/questions/55205823/postman-and-google-service-account-how-to-authorize

main = ->
  { data } = await axios {
    url: 'https://exp-cloud-run--express-tyk25nmqfq-uc.a.run.app'
    method: 'get'
  }

  console.log data
 
main()