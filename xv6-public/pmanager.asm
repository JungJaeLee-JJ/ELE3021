
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
  11:	68 71 0c 00 00       	push   $0xc71
  16:	e8 ef 07 00 00       	call   80a <getadmin>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	83 f8 ff             	cmp    $0xffffffff,%eax
  21:	0f 84 83 00 00 00    	je     aa <main+0xaa>
       printf(2, "Authentication Failure : Wrong Password\n");
       exit();
  }
  printf(2, "[Process Manager] \n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 7c 0c 00 00       	push   $0xc7c
  2f:	6a 02                	push   $0x2
  31:	e8 9a 08 00 00       	call   8d0 <printf>

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  36:	83 c4 10             	add    $0x10,%esp
  39:	eb 0a                	jmp    45 <main+0x45>
  3b:	90                   	nop
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
  40:	83 f8 02             	cmp    $0x2,%eax
  43:	7f 57                	jg     9c <main+0x9c>
       exit();
  }
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
  45:	83 ec 08             	sub    $0x8,%esp
  48:	6a 02                	push   $0x2
  4a:	68 90 0c 00 00       	push   $0xc90
  4f:	e8 3e 07 00 00       	call   792 <open>
  54:	83 c4 10             	add    $0x10,%esp
  57:	85 c0                	test   %eax,%eax
  59:	79 e5                	jns    40 <main+0x40>
  5b:	eb 31                	jmp    8e <main+0x8e>
  5d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  60:	83 ec 08             	sub    $0x8,%esp
  63:	6a 64                	push   $0x64
  65:	68 e0 10 00 00       	push   $0x10e0
  6a:	e8 51 00 00 00       	call   c0 <getcmd>
  6f:	83 c4 10             	add    $0x10,%esp
  72:	85 c0                	test   %eax,%eax
  74:	78 21                	js     97 <main+0x97>
    runcmd(parsing(buf));
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	68 e0 10 00 00       	push   $0x10e0
  7e:	e8 fd 02 00 00       	call   380 <parsing>
  83:	89 04 24             	mov    %eax,(%esp)
  86:	e8 c5 00 00 00       	call   150 <runcmd>
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	a1 c0 10 00 00       	mov    0x10c0,%eax
  93:	85 c0                	test   %eax,%eax
  95:	74 c9                	je     60 <main+0x60>
    runcmd(parsing(buf));
  }
  exit();
  97:	e8 b6 06 00 00       	call   752 <exit>
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
  9c:	83 ec 0c             	sub    $0xc,%esp
  9f:	50                   	push   %eax
  a0:	e8 d5 06 00 00       	call   77a <close>
      break;
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	eb e4                	jmp    8e <main+0x8e>
  static char buf[100];
  int fd;
  
  //관리자 권한 획득
  if (getadmin("2016025823") == -1){
       printf(2, "Authentication Failure : Wrong Password\n");
  aa:	52                   	push   %edx
  ab:	52                   	push   %edx
  ac:	68 d0 0c 00 00       	push   $0xcd0
  b1:	6a 02                	push   $0x2
  b3:	e8 18 08 00 00       	call   8d0 <printf>
       exit();
  b8:	e8 95 06 00 00       	call   752 <exit>
  bd:	66 90                	xchg   %ax,%ax
  bf:	90                   	nop

000000c0 <getcmd>:
}


int
getcmd(char *buf, int nbuf)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	56                   	push   %esi
  c4:	53                   	push   %ebx
  c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "> ");
  cb:	83 ec 08             	sub    $0x8,%esp
  ce:	68 f0 0b 00 00       	push   $0xbf0
  d3:	6a 02                	push   $0x2
  d5:	e8 f6 07 00 00       	call   8d0 <printf>
  memset(buf, 0, nbuf);
  da:	83 c4 0c             	add    $0xc,%esp
  dd:	56                   	push   %esi
  de:	6a 00                	push   $0x0
  e0:	53                   	push   %ebx
  e1:	e8 da 04 00 00       	call   5c0 <memset>
  gets(buf, nbuf);
  e6:	58                   	pop    %eax
  e7:	5a                   	pop    %edx
  e8:	56                   	push   %esi
  e9:	53                   	push   %ebx
  ea:	e8 31 05 00 00       	call   620 <gets>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	31 c0                	xor    %eax,%eax
  f4:	80 3b 00             	cmpb   $0x0,(%ebx)
  f7:	0f 94 c0             	sete   %al
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
  fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  fd:	f7 d8                	neg    %eax
  ff:	5b                   	pop    %ebx
 100:	5e                   	pop    %esi
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    
 103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <wrong_input>:

void 
wrong_input()
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 10             	sub    $0x10,%esp
    printf(2, "It is Wrong input. \n");
 116:	68 f3 0b 00 00       	push   $0xbf3
 11b:	6a 02                	push   $0x2
 11d:	e8 ae 07 00 00       	call   8d0 <printf>
}
 122:	83 c4 10             	add    $0x10,%esp
 125:	c9                   	leave  
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <panic>:


