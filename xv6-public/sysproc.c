#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "stat.h"
#include "proc.h"


extern int strcmp(const char *p, const char *q);

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_useradd(void)
{
  char *username;
  char *password;
  if(argstr(0, &username) < 0 || argstr(1, &password) < 0) return -1;
  return useradd(username,password);
}

int
sys_userdel(void)
{
  char *username;
  if(argstr(0, &username) < 0) return -1;
  return userdel(username);
}

int 
sys_chname(void){
  char *username;
  if(argstr(0, &username) < 0) return -1;
  return chname(username);
}


int
sys_chmod(void)
{
  struct inode *ip;
  char *path;
  int mode;

  if(argstr(0, &path) < 0 || argint(1, &mode) < 0)
    return -1;
  
  //ip획득
  begin_op();
  if((ip = namei(path)) == 0) {
	  end_op();
	  return -1;
  }
  ilock(ip);

  //해당할때
  if(!(strcmp(myproc()->owner, "root")) || !(strcmp(myproc()->owner, ip->owner))){
    ip->mode = mode;
    iupdate(ip);
    iunlock(ip);
    end_op();
    return 0;
  }
	iunlock(ip);
	end_op();
	return -1;
}

