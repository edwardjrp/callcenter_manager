fs = require 'fs'
coffee = require('coffee-script')
dist_root = "#{__dirname}/dst"
src_root = "#{__dirname}/src"


recursive_compile_file = (dir_to_build, destination_build)->
  files = fs.readdirSync dir_to_build
  for file in files
    if fs.existsSync("#{dir_to_build}/#{file}")
      if fs.statSync("#{dir_to_build}/#{file}").isDirectory() == true
        fs.mkdirSync("#{destination_build}/#{file}") unless fs.existsSync("#{destination_build}/#{file}")
        current_dir_to_build = "#{dir_to_build}/#{file}"
        recursive_compile_file(current_dir_to_build, "#{destination_build}/#{file}")
      else
        if file.match(/.coffee$/)
          if fs.existsSync("#{dir_to_build}/#{file}")
            try
              appsrc = coffee.compile(fs.readFileSync("#{dir_to_build}/#{file}").toString('utf-8'), { bare: true })
              fs.writeFileSync("#{destination_build}/#{file.replace(/.coffee$/, '.js')}", appsrc)
            catch error
              console.error "cant compile #{file} error : #{error}"
          else
            console.log "#{dir_to_build}/#{file} does not exists"
        else
          console.log "#{dir_to_build}/#{file} does not seems to be a source file"
    else
      console.log "#{dir_to_build}#{file} does not exists"
      
      
recursive_compile_file(src_root, dist_root)