void
panic(char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 136:	ff 75 08             	pushl  0x8(%ebp)
 139:	68 08 0c 00 00       	push   $0xc08
 13e:	6a 02                	push   $0x2
 140:	e8 8b 07 00 00       	call   8d0 <printf>
  exit();
 145:	e8 08 06 00 00       	call   752 <exit>
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <runcmd>:

int finish = 0;

void
runcmd(struct cmd *cmd)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	56                   	push   %esi
 154:	53                   	push   %ebx
 155:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //명령어가 입력되지 않은 경우
  if(cmd == 0) wrong_input();
 158:	85 db                	test   %ebx,%ebx
 15a:	0f 84 b8 01 00 00    	je     318 <runcmd+0x1c8>

  switch(cmd->type){
 160:	83 3b 05             	cmpl   $0x5,(%ebx)
 163:	77 0b                	ja     170 <runcmd+0x20>
 165:	8b 03                	mov    (%ebx),%eax
 167:	ff 24 85 fc 0c 00 00 	jmp    *0xcfc(,%eax,4)
 16e:	66 90                	xchg   %ax,%ax
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 170:	83 ec 08             	sub    $0x8,%esp
 173:	68 f3 0b 00 00       	push   $0xbf3
 178:	6a 02                	push   $0x2
 17a:	e8 51 07 00 00       	call   8d0 <printf>
 17f:	83 c4 10             	add    $0x10,%esp
  case EXIT:
    printf(2,"Terminate Pmanager \n");
    finish = 1;
    break;
  }
}
 182:	8d 65 f8             	lea    -0x8(%ebp),%esp
 185:	5b                   	pop    %ebx
 186:	5e                   	pop    %esi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else{
        printf(2,"Fail to set Memory Limit\n");
    }
    break;
  case EXIT:
    printf(2,"Terminate Pmanager \n");
 190:	83 ec 08             	sub    $0x8,%esp
 193:	68 5c 0c 00 00       	push   $0xc5c
 198:	6a 02                	push   $0x2
 19a:	e8 31 07 00 00       	call   8d0 <printf>
    finish = 1;
 19f:	c7 05 c0 10 00 00 01 	movl   $0x1,0x10c0
 1a6:	00 00 00 
    break;
 1a9:	83 c4 10             	add    $0x10,%esp
  }
}
 1ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1af:	5b                   	pop    %ebx
 1b0:	5e                   	pop    %esi
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	90                   	nop
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bb:	5b                   	pop    %ebx
 1bc:	5e                   	pop    %esi
 1bd:	5d                   	pop    %ebp
  default:
	wrong_input();
	break;

  case LIST:
    list();
 1be:	e9 5f 06 00 00       	jmp    822 <list>
 1c3:	90                   	nop
 1c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    break;

  case KILL:
    //입력 유효 검사
    if(cmd->first_arg == 0) {
 1c8:	8b 43 04             	mov    0x4(%ebx),%eax
 1cb:	85 c0                	test   %eax,%eax
 1cd:	74 a1                	je     170 <runcmd+0x20>
        wrong_input();
    }
 
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg)) == 0){
 1cf:	83 ec 0c             	sub    $0xc,%esp
 1d2:	50                   	push   %eax
 1d3:	e8 08 05 00 00       	call   6e0 <atoi>
 1d8:	89 04 24             	mov    %eax,(%esp)
 1db:	e8 a2 05 00 00       	call   782 <kill>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	85 c0                	test   %eax,%eax
 1e5:	0f 85 05 01 00 00    	jne    2f0 <runcmd+0x1a0>
        printf(2, "Success to kill %d\n",atoi(cmd->first_arg));
 1eb:	83 ec 0c             	sub    $0xc,%esp
 1ee:	ff 73 04             	pushl  0x4(%ebx)
 1f1:	e8 ea 04 00 00       	call   6e0 <atoi>
 1f6:	83 c4 0c             	add    $0xc,%esp
 1f9:	50                   	push   %eax
 1fa:	68 0c 0c 00 00       	push   $0xc0c
 1ff:	6a 02                	push   $0x2
 201:	e8 ca 06 00 00       	call   8d0 <printf>
        wait();
 206:	83 c4 10             	add    $0x10,%esp
  case EXIT:
    printf(2,"Terminate Pmanager \n");
    finish = 1;
    break;
  }
}
 209:	8d 65 f8             	lea    -0x8(%ebp),%esp
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5d                   	pop    %ebp
    }
 
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg)) == 0){
        printf(2, "Success to kill %d\n",atoi(cmd->first_arg));
        wait();
 20f:	e9 46 05 00 00       	jmp    75a <wait>
 214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	}
    break;

  case EXEC2:
	//인자가 2개일때
	if(cmd->second_arg != 0) *(cmd->second_arg-1) = 0;
 218:	8b 43 08             	mov    0x8(%ebx),%eax
 21b:	85 c0                	test   %eax,%eax
 21d:	74 04                	je     223 <runcmd+0xd3>
 21f:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)

