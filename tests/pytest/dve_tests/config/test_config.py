import unittest


def load_test(c):
    return unittest.defaultTestLoader.loadTestsFromTestCase(c)


def all_tests():
    test_suite = unittest.TestSuite()
    return test_suite


if __name__ == "__main__":
    suite = all_tests()
    runner = unittest.TextTestRunner()
    runner.run(suite)
