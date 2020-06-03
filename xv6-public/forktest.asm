
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
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
   e:	83 ec 04             	sub    $0x4,%esp
  forktest();
  11:	e8 3a 00 00 00       	call   50 <forktest>
  exit();
  16:	e8 c7 03 00 00       	call   3e2 <exit>
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	53                   	push   %ebx
  24:	83 ec 10             	sub    $0x10,%esp
  27:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  2a:	53                   	push   %ebx
  2b:	e8 f0 01 00 00       	call   220 <strlen>
  30:	83 c4 0c             	add    $0xc,%esp
  33:	50                   	push   %eax
  34:	53                   	push   %ebx
  35:	ff 75 08             	pushl  0x8(%ebp)
  38:	e8 c5 03 00 00       	call   402 <write>
}
  3d:	83 c4 10             	add    $0x10,%esp
  40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  43:	c9                   	leave  
  44:	c3                   	ret    
  45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000050 <forktest>:

void
forktest(void)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  54:	31 db                	xor    %ebx,%ebx
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  56:	83 ec 10             	sub    $0x10,%esp
#define N  1000

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
  59:	68 bc 04 00 00       	push   $0x4bc
  5e:	e8 bd 01 00 00       	call   220 <strlen>
  63:	83 c4 0c             	add    $0xc,%esp
  66:	50                   	push   %eax
  67:	68 bc 04 00 00       	push   $0x4bc
  6c:	6a 01                	push   $0x1
  6e:	e8 8f 03 00 00       	call   402 <write>
  73:	83 c4 10             	add    $0x10,%esp
  76:	eb 19                	jmp    91 <forktest+0x41>
  78:	90                   	nop
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(n=0; n<N; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
  80:	0f 84 7c 00 00 00    	je     102 <forktest+0xb2>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  86:	83 c3 01             	add    $0x1,%ebx
  89:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  8f:	74 4f                	je     e0 <forktest+0x90>
    pid = fork();
  91:	e8 44 03 00 00       	call   3da <fork>
    if(pid < 0)
  96:	85 c0                	test   %eax,%eax
  98:	79 e6                	jns    80 <forktest+0x30>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
  9a:	85 db                	test   %ebx,%ebx
  9c:	74 10                	je     ae <forktest+0x5e>
  9e:	66 90                	xchg   %ax,%ax
    if(wait() < 0){
  a0:	e8 45 03 00 00       	call   3ea <wait>
  a5:	85 c0                	test   %eax,%eax
  a7:	78 5e                	js     107 <forktest+0xb7>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
  a9:	83 eb 01             	sub    $0x1,%ebx
  ac:	75 f2                	jne    a0 <forktest+0x50>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  ae:	e8 37 03 00 00       	call   3ea <wait>
  b3:	83 f8 ff             	cmp    $0xffffffff,%eax
  b6:	75 71                	jne    129 <forktest+0xd9>
#define N  1000

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
  b8:	83 ec 0c             	sub    $0xc,%esp
  bb:	68 ee 04 00 00       	push   $0x4ee
  c0:	e8 5b 01 00 00       	call   220 <strlen>
  c5:	83 c4 0c             	add    $0xc,%esp
  c8:	50                   	push   %eax
  c9:	68 ee 04 00 00       	push   $0x4ee
  ce:	6a 01                	push   $0x1
  d0:	e8 2d 03 00 00       	call   402 <write>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
}
  d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d8:	c9                   	leave  
  d9:	c3                   	ret    
  da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
#define N  1000

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
  e0:	83 ec 0c             	sub    $0xc,%esp
  e3:	68 fc 04 00 00       	push   $0x4fc
  e8:	e8 33 01 00 00       	call   220 <strlen>
  ed:	83 c4 0c             	add    $0xc,%esp
  f0:	50                   	push   %eax
  f1:	68 fc 04 00 00       	push   $0x4fc
  f6:	6a 01                	push   $0x1
  f8:	e8 05 03 00 00       	call   402 <write>
      exit();
  }

  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  fd:	e8 e0 02 00 00       	call   3e2 <exit>
  for(n=0; n<N; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
      exit();
 102:	e8 db 02 00 00       	call   3e2 <exit>
#define N  1000

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
 107:	83 ec 0c             	sub    $0xc,%esp
 10a:	68 c7 04 00 00       	push   $0x4c7
 10f:	e8 0c 01 00 00       	call   220 <strlen>
 114:	83 c4 0c             	add    $0xc,%esp
 117:	50                   	push   %eax
 118:	68 c7 04 00 00       	push   $0x4c7
 11d:	6a 01                	push   $0x1
 11f:	e8 de 02 00 00       	call   402 <write>
  }

  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
      exit();
 124:	e8 b9 02 00 00       	call   3e2 <exit>
