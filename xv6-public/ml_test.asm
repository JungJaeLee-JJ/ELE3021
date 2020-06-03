
_ml_test:     file format elf32-i386


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
  10:	bb 14 00 00 00       	mov    $0x14,%ebx
  15:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;

  parent = getpid();
  18:	e8 b5 04 00 00       	call   4d2 <getpid>

  printf(1, "Multilevel test start\n");
  1d:	83 ec 08             	sub    $0x8,%esp

int main(int argc, char *argv[])
{
  int i, pid;

  parent = getpid();
  20:	a3 bc 0c 00 00       	mov    %eax,0xcbc

  printf(1, "Multilevel test start\n");
  25:	68 f0 08 00 00       	push   $0x8f0
  2a:	6a 01                	push   $0x1
  2c:	e8 9f 05 00 00       	call   5d0 <printf>

  printf(1, "[Test 1] without yield / sleep\n");
  31:	5e                   	pop    %esi
  32:	58                   	pop    %eax
  33:	68 8c 09 00 00       	push   $0x98c
  38:	6a 01                	push   $0x1
  3a:	e8 91 05 00 00       	call   5d0 <printf>
  pid = fork_children();
  3f:	e8 0c 01 00 00       	call   150 <fork_children>

  if (pid != parent)
  44:	83 c4 10             	add    $0x10,%esp
  47:	3b 05 bc 0c 00 00    	cmp    0xcbc,%eax
  4d:	89 c6                	mov    %eax,%esi
  4f:	74 1f                	je     70 <main+0x70>
  51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    for (i = 0; i < NUM_LOOP; i++)
      printf(1, "Process %d\n", pid);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	56                   	push   %esi
  5c:	68 2f 09 00 00       	push   $0x92f
  61:	6a 01                	push   $0x1
  63:	e8 68 05 00 00       	call   5d0 <printf>
  printf(1, "[Test 1] without yield / sleep\n");
  pid = fork_children();

  if (pid != parent)
  {
    for (i = 0; i < NUM_LOOP; i++)
  68:	83 c4 10             	add    $0x10,%esp
  6b:	83 eb 01             	sub    $0x1,%ebx
  6e:	75 e8                	jne    58 <main+0x58>
      printf(1, "Process %d\n", pid);
  }
  exit_children();
  70:	e8 1b 01 00 00       	call   190 <exit_children>
  printf(1, "[Test 1] finished\n");
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 07 09 00 00       	push   $0x907
  7d:	6a 01                	push   $0x1
  7f:	e8 4c 05 00 00       	call   5d0 <printf>

  printf(1, "[Test 2] with yield\n");
  84:	59                   	pop    %ecx
  85:	5b                   	pop    %ebx
  86:	68 1a 09 00 00       	push   $0x91a
  8b:	6a 01                	push   $0x1
  8d:	bb 50 c3 00 00       	mov    $0xc350,%ebx
  92:	e8 39 05 00 00       	call   5d0 <printf>
  pid = fork_children();
  97:	e8 b4 00 00 00       	call   150 <fork_children>

  if (pid != parent)
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	3b 05 bc 0c 00 00    	cmp    0xcbc,%eax
  }
  exit_children();
  printf(1, "[Test 1] finished\n");

  printf(1, "[Test 2] with yield\n");
  pid = fork_children();
  a5:	89 c6                	mov    %eax,%esi

  if (pid != parent)
  a7:	74 24                	je     cd <main+0xcd>
  a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    for (i = 0; i < NUM_YIELD; i++)
      yield();
  b0:	e8 3d 04 00 00       	call   4f2 <yield>
  printf(1, "[Test 2] with yield\n");
  pid = fork_children();

  if (pid != parent)
  {
    for (i = 0; i < NUM_YIELD; i++)
  b5:	83 eb 01             	sub    $0x1,%ebx
  b8:	75 f6                	jne    b0 <main+0xb0>
      yield();
    printf(1, "Process %d finished\n", pid);
  ba:	83 ec 04             	sub    $0x4,%esp
  bd:	56                   	push   %esi
  be:	68 3b 09 00 00       	push   $0x93b
  c3:	6a 01                	push   $0x1
  c5:	e8 06 05 00 00       	call   5d0 <printf>
  ca:	83 c4 10             	add    $0x10,%esp
  }
  
  exit_children();
  cd:	e8 be 00 00 00       	call   190 <exit_children>
  printf(1, "[Test 2] finished\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	bb 0a 00 00 00       	mov    $0xa,%ebx
  da:	68 50 09 00 00       	push   $0x950
  df:	6a 01                	push   $0x1
  e1:	e8 ea 04 00 00       	call   5d0 <printf>

  printf(1, "[Test 3] with sleep\n");
  e6:	58                   	pop    %eax
  e7:	5a                   	pop    %edx
  e8:	68 63 09 00 00       	push   $0x963
  ed:	6a 01                	push   $0x1
  ef:	e8 dc 04 00 00       	call   5d0 <printf>
  pid = fork_children();
  f4:	e8 57 00 00 00       	call   150 <fork_children>

  if (pid != parent)
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	3b 05 bc 0c 00 00    	cmp    0xcbc,%eax
  
  exit_children();
  printf(1, "[Test 2] finished\n");

  printf(1, "[Test 3] with sleep\n");
  pid = fork_children();
 102:	89 c6                	mov    %eax,%esi

  if (pid != parent)
 104:	74 2e                	je     134 <main+0x134>
 106:	8d 76 00             	lea    0x0(%esi),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  {
    for (i = 0; i < NUM_SLEEP; i++)
    {
      printf(1, "Process %d\n", pid);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	56                   	push   %esi
 114:	68 2f 09 00 00       	push   $0x92f
 119:	6a 01                	push   $0x1
 11b:	e8 b0 04 00 00       	call   5d0 <printf>
      sleep(10);
 120:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 127:	e8 b6 03 00 00       	call   4e2 <sleep>
  printf(1, "[Test 3] with sleep\n");
  pid = fork_children();

  if (pid != parent)
  {
    for (i = 0; i < NUM_SLEEP; i++)
 12c:	83 c4 10             	add    $0x10,%esp
 12f:	83 eb 01             	sub    $0x1,%ebx
 132:	75 dc                	jne    110 <main+0x110>
    {
      printf(1, "Process %d\n", pid);
      sleep(10);
    }
  }
  exit_children();
 134:	e8 57 00 00 00       	call   190 <exit_children>
  printf(1, "[Test 3] finished\n");
 139:	83 ec 08             	sub    $0x8,%esp
 13c:	68 78 09 00 00       	push   $0x978
 141:	6a 01                	push   $0x1
 143:	e8 88 04 00 00       	call   5d0 <printf>
  exit();
 148:	e8 05 03 00 00       	call   452 <exit>
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <fork_children>:
#define NUM_THREAD 4

int parent;

int fork_children()
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	bb 04 00 00 00       	mov    $0x4,%ebx
 159:	83 ec 04             	sub    $0x4,%esp
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
    if ((p = fork()) == 0)
 15c:	e8 e9 02 00 00       	call   44a <fork>
 161:	85 c0                	test   %eax,%eax
 163:	74 13                	je     178 <fork_children+0x28>
int parent;

int fork_children()
{
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
 165:	83 eb 01             	sub    $0x1,%ebx
 168:	75 f2                	jne    15c <fork_children+0xc>
    {
      sleep(10);
      return getpid();
    }
  return parent;
}
 16a:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 16f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 172:	c9                   	leave  
 173:	c3                   	ret    
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
    if ((p = fork()) == 0)
    {
      sleep(10);
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	6a 0a                	push   $0xa
 17d:	e8 60 03 00 00       	call   4e2 <sleep>
      return getpid();
 182:	83 c4 10             	add    $0x10,%esp
    }
  return parent;
}
 185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 188:	c9                   	leave  
  int i, p;
  for (i = 0; i < NUM_THREAD; i++)
    if ((p = fork()) == 0)
    {
      sleep(10);
      return getpid();
 189:	e9 44 03 00 00       	jmp    4d2 <getpid>
 18e:	66 90                	xchg   %ax,%ax

00000190 <exit_children>:
    }
  return parent;
}

void exit_children()
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 08             	sub    $0x8,%esp
  if (getpid() != parent)
 196:	e8 37 03 00 00       	call   4d2 <getpid>
 19b:	3b 05 bc 0c 00 00    	cmp    0xcbc,%eax
 1a1:	75 11                	jne    1b4 <exit_children+0x24>
 1a3:	90                   	nop
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
  while (wait() != -1);
 1a8:	e8 ad 02 00 00       	call   45a <wait>
 1ad:	83 f8 ff             	cmp    $0xffffffff,%eax
 1b0:	75 f6                	jne    1a8 <exit_children+0x18>
}
 1b2:	c9                   	leave  
 1b3:	c3                   	ret    
}

