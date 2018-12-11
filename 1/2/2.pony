use "files"
use "collections"
use "debug"
use "itertools"
actor Main
  new create(env: Env) =>
    let n = 
    try 
      env.args(1)? 
    else 
      env.out.print("Not enough arguments")
      return
     end
     env.out.print(FrequencyCounter(n,env).find_repeating_frequency().string())

class FrequencyCounter

  let fileContent: List[I32]
  new create(path:String, env:Env)=>
      fileContent = List[I32]()
      let capabilities = recover val FileCaps.>set(FileRead).>set(FileStat) end
      try
        with file = OpenFile(
          FilePath(env.root as AmbientAuth, path, capabilities)?) as File
        do
          for line in file.lines() do
            fileContent.push(parse_int(consume line)?)
            

          end
        end
      else
        env.out.print("Couldn't find file: "+path)
      end

  fun find_repeating_frequency():I32=>
    var counter:I32=0
    let seenFrequencies: Set[I32]=Set[I32]()
    for elem in Iter[I32](fileContent.values()).cycle() do
      counter = counter + elem 
      if seenFrequencies.contains(counter) then
              return counter
            else
              seenFrequencies.set(counter)
      end

    end
  counter

  fun parse_int(s:String iso):I32?=>
    s.lstrip("+")
    s.i32()?
