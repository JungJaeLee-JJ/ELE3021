
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
  36:	e8 57 09 00 00       	call   992 <getpid>

  printf(1, "MLFQ test start\n");
  3b:	83 ec 08             	sub    $0x8,%esp
{
  int i, pid;
  int count[MAX_LEVEL] = {0};
  int child;

  parent = getpid();
  3e:	a3 dc 13 00 00       	mov    %eax,0x13dc

  printf(1, "MLFQ test start\n");
  43:	68 c9 0d 00 00       	push   $0xdc9
  48:	6a 01                	push   $0x1
  4a:	e8 41 0a 00 00       	call   a90 <printf>

  printf(1, "[Test 1] default\n");
  4f:	59                   	pop    %ecx
  50:	5b                   	pop    %ebx
  51:	68 da 0d 00 00       	push   $0xdda
  56:	6a 01                	push   $0x1
  58:	bb a0 86 01 00       	mov    $0x186a0,%ebx
  5d:	e8 2e 0a 00 00       	call   a90 <printf>
  pid = fork_children();
  62:	e8 e9 04 00 00       	call   550 <fork_children>

  if (pid != parent)
  67:	83 c4 10             	add    $0x10,%esp
  6a:	3b 05 dc 13 00 00    	cmp    0x13dc,%eax
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
  8a:	e8 2b 09 00 00       	call   9ba <getlev>
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
  98:	68 14 0e 00 00       	push   $0xe14
  9d:	6a 01                	push   $0x1
  9f:	e8 ec 09 00 00       	call   a90 <printf>
        exit();
  a4:	e8 69 08 00 00       	call   912 <exit>
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
  a9:	50                   	push   %eax
  aa:	56                   	push   %esi
  ab:	8d 75 d4             	lea    -0x2c(%ebp),%esi
  ae:	68 25 0e 00 00       	push   $0xe25
  b3:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
  b5:	31 db                	xor    %ebx,%ebx
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
  b7:	e8 d4 09 00 00       	call   a90 <printf>
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
  c6:	68 31 0e 00 00       	push   $0xe31
  cb:	6a 01                	push   $0x1
  cd:	e8 be 09 00 00       	call   a90 <printf>
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
  e6:	68 ec 0d 00 00       	push   $0xdec
  eb:	6a 01                	push   $0x1
  ed:	e8 9e 09 00 00       	call   a90 <printf>

  printf(1, "[Test 2] priorities\n");
  f2:	58                   	pop    %eax
  f3:	5a                   	pop    %edx
  f4:	68 ff 0d 00 00       	push   $0xdff
  f9:	6a 01                	push   $0x1
  fb:	e8 90 09 00 00       	call   a90 <printf>
  pid = fork_children2();
 100:	e8 8b 04 00 00       	call   590 <fork_children2>

  if (pid != parent)
 105:	83 c4 10             	add    $0x10,%esp
 108:	3b 05 dc 13 00 00    	cmp    0x13dc,%eax
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
 122:	e8 93 08 00 00       	call   9ba <getlev>
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
 136:	68 25 0e 00 00       	push   $0xe25
 13b:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 13d:	31 db                	xor    %ebx,%ebx
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
    }
    printf(1, "Process %d\n", pid);
 13f:	e8 4c 09 00 00       	call   a90 <printf>
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
 14e:	68 31 0e 00 00       	push   $0xe31
 153:	6a 01                	push   $0x1
 155:	e8 36 09 00 00       	call   a90 <printf>
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
 16e:	68 3a 0e 00 00       	push   $0xe3a
 173:	6a 01                	push   $0x1
 175:	e8 16 09 00 00       	call   a90 <printf>
  
  printf(1, "[Test 3] yield\n");
 17a:	5e                   	pop    %esi
 17b:	58                   	pop    %eax
 17c:	68 4d 0e 00 00       	push   $0xe4d
 181:	6a 01                	push   $0x1
 183:	e8 08 09 00 00       	call   a90 <printf>
  pid = fork_children2();
 188:	e8 03 04 00 00       	call   590 <fork_children2>

  if (pid != parent)
 18d:	83 c4 10             	add    $0x10,%esp
 190:	3b 05 dc 13 00 00    	cmp    0x13dc,%eax
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
 1a5:	e8 08 08 00 00       	call   9b2 <yield>
  printf(1, "[Test 3] yield\n");
  pid = fork_children2();

  if (pid != parent)
  {
    for (i = 0; i < NUM_YIELD; i++)
 1aa:	83 eb 01             	sub    $0x1,%ebx
 1ad:	74 0f                	je     1be <main+0x1be>
    {
      int x = getlev();
 1af:	e8 06 08 00 00       	call   9ba <getlev>
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
 1c3:	68 25 0e 00 00       	push   $0xe25
 1c8:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 1ca:	31 db                	xor    %ebx,%ebx
        exit();
      }
      count[x]++;
      yield();
    }
    printf(1, "Process %d\n", pid);
 1cc:	e8 bf 08 00 00       	call   a90 <printf>
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
 1db:	68 31 0e 00 00       	push   $0xe31
 1e0:	6a 01                	push   $0x1
 1e2:	e8 a9 08 00 00       	call   a90 <printf>
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
 1fb:	68 5d 0e 00 00       	push   $0xe5d
 200:	6a 01                	push   $0x1
 202:	e8 89 08 00 00       	call   a90 <printf>

  printf(1, "[Test 4] sleep\n");
 207:	58                   	pop    %eax
 208:	5a                   	pop    %edx
 209:	68 70 0e 00 00       	push   $0xe70
 20e:	6a 01                	push   $0x1
 210:	e8 7b 08 00 00       	call   a90 <printf>
  pid = fork_children2();
 215:	e8 76 03 00 00       	call   590 <fork_children2>

  if (pid != parent)
 21a:	83 c4 10             	add    $0x10,%esp
 21d:	3b 05 dc 13 00 00    	cmp    0x13dc,%eax
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
 233:	e8 6a 07 00 00       	call   9a2 <sleep>
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
 240:	e8 75 07 00 00       	call   9ba <getlev>
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
 254:	68 25 0e 00 00       	push   $0xe25
 259:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 25b:	31 db                	xor    %ebx,%ebx
        exit();
      }
      count[x]++;
      sleep(1);
    }
    printf(1, "Process %d\n", pid);
 25d:	e8 2e 08 00 00       	call   a90 <printf>
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
 26c:	68 31 0e 00 00       	push   $0xe31
 271:	6a 01                	push   $0x1
 273:	e8 18 08 00 00       	call   a90 <printf>
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
 28c:	68 80 0e 00 00       	push   $0xe80
 291:	6a 01                	push   $0x1
 293:	e8 f8 07 00 00       	call   a90 <printf>
  
  printf(1, "[Test 5] max level\n");
 298:	5e                   	pop    %esi
 299:	58                   	pop    %eax
 29a:	68 93 0e 00 00       	push   $0xe93
 29f:	6a 01                	push   $0x1
 2a1:	e8 ea 07 00 00       	call   a90 <printf>
  pid = fork_children3();
 2a6:	e8 55 03 00 00       	call   600 <fork_children3>

  if (pid != parent)
 2ab:	83 c4 10             	add    $0x10,%esp
 2ae:	3b 05 dc 13 00 00    	cmp    0x13dc,%eax
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
 2bf:	e8 f6 06 00 00       	call   9ba <getlev>
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
 2d2:	3b 05 e0 13 00 00    	cmp    0x13e0,%eax
 2d8:	7e e0                	jle    2ba <main+0x2ba>
        yield();
 2da:	e8 d3 06 00 00       	call   9b2 <yield>
 2df:	eb d9                	jmp    2ba <main+0x2ba>
    }
    printf(1, "Process %d\n", pid);
 2e1:	53                   	push   %ebx
 2e2:	56                   	push   %esi
 2e3:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 2e6:	68 25 0e 00 00       	push   $0xe25
 2eb:	6a 01                	push   $0x1
    for (i = 0; i < MAX_LEVEL; i++)
 2ed:	31 db                	xor    %ebx,%ebx
      }
      count[x]++;
      if (x > max_level)
        yield();
    }
    printf(1, "Process %d\n", pid);
 2ef:	e8 9c 07 00 00       	call   a90 <printf>
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
 2fe:	68 31 0e 00 00       	push   $0xe31
 303:	6a 01                	push   $0x1
 305:	e8 86 07 00 00       	call   a90 <printf>
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
 319:	68 a7 0e 00 00       	push   $0xea7
 31e:	6a 01                	push   $0x1
 320:	e8 6b 07 00 00       	call   a90 <printf>
  
  printf(1, "[Test 6] setpriority return value\n");
 325:	58                   	pop    %eax
 326:	5a                   	pop    %edx
 327:	68 d4 0e 00 00       	push   $0xed4
 32c:	6a 01                	push   $0x1
 32e:	e8 5d 07 00 00       	call   a90 <printf>
  child = fork();
 333:	e8 d2 05 00 00       	call   90a <fork>

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
 34a:	e8 53 06 00 00       	call   9a2 <sleep>
    grandson = fork();
 34f:	e8 b6 05 00 00       	call   90a <fork>
    if (grandson == 0)
 354:	83 c4 10             	add    $0x10,%esp
 357:	85 c0                	test   %eax,%eax
 359:	0f 85 b5 00 00 00    	jne    414 <main+0x414>
    {
      r = setpriority(getpid() - 2, 0);
 35f:	e8 2e 06 00 00       	call   992 <getpid>
 364:	83 e8 02             	sub    $0x2,%eax
 367:	51                   	push   %ecx
 368:	51                   	push   %ecx
 369:	6a 00                	push   $0x0
 36b:	50                   	push   %eax
 36c:	e8 51 06 00 00       	call   9c2 <setpriority>
      if (r != -1)
 371:	83 c4 10             	add    $0x10,%esp
 374:	83 f8 ff             	cmp    $0xffffffff,%eax
 377:	74 11                	je     38a <main+0x38a>
        printf(1, "wrong: setpriority of parent: expected -1, got %d\n", r);
 379:	52                   	push   %edx
 37a:	50                   	push   %eax
 37b:	68 f8 0e 00 00       	push   $0xef8
 380:	6a 01                	push   $0x1
 382:	e8 09 07 00 00       	call   a90 <printf>
 387:	83 c4 10             	add    $0x10,%esp
      r = setpriority(getpid() - 3, 0);
 38a:	e8 03 06 00 00       	call   992 <getpid>
 38f:	83 e8 03             	sub    $0x3,%eax
 392:	56                   	push   %esi
 393:	56                   	push   %esi
 394:	6a 00                	push   $0x0
 396:	50                   	push   %eax
 397:	e8 26 06 00 00       	call   9c2 <setpriority>
      if (r != -1)
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	83 f8 ff             	cmp    $0xffffffff,%eax
 3a2:	74 11                	je     3b5 <main+0x3b5>
        printf(1, "wrong: setpriority of ancestor: expected -1, got %d\n", r);
 3a4:	53                   	push   %ebx
 3a5:	50                   	push   %eax
 3a6:	68 2c 0f 00 00       	push   $0xf2c
 3ab:	6a 01                	push   $0x1
 3ad:	e8 de 06 00 00       	call   a90 <printf>
 3b2:	83 c4 10             	add    $0x10,%esp
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
      r = setpriority(getpid() + 1, 0);
      if (r != -1)
        printf(1, "wrong: setpriority of other: expected -1, got %d\n", r);
    }
    sleep(20);
 3b5:	83 ec 0c             	sub    $0xc,%esp
 3b8:	6a 14                	push   $0x14
 3ba:	e8 e3 05 00 00       	call   9a2 <sleep>
    wait();
 3bf:	e8 56 05 00 00       	call   91a <wait>
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
 3ce:	68 ba 0e 00 00       	push   $0xeba
 3d3:	6a 01                	push   $0x1
 3d5:	e8 b6 06 00 00       	call   a90 <printf>
  printf(1, "[Test 6] finished\n");
 3da:	5a                   	pop    %edx
 3db:	59                   	pop    %ecx
 3dc:	68 c0 0e 00 00       	push   $0xec0
 3e1:	6a 01                	push   $0x1
 3e3:	e8 a8 06 00 00       	call   a90 <printf>

  exit();
 3e8:	e8 25 05 00 00       	call   912 <exit>
    wait();
  }
  else
  {
    int r;
    int child2 = fork();
 3ed:	e8 18 05 00 00       	call   90a <fork>
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
 3f9:	e8 a4 05 00 00       	call   9a2 <sleep>
    if (child2 == 0)
 3fe:	83 c4 10             	add    $0x10,%esp
 401:	85 f6                	test   %esi,%esi
 403:	75 65                	jne    46a <main+0x46a>
      sleep(10);
 405:	83 ec 0c             	sub    $0xc,%esp
 408:	6a 0a                	push   $0xa
 40a:	e8 93 05 00 00       	call   9a2 <sleep>
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
 419:	e8 a4 05 00 00       	call   9c2 <setpriority>
      if (r != 0)
 41e:	83 c4 10             	add    $0x10,%esp
 421:	85 c0                	test   %eax,%eax
 423:	74 11                	je     436 <main+0x436>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 425:	52                   	push   %edx
 426:	50                   	push   %eax
 427:	68 64 0f 00 00       	push   $0xf64
 42c:	6a 01                	push   $0x1
 42e:	e8 5d 06 00 00       	call   a90 <printf>
 433:	83 c4 10             	add    $0x10,%esp
      r = setpriority(getpid() + 1, 0);
 436:	e8 57 05 00 00       	call   992 <getpid>
 43b:	83 c0 01             	add    $0x1,%eax
 43e:	56                   	push   %esi
 43f:	56                   	push   %esi
 440:	6a 00                	push   $0x0
 442:	50                   	push   %eax
 443:	e8 7a 05 00 00       	call   9c2 <setpriority>
      if (r != -1)
 448:	83 c4 10             	add    $0x10,%esp
 44b:	83 f8 ff             	cmp    $0xffffffff,%eax
 44e:	0f 84 61 ff ff ff    	je     3b5 <main+0x3b5>
        printf(1, "wrong: setpriority of other: expected -1, got %d\n", r);
 454:	53                   	push   %ebx
 455:	50                   	push   %eax
 456:	68 98 0f 00 00       	push   $0xf98
 45b:	6a 01                	push   $0x1
 45d:	e8 2e 06 00 00       	call   a90 <printf>
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
 46f:	e8 4e 05 00 00       	call   9c2 <setpriority>
      if (r != -2)
 474:	83 c4 10             	add    $0x10,%esp
 477:	83 f8 fe             	cmp    $0xfffffffe,%eax
 47a:	74 11                	je     48d <main+0x48d>
        printf(1, "wrong: setpriority out of range: expected -2, got %d\n", r);
 47c:	52                   	push   %edx
 47d:	50                   	push   %eax
 47e:	68 cc 0f 00 00       	push   $0xfcc
 483:	6a 01                	push   $0x1
 485:	e8 06 06 00 00       	call   a90 <printf>
 48a:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child, 11);
 48d:	50                   	push   %eax
 48e:	50                   	push   %eax
 48f:	6a 0b                	push   $0xb
 491:	53                   	push   %ebx
 492:	e8 2b 05 00 00       	call   9c2 <setpriority>
      if (r != -2)
 497:	83 c4 10             	add    $0x10,%esp
 49a:	83 f8 fe             	cmp    $0xfffffffe,%eax
 49d:	74 11                	je     4b0 <main+0x4b0>
        printf(1, "wrong: setpriority out of range: expected -2, got %d\n", r);
 49f:	56                   	push   %esi
 4a0:	50                   	push   %eax
 4a1:	68 cc 0f 00 00       	push   $0xfcc
 4a6:	6a 01                	push   $0x1
 4a8:	e8 e3 05 00 00       	call   a90 <printf>
 4ad:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child, 10);
 4b0:	51                   	push   %ecx
 4b1:	51                   	push   %ecx
 4b2:	6a 0a                	push   $0xa
 4b4:	53                   	push   %ebx
 4b5:	e8 08 05 00 00       	call   9c2 <setpriority>
      if (r != 0)
 4ba:	83 c4 10             	add    $0x10,%esp
 4bd:	85 c0                	test   %eax,%eax
 4bf:	74 11                	je     4d2 <main+0x4d2>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 4c1:	52                   	push   %edx
 4c2:	50                   	push   %eax
 4c3:	68 64 0f 00 00       	push   $0xf64
 4c8:	6a 01                	push   $0x1
 4ca:	e8 c1 05 00 00       	call   a90 <printf>
 4cf:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child + 1, 10);
 4d2:	50                   	push   %eax
 4d3:	50                   	push   %eax
 4d4:	8d 43 01             	lea    0x1(%ebx),%eax
 4d7:	6a 0a                	push   $0xa
 4d9:	50                   	push   %eax
 4da:	e8 e3 04 00 00       	call   9c2 <setpriority>
      if (r != 0)
 4df:	83 c4 10             	add    $0x10,%esp
 4e2:	85 c0                	test   %eax,%eax
 4e4:	74 11                	je     4f7 <main+0x4f7>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 4e6:	56                   	push   %esi
 4e7:	50                   	push   %eax
 4e8:	68 64 0f 00 00       	push   $0xf64
 4ed:	6a 01                	push   $0x1
 4ef:	e8 9c 05 00 00       	call   a90 <printf>
 4f4:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child + 2, 10);
 4f7:	83 c3 02             	add    $0x2,%ebx
 4fa:	51                   	push   %ecx
 4fb:	51                   	push   %ecx
 4fc:	6a 0a                	push   $0xa
 4fe:	53                   	push   %ebx
 4ff:	e8 be 04 00 00       	call   9c2 <setpriority>
      if (r != -1)
 504:	83 c4 10             	add    $0x10,%esp
 507:	83 f8 ff             	cmp    $0xffffffff,%eax
 50a:	74 11                	je     51d <main+0x51d>
        printf(1, "wrong: setpriority of grandson: expected -1, got %d\n", r);
 50c:	52                   	push   %edx
 50d:	50                   	push   %eax
 50e:	68 04 10 00 00       	push   $0x1004
 513:	6a 01                	push   $0x1
 515:	e8 76 05 00 00       	call   a90 <printf>
 51a:	83 c4 10             	add    $0x10,%esp
      r = setpriority(parent, 5);
 51d:	56                   	push   %esi
 51e:	56                   	push   %esi
 51f:	6a 05                	push   $0x5
 521:	ff 35 dc 13 00 00    	pushl  0x13dc
 527:	e8 96 04 00 00       	call   9c2 <setpriority>
      if (r != -1)
 52c:	83 c4 10             	add    $0x10,%esp
 52f:	83 f8 ff             	cmp    $0xffffffff,%eax
 532:	0f 84 8f fe ff ff    	je     3c7 <main+0x3c7>
        printf(1, "wrong: setpriority of self: expected -1, got %d\n", r);
 538:	53                   	push   %ebx
 539:	50                   	push   %eax
 53a:	68 3c 10 00 00       	push   $0x103c
 53f:	6a 01                	push   $0x1
 541:	e8 4a 05 00 00       	call   a90 <printf>
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
 55c:	e8 a9 03 00 00       	call   90a <fork>
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
 56a:	a1 dc 13 00 00       	mov    0x13dc,%eax
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
 57d:	e8 20 04 00 00       	call   9a2 <sleep>
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
 589:	e9 04 04 00 00       	jmp    992 <getpid>
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
 599:	e8 6c 03 00 00       	call   90a <fork>
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
 5a7:	e8 16 04 00 00       	call   9c2 <setpriority>
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
 5bb:	a1 dc 13 00 00       	mov    0x13dc,%eax
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
 5cd:	e8 d0 03 00 00       	call   9a2 <sleep>
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
 5d9:	e9 b4 03 00 00       	jmp    992 <getpid>
    else
    {
      int r = setpriority(p, i);
      if (r < 0)
      {
        printf(1, "setpriority returned %d\n", r);
 5de:	83 ec 04             	sub    $0x4,%esp
 5e1:	50                   	push   %eax
 5e2:	68 b0 0d 00 00       	push   $0xdb0
 5e7:	6a 01                	push   $0x1
 5e9:	e8 a2 04 00 00       	call   a90 <printf>
        exit();
 5ee:	e8 1f 03 00 00       	call   912 <exit>
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
 609:	e8 fc 02 00 00       	call   90a <fork>
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
 61a:	a1 dc 13 00 00       	mov    0x13dc,%eax
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
 62d:	e8 70 03 00 00       	call   9a2 <sleep>
      max_level = i;
 632:	89 1d e0 13 00 00    	mov    %ebx,0x13e0
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
 63f:	e9 4e 03 00 00       	jmp    992 <getpid>
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
 656:	e8 37 03 00 00       	call   992 <getpid>
 65b:	3b 05 dc 13 00 00    	cmp    0x13dc,%eax
 661:	75 11                	jne    674 <exit_children+0x24>
 663:	90                   	nop
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
  while (wait() != -1);
 668:	e8 ad 02 00 00       	call   91a <wait>
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
 674:	e8 99 02 00 00       	call   912 <exit>
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
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 0c             	sub    $0xc,%esp
 6b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q){
 6bf:	0f be 03             	movsbl (%ebx),%eax
 6c2:	0f be 16             	movsbl (%esi),%edx
 6c5:	84 c0                	test   %al,%al
 6c7:	74 76                	je     73f <strcmp+0x8f>
 6c9:	38 c2                	cmp    %al,%dl
 6cb:	89 f7                	mov    %esi,%edi
 6cd:	74 0f                	je     6de <strcmp+0x2e>
 6cf:	eb 38                	jmp    709 <strcmp+0x59>
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6d8:	38 d0                	cmp    %dl,%al
 6da:	89 fe                	mov    %edi,%esi
 6dc:	75 2b                	jne    709 <strcmp+0x59>
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
 6de:	0f be 46 01          	movsbl 0x1(%esi),%eax

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
    p++, q++;
 6e2:	83 c3 01             	add    $0x1,%ebx
 6e5:	8d 7e 01             	lea    0x1(%esi),%edi
	printf(2,"%c %c\n",*p,*q );
 6e8:	50                   	push   %eax
 6e9:	0f be 03             	movsbl (%ebx),%eax
 6ec:	50                   	push   %eax
 6ed:	68 70 10 00 00       	push   $0x1070
 6f2:	6a 02                	push   $0x2
 6f4:	e8 97 03 00 00       	call   a90 <printf>
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 6f9:	0f be 03             	movsbl (%ebx),%eax
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	0f be 56 01          	movsbl 0x1(%esi),%edx
 703:	84 c0                	test   %al,%al
 705:	75 d1                	jne    6d8 <strcmp+0x28>
 707:	31 c0                	xor    %eax,%eax
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
 709:	52                   	push   %edx
 70a:	50                   	push   %eax
 70b:	68 77 10 00 00       	push   $0x1077
 710:	6a 02                	push   $0x2
 712:	e8 79 03 00 00       	call   a90 <printf>
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
 717:	0f b6 17             	movzbl (%edi),%edx
 71a:	0f b6 03             	movzbl (%ebx),%eax
 71d:	83 c4 0c             	add    $0xc,%esp
 720:	29 d0                	sub    %edx,%eax
 722:	50                   	push   %eax
 723:	68 36 0e 00 00       	push   $0xe36
 728:	6a 02                	push   $0x2
 72a:	e8 61 03 00 00       	call   a90 <printf>
  return (uchar)*p - (uchar)*q;
 72f:	0f b6 03             	movzbl (%ebx),%eax
 732:	0f b6 17             	movzbl (%edi),%edx
}
 735:	8d 65 f4             	lea    -0xc(%ebp),%esp
 738:	5b                   	pop    %ebx
 739:	5e                   	pop    %esi
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 73a:	29 d0                	sub    %edx,%eax
}
 73c:	5f                   	pop    %edi
 73d:	5d                   	pop    %ebp
 73e:	c3                   	ret    
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 73f:	89 f7                	mov    %esi,%edi
 741:	31 c0                	xor    %eax,%eax
 743:	eb c4                	jmp    709 <strcmp+0x59>
 745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000750 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 756:	80 39 00             	cmpb   $0x0,(%ecx)
 759:	74 12                	je     76d <strlen+0x1d>
 75b:	31 d2                	xor    %edx,%edx
 75d:	8d 76 00             	lea    0x0(%esi),%esi
 760:	83 c2 01             	add    $0x1,%edx
 763:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 767:	89 d0                	mov    %edx,%eax
 769:	75 f5                	jne    760 <strlen+0x10>
    ;
  return n;
}
 76b:	5d                   	pop    %ebp
 76c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 76d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 76f:	5d                   	pop    %ebp
 770:	c3                   	ret    
 771:	eb 0d                	jmp    780 <memset>
 773:	90                   	nop
 774:	90                   	nop
 775:	90                   	nop
 776:	90                   	nop
 777:	90                   	nop
 778:	90                   	nop
 779:	90                   	nop
 77a:	90                   	nop
 77b:	90                   	nop
 77c:	90                   	nop
 77d:	90                   	nop
 77e:	90                   	nop
 77f:	90                   	nop

