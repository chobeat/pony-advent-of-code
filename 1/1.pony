use "files"
actor Main
  new create(env: Env) =>
    let n = 
    try 
      env.args(1)? 
    else 
      env.out.print("Not enough arguments")
      return
     end
     env.out.print(FrequencyCounter(n,env).get_final_frequency().string())

class FrequencyCounter
  var counter:I32
  new create(path:String, env:Env)=>
      counter=0
      let capabilities = recover val FileCaps.>set(FileRead).>set(FileStat) end
      try
        with file = OpenFile(
          FilePath(env.root as AmbientAuth, path, capabilities)?) as File
        do
          for line in file.lines() do
            counter=counter+this.parse_int(consume line)?

          end
        end
      else
        env.out.print("Couldn't find file: "+path)
      end
  fun get_final_frequency():I32=>
     counter

  fun parse_int(s:String iso):I32?=>
    s.lstrip("+")
    s.i32()?