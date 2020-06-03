
_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

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
  11:	bf 01 00 00 00       	mov    $0x1,%edi
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	83 c3 04             	add    $0x4,%ebx
  int i;

  if(argc < 2){
  21:	83 fe 01             	cmp    $0x1,%esi
  24:	7e 3e                	jle    64 <main+0x64>
  26:	8d 76 00             	lea    0x0(%esi),%esi
  29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	ff 33                	pushl  (%ebx)
  35:	e8 40 03 00 00       	call   37a <mkdir>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	78 0f                	js     50 <main+0x50>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  41:	83 c7 01             	add    $0x1,%edi
  44:	83 c3 04             	add    $0x4,%ebx
  47:	39 fe                	cmp    %edi,%esi
  49:	75 e5                	jne    30 <main+0x30>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  4b:	e8 c2 02 00 00       	call   312 <exit>
    exit();
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	50                   	push   %eax
  51:	ff 33                	pushl  (%ebx)
  53:	68 c7 07 00 00       	push   $0x7c7
  58:	6a 02                	push   $0x2
  5a:	e8 31 04 00 00       	call   490 <printf>
      break;
  5f:	83 c4 10             	add    $0x10,%esp
  62:	eb e7                	jmp    4b <main+0x4b>
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
  64:	52                   	push   %edx
  65:	52                   	push   %edx
  66:	68 b0 07 00 00       	push   $0x7b0
  6b:	6a 02                	push   $0x2
  6d:	e8 1e 04 00 00       	call   490 <printf>
    exit();
  72:	e8 9b 02 00 00       	call   312 <exit>
  77:	66 90                	xchg   %ax,%ax
  79:	66 90                	xchg   %ax,%ax
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	8b 45 08             	mov    0x8(%ebp),%eax
  87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	89 c2                	mov    %eax,%edx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	83 c1 01             	add    $0x1,%ecx
  93:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 db                	test   %bl,%bl
  9c:	88 5a ff             	mov    %bl,-0x1(%edx)
  9f:	75 ef                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  a1:	5b                   	pop    %ebx
  a2:	5d                   	pop    %ebp
  a3:	c3                   	ret    
  a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q){
  bf:	0f be 03             	movsbl (%ebx),%eax
  c2:	0f be 16             	movsbl (%esi),%edx
  c5:	84 c0                	test   %al,%al
  c7:	74 76                	je     13f <strcmp+0x8f>
  c9:	38 c2                	cmp    %al,%dl
  cb:	89 f7                	mov    %esi,%edi
  cd:	74 0f                	je     de <strcmp+0x2e>
  cf:	eb 38                	jmp    109 <strcmp+0x59>
  d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d8:	38 d0                	cmp    %dl,%al
  da:	89 fe                	mov    %edi,%esi
  dc:	75 2b                	jne    109 <strcmp+0x59>
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  de:	0f be 46 01          	movsbl 0x1(%esi),%eax

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
    p++, q++;
  e2:	83 c3 01             	add    $0x1,%ebx
  e5:	8d 7e 01             	lea    0x1(%esi),%edi
	printf(2,"%c %c\n",*p,*q );
  e8:	50                   	push   %eax
  e9:	0f be 03             	movsbl (%ebx),%eax
  ec:	50                   	push   %eax
  ed:	68 e3 07 00 00       	push   $0x7e3
  f2:	6a 02                	push   $0x2
  f4:	e8 97 03 00 00       	call   490 <printf>
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
  f9:	0f be 03             	movsbl (%ebx),%eax
  fc:	83 c4 10             	add    $0x10,%esp
  ff:	0f be 56 01          	movsbl 0x1(%esi),%edx
 103:	84 c0                	test   %al,%al
 105:	75 d1                	jne    d8 <strcmp+0x28>
 107:	31 c0                	xor    %eax,%eax
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
 109:	52                   	push   %edx
 10a:	50                   	push   %eax
 10b:	68 ea 07 00 00       	push   $0x7ea
 110:	6a 02                	push   $0x2
 112:	e8 79 03 00 00       	call   490 <printf>
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
 117:	0f b6 17             	movzbl (%edi),%edx
 11a:	0f b6 03             	movzbl (%ebx),%eax
 11d:	83 c4 0c             	add    $0xc,%esp
 120:	29 d0                	sub    %edx,%eax
 122:	50                   	push   %eax
 123:	68 ed 07 00 00       	push   $0x7ed
 128:	6a 02                	push   $0x2
 12a:	e8 61 03 00 00       	call   490 <printf>
  return (uchar)*p - (uchar)*q;
 12f:	0f b6 03             	movzbl (%ebx),%eax
 132:	0f b6 17             	movzbl (%edi),%edx
}
 135:	8d 65 f4             	lea    -0xc(%ebp),%esp
 138:	5b                   	pop    %ebx
 139:	5e                   	pop    %esi
    p++, q++;
	printf(2,"%c %c\n",*p,*q );
  }
  printf(2,"%d %d\n",*p,*q);
  printf(2,"%d\n",(uchar)*p - (uchar)*q);
  return (uchar)*p - (uchar)*q;
 13a:	29 d0                	sub    %edx,%eax
}
 13c:	5f                   	pop    %edi
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q){
 13f:	89 f7                	mov    %esi,%edi
 141:	31 c0                	xor    %eax,%eax
 143:	eb c4                	jmp    109 <strcmp+0x59>
 145:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000150 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 156:	80 39 00             	cmpb   $0x0,(%ecx)
 159:	74 12                	je     16d <strlen+0x1d>
 15b:	31 d2                	xor    %edx,%edx
 15d:	8d 76 00             	lea    0x0(%esi),%esi
 160:	83 c2 01             	add    $0x1,%edx
 163:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 167:	89 d0                	mov    %edx,%eax
 169:	75 f5                	jne    160 <strlen+0x10>
    ;
  return n;
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 16d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    
 171:	eb 0d                	jmp    180 <memset>
 173:	90                   	nop
 174:	90                   	nop
 175:	90                   	nop
 176:	90                   	nop
 177:	90                   	nop
 178:	90                   	nop
 179:	90                   	nop
 17a:	90                   	nop
 17b:	90                   	nop
 17c:	90                   	nop
 17d:	90                   	nop
 17e:	90                   	nop
 17f:	90                   	nop

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 187:	8b 4d 10             	mov    0x10(%ebp),%ecx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	89 d7                	mov    %edx,%edi
 18f:	fc                   	cld    
 190:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 192:	89 d0                	mov    %edx,%eax
 194:	5f                   	pop    %edi
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	89 f6                	mov    %esi,%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1aa:	0f b6 10             	movzbl (%eax),%edx
 1ad:	84 d2                	test   %dl,%dl
 1af:	74 1d                	je     1ce <strchr+0x2e>
    if(*s == c)
 1b1:	38 d3                	cmp    %dl,%bl
 1b3:	89 d9                	mov    %ebx,%ecx
 1b5:	75 0d                	jne    1c4 <strchr+0x24>
 1b7:	eb 17                	jmp    1d0 <strchr+0x30>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1c0:	38 ca                	cmp    %cl,%dl
 1c2:	74 0c                	je     1d0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	0f b6 10             	movzbl (%eax),%edx
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1ce:	31 c0                	xor    %eax,%eax
}
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <gets>:

char*
gets(char *buf, int max)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
 1e5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 1e8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 1eb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	eb 29                	jmp    219 <gets+0x39>
    cc = read(0, &c, 1);
 1f0:	83 ec 04             	sub    $0x4,%esp
 1f3:	6a 01                	push   $0x1
 1f5:	57                   	push   %edi
 1f6:	6a 00                	push   $0x0
 1f8:	e8 2d 01 00 00       	call   32a <read>
    if(cc < 1)
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	85 c0                	test   %eax,%eax
 202:	7e 1d                	jle    221 <gets+0x41>
      break;
    buf[i++] = c;
 204:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 208:	8b 55 08             	mov    0x8(%ebp),%edx
 20b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 20d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 20f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 213:	74 1b                	je     230 <gets+0x50>
 215:	3c 0d                	cmp    $0xd,%al
 217:	74 17                	je     230 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 219:	8d 5e 01             	lea    0x1(%esi),%ebx
 21c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 21f:	7c cf                	jl     1f0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 228:	8d 65 f4             	lea    -0xc(%ebp),%esp
 22b:	5b                   	pop    %ebx
 22c:	5e                   	pop    %esi
 22d:	5f                   	pop    %edi
 22e:	5d                   	pop    %ebp
 22f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 230:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 233:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 235:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 239:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23c:	5b                   	pop    %ebx
 23d:	5e                   	pop    %esi
 23e:	5f                   	pop    %edi
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    
 241:	eb 0d                	jmp    250 <stat>
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