00000780 <memset>:

void*
memset(void *dst, int c, uint n)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 787:	8b 4d 10             	mov    0x10(%ebp),%ecx
 78a:	8b 45 0c             	mov    0xc(%ebp),%eax
 78d:	89 d7                	mov    %edx,%edi
 78f:	fc                   	cld    
 790:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 792:	89 d0                	mov    %edx,%eax
 794:	5f                   	pop    %edi
 795:	5d                   	pop    %ebp
 796:	c3                   	ret    
 797:	89 f6                	mov    %esi,%esi
 799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007a0 <strchr>:

char*
strchr(const char *s, char c)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	53                   	push   %ebx
 7a4:	8b 45 08             	mov    0x8(%ebp),%eax
 7a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 7aa:	0f b6 10             	movzbl (%eax),%edx
 7ad:	84 d2                	test   %dl,%dl
 7af:	74 1d                	je     7ce <strchr+0x2e>
    if(*s == c)
 7b1:	38 d3                	cmp    %dl,%bl
 7b3:	89 d9                	mov    %ebx,%ecx
 7b5:	75 0d                	jne    7c4 <strchr+0x24>
 7b7:	eb 17                	jmp    7d0 <strchr+0x30>
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7c0:	38 ca                	cmp    %cl,%dl
 7c2:	74 0c                	je     7d0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 7c4:	83 c0 01             	add    $0x1,%eax
 7c7:	0f b6 10             	movzbl (%eax),%edx
 7ca:	84 d2                	test   %dl,%dl
 7cc:	75 f2                	jne    7c0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 7ce:	31 c0                	xor    %eax,%eax
}
 7d0:	5b                   	pop    %ebx
 7d1:	5d                   	pop    %ebp
 7d2:	c3                   	ret    
 7d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007e0 <gets>:

char*
gets(char *buf, int max)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7e6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 7e8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 7eb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7ee:	eb 29                	jmp    819 <gets+0x39>
    cc = read(0, &c, 1);
 7f0:	83 ec 04             	sub    $0x4,%esp
 7f3:	6a 01                	push   $0x1
 7f5:	57                   	push   %edi
 7f6:	6a 00                	push   $0x0
 7f8:	e8 2d 01 00 00       	call   92a <read>
    if(cc < 1)
 7fd:	83 c4 10             	add    $0x10,%esp
 800:	85 c0                	test   %eax,%eax
 802:	7e 1d                	jle    821 <gets+0x41>
      break;
    buf[i++] = c;
 804:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 808:	8b 55 08             	mov    0x8(%ebp),%edx
 80b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 80d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 80f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 813:	74 1b                	je     830 <gets+0x50>
 815:	3c 0d                	cmp    $0xd,%al
 817:	74 17                	je     830 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 819:	8d 5e 01             	lea    0x1(%esi),%ebx
 81c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 81f:	7c cf                	jl     7f0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 821:	8b 45 08             	mov    0x8(%ebp),%eax
 824:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 828:	8d 65 f4             	lea    -0xc(%ebp),%esp
 82b:	5b                   	pop    %ebx
 82c:	5e                   	pop    %esi
 82d:	5f                   	pop    %edi
 82e:	5d                   	pop    %ebp
 82f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 830:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 833:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 835:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 839:	8d 65 f4             	lea    -0xc(%ebp),%esp
 83c:	5b                   	pop    %ebx
 83d:	5e                   	pop    %esi
 83e:	5f                   	pop    %edi
 83f:	5d                   	pop    %ebp
 840:	c3                   	ret    
 841:	eb 0d                	jmp    850 <stat>
 843:	90                   	nop
 844:	90                   	nop
 845:	90                   	nop
 846:	90                   	nop
 847:	90                   	nop
 848:	90                   	nop
 849:	90                   	nop
 84a:	90                   	nop
 84b:	90                   	nop
 84c:	90                   	nop
 84d:	90                   	nop
 84e:	90                   	nop
 84f:	90                   	nop

