project(PlayBarEngine)

set(CMAKE_CXX_STANDARD 14)

add_definitions(-DTRANSLATION_DOMAIN=\"plasma_engine_playbar\")
add_definitions(-DQT_USE_FAST_CONCATENATION -DQT_USE_FAST_OPERATOR_PLUS)

set(playbar_engine_SRCS
    configdialog.cpp
    generalwidget.cpp
    playbar.cpp
    playbarengine.cpp
    playbarjob.cpp
    playbarservice.cpp
)

kconfig_add_kcfg_files(playbar_engine_SRCS playbarsettings.kcfgc)
ki18n_wrap_ui(playbar_engine_SRCS generalconfig.ui)
add_library(plasma_engine_playbar MODULE ${playbar_engine_SRCS})
kcoreaddons_desktop_to_json(plasma_engine_playbar plasma-dataengine-playbar.desktop)

target_link_libraries(plasma_engine_playbar
    KF5::ConfigCore
    KF5::ConfigGui
    KF5::ConfigWidgets
    KF5::GlobalAccel
    KF5::I18n
    KF5::Plasma
    KF5::WindowSystem
    KF5::XmlGui
)

install(TARGETS plasma_engine_playbar
		DESTINATION ${KDE_INSTALL_PLUGINDIR}/plasma/dataengine)

install(FILES plasma-dataengine-playbar.desktop
		DESTINATION ${KDE_INSTALL_KSERVICES5DIR})

install(FILES audoban.engine.playbar.operations
		DESTINATION ${PLASMA_DATA_INSTALL_DIR}/services)

install(FILES playbar.kcfg
        DESTINATION ${KCFG_INSTALL_DIR})


