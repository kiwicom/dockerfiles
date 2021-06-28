#!/usr/bin/env python3
#
# This script iterates over all kustomize overlays under specified
# directory, renders the resulting manifests and performs a kubeconform check on them
import subprocess
import tempfile
import argparse
import os.path
import sys
from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument('analyse_dir', nargs='?', default='.')
parser.add_argument('-schema-location', action='append')

args = parser.parse_args()

kubeconform_cache = os.environ.get('KUBECONFORM_CACHE')
if not kubeconform_cache:
    kubeconform_cache = tempfile.mkdtemp()


def analyse_overlay(overlay_dir):
    print(f"🧐 {overlay_dir}: \t", end='', flush=True)

    extra_args = []
    if args.schema_location:
        for location in args.schema_location:
            extra_args.extend(['-schema-location', location])

    p1 = subprocess.Popen(["kubectl", "kustomize", overlay_dir], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(["kubeconform", "-summary", "-exit-on-error", "-cache", kubeconform_cache] + extra_args,
                          stdin=p1.stdout)
    p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
    return_code = p2.wait()
    if return_code != 0:
        raise SystemExit(return_code)


def analyse_k8s(dir):
    overlays_dir = Path(dir) / 'overlays'
    if overlays_dir.is_dir():
        overlay_dirs = list(overlays_dir.glob('*'))
    else:
        overlay_dirs = list(Path(dir).glob('*/overlays/*'))

    if len(overlay_dirs) == 0:
        print('No overlay directories found', file=sys.stderr)
        raise SystemExit(1)

    for overlay_dir in overlay_dirs:
        analyse_overlay(overlay_dir)


if __name__ == '__main__':
    os.makedirs(kubeconform_cache, exist_ok=True)
    analyse_k8s(args.analyse_dir)