void exit_children()
{
  if (getpid() != parent)
    exit();
 1b4:	e8 99 02 00 00       	call   452 <exit>
 1b9:	66 90                	xchg   %ax,%ax
 1bb:	66 90                	xchg   %ax,%ax
 1bd:	66 90                	xchg   %ax,%ax
 1bf:	90                   	nop

000001c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ca:	89 c2                	mov    %eax,%edx
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	83 c1 01             	add    $0x1,%ecx
 1d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1d7:	83 c2 01             	add    $0x1,%edx
 1da:	84 db                	test   %bl,%bl
 1dc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1df:	75 ef                	jne    1d0 <strcpy+0x10>
    ;
  return os;
}
 1e1:	5b                   	pop    %ebx
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
 1f6:	83 ec 0c             	sub    $0xc,%esp
 1f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q){
 1ff:	0f be 03             	movsbl (%ebx),%eax
 202:	0f be 16             	movsbl (%esi),%edx
 205:	84 c0                	test   %al,%al
 207:	74 76                	je     27f <strcmp+0x8f>
 209:	38 c2                	cmp    %al,%dl
 20b:	89 f7                	mov    %esi,%edi
 20d:	74 0f                	je     21e <strcmp+0x2e>
 20f:	eb 38                	jmp    249 <strcmp+0x59>
 211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 218:	38 d0                	cmp    %dl,%al
 21a:	89 fe                	mov    %edi,%esi
 21c:	75 2b                	jne    249 <strcmp+0x59>
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
 21e:	0f be 46 01          	movsbl 0x1(%esi),%eax

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
    p++, q++;
 222:	83 c3 01             	add    $0x1,%ebx
 225:	8d 7e 01             	lea    0x1(%esi),%edi
	printf(2,"%c %c\n",*p,*q );
 228:	50                   	push   %eax
 229:	0f be 03             	movsbl (%ebx),%eax
 22c:	50                   	push   %eax
 22d:	68 ac 09 00 00       	push   $0x9ac
 232:	6a 02                	push   $0x2
 234:	e8 97 03 00 00       	call   5d0 <printf>
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 239:	0f be 03             	movsbl (%ebx),%eax
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	0f be 56 01          	movsbl 0x1(%esi),%edx
 243:	84 c0                	test   %al,%al
 245:	75 d1                	jne    218 <strcmp+0x28>
 247:	31 c0                	xor    %eax,%eax
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
 249:	52                   	push   %edx
 24a:	50                   	push   %eax
 24b:	68 b3 09 00 00       	push   $0x9b3
 250:	6a 02                	push   $0x2
 252:	e8 79 03 00 00       	call   5d0 <printf>
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
 257:	0f b6 17             	movzbl (%edi),%edx
 25a:	0f b6 03             	movzbl (%ebx),%eax
 25d:	83 c4 0c             	add    $0xc,%esp
 260:	29 d0                	sub    %edx,%eax
 262:	50                   	push   %eax
 263:	68 b6 09 00 00       	push   $0x9b6
 268:	6a 02                	push   $0x2
 26a:	e8 61 03 00 00       	call   5d0 <printf>
  return (uchar)*p - (uchar)*q;
 26f:	0f b6 03             	movzbl (%ebx),%eax
 272:	0f b6 17             	movzbl (%edi),%edx
}
 275:	8d 65 f4             	lea    -0xc(%ebp),%esp
 278:	5b                   	pop    %ebx
 279:	5e                   	pop    %esi
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 27a:	29 d0                	sub    %edx,%eax
}
 27c:	5f                   	pop    %edi
 27d:	5d                   	pop    %ebp
 27e:	c3                   	ret    
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 27f:	89 f7                	mov    %esi,%edi
 281:	31 c0                	xor    %eax,%eax
 283:	eb c4                	jmp    249 <strcmp+0x59>
 285:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 296:	80 39 00             	cmpb   $0x0,(%ecx)
 299:	74 12                	je     2ad <strlen+0x1d>
 29b:	31 d2                	xor    %edx,%edx
 29d:	8d 76 00             	lea    0x0(%esi),%esi
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2a7:	89 d0                	mov    %edx,%eax
 2a9:	75 f5                	jne    2a0 <strlen+0x10>
    ;
  return n;
}
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 2ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    
 2b1:	eb 0d                	jmp    2c0 <memset>
 2b3:	90                   	nop
 2b4:	90                   	nop
 2b5:	90                   	nop
 2b6:	90                   	nop
 2b7:	90                   	nop
 2b8:	90                   	nop
 2b9:	90                   	nop
 2ba:	90                   	nop
 2bb:	90                   	nop
 2bc:	90                   	nop
 2bd:	90                   	nop
 2be:	90                   	nop
 2bf:	90                   	nop

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 d7                	mov    %edx,%edi
 2cf:	fc                   	cld    
 2d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d2:	89 d0                	mov    %edx,%eax
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	89 f6                	mov    %esi,%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2ea:	0f b6 10             	movzbl (%eax),%edx
 2ed:	84 d2                	test   %dl,%dl
 2ef:	74 1d                	je     30e <strchr+0x2e>
    if(*s == c)
 2f1:	38 d3                	cmp    %dl,%bl
 2f3:	89 d9                	mov    %ebx,%ecx
 2f5:	75 0d                	jne    304 <strchr+0x24>
 2f7:	eb 17                	jmp    310 <strchr+0x30>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 300:	38 ca                	cmp    %cl,%dl
 302:	74 0c                	je     310 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 304:	83 c0 01             	add    $0x1,%eax
 307:	0f b6 10             	movzbl (%eax),%edx
 30a:	84 d2                	test   %dl,%dl
 30c:	75 f2                	jne    300 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 30e:	31 c0                	xor    %eax,%eax
}
 310:	5b                   	pop    %ebx
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <gets>:

char*
gets(char *buf, int max)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 326:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 328:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 32b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32e:	eb 29                	jmp    359 <gets+0x39>
    cc = read(0, &c, 1);
 330:	83 ec 04             	sub    $0x4,%esp
 333:	6a 01                	push   $0x1
 335:	57                   	push   %edi
 336:	6a 00                	push   $0x0
 338:	e8 2d 01 00 00       	call   46a <read>
    if(cc < 1)
 33d:	83 c4 10             	add    $0x10,%esp
 340:	85 c0                	test   %eax,%eax
 342:	7e 1d                	jle    361 <gets+0x41>
      break;
    buf[i++] = c;
 344:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 348:	8b 55 08             	mov    0x8(%ebp),%edx
 34b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 34d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 34f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 353:	74 1b                	je     370 <gets+0x50>
 355:	3c 0d                	cmp    $0xd,%al
 357:	74 17                	je     370 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 359:	8d 5e 01             	lea    0x1(%esi),%ebx
 35c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 35f:	7c cf                	jl     330 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 368:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36b:	5b                   	pop    %ebx
 36c:	5e                   	pop    %esi
 36d:	5f                   	pop    %edi
 36e:	5d                   	pop    %ebp
 36f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 370:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 373:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 375:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 379:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37c:	5b                   	pop    %ebx
 37d:	5e                   	pop    %esi
 37e:	5f                   	pop    %edi
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
 381:	eb 0d                	jmp    390 <stat>
 383:	90                   	nop
 384:	90                   	nop
 385:	90                   	nop
 386:	90                   	nop
 387:	90                   	nop
 388:	90                   	nop
 389:	90                   	nop
 38a:	90                   	nop
 38b:	90                   	nop
 38c:	90                   	nop
 38d:	90                   	nop
 38e:	90                   	nop
 38f:	90                   	nop