#define N  1000

void
printf(int fd, const char *s, ...)
{
  write(fd, s, strlen(s));
 129:	83 ec 0c             	sub    $0xc,%esp
 12c:	68 db 04 00 00       	push   $0x4db
 131:	e8 ea 00 00 00       	call   220 <strlen>
 136:	83 c4 0c             	add    $0xc,%esp
 139:	50                   	push   %eax
 13a:	68 db 04 00 00       	push   $0x4db
 13f:	6a 01                	push   $0x1
 141:	e8 bc 02 00 00       	call   402 <write>
    }
  }

  if(wait() != -1){
    printf(1, "wait got too many\n");
    exit();
 146:	e8 97 02 00 00       	call   3e2 <exit>
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15a:	89 c2                	mov    %eax,%edx
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 160:	83 c1 01             	add    $0x1,%ecx
 163:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 167:	83 c2 01             	add    $0x1,%edx
 16a:	84 db                	test   %bl,%bl
 16c:	88 5a ff             	mov    %bl,-0x1(%edx)
 16f:	75 ef                	jne    160 <strcpy+0x10>
    ;
  return os;
}
 171:	5b                   	pop    %ebx
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 17a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
 186:	83 ec 0c             	sub    $0xc,%esp
 189:	8b 5d 08             	mov    0x8(%ebp),%ebx
 18c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q){
 18f:	0f be 03             	movsbl (%ebx),%eax
 192:	0f be 16             	movsbl (%esi),%edx
 195:	84 c0                	test   %al,%al
 197:	74 76                	je     20f <strcmp+0x8f>
 199:	38 c2                	cmp    %al,%dl
 19b:	89 f7                	mov    %esi,%edi
 19d:	74 0f                	je     1ae <strcmp+0x2e>
 19f:	eb 38                	jmp    1d9 <strcmp+0x59>
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a8:	38 d0                	cmp    %dl,%al
 1aa:	89 fe                	mov    %edi,%esi
 1ac:	75 2b                	jne    1d9 <strcmp+0x59>
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
 1ae:	0f be 46 01          	movsbl 0x1(%esi),%eax

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
    p++, q++;
 1b2:	83 c3 01             	add    $0x1,%ebx
 1b5:	8d 7e 01             	lea    0x1(%esi),%edi
	printf(2,"%c %c\n",*p,*q );
 1b8:	50                   	push   %eax
 1b9:	0f be 03             	movsbl (%ebx),%eax
 1bc:	50                   	push   %eax
 1bd:	68 1c 05 00 00       	push   $0x51c
 1c2:	6a 02                	push   $0x2
 1c4:	e8 57 fe ff ff       	call   20 <printf>
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 1c9:	0f be 03             	movsbl (%ebx),%eax
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	0f be 56 01          	movsbl 0x1(%esi),%edx
 1d3:	84 c0                	test   %al,%al
 1d5:	75 d1                	jne    1a8 <strcmp+0x28>
 1d7:	31 c0                	xor    %eax,%eax
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
 1d9:	52                   	push   %edx
 1da:	50                   	push   %eax
 1db:	68 23 05 00 00       	push   $0x523
 1e0:	6a 02                	push   $0x2
 1e2:	e8 39 fe ff ff       	call   20 <printf>
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
 1e7:	0f b6 17             	movzbl (%edi),%edx
 1ea:	0f b6 03             	movzbl (%ebx),%eax
 1ed:	83 c4 0c             	add    $0xc,%esp
 1f0:	29 d0                	sub    %edx,%eax
 1f2:	50                   	push   %eax
 1f3:	68 26 05 00 00       	push   $0x526
 1f8:	6a 02                	push   $0x2
 1fa:	e8 21 fe ff ff       	call   20 <printf>
  return (uchar)*p - (uchar)*q;
 1ff:	0f b6 03             	movzbl (%ebx),%eax
 202:	0f b6 17             	movzbl (%edi),%edx
}
 205:	8d 65 f4             	lea    -0xc(%ebp),%esp
 208:	5b                   	pop    %ebx
 209:	5e                   	pop    %esi
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 20a:	29 d0                	sub    %edx,%eax
}
 20c:	5f                   	pop    %edi
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret    
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 20f:	89 f7                	mov    %esi,%edi
 211:	31 c0                	xor    %eax,%eax
 213:	eb c4                	jmp    1d9 <strcmp+0x59>
 215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 226:	80 39 00             	cmpb   $0x0,(%ecx)
 229:	74 12                	je     23d <strlen+0x1d>
 22b:	31 d2                	xor    %edx,%edx
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	83 c2 01             	add    $0x1,%edx
 233:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 237:	89 d0                	mov    %edx,%eax
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 23d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    
 241:	eb 0d                	jmp    250 <memset>
 243:	90                   	nop
 244:	90                   	nop
 245:	90                   	nop
 246:	90                   	nop
 247:	90                   	nop
 248:	90                   	nop
 249:	90                   	nop
 24a:	90                   	nop
 24b:	90                   	nop
 24c:	90                   	nop
 24d:	90                   	nop
 24e:	90                   	nop
 24f:	90                   	nop

