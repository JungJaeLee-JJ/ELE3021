
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

  //데이터 동적할당
  command = malloc(sizeof(*command));
  11:	6a 0c                	push   $0xc
  13:	e8 28 0b 00 00       	call   b40 <malloc>
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
  18:	c7 04 24 b1 0c 00 00 	movl   $0xcb1,(%esp)
{
  static char buf[100];
  int fd;

  //데이터 동적할당
  command = malloc(sizeof(*command));
  1f:	a3 90 11 00 00       	mov    %eax,0x1190
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
  24:	e8 11 08 00 00       	call   83a <getadmin>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	83 f8 ff             	cmp    $0xffffffff,%eax
  2f:	0f 84 93 00 00 00    	je     c8 <main+0xc8>
       printf(2, "Authentication Failure : Wrong Password\n");
       exit();
  }
  printf(2, "[Process Manager] \n");
  35:	83 ec 08             	sub    $0x8,%esp
  38:	68 bc 0c 00 00       	push   $0xcbc
  3d:	6a 02                	push   $0x2
  3f:	e8 cc 08 00 00       	call   910 <printf>

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  44:	83 c4 10             	add    $0x10,%esp
  47:	eb 0c                	jmp    55 <main+0x55>
  49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
  50:	83 f8 02             	cmp    $0x2,%eax
  53:	7f 65                	jg     ba <main+0xba>
       exit();
  }
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  55:	83 ec 08             	sub    $0x8,%esp
  58:	6a 02                	push   $0x2
  5a:	68 d0 0c 00 00       	push   $0xcd0
  5f:	e8 5e 07 00 00       	call   7c2 <open>
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 c0                	test   %eax,%eax
  69:	79 e5                	jns    50 <main+0x50>
  6b:	eb 31                	jmp    9e <main+0x9e>
  6d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  70:	83 ec 08             	sub    $0x8,%esp
  73:	6a 64                	push   $0x64
  75:	68 20 11 00 00       	push   $0x1120
  7a:	e8 61 00 00 00       	call   e0 <getcmd>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	85 c0                	test   %eax,%eax
  84:	78 21                	js     a7 <main+0xa7>
    runcmd(parsing(buf));
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	68 20 11 00 00       	push   $0x1120
  8e:	e8 0d 03 00 00       	call   3a0 <parsing>
  93:	89 04 24             	mov    %eax,(%esp)
  96:	e8 d5 00 00 00       	call   170 <runcmd>
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  9b:	83 c4 10             	add    $0x10,%esp
  9e:	a1 00 11 00 00       	mov    0x1100,%eax
  a3:	85 c0                	test   %eax,%eax
  a5:	74 c9                	je     70 <main+0x70>
    runcmd(parsing(buf));
  }
  free(command);
  a7:	83 ec 0c             	sub    $0xc,%esp
  aa:	ff 35 90 11 00 00    	pushl  0x1190
  b0:	e8 fb 09 00 00       	call   ab0 <free>
  exit();
  b5:	e8 c8 06 00 00       	call   782 <exit>
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
  ba:	83 ec 0c             	sub    $0xc,%esp
  bd:	50                   	push   %eax
  be:	e8 e7 06 00 00       	call   7aa <close>
      break;
  c3:	83 c4 10             	add    $0x10,%esp
  c6:	eb d6                	jmp    9e <main+0x9e>
  //데이터 동적할당
  command = malloc(sizeof(*command));
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
       printf(2, "Authentication Failure : Wrong Password\n");
  c8:	52                   	push   %edx
  c9:	52                   	push   %edx
  ca:	68 10 0d 00 00       	push   $0xd10
  cf:	6a 02                	push   $0x2
  d1:	e8 3a 08 00 00       	call   910 <printf>
       exit();
  d6:	e8 a7 06 00 00       	call   782 <exit>
  db:	66 90                	xchg   %ax,%ax
  dd:	66 90                	xchg   %ax,%ax
  df:	90                   	nop

000000e0 <getcmd>:
}


int
getcmd(char *buf, int nbuf)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	56                   	push   %esi
  e4:	53                   	push   %ebx
  e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "> ");
  eb:	83 ec 08             	sub    $0x8,%esp
  ee:	68 30 0c 00 00       	push   $0xc30
  f3:	6a 02                	push   $0x2
  f5:	e8 16 08 00 00       	call   910 <printf>
  memset(buf, 0, nbuf);
  fa:	83 c4 0c             	add    $0xc,%esp
  fd:	56                   	push   %esi
  fe:	6a 00                	push   $0x0
 100:	53                   	push   %ebx
 101:	e8 ea 04 00 00       	call   5f0 <memset>
  gets(buf, nbuf);
 106:	58                   	pop    %eax
 107:	5a                   	pop    %edx
 108:	56                   	push   %esi
 109:	53                   	push   %ebx
 10a:	e8 41 05 00 00       	call   650 <gets>
 10f:	83 c4 10             	add    $0x10,%esp
 112:	31 c0                	xor    %eax,%eax
 114:	80 3b 00             	cmpb   $0x0,(%ebx)
 117:	0f 94 c0             	sete   %al
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
 11a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 11d:	f7 d8                	neg    %eax
 11f:	5b                   	pop    %ebx
 120:	5e                   	pop    %esi
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    
 123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <wrong_input>:

void 
wrong_input()
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 10             	sub    $0x10,%esp
    printf(2, "It is Wrong input. \n");
 136:	68 33 0c 00 00       	push   $0xc33
 13b:	6a 02                	push   $0x2
 13d:	e8 ce 07 00 00       	call   910 <printf>
}
 142:	83 c4 10             	add    $0x10,%esp
 145:	c9                   	leave  
 146:	c3                   	ret    
 147:	89 f6                	mov    %esi,%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <panic>:


void
panic(char *s)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 156:	ff 75 08             	pushl  0x8(%ebp)
 159:	68 48 0c 00 00       	push   $0xc48
 15e:	6a 02                	push   $0x2
 160:	e8 ab 07 00 00       	call   910 <printf>
  exit();
 165:	e8 18 06 00 00       	call   782 <exit>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <runcmd>:
//cmd 자료형을 만든다.
struct cmd* command;

