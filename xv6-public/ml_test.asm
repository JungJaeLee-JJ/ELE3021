
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
  18:	e8 65 04 00 00       	call   482 <getpid>

  printf(1, "Multilevel test start\n");
  1d:	83 ec 08             	sub    $0x8,%esp

int main(int argc, char *argv[])
{
  int i, pid;

  parent = getpid();
  20:	a3 70 0c 00 00       	mov    %eax,0xc70

  printf(1, "Multilevel test start\n");
  25:	68 b0 08 00 00       	push   $0x8b0
  2a:	6a 01                	push   $0x1
  2c:	e8 5f 05 00 00       	call   590 <printf>

  printf(1, "[Test 1] without yield / sleep\n");
  31:	5e                   	pop    %esi
  32:	58                   	pop    %eax
  33:	68 4c 09 00 00       	push   $0x94c
  38:	6a 01                	push   $0x1
  3a:	e8 51 05 00 00       	call   590 <printf>
  pid = fork_children();
  3f:	e8 0c 01 00 00       	call   150 <fork_children>

  if (pid != parent)
  44:	83 c4 10             	add    $0x10,%esp
  47:	3b 05 70 0c 00 00    	cmp    0xc70,%eax
  4d:	89 c6                	mov    %eax,%esi
  4f:	74 1f                	je     70 <main+0x70>
  51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    for (i = 0; i < NUM_LOOP; i++)
      printf(1, "Process %d\n", pid);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	56                   	push   %esi
  5c:	68 ef 08 00 00       	push   $0x8ef
  61:	6a 01                	push   $0x1
  63:	e8 28 05 00 00       	call   590 <printf>
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
  78:	68 c7 08 00 00       	push   $0x8c7
  7d:	6a 01                	push   $0x1
  7f:	e8 0c 05 00 00       	call   590 <printf>

  printf(1, "[Test 2] with yield\n");
  84:	59                   	pop    %ecx
  85:	5b                   	pop    %ebx
  86:	68 da 08 00 00       	push   $0x8da
  8b:	6a 01                	push   $0x1
  8d:	bb 50 c3 00 00       	mov    $0xc350,%ebx
  92:	e8 f9 04 00 00       	call   590 <printf>
  pid = fork_children();
  97:	e8 b4 00 00 00       	call   150 <fork_children>

  if (pid != parent)
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	3b 05 70 0c 00 00    	cmp    0xc70,%eax
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
  b0:	e8 ed 03 00 00       	call   4a2 <yield>
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
  be:	68 fb 08 00 00       	push   $0x8fb
  c3:	6a 01                	push   $0x1
  c5:	e8 c6 04 00 00       	call   590 <printf>
  ca:	83 c4 10             	add    $0x10,%esp
  }
  
  exit_children();
  cd:	e8 be 00 00 00       	call   190 <exit_children>
  printf(1, "[Test 2] finished\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	bb 0a 00 00 00       	mov    $0xa,%ebx
  da:	68 10 09 00 00       	push   $0x910
  df:	6a 01                	push   $0x1
  e1:	e8 aa 04 00 00       	call   590 <printf>

  printf(1, "[Test 3] with sleep\n");
  e6:	58                   	pop    %eax
  e7:	5a                   	pop    %edx
  e8:	68 23 09 00 00       	push   $0x923
  ed:	6a 01                	push   $0x1
  ef:	e8 9c 04 00 00       	call   590 <printf>
  pid = fork_children();
  f4:	e8 57 00 00 00       	call   150 <fork_children>

  if (pid != parent)
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	3b 05 70 0c 00 00    	cmp    0xc70,%eax
  
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
 114:	68 ef 08 00 00       	push   $0x8ef
 119:	6a 01                	push   $0x1
 11b:	e8 70 04 00 00       	call   590 <printf>
      sleep(10);
 120:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 127:	e8 66 03 00 00       	call   492 <sleep>
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
 13c:	68 38 09 00 00       	push   $0x938
 141:	6a 01                	push   $0x1
 143:	e8 48 04 00 00       	call   590 <printf>
  exit();
 148:	e8 b5 02 00 00       	call   402 <exit>
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
 15c:	e8 99 02 00 00       	call   3fa <fork>
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
 16a:	a1 70 0c 00 00       	mov    0xc70,%eax
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
 17d:	e8 10 03 00 00       	call   492 <sleep>
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
 189:	e9 f4 02 00 00       	jmp    482 <getpid>
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
 196:	e8 e7 02 00 00       	call   482 <getpid>
 19b:	3b 05 70 0c 00 00    	cmp    0xc70,%eax
 1a1:	75 11                	jne    1b4 <exit_children+0x24>
 1a3:	90                   	nop
 1a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
  while (wait() != -1);
 1a8:	e8 5d 02 00 00       	call   40a <wait>
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
 1b4:	e8 49 02 00 00       	call   402 <exit>
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
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
 1f5:	8b 55 08             	mov    0x8(%ebp),%edx
 1f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q){
 1fb:	0f b6 02             	movzbl (%edx),%eax
 1fe:	0f b6 19             	movzbl (%ecx),%ebx
 201:	84 c0                	test   %al,%al
 203:	75 1e                	jne    223 <strcmp+0x33>
 205:	eb 29                	jmp    230 <strcmp+0x40>
 207:	89 f6                	mov    %esi,%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 210:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 213:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 216:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 219:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 21d:	84 c0                	test   %al,%al
 21f:	74 0f                	je     230 <strcmp+0x40>
 221:	89 f1                	mov    %esi,%ecx
 223:	38 d8                	cmp    %bl,%al
 225:	74 e9                	je     210 <strcmp+0x20>
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 227:	29 d8                	sub    %ebx,%eax
}
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 230:	31 c0                	xor    %eax,%eax
    p++, q++;
	//printf(2,"%c %c\n",*p,*q );
  }
 // printf(2,"%d %d\n",*p,*q);
 // printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 232:	29 d8                	sub    %ebx,%eax
}
 234:	5b                   	pop    %ebx
 235:	5e                   	pop    %esi
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    
 238:	90                   	nop
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000240 <strlen>:

