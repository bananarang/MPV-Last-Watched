require 'lua-table-persistence/persistence'
mputils = require 'mp.utils'
DATASTORE_FILENAME = ".LAST_WATCHED_MPV.MPVWTC"
datastore_input = persistence.load(DATASTORE_FILENAME) or {}
global_dir =  "./"
global_filename = ""

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
   update_current_database_object()
end

function update_current_database_object ()
   local stripped_str = strip_string(global_filename)
   print("Stripped str is " .. stripped_str)
   local number = get_numbers_from_str(stripped_str)
   local curr_percent_into = mp.get_property("percent-pos","")
   local curr_time_into = mp.get_property("time-pos","")

   local episode_name = get_non_numbers_from_str(stripped_str)

   local original_episode_map = {}
   if datastore_input[episode_name] ~= nil then
      original_episode_map = datastore_input[episode_name]["episode_map"]
   end

   datastore_input[episode_name]
      = { ["most_recent_opened_episode_number"] = number,
         ["current_time"] = curr_time_into,
         ["percent_completed"] = curr_percent_into,
         ["episode_map"] = original_episode_map
        }
   datastore_input[episode_name]["episode_map"][number] = curr_percent_into .. "%"
end

function save_file_handler (event)
   write_data_file(datastore_input,global_dir,DATASTORE_FILENAME)
end

--datastore_input.gundam = datastore_input.gundam+1

mp.register_event("file-loaded", load_file_handler)
mp.register_event("shutdown", save_file_handler)




--String manipulation functions

function strip_string (str)
   -- Remove extension first
   str = str:gsub("%.([%w%-]+)$", "")
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
