mputils = require 'mp.utils'
test_file = { gundam = 1, breaking_bad = 2 }
LAST_WATCHED_FILENAME = "LAST_WATCHED_MPV"
last_watched_input = dofile(LAST_WATCHED_FILENAME) or {}
last_watched_dir =  "./"
last_watched_filename = ""
print("Hello World!!!")

function simple_print_table(table)
   for key,value in pairs(table) do
      print(key," ",value)
   end
end



function last_watched_write_data_file(table,path,filename)
   -- Writes the table to file
   -- Doesn't do nested table
   -- Only supporst writing one table to the file, that table is then returned
   io.output(path..filename)
   io.write("\n")
   io.write("return ")
   io.write("\n")
   io.write("{")
   io.write("\n")
   first = true
      for key, value in pairs(table) do
         if not first then
            io.write(" , ")
            io.write("\n")
         end
         first = false
         io.write("[\""..key.."\"]")
         io.write( " = " )
         
         io.write(value)
         io.write("\n")

      end
      io.write("}")
      io.write("\n")
end

function last_watched_load_file_handler (event)
   print("File loaded!!!!!")

   local path = mp.get_property("path", "")
   local dir, filename = mputils.split_path(path)
   if last_watched_dir == "." then
      last_watched_dir = "./"
   end
   if dir == "." then
      dir = "./"
   end
   if dir ~= last_watched_dir then
      last_watched_save_file({})
      last_watched_filename = filename
      last_watched_dir = dir
      
      print(last_watched_dir..LAST_WATCHED_FILENAME)
      tempfile = loadfile(last_watched_dir..LAST_WATCHED_FILENAME)
      last_watched_input = {}
      if tempfile then
         last_watched_input = tempfile()
      end
   end
   last_watched_input[last_watched_filename] = 0
end

function last_watched_save_file (event)
   last_watched_write_data_file(last_watched_input,last_watched_dir,LAST_WATCHED_FILENAME)
end

last_watched_input.gundam = last_watched_input.gundam+1

mp.register_event("file-loaded", last_watched_load_file_handler)
mp.register_event("shutdown", last_watched_save_file)
