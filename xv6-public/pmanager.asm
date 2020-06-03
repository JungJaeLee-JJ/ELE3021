
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
  11:	68 8d 0c 00 00       	push   $0xc8d
  16:	e8 2f 08 00 00       	call   84a <getadmin>
  1b:	83 c4 10             	add    $0x10,%esp
  1e:	83 f8 ff             	cmp    $0xffffffff,%eax
  21:	0f 84 83 00 00 00    	je     aa <main+0xaa>
       printf(2, "Authentication Failure : Wrong Password\n");
       exit();
  }
  printf(2, "[Process Manager] \n");
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	68 98 0c 00 00       	push   $0xc98
  2f:	6a 02                	push   $0x2
  31:	e8 da 08 00 00       	call   910 <printf>

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
  4a:	68 ac 0c 00 00       	push   $0xcac
  4f:	e8 7e 07 00 00       	call   7d2 <open>
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
  65:	68 40 11 00 00       	push   $0x1140
  6a:	e8 51 00 00 00       	call   c0 <getcmd>
  6f:	83 c4 10             	add    $0x10,%esp
  72:	85 c0                	test   %eax,%eax
  74:	78 21                	js     97 <main+0x97>
    runcmd(parsing(buf));
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	68 40 11 00 00       	push   $0x1140
  7e:	e8 0d 03 00 00       	call   390 <parsing>
  83:	89 04 24             	mov    %eax,(%esp)
  86:	e8 f5 00 00 00       	call   180 <runcmd>
    }
  }
  

  // Read and run input commands.
  while(finish==0 && getcmd(buf, sizeof(buf)) >= 0){
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	a1 20 11 00 00       	mov    0x1120,%eax
  93:	85 c0                	test   %eax,%eax
  95:	74 c9                	je     60 <main+0x60>
    runcmd(parsing(buf));
  }
  exit();
  97:	e8 f6 06 00 00       	call   792 <exit>
  printf(2, "[Process Manager] \n");

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
  9c:	83 ec 0c             	sub    $0xc,%esp
  9f:	50                   	push   %eax
  a0:	e8 15 07 00 00       	call   7ba <close>
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
  ac:	68 14 0d 00 00       	push   $0xd14
  b1:	6a 02                	push   $0x2
  b3:	e8 58 08 00 00       	call   910 <printf>
       exit();
  b8:	e8 d5 06 00 00       	call   792 <exit>
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
  ce:	68 30 0c 00 00       	push   $0xc30
  d3:	6a 02                	push   $0x2
  d5:	e8 36 08 00 00       	call   910 <printf>
  memset(buf, 0, nbuf);
  da:	83 c4 0c             	add    $0xc,%esp
  dd:	56                   	push   %esi
  de:	6a 00                	push   $0x0
  e0:	53                   	push   %ebx
  e1:	e8 1a 05 00 00       	call   600 <memset>
  gets(buf, nbuf);
  e6:	58                   	pop    %eax
  e7:	5a                   	pop    %edx
  e8:	56                   	push   %esi
  e9:	53                   	push   %ebx
  ea:	e8 71 05 00 00       	call   660 <gets>
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
 116:	68 33 0c 00 00       	push   $0xc33
 11b:	6a 02                	push   $0x2
 11d:	e8 ee 07 00 00       	call   910 <printf>
    //exit();
}
 122:	83 c4 10             	add    $0x10,%esp
 125:	c9                   	leave  
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <panic>:
  return pid;
}

void
panic(char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
 136:	ff 75 08             	pushl  0x8(%ebp)
 139:	68 48 0c 00 00       	push   $0xc48
 13e:	6a 02                	push   $0x2
 140:	e8 cb 07 00 00       	call   910 <printf>
  exit();
 145:	e8 48 06 00 00       	call   792 <exit>
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <exec_>:
}


