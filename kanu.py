import kanu
import sys

result = kanu.all_together_now(sys.argv[1])

file_name = "result.txt"

print(result)

f = open(file_name, "w")
f.write(str(result))
f.close()