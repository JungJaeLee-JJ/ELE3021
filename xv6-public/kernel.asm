
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 32 10 80       	mov    $0x80103250,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 00 79 10 80       	push   $0x80107900
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 35 49 00 00       	call   80104990 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 79 10 80       	push   $0x80107907
80100097:	50                   	push   %eax
80100098:	e8 c3 47 00 00       	call   80104860 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 07 4a 00 00       	call   80104af0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 39 4a 00 00       	call   80104ba0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 47 00 00       	call   801048a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 23 00 00       	call   801024e0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 79 10 80       	push   $0x8010790e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 8d 47 00 00       	call   80104940 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 17 23 00 00       	jmp    801024e0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 79 10 80       	push   $0x8010791f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 4c 47 00 00       	call   80104940 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 46 00 00       	call   80104900 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 e0 48 00 00       	call   80104af0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 3f 49 00 00       	jmp    80104ba0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 79 10 80       	push   $0x80107926
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 18 00 00       	call   80101b40 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 5f 48 00 00       	call   80104af0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 2e 42 00 00       	call   801044f0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 e9 38 00 00       	call   80103bc0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 b5 48 00 00       	call   80104ba0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 6d 17 00 00       	call   80101a60 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 55 48 00 00       	call   80104ba0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 0d 17 00 00       	call   80101a60 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 52 27 00 00       	call   80102ae0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 2d 79 10 80       	push   $0x8010792d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 13 83 10 80 	movl   $0x80108313,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 f3 45 00 00       	call   801049b0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 41 79 10 80       	push   $0x80107941
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 a1 60 00 00       	call   801064c0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 e8 5f 00 00       	call   801064c0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 dc 5f 00 00       	call   801064c0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 d0 5f 00 00       	call   801064c0 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 87 47 00 00       	call   80104ca0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 c2 46 00 00       	call   80104bf0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 45 79 10 80       	push   $0x80107945
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 70 79 10 80 	movzbl -0x7fef8690(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 2c 15 00 00       	call   80101b40 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 d0 44 00 00       	call   80104af0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 54 45 00 00       	call   80104ba0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 14 00 00       	call   80101a60 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 8e 44 00 00       	call   80104ba0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 58 79 10 80       	mov    $0x80107958,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 23 43 00 00       	call   80104af0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 5f 79 10 80       	push   $0x8010795f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 e8 42 00 00       	call   80104af0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 33 43 00 00       	call   80104ba0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 b5 3d 00 00       	call   801046b0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 24 3e 00 00       	jmp    801047a0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 68 79 10 80       	push   $0x80107968
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 db 3f 00 00       	call   80104990 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 b2 1c 00 00       	call   80102690 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 bf 31 00 00       	call   80103bc0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  //cprintf("%s , %s \n",path,*argv);

  begin_op();
80100a07:	e8 34 25 00 00       	call   80102f40 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 99 18 00 00       	call   801022b0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 33 10 00 00       	call   80101a60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 02 13 00 00       	call   80101d40 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 a1 12 00 00       	call   80101cf0 <iunlockput>
    end_op();
80100a4f:	e8 5c 25 00 00       	call   80102fb0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 d7 6b 00 00       	call   80107650 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 73 12 00 00       	call   80101d40 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 97 69 00 00       	call   801074a0 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 a1 68 00 00       	call   801073e0 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 72 6a 00 00       	call   801075d0 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 81 11 00 00       	call   80101cf0 <iunlockput>
  end_op();
80100b6f:	e8 3c 24 00 00       	call   80102fb0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 06 69 00 00       	call   801074a0 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 1f 6a 00 00       	call   801075d0 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  //cprintf("%s , %s \n",path,*argv);

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 ed 23 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 81 79 10 80       	push   $0x80107981
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 fa 6a 00 00       	call   801076f0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	  //cprintf("%s \n",argv[argc]);
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 fe 41 00 00       	call   80104e30 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  //cprintf("%s \n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 eb 41 00 00       	call   80104e30 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 0a 6c 00 00       	call   80107860 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 a0 6b 00 00       	call   80107860 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 eb 40 00 00       	call   80104df0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
80100d29:	c7 81 88 00 00 00 00 	movl   $0x0,0x88(%ecx)
80100d30:	00 00 00 
  curproc->limit_sz = 0;
80100d33:	c7 81 90 00 00 00 00 	movl   $0x0,0x90(%ecx)
80100d3a:	00 00 00 
  curproc->custom_stack_size = 1;
80100d3d:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80100d44:	00 00 00 


  switchuvm(curproc);
80100d47:	89 0c 24             	mov    %ecx,(%esp)
80100d4a:	e8 01 65 00 00       	call   80107250 <switchuvm>
  freevm(oldpgdir);
80100d4f:	89 3c 24             	mov    %edi,(%esp)
80100d52:	e8 79 68 00 00       	call   801075d0 <freevm>
  return 0;
80100d57:	83 c4 10             	add    $0x10,%esp
80100d5a:	31 c0                	xor    %eax,%eax
80100d5c:	e9 fb fc ff ff       	jmp    80100a5c <exec+0x6c>
80100d61:	eb 0d                	jmp    80100d70 <exec2>
80100d63:	90                   	nop
80100d64:	90                   	nop
80100d65:	90                   	nop
80100d66:	90                   	nop
80100d67:	90                   	nop
80100d68:	90                   	nop
80100d69:	90                   	nop
80100d6a:	90                   	nop
80100d6b:	90                   	nop
80100d6c:	90                   	nop
80100d6d:	90                   	nop
80100d6e:	90                   	nop
80100d6f:	90                   	nop

80100d70 <exec2>:
}


int
exec2(char *path, char **argv, int stacksize)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	57                   	push   %edi
80100d74:	56                   	push   %esi
80100d75:	53                   	push   %ebx
80100d76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d7c:	e8 3f 2e 00 00       	call   80103bc0 <myproc>

  //cprintf("%s , %s, %d\n",path,*argv,stacksize);
  //cprintf("exec : %d\n",stacksize);

  //admin mode가 아닐때
  if (curproc->admin_mode==0){
80100d81:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80100d87:	85 c9                	test   %ecx,%ecx
80100d89:	0f 84 c5 00 00 00    	je     80100e54 <exec2+0xe4>
80100d8f:	89 c6                	mov    %eax,%esi
    return -1;
  }

  begin_op();
80100d91:	e8 aa 21 00 00       	call   80102f40 <begin_op>

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
80100d96:	83 ec 0c             	sub    $0xc,%esp
80100d99:	ff 75 08             	pushl  0x8(%ebp)
80100d9c:	e8 0f 15 00 00       	call   801022b0 <namei>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	85 c0                	test   %eax,%eax
80100da6:	89 c3                	mov    %eax,%ebx
80100da8:	0f 84 c8 01 00 00    	je     80100f76 <exec2+0x206>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100dae:	83 ec 0c             	sub    $0xc,%esp
80100db1:	50                   	push   %eax
80100db2:	e8 a9 0c 00 00       	call   80101a60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100db7:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100dbd:	6a 34                	push   $0x34
80100dbf:	6a 00                	push   $0x0
80100dc1:	50                   	push   %eax
80100dc2:	53                   	push   %ebx
80100dc3:	e8 78 0f 00 00       	call   80101d40 <readi>
80100dc8:	83 c4 20             	add    $0x20,%esp
80100dcb:	83 f8 34             	cmp    $0x34,%eax
80100dce:	0f 84 94 00 00 00    	je     80100e68 <exec2+0xf8>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100dd4:	83 ec 0c             	sub    $0xc,%esp
80100dd7:	53                   	push   %ebx
80100dd8:	e8 13 0f 00 00       	call   80101cf0 <iunlockput>
    end_op();
80100ddd:	e8 ce 21 00 00       	call   80102fb0 <end_op>
80100de2:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ded:	5b                   	pop    %ebx
80100dee:	5e                   	pop    %esi
80100def:	5f                   	pop    %edi
80100df0:	5d                   	pop    %ebp
80100df1:	c3                   	ret    
80100df2:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	53                   	push   %ebx
80100dfc:	e8 ef 0e 00 00       	call   80101cf0 <iunlockput>
  end_op();
80100e01:	e8 aa 21 00 00       	call   80102fb0 <end_op>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e06:	8b 4d 10             	mov    0x10(%ebp),%ecx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
80100e09:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e0f:	83 c4 0c             	add    $0xc,%esp
80100e12:	8d 59 01             	lea    0x1(%ecx),%ebx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
80100e15:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e1f:	c1 e3 0c             	shl    $0xc,%ebx
80100e22:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100e25:	52                   	push   %edx
80100e26:	50                   	push   %eax
80100e27:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e2d:	e8 6e 66 00 00       	call   801074a0 <allocuvm>
80100e32:	83 c4 10             	add    $0x10,%esp
80100e35:	85 c0                	test   %eax,%eax
80100e37:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e3d:	0f 85 4d 01 00 00    	jne    80100f90 <exec2+0x220>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100e43:	83 ec 0c             	sub    $0xc,%esp
80100e46:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e4c:	e8 7f 67 00 00       	call   801075d0 <freevm>
80100e51:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e5c:	5b                   	pop    %ebx
80100e5d:	5e                   	pop    %esi
80100e5e:	5f                   	pop    %edi
80100e5f:	5d                   	pop    %ebp
80100e60:	c3                   	ret    
80100e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100e68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e6f:	45 4c 46 
80100e72:	0f 85 5c ff ff ff    	jne    80100dd4 <exec2+0x64>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100e78:	e8 d3 67 00 00       	call   80107650 <setupkvm>
80100e7d:	85 c0                	test   %eax,%eax
80100e7f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e85:	0f 84 49 ff ff ff    	je     80100dd4 <exec2+0x64>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e92:	00 
80100e93:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100e99:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ea0:	00 00 00 
80100ea3:	0f 84 4f ff ff ff    	je     80100df8 <exec2+0x88>
80100ea9:	31 c0                	xor    %eax,%eax
80100eab:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100eb1:	89 c6                	mov    %eax,%esi
80100eb3:	eb 18                	jmp    80100ecd <exec2+0x15d>
80100eb5:	8d 76 00             	lea    0x0(%esi),%esi
80100eb8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ebf:	83 c6 01             	add    $0x1,%esi
80100ec2:	83 c7 20             	add    $0x20,%edi
80100ec5:	39 f0                	cmp    %esi,%eax
80100ec7:	0f 8e 25 ff ff ff    	jle    80100df2 <exec2+0x82>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ecd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ed3:	6a 20                	push   $0x20
80100ed5:	57                   	push   %edi
80100ed6:	50                   	push   %eax
80100ed7:	53                   	push   %ebx
80100ed8:	e8 63 0e 00 00       	call   80101d40 <readi>
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 f8 20             	cmp    $0x20,%eax
80100ee3:	75 7b                	jne    80100f60 <exec2+0x1f0>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ee5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100eec:	75 ca                	jne    80100eb8 <exec2+0x148>
      continue;
    if(ph.memsz < ph.filesz)
80100eee:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ef4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100efa:	72 64                	jb     80100f60 <exec2+0x1f0>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100efc:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100f02:	72 5c                	jb     80100f60 <exec2+0x1f0>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	50                   	push   %eax
80100f08:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f0e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f14:	e8 87 65 00 00       	call   801074a0 <allocuvm>
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 c0                	test   %eax,%eax
80100f1e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f24:	74 3a                	je     80100f60 <exec2+0x1f0>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100f26:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f2c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f31:	75 2d                	jne    80100f60 <exec2+0x1f0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f33:	83 ec 0c             	sub    $0xc,%esp
80100f36:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100f3c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100f42:	53                   	push   %ebx
80100f43:	50                   	push   %eax
80100f44:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f4a:	e8 91 64 00 00       	call   801073e0 <loaduvm>
80100f4f:	83 c4 20             	add    $0x20,%esp
80100f52:	85 c0                	test   %eax,%eax
80100f54:	0f 89 5e ff ff ff    	jns    80100eb8 <exec2+0x148>
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100f60:	83 ec 0c             	sub    $0xc,%esp
80100f63:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f69:	e8 62 66 00 00       	call   801075d0 <freevm>
80100f6e:	83 c4 10             	add    $0x10,%esp
80100f71:	e9 5e fe ff ff       	jmp    80100dd4 <exec2+0x64>
  begin_op();

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
80100f76:	e8 35 20 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100f7b:	83 ec 0c             	sub    $0xc,%esp
80100f7e:	68 81 79 10 80       	push   $0x80107981
80100f83:	e8 d8 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100f88:	83 c4 10             	add    $0x10,%esp
80100f8b:	e9 c4 fe ff ff       	jmp    80100e54 <exec2+0xe4>

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
80100f90:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f96:	83 ec 08             	sub    $0x8,%esp
80100f99:	29 d8                	sub    %ebx,%eax
80100f9b:	50                   	push   %eax
80100f9c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fa2:	e8 49 67 00 00       	call   801076f0 <clearpteu>
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faa:	83 c4 10             	add    $0x10,%esp
80100fad:	8b 00                	mov    (%eax),%eax
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	0f 84 85 01 00 00    	je     8010113c <exec2+0x3cc>
	  cprintf("%s\n",argv[argc]);
80100fb7:	83 ec 08             	sub    $0x8,%esp
80100fba:	31 ff                	xor    %edi,%edi
80100fbc:	50                   	push   %eax
80100fbd:	68 8d 79 10 80       	push   $0x8010798d
80100fc2:	e8 99 f6 ff ff       	call   80100660 <cprintf>
80100fc7:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100fcd:	83 c4 10             	add    $0x10,%esp
80100fd0:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100fd6:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100fdc:	eb 1c                	jmp    80100ffa <exec2+0x28a>
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	83 ec 08             	sub    $0x8,%esp
80100fe3:	50                   	push   %eax
80100fe4:	68 8d 79 10 80       	push   $0x8010798d
80100fe9:	e8 72 f6 ff ff       	call   80100660 <cprintf>
    if(argc >= MAXARG)
80100fee:	83 c4 10             	add    $0x10,%esp
80100ff1:	83 ff 20             	cmp    $0x20,%edi
80100ff4:	0f 84 49 fe ff ff    	je     80100e43 <exec2+0xd3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ffd:	83 ec 0c             	sub    $0xc,%esp
80101000:	ff 34 b8             	pushl  (%eax,%edi,4)
80101003:	e8 28 3e 00 00       	call   80104e30 <strlen>
80101008:	f7 d0                	not    %eax
8010100a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010100c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010100f:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  cprintf("%s\n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101010:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101013:	ff 34 b8             	pushl  (%eax,%edi,4)
80101016:	e8 15 3e 00 00       	call   80104e30 <strlen>
8010101b:	83 c0 01             	add    $0x1,%eax
8010101e:	50                   	push   %eax
8010101f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101022:	ff 34 b8             	pushl  (%eax,%edi,4)
80101025:	53                   	push   %ebx
80101026:	56                   	push   %esi
80101027:	e8 34 68 00 00       	call   80107860 <copyout>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	85 c0                	test   %eax,%eax
80101031:	0f 88 0c fe ff ff    	js     80100e43 <exec2+0xd3>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101037:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
8010103a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101041:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80101044:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010104a:	8b 04 b8             	mov    (%eax,%edi,4),%eax
8010104d:	85 c0                	test   %eax,%eax
8010104f:	75 8f                	jne    80100fe0 <exec2+0x270>
80101051:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101057:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
8010105e:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80101060:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101067:	00 00 00 00 

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
8010106b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101072:	ff ff ff 
  ustack[1] = argc;
80101075:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010107b:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
8010107d:	83 c0 0c             	add    $0xc,%eax
80101080:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101082:	50                   	push   %eax
80101083:	52                   	push   %edx
80101084:	53                   	push   %ebx
80101085:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010108b:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101091:	e8 ca 67 00 00       	call   80107860 <copyout>
80101096:	83 c4 10             	add    $0x10,%esp
80101099:	85 c0                	test   %eax,%eax
8010109b:	0f 88 a2 fd ff ff    	js     80100e43 <exec2+0xd3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010a1:	8b 45 08             	mov    0x8(%ebp),%eax
801010a4:	0f b6 10             	movzbl (%eax),%edx
801010a7:	84 d2                	test   %dl,%dl
801010a9:	74 19                	je     801010c4 <exec2+0x354>
801010ab:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
801010ae:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010b1:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
801010b4:	89 c1                	mov    %eax,%ecx
801010b6:	0f 45 4d 08          	cmovne 0x8(%ebp),%ecx
801010ba:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010bd:	84 d2                	test   %dl,%dl
    if(*s == '/')
      last = s+1;
801010bf:	89 4d 08             	mov    %ecx,0x8(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010c2:	75 ea                	jne    801010ae <exec2+0x33e>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010c4:	50                   	push   %eax
801010c5:	8d 46 6c             	lea    0x6c(%esi),%eax
801010c8:	6a 10                	push   $0x10
801010ca:	ff 75 08             	pushl  0x8(%ebp)
801010cd:	50                   	push   %eax
801010ce:	e8 1d 3d 00 00       	call   80104df0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
801010d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010d9:	8b 7e 04             	mov    0x4(%esi),%edi
  curproc->pgdir = pgdir;
801010dc:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
801010df:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010e5:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
801010e7:	8b 46 18             	mov    0x18(%esi),%eax
801010ea:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801010f0:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801010f3:	8b 46 18             	mov    0x18(%esi),%eax
801010f6:	89 58 44             	mov    %ebx,0x44(%eax)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
  curproc->limit_sz = 0;
  curproc->custom_stack_size = stacksize;
801010f9:	8b 45 10             	mov    0x10(%ebp),%eax
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
801010fc:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101103:	00 00 00 
  curproc->limit_sz = 0;
80101106:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
8010110d:	00 00 00 
  curproc->custom_stack_size = stacksize;
80101110:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)

  cprintf("initailizing done\n");
80101116:	c7 04 24 91 79 10 80 	movl   $0x80107991,(%esp)
8010111d:	e8 3e f5 ff ff       	call   80100660 <cprintf>

  switchuvm(curproc);
80101122:	89 34 24             	mov    %esi,(%esp)
80101125:	e8 26 61 00 00       	call   80107250 <switchuvm>
  freevm(oldpgdir);
8010112a:	89 3c 24             	mov    %edi,(%esp)
8010112d:	e8 9e 64 00 00       	call   801075d0 <freevm>
  return 0;
80101132:	83 c4 10             	add    $0x10,%esp
80101135:	31 c0                	xor    %eax,%eax
80101137:	e9 ae fc ff ff       	jmp    80100dea <exec2+0x7a>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010113c:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80101142:	31 ff                	xor    %edi,%edi
80101144:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
8010114a:	e9 08 ff ff ff       	jmp    80101057 <exec2+0x2e7>
8010114f:	90                   	nop

80101150 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101156:	68 a4 79 10 80       	push   $0x801079a4
8010115b:	68 c0 0f 11 80       	push   $0x80110fc0
80101160:	e8 2b 38 00 00       	call   80104990 <initlock>
}
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	c9                   	leave  
80101169:	c3                   	ret    
8010116a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101170 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101174:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80101179:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
8010117c:	68 c0 0f 11 80       	push   $0x80110fc0
80101181:	e8 6a 39 00 00       	call   80104af0 <acquire>
80101186:	83 c4 10             	add    $0x10,%esp
80101189:	eb 10                	jmp    8010119b <filealloc+0x2b>
8010118b:	90                   	nop
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101190:	83 c3 18             	add    $0x18,%ebx
80101193:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80101199:	74 25                	je     801011c0 <filealloc+0x50>
    if(f->ref == 0){
8010119b:	8b 43 04             	mov    0x4(%ebx),%eax
8010119e:	85 c0                	test   %eax,%eax
801011a0:	75 ee                	jne    80101190 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801011a2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
801011a5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801011ac:	68 c0 0f 11 80       	push   $0x80110fc0
801011b1:	e8 ea 39 00 00       	call   80104ba0 <release>
      return f;
801011b6:	89 d8                	mov    %ebx,%eax
801011b8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
801011bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011be:	c9                   	leave  
801011bf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801011c0:	83 ec 0c             	sub    $0xc,%esp
801011c3:	68 c0 0f 11 80       	push   $0x80110fc0
801011c8:	e8 d3 39 00 00       	call   80104ba0 <release>
  return 0;
801011cd:	83 c4 10             	add    $0x10,%esp
801011d0:	31 c0                	xor    %eax,%eax
}
801011d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d5:	c9                   	leave  
801011d6:	c3                   	ret    
801011d7:	89 f6                	mov    %esi,%esi
801011d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011e0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	53                   	push   %ebx
801011e4:	83 ec 10             	sub    $0x10,%esp
801011e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011ea:	68 c0 0f 11 80       	push   $0x80110fc0
801011ef:	e8 fc 38 00 00       	call   80104af0 <acquire>
  if(f->ref < 1)
801011f4:	8b 43 04             	mov    0x4(%ebx),%eax
801011f7:	83 c4 10             	add    $0x10,%esp
801011fa:	85 c0                	test   %eax,%eax
801011fc:	7e 1a                	jle    80101218 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011fe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101201:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80101204:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101207:	68 c0 0f 11 80       	push   $0x80110fc0
8010120c:	e8 8f 39 00 00       	call   80104ba0 <release>
  return f;
}
80101211:	89 d8                	mov    %ebx,%eax
80101213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101216:	c9                   	leave  
80101217:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80101218:	83 ec 0c             	sub    $0xc,%esp
8010121b:	68 ab 79 10 80       	push   $0x801079ab
80101220:	e8 4b f1 ff ff       	call   80100370 <panic>
80101225:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101230 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 28             	sub    $0x28,%esp
80101239:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
8010123c:	68 c0 0f 11 80       	push   $0x80110fc0
80101241:	e8 aa 38 00 00       	call   80104af0 <acquire>
  if(f->ref < 1)
80101246:	8b 47 04             	mov    0x4(%edi),%eax
80101249:	83 c4 10             	add    $0x10,%esp
8010124c:	85 c0                	test   %eax,%eax
8010124e:	0f 8e 9b 00 00 00    	jle    801012ef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101254:	83 e8 01             	sub    $0x1,%eax
80101257:	85 c0                	test   %eax,%eax
80101259:	89 47 04             	mov    %eax,0x4(%edi)
8010125c:	74 1a                	je     80101278 <fileclose+0x48>
    release(&ftable.lock);
8010125e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101265:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101268:	5b                   	pop    %ebx
80101269:	5e                   	pop    %esi
8010126a:	5f                   	pop    %edi
8010126b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
8010126c:	e9 2f 39 00 00       	jmp    80104ba0 <release>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80101278:	0f b6 47 09          	movzbl 0x9(%edi),%eax
8010127c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
8010127e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101281:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80101284:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010128a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010128d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101290:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101295:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101298:	e8 03 39 00 00       	call   80104ba0 <release>

  if(ff.type == FD_PIPE)
8010129d:	83 c4 10             	add    $0x10,%esp
801012a0:	83 fb 01             	cmp    $0x1,%ebx
801012a3:	74 13                	je     801012b8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012a5:	83 fb 02             	cmp    $0x2,%ebx
801012a8:	74 26                	je     801012d0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	5b                   	pop    %ebx
801012ae:	5e                   	pop    %esi
801012af:	5f                   	pop    %edi
801012b0:	5d                   	pop    %ebp
801012b1:	c3                   	ret    
801012b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
801012b8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012bc:	83 ec 08             	sub    $0x8,%esp
801012bf:	53                   	push   %ebx
801012c0:	56                   	push   %esi
801012c1:	e8 1a 24 00 00       	call   801036e0 <pipeclose>
801012c6:	83 c4 10             	add    $0x10,%esp
801012c9:	eb df                	jmp    801012aa <fileclose+0x7a>
801012cb:	90                   	nop
801012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
801012d0:	e8 6b 1c 00 00       	call   80102f40 <begin_op>
    iput(ff.ip);
801012d5:	83 ec 0c             	sub    $0xc,%esp
801012d8:	ff 75 e0             	pushl  -0x20(%ebp)
801012db:	e8 b0 08 00 00       	call   80101b90 <iput>
    end_op();
801012e0:	83 c4 10             	add    $0x10,%esp
  }
}
801012e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e6:	5b                   	pop    %ebx
801012e7:	5e                   	pop    %esi
801012e8:	5f                   	pop    %edi
801012e9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
801012ea:	e9 c1 1c 00 00       	jmp    80102fb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
801012ef:	83 ec 0c             	sub    $0xc,%esp
801012f2:	68 b3 79 10 80       	push   $0x801079b3
801012f7:	e8 74 f0 ff ff       	call   80100370 <panic>
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101300 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	53                   	push   %ebx
80101304:	83 ec 04             	sub    $0x4,%esp
80101307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010130a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010130d:	75 31                	jne    80101340 <filestat+0x40>
    ilock(f->ip);
8010130f:	83 ec 0c             	sub    $0xc,%esp
80101312:	ff 73 10             	pushl  0x10(%ebx)
80101315:	e8 46 07 00 00       	call   80101a60 <ilock>
    stati(f->ip, st);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	ff 75 0c             	pushl  0xc(%ebp)
8010131f:	ff 73 10             	pushl  0x10(%ebx)
80101322:	e8 e9 09 00 00       	call   80101d10 <stati>
    iunlock(f->ip);
80101327:	59                   	pop    %ecx
80101328:	ff 73 10             	pushl  0x10(%ebx)
8010132b:	e8 10 08 00 00       	call   80101b40 <iunlock>
    return 0;
80101330:	83 c4 10             	add    $0x10,%esp
80101333:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101338:	c9                   	leave  
80101339:	c3                   	ret    
8010133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80101340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101348:	c9                   	leave  
80101349:	c3                   	ret    
8010134a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101350 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	83 ec 0c             	sub    $0xc,%esp
80101359:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010135c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010135f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101362:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101366:	74 60                	je     801013c8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101368:	8b 03                	mov    (%ebx),%eax
8010136a:	83 f8 01             	cmp    $0x1,%eax
8010136d:	74 41                	je     801013b0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010136f:	83 f8 02             	cmp    $0x2,%eax
80101372:	75 5b                	jne    801013cf <fileread+0x7f>
    ilock(f->ip);
80101374:	83 ec 0c             	sub    $0xc,%esp
80101377:	ff 73 10             	pushl  0x10(%ebx)
8010137a:	e8 e1 06 00 00       	call   80101a60 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010137f:	57                   	push   %edi
80101380:	ff 73 14             	pushl  0x14(%ebx)
80101383:	56                   	push   %esi
80101384:	ff 73 10             	pushl  0x10(%ebx)
80101387:	e8 b4 09 00 00       	call   80101d40 <readi>
8010138c:	83 c4 20             	add    $0x20,%esp
8010138f:	85 c0                	test   %eax,%eax
80101391:	89 c6                	mov    %eax,%esi
80101393:	7e 03                	jle    80101398 <fileread+0x48>
      f->off += r;
80101395:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101398:	83 ec 0c             	sub    $0xc,%esp
8010139b:	ff 73 10             	pushl  0x10(%ebx)
8010139e:	e8 9d 07 00 00       	call   80101b40 <iunlock>
    return r;
801013a3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013a6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
801013a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ab:	5b                   	pop    %ebx
801013ac:	5e                   	pop    %esi
801013ad:	5f                   	pop    %edi
801013ae:	5d                   	pop    %ebp
801013af:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
801013b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801013b3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
801013b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b9:	5b                   	pop    %ebx
801013ba:	5e                   	pop    %esi
801013bb:	5f                   	pop    %edi
801013bc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
801013bd:	e9 be 24 00 00       	jmp    80103880 <piperead>
801013c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
801013c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013cd:	eb d9                	jmp    801013a8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
801013cf:	83 ec 0c             	sub    $0xc,%esp
801013d2:	68 bd 79 10 80       	push   $0x801079bd
801013d7:	e8 94 ef ff ff       	call   80100370 <panic>
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	56                   	push   %esi
801013e5:	53                   	push   %ebx
801013e6:	83 ec 1c             	sub    $0x1c,%esp
801013e9:	8b 75 08             	mov    0x8(%ebp),%esi
801013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801013ef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013f6:	8b 45 10             	mov    0x10(%ebp),%eax
801013f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
801013fc:	0f 84 aa 00 00 00    	je     801014ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101402:	8b 06                	mov    (%esi),%eax
80101404:	83 f8 01             	cmp    $0x1,%eax
80101407:	0f 84 c2 00 00 00    	je     801014cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010140d:	83 f8 02             	cmp    $0x2,%eax
80101410:	0f 85 d8 00 00 00    	jne    801014ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101419:	31 ff                	xor    %edi,%edi
8010141b:	85 c0                	test   %eax,%eax
8010141d:	7f 34                	jg     80101453 <filewrite+0x73>
8010141f:	e9 9c 00 00 00       	jmp    801014c0 <filewrite+0xe0>
80101424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101428:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010142b:	83 ec 0c             	sub    $0xc,%esp
8010142e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101431:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101434:	e8 07 07 00 00       	call   80101b40 <iunlock>
      end_op();
80101439:	e8 72 1b 00 00       	call   80102fb0 <end_op>
8010143e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101441:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101444:	39 d8                	cmp    %ebx,%eax
80101446:	0f 85 95 00 00 00    	jne    801014e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010144c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010144e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101451:	7e 6d                	jle    801014c0 <filewrite+0xe0>
      int n1 = n - i;
80101453:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101456:	b8 00 06 00 00       	mov    $0x600,%eax
8010145b:	29 fb                	sub    %edi,%ebx
8010145d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101463:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101466:	e8 d5 1a 00 00       	call   80102f40 <begin_op>
      ilock(f->ip);
8010146b:	83 ec 0c             	sub    $0xc,%esp
8010146e:	ff 76 10             	pushl  0x10(%esi)
80101471:	e8 ea 05 00 00       	call   80101a60 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101476:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101479:	53                   	push   %ebx
8010147a:	ff 76 14             	pushl  0x14(%esi)
8010147d:	01 f8                	add    %edi,%eax
8010147f:	50                   	push   %eax
80101480:	ff 76 10             	pushl  0x10(%esi)
80101483:	e8 b8 09 00 00       	call   80101e40 <writei>
80101488:	83 c4 20             	add    $0x20,%esp
8010148b:	85 c0                	test   %eax,%eax
8010148d:	7f 99                	jg     80101428 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010148f:	83 ec 0c             	sub    $0xc,%esp
80101492:	ff 76 10             	pushl  0x10(%esi)
80101495:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101498:	e8 a3 06 00 00       	call   80101b40 <iunlock>
      end_op();
8010149d:	e8 0e 1b 00 00       	call   80102fb0 <end_op>

      if(r < 0)
801014a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	85 c0                	test   %eax,%eax
801014aa:	74 98                	je     80101444 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801014ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801014b4:	5b                   	pop    %ebx
801014b5:	5e                   	pop    %esi
801014b6:	5f                   	pop    %edi
801014b7:	5d                   	pop    %ebp
801014b8:	c3                   	ret    
801014b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801014c3:	75 e7                	jne    801014ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801014c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c8:	89 f8                	mov    %edi,%eax
801014ca:	5b                   	pop    %ebx
801014cb:	5e                   	pop    %esi
801014cc:	5f                   	pop    %edi
801014cd:	5d                   	pop    %ebp
801014ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801014cf:	8b 46 0c             	mov    0xc(%esi),%eax
801014d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801014d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014d8:	5b                   	pop    %ebx
801014d9:	5e                   	pop    %esi
801014da:	5f                   	pop    %edi
801014db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801014dc:	e9 9f 22 00 00       	jmp    80103780 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801014e1:	83 ec 0c             	sub    $0xc,%esp
801014e4:	68 c6 79 10 80       	push   $0x801079c6
801014e9:	e8 82 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801014ee:	83 ec 0c             	sub    $0xc,%esp
801014f1:	68 cc 79 10 80       	push   $0x801079cc
801014f6:	e8 75 ee ff ff       	call   80100370 <panic>
801014fb:	66 90                	xchg   %ax,%ax
801014fd:	66 90                	xchg   %ax,%ax
801014ff:	90                   	nop

80101500 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	56                   	push   %esi
80101504:	53                   	push   %ebx
80101505:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101507:	c1 ea 0c             	shr    $0xc,%edx
8010150a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101510:	83 ec 08             	sub    $0x8,%esp
80101513:	52                   	push   %edx
80101514:	50                   	push   %eax
80101515:	e8 b6 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010151a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010151c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101522:	ba 01 00 00 00       	mov    $0x1,%edx
80101527:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010152a:	c1 fb 03             	sar    $0x3,%ebx
8010152d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101530:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101532:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101537:	85 d1                	test   %edx,%ecx
80101539:	74 27                	je     80101562 <bfree+0x62>
8010153b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010153d:	f7 d2                	not    %edx
8010153f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101541:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101544:	21 d0                	and    %edx,%eax
80101546:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010154a:	56                   	push   %esi
8010154b:	e8 d0 1b 00 00       	call   80103120 <log_write>
  brelse(bp);
80101550:	89 34 24             	mov    %esi,(%esp)
80101553:	e8 88 ec ff ff       	call   801001e0 <brelse>
}
80101558:	83 c4 10             	add    $0x10,%esp
8010155b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155e:	5b                   	pop    %ebx
8010155f:	5e                   	pop    %esi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 d6 79 10 80       	push   $0x801079d6
8010156a:	e8 01 ee ff ff       	call   80100370 <panic>
8010156f:	90                   	nop

80101570 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101579:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010157f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101582:	85 c9                	test   %ecx,%ecx
80101584:	0f 84 85 00 00 00    	je     8010160f <balloc+0x9f>
8010158a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101591:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101594:	83 ec 08             	sub    $0x8,%esp
80101597:	89 f0                	mov    %esi,%eax
80101599:	c1 f8 0c             	sar    $0xc,%eax
8010159c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801015a2:	50                   	push   %eax
801015a3:	ff 75 d8             	pushl  -0x28(%ebp)
801015a6:	e8 25 eb ff ff       	call   801000d0 <bread>
801015ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801015ae:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801015b3:	83 c4 10             	add    $0x10,%esp
801015b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b9:	31 c0                	xor    %eax,%eax
801015bb:	eb 2d                	jmp    801015ea <balloc+0x7a>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801015c0:	89 c1                	mov    %eax,%ecx
801015c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801015ca:	83 e1 07             	and    $0x7,%ecx
801015cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015cf:	89 c1                	mov    %eax,%ecx
801015d1:	c1 f9 03             	sar    $0x3,%ecx
801015d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801015d9:	85 d7                	test   %edx,%edi
801015db:	74 43                	je     80101620 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015dd:	83 c0 01             	add    $0x1,%eax
801015e0:	83 c6 01             	add    $0x1,%esi
801015e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015e8:	74 05                	je     801015ef <balloc+0x7f>
801015ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801015ed:	72 d1                	jb     801015c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015ef:	83 ec 0c             	sub    $0xc,%esp
801015f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801015f5:	e8 e6 eb ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101601:	83 c4 10             	add    $0x10,%esp
80101604:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101607:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010160d:	77 82                	ja     80101591 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010160f:	83 ec 0c             	sub    $0xc,%esp
80101612:	68 e9 79 10 80       	push   $0x801079e9
80101617:	e8 54 ed ff ff       	call   80100370 <panic>
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101620:	09 fa                	or     %edi,%edx
80101622:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101625:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101628:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010162c:	57                   	push   %edi
8010162d:	e8 ee 1a 00 00       	call   80103120 <log_write>
        brelse(bp);
80101632:	89 3c 24             	mov    %edi,(%esp)
80101635:	e8 a6 eb ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010163a:	58                   	pop    %eax
8010163b:	5a                   	pop    %edx
8010163c:	56                   	push   %esi
8010163d:	ff 75 d8             	pushl  -0x28(%ebp)
80101640:	e8 8b ea ff ff       	call   801000d0 <bread>
80101645:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101647:	8d 40 5c             	lea    0x5c(%eax),%eax
8010164a:	83 c4 0c             	add    $0xc,%esp
8010164d:	68 00 02 00 00       	push   $0x200
80101652:	6a 00                	push   $0x0
80101654:	50                   	push   %eax
80101655:	e8 96 35 00 00       	call   80104bf0 <memset>
  log_write(bp);
8010165a:	89 1c 24             	mov    %ebx,(%esp)
8010165d:	e8 be 1a 00 00       	call   80103120 <log_write>
  brelse(bp);
80101662:	89 1c 24             	mov    %ebx,(%esp)
80101665:	e8 76 eb ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010166a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010166d:	89 f0                	mov    %esi,%eax
8010166f:	5b                   	pop    %ebx
80101670:	5e                   	pop    %esi
80101671:	5f                   	pop    %edi
80101672:	5d                   	pop    %ebp
80101673:	c3                   	ret    
80101674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010167a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101680 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101688:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010168a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010168f:	83 ec 28             	sub    $0x28,%esp
80101692:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101695:	68 e0 19 11 80       	push   $0x801119e0
8010169a:	e8 51 34 00 00       	call   80104af0 <acquire>
8010169f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016a5:	eb 1b                	jmp    801016c2 <iget+0x42>
801016a7:	89 f6                	mov    %esi,%esi
801016a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016b0:	85 f6                	test   %esi,%esi
801016b2:	74 44                	je     801016f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016ba:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801016c0:	74 4e                	je     80101710 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016c5:	85 c9                	test   %ecx,%ecx
801016c7:	7e e7                	jle    801016b0 <iget+0x30>
801016c9:	39 3b                	cmp    %edi,(%ebx)
801016cb:	75 e3                	jne    801016b0 <iget+0x30>
801016cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801016d0:	75 de                	jne    801016b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801016d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801016d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801016d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801016da:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801016df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801016e2:	e8 b9 34 00 00       	call   80104ba0 <release>
      return ip;
801016e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801016ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ed:	89 f0                	mov    %esi,%eax
801016ef:	5b                   	pop    %ebx
801016f0:	5e                   	pop    %esi
801016f1:	5f                   	pop    %edi
801016f2:	5d                   	pop    %ebp
801016f3:	c3                   	ret    
801016f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016f8:	85 c9                	test   %ecx,%ecx
801016fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016fd:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101703:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101709:	75 b7                	jne    801016c2 <iget+0x42>
8010170b:	90                   	nop
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101710:	85 f6                	test   %esi,%esi
80101712:	74 2d                	je     80101741 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101714:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101717:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101719:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010171c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101723:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010172a:	68 e0 19 11 80       	push   $0x801119e0
8010172f:	e8 6c 34 00 00       	call   80104ba0 <release>

  return ip;
80101734:	83 c4 10             	add    $0x10,%esp
}
80101737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173a:	89 f0                	mov    %esi,%eax
8010173c:	5b                   	pop    %ebx
8010173d:	5e                   	pop    %esi
8010173e:	5f                   	pop    %edi
8010173f:	5d                   	pop    %ebp
80101740:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101741:	83 ec 0c             	sub    $0xc,%esp
80101744:	68 ff 79 10 80       	push   $0x801079ff
80101749:	e8 22 ec ff ff       	call   80100370 <panic>
8010174e:	66 90                	xchg   %ax,%ax

80101750 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	89 c6                	mov    %eax,%esi
80101758:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010175b:	83 fa 0b             	cmp    $0xb,%edx
8010175e:	77 18                	ja     80101778 <bmap+0x28>
80101760:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101763:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101766:	85 c0                	test   %eax,%eax
80101768:	74 76                	je     801017e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010176a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010176d:	5b                   	pop    %ebx
8010176e:	5e                   	pop    %esi
8010176f:	5f                   	pop    %edi
80101770:	5d                   	pop    %ebp
80101771:	c3                   	ret    
80101772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101778:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010177b:	83 fb 7f             	cmp    $0x7f,%ebx
8010177e:	0f 87 83 00 00 00    	ja     80101807 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101784:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010178a:	85 c0                	test   %eax,%eax
8010178c:	74 6a                	je     801017f8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010178e:	83 ec 08             	sub    $0x8,%esp
80101791:	50                   	push   %eax
80101792:	ff 36                	pushl  (%esi)
80101794:	e8 37 e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101799:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010179d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801017a0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801017a2:	8b 1a                	mov    (%edx),%ebx
801017a4:	85 db                	test   %ebx,%ebx
801017a6:	75 1d                	jne    801017c5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801017a8:	8b 06                	mov    (%esi),%eax
801017aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801017ad:	e8 be fd ff ff       	call   80101570 <balloc>
801017b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801017b5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801017b8:	89 c3                	mov    %eax,%ebx
801017ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801017bc:	57                   	push   %edi
801017bd:	e8 5e 19 00 00       	call   80103120 <log_write>
801017c2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801017c5:	83 ec 0c             	sub    $0xc,%esp
801017c8:	57                   	push   %edi
801017c9:	e8 12 ea ff ff       	call   801001e0 <brelse>
801017ce:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801017d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801017d4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801017d6:	5b                   	pop    %ebx
801017d7:	5e                   	pop    %esi
801017d8:	5f                   	pop    %edi
801017d9:	5d                   	pop    %ebp
801017da:	c3                   	ret    
801017db:	90                   	nop
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801017e0:	8b 06                	mov    (%esi),%eax
801017e2:	e8 89 fd ff ff       	call   80101570 <balloc>
801017e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801017ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ed:	5b                   	pop    %ebx
801017ee:	5e                   	pop    %esi
801017ef:	5f                   	pop    %edi
801017f0:	5d                   	pop    %ebp
801017f1:	c3                   	ret    
801017f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017f8:	8b 06                	mov    (%esi),%eax
801017fa:	e8 71 fd ff ff       	call   80101570 <balloc>
801017ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101805:	eb 87                	jmp    8010178e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101807:	83 ec 0c             	sub    $0xc,%esp
8010180a:	68 0f 7a 10 80       	push   $0x80107a0f
8010180f:	e8 5c eb ff ff       	call   80100370 <panic>
80101814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010181a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101820 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101828:	83 ec 08             	sub    $0x8,%esp
8010182b:	6a 01                	push   $0x1
8010182d:	ff 75 08             	pushl  0x8(%ebp)
80101830:	e8 9b e8 ff ff       	call   801000d0 <bread>
80101835:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101837:	8d 40 5c             	lea    0x5c(%eax),%eax
8010183a:	83 c4 0c             	add    $0xc,%esp
8010183d:	6a 1c                	push   $0x1c
8010183f:	50                   	push   %eax
80101840:	56                   	push   %esi
80101841:	e8 5a 34 00 00       	call   80104ca0 <memmove>
  brelse(bp);
80101846:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101849:	83 c4 10             	add    $0x10,%esp
}
8010184c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010184f:	5b                   	pop    %ebx
80101850:	5e                   	pop    %esi
80101851:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101852:	e9 89 e9 ff ff       	jmp    801001e0 <brelse>
80101857:	89 f6                	mov    %esi,%esi
80101859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101860 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	53                   	push   %ebx
80101864:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101869:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010186c:	68 22 7a 10 80       	push   $0x80107a22
80101871:	68 e0 19 11 80       	push   $0x801119e0
80101876:	e8 15 31 00 00       	call   80104990 <initlock>
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	68 29 7a 10 80       	push   $0x80107a29
80101888:	53                   	push   %ebx
80101889:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010188f:	e8 cc 2f 00 00       	call   80104860 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101894:	83 c4 10             	add    $0x10,%esp
80101897:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010189d:	75 e1                	jne    80101880 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010189f:	83 ec 08             	sub    $0x8,%esp
801018a2:	68 c0 19 11 80       	push   $0x801119c0
801018a7:	ff 75 08             	pushl  0x8(%ebp)
801018aa:	e8 71 ff ff ff       	call   80101820 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018af:	ff 35 d8 19 11 80    	pushl  0x801119d8
801018b5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801018bb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801018c1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801018c7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801018cd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801018d3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801018d9:	68 8c 7a 10 80       	push   $0x80107a8c
801018de:	e8 7d ed ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801018e3:	83 c4 30             	add    $0x30,%esp
801018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018e9:	c9                   	leave  
801018ea:	c3                   	ret    
801018eb:	90                   	nop
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	53                   	push   %ebx
801018f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018f9:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101900:	8b 45 0c             	mov    0xc(%ebp),%eax
80101903:	8b 75 08             	mov    0x8(%ebp),%esi
80101906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101909:	0f 86 91 00 00 00    	jbe    801019a0 <ialloc+0xb0>
8010190f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101914:	eb 21                	jmp    80101937 <ialloc+0x47>
80101916:	8d 76 00             	lea    0x0(%esi),%esi
80101919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101920:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101923:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101926:	57                   	push   %edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010192c:	83 c4 10             	add    $0x10,%esp
8010192f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101935:	76 69                	jbe    801019a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101937:	89 d8                	mov    %ebx,%eax
80101939:	83 ec 08             	sub    $0x8,%esp
8010193c:	c1 e8 03             	shr    $0x3,%eax
8010193f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101945:	50                   	push   %eax
80101946:	56                   	push   %esi
80101947:	e8 84 e7 ff ff       	call   801000d0 <bread>
8010194c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010194e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101950:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101953:	83 e0 07             	and    $0x7,%eax
80101956:	c1 e0 06             	shl    $0x6,%eax
80101959:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010195d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101961:	75 bd                	jne    80101920 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101963:	83 ec 04             	sub    $0x4,%esp
80101966:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101969:	6a 40                	push   $0x40
8010196b:	6a 00                	push   $0x0
8010196d:	51                   	push   %ecx
8010196e:	e8 7d 32 00 00       	call   80104bf0 <memset>
      dip->type = type;
80101973:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101977:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010197a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010197d:	89 3c 24             	mov    %edi,(%esp)
80101980:	e8 9b 17 00 00       	call   80103120 <log_write>
      brelse(bp);
80101985:	89 3c 24             	mov    %edi,(%esp)
80101988:	e8 53 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010198d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101990:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101993:	89 da                	mov    %ebx,%edx
80101995:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101997:	5b                   	pop    %ebx
80101998:	5e                   	pop    %esi
80101999:	5f                   	pop    %edi
8010199a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010199b:	e9 e0 fc ff ff       	jmp    80101680 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801019a0:	83 ec 0c             	sub    $0xc,%esp
801019a3:	68 2f 7a 10 80       	push   $0x80107a2f
801019a8:	e8 c3 e9 ff ff       	call   80100370 <panic>
801019ad:	8d 76 00             	lea    0x0(%esi),%esi

801019b0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	56                   	push   %esi
801019b4:	53                   	push   %ebx
801019b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019b8:	83 ec 08             	sub    $0x8,%esp
801019bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019c1:	c1 e8 03             	shr    $0x3,%eax
801019c4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801019ca:	50                   	push   %eax
801019cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801019ce:	e8 fd e6 ff ff       	call   801000d0 <bread>
801019d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801019d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019df:	83 e0 07             	and    $0x7,%eax
801019e2:	c1 e0 06             	shl    $0x6,%eax
801019e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801019f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a03:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a07:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a0a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a0d:	6a 34                	push   $0x34
80101a0f:	53                   	push   %ebx
80101a10:	50                   	push   %eax
80101a11:	e8 8a 32 00 00       	call   80104ca0 <memmove>
  log_write(bp);
80101a16:	89 34 24             	mov    %esi,(%esp)
80101a19:	e8 02 17 00 00       	call   80103120 <log_write>
  brelse(bp);
80101a1e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a21:	83 c4 10             	add    $0x10,%esp
}
80101a24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a27:	5b                   	pop    %ebx
80101a28:	5e                   	pop    %esi
80101a29:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101a2a:	e9 b1 e7 ff ff       	jmp    801001e0 <brelse>
80101a2f:	90                   	nop

80101a30 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	53                   	push   %ebx
80101a34:	83 ec 10             	sub    $0x10,%esp
80101a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a3a:	68 e0 19 11 80       	push   $0x801119e0
80101a3f:	e8 ac 30 00 00       	call   80104af0 <acquire>
  ip->ref++;
80101a44:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a48:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a4f:	e8 4c 31 00 00       	call   80104ba0 <release>
  return ip;
}
80101a54:	89 d8                	mov    %ebx,%eax
80101a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a59:	c9                   	leave  
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a60 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	56                   	push   %esi
80101a64:	53                   	push   %ebx
80101a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a68:	85 db                	test   %ebx,%ebx
80101a6a:	0f 84 b7 00 00 00    	je     80101b27 <ilock+0xc7>
80101a70:	8b 53 08             	mov    0x8(%ebx),%edx
80101a73:	85 d2                	test   %edx,%edx
80101a75:	0f 8e ac 00 00 00    	jle    80101b27 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
80101a7b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a7e:	83 ec 0c             	sub    $0xc,%esp
80101a81:	50                   	push   %eax
80101a82:	e8 19 2e 00 00       	call   801048a0 <acquiresleep>

  if(ip->valid == 0){
80101a87:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a8a:	83 c4 10             	add    $0x10,%esp
80101a8d:	85 c0                	test   %eax,%eax
80101a8f:	74 0f                	je     80101aa0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101a91:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a94:	5b                   	pop    %ebx
80101a95:	5e                   	pop    %esi
80101a96:	5d                   	pop    %ebp
80101a97:	c3                   	ret    
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101aa0:	8b 43 04             	mov    0x4(%ebx),%eax
80101aa3:	83 ec 08             	sub    $0x8,%esp
80101aa6:	c1 e8 03             	shr    $0x3,%eax
80101aa9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101aaf:	50                   	push   %eax
80101ab0:	ff 33                	pushl  (%ebx)
80101ab2:	e8 19 e6 ff ff       	call   801000d0 <bread>
80101ab7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ab9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101abc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101abf:	83 e0 07             	and    $0x7,%eax
80101ac2:	c1 e0 06             	shl    $0x6,%eax
80101ac5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ac9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101acc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101acf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101ad3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101ad7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101adb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101adf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ae3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ae7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101aeb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101aee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101af1:	6a 34                	push   $0x34
80101af3:	50                   	push   %eax
80101af4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101af7:	50                   	push   %eax
80101af8:	e8 a3 31 00 00       	call   80104ca0 <memmove>
    brelse(bp);
80101afd:	89 34 24             	mov    %esi,(%esp)
80101b00:	e8 db e6 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101b05:	83 c4 10             	add    $0x10,%esp
80101b08:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
80101b0d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b14:	0f 85 77 ff ff ff    	jne    80101a91 <ilock+0x31>
      panic("ilock: no type");
80101b1a:	83 ec 0c             	sub    $0xc,%esp
80101b1d:	68 47 7a 10 80       	push   $0x80107a47
80101b22:	e8 49 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101b27:	83 ec 0c             	sub    $0xc,%esp
80101b2a:	68 41 7a 10 80       	push   $0x80107a41
80101b2f:	e8 3c e8 ff ff       	call   80100370 <panic>
80101b34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b40 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	56                   	push   %esi
80101b44:	53                   	push   %ebx
80101b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b48:	85 db                	test   %ebx,%ebx
80101b4a:	74 28                	je     80101b74 <iunlock+0x34>
80101b4c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b4f:	83 ec 0c             	sub    $0xc,%esp
80101b52:	56                   	push   %esi
80101b53:	e8 e8 2d 00 00       	call   80104940 <holdingsleep>
80101b58:	83 c4 10             	add    $0x10,%esp
80101b5b:	85 c0                	test   %eax,%eax
80101b5d:	74 15                	je     80101b74 <iunlock+0x34>
80101b5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b62:	85 c0                	test   %eax,%eax
80101b64:	7e 0e                	jle    80101b74 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101b66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b6c:	5b                   	pop    %ebx
80101b6d:	5e                   	pop    %esi
80101b6e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
80101b6f:	e9 8c 2d 00 00       	jmp    80104900 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101b74:	83 ec 0c             	sub    $0xc,%esp
80101b77:	68 56 7a 10 80       	push   $0x80107a56
80101b7c:	e8 ef e7 ff ff       	call   80100370 <panic>
80101b81:	eb 0d                	jmp    80101b90 <iput>
80101b83:	90                   	nop
80101b84:	90                   	nop
80101b85:	90                   	nop
80101b86:	90                   	nop
80101b87:	90                   	nop
80101b88:	90                   	nop
80101b89:	90                   	nop
80101b8a:	90                   	nop
80101b8b:	90                   	nop
80101b8c:	90                   	nop
80101b8d:	90                   	nop
80101b8e:	90                   	nop
80101b8f:	90                   	nop

80101b90 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 28             	sub    $0x28,%esp
80101b99:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
80101b9c:	8d 7e 0c             	lea    0xc(%esi),%edi
80101b9f:	57                   	push   %edi
80101ba0:	e8 fb 2c 00 00       	call   801048a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ba5:	8b 56 4c             	mov    0x4c(%esi),%edx
80101ba8:	83 c4 10             	add    $0x10,%esp
80101bab:	85 d2                	test   %edx,%edx
80101bad:	74 07                	je     80101bb6 <iput+0x26>
80101baf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101bb4:	74 32                	je     80101be8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101bb6:	83 ec 0c             	sub    $0xc,%esp
80101bb9:	57                   	push   %edi
80101bba:	e8 41 2d 00 00       	call   80104900 <releasesleep>

  acquire(&icache.lock);
80101bbf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bc6:	e8 25 2f 00 00       	call   80104af0 <acquire>
  ip->ref--;
80101bcb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101bcf:	83 c4 10             	add    $0x10,%esp
80101bd2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101bd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdc:	5b                   	pop    %ebx
80101bdd:	5e                   	pop    %esi
80101bde:	5f                   	pop    %edi
80101bdf:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101be0:	e9 bb 2f 00 00       	jmp    80104ba0 <release>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101be8:	83 ec 0c             	sub    $0xc,%esp
80101beb:	68 e0 19 11 80       	push   $0x801119e0
80101bf0:	e8 fb 2e 00 00       	call   80104af0 <acquire>
    int r = ip->ref;
80101bf5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101bf8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bff:	e8 9c 2f 00 00       	call   80104ba0 <release>
    if(r == 1){
80101c04:	83 c4 10             	add    $0x10,%esp
80101c07:	83 fb 01             	cmp    $0x1,%ebx
80101c0a:	75 aa                	jne    80101bb6 <iput+0x26>
80101c0c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101c12:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c15:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101c18:	89 cf                	mov    %ecx,%edi
80101c1a:	eb 0b                	jmp    80101c27 <iput+0x97>
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c20:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c23:	39 fb                	cmp    %edi,%ebx
80101c25:	74 19                	je     80101c40 <iput+0xb0>
    if(ip->addrs[i]){
80101c27:	8b 13                	mov    (%ebx),%edx
80101c29:	85 d2                	test   %edx,%edx
80101c2b:	74 f3                	je     80101c20 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c2d:	8b 06                	mov    (%esi),%eax
80101c2f:	e8 cc f8 ff ff       	call   80101500 <bfree>
      ip->addrs[i] = 0;
80101c34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101c3a:	eb e4                	jmp    80101c20 <iput+0x90>
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c40:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101c46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c49:	85 c0                	test   %eax,%eax
80101c4b:	75 33                	jne    80101c80 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c4d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101c50:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101c57:	56                   	push   %esi
80101c58:	e8 53 fd ff ff       	call   801019b0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101c5d:	31 c0                	xor    %eax,%eax
80101c5f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101c63:	89 34 24             	mov    %esi,(%esp)
80101c66:	e8 45 fd ff ff       	call   801019b0 <iupdate>
      ip->valid = 0;
80101c6b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	e9 3c ff ff ff       	jmp    80101bb6 <iput+0x26>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c80:	83 ec 08             	sub    $0x8,%esp
80101c83:	50                   	push   %eax
80101c84:	ff 36                	pushl  (%esi)
80101c86:	e8 45 e4 ff ff       	call   801000d0 <bread>
80101c8b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c91:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c97:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101c9a:	83 c4 10             	add    $0x10,%esp
80101c9d:	89 cf                	mov    %ecx,%edi
80101c9f:	eb 0e                	jmp    80101caf <iput+0x11f>
80101ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ca8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101cab:	39 fb                	cmp    %edi,%ebx
80101cad:	74 0f                	je     80101cbe <iput+0x12e>
      if(a[j])
80101caf:	8b 13                	mov    (%ebx),%edx
80101cb1:	85 d2                	test   %edx,%edx
80101cb3:	74 f3                	je     80101ca8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101cb5:	8b 06                	mov    (%esi),%eax
80101cb7:	e8 44 f8 ff ff       	call   80101500 <bfree>
80101cbc:	eb ea                	jmp    80101ca8 <iput+0x118>
    }
    brelse(bp);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
80101cc1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101cc4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cc7:	e8 14 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ccc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101cd2:	8b 06                	mov    (%esi),%eax
80101cd4:	e8 27 f8 ff ff       	call   80101500 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cd9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101ce0:	00 00 00 
80101ce3:	83 c4 10             	add    $0x10,%esp
80101ce6:	e9 62 ff ff ff       	jmp    80101c4d <iput+0xbd>
80101ceb:	90                   	nop
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	53                   	push   %ebx
80101cf4:	83 ec 10             	sub    $0x10,%esp
80101cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101cfa:	53                   	push   %ebx
80101cfb:	e8 40 fe ff ff       	call   80101b40 <iunlock>
  iput(ip);
80101d00:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d03:	83 c4 10             	add    $0x10,%esp
}
80101d06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d09:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101d0a:	e9 81 fe ff ff       	jmp    80101b90 <iput>
80101d0f:	90                   	nop

80101d10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	8b 55 08             	mov    0x8(%ebp),%edx
80101d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d19:	8b 0a                	mov    (%edx),%ecx
80101d1b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d21:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d28:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d33:	8b 52 58             	mov    0x58(%edx),%edx
80101d36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d39:	5d                   	pop    %ebp
80101d3a:	c3                   	ret    
80101d3b:	90                   	nop
80101d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d4f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d57:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d5a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101d5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d63:	0f 84 a7 00 00 00    	je     80101e10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	8b 40 58             	mov    0x58(%eax),%eax
80101d6f:	39 f0                	cmp    %esi,%eax
80101d71:	0f 82 c1 00 00 00    	jb     80101e38 <readi+0xf8>
80101d77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d7a:	89 fa                	mov    %edi,%edx
80101d7c:	01 f2                	add    %esi,%edx
80101d7e:	0f 82 b4 00 00 00    	jb     80101e38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d84:	89 c1                	mov    %eax,%ecx
80101d86:	29 f1                	sub    %esi,%ecx
80101d88:	39 d0                	cmp    %edx,%eax
80101d8a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d8d:	31 ff                	xor    %edi,%edi
80101d8f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d94:	74 6d                	je     80101e03 <readi+0xc3>
80101d96:	8d 76 00             	lea    0x0(%esi),%esi
80101d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101da0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101da3:	89 f2                	mov    %esi,%edx
80101da5:	c1 ea 09             	shr    $0x9,%edx
80101da8:	89 d8                	mov    %ebx,%eax
80101daa:	e8 a1 f9 ff ff       	call   80101750 <bmap>
80101daf:	83 ec 08             	sub    $0x8,%esp
80101db2:	50                   	push   %eax
80101db3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101db5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dba:	e8 11 e3 ff ff       	call   801000d0 <bread>
80101dbf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dc4:	89 f1                	mov    %esi,%ecx
80101dc6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101dcc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101dcf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101dd2:	29 cb                	sub    %ecx,%ebx
80101dd4:	29 f8                	sub    %edi,%eax
80101dd6:	39 c3                	cmp    %eax,%ebx
80101dd8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ddb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101ddf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101de0:	01 df                	add    %ebx,%edi
80101de2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101de4:	50                   	push   %eax
80101de5:	ff 75 e0             	pushl  -0x20(%ebp)
80101de8:	e8 b3 2e 00 00       	call   80104ca0 <memmove>
    brelse(bp);
80101ded:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101df0:	89 14 24             	mov    %edx,(%esp)
80101df3:	e8 e8 e3 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101df8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dfb:	83 c4 10             	add    $0x10,%esp
80101dfe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e01:	77 9d                	ja     80101da0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e09:	5b                   	pop    %ebx
80101e0a:	5e                   	pop    %esi
80101e0b:	5f                   	pop    %edi
80101e0c:	5d                   	pop    %ebp
80101e0d:	c3                   	ret    
80101e0e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e14:	66 83 f8 09          	cmp    $0x9,%ax
80101e18:	77 1e                	ja     80101e38 <readi+0xf8>
80101e1a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101e21:	85 c0                	test   %eax,%eax
80101e23:	74 13                	je     80101e38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101e25:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2b:	5b                   	pop    %ebx
80101e2c:	5e                   	pop    %esi
80101e2d:	5f                   	pop    %edi
80101e2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101e2f:	ff e0                	jmp    *%eax
80101e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e3d:	eb c7                	jmp    80101e06 <readi+0xc6>
80101e3f:	90                   	nop

80101e40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 1c             	sub    $0x1c,%esp
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e63:	0f 84 b7 00 00 00    	je     80101f20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e6f:	0f 82 eb 00 00 00    	jb     80101f60 <writei+0x120>
80101e75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e78:	89 f8                	mov    %edi,%eax
80101e7a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e7c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e81:	0f 87 d9 00 00 00    	ja     80101f60 <writei+0x120>
80101e87:	39 c6                	cmp    %eax,%esi
80101e89:	0f 87 d1 00 00 00    	ja     80101f60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e8f:	85 ff                	test   %edi,%edi
80101e91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e98:	74 78                	je     80101f12 <writei+0xd2>
80101e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ea0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ea3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eaa:	c1 ea 09             	shr    $0x9,%edx
80101ead:	89 f8                	mov    %edi,%eax
80101eaf:	e8 9c f8 ff ff       	call   80101750 <bmap>
80101eb4:	83 ec 08             	sub    $0x8,%esp
80101eb7:	50                   	push   %eax
80101eb8:	ff 37                	pushl  (%edi)
80101eba:	e8 11 e2 ff ff       	call   801000d0 <bread>
80101ebf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ec7:	89 f1                	mov    %esi,%ecx
80101ec9:	83 c4 0c             	add    $0xc,%esp
80101ecc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ed2:	29 cb                	sub    %ecx,%ebx
80101ed4:	39 c3                	cmp    %eax,%ebx
80101ed6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ed9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101edd:	53                   	push   %ebx
80101ede:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ee1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ee3:	50                   	push   %eax
80101ee4:	e8 b7 2d 00 00       	call   80104ca0 <memmove>
    log_write(bp);
80101ee9:	89 3c 24             	mov    %edi,(%esp)
80101eec:	e8 2f 12 00 00       	call   80103120 <log_write>
    brelse(bp);
80101ef1:	89 3c 24             	mov    %edi,(%esp)
80101ef4:	e8 e7 e2 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ef9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101efc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101eff:	83 c4 10             	add    $0x10,%esp
80101f02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f05:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101f08:	77 96                	ja     80101ea0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101f0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f0d:	3b 70 58             	cmp    0x58(%eax),%esi
80101f10:	77 36                	ja     80101f48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f12:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f18:	5b                   	pop    %ebx
80101f19:	5e                   	pop    %esi
80101f1a:	5f                   	pop    %edi
80101f1b:	5d                   	pop    %ebp
80101f1c:	c3                   	ret    
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f24:	66 83 f8 09          	cmp    $0x9,%ax
80101f28:	77 36                	ja     80101f60 <writei+0x120>
80101f2a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101f31:	85 c0                	test   %eax,%eax
80101f33:	74 2b                	je     80101f60 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101f35:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3b:	5b                   	pop    %ebx
80101f3c:	5e                   	pop    %esi
80101f3d:	5f                   	pop    %edi
80101f3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101f3f:	ff e0                	jmp    *%eax
80101f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101f48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f4b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101f4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f51:	50                   	push   %eax
80101f52:	e8 59 fa ff ff       	call   801019b0 <iupdate>
80101f57:	83 c4 10             	add    $0x10,%esp
80101f5a:	eb b6                	jmp    80101f12 <writei+0xd2>
80101f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f65:	eb ae                	jmp    80101f15 <writei+0xd5>
80101f67:	89 f6                	mov    %esi,%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f76:	6a 0e                	push   $0xe
80101f78:	ff 75 0c             	pushl  0xc(%ebp)
80101f7b:	ff 75 08             	pushl  0x8(%ebp)
80101f7e:	e8 9d 2d 00 00       	call   80104d20 <strncmp>
}
80101f83:	c9                   	leave  
80101f84:	c3                   	ret    
80101f85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 1c             	sub    $0x1c,%esp
80101f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101fa1:	0f 85 80 00 00 00    	jne    80102027 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa7:	8b 53 58             	mov    0x58(%ebx),%edx
80101faa:	31 ff                	xor    %edi,%edi
80101fac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101faf:	85 d2                	test   %edx,%edx
80101fb1:	75 0d                	jne    80101fc0 <dirlookup+0x30>
80101fb3:	eb 5b                	jmp    80102010 <dirlookup+0x80>
80101fb5:	8d 76 00             	lea    0x0(%esi),%esi
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101fbe:	76 50                	jbe    80102010 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 76 fd ff ff       	call   80101d40 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 48                	jne    8010201a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	74 df                	je     80101fb8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101fd9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdc:	83 ec 04             	sub    $0x4,%esp
80101fdf:	6a 0e                	push   $0xe
80101fe1:	50                   	push   %eax
80101fe2:	ff 75 0c             	pushl  0xc(%ebp)
80101fe5:	e8 36 2d 00 00       	call   80104d20 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	85 c0                	test   %eax,%eax
80101fef:	75 c7                	jne    80101fb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101ff1:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff4:	85 c0                	test   %eax,%eax
80101ff6:	74 05                	je     80101ffd <dirlookup+0x6d>
        *poff = off;
80101ff8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ffb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101ffd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80102001:	8b 03                	mov    (%ebx),%eax
80102003:	e8 78 f6 ff ff       	call   80101680 <iget>
    }
  }

  return 0;
}
80102008:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5f                   	pop    %edi
8010200e:	5d                   	pop    %ebp
8010200f:	c3                   	ret    
80102010:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102013:	31 c0                	xor    %eax,%eax
}
80102015:	5b                   	pop    %ebx
80102016:	5e                   	pop    %esi
80102017:	5f                   	pop    %edi
80102018:	5d                   	pop    %ebp
80102019:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
8010201a:	83 ec 0c             	sub    $0xc,%esp
8010201d:	68 70 7a 10 80       	push   $0x80107a70
80102022:	e8 49 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80102027:	83 ec 0c             	sub    $0xc,%esp
8010202a:	68 5e 7a 10 80       	push   $0x80107a5e
8010202f:	e8 3c e3 ff ff       	call   80100370 <panic>
80102034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010203a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102040 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	89 cf                	mov    %ecx,%edi
80102048:	89 c3                	mov    %eax,%ebx
8010204a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010204d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102050:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80102053:	0f 84 53 01 00 00    	je     801021ac <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102059:	e8 62 1b 00 00       	call   80103bc0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
8010205e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102061:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80102064:	68 e0 19 11 80       	push   $0x801119e0
80102069:	e8 82 2a 00 00       	call   80104af0 <acquire>
  ip->ref++;
8010206e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102072:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80102079:	e8 22 2b 00 00       	call   80104ba0 <release>
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	eb 08                	jmp    8010208b <namex+0x4b>
80102083:	90                   	nop
80102084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80102088:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010208b:	0f b6 03             	movzbl (%ebx),%eax
8010208e:	3c 2f                	cmp    $0x2f,%al
80102090:	74 f6                	je     80102088 <namex+0x48>
    path++;
  if(*path == 0)
80102092:	84 c0                	test   %al,%al
80102094:	0f 84 e3 00 00 00    	je     8010217d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010209a:	0f b6 03             	movzbl (%ebx),%eax
8010209d:	89 da                	mov    %ebx,%edx
8010209f:	84 c0                	test   %al,%al
801020a1:	0f 84 ac 00 00 00    	je     80102153 <namex+0x113>
801020a7:	3c 2f                	cmp    $0x2f,%al
801020a9:	75 09                	jne    801020b4 <namex+0x74>
801020ab:	e9 a3 00 00 00       	jmp    80102153 <namex+0x113>
801020b0:	84 c0                	test   %al,%al
801020b2:	74 0a                	je     801020be <namex+0x7e>
    path++;
801020b4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801020b7:	0f b6 02             	movzbl (%edx),%eax
801020ba:	3c 2f                	cmp    $0x2f,%al
801020bc:	75 f2                	jne    801020b0 <namex+0x70>
801020be:	89 d1                	mov    %edx,%ecx
801020c0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
801020c2:	83 f9 0d             	cmp    $0xd,%ecx
801020c5:	0f 8e 8d 00 00 00    	jle    80102158 <namex+0x118>
    memmove(name, s, DIRSIZ);
801020cb:	83 ec 04             	sub    $0x4,%esp
801020ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801020d1:	6a 0e                	push   $0xe
801020d3:	53                   	push   %ebx
801020d4:	57                   	push   %edi
801020d5:	e8 c6 2b 00 00       	call   80104ca0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
801020da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
801020dd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
801020e0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801020e2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801020e5:	75 11                	jne    801020f8 <namex+0xb8>
801020e7:	89 f6                	mov    %esi,%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801020f0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801020f3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020f6:	74 f8                	je     801020f0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	56                   	push   %esi
801020fc:	e8 5f f9 ff ff       	call   80101a60 <ilock>
    if(ip->type != T_DIR){
80102101:	83 c4 10             	add    $0x10,%esp
80102104:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102109:	0f 85 7f 00 00 00    	jne    8010218e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010210f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102112:	85 d2                	test   %edx,%edx
80102114:	74 09                	je     8010211f <namex+0xdf>
80102116:	80 3b 00             	cmpb   $0x0,(%ebx)
80102119:	0f 84 a3 00 00 00    	je     801021c2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010211f:	83 ec 04             	sub    $0x4,%esp
80102122:	6a 00                	push   $0x0
80102124:	57                   	push   %edi
80102125:	56                   	push   %esi
80102126:	e8 65 fe ff ff       	call   80101f90 <dirlookup>
8010212b:	83 c4 10             	add    $0x10,%esp
8010212e:	85 c0                	test   %eax,%eax
80102130:	74 5c                	je     8010218e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102132:	83 ec 0c             	sub    $0xc,%esp
80102135:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102138:	56                   	push   %esi
80102139:	e8 02 fa ff ff       	call   80101b40 <iunlock>
  iput(ip);
8010213e:	89 34 24             	mov    %esi,(%esp)
80102141:	e8 4a fa ff ff       	call   80101b90 <iput>
80102146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102149:	83 c4 10             	add    $0x10,%esp
8010214c:	89 c6                	mov    %eax,%esi
8010214e:	e9 38 ff ff ff       	jmp    8010208b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102153:	31 c9                	xor    %ecx,%ecx
80102155:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102158:	83 ec 04             	sub    $0x4,%esp
8010215b:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010215e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102161:	51                   	push   %ecx
80102162:	53                   	push   %ebx
80102163:	57                   	push   %edi
80102164:	e8 37 2b 00 00       	call   80104ca0 <memmove>
    name[len] = 0;
80102169:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010216c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010216f:	83 c4 10             	add    $0x10,%esp
80102172:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80102176:	89 d3                	mov    %edx,%ebx
80102178:	e9 65 ff ff ff       	jmp    801020e2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010217d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102180:	85 c0                	test   %eax,%eax
80102182:	75 54                	jne    801021d8 <namex+0x198>
80102184:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80102186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102189:	5b                   	pop    %ebx
8010218a:	5e                   	pop    %esi
8010218b:	5f                   	pop    %edi
8010218c:	5d                   	pop    %ebp
8010218d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010218e:	83 ec 0c             	sub    $0xc,%esp
80102191:	56                   	push   %esi
80102192:	e8 a9 f9 ff ff       	call   80101b40 <iunlock>
  iput(ip);
80102197:	89 34 24             	mov    %esi,(%esp)
8010219a:	e8 f1 f9 ff ff       	call   80101b90 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
8010219f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
801021a5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021a7:	5b                   	pop    %ebx
801021a8:	5e                   	pop    %esi
801021a9:	5f                   	pop    %edi
801021aa:	5d                   	pop    %ebp
801021ab:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
801021ac:	ba 01 00 00 00       	mov    $0x1,%edx
801021b1:	b8 01 00 00 00       	mov    $0x1,%eax
801021b6:	e8 c5 f4 ff ff       	call   80101680 <iget>
801021bb:	89 c6                	mov    %eax,%esi
801021bd:	e9 c9 fe ff ff       	jmp    8010208b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
801021c2:	83 ec 0c             	sub    $0xc,%esp
801021c5:	56                   	push   %esi
801021c6:	e8 75 f9 ff ff       	call   80101b40 <iunlock>
      return ip;
801021cb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
801021d1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021d3:	5b                   	pop    %ebx
801021d4:	5e                   	pop    %esi
801021d5:	5f                   	pop    %edi
801021d6:	5d                   	pop    %ebp
801021d7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	56                   	push   %esi
801021dc:	e8 af f9 ff ff       	call   80101b90 <iput>
    return 0;
801021e1:	83 c4 10             	add    $0x10,%esp
801021e4:	31 c0                	xor    %eax,%eax
801021e6:	eb 9e                	jmp    80102186 <namex+0x146>
801021e8:	90                   	nop
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021f0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 20             	sub    $0x20,%esp
801021f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021fc:	6a 00                	push   $0x0
801021fe:	ff 75 0c             	pushl  0xc(%ebp)
80102201:	53                   	push   %ebx
80102202:	e8 89 fd ff ff       	call   80101f90 <dirlookup>
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	85 c0                	test   %eax,%eax
8010220c:	75 67                	jne    80102275 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010220e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102211:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102214:	85 ff                	test   %edi,%edi
80102216:	74 29                	je     80102241 <dirlink+0x51>
80102218:	31 ff                	xor    %edi,%edi
8010221a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010221d:	eb 09                	jmp    80102228 <dirlink+0x38>
8010221f:	90                   	nop
80102220:	83 c7 10             	add    $0x10,%edi
80102223:	39 7b 58             	cmp    %edi,0x58(%ebx)
80102226:	76 19                	jbe    80102241 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102228:	6a 10                	push   $0x10
8010222a:	57                   	push   %edi
8010222b:	56                   	push   %esi
8010222c:	53                   	push   %ebx
8010222d:	e8 0e fb ff ff       	call   80101d40 <readi>
80102232:	83 c4 10             	add    $0x10,%esp
80102235:	83 f8 10             	cmp    $0x10,%eax
80102238:	75 4e                	jne    80102288 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
8010223a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010223f:	75 df                	jne    80102220 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102241:	8d 45 da             	lea    -0x26(%ebp),%eax
80102244:	83 ec 04             	sub    $0x4,%esp
80102247:	6a 0e                	push   $0xe
80102249:	ff 75 0c             	pushl  0xc(%ebp)
8010224c:	50                   	push   %eax
8010224d:	e8 3e 2b 00 00       	call   80104d90 <strncpy>
  de.inum = inum;
80102252:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102255:	6a 10                	push   $0x10
80102257:	57                   	push   %edi
80102258:	56                   	push   %esi
80102259:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
8010225a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010225e:	e8 dd fb ff ff       	call   80101e40 <writei>
80102263:	83 c4 20             	add    $0x20,%esp
80102266:	83 f8 10             	cmp    $0x10,%eax
80102269:	75 2a                	jne    80102295 <dirlink+0xa5>
    panic("dirlink");

  return 0;
8010226b:	31 c0                	xor    %eax,%eax
}
8010226d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102270:	5b                   	pop    %ebx
80102271:	5e                   	pop    %esi
80102272:	5f                   	pop    %edi
80102273:	5d                   	pop    %ebp
80102274:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	50                   	push   %eax
80102279:	e8 12 f9 ff ff       	call   80101b90 <iput>
    return -1;
8010227e:	83 c4 10             	add    $0x10,%esp
80102281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102286:	eb e5                	jmp    8010226d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80102288:	83 ec 0c             	sub    $0xc,%esp
8010228b:	68 7f 7a 10 80       	push   $0x80107a7f
80102290:	e8 db e0 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102295:	83 ec 0c             	sub    $0xc,%esp
80102298:	68 fa 80 10 80       	push   $0x801080fa
8010229d:	e8 ce e0 ff ff       	call   80100370 <panic>
801022a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022b0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
801022b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022b1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
801022b3:	89 e5                	mov    %esp,%ebp
801022b5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022b8:	8b 45 08             	mov    0x8(%ebp),%eax
801022bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801022be:	e8 7d fd ff ff       	call   80102040 <namex>
}
801022c3:	c9                   	leave  
801022c4:	c3                   	ret    
801022c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022d0:	55                   	push   %ebp
  return namex(path, 1, name);
801022d1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
801022d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022de:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
801022df:	e9 5c fd ff ff       	jmp    80102040 <namex>
801022e4:	66 90                	xchg   %ax,%ax
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022f0:	55                   	push   %ebp
  if(b == 0)
801022f1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022f3:	89 e5                	mov    %esp,%ebp
801022f5:	56                   	push   %esi
801022f6:	53                   	push   %ebx
  if(b == 0)
801022f7:	0f 84 ad 00 00 00    	je     801023aa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022fd:	8b 58 08             	mov    0x8(%eax),%ebx
80102300:	89 c1                	mov    %eax,%ecx
80102302:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102308:	0f 87 8f 00 00 00    	ja     8010239d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010230e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102313:	90                   	nop
80102314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102318:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102319:	83 e0 c0             	and    $0xffffffc0,%eax
8010231c:	3c 40                	cmp    $0x40,%al
8010231e:	75 f8                	jne    80102318 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102320:	31 f6                	xor    %esi,%esi
80102322:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102327:	89 f0                	mov    %esi,%eax
80102329:	ee                   	out    %al,(%dx)
8010232a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010232f:	b8 01 00 00 00       	mov    $0x1,%eax
80102334:	ee                   	out    %al,(%dx)
80102335:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010233a:	89 d8                	mov    %ebx,%eax
8010233c:	ee                   	out    %al,(%dx)
8010233d:	89 d8                	mov    %ebx,%eax
8010233f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102344:	c1 f8 08             	sar    $0x8,%eax
80102347:	ee                   	out    %al,(%dx)
80102348:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010234d:	89 f0                	mov    %esi,%eax
8010234f:	ee                   	out    %al,(%dx)
80102350:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102354:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102359:	83 e0 01             	and    $0x1,%eax
8010235c:	c1 e0 04             	shl    $0x4,%eax
8010235f:	83 c8 e0             	or     $0xffffffe0,%eax
80102362:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102363:	f6 01 04             	testb  $0x4,(%ecx)
80102366:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010236b:	75 13                	jne    80102380 <idestart+0x90>
8010236d:	b8 20 00 00 00       	mov    $0x20,%eax
80102372:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102373:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102376:	5b                   	pop    %ebx
80102377:	5e                   	pop    %esi
80102378:	5d                   	pop    %ebp
80102379:	c3                   	ret    
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102380:	b8 30 00 00 00       	mov    $0x30,%eax
80102385:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102386:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010238b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010238e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102393:	fc                   	cld    
80102394:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102396:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102399:	5b                   	pop    %ebx
8010239a:	5e                   	pop    %esi
8010239b:	5d                   	pop    %ebp
8010239c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010239d:	83 ec 0c             	sub    $0xc,%esp
801023a0:	68 e8 7a 10 80       	push   $0x80107ae8
801023a5:	e8 c6 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801023aa:	83 ec 0c             	sub    $0xc,%esp
801023ad:	68 df 7a 10 80       	push   $0x80107adf
801023b2:	e8 b9 df ff ff       	call   80100370 <panic>
801023b7:	89 f6                	mov    %esi,%esi
801023b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023c0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801023c6:	68 fa 7a 10 80       	push   $0x80107afa
801023cb:	68 80 b5 10 80       	push   $0x8010b580
801023d0:	e8 bb 25 00 00       	call   80104990 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023d5:	58                   	pop    %eax
801023d6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801023db:	5a                   	pop    %edx
801023dc:	83 e8 01             	sub    $0x1,%eax
801023df:	50                   	push   %eax
801023e0:	6a 0e                	push   $0xe
801023e2:	e8 a9 02 00 00       	call   80102690 <ioapicenable>
801023e7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ef:	90                   	nop
801023f0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023f1:	83 e0 c0             	and    $0xffffffc0,%eax
801023f4:	3c 40                	cmp    $0x40,%al
801023f6:	75 f8                	jne    801023f0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023f8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102402:	ee                   	out    %al,(%dx)
80102403:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102408:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010240d:	eb 06                	jmp    80102415 <ideinit+0x55>
8010240f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102410:	83 e9 01             	sub    $0x1,%ecx
80102413:	74 0f                	je     80102424 <ideinit+0x64>
80102415:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102416:	84 c0                	test   %al,%al
80102418:	74 f6                	je     80102410 <ideinit+0x50>
      havedisk1 = 1;
8010241a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102421:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102424:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102429:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010242e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010242f:	c9                   	leave  
80102430:	c3                   	ret    
80102431:	eb 0d                	jmp    80102440 <ideintr>
80102433:	90                   	nop
80102434:	90                   	nop
80102435:	90                   	nop
80102436:	90                   	nop
80102437:	90                   	nop
80102438:	90                   	nop
80102439:	90                   	nop
8010243a:	90                   	nop
8010243b:	90                   	nop
8010243c:	90                   	nop
8010243d:	90                   	nop
8010243e:	90                   	nop
8010243f:	90                   	nop

80102440 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	57                   	push   %edi
80102444:	56                   	push   %esi
80102445:	53                   	push   %ebx
80102446:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102449:	68 80 b5 10 80       	push   $0x8010b580
8010244e:	e8 9d 26 00 00       	call   80104af0 <acquire>

  if((b = idequeue) == 0){
80102453:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102459:	83 c4 10             	add    $0x10,%esp
8010245c:	85 db                	test   %ebx,%ebx
8010245e:	74 34                	je     80102494 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102460:	8b 43 58             	mov    0x58(%ebx),%eax
80102463:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102468:	8b 33                	mov    (%ebx),%esi
8010246a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102470:	74 3e                	je     801024b0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102472:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102475:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102478:	83 ce 02             	or     $0x2,%esi
8010247b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010247d:	53                   	push   %ebx
8010247e:	e8 2d 22 00 00       	call   801046b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102483:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	85 c0                	test   %eax,%eax
8010248d:	74 05                	je     80102494 <ideintr+0x54>
    idestart(idequeue);
8010248f:	e8 5c fe ff ff       	call   801022f0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102494:	83 ec 0c             	sub    $0xc,%esp
80102497:	68 80 b5 10 80       	push   $0x8010b580
8010249c:	e8 ff 26 00 00       	call   80104ba0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801024a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024a4:	5b                   	pop    %ebx
801024a5:	5e                   	pop    %esi
801024a6:	5f                   	pop    %edi
801024a7:	5d                   	pop    %ebp
801024a8:	c3                   	ret    
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024b5:	8d 76 00             	lea    0x0(%esi),%esi
801024b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024b9:	89 c1                	mov    %eax,%ecx
801024bb:	83 e1 c0             	and    $0xffffffc0,%ecx
801024be:	80 f9 40             	cmp    $0x40,%cl
801024c1:	75 f5                	jne    801024b8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024c3:	a8 21                	test   $0x21,%al
801024c5:	75 ab                	jne    80102472 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801024c7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801024ca:	b9 80 00 00 00       	mov    $0x80,%ecx
801024cf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024d4:	fc                   	cld    
801024d5:	f3 6d                	rep insl (%dx),%es:(%edi)
801024d7:	8b 33                	mov    (%ebx),%esi
801024d9:	eb 97                	jmp    80102472 <ideintr+0x32>
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 10             	sub    $0x10,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801024ed:	50                   	push   %eax
801024ee:	e8 4d 24 00 00       	call   80104940 <holdingsleep>
801024f3:	83 c4 10             	add    $0x10,%esp
801024f6:	85 c0                	test   %eax,%eax
801024f8:	0f 84 ad 00 00 00    	je     801025ab <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024fe:	8b 03                	mov    (%ebx),%eax
80102500:	83 e0 06             	and    $0x6,%eax
80102503:	83 f8 02             	cmp    $0x2,%eax
80102506:	0f 84 b9 00 00 00    	je     801025c5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010250c:	8b 53 04             	mov    0x4(%ebx),%edx
8010250f:	85 d2                	test   %edx,%edx
80102511:	74 0d                	je     80102520 <iderw+0x40>
80102513:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102518:	85 c0                	test   %eax,%eax
8010251a:	0f 84 98 00 00 00    	je     801025b8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 80 b5 10 80       	push   $0x8010b580
80102528:	e8 c3 25 00 00       	call   80104af0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010252d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102533:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102536:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010253d:	85 d2                	test   %edx,%edx
8010253f:	75 09                	jne    8010254a <iderw+0x6a>
80102541:	eb 58                	jmp    8010259b <iderw+0xbb>
80102543:	90                   	nop
80102544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102548:	89 c2                	mov    %eax,%edx
8010254a:	8b 42 58             	mov    0x58(%edx),%eax
8010254d:	85 c0                	test   %eax,%eax
8010254f:	75 f7                	jne    80102548 <iderw+0x68>
80102551:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102554:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102556:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010255c:	74 44                	je     801025a2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010255e:	8b 03                	mov    (%ebx),%eax
80102560:	83 e0 06             	and    $0x6,%eax
80102563:	83 f8 02             	cmp    $0x2,%eax
80102566:	74 23                	je     8010258b <iderw+0xab>
80102568:	90                   	nop
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102570:	83 ec 08             	sub    $0x8,%esp
80102573:	68 80 b5 10 80       	push   $0x8010b580
80102578:	53                   	push   %ebx
80102579:	e8 72 1f 00 00       	call   801044f0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010257e:	8b 03                	mov    (%ebx),%eax
80102580:	83 c4 10             	add    $0x10,%esp
80102583:	83 e0 06             	and    $0x6,%eax
80102586:	83 f8 02             	cmp    $0x2,%eax
80102589:	75 e5                	jne    80102570 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010258b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102595:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102596:	e9 05 26 00 00       	jmp    80104ba0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010259b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025a0:	eb b2                	jmp    80102554 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801025a2:	89 d8                	mov    %ebx,%eax
801025a4:	e8 47 fd ff ff       	call   801022f0 <idestart>
801025a9:	eb b3                	jmp    8010255e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801025ab:	83 ec 0c             	sub    $0xc,%esp
801025ae:	68 fe 7a 10 80       	push   $0x80107afe
801025b3:	e8 b8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	68 29 7b 10 80       	push   $0x80107b29
801025c0:	e8 ab dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025c5:	83 ec 0c             	sub    $0xc,%esp
801025c8:	68 14 7b 10 80       	push   $0x80107b14
801025cd:	e8 9e dd ff ff       	call   80100370 <panic>
801025d2:	66 90                	xchg   %ax,%ax
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025e1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801025e8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025eb:	89 e5                	mov    %esp,%ebp
801025ed:	56                   	push   %esi
801025ee:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025f6:	00 00 00 
  return ioapic->data;
801025f9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801025ff:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102602:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102608:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010260e:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102615:	89 f0                	mov    %esi,%eax
80102617:	c1 e8 10             	shr    $0x10,%eax
8010261a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010261d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102620:	c1 e8 18             	shr    $0x18,%eax
80102623:	39 d0                	cmp    %edx,%eax
80102625:	74 16                	je     8010263d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102627:	83 ec 0c             	sub    $0xc,%esp
8010262a:	68 48 7b 10 80       	push   $0x80107b48
8010262f:	e8 2c e0 ff ff       	call   80100660 <cprintf>
80102634:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010263a:	83 c4 10             	add    $0x10,%esp
8010263d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102640:	ba 10 00 00 00       	mov    $0x10,%edx
80102645:	b8 20 00 00 00       	mov    $0x20,%eax
8010264a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102650:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102652:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102658:	89 c3                	mov    %eax,%ebx
8010265a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102660:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102663:	89 59 10             	mov    %ebx,0x10(%ecx)
80102666:	8d 5a 01             	lea    0x1(%edx),%ebx
80102669:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010266c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010266e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102670:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102676:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010267d:	75 d1                	jne    80102650 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010267f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102682:	5b                   	pop    %ebx
80102683:	5e                   	pop    %esi
80102684:	5d                   	pop    %ebp
80102685:	c3                   	ret    
80102686:	8d 76 00             	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102690:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102691:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102697:	89 e5                	mov    %esp,%ebp
80102699:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010269c:	8d 50 20             	lea    0x20(%eax),%edx
8010269f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026a5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ae:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026b1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026b6:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026bb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801026be:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret    
801026c3:	66 90                	xchg   %ax,%ax
801026c5:	66 90                	xchg   %ax,%ax
801026c7:	66 90                	xchg   %ax,%ax
801026c9:	66 90                	xchg   %ax,%ax
801026cb:	66 90                	xchg   %ax,%ax
801026cd:	66 90                	xchg   %ax,%ax
801026cf:	90                   	nop

801026d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	53                   	push   %ebx
801026d4:	83 ec 04             	sub    $0x4,%esp
801026d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026e0:	75 70                	jne    80102752 <kfree+0x82>
801026e2:	81 fb a8 6c 11 80    	cmp    $0x80116ca8,%ebx
801026e8:	72 68                	jb     80102752 <kfree+0x82>
801026ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026f5:	77 5b                	ja     80102752 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026f7:	83 ec 04             	sub    $0x4,%esp
801026fa:	68 00 10 00 00       	push   $0x1000
801026ff:	6a 01                	push   $0x1
80102701:	53                   	push   %ebx
80102702:	e8 e9 24 00 00       	call   80104bf0 <memset>

  if(kmem.use_lock)
80102707:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	85 d2                	test   %edx,%edx
80102712:	75 2c                	jne    80102740 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102714:	a1 78 36 11 80       	mov    0x80113678,%eax
80102719:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010271b:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102720:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102726:	85 c0                	test   %eax,%eax
80102728:	75 06                	jne    80102730 <kfree+0x60>
    release(&kmem.lock);
}
8010272a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010272d:	c9                   	leave  
8010272e:	c3                   	ret    
8010272f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102730:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010273a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010273b:	e9 60 24 00 00       	jmp    80104ba0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 40 36 11 80       	push   $0x80113640
80102748:	e8 a3 23 00 00       	call   80104af0 <acquire>
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	eb c2                	jmp    80102714 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102752:	83 ec 0c             	sub    $0xc,%esp
80102755:	68 7a 7b 10 80       	push   $0x80107b7a
8010275a:	e8 11 dc ff ff       	call   80100370 <panic>
8010275f:	90                   	nop

80102760 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	56                   	push   %esi
80102764:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102765:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102768:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010276b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102771:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102777:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010277d:	39 de                	cmp    %ebx,%esi
8010277f:	72 23                	jb     801027a4 <freerange+0x44>
80102781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102788:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010278e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102791:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102797:	50                   	push   %eax
80102798:	e8 33 ff ff ff       	call   801026d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	39 f3                	cmp    %esi,%ebx
801027a2:	76 e4                	jbe    80102788 <freerange+0x28>
    kfree(p);
}
801027a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027a7:	5b                   	pop    %ebx
801027a8:	5e                   	pop    %esi
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	56                   	push   %esi
801027b4:	53                   	push   %ebx
801027b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027b8:	83 ec 08             	sub    $0x8,%esp
801027bb:	68 80 7b 10 80       	push   $0x80107b80
801027c0:	68 40 36 11 80       	push   $0x80113640
801027c5:	e8 c6 21 00 00       	call   80104990 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801027d0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801027d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ec:	39 de                	cmp    %ebx,%esi
801027ee:	72 1c                	jb     8010280c <kinit1+0x5c>
    kfree(p);
801027f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027ff:	50                   	push   %eax
80102800:	e8 cb fe ff ff       	call   801026d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102805:	83 c4 10             	add    $0x10,%esp
80102808:	39 de                	cmp    %ebx,%esi
8010280a:	73 e4                	jae    801027f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010280c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010280f:	5b                   	pop    %ebx
80102810:	5e                   	pop    %esi
80102811:	5d                   	pop    %ebp
80102812:	c3                   	ret    
80102813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	56                   	push   %esi
80102824:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102825:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102828:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010282b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102831:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102837:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010283d:	39 de                	cmp    %ebx,%esi
8010283f:	72 23                	jb     80102864 <kinit2+0x44>
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102848:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010284e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102851:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102857:	50                   	push   %eax
80102858:	e8 73 fe ff ff       	call   801026d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	39 de                	cmp    %ebx,%esi
80102862:	73 e4                	jae    80102848 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102864:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010286b:	00 00 00 
}
8010286e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102871:	5b                   	pop    %ebx
80102872:	5e                   	pop    %esi
80102873:	5d                   	pop    %ebp
80102874:	c3                   	ret    
80102875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102880 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	53                   	push   %ebx
80102884:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102887:	a1 74 36 11 80       	mov    0x80113674,%eax
8010288c:	85 c0                	test   %eax,%eax
8010288e:	75 30                	jne    801028c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102890:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102896:	85 db                	test   %ebx,%ebx
80102898:	74 1c                	je     801028b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010289a:	8b 13                	mov    (%ebx),%edx
8010289c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801028a2:	85 c0                	test   %eax,%eax
801028a4:	74 10                	je     801028b6 <kalloc+0x36>
    release(&kmem.lock);
801028a6:	83 ec 0c             	sub    $0xc,%esp
801028a9:	68 40 36 11 80       	push   $0x80113640
801028ae:	e8 ed 22 00 00       	call   80104ba0 <release>
801028b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801028b6:	89 d8                	mov    %ebx,%eax
801028b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028bb:	c9                   	leave  
801028bc:	c3                   	ret    
801028bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801028c0:	83 ec 0c             	sub    $0xc,%esp
801028c3:	68 40 36 11 80       	push   $0x80113640
801028c8:	e8 23 22 00 00       	call   80104af0 <acquire>
  r = kmem.freelist;
801028cd:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801028d3:	83 c4 10             	add    $0x10,%esp
801028d6:	a1 74 36 11 80       	mov    0x80113674,%eax
801028db:	85 db                	test   %ebx,%ebx
801028dd:	75 bb                	jne    8010289a <kalloc+0x1a>
801028df:	eb c1                	jmp    801028a2 <kalloc+0x22>
801028e1:	66 90                	xchg   %ax,%ax
801028e3:	66 90                	xchg   %ax,%ax
801028e5:	66 90                	xchg   %ax,%ax
801028e7:	66 90                	xchg   %ax,%ax
801028e9:	66 90                	xchg   %ax,%ax
801028eb:	66 90                	xchg   %ax,%ax
801028ed:	66 90                	xchg   %ax,%ax
801028ef:	90                   	nop

801028f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f1:	ba 64 00 00 00       	mov    $0x64,%edx
801028f6:	89 e5                	mov    %esp,%ebp
801028f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028f9:	a8 01                	test   $0x1,%al
801028fb:	0f 84 af 00 00 00    	je     801029b0 <kbdgetc+0xc0>
80102901:	ba 60 00 00 00       	mov    $0x60,%edx
80102906:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102907:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010290a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102910:	74 7e                	je     80102990 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102912:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102914:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010291a:	79 24                	jns    80102940 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010291c:	f6 c1 40             	test   $0x40,%cl
8010291f:	75 05                	jne    80102926 <kbdgetc+0x36>
80102921:	89 c2                	mov    %eax,%edx
80102923:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102926:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
8010292d:	83 c8 40             	or     $0x40,%eax
80102930:	0f b6 c0             	movzbl %al,%eax
80102933:	f7 d0                	not    %eax
80102935:	21 c8                	and    %ecx,%eax
80102937:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010293c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010293e:	5d                   	pop    %ebp
8010293f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102940:	f6 c1 40             	test   $0x40,%cl
80102943:	74 09                	je     8010294e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102945:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102948:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010294b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010294e:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
80102955:	09 c1                	or     %eax,%ecx
80102957:	0f b6 82 c0 7b 10 80 	movzbl -0x7fef8440(%edx),%eax
8010295e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102960:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102962:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102968:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010296b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010296e:	8b 04 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%eax
80102975:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102979:	74 c3                	je     8010293e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010297b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010297e:	83 fa 19             	cmp    $0x19,%edx
80102981:	77 1d                	ja     801029a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102983:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    
80102988:	90                   	nop
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102990:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102992:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102999:	5d                   	pop    %ebp
8010299a:	c3                   	ret    
8010299b:	90                   	nop
8010299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801029a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801029a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801029a7:	83 f9 19             	cmp    $0x19,%ecx
801029aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801029ad:	c3                   	ret    
801029ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801029b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029b5:	5d                   	pop    %ebp
801029b6:	c3                   	ret    
801029b7:	89 f6                	mov    %esi,%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029c0 <kbdintr>:

void
kbdintr(void)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029c6:	68 f0 28 10 80       	push   $0x801028f0
801029cb:	e8 20 de ff ff       	call   801007f0 <consoleintr>
}
801029d0:	83 c4 10             	add    $0x10,%esp
801029d3:	c9                   	leave  
801029d4:	c3                   	ret    
801029d5:	66 90                	xchg   %ax,%ax
801029d7:	66 90                	xchg   %ax,%ax
801029d9:	66 90                	xchg   %ax,%ax
801029db:	66 90                	xchg   %ax,%ax
801029dd:	66 90                	xchg   %ax,%ax
801029df:	90                   	nop

801029e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029e0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801029e5:	55                   	push   %ebp
801029e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029e8:	85 c0                	test   %eax,%eax
801029ea:	0f 84 c8 00 00 00    	je     80102ab8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a07:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a0a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a11:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a14:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a17:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a1e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a21:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a24:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a2b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a31:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a3e:	8b 50 30             	mov    0x30(%eax),%edx
80102a41:	c1 ea 10             	shr    $0x10,%edx
80102a44:	80 fa 03             	cmp    $0x3,%dl
80102a47:	77 77                	ja     80102ac0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a49:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a56:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a60:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a63:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a70:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a77:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a7d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a87:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a8a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a91:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a94:	8b 50 20             	mov    0x20(%eax),%edx
80102a97:	89 f6                	mov    %esi,%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102aa0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102aa6:	80 e6 10             	and    $0x10,%dh
80102aa9:	75 f5                	jne    80102aa0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ab2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ab8:	5d                   	pop    %ebp
80102ab9:	c3                   	ret    
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ac0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ac7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aca:	8b 50 20             	mov    0x20(%eax),%edx
80102acd:	e9 77 ff ff ff       	jmp    80102a49 <lapicinit+0x69>
80102ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102ae0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	74 0c                	je     80102af8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102aec:	8b 40 20             	mov    0x20(%eax),%eax
}
80102aef:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102af0:	c1 e8 18             	shr    $0x18,%eax
}
80102af3:	c3                   	ret    
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102af8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b00:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b05:	55                   	push   %ebp
80102b06:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b08:	85 c0                	test   %eax,%eax
80102b0a:	74 0d                	je     80102b19 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b0c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b13:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b16:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102b19:	5d                   	pop    %ebp
80102b1a:	c3                   	ret    
80102b1b:	90                   	nop
80102b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b20 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
}
80102b23:	5d                   	pop    %ebp
80102b24:	c3                   	ret    
80102b25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b30:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b31:	ba 70 00 00 00       	mov    $0x70,%edx
80102b36:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b3b:	89 e5                	mov    %esp,%ebp
80102b3d:	53                   	push   %ebx
80102b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b44:	ee                   	out    %al,(%dx)
80102b45:	ba 71 00 00 00       	mov    $0x71,%edx
80102b4a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b50:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b52:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b5d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b60:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b63:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b65:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b68:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b6e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b79:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b86:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b93:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ba8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bb1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bb7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102bba:	5b                   	pop    %ebx
80102bbb:	5d                   	pop    %ebp
80102bbc:	c3                   	ret    
80102bbd:	8d 76 00             	lea    0x0(%esi),%esi

80102bc0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bc0:	55                   	push   %ebp
80102bc1:	ba 70 00 00 00       	mov    $0x70,%edx
80102bc6:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bcb:	89 e5                	mov    %esp,%ebp
80102bcd:	57                   	push   %edi
80102bce:	56                   	push   %esi
80102bcf:	53                   	push   %ebx
80102bd0:	83 ec 4c             	sub    $0x4c,%esp
80102bd3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bd9:	ec                   	in     (%dx),%al
80102bda:	83 e0 04             	and    $0x4,%eax
80102bdd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be0:	31 db                	xor    %ebx,%ebx
80102be2:	88 45 b7             	mov    %al,-0x49(%ebp)
80102be5:	bf 70 00 00 00       	mov    $0x70,%edi
80102bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bf0:	89 d8                	mov    %ebx,%eax
80102bf2:	89 fa                	mov    %edi,%edx
80102bf4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bfa:	89 ca                	mov    %ecx,%edx
80102bfc:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102bfd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c00:	89 fa                	mov    %edi,%edx
80102c02:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c05:	b8 02 00 00 00       	mov    $0x2,%eax
80102c0a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0b:	89 ca                	mov    %ecx,%edx
80102c0d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c0e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c11:	89 fa                	mov    %edi,%edx
80102c13:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c16:	b8 04 00 00 00       	mov    $0x4,%eax
80102c1b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1c:	89 ca                	mov    %ecx,%edx
80102c1e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c1f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c22:	89 fa                	mov    %edi,%edx
80102c24:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c27:	b8 07 00 00 00       	mov    $0x7,%eax
80102c2c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2d:	89 ca                	mov    %ecx,%edx
80102c2f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c30:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c33:	89 fa                	mov    %edi,%edx
80102c35:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c38:	b8 08 00 00 00       	mov    $0x8,%eax
80102c3d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3e:	89 ca                	mov    %ecx,%edx
80102c40:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c41:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c44:	89 fa                	mov    %edi,%edx
80102c46:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c49:	b8 09 00 00 00       	mov    $0x9,%eax
80102c4e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4f:	89 ca                	mov    %ecx,%edx
80102c51:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c52:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c55:	89 fa                	mov    %edi,%edx
80102c57:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c5a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c5f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c60:	89 ca                	mov    %ecx,%edx
80102c62:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c63:	84 c0                	test   %al,%al
80102c65:	78 89                	js     80102bf0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c67:	89 d8                	mov    %ebx,%eax
80102c69:	89 fa                	mov    %edi,%edx
80102c6b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c6f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 fa                	mov    %edi,%edx
80102c74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c77:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c80:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 fa                	mov    %edi,%edx
80102c85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c88:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c91:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 fa                	mov    %edi,%edx
80102c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c99:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102ca2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 fa                	mov    %edi,%edx
80102ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102caa:	b8 08 00 00 00       	mov    $0x8,%eax
80102caf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102cb3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 fa                	mov    %edi,%edx
80102cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc1:	89 ca                	mov    %ecx,%edx
80102cc3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102cc4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccd:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd0:	6a 18                	push   $0x18
80102cd2:	56                   	push   %esi
80102cd3:	50                   	push   %eax
80102cd4:	e8 67 1f 00 00       	call   80104c40 <memcmp>
80102cd9:	83 c4 10             	add    $0x10,%esp
80102cdc:	85 c0                	test   %eax,%eax
80102cde:	0f 85 0c ff ff ff    	jne    80102bf0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102ce4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102ce8:	75 78                	jne    80102d62 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cea:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ced:	89 c2                	mov    %eax,%edx
80102cef:	83 e0 0f             	and    $0xf,%eax
80102cf2:	c1 ea 04             	shr    $0x4,%edx
80102cf5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cfe:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d01:	89 c2                	mov    %eax,%edx
80102d03:	83 e0 0f             	and    $0xf,%eax
80102d06:	c1 ea 04             	shr    $0x4,%edx
80102d09:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d0f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d12:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d15:	89 c2                	mov    %eax,%edx
80102d17:	83 e0 0f             	and    $0xf,%eax
80102d1a:	c1 ea 04             	shr    $0x4,%edx
80102d1d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d20:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d23:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d29:	89 c2                	mov    %eax,%edx
80102d2b:	83 e0 0f             	and    $0xf,%eax
80102d2e:	c1 ea 04             	shr    $0x4,%edx
80102d31:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d34:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d37:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d3a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d3d:	89 c2                	mov    %eax,%edx
80102d3f:	83 e0 0f             	and    $0xf,%eax
80102d42:	c1 ea 04             	shr    $0x4,%edx
80102d45:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d48:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d51:	89 c2                	mov    %eax,%edx
80102d53:	83 e0 0f             	and    $0xf,%eax
80102d56:	c1 ea 04             	shr    $0x4,%edx
80102d59:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d5f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d62:	8b 75 08             	mov    0x8(%ebp),%esi
80102d65:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d68:	89 06                	mov    %eax,(%esi)
80102d6a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d6d:	89 46 04             	mov    %eax,0x4(%esi)
80102d70:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d73:	89 46 08             	mov    %eax,0x8(%esi)
80102d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d79:	89 46 0c             	mov    %eax,0xc(%esi)
80102d7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d7f:	89 46 10             	mov    %eax,0x10(%esi)
80102d82:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d85:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d88:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d92:	5b                   	pop    %ebx
80102d93:	5e                   	pop    %esi
80102d94:	5f                   	pop    %edi
80102d95:	5d                   	pop    %ebp
80102d96:	c3                   	ret    
80102d97:	66 90                	xchg   %ax,%ax
80102d99:	66 90                	xchg   %ax,%ax
80102d9b:	66 90                	xchg   %ax,%ax
80102d9d:	66 90                	xchg   %ax,%ax
80102d9f:	90                   	nop

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 85 00 00 00    	jle    80102e33 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
80102db2:	56                   	push   %esi
80102db3:	53                   	push   %ebx
80102db4:	31 db                	xor    %ebx,%ebx
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 d8                	add    %ebx,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102de4:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
80102df2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102df7:	83 c4 0c             	add    $0xc,%esp
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 97 1e 00 00       	call   80104ca0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 8f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e11:	89 3c 24             	mov    %edi,(%esp)
80102e14:	e8 c7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e19:	89 34 24             	mov    %esi,(%esp)
80102e1c:	e8 bf d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	f3 c3                	repz ret 
80102e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e47:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e4d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e53:	e8 78 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e58:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e5e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e61:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e63:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e65:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e68:	7e 1f                	jle    80102e89 <write_head+0x49>
80102e6a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e71:	31 d2                	xor    %edx,%edx
80102e73:	90                   	nop
80102e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e78:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e7e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e82:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e85:	39 c2                	cmp    %eax,%edx
80102e87:	75 ef                	jne    80102e78 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e89:	83 ec 0c             	sub    $0xc,%esp
80102e8c:	53                   	push   %ebx
80102e8d:	e8 0e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e92:	89 1c 24             	mov    %ebx,(%esp)
80102e95:	e8 46 d3 ff ff       	call   801001e0 <brelse>
}
80102e9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e9d:	c9                   	leave  
80102e9e:	c3                   	ret    
80102e9f:	90                   	nop

80102ea0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 2c             	sub    $0x2c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102eaa:	68 c0 7d 10 80       	push   $0x80107dc0
80102eaf:	68 80 36 11 80       	push   $0x80113680
80102eb4:	e8 d7 1a 00 00       	call   80104990 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 5b e9 ff ff       	call   80101820 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ecb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102ecc:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ed2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ed8:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ee5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102eed:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	7e 1c                	jle    80102f11 <initlog+0x71>
80102ef5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102efc:	31 d2                	xor    %edx,%edx
80102efe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f04:	83 c2 04             	add    $0x4,%edx
80102f07:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102f0d:	39 da                	cmp    %ebx,%edx
80102f0f:	75 ef                	jne    80102f00 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102f11:	83 ec 0c             	sub    $0xc,%esp
80102f14:	50                   	push   %eax
80102f15:	e8 c6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1a:	e8 81 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f1f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f26:	00 00 00 
  write_head(); // clear the log
80102f29:	e8 12 ff ff ff       	call   80102e40 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102f2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f31:	c9                   	leave  
80102f32:	c3                   	ret    
80102f33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 80 36 11 80       	push   $0x80113680
80102f4b:	e8 a0 1b 00 00       	call   80104af0 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 80 36 11 80       	push   $0x80113680
80102f60:	68 80 36 11 80       	push   $0x80113680
80102f65:	e8 86 15 00 00       	call   801044f0 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f6d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f7b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f92:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102f97:	68 80 36 11 80       	push   $0x80113680
80102f9c:	e8 ff 1b 00 00       	call   80104ba0 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 80 36 11 80       	push   $0x80113680
80102fbe:	e8 2d 1b 00 00       	call   80104af0 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102fc8:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102fce:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fd1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102fd4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fd6:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102fdb:	0f 85 23 01 00 00    	jne    80103104 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe1:	85 c0                	test   %eax,%eax
80102fe3:	0f 85 f7 00 00 00    	jne    801030e0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fe9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102fec:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102ff3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ff6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ff8:	68 80 36 11 80       	push   $0x80113680
80102ffd:	e8 9e 1b 00 00       	call   80104ba0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103002:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103008:	83 c4 10             	add    $0x10,%esp
8010300b:	85 c9                	test   %ecx,%ecx
8010300d:	0f 8e 8a 00 00 00    	jle    8010309d <end_op+0xed>
80103013:	90                   	nop
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103018:	a1 b4 36 11 80       	mov    0x801136b4,%eax
8010301d:	83 ec 08             	sub    $0x8,%esp
80103020:	01 d8                	add    %ebx,%eax
80103022:	83 c0 01             	add    $0x1,%eax
80103025:	50                   	push   %eax
80103026:	ff 35 c4 36 11 80    	pushl  0x801136c4
8010302c:	e8 9f d0 ff ff       	call   801000d0 <bread>
80103031:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103033:	58                   	pop    %eax
80103034:	5a                   	pop    %edx
80103035:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
8010303c:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103042:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103045:	e8 86 d0 ff ff       	call   801000d0 <bread>
8010304a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010304c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010304f:	83 c4 0c             	add    $0xc,%esp
80103052:	68 00 02 00 00       	push   $0x200
80103057:	50                   	push   %eax
80103058:	8d 46 5c             	lea    0x5c(%esi),%eax
8010305b:	50                   	push   %eax
8010305c:	e8 3f 1c 00 00       	call   80104ca0 <memmove>
    bwrite(to);  // write the log
80103061:	89 34 24             	mov    %esi,(%esp)
80103064:	e8 37 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103069:	89 3c 24             	mov    %edi,(%esp)
8010306c:	e8 6f d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103071:	89 34 24             	mov    %esi,(%esp)
80103074:	e8 67 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103079:	83 c4 10             	add    $0x10,%esp
8010307c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80103082:	7c 94                	jl     80103018 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103084:	e8 b7 fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
80103089:	e8 12 fd ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
8010308e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103095:	00 00 00 
    write_head();    // Erase the transaction from the log
80103098:	e8 a3 fd ff ff       	call   80102e40 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010309d:	83 ec 0c             	sub    $0xc,%esp
801030a0:	68 80 36 11 80       	push   $0x80113680
801030a5:	e8 46 1a 00 00       	call   80104af0 <acquire>
    log.committing = 0;
    wakeup(&log);
801030aa:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
801030b1:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
801030b8:	00 00 00 
    wakeup(&log);
801030bb:	e8 f0 15 00 00       	call   801046b0 <wakeup>
    release(&log.lock);
801030c0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030c7:	e8 d4 1a 00 00       	call   80104ba0 <release>
801030cc:	83 c4 10             	add    $0x10,%esp
  }
}
801030cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	89 f6                	mov    %esi,%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	68 80 36 11 80       	push   $0x80113680
801030e8:	e8 c3 15 00 00       	call   801046b0 <wakeup>
  }
  release(&log.lock);
801030ed:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030f4:	e8 a7 1a 00 00       	call   80104ba0 <release>
801030f9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801030fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ff:	5b                   	pop    %ebx
80103100:	5e                   	pop    %esi
80103101:	5f                   	pop    %edi
80103102:	5d                   	pop    %ebp
80103103:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80103104:	83 ec 0c             	sub    $0xc,%esp
80103107:	68 c4 7d 10 80       	push   $0x80107dc4
8010310c:	e8 5f d2 ff ff       	call   80100370 <panic>
80103111:	eb 0d                	jmp    80103120 <log_write>
80103113:	90                   	nop
80103114:	90                   	nop
80103115:	90                   	nop
80103116:	90                   	nop
80103117:	90                   	nop
80103118:	90                   	nop
80103119:	90                   	nop
8010311a:	90                   	nop
8010311b:	90                   	nop
8010311c:	90                   	nop
8010311d:	90                   	nop
8010311e:	90                   	nop
8010311f:	90                   	nop

80103120 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103127:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010312d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103130:	83 fa 1d             	cmp    $0x1d,%edx
80103133:	0f 8f 97 00 00 00    	jg     801031d0 <log_write+0xb0>
80103139:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010313e:	83 e8 01             	sub    $0x1,%eax
80103141:	39 c2                	cmp    %eax,%edx
80103143:	0f 8d 87 00 00 00    	jge    801031d0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103149:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010314e:	85 c0                	test   %eax,%eax
80103150:	0f 8e 87 00 00 00    	jle    801031dd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103156:	83 ec 0c             	sub    $0xc,%esp
80103159:	68 80 36 11 80       	push   $0x80113680
8010315e:	e8 8d 19 00 00       	call   80104af0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103163:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103169:	83 c4 10             	add    $0x10,%esp
8010316c:	83 fa 00             	cmp    $0x0,%edx
8010316f:	7e 50                	jle    801031c1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103171:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103174:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103176:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
8010317c:	75 0b                	jne    80103189 <log_write+0x69>
8010317e:	eb 38                	jmp    801031b8 <log_write+0x98>
80103180:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103187:	74 2f                	je     801031b8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103189:	83 c0 01             	add    $0x1,%eax
8010318c:	39 d0                	cmp    %edx,%eax
8010318e:	75 f0                	jne    80103180 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103190:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103197:	83 c2 01             	add    $0x1,%edx
8010319a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
801031a0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031a3:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
801031aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031ad:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
801031ae:	e9 ed 19 00 00       	jmp    80104ba0 <release>
801031b3:	90                   	nop
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801031b8:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
801031bf:	eb df                	jmp    801031a0 <log_write+0x80>
801031c1:	8b 43 08             	mov    0x8(%ebx),%eax
801031c4:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
801031c9:	75 d5                	jne    801031a0 <log_write+0x80>
801031cb:	eb ca                	jmp    80103197 <log_write+0x77>
801031cd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
801031d0:	83 ec 0c             	sub    $0xc,%esp
801031d3:	68 d3 7d 10 80       	push   $0x80107dd3
801031d8:	e8 93 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
801031dd:	83 ec 0c             	sub    $0xc,%esp
801031e0:	68 e9 7d 10 80       	push   $0x80107de9
801031e5:	e8 86 d1 ff ff       	call   80100370 <panic>
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	53                   	push   %ebx
801031f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031f7:	e8 a4 09 00 00       	call   80103ba0 <cpuid>
801031fc:	89 c3                	mov    %eax,%ebx
801031fe:	e8 9d 09 00 00       	call   80103ba0 <cpuid>
80103203:	83 ec 04             	sub    $0x4,%esp
80103206:	53                   	push   %ebx
80103207:	50                   	push   %eax
80103208:	68 04 7e 10 80       	push   $0x80107e04
8010320d:	e8 4e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103212:	e8 f9 2e 00 00       	call   80106110 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103217:	e8 04 09 00 00       	call   80103b20 <mycpu>
8010321c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010321e:	b8 01 00 00 00       	mov    $0x1,%eax
80103223:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010322a:	e8 e1 0c 00 00       	call   80103f10 <scheduler>
8010322f:	90                   	nop

80103230 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103236:	e8 f5 3f 00 00       	call   80107230 <switchkvm>
  seginit();
8010323b:	e8 f0 3e 00 00       	call   80107130 <seginit>
  lapicinit();
80103240:	e8 9b f7 ff ff       	call   801029e0 <lapicinit>
  mpmain();
80103245:	e8 a6 ff ff ff       	call   801031f0 <mpmain>
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103250:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103254:	83 e4 f0             	and    $0xfffffff0,%esp
80103257:	ff 71 fc             	pushl  -0x4(%ecx)
8010325a:	55                   	push   %ebp
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	53                   	push   %ebx
8010325e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010325f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103264:	83 ec 08             	sub    $0x8,%esp
80103267:	68 00 00 40 80       	push   $0x80400000
8010326c:	68 a8 6c 11 80       	push   $0x80116ca8
80103271:	e8 3a f5 ff ff       	call   801027b0 <kinit1>
  kvmalloc();      // kernel page table
80103276:	e8 55 44 00 00       	call   801076d0 <kvmalloc>
  mpinit();        // detect other processors
8010327b:	e8 70 01 00 00       	call   801033f0 <mpinit>
  lapicinit();     // interrupt controller
80103280:	e8 5b f7 ff ff       	call   801029e0 <lapicinit>
  seginit();       // segment descriptors
80103285:	e8 a6 3e 00 00       	call   80107130 <seginit>
  picinit();       // disable pic
8010328a:	e8 31 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010328f:	e8 4c f3 ff ff       	call   801025e0 <ioapicinit>
  consoleinit();   // console hardware
80103294:	e8 07 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103299:	e8 62 31 00 00       	call   80106400 <uartinit>
  pinit();         // process table
8010329e:	e8 5d 08 00 00       	call   80103b00 <pinit>
  tvinit();        // trap vectors
801032a3:	e8 c8 2d 00 00       	call   80106070 <tvinit>
  binit();         // buffer cache
801032a8:	e8 93 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032ad:	e8 9e de ff ff       	call   80101150 <fileinit>
  ideinit();       // disk 
801032b2:	e8 09 f1 ff ff       	call   801023c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032b7:	83 c4 0c             	add    $0xc,%esp
801032ba:	68 8a 00 00 00       	push   $0x8a
801032bf:	68 8c b4 10 80       	push   $0x8010b48c
801032c4:	68 00 70 00 80       	push   $0x80007000
801032c9:	e8 d2 19 00 00       	call   80104ca0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032ce:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032d5:	00 00 00 
801032d8:	83 c4 10             	add    $0x10,%esp
801032db:	05 80 37 11 80       	add    $0x80113780,%eax
801032e0:	39 d8                	cmp    %ebx,%eax
801032e2:	76 6f                	jbe    80103353 <main+0x103>
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801032e8:	e8 33 08 00 00       	call   80103b20 <mycpu>
801032ed:	39 d8                	cmp    %ebx,%eax
801032ef:	74 49                	je     8010333a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032f1:	e8 8a f5 ff ff       	call   80102880 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032f6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801032fb:	c7 05 f8 6f 00 80 30 	movl   $0x80103230,0x80006ff8
80103302:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103305:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010330c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010330f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103314:	0f b6 03             	movzbl (%ebx),%eax
80103317:	83 ec 08             	sub    $0x8,%esp
8010331a:	68 00 70 00 00       	push   $0x7000
8010331f:	50                   	push   %eax
80103320:	e8 0b f8 ff ff       	call   80102b30 <lapicstartap>
80103325:	83 c4 10             	add    $0x10,%esp
80103328:	90                   	nop
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103330:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103336:	85 c0                	test   %eax,%eax
80103338:	74 f6                	je     80103330 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010333a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103341:	00 00 00 
80103344:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010334a:	05 80 37 11 80       	add    $0x80113780,%eax
8010334f:	39 c3                	cmp    %eax,%ebx
80103351:	72 95                	jb     801032e8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103353:	83 ec 08             	sub    $0x8,%esp
80103356:	68 00 00 00 8e       	push   $0x8e000000
8010335b:	68 00 00 40 80       	push   $0x80400000
80103360:	e8 bb f4 ff ff       	call   80102820 <kinit2>
  userinit();      // first user process
80103365:	e8 86 08 00 00       	call   80103bf0 <userinit>
  mpmain();        // finish this processor's setup
8010336a:	e8 81 fe ff ff       	call   801031f0 <mpmain>
8010336f:	90                   	nop

80103370 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103375:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010337b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010337c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010337f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103382:	39 de                	cmp    %ebx,%esi
80103384:	73 48                	jae    801033ce <mpsearch1+0x5e>
80103386:	8d 76 00             	lea    0x0(%esi),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103390:	83 ec 04             	sub    $0x4,%esp
80103393:	8d 7e 10             	lea    0x10(%esi),%edi
80103396:	6a 04                	push   $0x4
80103398:	68 18 7e 10 80       	push   $0x80107e18
8010339d:	56                   	push   %esi
8010339e:	e8 9d 18 00 00       	call   80104c40 <memcmp>
801033a3:	83 c4 10             	add    $0x10,%esp
801033a6:	85 c0                	test   %eax,%eax
801033a8:	75 1e                	jne    801033c8 <mpsearch1+0x58>
801033aa:	8d 7e 10             	lea    0x10(%esi),%edi
801033ad:	89 f2                	mov    %esi,%edx
801033af:	31 c9                	xor    %ecx,%ecx
801033b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
801033b8:	0f b6 02             	movzbl (%edx),%eax
801033bb:	83 c2 01             	add    $0x1,%edx
801033be:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801033c0:	39 fa                	cmp    %edi,%edx
801033c2:	75 f4                	jne    801033b8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033c4:	84 c9                	test   %cl,%cl
801033c6:	74 10                	je     801033d8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801033c8:	39 fb                	cmp    %edi,%ebx
801033ca:	89 fe                	mov    %edi,%esi
801033cc:	77 c2                	ja     80103390 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801033ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801033d1:	31 c0                	xor    %eax,%eax
}
801033d3:	5b                   	pop    %ebx
801033d4:	5e                   	pop    %esi
801033d5:	5f                   	pop    %edi
801033d6:	5d                   	pop    %ebp
801033d7:	c3                   	ret    
801033d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033db:	89 f0                	mov    %esi,%eax
801033dd:	5b                   	pop    %ebx
801033de:	5e                   	pop    %esi
801033df:	5f                   	pop    %edi
801033e0:	5d                   	pop    %ebp
801033e1:	c3                   	ret    
801033e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103400:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103407:	c1 e0 08             	shl    $0x8,%eax
8010340a:	09 d0                	or     %edx,%eax
8010340c:	c1 e0 04             	shl    $0x4,%eax
8010340f:	85 c0                	test   %eax,%eax
80103411:	75 1b                	jne    8010342e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103413:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010341a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103421:	c1 e0 08             	shl    $0x8,%eax
80103424:	09 d0                	or     %edx,%eax
80103426:	c1 e0 0a             	shl    $0xa,%eax
80103429:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010342e:	ba 00 04 00 00       	mov    $0x400,%edx
80103433:	e8 38 ff ff ff       	call   80103370 <mpsearch1>
80103438:	85 c0                	test   %eax,%eax
8010343a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010343d:	0f 84 37 01 00 00    	je     8010357a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103446:	8b 58 04             	mov    0x4(%eax),%ebx
80103449:	85 db                	test   %ebx,%ebx
8010344b:	0f 84 43 01 00 00    	je     80103594 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103451:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103457:	83 ec 04             	sub    $0x4,%esp
8010345a:	6a 04                	push   $0x4
8010345c:	68 1d 7e 10 80       	push   $0x80107e1d
80103461:	56                   	push   %esi
80103462:	e8 d9 17 00 00       	call   80104c40 <memcmp>
80103467:	83 c4 10             	add    $0x10,%esp
8010346a:	85 c0                	test   %eax,%eax
8010346c:	0f 85 22 01 00 00    	jne    80103594 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103472:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103479:	3c 01                	cmp    $0x1,%al
8010347b:	74 08                	je     80103485 <mpinit+0x95>
8010347d:	3c 04                	cmp    $0x4,%al
8010347f:	0f 85 0f 01 00 00    	jne    80103594 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103485:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010348c:	85 ff                	test   %edi,%edi
8010348e:	74 21                	je     801034b1 <mpinit+0xc1>
80103490:	31 d2                	xor    %edx,%edx
80103492:	31 c0                	xor    %eax,%eax
80103494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103498:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010349f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034a0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034a3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034a5:	39 c7                	cmp    %eax,%edi
801034a7:	75 ef                	jne    80103498 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801034a9:	84 d2                	test   %dl,%dl
801034ab:	0f 85 e3 00 00 00    	jne    80103594 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801034b1:	85 f6                	test   %esi,%esi
801034b3:	0f 84 db 00 00 00    	je     80103594 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034b9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034bf:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034c4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034cb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801034d1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d6:	01 d6                	add    %edx,%esi
801034d8:	90                   	nop
801034d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034e0:	39 c6                	cmp    %eax,%esi
801034e2:	76 23                	jbe    80103507 <mpinit+0x117>
801034e4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801034e7:	80 fa 04             	cmp    $0x4,%dl
801034ea:	0f 87 c0 00 00 00    	ja     801035b0 <mpinit+0x1c0>
801034f0:	ff 24 95 5c 7e 10 80 	jmp    *-0x7fef81a4(,%edx,4)
801034f7:	89 f6                	mov    %esi,%esi
801034f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103500:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103503:	39 c6                	cmp    %eax,%esi
80103505:	77 dd                	ja     801034e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103507:	85 db                	test   %ebx,%ebx
80103509:	0f 84 92 00 00 00    	je     801035a1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010350f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103512:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103516:	74 15                	je     8010352d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103518:	ba 22 00 00 00       	mov    $0x22,%edx
8010351d:	b8 70 00 00 00       	mov    $0x70,%eax
80103522:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103523:	ba 23 00 00 00       	mov    $0x23,%edx
80103528:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103529:	83 c8 01             	or     $0x1,%eax
8010352c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010352d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103530:	5b                   	pop    %ebx
80103531:	5e                   	pop    %esi
80103532:	5f                   	pop    %edi
80103533:	5d                   	pop    %ebp
80103534:	c3                   	ret    
80103535:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103538:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010353e:	83 f9 07             	cmp    $0x7,%ecx
80103541:	7f 19                	jg     8010355c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103543:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103547:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010354d:	83 c1 01             	add    $0x1,%ecx
80103550:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103556:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010355c:	83 c0 14             	add    $0x14,%eax
      continue;
8010355f:	e9 7c ff ff ff       	jmp    801034e0 <mpinit+0xf0>
80103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103568:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010356c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010356f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103575:	e9 66 ff ff ff       	jmp    801034e0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010357a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010357f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103584:	e8 e7 fd ff ff       	call   80103370 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103589:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010358b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010358e:	0f 85 af fe ff ff    	jne    80103443 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103594:	83 ec 0c             	sub    $0xc,%esp
80103597:	68 22 7e 10 80       	push   $0x80107e22
8010359c:	e8 cf cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801035a1:	83 ec 0c             	sub    $0xc,%esp
801035a4:	68 3c 7e 10 80       	push   $0x80107e3c
801035a9:	e8 c2 cd ff ff       	call   80100370 <panic>
801035ae:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801035b0:	31 db                	xor    %ebx,%ebx
801035b2:	e9 30 ff ff ff       	jmp    801034e7 <mpinit+0xf7>
801035b7:	66 90                	xchg   %ax,%ax
801035b9:	66 90                	xchg   %ax,%ax
801035bb:	66 90                	xchg   %ax,%ax
801035bd:	66 90                	xchg   %ax,%ax
801035bf:	90                   	nop

801035c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035c0:	55                   	push   %ebp
801035c1:	ba 21 00 00 00       	mov    $0x21,%edx
801035c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035cb:	89 e5                	mov    %esp,%ebp
801035cd:	ee                   	out    %al,(%dx)
801035ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801035d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035d4:	5d                   	pop    %ebp
801035d5:	c3                   	ret    
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	8b 75 08             	mov    0x8(%ebp),%esi
801035ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801035f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035fb:	e8 70 db ff ff       	call   80101170 <filealloc>
80103600:	85 c0                	test   %eax,%eax
80103602:	89 06                	mov    %eax,(%esi)
80103604:	0f 84 a8 00 00 00    	je     801036b2 <pipealloc+0xd2>
8010360a:	e8 61 db ff ff       	call   80101170 <filealloc>
8010360f:	85 c0                	test   %eax,%eax
80103611:	89 03                	mov    %eax,(%ebx)
80103613:	0f 84 87 00 00 00    	je     801036a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103619:	e8 62 f2 ff ff       	call   80102880 <kalloc>
8010361e:	85 c0                	test   %eax,%eax
80103620:	89 c7                	mov    %eax,%edi
80103622:	0f 84 b0 00 00 00    	je     801036d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103628:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010362b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103632:	00 00 00 
  p->writeopen = 1;
80103635:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010363c:	00 00 00 
  p->nwrite = 0;
8010363f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103646:	00 00 00 
  p->nread = 0;
80103649:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103650:	00 00 00 
  initlock(&p->lock, "pipe");
80103653:	68 70 7e 10 80       	push   $0x80107e70
80103658:	50                   	push   %eax
80103659:	e8 32 13 00 00       	call   80104990 <initlock>
  (*f0)->type = FD_PIPE;
8010365e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103660:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103663:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103669:	8b 06                	mov    (%esi),%eax
8010366b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010366f:	8b 06                	mov    (%esi),%eax
80103671:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103675:	8b 06                	mov    (%esi),%eax
80103677:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010367a:	8b 03                	mov    (%ebx),%eax
8010367c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103682:	8b 03                	mov    (%ebx),%eax
80103684:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103688:	8b 03                	mov    (%ebx),%eax
8010368a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010368e:	8b 03                	mov    (%ebx),%eax
80103690:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103693:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103696:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103698:	5b                   	pop    %ebx
80103699:	5e                   	pop    %esi
8010369a:	5f                   	pop    %edi
8010369b:	5d                   	pop    %ebp
8010369c:	c3                   	ret    
8010369d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036a0:	8b 06                	mov    (%esi),%eax
801036a2:	85 c0                	test   %eax,%eax
801036a4:	74 1e                	je     801036c4 <pipealloc+0xe4>
    fileclose(*f0);
801036a6:	83 ec 0c             	sub    $0xc,%esp
801036a9:	50                   	push   %eax
801036aa:	e8 81 db ff ff       	call   80101230 <fileclose>
801036af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036b2:	8b 03                	mov    (%ebx),%eax
801036b4:	85 c0                	test   %eax,%eax
801036b6:	74 0c                	je     801036c4 <pipealloc+0xe4>
    fileclose(*f1);
801036b8:	83 ec 0c             	sub    $0xc,%esp
801036bb:	50                   	push   %eax
801036bc:	e8 6f db ff ff       	call   80101230 <fileclose>
801036c1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801036c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	75 c8                	jne    801036a6 <pipealloc+0xc6>
801036de:	eb d2                	jmp    801036b2 <pipealloc+0xd2>

801036e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036eb:	83 ec 0c             	sub    $0xc,%esp
801036ee:	53                   	push   %ebx
801036ef:	e8 fc 13 00 00       	call   80104af0 <acquire>
  if(writable){
801036f4:	83 c4 10             	add    $0x10,%esp
801036f7:	85 f6                	test   %esi,%esi
801036f9:	74 45                	je     80103740 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103701:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103704:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010370b:	00 00 00 
    wakeup(&p->nread);
8010370e:	50                   	push   %eax
8010370f:	e8 9c 0f 00 00       	call   801046b0 <wakeup>
80103714:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103717:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010371d:	85 d2                	test   %edx,%edx
8010371f:	75 0a                	jne    8010372b <pipeclose+0x4b>
80103721:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103727:	85 c0                	test   %eax,%eax
80103729:	74 35                	je     80103760 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010372b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010372e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103731:	5b                   	pop    %ebx
80103732:	5e                   	pop    %esi
80103733:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103734:	e9 67 14 00 00       	jmp    80104ba0 <release>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103740:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103746:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103749:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103750:	00 00 00 
    wakeup(&p->nwrite);
80103753:	50                   	push   %eax
80103754:	e8 57 0f 00 00       	call   801046b0 <wakeup>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	eb b9                	jmp    80103717 <pipeclose+0x37>
8010375e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 37 14 00 00       	call   80104ba0 <release>
    kfree((char*)p);
80103769:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010376c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010376f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103772:	5b                   	pop    %ebx
80103773:	5e                   	pop    %esi
80103774:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103775:	e9 56 ef ff ff       	jmp    801026d0 <kfree>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103780 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 28             	sub    $0x28,%esp
80103789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010378c:	53                   	push   %ebx
8010378d:	e8 5e 13 00 00       	call   80104af0 <acquire>
  for(i = 0; i < n; i++){
80103792:	8b 45 10             	mov    0x10(%ebp),%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	0f 8e b9 00 00 00    	jle    80103859 <pipewrite+0xd9>
801037a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037a3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037af:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037b8:	03 4d 10             	add    0x10(%ebp),%ecx
801037bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037be:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037c4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037ca:	39 d0                	cmp    %edx,%eax
801037cc:	74 38                	je     80103806 <pipewrite+0x86>
801037ce:	eb 59                	jmp    80103829 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801037d0:	e8 eb 03 00 00       	call   80103bc0 <myproc>
801037d5:	8b 48 24             	mov    0x24(%eax),%ecx
801037d8:	85 c9                	test   %ecx,%ecx
801037da:	75 34                	jne    80103810 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037dc:	83 ec 0c             	sub    $0xc,%esp
801037df:	57                   	push   %edi
801037e0:	e8 cb 0e 00 00       	call   801046b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e5:	58                   	pop    %eax
801037e6:	5a                   	pop    %edx
801037e7:	53                   	push   %ebx
801037e8:	56                   	push   %esi
801037e9:	e8 02 0d 00 00       	call   801044f0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037fa:	83 c4 10             	add    $0x10,%esp
801037fd:	05 00 02 00 00       	add    $0x200,%eax
80103802:	39 c2                	cmp    %eax,%edx
80103804:	75 2a                	jne    80103830 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103806:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010380c:	85 c0                	test   %eax,%eax
8010380e:	75 c0                	jne    801037d0 <pipewrite+0x50>
        release(&p->lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	53                   	push   %ebx
80103814:	e8 87 13 00 00       	call   80104ba0 <release>
        return -1;
80103819:	83 c4 10             	add    $0x10,%esp
8010381c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103824:	5b                   	pop    %ebx
80103825:	5e                   	pop    %esi
80103826:	5f                   	pop    %edi
80103827:	5d                   	pop    %ebp
80103828:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103829:	89 c2                	mov    %eax,%edx
8010382b:	90                   	nop
8010382c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103830:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103833:	8d 42 01             	lea    0x1(%edx),%eax
80103836:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010383a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103840:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103846:	0f b6 09             	movzbl (%ecx),%ecx
80103849:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010384d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103850:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103853:	0f 85 65 ff ff ff    	jne    801037be <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103859:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010385f:	83 ec 0c             	sub    $0xc,%esp
80103862:	50                   	push   %eax
80103863:	e8 48 0e 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
80103868:	89 1c 24             	mov    %ebx,(%esp)
8010386b:	e8 30 13 00 00       	call   80104ba0 <release>
  return n;
80103870:	83 c4 10             	add    $0x10,%esp
80103873:	8b 45 10             	mov    0x10(%ebp),%eax
80103876:	eb a9                	jmp    80103821 <pipewrite+0xa1>
80103878:	90                   	nop
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 18             	sub    $0x18,%esp
80103889:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010388c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010388f:	53                   	push   %ebx
80103890:	e8 5b 12 00 00       	call   80104af0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010389e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801038a4:	75 6a                	jne    80103910 <piperead+0x90>
801038a6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801038ac:	85 f6                	test   %esi,%esi
801038ae:	0f 84 cc 00 00 00    	je     80103980 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038b4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801038ba:	eb 2d                	jmp    801038e9 <piperead+0x69>
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038c0:	83 ec 08             	sub    $0x8,%esp
801038c3:	53                   	push   %ebx
801038c4:	56                   	push   %esi
801038c5:	e8 26 0c 00 00       	call   801044f0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ca:	83 c4 10             	add    $0x10,%esp
801038cd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801038d3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801038d9:	75 35                	jne    80103910 <piperead+0x90>
801038db:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801038e1:	85 d2                	test   %edx,%edx
801038e3:	0f 84 97 00 00 00    	je     80103980 <piperead+0x100>
    if(myproc()->killed){
801038e9:	e8 d2 02 00 00       	call   80103bc0 <myproc>
801038ee:	8b 48 24             	mov    0x24(%eax),%ecx
801038f1:	85 c9                	test   %ecx,%ecx
801038f3:	74 cb                	je     801038c0 <piperead+0x40>
      release(&p->lock);
801038f5:	83 ec 0c             	sub    $0xc,%esp
801038f8:	53                   	push   %ebx
801038f9:	e8 a2 12 00 00       	call   80104ba0 <release>
      return -1;
801038fe:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103901:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103909:	5b                   	pop    %ebx
8010390a:	5e                   	pop    %esi
8010390b:	5f                   	pop    %edi
8010390c:	5d                   	pop    %ebp
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103910:	8b 45 10             	mov    0x10(%ebp),%eax
80103913:	85 c0                	test   %eax,%eax
80103915:	7e 69                	jle    80103980 <piperead+0x100>
    if(p->nread == p->nwrite)
80103917:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010391d:	31 c9                	xor    %ecx,%ecx
8010391f:	eb 15                	jmp    80103936 <piperead+0xb6>
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103928:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010392e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103934:	74 5a                	je     80103990 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103936:	8d 70 01             	lea    0x1(%eax),%esi
80103939:	25 ff 01 00 00       	and    $0x1ff,%eax
8010393e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103944:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103949:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010394c:	83 c1 01             	add    $0x1,%ecx
8010394f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103952:	75 d4                	jne    80103928 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103954:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010395a:	83 ec 0c             	sub    $0xc,%esp
8010395d:	50                   	push   %eax
8010395e:	e8 4d 0d 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
80103963:	89 1c 24             	mov    %ebx,(%esp)
80103966:	e8 35 12 00 00       	call   80104ba0 <release>
  return i;
8010396b:	8b 45 10             	mov    0x10(%ebp),%eax
8010396e:	83 c4 10             	add    $0x10,%esp
}
80103971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103974:	5b                   	pop    %ebx
80103975:	5e                   	pop    %esi
80103976:	5f                   	pop    %edi
80103977:	5d                   	pop    %ebp
80103978:	c3                   	ret    
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103980:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103987:	eb cb                	jmp    80103954 <piperead+0xd4>
80103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103990:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103993:	eb bf                	jmp    80103954 <piperead+0xd4>
80103995:	66 90                	xchg   %ax,%ax
80103997:	66 90                	xchg   %ax,%ax
80103999:	66 90                	xchg   %ax,%ax
8010399b:	66 90                	xchg   %ax,%ax
8010399d:	66 90                	xchg   %ax,%ax
8010399f:	90                   	nop

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801039ac:	68 20 3d 11 80       	push   $0x80113d20
801039b1:	e8 3a 11 00 00       	call   80104af0 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 17                	jmp    801039d2 <allocproc+0x32>
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801039c6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801039cc:	0f 84 be 00 00 00    	je     80103a90 <allocproc+0xf0>
    if(p->state == UNUSED)
801039d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039d5:	85 c0                	test   %eax,%eax
801039d7:	75 e7                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->custom_stack_size = 1;
  //시작시간 
  p->start_time_tick = ticks;
  //////////////////////////////////////////

  release(&ptable.lock);
801039de:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801039e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->custom_stack_size = 1;
  //시작시간 
  p->start_time_tick = ticks;
  //////////////////////////////////////////

  release(&ptable.lock);
801039e8:	68 20 3d 11 80       	push   $0x80113d20
found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  /////////////////////////////////////////
  //항상 레벨 0에 들어가고 우선순위는 0이다.
  p->queuelevel = 0;
801039ed:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801039f4:	00 00 00 
  p->priority = 0;
801039f7:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->tickleft = 4;
801039fe:	c7 83 84 00 00 00 04 	movl   $0x4,0x84(%ebx)
80103a05:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a08:	8d 50 01             	lea    0x1(%eax),%edx
80103a0b:	89 43 10             	mov    %eax,0x10(%ebx)
  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  p->limit_sz = 0;
  p->custom_stack_size = 1;
  //시작시간 
  p->start_time_tick = ticks;
80103a0e:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
  p->queuelevel = 0;
  p->priority = 0;
  p->tickleft = 4;

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
80103a13:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103a1a:	00 00 00 
  p->limit_sz = 0;
80103a1d:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103a24:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a27:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->tickleft = 4;

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  p->limit_sz = 0;
  p->custom_stack_size = 1;
80103a2d:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80103a34:	00 00 00 
  //시작시간 
  p->start_time_tick = ticks;
80103a37:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
  //////////////////////////////////////////

  release(&ptable.lock);
80103a3d:	e8 5e 11 00 00       	call   80104ba0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a42:	e8 39 ee ff ff       	call   80102880 <kalloc>
80103a47:	83 c4 10             	add    $0x10,%esp
80103a4a:	85 c0                	test   %eax,%eax
80103a4c:	89 43 08             	mov    %eax,0x8(%ebx)
80103a4f:	74 56                	je     80103aa7 <allocproc+0x107>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a51:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a57:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103a5a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a5f:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103a62:	c7 40 14 61 60 10 80 	movl   $0x80106061,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a69:	6a 14                	push   $0x14
80103a6b:	6a 00                	push   $0x0
80103a6d:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103a6e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a71:	e8 7a 11 00 00       	call   80104bf0 <memset>
  p->context->eip = (uint)forkret;
80103a76:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a79:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103a7c:	c7 40 10 b0 3a 10 80 	movl   $0x80103ab0,0x10(%eax)

  return p;
80103a83:	89 d8                	mov    %ebx,%eax
}
80103a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a88:	c9                   	leave  
80103a89:	c3                   	ret    
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 20 3d 11 80       	push   $0x80113d20
80103a98:	e8 03 11 00 00       	call   80104ba0 <release>
  return 0;
80103a9d:	83 c4 10             	add    $0x10,%esp
80103aa0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aa5:	c9                   	leave  
80103aa6:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103aa7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103aae:	eb d5                	jmp    80103a85 <allocproc+0xe5>

80103ab0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ab6:	68 20 3d 11 80       	push   $0x80113d20
80103abb:	e8 e0 10 00 00       	call   80104ba0 <release>

  if (first) {
80103ac0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	85 c0                	test   %eax,%eax
80103aca:	75 04                	jne    80103ad0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103acc:	c9                   	leave  
80103acd:	c3                   	ret    
80103ace:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103ad0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103ad3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103ada:	00 00 00 
    iinit(ROOTDEV);
80103add:	6a 01                	push   $0x1
80103adf:	e8 7c dd ff ff       	call   80101860 <iinit>
    initlog(ROOTDEV);
80103ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aeb:	e8 b0 f3 ff ff       	call   80102ea0 <initlog>
80103af0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103af3:	c9                   	leave  
80103af4:	c3                   	ret    
80103af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b06:	68 75 7e 10 80       	push   $0x80107e75
80103b0b:	68 20 3d 11 80       	push   $0x80113d20
80103b10:	e8 7b 0e 00 00       	call   80104990 <initlock>
}
80103b15:	83 c4 10             	add    $0x10,%esp
80103b18:	c9                   	leave  
80103b19:	c3                   	ret    
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
80103b24:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b25:	9c                   	pushf  
80103b26:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103b27:	f6 c4 02             	test   $0x2,%ah
80103b2a:	75 5b                	jne    80103b87 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103b2c:	e8 af ef ff ff       	call   80102ae0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b31:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103b37:	85 f6                	test   %esi,%esi
80103b39:	7e 3f                	jle    80103b7a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b3b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103b42:	39 d0                	cmp    %edx,%eax
80103b44:	74 30                	je     80103b76 <mycpu+0x56>
80103b46:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103b4b:	31 d2                	xor    %edx,%edx
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b50:	83 c2 01             	add    $0x1,%edx
80103b53:	39 f2                	cmp    %esi,%edx
80103b55:	74 23                	je     80103b7a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b57:	0f b6 19             	movzbl (%ecx),%ebx
80103b5a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b60:	39 d8                	cmp    %ebx,%eax
80103b62:	75 ec                	jne    80103b50 <mycpu+0x30>
      return &cpus[i];
80103b64:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b6d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103b6e:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103b73:	5e                   	pop    %esi
80103b74:	5d                   	pop    %ebp
80103b75:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b76:	31 d2                	xor    %edx,%edx
80103b78:	eb ea                	jmp    80103b64 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 7c 7e 10 80       	push   $0x80107e7c
80103b82:	e8 e9 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b87:	83 ec 0c             	sub    $0xc,%esp
80103b8a:	68 84 7f 10 80       	push   $0x80107f84
80103b8f:	e8 dc c7 ff ff       	call   80100370 <panic>
80103b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ba0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ba6:	e8 75 ff ff ff       	call   80103b20 <mycpu>
80103bab:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103bb0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103bb1:	c1 f8 04             	sar    $0x4,%eax
80103bb4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bba:	c3                   	ret    
80103bbb:	90                   	nop
80103bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bc0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bc7:	e8 44 0e 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103bcc:	e8 4f ff ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103bd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd7:	e8 74 0e 00 00       	call   80104a50 <popcli>
  return p;
}
80103bdc:	83 c4 04             	add    $0x4,%esp
80103bdf:	89 d8                	mov    %ebx,%eax
80103be1:	5b                   	pop    %ebx
80103be2:	5d                   	pop    %ebp
80103be3:	c3                   	ret    
80103be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bf0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	53                   	push   %ebx
80103bf4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103bf7:	e8 a4 fd ff ff       	call   801039a0 <allocproc>
80103bfc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103bfe:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103c03:	e8 48 3a 00 00       	call   80107650 <setupkvm>
80103c08:	85 c0                	test   %eax,%eax
80103c0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c0d:	0f 84 bd 00 00 00    	je     80103cd0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c13:	83 ec 04             	sub    $0x4,%esp
80103c16:	68 2c 00 00 00       	push   $0x2c
80103c1b:	68 60 b4 10 80       	push   $0x8010b460
80103c20:	50                   	push   %eax
80103c21:	e8 3a 37 00 00       	call   80107360 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103c26:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103c29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c2f:	6a 4c                	push   $0x4c
80103c31:	6a 00                	push   $0x0
80103c33:	ff 73 18             	pushl  0x18(%ebx)
80103c36:	e8 b5 0f 00 00       	call   80104bf0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c43:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c48:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c56:	8b 43 18             	mov    0x18(%ebx),%eax
80103c59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c61:	8b 43 18             	mov    0x18(%ebx),%eax
80103c64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c76:	8b 43 18             	mov    0x18(%ebx),%eax
80103c79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c80:	8b 43 18             	mov    0x18(%ebx),%eax
80103c83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c8d:	6a 10                	push   $0x10
80103c8f:	68 a5 7e 10 80       	push   $0x80107ea5
80103c94:	50                   	push   %eax
80103c95:	e8 56 11 00 00       	call   80104df0 <safestrcpy>
  p->cwd = namei("/");
80103c9a:	c7 04 24 ae 7e 10 80 	movl   $0x80107eae,(%esp)
80103ca1:	e8 0a e6 ff ff       	call   801022b0 <namei>
80103ca6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ca9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cb0:	e8 3b 0e 00 00       	call   80104af0 <acquire>

  p->state = RUNNABLE;
80103cb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103cbc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cc3:	e8 d8 0e 00 00       	call   80104ba0 <release>
}
80103cc8:	83 c4 10             	add    $0x10,%esp
80103ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cce:	c9                   	leave  
80103ccf:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	68 8c 7e 10 80       	push   $0x80107e8c
80103cd8:	e8 93 c6 ff ff       	call   80100370 <panic>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi

80103ce0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ce8:	e8 23 0d 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103ced:	e8 2e fe ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103cf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf8:	e8 53 0d 00 00       	call   80104a50 <popcli>
  struct proc *curproc = myproc();

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
80103cfd:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103d03:	8b 03                	mov    (%ebx),%eax

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
80103d05:	85 d2                	test   %edx,%edx
80103d07:	74 07                	je     80103d10 <growproc+0x30>
80103d09:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80103d0c:	39 d1                	cmp    %edx,%ecx
80103d0e:	77 50                	ja     80103d60 <growproc+0x80>
    return -1;
  }
  if(n > 0){
80103d10:	83 fe 00             	cmp    $0x0,%esi
80103d13:	7e 33                	jle    80103d48 <growproc+0x68>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d15:	83 ec 04             	sub    $0x4,%esp
80103d18:	01 c6                	add    %eax,%esi
80103d1a:	56                   	push   %esi
80103d1b:	50                   	push   %eax
80103d1c:	ff 73 04             	pushl  0x4(%ebx)
80103d1f:	e8 7c 37 00 00       	call   801074a0 <allocuvm>
80103d24:	83 c4 10             	add    $0x10,%esp
80103d27:	85 c0                	test   %eax,%eax
80103d29:	74 35                	je     80103d60 <growproc+0x80>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103d2b:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103d2e:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d30:	53                   	push   %ebx
80103d31:	e8 1a 35 00 00       	call   80107250 <switchuvm>
  return 0;
80103d36:	83 c4 10             	add    $0x10,%esp
80103d39:	31 c0                	xor    %eax,%eax
}
80103d3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d3e:	5b                   	pop    %ebx
80103d3f:	5e                   	pop    %esi
80103d40:	5d                   	pop    %ebp
80103d41:	c3                   	ret    
80103d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  }
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103d48:	74 e1                	je     80103d2b <growproc+0x4b>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d4a:	83 ec 04             	sub    $0x4,%esp
80103d4d:	01 c6                	add    %eax,%esi
80103d4f:	56                   	push   %esi
80103d50:	50                   	push   %eax
80103d51:	ff 73 04             	pushl  0x4(%ebx)
80103d54:	e8 47 38 00 00       	call   801075a0 <deallocuvm>
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	85 c0                	test   %eax,%eax
80103d5e:	75 cb                	jne    80103d2b <growproc+0x4b>

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
    return -1;
80103d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d65:	eb d4                	jmp    80103d3b <growproc+0x5b>
80103d67:	89 f6                	mov    %esi,%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d70 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d79:	e8 92 0c 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103d7e:	e8 9d fd ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103d83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d89:	e8 c2 0c 00 00       	call   80104a50 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103d8e:	e8 0d fc ff ff       	call   801039a0 <allocproc>
80103d93:	85 c0                	test   %eax,%eax
80103d95:	89 c7                	mov    %eax,%edi
80103d97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d9a:	0f 84 dd 00 00 00    	je     80103e7d <fork+0x10d>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103da0:	83 ec 08             	sub    $0x8,%esp
80103da3:	ff 33                	pushl  (%ebx)
80103da5:	ff 73 04             	pushl  0x4(%ebx)
80103da8:	e8 73 39 00 00       	call   80107720 <copyuvm>
80103dad:	83 c4 10             	add    $0x10,%esp
80103db0:	85 c0                	test   %eax,%eax
80103db2:	89 47 04             	mov    %eax,0x4(%edi)
80103db5:	0f 84 c9 00 00 00    	je     80103e84 <fork+0x114>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103dbb:	8b 03                	mov    (%ebx),%eax
80103dbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103dc0:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103dc5:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103dc7:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103dca:	8b 7a 18             	mov    0x18(%edx),%edi
80103dcd:	8b 73 18             	mov    0x18(%ebx),%esi
80103dd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103dd2:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  //부모 프로세스와 같은 값으로 설정해준다.
  np->admin_mode = curproc->admin_mode;
80103dd4:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103dda:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  np->limit_sz = curproc->limit_sz;
80103de0:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80103de6:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
  np->custom_stack_size = curproc->custom_stack_size;
80103dec:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103df2:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103df8:	8b 42 18             	mov    0x18(%edx),%eax
80103dfb:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103e08:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e0c:	85 c0                	test   %eax,%eax
80103e0e:	74 13                	je     80103e23 <fork+0xb3>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e10:	83 ec 0c             	sub    $0xc,%esp
80103e13:	50                   	push   %eax
80103e14:	e8 c7 d3 ff ff       	call   801011e0 <filedup>
80103e19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e1c:	83 c4 10             	add    $0x10,%esp
80103e1f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103e23:	83 c6 01             	add    $0x1,%esi
80103e26:	83 fe 10             	cmp    $0x10,%esi
80103e29:	75 dd                	jne    80103e08 <fork+0x98>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e2b:	83 ec 0c             	sub    $0xc,%esp
80103e2e:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e31:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e34:	e8 f7 db ff ff       	call   80101a30 <idup>
80103e39:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e3c:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e3f:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e42:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e45:	6a 10                	push   $0x10
80103e47:	53                   	push   %ebx
80103e48:	50                   	push   %eax
80103e49:	e8 a2 0f 00 00       	call   80104df0 <safestrcpy>

  pid = np->pid;
80103e4e:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103e51:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e58:	e8 93 0c 00 00       	call   80104af0 <acquire>

  np->state = RUNNABLE;
80103e5d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103e64:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e6b:	e8 30 0d 00 00       	call   80104ba0 <release>

  return pid;
80103e70:	83 c4 10             	add    $0x10,%esp
80103e73:	89 d8                	mov    %ebx,%eax
}
80103e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e78:	5b                   	pop    %ebx
80103e79:	5e                   	pop    %esi
80103e7a:	5f                   	pop    %edi
80103e7b:	5d                   	pop    %ebp
80103e7c:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e82:	eb f1                	jmp    80103e75 <fork+0x105>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103e84:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e87:	83 ec 0c             	sub    $0xc,%esp
80103e8a:	ff 77 08             	pushl  0x8(%edi)
80103e8d:	e8 3e e8 ff ff       	call   801026d0 <kfree>
    np->kstack = 0;
80103e92:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103e99:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103ea0:	83 c4 10             	add    $0x10,%esp
80103ea3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ea8:	eb cb                	jmp    80103e75 <fork+0x105>
80103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103eb0 <priority_boosting>:
//      via swtch back to the scheduler.


void 
priority_boosting(void)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103eb6:	68 20 3d 11 80       	push   $0x80113d20
80103ebb:	e8 30 0c 00 00       	call   80104af0 <acquire>
80103ec0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec3:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ec8:	90                   	nop
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103ed0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103ed7:	00 00 00 
        p->tickleft=4;
80103eda:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103ee1:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee4:	05 9c 00 00 00       	add    $0x9c,%eax
80103ee9:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103eee:	75 e0                	jne    80103ed0 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	68 20 3d 11 80       	push   $0x80113d20
80103ef8:	e8 a3 0c 00 00       	call   80104ba0 <release>
}
80103efd:	83 c4 10             	add    $0x10,%esp
80103f00:	c9                   	leave  
80103f01:	c3                   	ret    
80103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <scheduler>:
*/


void
scheduler(void)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	57                   	push   %edi
80103f14:	56                   	push   %esi
80103f15:	53                   	push   %ebx
80103f16:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103f19:	e8 02 fc ff ff       	call   80103b20 <mycpu>
80103f1e:	8d 78 04             	lea    0x4(%eax),%edi
80103f21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f2a:	00 00 00 
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103f30:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f31:	83 ec 0c             	sub    $0xc,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f34:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f39:	68 20 3d 11 80       	push   $0x80113d20
80103f3e:	e8 ad 0b 00 00       	call   80104af0 <acquire>
80103f43:	83 c4 10             	add    $0x10,%esp
80103f46:	eb 16                	jmp    80103f5e <scheduler+0x4e>
80103f48:	90                   	nop
80103f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f50:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103f56:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80103f5c:	74 52                	je     80103fb0 <scheduler+0xa0>
      if(p->state != RUNNABLE) continue;
80103f5e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f62:	75 ec                	jne    80103f50 <scheduler+0x40>
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103f64:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE) continue;
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103f67:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f6d:	53                   	push   %ebx
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6e:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103f74:	e8 d7 32 00 00       	call   80107250 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103f79:	58                   	pop    %eax
80103f7a:	5a                   	pop    %edx
80103f7b:	ff 73 80             	pushl  -0x80(%ebx)
80103f7e:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103f7f:	c7 83 70 ff ff ff 04 	movl   $0x4,-0x90(%ebx)
80103f86:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103f89:	e8 bd 0e 00 00       	call   80104e4b <swtch>
      switchkvm();
80103f8e:	e8 9d 32 00 00       	call   80107230 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f93:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f96:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f9c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fa3:	00 00 00 
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa6:	75 b6                	jne    80103f5e <scheduler+0x4e>
80103fa8:	90                   	nop
80103fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103fb0:	83 ec 0c             	sub    $0xc,%esp
80103fb3:	68 20 3d 11 80       	push   $0x80113d20
80103fb8:	e8 e3 0b 00 00       	call   80104ba0 <release>
    #endif
  }
80103fbd:	83 c4 10             	add    $0x10,%esp
80103fc0:	e9 6b ff ff ff       	jmp    80103f30 <scheduler+0x20>
80103fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103fd5:	e8 36 0a 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103fda:	e8 41 fb ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103fdf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fe5:	e8 66 0a 00 00       	call   80104a50 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 20 3d 11 80       	push   $0x80113d20
80103ff2:	e8 c9 0a 00 00       	call   80104ac0 <holding>
80103ff7:	83 c4 10             	add    $0x10,%esp
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 4f                	je     8010404d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103ffe:	e8 1d fb ff ff       	call   80103b20 <mycpu>
80104003:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010400a:	75 68                	jne    80104074 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010400c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104010:	74 55                	je     80104067 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104012:	9c                   	pushf  
80104013:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80104014:	f6 c4 02             	test   $0x2,%ah
80104017:	75 41                	jne    8010405a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80104019:	e8 02 fb ff ff       	call   80103b20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010401e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80104021:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104027:	e8 f4 fa ff ff       	call   80103b20 <mycpu>
8010402c:	83 ec 08             	sub    $0x8,%esp
8010402f:	ff 70 04             	pushl  0x4(%eax)
80104032:	53                   	push   %ebx
80104033:	e8 13 0e 00 00       	call   80104e4b <swtch>
  mycpu()->intena = intena;
80104038:	e8 e3 fa ff ff       	call   80103b20 <mycpu>
}
8010403d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104040:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104046:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104049:	5b                   	pop    %ebx
8010404a:	5e                   	pop    %esi
8010404b:	5d                   	pop    %ebp
8010404c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 b0 7e 10 80       	push   $0x80107eb0
80104055:	e8 16 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 dc 7e 10 80       	push   $0x80107edc
80104062:	e8 09 c3 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80104067:	83 ec 0c             	sub    $0xc,%esp
8010406a:	68 ce 7e 10 80       	push   $0x80107ece
8010406f:	e8 fc c2 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	68 c2 7e 10 80       	push   $0x80107ec2
8010407c:	e8 ef c2 ff ff       	call   80100370 <panic>
80104081:	eb 0d                	jmp    80104090 <exit>
80104083:	90                   	nop
80104084:	90                   	nop
80104085:	90                   	nop
80104086:	90                   	nop
80104087:	90                   	nop
80104088:	90                   	nop
80104089:	90                   	nop
8010408a:	90                   	nop
8010408b:	90                   	nop
8010408c:	90                   	nop
8010408d:	90                   	nop
8010408e:	90                   	nop
8010408f:	90                   	nop

80104090 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104099:	e8 72 09 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010409e:	e8 7d fa ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801040a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040a9:	e8 a2 09 00 00       	call   80104a50 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
801040ae:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801040b4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040b7:	8d 7e 68             	lea    0x68(%esi),%edi
801040ba:	0f 84 f1 00 00 00    	je     801041b1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
801040c0:	8b 03                	mov    (%ebx),%eax
801040c2:	85 c0                	test   %eax,%eax
801040c4:	74 12                	je     801040d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040c6:	83 ec 0c             	sub    $0xc,%esp
801040c9:	50                   	push   %eax
801040ca:	e8 61 d1 ff ff       	call   80101230 <fileclose>
      curproc->ofile[fd] = 0;
801040cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801040db:	39 df                	cmp    %ebx,%edi
801040dd:	75 e1                	jne    801040c0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801040df:	e8 5c ee ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	ff 76 68             	pushl  0x68(%esi)
801040ea:	e8 a1 da ff ff       	call   80101b90 <iput>
  end_op();
801040ef:	e8 bc ee ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
801040f4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
801040fb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104102:	e8 e9 09 00 00       	call   80104af0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104107:	8b 56 14             	mov    0x14(%esi),%edx
8010410a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104112:	eb 10                	jmp    80104124 <exit+0x94>
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104118:	05 9c 00 00 00       	add    $0x9c,%eax
8010411d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104122:	74 1e                	je     80104142 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104124:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104128:	75 ee                	jne    80104118 <exit+0x88>
8010412a:	3b 50 20             	cmp    0x20(%eax),%edx
8010412d:	75 e9                	jne    80104118 <exit+0x88>
      p->state = RUNNABLE;
8010412f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104136:	05 9c 00 00 00       	add    $0x9c,%eax
8010413b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104140:	75 e2                	jne    80104124 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104142:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104148:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010414d:	eb 0f                	jmp    8010415e <exit+0xce>
8010414f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104150:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80104156:	81 fa 54 64 11 80    	cmp    $0x80116454,%edx
8010415c:	74 3a                	je     80104198 <exit+0x108>
    if(p->parent == curproc){
8010415e:	39 72 14             	cmp    %esi,0x14(%edx)
80104161:	75 ed                	jne    80104150 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104163:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104167:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010416a:	75 e4                	jne    80104150 <exit+0xc0>
8010416c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104171:	eb 11                	jmp    80104184 <exit+0xf4>
80104173:	90                   	nop
80104174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104178:	05 9c 00 00 00       	add    $0x9c,%eax
8010417d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104182:	74 cc                	je     80104150 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104184:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104188:	75 ee                	jne    80104178 <exit+0xe8>
8010418a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010418d:	75 e9                	jne    80104178 <exit+0xe8>
      p->state = RUNNABLE;
8010418f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104196:	eb e0                	jmp    80104178 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104198:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010419f:	e8 2c fe ff ff       	call   80103fd0 <sched>
  panic("zombie exit");
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	68 fd 7e 10 80       	push   $0x80107efd
801041ac:	e8 bf c1 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
801041b1:	83 ec 0c             	sub    $0xc,%esp
801041b4:	68 f0 7e 10 80       	push   $0x80107ef0
801041b9:	e8 b2 c1 ff ff       	call   80100370 <panic>
801041be:	66 90                	xchg   %ax,%ax

801041c0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041c7:	68 20 3d 11 80       	push   $0x80113d20
801041cc:	e8 1f 09 00 00       	call   80104af0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041d1:	e8 3a 08 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801041d6:	e8 45 f9 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801041db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e1:	e8 6a 08 00 00       	call   80104a50 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
801041e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041ed:	e8 de fd ff ff       	call   80103fd0 <sched>
  release(&ptable.lock);
801041f2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041f9:	e8 a2 09 00 00       	call   80104ba0 <release>
}
801041fe:	83 c4 10             	add    $0x10,%esp
80104201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104204:	c9                   	leave  
80104205:	c3                   	ret    
80104206:	8d 76 00             	lea    0x0(%esi),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <getlev>:

int             
getlev(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104217:	e8 f4 07 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010421c:	e8 ff f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104221:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104227:	e8 24 08 00 00       	call   80104a50 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
8010422c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104232:	83 c4 04             	add    $0x4,%esp
80104235:	5b                   	pop    %ebx
80104236:	5d                   	pop    %ebp
80104237:	c3                   	ret    
80104238:	90                   	nop
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104240 <getadmin>:

int
getadmin(char *password)
{
80104240:	55                   	push   %ebp
  char my_number[10] = "2016025823";
80104241:	b8 32 33 00 00       	mov    $0x3332,%eax
  int flag = 0;
80104246:	31 d2                	xor    %edx,%edx
  return myproc()->queuelevel;
}

int
getadmin(char *password)
{
80104248:	89 e5                	mov    %esp,%ebp
8010424a:	53                   	push   %ebx
8010424b:	83 ec 14             	sub    $0x14,%esp
8010424e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char my_number[10] = "2016025823";
80104251:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80104255:	c7 45 ee 32 30 31 36 	movl   $0x36313032,-0x12(%ebp)
8010425c:	c7 45 f2 30 32 35 38 	movl   $0x38353230,-0xe(%ebp)
  int flag = 0;
  for(int i=0;i<10;i++){
80104263:	31 c0                	xor    %eax,%eax
80104265:	8d 76 00             	lea    0x0(%esi),%esi
    if(my_number[i] == password[i]) flag++;
80104268:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
8010426c:	38 4c 05 ee          	cmp    %cl,-0x12(%ebp,%eax,1)
80104270:	0f 94 c1             	sete   %cl
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
80104273:	83 c0 01             	add    $0x1,%eax
    if(my_number[i] == password[i]) flag++;
80104276:	0f b6 c9             	movzbl %cl,%ecx
80104279:	01 ca                	add    %ecx,%edx
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
8010427b:	83 f8 0a             	cmp    $0xa,%eax
8010427e:	75 e8                	jne    80104268 <getadmin+0x28>
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
80104280:	83 fa 0a             	cmp    $0xa,%edx
80104283:	75 2b                	jne    801042b0 <getadmin+0x70>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104285:	e8 86 07 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010428a:	e8 91 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010428f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104295:	e8 b6 07 00 00       	call   80104a50 <popcli>
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
8010429a:	31 c0                	xor    %eax,%eax
  int flag = 0;
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
8010429c:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801042a3:	00 00 00 
    return 0;
  }
  else{
    return -1;
  }
}
801042a6:	83 c4 14             	add    $0x14,%esp
801042a9:	5b                   	pop    %ebx
801042aa:	5d                   	pop    %ebp
801042ab:	c3                   	ret    
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b0:	83 c4 14             	add    $0x14,%esp
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
  }
  else{
    return -1;
801042b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801042b8:	5b                   	pop    %ebx
801042b9:	5d                   	pop    %ebp
801042ba:	c3                   	ret    
801042bb:	90                   	nop
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042c0 <setmemorylimit>:

int 
setmemorylimit(int pid, int limit)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	57                   	push   %edi
801042c4:	56                   	push   %esi
801042c5:	53                   	push   %ebx
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042cc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801042cf:	e8 3c 07 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801042d4:	e8 47 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801042d9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042df:	e8 6c 07 00 00       	call   80104a50 <popcli>

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
801042e4:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 5c                	je     8010434a <setmemorylimit+0x8a>
801042ee:	89 f0                	mov    %esi,%eax
801042f0:	c1 e8 1f             	shr    $0x1f,%eax
801042f3:	84 c0                	test   %al,%al
801042f5:	75 53                	jne    8010434a <setmemorylimit+0x8a>
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
801042f7:	83 ec 0c             	sub    $0xc,%esp
int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
801042fa:	31 db                	xor    %ebx,%ebx
  struct proc *p;
  acquire(&ptable.lock);
801042fc:	68 20 3d 11 80       	push   $0x80113d20
80104301:	e8 ea 07 00 00       	call   80104af0 <acquire>
80104306:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104309:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010430e:	66 90                	xchg   %ax,%ax
    if(p->pid == pid) target = p;
80104310:	39 78 10             	cmp    %edi,0x10(%eax)
80104313:	0f 44 d8             	cmove  %eax,%ebx
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104316:	05 9c 00 00 00       	add    $0x9c,%eax
8010431b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104320:	75 ee                	jne    80104310 <setmemorylimit+0x50>
    if(p->pid == pid) target = p;
  }
	release(&ptable.lock);
80104322:	83 ec 0c             	sub    $0xc,%esp
80104325:	68 20 3d 11 80       	push   $0x80113d20
8010432a:	e8 71 08 00 00       	call   80104ba0 <release>
  //해당 pid가 없을 때
  if(target==0) return -1;
8010432f:	83 c4 10             	add    $0x10,%esp
80104332:	85 db                	test   %ebx,%ebx
80104334:	74 14                	je     8010434a <setmemorylimit+0x8a>

  //기존 사이즈보다 더 작은 Limit을 주려고 할때

  if(target->sz > limit) return -1;
80104336:	39 33                	cmp    %esi,(%ebx)
80104338:	77 10                	ja     8010434a <setmemorylimit+0x8a>
  target->limit_sz = limit;
8010433a:	89 b3 90 00 00 00    	mov    %esi,0x90(%ebx)
  return 0;
80104340:	31 c0                	xor    %eax,%eax
}
80104342:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104345:	5b                   	pop    %ebx
80104346:	5e                   	pop    %esi
80104347:	5f                   	pop    %edi
80104348:	5d                   	pop    %ebp
80104349:	c3                   	ret    

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
8010434a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010434f:	eb f1                	jmp    80104342 <setmemorylimit+0x82>
80104351:	eb 0d                	jmp    80104360 <list>
80104353:	90                   	nop
80104354:	90                   	nop
80104355:	90                   	nop
80104356:	90                   	nop
80104357:	90                   	nop
80104358:	90                   	nop
80104359:	90                   	nop
8010435a:	90                   	nop
8010435b:	90                   	nop
8010435c:	90                   	nop
8010435d:	90                   	nop
8010435e:	90                   	nop
8010435f:	90                   	nop

80104360 <list>:
}


int
list()
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104369:	83 ec 10             	sub    $0x10,%esp
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
8010436c:	68 ac 7f 10 80       	push   $0x80107fac
80104371:	e8 ea c2 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  acquire(&ptable.lock);
80104376:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010437d:	e8 6e 07 00 00       	call   80104af0 <acquire>
80104382:	83 c4 10             	add    $0x10,%esp
80104385:	eb 17                	jmp    8010439e <list+0x3e>
80104387:	89 f6                	mov    %esi,%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104390:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104396:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
8010439c:	74 49                	je     801043e7 <list+0x87>
   if(p->pid != 0){
8010439e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801043a1:	85 c0                	test   %eax,%eax
801043a3:	74 eb                	je     80104390 <list+0x30>
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
801043a5:	83 ec 0c             	sub    $0xc,%esp
801043a8:	53                   	push   %ebx
801043a9:	e8 82 0a 00 00       	call   80104e30 <strlen>
801043ae:	83 c4 10             	add    $0x10,%esp
801043b1:	83 f8 06             	cmp    $0x6,%eax
801043b4:	7e 4a                	jle    80104400 <list+0xa0>
801043b6:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
801043bb:	2b 43 28             	sub    0x28(%ebx),%eax
801043be:	83 ec 08             	sub    $0x8,%esp
801043c1:	ff 73 24             	pushl  0x24(%ebx)
801043c4:	ff 73 94             	pushl  -0x6c(%ebx)
801043c7:	50                   	push   %eax
801043c8:	ff 73 a4             	pushl  -0x5c(%ebx)
801043cb:	53                   	push   %ebx
801043cc:	68 09 7f 10 80       	push   $0x80107f09
801043d1:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801043d7:	e8 84 c2 ff ff       	call   80100660 <cprintf>
801043dc:	83 c4 20             	add    $0x20,%esp
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043df:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
801043e5:	75 b7                	jne    8010439e <list+0x3e>
   if(p->pid != 0){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
    }
  }
	release(&ptable.lock);
801043e7:	83 ec 0c             	sub    $0xc,%esp
801043ea:	68 20 3d 11 80       	push   $0x80113d20
801043ef:	e8 ac 07 00 00       	call   80104ba0 <release>
  return 0;
}
801043f4:	31 c0                	xor    %eax,%eax
801043f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f9:	c9                   	leave  
801043fa:	c3                   	ret    
801043fb:	90                   	nop
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   if(p->pid != 0){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
80104400:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80104405:	2b 43 28             	sub    0x28(%ebx),%eax
80104408:	83 ec 08             	sub    $0x8,%esp
8010440b:	ff 73 24             	pushl  0x24(%ebx)
8010440e:	ff 73 94             	pushl  -0x6c(%ebx)
80104411:	50                   	push   %eax
80104412:	ff 73 a4             	pushl  -0x5c(%ebx)
80104415:	53                   	push   %ebx
80104416:	68 1f 7f 10 80       	push   $0x80107f1f
8010441b:	e8 40 c2 ff ff       	call   80100660 <cprintf>
80104420:	83 c4 20             	add    $0x20,%esp
80104423:	e9 68 ff ff ff       	jmp    80104390 <list+0x30>
80104428:	90                   	nop
80104429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104430 <setpriority>:
}


int             
setpriority(int pid, int priority)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	53                   	push   %ebx
80104436:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104439:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
}


int             
setpriority(int pid, int priority)
{
8010443d:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104440:	0f 87 97 00 00 00    	ja     801044dd <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
80104446:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104449:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
8010444e:	68 20 3d 11 80       	push   $0x80113d20
80104453:	e8 98 06 00 00       	call   80104af0 <acquire>
80104458:	83 c4 10             	add    $0x10,%esp
8010445b:	eb 11                	jmp    8010446e <setpriority+0x3e>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104460:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104466:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010446c:	74 52                	je     801044c0 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
8010446e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104471:	75 ed                	jne    80104460 <setpriority+0x30>
80104473:	8b 43 14             	mov    0x14(%ebx),%eax
80104476:	8b 50 10             	mov    0x10(%eax),%edx
80104479:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010447c:	e8 8f 05 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80104481:	e8 9a f6 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104486:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010448c:	e8 bf 05 00 00       	call   80104a50 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
80104491:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104494:	3b 57 10             	cmp    0x10(%edi),%edx
80104497:	75 c7                	jne    80104460 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104499:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
8010449c:	83 ec 0c             	sub    $0xc,%esp
8010449f:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
801044a4:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
801044a7:	e8 f4 06 00 00       	call   80104ba0 <release>

      return 0;
801044ac:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
801044af:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
801044b2:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
801044b4:	5b                   	pop    %ebx
801044b5:	5e                   	pop    %esi
801044b6:	5f                   	pop    %edi
801044b7:	5d                   	pop    %ebp
801044b8:	c3                   	ret    
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	68 20 3d 11 80       	push   $0x80113d20
801044c8:	e8 d3 06 00 00       	call   80104ba0 <release>
  return -1;
801044cd:	83 c4 10             	add    $0x10,%esp
801044d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044d8:	5b                   	pop    %ebx
801044d9:	5e                   	pop    %esi
801044da:	5f                   	pop    %edi
801044db:	5d                   	pop    %ebp
801044dc:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801044dd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801044e2:	eb f1                	jmp    801044d5 <setpriority+0xa5>
801044e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801044f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	53                   	push   %ebx
801044f6:	83 ec 0c             	sub    $0xc,%esp
801044f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801044fc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801044ff:	e8 0c 05 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80104504:	e8 17 f6 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104509:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010450f:	e8 3c 05 00 00       	call   80104a50 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104514:	85 db                	test   %ebx,%ebx
80104516:	0f 84 87 00 00 00    	je     801045a3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010451c:	85 f6                	test   %esi,%esi
8010451e:	74 76                	je     80104596 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104520:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104526:	74 50                	je     80104578 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	68 20 3d 11 80       	push   $0x80113d20
80104530:	e8 bb 05 00 00       	call   80104af0 <acquire>
    release(lk);
80104535:	89 34 24             	mov    %esi,(%esp)
80104538:	e8 63 06 00 00       	call   80104ba0 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010453d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104540:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104547:	e8 84 fa ff ff       	call   80103fd0 <sched>
  // Tidy up.
  p->chan = 0;
8010454c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104553:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010455a:	e8 41 06 00 00       	call   80104ba0 <release>
    acquire(lk);
8010455f:	89 75 08             	mov    %esi,0x8(%ebp)
80104562:	83 c4 10             	add    $0x10,%esp
  }
}
80104565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104568:	5b                   	pop    %ebx
80104569:	5e                   	pop    %esi
8010456a:	5f                   	pop    %edi
8010456b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010456c:	e9 7f 05 00 00       	jmp    80104af0 <acquire>
80104571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104578:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010457b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104582:	e8 49 fa ff ff       	call   80103fd0 <sched>
  // Tidy up.
  p->chan = 0;
80104587:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010458e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104591:	5b                   	pop    %ebx
80104592:	5e                   	pop    %esi
80104593:	5f                   	pop    %edi
80104594:	5d                   	pop    %ebp
80104595:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	68 3c 7f 10 80       	push   $0x80107f3c
8010459e:	e8 cd bd ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
801045a3:	83 ec 0c             	sub    $0xc,%esp
801045a6:	68 36 7f 10 80       	push   $0x80107f36
801045ab:	e8 c0 bd ff ff       	call   80100370 <panic>

801045b0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801045b5:	e8 56 04 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801045ba:	e8 61 f5 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801045bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045c5:	e8 86 04 00 00       	call   80104a50 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
801045ca:	83 ec 0c             	sub    $0xc,%esp
801045cd:	68 20 3d 11 80       	push   $0x80113d20
801045d2:	e8 19 05 00 00       	call   80104af0 <acquire>
801045d7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801045da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045dc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801045e1:	eb 13                	jmp    801045f6 <wait+0x46>
801045e3:	90                   	nop
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045e8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801045ee:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801045f4:	74 22                	je     80104618 <wait+0x68>
      if(p->parent != curproc)
801045f6:	39 73 14             	cmp    %esi,0x14(%ebx)
801045f9:	75 ed                	jne    801045e8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801045fb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045ff:	74 35                	je     80104636 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104601:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104607:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010460c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104612:	75 e2                	jne    801045f6 <wait+0x46>
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104618:	85 c0                	test   %eax,%eax
8010461a:	74 70                	je     8010468c <wait+0xdc>
8010461c:	8b 46 24             	mov    0x24(%esi),%eax
8010461f:	85 c0                	test   %eax,%eax
80104621:	75 69                	jne    8010468c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104623:	83 ec 08             	sub    $0x8,%esp
80104626:	68 20 3d 11 80       	push   $0x80113d20
8010462b:	56                   	push   %esi
8010462c:	e8 bf fe ff ff       	call   801044f0 <sleep>
  }
80104631:	83 c4 10             	add    $0x10,%esp
80104634:	eb a4                	jmp    801045da <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104636:	83 ec 0c             	sub    $0xc,%esp
80104639:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010463c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010463f:	e8 8c e0 ff ff       	call   801026d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104644:	5a                   	pop    %edx
80104645:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104648:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010464f:	e8 7c 2f 00 00       	call   801075d0 <freevm>
        p->pid = 0;
80104654:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010465b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104662:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104666:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010466d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104674:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010467b:	e8 20 05 00 00       	call   80104ba0 <release>
        return pid;
80104680:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104683:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104686:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104688:	5b                   	pop    %ebx
80104689:	5e                   	pop    %esi
8010468a:	5d                   	pop    %ebp
8010468b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010468c:	83 ec 0c             	sub    $0xc,%esp
8010468f:	68 20 3d 11 80       	push   $0x80113d20
80104694:	e8 07 05 00 00       	call   80104ba0 <release>
      return -1;
80104699:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010469c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010469f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801046a4:	5b                   	pop    %ebx
801046a5:	5e                   	pop    %esi
801046a6:	5d                   	pop    %ebp
801046a7:	c3                   	ret    
801046a8:	90                   	nop
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046ba:	68 20 3d 11 80       	push   $0x80113d20
801046bf:	e8 2c 04 00 00       	call   80104af0 <acquire>
801046c4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801046cc:	eb 0e                	jmp    801046dc <wakeup+0x2c>
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	05 9c 00 00 00       	add    $0x9c,%eax
801046d5:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801046da:	74 1e                	je     801046fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801046dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046e0:	75 ee                	jne    801046d0 <wakeup+0x20>
801046e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801046e5:	75 e9                	jne    801046d0 <wakeup+0x20>
      p->state = RUNNABLE;
801046e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046ee:	05 9c 00 00 00       	add    $0x9c,%eax
801046f3:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801046f8:	75 e2                	jne    801046dc <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801046fa:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104704:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104705:	e9 96 04 00 00       	jmp    80104ba0 <release>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010471a:	68 20 3d 11 80       	push   $0x80113d20
8010471f:	e8 cc 03 00 00       	call   80104af0 <acquire>
80104724:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104727:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010472c:	eb 0e                	jmp    8010473c <kill+0x2c>
8010472e:	66 90                	xchg   %ax,%ax
80104730:	05 9c 00 00 00       	add    $0x9c,%eax
80104735:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010473a:	74 3c                	je     80104778 <kill+0x68>
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
8010473c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010473f:	75 ef                	jne    80104730 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104741:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
80104745:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010474c:	74 1a                	je     80104768 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010474e:	83 ec 0c             	sub    $0xc,%esp
80104751:	68 20 3d 11 80       	push   $0x80113d20
80104756:	e8 45 04 00 00       	call   80104ba0 <release>
      return 0;
8010475b:	83 c4 10             	add    $0x10,%esp
8010475e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104763:	c9                   	leave  
80104764:	c3                   	ret    
80104765:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104768:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010476f:	eb dd                	jmp    8010474e <kill+0x3e>
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	68 20 3d 11 80       	push   $0x80113d20
80104780:	e8 1b 04 00 00       	call   80104ba0 <release>
  return -1;
80104785:	83 c4 10             	add    $0x10,%esp
80104788:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010478d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104790:	c9                   	leave  
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	53                   	push   %ebx
801047a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801047a9:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801047ae:	83 ec 3c             	sub    $0x3c,%esp
801047b1:	eb 27                	jmp    801047da <procdump+0x3a>
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 13 83 10 80       	push   $0x80108313
801047c0:	e8 9b be ff ff       	call   80100660 <cprintf>
801047c5:	83 c4 10             	add    $0x10,%esp
801047c8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ce:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
801047d4:	0f 84 7e 00 00 00    	je     80104858 <procdump+0xb8>
    if(p->state == UNUSED)
801047da:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047dd:	85 c0                	test   %eax,%eax
801047df:	74 e7                	je     801047c8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047e1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801047e4:	ba 4d 7f 10 80       	mov    $0x80107f4d,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047e9:	77 11                	ja     801047fc <procdump+0x5c>
801047eb:	8b 14 85 e0 7f 10 80 	mov    -0x7fef8020(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801047f2:	b8 4d 7f 10 80       	mov    $0x80107f4d,%eax
801047f7:	85 d2                	test   %edx,%edx
801047f9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047fc:	53                   	push   %ebx
801047fd:	52                   	push   %edx
801047fe:	ff 73 a4             	pushl  -0x5c(%ebx)
80104801:	68 51 7f 10 80       	push   $0x80107f51
80104806:	e8 55 be ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010480b:	83 c4 10             	add    $0x10,%esp
8010480e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104812:	75 a4                	jne    801047b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104814:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104817:	83 ec 08             	sub    $0x8,%esp
8010481a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010481d:	50                   	push   %eax
8010481e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104821:	8b 40 0c             	mov    0xc(%eax),%eax
80104824:	83 c0 08             	add    $0x8,%eax
80104827:	50                   	push   %eax
80104828:	e8 83 01 00 00       	call   801049b0 <getcallerpcs>
8010482d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104830:	8b 17                	mov    (%edi),%edx
80104832:	85 d2                	test   %edx,%edx
80104834:	74 82                	je     801047b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104836:	83 ec 08             	sub    $0x8,%esp
80104839:	83 c7 04             	add    $0x4,%edi
8010483c:	52                   	push   %edx
8010483d:	68 41 79 10 80       	push   $0x80107941
80104842:	e8 19 be ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104847:	83 c4 10             	add    $0x10,%esp
8010484a:	39 f7                	cmp    %esi,%edi
8010484c:	75 e2                	jne    80104830 <procdump+0x90>
8010484e:	e9 65 ff ff ff       	jmp    801047b8 <procdump+0x18>
80104853:	90                   	nop
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485b:	5b                   	pop    %ebx
8010485c:	5e                   	pop    %esi
8010485d:	5f                   	pop    %edi
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    

80104860 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010486a:	68 f8 7f 10 80       	push   $0x80107ff8
8010486f:	8d 43 04             	lea    0x4(%ebx),%eax
80104872:	50                   	push   %eax
80104873:	e8 18 01 00 00       	call   80104990 <initlock>
  lk->name = name;
80104878:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010487b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104881:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104884:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010488b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010488e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104891:	c9                   	leave  
80104892:	c3                   	ret    
80104893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	8d 73 04             	lea    0x4(%ebx),%esi
801048ae:	56                   	push   %esi
801048af:	e8 3c 02 00 00       	call   80104af0 <acquire>
  while (lk->locked) {
801048b4:	8b 13                	mov    (%ebx),%edx
801048b6:	83 c4 10             	add    $0x10,%esp
801048b9:	85 d2                	test   %edx,%edx
801048bb:	74 16                	je     801048d3 <acquiresleep+0x33>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801048c0:	83 ec 08             	sub    $0x8,%esp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
801048c5:	e8 26 fc ff ff       	call   801044f0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801048ca:	8b 03                	mov    (%ebx),%eax
801048cc:	83 c4 10             	add    $0x10,%esp
801048cf:	85 c0                	test   %eax,%eax
801048d1:	75 ed                	jne    801048c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801048d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801048d9:	e8 e2 f2 ff ff       	call   80103bc0 <myproc>
801048de:	8b 40 10             	mov    0x10(%eax),%eax
801048e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801048e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ea:	5b                   	pop    %ebx
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801048ed:	e9 ae 02 00 00       	jmp    80104ba0 <release>
801048f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104908:	83 ec 0c             	sub    $0xc,%esp
8010490b:	8d 73 04             	lea    0x4(%ebx),%esi
8010490e:	56                   	push   %esi
8010490f:	e8 dc 01 00 00       	call   80104af0 <acquire>
  lk->locked = 0;
80104914:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010491a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104921:	89 1c 24             	mov    %ebx,(%esp)
80104924:	e8 87 fd ff ff       	call   801046b0 <wakeup>
  release(&lk->lk);
80104929:	89 75 08             	mov    %esi,0x8(%ebp)
8010492c:	83 c4 10             	add    $0x10,%esp
}
8010492f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104932:	5b                   	pop    %ebx
80104933:	5e                   	pop    %esi
80104934:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104935:	e9 66 02 00 00       	jmp    80104ba0 <release>
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104940 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	56                   	push   %esi
80104945:	53                   	push   %ebx
80104946:	31 ff                	xor    %edi,%edi
80104948:	83 ec 18             	sub    $0x18,%esp
8010494b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010494e:	8d 73 04             	lea    0x4(%ebx),%esi
80104951:	56                   	push   %esi
80104952:	e8 99 01 00 00       	call   80104af0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104957:	8b 03                	mov    (%ebx),%eax
80104959:	83 c4 10             	add    $0x10,%esp
8010495c:	85 c0                	test   %eax,%eax
8010495e:	74 13                	je     80104973 <holdingsleep+0x33>
80104960:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104963:	e8 58 f2 ff ff       	call   80103bc0 <myproc>
80104968:	39 58 10             	cmp    %ebx,0x10(%eax)
8010496b:	0f 94 c0             	sete   %al
8010496e:	0f b6 c0             	movzbl %al,%eax
80104971:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104973:	83 ec 0c             	sub    $0xc,%esp
80104976:	56                   	push   %esi
80104977:	e8 24 02 00 00       	call   80104ba0 <release>
  return r;
}
8010497c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010497f:	89 f8                	mov    %edi,%eax
80104981:	5b                   	pop    %ebx
80104982:	5e                   	pop    %esi
80104983:	5f                   	pop    %edi
80104984:	5d                   	pop    %ebp
80104985:	c3                   	ret    
80104986:	66 90                	xchg   %ax,%ax
80104988:	66 90                	xchg   %ax,%ax
8010498a:	66 90                	xchg   %ax,%ax
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax

80104990 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104996:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104999:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010499f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801049a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    
801049ab:	90                   	nop
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801049b4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801049b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801049ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801049bd:	31 c0                	xor    %eax,%eax
801049bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801049c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049cc:	77 1a                	ja     801049e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801049d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049d4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801049d7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049d9:	83 f8 0a             	cmp    $0xa,%eax
801049dc:	75 e2                	jne    801049c0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801049de:	5b                   	pop    %ebx
801049df:	5d                   	pop    %ebp
801049e0:	c3                   	ret    
801049e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801049e8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801049ef:	83 c0 01             	add    $0x1,%eax
801049f2:	83 f8 0a             	cmp    $0xa,%eax
801049f5:	74 e7                	je     801049de <getcallerpcs+0x2e>
    pcs[i] = 0;
801049f7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801049fe:	83 c0 01             	add    $0x1,%eax
80104a01:	83 f8 0a             	cmp    $0xa,%eax
80104a04:	75 e2                	jne    801049e8 <getcallerpcs+0x38>
80104a06:	eb d6                	jmp    801049de <getcallerpcs+0x2e>
80104a08:	90                   	nop
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	9c                   	pushf  
80104a18:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104a19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a1a:	e8 01 f1 ff ff       	call   80103b20 <mycpu>
80104a1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a25:	85 c0                	test   %eax,%eax
80104a27:	75 11                	jne    80104a3a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a29:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a2f:	e8 ec f0 ff ff       	call   80103b20 <mycpu>
80104a34:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a3a:	e8 e1 f0 ff ff       	call   80103b20 <mycpu>
80104a3f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a46:	83 c4 04             	add    $0x4,%esp
80104a49:	5b                   	pop    %ebx
80104a4a:	5d                   	pop    %ebp
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <popcli>:

void
popcli(void)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a56:	9c                   	pushf  
80104a57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a58:	f6 c4 02             	test   $0x2,%ah
80104a5b:	75 52                	jne    80104aaf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a5d:	e8 be f0 ff ff       	call   80103b20 <mycpu>
80104a62:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104a68:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104a6b:	85 d2                	test   %edx,%edx
80104a6d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104a73:	78 2d                	js     80104aa2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a75:	e8 a6 f0 ff ff       	call   80103b20 <mycpu>
80104a7a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a80:	85 d2                	test   %edx,%edx
80104a82:	74 0c                	je     80104a90 <popcli+0x40>
    sti();
}
80104a84:	c9                   	leave  
80104a85:	c3                   	ret    
80104a86:	8d 76 00             	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a90:	e8 8b f0 ff ff       	call   80103b20 <mycpu>
80104a95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a9b:	85 c0                	test   %eax,%eax
80104a9d:	74 e5                	je     80104a84 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104a9f:	fb                   	sti    
    sti();
}
80104aa0:	c9                   	leave  
80104aa1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104aa2:	83 ec 0c             	sub    $0xc,%esp
80104aa5:	68 1a 80 10 80       	push   $0x8010801a
80104aaa:	e8 c1 b8 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104aaf:	83 ec 0c             	sub    $0xc,%esp
80104ab2:	68 03 80 10 80       	push   $0x80108003
80104ab7:	e8 b4 b8 ff ff       	call   80100370 <panic>
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ac8:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104aca:	e8 41 ff ff ff       	call   80104a10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104acf:	8b 06                	mov    (%esi),%eax
80104ad1:	85 c0                	test   %eax,%eax
80104ad3:	74 10                	je     80104ae5 <holding+0x25>
80104ad5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ad8:	e8 43 f0 ff ff       	call   80103b20 <mycpu>
80104add:	39 c3                	cmp    %eax,%ebx
80104adf:	0f 94 c3             	sete   %bl
80104ae2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104ae5:	e8 66 ff ff ff       	call   80104a50 <popcli>
  return r;
}
80104aea:	89 d8                	mov    %ebx,%eax
80104aec:	5b                   	pop    %ebx
80104aed:	5e                   	pop    %esi
80104aee:	5d                   	pop    %ebp
80104aef:	c3                   	ret    

80104af0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104af7:	e8 14 ff ff ff       	call   80104a10 <pushcli>
  if(holding(lk))
80104afc:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104aff:	83 ec 0c             	sub    $0xc,%esp
80104b02:	53                   	push   %ebx
80104b03:	e8 b8 ff ff ff       	call   80104ac0 <holding>
80104b08:	83 c4 10             	add    $0x10,%esp
80104b0b:	85 c0                	test   %eax,%eax
80104b0d:	0f 85 7d 00 00 00    	jne    80104b90 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104b13:	ba 01 00 00 00       	mov    $0x1,%edx
80104b18:	eb 09                	jmp    80104b23 <acquire+0x33>
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b23:	89 d0                	mov    %edx,%eax
80104b25:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104b28:	85 c0                	test   %eax,%eax
80104b2a:	75 f4                	jne    80104b20 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104b2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b34:	e8 e7 ef ff ff       	call   80103b20 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b39:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104b3b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104b3e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b41:	31 c0                	xor    %eax,%eax
80104b43:	90                   	nop
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b48:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b4e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b54:	77 1a                	ja     80104b70 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b56:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b59:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b5c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104b5f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b61:	83 f8 0a             	cmp    $0xa,%eax
80104b64:	75 e2                	jne    80104b48 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b69:	c9                   	leave  
80104b6a:	c3                   	ret    
80104b6b:	90                   	nop
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104b70:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b77:	83 c0 01             	add    $0x1,%eax
80104b7a:	83 f8 0a             	cmp    $0xa,%eax
80104b7d:	74 e7                	je     80104b66 <acquire+0x76>
    pcs[i] = 0;
80104b7f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b86:	83 c0 01             	add    $0x1,%eax
80104b89:	83 f8 0a             	cmp    $0xa,%eax
80104b8c:	75 e2                	jne    80104b70 <acquire+0x80>
80104b8e:	eb d6                	jmp    80104b66 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	68 21 80 10 80       	push   $0x80108021
80104b98:	e8 d3 b7 ff ff       	call   80100370 <panic>
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ba0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	53                   	push   %ebx
80104ba4:	83 ec 10             	sub    $0x10,%esp
80104ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104baa:	53                   	push   %ebx
80104bab:	e8 10 ff ff ff       	call   80104ac0 <holding>
80104bb0:	83 c4 10             	add    $0x10,%esp
80104bb3:	85 c0                	test   %eax,%eax
80104bb5:	74 22                	je     80104bd9 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104bb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bbe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104bc5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104bd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd3:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104bd4:	e9 77 fe ff ff       	jmp    80104a50 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104bd9:	83 ec 0c             	sub    $0xc,%esp
80104bdc:	68 29 80 10 80       	push   $0x80108029
80104be1:	e8 8a b7 ff ff       	call   80100370 <panic>
80104be6:	66 90                	xchg   %ax,%ax
80104be8:	66 90                	xchg   %ax,%ax
80104bea:	66 90                	xchg   %ax,%ax
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 55 08             	mov    0x8(%ebp),%edx
80104bf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104bfb:	f6 c2 03             	test   $0x3,%dl
80104bfe:	75 05                	jne    80104c05 <memset+0x15>
80104c00:	f6 c1 03             	test   $0x3,%cl
80104c03:	74 13                	je     80104c18 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104c05:	89 d7                	mov    %edx,%edi
80104c07:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0a:	fc                   	cld    
80104c0b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c0d:	5b                   	pop    %ebx
80104c0e:	89 d0                	mov    %edx,%eax
80104c10:	5f                   	pop    %edi
80104c11:	5d                   	pop    %ebp
80104c12:	c3                   	ret    
80104c13:	90                   	nop
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104c18:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104c1c:	c1 e9 02             	shr    $0x2,%ecx
80104c1f:	89 fb                	mov    %edi,%ebx
80104c21:	89 f8                	mov    %edi,%eax
80104c23:	c1 e3 18             	shl    $0x18,%ebx
80104c26:	c1 e0 10             	shl    $0x10,%eax
80104c29:	09 d8                	or     %ebx,%eax
80104c2b:	09 f8                	or     %edi,%eax
80104c2d:	c1 e7 08             	shl    $0x8,%edi
80104c30:	09 f8                	or     %edi,%eax
80104c32:	89 d7                	mov    %edx,%edi
80104c34:	fc                   	cld    
80104c35:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c37:	5b                   	pop    %ebx
80104c38:	89 d0                	mov    %edx,%eax
80104c3a:	5f                   	pop    %edi
80104c3b:	5d                   	pop    %ebp
80104c3c:	c3                   	ret    
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi

80104c40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	56                   	push   %esi
80104c45:	8b 45 10             	mov    0x10(%ebp),%eax
80104c48:	53                   	push   %ebx
80104c49:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c4f:	85 c0                	test   %eax,%eax
80104c51:	74 29                	je     80104c7c <memcmp+0x3c>
    if(*s1 != *s2)
80104c53:	0f b6 13             	movzbl (%ebx),%edx
80104c56:	0f b6 0e             	movzbl (%esi),%ecx
80104c59:	38 d1                	cmp    %dl,%cl
80104c5b:	75 2b                	jne    80104c88 <memcmp+0x48>
80104c5d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104c60:	31 c0                	xor    %eax,%eax
80104c62:	eb 14                	jmp    80104c78 <memcmp+0x38>
80104c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c68:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104c6d:	83 c0 01             	add    $0x1,%eax
80104c70:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c74:	38 ca                	cmp    %cl,%dl
80104c76:	75 10                	jne    80104c88 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c78:	39 f8                	cmp    %edi,%eax
80104c7a:	75 ec                	jne    80104c68 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104c7c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104c7d:	31 c0                	xor    %eax,%eax
}
80104c7f:	5e                   	pop    %esi
80104c80:	5f                   	pop    %edi
80104c81:	5d                   	pop    %ebp
80104c82:	c3                   	ret    
80104c83:	90                   	nop
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104c88:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104c8b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104c8c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104c8e:	5e                   	pop    %esi
80104c8f:	5f                   	pop    %edi
80104c90:	5d                   	pop    %ebp
80104c91:	c3                   	ret    
80104c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cae:	39 c6                	cmp    %eax,%esi
80104cb0:	73 2e                	jae    80104ce0 <memmove+0x40>
80104cb2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104cb5:	39 c8                	cmp    %ecx,%eax
80104cb7:	73 27                	jae    80104ce0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104cb9:	85 db                	test   %ebx,%ebx
80104cbb:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104cbe:	74 17                	je     80104cd7 <memmove+0x37>
      *--d = *--s;
80104cc0:	29 d9                	sub    %ebx,%ecx
80104cc2:	89 cb                	mov    %ecx,%ebx
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ccc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104ccf:	83 ea 01             	sub    $0x1,%edx
80104cd2:	83 fa ff             	cmp    $0xffffffff,%edx
80104cd5:	75 f1                	jne    80104cc8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cd7:	5b                   	pop    %ebx
80104cd8:	5e                   	pop    %esi
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    
80104cdb:	90                   	nop
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104ce0:	31 d2                	xor    %edx,%edx
80104ce2:	85 db                	test   %ebx,%ebx
80104ce4:	74 f1                	je     80104cd7 <memmove+0x37>
80104ce6:	8d 76 00             	lea    0x0(%esi),%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104cf0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104cf4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104cf7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104cfa:	39 d3                	cmp    %edx,%ebx
80104cfc:	75 f2                	jne    80104cf0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104cfe:	5b                   	pop    %ebx
80104cff:	5e                   	pop    %esi
80104d00:	5d                   	pop    %ebp
80104d01:	c3                   	ret    
80104d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d13:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104d14:	eb 8a                	jmp    80104ca0 <memmove>
80104d16:	8d 76 00             	lea    0x0(%esi),%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d28:	53                   	push   %ebx
80104d29:	8b 7d 08             	mov    0x8(%ebp),%edi
80104d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d2f:	85 c9                	test   %ecx,%ecx
80104d31:	74 37                	je     80104d6a <strncmp+0x4a>
80104d33:	0f b6 17             	movzbl (%edi),%edx
80104d36:	0f b6 1e             	movzbl (%esi),%ebx
80104d39:	84 d2                	test   %dl,%dl
80104d3b:	74 3f                	je     80104d7c <strncmp+0x5c>
80104d3d:	38 d3                	cmp    %dl,%bl
80104d3f:	75 3b                	jne    80104d7c <strncmp+0x5c>
80104d41:	8d 47 01             	lea    0x1(%edi),%eax
80104d44:	01 cf                	add    %ecx,%edi
80104d46:	eb 1b                	jmp    80104d63 <strncmp+0x43>
80104d48:	90                   	nop
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d50:	0f b6 10             	movzbl (%eax),%edx
80104d53:	84 d2                	test   %dl,%dl
80104d55:	74 21                	je     80104d78 <strncmp+0x58>
80104d57:	0f b6 19             	movzbl (%ecx),%ebx
80104d5a:	83 c0 01             	add    $0x1,%eax
80104d5d:	89 ce                	mov    %ecx,%esi
80104d5f:	38 da                	cmp    %bl,%dl
80104d61:	75 19                	jne    80104d7c <strncmp+0x5c>
80104d63:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104d65:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104d68:	75 e6                	jne    80104d50 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104d6a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104d6b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104d6d:	5e                   	pop    %esi
80104d6e:	5f                   	pop    %edi
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret    
80104d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d78:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d7c:	0f b6 c2             	movzbl %dl,%eax
80104d7f:	29 d8                	sub    %ebx,%eax
}
80104d81:	5b                   	pop    %ebx
80104d82:	5e                   	pop    %esi
80104d83:	5f                   	pop    %edi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d 76 00             	lea    0x0(%esi),%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 45 08             	mov    0x8(%ebp),%eax
80104d98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d9e:	89 c2                	mov    %eax,%edx
80104da0:	eb 19                	jmp    80104dbb <strncpy+0x2b>
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104da8:	83 c3 01             	add    $0x1,%ebx
80104dab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104daf:	83 c2 01             	add    $0x1,%edx
80104db2:	84 c9                	test   %cl,%cl
80104db4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104db7:	74 09                	je     80104dc2 <strncpy+0x32>
80104db9:	89 f1                	mov    %esi,%ecx
80104dbb:	85 c9                	test   %ecx,%ecx
80104dbd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104dc0:	7f e6                	jg     80104da8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104dc2:	31 c9                	xor    %ecx,%ecx
80104dc4:	85 f6                	test   %esi,%esi
80104dc6:	7e 17                	jle    80104ddf <strncpy+0x4f>
80104dc8:	90                   	nop
80104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104dd0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104dd4:	89 f3                	mov    %esi,%ebx
80104dd6:	83 c1 01             	add    $0x1,%ecx
80104dd9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104ddb:	85 db                	test   %ebx,%ebx
80104ddd:	7f f1                	jg     80104dd0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104ddf:	5b                   	pop    %ebx
80104de0:	5e                   	pop    %esi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104df8:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104dfe:	85 c9                	test   %ecx,%ecx
80104e00:	7e 26                	jle    80104e28 <safestrcpy+0x38>
80104e02:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e06:	89 c1                	mov    %eax,%ecx
80104e08:	eb 17                	jmp    80104e21 <safestrcpy+0x31>
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e10:	83 c2 01             	add    $0x1,%edx
80104e13:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e17:	83 c1 01             	add    $0x1,%ecx
80104e1a:	84 db                	test   %bl,%bl
80104e1c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e1f:	74 04                	je     80104e25 <safestrcpy+0x35>
80104e21:	39 f2                	cmp    %esi,%edx
80104e23:	75 eb                	jne    80104e10 <safestrcpy+0x20>
    ;
  *s = 0;
80104e25:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e28:	5b                   	pop    %ebx
80104e29:	5e                   	pop    %esi
80104e2a:	5d                   	pop    %ebp
80104e2b:	c3                   	ret    
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e30 <strlen>:

int
strlen(const char *s)
{
80104e30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e31:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104e38:	80 3a 00             	cmpb   $0x0,(%edx)
80104e3b:	74 0c                	je     80104e49 <strlen+0x19>
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
80104e40:	83 c0 01             	add    $0x1,%eax
80104e43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e47:	75 f7                	jne    80104e40 <strlen+0x10>
    ;
  return n;
}
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    

80104e4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e53:	55                   	push   %ebp
  pushl %ebx
80104e54:	53                   	push   %ebx
  pushl %esi
80104e55:	56                   	push   %esi
  pushl %edi
80104e56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e5b:	5f                   	pop    %edi
  popl %esi
80104e5c:	5e                   	pop    %esi
  popl %ebx
80104e5d:	5b                   	pop    %ebx
  popl %ebp
80104e5e:	5d                   	pop    %ebp
  ret
80104e5f:	c3                   	ret    

80104e60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 04             	sub    $0x4,%esp
80104e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e6a:	e8 51 ed ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e6f:	8b 00                	mov    (%eax),%eax
80104e71:	39 d8                	cmp    %ebx,%eax
80104e73:	76 1b                	jbe    80104e90 <fetchint+0x30>
80104e75:	8d 53 04             	lea    0x4(%ebx),%edx
80104e78:	39 d0                	cmp    %edx,%eax
80104e7a:	72 14                	jb     80104e90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7f:	8b 13                	mov    (%ebx),%edx
80104e81:	89 10                	mov    %edx,(%eax)
  return 0;
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	83 c4 04             	add    $0x4,%esp
80104e88:	5b                   	pop    %ebx
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	90                   	nop
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb ee                	jmp    80104e85 <fetchint+0x25>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
80104ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eaa:	e8 11 ed ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz)
80104eaf:	39 18                	cmp    %ebx,(%eax)
80104eb1:	76 29                	jbe    80104edc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104eb6:	89 da                	mov    %ebx,%edx
80104eb8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104eba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104ebc:	39 c3                	cmp    %eax,%ebx
80104ebe:	73 1c                	jae    80104edc <fetchstr+0x3c>
    if(*s == 0)
80104ec0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ec3:	75 10                	jne    80104ed5 <fetchstr+0x35>
80104ec5:	eb 29                	jmp    80104ef0 <fetchstr+0x50>
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ed0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ed3:	74 1b                	je     80104ef0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104ed5:	83 c2 01             	add    $0x1,%edx
80104ed8:	39 d0                	cmp    %edx,%eax
80104eda:	77 f4                	ja     80104ed0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104edc:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104ee4:	5b                   	pop    %ebx
80104ee5:	5d                   	pop    %ebp
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ef0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104ef3:	89 d0                	mov    %edx,%eax
80104ef5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ef7:	5b                   	pop    %ebx
80104ef8:	5d                   	pop    %ebp
80104ef9:	c3                   	ret    
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f05:	e8 b6 ec ff ff       	call   80103bc0 <myproc>
80104f0a:	8b 40 18             	mov    0x18(%eax),%eax
80104f0d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f10:	8b 40 44             	mov    0x44(%eax),%eax
80104f13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104f16:	e8 a5 ec ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f1b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f1d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f20:	39 c6                	cmp    %eax,%esi
80104f22:	73 1c                	jae    80104f40 <argint+0x40>
80104f24:	8d 53 08             	lea    0x8(%ebx),%edx
80104f27:	39 d0                	cmp    %edx,%eax
80104f29:	72 15                	jb     80104f40 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f31:	89 10                	mov    %edx,(%eax)
  return 0;
80104f33:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104f35:	5b                   	pop    %ebx
80104f36:	5e                   	pop    %esi
80104f37:	5d                   	pop    %ebp
80104f38:	c3                   	ret    
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb ee                	jmp    80104f35 <argint+0x35>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
80104f55:	83 ec 10             	sub    $0x10,%esp
80104f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f5b:	e8 60 ec ff ff       	call   80103bc0 <myproc>
80104f60:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104f62:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f65:	83 ec 08             	sub    $0x8,%esp
80104f68:	50                   	push   %eax
80104f69:	ff 75 08             	pushl  0x8(%ebp)
80104f6c:	e8 8f ff ff ff       	call   80104f00 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f71:	c1 e8 1f             	shr    $0x1f,%eax
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	84 c0                	test   %al,%al
80104f79:	75 2d                	jne    80104fa8 <argptr+0x58>
80104f7b:	89 d8                	mov    %ebx,%eax
80104f7d:	c1 e8 1f             	shr    $0x1f,%eax
80104f80:	84 c0                	test   %al,%al
80104f82:	75 24                	jne    80104fa8 <argptr+0x58>
80104f84:	8b 16                	mov    (%esi),%edx
80104f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f89:	39 c2                	cmp    %eax,%edx
80104f8b:	76 1b                	jbe    80104fa8 <argptr+0x58>
80104f8d:	01 c3                	add    %eax,%ebx
80104f8f:	39 da                	cmp    %ebx,%edx
80104f91:	72 15                	jb     80104fa8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104f93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f96:	89 02                	mov    %eax,(%edx)
  return 0;
80104f98:	31 c0                	xor    %eax,%eax
}
80104f9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9d:	5b                   	pop    %ebx
80104f9e:	5e                   	pop    %esi
80104f9f:	5d                   	pop    %ebp
80104fa0:	c3                   	ret    
80104fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fad:	eb eb                	jmp    80104f9a <argptr+0x4a>
80104faf:	90                   	nop

80104fb0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fb9:	50                   	push   %eax
80104fba:	ff 75 08             	pushl  0x8(%ebp)
80104fbd:	e8 3e ff ff ff       	call   80104f00 <argint>
80104fc2:	83 c4 10             	add    $0x10,%esp
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	78 17                	js     80104fe0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104fc9:	83 ec 08             	sub    $0x8,%esp
80104fcc:	ff 75 0c             	pushl  0xc(%ebp)
80104fcf:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd2:	e8 c9 fe ff ff       	call   80104ea0 <fetchstr>
80104fd7:	83 c4 10             	add    $0x10,%esp
}
80104fda:	c9                   	leave  
80104fdb:	c3                   	ret    
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104fe5:	c9                   	leave  
80104fe6:	c3                   	ret    
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <syscall>:
[SYS_list] sys_list,
};

void
syscall(void)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104ff5:	e8 c6 eb ff ff       	call   80103bc0 <myproc>

  num = curproc->tf->eax;
80104ffa:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104ffd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104fff:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105002:	8d 50 ff             	lea    -0x1(%eax),%edx
80105005:	83 fa 1b             	cmp    $0x1b,%edx
80105008:	77 1e                	ja     80105028 <syscall+0x38>
8010500a:	8b 14 85 60 80 10 80 	mov    -0x7fef7fa0(,%eax,4),%edx
80105011:	85 d2                	test   %edx,%edx
80105013:	74 13                	je     80105028 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105015:	ff d2                	call   *%edx
80105017:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010501a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010501d:	5b                   	pop    %ebx
8010501e:	5e                   	pop    %esi
8010501f:	5d                   	pop    %ebp
80105020:	c3                   	ret    
80105021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105028:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105029:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010502c:	50                   	push   %eax
8010502d:	ff 73 10             	pushl  0x10(%ebx)
80105030:	68 31 80 10 80       	push   $0x80108031
80105035:	e8 26 b6 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010503a:	8b 43 18             	mov    0x18(%ebx),%eax
8010503d:	83 c4 10             	add    $0x10,%esp
80105040:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105047:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010504a:	5b                   	pop    %ebx
8010504b:	5e                   	pop    %esi
8010504c:	5d                   	pop    %ebp
8010504d:	c3                   	ret    
8010504e:	66 90                	xchg   %ax,%ax

80105050 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
80105055:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105056:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105059:	83 ec 34             	sub    $0x34,%esp
8010505c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010505f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105062:	56                   	push   %esi
80105063:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105064:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105067:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010506a:	e8 61 d2 ff ff       	call   801022d0 <nameiparent>
8010506f:	83 c4 10             	add    $0x10,%esp
80105072:	85 c0                	test   %eax,%eax
80105074:	0f 84 f6 00 00 00    	je     80105170 <create+0x120>
    return 0;
  ilock(dp);
8010507a:	83 ec 0c             	sub    $0xc,%esp
8010507d:	89 c7                	mov    %eax,%edi
8010507f:	50                   	push   %eax
80105080:	e8 db c9 ff ff       	call   80101a60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105085:	83 c4 0c             	add    $0xc,%esp
80105088:	6a 00                	push   $0x0
8010508a:	56                   	push   %esi
8010508b:	57                   	push   %edi
8010508c:	e8 ff ce ff ff       	call   80101f90 <dirlookup>
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	85 c0                	test   %eax,%eax
80105096:	89 c3                	mov    %eax,%ebx
80105098:	74 56                	je     801050f0 <create+0xa0>
    iunlockput(dp);
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	57                   	push   %edi
8010509e:	e8 4d cc ff ff       	call   80101cf0 <iunlockput>
    ilock(ip);
801050a3:	89 1c 24             	mov    %ebx,(%esp)
801050a6:	e8 b5 c9 ff ff       	call   80101a60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050ab:	83 c4 10             	add    $0x10,%esp
801050ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801050b3:	75 1b                	jne    801050d0 <create+0x80>
801050b5:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801050ba:	89 d8                	mov    %ebx,%eax
801050bc:	75 12                	jne    801050d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5f                   	pop    %edi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d 76 00             	lea    0x0(%esi),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801050d0:	83 ec 0c             	sub    $0xc,%esp
801050d3:	53                   	push   %ebx
801050d4:	e8 17 cc ff ff       	call   80101cf0 <iunlockput>
    return 0;
801050d9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801050df:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050e1:	5b                   	pop    %ebx
801050e2:	5e                   	pop    %esi
801050e3:	5f                   	pop    %edi
801050e4:	5d                   	pop    %ebp
801050e5:	c3                   	ret    
801050e6:	8d 76 00             	lea    0x0(%esi),%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801050f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	50                   	push   %eax
801050f8:	ff 37                	pushl  (%edi)
801050fa:	e8 f1 c7 ff ff       	call   801018f0 <ialloc>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	85 c0                	test   %eax,%eax
80105104:	89 c3                	mov    %eax,%ebx
80105106:	0f 84 cc 00 00 00    	je     801051d8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	50                   	push   %eax
80105110:	e8 4b c9 ff ff       	call   80101a60 <ilock>
  ip->major = major;
80105115:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105119:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010511d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105121:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105125:	b8 01 00 00 00       	mov    $0x1,%eax
8010512a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010512e:	89 1c 24             	mov    %ebx,(%esp)
80105131:	e8 7a c8 ff ff       	call   801019b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010513e:	74 40                	je     80105180 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	ff 73 04             	pushl  0x4(%ebx)
80105146:	56                   	push   %esi
80105147:	57                   	push   %edi
80105148:	e8 a3 d0 ff ff       	call   801021f0 <dirlink>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	78 77                	js     801051cb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	57                   	push   %edi
80105158:	e8 93 cb ff ff       	call   80101cf0 <iunlockput>

  return ip;
8010515d:	83 c4 10             	add    $0x10,%esp
}
80105160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105163:	89 d8                	mov    %ebx,%eax
}
80105165:	5b                   	pop    %ebx
80105166:	5e                   	pop    %esi
80105167:	5f                   	pop    %edi
80105168:	5d                   	pop    %ebp
80105169:	c3                   	ret    
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105170:	31 c0                	xor    %eax,%eax
80105172:	e9 47 ff ff ff       	jmp    801050be <create+0x6e>
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105180:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105185:	83 ec 0c             	sub    $0xc,%esp
80105188:	57                   	push   %edi
80105189:	e8 22 c8 ff ff       	call   801019b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010518e:	83 c4 0c             	add    $0xc,%esp
80105191:	ff 73 04             	pushl  0x4(%ebx)
80105194:	68 f0 80 10 80       	push   $0x801080f0
80105199:	53                   	push   %ebx
8010519a:	e8 51 d0 ff ff       	call   801021f0 <dirlink>
8010519f:	83 c4 10             	add    $0x10,%esp
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 18                	js     801051be <create+0x16e>
801051a6:	83 ec 04             	sub    $0x4,%esp
801051a9:	ff 77 04             	pushl  0x4(%edi)
801051ac:	68 ef 80 10 80       	push   $0x801080ef
801051b1:	53                   	push   %ebx
801051b2:	e8 39 d0 ff ff       	call   801021f0 <dirlink>
801051b7:	83 c4 10             	add    $0x10,%esp
801051ba:	85 c0                	test   %eax,%eax
801051bc:	79 82                	jns    80105140 <create+0xf0>
      panic("create dots");
801051be:	83 ec 0c             	sub    $0xc,%esp
801051c1:	68 e3 80 10 80       	push   $0x801080e3
801051c6:	e8 a5 b1 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801051cb:	83 ec 0c             	sub    $0xc,%esp
801051ce:	68 f2 80 10 80       	push   $0x801080f2
801051d3:	e8 98 b1 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	68 d4 80 10 80       	push   $0x801080d4
801051e0:	e8 8b b1 ff ff       	call   80100370 <panic>
801051e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
801051f5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801051f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801051fa:	89 d3                	mov    %edx,%ebx
801051fc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801051ff:	50                   	push   %eax
80105200:	6a 00                	push   $0x0
80105202:	e8 f9 fc ff ff       	call   80104f00 <argint>
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	85 c0                	test   %eax,%eax
8010520c:	78 32                	js     80105240 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010520e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105212:	77 2c                	ja     80105240 <argfd.constprop.0+0x50>
80105214:	e8 a7 e9 ff ff       	call   80103bc0 <myproc>
80105219:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010521c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105220:	85 c0                	test   %eax,%eax
80105222:	74 1c                	je     80105240 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105224:	85 f6                	test   %esi,%esi
80105226:	74 02                	je     8010522a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105228:	89 16                	mov    %edx,(%esi)
  if(pf)
8010522a:	85 db                	test   %ebx,%ebx
8010522c:	74 22                	je     80105250 <argfd.constprop.0+0x60>
    *pf = f;
8010522e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105230:	31 c0                	xor    %eax,%eax
}
80105232:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105235:	5b                   	pop    %ebx
80105236:	5e                   	pop    %esi
80105237:	5d                   	pop    %ebp
80105238:	c3                   	ret    
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105240:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105248:	5b                   	pop    %ebx
80105249:	5e                   	pop    %esi
8010524a:	5d                   	pop    %ebp
8010524b:	c3                   	ret    
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105250:	31 c0                	xor    %eax,%eax
80105252:	eb de                	jmp    80105232 <argfd.constprop.0+0x42>
80105254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010525a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105260 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105260:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105261:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105263:	89 e5                	mov    %esp,%ebp
80105265:	56                   	push   %esi
80105266:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105267:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010526a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010526d:	e8 7e ff ff ff       	call   801051f0 <argfd.constprop.0>
80105272:	85 c0                	test   %eax,%eax
80105274:	78 1a                	js     80105290 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105276:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105278:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010527b:	e8 40 e9 ff ff       	call   80103bc0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105280:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105284:	85 d2                	test   %edx,%edx
80105286:	74 18                	je     801052a0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c3 01             	add    $0x1,%ebx
8010528b:	83 fb 10             	cmp    $0x10,%ebx
8010528e:	75 f0                	jne    80105280 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105290:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105298:	5b                   	pop    %ebx
80105299:	5e                   	pop    %esi
8010529a:	5d                   	pop    %ebp
8010529b:	c3                   	ret    
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801052a0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	ff 75 f4             	pushl  -0xc(%ebp)
801052aa:	e8 31 bf ff ff       	call   801011e0 <filedup>
  return fd;
801052af:	83 c4 10             	add    $0x10,%esp
}
801052b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801052b5:	89 d8                	mov    %ebx,%eax
}
801052b7:	5b                   	pop    %ebx
801052b8:	5e                   	pop    %esi
801052b9:	5d                   	pop    %ebp
801052ba:	c3                   	ret    
801052bb:	90                   	nop
801052bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_read>:

int
sys_read(void)
{
801052c0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052c1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801052c3:	89 e5                	mov    %esp,%ebp
801052c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052cb:	e8 20 ff ff ff       	call   801051f0 <argfd.constprop.0>
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 4c                	js     80105320 <sys_read+0x60>
801052d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052d7:	83 ec 08             	sub    $0x8,%esp
801052da:	50                   	push   %eax
801052db:	6a 02                	push   $0x2
801052dd:	e8 1e fc ff ff       	call   80104f00 <argint>
801052e2:	83 c4 10             	add    $0x10,%esp
801052e5:	85 c0                	test   %eax,%eax
801052e7:	78 37                	js     80105320 <sys_read+0x60>
801052e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ec:	83 ec 04             	sub    $0x4,%esp
801052ef:	ff 75 f0             	pushl  -0x10(%ebp)
801052f2:	50                   	push   %eax
801052f3:	6a 01                	push   $0x1
801052f5:	e8 56 fc ff ff       	call   80104f50 <argptr>
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	85 c0                	test   %eax,%eax
801052ff:	78 1f                	js     80105320 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105301:	83 ec 04             	sub    $0x4,%esp
80105304:	ff 75 f0             	pushl  -0x10(%ebp)
80105307:	ff 75 f4             	pushl  -0xc(%ebp)
8010530a:	ff 75 ec             	pushl  -0x14(%ebp)
8010530d:	e8 3e c0 ff ff       	call   80101350 <fileread>
80105312:	83 c4 10             	add    $0x10,%esp
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_write>:

int
sys_write(void)
{
80105330:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105331:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105333:	89 e5                	mov    %esp,%ebp
80105335:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105338:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010533b:	e8 b0 fe ff ff       	call   801051f0 <argfd.constprop.0>
80105340:	85 c0                	test   %eax,%eax
80105342:	78 4c                	js     80105390 <sys_write+0x60>
80105344:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105347:	83 ec 08             	sub    $0x8,%esp
8010534a:	50                   	push   %eax
8010534b:	6a 02                	push   $0x2
8010534d:	e8 ae fb ff ff       	call   80104f00 <argint>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 37                	js     80105390 <sys_write+0x60>
80105359:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535c:	83 ec 04             	sub    $0x4,%esp
8010535f:	ff 75 f0             	pushl  -0x10(%ebp)
80105362:	50                   	push   %eax
80105363:	6a 01                	push   $0x1
80105365:	e8 e6 fb ff ff       	call   80104f50 <argptr>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	78 1f                	js     80105390 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105371:	83 ec 04             	sub    $0x4,%esp
80105374:	ff 75 f0             	pushl  -0x10(%ebp)
80105377:	ff 75 f4             	pushl  -0xc(%ebp)
8010537a:	ff 75 ec             	pushl  -0x14(%ebp)
8010537d:	e8 5e c0 ff ff       	call   801013e0 <filewrite>
80105382:	83 c4 10             	add    $0x10,%esp
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_close>:

int
sys_close(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801053a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801053a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ac:	e8 3f fe ff ff       	call   801051f0 <argfd.constprop.0>
801053b1:	85 c0                	test   %eax,%eax
801053b3:	78 2b                	js     801053e0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801053b5:	e8 06 e8 ff ff       	call   80103bc0 <myproc>
801053ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801053bd:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
801053c0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053c7:	00 
  fileclose(f);
801053c8:	ff 75 f4             	pushl  -0xc(%ebp)
801053cb:	e8 60 be ff ff       	call   80101230 <fileclose>
  return 0;
801053d0:	83 c4 10             	add    $0x10,%esp
801053d3:	31 c0                	xor    %eax,%eax
}
801053d5:	c9                   	leave  
801053d6:	c3                   	ret    
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801053e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801053e5:	c9                   	leave  
801053e6:	c3                   	ret    
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <sys_fstat>:

int
sys_fstat(void)
{
801053f0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053f1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801053f3:	89 e5                	mov    %esp,%ebp
801053f5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053f8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801053fb:	e8 f0 fd ff ff       	call   801051f0 <argfd.constprop.0>
80105400:	85 c0                	test   %eax,%eax
80105402:	78 2c                	js     80105430 <sys_fstat+0x40>
80105404:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105407:	83 ec 04             	sub    $0x4,%esp
8010540a:	6a 14                	push   $0x14
8010540c:	50                   	push   %eax
8010540d:	6a 01                	push   $0x1
8010540f:	e8 3c fb ff ff       	call   80104f50 <argptr>
80105414:	83 c4 10             	add    $0x10,%esp
80105417:	85 c0                	test   %eax,%eax
80105419:	78 15                	js     80105430 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010541b:	83 ec 08             	sub    $0x8,%esp
8010541e:	ff 75 f4             	pushl  -0xc(%ebp)
80105421:	ff 75 f0             	pushl  -0x10(%ebp)
80105424:	e8 d7 be ff ff       	call   80101300 <filestat>
80105429:	83 c4 10             	add    $0x10,%esp
}
8010542c:	c9                   	leave  
8010542d:	c3                   	ret    
8010542e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105446:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105449:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010544c:	50                   	push   %eax
8010544d:	6a 00                	push   $0x0
8010544f:	e8 5c fb ff ff       	call   80104fb0 <argstr>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	0f 88 fb 00 00 00    	js     8010555a <sys_link+0x11a>
8010545f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105462:	83 ec 08             	sub    $0x8,%esp
80105465:	50                   	push   %eax
80105466:	6a 01                	push   $0x1
80105468:	e8 43 fb ff ff       	call   80104fb0 <argstr>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	0f 88 e2 00 00 00    	js     8010555a <sys_link+0x11a>
    return -1;

  begin_op();
80105478:	e8 c3 da ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	ff 75 d4             	pushl  -0x2c(%ebp)
80105483:	e8 28 ce ff ff       	call   801022b0 <namei>
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	85 c0                	test   %eax,%eax
8010548d:	89 c3                	mov    %eax,%ebx
8010548f:	0f 84 f3 00 00 00    	je     80105588 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	50                   	push   %eax
80105499:	e8 c2 c5 ff ff       	call   80101a60 <ilock>
  if(ip->type == T_DIR){
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a6:	0f 84 c4 00 00 00    	je     80105570 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801054ac:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801054b1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801054b4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801054b7:	53                   	push   %ebx
801054b8:	e8 f3 c4 ff ff       	call   801019b0 <iupdate>
  iunlock(ip);
801054bd:	89 1c 24             	mov    %ebx,(%esp)
801054c0:	e8 7b c6 ff ff       	call   80101b40 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801054c5:	58                   	pop    %eax
801054c6:	5a                   	pop    %edx
801054c7:	57                   	push   %edi
801054c8:	ff 75 d0             	pushl  -0x30(%ebp)
801054cb:	e8 00 ce ff ff       	call   801022d0 <nameiparent>
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	85 c0                	test   %eax,%eax
801054d5:	89 c6                	mov    %eax,%esi
801054d7:	74 5b                	je     80105534 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	50                   	push   %eax
801054dd:	e8 7e c5 ff ff       	call   80101a60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	8b 03                	mov    (%ebx),%eax
801054e7:	39 06                	cmp    %eax,(%esi)
801054e9:	75 3d                	jne    80105528 <sys_link+0xe8>
801054eb:	83 ec 04             	sub    $0x4,%esp
801054ee:	ff 73 04             	pushl  0x4(%ebx)
801054f1:	57                   	push   %edi
801054f2:	56                   	push   %esi
801054f3:	e8 f8 cc ff ff       	call   801021f0 <dirlink>
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	85 c0                	test   %eax,%eax
801054fd:	78 29                	js     80105528 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801054ff:	83 ec 0c             	sub    $0xc,%esp
80105502:	56                   	push   %esi
80105503:	e8 e8 c7 ff ff       	call   80101cf0 <iunlockput>
  iput(ip);
80105508:	89 1c 24             	mov    %ebx,(%esp)
8010550b:	e8 80 c6 ff ff       	call   80101b90 <iput>

  end_op();
80105510:	e8 9b da ff ff       	call   80102fb0 <end_op>

  return 0;
80105515:	83 c4 10             	add    $0x10,%esp
80105518:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010551a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010551d:	5b                   	pop    %ebx
8010551e:	5e                   	pop    %esi
8010551f:	5f                   	pop    %edi
80105520:	5d                   	pop    %ebp
80105521:	c3                   	ret    
80105522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105528:	83 ec 0c             	sub    $0xc,%esp
8010552b:	56                   	push   %esi
8010552c:	e8 bf c7 ff ff       	call   80101cf0 <iunlockput>
    goto bad;
80105531:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	53                   	push   %ebx
80105538:	e8 23 c5 ff ff       	call   80101a60 <ilock>
  ip->nlink--;
8010553d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105542:	89 1c 24             	mov    %ebx,(%esp)
80105545:	e8 66 c4 ff ff       	call   801019b0 <iupdate>
  iunlockput(ip);
8010554a:	89 1c 24             	mov    %ebx,(%esp)
8010554d:	e8 9e c7 ff ff       	call   80101cf0 <iunlockput>
  end_op();
80105552:	e8 59 da ff ff       	call   80102fb0 <end_op>
  return -1;
80105557:	83 c4 10             	add    $0x10,%esp
}
8010555a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010555d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105562:	5b                   	pop    %ebx
80105563:	5e                   	pop    %esi
80105564:	5f                   	pop    %edi
80105565:	5d                   	pop    %ebp
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	53                   	push   %ebx
80105574:	e8 77 c7 ff ff       	call   80101cf0 <iunlockput>
    end_op();
80105579:	e8 32 da ff ff       	call   80102fb0 <end_op>
    return -1;
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105586:	eb 92                	jmp    8010551a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105588:	e8 23 da ff ff       	call   80102fb0 <end_op>
    return -1;
8010558d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105592:	eb 86                	jmp    8010551a <sys_link+0xda>
80105594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010559a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801055a0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
801055a5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801055a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801055a9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801055ac:	50                   	push   %eax
801055ad:	6a 00                	push   $0x0
801055af:	e8 fc f9 ff ff       	call   80104fb0 <argstr>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 88 82 01 00 00    	js     80105741 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801055bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
801055c2:	e8 79 d9 ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055c7:	83 ec 08             	sub    $0x8,%esp
801055ca:	53                   	push   %ebx
801055cb:	ff 75 c0             	pushl  -0x40(%ebp)
801055ce:	e8 fd cc ff ff       	call   801022d0 <nameiparent>
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801055db:	0f 84 6a 01 00 00    	je     8010574b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
801055e1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	56                   	push   %esi
801055e8:	e8 73 c4 ff ff       	call   80101a60 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055ed:	58                   	pop    %eax
801055ee:	5a                   	pop    %edx
801055ef:	68 f0 80 10 80       	push   $0x801080f0
801055f4:	53                   	push   %ebx
801055f5:	e8 76 c9 ff ff       	call   80101f70 <namecmp>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	0f 84 fc 00 00 00    	je     80105701 <sys_unlink+0x161>
80105605:	83 ec 08             	sub    $0x8,%esp
80105608:	68 ef 80 10 80       	push   $0x801080ef
8010560d:	53                   	push   %ebx
8010560e:	e8 5d c9 ff ff       	call   80101f70 <namecmp>
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	0f 84 e3 00 00 00    	je     80105701 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010561e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105621:	83 ec 04             	sub    $0x4,%esp
80105624:	50                   	push   %eax
80105625:	53                   	push   %ebx
80105626:	56                   	push   %esi
80105627:	e8 64 c9 ff ff       	call   80101f90 <dirlookup>
8010562c:	83 c4 10             	add    $0x10,%esp
8010562f:	85 c0                	test   %eax,%eax
80105631:	89 c3                	mov    %eax,%ebx
80105633:	0f 84 c8 00 00 00    	je     80105701 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	50                   	push   %eax
8010563d:	e8 1e c4 ff ff       	call   80101a60 <ilock>

  if(ip->nlink < 1)
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010564a:	0f 8e 24 01 00 00    	jle    80105774 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105650:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105655:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105658:	74 66                	je     801056c0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010565a:	83 ec 04             	sub    $0x4,%esp
8010565d:	6a 10                	push   $0x10
8010565f:	6a 00                	push   $0x0
80105661:	56                   	push   %esi
80105662:	e8 89 f5 ff ff       	call   80104bf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105667:	6a 10                	push   $0x10
80105669:	ff 75 c4             	pushl  -0x3c(%ebp)
8010566c:	56                   	push   %esi
8010566d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105670:	e8 cb c7 ff ff       	call   80101e40 <writei>
80105675:	83 c4 20             	add    $0x20,%esp
80105678:	83 f8 10             	cmp    $0x10,%eax
8010567b:	0f 85 e6 00 00 00    	jne    80105767 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105681:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105686:	0f 84 9c 00 00 00    	je     80105728 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105692:	e8 59 c6 ff ff       	call   80101cf0 <iunlockput>

  ip->nlink--;
80105697:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010569c:	89 1c 24             	mov    %ebx,(%esp)
8010569f:	e8 0c c3 ff ff       	call   801019b0 <iupdate>
  iunlockput(ip);
801056a4:	89 1c 24             	mov    %ebx,(%esp)
801056a7:	e8 44 c6 ff ff       	call   80101cf0 <iunlockput>

  end_op();
801056ac:	e8 ff d8 ff ff       	call   80102fb0 <end_op>

  return 0;
801056b1:	83 c4 10             	add    $0x10,%esp
801056b4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801056b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b9:	5b                   	pop    %ebx
801056ba:	5e                   	pop    %esi
801056bb:	5f                   	pop    %edi
801056bc:	5d                   	pop    %ebp
801056bd:	c3                   	ret    
801056be:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056c4:	76 94                	jbe    8010565a <sys_unlink+0xba>
801056c6:	bf 20 00 00 00       	mov    $0x20,%edi
801056cb:	eb 0f                	jmp    801056dc <sys_unlink+0x13c>
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
801056d0:	83 c7 10             	add    $0x10,%edi
801056d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801056d6:	0f 83 7e ff ff ff    	jae    8010565a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056dc:	6a 10                	push   $0x10
801056de:	57                   	push   %edi
801056df:	56                   	push   %esi
801056e0:	53                   	push   %ebx
801056e1:	e8 5a c6 ff ff       	call   80101d40 <readi>
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	83 f8 10             	cmp    $0x10,%eax
801056ec:	75 6c                	jne    8010575a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
801056ee:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056f3:	74 db                	je     801056d0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801056f5:	83 ec 0c             	sub    $0xc,%esp
801056f8:	53                   	push   %ebx
801056f9:	e8 f2 c5 ff ff       	call   80101cf0 <iunlockput>
    goto bad;
801056fe:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105701:	83 ec 0c             	sub    $0xc,%esp
80105704:	ff 75 b4             	pushl  -0x4c(%ebp)
80105707:	e8 e4 c5 ff ff       	call   80101cf0 <iunlockput>
  end_op();
8010570c:	e8 9f d8 ff ff       	call   80102fb0 <end_op>
  return -1;
80105711:	83 c4 10             	add    $0x10,%esp
}
80105714:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571c:	5b                   	pop    %ebx
8010571d:	5e                   	pop    %esi
8010571e:	5f                   	pop    %edi
8010571f:	5d                   	pop    %ebp
80105720:	c3                   	ret    
80105721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105728:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010572b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010572e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105733:	50                   	push   %eax
80105734:	e8 77 c2 ff ff       	call   801019b0 <iupdate>
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	e9 4b ff ff ff       	jmp    8010568c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105746:	e9 6b ff ff ff       	jmp    801056b6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010574b:	e8 60 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105755:	e9 5c ff ff ff       	jmp    801056b6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010575a:	83 ec 0c             	sub    $0xc,%esp
8010575d:	68 14 81 10 80       	push   $0x80108114
80105762:	e8 09 ac ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105767:	83 ec 0c             	sub    $0xc,%esp
8010576a:	68 26 81 10 80       	push   $0x80108126
8010576f:	e8 fc ab ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105774:	83 ec 0c             	sub    $0xc,%esp
80105777:	68 02 81 10 80       	push   $0x80108102
8010577c:	e8 ef ab ff ff       	call   80100370 <panic>
80105781:	eb 0d                	jmp    80105790 <sys_open>
80105783:	90                   	nop
80105784:	90                   	nop
80105785:	90                   	nop
80105786:	90                   	nop
80105787:	90                   	nop
80105788:	90                   	nop
80105789:	90                   	nop
8010578a:	90                   	nop
8010578b:	90                   	nop
8010578c:	90                   	nop
8010578d:	90                   	nop
8010578e:	90                   	nop
8010578f:	90                   	nop

80105790 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
80105795:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105796:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105799:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010579c:	50                   	push   %eax
8010579d:	6a 00                	push   $0x0
8010579f:	e8 0c f8 ff ff       	call   80104fb0 <argstr>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	0f 88 9e 00 00 00    	js     8010584d <sys_open+0xbd>
801057af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057b2:	83 ec 08             	sub    $0x8,%esp
801057b5:	50                   	push   %eax
801057b6:	6a 01                	push   $0x1
801057b8:	e8 43 f7 ff ff       	call   80104f00 <argint>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	85 c0                	test   %eax,%eax
801057c2:	0f 88 85 00 00 00    	js     8010584d <sys_open+0xbd>
    return -1;

  begin_op();
801057c8:	e8 73 d7 ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801057cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057d1:	0f 85 89 00 00 00    	jne    80105860 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057d7:	83 ec 0c             	sub    $0xc,%esp
801057da:	ff 75 e0             	pushl  -0x20(%ebp)
801057dd:	e8 ce ca ff ff       	call   801022b0 <namei>
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	85 c0                	test   %eax,%eax
801057e7:	89 c6                	mov    %eax,%esi
801057e9:	0f 84 8e 00 00 00    	je     8010587d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801057ef:	83 ec 0c             	sub    $0xc,%esp
801057f2:	50                   	push   %eax
801057f3:	e8 68 c2 ff ff       	call   80101a60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105800:	0f 84 d2 00 00 00    	je     801058d8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105806:	e8 65 b9 ff ff       	call   80101170 <filealloc>
8010580b:	85 c0                	test   %eax,%eax
8010580d:	89 c7                	mov    %eax,%edi
8010580f:	74 2b                	je     8010583c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105811:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105813:	e8 a8 e3 ff ff       	call   80103bc0 <myproc>
80105818:	90                   	nop
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105820:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105824:	85 d2                	test   %edx,%edx
80105826:	74 68                	je     80105890 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105828:	83 c3 01             	add    $0x1,%ebx
8010582b:	83 fb 10             	cmp    $0x10,%ebx
8010582e:	75 f0                	jne    80105820 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	57                   	push   %edi
80105834:	e8 f7 b9 ff ff       	call   80101230 <fileclose>
80105839:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	56                   	push   %esi
80105840:	e8 ab c4 ff ff       	call   80101cf0 <iunlockput>
    end_op();
80105845:	e8 66 d7 ff ff       	call   80102fb0 <end_op>
    return -1;
8010584a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010584d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105855:	5b                   	pop    %ebx
80105856:	5e                   	pop    %esi
80105857:	5f                   	pop    %edi
80105858:	5d                   	pop    %ebp
80105859:	c3                   	ret    
8010585a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105866:	31 c9                	xor    %ecx,%ecx
80105868:	6a 00                	push   $0x0
8010586a:	ba 02 00 00 00       	mov    $0x2,%edx
8010586f:	e8 dc f7 ff ff       	call   80105050 <create>
    if(ip == 0){
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105879:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010587b:	75 89                	jne    80105806 <sys_open+0x76>
      end_op();
8010587d:	e8 2e d7 ff ff       	call   80102fb0 <end_op>
      return -1;
80105882:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105887:	eb 43                	jmp    801058cc <sys_open+0x13c>
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105890:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105893:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105897:	56                   	push   %esi
80105898:	e8 a3 c2 ff ff       	call   80101b40 <iunlock>
  end_op();
8010589d:	e8 0e d7 ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
801058a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058ab:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801058ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801058b1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801058b8:	89 d0                	mov    %edx,%eax
801058ba:	83 e0 01             	and    $0x1,%eax
801058bd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058c0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058c3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058c6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801058ca:	89 d8                	mov    %ebx,%eax
}
801058cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058cf:	5b                   	pop    %ebx
801058d0:	5e                   	pop    %esi
801058d1:	5f                   	pop    %edi
801058d2:	5d                   	pop    %ebp
801058d3:	c3                   	ret    
801058d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801058d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058db:	85 c9                	test   %ecx,%ecx
801058dd:	0f 84 23 ff ff ff    	je     80105806 <sys_open+0x76>
801058e3:	e9 54 ff ff ff       	jmp    8010583c <sys_open+0xac>
801058e8:	90                   	nop
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058f6:	e8 45 d6 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fe:	83 ec 08             	sub    $0x8,%esp
80105901:	50                   	push   %eax
80105902:	6a 00                	push   $0x0
80105904:	e8 a7 f6 ff ff       	call   80104fb0 <argstr>
80105909:	83 c4 10             	add    $0x10,%esp
8010590c:	85 c0                	test   %eax,%eax
8010590e:	78 30                	js     80105940 <sys_mkdir+0x50>
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105916:	31 c9                	xor    %ecx,%ecx
80105918:	6a 00                	push   $0x0
8010591a:	ba 01 00 00 00       	mov    $0x1,%edx
8010591f:	e8 2c f7 ff ff       	call   80105050 <create>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	74 15                	je     80105940 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010592b:	83 ec 0c             	sub    $0xc,%esp
8010592e:	50                   	push   %eax
8010592f:	e8 bc c3 ff ff       	call   80101cf0 <iunlockput>
  end_op();
80105934:	e8 77 d6 ff ff       	call   80102fb0 <end_op>
  return 0;
80105939:	83 c4 10             	add    $0x10,%esp
8010593c:	31 c0                	xor    %eax,%eax
}
8010593e:	c9                   	leave  
8010593f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105940:	e8 6b d6 ff ff       	call   80102fb0 <end_op>
    return -1;
80105945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010594a:	c9                   	leave  
8010594b:	c3                   	ret    
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_mknod>:

int
sys_mknod(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105956:	e8 e5 d5 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010595b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010595e:	83 ec 08             	sub    $0x8,%esp
80105961:	50                   	push   %eax
80105962:	6a 00                	push   $0x0
80105964:	e8 47 f6 ff ff       	call   80104fb0 <argstr>
80105969:	83 c4 10             	add    $0x10,%esp
8010596c:	85 c0                	test   %eax,%eax
8010596e:	78 60                	js     801059d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105970:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105973:	83 ec 08             	sub    $0x8,%esp
80105976:	50                   	push   %eax
80105977:	6a 01                	push   $0x1
80105979:	e8 82 f5 ff ff       	call   80104f00 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	85 c0                	test   %eax,%eax
80105983:	78 4b                	js     801059d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105985:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105988:	83 ec 08             	sub    $0x8,%esp
8010598b:	50                   	push   %eax
8010598c:	6a 02                	push   $0x2
8010598e:	e8 6d f5 ff ff       	call   80104f00 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105993:	83 c4 10             	add    $0x10,%esp
80105996:	85 c0                	test   %eax,%eax
80105998:	78 36                	js     801059d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010599a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010599e:	83 ec 0c             	sub    $0xc,%esp
801059a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801059a5:	ba 03 00 00 00       	mov    $0x3,%edx
801059aa:	50                   	push   %eax
801059ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059ae:	e8 9d f6 ff ff       	call   80105050 <create>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	85 c0                	test   %eax,%eax
801059b8:	74 16                	je     801059d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801059ba:	83 ec 0c             	sub    $0xc,%esp
801059bd:	50                   	push   %eax
801059be:	e8 2d c3 ff ff       	call   80101cf0 <iunlockput>
  end_op();
801059c3:	e8 e8 d5 ff ff       	call   80102fb0 <end_op>
  return 0;
801059c8:	83 c4 10             	add    $0x10,%esp
801059cb:	31 c0                	xor    %eax,%eax
}
801059cd:	c9                   	leave  
801059ce:	c3                   	ret    
801059cf:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801059d0:	e8 db d5 ff ff       	call   80102fb0 <end_op>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801059da:	c9                   	leave  
801059db:	c3                   	ret    
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_chdir>:

int
sys_chdir(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	56                   	push   %esi
801059e4:	53                   	push   %ebx
801059e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059e8:	e8 d3 e1 ff ff       	call   80103bc0 <myproc>
801059ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059ef:	e8 4c d5 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f7:	83 ec 08             	sub    $0x8,%esp
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 ae f5 ff ff       	call   80104fb0 <argstr>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 77                	js     80105a80 <sys_chdir+0xa0>
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a0f:	e8 9c c8 ff ff       	call   801022b0 <namei>
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	85 c0                	test   %eax,%eax
80105a19:	89 c3                	mov    %eax,%ebx
80105a1b:	74 63                	je     80105a80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
80105a20:	50                   	push   %eax
80105a21:	e8 3a c0 ff ff       	call   80101a60 <ilock>
  if(ip->type != T_DIR){
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a2e:	75 30                	jne    80105a60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	53                   	push   %ebx
80105a34:	e8 07 c1 ff ff       	call   80101b40 <iunlock>
  iput(curproc->cwd);
80105a39:	58                   	pop    %eax
80105a3a:	ff 76 68             	pushl  0x68(%esi)
80105a3d:	e8 4e c1 ff ff       	call   80101b90 <iput>
  end_op();
80105a42:	e8 69 d5 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105a47:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	31 c0                	xor    %eax,%eax
}
80105a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a52:	5b                   	pop    %ebx
80105a53:	5e                   	pop    %esi
80105a54:	5d                   	pop    %ebp
80105a55:	c3                   	ret    
80105a56:	8d 76 00             	lea    0x0(%esi),%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	53                   	push   %ebx
80105a64:	e8 87 c2 ff ff       	call   80101cf0 <iunlockput>
    end_op();
80105a69:	e8 42 d5 ff ff       	call   80102fb0 <end_op>
    return -1;
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a76:	eb d7                	jmp    80105a4f <sys_chdir+0x6f>
80105a78:	90                   	nop
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105a80:	e8 2b d5 ff ff       	call   80102fb0 <end_op>
    return -1;
80105a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8a:	eb c3                	jmp    80105a4f <sys_chdir+0x6f>
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
80105a95:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a96:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105a9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105aa2:	50                   	push   %eax
80105aa3:	6a 00                	push   $0x0
80105aa5:	e8 06 f5 ff ff       	call   80104fb0 <argstr>
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	85 c0                	test   %eax,%eax
80105aaf:	78 7f                	js     80105b30 <sys_exec+0xa0>
80105ab1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105ab7:	83 ec 08             	sub    $0x8,%esp
80105aba:	50                   	push   %eax
80105abb:	6a 01                	push   $0x1
80105abd:	e8 3e f4 ff ff       	call   80104f00 <argint>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	78 67                	js     80105b30 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ac9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105acf:	83 ec 04             	sub    $0x4,%esp
80105ad2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105ad8:	68 80 00 00 00       	push   $0x80
80105add:	6a 00                	push   $0x0
80105adf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ae5:	50                   	push   %eax
80105ae6:	31 db                	xor    %ebx,%ebx
80105ae8:	e8 03 f1 ff ff       	call   80104bf0 <memset>
80105aed:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105af0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105af6:	83 ec 08             	sub    $0x8,%esp
80105af9:	57                   	push   %edi
80105afa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105afd:	50                   	push   %eax
80105afe:	e8 5d f3 ff ff       	call   80104e60 <fetchint>
80105b03:	83 c4 10             	add    $0x10,%esp
80105b06:	85 c0                	test   %eax,%eax
80105b08:	78 26                	js     80105b30 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105b0a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b10:	85 c0                	test   %eax,%eax
80105b12:	74 2c                	je     80105b40 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b14:	83 ec 08             	sub    $0x8,%esp
80105b17:	56                   	push   %esi
80105b18:	50                   	push   %eax
80105b19:	e8 82 f3 ff ff       	call   80104ea0 <fetchstr>
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	85 c0                	test   %eax,%eax
80105b23:	78 0b                	js     80105b30 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105b25:	83 c3 01             	add    $0x1,%ebx
80105b28:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105b2b:	83 fb 20             	cmp    $0x20,%ebx
80105b2e:	75 c0                	jne    80105af0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105b38:	5b                   	pop    %ebx
80105b39:	5e                   	pop    %esi
80105b3a:	5f                   	pop    %edi
80105b3b:	5d                   	pop    %ebp
80105b3c:	c3                   	ret    
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105b40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b46:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105b49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b50:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105b54:	50                   	push   %eax
80105b55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b5b:	e8 90 ae ff ff       	call   801009f0 <exec>
80105b60:	83 c4 10             	add    $0x10,%esp
}
80105b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5f                   	pop    %edi
80105b69:	5d                   	pop    %ebp
80105b6a:	c3                   	ret    
80105b6b:	90                   	nop
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_exec2>:


int
sys_exec2(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b76:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
80105b7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b82:	50                   	push   %eax
80105b83:	6a 00                	push   $0x0
80105b85:	e8 26 f4 ff ff       	call   80104fb0 <argstr>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	78 7f                	js     80105c10 <sys_exec2+0xa0>
80105b91:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105b97:	83 ec 08             	sub    $0x8,%esp
80105b9a:	50                   	push   %eax
80105b9b:	6a 01                	push   $0x1
80105b9d:	e8 5e f3 ff ff       	call   80104f00 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 67                	js     80105c10 <sys_exec2+0xa0>
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
80105ba9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105baf:	83 ec 04             	sub    $0x4,%esp
80105bb2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105bb8:	68 80 00 00 00       	push   $0x80
80105bbd:	6a 00                	push   $0x0
80105bbf:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105bc5:	50                   	push   %eax
80105bc6:	31 db                	xor    %ebx,%ebx
80105bc8:	e8 23 f0 ff ff       	call   80104bf0 <memset>
80105bcd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bd0:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105bd6:	83 ec 08             	sub    $0x8,%esp
80105bd9:	57                   	push   %edi
80105bda:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105bdd:	50                   	push   %eax
80105bde:	e8 7d f2 ff ff       	call   80104e60 <fetchint>
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	78 26                	js     80105c10 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
80105bea:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	74 2c                	je     80105c20 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bf4:	83 ec 08             	sub    $0x8,%esp
80105bf7:	56                   	push   %esi
80105bf8:	50                   	push   %eax
80105bf9:	e8 a2 f2 ff ff       	call   80104ea0 <fetchstr>
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	78 0b                	js     80105c10 <sys_exec2+0xa0>
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105c05:	83 c3 01             	add    $0x1,%ebx
80105c08:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105c0b:	83 fb 20             	cmp    $0x20,%ebx
80105c0e:	75 c0                	jne    80105bd0 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105c18:	5b                   	pop    %ebx
80105c19:	5e                   	pop    %esi
80105c1a:	5f                   	pop    %edi
80105c1b:	5d                   	pop    %ebp
80105c1c:	c3                   	ret    
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105c20:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105c26:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105c29:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c30:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105c34:	50                   	push   %eax
80105c35:	6a 02                	push   $0x2
80105c37:	e8 c4 f2 ff ff       	call   80104f00 <argint>
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	85 c0                	test   %eax,%eax
80105c41:	78 cd                	js     80105c10 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105c43:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c49:	83 ec 04             	sub    $0x4,%esp
80105c4c:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105c52:	50                   	push   %eax
80105c53:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105c59:	e8 12 b1 ff ff       	call   80100d70 <exec2>
80105c5e:	83 c4 10             	add    $0x10,%esp
}
80105c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c64:	5b                   	pop    %ebx
80105c65:	5e                   	pop    %esi
80105c66:	5f                   	pop    %edi
80105c67:	5d                   	pop    %ebp
80105c68:	c3                   	ret    
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_pipe>:

int
sys_pipe(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c76:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105c79:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c7c:	6a 08                	push   $0x8
80105c7e:	50                   	push   %eax
80105c7f:	6a 00                	push   $0x0
80105c81:	e8 ca f2 ff ff       	call   80104f50 <argptr>
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	78 4a                	js     80105cd7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c8d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	50                   	push   %eax
80105c94:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c97:	50                   	push   %eax
80105c98:	e8 43 d9 ff ff       	call   801035e0 <pipealloc>
80105c9d:	83 c4 10             	add    $0x10,%esp
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	78 33                	js     80105cd7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ca4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ca6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105ca9:	e8 12 df ff ff       	call   80103bc0 <myproc>
80105cae:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105cb0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cb4:	85 f6                	test   %esi,%esi
80105cb6:	74 30                	je     80105ce8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105cb8:	83 c3 01             	add    $0x1,%ebx
80105cbb:	83 fb 10             	cmp    $0x10,%ebx
80105cbe:	75 f0                	jne    80105cb0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	ff 75 e0             	pushl  -0x20(%ebp)
80105cc6:	e8 65 b5 ff ff       	call   80101230 <fileclose>
    fileclose(wf);
80105ccb:	58                   	pop    %eax
80105ccc:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ccf:	e8 5c b5 ff ff       	call   80101230 <fileclose>
    return -1;
80105cd4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105cda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105cdf:	5b                   	pop    %ebx
80105ce0:	5e                   	pop    %esi
80105ce1:	5f                   	pop    %edi
80105ce2:	5d                   	pop    %ebp
80105ce3:	c3                   	ret    
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105ce8:	8d 73 08             	lea    0x8(%ebx),%esi
80105ceb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105cf2:	e8 c9 de ff ff       	call   80103bc0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105cf7:	31 d2                	xor    %edx,%edx
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d00:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d04:	85 c9                	test   %ecx,%ecx
80105d06:	74 18                	je     80105d20 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105d08:	83 c2 01             	add    $0x1,%edx
80105d0b:	83 fa 10             	cmp    $0x10,%edx
80105d0e:	75 f0                	jne    80105d00 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105d10:	e8 ab de ff ff       	call   80103bc0 <myproc>
80105d15:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d1c:	00 
80105d1d:	eb a1                	jmp    80105cc0 <sys_pipe+0x50>
80105d1f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105d20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105d32:	31 c0                	xor    %eax,%eax
}
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	66 90                	xchg   %ax,%ax
80105d3b:	66 90                	xchg   %ax,%ax
80105d3d:	66 90                	xchg   %ax,%ax
80105d3f:	90                   	nop

80105d40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d43:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105d44:	e9 27 e0 ff ff       	jmp    80103d70 <fork>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exit>:
}

int
sys_exit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d56:	e8 35 e3 ff ff       	call   80104090 <exit>
  return 0;  // not reached
}
80105d5b:	31 c0                	xor    %eax,%eax
80105d5d:	c9                   	leave  
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <sys_wait>:

int
sys_wait(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d63:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105d64:	e9 47 e8 ff ff       	jmp    801045b0 <wait>
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_kill>:
}

int
sys_kill(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 7f f1 ff ff       	call   80104f00 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 18                	js     80105da0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 7d e9 ff ff       	call   80104710 <kill>
80105d93:	83 c4 10             	add    $0x10,%esp
}
80105d96:	c9                   	leave  
80105d97:	c3                   	ret    
80105d98:	90                   	nop
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <sys_getpid>:

int
sys_getpid(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105db6:	e8 05 de ff ff       	call   80103bc0 <myproc>
80105dbb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dbe:	c9                   	leave  
80105dbf:	c3                   	ret    

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 2e f1 ff ff       	call   80104f00 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	78 27                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dd9:	e8 e2 dd ff ff       	call   80103bc0 <myproc>
  if(growproc(n) < 0)
80105dde:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105de1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105de3:	ff 75 f4             	pushl  -0xc(%ebp)
80105de6:	e8 f5 de ff ff       	call   80103ce0 <growproc>
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	85 c0                	test   %eax,%eax
80105df0:	78 0e                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
80105df2:	89 d8                	mov    %ebx,%eax
}
80105df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e05:	eb ed                	jmp    80105df4 <sys_sbrk+0x34>
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e10 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
80105e14:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105e17:	e8 a4 dd ff ff       	call   80103bc0 <myproc>
80105e1c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105e23:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105e26:	e8 95 dd ff ff       	call   80103bc0 <myproc>
80105e2b:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105e32:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e38:	83 ec 08             	sub    $0x8,%esp
80105e3b:	50                   	push   %eax
80105e3c:	6a 00                	push   $0x0
80105e3e:	e8 bd f0 ff ff       	call   80104f00 <argint>
80105e43:	83 c4 10             	add    $0x10,%esp
80105e46:	85 c0                	test   %eax,%eax
80105e48:	0f 88 89 00 00 00    	js     80105ed7 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105e4e:	83 ec 0c             	sub    $0xc,%esp
80105e51:	68 60 64 11 80       	push   $0x80116460
80105e56:	e8 95 ec ff ff       	call   80104af0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e5e:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105e61:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105e67:	85 d2                	test   %edx,%edx
80105e69:	75 26                	jne    80105e91 <sys_sleep+0x81>
80105e6b:	eb 53                	jmp    80105ec0 <sys_sleep+0xb0>
80105e6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	68 60 64 11 80       	push   $0x80116460
80105e78:	68 a0 6c 11 80       	push   $0x80116ca0
80105e7d:	e8 6e e6 ff ff       	call   801044f0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e82:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80105e87:	83 c4 10             	add    $0x10,%esp
80105e8a:	29 d8                	sub    %ebx,%eax
80105e8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e8f:	73 2f                	jae    80105ec0 <sys_sleep+0xb0>
    if(myproc()->killed){
80105e91:	e8 2a dd ff ff       	call   80103bc0 <myproc>
80105e96:	8b 40 24             	mov    0x24(%eax),%eax
80105e99:	85 c0                	test   %eax,%eax
80105e9b:	74 d3                	je     80105e70 <sys_sleep+0x60>
      release(&tickslock);
80105e9d:	83 ec 0c             	sub    $0xc,%esp
80105ea0:	68 60 64 11 80       	push   $0x80116460
80105ea5:	e8 f6 ec ff ff       	call   80104ba0 <release>
      return -1;
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	68 60 64 11 80       	push   $0x80116460
80105ec8:	e8 d3 ec ff ff       	call   80104ba0 <release>
  return 0;
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	31 c0                	xor    %eax,%eax
}
80105ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed5:	c9                   	leave  
80105ed6:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80105ed7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105edc:	eb d4                	jmp    80105eb2 <sys_sleep+0xa2>
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	53                   	push   %ebx
80105ee4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ee7:	68 60 64 11 80       	push   $0x80116460
80105eec:	e8 ff eb ff ff       	call   80104af0 <acquire>
  xticks = ticks;
80105ef1:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80105ef7:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
80105efe:	e8 9d ec ff ff       	call   80104ba0 <release>
  return xticks;
}
80105f03:	89 d8                	mov    %ebx,%eax
80105f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f08:	c9                   	leave  
80105f09:	c3                   	ret    
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <sys_yield>:

void 
sys_yield()
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80105f16:	e8 a5 dc ff ff       	call   80103bc0 <myproc>
80105f1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105f22:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
80105f25:	e8 96 dc ff ff       	call   80103bc0 <myproc>
80105f2a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105f31:	00 00 00 
  yield();
}
80105f34:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
80105f35:	e9 86 e2 ff ff       	jmp    801041c0 <yield>
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f40 <sys_getlev>:
}

int             
sys_getlev(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
  return getlev();
}
80105f43:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
80105f44:	e9 c7 e2 ff ff       	jmp    80104210 <getlev>
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f50 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105f56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f59:	50                   	push   %eax
80105f5a:	6a 00                	push   $0x0
80105f5c:	e8 9f ef ff ff       	call   80104f00 <argint>
80105f61:	83 c4 10             	add    $0x10,%esp
80105f64:	85 c0                	test   %eax,%eax
80105f66:	78 28                	js     80105f90 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
80105f68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f6b:	83 ec 08             	sub    $0x8,%esp
80105f6e:	50                   	push   %eax
80105f6f:	6a 01                	push   $0x1
80105f71:	e8 8a ef ff ff       	call   80104f00 <argint>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	78 23                	js     80105fa0 <sys_setpriority+0x50>
	return setpriority(pid,priority);
80105f7d:	83 ec 08             	sub    $0x8,%esp
80105f80:	ff 75 f4             	pushl  -0xc(%ebp)
80105f83:	ff 75 f0             	pushl  -0x10(%ebp)
80105f86:	e8 a5 e4 ff ff       	call   80104430 <setpriority>
80105f8b:	83 c4 10             	add    $0x10,%esp
}
80105f8e:	c9                   	leave  
80105f8f:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
80105fa0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
80105fa5:	c9                   	leave  
80105fa6:	c3                   	ret    
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fb0 <sys_getadmin>:


int
sys_getadmin(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fb9:	50                   	push   %eax
80105fba:	6a 00                	push   $0x0
80105fbc:	e8 ef ef ff ff       	call   80104fb0 <argstr>
80105fc1:	83 c4 10             	add    $0x10,%esp
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	78 18                	js     80105fe0 <sys_getadmin+0x30>
  return getadmin(student_number);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	ff 75 f4             	pushl  -0xc(%ebp)
80105fce:	e8 6d e2 ff ff       	call   80104240 <getadmin>
80105fd3:	83 c4 10             	add    $0x10,%esp
}
80105fd6:	c9                   	leave  
80105fd7:	c3                   	ret    
80105fd8:	90                   	nop
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ff0 <sys_setmemorylimit>:

int
sys_setmemorylimit(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	83 ec 20             	sub    $0x20,%esp
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80105ff6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ff9:	50                   	push   %eax
80105ffa:	6a 00                	push   $0x0
80105ffc:	e8 ff ee ff ff       	call   80104f00 <argint>
80106001:	83 c4 10             	add    $0x10,%esp
80106004:	85 c0                	test   %eax,%eax
80106006:	78 28                	js     80106030 <sys_setmemorylimit+0x40>
80106008:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600b:	83 ec 08             	sub    $0x8,%esp
8010600e:	50                   	push   %eax
8010600f:	6a 01                	push   $0x1
80106011:	e8 ea ee ff ff       	call   80104f00 <argint>
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	85 c0                	test   %eax,%eax
8010601b:	78 13                	js     80106030 <sys_setmemorylimit+0x40>
  return setmemorylimit(pid,limit);
8010601d:	83 ec 08             	sub    $0x8,%esp
80106020:	ff 75 f4             	pushl  -0xc(%ebp)
80106023:	ff 75 f0             	pushl  -0x10(%ebp)
80106026:	e8 95 e2 ff ff       	call   801042c0 <setmemorylimit>
8010602b:	83 c4 10             	add    $0x10,%esp
}
8010602e:	c9                   	leave  
8010602f:	c3                   	ret    

int
sys_setmemorylimit(void)
{
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return setmemorylimit(pid,limit);
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_list>:

int
sys_list(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
  return list();
80106043:	5d                   	pop    %ebp
}

int
sys_list(void)
{
  return list();
80106044:	e9 17 e3 ff ff       	jmp    80104360 <list>

80106049 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106049:	1e                   	push   %ds
  pushl %es
8010604a:	06                   	push   %es
  pushl %fs
8010604b:	0f a0                	push   %fs
  pushl %gs
8010604d:	0f a8                	push   %gs
  pushal
8010604f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106050:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106054:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106056:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106058:	54                   	push   %esp
  call trap
80106059:	e8 e2 00 00 00       	call   80106140 <trap>
  addl $4, %esp
8010605e:	83 c4 04             	add    $0x4,%esp

80106061 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106061:	61                   	popa   
  popl %gs
80106062:	0f a9                	pop    %gs
  popl %fs
80106064:	0f a1                	pop    %fs
  popl %es
80106066:	07                   	pop    %es
  popl %ds
80106067:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106068:	83 c4 08             	add    $0x8,%esp
  iret
8010606b:	cf                   	iret   
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106070:	31 c0                	xor    %eax,%eax
80106072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106078:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010607f:	b9 08 00 00 00       	mov    $0x8,%ecx
80106084:	c6 04 c5 a4 64 11 80 	movb   $0x0,-0x7fee9b5c(,%eax,8)
8010608b:	00 
8010608c:	66 89 0c c5 a2 64 11 	mov    %cx,-0x7fee9b5e(,%eax,8)
80106093:	80 
80106094:	c6 04 c5 a5 64 11 80 	movb   $0x8e,-0x7fee9b5b(,%eax,8)
8010609b:	8e 
8010609c:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
801060a3:	80 
801060a4:	c1 ea 10             	shr    $0x10,%edx
801060a7:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
801060ae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801060af:	83 c0 01             	add    $0x1,%eax
801060b2:	3d 00 01 00 00       	cmp    $0x100,%eax
801060b7:	75 bf                	jne    80106078 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060b9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060ba:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801060bf:	89 e5                	mov    %esp,%ebp
801060c1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060c4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801060c9:	68 35 81 10 80       	push   $0x80108135
801060ce:	68 60 64 11 80       	push   $0x80116460
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060d3:	66 89 15 a2 66 11 80 	mov    %dx,0x801166a2
801060da:	c6 05 a4 66 11 80 00 	movb   $0x0,0x801166a4
801060e1:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
801060e7:	c1 e8 10             	shr    $0x10,%eax
801060ea:	c6 05 a5 66 11 80 ef 	movb   $0xef,0x801166a5
801060f1:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6

  initlock(&tickslock, "time");
801060f7:	e8 94 e8 ff ff       	call   80104990 <initlock>
}
801060fc:	83 c4 10             	add    $0x10,%esp
801060ff:	c9                   	leave  
80106100:	c3                   	ret    
80106101:	eb 0d                	jmp    80106110 <idtinit>
80106103:	90                   	nop
80106104:	90                   	nop
80106105:	90                   	nop
80106106:	90                   	nop
80106107:	90                   	nop
80106108:	90                   	nop
80106109:	90                   	nop
8010610a:	90                   	nop
8010610b:	90                   	nop
8010610c:	90                   	nop
8010610d:	90                   	nop
8010610e:	90                   	nop
8010610f:	90                   	nop

80106110 <idtinit>:

void
idtinit(void)
{
80106110:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106111:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106116:	89 e5                	mov    %esp,%ebp
80106118:	83 ec 10             	sub    $0x10,%esp
8010611b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010611f:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
80106124:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106128:	c1 e8 10             	shr    $0x10,%eax
8010612b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010612f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106132:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106135:	c9                   	leave  
80106136:	c3                   	ret    
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106140 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	56                   	push   %esi
80106145:	53                   	push   %ebx
80106146:	83 ec 1c             	sub    $0x1c,%esp
80106149:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010614c:	8b 47 30             	mov    0x30(%edi),%eax
8010614f:	83 f8 40             	cmp    $0x40,%eax
80106152:	0f 84 88 01 00 00    	je     801062e0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106158:	83 e8 20             	sub    $0x20,%eax
8010615b:	83 f8 1f             	cmp    $0x1f,%eax
8010615e:	77 10                	ja     80106170 <trap+0x30>
80106160:	ff 24 85 dc 81 10 80 	jmp    *-0x7fef7e24(,%eax,4)
80106167:	89 f6                	mov    %esi,%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106170:	e8 4b da ff ff       	call   80103bc0 <myproc>
80106175:	85 c0                	test   %eax,%eax
80106177:	0f 84 d7 01 00 00    	je     80106354 <trap+0x214>
8010617d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106181:	0f 84 cd 01 00 00    	je     80106354 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106187:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010618a:	8b 57 38             	mov    0x38(%edi),%edx
8010618d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106190:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106193:	e8 08 da ff ff       	call   80103ba0 <cpuid>
80106198:	8b 77 34             	mov    0x34(%edi),%esi
8010619b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010619e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061a1:	e8 1a da ff ff       	call   80103bc0 <myproc>
801061a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061a9:	e8 12 da ff ff       	call   80103bc0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061ae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061b4:	51                   	push   %ecx
801061b5:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061b9:	ff 75 e4             	pushl  -0x1c(%ebp)
801061bc:	56                   	push   %esi
801061bd:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801061be:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061c1:	52                   	push   %edx
801061c2:	ff 70 10             	pushl  0x10(%eax)
801061c5:	68 98 81 10 80       	push   $0x80108198
801061ca:	e8 91 a4 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801061cf:	83 c4 20             	add    $0x20,%esp
801061d2:	e8 e9 d9 ff ff       	call   80103bc0 <myproc>
801061d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801061de:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061e0:	e8 db d9 ff ff       	call   80103bc0 <myproc>
801061e5:	85 c0                	test   %eax,%eax
801061e7:	74 0c                	je     801061f5 <trap+0xb5>
801061e9:	e8 d2 d9 ff ff       	call   80103bc0 <myproc>
801061ee:	8b 50 24             	mov    0x24(%eax),%edx
801061f1:	85 d2                	test   %edx,%edx
801061f3:	75 4b                	jne    80106240 <trap+0x100>
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
801061f5:	e8 c6 d9 ff ff       	call   80103bc0 <myproc>
801061fa:	85 c0                	test   %eax,%eax
801061fc:	74 0b                	je     80106209 <trap+0xc9>
801061fe:	e8 bd d9 ff ff       	call   80103bc0 <myproc>
80106203:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106207:	74 4f                	je     80106258 <trap+0x118>
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106209:	e8 b2 d9 ff ff       	call   80103bc0 <myproc>
8010620e:	85 c0                	test   %eax,%eax
80106210:	74 1d                	je     8010622f <trap+0xef>
80106212:	e8 a9 d9 ff ff       	call   80103bc0 <myproc>
80106217:	8b 40 24             	mov    0x24(%eax),%eax
8010621a:	85 c0                	test   %eax,%eax
8010621c:	74 11                	je     8010622f <trap+0xef>
8010621e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106222:	83 e0 03             	and    $0x3,%eax
80106225:	66 83 f8 03          	cmp    $0x3,%ax
80106229:	0f 84 da 00 00 00    	je     80106309 <trap+0x1c9>
    exit();
}
8010622f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106232:	5b                   	pop    %ebx
80106233:	5e                   	pop    %esi
80106234:	5f                   	pop    %edi
80106235:	5d                   	pop    %ebp
80106236:	c3                   	ret    
80106237:	89 f6                	mov    %esi,%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106240:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106244:	83 e0 03             	and    $0x3,%eax
80106247:	66 83 f8 03          	cmp    $0x3,%ax
8010624b:	75 a8                	jne    801061f5 <trap+0xb5>
    exit();
8010624d:	e8 3e de ff ff       	call   80104090 <exit>
80106252:	eb a1                	jmp    801061f5 <trap+0xb5>
80106254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
80106258:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010625c:	75 ab                	jne    80106209 <trap+0xc9>
8010625e:	e8 5d df ff ff       	call   801041c0 <yield>
80106263:	eb a4                	jmp    80106209 <trap+0xc9>
80106265:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106268:	e8 33 d9 ff ff       	call   80103ba0 <cpuid>
8010626d:	85 c0                	test   %eax,%eax
8010626f:	0f 84 ab 00 00 00    	je     80106320 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106275:	e8 86 c8 ff ff       	call   80102b00 <lapiceoi>
    break;
8010627a:	e9 61 ff ff ff       	jmp    801061e0 <trap+0xa0>
8010627f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106280:	e8 3b c7 ff ff       	call   801029c0 <kbdintr>
    lapiceoi();
80106285:	e8 76 c8 ff ff       	call   80102b00 <lapiceoi>
    break;
8010628a:	e9 51 ff ff ff       	jmp    801061e0 <trap+0xa0>
8010628f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106290:	e8 5b 02 00 00       	call   801064f0 <uartintr>
    lapiceoi();
80106295:	e8 66 c8 ff ff       	call   80102b00 <lapiceoi>
    break;
8010629a:	e9 41 ff ff ff       	jmp    801061e0 <trap+0xa0>
8010629f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062a0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801062a4:	8b 77 38             	mov    0x38(%edi),%esi
801062a7:	e8 f4 d8 ff ff       	call   80103ba0 <cpuid>
801062ac:	56                   	push   %esi
801062ad:	53                   	push   %ebx
801062ae:	50                   	push   %eax
801062af:	68 40 81 10 80       	push   $0x80108140
801062b4:	e8 a7 a3 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801062b9:	e8 42 c8 ff ff       	call   80102b00 <lapiceoi>
    break;
801062be:	83 c4 10             	add    $0x10,%esp
801062c1:	e9 1a ff ff ff       	jmp    801061e0 <trap+0xa0>
801062c6:	8d 76 00             	lea    0x0(%esi),%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801062d0:	e8 6b c1 ff ff       	call   80102440 <ideintr>
801062d5:	eb 9e                	jmp    80106275 <trap+0x135>
801062d7:	89 f6                	mov    %esi,%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801062e0:	e8 db d8 ff ff       	call   80103bc0 <myproc>
801062e5:	8b 58 24             	mov    0x24(%eax),%ebx
801062e8:	85 db                	test   %ebx,%ebx
801062ea:	75 2c                	jne    80106318 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
801062ec:	e8 cf d8 ff ff       	call   80103bc0 <myproc>
801062f1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801062f4:	e8 f7 ec ff ff       	call   80104ff0 <syscall>
    if(myproc()->killed)
801062f9:	e8 c2 d8 ff ff       	call   80103bc0 <myproc>
801062fe:	8b 48 24             	mov    0x24(%eax),%ecx
80106301:	85 c9                	test   %ecx,%ecx
80106303:	0f 84 26 ff ff ff    	je     8010622f <trap+0xef>
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106309:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010630c:	5b                   	pop    %ebx
8010630d:	5e                   	pop    %esi
8010630e:	5f                   	pop    %edi
8010630f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106310:	e9 7b dd ff ff       	jmp    80104090 <exit>
80106315:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106318:	e8 73 dd ff ff       	call   80104090 <exit>
8010631d:	eb cd                	jmp    801062ec <trap+0x1ac>
8010631f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106320:	83 ec 0c             	sub    $0xc,%esp
80106323:	68 60 64 11 80       	push   $0x80116460
80106328:	e8 c3 e7 ff ff       	call   80104af0 <acquire>
      ticks++;
      wakeup(&ticks);
8010632d:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106334:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      wakeup(&ticks);
8010633b:	e8 70 e3 ff ff       	call   801046b0 <wakeup>
      release(&tickslock);
80106340:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
80106347:	e8 54 e8 ff ff       	call   80104ba0 <release>
8010634c:	83 c4 10             	add    $0x10,%esp
8010634f:	e9 21 ff ff ff       	jmp    80106275 <trap+0x135>
80106354:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106357:	8b 5f 38             	mov    0x38(%edi),%ebx
8010635a:	e8 41 d8 ff ff       	call   80103ba0 <cpuid>
8010635f:	83 ec 0c             	sub    $0xc,%esp
80106362:	56                   	push   %esi
80106363:	53                   	push   %ebx
80106364:	50                   	push   %eax
80106365:	ff 77 30             	pushl  0x30(%edi)
80106368:	68 64 81 10 80       	push   $0x80108164
8010636d:	e8 ee a2 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106372:	83 c4 14             	add    $0x14,%esp
80106375:	68 3a 81 10 80       	push   $0x8010813a
8010637a:	e8 f1 9f ff ff       	call   80100370 <panic>
8010637f:	90                   	nop

80106380 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106380:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106385:	55                   	push   %ebp
80106386:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106388:	85 c0                	test   %eax,%eax
8010638a:	74 1c                	je     801063a8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010638c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106391:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106392:	a8 01                	test   $0x1,%al
80106394:	74 12                	je     801063a8 <uartgetc+0x28>
80106396:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010639b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010639c:	0f b6 c0             	movzbl %al,%eax
}
8010639f:	5d                   	pop    %ebp
801063a0:	c3                   	ret    
801063a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801063a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801063ad:	5d                   	pop    %ebp
801063ae:	c3                   	ret    
801063af:	90                   	nop

801063b0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	57                   	push   %edi
801063b4:	56                   	push   %esi
801063b5:	53                   	push   %ebx
801063b6:	89 c7                	mov    %eax,%edi
801063b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801063bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063c2:	83 ec 0c             	sub    $0xc,%esp
801063c5:	eb 1b                	jmp    801063e2 <uartputc.part.0+0x32>
801063c7:	89 f6                	mov    %esi,%esi
801063c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	6a 0a                	push   $0xa
801063d5:	e8 46 c7 ff ff       	call   80102b20 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	83 eb 01             	sub    $0x1,%ebx
801063e0:	74 07                	je     801063e9 <uartputc.part.0+0x39>
801063e2:	89 f2                	mov    %esi,%edx
801063e4:	ec                   	in     (%dx),%al
801063e5:	a8 20                	test   $0x20,%al
801063e7:	74 e7                	je     801063d0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ee:	89 f8                	mov    %edi,%eax
801063f0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
801063f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f4:	5b                   	pop    %ebx
801063f5:	5e                   	pop    %esi
801063f6:	5f                   	pop    %edi
801063f7:	5d                   	pop    %ebp
801063f8:	c3                   	ret    
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106400 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106400:	55                   	push   %ebp
80106401:	31 c9                	xor    %ecx,%ecx
80106403:	89 c8                	mov    %ecx,%eax
80106405:	89 e5                	mov    %esp,%ebp
80106407:	57                   	push   %edi
80106408:	56                   	push   %esi
80106409:	53                   	push   %ebx
8010640a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010640f:	89 da                	mov    %ebx,%edx
80106411:	83 ec 0c             	sub    $0xc,%esp
80106414:	ee                   	out    %al,(%dx)
80106415:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010641a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010641f:	89 fa                	mov    %edi,%edx
80106421:	ee                   	out    %al,(%dx)
80106422:	b8 0c 00 00 00       	mov    $0xc,%eax
80106427:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010642c:	ee                   	out    %al,(%dx)
8010642d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106432:	89 c8                	mov    %ecx,%eax
80106434:	89 f2                	mov    %esi,%edx
80106436:	ee                   	out    %al,(%dx)
80106437:	b8 03 00 00 00       	mov    $0x3,%eax
8010643c:	89 fa                	mov    %edi,%edx
8010643e:	ee                   	out    %al,(%dx)
8010643f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106444:	89 c8                	mov    %ecx,%eax
80106446:	ee                   	out    %al,(%dx)
80106447:	b8 01 00 00 00       	mov    $0x1,%eax
8010644c:	89 f2                	mov    %esi,%edx
8010644e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010644f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106454:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106455:	3c ff                	cmp    $0xff,%al
80106457:	74 5a                	je     801064b3 <uartinit+0xb3>
    return;
  uart = 1;
80106459:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106460:	00 00 00 
80106463:	89 da                	mov    %ebx,%edx
80106465:	ec                   	in     (%dx),%al
80106466:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010646c:	83 ec 08             	sub    $0x8,%esp
8010646f:	bb 5c 82 10 80       	mov    $0x8010825c,%ebx
80106474:	6a 00                	push   $0x0
80106476:	6a 04                	push   $0x4
80106478:	e8 13 c2 ff ff       	call   80102690 <ioapicenable>
8010647d:	83 c4 10             	add    $0x10,%esp
80106480:	b8 78 00 00 00       	mov    $0x78,%eax
80106485:	eb 13                	jmp    8010649a <uartinit+0x9a>
80106487:	89 f6                	mov    %esi,%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106490:	83 c3 01             	add    $0x1,%ebx
80106493:	0f be 03             	movsbl (%ebx),%eax
80106496:	84 c0                	test   %al,%al
80106498:	74 19                	je     801064b3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010649a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801064a0:	85 d2                	test   %edx,%edx
801064a2:	74 ec                	je     80106490 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801064a4:	83 c3 01             	add    $0x1,%ebx
801064a7:	e8 04 ff ff ff       	call   801063b0 <uartputc.part.0>
801064ac:	0f be 03             	movsbl (%ebx),%eax
801064af:	84 c0                	test   %al,%al
801064b1:	75 e7                	jne    8010649a <uartinit+0x9a>
    uartputc(*p);
}
801064b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064b6:	5b                   	pop    %ebx
801064b7:	5e                   	pop    %esi
801064b8:	5f                   	pop    %edi
801064b9:	5d                   	pop    %ebp
801064ba:	c3                   	ret    
801064bb:	90                   	nop
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064c0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801064c0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801064c6:	55                   	push   %ebp
801064c7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
801064c9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801064cb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
801064ce:	74 10                	je     801064e0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801064d0:	5d                   	pop    %ebp
801064d1:	e9 da fe ff ff       	jmp    801063b0 <uartputc.part.0>
801064d6:	8d 76 00             	lea    0x0(%esi),%esi
801064d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064e0:	5d                   	pop    %ebp
801064e1:	c3                   	ret    
801064e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064f0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801064f6:	68 80 63 10 80       	push   $0x80106380
801064fb:	e8 f0 a2 ff ff       	call   801007f0 <consoleintr>
}
80106500:	83 c4 10             	add    $0x10,%esp
80106503:	c9                   	leave  
80106504:	c3                   	ret    

80106505 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $0
80106507:	6a 00                	push   $0x0
  jmp alltraps
80106509:	e9 3b fb ff ff       	jmp    80106049 <alltraps>

8010650e <vector1>:
.globl vector1
vector1:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $1
80106510:	6a 01                	push   $0x1
  jmp alltraps
80106512:	e9 32 fb ff ff       	jmp    80106049 <alltraps>

80106517 <vector2>:
.globl vector2
vector2:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $2
80106519:	6a 02                	push   $0x2
  jmp alltraps
8010651b:	e9 29 fb ff ff       	jmp    80106049 <alltraps>

80106520 <vector3>:
.globl vector3
vector3:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $3
80106522:	6a 03                	push   $0x3
  jmp alltraps
80106524:	e9 20 fb ff ff       	jmp    80106049 <alltraps>

80106529 <vector4>:
.globl vector4
vector4:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $4
8010652b:	6a 04                	push   $0x4
  jmp alltraps
8010652d:	e9 17 fb ff ff       	jmp    80106049 <alltraps>

80106532 <vector5>:
.globl vector5
vector5:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $5
80106534:	6a 05                	push   $0x5
  jmp alltraps
80106536:	e9 0e fb ff ff       	jmp    80106049 <alltraps>

8010653b <vector6>:
.globl vector6
vector6:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $6
8010653d:	6a 06                	push   $0x6
  jmp alltraps
8010653f:	e9 05 fb ff ff       	jmp    80106049 <alltraps>

80106544 <vector7>:
.globl vector7
vector7:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $7
80106546:	6a 07                	push   $0x7
  jmp alltraps
80106548:	e9 fc fa ff ff       	jmp    80106049 <alltraps>

8010654d <vector8>:
.globl vector8
vector8:
  pushl $8
8010654d:	6a 08                	push   $0x8
  jmp alltraps
8010654f:	e9 f5 fa ff ff       	jmp    80106049 <alltraps>

80106554 <vector9>:
.globl vector9
vector9:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $9
80106556:	6a 09                	push   $0x9
  jmp alltraps
80106558:	e9 ec fa ff ff       	jmp    80106049 <alltraps>

8010655d <vector10>:
.globl vector10
vector10:
  pushl $10
8010655d:	6a 0a                	push   $0xa
  jmp alltraps
8010655f:	e9 e5 fa ff ff       	jmp    80106049 <alltraps>

80106564 <vector11>:
.globl vector11
vector11:
  pushl $11
80106564:	6a 0b                	push   $0xb
  jmp alltraps
80106566:	e9 de fa ff ff       	jmp    80106049 <alltraps>

8010656b <vector12>:
.globl vector12
vector12:
  pushl $12
8010656b:	6a 0c                	push   $0xc
  jmp alltraps
8010656d:	e9 d7 fa ff ff       	jmp    80106049 <alltraps>

80106572 <vector13>:
.globl vector13
vector13:
  pushl $13
80106572:	6a 0d                	push   $0xd
  jmp alltraps
80106574:	e9 d0 fa ff ff       	jmp    80106049 <alltraps>

80106579 <vector14>:
.globl vector14
vector14:
  pushl $14
80106579:	6a 0e                	push   $0xe
  jmp alltraps
8010657b:	e9 c9 fa ff ff       	jmp    80106049 <alltraps>

80106580 <vector15>:
.globl vector15
vector15:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $15
80106582:	6a 0f                	push   $0xf
  jmp alltraps
80106584:	e9 c0 fa ff ff       	jmp    80106049 <alltraps>

80106589 <vector16>:
.globl vector16
vector16:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $16
8010658b:	6a 10                	push   $0x10
  jmp alltraps
8010658d:	e9 b7 fa ff ff       	jmp    80106049 <alltraps>

80106592 <vector17>:
.globl vector17
vector17:
  pushl $17
80106592:	6a 11                	push   $0x11
  jmp alltraps
80106594:	e9 b0 fa ff ff       	jmp    80106049 <alltraps>

80106599 <vector18>:
.globl vector18
vector18:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $18
8010659b:	6a 12                	push   $0x12
  jmp alltraps
8010659d:	e9 a7 fa ff ff       	jmp    80106049 <alltraps>

801065a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $19
801065a4:	6a 13                	push   $0x13
  jmp alltraps
801065a6:	e9 9e fa ff ff       	jmp    80106049 <alltraps>

801065ab <vector20>:
.globl vector20
vector20:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $20
801065ad:	6a 14                	push   $0x14
  jmp alltraps
801065af:	e9 95 fa ff ff       	jmp    80106049 <alltraps>

801065b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $21
801065b6:	6a 15                	push   $0x15
  jmp alltraps
801065b8:	e9 8c fa ff ff       	jmp    80106049 <alltraps>

801065bd <vector22>:
.globl vector22
vector22:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $22
801065bf:	6a 16                	push   $0x16
  jmp alltraps
801065c1:	e9 83 fa ff ff       	jmp    80106049 <alltraps>

801065c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $23
801065c8:	6a 17                	push   $0x17
  jmp alltraps
801065ca:	e9 7a fa ff ff       	jmp    80106049 <alltraps>

801065cf <vector24>:
.globl vector24
vector24:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $24
801065d1:	6a 18                	push   $0x18
  jmp alltraps
801065d3:	e9 71 fa ff ff       	jmp    80106049 <alltraps>

801065d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $25
801065da:	6a 19                	push   $0x19
  jmp alltraps
801065dc:	e9 68 fa ff ff       	jmp    80106049 <alltraps>

801065e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $26
801065e3:	6a 1a                	push   $0x1a
  jmp alltraps
801065e5:	e9 5f fa ff ff       	jmp    80106049 <alltraps>

801065ea <vector27>:
.globl vector27
vector27:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $27
801065ec:	6a 1b                	push   $0x1b
  jmp alltraps
801065ee:	e9 56 fa ff ff       	jmp    80106049 <alltraps>

801065f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $28
801065f5:	6a 1c                	push   $0x1c
  jmp alltraps
801065f7:	e9 4d fa ff ff       	jmp    80106049 <alltraps>

801065fc <vector29>:
.globl vector29
vector29:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $29
801065fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106600:	e9 44 fa ff ff       	jmp    80106049 <alltraps>

80106605 <vector30>:
.globl vector30
vector30:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $30
80106607:	6a 1e                	push   $0x1e
  jmp alltraps
80106609:	e9 3b fa ff ff       	jmp    80106049 <alltraps>

8010660e <vector31>:
.globl vector31
vector31:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $31
80106610:	6a 1f                	push   $0x1f
  jmp alltraps
80106612:	e9 32 fa ff ff       	jmp    80106049 <alltraps>

80106617 <vector32>:
.globl vector32
vector32:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $32
80106619:	6a 20                	push   $0x20
  jmp alltraps
8010661b:	e9 29 fa ff ff       	jmp    80106049 <alltraps>

80106620 <vector33>:
.globl vector33
vector33:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $33
80106622:	6a 21                	push   $0x21
  jmp alltraps
80106624:	e9 20 fa ff ff       	jmp    80106049 <alltraps>

80106629 <vector34>:
.globl vector34
vector34:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $34
8010662b:	6a 22                	push   $0x22
  jmp alltraps
8010662d:	e9 17 fa ff ff       	jmp    80106049 <alltraps>

80106632 <vector35>:
.globl vector35
vector35:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $35
80106634:	6a 23                	push   $0x23
  jmp alltraps
80106636:	e9 0e fa ff ff       	jmp    80106049 <alltraps>

8010663b <vector36>:
.globl vector36
vector36:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $36
8010663d:	6a 24                	push   $0x24
  jmp alltraps
8010663f:	e9 05 fa ff ff       	jmp    80106049 <alltraps>

80106644 <vector37>:
.globl vector37
vector37:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $37
80106646:	6a 25                	push   $0x25
  jmp alltraps
80106648:	e9 fc f9 ff ff       	jmp    80106049 <alltraps>

8010664d <vector38>:
.globl vector38
vector38:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $38
8010664f:	6a 26                	push   $0x26
  jmp alltraps
80106651:	e9 f3 f9 ff ff       	jmp    80106049 <alltraps>

80106656 <vector39>:
.globl vector39
vector39:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $39
80106658:	6a 27                	push   $0x27
  jmp alltraps
8010665a:	e9 ea f9 ff ff       	jmp    80106049 <alltraps>

8010665f <vector40>:
.globl vector40
vector40:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $40
80106661:	6a 28                	push   $0x28
  jmp alltraps
80106663:	e9 e1 f9 ff ff       	jmp    80106049 <alltraps>

80106668 <vector41>:
.globl vector41
vector41:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $41
8010666a:	6a 29                	push   $0x29
  jmp alltraps
8010666c:	e9 d8 f9 ff ff       	jmp    80106049 <alltraps>

80106671 <vector42>:
.globl vector42
vector42:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $42
80106673:	6a 2a                	push   $0x2a
  jmp alltraps
80106675:	e9 cf f9 ff ff       	jmp    80106049 <alltraps>

8010667a <vector43>:
.globl vector43
vector43:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $43
8010667c:	6a 2b                	push   $0x2b
  jmp alltraps
8010667e:	e9 c6 f9 ff ff       	jmp    80106049 <alltraps>

80106683 <vector44>:
.globl vector44
vector44:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $44
80106685:	6a 2c                	push   $0x2c
  jmp alltraps
80106687:	e9 bd f9 ff ff       	jmp    80106049 <alltraps>

8010668c <vector45>:
.globl vector45
vector45:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $45
8010668e:	6a 2d                	push   $0x2d
  jmp alltraps
80106690:	e9 b4 f9 ff ff       	jmp    80106049 <alltraps>

80106695 <vector46>:
.globl vector46
vector46:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $46
80106697:	6a 2e                	push   $0x2e
  jmp alltraps
80106699:	e9 ab f9 ff ff       	jmp    80106049 <alltraps>

8010669e <vector47>:
.globl vector47
vector47:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $47
801066a0:	6a 2f                	push   $0x2f
  jmp alltraps
801066a2:	e9 a2 f9 ff ff       	jmp    80106049 <alltraps>

801066a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $48
801066a9:	6a 30                	push   $0x30
  jmp alltraps
801066ab:	e9 99 f9 ff ff       	jmp    80106049 <alltraps>

801066b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $49
801066b2:	6a 31                	push   $0x31
  jmp alltraps
801066b4:	e9 90 f9 ff ff       	jmp    80106049 <alltraps>

801066b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $50
801066bb:	6a 32                	push   $0x32
  jmp alltraps
801066bd:	e9 87 f9 ff ff       	jmp    80106049 <alltraps>

801066c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $51
801066c4:	6a 33                	push   $0x33
  jmp alltraps
801066c6:	e9 7e f9 ff ff       	jmp    80106049 <alltraps>

801066cb <vector52>:
.globl vector52
vector52:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $52
801066cd:	6a 34                	push   $0x34
  jmp alltraps
801066cf:	e9 75 f9 ff ff       	jmp    80106049 <alltraps>

801066d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $53
801066d6:	6a 35                	push   $0x35
  jmp alltraps
801066d8:	e9 6c f9 ff ff       	jmp    80106049 <alltraps>

801066dd <vector54>:
.globl vector54
vector54:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $54
801066df:	6a 36                	push   $0x36
  jmp alltraps
801066e1:	e9 63 f9 ff ff       	jmp    80106049 <alltraps>

801066e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $55
801066e8:	6a 37                	push   $0x37
  jmp alltraps
801066ea:	e9 5a f9 ff ff       	jmp    80106049 <alltraps>

801066ef <vector56>:
.globl vector56
vector56:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $56
801066f1:	6a 38                	push   $0x38
  jmp alltraps
801066f3:	e9 51 f9 ff ff       	jmp    80106049 <alltraps>

801066f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $57
801066fa:	6a 39                	push   $0x39
  jmp alltraps
801066fc:	e9 48 f9 ff ff       	jmp    80106049 <alltraps>

80106701 <vector58>:
.globl vector58
vector58:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $58
80106703:	6a 3a                	push   $0x3a
  jmp alltraps
80106705:	e9 3f f9 ff ff       	jmp    80106049 <alltraps>

8010670a <vector59>:
.globl vector59
vector59:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $59
8010670c:	6a 3b                	push   $0x3b
  jmp alltraps
8010670e:	e9 36 f9 ff ff       	jmp    80106049 <alltraps>

80106713 <vector60>:
.globl vector60
vector60:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $60
80106715:	6a 3c                	push   $0x3c
  jmp alltraps
80106717:	e9 2d f9 ff ff       	jmp    80106049 <alltraps>

8010671c <vector61>:
.globl vector61
vector61:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $61
8010671e:	6a 3d                	push   $0x3d
  jmp alltraps
80106720:	e9 24 f9 ff ff       	jmp    80106049 <alltraps>

80106725 <vector62>:
.globl vector62
vector62:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $62
80106727:	6a 3e                	push   $0x3e
  jmp alltraps
80106729:	e9 1b f9 ff ff       	jmp    80106049 <alltraps>

8010672e <vector63>:
.globl vector63
vector63:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $63
80106730:	6a 3f                	push   $0x3f
  jmp alltraps
80106732:	e9 12 f9 ff ff       	jmp    80106049 <alltraps>

80106737 <vector64>:
.globl vector64
vector64:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $64
80106739:	6a 40                	push   $0x40
  jmp alltraps
8010673b:	e9 09 f9 ff ff       	jmp    80106049 <alltraps>

80106740 <vector65>:
.globl vector65
vector65:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $65
80106742:	6a 41                	push   $0x41
  jmp alltraps
80106744:	e9 00 f9 ff ff       	jmp    80106049 <alltraps>

80106749 <vector66>:
.globl vector66
vector66:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $66
8010674b:	6a 42                	push   $0x42
  jmp alltraps
8010674d:	e9 f7 f8 ff ff       	jmp    80106049 <alltraps>

80106752 <vector67>:
.globl vector67
vector67:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $67
80106754:	6a 43                	push   $0x43
  jmp alltraps
80106756:	e9 ee f8 ff ff       	jmp    80106049 <alltraps>

8010675b <vector68>:
.globl vector68
vector68:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $68
8010675d:	6a 44                	push   $0x44
  jmp alltraps
8010675f:	e9 e5 f8 ff ff       	jmp    80106049 <alltraps>

80106764 <vector69>:
.globl vector69
vector69:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $69
80106766:	6a 45                	push   $0x45
  jmp alltraps
80106768:	e9 dc f8 ff ff       	jmp    80106049 <alltraps>

8010676d <vector70>:
.globl vector70
vector70:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $70
8010676f:	6a 46                	push   $0x46
  jmp alltraps
80106771:	e9 d3 f8 ff ff       	jmp    80106049 <alltraps>

80106776 <vector71>:
.globl vector71
vector71:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $71
80106778:	6a 47                	push   $0x47
  jmp alltraps
8010677a:	e9 ca f8 ff ff       	jmp    80106049 <alltraps>

8010677f <vector72>:
.globl vector72
vector72:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $72
80106781:	6a 48                	push   $0x48
  jmp alltraps
80106783:	e9 c1 f8 ff ff       	jmp    80106049 <alltraps>

80106788 <vector73>:
.globl vector73
vector73:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $73
8010678a:	6a 49                	push   $0x49
  jmp alltraps
8010678c:	e9 b8 f8 ff ff       	jmp    80106049 <alltraps>

80106791 <vector74>:
.globl vector74
vector74:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $74
80106793:	6a 4a                	push   $0x4a
  jmp alltraps
80106795:	e9 af f8 ff ff       	jmp    80106049 <alltraps>

8010679a <vector75>:
.globl vector75
vector75:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $75
8010679c:	6a 4b                	push   $0x4b
  jmp alltraps
8010679e:	e9 a6 f8 ff ff       	jmp    80106049 <alltraps>

801067a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $76
801067a5:	6a 4c                	push   $0x4c
  jmp alltraps
801067a7:	e9 9d f8 ff ff       	jmp    80106049 <alltraps>

801067ac <vector77>:
.globl vector77
vector77:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $77
801067ae:	6a 4d                	push   $0x4d
  jmp alltraps
801067b0:	e9 94 f8 ff ff       	jmp    80106049 <alltraps>

801067b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $78
801067b7:	6a 4e                	push   $0x4e
  jmp alltraps
801067b9:	e9 8b f8 ff ff       	jmp    80106049 <alltraps>

801067be <vector79>:
.globl vector79
vector79:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $79
801067c0:	6a 4f                	push   $0x4f
  jmp alltraps
801067c2:	e9 82 f8 ff ff       	jmp    80106049 <alltraps>

801067c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $80
801067c9:	6a 50                	push   $0x50
  jmp alltraps
801067cb:	e9 79 f8 ff ff       	jmp    80106049 <alltraps>

801067d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $81
801067d2:	6a 51                	push   $0x51
  jmp alltraps
801067d4:	e9 70 f8 ff ff       	jmp    80106049 <alltraps>

801067d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $82
801067db:	6a 52                	push   $0x52
  jmp alltraps
801067dd:	e9 67 f8 ff ff       	jmp    80106049 <alltraps>

801067e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $83
801067e4:	6a 53                	push   $0x53
  jmp alltraps
801067e6:	e9 5e f8 ff ff       	jmp    80106049 <alltraps>

801067eb <vector84>:
.globl vector84
vector84:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $84
801067ed:	6a 54                	push   $0x54
  jmp alltraps
801067ef:	e9 55 f8 ff ff       	jmp    80106049 <alltraps>

801067f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $85
801067f6:	6a 55                	push   $0x55
  jmp alltraps
801067f8:	e9 4c f8 ff ff       	jmp    80106049 <alltraps>

801067fd <vector86>:
.globl vector86
vector86:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $86
801067ff:	6a 56                	push   $0x56
  jmp alltraps
80106801:	e9 43 f8 ff ff       	jmp    80106049 <alltraps>

80106806 <vector87>:
.globl vector87
vector87:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $87
80106808:	6a 57                	push   $0x57
  jmp alltraps
8010680a:	e9 3a f8 ff ff       	jmp    80106049 <alltraps>

8010680f <vector88>:
.globl vector88
vector88:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $88
80106811:	6a 58                	push   $0x58
  jmp alltraps
80106813:	e9 31 f8 ff ff       	jmp    80106049 <alltraps>

80106818 <vector89>:
.globl vector89
vector89:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $89
8010681a:	6a 59                	push   $0x59
  jmp alltraps
8010681c:	e9 28 f8 ff ff       	jmp    80106049 <alltraps>

80106821 <vector90>:
.globl vector90
vector90:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $90
80106823:	6a 5a                	push   $0x5a
  jmp alltraps
80106825:	e9 1f f8 ff ff       	jmp    80106049 <alltraps>

8010682a <vector91>:
.globl vector91
vector91:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $91
8010682c:	6a 5b                	push   $0x5b
  jmp alltraps
8010682e:	e9 16 f8 ff ff       	jmp    80106049 <alltraps>

80106833 <vector92>:
.globl vector92
vector92:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $92
80106835:	6a 5c                	push   $0x5c
  jmp alltraps
80106837:	e9 0d f8 ff ff       	jmp    80106049 <alltraps>

8010683c <vector93>:
.globl vector93
vector93:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $93
8010683e:	6a 5d                	push   $0x5d
  jmp alltraps
80106840:	e9 04 f8 ff ff       	jmp    80106049 <alltraps>

80106845 <vector94>:
.globl vector94
vector94:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $94
80106847:	6a 5e                	push   $0x5e
  jmp alltraps
80106849:	e9 fb f7 ff ff       	jmp    80106049 <alltraps>

8010684e <vector95>:
.globl vector95
vector95:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $95
80106850:	6a 5f                	push   $0x5f
  jmp alltraps
80106852:	e9 f2 f7 ff ff       	jmp    80106049 <alltraps>

80106857 <vector96>:
.globl vector96
vector96:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $96
80106859:	6a 60                	push   $0x60
  jmp alltraps
8010685b:	e9 e9 f7 ff ff       	jmp    80106049 <alltraps>

80106860 <vector97>:
.globl vector97
vector97:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $97
80106862:	6a 61                	push   $0x61
  jmp alltraps
80106864:	e9 e0 f7 ff ff       	jmp    80106049 <alltraps>

80106869 <vector98>:
.globl vector98
vector98:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $98
8010686b:	6a 62                	push   $0x62
  jmp alltraps
8010686d:	e9 d7 f7 ff ff       	jmp    80106049 <alltraps>

80106872 <vector99>:
.globl vector99
vector99:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $99
80106874:	6a 63                	push   $0x63
  jmp alltraps
80106876:	e9 ce f7 ff ff       	jmp    80106049 <alltraps>

8010687b <vector100>:
.globl vector100
vector100:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $100
8010687d:	6a 64                	push   $0x64
  jmp alltraps
8010687f:	e9 c5 f7 ff ff       	jmp    80106049 <alltraps>

80106884 <vector101>:
.globl vector101
vector101:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $101
80106886:	6a 65                	push   $0x65
  jmp alltraps
80106888:	e9 bc f7 ff ff       	jmp    80106049 <alltraps>

8010688d <vector102>:
.globl vector102
vector102:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $102
8010688f:	6a 66                	push   $0x66
  jmp alltraps
80106891:	e9 b3 f7 ff ff       	jmp    80106049 <alltraps>

80106896 <vector103>:
.globl vector103
vector103:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $103
80106898:	6a 67                	push   $0x67
  jmp alltraps
8010689a:	e9 aa f7 ff ff       	jmp    80106049 <alltraps>

8010689f <vector104>:
.globl vector104
vector104:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $104
801068a1:	6a 68                	push   $0x68
  jmp alltraps
801068a3:	e9 a1 f7 ff ff       	jmp    80106049 <alltraps>

801068a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $105
801068aa:	6a 69                	push   $0x69
  jmp alltraps
801068ac:	e9 98 f7 ff ff       	jmp    80106049 <alltraps>

801068b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $106
801068b3:	6a 6a                	push   $0x6a
  jmp alltraps
801068b5:	e9 8f f7 ff ff       	jmp    80106049 <alltraps>

801068ba <vector107>:
.globl vector107
vector107:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $107
801068bc:	6a 6b                	push   $0x6b
  jmp alltraps
801068be:	e9 86 f7 ff ff       	jmp    80106049 <alltraps>

801068c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $108
801068c5:	6a 6c                	push   $0x6c
  jmp alltraps
801068c7:	e9 7d f7 ff ff       	jmp    80106049 <alltraps>

801068cc <vector109>:
.globl vector109
vector109:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $109
801068ce:	6a 6d                	push   $0x6d
  jmp alltraps
801068d0:	e9 74 f7 ff ff       	jmp    80106049 <alltraps>

801068d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $110
801068d7:	6a 6e                	push   $0x6e
  jmp alltraps
801068d9:	e9 6b f7 ff ff       	jmp    80106049 <alltraps>

801068de <vector111>:
.globl vector111
vector111:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $111
801068e0:	6a 6f                	push   $0x6f
  jmp alltraps
801068e2:	e9 62 f7 ff ff       	jmp    80106049 <alltraps>

801068e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $112
801068e9:	6a 70                	push   $0x70
  jmp alltraps
801068eb:	e9 59 f7 ff ff       	jmp    80106049 <alltraps>

801068f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $113
801068f2:	6a 71                	push   $0x71
  jmp alltraps
801068f4:	e9 50 f7 ff ff       	jmp    80106049 <alltraps>

801068f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $114
801068fb:	6a 72                	push   $0x72
  jmp alltraps
801068fd:	e9 47 f7 ff ff       	jmp    80106049 <alltraps>

80106902 <vector115>:
.globl vector115
vector115:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $115
80106904:	6a 73                	push   $0x73
  jmp alltraps
80106906:	e9 3e f7 ff ff       	jmp    80106049 <alltraps>

8010690b <vector116>:
.globl vector116
vector116:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $116
8010690d:	6a 74                	push   $0x74
  jmp alltraps
8010690f:	e9 35 f7 ff ff       	jmp    80106049 <alltraps>

80106914 <vector117>:
.globl vector117
vector117:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $117
80106916:	6a 75                	push   $0x75
  jmp alltraps
80106918:	e9 2c f7 ff ff       	jmp    80106049 <alltraps>

8010691d <vector118>:
.globl vector118
vector118:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $118
8010691f:	6a 76                	push   $0x76
  jmp alltraps
80106921:	e9 23 f7 ff ff       	jmp    80106049 <alltraps>

80106926 <vector119>:
.globl vector119
vector119:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $119
80106928:	6a 77                	push   $0x77
  jmp alltraps
8010692a:	e9 1a f7 ff ff       	jmp    80106049 <alltraps>

8010692f <vector120>:
.globl vector120
vector120:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $120
80106931:	6a 78                	push   $0x78
  jmp alltraps
80106933:	e9 11 f7 ff ff       	jmp    80106049 <alltraps>

80106938 <vector121>:
.globl vector121
vector121:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $121
8010693a:	6a 79                	push   $0x79
  jmp alltraps
8010693c:	e9 08 f7 ff ff       	jmp    80106049 <alltraps>

80106941 <vector122>:
.globl vector122
vector122:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $122
80106943:	6a 7a                	push   $0x7a
  jmp alltraps
80106945:	e9 ff f6 ff ff       	jmp    80106049 <alltraps>

8010694a <vector123>:
.globl vector123
vector123:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $123
8010694c:	6a 7b                	push   $0x7b
  jmp alltraps
8010694e:	e9 f6 f6 ff ff       	jmp    80106049 <alltraps>

80106953 <vector124>:
.globl vector124
vector124:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $124
80106955:	6a 7c                	push   $0x7c
  jmp alltraps
80106957:	e9 ed f6 ff ff       	jmp    80106049 <alltraps>

8010695c <vector125>:
.globl vector125
vector125:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $125
8010695e:	6a 7d                	push   $0x7d
  jmp alltraps
80106960:	e9 e4 f6 ff ff       	jmp    80106049 <alltraps>

80106965 <vector126>:
.globl vector126
vector126:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $126
80106967:	6a 7e                	push   $0x7e
  jmp alltraps
80106969:	e9 db f6 ff ff       	jmp    80106049 <alltraps>

8010696e <vector127>:
.globl vector127
vector127:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $127
80106970:	6a 7f                	push   $0x7f
  jmp alltraps
80106972:	e9 d2 f6 ff ff       	jmp    80106049 <alltraps>

80106977 <vector128>:
.globl vector128
vector128:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $128
80106979:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010697e:	e9 c6 f6 ff ff       	jmp    80106049 <alltraps>

80106983 <vector129>:
.globl vector129
vector129:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $129
80106985:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010698a:	e9 ba f6 ff ff       	jmp    80106049 <alltraps>

8010698f <vector130>:
.globl vector130
vector130:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $130
80106991:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106996:	e9 ae f6 ff ff       	jmp    80106049 <alltraps>

8010699b <vector131>:
.globl vector131
vector131:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $131
8010699d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801069a2:	e9 a2 f6 ff ff       	jmp    80106049 <alltraps>

801069a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $132
801069a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801069ae:	e9 96 f6 ff ff       	jmp    80106049 <alltraps>

801069b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $133
801069b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069ba:	e9 8a f6 ff ff       	jmp    80106049 <alltraps>

801069bf <vector134>:
.globl vector134
vector134:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $134
801069c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801069c6:	e9 7e f6 ff ff       	jmp    80106049 <alltraps>

801069cb <vector135>:
.globl vector135
vector135:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $135
801069cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069d2:	e9 72 f6 ff ff       	jmp    80106049 <alltraps>

801069d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $136
801069d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801069de:	e9 66 f6 ff ff       	jmp    80106049 <alltraps>

801069e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $137
801069e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069ea:	e9 5a f6 ff ff       	jmp    80106049 <alltraps>

801069ef <vector138>:
.globl vector138
vector138:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $138
801069f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801069f6:	e9 4e f6 ff ff       	jmp    80106049 <alltraps>

801069fb <vector139>:
.globl vector139
vector139:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $139
801069fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a02:	e9 42 f6 ff ff       	jmp    80106049 <alltraps>

80106a07 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $140
80106a09:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a0e:	e9 36 f6 ff ff       	jmp    80106049 <alltraps>

80106a13 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $141
80106a15:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a1a:	e9 2a f6 ff ff       	jmp    80106049 <alltraps>

80106a1f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $142
80106a21:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a26:	e9 1e f6 ff ff       	jmp    80106049 <alltraps>

80106a2b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $143
80106a2d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a32:	e9 12 f6 ff ff       	jmp    80106049 <alltraps>

80106a37 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $144
80106a39:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a3e:	e9 06 f6 ff ff       	jmp    80106049 <alltraps>

80106a43 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $145
80106a45:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a4a:	e9 fa f5 ff ff       	jmp    80106049 <alltraps>

80106a4f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $146
80106a51:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a56:	e9 ee f5 ff ff       	jmp    80106049 <alltraps>

80106a5b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $147
80106a5d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a62:	e9 e2 f5 ff ff       	jmp    80106049 <alltraps>

80106a67 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $148
80106a69:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a6e:	e9 d6 f5 ff ff       	jmp    80106049 <alltraps>

80106a73 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $149
80106a75:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a7a:	e9 ca f5 ff ff       	jmp    80106049 <alltraps>

80106a7f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $150
80106a81:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a86:	e9 be f5 ff ff       	jmp    80106049 <alltraps>

80106a8b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $151
80106a8d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a92:	e9 b2 f5 ff ff       	jmp    80106049 <alltraps>

80106a97 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $152
80106a99:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a9e:	e9 a6 f5 ff ff       	jmp    80106049 <alltraps>

80106aa3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $153
80106aa5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106aaa:	e9 9a f5 ff ff       	jmp    80106049 <alltraps>

80106aaf <vector154>:
.globl vector154
vector154:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $154
80106ab1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ab6:	e9 8e f5 ff ff       	jmp    80106049 <alltraps>

80106abb <vector155>:
.globl vector155
vector155:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $155
80106abd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ac2:	e9 82 f5 ff ff       	jmp    80106049 <alltraps>

80106ac7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $156
80106ac9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ace:	e9 76 f5 ff ff       	jmp    80106049 <alltraps>

80106ad3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $157
80106ad5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106ada:	e9 6a f5 ff ff       	jmp    80106049 <alltraps>

80106adf <vector158>:
.globl vector158
vector158:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $158
80106ae1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ae6:	e9 5e f5 ff ff       	jmp    80106049 <alltraps>

80106aeb <vector159>:
.globl vector159
vector159:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $159
80106aed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106af2:	e9 52 f5 ff ff       	jmp    80106049 <alltraps>

80106af7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $160
80106af9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106afe:	e9 46 f5 ff ff       	jmp    80106049 <alltraps>

80106b03 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $161
80106b05:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b0a:	e9 3a f5 ff ff       	jmp    80106049 <alltraps>

80106b0f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $162
80106b11:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b16:	e9 2e f5 ff ff       	jmp    80106049 <alltraps>

80106b1b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $163
80106b1d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b22:	e9 22 f5 ff ff       	jmp    80106049 <alltraps>

80106b27 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $164
80106b29:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b2e:	e9 16 f5 ff ff       	jmp    80106049 <alltraps>

80106b33 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $165
80106b35:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b3a:	e9 0a f5 ff ff       	jmp    80106049 <alltraps>

80106b3f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $166
80106b41:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b46:	e9 fe f4 ff ff       	jmp    80106049 <alltraps>

80106b4b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $167
80106b4d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b52:	e9 f2 f4 ff ff       	jmp    80106049 <alltraps>

80106b57 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $168
80106b59:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b5e:	e9 e6 f4 ff ff       	jmp    80106049 <alltraps>

80106b63 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $169
80106b65:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b6a:	e9 da f4 ff ff       	jmp    80106049 <alltraps>

80106b6f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $170
80106b71:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b76:	e9 ce f4 ff ff       	jmp    80106049 <alltraps>

80106b7b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $171
80106b7d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b82:	e9 c2 f4 ff ff       	jmp    80106049 <alltraps>

80106b87 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $172
80106b89:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b8e:	e9 b6 f4 ff ff       	jmp    80106049 <alltraps>

80106b93 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $173
80106b95:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b9a:	e9 aa f4 ff ff       	jmp    80106049 <alltraps>

80106b9f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $174
80106ba1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ba6:	e9 9e f4 ff ff       	jmp    80106049 <alltraps>

80106bab <vector175>:
.globl vector175
vector175:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $175
80106bad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106bb2:	e9 92 f4 ff ff       	jmp    80106049 <alltraps>

80106bb7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $176
80106bb9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106bbe:	e9 86 f4 ff ff       	jmp    80106049 <alltraps>

80106bc3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $177
80106bc5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106bca:	e9 7a f4 ff ff       	jmp    80106049 <alltraps>

80106bcf <vector178>:
.globl vector178
vector178:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $178
80106bd1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106bd6:	e9 6e f4 ff ff       	jmp    80106049 <alltraps>

80106bdb <vector179>:
.globl vector179
vector179:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $179
80106bdd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106be2:	e9 62 f4 ff ff       	jmp    80106049 <alltraps>

80106be7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $180
80106be9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bee:	e9 56 f4 ff ff       	jmp    80106049 <alltraps>

80106bf3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $181
80106bf5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106bfa:	e9 4a f4 ff ff       	jmp    80106049 <alltraps>

80106bff <vector182>:
.globl vector182
vector182:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $182
80106c01:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c06:	e9 3e f4 ff ff       	jmp    80106049 <alltraps>

80106c0b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $183
80106c0d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c12:	e9 32 f4 ff ff       	jmp    80106049 <alltraps>

80106c17 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $184
80106c19:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c1e:	e9 26 f4 ff ff       	jmp    80106049 <alltraps>

80106c23 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $185
80106c25:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c2a:	e9 1a f4 ff ff       	jmp    80106049 <alltraps>

80106c2f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $186
80106c31:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c36:	e9 0e f4 ff ff       	jmp    80106049 <alltraps>

80106c3b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $187
80106c3d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c42:	e9 02 f4 ff ff       	jmp    80106049 <alltraps>

80106c47 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $188
80106c49:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c4e:	e9 f6 f3 ff ff       	jmp    80106049 <alltraps>

80106c53 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $189
80106c55:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c5a:	e9 ea f3 ff ff       	jmp    80106049 <alltraps>

80106c5f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $190
80106c61:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c66:	e9 de f3 ff ff       	jmp    80106049 <alltraps>

80106c6b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $191
80106c6d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c72:	e9 d2 f3 ff ff       	jmp    80106049 <alltraps>

80106c77 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $192
80106c79:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c7e:	e9 c6 f3 ff ff       	jmp    80106049 <alltraps>

80106c83 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $193
80106c85:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c8a:	e9 ba f3 ff ff       	jmp    80106049 <alltraps>

80106c8f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $194
80106c91:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c96:	e9 ae f3 ff ff       	jmp    80106049 <alltraps>

80106c9b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $195
80106c9d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ca2:	e9 a2 f3 ff ff       	jmp    80106049 <alltraps>

80106ca7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $196
80106ca9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106cae:	e9 96 f3 ff ff       	jmp    80106049 <alltraps>

80106cb3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $197
80106cb5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106cba:	e9 8a f3 ff ff       	jmp    80106049 <alltraps>

80106cbf <vector198>:
.globl vector198
vector198:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $198
80106cc1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106cc6:	e9 7e f3 ff ff       	jmp    80106049 <alltraps>

80106ccb <vector199>:
.globl vector199
vector199:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $199
80106ccd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106cd2:	e9 72 f3 ff ff       	jmp    80106049 <alltraps>

80106cd7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $200
80106cd9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106cde:	e9 66 f3 ff ff       	jmp    80106049 <alltraps>

80106ce3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $201
80106ce5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106cea:	e9 5a f3 ff ff       	jmp    80106049 <alltraps>

80106cef <vector202>:
.globl vector202
vector202:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $202
80106cf1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106cf6:	e9 4e f3 ff ff       	jmp    80106049 <alltraps>

80106cfb <vector203>:
.globl vector203
vector203:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $203
80106cfd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d02:	e9 42 f3 ff ff       	jmp    80106049 <alltraps>

80106d07 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $204
80106d09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d0e:	e9 36 f3 ff ff       	jmp    80106049 <alltraps>

80106d13 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $205
80106d15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d1a:	e9 2a f3 ff ff       	jmp    80106049 <alltraps>

80106d1f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $206
80106d21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d26:	e9 1e f3 ff ff       	jmp    80106049 <alltraps>

80106d2b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $207
80106d2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d32:	e9 12 f3 ff ff       	jmp    80106049 <alltraps>

80106d37 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $208
80106d39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d3e:	e9 06 f3 ff ff       	jmp    80106049 <alltraps>

80106d43 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $209
80106d45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d4a:	e9 fa f2 ff ff       	jmp    80106049 <alltraps>

80106d4f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $210
80106d51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d56:	e9 ee f2 ff ff       	jmp    80106049 <alltraps>

80106d5b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $211
80106d5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d62:	e9 e2 f2 ff ff       	jmp    80106049 <alltraps>

80106d67 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $212
80106d69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d6e:	e9 d6 f2 ff ff       	jmp    80106049 <alltraps>

80106d73 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $213
80106d75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d7a:	e9 ca f2 ff ff       	jmp    80106049 <alltraps>

80106d7f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $214
80106d81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d86:	e9 be f2 ff ff       	jmp    80106049 <alltraps>

80106d8b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $215
80106d8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d92:	e9 b2 f2 ff ff       	jmp    80106049 <alltraps>

80106d97 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $216
80106d99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d9e:	e9 a6 f2 ff ff       	jmp    80106049 <alltraps>

80106da3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $217
80106da5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106daa:	e9 9a f2 ff ff       	jmp    80106049 <alltraps>

80106daf <vector218>:
.globl vector218
vector218:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $218
80106db1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106db6:	e9 8e f2 ff ff       	jmp    80106049 <alltraps>

80106dbb <vector219>:
.globl vector219
vector219:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $219
80106dbd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106dc2:	e9 82 f2 ff ff       	jmp    80106049 <alltraps>

80106dc7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $220
80106dc9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106dce:	e9 76 f2 ff ff       	jmp    80106049 <alltraps>

80106dd3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $221
80106dd5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106dda:	e9 6a f2 ff ff       	jmp    80106049 <alltraps>

80106ddf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $222
80106de1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106de6:	e9 5e f2 ff ff       	jmp    80106049 <alltraps>

80106deb <vector223>:
.globl vector223
vector223:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $223
80106ded:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106df2:	e9 52 f2 ff ff       	jmp    80106049 <alltraps>

80106df7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $224
80106df9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106dfe:	e9 46 f2 ff ff       	jmp    80106049 <alltraps>

80106e03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $225
80106e05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e0a:	e9 3a f2 ff ff       	jmp    80106049 <alltraps>

80106e0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $226
80106e11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e16:	e9 2e f2 ff ff       	jmp    80106049 <alltraps>

80106e1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $227
80106e1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e22:	e9 22 f2 ff ff       	jmp    80106049 <alltraps>

80106e27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $228
80106e29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e2e:	e9 16 f2 ff ff       	jmp    80106049 <alltraps>

80106e33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $229
80106e35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e3a:	e9 0a f2 ff ff       	jmp    80106049 <alltraps>

80106e3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $230
80106e41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e46:	e9 fe f1 ff ff       	jmp    80106049 <alltraps>

80106e4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $231
80106e4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e52:	e9 f2 f1 ff ff       	jmp    80106049 <alltraps>

80106e57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $232
80106e59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e5e:	e9 e6 f1 ff ff       	jmp    80106049 <alltraps>

80106e63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $233
80106e65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e6a:	e9 da f1 ff ff       	jmp    80106049 <alltraps>

80106e6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $234
80106e71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e76:	e9 ce f1 ff ff       	jmp    80106049 <alltraps>

80106e7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $235
80106e7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e82:	e9 c2 f1 ff ff       	jmp    80106049 <alltraps>

80106e87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $236
80106e89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e8e:	e9 b6 f1 ff ff       	jmp    80106049 <alltraps>

80106e93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $237
80106e95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e9a:	e9 aa f1 ff ff       	jmp    80106049 <alltraps>

80106e9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $238
80106ea1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ea6:	e9 9e f1 ff ff       	jmp    80106049 <alltraps>

80106eab <vector239>:
.globl vector239
vector239:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $239
80106ead:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106eb2:	e9 92 f1 ff ff       	jmp    80106049 <alltraps>

80106eb7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $240
80106eb9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ebe:	e9 86 f1 ff ff       	jmp    80106049 <alltraps>

80106ec3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $241
80106ec5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106eca:	e9 7a f1 ff ff       	jmp    80106049 <alltraps>

80106ecf <vector242>:
.globl vector242
vector242:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $242
80106ed1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ed6:	e9 6e f1 ff ff       	jmp    80106049 <alltraps>

80106edb <vector243>:
.globl vector243
vector243:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $243
80106edd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ee2:	e9 62 f1 ff ff       	jmp    80106049 <alltraps>

80106ee7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $244
80106ee9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106eee:	e9 56 f1 ff ff       	jmp    80106049 <alltraps>

80106ef3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $245
80106ef5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106efa:	e9 4a f1 ff ff       	jmp    80106049 <alltraps>

80106eff <vector246>:
.globl vector246
vector246:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $246
80106f01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f06:	e9 3e f1 ff ff       	jmp    80106049 <alltraps>

80106f0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $247
80106f0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f12:	e9 32 f1 ff ff       	jmp    80106049 <alltraps>

80106f17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $248
80106f19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f1e:	e9 26 f1 ff ff       	jmp    80106049 <alltraps>

80106f23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $249
80106f25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f2a:	e9 1a f1 ff ff       	jmp    80106049 <alltraps>

80106f2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $250
80106f31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f36:	e9 0e f1 ff ff       	jmp    80106049 <alltraps>

80106f3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $251
80106f3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f42:	e9 02 f1 ff ff       	jmp    80106049 <alltraps>

80106f47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $252
80106f49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f4e:	e9 f6 f0 ff ff       	jmp    80106049 <alltraps>

80106f53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $253
80106f55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f5a:	e9 ea f0 ff ff       	jmp    80106049 <alltraps>

80106f5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $254
80106f61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f66:	e9 de f0 ff ff       	jmp    80106049 <alltraps>

80106f6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $255
80106f6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f72:	e9 d2 f0 ff ff       	jmp    80106049 <alltraps>
80106f77:	66 90                	xchg   %ax,%ax
80106f79:	66 90                	xchg   %ax,%ax
80106f7b:	66 90                	xchg   %ax,%ax
80106f7d:	66 90                	xchg   %ax,%ax
80106f7f:	90                   	nop

80106f80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f88:	c1 ea 16             	shr    $0x16,%edx
80106f8b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f8e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106f91:	8b 07                	mov    (%edi),%eax
80106f93:	a8 01                	test   $0x1,%al
80106f95:	74 29                	je     80106fc0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f97:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f9c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106fa5:	c1 eb 0a             	shr    $0xa,%ebx
80106fa8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106fae:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106fb1:	5b                   	pop    %ebx
80106fb2:	5e                   	pop    %esi
80106fb3:	5f                   	pop    %edi
80106fb4:	5d                   	pop    %ebp
80106fb5:	c3                   	ret    
80106fb6:	8d 76 00             	lea    0x0(%esi),%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106fc0:	85 c9                	test   %ecx,%ecx
80106fc2:	74 2c                	je     80106ff0 <walkpgdir+0x70>
80106fc4:	e8 b7 b8 ff ff       	call   80102880 <kalloc>
80106fc9:	85 c0                	test   %eax,%eax
80106fcb:	89 c6                	mov    %eax,%esi
80106fcd:	74 21                	je     80106ff0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106fcf:	83 ec 04             	sub    $0x4,%esp
80106fd2:	68 00 10 00 00       	push   $0x1000
80106fd7:	6a 00                	push   $0x0
80106fd9:	50                   	push   %eax
80106fda:	e8 11 dc ff ff       	call   80104bf0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106fdf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fe5:	83 c4 10             	add    $0x10,%esp
80106fe8:	83 c8 07             	or     $0x7,%eax
80106feb:	89 07                	mov    %eax,(%edi)
80106fed:	eb b3                	jmp    80106fa2 <walkpgdir+0x22>
80106fef:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106ff3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107000 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107006:	89 d3                	mov    %edx,%ebx
80107008:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010700e:	83 ec 1c             	sub    $0x1c,%esp
80107011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107014:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107018:	8b 7d 08             	mov    0x8(%ebp),%edi
8010701b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107020:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107023:	8b 45 0c             	mov    0xc(%ebp),%eax
80107026:	29 df                	sub    %ebx,%edi
80107028:	83 c8 01             	or     $0x1,%eax
8010702b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010702e:	eb 15                	jmp    80107045 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107030:	f6 00 01             	testb  $0x1,(%eax)
80107033:	75 45                	jne    8010707a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107035:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107038:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010703b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010703d:	74 31                	je     80107070 <mappages+0x70>
      break;
    a += PGSIZE;
8010703f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107048:	b9 01 00 00 00       	mov    $0x1,%ecx
8010704d:	89 da                	mov    %ebx,%edx
8010704f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107052:	e8 29 ff ff ff       	call   80106f80 <walkpgdir>
80107057:	85 c0                	test   %eax,%eax
80107059:	75 d5                	jne    80107030 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010705b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010705e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107063:	5b                   	pop    %ebx
80107064:	5e                   	pop    %esi
80107065:	5f                   	pop    %edi
80107066:	5d                   	pop    %ebp
80107067:	c3                   	ret    
80107068:	90                   	nop
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010707a:	83 ec 0c             	sub    $0xc,%esp
8010707d:	68 64 82 10 80       	push   $0x80108264
80107082:	e8 e9 92 ff ff       	call   80100370 <panic>
80107087:	89 f6                	mov    %esi,%esi
80107089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107090 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107096:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010709c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010709e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070a4:	83 ec 1c             	sub    $0x1c,%esp
801070a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801070aa:	39 d3                	cmp    %edx,%ebx
801070ac:	73 66                	jae    80107114 <deallocuvm.part.0+0x84>
801070ae:	89 d6                	mov    %edx,%esi
801070b0:	eb 3d                	jmp    801070ef <deallocuvm.part.0+0x5f>
801070b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801070b8:	8b 10                	mov    (%eax),%edx
801070ba:	f6 c2 01             	test   $0x1,%dl
801070bd:	74 26                	je     801070e5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801070bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801070c5:	74 58                	je     8010711f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801070c7:	83 ec 0c             	sub    $0xc,%esp
801070ca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801070d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070d3:	52                   	push   %edx
801070d4:	e8 f7 b5 ff ff       	call   801026d0 <kfree>
      *pte = 0;
801070d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070dc:	83 c4 10             	add    $0x10,%esp
801070df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801070e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070eb:	39 f3                	cmp    %esi,%ebx
801070ed:	73 25                	jae    80107114 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801070ef:	31 c9                	xor    %ecx,%ecx
801070f1:	89 da                	mov    %ebx,%edx
801070f3:	89 f8                	mov    %edi,%eax
801070f5:	e8 86 fe ff ff       	call   80106f80 <walkpgdir>
    if(!pte)
801070fa:	85 c0                	test   %eax,%eax
801070fc:	75 ba                	jne    801070b8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070fe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107104:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010710a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107110:	39 f3                	cmp    %esi,%ebx
80107112:	72 db                	jb     801070ef <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107114:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107117:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711a:	5b                   	pop    %ebx
8010711b:	5e                   	pop    %esi
8010711c:	5f                   	pop    %edi
8010711d:	5d                   	pop    %ebp
8010711e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010711f:	83 ec 0c             	sub    $0xc,%esp
80107122:	68 7a 7b 10 80       	push   $0x80107b7a
80107127:	e8 44 92 ff ff       	call   80100370 <panic>
8010712c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107130 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107136:	e8 65 ca ff ff       	call   80103ba0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010713b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107141:	31 c9                	xor    %ecx,%ecx
80107143:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107148:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
8010714f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107156:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010715b:	31 c9                	xor    %ecx,%ecx
8010715d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107164:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107169:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107170:	31 c9                	xor    %ecx,%ecx
80107172:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80107179:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107180:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107185:	31 c9                	xor    %ecx,%ecx
80107187:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010718e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107195:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010719a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
801071a1:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
801071a8:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071af:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
801071b6:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
801071bd:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
801071c4:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071cb:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
801071d2:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
801071d9:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
801071e0:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071e7:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
801071ee:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
801071f5:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
801071fc:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80107203:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010720a:	05 f0 37 11 80       	add    $0x801137f0,%eax
8010720f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107213:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107217:	c1 e8 10             	shr    $0x10,%eax
8010721a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010721e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107221:	0f 01 10             	lgdtl  (%eax)
}
80107224:	c9                   	leave  
80107225:	c3                   	ret    
80107226:	8d 76 00             	lea    0x0(%esi),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107230:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107235:	55                   	push   %ebp
80107236:	89 e5                	mov    %esp,%ebp
80107238:	05 00 00 00 80       	add    $0x80000000,%eax
8010723d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107240:	5d                   	pop    %ebp
80107241:	c3                   	ret    
80107242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
80107259:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010725c:	85 f6                	test   %esi,%esi
8010725e:	0f 84 cd 00 00 00    	je     80107331 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107264:	8b 46 08             	mov    0x8(%esi),%eax
80107267:	85 c0                	test   %eax,%eax
80107269:	0f 84 dc 00 00 00    	je     8010734b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010726f:	8b 7e 04             	mov    0x4(%esi),%edi
80107272:	85 ff                	test   %edi,%edi
80107274:	0f 84 c4 00 00 00    	je     8010733e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010727a:	e8 91 d7 ff ff       	call   80104a10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010727f:	e8 9c c8 ff ff       	call   80103b20 <mycpu>
80107284:	89 c3                	mov    %eax,%ebx
80107286:	e8 95 c8 ff ff       	call   80103b20 <mycpu>
8010728b:	89 c7                	mov    %eax,%edi
8010728d:	e8 8e c8 ff ff       	call   80103b20 <mycpu>
80107292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107295:	83 c7 08             	add    $0x8,%edi
80107298:	e8 83 c8 ff ff       	call   80103b20 <mycpu>
8010729d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072a0:	83 c0 08             	add    $0x8,%eax
801072a3:	ba 67 00 00 00       	mov    $0x67,%edx
801072a8:	c1 e8 18             	shr    $0x18,%eax
801072ab:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801072b2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072b9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801072c0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801072c7:	83 c1 08             	add    $0x8,%ecx
801072ca:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072d0:	c1 e9 10             	shr    $0x10,%ecx
801072d3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801072de:	e8 3d c8 ff ff       	call   80103b20 <mycpu>
801072e3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ea:	e8 31 c8 ff ff       	call   80103b20 <mycpu>
801072ef:	b9 10 00 00 00       	mov    $0x10,%ecx
801072f4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072f8:	e8 23 c8 ff ff       	call   80103b20 <mycpu>
801072fd:	8b 56 08             	mov    0x8(%esi),%edx
80107300:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107306:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107309:	e8 12 c8 ff ff       	call   80103b20 <mycpu>
8010730e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107312:	b8 28 00 00 00       	mov    $0x28,%eax
80107317:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010731a:	8b 46 04             	mov    0x4(%esi),%eax
8010731d:	05 00 00 00 80       	add    $0x80000000,%eax
80107322:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010732c:	e9 1f d7 ff ff       	jmp    80104a50 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107331:	83 ec 0c             	sub    $0xc,%esp
80107334:	68 6a 82 10 80       	push   $0x8010826a
80107339:	e8 32 90 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010733e:	83 ec 0c             	sub    $0xc,%esp
80107341:	68 95 82 10 80       	push   $0x80108295
80107346:	e8 25 90 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010734b:	83 ec 0c             	sub    $0xc,%esp
8010734e:	68 80 82 10 80       	push   $0x80108280
80107353:	e8 18 90 ff ff       	call   80100370 <panic>
80107358:	90                   	nop
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107360 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 75 10             	mov    0x10(%ebp),%esi
8010736c:	8b 45 08             	mov    0x8(%ebp),%eax
8010736f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107372:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010737b:	77 49                	ja     801073c6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010737d:	e8 fe b4 ff ff       	call   80102880 <kalloc>
  memset(mem, 0, PGSIZE);
80107382:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107385:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107387:	68 00 10 00 00       	push   $0x1000
8010738c:	6a 00                	push   $0x0
8010738e:	50                   	push   %eax
8010738f:	e8 5c d8 ff ff       	call   80104bf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107394:	58                   	pop    %eax
80107395:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010739b:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a0:	5a                   	pop    %edx
801073a1:	6a 06                	push   $0x6
801073a3:	50                   	push   %eax
801073a4:	31 d2                	xor    %edx,%edx
801073a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073a9:	e8 52 fc ff ff       	call   80107000 <mappages>
  memmove(mem, init, sz);
801073ae:	89 75 10             	mov    %esi,0x10(%ebp)
801073b1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801073b4:	83 c4 10             	add    $0x10,%esp
801073b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bd:	5b                   	pop    %ebx
801073be:	5e                   	pop    %esi
801073bf:	5f                   	pop    %edi
801073c0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801073c1:	e9 da d8 ff ff       	jmp    80104ca0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801073c6:	83 ec 0c             	sub    $0xc,%esp
801073c9:	68 a9 82 10 80       	push   $0x801082a9
801073ce:	e8 9d 8f ff ff       	call   80100370 <panic>
801073d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073e0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801073e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073f0:	0f 85 91 00 00 00    	jne    80107487 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801073f6:	8b 75 18             	mov    0x18(%ebp),%esi
801073f9:	31 db                	xor    %ebx,%ebx
801073fb:	85 f6                	test   %esi,%esi
801073fd:	75 1a                	jne    80107419 <loaduvm+0x39>
801073ff:	eb 6f                	jmp    80107470 <loaduvm+0x90>
80107401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107408:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010740e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107414:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107417:	76 57                	jbe    80107470 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107419:	8b 55 0c             	mov    0xc(%ebp),%edx
8010741c:	8b 45 08             	mov    0x8(%ebp),%eax
8010741f:	31 c9                	xor    %ecx,%ecx
80107421:	01 da                	add    %ebx,%edx
80107423:	e8 58 fb ff ff       	call   80106f80 <walkpgdir>
80107428:	85 c0                	test   %eax,%eax
8010742a:	74 4e                	je     8010747a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010742c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010742e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107431:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010743b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107441:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107444:	01 d9                	add    %ebx,%ecx
80107446:	05 00 00 00 80       	add    $0x80000000,%eax
8010744b:	57                   	push   %edi
8010744c:	51                   	push   %ecx
8010744d:	50                   	push   %eax
8010744e:	ff 75 10             	pushl  0x10(%ebp)
80107451:	e8 ea a8 ff ff       	call   80101d40 <readi>
80107456:	83 c4 10             	add    $0x10,%esp
80107459:	39 c7                	cmp    %eax,%edi
8010745b:	74 ab                	je     80107408 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010745d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107465:	5b                   	pop    %ebx
80107466:	5e                   	pop    %esi
80107467:	5f                   	pop    %edi
80107468:	5d                   	pop    %ebp
80107469:	c3                   	ret    
8010746a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107470:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107473:	31 c0                	xor    %eax,%eax
}
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010747a:	83 ec 0c             	sub    $0xc,%esp
8010747d:	68 c3 82 10 80       	push   $0x801082c3
80107482:	e8 e9 8e ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107487:	83 ec 0c             	sub    $0xc,%esp
8010748a:	68 64 83 10 80       	push   $0x80108364
8010748f:	e8 dc 8e ff ff       	call   80100370 <panic>
80107494:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010749a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801074a0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
801074a6:	83 ec 0c             	sub    $0xc,%esp
801074a9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801074ac:	85 ff                	test   %edi,%edi
801074ae:	0f 88 ca 00 00 00    	js     8010757e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
801074b4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801074b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801074ba:	0f 82 82 00 00 00    	jb     80107542 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
801074c0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801074c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801074cc:	39 df                	cmp    %ebx,%edi
801074ce:	77 43                	ja     80107513 <allocuvm+0x73>
801074d0:	e9 bb 00 00 00       	jmp    80107590 <allocuvm+0xf0>
801074d5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801074d8:	83 ec 04             	sub    $0x4,%esp
801074db:	68 00 10 00 00       	push   $0x1000
801074e0:	6a 00                	push   $0x0
801074e2:	50                   	push   %eax
801074e3:	e8 08 d7 ff ff       	call   80104bf0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074e8:	58                   	pop    %eax
801074e9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074ef:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074f4:	5a                   	pop    %edx
801074f5:	6a 06                	push   $0x6
801074f7:	50                   	push   %eax
801074f8:	89 da                	mov    %ebx,%edx
801074fa:	8b 45 08             	mov    0x8(%ebp),%eax
801074fd:	e8 fe fa ff ff       	call   80107000 <mappages>
80107502:	83 c4 10             	add    $0x10,%esp
80107505:	85 c0                	test   %eax,%eax
80107507:	78 47                	js     80107550 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107509:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010750f:	39 df                	cmp    %ebx,%edi
80107511:	76 7d                	jbe    80107590 <allocuvm+0xf0>
    mem = kalloc();
80107513:	e8 68 b3 ff ff       	call   80102880 <kalloc>
    if(mem == 0){
80107518:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010751a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010751c:	75 ba                	jne    801074d8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010751e:	83 ec 0c             	sub    $0xc,%esp
80107521:	68 e1 82 10 80       	push   $0x801082e1
80107526:	e8 35 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010752b:	83 c4 10             	add    $0x10,%esp
8010752e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107531:	76 4b                	jbe    8010757e <allocuvm+0xde>
80107533:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107536:	8b 45 08             	mov    0x8(%ebp),%eax
80107539:	89 fa                	mov    %edi,%edx
8010753b:	e8 50 fb ff ff       	call   80107090 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107540:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107542:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107545:	5b                   	pop    %ebx
80107546:	5e                   	pop    %esi
80107547:	5f                   	pop    %edi
80107548:	5d                   	pop    %ebp
80107549:	c3                   	ret    
8010754a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107550:	83 ec 0c             	sub    $0xc,%esp
80107553:	68 f9 82 10 80       	push   $0x801082f9
80107558:	e8 03 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010755d:	83 c4 10             	add    $0x10,%esp
80107560:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107563:	76 0d                	jbe    80107572 <allocuvm+0xd2>
80107565:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107568:	8b 45 08             	mov    0x8(%ebp),%eax
8010756b:	89 fa                	mov    %edi,%edx
8010756d:	e8 1e fb ff ff       	call   80107090 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107572:	83 ec 0c             	sub    $0xc,%esp
80107575:	56                   	push   %esi
80107576:	e8 55 b1 ff ff       	call   801026d0 <kfree>
      return 0;
8010757b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010757e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107581:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107583:	5b                   	pop    %ebx
80107584:	5e                   	pop    %esi
80107585:	5f                   	pop    %edi
80107586:	5d                   	pop    %ebp
80107587:	c3                   	ret    
80107588:	90                   	nop
80107589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107593:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107595:	5b                   	pop    %ebx
80107596:	5e                   	pop    %esi
80107597:	5f                   	pop    %edi
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801075a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075a9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801075ac:	39 d1                	cmp    %edx,%ecx
801075ae:	73 10                	jae    801075c0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801075b0:	5d                   	pop    %ebp
801075b1:	e9 da fa ff ff       	jmp    80107090 <deallocuvm.part.0>
801075b6:	8d 76 00             	lea    0x0(%esi),%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801075c0:	89 d0                	mov    %edx,%eax
801075c2:	5d                   	pop    %ebp
801075c3:	c3                   	ret    
801075c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801075dc:	85 f6                	test   %esi,%esi
801075de:	74 59                	je     80107639 <freevm+0x69>
801075e0:	31 c9                	xor    %ecx,%ecx
801075e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801075e7:	89 f0                	mov    %esi,%eax
801075e9:	e8 a2 fa ff ff       	call   80107090 <deallocuvm.part.0>
801075ee:	89 f3                	mov    %esi,%ebx
801075f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801075f6:	eb 0f                	jmp    80107607 <freevm+0x37>
801075f8:	90                   	nop
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107600:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107603:	39 fb                	cmp    %edi,%ebx
80107605:	74 23                	je     8010762a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107607:	8b 03                	mov    (%ebx),%eax
80107609:	a8 01                	test   $0x1,%al
8010760b:	74 f3                	je     80107600 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010760d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107612:	83 ec 0c             	sub    $0xc,%esp
80107615:	83 c3 04             	add    $0x4,%ebx
80107618:	05 00 00 00 80       	add    $0x80000000,%eax
8010761d:	50                   	push   %eax
8010761e:	e8 ad b0 ff ff       	call   801026d0 <kfree>
80107623:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107626:	39 fb                	cmp    %edi,%ebx
80107628:	75 dd                	jne    80107607 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010762a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010762d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107630:	5b                   	pop    %ebx
80107631:	5e                   	pop    %esi
80107632:	5f                   	pop    %edi
80107633:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107634:	e9 97 b0 ff ff       	jmp    801026d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107639:	83 ec 0c             	sub    $0xc,%esp
8010763c:	68 15 83 10 80       	push   $0x80108315
80107641:	e8 2a 8d ff ff       	call   80100370 <panic>
80107646:	8d 76 00             	lea    0x0(%esi),%esi
80107649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107650 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	56                   	push   %esi
80107654:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107655:	e8 26 b2 ff ff       	call   80102880 <kalloc>
8010765a:	85 c0                	test   %eax,%eax
8010765c:	74 6a                	je     801076c8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010765e:	83 ec 04             	sub    $0x4,%esp
80107661:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107663:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107668:	68 00 10 00 00       	push   $0x1000
8010766d:	6a 00                	push   $0x0
8010766f:	50                   	push   %eax
80107670:	e8 7b d5 ff ff       	call   80104bf0 <memset>
80107675:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107678:	8b 43 04             	mov    0x4(%ebx),%eax
8010767b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010767e:	83 ec 08             	sub    $0x8,%esp
80107681:	8b 13                	mov    (%ebx),%edx
80107683:	ff 73 0c             	pushl  0xc(%ebx)
80107686:	50                   	push   %eax
80107687:	29 c1                	sub    %eax,%ecx
80107689:	89 f0                	mov    %esi,%eax
8010768b:	e8 70 f9 ff ff       	call   80107000 <mappages>
80107690:	83 c4 10             	add    $0x10,%esp
80107693:	85 c0                	test   %eax,%eax
80107695:	78 19                	js     801076b0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107697:	83 c3 10             	add    $0x10,%ebx
8010769a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076a0:	75 d6                	jne    80107678 <setupkvm+0x28>
801076a2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
801076a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076a7:	5b                   	pop    %ebx
801076a8:	5e                   	pop    %esi
801076a9:	5d                   	pop    %ebp
801076aa:	c3                   	ret    
801076ab:	90                   	nop
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801076b0:	83 ec 0c             	sub    $0xc,%esp
801076b3:	56                   	push   %esi
801076b4:	e8 17 ff ff ff       	call   801075d0 <freevm>
      return 0;
801076b9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
801076bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
801076bf:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801076c1:	5b                   	pop    %ebx
801076c2:	5e                   	pop    %esi
801076c3:	5d                   	pop    %ebp
801076c4:	c3                   	ret    
801076c5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801076c8:	31 c0                	xor    %eax,%eax
801076ca:	eb d8                	jmp    801076a4 <setupkvm+0x54>
801076cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076d0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076d6:	e8 75 ff ff ff       	call   80107650 <setupkvm>
801076db:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
801076e0:	05 00 00 00 80       	add    $0x80000000,%eax
801076e5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801076e8:	c9                   	leave  
801076e9:	c3                   	ret    
801076ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076f1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076f3:	89 e5                	mov    %esp,%ebp
801076f5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076fb:	8b 45 08             	mov    0x8(%ebp),%eax
801076fe:	e8 7d f8 ff ff       	call   80106f80 <walkpgdir>
  if(pte == 0)
80107703:	85 c0                	test   %eax,%eax
80107705:	74 05                	je     8010770c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107707:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010770a:	c9                   	leave  
8010770b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010770c:	83 ec 0c             	sub    $0xc,%esp
8010770f:	68 26 83 10 80       	push   $0x80108326
80107714:	e8 57 8c ff ff       	call   80100370 <panic>
80107719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107720 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	56                   	push   %esi
80107725:	53                   	push   %ebx
80107726:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107729:	e8 22 ff ff ff       	call   80107650 <setupkvm>
8010772e:	85 c0                	test   %eax,%eax
80107730:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107733:	0f 84 c5 00 00 00    	je     801077fe <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107739:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010773c:	85 c9                	test   %ecx,%ecx
8010773e:	0f 84 9c 00 00 00    	je     801077e0 <copyuvm+0xc0>
80107744:	31 ff                	xor    %edi,%edi
80107746:	eb 4a                	jmp    80107792 <copyuvm+0x72>
80107748:	90                   	nop
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107759:	68 00 10 00 00       	push   $0x1000
8010775e:	53                   	push   %ebx
8010775f:	50                   	push   %eax
80107760:	e8 3b d5 ff ff       	call   80104ca0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107765:	58                   	pop    %eax
80107766:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010776c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107771:	5a                   	pop    %edx
80107772:	ff 75 e4             	pushl  -0x1c(%ebp)
80107775:	50                   	push   %eax
80107776:	89 fa                	mov    %edi,%edx
80107778:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010777b:	e8 80 f8 ff ff       	call   80107000 <mappages>
80107780:	83 c4 10             	add    $0x10,%esp
80107783:	85 c0                	test   %eax,%eax
80107785:	78 69                	js     801077f0 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107787:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010778d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107790:	76 4e                	jbe    801077e0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107792:	8b 45 08             	mov    0x8(%ebp),%eax
80107795:	31 c9                	xor    %ecx,%ecx
80107797:	89 fa                	mov    %edi,%edx
80107799:	e8 e2 f7 ff ff       	call   80106f80 <walkpgdir>
8010779e:	85 c0                	test   %eax,%eax
801077a0:	74 6d                	je     8010780f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801077a2:	8b 00                	mov    (%eax),%eax
801077a4:	a8 01                	test   $0x1,%al
801077a6:	74 5a                	je     80107802 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801077a8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801077aa:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801077af:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801077b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801077b8:	e8 c3 b0 ff ff       	call   80102880 <kalloc>
801077bd:	85 c0                	test   %eax,%eax
801077bf:	89 c6                	mov    %eax,%esi
801077c1:	75 8d                	jne    80107750 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801077c3:	83 ec 0c             	sub    $0xc,%esp
801077c6:	ff 75 e0             	pushl  -0x20(%ebp)
801077c9:	e8 02 fe ff ff       	call   801075d0 <freevm>
  return 0;
801077ce:	83 c4 10             	add    $0x10,%esp
801077d1:	31 c0                	xor    %eax,%eax
}
801077d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d6:	5b                   	pop    %ebx
801077d7:	5e                   	pop    %esi
801077d8:	5f                   	pop    %edi
801077d9:	5d                   	pop    %ebp
801077da:	c3                   	ret    
801077db:	90                   	nop
801077dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801077e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e6:	5b                   	pop    %ebx
801077e7:	5e                   	pop    %esi
801077e8:	5f                   	pop    %edi
801077e9:	5d                   	pop    %ebp
801077ea:	c3                   	ret    
801077eb:	90                   	nop
801077ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	56                   	push   %esi
801077f4:	e8 d7 ae ff ff       	call   801026d0 <kfree>
      goto bad;
801077f9:	83 c4 10             	add    $0x10,%esp
801077fc:	eb c5                	jmp    801077c3 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801077fe:	31 c0                	xor    %eax,%eax
80107800:	eb d1                	jmp    801077d3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107802:	83 ec 0c             	sub    $0xc,%esp
80107805:	68 4a 83 10 80       	push   $0x8010834a
8010780a:	e8 61 8b ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010780f:	83 ec 0c             	sub    $0xc,%esp
80107812:	68 30 83 10 80       	push   $0x80108330
80107817:	e8 54 8b ff ff       	call   80100370 <panic>
8010781c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107820 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107820:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107821:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107823:	89 e5                	mov    %esp,%ebp
80107825:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107828:	8b 55 0c             	mov    0xc(%ebp),%edx
8010782b:	8b 45 08             	mov    0x8(%ebp),%eax
8010782e:	e8 4d f7 ff ff       	call   80106f80 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107833:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107835:	89 c2                	mov    %eax,%edx
80107837:	83 e2 05             	and    $0x5,%edx
8010783a:	83 fa 05             	cmp    $0x5,%edx
8010783d:	75 11                	jne    80107850 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010783f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107844:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107845:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010784a:	c3                   	ret    
8010784b:	90                   	nop
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107850:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107852:	c9                   	leave  
80107853:	c3                   	ret    
80107854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010785a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107860 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	57                   	push   %edi
80107864:	56                   	push   %esi
80107865:	53                   	push   %ebx
80107866:	83 ec 1c             	sub    $0x1c,%esp
80107869:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010786c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010786f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107872:	85 db                	test   %ebx,%ebx
80107874:	75 40                	jne    801078b6 <copyout+0x56>
80107876:	eb 70                	jmp    801078e8 <copyout+0x88>
80107878:	90                   	nop
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107880:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107883:	89 f1                	mov    %esi,%ecx
80107885:	29 d1                	sub    %edx,%ecx
80107887:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010788d:	39 d9                	cmp    %ebx,%ecx
8010788f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107892:	29 f2                	sub    %esi,%edx
80107894:	83 ec 04             	sub    $0x4,%esp
80107897:	01 d0                	add    %edx,%eax
80107899:	51                   	push   %ecx
8010789a:	57                   	push   %edi
8010789b:	50                   	push   %eax
8010789c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010789f:	e8 fc d3 ff ff       	call   80104ca0 <memmove>
    len -= n;
    buf += n;
801078a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078a7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801078aa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801078b0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078b2:	29 cb                	sub    %ecx,%ebx
801078b4:	74 32                	je     801078e8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801078b6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801078b8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801078bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801078be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801078c4:	56                   	push   %esi
801078c5:	ff 75 08             	pushl  0x8(%ebp)
801078c8:	e8 53 ff ff ff       	call   80107820 <uva2ka>
    if(pa0 == 0)
801078cd:	83 c4 10             	add    $0x10,%esp
801078d0:	85 c0                	test   %eax,%eax
801078d2:	75 ac                	jne    80107880 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801078d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801078d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801078dc:	5b                   	pop    %ebx
801078dd:	5e                   	pop    %esi
801078de:	5f                   	pop    %edi
801078df:	5d                   	pop    %ebp
801078e0:	c3                   	ret    
801078e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801078eb:	31 c0                	xor    %eax,%eax
}
801078ed:	5b                   	pop    %ebx
801078ee:	5e                   	pop    %esi
801078ef:	5f                   	pop    %edi
801078f0:	5d                   	pop    %ebp
801078f1:	c3                   	ret    
