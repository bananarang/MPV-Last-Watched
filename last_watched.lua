mputils = require 'mp.utils'
test_file = { gundam = 1, breaking_bad = 2 }
DATASTORE_FILENAME = "LAST_WATCHED_MPV"
datastore_input = dofile(DATASTORE_FILENAME) or {}
global_dir =  "./"
global_filename = ""
print("Hello World!!!")

function simple_print_table(table)
   for key,value in pairs(table) do
      print(key," ",value)
   end
end



function write_data_file(table,path,filename)
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

function load_file_handler (event)
   print("File loaded!!!!!")

   local path = mp.get_property("path", "")
   local dir, filename = mputils.split_path(path)
   if global_dir == "." then
      global_dir = "./"
   end
   if dir == "." then
      dir = "./"
   end
   if dir ~= global_dir then
      save_file_handler({})
      global_filename = filename
      global_dir = dir
      
      print(global_dir..DATASTORE_FILENAME)
      tempfile = loadfile(global_dir..DATASTORE_FILENAME)
      datastore_input = {}
      if tempfile then
         datastore_input = tempfile()
      end
   end
   datastore_input[global_filename] = 0
end

function save_file_handler (event)
   write_data_file(datastore_input,global_dir,DATASTORE_FILENAME)
end

datastore_input.gundam = datastore_input.gundam+1

mp.register_event("file-loaded", load_file_handler)
mp.register_event("shutdown", save_file_handler)