uint
strlen(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 246:	80 39 00             	cmpb   $0x0,(%ecx)
 249:	74 12                	je     25d <strlen+0x1d>
 24b:	31 d2                	xor    %edx,%edx
 24d:	8d 76 00             	lea    0x0(%esi),%esi
 250:	83 c2 01             	add    $0x1,%edx
 253:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 257:	89 d0                	mov    %edx,%eax
 259:	75 f5                	jne    250 <strlen+0x10>
    ;
  return n;
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 25d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    
 261:	eb 0d                	jmp    270 <memset>
 263:	90                   	nop
 264:	90                   	nop
 265:	90                   	nop
 266:	90                   	nop
 267:	90                   	nop
 268:	90                   	nop
 269:	90                   	nop
 26a:	90                   	nop
 26b:	90                   	nop
 26c:	90                   	nop
 26d:	90                   	nop
 26e:	90                   	nop
 26f:	90                   	nop

00000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 277:	8b 4d 10             	mov    0x10(%ebp),%ecx
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	89 d7                	mov    %edx,%edi
 27f:	fc                   	cld    
 280:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 282:	89 d0                	mov    %edx,%eax
 284:	5f                   	pop    %edi
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 29a:	0f b6 10             	movzbl (%eax),%edx
 29d:	84 d2                	test   %dl,%dl
 29f:	74 1d                	je     2be <strchr+0x2e>
    if(*s == c)
 2a1:	38 d3                	cmp    %dl,%bl
 2a3:	89 d9                	mov    %ebx,%ecx
 2a5:	75 0d                	jne    2b4 <strchr+0x24>
 2a7:	eb 17                	jmp    2c0 <strchr+0x30>
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b0:	38 ca                	cmp    %cl,%dl
 2b2:	74 0c                	je     2c0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b4:	83 c0 01             	add    $0x1,%eax
 2b7:	0f b6 10             	movzbl (%eax),%edx
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2be:	31 c0                	xor    %eax,%eax
}
 2c0:	5b                   	pop    %ebx
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <gets>:

char*
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 2d8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 2db:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2de:	eb 29                	jmp    309 <gets+0x39>
    cc = read(0, &c, 1);
 2e0:	83 ec 04             	sub    $0x4,%esp
 2e3:	6a 01                	push   $0x1
 2e5:	57                   	push   %edi
 2e6:	6a 00                	push   $0x0
 2e8:	e8 2d 01 00 00       	call   41a <read>
    if(cc < 1)
 2ed:	83 c4 10             	add    $0x10,%esp
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7e 1d                	jle    311 <gets+0x41>
      break;
    buf[i++] = c;
 2f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2f8:	8b 55 08             	mov    0x8(%ebp),%edx
 2fb:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 2fd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2ff:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 303:	74 1b                	je     320 <gets+0x50>
 305:	3c 0d                	cmp    $0xd,%al
 307:	74 17                	je     320 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 309:	8d 5e 01             	lea    0x1(%esi),%ebx
 30c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 30f:	7c cf                	jl     2e0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 318:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31b:	5b                   	pop    %ebx
 31c:	5e                   	pop    %esi
 31d:	5f                   	pop    %edi
 31e:	5d                   	pop    %ebp
 31f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 320:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 323:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 329:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32c:	5b                   	pop    %ebx
 32d:	5e                   	pop    %esi
 32e:	5f                   	pop    %edi
 32f:	5d                   	pop    %ebp
 330:	c3                   	ret    
 331:	eb 0d                	jmp    340 <stat>
 333:	90                   	nop
 334:	90                   	nop
 335:	90                   	nop
 336:	90                   	nop
 337:	90                   	nop
 338:	90                   	nop
 339:	90                   	nop
 33a:	90                   	nop
 33b:	90                   	nop
 33c:	90                   	nop
 33d:	90                   	nop
 33e:	90                   	nop
 33f:	90                   	nop

00000340 <stat>:

int
stat(const char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	83 ec 08             	sub    $0x8,%esp
 348:	6a 00                	push   $0x0
 34a:	ff 75 08             	pushl  0x8(%ebp)
 34d:	e8 f0 00 00 00       	call   442 <open>
  if(fd < 0)
 352:	83 c4 10             	add    $0x10,%esp
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	ff 75 0c             	pushl  0xc(%ebp)
 35f:	89 c3                	mov    %eax,%ebx
 361:	50                   	push   %eax
 362:	e8 f3 00 00 00       	call   45a <fstat>
 367:	89 c6                	mov    %eax,%esi
  close(fd);
 369:	89 1c 24             	mov    %ebx,(%esp)
 36c:	e8 b9 00 00 00       	call   42a <close>
  return r;
 371:	83 c4 10             	add    $0x10,%esp
 374:	89 f0                	mov    %esi,%eax
}
 376:	8d 65 f8             	lea    -0x8(%ebp),%esp
 379:	5b                   	pop    %ebx
 37a:	5e                   	pop    %esi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 385:	eb ef                	jmp    376 <stat+0x36>
 387:	89 f6                	mov    %esi,%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 397:	0f be 11             	movsbl (%ecx),%edx
 39a:	8d 42 d0             	lea    -0x30(%edx),%eax
 39d:	3c 09                	cmp    $0x9,%al
 39f:	b8 00 00 00 00       	mov    $0x0,%eax
 3a4:	77 1f                	ja     3c5 <atoi+0x35>
 3a6:	8d 76 00             	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3b3:	83 c1 01             	add    $0x1,%ecx
 3b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ba:	0f be 11             	movsbl (%ecx),%edx
 3bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3c0:	80 fb 09             	cmp    $0x9,%bl
 3c3:	76 eb                	jbe    3b0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3c5:	5b                   	pop    %ebx
 3c6:	5d                   	pop    %ebp
 3c7:	c3                   	ret    
 3c8:	90                   	nop
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3de:	85 db                	test   %ebx,%ebx
 3e0:	7e 14                	jle    3f6 <memmove+0x26>
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3ef:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f2:	39 da                	cmp    %ebx,%edx
 3f4:	75 f2                	jne    3e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    

000003fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fa:	b8 01 00 00 00       	mov    $0x1,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <exit>:
SYSCALL(exit)
 402:	b8 02 00 00 00       	mov    $0x2,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <wait>:
SYSCALL(wait)
 40a:	b8 03 00 00 00       	mov    $0x3,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <pipe>:
SYSCALL(pipe)
 412:	b8 04 00 00 00       	mov    $0x4,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <read>:
SYSCALL(read)
 41a:	b8 05 00 00 00       	mov    $0x5,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <write>:
SYSCALL(write)
 422:	b8 10 00 00 00       	mov    $0x10,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <close>:
SYSCALL(close)
 42a:	b8 15 00 00 00       	mov    $0x15,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <kill>:
SYSCALL(kill)
 432:	b8 06 00 00 00       	mov    $0x6,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <exec>:
SYSCALL(exec)
 43a:	b8 07 00 00 00       	mov    $0x7,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <open>:
SYSCALL(open)
 442:	b8 0f 00 00 00       	mov    $0xf,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <mknod>:
SYSCALL(mknod)
 44a:	b8 11 00 00 00       	mov    $0x11,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <unlink>:
SYSCALL(unlink)
 452:	b8 12 00 00 00       	mov    $0x12,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <fstat>:
SYSCALL(fstat)
 45a:	b8 08 00 00 00       	mov    $0x8,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <link>:
SYSCALL(link)
 462:	b8 13 00 00 00       	mov    $0x13,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <mkdir>:
SYSCALL(mkdir)
 46a:	b8 14 00 00 00       	mov    $0x14,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <chdir>:
SYSCALL(chdir)
 472:	b8 09 00 00 00       	mov    $0x9,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <dup>:
SYSCALL(dup)
 47a:	b8 0a 00 00 00       	mov    $0xa,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <getpid>:
SYSCALL(getpid)
 482:	b8 0b 00 00 00       	mov    $0xb,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <sbrk>:
SYSCALL(sbrk)
 48a:	b8 0c 00 00 00       	mov    $0xc,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <sleep>:
SYSCALL(sleep)
 492:	b8 0d 00 00 00       	mov    $0xd,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <uptime>:
SYSCALL(uptime)
 49a:	b8 0e 00 00 00       	mov    $0xe,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <yield>:
SYSCALL(yield)
 4a2:	b8 16 00 00 00       	mov    $0x16,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <getlev>:
SYSCALL(getlev)
 4aa:	b8 17 00 00 00       	mov    $0x17,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <setpriority>:
SYSCALL(setpriority)
 4b2:	b8 18 00 00 00       	mov    $0x18,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <getadmin>:
SYSCALL(getadmin)
 4ba:	b8 19 00 00 00       	mov    $0x19,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <exec2>:
SYSCALL(exec2)
 4c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <setmemorylimit>:
SYSCALL(setmemorylimit)
 4ca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <list>:
SYSCALL(list)
 4d2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <getshmem>:
SYSCALL(getshmem)
 4da:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    
 4e2:	66 90                	xchg   %ax,%ax
 4e4:	66 90                	xchg   %ax,%ax
 4e6:	66 90                	xchg   %ax,%ax
 4e8:	66 90                	xchg   %ax,%ax
 4ea:	66 90                	xchg   %ax,%ax
 4ec:	66 90                	xchg   %ax,%ax
 4ee:	66 90                	xchg   %ax,%ax

