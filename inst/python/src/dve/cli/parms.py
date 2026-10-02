from typing import cast, Optional, Callable, Sequence
from dataclasses import dataclass

import vce.cli.parms as std_parms


class JobParmsConsts(object):
    ENV_AUTO = "X_E_AUTO"


@dataclass(kw_only=True)
class JobName(std_parms.JobName):
    # id: str
    # ns: str
    pass


@dataclass(kw_only=True)
class JobCall(std_parms.JobCall):
    # func: Optional[Callable] = None
    # source: Optional[str] = None
    pass


@dataclass(kw_only=True)
class JobParm(std_parms.JobParm):
    # v: dict
    pass


@dataclass(kw_only=True)
class JobSpec:
    name: JobName
    call: JobCall
    parm: JobParm

    def as_std(self) -> std_parms.JobSpec:
        return std_parms.JobSpec(name=self.name, call=self.call, parm=self.parm)


@dataclass
class JobSpecs:
    specs: Sequence[JobSpec]
    auto: Optional[str] = None

    def as_std(self) -> std_parms.JobSpecs:
        return std_parms.JobSpecs(specs=[x.as_std() for x in self.specs], auto=self.auto)

    def get_job_spec(self, job_id: str, job_ns: Optional[str] = None) -> JobSpec:
        return cast("JobSpec", self.as_std().get_job_spec(job_id, job_ns))

    def get_auto_name(self, name: str = "") -> str:
        return self.as_std().get_auto_name(name)

    def get_auto_spec(self) -> JobSpec:
        return cast("JobSpec", self.as_std().get_auto_spec())


# //////////////////////////////////////////////////////////////////////////////////////////////////


def parm(**kwargs) -> JobParm:
    parm = JobParm(v=kwargs)
    return parm


def spec(id: str, ns: str, main: Callable, parm: JobParm) -> JobSpec:
    name = JobName(id=id, ns=ns)
    call = JobCall(func=main)
    spec = JobSpec(name=name, call=call, parm=parm)
    return spec


def specs(spec_list: Sequence[JobSpec], auto: Optional[str] = None) -> JobSpecs:
    specs = JobSpecs(specs=spec_list, auto=auto)
    return specs


class JobSpecsGlobals:
    _specs: Optional[JobSpecs] = None


def get_job_specs() -> JobSpecs:
    assert JobSpecsGlobals._specs, "global job_specs undefined"
    return JobSpecsGlobals._specs


def set_job_specs(specs: JobSpecs) -> JobSpecs:
    JobSpecsGlobals._specs = specs
    return JobSpecsGlobals._specs


def init_specs(spec_list: Sequence[JobSpec], auto: Optional[str] = None) -> JobSpecs:
    sps = specs(spec_list=spec_list, auto=auto)
    return set_job_specs(sps)