int
exec_(char *path, char **argv, int stacksize)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 0c             	sub    $0xc,%esp
  int pid;

  pid = exec2(path,argv,stacksize);
 156:	ff 75 10             	pushl  0x10(%ebp)
 159:	ff 75 0c             	pushl  0xc(%ebp)
 15c:	ff 75 08             	pushl  0x8(%ebp)
 15f:	e8 ee 06 00 00       	call   852 <exec2>
  if(pid == -1)
 164:	83 c4 10             	add    $0x10,%esp
 167:	83 f8 ff             	cmp    $0xffffffff,%eax
 16a:	74 02                	je     16e <exec_+0x1e>
    panic("exec2");
  return pid;
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    
{
  int pid;

  pid = exec2(path,argv,stacksize);
  if(pid == -1)
    panic("exec2");
 16e:	83 ec 0c             	sub    $0xc,%esp
 171:	68 4c 0c 00 00       	push   $0xc4c
 176:	e8 b5 ff ff ff       	call   130 <panic>
 17b:	90                   	nop
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
  if(cmd == 0) wrong_input();
 188:	85 db                	test   %ebx,%ebx
 18a:	0f 84 90 01 00 00    	je     320 <runcmd+0x1a0>

  switch(cmd->type){
 190:	83 3b 05             	cmpl   $0x5,(%ebx)
 193:	77 0b                	ja     1a0 <runcmd+0x20>
 195:	8b 03                	mov    (%ebx),%eax
 197:	ff 24 85 40 0d 00 00 	jmp    *0xd40(,%eax,4)
 19e:	66 90                	xchg   %ax,%ax
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 1a0:	83 ec 08             	sub    $0x8,%esp
 1a3:	68 33 0c 00 00       	push   $0xc33
 1a8:	6a 02                	push   $0x2
 1aa:	e8 61 07 00 00       	call   910 <printf>
 1af:	83 c4 10             	add    $0x10,%esp
    finish = 1;
    //exit();
    break;
  }
  //exit();
}
 1b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b5:	5b                   	pop    %ebx
 1b6:	5e                   	pop    %esi
 1b7:	5d                   	pop    %ebp
  default:
	wrong_input();
   // panic("runcmd");

  case LIST:
    list();
 1b8:	e9 a5 06 00 00       	jmp    862 <list>
 1bd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(2,"Fail to set Memory Limit\n");
    }
    break;

  case EXIT:
    printf(2,"\n");
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	68 46 0c 00 00       	push   $0xc46
 1c8:	6a 02                	push   $0x2
 1ca:	e8 41 07 00 00       	call   910 <printf>
    finish = 1;
 1cf:	c7 05 20 11 00 00 01 	movl   $0x1,0x1120
 1d6:	00 00 00 
    //exit();
    break;
 1d9:	83 c4 10             	add    $0x10,%esp
  }
  //exit();
}
 1dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1df:	5b                   	pop    %ebx
 1e0:	5e                   	pop    %esi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    list();
    break;

  case KILL:
    //입력 유효 검사
    if(cmd->first_arg == 0) {
 1e8:	8b 43 04             	mov    0x4(%ebx),%eax
 1eb:	85 c0                	test   %eax,%eax
 1ed:	0f 84 0d 01 00 00    	je     300 <runcmd+0x180>
        wrong_input();
        //exit();
    }
 
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg) == 0)){
 1f3:	83 ec 0c             	sub    $0xc,%esp
 1f6:	50                   	push   %eax
 1f7:	e8 24 05 00 00       	call   720 <atoi>
 1fc:	85 c0                	test   %eax,%eax
 1fe:	0f 94 c0             	sete   %al
 201:	0f b6 c0             	movzbl %al,%eax
 204:	89 04 24             	mov    %eax,(%esp)
 207:	e8 b6 05 00 00       	call   7c2 <kill>
 20c:	83 c4 10             	add    $0x10,%esp
 20f:	85 c0                	test   %eax,%eax
 211:	74 c9                	je     1dc <runcmd+0x5c>
        printf(2, "KILL SUCCESS !\n");
 213:	83 ec 08             	sub    $0x8,%esp
 216:	68 52 0c 00 00       	push   $0xc52
 21b:	6a 02                	push   $0x2
 21d:	e8 ee 06 00 00       	call   910 <printf>
        wait();
 222:	83 c4 10             	add    $0x10,%esp
    finish = 1;
    //exit();
    break;
  }
  //exit();
}
 225:	8d 65 f8             	lea    -0x8(%ebp),%esp
 228:	5b                   	pop    %ebx
 229:	5e                   	pop    %esi
 22a:	5d                   	pop    %ebp
    }
 
    //KILL 명령어 수행
	else if(kill(atoi(cmd->first_arg) == 0)){
        printf(2, "KILL SUCCESS !\n");
        wait();
 22b:	e9 6a 05 00 00       	jmp    79a <wait>
    }
    break;

  case EXEC2:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
 230:	8b 43 04             	mov    0x4(%ebx),%eax
 233:	85 c0                	test   %eax,%eax
 235:	0f 84 c5 00 00 00    	je     300 <runcmd+0x180>
 23b:	8b 73 08             	mov    0x8(%ebx),%esi
 23e:	85 f6                	test   %esi,%esi
 240:	0f 84 ba 00 00 00    	je     300 <runcmd+0x180>

