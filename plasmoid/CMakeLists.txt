install(DIRECTORY contents
        DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/playbar )

install(FILES metadata.desktop
        DESTINATION ${DATA_INSTALL_DIR}/plasma/plasmoids/playbar/ )

install(FILES metadata.desktop
        DESTINATION ${KDE4_SERVICES_INSTALL_DIR}
        RENAME plasma-applet-playbar.desktop )
set(locale_dirs 
    locale/es 
    locale/ru
)

install(DIRECTORY ${locale_dirs}
        DESTINATION ${KDE4_LOCALE_INSTALL_DIR}
        FILES_MATCHING PATTERN "*.mo"
        )
