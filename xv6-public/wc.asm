
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	be 01 00 00 00       	mov    $0x1,%esi
  16:	83 ec 18             	sub    $0x18,%esp
  19:	8b 01                	mov    (%ecx),%eax
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  21:	83 f8 01             	cmp    $0x1,%eax
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
  24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;

  if(argc <= 1){
  27:	7e 56                	jle    7f <main+0x7f>
  29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	pushl  (%ebx)
  37:	e8 16 04 00 00       	call   452 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	85 c0                	test   %eax,%eax
  41:	89 c7                	mov    %eax,%edi
  43:	78 26                	js     6b <main+0x6b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  45:	83 ec 08             	sub    $0x8,%esp
  48:	ff 33                	pushl  (%ebx)
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  4a:	83 c6 01             	add    $0x1,%esi
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  4d:	50                   	push   %eax
  4e:	83 c3 04             	add    $0x4,%ebx
  51:	e8 4a 00 00 00       	call   a0 <wc>
    close(fd);
  56:	89 3c 24             	mov    %edi,(%esp)
  59:	e8 dc 03 00 00       	call   43a <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  5e:	83 c4 10             	add    $0x10,%esp
  61:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  64:	75 ca                	jne    30 <main+0x30>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
  66:	e8 a7 03 00 00       	call   412 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
  6b:	50                   	push   %eax
  6c:	ff 33                	pushl  (%ebx)
  6e:	68 d3 08 00 00       	push   $0x8d3
  73:	6a 01                	push   $0x1
  75:	e8 16 05 00 00       	call   590 <printf>
      exit();
  7a:	e8 93 03 00 00       	call   412 <exit>
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    wc(0, "");
  7f:	52                   	push   %edx
  80:	52                   	push   %edx
  81:	68 ed 08 00 00       	push   $0x8ed
  86:	6a 00                	push   $0x0
  88:	e8 13 00 00 00       	call   a0 <wc>
    exit();
  8d:	e8 80 03 00 00       	call   412 <exit>
  92:	66 90                	xchg   %ax,%ax
  94:	66 90                	xchg   %ax,%ax
  96:	66 90                	xchg   %ax,%ax
  98:	66 90                	xchg   %ax,%ax
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  a6:	31 f6                	xor    %esi,%esi
wc(int fd, char *name)
{
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  a8:	31 db                	xor    %ebx,%ebx

char buf[512];

void
wc(int fd, char *name)
{
  aa:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  ad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  b4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  bb:	90                   	nop
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	68 00 02 00 00       	push   $0x200
  c8:	68 00 0c 00 00       	push   $0xc00
  cd:	ff 75 08             	pushl  0x8(%ebp)
  d0:	e8 55 03 00 00       	call   42a <read>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	83 f8 00             	cmp    $0x0,%eax
  db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  de:	7e 5f                	jle    13f <wc+0x9f>
  e0:	31 ff                	xor    %edi,%edi
  e2:	eb 0e                	jmp    f2 <wc+0x52>
  e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
  e8:	31 f6                	xor    %esi,%esi
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  ea:	83 c7 01             	add    $0x1,%edi
  ed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  f0:	74 3a                	je     12c <wc+0x8c>
      c++;
      if(buf[i] == '\n')
  f2:	0f be 87 00 0c 00 00 	movsbl 0xc00(%edi),%eax
        l++;
  f9:	31 c9                	xor    %ecx,%ecx
  fb:	3c 0a                	cmp    $0xa,%al
  fd:	0f 94 c1             	sete   %cl
      if(strchr(" \r\t\n\v", buf[i]))
 100:	83 ec 08             	sub    $0x8,%esp
 103:	50                   	push   %eax
 104:	68 b0 08 00 00       	push   $0x8b0
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
 109:	01 cb                	add    %ecx,%ebx
      if(strchr(" \r\t\n\v", buf[i]))
 10b:	e8 90 01 00 00       	call   2a0 <strchr>
 110:	83 c4 10             	add    $0x10,%esp
 113:	85 c0                	test   %eax,%eax
 115:	75 d1                	jne    e8 <wc+0x48>
        inword = 0;
      else if(!inword){
 117:	85 f6                	test   %esi,%esi
 119:	75 1d                	jne    138 <wc+0x98>
        w++;
 11b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
 11f:	83 c7 01             	add    $0x1,%edi
 122:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
        inword = 1;
 125:	be 01 00 00 00       	mov    $0x1,%esi
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
 12a:	75 c6                	jne    f2 <wc+0x52>
 12c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 12f:	01 55 dc             	add    %edx,-0x24(%ebp)
 132:	eb 8c                	jmp    c0 <wc+0x20>
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 138:	be 01 00 00 00       	mov    $0x1,%esi
 13d:	eb ab                	jmp    ea <wc+0x4a>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
 13f:	75 24                	jne    165 <wc+0xc5>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
 141:	83 ec 08             	sub    $0x8,%esp
 144:	ff 75 0c             	pushl  0xc(%ebp)
 147:	ff 75 dc             	pushl  -0x24(%ebp)
 14a:	ff 75 e0             	pushl  -0x20(%ebp)
 14d:	53                   	push   %ebx
 14e:	68 c6 08 00 00       	push   $0x8c6
 153:	6a 01                	push   $0x1
 155:	e8 36 04 00 00       	call   590 <printf>
}
 15a:	83 c4 20             	add    $0x20,%esp
 15d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 160:	5b                   	pop    %ebx
 161:	5e                   	pop    %esi
 162:	5f                   	pop    %edi
 163:	5d                   	pop    %ebp
 164:	c3                   	ret    
        inword = 1;
      }
    }
  }
  if(n < 0){
    printf(1, "wc: read error\n");
 165:	83 ec 08             	sub    $0x8,%esp
 168:	68 b6 08 00 00       	push   $0x8b6
 16d:	6a 01                	push   $0x1
 16f:	e8 1c 04 00 00       	call   590 <printf>
    exit();
 174:	e8 99 02 00 00       	call   412 <exit>
 179:	66 90                	xchg   %ax,%ax
 17b:	66 90                	xchg   %ax,%ax
 17d:	66 90                	xchg   %ax,%ax
 17f:	90                   	nop

00000180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18a:	89 c2                	mov    %eax,%edx
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 190:	83 c1 01             	add    $0x1,%ecx
 193:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 197:	83 c2 01             	add    $0x1,%edx
 19a:	84 db                	test   %bl,%bl
 19c:	88 5a ff             	mov    %bl,-0x1(%edx)
 19f:	75 ef                	jne    190 <strcpy+0x10>
    ;
  return os;
}
 1a1:	5b                   	pop    %ebx
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    
 1a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	83 ec 0c             	sub    $0xc,%esp
 1b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q){
 1bf:	0f be 03             	movsbl (%ebx),%eax
 1c2:	0f be 16             	movsbl (%esi),%edx
 1c5:	84 c0                	test   %al,%al
 1c7:	74 76                	je     23f <strcmp+0x8f>
 1c9:	38 c2                	cmp    %al,%dl
 1cb:	89 f7                	mov    %esi,%edi
 1cd:	74 0f                	je     1de <strcmp+0x2e>
 1cf:	eb 38                	jmp    209 <strcmp+0x59>
 1d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d8:	38 d0                	cmp    %dl,%al
 1da:	89 fe                	mov    %edi,%esi
 1dc:	75 2b                	jne    209 <strcmp+0x59>
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
 1de:	0f be 46 01          	movsbl 0x1(%esi),%eax

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
    p++, q++;
 1e2:	83 c3 01             	add    $0x1,%ebx
 1e5:	8d 7e 01             	lea    0x1(%esi),%edi
	printf(2,"%c %c\n",*p,*q );
 1e8:	50                   	push   %eax
 1e9:	0f be 03             	movsbl (%ebx),%eax
 1ec:	50                   	push   %eax
 1ed:	68 e7 08 00 00       	push   $0x8e7
 1f2:	6a 02                	push   $0x2
 1f4:	e8 97 03 00 00       	call   590 <printf>
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 1f9:	0f be 03             	movsbl (%ebx),%eax
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	0f be 56 01          	movsbl 0x1(%esi),%edx
 203:	84 c0                	test   %al,%al
 205:	75 d1                	jne    1d8 <strcmp+0x28>
 207:	31 c0                	xor    %eax,%eax
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
 209:	52                   	push   %edx
 20a:	50                   	push   %eax
 20b:	68 ee 08 00 00       	push   $0x8ee
 210:	6a 02                	push   $0x2
 212:	e8 79 03 00 00       	call   590 <printf>
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
 217:	0f b6 17             	movzbl (%edi),%edx
 21a:	0f b6 03             	movzbl (%ebx),%eax
 21d:	83 c4 0c             	add    $0xc,%esp
 220:	29 d0                	sub    %edx,%eax
 222:	50                   	push   %eax
 223:	68 f1 08 00 00       	push   $0x8f1
 228:	6a 02                	push   $0x2
 22a:	e8 61 03 00 00       	call   590 <printf>
  return (uchar)*p - (uchar)*q;
 22f:	0f b6 03             	movzbl (%ebx),%eax
 232:	0f b6 17             	movzbl (%edi),%edx
}
 235:	8d 65 f4             	lea    -0xc(%ebp),%esp
 238:	5b                   	pop    %ebx
 239:	5e                   	pop    %esi
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 23a:	29 d0                	sub    %edx,%eax
}
 23c:	5f                   	pop    %edi
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret    
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 23f:	89 f7                	mov    %esi,%edi
 241:	31 c0                	xor    %eax,%eax
 243:	eb c4                	jmp    209 <strcmp+0x59>
 245:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 256:	80 39 00             	cmpb   $0x0,(%ecx)
 259:	74 12                	je     26d <strlen+0x1d>
 25b:	31 d2                	xor    %edx,%edx
 25d:	8d 76 00             	lea    0x0(%esi),%esi
 260:	83 c2 01             	add    $0x1,%edx
 263:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 267:	89 d0                	mov    %edx,%eax
 269:	75 f5                	jne    260 <strlen+0x10>
    ;
  return n;
}
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 26d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 26f:	5d                   	pop    %ebp
 270:	c3                   	ret    
 271:	eb 0d                	jmp    280 <memset>
 273:	90                   	nop
 274:	90                   	nop
 275:	90                   	nop
 276:	90                   	nop
 277:	90                   	nop
 278:	90                   	nop
 279:	90                   	nop
 27a:	90                   	nop
 27b:	90                   	nop
 27c:	90                   	nop
 27d:	90                   	nop
 27e:	90                   	nop
 27f:	90                   	nop