int
fork1(void)
{
  int pid;
  pid = fork();
 223:	e8 22 05 00 00       	call   74a <fork>
  if(pid == -1)
 228:	83 f8 ff             	cmp    $0xffffffff,%eax
 22b:	0f 84 16 01 00 00    	je     347 <runcmd+0x1f7>

  case EXEC2:
	//인자가 2개일때
	if(cmd->second_arg != 0) *(cmd->second_arg-1) = 0;
    //프로세스 생성
	 if(fork1() == 0){
 231:	85 c0                	test   %eax,%eax
 233:	0f 85 49 ff ff ff    	jne    182 <runcmd+0x32>
      //exec2 명령어 실
		if(exec2(cmd->first_arg,&(cmd->first_arg),atoi(cmd->second_arg)) == -1) printf(2, "EXEC fail!\n");
 239:	83 ec 0c             	sub    $0xc,%esp
 23c:	ff 73 08             	pushl  0x8(%ebx)
 23f:	e8 9c 04 00 00       	call   6e0 <atoi>
 244:	83 c4 0c             	add    $0xc,%esp
 247:	50                   	push   %eax
 248:	8d 43 04             	lea    0x4(%ebx),%eax
 24b:	50                   	push   %eax
 24c:	ff 73 04             	pushl  0x4(%ebx)
 24f:	e8 be 05 00 00       	call   812 <exec2>
 254:	83 c4 10             	add    $0x10,%esp
 257:	83 f8 ff             	cmp    $0xffffffff,%eax
 25a:	0f 85 22 ff ff ff    	jne    182 <runcmd+0x32>
 260:	83 ec 08             	sub    $0x8,%esp
 263:	68 36 0c 00 00       	push   $0xc36
 268:	6a 02                	push   $0x2
 26a:	e8 61 06 00 00       	call   8d0 <printf>
 26f:	83 c4 10             	add    $0x10,%esp
 272:	e9 0b ff ff ff       	jmp    182 <runcmd+0x32>
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    break; 
  case MEMLIMIT:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
 280:	8b 4b 04             	mov    0x4(%ebx),%ecx
 283:	85 c9                	test   %ecx,%ecx
 285:	0f 84 e5 fe ff ff    	je     170 <runcmd+0x20>
 28b:	8b 43 08             	mov    0x8(%ebx),%eax
 28e:	85 c0                	test   %eax,%eax
 290:	0f 84 da fe ff ff    	je     170 <runcmd+0x20>
        wrong_input();
    }
	else if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
 296:	83 ec 0c             	sub    $0xc,%esp
 299:	50                   	push   %eax
 29a:	e8 41 04 00 00       	call   6e0 <atoi>
 29f:	5a                   	pop    %edx
 2a0:	ff 73 04             	pushl  0x4(%ebx)
 2a3:	89 c6                	mov    %eax,%esi
 2a5:	e8 36 04 00 00       	call   6e0 <atoi>
 2aa:	59                   	pop    %ecx
 2ab:	5a                   	pop    %edx
 2ac:	56                   	push   %esi
 2ad:	50                   	push   %eax
 2ae:	e8 67 05 00 00       	call   81a <setmemorylimit>
 2b3:	83 c4 10             	add    $0x10,%esp
 2b6:	85 c0                	test   %eax,%eax
 2b8:	75 76                	jne    330 <runcmd+0x1e0>
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	ff 73 08             	pushl  0x8(%ebx)
 2c0:	e8 1b 04 00 00       	call   6e0 <atoi>
 2c5:	89 c6                	mov    %eax,%esi
 2c7:	58                   	pop    %eax
 2c8:	ff 73 04             	pushl  0x4(%ebx)
 2cb:	e8 10 04 00 00       	call   6e0 <atoi>
 2d0:	56                   	push   %esi
 2d1:	50                   	push   %eax
 2d2:	68 98 0c 00 00       	push   $0xc98
 2d7:	6a 02                	push   $0x2
 2d9:	e8 f2 05 00 00       	call   8d0 <printf>
 2de:	83 c4 20             	add    $0x20,%esp
 2e1:	e9 9c fe ff ff       	jmp    182 <runcmd+0x32>
 2e6:	8d 76 00             	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg)) == 0){
        printf(2, "Success to kill %d\n",atoi(cmd->first_arg));
        wait();
    }else{
		printf(2,"Fail to kill %d\n",atoi(cmd->first_arg));
 2f0:	83 ec 0c             	sub    $0xc,%esp
 2f3:	ff 73 04             	pushl  0x4(%ebx)
 2f6:	e8 e5 03 00 00       	call   6e0 <atoi>
 2fb:	83 c4 0c             	add    $0xc,%esp
 2fe:	50                   	push   %eax
 2ff:	68 20 0c 00 00       	push   $0xc20
 304:	6a 02                	push   $0x2
 306:	e8 c5 05 00 00       	call   8d0 <printf>
 30b:	83 c4 10             	add    $0x10,%esp
 30e:	e9 6f fe ff ff       	jmp    182 <runcmd+0x32>
 313:	90                   	nop
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 318:	83 ec 08             	sub    $0x8,%esp
 31b:	68 f3 0b 00 00       	push   $0xbf3
 320:	6a 02                	push   $0x2
 322:	e8 a9 05 00 00       	call   8d0 <printf>
 327:	83 c4 10             	add    $0x10,%esp
 32a:	e9 31 fe ff ff       	jmp    160 <runcmd+0x10>
 32f:	90                   	nop
    }
	else if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
    }
    else{
        printf(2,"Fail to set Memory Limit\n");
 330:	83 ec 08             	sub    $0x8,%esp
 333:	68 42 0c 00 00       	push   $0xc42
 338:	6a 02                	push   $0x2
 33a:	e8 91 05 00 00       	call   8d0 <printf>
 33f:	83 c4 10             	add    $0x10,%esp
 342:	e9 3b fe ff ff       	jmp    182 <runcmd+0x32>
fork1(void)
{
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
 347:	83 ec 0c             	sub    $0xc,%esp
 34a:	68 31 0c 00 00       	push   $0xc31
 34f:	e8 dc fd ff ff       	call   130 <panic>
 354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 35a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000360 <fork1>:
  exit();
}

int
fork1(void)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 08             	sub    $0x8,%esp
  int pid;
  pid = fork();
 366:	e8 df 03 00 00       	call   74a <fork>
  if(pid == -1)
 36b:	83 f8 ff             	cmp    $0xffffffff,%eax
 36e:	74 02                	je     372 <fork1+0x12>
    panic("fork");
  return pid;
}
 370:	c9                   	leave  
 371:	c3                   	ret    
fork1(void)
{
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
 372:	83 ec 0c             	sub    $0xc,%esp
 375:	68 31 0c 00 00       	push   $0xc31
 37a:	e8 b1 fd ff ff       	call   130 <panic>
 37f:	90                   	nop

00000380 <parsing>:
  exit();
}