000004f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	89 c6                	mov    %eax,%esi
 4f8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4fe:	85 db                	test   %ebx,%ebx
 500:	74 7e                	je     580 <printint+0x90>
 502:	89 d0                	mov    %edx,%eax
 504:	c1 e8 1f             	shr    $0x1f,%eax
 507:	84 c0                	test   %al,%al
 509:	74 75                	je     580 <printint+0x90>
    neg = 1;
    x = -xx;
 50b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 50d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 514:	f7 d8                	neg    %eax
 516:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 519:	31 ff                	xor    %edi,%edi
 51b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 51e:	89 ce                	mov    %ecx,%esi
 520:	eb 08                	jmp    52a <printint+0x3a>
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 528:	89 cf                	mov    %ecx,%edi
 52a:	31 d2                	xor    %edx,%edx
 52c:	8d 4f 01             	lea    0x1(%edi),%ecx
 52f:	f7 f6                	div    %esi
 531:	0f b6 92 74 09 00 00 	movzbl 0x974(%edx),%edx
  }while((x /= base) != 0);
 538:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 53a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 53d:	75 e9                	jne    528 <printint+0x38>
  if(neg)
 53f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 542:	8b 75 c0             	mov    -0x40(%ebp),%esi
 545:	85 c0                	test   %eax,%eax
 547:	74 08                	je     551 <printint+0x61>
    buf[i++] = '-';
 549:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 54e:	8d 4f 02             	lea    0x2(%edi),%ecx
 551:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 555:	8d 76 00             	lea    0x0(%esi),%esi
 558:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 55b:	83 ec 04             	sub    $0x4,%esp
 55e:	83 ef 01             	sub    $0x1,%edi
 561:	6a 01                	push   $0x1
 563:	53                   	push   %ebx
 564:	56                   	push   %esi
 565:	88 45 d7             	mov    %al,-0x29(%ebp)
 568:	e8 b5 fe ff ff       	call   422 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 56d:	83 c4 10             	add    $0x10,%esp
 570:	39 df                	cmp    %ebx,%edi
 572:	75 e4                	jne    558 <printint+0x68>
    putc(fd, buf[i]);
}
 574:	8d 65 f4             	lea    -0xc(%ebp),%esp
 577:	5b                   	pop    %ebx
 578:	5e                   	pop    %esi
 579:	5f                   	pop    %edi
 57a:	5d                   	pop    %ebp
 57b:	c3                   	ret    
 57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 580:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 582:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 589:	eb 8b                	jmp    516 <printint+0x26>
 58b:	90                   	nop
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000590 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 596:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 599:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 59f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5a5:	0f b6 1e             	movzbl (%esi),%ebx
 5a8:	83 c6 01             	add    $0x1,%esi
 5ab:	84 db                	test   %bl,%bl
 5ad:	0f 84 b0 00 00 00    	je     663 <printf+0xd3>
 5b3:	31 d2                	xor    %edx,%edx
 5b5:	eb 39                	jmp    5f0 <printf+0x60>
 5b7:	89 f6                	mov    %esi,%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5c0:	83 f8 25             	cmp    $0x25,%eax
 5c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 5c6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5cb:	74 18                	je     5e5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5cd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5d6:	6a 01                	push   $0x1
 5d8:	50                   	push   %eax
 5d9:	57                   	push   %edi
 5da:	e8 43 fe ff ff       	call   422 <write>
 5df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5e2:	83 c4 10             	add    $0x10,%esp
 5e5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5ec:	84 db                	test   %bl,%bl
 5ee:	74 73                	je     663 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 5f0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5f2:	0f be cb             	movsbl %bl,%ecx
 5f5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5f8:	74 c6                	je     5c0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fa:	83 fa 25             	cmp    $0x25,%edx
 5fd:	75 e6                	jne    5e5 <printf+0x55>
      if(c == 'd'){
 5ff:	83 f8 64             	cmp    $0x64,%eax
 602:	0f 84 f8 00 00 00    	je     700 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 608:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 60e:	83 f9 70             	cmp    $0x70,%ecx
 611:	74 5d                	je     670 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 613:	83 f8 73             	cmp    $0x73,%eax
 616:	0f 84 84 00 00 00    	je     6a0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61c:	83 f8 63             	cmp    $0x63,%eax
 61f:	0f 84 ea 00 00 00    	je     70f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 625:	83 f8 25             	cmp    $0x25,%eax
 628:	0f 84 c2 00 00 00    	je     6f0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 631:	83 ec 04             	sub    $0x4,%esp
 634:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 638:	6a 01                	push   $0x1
 63a:	50                   	push   %eax
 63b:	57                   	push   %edi
 63c:	e8 e1 fd ff ff       	call   422 <write>
 641:	83 c4 0c             	add    $0xc,%esp
 644:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 647:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 64a:	6a 01                	push   $0x1
 64c:	50                   	push   %eax
 64d:	57                   	push   %edi
 64e:	83 c6 01             	add    $0x1,%esi
 651:	e8 cc fd ff ff       	call   422 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 656:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 65d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65f:	84 db                	test   %bl,%bl
 661:	75 8d                	jne    5f0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 663:	8d 65 f4             	lea    -0xc(%ebp),%esp
 666:	5b                   	pop    %ebx
 667:	5e                   	pop    %esi
 668:	5f                   	pop    %edi
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    
 66b:	90                   	nop
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 10 00 00 00       	mov    $0x10,%ecx
 678:	6a 00                	push   $0x0
 67a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 67d:	89 f8                	mov    %edi,%eax
 67f:	8b 13                	mov    (%ebx),%edx
 681:	e8 6a fe ff ff       	call   4f0 <printint>
        ap++;
 686:	89 d8                	mov    %ebx,%eax
 688:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 68d:	83 c0 04             	add    $0x4,%eax
 690:	89 45 d0             	mov    %eax,-0x30(%ebp)
 693:	e9 4d ff ff ff       	jmp    5e5 <printf+0x55>
 698:	90                   	nop
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6a5:	83 c0 04             	add    $0x4,%eax
 6a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 6ab:	b8 6c 09 00 00       	mov    $0x96c,%eax
 6b0:	85 db                	test   %ebx,%ebx
 6b2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6b5:	0f b6 03             	movzbl (%ebx),%eax
 6b8:	84 c0                	test   %al,%al
 6ba:	74 23                	je     6df <printf+0x14f>
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6c3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 6c6:	83 ec 04             	sub    $0x4,%esp
 6c9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6cb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ce:	50                   	push   %eax
 6cf:	57                   	push   %edi
 6d0:	e8 4d fd ff ff       	call   422 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6d5:	0f b6 03             	movzbl (%ebx),%eax
 6d8:	83 c4 10             	add    $0x10,%esp
 6db:	84 c0                	test   %al,%al
 6dd:	75 e1                	jne    6c0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 ff fe ff ff       	jmp    5e5 <printf+0x55>
 6e6:	8d 76 00             	lea    0x0(%esi),%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6f9:	6a 01                	push   $0x1
 6fb:	e9 4c ff ff ff       	jmp    64c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	b9 0a 00 00 00       	mov    $0xa,%ecx
 708:	6a 01                	push   $0x1
 70a:	e9 6b ff ff ff       	jmp    67a <printf+0xea>
 70f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 712:	83 ec 04             	sub    $0x4,%esp
 715:	8b 03                	mov    (%ebx),%eax
 717:	6a 01                	push   $0x1
 719:	88 45 e4             	mov    %al,-0x1c(%ebp)
 71c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 71f:	50                   	push   %eax
 720:	57                   	push   %edi
 721:	e8 fc fc ff ff       	call   422 <write>
 726:	e9 5b ff ff ff       	jmp    686 <printf+0xf6>
 72b:	66 90                	xchg   %ax,%ax
 72d:	66 90                	xchg   %ax,%ax
 72f:	90                   	nop

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 64 0c 00 00       	mov    0xc64,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 736:	89 e5                	mov    %esp,%ebp
 738:	57                   	push   %edi
 739:	56                   	push   %esi
 73a:	53                   	push   %ebx
 73b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 740:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	39 c8                	cmp    %ecx,%eax
 745:	73 19                	jae    760 <free+0x30>
 747:	89 f6                	mov    %esi,%esi
 749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 750:	39 d1                	cmp    %edx,%ecx
 752:	72 1c                	jb     770 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 754:	39 d0                	cmp    %edx,%eax
 756:	73 18                	jae    770 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	72 f0                	jb     750 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	39 d0                	cmp    %edx,%eax
 762:	72 f4                	jb     758 <free+0x28>
 764:	39 d1                	cmp    %edx,%ecx
 766:	73 f0                	jae    758 <free+0x28>
 768:	90                   	nop
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 770:	8b 73 fc             	mov    -0x4(%ebx),%esi
 773:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 776:	39 d7                	cmp    %edx,%edi
 778:	74 19                	je     793 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 77a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 783:	39 f1                	cmp    %esi,%ecx
 785:	74 23                	je     7aa <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 787:	89 08                	mov    %ecx,(%eax)
  freep = p;
 789:	a3 64 0c 00 00       	mov    %eax,0xc64
}
 78e:	5b                   	pop    %ebx
 78f:	5e                   	pop    %esi
 790:	5f                   	pop    %edi
 791:	5d                   	pop    %ebp
 792:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 793:	03 72 04             	add    0x4(%edx),%esi
 796:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 799:	8b 10                	mov    (%eax),%edx
 79b:	8b 12                	mov    (%edx),%edx
 79d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a0:	8b 50 04             	mov    0x4(%eax),%edx
 7a3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a6:	39 f1                	cmp    %esi,%ecx
 7a8:	75 dd                	jne    787 <free+0x57>
    p->s.size += bp->s.size;
 7aa:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7ad:	a3 64 0c 00 00       	mov    %eax,0xc64
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7b8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7ba:	5b                   	pop    %ebx
 7bb:	5e                   	pop    %esi
 7bc:	5f                   	pop    %edi
 7bd:	5d                   	pop    %ebp
 7be:	c3                   	ret    
 7bf:	90                   	nop

