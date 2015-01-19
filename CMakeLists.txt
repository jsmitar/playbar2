project(PlayBar)

find_package(KDE4 REQUIRED)

include(KDE4Defaults)

add_subdirectory( plasmoid )
add_subdirectory( engine )

execute_process(COMMAND ./messages.sh -compile-po
	OUTPUT_VARIABLE out_messages
	WORKING_DIRECTORY ${CMAKE_HOME_DIRECTORY})

message(${out_messages})

#This is not yet implemented
#add_subdirectory( kcm_shortcuts )