int
fork1(void)
{
  int pid;
  pid = fork();
 246:	e8 3f 05 00 00       	call   78a <fork>
  if(pid == -1)
 24b:	83 f8 ff             	cmp    $0xffffffff,%eax
 24e:	0f 84 03 01 00 00    	je     357 <runcmd+0x1d7>
        wrong_input();
        //exit();
     }
     
    //프로세스 생성
	else if(fork1() == 0){
 254:	85 c0                	test   %eax,%eax
 256:	75 84                	jne    1dc <runcmd+0x5c>
      //exec2 명령어 실행
       if(exec2(cmd->first_arg,&(cmd->first_arg),atoi(cmd->second_arg)) != 0) printf(2, "EXEC fail!\n");
 258:	83 ec 0c             	sub    $0xc,%esp
 25b:	ff 73 08             	pushl  0x8(%ebx)
 25e:	e8 bd 04 00 00       	call   720 <atoi>
 263:	83 c4 0c             	add    $0xc,%esp
 266:	50                   	push   %eax
 267:	8d 43 04             	lea    0x4(%ebx),%eax
 26a:	50                   	push   %eax
 26b:	ff 73 04             	pushl  0x4(%ebx)
 26e:	e8 df 05 00 00       	call   852 <exec2>
 273:	83 c4 10             	add    $0x10,%esp
 276:	85 c0                	test   %eax,%eax
 278:	0f 84 5e ff ff ff    	je     1dc <runcmd+0x5c>
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	68 67 0c 00 00       	push   $0xc67
 286:	6a 02                	push   $0x2
 288:	e8 83 06 00 00       	call   910 <printf>
 28d:	83 c4 10             	add    $0x10,%esp
 290:	e9 47 ff ff ff       	jmp    1dc <runcmd+0x5c>
 295:	8d 76 00             	lea    0x0(%esi),%esi
    }
    break;
    
  case MEMLIMIT:
    //입력 유효 검사
    if(cmd->first_arg==0 || cmd->second_arg == 0){
 298:	8b 4b 04             	mov    0x4(%ebx),%ecx
 29b:	85 c9                	test   %ecx,%ecx
 29d:	74 61                	je     300 <runcmd+0x180>
 29f:	8b 43 08             	mov    0x8(%ebx),%eax
 2a2:	85 c0                	test   %eax,%eax
 2a4:	74 5a                	je     300 <runcmd+0x180>
        wrong_input();
    }

	else if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
 2a6:	83 ec 0c             	sub    $0xc,%esp
 2a9:	50                   	push   %eax
 2aa:	e8 71 04 00 00       	call   720 <atoi>
 2af:	5a                   	pop    %edx
 2b0:	ff 73 04             	pushl  0x4(%ebx)
 2b3:	89 c6                	mov    %eax,%esi
 2b5:	e8 66 04 00 00       	call   720 <atoi>
 2ba:	59                   	pop    %ecx
 2bb:	5a                   	pop    %edx
 2bc:	56                   	push   %esi
 2bd:	50                   	push   %eax
 2be:	e8 97 05 00 00       	call   85a <setmemorylimit>
 2c3:	83 c4 10             	add    $0x10,%esp
 2c6:	85 c0                	test   %eax,%eax
 2c8:	75 76                	jne    340 <runcmd+0x1c0>
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
 2ca:	83 ec 0c             	sub    $0xc,%esp
 2cd:	ff 73 08             	pushl  0x8(%ebx)
 2d0:	e8 4b 04 00 00       	call   720 <atoi>
 2d5:	89 c6                	mov    %eax,%esi
 2d7:	58                   	pop    %eax
 2d8:	ff 73 04             	pushl  0x4(%ebx)
 2db:	e8 40 04 00 00       	call   720 <atoi>
 2e0:	56                   	push   %esi
 2e1:	50                   	push   %eax
 2e2:	68 b4 0c 00 00       	push   $0xcb4
 2e7:	6a 02                	push   $0x2
 2e9:	e8 22 06 00 00       	call   910 <printf>
 2ee:	83 c4 20             	add    $0x20,%esp
 2f1:	e9 e6 fe ff ff       	jmp    1dc <runcmd+0x5c>
 2f6:	8d 76 00             	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 300:	83 ec 08             	sub    $0x8,%esp
 303:	68 33 0c 00 00       	push   $0xc33
 308:	6a 02                	push   $0x2
 30a:	e8 01 06 00 00       	call   910 <printf>
 30f:	83 c4 10             	add    $0x10,%esp
    finish = 1;
    //exit();
    break;
  }
  //exit();
}
 312:	8d 65 f8             	lea    -0x8(%ebp),%esp
 315:	5b                   	pop    %ebx
 316:	5e                   	pop    %esi
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