00000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 257:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 d7                	mov    %edx,%edi
 25f:	fc                   	cld    
 260:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 262:	89 d0                	mov    %edx,%eax
 264:	5f                   	pop    %edi
 265:	5d                   	pop    %ebp
 266:	c3                   	ret    
 267:	89 f6                	mov    %esi,%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	74 1d                	je     29e <strchr+0x2e>
    if(*s == c)
 281:	38 d3                	cmp    %dl,%bl
 283:	89 d9                	mov    %ebx,%ecx
 285:	75 0d                	jne    294 <strchr+0x24>
 287:	eb 17                	jmp    2a0 <strchr+0x30>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 290:	38 ca                	cmp    %cl,%dl
 292:	74 0c                	je     2a0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 294:	83 c0 01             	add    $0x1,%eax
 297:	0f b6 10             	movzbl (%eax),%edx
 29a:	84 d2                	test   %dl,%dl
 29c:	75 f2                	jne    290 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 29e:	31 c0                	xor    %eax,%eax
}
 2a0:	5b                   	pop    %ebx
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <gets>:

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 2b8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 2bb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2be:	eb 29                	jmp    2e9 <gets+0x39>
    cc = read(0, &c, 1);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	6a 01                	push   $0x1
 2c5:	57                   	push   %edi
 2c6:	6a 00                	push   $0x0
 2c8:	e8 2d 01 00 00       	call   3fa <read>
    if(cc < 1)
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7e 1d                	jle    2f1 <gets+0x41>
      break;
    buf[i++] = c;
 2d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d8:	8b 55 08             	mov    0x8(%ebp),%edx
 2db:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 2dd:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2df:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2e3:	74 1b                	je     300 <gets+0x50>
 2e5:	3c 0d                	cmp    $0xd,%al
 2e7:	74 17                	je     300 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e9:	8d 5e 01             	lea    0x1(%esi),%ebx
 2ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2ef:	7c cf                	jl     2c0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fb:	5b                   	pop    %ebx
 2fc:	5e                   	pop    %esi
 2fd:	5f                   	pop    %edi
 2fe:	5d                   	pop    %ebp
 2ff:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 300:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 303:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 305:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 309:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30c:	5b                   	pop    %ebx
 30d:	5e                   	pop    %esi
 30e:	5f                   	pop    %edi
 30f:	5d                   	pop    %ebp
 310:	c3                   	ret    
 311:	eb 0d                	jmp    320 <stat>
 313:	90                   	nop
 314:	90                   	nop
 315:	90                   	nop
 316:	90                   	nop
 317:	90                   	nop
 318:	90                   	nop
 319:	90                   	nop
 31a:	90                   	nop
 31b:	90                   	nop
 31c:	90                   	nop
 31d:	90                   	nop
 31e:	90                   	nop
 31f:	90                   	nop