struct cmd*
parsing(char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	8b 75 08             	mov    0x8(%ebp),%esi
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
 388:	83 ec 0c             	sub    $0xc,%esp
 38b:	6a 0c                	push   $0xc
 38d:	e8 6e 07 00 00       	call   b00 <malloc>
  
  //초기화
  memset(command,0,sizeof(*command));
 392:	83 c4 0c             	add    $0xc,%esp
{
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
 395:	89 c3                	mov    %eax,%ebx
  
  //초기화
  memset(command,0,sizeof(*command));
 397:	6a 0c                	push   $0xc
 399:	6a 00                	push   $0x0
 39b:	50                   	push   %eax
 39c:	e8 1f 02 00 00       	call   5c0 <memset>
  memset(command->first_arg,0,sizeof(char*));
 3a1:	83 c4 0c             	add    $0xc,%esp
 3a4:	6a 04                	push   $0x4
 3a6:	6a 00                	push   $0x0
 3a8:	ff 73 04             	pushl  0x4(%ebx)
 3ab:	e8 10 02 00 00       	call   5c0 <memset>
  memset(command->second_arg,0,sizeof(char*));
 3b0:	83 c4 0c             	add    $0xc,%esp
 3b3:	6a 04                	push   $0x4
 3b5:	6a 00                	push   $0x0
 3b7:	ff 73 08             	pushl  0x8(%ebx)
 3ba:	e8 01 02 00 00       	call   5c0 <memset>
 3bf:	8d 46 01             	lea    0x1(%esi),%eax
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
 3d6:	74 1f                	je     3f7 <parsing+0x77>

  //각 인자의 시작 인덱스를 저장한다.
  while(1){
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
 3d8:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 3dc:	80 fa 20             	cmp    $0x20,%dl
 3df:	75 ef                	jne    3d0 <parsing+0x50>
         //첫번째 인자일 때
         if(command->first_arg == 0){
 3e1:	8b 53 04             	mov    0x4(%ebx),%edx
 3e4:	85 d2                	test   %edx,%edx
 3e6:	74 58                	je     440 <parsing+0xc0>
             command->first_arg = &s[index+1];
         }
         //두번째 인자일 때
         else 
         {
             command->second_arg = &s[index+1];
 3e8:	89 43 08             	mov    %eax,0x8(%ebx)
 3eb:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 3ef:	83 c0 01             	add    $0x1,%eax
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 3f2:	80 fa 0a             	cmp    $0xa,%dl
 3f5:	75 e1                	jne    3d8 <parsing+0x58>
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
 3f7:	0f b6 06             	movzbl (%esi),%eax
 3fa:	3c 6c                	cmp    $0x6c,%al
 3fc:	74 52                	je     450 <parsing+0xd0>
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
 3fe:	3c 6b                	cmp    $0x6b,%al
 400:	74 1e                	je     420 <parsing+0xa0>
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 402:	3c 65                	cmp    $0x65,%al
 404:	75 6a                	jne    470 <parsing+0xf0>
 406:	80 7e 01 78          	cmpb   $0x78,0x1(%esi)
 40a:	0f 84 98 00 00 00    	je     4a8 <parsing+0x128>
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='e'&&s[3]=='c'&&s[4]=='u'&&s[5]=='t'&&s[6]=='e' ) command->type = 3;

  
  //printf(2," %d %s %s\n",command->type, command->first_arg, command->second_arg);
  return command;
}
 410:	8d 65 f8             	lea    -0x8(%ebp),%esp
 413:	89 d8                	mov    %ebx,%eax
 415:	5b                   	pop    %ebx
 416:	5e                   	pop    %esi
 417:	5d                   	pop    %ebp
 418:	c3                   	ret    
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(s[index] == '\n') break;
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
 420:	80 7e 01 69          	cmpb   $0x69,0x1(%esi)
 424:	75 ea                	jne    410 <parsing+0x90>
 426:	80 7e 02 6c          	cmpb   $0x6c,0x2(%esi)
 42a:	75 e4                	jne    410 <parsing+0x90>
 42c:	80 7e 03 6c          	cmpb   $0x6c,0x3(%esi)
 430:	75 de                	jne    410 <parsing+0x90>
 432:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
 438:	eb d6                	jmp    410 <parsing+0x90>
 43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
         //첫번째 인자일 때
         if(command->first_arg == 0){
             command->first_arg = &s[index+1];
 440:	89 43 04             	mov    %eax,0x4(%ebx)
 443:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 447:	eb 87                	jmp    3d0 <parsing+0x50>
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      //종료조건
      if(s[index] == '\n') break;
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
 450:	80 7e 01 69          	cmpb   $0x69,0x1(%esi)
 454:	75 ba                	jne    410 <parsing+0x90>
 456:	80 7e 02 73          	cmpb   $0x73,0x2(%esi)
 45a:	75 b4                	jne    410 <parsing+0x90>
 45c:	80 7e 03 74          	cmpb   $0x74,0x3(%esi)
 460:	75 ae                	jne    410 <parsing+0x90>
 462:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
 468:	eb a6                	jmp    410 <parsing+0x90>
 46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
 470:	3c 6d                	cmp    $0x6d,%al
 472:	75 9c                	jne    410 <parsing+0x90>
 474:	80 7e 01 65          	cmpb   $0x65,0x1(%esi)
 478:	75 96                	jne    410 <parsing+0x90>
 47a:	80 7e 02 6d          	cmpb   $0x6d,0x2(%esi)
 47e:	75 90                	jne    410 <parsing+0x90>
 480:	80 7e 03 6c          	cmpb   $0x6c,0x3(%esi)
 484:	75 8a                	jne    410 <parsing+0x90>
 486:	80 7e 04 69          	cmpb   $0x69,0x4(%esi)
 48a:	75 84                	jne    410 <parsing+0x90>
 48c:	80 7e 05 6d          	cmpb   $0x6d,0x5(%esi)
 490:	0f 85 7a ff ff ff    	jne    410 <parsing+0x90>
 496:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
 49c:	e9 6f ff ff ff       	jmp    410 <parsing+0x90>
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 4a8:	80 7e 02 69          	cmpb   $0x69,0x2(%esi)
 4ac:	74 42                	je     4f0 <parsing+0x170>
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='e'&&s[3]=='c'&&s[4]=='u'&&s[5]=='t'&&s[6]=='e' ) command->type = 3;
 4ae:	80 7e 02 65          	cmpb   $0x65,0x2(%esi)
 4b2:	0f 85 58 ff ff ff    	jne    410 <parsing+0x90>
 4b8:	80 7e 03 63          	cmpb   $0x63,0x3(%esi)
 4bc:	0f 85 4e ff ff ff    	jne    410 <parsing+0x90>
 4c2:	80 7e 04 75          	cmpb   $0x75,0x4(%esi)
 4c6:	0f 85 44 ff ff ff    	jne    410 <parsing+0x90>
 4cc:	80 7e 05 74          	cmpb   $0x74,0x5(%esi)
 4d0:	0f 85 3a ff ff ff    	jne    410 <parsing+0x90>
 4d6:	80 7e 06 65          	cmpb   $0x65,0x6(%esi)
 4da:	0f 85 30 ff ff ff    	jne    410 <parsing+0x90>
 4e0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
 4e6:	e9 25 ff ff ff       	jmp    410 <parsing+0x90>
 4eb:	90                   	nop
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 4f0:	80 7e 03 74          	cmpb   $0x74,0x3(%esi)
 4f4:	75 b8                	jne    4ae <parsing+0x12e>
 4f6:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
 4fc:	e9 0f ff ff ff       	jmp    410 <parsing+0x90>
 501:	66 90                	xchg   %ax,%ax
 503:	66 90                	xchg   %ax,%ax
 505:	66 90                	xchg   %ax,%ax
 507:	66 90                	xchg   %ax,%ax
 509:	66 90                	xchg   %ax,%ax
 50b:	66 90                	xchg   %ax,%ax
 50d:	66 90                	xchg   %ax,%ax
 50f:	90                   	nop

00000510 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 51a:	89 c2                	mov    %eax,%edx
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 520:	83 c1 01             	add    $0x1,%ecx
 523:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 527:	83 c2 01             	add    $0x1,%edx
 52a:	84 db                	test   %bl,%bl
 52c:	88 5a ff             	mov    %bl,-0x1(%edx)
 52f:	75 ef                	jne    520 <strcpy+0x10>
    ;
  return os;
}
 531:	5b                   	pop    %ebx
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    
 534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 53a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000540 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
 545:	8b 55 08             	mov    0x8(%ebp),%edx
 548:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q){
 54b:	0f b6 02             	movzbl (%edx),%eax
 54e:	0f b6 19             	movzbl (%ecx),%ebx
 551:	84 c0                	test   %al,%al
 553:	75 1e                	jne    573 <strcmp+0x33>
 555:	eb 29                	jmp    580 <strcmp+0x40>
 557:	89 f6                	mov    %esi,%esi
 559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 560:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 563:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 566:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 569:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 56d:	84 c0                	test   %al,%al
 56f:	74 0f                	je     580 <strcmp+0x40>
 571:	89 f1                	mov    %esi,%ecx
 573:	38 d8                	cmp    %bl,%al
 575:	74 e9                	je     560 <strcmp+0x20>
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 577:	29 d8                	sub    %ebx,%eax
}
 579:	5b                   	pop    %ebx
 57a:	5e                   	pop    %esi
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 580:	31 c0                	xor    %eax,%eax
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 582:	29 d8                	sub    %ebx,%eax
}
 584:	5b                   	pop    %ebx
 585:	5e                   	pop    %esi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	90                   	nop
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <strlen>:

uint
strlen(const char *s)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 596:	80 39 00             	cmpb   $0x0,(%ecx)
 599:	74 12                	je     5ad <strlen+0x1d>
 59b:	31 d2                	xor    %edx,%edx
 59d:	8d 76 00             	lea    0x0(%esi),%esi
 5a0:	83 c2 01             	add    $0x1,%edx
 5a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 5a7:	89 d0                	mov    %edx,%eax
 5a9:	75 f5                	jne    5a0 <strlen+0x10>
    ;
  return n;
}
 5ab:	5d                   	pop    %ebp
 5ac:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 5ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 5af:	5d                   	pop    %ebp
 5b0:	c3                   	ret    
 5b1:	eb 0d                	jmp    5c0 <memset>
 5b3:	90                   	nop
 5b4:	90                   	nop
 5b5:	90                   	nop
 5b6:	90                   	nop
 5b7:	90                   	nop
 5b8:	90                   	nop
 5b9:	90                   	nop
 5ba:	90                   	nop
 5bb:	90                   	nop
 5bc:	90                   	nop
 5bd:	90                   	nop
 5be:	90                   	nop
 5bf:	90                   	nop

000005c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cd:	89 d7                	mov    %edx,%edi
 5cf:	fc                   	cld    
 5d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5d2:	89 d0                	mov    %edx,%eax
 5d4:	5f                   	pop    %edi
 5d5:	5d                   	pop    %ebp
 5d6:	c3                   	ret    
 5d7:	89 f6                	mov    %esi,%esi
 5d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005e0 <strchr>:

char*
strchr(const char *s, char c)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	53                   	push   %ebx
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 5ea:	0f b6 10             	movzbl (%eax),%edx
 5ed:	84 d2                	test   %dl,%dl
 5ef:	74 1d                	je     60e <strchr+0x2e>
    if(*s == c)
 5f1:	38 d3                	cmp    %dl,%bl
 5f3:	89 d9                	mov    %ebx,%ecx
 5f5:	75 0d                	jne    604 <strchr+0x24>
 5f7:	eb 17                	jmp    610 <strchr+0x30>
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 600:	38 ca                	cmp    %cl,%dl
 602:	74 0c                	je     610 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 604:	83 c0 01             	add    $0x1,%eax
 607:	0f b6 10             	movzbl (%eax),%edx
 60a:	84 d2                	test   %dl,%dl
 60c:	75 f2                	jne    600 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 60e:	31 c0                	xor    %eax,%eax
}
 610:	5b                   	pop    %ebx
 611:	5d                   	pop    %ebp
 612:	c3                   	ret    
 613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000620 <gets>:

char*
gets(char *buf, int max)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 626:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 628:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 62b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 62e:	eb 29                	jmp    659 <gets+0x39>
    cc = read(0, &c, 1);
 630:	83 ec 04             	sub    $0x4,%esp
 633:	6a 01                	push   $0x1
 635:	57                   	push   %edi
 636:	6a 00                	push   $0x0
 638:	e8 2d 01 00 00       	call   76a <read>
    if(cc < 1)
 63d:	83 c4 10             	add    $0x10,%esp
 640:	85 c0                	test   %eax,%eax
 642:	7e 1d                	jle    661 <gets+0x41>
      break;
    buf[i++] = c;
 644:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 648:	8b 55 08             	mov    0x8(%ebp),%edx
 64b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 64d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 64f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 653:	74 1b                	je     670 <gets+0x50>
 655:	3c 0d                	cmp    $0xd,%al
 657:	74 17                	je     670 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 659:	8d 5e 01             	lea    0x1(%esi),%ebx
 65c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 65f:	7c cf                	jl     630 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 661:	8b 45 08             	mov    0x8(%ebp),%eax
 664:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 668:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66b:	5b                   	pop    %ebx
 66c:	5e                   	pop    %esi
 66d:	5f                   	pop    %edi
 66e:	5d                   	pop    %ebp
 66f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 670:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 673:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 675:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 679:	8d 65 f4             	lea    -0xc(%ebp),%esp
 67c:	5b                   	pop    %ebx
 67d:	5e                   	pop    %esi
 67e:	5f                   	pop    %edi
 67f:	5d                   	pop    %ebp
 680:	c3                   	ret    
 681:	eb 0d                	jmp    690 <stat>
 683:	90                   	nop
 684:	90                   	nop
 685:	90                   	nop
 686:	90                   	nop
 687:	90                   	nop
 688:	90                   	nop
 689:	90                   	nop
 68a:	90                   	nop
 68b:	90                   	nop
 68c:	90                   	nop
 68d:	90                   	nop
 68e:	90                   	nop
 68f:	90                   	nop

00000690 <stat>:

int
stat(const char *n, struct stat *st)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	56                   	push   %esi
 694:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 695:	83 ec 08             	sub    $0x8,%esp
 698:	6a 00                	push   $0x0
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 f0 00 00 00       	call   792 <open>
  if(fd < 0)
 6a2:	83 c4 10             	add    $0x10,%esp
 6a5:	85 c0                	test   %eax,%eax
 6a7:	78 27                	js     6d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 6a9:	83 ec 08             	sub    $0x8,%esp
 6ac:	ff 75 0c             	pushl  0xc(%ebp)
 6af:	89 c3                	mov    %eax,%ebx
 6b1:	50                   	push   %eax
 6b2:	e8 f3 00 00 00       	call   7aa <fstat>
 6b7:	89 c6                	mov    %eax,%esi
  close(fd);
 6b9:	89 1c 24             	mov    %ebx,(%esp)
 6bc:	e8 b9 00 00 00       	call   77a <close>
  return r;
 6c1:	83 c4 10             	add    $0x10,%esp
 6c4:	89 f0                	mov    %esi,%eax
}
 6c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6c9:	5b                   	pop    %ebx
 6ca:	5e                   	pop    %esi
 6cb:	5d                   	pop    %ebp
 6cc:	c3                   	ret    
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 6d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6d5:	eb ef                	jmp    6c6 <stat+0x36>
 6d7:	89 f6                	mov    %esi,%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	53                   	push   %ebx
 6e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6e7:	0f be 11             	movsbl (%ecx),%edx
 6ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 6ed:	3c 09                	cmp    $0x9,%al
 6ef:	b8 00 00 00 00       	mov    $0x0,%eax
 6f4:	77 1f                	ja     715 <atoi+0x35>
 6f6:	8d 76 00             	lea    0x0(%esi),%esi
 6f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 700:	8d 04 80             	lea    (%eax,%eax,4),%eax
 703:	83 c1 01             	add    $0x1,%ecx
 706:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 70a:	0f be 11             	movsbl (%ecx),%edx
 70d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 710:	80 fb 09             	cmp    $0x9,%bl
 713:	76 eb                	jbe    700 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 715:	5b                   	pop    %ebx
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	90                   	nop
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000720 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	56                   	push   %esi
 724:	53                   	push   %ebx
 725:	8b 5d 10             	mov    0x10(%ebp),%ebx
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 72e:	85 db                	test   %ebx,%ebx
 730:	7e 14                	jle    746 <memmove+0x26>
 732:	31 d2                	xor    %edx,%edx
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 738:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 73c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 73f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 742:	39 da                	cmp    %ebx,%edx
 744:	75 f2                	jne    738 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 746:	5b                   	pop    %ebx
 747:	5e                   	pop    %esi
 748:	5d                   	pop    %ebp
 749:	c3                   	ret    

0000074a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 74a:	b8 01 00 00 00       	mov    $0x1,%eax
 74f:	cd 40                	int    $0x40
 751:	c3                   	ret    

00000752 <exit>:
SYSCALL(exit)
 752:	b8 02 00 00 00       	mov    $0x2,%eax
 757:	cd 40                	int    $0x40
 759:	c3                   	ret    

0000075a <wait>:
SYSCALL(wait)
 75a:	b8 03 00 00 00       	mov    $0x3,%eax
 75f:	cd 40                	int    $0x40
 761:	c3                   	ret    

00000762 <pipe>:
SYSCALL(pipe)
 762:	b8 04 00 00 00       	mov    $0x4,%eax
 767:	cd 40                	int    $0x40
 769:	c3                   	ret    

0000076a <read>:
SYSCALL(read)
 76a:	b8 05 00 00 00       	mov    $0x5,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <write>:
SYSCALL(write)
 772:	b8 10 00 00 00       	mov    $0x10,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <close>:
SYSCALL(close)
 77a:	b8 15 00 00 00       	mov    $0x15,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <kill>:
SYSCALL(kill)
 782:	b8 06 00 00 00       	mov    $0x6,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <exec>:
SYSCALL(exec)
 78a:	b8 07 00 00 00       	mov    $0x7,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <open>:
SYSCALL(open)
 792:	b8 0f 00 00 00       	mov    $0xf,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <mknod>:
SYSCALL(mknod)
 79a:	b8 11 00 00 00       	mov    $0x11,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <unlink>:
SYSCALL(unlink)
 7a2:	b8 12 00 00 00       	mov    $0x12,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <fstat>:
SYSCALL(fstat)
 7aa:	b8 08 00 00 00       	mov    $0x8,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <link>:
SYSCALL(link)
 7b2:	b8 13 00 00 00       	mov    $0x13,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <mkdir>:
SYSCALL(mkdir)
 7ba:	b8 14 00 00 00       	mov    $0x14,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <chdir>:
SYSCALL(chdir)
 7c2:	b8 09 00 00 00       	mov    $0x9,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <dup>:
SYSCALL(dup)
 7ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <getpid>:
SYSCALL(getpid)
 7d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <sbrk>:
SYSCALL(sbrk)
 7da:	b8 0c 00 00 00       	mov    $0xc,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <sleep>:
SYSCALL(sleep)
 7e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <uptime>:
SYSCALL(uptime)
 7ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <yield>:
SYSCALL(yield)
 7f2:	b8 16 00 00 00       	mov    $0x16,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <getlev>:
SYSCALL(getlev)
 7fa:	b8 17 00 00 00       	mov    $0x17,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <setpriority>:
SYSCALL(setpriority)
 802:	b8 18 00 00 00       	mov    $0x18,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <getadmin>:
SYSCALL(getadmin)
 80a:	b8 19 00 00 00       	mov    $0x19,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <exec2>:
SYSCALL(exec2)
 812:	b8 1a 00 00 00       	mov    $0x1a,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <setmemorylimit>:
SYSCALL(setmemorylimit)
 81a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <list>:
SYSCALL(list)
 822:	b8 1c 00 00 00       	mov    $0x1c,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    
 82a:	66 90                	xchg   %ax,%ax
 82c:	66 90                	xchg   %ax,%ax
 82e:	66 90                	xchg   %ax,%ax