void 
wrong_input()
{
    printf(2, "It is Wrong input. \n");
 320:	83 ec 08             	sub    $0x8,%esp
 323:	68 33 0c 00 00       	push   $0xc33
 328:	6a 02                	push   $0x2
 32a:	e8 e1 05 00 00       	call   910 <printf>
 32f:	83 c4 10             	add    $0x10,%esp
 332:	e9 59 fe ff ff       	jmp    190 <runcmd+0x10>
 337:	89 f6                	mov    %esi,%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

	else if( setmemorylimit(atoi(cmd->first_arg),atoi(cmd->second_arg)) == 0 ){
        printf(2, "Success to set process(pid : %d) Memory Limit as %d\n",atoi(cmd->first_arg),atoi(cmd->second_arg));
    }
    else{
        printf(2,"Fail to set Memory Limit\n");
 340:	83 ec 08             	sub    $0x8,%esp
 343:	68 73 0c 00 00       	push   $0xc73
 348:	6a 02                	push   $0x2
 34a:	e8 c1 05 00 00       	call   910 <printf>
 34f:	83 c4 10             	add    $0x10,%esp
 352:	e9 85 fe ff ff       	jmp    1dc <runcmd+0x5c>
fork1(void)
{
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
 357:	83 ec 0c             	sub    $0xc,%esp
 35a:	68 62 0c 00 00       	push   $0xc62
 35f:	e8 cc fd ff ff       	call   130 <panic>
 364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 36a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000370 <fork1>:
  exit();
}

int
fork1(void)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 08             	sub    $0x8,%esp
  int pid;
  pid = fork();
 376:	e8 0f 04 00 00       	call   78a <fork>
  if(pid == -1)
 37b:	83 f8 ff             	cmp    $0xffffffff,%eax
 37e:	74 02                	je     382 <fork1+0x12>
    panic("fork");
  return pid;
}
 380:	c9                   	leave  
 381:	c3                   	ret    
fork1(void)
{
  int pid;
  pid = fork();
  if(pid == -1)
    panic("fork");
 382:	83 ec 0c             	sub    $0xc,%esp
 385:	68 62 0c 00 00       	push   $0xc62
 38a:	e8 a1 fd ff ff       	call   130 <panic>
 38f:	90                   	nop

00000390 <parsing>:
  exit();
}

struct cmd*
parsing(char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
 395:	8b 75 08             	mov    0x8(%ebp),%esi
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
 398:	83 ec 0c             	sub    $0xc,%esp
 39b:	6a 0c                	push   $0xc
 39d:	e8 9e 07 00 00       	call   b40 <malloc>
  //command->cmd_type_string = malloc(sizeof(char)*100);
  //command->first_arg = malloc(sizeof(char)*100);
  //command->second_arg = malloc(sizeof(char)*100);
  
  //초기화
  memset(command,0,sizeof(*command));
 3a2:	83 c4 0c             	add    $0xc,%esp
{
  //cmd 자료형을 만든다.
  struct cmd* command;

  //데이터 동적할당
  command = malloc(sizeof(*command));
 3a5:	89 c3                	mov    %eax,%ebx
  //command->cmd_type_string = malloc(sizeof(char)*100);
  //command->first_arg = malloc(sizeof(char)*100);
  //command->second_arg = malloc(sizeof(char)*100);
  
  //초기화
  memset(command,0,sizeof(*command));
 3a7:	6a 0c                	push   $0xc
 3a9:	6a 00                	push   $0x0
 3ab:	50                   	push   %eax
 3ac:	e8 4f 02 00 00       	call   600 <memset>
  //memset(command->cmd_type_string,0,sizeof(char)*100);
  memset(command->first_arg,0,sizeof(char*));
 3b1:	83 c4 0c             	add    $0xc,%esp
 3b4:	6a 04                	push   $0x4
 3b6:	6a 00                	push   $0x0
 3b8:	ff 73 04             	pushl  0x4(%ebx)
 3bb:	e8 40 02 00 00       	call   600 <memset>
  memset(command->second_arg,0,sizeof(char*));
 3c0:	83 c4 0c             	add    $0xc,%esp
 3c3:	6a 04                	push   $0x4
 3c5:	6a 00                	push   $0x0
 3c7:	ff 73 08             	pushl  0x8(%ebx)
 3ca:	e8 31 02 00 00       	call   600 <memset>
 3cf:	8b 4b 04             	mov    0x4(%ebx),%ecx
 3d2:	8d 46 01             	lea    0x1(%esi),%eax
 3d5:	83 c4 10             	add    $0x10,%esp
 3d8:	eb 0e                	jmp    3e8 <parsing+0x58>
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e0:	83 c0 01             	add    $0x1,%eax
         {
             command->second_arg = &s[index+1];
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 3e3:	80 fa 0a             	cmp    $0xa,%dl
 3e6:	74 1c                	je     404 <parsing+0x74>

  //각 인자의 시작 인덱스를 저장한다.
  while(1){
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
 3e8:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 3ec:	80 fa 20             	cmp    $0x20,%dl
 3ef:	75 ef                	jne    3e0 <parsing+0x50>
         //첫번째 인자일 때
         if(command->first_arg == 0){
 3f1:	85 c9                	test   %ecx,%ecx
 3f3:	74 6b                	je     460 <parsing+0xd0>
             command->first_arg = &s[index+1];
         }
         //두번째 인자일 때
         else 
         {
             command->second_arg = &s[index+1];
 3f5:	89 43 08             	mov    %eax,0x8(%ebx)
 3f8:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 3fc:	83 c0 01             	add    $0x1,%eax
         }
      }
      //종료조건
      if(s[index] == '\n') break;
 3ff:	80 fa 0a             	cmp    $0xa,%dl
 402:	75 e4                	jne    3e8 <parsing+0x58>
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
 404:	0f b6 06             	movzbl (%esi),%eax
 407:	3c 6c                	cmp    $0x6c,%al
 409:	74 65                	je     470 <parsing+0xe0>
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
 40b:	3c 6b                	cmp    $0x6b,%al
 40d:	74 31                	je     440 <parsing+0xb0>
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 40f:	3c 65                	cmp    $0x65,%al
 411:	0f 85 c9 00 00 00    	jne    4e0 <parsing+0x150>
 417:	80 7e 01 78          	cmpb   $0x78,0x1(%esi)
 41b:	74 73                	je     490 <parsing+0x100>
 41d:	8d 76 00             	lea    0x0(%esi),%esi
 420:	8b 03                	mov    (%ebx),%eax
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='e'&&s[3]=='c'&&s[4]=='u'&&s[5]=='t'&&s[6]=='e' ) command->type = 3;

  
  printf(2,"In parse type, argv1, argv2 : %d %s %s\n",command->type, command->first_arg, command->second_arg);
 422:	83 ec 0c             	sub    $0xc,%esp
 425:	ff 73 08             	pushl  0x8(%ebx)
 428:	51                   	push   %ecx
 429:	50                   	push   %eax
 42a:	68 ec 0c 00 00       	push   $0xcec
 42f:	6a 02                	push   $0x2
 431:	e8 da 04 00 00       	call   910 <printf>
  return command;
}
 436:	8d 65 f8             	lea    -0x8(%ebp),%esp
 439:	89 d8                	mov    %ebx,%eax
 43b:	5b                   	pop    %ebx
 43c:	5e                   	pop    %esi
 43d:	5d                   	pop    %ebp
 43e:	c3                   	ret    
 43f:	90                   	nop
      if(s[index] == '\n') break;
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
 440:	80 7e 01 69          	cmpb   $0x69,0x1(%esi)
 444:	75 da                	jne    420 <parsing+0x90>
 446:	80 7e 02 6c          	cmpb   $0x6c,0x2(%esi)
 44a:	75 d4                	jne    420 <parsing+0x90>
 44c:	80 7e 03 6c          	cmpb   $0x6c,0x3(%esi)
 450:	75 ce                	jne    420 <parsing+0x90>
 452:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
 458:	b8 02 00 00 00       	mov    $0x2,%eax
 45d:	eb c3                	jmp    422 <parsing+0x92>
 45f:	90                   	nop
      //띄어쓰기 간격발생
	  //printf(2,"%s\n",s);
      if(s[index] == ' '){
         //첫번째 인자일 때
         if(command->first_arg == 0){
             command->first_arg = &s[index+1];
 460:	89 43 04             	mov    %eax,0x4(%ebx)
 463:	89 c1                	mov    %eax,%ecx
 465:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
 469:	e9 72 ff ff ff       	jmp    3e0 <parsing+0x50>
 46e:	66 90                	xchg   %ax,%ax
      //종료조건
      if(s[index] == '\n') break;
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
 470:	80 7e 01 69          	cmpb   $0x69,0x1(%esi)
 474:	75 aa                	jne    420 <parsing+0x90>
 476:	80 7e 02 73          	cmpb   $0x73,0x2(%esi)
 47a:	75 a4                	jne    420 <parsing+0x90>
 47c:	80 7e 03 74          	cmpb   $0x74,0x3(%esi)
 480:	75 9e                	jne    420 <parsing+0x90>
 482:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
 488:	b8 01 00 00 00       	mov    $0x1,%eax
 48d:	eb 93                	jmp    422 <parsing+0x92>
 48f:	90                   	nop
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 490:	80 7e 02 69          	cmpb   $0x69,0x2(%esi)
 494:	0f 84 96 00 00 00    	je     530 <parsing+0x1a0>
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='e'&&s[3]=='c'&&s[4]=='u'&&s[5]=='t'&&s[6]=='e' ) command->type = 3;
 49a:	80 7e 02 65          	cmpb   $0x65,0x2(%esi)
 49e:	75 80                	jne    420 <parsing+0x90>
 4a0:	80 7e 03 63          	cmpb   $0x63,0x3(%esi)
 4a4:	0f 85 76 ff ff ff    	jne    420 <parsing+0x90>
 4aa:	80 7e 04 75          	cmpb   $0x75,0x4(%esi)
 4ae:	0f 85 6c ff ff ff    	jne    420 <parsing+0x90>
 4b4:	80 7e 05 74          	cmpb   $0x74,0x5(%esi)
 4b8:	0f 85 62 ff ff ff    	jne    420 <parsing+0x90>
 4be:	80 7e 06 65          	cmpb   $0x65,0x6(%esi)
 4c2:	0f 85 58 ff ff ff    	jne    420 <parsing+0x90>
 4c8:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
 4ce:	b8 03 00 00 00       	mov    $0x3,%eax
 4d3:	e9 4a ff ff ff       	jmp    422 <parsing+0x92>
 4d8:	90                   	nop
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
  else if (s[0]=='m' && s[1]=='e'&&s[2]=='m'&&s[3]=='l'&&s[4]=='i'&&s[5]=='m') command->type = 4;
 4e0:	3c 6d                	cmp    $0x6d,%al
 4e2:	0f 85 38 ff ff ff    	jne    420 <parsing+0x90>
 4e8:	80 7e 01 65          	cmpb   $0x65,0x1(%esi)
 4ec:	0f 85 2e ff ff ff    	jne    420 <parsing+0x90>
 4f2:	80 7e 02 6d          	cmpb   $0x6d,0x2(%esi)
 4f6:	0f 85 24 ff ff ff    	jne    420 <parsing+0x90>
 4fc:	80 7e 03 6c          	cmpb   $0x6c,0x3(%esi)
 500:	0f 85 1a ff ff ff    	jne    420 <parsing+0x90>
 506:	80 7e 04 69          	cmpb   $0x69,0x4(%esi)
 50a:	0f 85 10 ff ff ff    	jne    420 <parsing+0x90>
 510:	80 7e 05 6d          	cmpb   $0x6d,0x5(%esi)
 514:	0f 85 06 ff ff ff    	jne    420 <parsing+0x90>
 51a:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
 520:	b8 04 00 00 00       	mov    $0x4,%eax
 525:	e9 f8 fe ff ff       	jmp    422 <parsing+0x92>
 52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      index++;
  }

  if(s[0]=='l' && s[1]=='i'&&s[2]=='s'&&s[3]=='t') command->type = 1;
  else if (s[0]=='k' && s[1]=='i'&&s[2]=='l'&&s[3]=='l') command->type = 2;
  else if (s[0]=='e' && s[1]=='x'&&s[2]=='i'&&s[3]=='t') command->type = 5;
 530:	80 7e 03 74          	cmpb   $0x74,0x3(%esi)
 534:	0f 85 60 ff ff ff    	jne    49a <parsing+0x10a>
 53a:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
 540:	b8 05 00 00 00       	mov    $0x5,%eax
 545:	e9 d8 fe ff ff       	jmp    422 <parsing+0x92>
 54a:	66 90                	xchg   %ax,%ax
 54c:	66 90                	xchg   %ax,%ax
 54e:	66 90                	xchg   %ax,%ax

00000550 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	53                   	push   %ebx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 55a:	89 c2                	mov    %eax,%edx
 55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 560:	83 c1 01             	add    $0x1,%ecx
 563:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 567:	83 c2 01             	add    $0x1,%edx
 56a:	84 db                	test   %bl,%bl
 56c:	88 5a ff             	mov    %bl,-0x1(%edx)
 56f:	75 ef                	jne    560 <strcpy+0x10>
    ;
  return os;
}
 571:	5b                   	pop    %ebx
 572:	5d                   	pop    %ebp
 573:	c3                   	ret    
 574:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 57a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000580 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	56                   	push   %esi
 584:	53                   	push   %ebx
 585:	8b 55 08             	mov    0x8(%ebp),%edx
 588:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q){
 58b:	0f b6 02             	movzbl (%edx),%eax
 58e:	0f b6 19             	movzbl (%ecx),%ebx
 591:	84 c0                	test   %al,%al
 593:	75 1e                	jne    5b3 <strcmp+0x33>
 595:	eb 29                	jmp    5c0 <strcmp+0x40>
 597:	89 f6                	mov    %esi,%esi
 599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 5a0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 5a3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 5a6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 5a9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 5ad:	84 c0                	test   %al,%al
 5af:	74 0f                	je     5c0 <strcmp+0x40>
 5b1:	89 f1                	mov    %esi,%ecx
 5b3:	38 d8                	cmp    %bl,%al
 5b5:	74 e9                	je     5a0 <strcmp+0x20>
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 5b7:	29 d8                	sub    %ebx,%eax
}
 5b9:	5b                   	pop    %ebx
 5ba:	5e                   	pop    %esi
 5bb:	5d                   	pop    %ebp
 5bc:	c3                   	ret    
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 5c0:	31 c0                	xor    %eax,%eax
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 5c2:	29 d8                	sub    %ebx,%eax
}
 5c4:	5b                   	pop    %ebx
 5c5:	5e                   	pop    %esi
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005d0 <strlen>:

uint
strlen(const char *s)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 5d6:	80 39 00             	cmpb   $0x0,(%ecx)
 5d9:	74 12                	je     5ed <strlen+0x1d>
 5db:	31 d2                	xor    %edx,%edx
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
 5e0:	83 c2 01             	add    $0x1,%edx
 5e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 5e7:	89 d0                	mov    %edx,%eax
 5e9:	75 f5                	jne    5e0 <strlen+0x10>
    ;
  return n;
}
 5eb:	5d                   	pop    %ebp
 5ec:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 5ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 5ef:	5d                   	pop    %ebp
 5f0:	c3                   	ret    
 5f1:	eb 0d                	jmp    600 <memset>
 5f3:	90                   	nop
 5f4:	90                   	nop
 5f5:	90                   	nop
 5f6:	90                   	nop
 5f7:	90                   	nop
 5f8:	90                   	nop
 5f9:	90                   	nop
 5fa:	90                   	nop
 5fb:	90                   	nop
 5fc:	90                   	nop
 5fd:	90                   	nop
 5fe:	90                   	nop
 5ff:	90                   	nop

00000600 <memset>:

void*
memset(void *dst, int c, uint n)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 607:	8b 4d 10             	mov    0x10(%ebp),%ecx
 60a:	8b 45 0c             	mov    0xc(%ebp),%eax
 60d:	89 d7                	mov    %edx,%edi
 60f:	fc                   	cld    
 610:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 612:	89 d0                	mov    %edx,%eax
 614:	5f                   	pop    %edi
 615:	5d                   	pop    %ebp
 616:	c3                   	ret    
 617:	89 f6                	mov    %esi,%esi
 619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000620 <strchr>:

char*
strchr(const char *s, char c)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	53                   	push   %ebx
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 62a:	0f b6 10             	movzbl (%eax),%edx
 62d:	84 d2                	test   %dl,%dl
 62f:	74 1d                	je     64e <strchr+0x2e>
    if(*s == c)
 631:	38 d3                	cmp    %dl,%bl
 633:	89 d9                	mov    %ebx,%ecx
 635:	75 0d                	jne    644 <strchr+0x24>
 637:	eb 17                	jmp    650 <strchr+0x30>
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 640:	38 ca                	cmp    %cl,%dl
 642:	74 0c                	je     650 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 644:	83 c0 01             	add    $0x1,%eax
 647:	0f b6 10             	movzbl (%eax),%edx
 64a:	84 d2                	test   %dl,%dl
 64c:	75 f2                	jne    640 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 64e:	31 c0                	xor    %eax,%eax
}
 650:	5b                   	pop    %ebx
 651:	5d                   	pop    %ebp
 652:	c3                   	ret    
 653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000660 <gets>:

char*
gets(char *buf, int max)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 666:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 668:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 66b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 66e:	eb 29                	jmp    699 <gets+0x39>
    cc = read(0, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
 673:	6a 01                	push   $0x1
 675:	57                   	push   %edi
 676:	6a 00                	push   $0x0
 678:	e8 2d 01 00 00       	call   7aa <read>
    if(cc < 1)
 67d:	83 c4 10             	add    $0x10,%esp
 680:	85 c0                	test   %eax,%eax
 682:	7e 1d                	jle    6a1 <gets+0x41>
      break;
    buf[i++] = c;
 684:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 688:	8b 55 08             	mov    0x8(%ebp),%edx
 68b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 68d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 68f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 693:	74 1b                	je     6b0 <gets+0x50>
 695:	3c 0d                	cmp    $0xd,%al
 697:	74 17                	je     6b0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 699:	8d 5e 01             	lea    0x1(%esi),%ebx
 69c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 69f:	7c cf                	jl     670 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 6a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ab:	5b                   	pop    %ebx
 6ac:	5e                   	pop    %esi
 6ad:	5f                   	pop    %edi
 6ae:	5d                   	pop    %ebp
 6af:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6b0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6b3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6b5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 6b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bc:	5b                   	pop    %ebx
 6bd:	5e                   	pop    %esi
 6be:	5f                   	pop    %edi
 6bf:	5d                   	pop    %ebp
 6c0:	c3                   	ret    
 6c1:	eb 0d                	jmp    6d0 <stat>
 6c3:	90                   	nop
 6c4:	90                   	nop
 6c5:	90                   	nop
 6c6:	90                   	nop
 6c7:	90                   	nop
 6c8:	90                   	nop
 6c9:	90                   	nop
 6ca:	90                   	nop
 6cb:	90                   	nop
 6cc:	90                   	nop
 6cd:	90                   	nop
 6ce:	90                   	nop
 6cf:	90                   	nop

000006d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	56                   	push   %esi
 6d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6d5:	83 ec 08             	sub    $0x8,%esp
 6d8:	6a 00                	push   $0x0
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 f0 00 00 00       	call   7d2 <open>
  if(fd < 0)
 6e2:	83 c4 10             	add    $0x10,%esp
 6e5:	85 c0                	test   %eax,%eax
 6e7:	78 27                	js     710 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 6e9:	83 ec 08             	sub    $0x8,%esp
 6ec:	ff 75 0c             	pushl  0xc(%ebp)
 6ef:	89 c3                	mov    %eax,%ebx
 6f1:	50                   	push   %eax
 6f2:	e8 f3 00 00 00       	call   7ea <fstat>
 6f7:	89 c6                	mov    %eax,%esi
  close(fd);
 6f9:	89 1c 24             	mov    %ebx,(%esp)
 6fc:	e8 b9 00 00 00       	call   7ba <close>
  return r;
 701:	83 c4 10             	add    $0x10,%esp
 704:	89 f0                	mov    %esi,%eax
}
 706:	8d 65 f8             	lea    -0x8(%ebp),%esp
 709:	5b                   	pop    %ebx
 70a:	5e                   	pop    %esi
 70b:	5d                   	pop    %ebp
 70c:	c3                   	ret    
 70d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 715:	eb ef                	jmp    706 <stat+0x36>
 717:	89 f6                	mov    %esi,%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000720 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	53                   	push   %ebx
 724:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 727:	0f be 11             	movsbl (%ecx),%edx
 72a:	8d 42 d0             	lea    -0x30(%edx),%eax
 72d:	3c 09                	cmp    $0x9,%al
 72f:	b8 00 00 00 00       	mov    $0x0,%eax
 734:	77 1f                	ja     755 <atoi+0x35>
 736:	8d 76 00             	lea    0x0(%esi),%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 740:	8d 04 80             	lea    (%eax,%eax,4),%eax
 743:	83 c1 01             	add    $0x1,%ecx
 746:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 74a:	0f be 11             	movsbl (%ecx),%edx
 74d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 750:	80 fb 09             	cmp    $0x9,%bl
 753:	76 eb                	jbe    740 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 755:	5b                   	pop    %ebx
 756:	5d                   	pop    %ebp
 757:	c3                   	ret    
 758:	90                   	nop
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000760 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	56                   	push   %esi
 764:	53                   	push   %ebx
 765:	8b 5d 10             	mov    0x10(%ebp),%ebx
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 76e:	85 db                	test   %ebx,%ebx
 770:	7e 14                	jle    786 <memmove+0x26>
 772:	31 d2                	xor    %edx,%edx
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 778:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 77c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 77f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 782:	39 da                	cmp    %ebx,%edx
 784:	75 f2                	jne    778 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 786:	5b                   	pop    %ebx
 787:	5e                   	pop    %esi
 788:	5d                   	pop    %ebp
 789:	c3                   	ret    