void
runcmd(struct cmd *cmd)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	56                   	push   %esi
 174:	53                   	push   %ebx
 175:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //명령어가 입력되지 않은 경우
  if(cmd == 0) wrong_input();
 178:	85 db                	test   %ebx,%ebx
 17a:	0f 84 b8 01 00 00    	je     338 <runcmd+0x1c8>

  switch(cmd->type){
 180:	83 3b 05             	cmpl   $0x5,(%ebx)
 183:	77 0b                	ja     190 <runcmd+0x20>
 185:	8b 03                	mov    (%ebx),%eax
 187:	ff 24 85 3c 0d 00 00 	jmp    *0xd3c(,%eax,4)
 18e:	66 90                	xchg   %ax,%ax
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 190:	83 ec 08             	sub    $0x8,%esp
 193:	68 33 0c 00 00       	push   $0xc33
 198:	6a 02                	push   $0x2
 19a:	e8 71 07 00 00       	call   910 <printf>
 19f:	83 c4 10             	add    $0x10,%esp
	//wait();
    printf(2,"Terminate Pmanager \n");
    finish = 1;
    break;
  }
}
 1a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a5:	5b                   	pop    %ebx
 1a6:	5e                   	pop    %esi
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2,"Fail to set Memory Limit\n");
    }
    break;
  case EXIT:
	//wait();
    printf(2,"Terminate Pmanager \n");
 1b0:	83 ec 08             	sub    $0x8,%esp
 1b3:	68 9c 0c 00 00       	push   $0xc9c
 1b8:	6a 02                	push   $0x2
 1ba:	e8 51 07 00 00       	call   910 <printf>
    finish = 1;
 1bf:	c7 05 00 11 00 00 01 	movl   $0x1,0x1100
 1c6:	00 00 00 
    break;
 1c9:	83 c4 10             	add    $0x10,%esp
  }
}
 1cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	90                   	nop
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5d                   	pop    %ebp
  default:
	wrong_input();
	break;

  case LIST:
    list();
 1de:	e9 6f 06 00 00       	jmp    852 <list>
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    break;

  case KILL:
    //입력 유효 검사
    if(cmd->first_arg == 0) {
 1e8:	8b 43 04             	mov    0x4(%ebx),%eax
 1eb:	85 c0                	test   %eax,%eax
 1ed:	74 a1                	je     190 <runcmd+0x20>
        wrong_input();
    }
 
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg)) == 0){
 1ef:	83 ec 0c             	sub    $0xc,%esp
 1f2:	50                   	push   %eax
 1f3:	e8 18 05 00 00       	call   710 <atoi>
 1f8:	89 04 24             	mov    %eax,(%esp)
 1fb:	e8 b2 05 00 00       	call   7b2 <kill>
 200:	83 c4 10             	add    $0x10,%esp
 203:	85 c0                	test   %eax,%eax
 205:	0f 85 05 01 00 00    	jne    310 <runcmd+0x1a0>
        printf(2, "Success to kill %d\n",atoi(cmd->first_arg));
 20b:	83 ec 0c             	sub    $0xc,%esp
 20e:	ff 73 04             	pushl  0x4(%ebx)
 211:	e8 fa 04 00 00       	call   710 <atoi>
 216:	83 c4 0c             	add    $0xc,%esp
 219:	50                   	push   %eax
 21a:	68 4c 0c 00 00       	push   $0xc4c
 21f:	6a 02                	push   $0x2
 221:	e8 ea 06 00 00       	call   910 <printf>
        wait();
 226:	83 c4 10             	add    $0x10,%esp
	//wait();
    printf(2,"Terminate Pmanager \n");
    finish = 1;
    break;
  }
}
 229:	8d 65 f8             	lea    -0x8(%ebp),%esp
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5d                   	pop    %ebp
    }
 
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg)) == 0){
        printf(2, "Success to kill %d\n",atoi(cmd->first_arg));
        wait();
 22f:	e9 56 05 00 00       	jmp    78a <wait>
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	}
    break;

  case EXEC2:
	//인자가 2개일때
	if(cmd->second_arg != 0) *(cmd->second_arg-1) = 0;
 238:	8b 43 08             	mov    0x8(%ebx),%eax
 23b:	85 c0                	test   %eax,%eax
 23d:	74 04                	je     243 <runcmd+0xd3>
 23f:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)

