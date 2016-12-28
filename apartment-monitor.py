import json
import os
import pycurl
import re
import ast

from io import BytesIO


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

        with open(os.path.join(target, page['key']), 'w') as target_file:
            body = buffer.getvalue()
            charset = capture.charset
            if 'charset' in page:
                charset = page['charset']
            value = body.decode(charset)
            target_file.write(value)

        c.close()
        print(page['key'] + " written")