0000078a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 78a:	b8 01 00 00 00       	mov    $0x1,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <exit>:
SYSCALL(exit)
 792:	b8 02 00 00 00       	mov    $0x2,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <wait>:
SYSCALL(wait)
 79a:	b8 03 00 00 00       	mov    $0x3,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <pipe>:
SYSCALL(pipe)
 7a2:	b8 04 00 00 00       	mov    $0x4,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <read>:
SYSCALL(read)
 7aa:	b8 05 00 00 00       	mov    $0x5,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <write>:
SYSCALL(write)
 7b2:	b8 10 00 00 00       	mov    $0x10,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <close>:
SYSCALL(close)
 7ba:	b8 15 00 00 00       	mov    $0x15,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <kill>:
SYSCALL(kill)
 7c2:	b8 06 00 00 00       	mov    $0x6,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <exec>:
SYSCALL(exec)
 7ca:	b8 07 00 00 00       	mov    $0x7,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <open>:
SYSCALL(open)
 7d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <mknod>:
SYSCALL(mknod)
 7da:	b8 11 00 00 00       	mov    $0x11,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <unlink>:
SYSCALL(unlink)
 7e2:	b8 12 00 00 00       	mov    $0x12,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <fstat>:
SYSCALL(fstat)
 7ea:	b8 08 00 00 00       	mov    $0x8,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <link>:
