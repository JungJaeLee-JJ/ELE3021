
_pmanager:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}


int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 10             	sub    $0x10,%esp
  static char buf[100];
  int fd;
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
  11:	68 e2 0c 00 00       	push   $0xce2
  16:	e8 5f 08 00 00       	call   87a <getadmin>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	83 f8 ff             	cmp    $0xffffffff,%eax
  21:	0f 84 86 00 00 00    	je     ad <main+0xad>
       printf(2, "Authentication Failure : Wrong Password\n");
       exit();
  }
  printf(2, "[Process Manager] \n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 ed 0c 00 00       	push   $0xced
  2f:	6a 02                	push   $0x2
  31:	e8 0a 09 00 00       	call   940 <printf>

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  36:	83 c4 10             	add    $0x10,%esp
  39:	eb 0a                	jmp    45 <main+0x45>
  3b:	90                   	nop
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
  40:	83 f8 02             	cmp    $0x2,%eax
  43:	7f 5a                	jg     9f <main+0x9f>
       exit();
  }
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  45:	83 ec 08             	sub    $0x8,%esp
  48:	6a 02                	push   $0x2
  4a:	68 01 0d 00 00       	push   $0xd01
  4f:	e8 ae 07 00 00       	call   802 <open>
  54:	83 c4 10             	add    $0x10,%esp
  57:	85 c0                	test   %eax,%eax
  59:	79 e5                	jns    40 <main+0x40>
  5b:	a1 80 11 00 00       	mov    0x1180,%eax
  60:	eb 34                	jmp    96 <main+0x96>
  62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  68:	83 ec 08             	sub    $0x8,%esp
  6b:	6a 64                	push   $0x64
  6d:	68 a0 11 00 00       	push   $0x11a0
  72:	e8 79 00 00 00       	call   f0 <getcmd>
  77:	83 c4 10             	add    $0x10,%esp
  7a:	85 c0                	test   %eax,%eax
  7c:	78 1c                	js     9a <main+0x9a>
int
fork1(void)
{
  int pid;

  pid = fork();
  7e:	e8 37 07 00 00       	call   7ba <fork>
  if(pid == -1)
  83:	83 f8 ff             	cmp    $0xffffffff,%eax
  86:	74 38                	je     c0 <main+0xc0>
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
    if(fork1() == 0) runcmd(parsing(buf));
  88:	85 c0                	test   %eax,%eax
  8a:	74 41                	je     cd <main+0xcd>
    if(finish == 1) break;
  8c:	a1 80 11 00 00       	mov    0x1180,%eax
  91:	83 f8 01             	cmp    $0x1,%eax
  94:	74 04                	je     9a <main+0x9a>
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  96:	85 c0                	test   %eax,%eax
  98:	74 ce                	je     68 <main+0x68>
    if(fork1() == 0) runcmd(parsing(buf));
    if(finish == 1) break;
  }
  exit();
  9a:	e8 23 07 00 00       	call   7c2 <exit>
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
  9f:	83 ec 0c             	sub    $0xc,%esp
  a2:	50                   	push   %eax
  a3:	e8 42 07 00 00       	call   7ea <close>
      break;
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	eb ae                	jmp    5b <main+0x5b>
  static char buf[100];
  int fd;
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
       printf(2, "Authentication Failure : Wrong Password\n");
  ad:	50                   	push   %eax
  ae:	50                   	push   %eax
  af:	68 6c 0d 00 00       	push   $0xd6c
  b4:	6a 02                	push   $0x2
  b6:	e8 85 08 00 00       	call   940 <printf>
       exit();
  bb:	e8 02 07 00 00       	call   7c2 <exit>
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	68 bf 0c 00 00       	push   $0xcbf
  c8:	e8 93 00 00 00       	call   160 <panic>
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
    if(fork1() == 0) runcmd(parsing(buf));
  cd:	83 ec 0c             	sub    $0xc,%esp
  d0:	68 a0 11 00 00       	push   $0x11a0
  d5:	e8 a6 02 00 00       	call   380 <parsing>
  da:	89 04 24             	mov    %eax,(%esp)
  dd:	e8 9e 00 00 00       	call   180 <runcmd>
  e2:	66 90                	xchg   %ax,%ax
  e4:	66 90                	xchg   %ax,%ax
  e6:	66 90                	xchg   %ax,%ax
  e8:	66 90                	xchg   %ax,%ax
  ea:	66 90                	xchg   %ax,%ax
  ec:	66 90                	xchg   %ax,%ax
  ee:	66 90                	xchg   %ax,%ax

000000f0 <getcmd>:
}


int
getcmd(char *buf, int nbuf)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "> ");
  fb:	83 ec 08             	sub    $0x8,%esp
  fe:	68 60 0c 00 00       	push   $0xc60
 103:	6a 02                	push   $0x2
 105:	e8 36 08 00 00       	call   940 <printf>
  memset(buf, 0, nbuf);
 10a:	83 c4 0c             	add    $0xc,%esp
 10d:	56                   	push   %esi
 10e:	6a 00                	push   $0x0
 110:	53                   	push   %ebx
 111:	e8 1a 05 00 00       	call   630 <memset>
  gets(buf, nbuf);
 116:	58                   	pop    %eax
 117:	5a                   	pop    %edx
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	e8 71 05 00 00       	call   690 <gets>
 11f:	83 c4 10             	add    $0x10,%esp
 122:	31 c0                	xor    %eax,%eax
 124:	80 3b 00             	cmpb   $0x0,(%ebx)
 127:	0f 94 c0             	sete   %al
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
 12a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 12d:	f7 d8                	neg    %eax
 12f:	5b                   	pop    %ebx
 130:	5e                   	pop    %esi
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    
 133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <wrong_input>:

void 
wrong_input()
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	83 ec 10             	sub    $0x10,%esp
    printf(2, "It is Wrong input. \n");
 146:	68 63 0c 00 00       	push   $0xc63
 14b:	6a 02                	push   $0x2
 14d:	e8 ee 07 00 00       	call   940 <printf>
    exit();
 152:	e8 6b 06 00 00       	call   7c2 <exit>
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <panic>:
  return pid;
}

