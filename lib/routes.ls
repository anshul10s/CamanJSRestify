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
      filter = req.params['filter'];

      if !src
        res.send 400 "please provide src param"
        return next!

      console.log 'filter from req' filter

      if !(filter is 'clarity' or filter is 'sunlight')
        res.send 400 "please provide valid filter, currently supported ones are clarity & sunlight"
        return next!

      console.log "src file" src
      
      dest = req.params['dest'];      
      if !dest
        l = src.split(".")
        dest = l[0]+"_mod1"+filter+"."+ l[1]; 

      console.log "dest file" dest  
      console.log "filter" filter      
      
      Caman src, -> 
        if filter == 'clarity'
         this.curves('rgb', [5, 0], [130, 150], [190, 220], [250, 255]);         
         this.vibrance(20);
         this.sharpen(15);
         this.vignette('45%',20);
        else if filter == 'sunlight'
         @brightness 10
         @newLayer (->
           @setBlendingMode 'multiply'
           @opacity 80
           @copyParent!
           @filter.gamma 0.8
           @filter.contrast 50
           @filter.exposure 10)
         @newLayer (->
           @setBlendingMode 'softLight'
           @opacity 80
           @fillColor '#f49600')
         @exposure 10
         @gamma 0.8
        else
         console.log('no filter passed');
 
        this.render  -> 
          this.save dest
          res.send "modified file at "+ dest
          return next!    

