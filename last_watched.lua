require 'lua-table-persistence/persistence'
mputils = require 'mp.utils'
test_file = { gundam = 1, breaking_bad = 2 }
DATASTORE_FILENAME = "LAST_WATCHED_MPV"
datastore_input = persistence.load(DATASTORE_FILENAME) or {}
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
   print("SAVING " .. path..filename)
   persistence.store(path..filename,table)
end

function load_file_handler (event)
   print("File loaded!!!!!")

   local path = mp.get_property("path", "")
   local dir, filename = mputils.split_path(path)
   print("filename is " .. filename)
   if global_dir == "." then
      global_dir = "./"
   end
   if dir == "." then
      dir = "./"
   end
   global_filename = filename
   if dir ~= global_dir then
      save_file_handler({})
      global_dir = dir
      
      print(global_dir..DATASTORE_FILENAME)
      tempfile = persistence.load(global_dir..DATASTORE_FILENAME)
      datastore_input = {}
      if tempfile then
         datastore_input = tempfile
      end
   end
    print("Global filename is "..global_filename)
   local stripped_str = strip_string(global_filename)
   print("Stripped str is"..stripped_str.."fin")
   datastore_input[get_non_numbers_from_str(stripped_str)] = get_numbers_from_str(stripped_str)
end

function save_file_handler (event)
   write_data_file(datastore_input,global_dir,DATASTORE_FILENAME)
end

--datastore_input.gundam = datastore_input.gundam+1

mp.register_event("file-loaded", load_file_handler)
mp.register_event("shutdown", save_file_handler)




--String manipulation functions

function strip_string (str)
-- Strip string of any ",', \ and remove any text inside (,[,{,,< limiters.
	str = (str:gsub("[[{<]","("))
	str = (str:gsub("[]}>]",")"))
	str = str:gsub('%b()', '')
	return str
end

function get_numbers_from_str (str)
	return (str:gsub("%D",""))
end

function get_non_numbers_from_str (str)
	return (str:gsub("%d",""))
end