void
panic(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 166:	ff 75 08             	pushl  0x8(%ebp)
 169:	68 78 0c 00 00       	push   $0xc78
 16e:	6a 02                	push   $0x2
 170:	e8 cb 07 00 00       	call   940 <printf>
  exit();
 175:	e8 48 06 00 00       	call   7c2 <exit>
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000180 <runcmd>:

int finish = 0;

void
runcmd(struct cmd *cmd)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	56                   	push   %esi
 184:	53                   	push   %ebx
 185:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //명령어가 안들어온 경우
  if(cmd == 0) exit();
 188:	85 db                	test   %ebx,%ebx
 18a:	74 76                	je     202 <runcmd+0x82>

  switch(cmd->type){
 18c:	83 3b 05             	cmpl   $0x5,(%ebx)
 18f:	0f 87 20 01 00 00    	ja     2b5 <runcmd+0x135>
 195:	8b 03                	mov    (%ebx),%eax
 197:	ff 24 85 98 0d 00 00 	jmp    *0xd98(,%eax,4)
    }
    break;
    
  case MEMLIMIT:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
 19e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
 1a2:	0f 84 1a 01 00 00    	je     2c2 <runcmd+0x142>
 1a8:	8b 43 08             	mov    0x8(%ebx),%eax
 1ab:	85 c0                	test   %eax,%eax
 1ad:	0f 84 0f 01 00 00    	je     2c2 <runcmd+0x142>
        wrong_input();
        exit();
    }

    if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
 1b3:	83 ec 0c             	sub    $0xc,%esp
 1b6:	50                   	push   %eax
 1b7:	e8 94 05 00 00       	call   750 <atoi>
 1bc:	89 c6                	mov    %eax,%esi
 1be:	58                   	pop    %eax
 1bf:	ff 73 04             	pushl  0x4(%ebx)
 1c2:	e8 89 05 00 00       	call   750 <atoi>
 1c7:	5a                   	pop    %edx
 1c8:	59                   	pop    %ecx
 1c9:	56                   	push   %esi
 1ca:	50                   	push   %eax
 1cb:	e8 ba 06 00 00       	call   88a <setmemorylimit>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	85 c0                	test   %eax,%eax
 1d5:	0f 85 ec 00 00 00    	jne    2c7 <runcmd+0x147>
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
 1db:	83 ec 0c             	sub    $0xc,%esp
 1de:	ff 73 08             	pushl  0x8(%ebx)
 1e1:	e8 6a 05 00 00       	call   750 <atoi>
 1e6:	59                   	pop    %ecx
 1e7:	ff 73 04             	pushl  0x4(%ebx)
 1ea:	89 c6                	mov    %eax,%esi
 1ec:	e8 5f 05 00 00       	call   750 <atoi>
 1f1:	56                   	push   %esi
 1f2:	50                   	push   %eax
 1f3:	68 0c 0d 00 00       	push   $0xd0c
 1f8:	6a 02                	push   $0x2
 1fa:	e8 41 07 00 00       	call   940 <printf>
 1ff:	83 c4 20             	add    $0x20,%esp

void
runcmd(struct cmd *cmd)
{
  //명령어가 안들어온 경우
  if(cmd == 0) exit();
 202:	e8 bb 05 00 00       	call   7c2 <exit>
        printf(2,"Fail to set Memory Limit\n");
    }
    break;

  case EXIT:
    printf(2,"\n");
 207:	50                   	push   %eax
 208:	50                   	push   %eax
 209:	68 76 0c 00 00       	push   $0xc76
 20e:	6a 02                	push   $0x2
 210:	e8 2b 07 00 00       	call   940 <printf>
    finish = 1;
 215:	c7 05 80 11 00 00 01 	movl   $0x1,0x1180
 21c:	00 00 00 
    exit();
 21f:	e8 9e 05 00 00       	call   7c2 <exit>
  switch(cmd->type){
  default:
    panic("runcmd");

  case LIST:
    list();
 224:	e8 69 06 00 00       	call   892 <list>
    break;
 229:	eb d7                	jmp    202 <runcmd+0x82>

  case KILL:
    //입력 유효 검사
    if(cmd->first_arg == 0) {
 22b:	8b 43 04             	mov    0x4(%ebx),%eax
 22e:	85 c0                	test   %eax,%eax
 230:	0f 84 8c 00 00 00    	je     2c2 <runcmd+0x142>
        wrong_input();
        exit();
    }
 
    //KILL 명령어 수행
    if(kill(atoi(cmd->first_arg) == 0)){
 236:	83 ec 0c             	sub    $0xc,%esp
 239:	50                   	push   %eax
 23a:	e8 11 05 00 00       	call   750 <atoi>
 23f:	85 c0                	test   %eax,%eax
 241:	0f 94 c0             	sete   %al
 244:	0f b6 c0             	movzbl %al,%eax
 247:	89 04 24             	mov    %eax,(%esp)
 24a:	e8 a3 05 00 00       	call   7f2 <kill>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	85 c0                	test   %eax,%eax
 254:	74 ac                	je     202 <runcmd+0x82>
        printf(2, "KILL SUCCESS !\n");
 256:	56                   	push   %esi
 257:	56                   	push   %esi
 258:	68 83 0c 00 00       	push   $0xc83
 25d:	6a 02                	push   $0x2
 25f:	e8 dc 06 00 00       	call   940 <printf>
        wait();
 264:	e8 61 05 00 00       	call   7ca <wait>
 269:	83 c4 10             	add    $0x10,%esp
 26c:	eb 94                	jmp    202 <runcmd+0x82>
    }
    break;

  case EXEC2:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
 26e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
 272:	74 4e                	je     2c2 <runcmd+0x142>
 274:	8b 43 08             	mov    0x8(%ebx),%eax
 277:	85 c0                	test   %eax,%eax
 279:	74 47                	je     2c2 <runcmd+0x142>
        wrong_input();
        exit();
     }
     
    //exec2 명령어 실행
    if(exec2(cmd->first_arg,&(cmd->first_arg),atoi(cmd->second_arg)) != 0){
 27b:	83 ec 0c             	sub    $0xc,%esp
 27e:	50                   	push   %eax
 27f:	e8 cc 04 00 00       	call   750 <atoi>
 284:	83 c4 0c             	add    $0xc,%esp
 287:	50                   	push   %eax
 288:	8d 43 04             	lea    0x4(%ebx),%eax
 28b:	50                   	push   %eax
 28c:	ff 73 04             	pushl  0x4(%ebx)
 28f:	e8 ee 05 00 00       	call   882 <exec2>
 294:	83 c4 10             	add    $0x10,%esp
 297:	85 c0                	test   %eax,%eax
 299:	0f 84 63 ff ff ff    	je     202 <runcmd+0x82>
        printf(2, "EXEC fail!\n");
 29f:	53                   	push   %ebx
 2a0:	53                   	push   %ebx
 2a1:	68 93 0c 00 00       	push   $0xc93
 2a6:	6a 02                	push   $0x2
 2a8:	e8 93 06 00 00       	call   940 <printf>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	e9 4d ff ff ff       	jmp    202 <runcmd+0x82>
  //명령어가 안들어온 경우
  if(cmd == 0) exit();

  switch(cmd->type){
  default:
    panic("runcmd");
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	68 7c 0c 00 00       	push   $0xc7c
 2bd:	e8 9e fe ff ff       	call   160 <panic>
    break;

  case KILL:
    //입력 유효 검사
    if(cmd->first_arg == 0) {
        wrong_input();
 2c2:	e8 79 fe ff ff       	call   140 <wrong_input>

    if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
    }
    else{
        printf(2,"Fail to set Memory Limit\n");
 2c7:	52                   	push   %edx
 2c8:	52                   	push   %edx
 2c9:	68 9f 0c 00 00       	push   $0xc9f
 2ce:	6a 02                	push   $0x2
 2d0:	e8 6b 06 00 00       	call   940 <printf>
 2d5:	83 c4 10             	add    $0x10,%esp
 2d8:	e9 25 ff ff ff       	jmp    202 <runcmd+0x82>
 2dd:	8d 76 00             	lea    0x0(%esi),%esi

000002e0 <exec_>:
}


int
exec_(char *path, char **argv, int stacksize)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 0c             	sub    $0xc,%esp
  int pid;

  pid = exec2(path,argv,stacksize);
 2e6:	ff 75 10             	pushl  0x10(%ebp)
 2e9:	ff 75 0c             	pushl  0xc(%ebp)
 2ec:	ff 75 08             	pushl  0x8(%ebp)
 2ef:	e8 8e 05 00 00       	call   882 <exec2>
  if(pid == -1)
 2f4:	83 c4 10             	add    $0x10,%esp
 2f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 2fa:	74 02                	je     2fe <exec_+0x1e>
    panic("exec2");
  return pid;
}
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    
{
  int pid;

  pid = exec2(path,argv,stacksize);
  if(pid == -1)
    panic("exec2");
 2fe:	83 ec 0c             	sub    $0xc,%esp
 301:	68 b9 0c 00 00       	push   $0xcb9
 306:	e8 55 fe ff ff       	call   160 <panic>
 30b:	90                   	nop
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <fork1>:
  exit();
}

int
fork1(void)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
 316:	e8 9f 04 00 00       	call   7ba <fork>
  if(pid == -1)
 31b:	83 f8 ff             	cmp    $0xffffffff,%eax
 31e:	74 02                	je     322 <fork1+0x12>
    panic("fork");
  return pid;
}
 320:	c9                   	leave  
 321:	c3                   	ret    
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
 322:	83 ec 0c             	sub    $0xc,%esp
 325:	68 bf 0c 00 00       	push   $0xcbf
 32a:	e8 31 fe ff ff       	call   160 <panic>
 32f:	90                   	nop

