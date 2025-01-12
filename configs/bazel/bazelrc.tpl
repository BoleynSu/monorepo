common --experimental_repo_remote_exec

# See https://github.com/bazelbuild/rules_docker/blob/6ea707babdcd54514e0884278ac624fb8bda19c1/docs/container.md
build --loading_phase_threads=1

build --conlyopt=-std=c{c_version}
build --host_conlyopt=-std=c{c_version}

build --cxxopt=-std=c++{cpp_version}
build --host_cxxopt=-std=c++{cpp_version}

build --java_language_version={java_version}
build --java_runtime_version=remotejdk_{java_version}
build --tool_java_language_version={java_version}
build --tool_java_runtime_version=remotejdk_{java_version}

# https://github.com/bazelbuild/bazel-toolchains/blob/b9bc541aae7bd8e09c6954e2e9da3f7ffe4f77f0/bazelrc/bazel-4.1.0.bazelrc
build:remote_common --jobs=24
build:remote_common --extra_toolchains=@boleynsu_org//configs/build/remote/java:all
build:remote_common --crosstool_top=@boleynsu_org//configs/build/remote/cc:toolchain
# FIXME(https://github.com/bazelbuild/bazel/issues/10756, https://github.com/bazelbuild/rules_docker/issues/1935#issuecomment-938028835):
# Temporary fix:
# Removed --action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1 from .bazelrc
# build:remote_common --action_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1
build:remote_common --extra_toolchains=@boleynsu_org//configs/build/remote/config:cc-toolchain
build:remote_common --extra_execution_platforms=@boleynsu_org//configs/build/remote/config:platform
build:remote_common --host_platform=@boleynsu_org//configs/build/remote/config:platform
build:remote_common --platforms=@boleynsu_org//configs/build/remote/config:platform
build:remote_common --remote_executor=grpc://build.boleyn.su:8980
build:remote_common --remote_instance_name=remote-monorepo
build:remote_common --incompatible_strict_action_env=true
build:remote_common --remote_timeout=3600

build:remote --config=remote_common
build:remote --remote_download_minimal

build:remote_toplevel --config=remote_common
build:remote_toplevel --remote_download_toplevel

build:remote_all --config=remote_common