00000850 <stat>:

int
stat(const char *n, struct stat *st)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	56                   	push   %esi
 854:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 855:	83 ec 08             	sub    $0x8,%esp
 858:	6a 00                	push   $0x0
 85a:	ff 75 08             	pushl  0x8(%ebp)
 85d:	e8 f0 00 00 00       	call   952 <open>
  if(fd < 0)
 862:	83 c4 10             	add    $0x10,%esp
 865:	85 c0                	test   %eax,%eax
 867:	78 27                	js     890 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 869:	83 ec 08             	sub    $0x8,%esp
 86c:	ff 75 0c             	pushl  0xc(%ebp)
 86f:	89 c3                	mov    %eax,%ebx
 871:	50                   	push   %eax
 872:	e8 f3 00 00 00       	call   96a <fstat>
 877:	89 c6                	mov    %eax,%esi
  close(fd);
 879:	89 1c 24             	mov    %ebx,(%esp)
 87c:	e8 b9 00 00 00       	call   93a <close>
  return r;
 881:	83 c4 10             	add    $0x10,%esp
 884:	89 f0                	mov    %esi,%eax
}
 886:	8d 65 f8             	lea    -0x8(%ebp),%esp
 889:	5b                   	pop    %ebx
 88a:	5e                   	pop    %esi
 88b:	5d                   	pop    %ebp
 88c:	c3                   	ret    
 88d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 895:	eb ef                	jmp    886 <stat+0x36>
 897:	89 f6                	mov    %esi,%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	53                   	push   %ebx
 8a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8a7:	0f be 11             	movsbl (%ecx),%edx
 8aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 8ad:	3c 09                	cmp    $0x9,%al
 8af:	b8 00 00 00 00       	mov    $0x0,%eax
 8b4:	77 1f                	ja     8d5 <atoi+0x35>
 8b6:	8d 76 00             	lea    0x0(%esi),%esi
 8b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 8c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 8c3:	83 c1 01             	add    $0x1,%ecx
 8c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8ca:	0f be 11             	movsbl (%ecx),%edx
 8cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 8d0:	80 fb 09             	cmp    $0x9,%bl
 8d3:	76 eb                	jbe    8c0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 8d5:	5b                   	pop    %ebx
 8d6:	5d                   	pop    %ebp
 8d7:	c3                   	ret    
 8d8:	90                   	nop
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	56                   	push   %esi
 8e4:	53                   	push   %ebx
 8e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8e8:	8b 45 08             	mov    0x8(%ebp),%eax
 8eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8ee:	85 db                	test   %ebx,%ebx
 8f0:	7e 14                	jle    906 <memmove+0x26>
 8f2:	31 d2                	xor    %edx,%edx
 8f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 8f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 8fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 8ff:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 902:	39 da                	cmp    %ebx,%edx
 904:	75 f2                	jne    8f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 906:	5b                   	pop    %ebx
 907:	5e                   	pop    %esi
 908:	5d                   	pop    %ebp
 909:	c3                   	ret    

