#!/usr/bin/env python3

import os
import argparse

parser = argparse.ArgumentParser(description='list git modifies, deleted, untracked files')
parser.add_argument('repo', type=str, default=os.getcwd(), help='git repo directory')
args = parser.parse_args()

bash_command = [f"cd {args.repo}", "git ls-files -dmo"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.splitlines():
    print(os.path.join(args.repo, result.strip()))