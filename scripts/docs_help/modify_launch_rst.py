#!/usr/bin/env python3
import importlib
from argparse import ArgumentParser
import os
from glob import glob


# https://stackoverflow.com/questions/11347505/what-are-some-approaches-to-outputting-a-python-data-structure-to-restructuredte
def make_table(grid):
    max_cols = [max(out) for out in map(list, zip(*[[len(item) for item in row] for row in grid]))]
    rst = table_div(max_cols, 1)

    for i, row in enumerate(grid):
        header_flag = False
        if i == 0 or i == len(grid)-1: header_flag = True
        rst += normalize_row(row,max_cols)
        rst += table_div(max_cols, header_flag )
    return rst

def table_div(max_cols, header_flag=1):
    out = ""
    if header_flag == 1:
        style = "="
    else:
        style = "-"

    for max_col in max_cols:
        out += max_col * style + " "

    out += "\n"
    return out


def normalize_row(row, max_cols):
    r = ""
    for i, max_col in enumerate(max_cols):
        r += row[i] + (max_col  - len(row[i]) + 1) * " "

    return r + "\n"
#########################################################################


def modify_rst(file_path: str):
    """Modifies RST to structure launch arguments in readable format. Requires constant
    `LAUNCH_ARGS` in file.

    Args:
        file (str): file path
    """
    full_module_name = ".".join(file_path.split("/")[-1].split(".")[:-1])
    # package, subpackage, module = full_module_name
    module = importlib.import_module(full_module_name)
    LAUNCH_ARGS = module.LAUNCH_ARGS
    keys = ["name", "default", "description"]
    grid = [keys]
    for launch_arg in LAUNCH_ARGS:
        row = []
        for k, v in launch_arg.items():
            if k not in keys:
                continue
            if k == "default" and "/share/" in v:
                v = v.split("/share/")[-1]
            row.append(v)
        if row:
            grid.append(row)
    table = make_table(grid)
    header = """
Launch Arguments

"""
    footer = """
    
"""
    addition = header + table + footer

    with open(file_path,'r') as contents:
        save = contents.read()
    with open(file_path,'w') as contents:
        contents.write(addition)
    with open(file_path,'a') as contents:
        contents.write(save)


def find_package(src_path: str, package: str):
    """Recursively finds ROS2 package. Assumes docs folder is in same folder as `package.xml`.

    Args:
        src_path (str): source path of ros2 workspace
        package (str): ros2 package name

    Returns:
        str: Path to package. `None` if package cannot be found.
    """
    rpaths = []
    for path in os.listdir(src_path):
        if path == package:
            full_path = os.path.join(src_path, path)
            if os.path.isfile(os.path.join(full_path, "package.xml")):
                return full_path
        rpaths.append(os.path.join(src_path, path))
    for rpath in rpaths:
        if os.path.isdir(rpath):
            path = find_package(rpath, package)
            if path is not None:
                return path
    return None


def modify_launch_modules(package: str):
    """Modifies all sphinx RsT files generated from `launch` folder of package and adds launch args
    TOC.

    Args:
        package (str): Name of ROS2 package.
    """
    dir_path = os.path.dirname(os.path.realpath(__file__))
    src_path = os.path.abspath(os.path.join(dir_path, "..", "..", "src"))
    path = find_package(src_path, package)
    if path is None:
        raise Exception(f"Could not find package '{package}'")
    docs_path = os.path.join(path, "docs", "source")
    launch_rsts = glob(os.path.join(docs_path, "*.launch.*.rst"))
    for rst in launch_rsts:
        if ".common." in rst:
            continue
        modify_rst(rst)


if __name__=="__main__":
    parser = ArgumentParser()
    parser.add_argument("package", type=str, help="Package to modify launch RSTs.")
    args = parser.parse_args()
    modify_launch_modules(args.package)
