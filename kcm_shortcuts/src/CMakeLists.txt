# In this CMakeLists.txt we define which files
# are used to compile the application
set(kcm_playbarshortcuts_SRCS
   kcm_playbarshortcuts.cpp
   mprisservice.cpp
 )

# Set the name of the application
kde4_add_executable(kcm_playbarshortcuts ${kcm_playbarshortcuts_SRCS})

# Added plugin
kde4_add_plugin(kcm_playbarshortcuts ${playbarshortcuts_SRCS} ${KDE4_MODULE_DIR})

# Select which libraries we need to link to
target_link_libraries(kcm_playbarshortcuts ${KDE4_KDEUI_LIBS} ${KDE4_PLASMA_LIBS})

# Tell cmake to install the application binary library
install(TARGETS kcm_playbarshortcuts DESTINATION ${PLUGIN_INSTALL_DIR} )

# Install the .desktop file
install( PROGRAMS kcm_playbarshortcuts.desktop DESTINATION ${KDE4_SERVICES_INSTALL_DIR} )
