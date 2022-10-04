#!/usr/bin/env python3
import json5 as json
from argparse import ArgumentParser
import os
from platform import uname


def merge_dict(d1: dict, d2: dict):
    for key, val in d2.items():
        if isinstance(val, dict):
            sub = d1[key] if key in d1.keys() and isinstance(d1[key], dict) else {}
            merge_dict(sub, val)
            d1[key] = sub
        elif key in d1.keys():
            if isinstance(val, list) and isinstance(d1[key], list):
                d1[key].extend(val)
            else:
                d1[key] =  val
        else:
            d1[key] = val

def main():
    dir = os.path.dirname(__file__)
    base = {}
    extra = {}
    with open(os.path.join(dir, "base_template_devcontainer.json")) as base_file:
        base.update(json.load(base_file))

    # https://www.scivision.dev/python-detect-wsl/
    if 'microsoft-standard' in uname().release:
        with open(os.path.join(dir, "wsl_template_devcontainer.json")) as wsl_file:
            extra.update(json.load(wsl_file))

    
    final = base.copy()
    merge_dict(final, extra)
    with open(os.path.abspath(os.path.join(dir, "..", "..", ".devcontainer", "devcontainer.json")), "w") as out:
        json.dump(final, out, indent=4, quote_keys=True)


if __name__=="__main__":
    main()