00000390 <stat>:

int
stat(const char *n, struct stat *st)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 395:	83 ec 08             	sub    $0x8,%esp
 398:	6a 00                	push   $0x0
 39a:	ff 75 08             	pushl  0x8(%ebp)
 39d:	e8 f0 00 00 00       	call   492 <open>
  if(fd < 0)
 3a2:	83 c4 10             	add    $0x10,%esp
 3a5:	85 c0                	test   %eax,%eax
 3a7:	78 27                	js     3d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	ff 75 0c             	pushl  0xc(%ebp)
 3af:	89 c3                	mov    %eax,%ebx
 3b1:	50                   	push   %eax
 3b2:	e8 f3 00 00 00       	call   4aa <fstat>
 3b7:	89 c6                	mov    %eax,%esi
  close(fd);
 3b9:	89 1c 24             	mov    %ebx,(%esp)
 3bc:	e8 b9 00 00 00       	call   47a <close>
  return r;
 3c1:	83 c4 10             	add    $0x10,%esp
 3c4:	89 f0                	mov    %esi,%eax
}
 3c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3c9:	5b                   	pop    %ebx
 3ca:	5e                   	pop    %esi
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d5:	eb ef                	jmp    3c6 <stat+0x36>
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e7:	0f be 11             	movsbl (%ecx),%edx
 3ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 3ed:	3c 09                	cmp    $0x9,%al
 3ef:	b8 00 00 00 00       	mov    $0x0,%eax
 3f4:	77 1f                	ja     415 <atoi+0x35>
 3f6:	8d 76 00             	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 400:	8d 04 80             	lea    (%eax,%eax,4),%eax
 403:	83 c1 01             	add    $0x1,%ecx
 406:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40a:	0f be 11             	movsbl (%ecx),%edx
 40d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 410:	80 fb 09             	cmp    $0x9,%bl
 413:	76 eb                	jbe    400 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 415:	5b                   	pop    %ebx
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
 425:	8b 5d 10             	mov    0x10(%ebp),%ebx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 42e:	85 db                	test   %ebx,%ebx
 430:	7e 14                	jle    446 <memmove+0x26>
 432:	31 d2                	xor    %edx,%edx
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 438:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 43c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 43f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 442:	39 da                	cmp    %ebx,%edx
 444:	75 f2                	jne    438 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 446:	5b                   	pop    %ebx
 447:	5e                   	pop    %esi
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    