00000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 325:	83 ec 08             	sub    $0x8,%esp
 328:	6a 00                	push   $0x0
 32a:	ff 75 08             	pushl  0x8(%ebp)
 32d:	e8 f0 00 00 00       	call   422 <open>
  if(fd < 0)
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 27                	js     360 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	pushl  0xc(%ebp)
 33f:	89 c3                	mov    %eax,%ebx
 341:	50                   	push   %eax
 342:	e8 f3 00 00 00       	call   43a <fstat>
 347:	89 c6                	mov    %eax,%esi
  close(fd);
 349:	89 1c 24             	mov    %ebx,(%esp)
 34c:	e8 b9 00 00 00       	call   40a <close>
  return r;
 351:	83 c4 10             	add    $0x10,%esp
 354:	89 f0                	mov    %esi,%eax
}
 356:	8d 65 f8             	lea    -0x8(%ebp),%esp
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret    
 35d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 365:	eb ef                	jmp    356 <stat+0x36>
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 11             	movsbl (%ecx),%edx
 37a:	8d 42 d0             	lea    -0x30(%edx),%eax
 37d:	3c 09                	cmp    $0x9,%al
 37f:	b8 00 00 00 00       	mov    $0x0,%eax
 384:	77 1f                	ja     3a5 <atoi+0x35>
 386:	8d 76 00             	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 390:	8d 04 80             	lea    (%eax,%eax,4),%eax
 393:	83 c1 01             	add    $0x1,%ecx
 396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39a:	0f be 11             	movsbl (%ecx),%edx
 39d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3a0:	80 fb 09             	cmp    $0x9,%bl
 3a3:	76 eb                	jbe    390 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3a5:	5b                   	pop    %ebx
 3a6:	5d                   	pop    %ebp
 3a7:	c3                   	ret    
 3a8:	90                   	nop
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	56                   	push   %esi
 3b4:	53                   	push   %ebx
 3b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3be:	85 db                	test   %ebx,%ebx
 3c0:	7e 14                	jle    3d6 <memmove+0x26>
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3cf:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3d2:	39 da                	cmp    %ebx,%edx
 3d4:	75 f2                	jne    3c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 3d6:	5b                   	pop    %ebx
 3d7:	5e                   	pop    %esi
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    

000003da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3da:	b8 01 00 00 00       	mov    $0x1,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <exit>:
SYSCALL(exit)
 3e2:	b8 02 00 00 00       	mov    $0x2,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <wait>:
SYSCALL(wait)
 3ea:	b8 03 00 00 00       	mov    $0x3,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <pipe>:
SYSCALL(pipe)
 3f2:	b8 04 00 00 00       	mov    $0x4,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <read>:
SYSCALL(read)
 3fa:	b8 05 00 00 00       	mov    $0x5,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <write>:
SYSCALL(write)
 402:	b8 10 00 00 00       	mov    $0x10,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <close>:
SYSCALL(close)
 40a:	b8 15 00 00 00       	mov    $0x15,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <kill>:
SYSCALL(kill)
 412:	b8 06 00 00 00       	mov    $0x6,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <exec>:
SYSCALL(exec)
 41a:	b8 07 00 00 00       	mov    $0x7,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <open>:
SYSCALL(open)
 422:	b8 0f 00 00 00       	mov    $0xf,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <mknod>:
SYSCALL(mknod)
 42a:	b8 11 00 00 00       	mov    $0x11,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <unlink>:
SYSCALL(unlink)
 432:	b8 12 00 00 00       	mov    $0x12,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <fstat>:
SYSCALL(fstat)
 43a:	b8 08 00 00 00       	mov    $0x8,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <link>:
SYSCALL(link)
 442:	b8 13 00 00 00       	mov    $0x13,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <mkdir>:
SYSCALL(mkdir)
 44a:	b8 14 00 00 00       	mov    $0x14,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <chdir>:
SYSCALL(chdir)
 452:	b8 09 00 00 00       	mov    $0x9,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <dup>:
SYSCALL(dup)
 45a:	b8 0a 00 00 00       	mov    $0xa,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <getpid>:
SYSCALL(getpid)
 462:	b8 0b 00 00 00       	mov    $0xb,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <sbrk>:
SYSCALL(sbrk)
 46a:	b8 0c 00 00 00       	mov    $0xc,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <sleep>:
SYSCALL(sleep)
 472:	b8 0d 00 00 00       	mov    $0xd,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <uptime>:
SYSCALL(uptime)
 47a:	b8 0e 00 00 00       	mov    $0xe,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <yield>:
SYSCALL(yield)
 482:	b8 16 00 00 00       	mov    $0x16,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <getlev>:
SYSCALL(getlev)
 48a:	b8 17 00 00 00       	mov    $0x17,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <setpriority>:
SYSCALL(setpriority)
 492:	b8 18 00 00 00       	mov    $0x18,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <getadmin>:
SYSCALL(getadmin)
 49a:	b8 19 00 00 00       	mov    $0x19,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <exec2>:
SYSCALL(exec2)
 4a2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <setmemorylimit>:
SYSCALL(setmemorylimit)
 4aa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <list>:
SYSCALL(list)
 4b2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    
