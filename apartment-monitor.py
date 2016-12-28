import json
import os
import pycurl
import re
import ast
from filecmp import dircmp

from io import BytesIO
from lxml import etree


def apply_query(html_content, xpath, encoding):
    tree = etree.HTML(html_content)
    result = ""
    for element in tree.xpath(xpath):
        result += etree.tostring(element).decode(encoding)
    return result


class CaptureCharset:

    def __init__(self):
        self.regex = re.compile(r'.+charset=([^\\]+)')
        self.charset = "utf-8"

    def store(self, buf):
        if "Content-Type" in str(buf):
            result = self.regex.findall(str(buf).strip())
            if len(result) > 0:
                self.charset = result[0]

current = 0
if os.path.isfile("./state"):
    with open('./state') as state:
        current = int(state.read().strip())

print("Current file " + str(current))
target = str(current % 2)
if not os.path.isdir(target):
    os.mkdir(target)

with open('estate_pages.json') as pages_file:
    pages = json.load(pages_file)

    for page in pages['pages']:

        buffer = BytesIO()
        c = pycurl.Curl()
        print(page['key'])

        capture = CaptureCharset()
        c.setopt(c.HEADERFUNCTION, capture.store)
        c.setopt(c.URL, page['url'])
        c.setopt(c.WRITEDATA, buffer)

        if 'options' in page:
            for option in page['options'].keys():
                option_value = page['options'][option]
                try:
                    converted = ast.literal_eval(option_value)
                    c.setopt(getattr(c, option), converted)
                except:
                    c.setopt(getattr(c, option), option_value)

        if 'data_binary' in page:
            c.setopt(c.POST, 1)
            c.setopt(c.POSTFIELDSIZE, len(page['data_binary']))
            c.setopt(c.POSTFIELDS, page['data_binary'])

        if 'data' in page:
            c.setopt(c.POST, 1)
            c.setopt(c.POSTFIELDS, page['data'])

        if 'headers' in page:
            c.setopt(c.HTTPHEADER, page['headers'])

        c.perform()
        print(page['key'] + " " + str(c.getinfo(c.RESPONSE_CODE)))

        try:
            with open(os.path.join(target, page['key']), 'w') as target_file:
                body = buffer.getvalue()
                charset = capture.charset
                if 'charset' in page:
                    charset = page['charset']
                value = body.decode(charset)
                if 'query' in page:
                    value = apply_query(value, page['query'], 'utf-8')
                target_file.write(value)
        except Exception as e:
            print("TEST")
        finally:
            c.close()
        print(page['key'] + " written")

with open('./state', 'w') as state:
    state.write(str(current+1))


previous = current - 1
previous_target = previous % 2

if os.path.isdir(str(previous_target)):
    print("Comparing current with previous result")
    print(str(previous_target))
    print(str(target))

    dcmp = dircmp(str(previous_target), str(target))
    for name in dcmp.diff_files:
        print(name)
else:
    print("Directory does not exist")