00000830 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	89 c6                	mov    %eax,%esi
 838:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 83b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 83e:	85 db                	test   %ebx,%ebx
 840:	74 7e                	je     8c0 <printint+0x90>
 842:	89 d0                	mov    %edx,%eax
 844:	c1 e8 1f             	shr    $0x1f,%eax
 847:	84 c0                	test   %al,%al
 849:	74 75                	je     8c0 <printint+0x90>
    neg = 1;
    x = -xx;
 84b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 84d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 854:	f7 d8                	neg    %eax
 856:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 859:	31 ff                	xor    %edi,%edi
 85b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 85e:	89 ce                	mov    %ecx,%esi
 860:	eb 08                	jmp    86a <printint+0x3a>
 862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 868:	89 cf                	mov    %ecx,%edi
 86a:	31 d2                	xor    %edx,%edx
 86c:	8d 4f 01             	lea    0x1(%edi),%ecx
 86f:	f7 f6                	div    %esi
 871:	0f b6 92 1c 0d 00 00 	movzbl 0xd1c(%edx),%edx
  }while((x /= base) != 0);
 878:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 87a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 87d:	75 e9                	jne    868 <printint+0x38>
  if(neg)
 87f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 882:	8b 75 c0             	mov    -0x40(%ebp),%esi
 885:	85 c0                	test   %eax,%eax
 887:	74 08                	je     891 <printint+0x61>
    buf[i++] = '-';
 889:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 88e:	8d 4f 02             	lea    0x2(%edi),%ecx
 891:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 895:	8d 76 00             	lea    0x0(%esi),%esi
 898:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 89b:	83 ec 04             	sub    $0x4,%esp
 89e:	83 ef 01             	sub    $0x1,%edi
 8a1:	6a 01                	push   $0x1
 8a3:	53                   	push   %ebx
 8a4:	56                   	push   %esi
 8a5:	88 45 d7             	mov    %al,-0x29(%ebp)
 8a8:	e8 c5 fe ff ff       	call   772 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	39 df                	cmp    %ebx,%edi
 8b2:	75 e4                	jne    898 <printint+0x68>
    putc(fd, buf[i]);
}
 8b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8b7:	5b                   	pop    %ebx
 8b8:	5e                   	pop    %esi
 8b9:	5f                   	pop    %edi
 8ba:	5d                   	pop    %ebp
 8bb:	c3                   	ret    
 8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8c0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8c2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 8c9:	eb 8b                	jmp    856 <printint+0x26>
 8cb:	90                   	nop
 8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8d6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8d9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8dc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8df:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 8e5:	0f b6 1e             	movzbl (%esi),%ebx
 8e8:	83 c6 01             	add    $0x1,%esi
 8eb:	84 db                	test   %bl,%bl
 8ed:	0f 84 b0 00 00 00    	je     9a3 <printf+0xd3>
 8f3:	31 d2                	xor    %edx,%edx
 8f5:	eb 39                	jmp    930 <printf+0x60>
 8f7:	89 f6                	mov    %esi,%esi
 8f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 900:	83 f8 25             	cmp    $0x25,%eax
 903:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 906:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 90b:	74 18                	je     925 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 90d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 910:	83 ec 04             	sub    $0x4,%esp
 913:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 916:	6a 01                	push   $0x1
 918:	50                   	push   %eax
 919:	57                   	push   %edi
 91a:	e8 53 fe ff ff       	call   772 <write>
 91f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 922:	83 c4 10             	add    $0x10,%esp
 925:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 928:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 92c:	84 db                	test   %bl,%bl
 92e:	74 73                	je     9a3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 930:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 932:	0f be cb             	movsbl %bl,%ecx
 935:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 938:	74 c6                	je     900 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 93a:	83 fa 25             	cmp    $0x25,%edx
 93d:	75 e6                	jne    925 <printf+0x55>
      if(c == 'd'){
 93f:	83 f8 64             	cmp    $0x64,%eax
 942:	0f 84 f8 00 00 00    	je     a40 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 948:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 94e:	83 f9 70             	cmp    $0x70,%ecx
 951:	74 5d                	je     9b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 953:	83 f8 73             	cmp    $0x73,%eax
 956:	0f 84 84 00 00 00    	je     9e0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 95c:	83 f8 63             	cmp    $0x63,%eax
 95f:	0f 84 ea 00 00 00    	je     a4f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 965:	83 f8 25             	cmp    $0x25,%eax
 968:	0f 84 c2 00 00 00    	je     a30 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 96e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 971:	83 ec 04             	sub    $0x4,%esp
 974:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 978:	6a 01                	push   $0x1
 97a:	50                   	push   %eax
 97b:	57                   	push   %edi
 97c:	e8 f1 fd ff ff       	call   772 <write>
 981:	83 c4 0c             	add    $0xc,%esp
 984:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 987:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 98a:	6a 01                	push   $0x1
 98c:	50                   	push   %eax
 98d:	57                   	push   %edi
 98e:	83 c6 01             	add    $0x1,%esi
 991:	e8 dc fd ff ff       	call   772 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 996:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 99a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 99d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 99f:	84 db                	test   %bl,%bl
 9a1:	75 8d                	jne    930 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9a6:	5b                   	pop    %ebx
 9a7:	5e                   	pop    %esi
 9a8:	5f                   	pop    %edi
 9a9:	5d                   	pop    %ebp
 9aa:	c3                   	ret    
 9ab:	90                   	nop
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 9b0:	83 ec 0c             	sub    $0xc,%esp
 9b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9b8:	6a 00                	push   $0x0
 9ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9bd:	89 f8                	mov    %edi,%eax
 9bf:	8b 13                	mov    (%ebx),%edx
 9c1:	e8 6a fe ff ff       	call   830 <printint>
        ap++;
 9c6:	89 d8                	mov    %ebx,%eax
 9c8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 9cb:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 9cd:	83 c0 04             	add    $0x4,%eax
 9d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 9d3:	e9 4d ff ff ff       	jmp    925 <printf+0x55>
 9d8:	90                   	nop
 9d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 9e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 9e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 9e5:	83 c0 04             	add    $0x4,%eax
 9e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 9eb:	b8 14 0d 00 00       	mov    $0xd14,%eax
 9f0:	85 db                	test   %ebx,%ebx
 9f2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 9f5:	0f b6 03             	movzbl (%ebx),%eax
 9f8:	84 c0                	test   %al,%al
 9fa:	74 23                	je     a1f <printf+0x14f>
 9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a00:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a03:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 a06:	83 ec 04             	sub    $0x4,%esp
 a09:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 a0b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a0e:	50                   	push   %eax
 a0f:	57                   	push   %edi
 a10:	e8 5d fd ff ff       	call   772 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a15:	0f b6 03             	movzbl (%ebx),%eax
 a18:	83 c4 10             	add    $0x10,%esp
 a1b:	84 c0                	test   %al,%al
 a1d:	75 e1                	jne    a00 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 a1f:	31 d2                	xor    %edx,%edx
 a21:	e9 ff fe ff ff       	jmp    925 <printf+0x55>
 a26:	8d 76 00             	lea    0x0(%esi),%esi
 a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a30:	83 ec 04             	sub    $0x4,%esp
 a33:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a36:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a39:	6a 01                	push   $0x1
 a3b:	e9 4c ff ff ff       	jmp    98c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 a40:	83 ec 0c             	sub    $0xc,%esp
 a43:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a48:	6a 01                	push   $0x1
 a4a:	e9 6b ff ff ff       	jmp    9ba <printf+0xea>
 a4f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a52:	83 ec 04             	sub    $0x4,%esp
 a55:	8b 03                	mov    (%ebx),%eax
 a57:	6a 01                	push   $0x1
 a59:	88 45 e4             	mov    %al,-0x1c(%ebp)
 a5c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a5f:	50                   	push   %eax
 a60:	57                   	push   %edi
 a61:	e8 0c fd ff ff       	call   772 <write>
 a66:	e9 5b ff ff ff       	jmp    9c6 <printf+0xf6>
 a6b:	66 90                	xchg   %ax,%ax
 a6d:	66 90                	xchg   %ax,%ax
 a6f:	90                   	nop

00000a70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a70:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a71:	a1 44 11 00 00       	mov    0x1144,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 a76:	89 e5                	mov    %esp,%ebp
 a78:	57                   	push   %edi
 a79:	56                   	push   %esi
 a7a:	53                   	push   %ebx
 a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a7e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a80:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a83:	39 c8                	cmp    %ecx,%eax
 a85:	73 19                	jae    aa0 <free+0x30>
 a87:	89 f6                	mov    %esi,%esi
 a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 a90:	39 d1                	cmp    %edx,%ecx
 a92:	72 1c                	jb     ab0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a94:	39 d0                	cmp    %edx,%eax
 a96:	73 18                	jae    ab0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 a98:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a9c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a9e:	72 f0                	jb     a90 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa0:	39 d0                	cmp    %edx,%eax
 aa2:	72 f4                	jb     a98 <free+0x28>
 aa4:	39 d1                	cmp    %edx,%ecx
 aa6:	73 f0                	jae    a98 <free+0x28>
 aa8:	90                   	nop
 aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 ab0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 ab3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 ab6:	39 d7                	cmp    %edx,%edi
 ab8:	74 19                	je     ad3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 aba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 abd:	8b 50 04             	mov    0x4(%eax),%edx
 ac0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ac3:	39 f1                	cmp    %esi,%ecx
 ac5:	74 23                	je     aea <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ac7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 ac9:	a3 44 11 00 00       	mov    %eax,0x1144
}
 ace:	5b                   	pop    %ebx
 acf:	5e                   	pop    %esi
 ad0:	5f                   	pop    %edi
 ad1:	5d                   	pop    %ebp
 ad2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ad3:	03 72 04             	add    0x4(%edx),%esi
 ad6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad9:	8b 10                	mov    (%eax),%edx
 adb:	8b 12                	mov    (%edx),%edx
 add:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 ae0:	8b 50 04             	mov    0x4(%eax),%edx
 ae3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ae6:	39 f1                	cmp    %esi,%ecx
 ae8:	75 dd                	jne    ac7 <free+0x57>
    p->s.size += bp->s.size;
 aea:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 aed:	a3 44 11 00 00       	mov    %eax,0x1144
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 af2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 af5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 af8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 afa:	5b                   	pop    %ebx
 afb:	5e                   	pop    %esi
 afc:	5f                   	pop    %edi
 afd:	5d                   	pop    %ebp
 afe:	c3                   	ret    
 aff:	90                   	nop

