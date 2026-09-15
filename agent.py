#!/usr/bin/env -S python3 -B

import subprocess
import sys

if len(sys.argv) < 2:
    raise SystemExit(f"Usage: {sys.argv[0]} <prompt>")

result = subprocess.run(
    ["copilot", "--allow-all", "-p", sys.argv[1]]
)

print (f"Done. Return code: {result.returncode}")
