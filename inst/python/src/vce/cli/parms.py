from typing import Optional, Callable, TypeVar, Sequence
from dataclasses import dataclass

from vce.common.util import proc
import vce.common.util.environ as en


class JobParmsConsts(object):
    ENV_AUTO = "X_E_AUTO"


@dataclass(kw_only=True)
class JobName:
    id: str
    ns: str


JobNameT_co = TypeVar("JobNameT_co", bound=JobName, covariant=True)


@dataclass(kw_only=True)
class JobCall:
    func: Optional[Callable] = None
    source: Optional[str] = None

    def get_main(self) -> Callable:
        if self.func:
            return self.func

        if not self.source:
            raise ValueError("job_script undefined")

        script = self.source

        def script_wrapper(argv, **kwargs):
            rc = proc.call_script(script=script, argv=argv, **kwargs)
            return rc

        return script_wrapper


JobCallT_co = TypeVar("JobCallT_co", bound=JobCall, covariant=True)


@dataclass(kw_only=True)
class JobParm:
    v: dict


JobParmT_co = TypeVar("JobParmT_co", bound=JobParm, covariant=True)


@dataclass(kw_only=True)
class JobSpec:
    name: JobName
    call: JobCall
    parm: JobParm


JobSpecT_co = TypeVar("JobSpecT_co", bound=JobSpec, covariant=True)


@dataclass
class JobSpecs:
    specs: Sequence[JobSpec]
    auto: Optional[str] = None

    def get_job_spec(self, job_id: str, job_ns: Optional[str] = None) -> JobSpec:
        for spec in self.specs:
            if job_id == spec.name.id:
                if job_ns is None or job_ns == spec.name.ns:
                    return spec
        raise ValueError(f"Job Info not found in Specs: id={job_id}, ns={job_ns}")

    def get_auto_name(self, name: str = "") -> str:
        job_id = en.env_get(JobParmsConsts.ENV_AUTO)
        if job_id:
            return job_id
        if self.auto:
            return self.auto
        if self.specs:
            return self.specs[0].name.id
        raise ValueError(f"Job Specs is empty(name={name})")

    def get_auto_spec(self) -> JobSpec:
        job_id = self.get_auto_name()
        result = self.get_job_spec(job_id)
        return result


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


_specs: Optional[JobSpecs] = None


def get_job_specs() -> JobSpecs:
    assert _specs, "global job_specs undefined"
    return _specs


def set_job_specs(specs: JobSpecs) -> JobSpecs:
    _specs = specs
    return _specs


def init_specs(spec_list: Sequence[JobSpec], auto: Optional[str] = None) -> JobSpecs:
    sps = specs(spec_list=spec_list, auto=auto)
    return set_job_specs(sps)
