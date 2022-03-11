library_path <- paste("Library Path: ", Sys.getenv(c("LD_LIBRARY_PATH")))
print(paste("LD_LIBRARY_PATH: ", library_path))

lib_dir <- '/home/vcap/deps/0/r/lib'
local_lib_dir <- 'lib'
local_share_dir <- 'share'

if(dir.exists(lib_dir))
{
	if(dir.exists(local_lib_dir))
	{
		# Get the list of libs
		lib_tars <- list.files(local_lib_dir)
		lib_tars <- paste(local_lib_dir, lib_tars, sep="/")

		print(paste("Local libs: ", lib_tars))
		print(paste("Working directory: ", list.files(getwd())))

		# Copy the files to the lib_dir
		for(i in 1:length(lib_tars)) {untar(lib_tars[i], exdir = lib_dir)}
	}

	if(dir.exists(local_share_dir))
	{
		share_files <- list.files(local_share_dir)

		# Copy the files to the lib_dir
		for(i in 1:length(share_files))
			{
				file.rename(from = paste(local_share_dir, share_files[i], sep="/"), to = paste(lib_dir, share_files[i], sep="/"))
			}
			Sys.setenv(PROJ_LIB=lib_dir)
	}
}

print(list.files(lib_dir))

library(shiny)

runApp(host="0.0.0.0", port=strtoi(Sys.getenv("PORT")))
