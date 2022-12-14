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

k8s_version = os.environ.get('KUBECONFORM_K8S_VERSION')

def analyse_overlay(overlay_dir):
    print(f"🧐 {overlay_dir}: \t", end='', flush=True)

    extra_args = []
    if args.schema_location:
        for location in args.schema_location:
            extra_args.extend(['-schema-location', location])

    if k8s_version:
        extra_args.extend(['-kubernetes-version', k8s_version])

    p1 = subprocess.Popen(["kubectl", "kustomize", overlay_dir], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(
        ["kubeconform", "-summary", "-exit-on-error", "-cache", kubeconform_cache, *extra_args],
        stdin=p1.stdout,
    )
    p1.stdout.close()  # Allow p1 to receive a SIGPIPE if p2 exits.
    p2ret = p2.wait()
    if p2ret != 0:
        print(f'kubeconform failed with exit code {p2ret}', file=sys.stderr)
        raise SystemExit(p2ret)
    p1ret = p1.wait()
    if p1ret != 0:
        print(f'kubectl kustomize failed with exit code {p1ret}', file=sys.stderr)
        raise SystemExit(p1ret)


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