000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7cc:	8b 15 64 0c 00 00    	mov    0xc64,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8d 78 07             	lea    0x7(%eax),%edi
 7d5:	c1 ef 03             	shr    $0x3,%edi
 7d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7db:	85 d2                	test   %edx,%edx
 7dd:	0f 84 a3 00 00 00    	je     886 <malloc+0xc6>
 7e3:	8b 02                	mov    (%edx),%eax
 7e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7e8:	39 cf                	cmp    %ecx,%edi
 7ea:	76 74                	jbe    860 <malloc+0xa0>
 7ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7f2:	be 00 10 00 00       	mov    $0x1000,%esi
 7f7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 7fe:	0f 43 f7             	cmovae %edi,%esi
 801:	ba 00 80 00 00       	mov    $0x8000,%edx
 806:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 80c:	0f 46 da             	cmovbe %edx,%ebx
 80f:	eb 10                	jmp    821 <malloc+0x61>
 811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 81a:	8b 48 04             	mov    0x4(%eax),%ecx
 81d:	39 cf                	cmp    %ecx,%edi
 81f:	76 3f                	jbe    860 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 821:	39 05 64 0c 00 00    	cmp    %eax,0xc64
 827:	89 c2                	mov    %eax,%edx
 829:	75 ed                	jne    818 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	53                   	push   %ebx
 82f:	e8 56 fc ff ff       	call   48a <sbrk>
  if(p == (char*)-1)
 834:	83 c4 10             	add    $0x10,%esp
 837:	83 f8 ff             	cmp    $0xffffffff,%eax
 83a:	74 1c                	je     858 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 83c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 83f:	83 ec 0c             	sub    $0xc,%esp
 842:	83 c0 08             	add    $0x8,%eax
 845:	50                   	push   %eax
 846:	e8 e5 fe ff ff       	call   730 <free>
  return freep;
 84b:	8b 15 64 0c 00 00    	mov    0xc64,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 851:	83 c4 10             	add    $0x10,%esp
 854:	85 d2                	test   %edx,%edx
 856:	75 c0                	jne    818 <malloc+0x58>
        return 0;
 858:	31 c0                	xor    %eax,%eax
 85a:	eb 1c                	jmp    878 <malloc+0xb8>
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 860:	39 cf                	cmp    %ecx,%edi
 862:	74 1c                	je     880 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 864:	29 f9                	sub    %edi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 86c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 86f:	89 15 64 0c 00 00    	mov    %edx,0xc64
      return (void*)(p + 1);
 875:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 878:	8d 65 f4             	lea    -0xc(%ebp),%esp
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 880:	8b 08                	mov    (%eax),%ecx
 882:	89 0a                	mov    %ecx,(%edx)
 884:	eb e9                	jmp    86f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 886:	c7 05 64 0c 00 00 68 	movl   $0xc68,0xc64
 88d:	0c 00 00 
 890:	c7 05 68 0c 00 00 68 	movl   $0xc68,0xc68
 897:	0c 00 00 
    base.s.size = 0;
 89a:	b8 68 0c 00 00       	mov    $0xc68,%eax
 89f:	c7 05 6c 0c 00 00 00 	movl   $0x0,0xc6c
 8a6:	00 00 00 
 8a9:	e9 3e ff ff ff       	jmp    7ec <malloc+0x2c>
