require! \caman
Caman = caman.Caman

module.exports =
  apply: (server) ->
    server.get '/', (req, res, next) ->
      res.send 200 "Hello here are the usage: \n
      POST /enhanceImage/:receipe?src=<fileOnCurrentServer>&dest=<optional> \n
      receipe : clear,xyz"
      next!

    server.get '/echo/:name', (req, res, next) ->
      res.send req.params
      next!
    
    server.post '/enhanceImage/:receipe', (req, res, next) ->
      console.log req.params

      src = req.params['src'];

      if !src
        res.send 400 "please provide src param"
        return next!

      console.log "src file" src
      
      dest = req.params['dest'];      
      if !dest
        l = src.split(".")
        dest = l[0]+"_mod."+ l[1]; 

      console.log "dest file" dest  
      
      Caman src, -> 
        this.brightness(10);
        this.contrast(30);
        this.sepia(60);
        this.saturation(-30);
    
        this.render  -> 
          this.save dest
          res.send "modified file at "+ dest
          return next!    

      

      