00000280 <memset>:

void*
memset(void *dst, int c, uint n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 287:	8b 4d 10             	mov    0x10(%ebp),%ecx
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	89 d7                	mov    %edx,%edi
 28f:	fc                   	cld    
 290:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 292:	89 d0                	mov    %edx,%eax
 294:	5f                   	pop    %edi
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    
 297:	89 f6                	mov    %esi,%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <strchr>:

char*
strchr(const char *s, char c)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2aa:	0f b6 10             	movzbl (%eax),%edx
 2ad:	84 d2                	test   %dl,%dl
 2af:	74 1d                	je     2ce <strchr+0x2e>
    if(*s == c)
 2b1:	38 d3                	cmp    %dl,%bl
 2b3:	89 d9                	mov    %ebx,%ecx
 2b5:	75 0d                	jne    2c4 <strchr+0x24>
 2b7:	eb 17                	jmp    2d0 <strchr+0x30>
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2c0:	38 ca                	cmp    %cl,%dl
 2c2:	74 0c                	je     2d0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c4:	83 c0 01             	add    $0x1,%eax
 2c7:	0f b6 10             	movzbl (%eax),%edx
 2ca:	84 d2                	test   %dl,%dl
 2cc:	75 f2                	jne    2c0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2ce:	31 c0                	xor    %eax,%eax
}
 2d0:	5b                   	pop    %ebx
 2d1:	5d                   	pop    %ebp
 2d2:	c3                   	ret    
 2d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <gets>:

char*
gets(char *buf, int max)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	56                   	push   %esi
 2e5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 2e8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 2eb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ee:	eb 29                	jmp    319 <gets+0x39>
    cc = read(0, &c, 1);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	6a 01                	push   $0x1
 2f5:	57                   	push   %edi
 2f6:	6a 00                	push   $0x0
 2f8:	e8 2d 01 00 00       	call   42a <read>
    if(cc < 1)
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	7e 1d                	jle    321 <gets+0x41>
      break;
    buf[i++] = c;
 304:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 308:	8b 55 08             	mov    0x8(%ebp),%edx
 30b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 30d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 30f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 313:	74 1b                	je     330 <gets+0x50>
 315:	3c 0d                	cmp    $0xd,%al
 317:	74 17                	je     330 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 319:	8d 5e 01             	lea    0x1(%esi),%ebx
 31c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 31f:	7c cf                	jl     2f0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 328:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32b:	5b                   	pop    %ebx
 32c:	5e                   	pop    %esi
 32d:	5f                   	pop    %edi
 32e:	5d                   	pop    %ebp
 32f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 330:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 333:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 335:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 339:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33c:	5b                   	pop    %ebx
 33d:	5e                   	pop    %esi
 33e:	5f                   	pop    %edi
 33f:	5d                   	pop    %ebp
 340:	c3                   	ret    
 341:	eb 0d                	jmp    350 <stat>
 343:	90                   	nop
 344:	90                   	nop
 345:	90                   	nop
 346:	90                   	nop
 347:	90                   	nop
 348:	90                   	nop
 349:	90                   	nop
 34a:	90                   	nop
 34b:	90                   	nop
 34c:	90                   	nop
 34d:	90                   	nop
 34e:	90                   	nop
 34f:	90                   	nop