00000330 <remove_trash>:
  }
  exit();
}

char* remove_trash(char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	8b 45 08             	mov    0x8(%ebp),%eax
	char * os = s;
	while(1){
		if(*os=='\n'){
 336:	0f b6 10             	movzbl (%eax),%edx
 339:	80 fa 0a             	cmp    $0xa,%dl
 33c:	74 31                	je     36f <remove_trash+0x3f>
 33e:	89 c1                	mov    %eax,%ecx
 340:	eb 18                	jmp    35a <remove_trash+0x2a>
 342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			os=0;
			break;
		}
		else if(*os == ' ') os=0;	
		else if (*os==0) break;
 348:	84 d2                	test   %dl,%dl
 34a:	74 23                	je     36f <remove_trash+0x3f>
 34c:	89 ca                	mov    %ecx,%edx
 34e:	83 c1 01             	add    $0x1,%ecx

char* remove_trash(char *s)
{
	char * os = s;
	while(1){
		if(*os=='\n'){
 351:	0f b6 52 01          	movzbl 0x1(%edx),%edx
 355:	80 fa 0a             	cmp    $0xa,%dl
 358:	74 15                	je     36f <remove_trash+0x3f>
			os=0;
			break;
		}
		else if(*os == ' ') os=0;	
 35a:	80 fa 20             	cmp    $0x20,%dl
 35d:	75 e9                	jne    348 <remove_trash+0x18>
 35f:	31 d2                	xor    %edx,%edx
 361:	b9 01 00 00 00       	mov    $0x1,%ecx

char* remove_trash(char *s)
{
	char * os = s;
	while(1){
		if(*os=='\n'){
 366:	0f b6 52 01          	movzbl 0x1(%edx),%edx
 36a:	80 fa 0a             	cmp    $0xa,%dl
 36d:	75 eb                	jne    35a <remove_trash+0x2a>
		else if(*os == ' ') os=0;	
		else if (*os==0) break;
		os++;
	}
	return s;
}
 36f:	5d                   	pop    %ebp
 370:	c3                   	ret    
 371:	eb 0d                	jmp    380 <parsing>
 373:	90                   	nop
 374:	90                   	nop
 375:	90                   	nop
 376:	90                   	nop
 377:	90                   	nop
 378:	90                   	nop
 379:	90                   	nop
 37a:	90                   	nop
 37b:	90                   	nop
 37c:	90                   	nop
 37d:	90                   	nop
 37e:	90                   	nop
 37f:	90                   	nop

00000380 <parsing>:

struct cmd*
parsing(char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
 388:	83 ec 0c             	sub    $0xc,%esp
 38b:	6a 0c                	push   $0xc
 38d:	e8 de 07 00 00       	call   b70 <malloc>
  //command->cmd_type_string = malloc(sizeof(char)*100);
  //command->first_arg = malloc(sizeof(char)*100);
  //command->second_arg = malloc(sizeof(char)*100);
  
  //초기화
  memset(command,0,sizeof(*command));
 392:	83 c4 0c             	add    $0xc,%esp
{
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
 395:	89 c6                	mov    %eax,%esi
  //command->cmd_type_string = malloc(sizeof(char)*100);
  //command->first_arg = malloc(sizeof(char)*100);
  //command->second_arg = malloc(sizeof(char)*100);
  
  //초기화
  memset(command,0,sizeof(*command));
 397:	6a 0c                	push   $0xc
 399:	6a 00                	push   $0x0
 39b:	50                   	push   %eax
 39c:	e8 8f 02 00 00       	call   630 <memset>
  //memset(command->cmd_type_string,0,sizeof(char)*100);
  memset(command->first_arg,0,sizeof(char*));
 3a1:	83 c4 0c             	add    $0xc,%esp
 3a4:	6a 04                	push   $0x4
 3a6:	6a 00                	push   $0x0
 3a8:	ff 76 04             	pushl  0x4(%esi)
 3ab:	e8 80 02 00 00       	call   630 <memset>
  memset(command->second_arg,0,sizeof(char*));
 3b0:	83 c4 0c             	add    $0xc,%esp
 3b3:	6a 04                	push   $0x4
 3b5:	6a 00                	push   $0x0
 3b7:	ff 76 08             	pushl  0x8(%esi)
 3ba:	e8 71 02 00 00       	call   630 <memset>
 3bf:	8d 43 01             	lea    0x1(%ebx),%eax
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	eb 11                	jmp    3d8 <parsing+0x58>
 3c7:	89 f6                	mov    %esi,%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 3d0:	83 c0 01             	add    $0x1,%eax
         {
             command->second_arg = &s[index+1];
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 3d3:	80 fa 0a             	cmp    $0xa,%dl
 3d6:	74 23                	je     3fb <parsing+0x7b>
  int index = 0;

  while(1){
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
 3d8:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 3dc:	80 fa 20             	cmp    $0x20,%dl
 3df:	75 ef                	jne    3d0 <parsing+0x50>
         //첫번째 인자일 때
         if(command->first_arg == 0){
 3e1:	8b 56 04             	mov    0x4(%esi),%edx
 3e4:	85 d2                	test   %edx,%edx
 3e6:	0f 84 94 00 00 00    	je     480 <parsing+0x100>
             command->first_arg = &s[index+1];
         }
         //두번째 인자일 때
         else 
         {
             command->second_arg = &s[index+1];
 3ec:	89 46 08             	mov    %eax,0x8(%esi)
 3ef:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 3f3:	83 c0 01             	add    $0x1,%eax
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 3f6:	80 fa 0a             	cmp    $0xa,%dl
 3f9:	75 dd                	jne    3d8 <parsing+0x58>

char* remove_trash(char *s)
{
	char * os = s;
	while(1){
		if(*os=='\n'){
 3fb:	0f b6 03             	movzbl (%ebx),%eax
 3fe:	3c 0a                	cmp    $0xa,%al
 400:	74 36                	je     438 <parsing+0xb8>
 402:	89 da                	mov    %ebx,%edx
 404:	eb 1b                	jmp    421 <parsing+0xa1>
 406:	8d 76 00             	lea    0x0(%esi),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			os=0;
			break;
		}
		else if(*os == ' ') os=0;	
		else if (*os==0) break;
 410:	84 c0                	test   %al,%al
 412:	74 24                	je     438 <parsing+0xb8>
 414:	89 d0                	mov    %edx,%eax
 416:	83 c2 01             	add    $0x1,%edx

char* remove_trash(char *s)
{
	char * os = s;
	while(1){
		if(*os=='\n'){
 419:	0f b6 40 01          	movzbl 0x1(%eax),%eax
 41d:	3c 0a                	cmp    $0xa,%al
 41f:	74 17                	je     438 <parsing+0xb8>
			os=0;
			break;
		}
		else if(*os == ' ') os=0;	
 421:	3c 20                	cmp    $0x20,%al
 423:	75 eb                	jne    410 <parsing+0x90>
 425:	31 c0                	xor    %eax,%eax
 427:	ba 01 00 00 00       	mov    $0x1,%edx

char* remove_trash(char *s)
{
	char * os = s;
	while(1){
		if(*os=='\n'){
 42c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
 430:	3c 0a                	cmp    $0xa,%al
 432:	75 ed                	jne    421 <parsing+0xa1>
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
	
  s = remove_trash(s);
  
  //type 지정
  if( !strcmp(s, "list") ) command->type = 1;
 438:	83 ec 08             	sub    $0x8,%esp
 43b:	68 c4 0c 00 00       	push   $0xcc4
 440:	53                   	push   %ebx
 441:	e8 1a 01 00 00       	call   560 <strcmp>
 446:	83 c4 10             	add    $0x10,%esp
 449:	85 c0                	test   %eax,%eax
 44b:	75 43                	jne    490 <parsing+0x110>
 44d:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
 453:	b8 01 00 00 00       	mov    $0x1,%eax
  else if( !strcmp(s, "kill") ) command->type = 2;
  else if( !strcmp(s, "execute") )  command->type = 3;
  else if( !strcmp(s, "memlim") ) command->type = 4;
  else if( !strcmp(s, "exit") ) command->type = 5;
  
  printf(2,"In parse type, argv1, argv2 : %d %s %s\n",command->type, command->first_arg, command->second_arg);
 458:	83 ec 0c             	sub    $0xc,%esp
 45b:	ff 76 08             	pushl  0x8(%esi)
 45e:	ff 76 04             	pushl  0x4(%esi)
 461:	50                   	push   %eax
 462:	68 44 0d 00 00       	push   $0xd44
 467:	6a 02                	push   $0x2
 469:	e8 d2 04 00 00       	call   940 <printf>
  return command;
}
 46e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 471:	89 f0                	mov    %esi,%eax
 473:	5b                   	pop    %ebx
 474:	5e                   	pop    %esi
 475:	5d                   	pop    %ebp
 476:	c3                   	ret    
 477:	89 f6                	mov    %esi,%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
         //첫번째 인자일 때
         if(command->first_arg == 0){
             command->first_arg = &s[index+1];
 480:	89 46 04             	mov    %eax,0x4(%esi)
 483:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 487:	e9 44 ff ff ff       	jmp    3d0 <parsing+0x50>
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	
  s = remove_trash(s);
  
  //type 지정
  if( !strcmp(s, "list") ) command->type = 1;
  else if( !strcmp(s, "kill") ) command->type = 2;
 490:	83 ec 08             	sub    $0x8,%esp
 493:	68 c9 0c 00 00       	push   $0xcc9
 498:	53                   	push   %ebx
 499:	e8 c2 00 00 00       	call   560 <strcmp>
 49e:	83 c4 10             	add    $0x10,%esp
 4a1:	85 c0                	test   %eax,%eax
 4a3:	75 13                	jne    4b8 <parsing+0x138>
 4a5:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
 4ab:	b8 02 00 00 00       	mov    $0x2,%eax
 4b0:	eb a6                	jmp    458 <parsing+0xd8>
 4b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if( !strcmp(s, "execute") )  command->type = 3;
 4b8:	83 ec 08             	sub    $0x8,%esp
 4bb:	68 ce 0c 00 00       	push   $0xcce
 4c0:	53                   	push   %ebx
 4c1:	e8 9a 00 00 00       	call   560 <strcmp>
 4c6:	83 c4 10             	add    $0x10,%esp
 4c9:	85 c0                	test   %eax,%eax
 4cb:	75 10                	jne    4dd <parsing+0x15d>
 4cd:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
 4d3:	b8 03 00 00 00       	mov    $0x3,%eax
 4d8:	e9 7b ff ff ff       	jmp    458 <parsing+0xd8>
  else if( !strcmp(s, "memlim") ) command->type = 4;
 4dd:	83 ec 08             	sub    $0x8,%esp
 4e0:	68 d6 0c 00 00       	push   $0xcd6
 4e5:	53                   	push   %ebx
 4e6:	e8 75 00 00 00       	call   560 <strcmp>
 4eb:	83 c4 10             	add    $0x10,%esp
 4ee:	85 c0                	test   %eax,%eax
 4f0:	75 10                	jne    502 <parsing+0x182>
 4f2:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
 4f8:	b8 04 00 00 00       	mov    $0x4,%eax
 4fd:	e9 56 ff ff ff       	jmp    458 <parsing+0xd8>
  else if( !strcmp(s, "exit") ) command->type = 5;
 502:	83 ec 08             	sub    $0x8,%esp
 505:	68 dd 0c 00 00       	push   $0xcdd
 50a:	53                   	push   %ebx
 50b:	e8 50 00 00 00       	call   560 <strcmp>
 510:	83 c4 10             	add    $0x10,%esp
 513:	85 c0                	test   %eax,%eax
 515:	75 10                	jne    527 <parsing+0x1a7>
 517:	c7 06 05 00 00 00    	movl   $0x5,(%esi)
 51d:	b8 05 00 00 00       	mov    $0x5,%eax
 522:	e9 31 ff ff ff       	jmp    458 <parsing+0xd8>
 527:	8b 06                	mov    (%esi),%eax
 529:	e9 2a ff ff ff       	jmp    458 <parsing+0xd8>
 52e:	66 90                	xchg   %ax,%ax

00000530 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	53                   	push   %ebx
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 53a:	89 c2                	mov    %eax,%edx
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 540:	83 c1 01             	add    $0x1,%ecx
 543:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 547:	83 c2 01             	add    $0x1,%edx
 54a:	84 db                	test   %bl,%bl
 54c:	88 5a ff             	mov    %bl,-0x1(%edx)
 54f:	75 ef                	jne    540 <strcpy+0x10>
    ;
  return os;
}
 551:	5b                   	pop    %ebx
 552:	5d                   	pop    %ebp
 553:	c3                   	ret    
 554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 55a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000560 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 0c             	sub    $0xc,%esp
 569:	8b 5d 08             	mov    0x8(%ebp),%ebx
 56c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q){
 56f:	0f be 03             	movsbl (%ebx),%eax
 572:	0f be 16             	movsbl (%esi),%edx
 575:	84 c0                	test   %al,%al
 577:	74 76                	je     5ef <strcmp+0x8f>
 579:	38 c2                	cmp    %al,%dl
 57b:	89 f7                	mov    %esi,%edi
 57d:	74 0f                	je     58e <strcmp+0x2e>
 57f:	eb 38                	jmp    5b9 <strcmp+0x59>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	38 d0                	cmp    %dl,%al
 58a:	89 fe                	mov    %edi,%esi
 58c:	75 2b                	jne    5b9 <strcmp+0x59>
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
 58e:	0f be 46 01          	movsbl 0x1(%esi),%eax

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
    p++, q++;
 592:	83 c3 01             	add    $0x1,%ebx
 595:	8d 7e 01             	lea    0x1(%esi),%edi
	printf(2,"%c %c\n",*p,*q );
 598:	50                   	push   %eax
 599:	0f be 03             	movsbl (%ebx),%eax
 59c:	50                   	push   %eax
 59d:	68 b0 0d 00 00       	push   $0xdb0
 5a2:	6a 02                	push   $0x2
 5a4:	e8 97 03 00 00       	call   940 <printf>
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 5a9:	0f be 03             	movsbl (%ebx),%eax
 5ac:	83 c4 10             	add    $0x10,%esp
 5af:	0f be 56 01          	movsbl 0x1(%esi),%edx
 5b3:	84 c0                	test   %al,%al
 5b5:	75 d1                	jne    588 <strcmp+0x28>
 5b7:	31 c0                	xor    %eax,%eax
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
 5b9:	52                   	push   %edx
 5ba:	50                   	push   %eax
 5bb:	68 b7 0d 00 00       	push   $0xdb7
 5c0:	6a 02                	push   $0x2
 5c2:	e8 79 03 00 00       	call   940 <printf>
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
 5c7:	0f b6 17             	movzbl (%edi),%edx
 5ca:	0f b6 03             	movzbl (%ebx),%eax
 5cd:	83 c4 0c             	add    $0xc,%esp
 5d0:	29 d0                	sub    %edx,%eax
 5d2:	50                   	push   %eax
 5d3:	68 ba 0d 00 00       	push   $0xdba
 5d8:	6a 02                	push   $0x2
 5da:	e8 61 03 00 00       	call   940 <printf>
  return (uchar)*p - (uchar)*q;
 5df:	0f b6 03             	movzbl (%ebx),%eax
 5e2:	0f b6 17             	movzbl (%edi),%edx
}
 5e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e8:	5b                   	pop    %ebx
 5e9:	5e                   	pop    %esi
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 5ea:	29 d0                	sub    %edx,%eax
}
 5ec:	5f                   	pop    %edi
 5ed:	5d                   	pop    %ebp
 5ee:	c3                   	ret    
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 5ef:	89 f7                	mov    %esi,%edi
 5f1:	31 c0                	xor    %eax,%eax
 5f3:	eb c4                	jmp    5b9 <strcmp+0x59>
 5f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000600 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 606:	80 39 00             	cmpb   $0x0,(%ecx)
 609:	74 12                	je     61d <strlen+0x1d>
 60b:	31 d2                	xor    %edx,%edx
 60d:	8d 76 00             	lea    0x0(%esi),%esi
 610:	83 c2 01             	add    $0x1,%edx
 613:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 617:	89 d0                	mov    %edx,%eax
 619:	75 f5                	jne    610 <strlen+0x10>
    ;
  return n;
}
 61b:	5d                   	pop    %ebp
 61c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 61d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 61f:	5d                   	pop    %ebp
 620:	c3                   	ret    
 621:	eb 0d                	jmp    630 <memset>
 623:	90                   	nop
 624:	90                   	nop
 625:	90                   	nop
 626:	90                   	nop
 627:	90                   	nop
 628:	90                   	nop
 629:	90                   	nop
 62a:	90                   	nop
 62b:	90                   	nop
 62c:	90                   	nop
 62d:	90                   	nop
 62e:	90                   	nop
 62f:	90                   	nop

00000630 <memset>:

void*
memset(void *dst, int c, uint n)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 637:	8b 4d 10             	mov    0x10(%ebp),%ecx
 63a:	8b 45 0c             	mov    0xc(%ebp),%eax
 63d:	89 d7                	mov    %edx,%edi
 63f:	fc                   	cld    
 640:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 642:	89 d0                	mov    %edx,%eax
 644:	5f                   	pop    %edi
 645:	5d                   	pop    %ebp
 646:	c3                   	ret    
 647:	89 f6                	mov    %esi,%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000650 <strchr>:

char*
strchr(const char *s, char c)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	53                   	push   %ebx
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 65a:	0f b6 10             	movzbl (%eax),%edx
 65d:	84 d2                	test   %dl,%dl
 65f:	74 1d                	je     67e <strchr+0x2e>
    if(*s == c)
 661:	38 d3                	cmp    %dl,%bl
 663:	89 d9                	mov    %ebx,%ecx
 665:	75 0d                	jne    674 <strchr+0x24>
 667:	eb 17                	jmp    680 <strchr+0x30>
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 670:	38 ca                	cmp    %cl,%dl
 672:	74 0c                	je     680 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 674:	83 c0 01             	add    $0x1,%eax
 677:	0f b6 10             	movzbl (%eax),%edx
 67a:	84 d2                	test   %dl,%dl
 67c:	75 f2                	jne    670 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 67e:	31 c0                	xor    %eax,%eax
}
 680:	5b                   	pop    %ebx
 681:	5d                   	pop    %ebp
 682:	c3                   	ret    
 683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000690 <gets>:

char*
gets(char *buf, int max)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 696:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 698:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 69b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 69e:	eb 29                	jmp    6c9 <gets+0x39>
    cc = read(0, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
 6a3:	6a 01                	push   $0x1
 6a5:	57                   	push   %edi
 6a6:	6a 00                	push   $0x0
 6a8:	e8 2d 01 00 00       	call   7da <read>
    if(cc < 1)
 6ad:	83 c4 10             	add    $0x10,%esp
 6b0:	85 c0                	test   %eax,%eax
 6b2:	7e 1d                	jle    6d1 <gets+0x41>
      break;
    buf[i++] = c;
 6b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 6b8:	8b 55 08             	mov    0x8(%ebp),%edx
 6bb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 6bd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 6bf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 6c3:	74 1b                	je     6e0 <gets+0x50>
 6c5:	3c 0d                	cmp    $0xd,%al
 6c7:	74 17                	je     6e0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6c9:	8d 5e 01             	lea    0x1(%esi),%ebx
 6cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 6cf:	7c cf                	jl     6a0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6d1:	8b 45 08             	mov    0x8(%ebp),%eax
 6d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 6d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6db:	5b                   	pop    %ebx
 6dc:	5e                   	pop    %esi
 6dd:	5f                   	pop    %edi
 6de:	5d                   	pop    %ebp
 6df:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6e3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 6e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ec:	5b                   	pop    %ebx
 6ed:	5e                   	pop    %esi
 6ee:	5f                   	pop    %edi
 6ef:	5d                   	pop    %ebp
 6f0:	c3                   	ret    
 6f1:	eb 0d                	jmp    700 <stat>
 6f3:	90                   	nop
 6f4:	90                   	nop
 6f5:	90                   	nop
 6f6:	90                   	nop
 6f7:	90                   	nop
 6f8:	90                   	nop
 6f9:	90                   	nop
 6fa:	90                   	nop
 6fb:	90                   	nop
 6fc:	90                   	nop
 6fd:	90                   	nop
 6fe:	90                   	nop
 6ff:	90                   	nop

00000700 <stat>:

int
stat(const char *n, struct stat *st)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	56                   	push   %esi
 704:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 705:	83 ec 08             	sub    $0x8,%esp
 708:	6a 00                	push   $0x0
 70a:	ff 75 08             	pushl  0x8(%ebp)
 70d:	e8 f0 00 00 00       	call   802 <open>
  if(fd < 0)
 712:	83 c4 10             	add    $0x10,%esp
 715:	85 c0                	test   %eax,%eax
 717:	78 27                	js     740 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 719:	83 ec 08             	sub    $0x8,%esp
 71c:	ff 75 0c             	pushl  0xc(%ebp)
 71f:	89 c3                	mov    %eax,%ebx
 721:	50                   	push   %eax
 722:	e8 f3 00 00 00       	call   81a <fstat>
 727:	89 c6                	mov    %eax,%esi
  close(fd);
 729:	89 1c 24             	mov    %ebx,(%esp)
 72c:	e8 b9 00 00 00       	call   7ea <close>
  return r;
 731:	83 c4 10             	add    $0x10,%esp
 734:	89 f0                	mov    %esi,%eax
}
 736:	8d 65 f8             	lea    -0x8(%ebp),%esp
 739:	5b                   	pop    %ebx
 73a:	5e                   	pop    %esi
 73b:	5d                   	pop    %ebp
 73c:	c3                   	ret    
 73d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 745:	eb ef                	jmp    736 <stat+0x36>
 747:	89 f6                	mov    %esi,%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000750 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	53                   	push   %ebx
 754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 757:	0f be 11             	movsbl (%ecx),%edx
 75a:	8d 42 d0             	lea    -0x30(%edx),%eax
 75d:	3c 09                	cmp    $0x9,%al
 75f:	b8 00 00 00 00       	mov    $0x0,%eax
 764:	77 1f                	ja     785 <atoi+0x35>
 766:	8d 76 00             	lea    0x0(%esi),%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 770:	8d 04 80             	lea    (%eax,%eax,4),%eax
 773:	83 c1 01             	add    $0x1,%ecx
 776:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 77a:	0f be 11             	movsbl (%ecx),%edx
 77d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 780:	80 fb 09             	cmp    $0x9,%bl
 783:	76 eb                	jbe    770 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 785:	5b                   	pop    %ebx
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000790 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	56                   	push   %esi
 794:	53                   	push   %ebx
 795:	8b 5d 10             	mov    0x10(%ebp),%ebx
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 79e:	85 db                	test   %ebx,%ebx
 7a0:	7e 14                	jle    7b6 <memmove+0x26>
 7a2:	31 d2                	xor    %edx,%edx
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 7a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 7ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 7af:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7b2:	39 da                	cmp    %ebx,%edx
 7b4:	75 f2                	jne    7a8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 7b6:	5b                   	pop    %ebx
 7b7:	5e                   	pop    %esi
 7b8:	5d                   	pop    %ebp
 7b9:	c3                   	ret    

000007ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7ba:	b8 01 00 00 00       	mov    $0x1,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <exit>:
SYSCALL(exit)
 7c2:	b8 02 00 00 00       	mov    $0x2,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <wait>:
SYSCALL(wait)
 7ca:	b8 03 00 00 00       	mov    $0x3,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <pipe>:
SYSCALL(pipe)
 7d2:	b8 04 00 00 00       	mov    $0x4,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <read>:
SYSCALL(read)
 7da:	b8 05 00 00 00       	mov    $0x5,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <write>:
SYSCALL(write)
 7e2:	b8 10 00 00 00       	mov    $0x10,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <close>:
SYSCALL(close)
 7ea:	b8 15 00 00 00       	mov    $0x15,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <kill>:
SYSCALL(kill)
 7f2:	b8 06 00 00 00       	mov    $0x6,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <exec>:
SYSCALL(exec)
 7fa:	b8 07 00 00 00       	mov    $0x7,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <open>:
SYSCALL(open)
 802:	b8 0f 00 00 00       	mov    $0xf,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <mknod>:
SYSCALL(mknod)
 80a:	b8 11 00 00 00       	mov    $0x11,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <unlink>:
SYSCALL(unlink)
 812:	b8 12 00 00 00       	mov    $0x12,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <fstat>:
SYSCALL(fstat)
 81a:	b8 08 00 00 00       	mov    $0x8,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <link>:
SYSCALL(link)
 822:	b8 13 00 00 00       	mov    $0x13,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <mkdir>:
SYSCALL(mkdir)
 82a:	b8 14 00 00 00       	mov    $0x14,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <chdir>:
SYSCALL(chdir)
 832:	b8 09 00 00 00       	mov    $0x9,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <dup>:
SYSCALL(dup)
 83a:	b8 0a 00 00 00       	mov    $0xa,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <getpid>:
SYSCALL(getpid)
 842:	b8 0b 00 00 00       	mov    $0xb,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <sbrk>:
SYSCALL(sbrk)
 84a:	b8 0c 00 00 00       	mov    $0xc,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <sleep>:
SYSCALL(sleep)
 852:	b8 0d 00 00 00       	mov    $0xd,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <uptime>:
SYSCALL(uptime)
 85a:	b8 0e 00 00 00       	mov    $0xe,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    

00000862 <yield>:
SYSCALL(yield)
 862:	b8 16 00 00 00       	mov    $0x16,%eax
 867:	cd 40                	int    $0x40
 869:	c3                   	ret    

0000086a <getlev>:
SYSCALL(getlev)
 86a:	b8 17 00 00 00       	mov    $0x17,%eax
 86f:	cd 40                	int    $0x40
 871:	c3                   	ret    

00000872 <setpriority>:
SYSCALL(setpriority)
 872:	b8 18 00 00 00       	mov    $0x18,%eax
 877:	cd 40                	int    $0x40
 879:	c3                   	ret    

0000087a <getadmin>:
SYSCALL(getadmin)
 87a:	b8 19 00 00 00       	mov    $0x19,%eax
 87f:	cd 40                	int    $0x40
 881:	c3                   	ret    

00000882 <exec2>:
SYSCALL(exec2)
 882:	b8 1a 00 00 00       	mov    $0x1a,%eax
 887:	cd 40                	int    $0x40
 889:	c3                   	ret    

0000088a <setmemorylimit>:
SYSCALL(setmemorylimit)
 88a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 88f:	cd 40                	int    $0x40
 891:	c3                   	ret    

00000892 <list>:
SYSCALL(list)
 892:	b8 1c 00 00 00       	mov    $0x1c,%eax
 897:	cd 40                	int    $0x40
 899:	c3                   	ret    
 89a:	66 90                	xchg   %ax,%ax
 89c:	66 90                	xchg   %ax,%ax
 89e:	66 90                	xchg   %ax,%ax

000008a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	89 c6                	mov    %eax,%esi
 8a8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8ae:	85 db                	test   %ebx,%ebx
 8b0:	74 7e                	je     930 <printint+0x90>
 8b2:	89 d0                	mov    %edx,%eax
 8b4:	c1 e8 1f             	shr    $0x1f,%eax
 8b7:	84 c0                	test   %al,%al
 8b9:	74 75                	je     930 <printint+0x90>
    neg = 1;
    x = -xx;
 8bb:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 8bd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 8c4:	f7 d8                	neg    %eax
 8c6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 8c9:	31 ff                	xor    %edi,%edi
 8cb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 8ce:	89 ce                	mov    %ecx,%esi
 8d0:	eb 08                	jmp    8da <printint+0x3a>
 8d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 8d8:	89 cf                	mov    %ecx,%edi
 8da:	31 d2                	xor    %edx,%edx
 8dc:	8d 4f 01             	lea    0x1(%edi),%ecx
 8df:	f7 f6                	div    %esi
 8e1:	0f b6 92 c8 0d 00 00 	movzbl 0xdc8(%edx),%edx
  }while((x /= base) != 0);
 8e8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 8ea:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 8ed:	75 e9                	jne    8d8 <printint+0x38>
  if(neg)
 8ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 8f2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 8f5:	85 c0                	test   %eax,%eax
 8f7:	74 08                	je     901 <printint+0x61>
    buf[i++] = '-';
 8f9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 8fe:	8d 4f 02             	lea    0x2(%edi),%ecx
 901:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 905:	8d 76 00             	lea    0x0(%esi),%esi
 908:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 90b:	83 ec 04             	sub    $0x4,%esp
 90e:	83 ef 01             	sub    $0x1,%edi
 911:	6a 01                	push   $0x1
 913:	53                   	push   %ebx
 914:	56                   	push   %esi
 915:	88 45 d7             	mov    %al,-0x29(%ebp)
 918:	e8 c5 fe ff ff       	call   7e2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 91d:	83 c4 10             	add    $0x10,%esp
 920:	39 df                	cmp    %ebx,%edi
 922:	75 e4                	jne    908 <printint+0x68>
    putc(fd, buf[i]);
}
 924:	8d 65 f4             	lea    -0xc(%ebp),%esp
 927:	5b                   	pop    %ebx
 928:	5e                   	pop    %esi
 929:	5f                   	pop    %edi
 92a:	5d                   	pop    %ebp
 92b:	c3                   	ret    
 92c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 930:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 932:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 939:	eb 8b                	jmp    8c6 <printint+0x26>
 93b:	90                   	nop
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000940 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	57                   	push   %edi
 944:	56                   	push   %esi
 945:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 946:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 949:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 94c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 94f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 952:	89 45 d0             	mov    %eax,-0x30(%ebp)
 955:	0f b6 1e             	movzbl (%esi),%ebx
 958:	83 c6 01             	add    $0x1,%esi
 95b:	84 db                	test   %bl,%bl
 95d:	0f 84 b0 00 00 00    	je     a13 <printf+0xd3>
 963:	31 d2                	xor    %edx,%edx
 965:	eb 39                	jmp    9a0 <printf+0x60>
 967:	89 f6                	mov    %esi,%esi
 969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 970:	83 f8 25             	cmp    $0x25,%eax
 973:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 976:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 97b:	74 18                	je     995 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 97d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 980:	83 ec 04             	sub    $0x4,%esp
 983:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 986:	6a 01                	push   $0x1
 988:	50                   	push   %eax
 989:	57                   	push   %edi
 98a:	e8 53 fe ff ff       	call   7e2 <write>
 98f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 992:	83 c4 10             	add    $0x10,%esp
 995:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 998:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 99c:	84 db                	test   %bl,%bl
 99e:	74 73                	je     a13 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 9a0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 9a2:	0f be cb             	movsbl %bl,%ecx
 9a5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 9a8:	74 c6                	je     970 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 9aa:	83 fa 25             	cmp    $0x25,%edx
 9ad:	75 e6                	jne    995 <printf+0x55>
      if(c == 'd'){
 9af:	83 f8 64             	cmp    $0x64,%eax
 9b2:	0f 84 f8 00 00 00    	je     ab0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 9b8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 9be:	83 f9 70             	cmp    $0x70,%ecx
 9c1:	74 5d                	je     a20 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 9c3:	83 f8 73             	cmp    $0x73,%eax
 9c6:	0f 84 84 00 00 00    	je     a50 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9cc:	83 f8 63             	cmp    $0x63,%eax
 9cf:	0f 84 ea 00 00 00    	je     abf <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 9d5:	83 f8 25             	cmp    $0x25,%eax
 9d8:	0f 84 c2 00 00 00    	je     aa0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9de:	8d 45 e7             	lea    -0x19(%ebp),%eax
 9e1:	83 ec 04             	sub    $0x4,%esp
 9e4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9e8:	6a 01                	push   $0x1
 9ea:	50                   	push   %eax
 9eb:	57                   	push   %edi
 9ec:	e8 f1 fd ff ff       	call   7e2 <write>
 9f1:	83 c4 0c             	add    $0xc,%esp
 9f4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 9f7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 9fa:	6a 01                	push   $0x1
 9fc:	50                   	push   %eax
 9fd:	57                   	push   %edi
 9fe:	83 c6 01             	add    $0x1,%esi
 a01:	e8 dc fd ff ff       	call   7e2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a06:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a0a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a0d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a0f:	84 db                	test   %bl,%bl
 a11:	75 8d                	jne    9a0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a16:	5b                   	pop    %ebx
 a17:	5e                   	pop    %esi
 a18:	5f                   	pop    %edi
 a19:	5d                   	pop    %ebp
 a1a:	c3                   	ret    
 a1b:	90                   	nop
 a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 a20:	83 ec 0c             	sub    $0xc,%esp
 a23:	b9 10 00 00 00       	mov    $0x10,%ecx
 a28:	6a 00                	push   $0x0
 a2a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 a2d:	89 f8                	mov    %edi,%eax
 a2f:	8b 13                	mov    (%ebx),%edx
 a31:	e8 6a fe ff ff       	call   8a0 <printint>
        ap++;
 a36:	89 d8                	mov    %ebx,%eax
 a38:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a3b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 a3d:	83 c0 04             	add    $0x4,%eax
 a40:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a43:	e9 4d ff ff ff       	jmp    995 <printf+0x55>
 a48:	90                   	nop
 a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 a50:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a53:	8b 18                	mov    (%eax),%ebx
        ap++;
 a55:	83 c0 04             	add    $0x4,%eax
 a58:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 a5b:	b8 be 0d 00 00       	mov    $0xdbe,%eax
 a60:	85 db                	test   %ebx,%ebx
 a62:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 a65:	0f b6 03             	movzbl (%ebx),%eax
 a68:	84 c0                	test   %al,%al
 a6a:	74 23                	je     a8f <printf+0x14f>
 a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a70:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a73:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 a76:	83 ec 04             	sub    $0x4,%esp
 a79:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 a7b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a7e:	50                   	push   %eax
 a7f:	57                   	push   %edi
 a80:	e8 5d fd ff ff       	call   7e2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a85:	0f b6 03             	movzbl (%ebx),%eax
 a88:	83 c4 10             	add    $0x10,%esp
 a8b:	84 c0                	test   %al,%al
 a8d:	75 e1                	jne    a70 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a8f:	31 d2                	xor    %edx,%edx
 a91:	e9 ff fe ff ff       	jmp    995 <printf+0x55>
 a96:	8d 76 00             	lea    0x0(%esi),%esi
 a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 aa0:	83 ec 04             	sub    $0x4,%esp
 aa3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 aa6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 aa9:	6a 01                	push   $0x1
 aab:	e9 4c ff ff ff       	jmp    9fc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 ab0:	83 ec 0c             	sub    $0xc,%esp
 ab3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 ab8:	6a 01                	push   $0x1
 aba:	e9 6b ff ff ff       	jmp    a2a <printf+0xea>
 abf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 ac2:	83 ec 04             	sub    $0x4,%esp
 ac5:	8b 03                	mov    (%ebx),%eax
 ac7:	6a 01                	push   $0x1
 ac9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 acc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 acf:	50                   	push   %eax
 ad0:	57                   	push   %edi
 ad1:	e8 0c fd ff ff       	call   7e2 <write>
 ad6:	e9 5b ff ff ff       	jmp    a36 <printf+0xf6>
 adb:	66 90                	xchg   %ax,%ax
 add:	66 90                	xchg   %ax,%ax
 adf:	90                   	nop

00000ae0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae1:	a1 04 12 00 00       	mov    0x1204,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae6:	89 e5                	mov    %esp,%ebp
 ae8:	57                   	push   %edi
 ae9:	56                   	push   %esi
 aea:	53                   	push   %ebx
 aeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aee:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 af0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af3:	39 c8                	cmp    %ecx,%eax
 af5:	73 19                	jae    b10 <free+0x30>
 af7:	89 f6                	mov    %esi,%esi
 af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 b00:	39 d1                	cmp    %edx,%ecx
 b02:	72 1c                	jb     b20 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b04:	39 d0                	cmp    %edx,%eax
 b06:	73 18                	jae    b20 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 b08:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b0a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b0c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b0e:	72 f0                	jb     b00 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b10:	39 d0                	cmp    %edx,%eax
 b12:	72 f4                	jb     b08 <free+0x28>
 b14:	39 d1                	cmp    %edx,%ecx
 b16:	73 f0                	jae    b08 <free+0x28>
 b18:	90                   	nop
 b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 b20:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b23:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b26:	39 d7                	cmp    %edx,%edi
 b28:	74 19                	je     b43 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b2a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b2d:	8b 50 04             	mov    0x4(%eax),%edx
 b30:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b33:	39 f1                	cmp    %esi,%ecx
 b35:	74 23                	je     b5a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b37:	89 08                	mov    %ecx,(%eax)
  freep = p;
 b39:	a3 04 12 00 00       	mov    %eax,0x1204
}
 b3e:	5b                   	pop    %ebx
 b3f:	5e                   	pop    %esi
 b40:	5f                   	pop    %edi
 b41:	5d                   	pop    %ebp
 b42:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b43:	03 72 04             	add    0x4(%edx),%esi
 b46:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b49:	8b 10                	mov    (%eax),%edx
 b4b:	8b 12                	mov    (%edx),%edx
 b4d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b50:	8b 50 04             	mov    0x4(%eax),%edx
 b53:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b56:	39 f1                	cmp    %esi,%ecx
 b58:	75 dd                	jne    b37 <free+0x57>
    p->s.size += bp->s.size;
 b5a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 b5d:	a3 04 12 00 00       	mov    %eax,0x1204
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b62:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b65:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b68:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 b6a:	5b                   	pop    %ebx
 b6b:	5e                   	pop    %esi
 b6c:	5f                   	pop    %edi
 b6d:	5d                   	pop    %ebp
 b6e:	c3                   	ret    
 b6f:	90                   	nop

00000b70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b70:	55                   	push   %ebp
 b71:	89 e5                	mov    %esp,%ebp
 b73:	57                   	push   %edi
 b74:	56                   	push   %esi
 b75:	53                   	push   %ebx
 b76:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b79:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b7c:	8b 15 04 12 00 00    	mov    0x1204,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b82:	8d 78 07             	lea    0x7(%eax),%edi
 b85:	c1 ef 03             	shr    $0x3,%edi
 b88:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b8b:	85 d2                	test   %edx,%edx
 b8d:	0f 84 a3 00 00 00    	je     c36 <malloc+0xc6>
 b93:	8b 02                	mov    (%edx),%eax
 b95:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b98:	39 cf                	cmp    %ecx,%edi
 b9a:	76 74                	jbe    c10 <malloc+0xa0>
 b9c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 ba2:	be 00 10 00 00       	mov    $0x1000,%esi
 ba7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 bae:	0f 43 f7             	cmovae %edi,%esi
 bb1:	ba 00 80 00 00       	mov    $0x8000,%edx
 bb6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 bbc:	0f 46 da             	cmovbe %edx,%ebx
 bbf:	eb 10                	jmp    bd1 <malloc+0x61>
 bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 bca:	8b 48 04             	mov    0x4(%eax),%ecx
 bcd:	39 cf                	cmp    %ecx,%edi
 bcf:	76 3f                	jbe    c10 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bd1:	39 05 04 12 00 00    	cmp    %eax,0x1204
 bd7:	89 c2                	mov    %eax,%edx
 bd9:	75 ed                	jne    bc8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 bdb:	83 ec 0c             	sub    $0xc,%esp
 bde:	53                   	push   %ebx
 bdf:	e8 66 fc ff ff       	call   84a <sbrk>
  if(p == (char*)-1)
 be4:	83 c4 10             	add    $0x10,%esp
 be7:	83 f8 ff             	cmp    $0xffffffff,%eax
 bea:	74 1c                	je     c08 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 bec:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 bef:	83 ec 0c             	sub    $0xc,%esp
 bf2:	83 c0 08             	add    $0x8,%eax
 bf5:	50                   	push   %eax
 bf6:	e8 e5 fe ff ff       	call   ae0 <free>
  return freep;
 bfb:	8b 15 04 12 00 00    	mov    0x1204,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 c01:	83 c4 10             	add    $0x10,%esp
 c04:	85 d2                	test   %edx,%edx
 c06:	75 c0                	jne    bc8 <malloc+0x58>
        return 0;
 c08:	31 c0                	xor    %eax,%eax
 c0a:	eb 1c                	jmp    c28 <malloc+0xb8>
 c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 c10:	39 cf                	cmp    %ecx,%edi
 c12:	74 1c                	je     c30 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 c14:	29 f9                	sub    %edi,%ecx
 c16:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 c19:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 c1c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 c1f:	89 15 04 12 00 00    	mov    %edx,0x1204
      return (void*)(p + 1);
 c25:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c2b:	5b                   	pop    %ebx
 c2c:	5e                   	pop    %esi
 c2d:	5f                   	pop    %edi
 c2e:	5d                   	pop    %ebp
 c2f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 c30:	8b 08                	mov    (%eax),%ecx
 c32:	89 0a                	mov    %ecx,(%edx)
 c34:	eb e9                	jmp    c1f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 c36:	c7 05 04 12 00 00 08 	movl   $0x1208,0x1204
 c3d:	12 00 00 
 c40:	c7 05 08 12 00 00 08 	movl   $0x1208,0x1208
 c47:	12 00 00 
    base.s.size = 0;
 c4a:	b8 08 12 00 00       	mov    $0x1208,%eax
 c4f:	c7 05 0c 12 00 00 00 	movl   $0x0,0x120c
 c56:	00 00 00 
 c59:	e9 3e ff ff ff       	jmp    b9c <malloc+0x2c>
