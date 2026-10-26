ExternalProject_Add(cppwinrt
    GIT_REPOSITORY https://github.com/microsoft/cppwinrt.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 PATH=$O_PATH cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -GNinja
        -DCMAKE_BUILD_TYPE=Release
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
            # microsoft/windows-rs 把 winmd 从 crates/libs/bindgen/default/ 移到了
            # crates/libs/default/，旧路径现在返回 404，wget 直接失败。这里固定到
            # 一个具体提交，避免 master 再变。
            COMMAND ${EXEC} wget -O <BINARY_DIR>/Windows.winmd https://raw.githubusercontent.com/microsoft/windows-rs/f8fec5cbb08bb33ca5a257faa05db30eb975e40b/crates/libs/default/Windows.winmd
            COMMAND ${EXEC} cppwinrt -input <BINARY_DIR>/Windows.winmd -output ${MINGW_INSTALL_PREFIX}/include/
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(cppwinrt)
cleanup(cppwinrt install)