0000090a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 90a:	b8 01 00 00 00       	mov    $0x1,%eax
 90f:	cd 40                	int    $0x40
 911:	c3                   	ret    

00000912 <exit>:
SYSCALL(exit)
 912:	b8 02 00 00 00       	mov    $0x2,%eax
 917:	cd 40                	int    $0x40
 919:	c3                   	ret    

0000091a <wait>:
SYSCALL(wait)
 91a:	b8 03 00 00 00       	mov    $0x3,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <pipe>:
SYSCALL(pipe)
 922:	b8 04 00 00 00       	mov    $0x4,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <read>:
SYSCALL(read)
 92a:	b8 05 00 00 00       	mov    $0x5,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <write>:
SYSCALL(write)
 932:	b8 10 00 00 00       	mov    $0x10,%eax
 937:	cd 40                	int    $0x40
 939:	c3                   	ret    

0000093a <close>:
SYSCALL(close)
 93a:	b8 15 00 00 00       	mov    $0x15,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <kill>:
SYSCALL(kill)
 942:	b8 06 00 00 00       	mov    $0x6,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <exec>:
SYSCALL(exec)
 94a:	b8 07 00 00 00       	mov    $0x7,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <open>:
SYSCALL(open)
 952:	b8 0f 00 00 00       	mov    $0xf,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <mknod>:
SYSCALL(mknod)
 95a:	b8 11 00 00 00       	mov    $0x11,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <unlink>:
SYSCALL(unlink)
 962:	b8 12 00 00 00       	mov    $0x12,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <fstat>:
SYSCALL(fstat)
 96a:	b8 08 00 00 00       	mov    $0x8,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <link>:
SYSCALL(link)
 972:	b8 13 00 00 00       	mov    $0x13,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <mkdir>:
SYSCALL(mkdir)
 97a:	b8 14 00 00 00       	mov    $0x14,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <chdir>:
SYSCALL(chdir)
 982:	b8 09 00 00 00       	mov    $0x9,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <dup>:
SYSCALL(dup)
 98a:	b8 0a 00 00 00       	mov    $0xa,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <getpid>:
SYSCALL(getpid)
 992:	b8 0b 00 00 00       	mov    $0xb,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <sbrk>:
SYSCALL(sbrk)
 99a:	b8 0c 00 00 00       	mov    $0xc,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <sleep>:
SYSCALL(sleep)
 9a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <uptime>:
SYSCALL(uptime)
 9aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <yield>:
SYSCALL(yield)
 9b2:	b8 16 00 00 00       	mov    $0x16,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <getlev>:
SYSCALL(getlev)
 9ba:	b8 17 00 00 00       	mov    $0x17,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    

000009c2 <setpriority>:
SYSCALL(setpriority)
 9c2:	b8 18 00 00 00       	mov    $0x18,%eax
 9c7:	cd 40                	int    $0x40
 9c9:	c3                   	ret    

000009ca <getadmin>:
SYSCALL(getadmin)
 9ca:	b8 19 00 00 00       	mov    $0x19,%eax
 9cf:	cd 40                	int    $0x40
 9d1:	c3                   	ret    

000009d2 <exec2>:
SYSCALL(exec2)
 9d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 9d7:	cd 40                	int    $0x40
 9d9:	c3                   	ret    

000009da <setmemorylimit>:
SYSCALL(setmemorylimit)
 9da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 9df:	cd 40                	int    $0x40
 9e1:	c3                   	ret    

000009e2 <list>:
SYSCALL(list)
 9e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 9e7:	cd 40                	int    $0x40
 9e9:	c3                   	ret    
 9ea:	66 90                	xchg   %ax,%ax
 9ec:	66 90                	xchg   %ax,%ax
 9ee:	66 90                	xchg   %ax,%ax

