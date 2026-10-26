ExternalProject_Add(mingw-w64
    GIT_REPOSITORY https://github.com/mingw-w64/mingw-w64.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    # 固定在 v14.0.0。mingw-w64 master 已经把 EXCEPTION_DISPOSITION 从
    # `#define EXCEPTION_DISPOSITION int` 改成了 `enum _EXCEPTION_DISPOSITION`，
    # 而 LLVM 20 的 libunwind/src/Unwind-seh.cpp 仍按 int 返回，会编译失败：
    #   error: cannot initialize return object of type 'EXCEPTION_DISPOSITION'
    #          (aka '_EXCEPTION_DISPOSITION') with an rvalue of type 'int'
    # 不固定分支的话，上游 master 一动整个工具链就不可复现。
    GIT_TAG v14.0.0
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    LOG_DOWNLOAD 1 LOG_UPDATE 1
)

force_rebuild_git(mingw-w64)
get_property(MINGW_SRC TARGET mingw-w64 PROPERTY _EP_SOURCE_DIR)
