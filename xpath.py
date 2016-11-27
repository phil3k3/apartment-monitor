from lxml import etree as ElementTree
from sys import stdin
import sys

xpath = sys.argv[1]

parser = ElementTree.HTMLParser()
tree = ElementTree.parse(stdin, parser)
result = tree.xpath(xpath)
for element in tree.xpath(xpath):
    print(ElementTree.tostring(element))
