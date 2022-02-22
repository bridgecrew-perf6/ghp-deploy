from __future__ import absolute_import
from jinja2 import Template, Environment, FileSystemLoader
import glob
import pathlib

CONTENT_PATH = 'pages'
OUTPUT_PATH = 'output'

# load templates folder to environment
env = Environment(loader=FileSystemLoader('templates'))

# load the main template
main_template = env.get_template('main.jinja')

content_path = pathlib.Path(CONTENT_PATH)
for content_filename in glob.glob(str(content_path / '*html')):
    with open(content_filename) as content_file:
        content = content_file.read()

    output_from_parsed_template = main_template.render(content=content)

    absolute_path = pathlib.Path(content_filename)
    relative_path = pathlib.Path(*absolute_path.parts[1:])

    # write the parsed template
    with open(OUTPUT_PATH / relative_path, "w") as output_file:
        output_file.write(output_from_parsed_template)
