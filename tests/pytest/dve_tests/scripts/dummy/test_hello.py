"""Unit tests for Greeter module."""

import dve.scripts.dummy.dummy_hello as app


class TestHello:
    """Tests for dummy_hello script."""

    def test_all_args(self) -> None:
        """Test that Greeter format message on constructor data."""
        rc = app.main(
            [
                "--salutation",
                "Hey",
                "--who",
                "Ya",
                "--n-points",
                "5",
                "--verbose",
            ]
        )
        assert rc == 0

    def test_arg_points(self) -> None:
        """Test that Greeter format message on constructor data."""
        rc = app.main(["--n-points", "5"])
        assert rc == 0

    def test_arg_who(self) -> None:
        """Test that Greeter format message on constructor data."""
        rc = app.main(["--who", "Ya"])
        assert rc == 0

    def test_arg_salutation(self) -> None:
        """Test that Greeter format message on constructor data."""
        rc = app.main(["--salutation", "Hey"])
        assert rc == 0

    def test_app_default(self) -> None:
        """Test that Greeter format message on constructor data."""
        rc = app.main([])  # avoid implicy pytest sys.argv, like --color

        assert rc == 0