000009f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	57                   	push   %edi
 9f4:	56                   	push   %esi
 9f5:	53                   	push   %ebx
 9f6:	89 c6                	mov    %eax,%esi
 9f8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 9fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9fe:	85 db                	test   %ebx,%ebx
 a00:	74 7e                	je     a80 <printint+0x90>
 a02:	89 d0                	mov    %edx,%eax
 a04:	c1 e8 1f             	shr    $0x1f,%eax
 a07:	84 c0                	test   %al,%al
 a09:	74 75                	je     a80 <printint+0x90>
    neg = 1;
    x = -xx;
 a0b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 a0d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 a14:	f7 d8                	neg    %eax
 a16:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 a19:	31 ff                	xor    %edi,%edi
 a1b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 a1e:	89 ce                	mov    %ecx,%esi
 a20:	eb 08                	jmp    a2a <printint+0x3a>
 a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 a28:	89 cf                	mov    %ecx,%edi
 a2a:	31 d2                	xor    %edx,%edx
 a2c:	8d 4f 01             	lea    0x1(%edi),%ecx
 a2f:	f7 f6                	div    %esi
 a31:	0f b6 92 88 10 00 00 	movzbl 0x1088(%edx),%edx
  }while((x /= base) != 0);
 a38:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 a3a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 a3d:	75 e9                	jne    a28 <printint+0x38>
  if(neg)
 a3f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 a42:	8b 75 c0             	mov    -0x40(%ebp),%esi
 a45:	85 c0                	test   %eax,%eax
 a47:	74 08                	je     a51 <printint+0x61>
    buf[i++] = '-';
 a49:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 a4e:	8d 4f 02             	lea    0x2(%edi),%ecx
 a51:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 a55:	8d 76 00             	lea    0x0(%esi),%esi
 a58:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 a5b:	83 ec 04             	sub    $0x4,%esp
 a5e:	83 ef 01             	sub    $0x1,%edi
 a61:	6a 01                	push   $0x1
 a63:	53                   	push   %ebx
 a64:	56                   	push   %esi
 a65:	88 45 d7             	mov    %al,-0x29(%ebp)
 a68:	e8 c5 fe ff ff       	call   932 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a6d:	83 c4 10             	add    $0x10,%esp
 a70:	39 df                	cmp    %ebx,%edi
 a72:	75 e4                	jne    a58 <printint+0x68>
    putc(fd, buf[i]);
}
 a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a77:	5b                   	pop    %ebx
 a78:	5e                   	pop    %esi
 a79:	5f                   	pop    %edi
 a7a:	5d                   	pop    %ebp
 a7b:	c3                   	ret    
 a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a80:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a82:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 a89:	eb 8b                	jmp    a16 <printint+0x26>
 a8b:	90                   	nop
 a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a90 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	57                   	push   %edi
 a94:	56                   	push   %esi
 a95:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a96:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a99:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a9f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 aa2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 aa5:	0f b6 1e             	movzbl (%esi),%ebx
 aa8:	83 c6 01             	add    $0x1,%esi
 aab:	84 db                	test   %bl,%bl
 aad:	0f 84 b0 00 00 00    	je     b63 <printf+0xd3>
 ab3:	31 d2                	xor    %edx,%edx
 ab5:	eb 39                	jmp    af0 <printf+0x60>
 ab7:	89 f6                	mov    %esi,%esi
 ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 ac0:	83 f8 25             	cmp    $0x25,%eax
 ac3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 ac6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 acb:	74 18                	je     ae5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 acd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 ad0:	83 ec 04             	sub    $0x4,%esp
 ad3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 ad6:	6a 01                	push   $0x1
 ad8:	50                   	push   %eax
 ad9:	57                   	push   %edi
 ada:	e8 53 fe ff ff       	call   932 <write>
 adf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 ae2:	83 c4 10             	add    $0x10,%esp
 ae5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 ae8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 aec:	84 db                	test   %bl,%bl
 aee:	74 73                	je     b63 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 af0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 af2:	0f be cb             	movsbl %bl,%ecx
 af5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 af8:	74 c6                	je     ac0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 afa:	83 fa 25             	cmp    $0x25,%edx
 afd:	75 e6                	jne    ae5 <printf+0x55>
      if(c == 'd'){
 aff:	83 f8 64             	cmp    $0x64,%eax
 b02:	0f 84 f8 00 00 00    	je     c00 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b08:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b0e:	83 f9 70             	cmp    $0x70,%ecx
 b11:	74 5d                	je     b70 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b13:	83 f8 73             	cmp    $0x73,%eax
 b16:	0f 84 84 00 00 00    	je     ba0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b1c:	83 f8 63             	cmp    $0x63,%eax
 b1f:	0f 84 ea 00 00 00    	je     c0f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b25:	83 f8 25             	cmp    $0x25,%eax
 b28:	0f 84 c2 00 00 00    	je     bf0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b2e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b31:	83 ec 04             	sub    $0x4,%esp
 b34:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b38:	6a 01                	push   $0x1
 b3a:	50                   	push   %eax
 b3b:	57                   	push   %edi
 b3c:	e8 f1 fd ff ff       	call   932 <write>
 b41:	83 c4 0c             	add    $0xc,%esp
 b44:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 b47:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 b4a:	6a 01                	push   $0x1
 b4c:	50                   	push   %eax
 b4d:	57                   	push   %edi
 b4e:	83 c6 01             	add    $0x1,%esi
 b51:	e8 dc fd ff ff       	call   932 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b56:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b5a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b5d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b5f:	84 db                	test   %bl,%bl
 b61:	75 8d                	jne    af0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b66:	5b                   	pop    %ebx
 b67:	5e                   	pop    %esi
 b68:	5f                   	pop    %edi
 b69:	5d                   	pop    %ebp
 b6a:	c3                   	ret    
 b6b:	90                   	nop
 b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 b70:	83 ec 0c             	sub    $0xc,%esp
 b73:	b9 10 00 00 00       	mov    $0x10,%ecx
 b78:	6a 00                	push   $0x0
 b7a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 b7d:	89 f8                	mov    %edi,%eax
 b7f:	8b 13                	mov    (%ebx),%edx
 b81:	e8 6a fe ff ff       	call   9f0 <printint>
        ap++;
 b86:	89 d8                	mov    %ebx,%eax
 b88:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b8b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 b8d:	83 c0 04             	add    $0x4,%eax
 b90:	89 45 d0             	mov    %eax,-0x30(%ebp)
 b93:	e9 4d ff ff ff       	jmp    ae5 <printf+0x55>
 b98:	90                   	nop
 b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 ba0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 ba3:	8b 18                	mov    (%eax),%ebx
        ap++;
 ba5:	83 c0 04             	add    $0x4,%eax
 ba8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 bab:	b8 7e 10 00 00       	mov    $0x107e,%eax
 bb0:	85 db                	test   %ebx,%ebx
 bb2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 bb5:	0f b6 03             	movzbl (%ebx),%eax
 bb8:	84 c0                	test   %al,%al
 bba:	74 23                	je     bdf <printf+0x14f>
 bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 bc0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bc3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 bc6:	83 ec 04             	sub    $0x4,%esp
 bc9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 bcb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bce:	50                   	push   %eax
 bcf:	57                   	push   %edi
 bd0:	e8 5d fd ff ff       	call   932 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 bd5:	0f b6 03             	movzbl (%ebx),%eax
 bd8:	83 c4 10             	add    $0x10,%esp
 bdb:	84 c0                	test   %al,%al
 bdd:	75 e1                	jne    bc0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 bdf:	31 d2                	xor    %edx,%edx
 be1:	e9 ff fe ff ff       	jmp    ae5 <printf+0x55>
 be6:	8d 76 00             	lea    0x0(%esi),%esi
 be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bf0:	83 ec 04             	sub    $0x4,%esp
 bf3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 bf6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 bf9:	6a 01                	push   $0x1
 bfb:	e9 4c ff ff ff       	jmp    b4c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 c00:	83 ec 0c             	sub    $0xc,%esp
 c03:	b9 0a 00 00 00       	mov    $0xa,%ecx
 c08:	6a 01                	push   $0x1
 c0a:	e9 6b ff ff ff       	jmp    b7a <printf+0xea>
 c0f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c12:	83 ec 04             	sub    $0x4,%esp
 c15:	8b 03                	mov    (%ebx),%eax
 c17:	6a 01                	push   $0x1
 c19:	88 45 e4             	mov    %al,-0x1c(%ebp)
 c1c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 c1f:	50                   	push   %eax
 c20:	57                   	push   %edi
 c21:	e8 0c fd ff ff       	call   932 <write>
 c26:	e9 5b ff ff ff       	jmp    b86 <printf+0xf6>
 c2b:	66 90                	xchg   %ax,%ax
 c2d:	66 90                	xchg   %ax,%ax
 c2f:	90                   	nop

00000c30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c30:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c31:	a1 d0 13 00 00       	mov    0x13d0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 c36:	89 e5                	mov    %esp,%ebp
 c38:	57                   	push   %edi
 c39:	56                   	push   %esi
 c3a:	53                   	push   %ebx
 c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c3e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c40:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c43:	39 c8                	cmp    %ecx,%eax
 c45:	73 19                	jae    c60 <free+0x30>
 c47:	89 f6                	mov    %esi,%esi
 c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 c50:	39 d1                	cmp    %edx,%ecx
 c52:	72 1c                	jb     c70 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c54:	39 d0                	cmp    %edx,%eax
 c56:	73 18                	jae    c70 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 c58:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c5a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c5c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c5e:	72 f0                	jb     c50 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c60:	39 d0                	cmp    %edx,%eax
 c62:	72 f4                	jb     c58 <free+0x28>
 c64:	39 d1                	cmp    %edx,%ecx
 c66:	73 f0                	jae    c58 <free+0x28>
 c68:	90                   	nop
 c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 c70:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c73:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c76:	39 d7                	cmp    %edx,%edi
 c78:	74 19                	je     c93 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 c7a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 c7d:	8b 50 04             	mov    0x4(%eax),%edx
 c80:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 c83:	39 f1                	cmp    %esi,%ecx
 c85:	74 23                	je     caa <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 c87:	89 08                	mov    %ecx,(%eax)
  freep = p;
 c89:	a3 d0 13 00 00       	mov    %eax,0x13d0
}
 c8e:	5b                   	pop    %ebx
 c8f:	5e                   	pop    %esi
 c90:	5f                   	pop    %edi
 c91:	5d                   	pop    %ebp
 c92:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c93:	03 72 04             	add    0x4(%edx),%esi
 c96:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 c99:	8b 10                	mov    (%eax),%edx
 c9b:	8b 12                	mov    (%edx),%edx
 c9d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 ca0:	8b 50 04             	mov    0x4(%eax),%edx
 ca3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ca6:	39 f1                	cmp    %esi,%ecx
 ca8:	75 dd                	jne    c87 <free+0x57>
    p->s.size += bp->s.size;
 caa:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 cad:	a3 d0 13 00 00       	mov    %eax,0x13d0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 cb2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cb5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 cb8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 cba:	5b                   	pop    %ebx
 cbb:	5e                   	pop    %esi
 cbc:	5f                   	pop    %edi
 cbd:	5d                   	pop    %ebp
 cbe:	c3                   	ret    
 cbf:	90                   	nop

