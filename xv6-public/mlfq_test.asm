
_mlfq_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    exit();
  while (wait() != -1);
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  int count[MAX_LEVEL] = {0};
  13:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  1a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  21:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  28:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int child;

  parent = getpid();
  36:	e8 07 09 00 00       	call   942 <getpid>

  printf(1, "MLFQ test start\n");
  3b:	83 ec 08             	sub    $0x8,%esp
{
  int i, pid;
  int count[MAX_LEVEL] = {0};
  int child;

  parent = getpid();
  3e:	a3 70 13 00 00       	mov    %eax,0x1370

  printf(1, "MLFQ test start\n");
  43:	68 69 0d 00 00       	push   $0xd69
  48:	6a 01                	push   $0x1
  4a:	e8 e1 09 00 00       	call   a30 <printf>

  printf(1, "[Test 1] default\n");
  4f:	59                   	pop    %ecx
  50:	5b                   	pop    %ebx
  51:	68 7a 0d 00 00       	push   $0xd7a
  56:	6a 01                	push   $0x1
  58:	bb a0 86 01 00       	mov    $0x186a0,%ebx
  5d:	e8 ce 09 00 00       	call   a30 <printf>
  pid = fork_children();
  62:	e8 e9 04 00 00       	call   550 <fork_children>

  if (pid != parent)
  67:	83 c4 10             	add    $0x10,%esp
  6a:	3b 05 70 13 00 00    	cmp    0x1370,%eax
  70:	89 c6                	mov    %eax,%esi
  72:	75 16                	jne    8a <main+0x8a>
  74:	eb 64                	jmp    da <main+0xda>
  76:	8d 76 00             	lea    0x0(%esi),%esi
  79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
  80:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
  printf(1, "[Test 1] default\n");
  pid = fork_children();

  if (pid != parent)
  {
    for (i = 0; i < NUM_LOOP; i++)
  85:	83 eb 01             	sub    $0x1,%ebx
  88:	74 1f                	je     a9 <main+0xa9>
    {
      int x = getlev();
  8a:	e8 db 08 00 00       	call   96a <getlev>
      if (x < 0 || x > 4)
  8f:	83 f8 04             	cmp    $0x4,%eax
  92:	76 ec                	jbe    80 <main+0x80>
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
  94:	83 ec 04             	sub    $0x4,%esp
  97:	50                   	push   %eax
  98:	68 b4 0d 00 00       	push   $0xdb4
  9d:	6a 01                	push   $0x1
  9f:	e8 8c 09 00 00       	call   a30 <printf>
        exit();
  a4:	e8 19 08 00 00       	call   8c2 <exit>
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
  a9:	50                   	push   %eax
  aa:	56                   	push   %esi
  ab:	8d 75 d4             	lea    -0x2c(%ebp),%esi
  ae:	68 c5 0d 00 00       	push   $0xdc5
  b3:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
  b5:	31 db                	xor    %ebx,%ebx
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
  b7:	e8 74 09 00 00       	call   a30 <printf>
  bc:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < MAX_LEVEL; i++)
      printf(1, "L%d: %d\n", i, count[i]);
  bf:	ff 34 9e             	pushl  (%esi,%ebx,4)
  c2:	53                   	push   %ebx
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
  c3:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
  c6:	68 d1 0d 00 00       	push   $0xdd1
  cb:	6a 01                	push   $0x1
  cd:	e8 5e 09 00 00       	call   a30 <printf>
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	83 fb 05             	cmp    $0x5,%ebx
  d8:	75 e5                	jne    bf <main+0xbf>
      printf(1, "L%d: %d\n", i, count[i]);
  }
  exit_children();
  da:	e8 71 05 00 00       	call   650 <exit_children>
  printf(1, "[Test 1] finished\n");
  df:	50                   	push   %eax
  e0:	50                   	push   %eax
  e1:	bb a0 86 01 00       	mov    $0x186a0,%ebx
  e6:	68 8c 0d 00 00       	push   $0xd8c
  eb:	6a 01                	push   $0x1
  ed:	e8 3e 09 00 00       	call   a30 <printf>

  printf(1, "[Test 2] priorities\n");
  f2:	58                   	pop    %eax
  f3:	5a                   	pop    %edx
  f4:	68 9f 0d 00 00       	push   $0xd9f
  f9:	6a 01                	push   $0x1
  fb:	e8 30 09 00 00       	call   a30 <printf>
  pid = fork_children2();
 100:	e8 8b 04 00 00       	call   590 <fork_children2>

  if (pid != parent)
 105:	83 c4 10             	add    $0x10,%esp
 108:	3b 05 70 13 00 00    	cmp    0x1370,%eax
  }
  exit_children();
  printf(1, "[Test 1] finished\n");

  printf(1, "[Test 2] priorities\n");
  pid = fork_children2();
 10e:	89 c6                	mov    %eax,%esi

  if (pid != parent)
 110:	75 10                	jne    122 <main+0x122>
 112:	eb 4e                	jmp    162 <main+0x162>
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
 118:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
  printf(1, "[Test 2] priorities\n");
  pid = fork_children2();

  if (pid != parent)
  {
    for (i = 0; i < NUM_LOOP; i++)
 11d:	83 eb 01             	sub    $0x1,%ebx
 120:	74 0f                	je     131 <main+0x131>
    {
      int x = getlev();
 122:	e8 43 08 00 00       	call   96a <getlev>
      if (x < 0 || x > 4)
 127:	83 f8 04             	cmp    $0x4,%eax
 12a:	76 ec                	jbe    118 <main+0x118>
 12c:	e9 63 ff ff ff       	jmp    94 <main+0x94>
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
 131:	51                   	push   %ecx
 132:	56                   	push   %esi
 133:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 136:	68 c5 0d 00 00       	push   $0xdc5
 13b:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 13d:	31 db                	xor    %ebx,%ebx
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
 13f:	e8 ec 08 00 00       	call   a30 <printf>
 144:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < MAX_LEVEL; i++)
      printf(1, "L%d: %d\n", i, count[i]);
 147:	ff 34 9e             	pushl  (%esi,%ebx,4)
 14a:	53                   	push   %ebx
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 14b:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 14e:	68 d1 0d 00 00       	push   $0xdd1
 153:	6a 01                	push   $0x1
 155:	e8 d6 08 00 00       	call   a30 <printf>
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	83 fb 05             	cmp    $0x5,%ebx
 160:	75 e5                	jne    147 <main+0x147>
      printf(1, "L%d: %d\n", i, count[i]);
  }
  exit_children();
 162:	e8 e9 04 00 00       	call   650 <exit_children>
  printf(1, "[Test 2] finished\n");
 167:	53                   	push   %ebx
 168:	53                   	push   %ebx
 169:	bb 20 4e 00 00       	mov    $0x4e20,%ebx
 16e:	68 da 0d 00 00       	push   $0xdda
 173:	6a 01                	push   $0x1
 175:	e8 b6 08 00 00       	call   a30 <printf>
  
  printf(1, "[Test 3] yield\n");
 17a:	5e                   	pop    %esi
 17b:	58                   	pop    %eax
 17c:	68 ed 0d 00 00       	push   $0xded
 181:	6a 01                	push   $0x1
 183:	e8 a8 08 00 00       	call   a30 <printf>
  pid = fork_children2();
 188:	e8 03 04 00 00       	call   590 <fork_children2>

  if (pid != parent)
 18d:	83 c4 10             	add    $0x10,%esp
 190:	3b 05 70 13 00 00    	cmp    0x1370,%eax
  }
  exit_children();
  printf(1, "[Test 2] finished\n");
  
  printf(1, "[Test 3] yield\n");
  pid = fork_children2();
 196:	89 c6                	mov    %eax,%esi

  if (pid != parent)
 198:	75 15                	jne    1af <main+0x1af>
 19a:	eb 53                	jmp    1ef <main+0x1ef>
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
 1a0:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
      yield();
 1a5:	e8 b8 07 00 00       	call   962 <yield>
  printf(1, "[Test 3] yield\n");
  pid = fork_children2();

  if (pid != parent)
  {
    for (i = 0; i < NUM_YIELD; i++)
 1aa:	83 eb 01             	sub    $0x1,%ebx
 1ad:	74 0f                	je     1be <main+0x1be>
    {
      int x = getlev();
 1af:	e8 b6 07 00 00       	call   96a <getlev>
      if (x < 0 || x > 4)
 1b4:	83 f8 04             	cmp    $0x4,%eax
 1b7:	76 e7                	jbe    1a0 <main+0x1a0>
 1b9:	e9 d6 fe ff ff       	jmp    94 <main+0x94>
        exit();
      }
      count[x]++;
      yield();
    }
    printf(1, "Process %d\n", pid);
 1be:	50                   	push   %eax
 1bf:	56                   	push   %esi
 1c0:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 1c3:	68 c5 0d 00 00       	push   $0xdc5
 1c8:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 1ca:	31 db                	xor    %ebx,%ebx
        exit();
      }
      count[x]++;
      yield();
    }
    printf(1, "Process %d\n", pid);
 1cc:	e8 5f 08 00 00       	call   a30 <printf>
 1d1:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < MAX_LEVEL; i++)
      printf(1, "L%d: %d\n", i, count[i]);
 1d4:	ff 34 9e             	pushl  (%esi,%ebx,4)
 1d7:	53                   	push   %ebx
      }
      count[x]++;
      yield();
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 1d8:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 1db:	68 d1 0d 00 00       	push   $0xdd1
 1e0:	6a 01                	push   $0x1
 1e2:	e8 49 08 00 00       	call   a30 <printf>
      }
      count[x]++;
      yield();
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	83 fb 05             	cmp    $0x5,%ebx
 1ed:	75 e5                	jne    1d4 <main+0x1d4>
      printf(1, "L%d: %d\n", i, count[i]);
  }
  exit_children();
 1ef:	e8 5c 04 00 00       	call   650 <exit_children>
  printf(1, "[Test 3] finished\n");
 1f4:	50                   	push   %eax
 1f5:	50                   	push   %eax
 1f6:	bb f4 01 00 00       	mov    $0x1f4,%ebx
 1fb:	68 fd 0d 00 00       	push   $0xdfd
 200:	6a 01                	push   $0x1
 202:	e8 29 08 00 00       	call   a30 <printf>

  printf(1, "[Test 4] sleep\n");
 207:	58                   	pop    %eax
 208:	5a                   	pop    %edx
 209:	68 10 0e 00 00       	push   $0xe10
 20e:	6a 01                	push   $0x1
 210:	e8 1b 08 00 00       	call   a30 <printf>
  pid = fork_children2();
 215:	e8 76 03 00 00       	call   590 <fork_children2>

  if (pid != parent)
 21a:	83 c4 10             	add    $0x10,%esp
 21d:	3b 05 70 13 00 00    	cmp    0x1370,%eax
  }
  exit_children();
  printf(1, "[Test 3] finished\n");

  printf(1, "[Test 4] sleep\n");
  pid = fork_children2();
 223:	89 c6                	mov    %eax,%esi

  if (pid != parent)
 225:	75 19                	jne    240 <main+0x240>
 227:	eb 57                	jmp    280 <main+0x280>
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
      sleep(1);
 229:	83 ec 0c             	sub    $0xc,%esp
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
 22c:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
      sleep(1);
 231:	6a 01                	push   $0x1
 233:	e8 1a 07 00 00       	call   952 <sleep>
  printf(1, "[Test 4] sleep\n");
  pid = fork_children2();

  if (pid != parent)
  {
    for (i = 0; i < NUM_SLEEP; i++)
 238:	83 c4 10             	add    $0x10,%esp
 23b:	83 eb 01             	sub    $0x1,%ebx
 23e:	74 0f                	je     24f <main+0x24f>
    {
      int x = getlev();
 240:	e8 25 07 00 00       	call   96a <getlev>
      if (x < 0 || x > 4)
 245:	83 f8 04             	cmp    $0x4,%eax
 248:	76 df                	jbe    229 <main+0x229>
 24a:	e9 45 fe ff ff       	jmp    94 <main+0x94>
        exit();
      }
      count[x]++;
      sleep(1);
    }
    printf(1, "Process %d\n", pid);
 24f:	51                   	push   %ecx
 250:	56                   	push   %esi
 251:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 254:	68 c5 0d 00 00       	push   $0xdc5
 259:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 25b:	31 db                	xor    %ebx,%ebx
        exit();
      }
      count[x]++;
      sleep(1);
    }
    printf(1, "Process %d\n", pid);
 25d:	e8 ce 07 00 00       	call   a30 <printf>
 262:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < MAX_LEVEL; i++)
      printf(1, "L%d: %d\n", i, count[i]);
 265:	ff 34 9e             	pushl  (%esi,%ebx,4)
 268:	53                   	push   %ebx
      }
      count[x]++;
      sleep(1);
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 269:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 26c:	68 d1 0d 00 00       	push   $0xdd1
 271:	6a 01                	push   $0x1
 273:	e8 b8 07 00 00       	call   a30 <printf>
      }
      count[x]++;
      sleep(1);
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 278:	83 c4 10             	add    $0x10,%esp
 27b:	83 fb 05             	cmp    $0x5,%ebx
 27e:	75 e5                	jne    265 <main+0x265>
      printf(1, "L%d: %d\n", i, count[i]);
  }
  exit_children();
 280:	e8 cb 03 00 00       	call   650 <exit_children>
  printf(1, "[Test 4] finished\n");
 285:	53                   	push   %ebx
 286:	53                   	push   %ebx
 287:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 28c:	68 20 0e 00 00       	push   $0xe20
 291:	6a 01                	push   $0x1
 293:	e8 98 07 00 00       	call   a30 <printf>
  
  printf(1, "[Test 5] max level\n");
 298:	5e                   	pop    %esi
 299:	58                   	pop    %eax
 29a:	68 33 0e 00 00       	push   $0xe33
 29f:	6a 01                	push   $0x1
 2a1:	e8 8a 07 00 00       	call   a30 <printf>
  pid = fork_children3();
 2a6:	e8 55 03 00 00       	call   600 <fork_children3>

  if (pid != parent)
 2ab:	83 c4 10             	add    $0x10,%esp
 2ae:	3b 05 70 13 00 00    	cmp    0x1370,%eax
  }
  exit_children();
  printf(1, "[Test 4] finished\n");
  
  printf(1, "[Test 5] max level\n");
  pid = fork_children3();
 2b4:	89 c6                	mov    %eax,%esi

  if (pid != parent)
 2b6:	75 07                	jne    2bf <main+0x2bf>
 2b8:	eb 58                	jmp    312 <main+0x312>
  {
    for (i = 0; i < NUM_LOOP; i++)
 2ba:	83 eb 01             	sub    $0x1,%ebx
 2bd:	74 22                	je     2e1 <main+0x2e1>
    {
      int x = getlev();
 2bf:	e8 a6 06 00 00       	call   96a <getlev>
      if (x < 0 || x > 4)
 2c4:	83 f8 04             	cmp    $0x4,%eax
 2c7:	0f 87 c7 fd ff ff    	ja     94 <main+0x94>
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
 2cd:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
      if (x > max_level)
 2d2:	3b 05 74 13 00 00    	cmp    0x1374,%eax
 2d8:	7e e0                	jle    2ba <main+0x2ba>
        yield();
 2da:	e8 83 06 00 00       	call   962 <yield>
 2df:	eb d9                	jmp    2ba <main+0x2ba>
    }
    printf(1, "Process %d\n", pid);
 2e1:	53                   	push   %ebx
 2e2:	56                   	push   %esi
 2e3:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 2e6:	68 c5 0d 00 00       	push   $0xdc5
 2eb:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 2ed:	31 db                	xor    %ebx,%ebx
      }
      count[x]++;
      if (x > max_level)
        yield();
    }
    printf(1, "Process %d\n", pid);
 2ef:	e8 3c 07 00 00       	call   a30 <printf>
 2f4:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < MAX_LEVEL; i++)
      printf(1, "L%d: %d\n", i, count[i]);
 2f7:	ff 34 9e             	pushl  (%esi,%ebx,4)
 2fa:	53                   	push   %ebx
      count[x]++;
      if (x > max_level)
        yield();
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 2fb:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 2fe:	68 d1 0d 00 00       	push   $0xdd1
 303:	6a 01                	push   $0x1
 305:	e8 26 07 00 00       	call   a30 <printf>
      count[x]++;
      if (x > max_level)
        yield();
    }
    printf(1, "Process %d\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	83 fb 05             	cmp    $0x5,%ebx
 310:	75 e5                	jne    2f7 <main+0x2f7>
      printf(1, "L%d: %d\n", i, count[i]);
  }
  exit_children();
 312:	e8 39 03 00 00       	call   650 <exit_children>
  printf(1, "[Test 5] finished\n");
 317:	56                   	push   %esi
 318:	56                   	push   %esi
 319:	68 47 0e 00 00       	push   $0xe47
 31e:	6a 01                	push   $0x1
 320:	e8 0b 07 00 00       	call   a30 <printf>
  
  printf(1, "[Test 6] setpriority return value\n");
 325:	58                   	pop    %eax
 326:	5a                   	pop    %edx
 327:	68 74 0e 00 00       	push   $0xe74
 32c:	6a 01                	push   $0x1
 32e:	e8 fd 06 00 00       	call   a30 <printf>
  child = fork();
 333:	e8 82 05 00 00       	call   8ba <fork>

  if (child == 0)
 338:	83 c4 10             	add    $0x10,%esp
 33b:	85 c0                	test   %eax,%eax
  }
  exit_children();
  printf(1, "[Test 5] finished\n");
  
  printf(1, "[Test 6] setpriority return value\n");
  child = fork();
 33d:	89 c3                	mov    %eax,%ebx

  if (child == 0)
 33f:	0f 85 a8 00 00 00    	jne    3ed <main+0x3ed>
  {
    int r;
    int grandson;
    sleep(10);
 345:	83 ec 0c             	sub    $0xc,%esp
 348:	6a 0a                	push   $0xa
 34a:	e8 03 06 00 00       	call   952 <sleep>
    grandson = fork();
 34f:	e8 66 05 00 00       	call   8ba <fork>
    if (grandson == 0)
 354:	83 c4 10             	add    $0x10,%esp
 357:	85 c0                	test   %eax,%eax
 359:	0f 85 b5 00 00 00    	jne    414 <main+0x414>
    {
      r = setpriority(getpid() - 2, 0);
 35f:	e8 de 05 00 00       	call   942 <getpid>
 364:	83 e8 02             	sub    $0x2,%eax
 367:	51                   	push   %ecx
 368:	51                   	push   %ecx
 369:	6a 00                	push   $0x0
 36b:	50                   	push   %eax
 36c:	e8 01 06 00 00       	call   972 <setpriority>
      if (r != -1)
 371:	83 c4 10             	add    $0x10,%esp
 374:	83 f8 ff             	cmp    $0xffffffff,%eax
 377:	74 11                	je     38a <main+0x38a>
        printf(1, "wrong: setpriority of parent: expected -1, got %d\n", r);
 379:	52                   	push   %edx
 37a:	50                   	push   %eax
 37b:	68 98 0e 00 00       	push   $0xe98
 380:	6a 01                	push   $0x1
 382:	e8 a9 06 00 00       	call   a30 <printf>
 387:	83 c4 10             	add    $0x10,%esp
      r = setpriority(getpid() - 3, 0);
 38a:	e8 b3 05 00 00       	call   942 <getpid>
 38f:	83 e8 03             	sub    $0x3,%eax
 392:	56                   	push   %esi
 393:	56                   	push   %esi
 394:	6a 00                	push   $0x0
 396:	50                   	push   %eax
 397:	e8 d6 05 00 00       	call   972 <setpriority>
      if (r != -1)
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	83 f8 ff             	cmp    $0xffffffff,%eax
 3a2:	74 11                	je     3b5 <main+0x3b5>
        printf(1, "wrong: setpriority of ancestor: expected -1, got %d\n", r);
 3a4:	53                   	push   %ebx
 3a5:	50                   	push   %eax
 3a6:	68 cc 0e 00 00       	push   $0xecc
 3ab:	6a 01                	push   $0x1
 3ad:	e8 7e 06 00 00       	call   a30 <printf>
 3b2:	83 c4 10             	add    $0x10,%esp
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
      r = setpriority(getpid() + 1, 0);
      if (r != -1)
        printf(1, "wrong: setpriority of other: expected -1, got %d\n", r);
    }
    sleep(20);
 3b5:	83 ec 0c             	sub    $0xc,%esp
 3b8:	6a 14                	push   $0x14
 3ba:	e8 93 05 00 00       	call   952 <sleep>
    wait();
 3bf:	e8 06 05 00 00       	call   8ca <wait>
 3c4:	83 c4 10             	add    $0x10,%esp
      if (r != -1)
        printf(1, "wrong: setpriority of self: expected -1, got %d\n", r);
    }
  }

  exit_children();
 3c7:	e8 84 02 00 00       	call   650 <exit_children>
  printf(1, "done\n");
 3cc:	50                   	push   %eax
 3cd:	50                   	push   %eax
 3ce:	68 5a 0e 00 00       	push   $0xe5a
 3d3:	6a 01                	push   $0x1
 3d5:	e8 56 06 00 00       	call   a30 <printf>
  printf(1, "[Test 6] finished\n");
 3da:	5a                   	pop    %edx
 3db:	59                   	pop    %ecx
 3dc:	68 60 0e 00 00       	push   $0xe60
 3e1:	6a 01                	push   $0x1
 3e3:	e8 48 06 00 00       	call   a30 <printf>

  exit();
 3e8:	e8 d5 04 00 00       	call   8c2 <exit>
    wait();
  }
  else
  {
    int r;
    int child2 = fork();
 3ed:	e8 c8 04 00 00       	call   8ba <fork>
    sleep(20);
 3f2:	83 ec 0c             	sub    $0xc,%esp
    wait();
  }
  else
  {
    int r;
    int child2 = fork();
 3f5:	89 c6                	mov    %eax,%esi
    sleep(20);
 3f7:	6a 14                	push   $0x14
 3f9:	e8 54 05 00 00       	call   952 <sleep>
    if (child2 == 0)
 3fe:	83 c4 10             	add    $0x10,%esp
 401:	85 f6                	test   %esi,%esi
 403:	75 65                	jne    46a <main+0x46a>
      sleep(10);
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	6a 0a                	push   $0xa
 40a:	e8 43 05 00 00       	call   952 <sleep>
 40f:	83 c4 10             	add    $0x10,%esp
 412:	eb b3                	jmp    3c7 <main+0x3c7>
      if (r != -1)
        printf(1, "wrong: setpriority of ancestor: expected -1, got %d\n", r);
    }
    else
    {
      r = setpriority(grandson, 0);
 414:	51                   	push   %ecx
 415:	51                   	push   %ecx
 416:	6a 00                	push   $0x0
 418:	50                   	push   %eax
 419:	e8 54 05 00 00       	call   972 <setpriority>
      if (r != 0)
 41e:	83 c4 10             	add    $0x10,%esp
 421:	85 c0                	test   %eax,%eax
 423:	74 11                	je     436 <main+0x436>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 425:	52                   	push   %edx
 426:	50                   	push   %eax
 427:	68 04 0f 00 00       	push   $0xf04
 42c:	6a 01                	push   $0x1
 42e:	e8 fd 05 00 00       	call   a30 <printf>
 433:	83 c4 10             	add    $0x10,%esp
      r = setpriority(getpid() + 1, 0);
 436:	e8 07 05 00 00       	call   942 <getpid>
 43b:	83 c0 01             	add    $0x1,%eax
 43e:	56                   	push   %esi
 43f:	56                   	push   %esi
 440:	6a 00                	push   $0x0
 442:	50                   	push   %eax
 443:	e8 2a 05 00 00       	call   972 <setpriority>
      if (r != -1)
 448:	83 c4 10             	add    $0x10,%esp
 44b:	83 f8 ff             	cmp    $0xffffffff,%eax
 44e:	0f 84 61 ff ff ff    	je     3b5 <main+0x3b5>
        printf(1, "wrong: setpriority of other: expected -1, got %d\n", r);
 454:	53                   	push   %ebx
 455:	50                   	push   %eax
 456:	68 38 0f 00 00       	push   $0xf38
 45b:	6a 01                	push   $0x1
 45d:	e8 ce 05 00 00       	call   a30 <printf>
 462:	83 c4 10             	add    $0x10,%esp
 465:	e9 4b ff ff ff       	jmp    3b5 <main+0x3b5>
    sleep(20);
    if (child2 == 0)
      sleep(10);
    else
    {
      r = setpriority(child, -1);
 46a:	51                   	push   %ecx
 46b:	51                   	push   %ecx
 46c:	6a ff                	push   $0xffffffff
 46e:	53                   	push   %ebx
 46f:	e8 fe 04 00 00       	call   972 <setpriority>
      if (r != -2)
 474:	83 c4 10             	add    $0x10,%esp
 477:	83 f8 fe             	cmp    $0xfffffffe,%eax
 47a:	74 11                	je     48d <main+0x48d>
        printf(1, "wrong: setpriority out of range: expected -2, got %d\n", r);
 47c:	52                   	push   %edx
 47d:	50                   	push   %eax
 47e:	68 6c 0f 00 00       	push   $0xf6c
 483:	6a 01                	push   $0x1
 485:	e8 a6 05 00 00       	call   a30 <printf>
 48a:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child, 11);
 48d:	50                   	push   %eax
 48e:	50                   	push   %eax
 48f:	6a 0b                	push   $0xb
 491:	53                   	push   %ebx
 492:	e8 db 04 00 00       	call   972 <setpriority>
      if (r != -2)
 497:	83 c4 10             	add    $0x10,%esp
 49a:	83 f8 fe             	cmp    $0xfffffffe,%eax
 49d:	74 11                	je     4b0 <main+0x4b0>
        printf(1, "wrong: setpriority out of range: expected -2, got %d\n", r);
 49f:	56                   	push   %esi
 4a0:	50                   	push   %eax
 4a1:	68 6c 0f 00 00       	push   $0xf6c
 4a6:	6a 01                	push   $0x1
 4a8:	e8 83 05 00 00       	call   a30 <printf>
 4ad:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child, 10);
 4b0:	51                   	push   %ecx
 4b1:	51                   	push   %ecx
 4b2:	6a 0a                	push   $0xa
 4b4:	53                   	push   %ebx
 4b5:	e8 b8 04 00 00       	call   972 <setpriority>
      if (r != 0)
 4ba:	83 c4 10             	add    $0x10,%esp
 4bd:	85 c0                	test   %eax,%eax
 4bf:	74 11                	je     4d2 <main+0x4d2>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 4c1:	52                   	push   %edx
 4c2:	50                   	push   %eax
 4c3:	68 04 0f 00 00       	push   $0xf04
 4c8:	6a 01                	push   $0x1
 4ca:	e8 61 05 00 00       	call   a30 <printf>
 4cf:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child + 1, 10);
 4d2:	50                   	push   %eax
 4d3:	50                   	push   %eax
 4d4:	8d 43 01             	lea    0x1(%ebx),%eax
 4d7:	6a 0a                	push   $0xa
 4d9:	50                   	push   %eax
 4da:	e8 93 04 00 00       	call   972 <setpriority>
      if (r != 0)
 4df:	83 c4 10             	add    $0x10,%esp
 4e2:	85 c0                	test   %eax,%eax
 4e4:	74 11                	je     4f7 <main+0x4f7>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 4e6:	56                   	push   %esi
 4e7:	50                   	push   %eax
 4e8:	68 04 0f 00 00       	push   $0xf04
 4ed:	6a 01                	push   $0x1
 4ef:	e8 3c 05 00 00       	call   a30 <printf>
 4f4:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child + 2, 10);
 4f7:	83 c3 02             	add    $0x2,%ebx
 4fa:	51                   	push   %ecx
 4fb:	51                   	push   %ecx
 4fc:	6a 0a                	push   $0xa
 4fe:	53                   	push   %ebx
 4ff:	e8 6e 04 00 00       	call   972 <setpriority>
      if (r != -1)
 504:	83 c4 10             	add    $0x10,%esp
 507:	83 f8 ff             	cmp    $0xffffffff,%eax
 50a:	74 11                	je     51d <main+0x51d>
        printf(1, "wrong: setpriority of grandson: expected -1, got %d\n", r);
 50c:	52                   	push   %edx
 50d:	50                   	push   %eax
 50e:	68 a4 0f 00 00       	push   $0xfa4
 513:	6a 01                	push   $0x1
 515:	e8 16 05 00 00       	call   a30 <printf>
 51a:	83 c4 10             	add    $0x10,%esp
      r = setpriority(parent, 5);
 51d:	56                   	push   %esi
 51e:	56                   	push   %esi
 51f:	6a 05                	push   $0x5
 521:	ff 35 70 13 00 00    	pushl  0x1370
 527:	e8 46 04 00 00       	call   972 <setpriority>
      if (r != -1)
 52c:	83 c4 10             	add    $0x10,%esp
 52f:	83 f8 ff             	cmp    $0xffffffff,%eax
 532:	0f 84 8f fe ff ff    	je     3c7 <main+0x3c7>
        printf(1, "wrong: setpriority of self: expected -1, got %d\n", r);
 538:	53                   	push   %ebx
 539:	50                   	push   %eax
 53a:	68 dc 0f 00 00       	push   $0xfdc
 53f:	6a 01                	push   $0x1
 541:	e8 ea 04 00 00       	call   a30 <printf>
 546:	83 c4 10             	add    $0x10,%esp
 549:	e9 79 fe ff ff       	jmp    3c7 <main+0x3c7>
 54e:	66 90                	xchg   %ax,%ax

