# This is a work-in-progress.
# The idea is to generate a combination of builds 
# with different parameters.

from pathlib import Path
import yaml
import itertools

base_dir = Path('../')
config_path = Path('build_config.yml')

config = yaml.load(open(config_path))
matrix = config['matrix']
excluded = config['exclude']

# List all possible combinations
matrix_keys = sorted(matrix)
temp_builds = list(itertools.product(*(matrix[key] for key in matrix_keys)))

# Exclude unwanted builds.
builds = []
for temp_build in temp_builds:
    build = dict(zip(matrix_keys, temp_build))

    do_exclude = False
    for exclude_build in excluded:
        exclude_count = 0
        for k, v in exclude_build.items():
            if build[k] == v:
                exclude_count += 1
        if exclude_count == len(exclude_build):
            do_exclude = True
            
    if not do_exclude:
        builds.append(build)

print(builds)