int
fork1(void)
{
  int pid;
  pid = fork();
 243:	e8 32 05 00 00       	call   77a <fork>
  if(pid == -1)
 248:	83 f8 ff             	cmp    $0xffffffff,%eax
 24b:	0f 84 16 01 00 00    	je     367 <runcmd+0x1f7>

  case EXEC2:
	//인자가 2개일때
	if(cmd->second_arg != 0) *(cmd->second_arg-1) = 0;
    //프로세스 생성
	 if(fork1() == 0){
 251:	85 c0                	test   %eax,%eax
 253:	0f 85 49 ff ff ff    	jne    1a2 <runcmd+0x32>
      //exec2 명령어 실
		if(exec2(cmd->first_arg,&(cmd->first_arg),atoi(cmd->second_arg)) == -1) printf(2, "EXEC fail!\n");
 259:	83 ec 0c             	sub    $0xc,%esp
 25c:	ff 73 08             	pushl  0x8(%ebx)
 25f:	e8 ac 04 00 00       	call   710 <atoi>
 264:	83 c4 0c             	add    $0xc,%esp
 267:	50                   	push   %eax
 268:	8d 43 04             	lea    0x4(%ebx),%eax
 26b:	50                   	push   %eax
 26c:	ff 73 04             	pushl  0x4(%ebx)
 26f:	e8 ce 05 00 00       	call   842 <exec2>
 274:	83 c4 10             	add    $0x10,%esp
 277:	83 f8 ff             	cmp    $0xffffffff,%eax
 27a:	0f 85 22 ff ff ff    	jne    1a2 <runcmd+0x32>
 280:	83 ec 08             	sub    $0x8,%esp
 283:	68 76 0c 00 00       	push   $0xc76
 288:	6a 02                	push   $0x2
 28a:	e8 81 06 00 00       	call   910 <printf>
 28f:	83 c4 10             	add    $0x10,%esp
 292:	e9 0b ff ff ff       	jmp    1a2 <runcmd+0x32>
 297:	89 f6                	mov    %esi,%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    break; 
  case MEMLIMIT:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
 2a0:	8b 4b 04             	mov    0x4(%ebx),%ecx
 2a3:	85 c9                	test   %ecx,%ecx
 2a5:	0f 84 e5 fe ff ff    	je     190 <runcmd+0x20>
 2ab:	8b 43 08             	mov    0x8(%ebx),%eax
 2ae:	85 c0                	test   %eax,%eax
 2b0:	0f 84 da fe ff ff    	je     190 <runcmd+0x20>
        wrong_input();
    }
	else if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
 2b6:	83 ec 0c             	sub    $0xc,%esp
 2b9:	50                   	push   %eax
 2ba:	e8 51 04 00 00       	call   710 <atoi>
 2bf:	5a                   	pop    %edx
 2c0:	ff 73 04             	pushl  0x4(%ebx)
 2c3:	89 c6                	mov    %eax,%esi
 2c5:	e8 46 04 00 00       	call   710 <atoi>
 2ca:	59                   	pop    %ecx
 2cb:	5a                   	pop    %edx
 2cc:	56                   	push   %esi
 2cd:	50                   	push   %eax
 2ce:	e8 77 05 00 00       	call   84a <setmemorylimit>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	85 c0                	test   %eax,%eax
 2d8:	75 76                	jne    350 <runcmd+0x1e0>
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
 2da:	83 ec 0c             	sub    $0xc,%esp
 2dd:	ff 73 08             	pushl  0x8(%ebx)
 2e0:	e8 2b 04 00 00       	call   710 <atoi>
 2e5:	89 c6                	mov    %eax,%esi
 2e7:	58                   	pop    %eax
 2e8:	ff 73 04             	pushl  0x4(%ebx)
 2eb:	e8 20 04 00 00       	call   710 <atoi>
 2f0:	56                   	push   %esi
 2f1:	50                   	push   %eax
 2f2:	68 d8 0c 00 00       	push   $0xcd8
 2f7:	6a 02                	push   $0x2
 2f9:	e8 12 06 00 00       	call   910 <printf>
 2fe:	83 c4 20             	add    $0x20,%esp
 301:	e9 9c fe ff ff       	jmp    1a2 <runcmd+0x32>
 306:	8d 76 00             	lea    0x0(%esi),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg)) == 0){
        printf(2, "Success to kill %d\n",atoi(cmd->first_arg));
        wait();
    }else{
		printf(2,"Fail to kill %d\n",atoi(cmd->first_arg));
 310:	83 ec 0c             	sub    $0xc,%esp
 313:	ff 73 04             	pushl  0x4(%ebx)
 316:	e8 f5 03 00 00       	call   710 <atoi>
 31b:	83 c4 0c             	add    $0xc,%esp
 31e:	50                   	push   %eax
 31f:	68 60 0c 00 00       	push   $0xc60
 324:	6a 02                	push   $0x2
 326:	e8 e5 05 00 00       	call   910 <printf>
 32b:	83 c4 10             	add    $0x10,%esp
 32e:	e9 6f fe ff ff       	jmp    1a2 <runcmd+0x32>
 333:	90                   	nop
 334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 338:	83 ec 08             	sub    $0x8,%esp
 33b:	68 33 0c 00 00       	push   $0xc33
 340:	6a 02                	push   $0x2
 342:	e8 c9 05 00 00       	call   910 <printf>
 347:	83 c4 10             	add    $0x10,%esp
 34a:	e9 31 fe ff ff       	jmp    180 <runcmd+0x10>
 34f:	90                   	nop
    }
	else if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
    }
    else{
        printf(2,"Fail to set Memory Limit\n");
 350:	83 ec 08             	sub    $0x8,%esp
 353:	68 82 0c 00 00       	push   $0xc82
 358:	6a 02                	push   $0x2
 35a:	e8 b1 05 00 00       	call   910 <printf>
 35f:	83 c4 10             	add    $0x10,%esp
 362:	e9 3b fe ff ff       	jmp    1a2 <runcmd+0x32>
fork1(void)
{
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
 367:	83 ec 0c             	sub    $0xc,%esp
 36a:	68 71 0c 00 00       	push   $0xc71
 36f:	e8 dc fd ff ff       	call   150 <panic>
 374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 37a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000380 <fork1>:
  exit();
}

int
fork1(void)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 08             	sub    $0x8,%esp
  int pid;
  pid = fork();
 386:	e8 ef 03 00 00       	call   77a <fork>
  if(pid == -1)
 38b:	83 f8 ff             	cmp    $0xffffffff,%eax
 38e:	74 02                	je     392 <fork1+0x12>
    panic("fork");
  return pid;
}
 390:	c9                   	leave  
 391:	c3                   	ret    
fork1(void)
{
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
 392:	83 ec 0c             	sub    $0xc,%esp
 395:	68 71 0c 00 00       	push   $0xc71
 39a:	e8 b1 fd ff ff       	call   150 <panic>
 39f:	90                   	nop

000003a0 <parsing>:
  exit();
}