0000044a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44a:	b8 01 00 00 00       	mov    $0x1,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <exit>:
SYSCALL(exit)
 452:	b8 02 00 00 00       	mov    $0x2,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <wait>:
SYSCALL(wait)
 45a:	b8 03 00 00 00       	mov    $0x3,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <pipe>:
SYSCALL(pipe)
 462:	b8 04 00 00 00       	mov    $0x4,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <read>:
SYSCALL(read)
 46a:	b8 05 00 00 00       	mov    $0x5,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <write>:
SYSCALL(write)
 472:	b8 10 00 00 00       	mov    $0x10,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <close>:
SYSCALL(close)
 47a:	b8 15 00 00 00       	mov    $0x15,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <kill>:
SYSCALL(kill)
 482:	b8 06 00 00 00       	mov    $0x6,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <exec>:
SYSCALL(exec)
 48a:	b8 07 00 00 00       	mov    $0x7,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <open>:
SYSCALL(open)
 492:	b8 0f 00 00 00       	mov    $0xf,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mknod>:
SYSCALL(mknod)
 49a:	b8 11 00 00 00       	mov    $0x11,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <unlink>:
SYSCALL(unlink)
 4a2:	b8 12 00 00 00       	mov    $0x12,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <fstat>:
SYSCALL(fstat)
 4aa:	b8 08 00 00 00       	mov    $0x8,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <link>:
SYSCALL(link)
 4b2:	b8 13 00 00 00       	mov    $0x13,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <mkdir>:
SYSCALL(mkdir)
 4ba:	b8 14 00 00 00       	mov    $0x14,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <chdir>:
SYSCALL(chdir)
 4c2:	b8 09 00 00 00       	mov    $0x9,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <dup>:
SYSCALL(dup)
 4ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <getpid>:
SYSCALL(getpid)
 4d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <sbrk>:
SYSCALL(sbrk)
 4da:	b8 0c 00 00 00       	mov    $0xc,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <sleep>:
SYSCALL(sleep)
 4e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <uptime>:
SYSCALL(uptime)
 4ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <yield>:
SYSCALL(yield)
 4f2:	b8 16 00 00 00       	mov    $0x16,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <getlev>:
SYSCALL(getlev)
 4fa:	b8 17 00 00 00       	mov    $0x17,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <setpriority>:
SYSCALL(setpriority)
 502:	b8 18 00 00 00       	mov    $0x18,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <getadmin>:
SYSCALL(getadmin)
 50a:	b8 19 00 00 00       	mov    $0x19,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <exec2>:
SYSCALL(exec2)
 512:	b8 1a 00 00 00       	mov    $0x1a,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <setmemorylimit>:
SYSCALL(setmemorylimit)
 51a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <list>:
SYSCALL(list)
 522:	b8 1c 00 00 00       	mov    $0x1c,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    
 52a:	66 90                	xchg   %ax,%ax
 52c:	66 90                	xchg   %ax,%ax
 52e:	66 90                	xchg   %ax,%ax

