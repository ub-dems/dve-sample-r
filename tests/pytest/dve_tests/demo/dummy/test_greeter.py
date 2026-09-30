"""Unit tests for Greeter module."""

import dve.demo.dummy.greeter as dmy


class TestGreeter:
    """Tests for target discovery logic."""

    def test_greeting_class(self) -> None:
        """Test Greeting dataclass ctor."""
        g1 = dmy.Greeting(who="a", salutation="b")
        g2 = dmy.Greeting(who="a", salutation="b")
        g3 = dmy.Greeting(who="c", salutation="d")

        assert "a" in repr(g1)
        assert "b" in repr(g1)

        assert g1 == g2
        assert not g1 == g3

    def test_greeter_data(self) -> None:
        """Test that Greeter format message on constructor data."""
        g1 = dmy.Greeting(who="a", salutation="b")
        gtr = dmy.Greeter(g1)
        msg = gtr.get_message()

        assert "a" in msg
        assert "b" in msg

    def test_greeter_default(self) -> None:
        """Test that Greeter format message on constructor data."""
        gtr = dmy.Greeter()
        msg = gtr.get_message()

        assert "Hello" in msg
        assert "World" in msg
