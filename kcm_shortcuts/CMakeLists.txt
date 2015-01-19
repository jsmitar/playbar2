project(kcm_playbarshortcuts)

find_package(KDE4 REQUIRED)

include(KDE4Defaults)
include(MacroLibrary)

include_directories( ${KDE4_INCLUDES} ${QT_INCLUDES} )

add_subdirectory( src )
