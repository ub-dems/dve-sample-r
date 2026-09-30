NOOP = False


def unused(*args):
    if NOOP:
        print("NOOP(%s)", str(args))
