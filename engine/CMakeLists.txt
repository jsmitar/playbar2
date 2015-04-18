project(PlayBarEngine)

set(playbar_engine_SRCS
	configdialog.cpp
	generalwidget.cpp
	playbar.cpp
	playbarengine.cpp
	playbarjob.cpp
	playbarservice.cpp
	)

ki18n_wrap_ui( playbar_engine_SRCS generalconfig.ui )
kconfig_add_kcfg_files( playbar_engine_SRCS playbarsettings.kcfgc )
add_library( plasma_engine_playbar MODULE ${playbar_engine_SRCS} )
kcoreaddons_desktop_to_json( plasma_engine_playbar plasma-dataengine-playbar.desktop )

target_link_libraries( plasma_engine_playbar
	KF5::Plasma
	KF5::PlasmaQuick
	KF5::ConfigWidgets
	KF5::ConfigGui
	KF5::ConfigCore
	KF5::WindowSystem
	KF5::XmlGui
	KF5::GlobalAccel
	KF5::I18n
)

install(TARGETS plasma_engine_playbar
		DESTINATION ${KDE_INSTALL_LIBDIR}/qt5/plugins/plasma/dataengine)

install(FILES plasma-dataengine-playbar.desktop
		DESTINATION ${KDE_INSTALL_KSERVICES5DIR})

install(FILES audoban.dataengine.playbar.operations
		DESTINATION ${PLASMA_DATA_INSTALL_DIR}/services)

install(FILES playbar.kcfg DESTINATION ${KCFG_INSTALL_DIR})