struct cmd*
parsing(char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	83 ec 08             	sub    $0x8,%esp
 3a7:	8b 5d 08             	mov    0x8(%ebp),%ebx

  //데이터 동적할당
  //command = malloc(sizeof(*command));
  
  //초기화
  memset(command,0,sizeof(*command));
 3aa:	6a 0c                	push   $0xc
 3ac:	6a 00                	push   $0x0
 3ae:	ff 35 90 11 00 00    	pushl  0x1190
 3b4:	e8 37 02 00 00       	call   5f0 <memset>
  memset(command->first_arg,0,sizeof(char*));
 3b9:	a1 90 11 00 00       	mov    0x1190,%eax
 3be:	83 c4 0c             	add    $0xc,%esp
 3c1:	6a 04                	push   $0x4
 3c3:	6a 00                	push   $0x0
 3c5:	ff 70 04             	pushl  0x4(%eax)
 3c8:	e8 23 02 00 00       	call   5f0 <memset>
  memset(command->second_arg,0,sizeof(char*));
 3cd:	a1 90 11 00 00       	mov    0x1190,%eax
 3d2:	83 c4 0c             	add    $0xc,%esp
 3d5:	6a 04                	push   $0x4
 3d7:	6a 00                	push   $0x0
 3d9:	ff 70 08             	pushl  0x8(%eax)
 3dc:	e8 0f 02 00 00       	call   5f0 <memset>
 3e1:	a1 90 11 00 00       	mov    0x1190,%eax
 3e6:	8d 53 01             	lea    0x1(%ebx),%edx
 3e9:	83 c4 10             	add    $0x10,%esp
 3ec:	eb 0a                	jmp    3f8 <parsing+0x58>
 3ee:	66 90                	xchg   %ax,%ax
 3f0:	83 c2 01             	add    $0x1,%edx
         {
             command->second_arg = &s[index+1];
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 3f3:	80 f9 0a             	cmp    $0xa,%cl
 3f6:	74 1f                	je     417 <parsing+0x77>

  //각 인자의 시작 인덱스를 저장한다.
  while(1){
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
 3f8:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 3fc:	80 f9 20             	cmp    $0x20,%cl
 3ff:	75 ef                	jne    3f0 <parsing+0x50>
         //첫번째 인자일 때
         if(command->first_arg == 0){
 401:	8b 48 04             	mov    0x4(%eax),%ecx
 404:	85 c9                	test   %ecx,%ecx
 406:	74 58                	je     460 <parsing+0xc0>
             command->first_arg = &s[index+1];
         }
         //두번째 인자일 때
         else 
         {
             command->second_arg = &s[index+1];
 408:	89 50 08             	mov    %edx,0x8(%eax)
 40b:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 40f:	83 c2 01             	add    $0x1,%edx
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 412:	80 f9 0a             	cmp    $0xa,%cl
 415:	75 e1                	jne    3f8 <parsing+0x58>
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
 417:	0f b6 13             	movzbl (%ebx),%edx
 41a:	80 fa 6c             	cmp    $0x6c,%dl
 41d:	74 51                	je     470 <parsing+0xd0>
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
 41f:	80 fa 6b             	cmp    $0x6b,%dl
 422:	74 1c                	je     440 <parsing+0xa0>
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 424:	80 fa 65             	cmp    $0x65,%dl
 427:	75 67                	jne    490 <parsing+0xf0>
 429:	80 7b 01 78          	cmpb   $0x78,0x1(%ebx)
 42d:	0f 84 9d 00 00 00    	je     4d0 <parsing+0x130>
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='e'&&s[3]=='c'&&s[4]=='u'&&s[5]=='t'&&s[6]=='e' ) command->type = 3;

  
  //printf(2," %d %s %s\n",command->type, command->first_arg, command->second_arg);
  return command;
}
 433:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 436:	c9                   	leave  
 437:	c3                   	ret    
 438:	90                   	nop
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(s[index] == '\n') break;
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
 440:	80 7b 01 69          	cmpb   $0x69,0x1(%ebx)
 444:	75 ed                	jne    433 <parsing+0x93>
 446:	80 7b 02 6c          	cmpb   $0x6c,0x2(%ebx)
 44a:	75 e7                	jne    433 <parsing+0x93>
 44c:	80 7b 03 6c          	cmpb   $0x6c,0x3(%ebx)
 450:	75 e1                	jne    433 <parsing+0x93>
 452:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
 458:	a1 90 11 00 00       	mov    0x1190,%eax
 45d:	eb d4                	jmp    433 <parsing+0x93>
 45f:	90                   	nop
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
         //첫번째 인자일 때
         if(command->first_arg == 0){
             command->first_arg = &s[index+1];
 460:	89 50 04             	mov    %edx,0x4(%eax)
 463:	0f b6 4a ff          	movzbl -0x1(%edx),%ecx
 467:	eb 87                	jmp    3f0 <parsing+0x50>
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      //종료조건
      if(s[index] == '\n') break;
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
 470:	80 7b 01 69          	cmpb   $0x69,0x1(%ebx)
 474:	75 bd                	jne    433 <parsing+0x93>
 476:	80 7b 02 73          	cmpb   $0x73,0x2(%ebx)
 47a:	75 b7                	jne    433 <parsing+0x93>
 47c:	80 7b 03 74          	cmpb   $0x74,0x3(%ebx)
 480:	75 b1                	jne    433 <parsing+0x93>
 482:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
 488:	a1 90 11 00 00       	mov    0x1190,%eax
 48d:	eb a4                	jmp    433 <parsing+0x93>
 48f:	90                   	nop
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
 490:	80 fa 6d             	cmp    $0x6d,%dl
 493:	75 9e                	jne    433 <parsing+0x93>
 495:	80 7b 01 65          	cmpb   $0x65,0x1(%ebx)
 499:	75 98                	jne    433 <parsing+0x93>
 49b:	80 7b 02 6d          	cmpb   $0x6d,0x2(%ebx)
 49f:	75 92                	jne    433 <parsing+0x93>
 4a1:	80 7b 03 6c          	cmpb   $0x6c,0x3(%ebx)
 4a5:	75 8c                	jne    433 <parsing+0x93>
 4a7:	80 7b 04 69          	cmpb   $0x69,0x4(%ebx)
 4ab:	75 86                	jne    433 <parsing+0x93>
 4ad:	80 7b 05 6d          	cmpb   $0x6d,0x5(%ebx)
 4b1:	0f 85 7c ff ff ff    	jne    433 <parsing+0x93>
 4b7:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
 4bd:	a1 90 11 00 00       	mov    0x1190,%eax
 4c2:	e9 6c ff ff ff       	jmp    433 <parsing+0x93>
 4c7:	89 f6                	mov    %esi,%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 4d0:	80 7b 02 69          	cmpb   $0x69,0x2(%ebx)
 4d4:	74 4a                	je     520 <parsing+0x180>
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='e'&&s[3]=='c'&&s[4]=='u'&&s[5]=='t'&&s[6]=='e' ) command->type = 3;
 4d6:	80 7b 02 65          	cmpb   $0x65,0x2(%ebx)
 4da:	0f 85 53 ff ff ff    	jne    433 <parsing+0x93>
 4e0:	80 7b 03 63          	cmpb   $0x63,0x3(%ebx)
 4e4:	0f 85 49 ff ff ff    	jne    433 <parsing+0x93>
 4ea:	80 7b 04 75          	cmpb   $0x75,0x4(%ebx)
 4ee:	0f 85 3f ff ff ff    	jne    433 <parsing+0x93>
 4f4:	80 7b 05 74          	cmpb   $0x74,0x5(%ebx)
 4f8:	0f 85 35 ff ff ff    	jne    433 <parsing+0x93>
 4fe:	80 7b 06 65          	cmpb   $0x65,0x6(%ebx)
 502:	0f 85 2b ff ff ff    	jne    433 <parsing+0x93>
 508:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
 50e:	a1 90 11 00 00       	mov    0x1190,%eax
 513:	e9 1b ff ff ff       	jmp    433 <parsing+0x93>
 518:	90                   	nop
 519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 520:	80 7b 03 74          	cmpb   $0x74,0x3(%ebx)
 524:	75 b0                	jne    4d6 <parsing+0x136>
 526:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
 52c:	a1 90 11 00 00       	mov    0x1190,%eax
 531:	e9 fd fe ff ff       	jmp    433 <parsing+0x93>
 536:	66 90                	xchg   %ax,%ax
 538:	66 90                	xchg   %ax,%ax
 53a:	66 90                	xchg   %ax,%ax
 53c:	66 90                	xchg   %ax,%ax
 53e:	66 90                	xchg   %ax,%ax

00000540 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	53                   	push   %ebx
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 54a:	89 c2                	mov    %eax,%edx
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 550:	83 c1 01             	add    $0x1,%ecx
 553:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 557:	83 c2 01             	add    $0x1,%edx
 55a:	84 db                	test   %bl,%bl
 55c:	88 5a ff             	mov    %bl,-0x1(%edx)
 55f:	75 ef                	jne    550 <strcpy+0x10>
    ;
  return os;
}
 561:	5b                   	pop    %ebx
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 56a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000570 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	56                   	push   %esi
 574:	53                   	push   %ebx
 575:	8b 55 08             	mov    0x8(%ebp),%edx
 578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q){
 57b:	0f b6 02             	movzbl (%edx),%eax
 57e:	0f b6 19             	movzbl (%ecx),%ebx
 581:	84 c0                	test   %al,%al
 583:	75 1e                	jne    5a3 <strcmp+0x33>
 585:	eb 29                	jmp    5b0 <strcmp+0x40>
 587:	89 f6                	mov    %esi,%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 590:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 593:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 596:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 599:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 59d:	84 c0                	test   %al,%al
 59f:	74 0f                	je     5b0 <strcmp+0x40>
 5a1:	89 f1                	mov    %esi,%ecx
 5a3:	38 d8                	cmp    %bl,%al
 5a5:	74 e9                	je     590 <strcmp+0x20>
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 5a7:	29 d8                	sub    %ebx,%eax
}
 5a9:	5b                   	pop    %ebx
 5aa:	5e                   	pop    %esi
 5ab:	5d                   	pop    %ebp
 5ac:	c3                   	ret    
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 5b0:	31 c0                	xor    %eax,%eax
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 5b2:	29 d8                	sub    %ebx,%eax
}
 5b4:	5b                   	pop    %ebx
 5b5:	5e                   	pop    %esi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
 5b8:	90                   	nop
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005c0 <strlen>:

uint
strlen(const char *s)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 5c6:	80 39 00             	cmpb   $0x0,(%ecx)
 5c9:	74 12                	je     5dd <strlen+0x1d>
 5cb:	31 d2                	xor    %edx,%edx
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
 5d0:	83 c2 01             	add    $0x1,%edx
 5d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 5d7:	89 d0                	mov    %edx,%eax
 5d9:	75 f5                	jne    5d0 <strlen+0x10>
    ;
  return n;
}
 5db:	5d                   	pop    %ebp
 5dc:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 5dd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 5df:	5d                   	pop    %ebp
 5e0:	c3                   	ret    
 5e1:	eb 0d                	jmp    5f0 <memset>
 5e3:	90                   	nop
 5e4:	90                   	nop
 5e5:	90                   	nop
 5e6:	90                   	nop
 5e7:	90                   	nop
 5e8:	90                   	nop
 5e9:	90                   	nop
 5ea:	90                   	nop
 5eb:	90                   	nop
 5ec:	90                   	nop
 5ed:	90                   	nop
 5ee:	90                   	nop
 5ef:	90                   	nop

000005f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fd:	89 d7                	mov    %edx,%edi
 5ff:	fc                   	cld    
 600:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 602:	89 d0                	mov    %edx,%eax
 604:	5f                   	pop    %edi
 605:	5d                   	pop    %ebp
 606:	c3                   	ret    
 607:	89 f6                	mov    %esi,%esi
 609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000610 <strchr>:

char*
strchr(const char *s, char c)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	53                   	push   %ebx
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 61a:	0f b6 10             	movzbl (%eax),%edx
 61d:	84 d2                	test   %dl,%dl
 61f:	74 1d                	je     63e <strchr+0x2e>
    if(*s == c)
 621:	38 d3                	cmp    %dl,%bl
 623:	89 d9                	mov    %ebx,%ecx
 625:	75 0d                	jne    634 <strchr+0x24>
 627:	eb 17                	jmp    640 <strchr+0x30>
 629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 630:	38 ca                	cmp    %cl,%dl
 632:	74 0c                	je     640 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 634:	83 c0 01             	add    $0x1,%eax
 637:	0f b6 10             	movzbl (%eax),%edx
 63a:	84 d2                	test   %dl,%dl
 63c:	75 f2                	jne    630 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 63e:	31 c0                	xor    %eax,%eax
}
 640:	5b                   	pop    %ebx
 641:	5d                   	pop    %ebp
 642:	c3                   	ret    
 643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000650 <gets>:

char*
gets(char *buf, int max)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 656:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 658:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 65b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 65e:	eb 29                	jmp    689 <gets+0x39>
    cc = read(0, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
 663:	6a 01                	push   $0x1
 665:	57                   	push   %edi
 666:	6a 00                	push   $0x0
 668:	e8 2d 01 00 00       	call   79a <read>
    if(cc < 1)
 66d:	83 c4 10             	add    $0x10,%esp
 670:	85 c0                	test   %eax,%eax
 672:	7e 1d                	jle    691 <gets+0x41>
      break;
    buf[i++] = c;
 674:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 678:	8b 55 08             	mov    0x8(%ebp),%edx
 67b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 67d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 67f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 683:	74 1b                	je     6a0 <gets+0x50>
 685:	3c 0d                	cmp    $0xd,%al
 687:	74 17                	je     6a0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 689:	8d 5e 01             	lea    0x1(%esi),%ebx
 68c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 68f:	7c cf                	jl     660 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 698:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69b:	5b                   	pop    %ebx
 69c:	5e                   	pop    %esi
 69d:	5f                   	pop    %edi
 69e:	5d                   	pop    %ebp
 69f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6a3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6a5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 6a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ac:	5b                   	pop    %ebx
 6ad:	5e                   	pop    %esi
 6ae:	5f                   	pop    %edi
 6af:	5d                   	pop    %ebp
 6b0:	c3                   	ret    
 6b1:	eb 0d                	jmp    6c0 <stat>
 6b3:	90                   	nop
 6b4:	90                   	nop
 6b5:	90                   	nop
 6b6:	90                   	nop
 6b7:	90                   	nop
 6b8:	90                   	nop
 6b9:	90                   	nop
 6ba:	90                   	nop
 6bb:	90                   	nop
 6bc:	90                   	nop
 6bd:	90                   	nop
 6be:	90                   	nop
 6bf:	90                   	nop

000006c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	56                   	push   %esi
 6c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6c5:	83 ec 08             	sub    $0x8,%esp
 6c8:	6a 00                	push   $0x0
 6ca:	ff 75 08             	pushl  0x8(%ebp)
 6cd:	e8 f0 00 00 00       	call   7c2 <open>
  if(fd < 0)
 6d2:	83 c4 10             	add    $0x10,%esp
 6d5:	85 c0                	test   %eax,%eax
 6d7:	78 27                	js     700 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	ff 75 0c             	pushl  0xc(%ebp)
 6df:	89 c3                	mov    %eax,%ebx
 6e1:	50                   	push   %eax
 6e2:	e8 f3 00 00 00       	call   7da <fstat>
 6e7:	89 c6                	mov    %eax,%esi
  close(fd);
 6e9:	89 1c 24             	mov    %ebx,(%esp)
 6ec:	e8 b9 00 00 00       	call   7aa <close>
  return r;
 6f1:	83 c4 10             	add    $0x10,%esp
 6f4:	89 f0                	mov    %esi,%eax
}
 6f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6f9:	5b                   	pop    %ebx
 6fa:	5e                   	pop    %esi
 6fb:	5d                   	pop    %ebp
 6fc:	c3                   	ret    
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 705:	eb ef                	jmp    6f6 <stat+0x36>
 707:	89 f6                	mov    %esi,%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	53                   	push   %ebx
 714:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 717:	0f be 11             	movsbl (%ecx),%edx
 71a:	8d 42 d0             	lea    -0x30(%edx),%eax
 71d:	3c 09                	cmp    $0x9,%al
 71f:	b8 00 00 00 00       	mov    $0x0,%eax
 724:	77 1f                	ja     745 <atoi+0x35>
 726:	8d 76 00             	lea    0x0(%esi),%esi
 729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 730:	8d 04 80             	lea    (%eax,%eax,4),%eax
 733:	83 c1 01             	add    $0x1,%ecx
 736:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 73a:	0f be 11             	movsbl (%ecx),%edx
 73d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 740:	80 fb 09             	cmp    $0x9,%bl
 743:	76 eb                	jbe    730 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 745:	5b                   	pop    %ebx
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	90                   	nop
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000750 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	56                   	push   %esi
 754:	53                   	push   %ebx
 755:	8b 5d 10             	mov    0x10(%ebp),%ebx
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 75e:	85 db                	test   %ebx,%ebx
 760:	7e 14                	jle    776 <memmove+0x26>
 762:	31 d2                	xor    %edx,%edx
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 768:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 76c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 76f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 772:	39 da                	cmp    %ebx,%edx
 774:	75 f2                	jne    768 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5d                   	pop    %ebp
 779:	c3                   	ret    