00000550 <fork_children>:
#define MAX_LEVEL 5

int parent;

int fork_children()
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	53                   	push   %ebx
 554:	bb 04 00 00 00       	mov    $0x4,%ebx
 559:	83 ec 04             	sub    $0x4,%esp
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
    if ((p = fork()) == 0)
 55c:	e8 59 03 00 00       	call   8ba <fork>
 561:	85 c0                	test   %eax,%eax
 563:	74 13                	je     578 <fork_children+0x28>
int parent;

int fork_children()
{
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
 565:	83 eb 01             	sub    $0x1,%ebx
 568:	75 f2                	jne    55c <fork_children+0xc>
    {
      sleep(10);
      return getpid();
    }
  return parent;
}
 56a:	a1 70 13 00 00       	mov    0x1370,%eax
 56f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 572:	c9                   	leave  
 573:	c3                   	ret    
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
    {
      sleep(10);
 578:	83 ec 0c             	sub    $0xc,%esp
 57b:	6a 0a                	push   $0xa
 57d:	e8 d0 03 00 00       	call   952 <sleep>
      return getpid();
 582:	83 c4 10             	add    $0x10,%esp
    {
      sleep(10);
      return getpid();
    }
  return parent;
}
 585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 588:	c9                   	leave  
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
    {
      sleep(10);
      return getpid();
 589:	e9 b4 03 00 00       	jmp    942 <getpid>
 58e:	66 90                	xchg   %ax,%ax

00000590 <fork_children2>:
  return parent;
}


