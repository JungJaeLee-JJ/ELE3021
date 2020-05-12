#include "types.h"
#include "stat.h"
#include "user.h"

int 
main(int argc , char* argv[])
{
	printf(1,"pid\t: %d\n",getpid());
	printf(1,"ppid\t: %d\n",getppid());
	exit();
}