00000b00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b00:	55                   	push   %ebp
 b01:	89 e5                	mov    %esp,%ebp
 b03:	57                   	push   %edi
 b04:	56                   	push   %esi
 b05:	53                   	push   %ebx
 b06:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b09:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b0c:	8b 15 44 11 00 00    	mov    0x1144,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b12:	8d 78 07             	lea    0x7(%eax),%edi
 b15:	c1 ef 03             	shr    $0x3,%edi
 b18:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b1b:	85 d2                	test   %edx,%edx
 b1d:	0f 84 a3 00 00 00    	je     bc6 <malloc+0xc6>
 b23:	8b 02                	mov    (%edx),%eax
 b25:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b28:	39 cf                	cmp    %ecx,%edi
 b2a:	76 74                	jbe    ba0 <malloc+0xa0>
 b2c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b32:	be 00 10 00 00       	mov    $0x1000,%esi
 b37:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 b3e:	0f 43 f7             	cmovae %edi,%esi
 b41:	ba 00 80 00 00       	mov    $0x8000,%edx
 b46:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 b4c:	0f 46 da             	cmovbe %edx,%ebx
 b4f:	eb 10                	jmp    b61 <malloc+0x61>
 b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b58:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b5a:	8b 48 04             	mov    0x4(%eax),%ecx
 b5d:	39 cf                	cmp    %ecx,%edi
 b5f:	76 3f                	jbe    ba0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b61:	39 05 44 11 00 00    	cmp    %eax,0x1144
 b67:	89 c2                	mov    %eax,%edx
 b69:	75 ed                	jne    b58 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 b6b:	83 ec 0c             	sub    $0xc,%esp
 b6e:	53                   	push   %ebx
 b6f:	e8 66 fc ff ff       	call   7da <sbrk>
  if(p == (char*)-1)
 b74:	83 c4 10             	add    $0x10,%esp
 b77:	83 f8 ff             	cmp    $0xffffffff,%eax
 b7a:	74 1c                	je     b98 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 b7c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 b7f:	83 ec 0c             	sub    $0xc,%esp
 b82:	83 c0 08             	add    $0x8,%eax
 b85:	50                   	push   %eax
 b86:	e8 e5 fe ff ff       	call   a70 <free>
  return freep;
 b8b:	8b 15 44 11 00 00    	mov    0x1144,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 b91:	83 c4 10             	add    $0x10,%esp
 b94:	85 d2                	test   %edx,%edx
 b96:	75 c0                	jne    b58 <malloc+0x58>
        return 0;
 b98:	31 c0                	xor    %eax,%eax
 b9a:	eb 1c                	jmp    bb8 <malloc+0xb8>
 b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 ba0:	39 cf                	cmp    %ecx,%edi
 ba2:	74 1c                	je     bc0 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 ba4:	29 f9                	sub    %edi,%ecx
 ba6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ba9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 bac:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 baf:	89 15 44 11 00 00    	mov    %edx,0x1144
      return (void*)(p + 1);
 bb5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 bbb:	5b                   	pop    %ebx
 bbc:	5e                   	pop    %esi
 bbd:	5f                   	pop    %edi
 bbe:	5d                   	pop    %ebp
 bbf:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 bc0:	8b 08                	mov    (%eax),%ecx
 bc2:	89 0a                	mov    %ecx,(%edx)
 bc4:	eb e9                	jmp    baf <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 bc6:	c7 05 44 11 00 00 48 	movl   $0x1148,0x1144
 bcd:	11 00 00 
 bd0:	c7 05 48 11 00 00 48 	movl   $0x1148,0x1148
 bd7:	11 00 00 
    base.s.size = 0;
 bda:	b8 48 11 00 00       	mov    $0x1148,%eax
 bdf:	c7 05 4c 11 00 00 00 	movl   $0x0,0x114c
 be6:	00 00 00 
 be9:	e9 3e ff ff ff       	jmp    b2c <malloc+0x2c>
