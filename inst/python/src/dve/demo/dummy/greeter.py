from dataclasses import dataclass


@dataclass(kw_only=True)
class Greeting:
    who: str
    salutation: str


DEFAULT_GREETING = Greeting(who="World", salutation="Hello")


class Greeter:
    def __init__(self, greeting: Greeting | None = None):
        self.greeting = greeting

    def get_greeting(self) -> Greeting:
        return self.greeting if self.greeting is not None else DEFAULT_GREETING

    def get_message(self, num_points: int = 0) -> str:
        grt = self.get_greeting()
        hnd = "👋" * num_points
        return f"{grt.salutation} {grt.who}! {hnd}"
