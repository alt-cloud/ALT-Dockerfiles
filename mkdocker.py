#! /usr/bin/python3

import argparse
import os
import sys

def get_dockerfile_contents(kwargs):
    instructions = ['from', 'maintainer', 'install', 'run', 'env', 'user', 'expose', 'volume', 'cmd']
    dockerfile = ''
    for instruction in instructions:
        upper = instruction.upper()
        arguments = kwargs[instruction]
        list_instructions = {'cmd', 'volume'}
        if arguments is not None:
            if not isinstance(arguments, list):
                arguments = [arguments]
            if instruction == 'install':
                for argument in arguments:
                    dockerfile += f'RUN apt-get update && apt-get install -y {argument} && apt-get clean\n'
            elif instruction in list_instructions:
                dockerfile += f'{upper} [' + ', '.join([f'"{a}"' for a in arguments]) + ']\n'
            else:
                for argument in arguments:
                    dockerfile += f'{upper} {argument}\n'
            dockerfile += '\n'
    return dockerfile.rstrip() + '\n'


def get_readme_contents(name):
    readme = ''
    header = f'dockerfiles-alt-{name}\n'
    readme += header + '='*len(header) + '\n'
    readme += f'''
ALT dockerfile for {name}.

Copy Dockerfile somewhere and build the image:
`$ docker build --rm -t <username>/{name} .`

And launch the {name} container:
`docker run -it <username>/{name}`
'''
    return readme


try:
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--name', required=True)
    parser.add_argument('-m', '--maintainer', default='alt-cloud')
    parser.add_argument('-r', '--run', nargs='+')
    parser.add_argument('-i', '--install', nargs='+')
    parser.add_argument('--from', default='alt')
    parser.add_argument('--env', nargs='+')
    parser.add_argument('--expose')
    parser.add_argument('--volume', nargs='+')
    parser.add_argument('-u', '--user')
    # cmd could contain strings like flags (e.g. irb -m), so it has to be the
    # very last option to catch all remaining strings
    parser.add_argument('--cmd', nargs=argparse.REMAINDER)
    args = parser.parse_args()

    name = args.name
    os.mkdir(name)
    os.chdir(name)

    with open('Dockerfile', 'w') as dockerfile:
        dockerfile.write(get_dockerfile_contents(args.__dict__))

    with open('README.md', 'w') as readme:
        readme.write(get_readme_contents(name))

except FileExistsError as e:
    print(f'This dockerfile directory `{e.filename}` is already exists.')
except Exception as e:
    print('Something goes wrong')
    print(e)