SYSCALL(link)
 7f2:	b8 13 00 00 00       	mov    $0x13,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <mkdir>:
SYSCALL(mkdir)
 7fa:	b8 14 00 00 00       	mov    $0x14,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <chdir>:
SYSCALL(chdir)
 802:	b8 09 00 00 00       	mov    $0x9,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <dup>:
SYSCALL(dup)
 80a:	b8 0a 00 00 00       	mov    $0xa,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <getpid>:
SYSCALL(getpid)
 812:	b8 0b 00 00 00       	mov    $0xb,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <sbrk>:
SYSCALL(sbrk)
 81a:	b8 0c 00 00 00       	mov    $0xc,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <sleep>:
SYSCALL(sleep)
 822:	b8 0d 00 00 00       	mov    $0xd,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <uptime>:
SYSCALL(uptime)
 82a:	b8 0e 00 00 00       	mov    $0xe,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <yield>:
SYSCALL(yield)
 832:	b8 16 00 00 00       	mov    $0x16,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <getlev>:
SYSCALL(getlev)
 83a:	b8 17 00 00 00       	mov    $0x17,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <setpriority>:
SYSCALL(setpriority)
 842:	b8 18 00 00 00       	mov    $0x18,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <getadmin>:
SYSCALL(getadmin)
 84a:	b8 19 00 00 00       	mov    $0x19,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <exec2>:
SYSCALL(exec2)
 852:	b8 1a 00 00 00       	mov    $0x1a,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <setmemorylimit>:
SYSCALL(setmemorylimit)
 85a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    

00000862 <list>:
SYSCALL(list)
 862:	b8 1c 00 00 00       	mov    $0x1c,%eax
 867:	cd 40                	int    $0x40
 869:	c3                   	ret    
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
 8b1:	0f b6 92 60 0d 00 00 	movzbl 0xd60(%edx),%edx
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
 8e8:	e8 c5 fe ff ff       	call   7b2 <write>
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
 95a:	e8 53 fe ff ff       	call   7b2 <write>
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
 9bc:	e8 f1 fd ff ff       	call   7b2 <write>
 9c1:	83 c4 0c             	add    $0xc,%esp
 9c4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 9c7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 9ca:	6a 01                	push   $0x1
 9cc:	50                   	push   %eax
 9cd:	57                   	push   %edi
 9ce:	83 c6 01             	add    $0x1,%esi
 9d1:	e8 dc fd ff ff       	call   7b2 <write>
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
 a2b:	b8 58 0d 00 00       	mov    $0xd58,%eax
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
 a50:	e8 5d fd ff ff       	call   7b2 <write>
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
 aa1:	e8 0c fd ff ff       	call   7b2 <write>
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
 ab1:	a1 a4 11 00 00       	mov    0x11a4,%eax
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
 b09:	a3 a4 11 00 00       	mov    %eax,0x11a4
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
 b2d:	a3 a4 11 00 00       	mov    %eax,0x11a4
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
 b4c:	8b 15 a4 11 00 00    	mov    0x11a4,%edx
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
 ba1:	39 05 a4 11 00 00    	cmp    %eax,0x11a4
 ba7:	89 c2                	mov    %eax,%edx
 ba9:	75 ed                	jne    b98 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 bab:	83 ec 0c             	sub    $0xc,%esp
 bae:	53                   	push   %ebx
 baf:	e8 66 fc ff ff       	call   81a <sbrk>
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
 bcb:	8b 15 a4 11 00 00    	mov    0x11a4,%edx
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
 bef:	89 15 a4 11 00 00    	mov    %edx,0x11a4
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
 c06:	c7 05 a4 11 00 00 a8 	movl   $0x11a8,0x11a4
 c0d:	11 00 00 
 c10:	c7 05 a8 11 00 00 a8 	movl   $0x11a8,0x11a8
 c17:	11 00 00 
    base.s.size = 0;
 c1a:	b8 a8 11 00 00       	mov    $0x11a8,%eax
 c1f:	c7 05 ac 11 00 00 00 	movl   $0x0,0x11ac
 c26:	00 00 00 
 c29:	e9 3e ff ff ff       	jmp    b6c <malloc+0x2c>
