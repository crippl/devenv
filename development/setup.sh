#/bin/bash

#
# Development software
#

install "git git-svn" "git/svn"
install "htop iotop" "System tools"
if install "build-essential glic-doc valgrind manpages-dev gdb cgdb autoconf autopoint manpages-posix-dev exuberant-ctags libgcc1-dbg libstdc++6-4.6-dbg bless" "C++ tools"; then
    install "eclipse eclipse-cdt eclipse-cdt-perf eclipse-cdt-profiling-framework eclipse-cdt-valgrind" "Eclipse"
    install "libqtcore4 qtdevelop qtcreator qt4-qtconfig libqt5webkit5-dev qt4-doc-html qtbase5-doc qttools5-doc-html qtwebkit5-doc-html qtdeclarative5-doc qtscript5-doc qtwebkit5-doc qttools5-doc" "QT development"
fi
install "sqlite3 libsqlite3-dev sqlite3-doc sqlitebrowser sqliteman sqliteman-doc" "sqlite3"
install "netbeans maven" "Java tools"