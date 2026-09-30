import argparse

import vce.cli.xargs as std_args


class AppArgsConsts(object):
    ARG_TYPE_GENERIC = "generic"
    ARG_TYPE_MAIN = "main"
    ARG_TYPE_RUNNER = "runner"
    ARG_TYPE_AUTO = "auto"

    ARG_TYPE_TEST = "test"
    ARG_TYPE_DUMMY = "dummy"

    ARGS_ENV_AUTO = "X_E_AUTO"


# ruff: noqa :B026
class AppMainArgs(std_args.AppMainArgs):
    arg_type = AppArgsConsts.ARG_TYPE_MAIN

    def __init__(self, parent=None, *args, **kwargs):
        super().__init__(parent=parent, *args, **kwargs)

    def base_parser(self) -> argparse.ArgumentParser:
        return super().base_parser()

    def main_parser(self) -> argparse.ArgumentParser:
        return super().main_parser()

    def get_parser(self) -> argparse.ArgumentParser:
        return super().get_parser()


def get_main_argparser(*args, **kwargs) -> AppMainArgs:
    result = AppMainArgs(*args, **kwargs)
    return result


class AppRunnerArgs(std_args.AppRunnerArgs):
    arg_type = AppArgsConsts.ARG_TYPE_RUNNER

    def __init__(self, parent=None, *args, **kwargs):
        super().__init__(parent=parent, *args, **kwargs)

    def base_parser(self) -> argparse.ArgumentParser:
        return super().base_parser()

    def runner_parser(self) -> argparse.ArgumentParser:
        return super().runner_parser()

    def get_parser(self) -> argparse.ArgumentParser:
        return self.runner_parser()


def get_runner_argparser(*args, **kwargs) -> AppRunnerArgs:
    result = AppRunnerArgs(*args, **kwargs)
    return result


class AppAutoArgs(std_args.AppAutoArgs):
    arg_type = AppArgsConsts.ARG_TYPE_AUTO

    def __init__(self, parent=None, *args, **kwargs):
        super().__init__(parent=parent, *args, **kwargs)

    def base_parser(self) -> argparse.ArgumentParser:
        return super().base_parser()

    def auto_parser(self) -> argparse.ArgumentParser:
        return super().auto_parser()

    def get_parser(self) -> argparse.ArgumentParser:
        return super().get_parser()


def get_auto_argparser(*args, **kwargs) -> AppAutoArgs:
    result = AppAutoArgs(*args, **kwargs)
    return result


# ///[ TEST ]///////////////////////////////////////////////////


class AppTestArgs(AppAutoArgs):
    arg_type = AppArgsConsts.ARG_TYPE_TEST

    def __init__(self, parent=None, *args, **kwargs):
        super().__init__(parent=parent, *args, **kwargs)

    def test_parser(self) -> argparse.ArgumentParser:
        parser = self.auto_parser()
        parser.add_argument("--demo-arg-1", "-1", type=str, help="demo script arg 1", default="A")
        return parser

    def get_parser(self) -> argparse.ArgumentParser:
        return self.test_parser()


def get_test_argparser(*args, **kwargs) -> AppTestArgs:
    result = AppTestArgs(*args, **kwargs)
    return result


class AppDummyArgs(AppAutoArgs):
    arg_type = AppArgsConsts.ARG_TYPE_DUMMY

    def __init__(self, parent=None, *args, **kwargs):
        super().__init__(parent=parent, *args, **kwargs)

    def dummy_parser(self) -> argparse.ArgumentParser:
        parser = self.auto_parser()
        parser.add_argument("--dummy-arg-1", "-1", type=str, help="dummy script arg 1", default="A")
        return parser

    def get_parser(self) -> argparse.ArgumentParser:
        return self.dummy_parser()


def get_dummy_argparser(*args, **kwargs) -> AppDummyArgs:
    result = AppDummyArgs(*args, **kwargs)
    return result