int fork_children2()
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
 594:	31 db                	xor    %ebx,%ebx
  return parent;
}


int fork_children2()
{
 596:	83 ec 04             	sub    $0x4,%esp
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
 599:	e8 1c 03 00 00       	call   8ba <fork>
 59e:	85 c0                	test   %eax,%eax
 5a0:	74 26                	je     5c8 <fork_children2+0x38>
      sleep(10);
      return getpid();
    }
    else
    {
      int r = setpriority(p, i);
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	53                   	push   %ebx
 5a6:	50                   	push   %eax
 5a7:	e8 c6 03 00 00       	call   972 <setpriority>
      if (r < 0)
 5ac:	83 c4 10             	add    $0x10,%esp
 5af:	85 c0                	test   %eax,%eax
 5b1:	78 2b                	js     5de <fork_children2+0x4e>


int fork_children2()
{
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
 5b3:	83 c3 01             	add    $0x1,%ebx
 5b6:	83 fb 04             	cmp    $0x4,%ebx
 5b9:	75 de                	jne    599 <fork_children2+0x9>
        exit();
      }
    }
  }
  return parent;
}
 5bb:	a1 70 13 00 00       	mov    0x1370,%eax
 5c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    
 5c5:	8d 76 00             	lea    0x0(%esi),%esi
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
    {
      sleep(10);
 5c8:	83 ec 0c             	sub    $0xc,%esp
 5cb:	6a 0a                	push   $0xa
 5cd:	e8 80 03 00 00       	call   952 <sleep>
      return getpid();
 5d2:	83 c4 10             	add    $0x10,%esp
        exit();
      }
    }
  }
  return parent;
}
 5d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5d8:	c9                   	leave  
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
    {
      sleep(10);
      return getpid();
 5d9:	e9 64 03 00 00       	jmp    942 <getpid>
    else
    {
      int r = setpriority(p, i);
      if (r < 0)
      {
        printf(1, "setpriority returned %d\n", r);
 5de:	83 ec 04             	sub    $0x4,%esp
 5e1:	50                   	push   %eax
 5e2:	68 50 0d 00 00       	push   $0xd50
 5e7:	6a 01                	push   $0x1
 5e9:	e8 42 04 00 00       	call   a30 <printf>
        exit();
 5ee:	e8 cf 02 00 00       	call   8c2 <exit>
 5f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000600 <fork_children3>:
}

int max_level;

int fork_children3()
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	53                   	push   %ebx
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
 604:	31 db                	xor    %ebx,%ebx
}

int max_level;

int fork_children3()
{
 606:	83 ec 04             	sub    $0x4,%esp
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
 609:	e8 ac 02 00 00       	call   8ba <fork>
 60e:	85 c0                	test   %eax,%eax
 610:	74 16                	je     628 <fork_children3+0x28>
int max_level;

int fork_children3()
{
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
 612:	83 c3 01             	add    $0x1,%ebx
 615:	83 fb 04             	cmp    $0x4,%ebx
 618:	75 ef                	jne    609 <fork_children3+0x9>
      max_level = i;
      return getpid();
    }
  }
  return parent;
}
 61a:	a1 70 13 00 00       	mov    0x1370,%eax
 61f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 622:	c9                   	leave  
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
  {
    if ((p = fork()) == 0)
    {
      sleep(10);
 628:	83 ec 0c             	sub    $0xc,%esp
 62b:	6a 0a                	push   $0xa
 62d:	e8 20 03 00 00       	call   952 <sleep>
      max_level = i;
 632:	89 1d 74 13 00 00    	mov    %ebx,0x1374
      return getpid();
 638:	83 c4 10             	add    $0x10,%esp
    }
  }
  return parent;
}
 63b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 63e:	c9                   	leave  
  {
    if ((p = fork()) == 0)
    {
      sleep(10);
      max_level = i;
      return getpid();
 63f:	e9 fe 02 00 00       	jmp    942 <getpid>
 644:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 64a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000650 <exit_children>:
    }
  }
  return parent;
}
void exit_children()
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 08             	sub    $0x8,%esp
  if (getpid() != parent)
 656:	e8 e7 02 00 00       	call   942 <getpid>
 65b:	3b 05 70 13 00 00    	cmp    0x1370,%eax
 661:	75 11                	jne    674 <exit_children+0x24>
 663:	90                   	nop
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
  while (wait() != -1);
 668:	e8 5d 02 00 00       	call   8ca <wait>
 66d:	83 f8 ff             	cmp    $0xffffffff,%eax
 670:	75 f6                	jne    668 <exit_children+0x18>
}
 672:	c9                   	leave  
 673:	c3                   	ret    
  return parent;
}
void exit_children()
{
  if (getpid() != parent)
    exit();
 674:	e8 49 02 00 00       	call   8c2 <exit>
 679:	66 90                	xchg   %ax,%ax
 67b:	66 90                	xchg   %ax,%ax
 67d:	66 90                	xchg   %ax,%ax
 67f:	90                   	nop

00000680 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	53                   	push   %ebx
 684:	8b 45 08             	mov    0x8(%ebp),%eax
 687:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 68a:	89 c2                	mov    %eax,%edx
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 690:	83 c1 01             	add    $0x1,%ecx
 693:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 697:	83 c2 01             	add    $0x1,%edx
 69a:	84 db                	test   %bl,%bl
 69c:	88 5a ff             	mov    %bl,-0x1(%edx)
 69f:	75 ef                	jne    690 <strcpy+0x10>
    ;
  return os;
}
 6a1:	5b                   	pop    %ebx
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
 6a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	56                   	push   %esi
 6b4:	53                   	push   %ebx
 6b5:	8b 55 08             	mov    0x8(%ebp),%edx
 6b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 6bb:	0f b6 02             	movzbl (%edx),%eax
 6be:	0f b6 19             	movzbl (%ecx),%ebx
 6c1:	84 c0                	test   %al,%al
 6c3:	75 1e                	jne    6e3 <strcmp+0x33>
 6c5:	eb 29                	jmp    6f0 <strcmp+0x40>
 6c7:	89 f6                	mov    %esi,%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 6d0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 6d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 6d6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 6d9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 6dd:	84 c0                	test   %al,%al
 6df:	74 0f                	je     6f0 <strcmp+0x40>
 6e1:	89 f1                	mov    %esi,%ecx
 6e3:	38 d8                	cmp    %bl,%al
 6e5:	74 e9                	je     6d0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6e7:	29 d8                	sub    %ebx,%eax
}
 6e9:	5b                   	pop    %ebx
 6ea:	5e                   	pop    %esi
 6eb:	5d                   	pop    %ebp
 6ec:	c3                   	ret    
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 6f0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6f2:	29 d8                	sub    %ebx,%eax
}
 6f4:	5b                   	pop    %ebx
 6f5:	5e                   	pop    %esi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
 6f8:	90                   	nop
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000700 <strlen>:

uint
strlen(const char *s)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 706:	80 39 00             	cmpb   $0x0,(%ecx)
 709:	74 12                	je     71d <strlen+0x1d>
 70b:	31 d2                	xor    %edx,%edx
 70d:	8d 76 00             	lea    0x0(%esi),%esi
 710:	83 c2 01             	add    $0x1,%edx
 713:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 717:	89 d0                	mov    %edx,%eax
 719:	75 f5                	jne    710 <strlen+0x10>
    ;
  return n;
}
 71b:	5d                   	pop    %ebp
 71c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 71d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 71f:	5d                   	pop    %ebp
 720:	c3                   	ret    
 721:	eb 0d                	jmp    730 <memset>
 723:	90                   	nop
 724:	90                   	nop
 725:	90                   	nop
 726:	90                   	nop
 727:	90                   	nop
 728:	90                   	nop
 729:	90                   	nop
 72a:	90                   	nop
 72b:	90                   	nop
 72c:	90                   	nop
 72d:	90                   	nop
 72e:	90                   	nop
 72f:	90                   	nop

00000730 <memset>:

void*
memset(void *dst, int c, uint n)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 737:	8b 4d 10             	mov    0x10(%ebp),%ecx
 73a:	8b 45 0c             	mov    0xc(%ebp),%eax
 73d:	89 d7                	mov    %edx,%edi
 73f:	fc                   	cld    
 740:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 742:	89 d0                	mov    %edx,%eax
 744:	5f                   	pop    %edi
 745:	5d                   	pop    %ebp
 746:	c3                   	ret    
 747:	89 f6                	mov    %esi,%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000750 <strchr>:

char*
strchr(const char *s, char c)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	53                   	push   %ebx
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 75a:	0f b6 10             	movzbl (%eax),%edx
 75d:	84 d2                	test   %dl,%dl
 75f:	74 1d                	je     77e <strchr+0x2e>
    if(*s == c)
 761:	38 d3                	cmp    %dl,%bl
 763:	89 d9                	mov    %ebx,%ecx
 765:	75 0d                	jne    774 <strchr+0x24>
 767:	eb 17                	jmp    780 <strchr+0x30>
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 770:	38 ca                	cmp    %cl,%dl
 772:	74 0c                	je     780 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 774:	83 c0 01             	add    $0x1,%eax
 777:	0f b6 10             	movzbl (%eax),%edx
 77a:	84 d2                	test   %dl,%dl
 77c:	75 f2                	jne    770 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 77e:	31 c0                	xor    %eax,%eax
}
 780:	5b                   	pop    %ebx
 781:	5d                   	pop    %ebp
 782:	c3                   	ret    
 783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000790 <gets>:

char*
gets(char *buf, int max)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 796:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 798:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 79b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 79e:	eb 29                	jmp    7c9 <gets+0x39>
    cc = read(0, &c, 1);
 7a0:	83 ec 04             	sub    $0x4,%esp
 7a3:	6a 01                	push   $0x1
 7a5:	57                   	push   %edi
 7a6:	6a 00                	push   $0x0
 7a8:	e8 2d 01 00 00       	call   8da <read>
    if(cc < 1)
 7ad:	83 c4 10             	add    $0x10,%esp
 7b0:	85 c0                	test   %eax,%eax
 7b2:	7e 1d                	jle    7d1 <gets+0x41>
      break;
    buf[i++] = c;
 7b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 7b8:	8b 55 08             	mov    0x8(%ebp),%edx
 7bb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 7bd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 7bf:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 7c3:	74 1b                	je     7e0 <gets+0x50>
 7c5:	3c 0d                	cmp    $0xd,%al
 7c7:	74 17                	je     7e0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7c9:	8d 5e 01             	lea    0x1(%esi),%ebx
 7cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 7cf:	7c cf                	jl     7a0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7d1:	8b 45 08             	mov    0x8(%ebp),%eax
 7d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 7d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7db:	5b                   	pop    %ebx
 7dc:	5e                   	pop    %esi
 7dd:	5f                   	pop    %edi
 7de:	5d                   	pop    %ebp
 7df:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7e3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 7e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7ec:	5b                   	pop    %ebx
 7ed:	5e                   	pop    %esi
 7ee:	5f                   	pop    %edi
 7ef:	5d                   	pop    %ebp
 7f0:	c3                   	ret    
 7f1:	eb 0d                	jmp    800 <stat>
 7f3:	90                   	nop
 7f4:	90                   	nop
 7f5:	90                   	nop
 7f6:	90                   	nop
 7f7:	90                   	nop
 7f8:	90                   	nop
 7f9:	90                   	nop
 7fa:	90                   	nop
 7fb:	90                   	nop
 7fc:	90                   	nop
 7fd:	90                   	nop
 7fe:	90                   	nop
 7ff:	90                   	nop