0000077a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 77a:	b8 01 00 00 00       	mov    $0x1,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <exit>:
SYSCALL(exit)
 782:	b8 02 00 00 00       	mov    $0x2,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <wait>:
SYSCALL(wait)
 78a:	b8 03 00 00 00       	mov    $0x3,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <pipe>:
SYSCALL(pipe)
 792:	b8 04 00 00 00       	mov    $0x4,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <read>:
SYSCALL(read)
 79a:	b8 05 00 00 00       	mov    $0x5,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <write>:
SYSCALL(write)
 7a2:	b8 10 00 00 00       	mov    $0x10,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <close>:
SYSCALL(close)
 7aa:	b8 15 00 00 00       	mov    $0x15,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <kill>:
SYSCALL(kill)
 7b2:	b8 06 00 00 00       	mov    $0x6,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <exec>:
SYSCALL(exec)
 7ba:	b8 07 00 00 00       	mov    $0x7,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <open>:
SYSCALL(open)
 7c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <mknod>:
SYSCALL(mknod)
 7ca:	b8 11 00 00 00       	mov    $0x11,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <unlink>:
SYSCALL(unlink)
 7d2:	b8 12 00 00 00       	mov    $0x12,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <fstat>:
SYSCALL(fstat)
 7da:	b8 08 00 00 00       	mov    $0x8,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <link>:
SYSCALL(link)
 7e2:	b8 13 00 00 00       	mov    $0x13,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <mkdir>:
SYSCALL(mkdir)
 7ea:	b8 14 00 00 00       	mov    $0x14,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <chdir>:
SYSCALL(chdir)
 7f2:	b8 09 00 00 00       	mov    $0x9,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <dup>:
SYSCALL(dup)
 7fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <getpid>:
SYSCALL(getpid)
 802:	b8 0b 00 00 00       	mov    $0xb,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <sbrk>:
SYSCALL(sbrk)
 80a:	b8 0c 00 00 00       	mov    $0xc,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <sleep>:
SYSCALL(sleep)
 812:	b8 0d 00 00 00       	mov    $0xd,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <uptime>:
SYSCALL(uptime)
 81a:	b8 0e 00 00 00       	mov    $0xe,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <yield>:
SYSCALL(yield)
 822:	b8 16 00 00 00       	mov    $0x16,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <getlev>:
SYSCALL(getlev)
 82a:	b8 17 00 00 00       	mov    $0x17,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <setpriority>:
SYSCALL(setpriority)
 832:	b8 18 00 00 00       	mov    $0x18,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <getadmin>:
SYSCALL(getadmin)
 83a:	b8 19 00 00 00       	mov    $0x19,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <exec2>:
SYSCALL(exec2)
 842:	b8 1a 00 00 00       	mov    $0x1a,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <setmemorylimit>:
SYSCALL(setmemorylimit)
 84a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <list>:
SYSCALL(list)
 852:	b8 1c 00 00 00       	mov    $0x1c,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <getshmem>:
SYSCALL(getshmem)
 85a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    
 862:	66 90                	xchg   %ax,%ax
 864:	66 90                	xchg   %ax,%ax
 866:	66 90                	xchg   %ax,%ax
 868:	66 90                	xchg   %ax,%ax
 86a:	66 90                	xchg   %ax,%ax
 86c:	66 90                	xchg   %ax,%ax
 86e:	66 90                	xchg   %ax,%ax