00000530 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	89 c6                	mov    %eax,%esi
 538:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 53e:	85 db                	test   %ebx,%ebx
 540:	74 7e                	je     5c0 <printint+0x90>
 542:	89 d0                	mov    %edx,%eax
 544:	c1 e8 1f             	shr    $0x1f,%eax
 547:	84 c0                	test   %al,%al
 549:	74 75                	je     5c0 <printint+0x90>
    neg = 1;
    x = -xx;
 54b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 54d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 554:	f7 d8                	neg    %eax
 556:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 559:	31 ff                	xor    %edi,%edi
 55b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 55e:	89 ce                	mov    %ecx,%esi
 560:	eb 08                	jmp    56a <printint+0x3a>
 562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 568:	89 cf                	mov    %ecx,%edi
 56a:	31 d2                	xor    %edx,%edx
 56c:	8d 4f 01             	lea    0x1(%edi),%ecx
 56f:	f7 f6                	div    %esi
 571:	0f b6 92 c4 09 00 00 	movzbl 0x9c4(%edx),%edx
  }while((x /= base) != 0);
 578:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 57a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 57d:	75 e9                	jne    568 <printint+0x38>
  if(neg)
 57f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 582:	8b 75 c0             	mov    -0x40(%ebp),%esi
 585:	85 c0                	test   %eax,%eax
 587:	74 08                	je     591 <printint+0x61>
    buf[i++] = '-';
 589:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 58e:	8d 4f 02             	lea    0x2(%edi),%ecx
 591:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 595:	8d 76 00             	lea    0x0(%esi),%esi
 598:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59b:	83 ec 04             	sub    $0x4,%esp
 59e:	83 ef 01             	sub    $0x1,%edi
 5a1:	6a 01                	push   $0x1
 5a3:	53                   	push   %ebx
 5a4:	56                   	push   %esi
 5a5:	88 45 d7             	mov    %al,-0x29(%ebp)
 5a8:	e8 c5 fe ff ff       	call   472 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ad:	83 c4 10             	add    $0x10,%esp
 5b0:	39 df                	cmp    %ebx,%edi
 5b2:	75 e4                	jne    598 <printint+0x68>
    putc(fd, buf[i]);
}
 5b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5b7:	5b                   	pop    %ebx
 5b8:	5e                   	pop    %esi
 5b9:	5f                   	pop    %edi
 5ba:	5d                   	pop    %ebp
 5bb:	c3                   	ret    
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5c0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5c2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5c9:	eb 8b                	jmp    556 <printint+0x26>
 5cb:	90                   	nop
 5cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5d9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5dc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5df:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5e5:	0f b6 1e             	movzbl (%esi),%ebx
 5e8:	83 c6 01             	add    $0x1,%esi
 5eb:	84 db                	test   %bl,%bl
 5ed:	0f 84 b0 00 00 00    	je     6a3 <printf+0xd3>
 5f3:	31 d2                	xor    %edx,%edx
 5f5:	eb 39                	jmp    630 <printf+0x60>
 5f7:	89 f6                	mov    %esi,%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 600:	83 f8 25             	cmp    $0x25,%eax
 603:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 606:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 60b:	74 18                	je     625 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 60d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 610:	83 ec 04             	sub    $0x4,%esp
 613:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 616:	6a 01                	push   $0x1
 618:	50                   	push   %eax
 619:	57                   	push   %edi
 61a:	e8 53 fe ff ff       	call   472 <write>
 61f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 622:	83 c4 10             	add    $0x10,%esp
 625:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 628:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 62c:	84 db                	test   %bl,%bl
 62e:	74 73                	je     6a3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 630:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 632:	0f be cb             	movsbl %bl,%ecx
 635:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 638:	74 c6                	je     600 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 63a:	83 fa 25             	cmp    $0x25,%edx
 63d:	75 e6                	jne    625 <printf+0x55>
      if(c == 'd'){
 63f:	83 f8 64             	cmp    $0x64,%eax
 642:	0f 84 f8 00 00 00    	je     740 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 648:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 64e:	83 f9 70             	cmp    $0x70,%ecx
 651:	74 5d                	je     6b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 653:	83 f8 73             	cmp    $0x73,%eax
 656:	0f 84 84 00 00 00    	je     6e0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65c:	83 f8 63             	cmp    $0x63,%eax
 65f:	0f 84 ea 00 00 00    	je     74f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 665:	83 f8 25             	cmp    $0x25,%eax
 668:	0f 84 c2 00 00 00    	je     730 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 671:	83 ec 04             	sub    $0x4,%esp
 674:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 678:	6a 01                	push   $0x1
 67a:	50                   	push   %eax
 67b:	57                   	push   %edi
 67c:	e8 f1 fd ff ff       	call   472 <write>
 681:	83 c4 0c             	add    $0xc,%esp
 684:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 687:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 68a:	6a 01                	push   $0x1
 68c:	50                   	push   %eax
 68d:	57                   	push   %edi
 68e:	83 c6 01             	add    $0x1,%esi
 691:	e8 dc fd ff ff       	call   472 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 696:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 69d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69f:	84 db                	test   %bl,%bl
 6a1:	75 8d                	jne    630 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a6:	5b                   	pop    %ebx
 6a7:	5e                   	pop    %esi
 6a8:	5f                   	pop    %edi
 6a9:	5d                   	pop    %ebp
 6aa:	c3                   	ret    
 6ab:	90                   	nop
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6b8:	6a 00                	push   $0x0
 6ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6bd:	89 f8                	mov    %edi,%eax
 6bf:	8b 13                	mov    (%ebx),%edx
 6c1:	e8 6a fe ff ff       	call   530 <printint>
        ap++;
 6c6:	89 d8                	mov    %ebx,%eax
 6c8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6cb:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 6cd:	83 c0 04             	add    $0x4,%eax
 6d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6d3:	e9 4d ff ff ff       	jmp    625 <printf+0x55>
 6d8:	90                   	nop
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6e5:	83 c0 04             	add    $0x4,%eax
 6e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 6eb:	b8 ba 09 00 00       	mov    $0x9ba,%eax
 6f0:	85 db                	test   %ebx,%ebx
 6f2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6f5:	0f b6 03             	movzbl (%ebx),%eax
 6f8:	84 c0                	test   %al,%al
 6fa:	74 23                	je     71f <printf+0x14f>
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 700:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 703:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 706:	83 ec 04             	sub    $0x4,%esp
 709:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 70b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 70e:	50                   	push   %eax
 70f:	57                   	push   %edi
 710:	e8 5d fd ff ff       	call   472 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 715:	0f b6 03             	movzbl (%ebx),%eax
 718:	83 c4 10             	add    $0x10,%esp
 71b:	84 c0                	test   %al,%al
 71d:	75 e1                	jne    700 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 71f:	31 d2                	xor    %edx,%edx
 721:	e9 ff fe ff ff       	jmp    625 <printf+0x55>
 726:	8d 76 00             	lea    0x0(%esi),%esi
 729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
 733:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 736:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 739:	6a 01                	push   $0x1
 73b:	e9 4c ff ff ff       	jmp    68c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 740:	83 ec 0c             	sub    $0xc,%esp
 743:	b9 0a 00 00 00       	mov    $0xa,%ecx
 748:	6a 01                	push   $0x1
 74a:	e9 6b ff ff ff       	jmp    6ba <printf+0xea>
 74f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 752:	83 ec 04             	sub    $0x4,%esp
 755:	8b 03                	mov    (%ebx),%eax
 757:	6a 01                	push   $0x1
 759:	88 45 e4             	mov    %al,-0x1c(%ebp)
 75c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 75f:	50                   	push   %eax
 760:	57                   	push   %edi
 761:	e8 0c fd ff ff       	call   472 <write>
 766:	e9 5b ff ff ff       	jmp    6c6 <printf+0xf6>
 76b:	66 90                	xchg   %ax,%ax
 76d:	66 90                	xchg   %ax,%ax
 76f:	90                   	nop

00000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 b0 0c 00 00       	mov    0xcb0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 780:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 783:	39 c8                	cmp    %ecx,%eax
 785:	73 19                	jae    7a0 <free+0x30>
 787:	89 f6                	mov    %esi,%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 790:	39 d1                	cmp    %edx,%ecx
 792:	72 1c                	jb     7b0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	39 d0                	cmp    %edx,%eax
 796:	73 18                	jae    7b0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 798:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	72 f0                	jb     790 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	39 d0                	cmp    %edx,%eax
 7a2:	72 f4                	jb     798 <free+0x28>
 7a4:	39 d1                	cmp    %edx,%ecx
 7a6:	73 f0                	jae    798 <free+0x28>
 7a8:	90                   	nop
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7b3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7b6:	39 d7                	cmp    %edx,%edi
 7b8:	74 19                	je     7d3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c3:	39 f1                	cmp    %esi,%ecx
 7c5:	74 23                	je     7ea <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7c7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7c9:	a3 b0 0c 00 00       	mov    %eax,0xcb0
}
 7ce:	5b                   	pop    %ebx
 7cf:	5e                   	pop    %esi
 7d0:	5f                   	pop    %edi
 7d1:	5d                   	pop    %ebp
 7d2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7d3:	03 72 04             	add    0x4(%edx),%esi
 7d6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d9:	8b 10                	mov    (%eax),%edx
 7db:	8b 12                	mov    (%edx),%edx
 7dd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7e0:	8b 50 04             	mov    0x4(%eax),%edx
 7e3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e6:	39 f1                	cmp    %esi,%ecx
 7e8:	75 dd                	jne    7c7 <free+0x57>
    p->s.size += bp->s.size;
 7ea:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7ed:	a3 b0 0c 00 00       	mov    %eax,0xcb0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7f8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7fa:	5b                   	pop    %ebx
 7fb:	5e                   	pop    %esi
 7fc:	5f                   	pop    %edi
 7fd:	5d                   	pop    %ebp
 7fe:	c3                   	ret    
 7ff:	90                   	nop

