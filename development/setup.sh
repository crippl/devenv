#/bin/bash

#
# Development software
#

post_install_eclipse_plugin() {
    # Adds a Eclipse plugin to post installation
    # $1: Repo
    # $2: Class path
    # Returns: True on success

    REPO="$1"
    CLASS="$2"
    POST_INSTALLATION_FILE=`pwd`/setup_eclipse_plugin.sh
    if [ ! -e "$POST_INSTALLATION_FILE" ]; then
        echo "> Cannot find script to install Eclipse plugins: $POST_INSTALLATION_FILE"
        return 1
    fi

    COMMAND="$POST_INSTALLATION_FILE"\ "$REPO"\ "$CLASS"
    
    post_install "$COMMAND"
}

if install "git git-svn" "git/svn"; then
    install "gitg" "gitg"
    bash ./setup_git.sh
    install "meld"
fi
install "htop iotop"
if install "build-essential glibc-doc valgrind manpages-dev gdb cgdb autoconf autopoint manpages-posix-dev exuberant-ctags libgcc1-dbg libstdc++6-4.6-dbg bless" "C++ tools"; then
    install "lsb" "Linux Standard Base"
    if install "eclipse eclipse-cdt eclipse-cdt-perf eclipse-cdt-profiling-framework eclipse-cdt-valgrind" "Eclipse"; then
        POST_INSTALL_ECLIPSE_PLUGIN=`pwd`/setup_eclipse_plugin.sh
        ECLIPSE_REPO="http://download.eclipse.org/releases/indigo/"
        INSTALL_ECLIPSE_STR="> Install Eclipse"
        if prompt "$INSTALL_ECLIPSE_STR Plugins"; then
            if prompt "$INSTALL_ECLIPSE_STR Marketplace"; then
                #Eclipse Marketplace
                post_install_eclipse_plugin "$ECLIPSE_REPO" org.eclipse.epp.mpc.feature.group
            fi
            if prompt "$INSTALL_ECLIPSE_STR Java EE Plugins"; then
                #Eclipse Java EE Developer Tools
                post_install_eclipse_plugin "$ECLIPSE_REPO" org.eclipse.jst.enterprise_ui.feature.feature.group
                #Eclipse Java Web Developer Tools
                post_install_eclipse_plugin "$ECLIPSE_REPO" org.eclipse.jst.web_ui.feature.feature.group
                #WST Server Adapters
                post_install_eclipse_plugin "$ECLIPSE_REPO" org.eclipse.wst.server_adapters.feature.feature.group
            fi
            if prompt "$INSTALL_ECLIPSE_STR OSGi Bundle"; then
                post_install_eclipse_plugin "$ECLIPSE_REPO" org.eclipse.libra.facet.feature.feature.group
            fi
            if prompt "$INSTALL_ECLIPSE_STR Maven Plugin"; then
                install "maven" "Maven"
                post_install_eclipse_plugin "$ECLIPSE_REPO" org.eclipse.m2e.feature.feature.group
            fi
        fi
    fi
    install "tomcat7"
    install "libqtcore4 qdevelop qtcreator qt4-qtconfig libqt5webkit5-dev qt4-doc-html qtbase5-doc qttools5-doc-html qtwebkit5-doc-html qtdeclarative5-doc qtscript5-doc qtwebkit5-doc qttools5-doc" "QT development"
fi
install "sqlite3 libsqlite3-dev sqlite3-doc sqlitebrowser sqliteman sqliteman-doc" "sqlite3"
install "netbeans" "Netbeans"
if [ -e "./setup_jdk6.sh" ] && prompt "> Download and install jdk6"; then
    bash ./setup_jdk6.sh
fi

if [ -e "./setup_android_sdk.sh" ] && prompt "> Download and install Android SDK"; then
    bash ./setup_android_sdk.sh
fi
# libraries from http://stackoverflow.com/questions/14976353/android-emulator-is-not-starting-in-ubuntu
install "libgles1-mesa-dev libgles2-mesa-dev libgles1-mesa libgles2-mesa libqt4-opengl glmark2 glmark2-es2 libgles1-mesa-dbg libgles2-mesa-dbg freeglut3 libhugs-opengl-bundled" "Android SDK Hardware emulation libraries"
install "android-tools-adb"