00000800 <stat>:

int
stat(const char *n, struct stat *st)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	56                   	push   %esi
 804:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 805:	83 ec 08             	sub    $0x8,%esp
 808:	6a 00                	push   $0x0
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 f0 00 00 00       	call   902 <open>
  if(fd < 0)
 812:	83 c4 10             	add    $0x10,%esp
 815:	85 c0                	test   %eax,%eax
 817:	78 27                	js     840 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	ff 75 0c             	pushl  0xc(%ebp)
 81f:	89 c3                	mov    %eax,%ebx
 821:	50                   	push   %eax
 822:	e8 f3 00 00 00       	call   91a <fstat>
 827:	89 c6                	mov    %eax,%esi
  close(fd);
 829:	89 1c 24             	mov    %ebx,(%esp)
 82c:	e8 b9 00 00 00       	call   8ea <close>
  return r;
 831:	83 c4 10             	add    $0x10,%esp
 834:	89 f0                	mov    %esi,%eax
}
 836:	8d 65 f8             	lea    -0x8(%ebp),%esp
 839:	5b                   	pop    %ebx
 83a:	5e                   	pop    %esi
 83b:	5d                   	pop    %ebp
 83c:	c3                   	ret    
 83d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 845:	eb ef                	jmp    836 <stat+0x36>
 847:	89 f6                	mov    %esi,%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	53                   	push   %ebx
 854:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 857:	0f be 11             	movsbl (%ecx),%edx
 85a:	8d 42 d0             	lea    -0x30(%edx),%eax
 85d:	3c 09                	cmp    $0x9,%al
 85f:	b8 00 00 00 00       	mov    $0x0,%eax
 864:	77 1f                	ja     885 <atoi+0x35>
 866:	8d 76 00             	lea    0x0(%esi),%esi
 869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 870:	8d 04 80             	lea    (%eax,%eax,4),%eax
 873:	83 c1 01             	add    $0x1,%ecx
 876:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 87a:	0f be 11             	movsbl (%ecx),%edx
 87d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 880:	80 fb 09             	cmp    $0x9,%bl
 883:	76 eb                	jbe    870 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 885:	5b                   	pop    %ebx
 886:	5d                   	pop    %ebp
 887:	c3                   	ret    
 888:	90                   	nop
 889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000890 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	56                   	push   %esi
 894:	53                   	push   %ebx
 895:	8b 5d 10             	mov    0x10(%ebp),%ebx
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 89e:	85 db                	test   %ebx,%ebx
 8a0:	7e 14                	jle    8b6 <memmove+0x26>
 8a2:	31 d2                	xor    %edx,%edx
 8a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 8a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 8ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 8af:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8b2:	39 da                	cmp    %ebx,%edx
 8b4:	75 f2                	jne    8a8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 8b6:	5b                   	pop    %ebx
 8b7:	5e                   	pop    %esi
 8b8:	5d                   	pop    %ebp
 8b9:	c3                   	ret    

000008ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8ba:	b8 01 00 00 00       	mov    $0x1,%eax
 8bf:	cd 40                	int    $0x40
 8c1:	c3                   	ret    

000008c2 <exit>:
SYSCALL(exit)
 8c2:	b8 02 00 00 00       	mov    $0x2,%eax
 8c7:	cd 40                	int    $0x40
 8c9:	c3                   	ret    

000008ca <wait>:
SYSCALL(wait)
 8ca:	b8 03 00 00 00       	mov    $0x3,%eax
 8cf:	cd 40                	int    $0x40
 8d1:	c3                   	ret    

000008d2 <pipe>:
SYSCALL(pipe)
 8d2:	b8 04 00 00 00       	mov    $0x4,%eax
 8d7:	cd 40                	int    $0x40
 8d9:	c3                   	ret    

000008da <read>:
SYSCALL(read)
 8da:	b8 05 00 00 00       	mov    $0x5,%eax
 8df:	cd 40                	int    $0x40
 8e1:	c3                   	ret    

000008e2 <write>:
SYSCALL(write)
 8e2:	b8 10 00 00 00       	mov    $0x10,%eax
 8e7:	cd 40                	int    $0x40
 8e9:	c3                   	ret    

000008ea <close>:
SYSCALL(close)
 8ea:	b8 15 00 00 00       	mov    $0x15,%eax
 8ef:	cd 40                	int    $0x40
 8f1:	c3                   	ret    

000008f2 <kill>:
SYSCALL(kill)
 8f2:	b8 06 00 00 00       	mov    $0x6,%eax
 8f7:	cd 40                	int    $0x40
 8f9:	c3                   	ret    

000008fa <exec>:
SYSCALL(exec)
 8fa:	b8 07 00 00 00       	mov    $0x7,%eax
 8ff:	cd 40                	int    $0x40
 901:	c3                   	ret    

00000902 <open>:
SYSCALL(open)
 902:	b8 0f 00 00 00       	mov    $0xf,%eax
 907:	cd 40                	int    $0x40
 909:	c3                   	ret    

0000090a <mknod>:
SYSCALL(mknod)
 90a:	b8 11 00 00 00       	mov    $0x11,%eax
 90f:	cd 40                	int    $0x40
 911:	c3                   	ret    

00000912 <unlink>:
SYSCALL(unlink)
 912:	b8 12 00 00 00       	mov    $0x12,%eax
 917:	cd 40                	int    $0x40
 919:	c3                   	ret    

0000091a <fstat>:
SYSCALL(fstat)
 91a:	b8 08 00 00 00       	mov    $0x8,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <link>:
SYSCALL(link)
 922:	b8 13 00 00 00       	mov    $0x13,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <mkdir>:
SYSCALL(mkdir)
 92a:	b8 14 00 00 00       	mov    $0x14,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <chdir>:
SYSCALL(chdir)
 932:	b8 09 00 00 00       	mov    $0x9,%eax
 937:	cd 40                	int    $0x40
 939:	c3                   	ret    

0000093a <dup>:
SYSCALL(dup)
 93a:	b8 0a 00 00 00       	mov    $0xa,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <getpid>:
SYSCALL(getpid)
 942:	b8 0b 00 00 00       	mov    $0xb,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <sbrk>:
SYSCALL(sbrk)
 94a:	b8 0c 00 00 00       	mov    $0xc,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <sleep>:
SYSCALL(sleep)
 952:	b8 0d 00 00 00       	mov    $0xd,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <uptime>:
SYSCALL(uptime)
 95a:	b8 0e 00 00 00       	mov    $0xe,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <yield>:
SYSCALL(yield)
 962:	b8 16 00 00 00       	mov    $0x16,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <getlev>:
SYSCALL(getlev)
 96a:	b8 17 00 00 00       	mov    $0x17,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <setpriority>:
SYSCALL(setpriority)
 972:	b8 18 00 00 00       	mov    $0x18,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <getadmin>:
SYSCALL(getadmin)
 97a:	b8 19 00 00 00       	mov    $0x19,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    
 982:	66 90                	xchg   %ax,%ax
 984:	66 90                	xchg   %ax,%ax
 986:	66 90                	xchg   %ax,%ax
 988:	66 90                	xchg   %ax,%ax
 98a:	66 90                	xchg   %ax,%ax
 98c:	66 90                	xchg   %ax,%ax
 98e:	66 90                	xchg   %ax,%ax

00000990 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	57                   	push   %edi
 994:	56                   	push   %esi
 995:	53                   	push   %ebx
 996:	89 c6                	mov    %eax,%esi
 998:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 99b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 99e:	85 db                	test   %ebx,%ebx
 9a0:	74 7e                	je     a20 <printint+0x90>
 9a2:	89 d0                	mov    %edx,%eax
 9a4:	c1 e8 1f             	shr    $0x1f,%eax
 9a7:	84 c0                	test   %al,%al
 9a9:	74 75                	je     a20 <printint+0x90>
    neg = 1;
    x = -xx;
 9ab:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 9ad:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 9b4:	f7 d8                	neg    %eax
 9b6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 9b9:	31 ff                	xor    %edi,%edi
 9bb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 9be:	89 ce                	mov    %ecx,%esi
 9c0:	eb 08                	jmp    9ca <printint+0x3a>
 9c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 9c8:	89 cf                	mov    %ecx,%edi
 9ca:	31 d2                	xor    %edx,%edx
 9cc:	8d 4f 01             	lea    0x1(%edi),%ecx
 9cf:	f7 f6                	div    %esi
 9d1:	0f b6 92 18 10 00 00 	movzbl 0x1018(%edx),%edx
  }while((x /= base) != 0);
 9d8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 9da:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 9dd:	75 e9                	jne    9c8 <printint+0x38>
  if(neg)
 9df:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 9e2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 9e5:	85 c0                	test   %eax,%eax
 9e7:	74 08                	je     9f1 <printint+0x61>
    buf[i++] = '-';
 9e9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 9ee:	8d 4f 02             	lea    0x2(%edi),%ecx
 9f1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 9f5:	8d 76 00             	lea    0x0(%esi),%esi
 9f8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9fb:	83 ec 04             	sub    $0x4,%esp
 9fe:	83 ef 01             	sub    $0x1,%edi
 a01:	6a 01                	push   $0x1
 a03:	53                   	push   %ebx
 a04:	56                   	push   %esi
 a05:	88 45 d7             	mov    %al,-0x29(%ebp)
 a08:	e8 d5 fe ff ff       	call   8e2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a0d:	83 c4 10             	add    $0x10,%esp
 a10:	39 df                	cmp    %ebx,%edi
 a12:	75 e4                	jne    9f8 <printint+0x68>
    putc(fd, buf[i]);
}
 a14:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a17:	5b                   	pop    %ebx
 a18:	5e                   	pop    %esi
 a19:	5f                   	pop    %edi
 a1a:	5d                   	pop    %ebp
 a1b:	c3                   	ret    
 a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a20:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a22:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 a29:	eb 8b                	jmp    9b6 <printint+0x26>
 a2b:	90                   	nop
 a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a30 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	57                   	push   %edi
 a34:	56                   	push   %esi
 a35:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a36:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a39:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a42:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a45:	0f b6 1e             	movzbl (%esi),%ebx
 a48:	83 c6 01             	add    $0x1,%esi
 a4b:	84 db                	test   %bl,%bl
 a4d:	0f 84 b0 00 00 00    	je     b03 <printf+0xd3>
 a53:	31 d2                	xor    %edx,%edx
 a55:	eb 39                	jmp    a90 <printf+0x60>
 a57:	89 f6                	mov    %esi,%esi
 a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 a60:	83 f8 25             	cmp    $0x25,%eax
 a63:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 a66:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 a6b:	74 18                	je     a85 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a6d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 a70:	83 ec 04             	sub    $0x4,%esp
 a73:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 a76:	6a 01                	push   $0x1
 a78:	50                   	push   %eax
 a79:	57                   	push   %edi
 a7a:	e8 63 fe ff ff       	call   8e2 <write>
 a7f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 a82:	83 c4 10             	add    $0x10,%esp
 a85:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a88:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 a8c:	84 db                	test   %bl,%bl
 a8e:	74 73                	je     b03 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 a90:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 a92:	0f be cb             	movsbl %bl,%ecx
 a95:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 a98:	74 c6                	je     a60 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 a9a:	83 fa 25             	cmp    $0x25,%edx
 a9d:	75 e6                	jne    a85 <printf+0x55>
      if(c == 'd'){
 a9f:	83 f8 64             	cmp    $0x64,%eax
 aa2:	0f 84 f8 00 00 00    	je     ba0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 aa8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 aae:	83 f9 70             	cmp    $0x70,%ecx
 ab1:	74 5d                	je     b10 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 ab3:	83 f8 73             	cmp    $0x73,%eax
 ab6:	0f 84 84 00 00 00    	je     b40 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 abc:	83 f8 63             	cmp    $0x63,%eax
 abf:	0f 84 ea 00 00 00    	je     baf <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 ac5:	83 f8 25             	cmp    $0x25,%eax
 ac8:	0f 84 c2 00 00 00    	je     b90 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 ace:	8d 45 e7             	lea    -0x19(%ebp),%eax
 ad1:	83 ec 04             	sub    $0x4,%esp
 ad4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 ad8:	6a 01                	push   $0x1
 ada:	50                   	push   %eax
 adb:	57                   	push   %edi
 adc:	e8 01 fe ff ff       	call   8e2 <write>
 ae1:	83 c4 0c             	add    $0xc,%esp
 ae4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 ae7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 aea:	6a 01                	push   $0x1
 aec:	50                   	push   %eax
 aed:	57                   	push   %edi
 aee:	83 c6 01             	add    $0x1,%esi
 af1:	e8 ec fd ff ff       	call   8e2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 af6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 afa:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 afd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 aff:	84 db                	test   %bl,%bl
 b01:	75 8d                	jne    a90 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b06:	5b                   	pop    %ebx
 b07:	5e                   	pop    %esi
 b08:	5f                   	pop    %edi
 b09:	5d                   	pop    %ebp
 b0a:	c3                   	ret    
 b0b:	90                   	nop
 b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 b10:	83 ec 0c             	sub    $0xc,%esp
 b13:	b9 10 00 00 00       	mov    $0x10,%ecx
 b18:	6a 00                	push   $0x0
 b1a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 b1d:	89 f8                	mov    %edi,%eax
 b1f:	8b 13                	mov    (%ebx),%edx
 b21:	e8 6a fe ff ff       	call   990 <printint>
        ap++;
 b26:	89 d8                	mov    %ebx,%eax
 b28:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b2b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 b2d:	83 c0 04             	add    $0x4,%eax
 b30:	89 45 d0             	mov    %eax,-0x30(%ebp)
 b33:	e9 4d ff ff ff       	jmp    a85 <printf+0x55>
 b38:	90                   	nop
 b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 b40:	8b 45 d0             	mov    -0x30(%ebp),%eax
 b43:	8b 18                	mov    (%eax),%ebx
        ap++;
 b45:	83 c0 04             	add    $0x4,%eax
 b48:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 b4b:	b8 10 10 00 00       	mov    $0x1010,%eax
 b50:	85 db                	test   %ebx,%ebx
 b52:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 b55:	0f b6 03             	movzbl (%ebx),%eax
 b58:	84 c0                	test   %al,%al
 b5a:	74 23                	je     b7f <printf+0x14f>
 b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b60:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b63:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 b66:	83 ec 04             	sub    $0x4,%esp
 b69:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 b6b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b6e:	50                   	push   %eax
 b6f:	57                   	push   %edi
 b70:	e8 6d fd ff ff       	call   8e2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b75:	0f b6 03             	movzbl (%ebx),%eax
 b78:	83 c4 10             	add    $0x10,%esp
 b7b:	84 c0                	test   %al,%al
 b7d:	75 e1                	jne    b60 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b7f:	31 d2                	xor    %edx,%edx
 b81:	e9 ff fe ff ff       	jmp    a85 <printf+0x55>
 b86:	8d 76 00             	lea    0x0(%esi),%esi
 b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b90:	83 ec 04             	sub    $0x4,%esp
 b93:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 b96:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 b99:	6a 01                	push   $0x1
 b9b:	e9 4c ff ff ff       	jmp    aec <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 ba0:	83 ec 0c             	sub    $0xc,%esp
 ba3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 ba8:	6a 01                	push   $0x1
 baa:	e9 6b ff ff ff       	jmp    b1a <printf+0xea>
 baf:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bb2:	83 ec 04             	sub    $0x4,%esp
 bb5:	8b 03                	mov    (%ebx),%eax
 bb7:	6a 01                	push   $0x1
 bb9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 bbc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 bbf:	50                   	push   %eax
 bc0:	57                   	push   %edi
 bc1:	e8 1c fd ff ff       	call   8e2 <write>
 bc6:	e9 5b ff ff ff       	jmp    b26 <printf+0xf6>
 bcb:	66 90                	xchg   %ax,%ax
 bcd:	66 90                	xchg   %ax,%ax
 bcf:	90                   	nop

00000bd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bd0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd1:	a1 64 13 00 00       	mov    0x1364,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 bd6:	89 e5                	mov    %esp,%ebp
 bd8:	57                   	push   %edi
 bd9:	56                   	push   %esi
 bda:	53                   	push   %ebx
 bdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bde:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 be0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 be3:	39 c8                	cmp    %ecx,%eax
 be5:	73 19                	jae    c00 <free+0x30>
 be7:	89 f6                	mov    %esi,%esi
 be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 bf0:	39 d1                	cmp    %edx,%ecx
 bf2:	72 1c                	jb     c10 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bf4:	39 d0                	cmp    %edx,%eax
 bf6:	73 18                	jae    c10 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 bf8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfa:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bfc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfe:	72 f0                	jb     bf0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c00:	39 d0                	cmp    %edx,%eax
 c02:	72 f4                	jb     bf8 <free+0x28>
 c04:	39 d1                	cmp    %edx,%ecx
 c06:	73 f0                	jae    bf8 <free+0x28>
 c08:	90                   	nop
 c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 c10:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c13:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c16:	39 d7                	cmp    %edx,%edi
 c18:	74 19                	je     c33 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 c1a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 c1d:	8b 50 04             	mov    0x4(%eax),%edx
 c20:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 c23:	39 f1                	cmp    %esi,%ecx
 c25:	74 23                	je     c4a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 c27:	89 08                	mov    %ecx,(%eax)
  freep = p;
 c29:	a3 64 13 00 00       	mov    %eax,0x1364
}
 c2e:	5b                   	pop    %ebx
 c2f:	5e                   	pop    %esi
 c30:	5f                   	pop    %edi
 c31:	5d                   	pop    %ebp
 c32:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c33:	03 72 04             	add    0x4(%edx),%esi
 c36:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 c39:	8b 10                	mov    (%eax),%edx
 c3b:	8b 12                	mov    (%edx),%edx
 c3d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 c40:	8b 50 04             	mov    0x4(%eax),%edx
 c43:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 c46:	39 f1                	cmp    %esi,%ecx
 c48:	75 dd                	jne    c27 <free+0x57>
    p->s.size += bp->s.size;
 c4a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 c4d:	a3 64 13 00 00       	mov    %eax,0x1364
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 c52:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c55:	8b 53 f8             	mov    -0x8(%ebx),%edx
 c58:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 c5a:	5b                   	pop    %ebx
 c5b:	5e                   	pop    %esi
 c5c:	5f                   	pop    %edi
 c5d:	5d                   	pop    %ebp
 c5e:	c3                   	ret    
 c5f:	90                   	nop

