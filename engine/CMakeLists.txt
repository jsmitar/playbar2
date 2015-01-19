project(PlayBarEngine)

find_package(KDE4 REQUIRED)
#find_package(Taglib 1.8)

include(KDE4Defaults)
include(MacroLibrary)

add_definitions (${QT_DEFINITIONS} ${KDE4_DEFINITIONS})
include_directories(
   ${CMAKE_SOURCE_DIR}
   ${CMAKE_BINARY_DIR}
   ${KDE4_INCLUDES}
   ${QT_INCLUDES}
#   ${TAGLIB_INCLUDES}
   )

# We add our source code here
set(playbar_engine_SRCS shortcuts.cpp service.cpp playbarengine.cpp)

# Now make sure all files get to the right place
kde4_add_plugin(plasma_engine_playbar ${playbar_engine_SRCS})

target_link_libraries(plasma_engine_playbar
                      ${KDE4_KDECORE_LIBS}
                      ${KDE4_PLASMA_LIBS}
                      #${TAGLIBS}
                      )

install(TARGETS plasma_engine_playbar
        DESTINATION ${PLUGIN_INSTALL_DIR})

install(FILES plasma-engine-playbar.desktop
        DESTINATION ${SERVICES_INSTALL_DIR})

install(FILES playbarservice.operations
        DESTINATION ${DATA_INSTALL_DIR}/plasma/services)
