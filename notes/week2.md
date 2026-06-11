# Week 2 - Linux Intermediate

Monday: ps, top, kill-management with processes + systemctl-start/stop/status of services

Lessons:
top and ps aux are for monitoring, to see what is taking CPU and RAM
ps aux is snapshot of processes, you use it when u want to see what process is active(wanna find some process), but top is live visualize of process, he is active and every second is refreshing, you see processes live how changing, like cpu and ram(when server is slowing and u wanna see what is problem example)
MiB mem is for ram(when u type top thats in processes, swap is for false ram, when server lose RAM then Linux takes part of disk and make false RAM, stopping crash when u lose RAM, slower then real RAM)
when u press k while u are in top thats for kill process that you wanna kill, with esc you leave that 
reason for killing process is when he is bad for server(example server of some client is slowing, then u type top and see 95% is eating CPU, u see PID then and kill it, to know which process u must sort it by cpu or mem to see), to leave top press q
kill -l- list of all signals, for jobs most important are SIGTERM(15)- request from process to shut down on good way, to finish what he has and then turn off, thats often using in real jobs and SIGKILL(9)-he is killing process brutal when u type, in the moment process dont have choice to finish, use just when SIGTERM doesn't work, so every time u type kill <pid> and then he sends SIGTERM, if dont work then kill -9 <PID>
&- activate process in BACKGROUND, just see prompt on screen
ps aux | grep <process>- to see process 
sleep 1000- command that wait 1000 seconds and dont doing anything(for practice we use), when u type then 1000 is process with real pid and good for practice because can kill easy without problems
process- every program that is executing, can be long or short 
service- special type of process that is working in background,always, automatic is on when boot and system manage him, difference IRL: sleep: process, you execute him, he ends and thats it. sshd-service, working in background, wait connections, restart if fails
Deamon is service that works in background and wait inputs, that Linux call on that way
with systemctl status sshd i see when automate internet bots try to connect my instance because of public, so for production u change port 22 or use security group with just some ports to ssh 
systemctl-for managing services and check status
systemctl restart sshd- to restart sshd(but must sudo first for permissions)

TUESDAY:cron and crontab, write cron job that logging uptime every hour 

Lessons:
cron is Linux scheduler- system that automatic starts commands or scripts in scheduled time(automate, without cron u must manual start things)
to install things on Linux 2 user command yum install <name>(name of packet for cron is cronie)
crontab -l- to see cron jobs
syntax of cron: * * * * *(minute, hour, day in month, month, day in week)
uptime- command to see how long server is working 
>>- add output without deleting old context
crontab -e- opens editor when u write cron jobs

WEDNESDAY: network tools and log analysis

Lessons:
network tools are diagnostic tools(when client says site doesn't work, u must ssh and see does server listen right port, does have connection, dns working or not,..)
ping- command that sends packet to destination and measure how much takes to get back(like throw smth in water and measure time to get in water), bytes-size of packet, address in () is ip of destination, icmp-seq- sequence number of packet, time on end is time that how much he had to get back, when ping doesn't work server doesn't have internet connection and when time is big network is slow
dig- to see do DNS work, if you get domain dns is working, if not then problem is in DNS configuration(for job when client says site doesn't work u first see does dns working with dig)
curl- sends http request from terminal, like browser but without GUI(you check does server is working and answering, you must get html page, if u dont get then software doesn't work, apache example)
ss -tulnp- to see what ports are listening(opened) on your machine(when u install apache is port 80 is open then apache listen if not then not)
sudo journalctl -u name_service -f- | grep <Line> to see live logs and line that u want with grep, what happend, -f is marking new, follows
cloud-init- service that runs first time when instance is creating, give hostnames, SSH keys, bootstrap script if you gave
cloud-init.log have what happend when u started instance
tail -f - for live following /var/log

THURSDAY: Bash scripting, variables, if/else, for + write script that checks does service is up
Lessons: 
if is condition and syntax is:
if [ "$(command)" = "expected_output" ]; then 
  command(statement)
else 
  command(statement)
fi

else+if= elif and elif using just when we have more then 2 situations
else is for all situations that condition is not confirmed, do not need to say that thats recommended
when u stop sshd, if you are in shell that will not sign out you but new consumers cant log in
for-loop that repeating command for some times or for every thing in list, syntax:
for i in 1 2 3; do
 echo $i
done

$()- $ before () is must, because takes output and execute him, without it wont execute

Friday: package management-yum install/remove + set Apache or Nginx on EC2 instance
Lessons:
Apache is web server- software that receives HTTP request and give back web pages to users. When somebody types google.com in browser- web server from google(not Apache in this example but same principle) receives that request and give back HTML web page
packets are programs and libraries installed on system- everything that Linux using to work properly
package manager(yum/dnf) install that packets, update and remove. Like app store, but for server(packet for Apache is httpd)
sudo is too to see what processes are listening on port
localhost means this server where you are, send request to you
with ss -tulnp we check does port is open, if web server(apache example) work and port is not open, then problem is in security groups or firewall on example, because port is like door to service

SATURDAY: Mini-project: bash script for automatic backup directory on S3

Lessons:
u start command with aws in aws and then name of service like s3 and for s3 is mb command to create folder
in s3 u have s3:// prefix
with cron u automate scripts and things to do on schedule
/home/user/..- thats home directory of some user
between ***** in cron jobs need space, * * * * * 
iam role is for communication between aws services
systemctl is just for services, ps aux | grep is for processes classic