00000870 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	57                   	push   %edi
 874:	56                   	push   %esi
 875:	53                   	push   %ebx
 876:	89 c6                	mov    %eax,%esi
 878:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 87b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 87e:	85 db                	test   %ebx,%ebx
 880:	74 7e                	je     900 <printint+0x90>
 882:	89 d0                	mov    %edx,%eax
 884:	c1 e8 1f             	shr    $0x1f,%eax
 887:	84 c0                	test   %al,%al
 889:	74 75                	je     900 <printint+0x90>
    neg = 1;
    x = -xx;
 88b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 88d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 894:	f7 d8                	neg    %eax
 896:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 899:	31 ff                	xor    %edi,%edi
 89b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 89e:	89 ce                	mov    %ecx,%esi
 8a0:	eb 08                	jmp    8aa <printint+0x3a>
 8a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 8a8:	89 cf                	mov    %ecx,%edi
 8aa:	31 d2                	xor    %edx,%edx
 8ac:	8d 4f 01             	lea    0x1(%edi),%ecx
 8af:	f7 f6                	div    %esi
 8b1:	0f b6 92 5c 0d 00 00 	movzbl 0xd5c(%edx),%edx
  }while((x /= base) != 0);
 8b8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 8ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 8bd:	75 e9                	jne    8a8 <printint+0x38>
  if(neg)
 8bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 8c2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 8c5:	85 c0                	test   %eax,%eax
 8c7:	74 08                	je     8d1 <printint+0x61>
    buf[i++] = '-';
 8c9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 8ce:	8d 4f 02             	lea    0x2(%edi),%ecx
 8d1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 8d5:	8d 76 00             	lea    0x0(%esi),%esi
 8d8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8db:	83 ec 04             	sub    $0x4,%esp
 8de:	83 ef 01             	sub    $0x1,%edi
 8e1:	6a 01                	push   $0x1
 8e3:	53                   	push   %ebx
 8e4:	56                   	push   %esi
 8e5:	88 45 d7             	mov    %al,-0x29(%ebp)
 8e8:	e8 b5 fe ff ff       	call   7a2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8ed:	83 c4 10             	add    $0x10,%esp
 8f0:	39 df                	cmp    %ebx,%edi
 8f2:	75 e4                	jne    8d8 <printint+0x68>
    putc(fd, buf[i]);
}
 8f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8f7:	5b                   	pop    %ebx
 8f8:	5e                   	pop    %esi
 8f9:	5f                   	pop    %edi
 8fa:	5d                   	pop    %ebp
 8fb:	c3                   	ret    
 8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 900:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 902:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 909:	eb 8b                	jmp    896 <printint+0x26>
 90b:	90                   	nop
 90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000910 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	57                   	push   %edi
 914:	56                   	push   %esi
 915:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 916:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 919:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 91c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 91f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 922:	89 45 d0             	mov    %eax,-0x30(%ebp)
 925:	0f b6 1e             	movzbl (%esi),%ebx
 928:	83 c6 01             	add    $0x1,%esi
 92b:	84 db                	test   %bl,%bl
 92d:	0f 84 b0 00 00 00    	je     9e3 <printf+0xd3>
 933:	31 d2                	xor    %edx,%edx
 935:	eb 39                	jmp    970 <printf+0x60>
 937:	89 f6                	mov    %esi,%esi
 939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 940:	83 f8 25             	cmp    $0x25,%eax
 943:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 946:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 94b:	74 18                	je     965 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 94d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 950:	83 ec 04             	sub    $0x4,%esp
 953:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 956:	6a 01                	push   $0x1
 958:	50                   	push   %eax
 959:	57                   	push   %edi
 95a:	e8 43 fe ff ff       	call   7a2 <write>
 95f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 962:	83 c4 10             	add    $0x10,%esp
 965:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 968:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 96c:	84 db                	test   %bl,%bl
 96e:	74 73                	je     9e3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 970:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 972:	0f be cb             	movsbl %bl,%ecx
 975:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 978:	74 c6                	je     940 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 97a:	83 fa 25             	cmp    $0x25,%edx
 97d:	75 e6                	jne    965 <printf+0x55>
      if(c == 'd'){
 97f:	83 f8 64             	cmp    $0x64,%eax
 982:	0f 84 f8 00 00 00    	je     a80 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 988:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 98e:	83 f9 70             	cmp    $0x70,%ecx
 991:	74 5d                	je     9f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 993:	83 f8 73             	cmp    $0x73,%eax
 996:	0f 84 84 00 00 00    	je     a20 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 99c:	83 f8 63             	cmp    $0x63,%eax
 99f:	0f 84 ea 00 00 00    	je     a8f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 9a5:	83 f8 25             	cmp    $0x25,%eax
 9a8:	0f 84 c2 00 00 00    	je     a70 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
 9b1:	83 ec 04             	sub    $0x4,%esp
 9b4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9b8:	6a 01                	push   $0x1
 9ba:	50                   	push   %eax
 9bb:	57                   	push   %edi
 9bc:	e8 e1 fd ff ff       	call   7a2 <write>
 9c1:	83 c4 0c             	add    $0xc,%esp
 9c4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 9c7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 9ca:	6a 01                	push   $0x1
 9cc:	50                   	push   %eax
 9cd:	57                   	push   %edi
 9ce:	83 c6 01             	add    $0x1,%esi
 9d1:	e8 cc fd ff ff       	call   7a2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9d6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9da:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9dd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9df:	84 db                	test   %bl,%bl
 9e1:	75 8d                	jne    970 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9e6:	5b                   	pop    %ebx
 9e7:	5e                   	pop    %esi
 9e8:	5f                   	pop    %edi
 9e9:	5d                   	pop    %ebp
 9ea:	c3                   	ret    
 9eb:	90                   	nop
 9ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 9f0:	83 ec 0c             	sub    $0xc,%esp
 9f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9f8:	6a 00                	push   $0x0
 9fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9fd:	89 f8                	mov    %edi,%eax
 9ff:	8b 13                	mov    (%ebx),%edx
 a01:	e8 6a fe ff ff       	call   870 <printint>
        ap++;
 a06:	89 d8                	mov    %ebx,%eax
 a08:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a0b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 a0d:	83 c0 04             	add    $0x4,%eax
 a10:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a13:	e9 4d ff ff ff       	jmp    965 <printf+0x55>
 a18:	90                   	nop
 a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 a20:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a23:	8b 18                	mov    (%eax),%ebx
        ap++;
 a25:	83 c0 04             	add    $0x4,%eax
 a28:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 a2b:	b8 54 0d 00 00       	mov    $0xd54,%eax
 a30:	85 db                	test   %ebx,%ebx
 a32:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 a35:	0f b6 03             	movzbl (%ebx),%eax
 a38:	84 c0                	test   %al,%al
 a3a:	74 23                	je     a5f <printf+0x14f>
 a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a40:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a43:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 a46:	83 ec 04             	sub    $0x4,%esp
 a49:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 a4b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a4e:	50                   	push   %eax
 a4f:	57                   	push   %edi
 a50:	e8 4d fd ff ff       	call   7a2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a55:	0f b6 03             	movzbl (%ebx),%eax
 a58:	83 c4 10             	add    $0x10,%esp
 a5b:	84 c0                	test   %al,%al
 a5d:	75 e1                	jne    a40 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a5f:	31 d2                	xor    %edx,%edx
 a61:	e9 ff fe ff ff       	jmp    965 <printf+0x55>
 a66:	8d 76 00             	lea    0x0(%esi),%esi
 a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a70:	83 ec 04             	sub    $0x4,%esp
 a73:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a76:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a79:	6a 01                	push   $0x1
 a7b:	e9 4c ff ff ff       	jmp    9cc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 a80:	83 ec 0c             	sub    $0xc,%esp
 a83:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a88:	6a 01                	push   $0x1
 a8a:	e9 6b ff ff ff       	jmp    9fa <printf+0xea>
 a8f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a92:	83 ec 04             	sub    $0x4,%esp
 a95:	8b 03                	mov    (%ebx),%eax
 a97:	6a 01                	push   $0x1
 a99:	88 45 e4             	mov    %al,-0x1c(%ebp)
 a9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a9f:	50                   	push   %eax
 aa0:	57                   	push   %edi
 aa1:	e8 fc fc ff ff       	call   7a2 <write>
 aa6:	e9 5b ff ff ff       	jmp    a06 <printf+0xf6>
 aab:	66 90                	xchg   %ax,%ax
 aad:	66 90                	xchg   %ax,%ax
 aaf:	90                   	nop

00000ab0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab1:	a1 84 11 00 00       	mov    0x1184,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab6:	89 e5                	mov    %esp,%ebp
 ab8:	57                   	push   %edi
 ab9:	56                   	push   %esi
 aba:	53                   	push   %ebx
 abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 abe:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ac0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac3:	39 c8                	cmp    %ecx,%eax
 ac5:	73 19                	jae    ae0 <free+0x30>
 ac7:	89 f6                	mov    %esi,%esi
 ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 ad0:	39 d1                	cmp    %edx,%ecx
 ad2:	72 1c                	jb     af0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad4:	39 d0                	cmp    %edx,%eax
 ad6:	73 18                	jae    af0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ada:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 adc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ade:	72 f0                	jb     ad0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae0:	39 d0                	cmp    %edx,%eax
 ae2:	72 f4                	jb     ad8 <free+0x28>
 ae4:	39 d1                	cmp    %edx,%ecx
 ae6:	73 f0                	jae    ad8 <free+0x28>
 ae8:	90                   	nop
 ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 af0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 af3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 af6:	39 d7                	cmp    %edx,%edi
 af8:	74 19                	je     b13 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 afa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 afd:	8b 50 04             	mov    0x4(%eax),%edx
 b00:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b03:	39 f1                	cmp    %esi,%ecx
 b05:	74 23                	je     b2a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b07:	89 08                	mov    %ecx,(%eax)
  freep = p;
 b09:	a3 84 11 00 00       	mov    %eax,0x1184
}
 b0e:	5b                   	pop    %ebx
 b0f:	5e                   	pop    %esi
 b10:	5f                   	pop    %edi
 b11:	5d                   	pop    %ebp
 b12:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b13:	03 72 04             	add    0x4(%edx),%esi
 b16:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b19:	8b 10                	mov    (%eax),%edx
 b1b:	8b 12                	mov    (%edx),%edx
 b1d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b20:	8b 50 04             	mov    0x4(%eax),%edx
 b23:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b26:	39 f1                	cmp    %esi,%ecx
 b28:	75 dd                	jne    b07 <free+0x57>
    p->s.size += bp->s.size;
 b2a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 b2d:	a3 84 11 00 00       	mov    %eax,0x1184
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b32:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b35:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b38:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 b3a:	5b                   	pop    %ebx
 b3b:	5e                   	pop    %esi
 b3c:	5f                   	pop    %edi
 b3d:	5d                   	pop    %ebp
 b3e:	c3                   	ret    
 b3f:	90                   	nop

