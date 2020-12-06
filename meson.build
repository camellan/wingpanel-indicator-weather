project('com.github.camellan.weatherindicator', 'vala', 'c',version: '1.0.0')

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)
wingpanel_dep = dependency('wingpanel-2.0')

shared_module(
    meson.project_name(),
    'src/Indicator.vala',
    'src/Widgets/DisplayWidget.vala',
    'src/lib/Weather.vala',
    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        wingpanel_dep
    ],
    install: true,
    install_dir : wingpanel_dep.get_pkgconfig_variable('indicatorsdir')
)

subdir('po')
