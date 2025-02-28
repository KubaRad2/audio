#!/usr/bin/env bash

set -e

eval "$(./conda/bin/conda shell.bash hook)"
conda activate ./env

python -m torch.utils.collect_env
env | grep TORCHAUDIO || true

export PATH="${PWD}/third_party/install/bin/:${PATH}"

declare -a args=(
    '-v'
    '--cov=torchaudio'
    "--junitxml=${PWD}/test-results/junit.xml"
    '--durations' '20'
)

if [[ "${CUDA_TESTS_ONLY}" = "1" ]]; then
  args+=('-k' 'cuda or gpu')
fi

cd test
pytest "${args[@]}" torchaudio_unittest
coverage html