00000cc0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cc0:	55                   	push   %ebp
 cc1:	89 e5                	mov    %esp,%ebp
 cc3:	57                   	push   %edi
 cc4:	56                   	push   %esi
 cc5:	53                   	push   %ebx
 cc6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 ccc:	8b 15 d0 13 00 00    	mov    0x13d0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cd2:	8d 78 07             	lea    0x7(%eax),%edi
 cd5:	c1 ef 03             	shr    $0x3,%edi
 cd8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 cdb:	85 d2                	test   %edx,%edx
 cdd:	0f 84 a3 00 00 00    	je     d86 <malloc+0xc6>
 ce3:	8b 02                	mov    (%edx),%eax
 ce5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 ce8:	39 cf                	cmp    %ecx,%edi
 cea:	76 74                	jbe    d60 <malloc+0xa0>
 cec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 cf2:	be 00 10 00 00       	mov    $0x1000,%esi
 cf7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 cfe:	0f 43 f7             	cmovae %edi,%esi
 d01:	ba 00 80 00 00       	mov    $0x8000,%edx
 d06:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 d0c:	0f 46 da             	cmovbe %edx,%ebx
 d0f:	eb 10                	jmp    d21 <malloc+0x61>
 d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d18:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 d1a:	8b 48 04             	mov    0x4(%eax),%ecx
 d1d:	39 cf                	cmp    %ecx,%edi
 d1f:	76 3f                	jbe    d60 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d21:	39 05 d0 13 00 00    	cmp    %eax,0x13d0
 d27:	89 c2                	mov    %eax,%edx
 d29:	75 ed                	jne    d18 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 d2b:	83 ec 0c             	sub    $0xc,%esp
 d2e:	53                   	push   %ebx
 d2f:	e8 66 fc ff ff       	call   99a <sbrk>
  if(p == (char*)-1)
 d34:	83 c4 10             	add    $0x10,%esp
 d37:	83 f8 ff             	cmp    $0xffffffff,%eax
 d3a:	74 1c                	je     d58 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 d3c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 d3f:	83 ec 0c             	sub    $0xc,%esp
 d42:	83 c0 08             	add    $0x8,%eax
 d45:	50                   	push   %eax
 d46:	e8 e5 fe ff ff       	call   c30 <free>
  return freep;
 d4b:	8b 15 d0 13 00 00    	mov    0x13d0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 d51:	83 c4 10             	add    $0x10,%esp
 d54:	85 d2                	test   %edx,%edx
 d56:	75 c0                	jne    d18 <malloc+0x58>
        return 0;
 d58:	31 c0                	xor    %eax,%eax
 d5a:	eb 1c                	jmp    d78 <malloc+0xb8>
 d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 d60:	39 cf                	cmp    %ecx,%edi
 d62:	74 1c                	je     d80 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 d64:	29 f9                	sub    %edi,%ecx
 d66:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 d69:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 d6c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 d6f:	89 15 d0 13 00 00    	mov    %edx,0x13d0
      return (void*)(p + 1);
 d75:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
 d7b:	5b                   	pop    %ebx
 d7c:	5e                   	pop    %esi
 d7d:	5f                   	pop    %edi
 d7e:	5d                   	pop    %ebp
 d7f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 d80:	8b 08                	mov    (%eax),%ecx
 d82:	89 0a                	mov    %ecx,(%edx)
 d84:	eb e9                	jmp    d6f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 d86:	c7 05 d0 13 00 00 d4 	movl   $0x13d4,0x13d0
 d8d:	13 00 00 
 d90:	c7 05 d4 13 00 00 d4 	movl   $0x13d4,0x13d4
 d97:	13 00 00 
    base.s.size = 0;
 d9a:	b8 d4 13 00 00       	mov    $0x13d4,%eax
 d9f:	c7 05 d8 13 00 00 00 	movl   $0x0,0x13d8
 da6:	00 00 00 
 da9:	e9 3e ff ff ff       	jmp    cec <malloc+0x2c>
