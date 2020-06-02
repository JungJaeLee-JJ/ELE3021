// Shell.
#include "types.h"
#include "user.h"
#include "fcntl.h"

// Parsed command representation
#define LIST  1
#define KILL  2
#define EXEC2  3
#define MEMLIMIT  4
#define EXIT  5

#define MAXARGS 3

struct cmd {
  int type;
  //char * cmd_type_string;
  char * first_arg;
  char * second_arg;
};

void panic(char*);
int fork1(void);
int exec_(char *path, char **argv, int stacksize);

int finish = 0;

void
runcmd(struct cmd *cmd)
{
  //명령어가 안들어온 경우
  if(cmd == 0) exit();

  switch(cmd->type){
  default:
    panic("runcmd");

  case LIST:
    list();
    break;

  case KILL:
    //입력 유효 검사
    if(cmd->first_arg == 0) {
        wrong_input();
        exit();
    }
 
    //KILL 명령어 수행
    if(kill(atoi(cmd->first_arg) == 0)){
        printf(2, "KILL SUCCESS !\n");
        wait();
    }
    break;

  case EXEC2:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
        wrong_input();
        exit();
     }
     
    //exec2 명령어 실행
    if(exec2(cmd->first_arg,&(cmd->first_arg),atoi(cmd->second_arg)) != 0){
        printf(2, "EXEC fail!\n");
    }
    break;
    
  case MEMLIMIT:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
        wrong_input();
        exit();
    }

    if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
    }
    else{
        printf(2,"Fail to set Memory Limit\n");
    }
    break;

  case EXIT:
    printf(2,"\n");
    finish = 1;
    exit();
    break;
  }
  exit();
}


int
getcmd(char *buf, int nbuf)
{
  printf(2, "> ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
    exit();
}


int
exec_(char *path, char **argv, int stacksize)
{
  int pid;

  pid = exec2(path,argv,stacksize);
  if(pid == -1)
    panic("exec2");
  return pid;
}

void
panic(char *s)
{
  printf(2, "%s\n", s);
  exit();
}

int
fork1(void)
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}


int
main(void)
{
  static char buf[100];
  int fd;
  int  isadmin;
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
       printf(2, "Authentication Failure : Wrong Password\n");
       exit();
  }
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
      break;
    }
  }
  

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(fork1() == 0) runcmd(parsing(buf));
    if(finish == 1) break;
  }
  exit();
}



struct cmd*
parsing(char *s)
{
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
  //command->cmd_type_string = malloc(sizeof(char)*100);
  //command->first_arg = malloc(sizeof(char)*100);
  //command->second_arg = malloc(sizeof(char)*100);
  
  //초기화
  memset(command,0,sizeof(*command));
  //memset(command->cmd_type_string,0,sizeof(char)*100);
  memset(command->first_arg,0,sizeof(char)*100);
  memset(command->second_arg,0,sizeof(char)*100);


  int index = 0;

  while(1){
      //띄어쓰기 간격발생
      if(s[index] == ' '){
         //첫번째 인자일 때
         if(command->first_arg == 0){
             command->first_arg = s[index+1];
         }
         //두번째 인자일 때
         else 
         {
             command->second_arg = s[index+1];
         }
      }
      //종료조건
      if(s[index] == '\n') break;
      index++;
  }

  //type 지정
  if( !strcmp(s, "list") ) command->type = 1;
  else if( !strcmp(s, "kill") ) command->type = 2;
  else if( !strcmp(s, "execute") )  command->type = 3;
  else if( !strcmp(s, "memlim") ) command->type = 4;
  else if( !strcmp(s, "exit") ) command->type = 5;
  
  printf(2,"In parse type, argv1, argv2 : %d %s %s\n",command->type, command->first_arg, command->second_arg);
  return command;
}





