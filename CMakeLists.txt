project(PlayBar)

find_package(KF5 REQUIRED)

include(KDEInstallDirs)

add_subdirectory( engine )
add_subdirectory( kcm_shortcuts )

execute_process(COMMAND ./messages.sh -compile-po
	OUTPUT_VARIABLE out_messages
	WORKING_DIRECTORY ${CMAKE_HOME_DIRECTORY})

message(${out_messages})

plasma_install_packages(plasmoid audoban.applet.playbar)