00000350 <stat>:

int
stat(const char *n, struct stat *st)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	56                   	push   %esi
 354:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 355:	83 ec 08             	sub    $0x8,%esp
 358:	6a 00                	push   $0x0
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	e8 f0 00 00 00       	call   452 <open>
  if(fd < 0)
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
 367:	78 27                	js     390 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 369:	83 ec 08             	sub    $0x8,%esp
 36c:	ff 75 0c             	pushl  0xc(%ebp)
 36f:	89 c3                	mov    %eax,%ebx
 371:	50                   	push   %eax
 372:	e8 f3 00 00 00       	call   46a <fstat>
 377:	89 c6                	mov    %eax,%esi
  close(fd);
 379:	89 1c 24             	mov    %ebx,(%esp)
 37c:	e8 b9 00 00 00       	call   43a <close>
  return r;
 381:	83 c4 10             	add    $0x10,%esp
 384:	89 f0                	mov    %esi,%eax
}
 386:	8d 65 f8             	lea    -0x8(%ebp),%esp
 389:	5b                   	pop    %ebx
 38a:	5e                   	pop    %esi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
 38d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 395:	eb ef                	jmp    386 <stat+0x36>
 397:	89 f6                	mov    %esi,%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3a7:	0f be 11             	movsbl (%ecx),%edx
 3aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 3ad:	3c 09                	cmp    $0x9,%al
 3af:	b8 00 00 00 00       	mov    $0x0,%eax
 3b4:	77 1f                	ja     3d5 <atoi+0x35>
 3b6:	8d 76 00             	lea    0x0(%esi),%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3c3:	83 c1 01             	add    $0x1,%ecx
 3c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ca:	0f be 11             	movsbl (%ecx),%edx
 3cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3d0:	80 fb 09             	cmp    $0x9,%bl
 3d3:	76 eb                	jbe    3c0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3d5:	5b                   	pop    %ebx
 3d6:	5d                   	pop    %ebp
 3d7:	c3                   	ret    
 3d8:	90                   	nop
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
 3e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ee:	85 db                	test   %ebx,%ebx
 3f0:	7e 14                	jle    406 <memmove+0x26>
 3f2:	31 d2                	xor    %edx,%edx
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3ff:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 402:	39 da                	cmp    %ebx,%edx
 404:	75 f2                	jne    3f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 406:	5b                   	pop    %ebx
 407:	5e                   	pop    %esi
 408:	5d                   	pop    %ebp
 409:	c3                   	ret    

0000040a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40a:	b8 01 00 00 00       	mov    $0x1,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <exit>:
SYSCALL(exit)
 412:	b8 02 00 00 00       	mov    $0x2,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <wait>:
SYSCALL(wait)
 41a:	b8 03 00 00 00       	mov    $0x3,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <pipe>:
SYSCALL(pipe)
 422:	b8 04 00 00 00       	mov    $0x4,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <read>:
SYSCALL(read)
 42a:	b8 05 00 00 00       	mov    $0x5,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <write>:
SYSCALL(write)
 432:	b8 10 00 00 00       	mov    $0x10,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <close>:
SYSCALL(close)
 43a:	b8 15 00 00 00       	mov    $0x15,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <kill>:
SYSCALL(kill)
 442:	b8 06 00 00 00       	mov    $0x6,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <exec>:
SYSCALL(exec)
 44a:	b8 07 00 00 00       	mov    $0x7,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <open>:
SYSCALL(open)
 452:	b8 0f 00 00 00       	mov    $0xf,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <mknod>:
SYSCALL(mknod)
 45a:	b8 11 00 00 00       	mov    $0x11,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <unlink>:
SYSCALL(unlink)
 462:	b8 12 00 00 00       	mov    $0x12,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <fstat>:
SYSCALL(fstat)
 46a:	b8 08 00 00 00       	mov    $0x8,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <link>:
SYSCALL(link)
 472:	b8 13 00 00 00       	mov    $0x13,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mkdir>:
SYSCALL(mkdir)
 47a:	b8 14 00 00 00       	mov    $0x14,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <chdir>:
SYSCALL(chdir)
 482:	b8 09 00 00 00       	mov    $0x9,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <dup>:
SYSCALL(dup)
 48a:	b8 0a 00 00 00       	mov    $0xa,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <getpid>:
SYSCALL(getpid)
 492:	b8 0b 00 00 00       	mov    $0xb,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <sbrk>:
SYSCALL(sbrk)
 49a:	b8 0c 00 00 00       	mov    $0xc,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <sleep>:
SYSCALL(sleep)
 4a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <uptime>:
SYSCALL(uptime)
 4aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <yield>:
SYSCALL(yield)
 4b2:	b8 16 00 00 00       	mov    $0x16,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <getlev>:
SYSCALL(getlev)
 4ba:	b8 17 00 00 00       	mov    $0x17,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <setpriority>:
SYSCALL(setpriority)
 4c2:	b8 18 00 00 00       	mov    $0x18,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <getadmin>:
SYSCALL(getadmin)
 4ca:	b8 19 00 00 00       	mov    $0x19,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <exec2>:
SYSCALL(exec2)
 4d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <setmemorylimit>:
SYSCALL(setmemorylimit)
 4da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <list>:
SYSCALL(list)
 4e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    
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
 531:	0f b6 92 fc 08 00 00 	movzbl 0x8fc(%edx),%edx
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
 568:	e8 c5 fe ff ff       	call   432 <write>
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
 5da:	e8 53 fe ff ff       	call   432 <write>
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
 63c:	e8 f1 fd ff ff       	call   432 <write>
 641:	83 c4 0c             	add    $0xc,%esp
 644:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 647:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 64a:	6a 01                	push   $0x1
 64c:	50                   	push   %eax
 64d:	57                   	push   %edi
 64e:	83 c6 01             	add    $0x1,%esi
 651:	e8 dc fd ff ff       	call   432 <write>
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
 6ab:	b8 f5 08 00 00       	mov    $0x8f5,%eax
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
 6d0:	e8 5d fd ff ff       	call   432 <write>
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
 721:	e8 0c fd ff ff       	call   432 <write>
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
 731:	a1 e0 0b 00 00       	mov    0xbe0,%eax
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
 789:	a3 e0 0b 00 00       	mov    %eax,0xbe0
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
 7ad:	a3 e0 0b 00 00       	mov    %eax,0xbe0
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
 7cc:	8b 15 e0 0b 00 00    	mov    0xbe0,%edx
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
 821:	39 05 e0 0b 00 00    	cmp    %eax,0xbe0
 827:	89 c2                	mov    %eax,%edx
 829:	75 ed                	jne    818 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	53                   	push   %ebx
 82f:	e8 66 fc ff ff       	call   49a <sbrk>
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
 84b:	8b 15 e0 0b 00 00    	mov    0xbe0,%edx
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
 86f:	89 15 e0 0b 00 00    	mov    %edx,0xbe0
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
 886:	c7 05 e0 0b 00 00 e4 	movl   $0xbe4,0xbe0
 88d:	0b 00 00 
 890:	c7 05 e4 0b 00 00 e4 	movl   $0xbe4,0xbe4
 897:	0b 00 00 
    base.s.size = 0;
 89a:	b8 e4 0b 00 00       	mov    $0xbe4,%eax
 89f:	c7 05 e8 0b 00 00 00 	movl   $0x0,0xbe8
 8a6:	00 00 00 
 8a9:	e9 3e ff ff ff       	jmp    7ec <malloc+0x2c>
