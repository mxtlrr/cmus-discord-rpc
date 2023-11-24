from pypresence import Presence
import time, subprocess

# Check if CMUS is open
f = __import__("os").system("pidof cmus")
if f != 0:
  print("CMUS is not running! Bye.")
  exit(2)

client_id = 1177691132185018418
RPC = Presence(client_id)
RPC.connect()

while True:
  # get values
  song = subprocess.check_output("./get.sh song", shell=True).decode("utf-8")
  author = subprocess.check_output("./get.sh author", shell=True).decode("utf-8")
  duration = subprocess.check_output("./get.sh duration", shell=True).decode("utf-8")
  
  ## update the rich presence
  RPC.update(details=f"{song} by {author}",
            state=f"{duration}")
  time.sleep(1) # wait one second