00000c60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c60:	55                   	push   %ebp
 c61:	89 e5                	mov    %esp,%ebp
 c63:	57                   	push   %edi
 c64:	56                   	push   %esi
 c65:	53                   	push   %ebx
 c66:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c69:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 c6c:	8b 15 64 13 00 00    	mov    0x1364,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c72:	8d 78 07             	lea    0x7(%eax),%edi
 c75:	c1 ef 03             	shr    $0x3,%edi
 c78:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 c7b:	85 d2                	test   %edx,%edx
 c7d:	0f 84 a3 00 00 00    	je     d26 <malloc+0xc6>
 c83:	8b 02                	mov    (%edx),%eax
 c85:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 c88:	39 cf                	cmp    %ecx,%edi
 c8a:	76 74                	jbe    d00 <malloc+0xa0>
 c8c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 c92:	be 00 10 00 00       	mov    $0x1000,%esi
 c97:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 c9e:	0f 43 f7             	cmovae %edi,%esi
 ca1:	ba 00 80 00 00       	mov    $0x8000,%edx
 ca6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 cac:	0f 46 da             	cmovbe %edx,%ebx
 caf:	eb 10                	jmp    cc1 <malloc+0x61>
 cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cb8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 cba:	8b 48 04             	mov    0x4(%eax),%ecx
 cbd:	39 cf                	cmp    %ecx,%edi
 cbf:	76 3f                	jbe    d00 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 cc1:	39 05 64 13 00 00    	cmp    %eax,0x1364
 cc7:	89 c2                	mov    %eax,%edx
 cc9:	75 ed                	jne    cb8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 ccb:	83 ec 0c             	sub    $0xc,%esp
 cce:	53                   	push   %ebx
 ccf:	e8 76 fc ff ff       	call   94a <sbrk>
  if(p == (char*)-1)
 cd4:	83 c4 10             	add    $0x10,%esp
 cd7:	83 f8 ff             	cmp    $0xffffffff,%eax
 cda:	74 1c                	je     cf8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 cdc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 cdf:	83 ec 0c             	sub    $0xc,%esp
 ce2:	83 c0 08             	add    $0x8,%eax
 ce5:	50                   	push   %eax
 ce6:	e8 e5 fe ff ff       	call   bd0 <free>
  return freep;
 ceb:	8b 15 64 13 00 00    	mov    0x1364,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 cf1:	83 c4 10             	add    $0x10,%esp
 cf4:	85 d2                	test   %edx,%edx
 cf6:	75 c0                	jne    cb8 <malloc+0x58>
        return 0;
 cf8:	31 c0                	xor    %eax,%eax
 cfa:	eb 1c                	jmp    d18 <malloc+0xb8>
 cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 d00:	39 cf                	cmp    %ecx,%edi
 d02:	74 1c                	je     d20 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 d04:	29 f9                	sub    %edi,%ecx
 d06:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 d09:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 d0c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 d0f:	89 15 64 13 00 00    	mov    %edx,0x1364
      return (void*)(p + 1);
 d15:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
 d1b:	5b                   	pop    %ebx
 d1c:	5e                   	pop    %esi
 d1d:	5f                   	pop    %edi
 d1e:	5d                   	pop    %ebp
 d1f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 d20:	8b 08                	mov    (%eax),%ecx
 d22:	89 0a                	mov    %ecx,(%edx)
 d24:	eb e9                	jmp    d0f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 d26:	c7 05 64 13 00 00 68 	movl   $0x1368,0x1364
 d2d:	13 00 00 
 d30:	c7 05 68 13 00 00 68 	movl   $0x1368,0x1368
 d37:	13 00 00 
    base.s.size = 0;
 d3a:	b8 68 13 00 00       	mov    $0x1368,%eax
 d3f:	c7 05 6c 13 00 00 00 	movl   $0x0,0x136c
 d46:	00 00 00 
 d49:	e9 3e ff ff ff       	jmp    c8c <malloc+0x2c>