00000250 <stat>:

int
stat(const char *n, struct stat *st)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 255:	83 ec 08             	sub    $0x8,%esp
 258:	6a 00                	push   $0x0
 25a:	ff 75 08             	pushl  0x8(%ebp)
 25d:	e8 f0 00 00 00       	call   352 <open>
  if(fd < 0)
 262:	83 c4 10             	add    $0x10,%esp
 265:	85 c0                	test   %eax,%eax
 267:	78 27                	js     290 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 269:	83 ec 08             	sub    $0x8,%esp
 26c:	ff 75 0c             	pushl  0xc(%ebp)
 26f:	89 c3                	mov    %eax,%ebx
 271:	50                   	push   %eax
 272:	e8 f3 00 00 00       	call   36a <fstat>
 277:	89 c6                	mov    %eax,%esi
  close(fd);
 279:	89 1c 24             	mov    %ebx,(%esp)
 27c:	e8 b9 00 00 00       	call   33a <close>
  return r;
 281:	83 c4 10             	add    $0x10,%esp
 284:	89 f0                	mov    %esi,%eax
}
 286:	8d 65 f8             	lea    -0x8(%ebp),%esp
 289:	5b                   	pop    %ebx
 28a:	5e                   	pop    %esi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
 28d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 295:	eb ef                	jmp    286 <stat+0x36>
 297:	89 f6                	mov    %esi,%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a7:	0f be 11             	movsbl (%ecx),%edx
 2aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ad:	3c 09                	cmp    $0x9,%al
 2af:	b8 00 00 00 00       	mov    $0x0,%eax
 2b4:	77 1f                	ja     2d5 <atoi+0x35>
 2b6:	8d 76 00             	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2c3:	83 c1 01             	add    $0x1,%ecx
 2c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ca:	0f be 11             	movsbl (%ecx),%edx
 2cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2d0:	80 fb 09             	cmp    $0x9,%bl
 2d3:	76 eb                	jbe    2c0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 2d5:	5b                   	pop    %ebx
 2d6:	5d                   	pop    %ebp
 2d7:	c3                   	ret    
 2d8:	90                   	nop
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
 2e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ee:	85 db                	test   %ebx,%ebx
 2f0:	7e 14                	jle    306 <memmove+0x26>
 2f2:	31 d2                	xor    %edx,%edx
 2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ff:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 302:	39 da                	cmp    %ebx,%edx
 304:	75 f2                	jne    2f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 306:	5b                   	pop    %ebx
 307:	5e                   	pop    %esi
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    

0000030a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30a:	b8 01 00 00 00       	mov    $0x1,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <exit>:
SYSCALL(exit)
 312:	b8 02 00 00 00       	mov    $0x2,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <wait>:
SYSCALL(wait)
 31a:	b8 03 00 00 00       	mov    $0x3,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <pipe>:
SYSCALL(pipe)
 322:	b8 04 00 00 00       	mov    $0x4,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <read>:
SYSCALL(read)
 32a:	b8 05 00 00 00       	mov    $0x5,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <write>:
SYSCALL(write)
 332:	b8 10 00 00 00       	mov    $0x10,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <close>:
SYSCALL(close)
 33a:	b8 15 00 00 00       	mov    $0x15,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <kill>:
SYSCALL(kill)
 342:	b8 06 00 00 00       	mov    $0x6,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <exec>:
SYSCALL(exec)
 34a:	b8 07 00 00 00       	mov    $0x7,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <open>:
SYSCALL(open)
 352:	b8 0f 00 00 00       	mov    $0xf,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mknod>:
SYSCALL(mknod)
 35a:	b8 11 00 00 00       	mov    $0x11,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <unlink>:
SYSCALL(unlink)
 362:	b8 12 00 00 00       	mov    $0x12,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <fstat>:
SYSCALL(fstat)
 36a:	b8 08 00 00 00       	mov    $0x8,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <link>:
SYSCALL(link)
 372:	b8 13 00 00 00       	mov    $0x13,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mkdir>:
SYSCALL(mkdir)
 37a:	b8 14 00 00 00       	mov    $0x14,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <chdir>:
SYSCALL(chdir)
 382:	b8 09 00 00 00       	mov    $0x9,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <dup>:
SYSCALL(dup)
 38a:	b8 0a 00 00 00       	mov    $0xa,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <getpid>:
SYSCALL(getpid)
 392:	b8 0b 00 00 00       	mov    $0xb,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <sbrk>:
SYSCALL(sbrk)
 39a:	b8 0c 00 00 00       	mov    $0xc,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <sleep>:
SYSCALL(sleep)
 3a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <uptime>:
SYSCALL(uptime)
 3aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <yield>:
SYSCALL(yield)
 3b2:	b8 16 00 00 00       	mov    $0x16,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <getlev>:
SYSCALL(getlev)
 3ba:	b8 17 00 00 00       	mov    $0x17,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <setpriority>:
SYSCALL(setpriority)
 3c2:	b8 18 00 00 00       	mov    $0x18,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <getadmin>:
SYSCALL(getadmin)
 3ca:	b8 19 00 00 00       	mov    $0x19,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <exec2>:
SYSCALL(exec2)
 3d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <setmemorylimit>:
SYSCALL(setmemorylimit)
 3da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <list>:
SYSCALL(list)
 3e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    
 3ea:	66 90                	xchg   %ax,%ax
 3ec:	66 90                	xchg   %ax,%ax
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	89 c6                	mov    %eax,%esi
 3f8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3fe:	85 db                	test   %ebx,%ebx
 400:	74 7e                	je     480 <printint+0x90>
 402:	89 d0                	mov    %edx,%eax
 404:	c1 e8 1f             	shr    $0x1f,%eax
 407:	84 c0                	test   %al,%al
 409:	74 75                	je     480 <printint+0x90>
    neg = 1;
    x = -xx;
 40b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 40d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 414:	f7 d8                	neg    %eax
 416:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 419:	31 ff                	xor    %edi,%edi
 41b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 41e:	89 ce                	mov    %ecx,%esi
 420:	eb 08                	jmp    42a <printint+0x3a>
 422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 428:	89 cf                	mov    %ecx,%edi
 42a:	31 d2                	xor    %edx,%edx
 42c:	8d 4f 01             	lea    0x1(%edi),%ecx
 42f:	f7 f6                	div    %esi
 431:	0f b6 92 f8 07 00 00 	movzbl 0x7f8(%edx),%edx
  }while((x /= base) != 0);
 438:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 43a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 43d:	75 e9                	jne    428 <printint+0x38>
  if(neg)
 43f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 442:	8b 75 c0             	mov    -0x40(%ebp),%esi
 445:	85 c0                	test   %eax,%eax
 447:	74 08                	je     451 <printint+0x61>
    buf[i++] = '-';
 449:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 44e:	8d 4f 02             	lea    0x2(%edi),%ecx
 451:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 455:	8d 76 00             	lea    0x0(%esi),%esi
 458:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	83 ef 01             	sub    $0x1,%edi
 461:	6a 01                	push   $0x1
 463:	53                   	push   %ebx
 464:	56                   	push   %esi
 465:	88 45 d7             	mov    %al,-0x29(%ebp)
 468:	e8 c5 fe ff ff       	call   332 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 46d:	83 c4 10             	add    $0x10,%esp
 470:	39 df                	cmp    %ebx,%edi
 472:	75 e4                	jne    458 <printint+0x68>
    putc(fd, buf[i]);
}
 474:	8d 65 f4             	lea    -0xc(%ebp),%esp
 477:	5b                   	pop    %ebx
 478:	5e                   	pop    %esi
 479:	5f                   	pop    %edi
 47a:	5d                   	pop    %ebp
 47b:	c3                   	ret    
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 480:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 482:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 489:	eb 8b                	jmp    416 <printint+0x26>
 48b:	90                   	nop
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 496:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 499:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 49c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 49f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4a5:	0f b6 1e             	movzbl (%esi),%ebx
 4a8:	83 c6 01             	add    $0x1,%esi
 4ab:	84 db                	test   %bl,%bl
 4ad:	0f 84 b0 00 00 00    	je     563 <printf+0xd3>
 4b3:	31 d2                	xor    %edx,%edx
 4b5:	eb 39                	jmp    4f0 <printf+0x60>
 4b7:	89 f6                	mov    %esi,%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c0:	83 f8 25             	cmp    $0x25,%eax
 4c3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 4c6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4cb:	74 18                	je     4e5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4cd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4d6:	6a 01                	push   $0x1
 4d8:	50                   	push   %eax
 4d9:	57                   	push   %edi
 4da:	e8 53 fe ff ff       	call   332 <write>
 4df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4ec:	84 db                	test   %bl,%bl
 4ee:	74 73                	je     563 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 4f0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4f2:	0f be cb             	movsbl %bl,%ecx
 4f5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4f8:	74 c6                	je     4c0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fa:	83 fa 25             	cmp    $0x25,%edx
 4fd:	75 e6                	jne    4e5 <printf+0x55>
      if(c == 'd'){
 4ff:	83 f8 64             	cmp    $0x64,%eax
 502:	0f 84 f8 00 00 00    	je     600 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 508:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 50e:	83 f9 70             	cmp    $0x70,%ecx
 511:	74 5d                	je     570 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 513:	83 f8 73             	cmp    $0x73,%eax
 516:	0f 84 84 00 00 00    	je     5a0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51c:	83 f8 63             	cmp    $0x63,%eax
 51f:	0f 84 ea 00 00 00    	je     60f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 525:	83 f8 25             	cmp    $0x25,%eax
 528:	0f 84 c2 00 00 00    	je     5f0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 52e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 531:	83 ec 04             	sub    $0x4,%esp
 534:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 538:	6a 01                	push   $0x1
 53a:	50                   	push   %eax
 53b:	57                   	push   %edi
 53c:	e8 f1 fd ff ff       	call   332 <write>
 541:	83 c4 0c             	add    $0xc,%esp
 544:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 547:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 54a:	6a 01                	push   $0x1
 54c:	50                   	push   %eax
 54d:	57                   	push   %edi
 54e:	83 c6 01             	add    $0x1,%esi
 551:	e8 dc fd ff ff       	call   332 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 556:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 55a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 55d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 55f:	84 db                	test   %bl,%bl
 561:	75 8d                	jne    4f0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 563:	8d 65 f4             	lea    -0xc(%ebp),%esp
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5f                   	pop    %edi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret    
 56b:	90                   	nop
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
 578:	6a 00                	push   $0x0
 57a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 57d:	89 f8                	mov    %edi,%eax
 57f:	8b 13                	mov    (%ebx),%edx
 581:	e8 6a fe ff ff       	call   3f0 <printint>
        ap++;
 586:	89 d8                	mov    %ebx,%eax
 588:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 58b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 d0             	mov    %eax,-0x30(%ebp)
 593:	e9 4d ff ff ff       	jmp    4e5 <printf+0x55>
 598:	90                   	nop
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 5a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5a3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5a5:	83 c0 04             	add    $0x4,%eax
 5a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 5ab:	b8 f1 07 00 00       	mov    $0x7f1,%eax
 5b0:	85 db                	test   %ebx,%ebx
 5b2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 5b5:	0f b6 03             	movzbl (%ebx),%eax
 5b8:	84 c0                	test   %al,%al
 5ba:	74 23                	je     5df <printf+0x14f>
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5c6:	83 ec 04             	sub    $0x4,%esp
 5c9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5cb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ce:	50                   	push   %eax
 5cf:	57                   	push   %edi
 5d0:	e8 5d fd ff ff       	call   332 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d5:	0f b6 03             	movzbl (%ebx),%eax
 5d8:	83 c4 10             	add    $0x10,%esp
 5db:	84 c0                	test   %al,%al
 5dd:	75 e1                	jne    5c0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5df:	31 d2                	xor    %edx,%edx
 5e1:	e9 ff fe ff ff       	jmp    4e5 <printf+0x55>
 5e6:	8d 76 00             	lea    0x0(%esi),%esi
 5e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5f9:	6a 01                	push   $0x1
 5fb:	e9 4c ff ff ff       	jmp    54c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	e9 6b ff ff ff       	jmp    57a <printf+0xea>
 60f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 612:	83 ec 04             	sub    $0x4,%esp
 615:	8b 03                	mov    (%ebx),%eax
 617:	6a 01                	push   $0x1
 619:	88 45 e4             	mov    %al,-0x1c(%ebp)
 61c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 61f:	50                   	push   %eax
 620:	57                   	push   %edi
 621:	e8 0c fd ff ff       	call   332 <write>
 626:	e9 5b ff ff ff       	jmp    586 <printf+0xf6>
 62b:	66 90                	xchg   %ax,%ax
 62d:	66 90                	xchg   %ax,%ax
 62f:	90                   	nop

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	a1 98 0a 00 00       	mov    0xa98,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 640:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 643:	39 c8                	cmp    %ecx,%eax
 645:	73 19                	jae    660 <free+0x30>
 647:	89 f6                	mov    %esi,%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 650:	39 d1                	cmp    %edx,%ecx
 652:	72 1c                	jb     670 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	39 d0                	cmp    %edx,%eax
 656:	73 18                	jae    670 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 658:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65e:	72 f0                	jb     650 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 d0                	cmp    %edx,%eax
 662:	72 f4                	jb     658 <free+0x28>
 664:	39 d1                	cmp    %edx,%ecx
 666:	73 f0                	jae    658 <free+0x28>
 668:	90                   	nop
 669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 670:	8b 73 fc             	mov    -0x4(%ebx),%esi
 673:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 676:	39 d7                	cmp    %edx,%edi
 678:	74 19                	je     693 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 67a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 683:	39 f1                	cmp    %esi,%ecx
 685:	74 23                	je     6aa <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 687:	89 08                	mov    %ecx,(%eax)
  freep = p;
 689:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 68e:	5b                   	pop    %ebx
 68f:	5e                   	pop    %esi
 690:	5f                   	pop    %edi
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 693:	03 72 04             	add    0x4(%edx),%esi
 696:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 12                	mov    (%edx),%edx
 69d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6a0:	8b 50 04             	mov    0x4(%eax),%edx
 6a3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a6:	39 f1                	cmp    %esi,%ecx
 6a8:	75 dd                	jne    687 <free+0x57>
    p->s.size += bp->s.size;
 6aa:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6ad:	a3 98 0a 00 00       	mov    %eax,0xa98
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6ba:	5b                   	pop    %ebx
 6bb:	5e                   	pop    %esi
 6bc:	5f                   	pop    %edi
 6bd:	5d                   	pop    %ebp
 6be:	c3                   	ret    
 6bf:	90                   	nop

000006c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6cc:	8b 15 98 0a 00 00    	mov    0xa98,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	8d 78 07             	lea    0x7(%eax),%edi
 6d5:	c1 ef 03             	shr    $0x3,%edi
 6d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6db:	85 d2                	test   %edx,%edx
 6dd:	0f 84 a3 00 00 00    	je     786 <malloc+0xc6>
 6e3:	8b 02                	mov    (%edx),%eax
 6e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6e8:	39 cf                	cmp    %ecx,%edi
 6ea:	76 74                	jbe    760 <malloc+0xa0>
 6ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6f2:	be 00 10 00 00       	mov    $0x1000,%esi
 6f7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 6fe:	0f 43 f7             	cmovae %edi,%esi
 701:	ba 00 80 00 00       	mov    $0x8000,%edx
 706:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 70c:	0f 46 da             	cmovbe %edx,%ebx
 70f:	eb 10                	jmp    721 <malloc+0x61>
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 718:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 71a:	8b 48 04             	mov    0x4(%eax),%ecx
 71d:	39 cf                	cmp    %ecx,%edi
 71f:	76 3f                	jbe    760 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	39 05 98 0a 00 00    	cmp    %eax,0xa98
 727:	89 c2                	mov    %eax,%edx
 729:	75 ed                	jne    718 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	53                   	push   %ebx
 72f:	e8 66 fc ff ff       	call   39a <sbrk>
  if(p == (char*)-1)
 734:	83 c4 10             	add    $0x10,%esp
 737:	83 f8 ff             	cmp    $0xffffffff,%eax
 73a:	74 1c                	je     758 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 73c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	83 c0 08             	add    $0x8,%eax
 745:	50                   	push   %eax
 746:	e8 e5 fe ff ff       	call   630 <free>
  return freep;
 74b:	8b 15 98 0a 00 00    	mov    0xa98,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 751:	83 c4 10             	add    $0x10,%esp
 754:	85 d2                	test   %edx,%edx
 756:	75 c0                	jne    718 <malloc+0x58>
        return 0;
 758:	31 c0                	xor    %eax,%eax
 75a:	eb 1c                	jmp    778 <malloc+0xb8>
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 760:	39 cf                	cmp    %ecx,%edi
 762:	74 1c                	je     780 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 764:	29 f9                	sub    %edi,%ecx
 766:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 769:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 76c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 76f:	89 15 98 0a 00 00    	mov    %edx,0xa98
      return (void*)(p + 1);
 775:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 778:	8d 65 f4             	lea    -0xc(%ebp),%esp
 77b:	5b                   	pop    %ebx
 77c:	5e                   	pop    %esi
 77d:	5f                   	pop    %edi
 77e:	5d                   	pop    %ebp
 77f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb e9                	jmp    76f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 786:	c7 05 98 0a 00 00 9c 	movl   $0xa9c,0xa98
 78d:	0a 00 00 
 790:	c7 05 9c 0a 00 00 9c 	movl   $0xa9c,0xa9c
 797:	0a 00 00 
    base.s.size = 0;
 79a:	b8 9c 0a 00 00       	mov    $0xa9c,%eax
 79f:	c7 05 a0 0a 00 00 00 	movl   $0x0,0xaa0
 7a6:	00 00 00 
 7a9:	e9 3e ff ff ff       	jmp    6ec <malloc+0x2c>
