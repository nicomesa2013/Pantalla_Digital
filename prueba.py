import os

file = open("inicial.txt","w")

for n in range(19200):
    file.write("0"*8 + "\n")
file.close