00000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 80c:	8b 15 b0 0c 00 00    	mov    0xcb0,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	8d 78 07             	lea    0x7(%eax),%edi
 815:	c1 ef 03             	shr    $0x3,%edi
 818:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 81b:	85 d2                	test   %edx,%edx
 81d:	0f 84 a3 00 00 00    	je     8c6 <malloc+0xc6>
 823:	8b 02                	mov    (%edx),%eax
 825:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 828:	39 cf                	cmp    %ecx,%edi
 82a:	76 74                	jbe    8a0 <malloc+0xa0>
 82c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 832:	be 00 10 00 00       	mov    $0x1000,%esi
 837:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 83e:	0f 43 f7             	cmovae %edi,%esi
 841:	ba 00 80 00 00       	mov    $0x8000,%edx
 846:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 84c:	0f 46 da             	cmovbe %edx,%ebx
 84f:	eb 10                	jmp    861 <malloc+0x61>
 851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 85a:	8b 48 04             	mov    0x4(%eax),%ecx
 85d:	39 cf                	cmp    %ecx,%edi
 85f:	76 3f                	jbe    8a0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 861:	39 05 b0 0c 00 00    	cmp    %eax,0xcb0
 867:	89 c2                	mov    %eax,%edx
 869:	75 ed                	jne    858 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 86b:	83 ec 0c             	sub    $0xc,%esp
 86e:	53                   	push   %ebx
 86f:	e8 66 fc ff ff       	call   4da <sbrk>
  if(p == (char*)-1)
 874:	83 c4 10             	add    $0x10,%esp
 877:	83 f8 ff             	cmp    $0xffffffff,%eax
 87a:	74 1c                	je     898 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 87c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 87f:	83 ec 0c             	sub    $0xc,%esp
 882:	83 c0 08             	add    $0x8,%eax
 885:	50                   	push   %eax
 886:	e8 e5 fe ff ff       	call   770 <free>
  return freep;
 88b:	8b 15 b0 0c 00 00    	mov    0xcb0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 891:	83 c4 10             	add    $0x10,%esp
 894:	85 d2                	test   %edx,%edx
 896:	75 c0                	jne    858 <malloc+0x58>
        return 0;
 898:	31 c0                	xor    %eax,%eax
 89a:	eb 1c                	jmp    8b8 <malloc+0xb8>
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 8a0:	39 cf                	cmp    %ecx,%edi
 8a2:	74 1c                	je     8c0 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8a4:	29 f9                	sub    %edi,%ecx
 8a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8ac:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 8af:	89 15 b0 0c 00 00    	mov    %edx,0xcb0
      return (void*)(p + 1);
 8b5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8bb:	5b                   	pop    %ebx
 8bc:	5e                   	pop    %esi
 8bd:	5f                   	pop    %edi
 8be:	5d                   	pop    %ebp
 8bf:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 8c0:	8b 08                	mov    (%eax),%ecx
 8c2:	89 0a                	mov    %ecx,(%edx)
 8c4:	eb e9                	jmp    8af <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8c6:	c7 05 b0 0c 00 00 b4 	movl   $0xcb4,0xcb0
 8cd:	0c 00 00 
 8d0:	c7 05 b4 0c 00 00 b4 	movl   $0xcb4,0xcb4
 8d7:	0c 00 00 
    base.s.size = 0;
 8da:	b8 b4 0c 00 00       	mov    $0xcb4,%eax
 8df:	c7 05 b8 0c 00 00 00 	movl   $0x0,0xcb8
 8e6:	00 00 00 
 8e9:	e9 3e ff ff ff       	jmp    82c <malloc+0x2c>
