import os

file = open("ola.txt","w")

for n in range(1920):
    file.write("0"*8 + "\n")
file.close