00000b40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	57                   	push   %edi
 b44:	56                   	push   %esi
 b45:	53                   	push   %ebx
 b46:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b49:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b4c:	8b 15 84 11 00 00    	mov    0x1184,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b52:	8d 78 07             	lea    0x7(%eax),%edi
 b55:	c1 ef 03             	shr    $0x3,%edi
 b58:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b5b:	85 d2                	test   %edx,%edx
 b5d:	0f 84 a3 00 00 00    	je     c06 <malloc+0xc6>
 b63:	8b 02                	mov    (%edx),%eax
 b65:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b68:	39 cf                	cmp    %ecx,%edi
 b6a:	76 74                	jbe    be0 <malloc+0xa0>
 b6c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b72:	be 00 10 00 00       	mov    $0x1000,%esi
 b77:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 b7e:	0f 43 f7             	cmovae %edi,%esi
 b81:	ba 00 80 00 00       	mov    $0x8000,%edx
 b86:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 b8c:	0f 46 da             	cmovbe %edx,%ebx
 b8f:	eb 10                	jmp    ba1 <malloc+0x61>
 b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b98:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b9a:	8b 48 04             	mov    0x4(%eax),%ecx
 b9d:	39 cf                	cmp    %ecx,%edi
 b9f:	76 3f                	jbe    be0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ba1:	39 05 84 11 00 00    	cmp    %eax,0x1184
 ba7:	89 c2                	mov    %eax,%edx
 ba9:	75 ed                	jne    b98 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 bab:	83 ec 0c             	sub    $0xc,%esp
 bae:	53                   	push   %ebx
 baf:	e8 56 fc ff ff       	call   80a <sbrk>
  if(p == (char*)-1)
 bb4:	83 c4 10             	add    $0x10,%esp
 bb7:	83 f8 ff             	cmp    $0xffffffff,%eax
 bba:	74 1c                	je     bd8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 bbc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 bbf:	83 ec 0c             	sub    $0xc,%esp
 bc2:	83 c0 08             	add    $0x8,%eax
 bc5:	50                   	push   %eax
 bc6:	e8 e5 fe ff ff       	call   ab0 <free>
  return freep;
 bcb:	8b 15 84 11 00 00    	mov    0x1184,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 bd1:	83 c4 10             	add    $0x10,%esp
 bd4:	85 d2                	test   %edx,%edx
 bd6:	75 c0                	jne    b98 <malloc+0x58>
        return 0;
 bd8:	31 c0                	xor    %eax,%eax
 bda:	eb 1c                	jmp    bf8 <malloc+0xb8>
 bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 be0:	39 cf                	cmp    %ecx,%edi
 be2:	74 1c                	je     c00 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 be4:	29 f9                	sub    %edi,%ecx
 be6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 be9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 bec:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 bef:	89 15 84 11 00 00    	mov    %edx,0x1184
      return (void*)(p + 1);
 bf5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 bfb:	5b                   	pop    %ebx
 bfc:	5e                   	pop    %esi
 bfd:	5f                   	pop    %edi
 bfe:	5d                   	pop    %ebp
 bff:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 c00:	8b 08                	mov    (%eax),%ecx
 c02:	89 0a                	mov    %ecx,(%edx)
 c04:	eb e9                	jmp    bef <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 c06:	c7 05 84 11 00 00 88 	movl   $0x1188,0x1184
 c0d:	11 00 00 
 c10:	c7 05 88 11 00 00 88 	movl   $0x1188,0x1188
 c17:	11 00 00 
    base.s.size = 0;
 c1a:	b8 88 11 00 00       	mov    $0x1188,%eax
 c1f:	c7 05 8c 11 00 00 00 	movl   $0x0,0x118c
 c26:	00 00 00 
 c29:	e9 3e ff ff ff       	jmp    b6c <malloc+0x2c>
