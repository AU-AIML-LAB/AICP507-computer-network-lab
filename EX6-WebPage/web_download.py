import urllib.request

response = urllib.request.urlretrieve("http://www.example.org", "webpage.html")

for line in open("webpage.html"):
    print(line.strip())
