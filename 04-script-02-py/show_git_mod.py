#!/usr/bin/env python3

import os

repo = os.getcwd()

bash_command = [f"cd {repo}", "git ls-files -dmo"]
result_os = os.popen(' && '.join(bash_command)).read()

for result in result_os.splitlines():
    print(os.path.join(repo, result.strip()))