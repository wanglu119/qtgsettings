import qbs 1.0
import qbs.Probes
import LiriUtils

LiriModuleProject {
    id: root

    name: "Qt5GSettings"
    moduleName: "Qt5GSettings"
    description: "Qt-style wrapper for GSettings"

    resolvedProperties: ({
        Depends: [{ name: LiriUtils.quote("Qt.core") },
                  { name: LiriUtils.quote("glib.gio") },
                  { name: LiriUtils.quote("glib.gobject") }],
    })

    pkgConfigDependencies: ["Qt5Core", "gio-2.0"]

    cmakeDependencies: ({ "Qt5Core": project.minimumQtVersion })
    cmakeLinkLibraries: ["Qt5::Core"]

    LiriHeaders {
        name: root.headersName
        sync.module: root.moduleName

        Group {
            name: "Headers"
            files: "**/*.h"
            fileTags: ["hpp_syncable"]
        }
    }

    LiriModule {
        name: root.moduleName
        targetName: root.targetName
        version: "1.0.0"

        condition: {
            if (!glib.gio.found) {
                console.error("gio is required to build " + targetName);
                return false;
            }

            if (!glib.gobject.found) {
                console.error("gobject is required to build " + targetName);
                return false;
            }

            return true;
        }

        Depends { name: root.headersName }
        Depends { name: "Qt.core"; versionAtLeast: project.minimumQtVersion }
        Depends { name: "glib"; submodules: ["gio", "gobject"] }

        Qt.core.enableKeywords: false

        files: ["*.cpp", "*.h"]

        Export {
            Depends { name: "cpp" }
            Depends { name: root.headersName }
            Depends { name: "Qt.core"; versionAtLeast: project.minimumQtVersion }
            Depends { name: "glib"; submodules: ["gio", "gobject"] }
        }
    }
}
