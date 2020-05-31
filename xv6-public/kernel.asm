
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
8010002d:	b8 f0 31 10 80       	mov    $0x801031f0,%eax
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
8010004c:	68 80 76 10 80       	push   $0x80107680
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 05 47 00 00       	call   80104760 <initlock>

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
80100092:	68 87 76 10 80       	push   $0x80107687
80100097:	50                   	push   %eax
80100098:	e8 93 45 00 00       	call   80104630 <initsleeplock>
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
801000e4:	e8 d7 47 00 00       	call   801048c0 <acquire>

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
80100162:	e8 09 48 00 00       	call   80104970 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 44 00 00       	call   80104670 <acquiresleep>
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
8010017e:	e8 fd 22 00 00       	call   80102480 <iderw>
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
80100193:	68 8e 76 10 80       	push   $0x8010768e
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
801001ae:	e8 5d 45 00 00       	call   80104710 <holdingsleep>
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
801001c4:	e9 b7 22 00 00       	jmp    80102480 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 76 10 80       	push   $0x8010769f
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
801001ef:	e8 1c 45 00 00       	call   80104710 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 44 00 00       	call   801046d0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 b0 46 00 00       	call   801048c0 <acquire>
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
8010025c:	e9 0f 47 00 00       	jmp    80104970 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 76 10 80       	push   $0x801076a6
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
80100280:	e8 5b 18 00 00       	call   80101ae0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 2f 46 00 00       	call   801048c0 <acquire>
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
801002bd:	e8 fe 3f 00 00       	call   801042c0 <sleep>

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
801002d2:	e8 69 38 00 00       	call   80103b40 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 85 46 00 00       	call   80104970 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 0d 17 00 00       	call   80101a00 <ilock>
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
80100346:	e8 25 46 00 00       	call   80104970 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 ad 16 00 00       	call   80101a00 <ilock>

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
80100389:	e8 f2 26 00 00       	call   80102a80 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ad 76 10 80       	push   $0x801076ad
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 0b 80 10 80 	movl   $0x8010800b,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 c3 43 00 00       	call   80104780 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 c1 76 10 80       	push   $0x801076c1
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
8010041a:	e8 11 5e 00 00       	call   80106230 <uartputc>
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
801004d3:	e8 58 5d 00 00       	call   80106230 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 4c 5d 00 00       	call   80106230 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 40 5d 00 00       	call   80106230 <uartputc>
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
80100514:	e8 57 45 00 00       	call   80104a70 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 92 44 00 00       	call   801049c0 <memset>
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
80100540:	68 c5 76 10 80       	push   $0x801076c5
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
801005b1:	0f b6 92 f0 76 10 80 	movzbl -0x7fef8910(%edx),%edx
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
8010060f:	e8 cc 14 00 00       	call   80101ae0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 a0 42 00 00       	call   801048c0 <acquire>
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
80100647:	e8 24 43 00 00       	call   80104970 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 ab 13 00 00       	call   80101a00 <ilock>

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
8010070d:	e8 5e 42 00 00       	call   80104970 <release>
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
80100788:	b8 d8 76 10 80       	mov    $0x801076d8,%eax
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
801007c8:	e8 f3 40 00 00       	call   801048c0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 df 76 10 80       	push   $0x801076df
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
80100803:	e8 b8 40 00 00       	call   801048c0 <acquire>
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
80100868:	e8 03 41 00 00       	call   80104970 <release>
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
801008f6:	e8 85 3b 00 00       	call   80104480 <wakeup>
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
80100977:	e9 f4 3b 00 00       	jmp    80104570 <procdump>
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
801009a6:	68 e8 76 10 80       	push   $0x801076e8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 ab 3d 00 00       	call   80104760 <initlock>

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
801009d9:	e8 52 1c 00 00       	call   80102630 <ioapicenable>
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
801009fc:	e8 3f 31 00 00       	call   80103b40 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 d4 24 00 00       	call   80102ee0 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 39 18 00 00       	call   80102250 <namei>
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
80100a28:	e8 d3 0f 00 00       	call   80101a00 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 a2 12 00 00       	call   80101ce0 <readi>
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
80100a4a:	e8 41 12 00 00       	call   80101c90 <iunlockput>
    end_op();
80100a4f:	e8 fc 24 00 00       	call   80102f50 <end_op>
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
80100a74:	e8 47 69 00 00       	call   801073c0 <setupkvm>
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
80100ac8:	e8 13 12 00 00       	call   80101ce0 <readi>
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
80100b04:	e8 07 67 00 00       	call   80107210 <allocuvm>
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
80100b3a:	e8 11 66 00 00       	call   80107150 <loaduvm>
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
80100b59:	e8 e2 67 00 00       	call   80107340 <freevm>
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
80100b6a:	e8 21 11 00 00       	call   80101c90 <iunlockput>
  end_op();
80100b6f:	e8 dc 23 00 00       	call   80102f50 <end_op>
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
80100b95:	e8 76 66 00 00       	call   80107210 <allocuvm>
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
80100bac:	e8 8f 67 00 00       	call   80107340 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 8d 23 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 01 77 10 80       	push   $0x80107701
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
80100bf1:	e8 6a 68 00 00       	call   80107460 <clearpteu>
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
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 ce 3f 00 00       	call   80104c00 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 bb 3f 00 00       	call   80104c00 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 7a 69 00 00       	call   801075d0 <copyout>
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
80100cbb:	e8 10 69 00 00       	call   801075d0 <copyout>
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
80100d00:	e8 bb 3e 00 00       	call   80104bc0 <safestrcpy>

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
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 8f 62 00 00       	call   80106fc0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 07 66 00 00       	call   80107340 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100d50 <exec2>:
}


int
exec2(char *path, char **argv, int stacksize)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	57                   	push   %edi
80100d54:	56                   	push   %esi
80100d55:	53                   	push   %ebx
80100d56:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d5c:	e8 df 2d 00 00       	call   80103b40 <myproc>

  //admin mode가 아닐때
  if (curproc->admin_mode==0){
80100d61:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80100d67:	85 c9                	test   %ecx,%ecx
80100d69:	0f 84 c2 00 00 00    	je     80100e31 <exec2+0xe1>
80100d6f:	89 c6                	mov    %eax,%esi
    return -1;
  }

  begin_op();
80100d71:	e8 6a 21 00 00       	call   80102ee0 <begin_op>

  if((ip = namei(path)) == 0){
80100d76:	83 ec 0c             	sub    $0xc,%esp
80100d79:	ff 75 08             	pushl  0x8(%ebp)
80100d7c:	e8 cf 14 00 00       	call   80102250 <namei>
80100d81:	83 c4 10             	add    $0x10,%esp
80100d84:	85 c0                	test   %eax,%eax
80100d86:	89 c3                	mov    %eax,%ebx
80100d88:	0f 84 c0 01 00 00    	je     80100f4e <exec2+0x1fe>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100d8e:	83 ec 0c             	sub    $0xc,%esp
80100d91:	50                   	push   %eax
80100d92:	e8 69 0c 00 00       	call   80101a00 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100d97:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100d9d:	6a 34                	push   $0x34
80100d9f:	6a 00                	push   $0x0
80100da1:	50                   	push   %eax
80100da2:	53                   	push   %ebx
80100da3:	e8 38 0f 00 00       	call   80101ce0 <readi>
80100da8:	83 c4 20             	add    $0x20,%esp
80100dab:	83 f8 34             	cmp    $0x34,%eax
80100dae:	0f 84 8c 00 00 00    	je     80100e40 <exec2+0xf0>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100db4:	83 ec 0c             	sub    $0xc,%esp
80100db7:	53                   	push   %ebx
80100db8:	e8 d3 0e 00 00       	call   80101c90 <iunlockput>
    end_op();
80100dbd:	e8 8e 21 00 00       	call   80102f50 <end_op>
80100dc2:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dcd:	5b                   	pop    %ebx
80100dce:	5e                   	pop    %esi
80100dcf:	5f                   	pop    %edi
80100dd0:	5d                   	pop    %ebp
80100dd1:	c3                   	ret    
80100dd2:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100dd8:	83 ec 0c             	sub    $0xc,%esp
80100ddb:	53                   	push   %ebx
80100ddc:	e8 af 0e 00 00       	call   80101c90 <iunlockput>
  end_op();
80100de1:	e8 6a 21 00 00       	call   80102f50 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100de6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*stacksize*PGSIZE)) == 0)
80100dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100def:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100df2:	05 ff 0f 00 00       	add    $0xfff,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*stacksize*PGSIZE)) == 0)
80100df7:	c1 e3 0d             	shl    $0xd,%ebx
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100dfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*stacksize*PGSIZE)) == 0)
80100dff:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100e02:	52                   	push   %edx
80100e03:	50                   	push   %eax
80100e04:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e0a:	e8 01 64 00 00       	call   80107210 <allocuvm>
80100e0f:	83 c4 10             	add    $0x10,%esp
80100e12:	85 c0                	test   %eax,%eax
80100e14:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e1a:	0f 85 48 01 00 00    	jne    80100f68 <exec2+0x218>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100e20:	83 ec 0c             	sub    $0xc,%esp
80100e23:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e29:	e8 12 65 00 00       	call   80107340 <freevm>
80100e2e:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e39:	5b                   	pop    %ebx
80100e3a:	5e                   	pop    %esi
80100e3b:	5f                   	pop    %edi
80100e3c:	5d                   	pop    %ebp
80100e3d:	c3                   	ret    
80100e3e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100e40:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e47:	45 4c 46 
80100e4a:	0f 85 64 ff ff ff    	jne    80100db4 <exec2+0x64>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100e50:	e8 6b 65 00 00       	call   801073c0 <setupkvm>
80100e55:	85 c0                	test   %eax,%eax
80100e57:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e5d:	0f 84 51 ff ff ff    	je     80100db4 <exec2+0x64>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e63:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e6a:	00 
80100e6b:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100e71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e78:	00 00 00 
80100e7b:	0f 84 57 ff ff ff    	je     80100dd8 <exec2+0x88>
80100e81:	31 c0                	xor    %eax,%eax
80100e83:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100e89:	89 c6                	mov    %eax,%esi
80100e8b:	eb 18                	jmp    80100ea5 <exec2+0x155>
80100e8d:	8d 76 00             	lea    0x0(%esi),%esi
80100e90:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e97:	83 c6 01             	add    $0x1,%esi
80100e9a:	83 c7 20             	add    $0x20,%edi
80100e9d:	39 f0                	cmp    %esi,%eax
80100e9f:	0f 8e 2d ff ff ff    	jle    80100dd2 <exec2+0x82>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ea5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100eab:	6a 20                	push   $0x20
80100ead:	57                   	push   %edi
80100eae:	50                   	push   %eax
80100eaf:	53                   	push   %ebx
80100eb0:	e8 2b 0e 00 00       	call   80101ce0 <readi>
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	83 f8 20             	cmp    $0x20,%eax
80100ebb:	75 7b                	jne    80100f38 <exec2+0x1e8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ebd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ec4:	75 ca                	jne    80100e90 <exec2+0x140>
      continue;
    if(ph.memsz < ph.filesz)
80100ec6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ecc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ed2:	72 64                	jb     80100f38 <exec2+0x1e8>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ed4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100eda:	72 5c                	jb     80100f38 <exec2+0x1e8>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100edc:	83 ec 04             	sub    $0x4,%esp
80100edf:	50                   	push   %eax
80100ee0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ee6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100eec:	e8 1f 63 00 00       	call   80107210 <allocuvm>
80100ef1:	83 c4 10             	add    $0x10,%esp
80100ef4:	85 c0                	test   %eax,%eax
80100ef6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100efc:	74 3a                	je     80100f38 <exec2+0x1e8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100efe:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f04:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f09:	75 2d                	jne    80100f38 <exec2+0x1e8>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f0b:	83 ec 0c             	sub    $0xc,%esp
80100f0e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100f14:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100f1a:	53                   	push   %ebx
80100f1b:	50                   	push   %eax
80100f1c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f22:	e8 29 62 00 00       	call   80107150 <loaduvm>
80100f27:	83 c4 20             	add    $0x20,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	0f 89 5e ff ff ff    	jns    80100e90 <exec2+0x140>
80100f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100f38:	83 ec 0c             	sub    $0xc,%esp
80100f3b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f41:	e8 fa 63 00 00       	call   80107340 <freevm>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	e9 66 fe ff ff       	jmp    80100db4 <exec2+0x64>
  }

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100f4e:	e8 fd 1f 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100f53:	83 ec 0c             	sub    $0xc,%esp
80100f56:	68 01 77 10 80       	push   $0x80107701
80100f5b:	e8 00 f7 ff ff       	call   80100660 <cprintf>
    return -1;
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	e9 c9 fe ff ff       	jmp    80100e31 <exec2+0xe1>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*stacksize*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*stacksize*PGSIZE));
80100f68:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100f6e:	83 ec 08             	sub    $0x8,%esp
80100f71:	89 f8                	mov    %edi,%eax
80100f73:	29 d8                	sub    %ebx,%eax
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f75:	89 fb                	mov    %edi,%ebx
80100f77:	31 ff                	xor    %edi,%edi
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*stacksize*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*stacksize*PGSIZE));
80100f79:	50                   	push   %eax
80100f7a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f80:	e8 db 64 00 00       	call   80107460 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f88:	83 c4 10             	add    $0x10,%esp
80100f8b:	8b 00                	mov    (%eax),%eax
80100f8d:	85 c0                	test   %eax,%eax
80100f8f:	0f 84 3c 01 00 00    	je     801010d1 <exec2+0x381>
80100f95:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100f9b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100fa1:	eb 0e                	jmp    80100fb1 <exec2+0x261>
80100fa3:	90                   	nop
80100fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100fa8:	83 ff 20             	cmp    $0x20,%edi
80100fab:	0f 84 6f fe ff ff    	je     80100e20 <exec2+0xd0>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fb1:	83 ec 0c             	sub    $0xc,%esp
80100fb4:	50                   	push   %eax
80100fb5:	e8 46 3c 00 00       	call   80104c00 <strlen>
80100fba:	f7 d0                	not    %eax
80100fbc:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fc1:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fc2:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fc5:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fc8:	e8 33 3c 00 00       	call   80104c00 <strlen>
80100fcd:	83 c0 01             	add    $0x1,%eax
80100fd0:	50                   	push   %eax
80100fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fd4:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fd7:	53                   	push   %ebx
80100fd8:	56                   	push   %esi
80100fd9:	e8 f2 65 00 00       	call   801075d0 <copyout>
80100fde:	83 c4 20             	add    $0x20,%esp
80100fe1:	85 c0                	test   %eax,%eax
80100fe3:	0f 88 37 fe ff ff    	js     80100e20 <exec2+0xd0>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*stacksize*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100fec:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*stacksize*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ff3:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100ff6:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*stacksize*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ffc:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100fff:	85 c0                	test   %eax,%eax
80101001:	75 a5                	jne    80100fa8 <exec2+0x258>
80101003:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101009:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101010:	89 da                	mov    %ebx,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80101012:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101019:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
8010101d:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101024:	ff ff ff 
  ustack[1] = argc;
80101027:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010102d:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
8010102f:	83 c0 0c             	add    $0xc,%eax
80101032:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101034:	50                   	push   %eax
80101035:	51                   	push   %ecx
80101036:	53                   	push   %ebx
80101037:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010103d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101043:	e8 88 65 00 00       	call   801075d0 <copyout>
80101048:	83 c4 10             	add    $0x10,%esp
8010104b:	85 c0                	test   %eax,%eax
8010104d:	0f 88 cd fd ff ff    	js     80100e20 <exec2+0xd0>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101053:	8b 45 08             	mov    0x8(%ebp),%eax
80101056:	0f b6 10             	movzbl (%eax),%edx
80101059:	84 d2                	test   %dl,%dl
8010105b:	74 19                	je     80101076 <exec2+0x326>
8010105d:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80101060:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101063:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80101066:	89 c1                	mov    %eax,%ecx
80101068:	0f 45 4d 08          	cmovne 0x8(%ebp),%ecx
8010106c:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
8010106f:	84 d2                	test   %dl,%dl
    if(*s == '/')
      last = s+1;
80101071:	89 4d 08             	mov    %ecx,0x8(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101074:	75 ea                	jne    80101060 <exec2+0x310>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101076:	50                   	push   %eax
80101077:	8d 46 6c             	lea    0x6c(%esi),%eax
8010107a:	6a 10                	push   $0x10
8010107c:	ff 75 08             	pushl  0x8(%ebp)
8010107f:	50                   	push   %eax
80101080:	e8 3b 3b 00 00       	call   80104bc0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80101085:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80101088:	8b 56 18             	mov    0x18(%esi),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
8010108b:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80101091:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80101097:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
8010109a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010a0:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
801010a2:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
801010a8:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
801010ab:	8b 56 18             	mov    0x18(%esi),%edx
801010ae:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(curproc);
801010b1:	89 34 24             	mov    %esi,(%esp)
801010b4:	e8 07 5f 00 00       	call   80106fc0 <switchuvm>
  freevm(oldpgdir);
801010b9:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010bf:	89 04 24             	mov    %eax,(%esp)
801010c2:	e8 79 62 00 00       	call   80107340 <freevm>
  return 0;
801010c7:	83 c4 10             	add    $0x10,%esp
801010ca:	31 c0                	xor    %eax,%eax
801010cc:	e9 f9 fc ff ff       	jmp    80100dca <exec2+0x7a>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*stacksize*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
801010d1:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
801010d7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801010dd:	e9 27 ff ff ff       	jmp    80101009 <exec2+0x2b9>
801010e2:	66 90                	xchg   %ax,%ax
801010e4:	66 90                	xchg   %ax,%ax
801010e6:	66 90                	xchg   %ax,%ax
801010e8:	66 90                	xchg   %ax,%ax
801010ea:	66 90                	xchg   %ax,%ax
801010ec:	66 90                	xchg   %ax,%ax
801010ee:	66 90                	xchg   %ax,%ax

801010f0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801010f6:	68 0d 77 10 80       	push   $0x8010770d
801010fb:	68 c0 0f 11 80       	push   $0x80110fc0
80101100:	e8 5b 36 00 00       	call   80104760 <initlock>
}
80101105:	83 c4 10             	add    $0x10,%esp
80101108:	c9                   	leave  
80101109:	c3                   	ret    
8010110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101110 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101114:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80101119:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
8010111c:	68 c0 0f 11 80       	push   $0x80110fc0
80101121:	e8 9a 37 00 00       	call   801048c0 <acquire>
80101126:	83 c4 10             	add    $0x10,%esp
80101129:	eb 10                	jmp    8010113b <filealloc+0x2b>
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101130:	83 c3 18             	add    $0x18,%ebx
80101133:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80101139:	74 25                	je     80101160 <filealloc+0x50>
    if(f->ref == 0){
8010113b:	8b 43 04             	mov    0x4(%ebx),%eax
8010113e:	85 c0                	test   %eax,%eax
80101140:	75 ee                	jne    80101130 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101142:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80101145:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010114c:	68 c0 0f 11 80       	push   $0x80110fc0
80101151:	e8 1a 38 00 00       	call   80104970 <release>
      return f;
80101156:	89 d8                	mov    %ebx,%eax
80101158:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
8010115b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010115e:	c9                   	leave  
8010115f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 c0 0f 11 80       	push   $0x80110fc0
80101168:	e8 03 38 00 00       	call   80104970 <release>
  return 0;
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	31 c0                	xor    %eax,%eax
}
80101172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101175:	c9                   	leave  
80101176:	c3                   	ret    
80101177:	89 f6                	mov    %esi,%esi
80101179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101180 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	53                   	push   %ebx
80101184:	83 ec 10             	sub    $0x10,%esp
80101187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010118a:	68 c0 0f 11 80       	push   $0x80110fc0
8010118f:	e8 2c 37 00 00       	call   801048c0 <acquire>
  if(f->ref < 1)
80101194:	8b 43 04             	mov    0x4(%ebx),%eax
80101197:	83 c4 10             	add    $0x10,%esp
8010119a:	85 c0                	test   %eax,%eax
8010119c:	7e 1a                	jle    801011b8 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010119e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011a1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
801011a4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011a7:	68 c0 0f 11 80       	push   $0x80110fc0
801011ac:	e8 bf 37 00 00       	call   80104970 <release>
  return f;
}
801011b1:	89 d8                	mov    %ebx,%eax
801011b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011b6:	c9                   	leave  
801011b7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
801011b8:	83 ec 0c             	sub    $0xc,%esp
801011bb:	68 14 77 10 80       	push   $0x80107714
801011c0:	e8 ab f1 ff ff       	call   80100370 <panic>
801011c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011d0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	83 ec 28             	sub    $0x28,%esp
801011d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
801011dc:	68 c0 0f 11 80       	push   $0x80110fc0
801011e1:	e8 da 36 00 00       	call   801048c0 <acquire>
  if(f->ref < 1)
801011e6:	8b 47 04             	mov    0x4(%edi),%eax
801011e9:	83 c4 10             	add    $0x10,%esp
801011ec:	85 c0                	test   %eax,%eax
801011ee:	0f 8e 9b 00 00 00    	jle    8010128f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
801011f4:	83 e8 01             	sub    $0x1,%eax
801011f7:	85 c0                	test   %eax,%eax
801011f9:	89 47 04             	mov    %eax,0x4(%edi)
801011fc:	74 1a                	je     80101218 <fileclose+0x48>
    release(&ftable.lock);
801011fe:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101208:	5b                   	pop    %ebx
80101209:	5e                   	pop    %esi
8010120a:	5f                   	pop    %edi
8010120b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
8010120c:	e9 5f 37 00 00       	jmp    80104970 <release>
80101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80101218:	0f b6 47 09          	movzbl 0x9(%edi),%eax
8010121c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
8010121e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101221:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80101224:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010122a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010122d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101230:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101235:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101238:	e8 33 37 00 00       	call   80104970 <release>

  if(ff.type == FD_PIPE)
8010123d:	83 c4 10             	add    $0x10,%esp
80101240:	83 fb 01             	cmp    $0x1,%ebx
80101243:	74 13                	je     80101258 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101245:	83 fb 02             	cmp    $0x2,%ebx
80101248:	74 26                	je     80101270 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010124a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010124d:	5b                   	pop    %ebx
8010124e:	5e                   	pop    %esi
8010124f:	5f                   	pop    %edi
80101250:	5d                   	pop    %ebp
80101251:	c3                   	ret    
80101252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80101258:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010125c:	83 ec 08             	sub    $0x8,%esp
8010125f:	53                   	push   %ebx
80101260:	56                   	push   %esi
80101261:	e8 1a 24 00 00       	call   80103680 <pipeclose>
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	eb df                	jmp    8010124a <fileclose+0x7a>
8010126b:	90                   	nop
8010126c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101270:	e8 6b 1c 00 00       	call   80102ee0 <begin_op>
    iput(ff.ip);
80101275:	83 ec 0c             	sub    $0xc,%esp
80101278:	ff 75 e0             	pushl  -0x20(%ebp)
8010127b:	e8 b0 08 00 00       	call   80101b30 <iput>
    end_op();
80101280:	83 c4 10             	add    $0x10,%esp
  }
}
80101283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101286:	5b                   	pop    %ebx
80101287:	5e                   	pop    %esi
80101288:	5f                   	pop    %edi
80101289:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
8010128a:	e9 c1 1c 00 00       	jmp    80102f50 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010128f:	83 ec 0c             	sub    $0xc,%esp
80101292:	68 1c 77 10 80       	push   $0x8010771c
80101297:	e8 d4 f0 ff ff       	call   80100370 <panic>
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012a0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	53                   	push   %ebx
801012a4:	83 ec 04             	sub    $0x4,%esp
801012a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012aa:	83 3b 02             	cmpl   $0x2,(%ebx)
801012ad:	75 31                	jne    801012e0 <filestat+0x40>
    ilock(f->ip);
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	ff 73 10             	pushl  0x10(%ebx)
801012b5:	e8 46 07 00 00       	call   80101a00 <ilock>
    stati(f->ip, st);
801012ba:	58                   	pop    %eax
801012bb:	5a                   	pop    %edx
801012bc:	ff 75 0c             	pushl  0xc(%ebp)
801012bf:	ff 73 10             	pushl  0x10(%ebx)
801012c2:	e8 e9 09 00 00       	call   80101cb0 <stati>
    iunlock(f->ip);
801012c7:	59                   	pop    %ecx
801012c8:	ff 73 10             	pushl  0x10(%ebx)
801012cb:	e8 10 08 00 00       	call   80101ae0 <iunlock>
    return 0;
801012d0:	83 c4 10             	add    $0x10,%esp
801012d3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012d8:	c9                   	leave  
801012d9:	c3                   	ret    
801012da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
801012e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012e8:	c9                   	leave  
801012e9:	c3                   	ret    
801012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801012f0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	83 ec 0c             	sub    $0xc,%esp
801012f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801012fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801012ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101302:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101306:	74 60                	je     80101368 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101308:	8b 03                	mov    (%ebx),%eax
8010130a:	83 f8 01             	cmp    $0x1,%eax
8010130d:	74 41                	je     80101350 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010130f:	83 f8 02             	cmp    $0x2,%eax
80101312:	75 5b                	jne    8010136f <fileread+0x7f>
    ilock(f->ip);
80101314:	83 ec 0c             	sub    $0xc,%esp
80101317:	ff 73 10             	pushl  0x10(%ebx)
8010131a:	e8 e1 06 00 00       	call   80101a00 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010131f:	57                   	push   %edi
80101320:	ff 73 14             	pushl  0x14(%ebx)
80101323:	56                   	push   %esi
80101324:	ff 73 10             	pushl  0x10(%ebx)
80101327:	e8 b4 09 00 00       	call   80101ce0 <readi>
8010132c:	83 c4 20             	add    $0x20,%esp
8010132f:	85 c0                	test   %eax,%eax
80101331:	89 c6                	mov    %eax,%esi
80101333:	7e 03                	jle    80101338 <fileread+0x48>
      f->off += r;
80101335:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	ff 73 10             	pushl  0x10(%ebx)
8010133e:	e8 9d 07 00 00       	call   80101ae0 <iunlock>
    return r;
80101343:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101346:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134b:	5b                   	pop    %ebx
8010134c:	5e                   	pop    %esi
8010134d:	5f                   	pop    %edi
8010134e:	5d                   	pop    %ebp
8010134f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101350:	8b 43 0c             	mov    0xc(%ebx),%eax
80101353:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101359:	5b                   	pop    %ebx
8010135a:	5e                   	pop    %esi
8010135b:	5f                   	pop    %edi
8010135c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010135d:	e9 be 24 00 00       	jmp    80103820 <piperead>
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010136d:	eb d9                	jmp    80101348 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010136f:	83 ec 0c             	sub    $0xc,%esp
80101372:	68 26 77 10 80       	push   $0x80107726
80101377:	e8 f4 ef ff ff       	call   80100370 <panic>
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101380 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	83 ec 1c             	sub    $0x1c,%esp
80101389:	8b 75 08             	mov    0x8(%ebp),%esi
8010138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010138f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101393:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101396:	8b 45 10             	mov    0x10(%ebp),%eax
80101399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010139c:	0f 84 aa 00 00 00    	je     8010144c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801013a2:	8b 06                	mov    (%esi),%eax
801013a4:	83 f8 01             	cmp    $0x1,%eax
801013a7:	0f 84 c2 00 00 00    	je     8010146f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013ad:	83 f8 02             	cmp    $0x2,%eax
801013b0:	0f 85 d8 00 00 00    	jne    8010148e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801013b9:	31 ff                	xor    %edi,%edi
801013bb:	85 c0                	test   %eax,%eax
801013bd:	7f 34                	jg     801013f3 <filewrite+0x73>
801013bf:	e9 9c 00 00 00       	jmp    80101460 <filewrite+0xe0>
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013c8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801013cb:	83 ec 0c             	sub    $0xc,%esp
801013ce:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013d4:	e8 07 07 00 00       	call   80101ae0 <iunlock>
      end_op();
801013d9:	e8 72 1b 00 00       	call   80102f50 <end_op>
801013de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013e1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801013e4:	39 d8                	cmp    %ebx,%eax
801013e6:	0f 85 95 00 00 00    	jne    80101481 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801013ec:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013ee:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801013f1:	7e 6d                	jle    80101460 <filewrite+0xe0>
      int n1 = n - i;
801013f3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801013f6:	b8 00 06 00 00       	mov    $0x600,%eax
801013fb:	29 fb                	sub    %edi,%ebx
801013fd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101403:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101406:	e8 d5 1a 00 00       	call   80102ee0 <begin_op>
      ilock(f->ip);
8010140b:	83 ec 0c             	sub    $0xc,%esp
8010140e:	ff 76 10             	pushl  0x10(%esi)
80101411:	e8 ea 05 00 00       	call   80101a00 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101416:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101419:	53                   	push   %ebx
8010141a:	ff 76 14             	pushl  0x14(%esi)
8010141d:	01 f8                	add    %edi,%eax
8010141f:	50                   	push   %eax
80101420:	ff 76 10             	pushl  0x10(%esi)
80101423:	e8 b8 09 00 00       	call   80101de0 <writei>
80101428:	83 c4 20             	add    $0x20,%esp
8010142b:	85 c0                	test   %eax,%eax
8010142d:	7f 99                	jg     801013c8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	ff 76 10             	pushl  0x10(%esi)
80101435:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101438:	e8 a3 06 00 00       	call   80101ae0 <iunlock>
      end_op();
8010143d:	e8 0e 1b 00 00       	call   80102f50 <end_op>

      if(r < 0)
80101442:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101445:	83 c4 10             	add    $0x10,%esp
80101448:	85 c0                	test   %eax,%eax
8010144a:	74 98                	je     801013e4 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010144f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
80101459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101460:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101463:	75 e7                	jne    8010144c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101465:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101468:	89 f8                	mov    %edi,%eax
8010146a:	5b                   	pop    %ebx
8010146b:	5e                   	pop    %esi
8010146c:	5f                   	pop    %edi
8010146d:	5d                   	pop    %ebp
8010146e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010146f:	8b 46 0c             	mov    0xc(%esi),%eax
80101472:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101475:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101478:	5b                   	pop    %ebx
80101479:	5e                   	pop    %esi
8010147a:	5f                   	pop    %edi
8010147b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010147c:	e9 9f 22 00 00       	jmp    80103720 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 2f 77 10 80       	push   $0x8010772f
80101489:	e8 e2 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010148e:	83 ec 0c             	sub    $0xc,%esp
80101491:	68 35 77 10 80       	push   $0x80107735
80101496:	e8 d5 ee ff ff       	call   80100370 <panic>
8010149b:	66 90                	xchg   %ax,%ax
8010149d:	66 90                	xchg   %ax,%ax
8010149f:	90                   	nop

801014a0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	53                   	push   %ebx
801014a5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014a7:	c1 ea 0c             	shr    $0xc,%edx
801014aa:	03 15 d8 19 11 80    	add    0x801119d8,%edx
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	52                   	push   %edx
801014b4:	50                   	push   %eax
801014b5:	e8 16 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014ba:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014bc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014c2:	ba 01 00 00 00       	mov    $0x1,%edx
801014c7:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ca:	c1 fb 03             	sar    $0x3,%ebx
801014cd:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014d0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014d2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014d7:	85 d1                	test   %edx,%ecx
801014d9:	74 27                	je     80101502 <bfree+0x62>
801014db:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014dd:	f7 d2                	not    %edx
801014df:	89 c8                	mov    %ecx,%eax
  log_write(bp);
801014e1:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014e4:	21 d0                	and    %edx,%eax
801014e6:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014ea:	56                   	push   %esi
801014eb:	e8 d0 1b 00 00       	call   801030c0 <log_write>
  brelse(bp);
801014f0:	89 34 24             	mov    %esi,(%esp)
801014f3:	e8 e8 ec ff ff       	call   801001e0 <brelse>
}
801014f8:	83 c4 10             	add    $0x10,%esp
801014fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014fe:	5b                   	pop    %ebx
801014ff:	5e                   	pop    %esi
80101500:	5d                   	pop    %ebp
80101501:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101502:	83 ec 0c             	sub    $0xc,%esp
80101505:	68 3f 77 10 80       	push   $0x8010773f
8010150a:	e8 61 ee ff ff       	call   80100370 <panic>
8010150f:	90                   	nop

80101510 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101519:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010151f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101522:	85 c9                	test   %ecx,%ecx
80101524:	0f 84 85 00 00 00    	je     801015af <balloc+0x9f>
8010152a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101531:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101534:	83 ec 08             	sub    $0x8,%esp
80101537:	89 f0                	mov    %esi,%eax
80101539:	c1 f8 0c             	sar    $0xc,%eax
8010153c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101542:	50                   	push   %eax
80101543:	ff 75 d8             	pushl  -0x28(%ebp)
80101546:	e8 85 eb ff ff       	call   801000d0 <bread>
8010154b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010154e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101553:	83 c4 10             	add    $0x10,%esp
80101556:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101559:	31 c0                	xor    %eax,%eax
8010155b:	eb 2d                	jmp    8010158a <balloc+0x7a>
8010155d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101560:	89 c1                	mov    %eax,%ecx
80101562:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101567:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010156a:	83 e1 07             	and    $0x7,%ecx
8010156d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010156f:	89 c1                	mov    %eax,%ecx
80101571:	c1 f9 03             	sar    $0x3,%ecx
80101574:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101579:	85 d7                	test   %edx,%edi
8010157b:	74 43                	je     801015c0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010157d:	83 c0 01             	add    $0x1,%eax
80101580:	83 c6 01             	add    $0x1,%esi
80101583:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101588:	74 05                	je     8010158f <balloc+0x7f>
8010158a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010158d:	72 d1                	jb     80101560 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010158f:	83 ec 0c             	sub    $0xc,%esp
80101592:	ff 75 e4             	pushl  -0x1c(%ebp)
80101595:	e8 46 ec ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010159a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015a1:	83 c4 10             	add    $0x10,%esp
801015a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015a7:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801015ad:	77 82                	ja     80101531 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015af:	83 ec 0c             	sub    $0xc,%esp
801015b2:	68 52 77 10 80       	push   $0x80107752
801015b7:	e8 b4 ed ff ff       	call   80100370 <panic>
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801015c0:	09 fa                	or     %edi,%edx
801015c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015c5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801015c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015cc:	57                   	push   %edi
801015cd:	e8 ee 1a 00 00       	call   801030c0 <log_write>
        brelse(bp);
801015d2:	89 3c 24             	mov    %edi,(%esp)
801015d5:	e8 06 ec ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801015da:	58                   	pop    %eax
801015db:	5a                   	pop    %edx
801015dc:	56                   	push   %esi
801015dd:	ff 75 d8             	pushl  -0x28(%ebp)
801015e0:	e8 eb ea ff ff       	call   801000d0 <bread>
801015e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801015e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ea:	83 c4 0c             	add    $0xc,%esp
801015ed:	68 00 02 00 00       	push   $0x200
801015f2:	6a 00                	push   $0x0
801015f4:	50                   	push   %eax
801015f5:	e8 c6 33 00 00       	call   801049c0 <memset>
  log_write(bp);
801015fa:	89 1c 24             	mov    %ebx,(%esp)
801015fd:	e8 be 1a 00 00       	call   801030c0 <log_write>
  brelse(bp);
80101602:	89 1c 24             	mov    %ebx,(%esp)
80101605:	e8 d6 eb ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010160a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010160d:	89 f0                	mov    %esi,%eax
8010160f:	5b                   	pop    %ebx
80101610:	5e                   	pop    %esi
80101611:	5f                   	pop    %edi
80101612:	5d                   	pop    %ebp
80101613:	c3                   	ret    
80101614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010161a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101620 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101628:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010162a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010162f:	83 ec 28             	sub    $0x28,%esp
80101632:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101635:	68 e0 19 11 80       	push   $0x801119e0
8010163a:	e8 81 32 00 00       	call   801048c0 <acquire>
8010163f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101642:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101645:	eb 1b                	jmp    80101662 <iget+0x42>
80101647:	89 f6                	mov    %esi,%esi
80101649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101650:	85 f6                	test   %esi,%esi
80101652:	74 44                	je     80101698 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101654:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010165a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101660:	74 4e                	je     801016b0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101662:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101665:	85 c9                	test   %ecx,%ecx
80101667:	7e e7                	jle    80101650 <iget+0x30>
80101669:	39 3b                	cmp    %edi,(%ebx)
8010166b:	75 e3                	jne    80101650 <iget+0x30>
8010166d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101670:	75 de                	jne    80101650 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101672:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101675:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101678:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010167a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010167f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101682:	e8 e9 32 00 00       	call   80104970 <release>
      return ip;
80101687:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010168a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010168d:	89 f0                	mov    %esi,%eax
8010168f:	5b                   	pop    %ebx
80101690:	5e                   	pop    %esi
80101691:	5f                   	pop    %edi
80101692:	5d                   	pop    %ebp
80101693:	c3                   	ret    
80101694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101698:	85 c9                	test   %ecx,%ecx
8010169a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010169d:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016a3:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801016a9:	75 b7                	jne    80101662 <iget+0x42>
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801016b0:	85 f6                	test   %esi,%esi
801016b2:	74 2d                	je     801016e1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801016b4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801016b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801016b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801016bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016ca:	68 e0 19 11 80       	push   $0x801119e0
801016cf:	e8 9c 32 00 00       	call   80104970 <release>

  return ip;
801016d4:	83 c4 10             	add    $0x10,%esp
}
801016d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016da:	89 f0                	mov    %esi,%eax
801016dc:	5b                   	pop    %ebx
801016dd:	5e                   	pop    %esi
801016de:	5f                   	pop    %edi
801016df:	5d                   	pop    %ebp
801016e0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801016e1:	83 ec 0c             	sub    $0xc,%esp
801016e4:	68 68 77 10 80       	push   $0x80107768
801016e9:	e8 82 ec ff ff       	call   80100370 <panic>
801016ee:	66 90                	xchg   %ax,%ax

801016f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	57                   	push   %edi
801016f4:	56                   	push   %esi
801016f5:	53                   	push   %ebx
801016f6:	89 c6                	mov    %eax,%esi
801016f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801016fb:	83 fa 0b             	cmp    $0xb,%edx
801016fe:	77 18                	ja     80101718 <bmap+0x28>
80101700:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101703:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101706:	85 c0                	test   %eax,%eax
80101708:	74 76                	je     80101780 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010170a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010170d:	5b                   	pop    %ebx
8010170e:	5e                   	pop    %esi
8010170f:	5f                   	pop    %edi
80101710:	5d                   	pop    %ebp
80101711:	c3                   	ret    
80101712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101718:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010171b:	83 fb 7f             	cmp    $0x7f,%ebx
8010171e:	0f 87 83 00 00 00    	ja     801017a7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101724:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010172a:	85 c0                	test   %eax,%eax
8010172c:	74 6a                	je     80101798 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010172e:	83 ec 08             	sub    $0x8,%esp
80101731:	50                   	push   %eax
80101732:	ff 36                	pushl  (%esi)
80101734:	e8 97 e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101739:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010173d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101740:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101742:	8b 1a                	mov    (%edx),%ebx
80101744:	85 db                	test   %ebx,%ebx
80101746:	75 1d                	jne    80101765 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101748:	8b 06                	mov    (%esi),%eax
8010174a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010174d:	e8 be fd ff ff       	call   80101510 <balloc>
80101752:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101755:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101758:	89 c3                	mov    %eax,%ebx
8010175a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010175c:	57                   	push   %edi
8010175d:	e8 5e 19 00 00       	call   801030c0 <log_write>
80101762:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101765:	83 ec 0c             	sub    $0xc,%esp
80101768:	57                   	push   %edi
80101769:	e8 72 ea ff ff       	call   801001e0 <brelse>
8010176e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101771:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101774:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101776:	5b                   	pop    %ebx
80101777:	5e                   	pop    %esi
80101778:	5f                   	pop    %edi
80101779:	5d                   	pop    %ebp
8010177a:	c3                   	ret    
8010177b:	90                   	nop
8010177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101780:	8b 06                	mov    (%esi),%eax
80101782:	e8 89 fd ff ff       	call   80101510 <balloc>
80101787:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010178a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010178d:	5b                   	pop    %ebx
8010178e:	5e                   	pop    %esi
8010178f:	5f                   	pop    %edi
80101790:	5d                   	pop    %ebp
80101791:	c3                   	ret    
80101792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101798:	8b 06                	mov    (%esi),%eax
8010179a:	e8 71 fd ff ff       	call   80101510 <balloc>
8010179f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017a5:	eb 87                	jmp    8010172e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801017a7:	83 ec 0c             	sub    $0xc,%esp
801017aa:	68 78 77 10 80       	push   $0x80107778
801017af:	e8 bc eb ff ff       	call   80100370 <panic>
801017b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017c0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801017c8:	83 ec 08             	sub    $0x8,%esp
801017cb:	6a 01                	push   $0x1
801017cd:	ff 75 08             	pushl  0x8(%ebp)
801017d0:	e8 fb e8 ff ff       	call   801000d0 <bread>
801017d5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801017d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801017da:	83 c4 0c             	add    $0xc,%esp
801017dd:	6a 1c                	push   $0x1c
801017df:	50                   	push   %eax
801017e0:	56                   	push   %esi
801017e1:	e8 8a 32 00 00       	call   80104a70 <memmove>
  brelse(bp);
801017e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801017e9:	83 c4 10             	add    $0x10,%esp
}
801017ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ef:	5b                   	pop    %ebx
801017f0:	5e                   	pop    %esi
801017f1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801017f2:	e9 e9 e9 ff ff       	jmp    801001e0 <brelse>
801017f7:	89 f6                	mov    %esi,%esi
801017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101800 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	53                   	push   %ebx
80101804:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101809:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010180c:	68 8b 77 10 80       	push   $0x8010778b
80101811:	68 e0 19 11 80       	push   $0x801119e0
80101816:	e8 45 2f 00 00       	call   80104760 <initlock>
8010181b:	83 c4 10             	add    $0x10,%esp
8010181e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101820:	83 ec 08             	sub    $0x8,%esp
80101823:	68 92 77 10 80       	push   $0x80107792
80101828:	53                   	push   %ebx
80101829:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010182f:	e8 fc 2d 00 00       	call   80104630 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010183d:	75 e1                	jne    80101820 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010183f:	83 ec 08             	sub    $0x8,%esp
80101842:	68 c0 19 11 80       	push   $0x801119c0
80101847:	ff 75 08             	pushl  0x8(%ebp)
8010184a:	e8 71 ff ff ff       	call   801017c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010184f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101855:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010185b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101861:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101867:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010186d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101873:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101879:	68 f8 77 10 80       	push   $0x801077f8
8010187e:	e8 dd ed ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101883:	83 c4 30             	add    $0x30,%esp
80101886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101889:	c9                   	leave  
8010188a:	c3                   	ret    
8010188b:	90                   	nop
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101899:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801018a3:	8b 75 08             	mov    0x8(%ebp),%esi
801018a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018a9:	0f 86 91 00 00 00    	jbe    80101940 <ialloc+0xb0>
801018af:	bb 01 00 00 00       	mov    $0x1,%ebx
801018b4:	eb 21                	jmp    801018d7 <ialloc+0x47>
801018b6:	8d 76 00             	lea    0x0(%esi),%esi
801018b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801018c0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018c3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801018c6:	57                   	push   %edi
801018c7:	e8 14 e9 ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801018d5:	76 69                	jbe    80101940 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801018d7:	89 d8                	mov    %ebx,%eax
801018d9:	83 ec 08             	sub    $0x8,%esp
801018dc:	c1 e8 03             	shr    $0x3,%eax
801018df:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801018e5:	50                   	push   %eax
801018e6:	56                   	push   %esi
801018e7:	e8 e4 e7 ff ff       	call   801000d0 <bread>
801018ec:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801018ee:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801018f0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801018f3:	83 e0 07             	and    $0x7,%eax
801018f6:	c1 e0 06             	shl    $0x6,%eax
801018f9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801018fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101901:	75 bd                	jne    801018c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101903:	83 ec 04             	sub    $0x4,%esp
80101906:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101909:	6a 40                	push   $0x40
8010190b:	6a 00                	push   $0x0
8010190d:	51                   	push   %ecx
8010190e:	e8 ad 30 00 00       	call   801049c0 <memset>
      dip->type = type;
80101913:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101917:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010191a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010191d:	89 3c 24             	mov    %edi,(%esp)
80101920:	e8 9b 17 00 00       	call   801030c0 <log_write>
      brelse(bp);
80101925:	89 3c 24             	mov    %edi,(%esp)
80101928:	e8 b3 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010192d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101930:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101933:	89 da                	mov    %ebx,%edx
80101935:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101937:	5b                   	pop    %ebx
80101938:	5e                   	pop    %esi
80101939:	5f                   	pop    %edi
8010193a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010193b:	e9 e0 fc ff ff       	jmp    80101620 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101940:	83 ec 0c             	sub    $0xc,%esp
80101943:	68 98 77 10 80       	push   $0x80107798
80101948:	e8 23 ea ff ff       	call   80100370 <panic>
8010194d:	8d 76 00             	lea    0x0(%esi),%esi

80101950 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	56                   	push   %esi
80101954:	53                   	push   %ebx
80101955:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101958:	83 ec 08             	sub    $0x8,%esp
8010195b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010195e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101961:	c1 e8 03             	shr    $0x3,%eax
80101964:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010196a:	50                   	push   %eax
8010196b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010196e:	e8 5d e7 ff ff       	call   801000d0 <bread>
80101973:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101975:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101978:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010197c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010197f:	83 e0 07             	and    $0x7,%eax
80101982:	c1 e0 06             	shl    $0x6,%eax
80101985:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101989:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010198c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101990:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101993:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101997:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010199b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010199f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ad:	6a 34                	push   $0x34
801019af:	53                   	push   %ebx
801019b0:	50                   	push   %eax
801019b1:	e8 ba 30 00 00       	call   80104a70 <memmove>
  log_write(bp);
801019b6:	89 34 24             	mov    %esi,(%esp)
801019b9:	e8 02 17 00 00       	call   801030c0 <log_write>
  brelse(bp);
801019be:	89 75 08             	mov    %esi,0x8(%ebp)
801019c1:	83 c4 10             	add    $0x10,%esp
}
801019c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019c7:	5b                   	pop    %ebx
801019c8:	5e                   	pop    %esi
801019c9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801019ca:	e9 11 e8 ff ff       	jmp    801001e0 <brelse>
801019cf:	90                   	nop

801019d0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	83 ec 10             	sub    $0x10,%esp
801019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801019da:	68 e0 19 11 80       	push   $0x801119e0
801019df:	e8 dc 2e 00 00       	call   801048c0 <acquire>
  ip->ref++;
801019e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019e8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801019ef:	e8 7c 2f 00 00       	call   80104970 <release>
  return ip;
}
801019f4:	89 d8                	mov    %ebx,%eax
801019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019f9:	c9                   	leave  
801019fa:	c3                   	ret    
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	56                   	push   %esi
80101a04:	53                   	push   %ebx
80101a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a08:	85 db                	test   %ebx,%ebx
80101a0a:	0f 84 b7 00 00 00    	je     80101ac7 <ilock+0xc7>
80101a10:	8b 53 08             	mov    0x8(%ebx),%edx
80101a13:	85 d2                	test   %edx,%edx
80101a15:	0f 8e ac 00 00 00    	jle    80101ac7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
80101a1b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a1e:	83 ec 0c             	sub    $0xc,%esp
80101a21:	50                   	push   %eax
80101a22:	e8 49 2c 00 00       	call   80104670 <acquiresleep>

  if(ip->valid == 0){
80101a27:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	85 c0                	test   %eax,%eax
80101a2f:	74 0f                	je     80101a40 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101a31:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a34:	5b                   	pop    %ebx
80101a35:	5e                   	pop    %esi
80101a36:	5d                   	pop    %ebp
80101a37:	c3                   	ret    
80101a38:	90                   	nop
80101a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a40:	8b 43 04             	mov    0x4(%ebx),%eax
80101a43:	83 ec 08             	sub    $0x8,%esp
80101a46:	c1 e8 03             	shr    $0x3,%eax
80101a49:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101a4f:	50                   	push   %eax
80101a50:	ff 33                	pushl  (%ebx)
80101a52:	e8 79 e6 ff ff       	call   801000d0 <bread>
80101a57:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a59:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a5c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a5f:	83 e0 07             	and    $0x7,%eax
80101a62:	c1 e0 06             	shl    $0x6,%eax
80101a65:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a69:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a6c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101a6f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a73:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a77:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a7b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a7f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a83:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a87:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a8b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a8e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a91:	6a 34                	push   $0x34
80101a93:	50                   	push   %eax
80101a94:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a97:	50                   	push   %eax
80101a98:	e8 d3 2f 00 00       	call   80104a70 <memmove>
    brelse(bp);
80101a9d:	89 34 24             	mov    %esi,(%esp)
80101aa0:	e8 3b e7 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101aa5:	83 c4 10             	add    $0x10,%esp
80101aa8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
80101aad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ab4:	0f 85 77 ff ff ff    	jne    80101a31 <ilock+0x31>
      panic("ilock: no type");
80101aba:	83 ec 0c             	sub    $0xc,%esp
80101abd:	68 b0 77 10 80       	push   $0x801077b0
80101ac2:	e8 a9 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101ac7:	83 ec 0c             	sub    $0xc,%esp
80101aca:	68 aa 77 10 80       	push   $0x801077aa
80101acf:	e8 9c e8 ff ff       	call   80100370 <panic>
80101ad4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ada:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ae0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	56                   	push   %esi
80101ae4:	53                   	push   %ebx
80101ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ae8:	85 db                	test   %ebx,%ebx
80101aea:	74 28                	je     80101b14 <iunlock+0x34>
80101aec:	8d 73 0c             	lea    0xc(%ebx),%esi
80101aef:	83 ec 0c             	sub    $0xc,%esp
80101af2:	56                   	push   %esi
80101af3:	e8 18 2c 00 00       	call   80104710 <holdingsleep>
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	85 c0                	test   %eax,%eax
80101afd:	74 15                	je     80101b14 <iunlock+0x34>
80101aff:	8b 43 08             	mov    0x8(%ebx),%eax
80101b02:	85 c0                	test   %eax,%eax
80101b04:	7e 0e                	jle    80101b14 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101b06:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b0c:	5b                   	pop    %ebx
80101b0d:	5e                   	pop    %esi
80101b0e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
80101b0f:	e9 bc 2b 00 00       	jmp    801046d0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	68 bf 77 10 80       	push   $0x801077bf
80101b1c:	e8 4f e8 ff ff       	call   80100370 <panic>
80101b21:	eb 0d                	jmp    80101b30 <iput>
80101b23:	90                   	nop
80101b24:	90                   	nop
80101b25:	90                   	nop
80101b26:	90                   	nop
80101b27:	90                   	nop
80101b28:	90                   	nop
80101b29:	90                   	nop
80101b2a:	90                   	nop
80101b2b:	90                   	nop
80101b2c:	90                   	nop
80101b2d:	90                   	nop
80101b2e:	90                   	nop
80101b2f:	90                   	nop

80101b30 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 28             	sub    $0x28,%esp
80101b39:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
80101b3c:	8d 7e 0c             	lea    0xc(%esi),%edi
80101b3f:	57                   	push   %edi
80101b40:	e8 2b 2b 00 00       	call   80104670 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b45:	8b 56 4c             	mov    0x4c(%esi),%edx
80101b48:	83 c4 10             	add    $0x10,%esp
80101b4b:	85 d2                	test   %edx,%edx
80101b4d:	74 07                	je     80101b56 <iput+0x26>
80101b4f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101b54:	74 32                	je     80101b88 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	57                   	push   %edi
80101b5a:	e8 71 2b 00 00       	call   801046d0 <releasesleep>

  acquire(&icache.lock);
80101b5f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b66:	e8 55 2d 00 00       	call   801048c0 <acquire>
  ip->ref--;
80101b6b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101b6f:	83 c4 10             	add    $0x10,%esp
80101b72:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7c:	5b                   	pop    %ebx
80101b7d:	5e                   	pop    %esi
80101b7e:	5f                   	pop    %edi
80101b7f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101b80:	e9 eb 2d 00 00       	jmp    80104970 <release>
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	68 e0 19 11 80       	push   $0x801119e0
80101b90:	e8 2b 2d 00 00       	call   801048c0 <acquire>
    int r = ip->ref;
80101b95:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101b98:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b9f:	e8 cc 2d 00 00       	call   80104970 <release>
    if(r == 1){
80101ba4:	83 c4 10             	add    $0x10,%esp
80101ba7:	83 fb 01             	cmp    $0x1,%ebx
80101baa:	75 aa                	jne    80101b56 <iput+0x26>
80101bac:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101bb2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bb5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101bb8:	89 cf                	mov    %ecx,%edi
80101bba:	eb 0b                	jmp    80101bc7 <iput+0x97>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bc0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101bc3:	39 fb                	cmp    %edi,%ebx
80101bc5:	74 19                	je     80101be0 <iput+0xb0>
    if(ip->addrs[i]){
80101bc7:	8b 13                	mov    (%ebx),%edx
80101bc9:	85 d2                	test   %edx,%edx
80101bcb:	74 f3                	je     80101bc0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101bcd:	8b 06                	mov    (%esi),%eax
80101bcf:	e8 cc f8 ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
80101bd4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101bda:	eb e4                	jmp    80101bc0 <iput+0x90>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101be0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101be6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101be9:	85 c0                	test   %eax,%eax
80101beb:	75 33                	jne    80101c20 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101bed:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101bf0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101bf7:	56                   	push   %esi
80101bf8:	e8 53 fd ff ff       	call   80101950 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101bfd:	31 c0                	xor    %eax,%eax
80101bff:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101c03:	89 34 24             	mov    %esi,(%esp)
80101c06:	e8 45 fd ff ff       	call   80101950 <iupdate>
      ip->valid = 0;
80101c0b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	e9 3c ff ff ff       	jmp    80101b56 <iput+0x26>
80101c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c20:	83 ec 08             	sub    $0x8,%esp
80101c23:	50                   	push   %eax
80101c24:	ff 36                	pushl  (%esi)
80101c26:	e8 a5 e4 ff ff       	call   801000d0 <bread>
80101c2b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c31:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c37:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101c3a:	83 c4 10             	add    $0x10,%esp
80101c3d:	89 cf                	mov    %ecx,%edi
80101c3f:	eb 0e                	jmp    80101c4f <iput+0x11f>
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101c4b:	39 fb                	cmp    %edi,%ebx
80101c4d:	74 0f                	je     80101c5e <iput+0x12e>
      if(a[j])
80101c4f:	8b 13                	mov    (%ebx),%edx
80101c51:	85 d2                	test   %edx,%edx
80101c53:	74 f3                	je     80101c48 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c55:	8b 06                	mov    (%esi),%eax
80101c57:	e8 44 f8 ff ff       	call   801014a0 <bfree>
80101c5c:	eb ea                	jmp    80101c48 <iput+0x118>
    }
    brelse(bp);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
80101c61:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c64:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c67:	e8 74 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c6c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101c72:	8b 06                	mov    (%esi),%eax
80101c74:	e8 27 f8 ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c79:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101c80:	00 00 00 
80101c83:	83 c4 10             	add    $0x10,%esp
80101c86:	e9 62 ff ff ff       	jmp    80101bed <iput+0xbd>
80101c8b:	90                   	nop
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c90 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	53                   	push   %ebx
80101c94:	83 ec 10             	sub    $0x10,%esp
80101c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c9a:	53                   	push   %ebx
80101c9b:	e8 40 fe ff ff       	call   80101ae0 <iunlock>
  iput(ip);
80101ca0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ca3:	83 c4 10             	add    $0x10,%esp
}
80101ca6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ca9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101caa:	e9 81 fe ff ff       	jmp    80101b30 <iput>
80101caf:	90                   	nop

80101cb0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	8b 55 08             	mov    0x8(%ebp),%edx
80101cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101cb9:	8b 0a                	mov    (%edx),%ecx
80101cbb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cbe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101cc1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101cc4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101cc8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101ccb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101ccf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cd3:	8b 52 58             	mov    0x58(%edx),%edx
80101cd6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101cd9:	5d                   	pop    %ebp
80101cda:	c3                   	ret    
80101cdb:	90                   	nop
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101cef:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101cf7:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101cfa:	8b 7d 14             	mov    0x14(%ebp),%edi
80101cfd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d03:	0f 84 a7 00 00 00    	je     80101db0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d0c:	8b 40 58             	mov    0x58(%eax),%eax
80101d0f:	39 f0                	cmp    %esi,%eax
80101d11:	0f 82 c1 00 00 00    	jb     80101dd8 <readi+0xf8>
80101d17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d1a:	89 fa                	mov    %edi,%edx
80101d1c:	01 f2                	add    %esi,%edx
80101d1e:	0f 82 b4 00 00 00    	jb     80101dd8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d24:	89 c1                	mov    %eax,%ecx
80101d26:	29 f1                	sub    %esi,%ecx
80101d28:	39 d0                	cmp    %edx,%eax
80101d2a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d2d:	31 ff                	xor    %edi,%edi
80101d2f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d31:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d34:	74 6d                	je     80101da3 <readi+0xc3>
80101d36:	8d 76 00             	lea    0x0(%esi),%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d43:	89 f2                	mov    %esi,%edx
80101d45:	c1 ea 09             	shr    $0x9,%edx
80101d48:	89 d8                	mov    %ebx,%eax
80101d4a:	e8 a1 f9 ff ff       	call   801016f0 <bmap>
80101d4f:	83 ec 08             	sub    $0x8,%esp
80101d52:	50                   	push   %eax
80101d53:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d55:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d5a:	e8 71 e3 ff ff       	call   801000d0 <bread>
80101d5f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d64:	89 f1                	mov    %esi,%ecx
80101d66:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101d6c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101d6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101d72:	29 cb                	sub    %ecx,%ebx
80101d74:	29 f8                	sub    %edi,%eax
80101d76:	39 c3                	cmp    %eax,%ebx
80101d78:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d7b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101d7f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d80:	01 df                	add    %ebx,%edi
80101d82:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101d84:	50                   	push   %eax
80101d85:	ff 75 e0             	pushl  -0x20(%ebp)
80101d88:	e8 e3 2c 00 00       	call   80104a70 <memmove>
    brelse(bp);
80101d8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d90:	89 14 24             	mov    %edx,(%esp)
80101d93:	e8 48 e4 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d98:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101da1:	77 9d                	ja     80101d40 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101da3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101da6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da9:	5b                   	pop    %ebx
80101daa:	5e                   	pop    %esi
80101dab:	5f                   	pop    %edi
80101dac:	5d                   	pop    %ebp
80101dad:	c3                   	ret    
80101dae:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101db0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101db4:	66 83 f8 09          	cmp    $0x9,%ax
80101db8:	77 1e                	ja     80101dd8 <readi+0xf8>
80101dba:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101dc1:	85 c0                	test   %eax,%eax
80101dc3:	74 13                	je     80101dd8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101dc5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101dcf:	ff e0                	jmp    *%eax
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ddd:	eb c7                	jmp    80101da6 <readi+0xc6>
80101ddf:	90                   	nop

80101de0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	83 ec 1c             	sub    $0x1c,%esp
80101de9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101def:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101df2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101df7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101dfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101dfd:	8b 75 10             	mov    0x10(%ebp),%esi
80101e00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e03:	0f 84 b7 00 00 00    	je     80101ec0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e0f:	0f 82 eb 00 00 00    	jb     80101f00 <writei+0x120>
80101e15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e18:	89 f8                	mov    %edi,%eax
80101e1a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e1c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e21:	0f 87 d9 00 00 00    	ja     80101f00 <writei+0x120>
80101e27:	39 c6                	cmp    %eax,%esi
80101e29:	0f 87 d1 00 00 00    	ja     80101f00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e2f:	85 ff                	test   %edi,%edi
80101e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e38:	74 78                	je     80101eb2 <writei+0xd2>
80101e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e43:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e45:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e4a:	c1 ea 09             	shr    $0x9,%edx
80101e4d:	89 f8                	mov    %edi,%eax
80101e4f:	e8 9c f8 ff ff       	call   801016f0 <bmap>
80101e54:	83 ec 08             	sub    $0x8,%esp
80101e57:	50                   	push   %eax
80101e58:	ff 37                	pushl  (%edi)
80101e5a:	e8 71 e2 ff ff       	call   801000d0 <bread>
80101e5f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e64:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101e67:	89 f1                	mov    %esi,%ecx
80101e69:	83 c4 0c             	add    $0xc,%esp
80101e6c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101e72:	29 cb                	sub    %ecx,%ebx
80101e74:	39 c3                	cmp    %eax,%ebx
80101e76:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e79:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101e7d:	53                   	push   %ebx
80101e7e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e81:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101e83:	50                   	push   %eax
80101e84:	e8 e7 2b 00 00       	call   80104a70 <memmove>
    log_write(bp);
80101e89:	89 3c 24             	mov    %edi,(%esp)
80101e8c:	e8 2f 12 00 00       	call   801030c0 <log_write>
    brelse(bp);
80101e91:	89 3c 24             	mov    %edi,(%esp)
80101e94:	e8 47 e3 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e99:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e9c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e9f:	83 c4 10             	add    $0x10,%esp
80101ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ea8:	77 96                	ja     80101e40 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101eaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ead:	3b 70 58             	cmp    0x58(%eax),%esi
80101eb0:	77 36                	ja     80101ee8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb8:	5b                   	pop    %ebx
80101eb9:	5e                   	pop    %esi
80101eba:	5f                   	pop    %edi
80101ebb:	5d                   	pop    %ebp
80101ebc:	c3                   	ret    
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ec0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ec4:	66 83 f8 09          	cmp    $0x9,%ax
80101ec8:	77 36                	ja     80101f00 <writei+0x120>
80101eca:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101ed1:	85 c0                	test   %eax,%eax
80101ed3:	74 2b                	je     80101f00 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ed5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101edb:	5b                   	pop    %ebx
80101edc:	5e                   	pop    %esi
80101edd:	5f                   	pop    %edi
80101ede:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101edf:	ff e0                	jmp    *%eax
80101ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101ee8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101eeb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101eee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ef1:	50                   	push   %eax
80101ef2:	e8 59 fa ff ff       	call   80101950 <iupdate>
80101ef7:	83 c4 10             	add    $0x10,%esp
80101efa:	eb b6                	jmp    80101eb2 <writei+0xd2>
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f05:	eb ae                	jmp    80101eb5 <writei+0xd5>
80101f07:	89 f6                	mov    %esi,%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f16:	6a 0e                	push   $0xe
80101f18:	ff 75 0c             	pushl  0xc(%ebp)
80101f1b:	ff 75 08             	pushl  0x8(%ebp)
80101f1e:	e8 cd 2b 00 00       	call   80104af0 <strncmp>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f41:	0f 85 80 00 00 00    	jne    80101fc7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f47:	8b 53 58             	mov    0x58(%ebx),%edx
80101f4a:	31 ff                	xor    %edi,%edi
80101f4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f4f:	85 d2                	test   %edx,%edx
80101f51:	75 0d                	jne    80101f60 <dirlookup+0x30>
80101f53:	eb 5b                	jmp    80101fb0 <dirlookup+0x80>
80101f55:	8d 76 00             	lea    0x0(%esi),%esi
80101f58:	83 c7 10             	add    $0x10,%edi
80101f5b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101f5e:	76 50                	jbe    80101fb0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f60:	6a 10                	push   $0x10
80101f62:	57                   	push   %edi
80101f63:	56                   	push   %esi
80101f64:	53                   	push   %ebx
80101f65:	e8 76 fd ff ff       	call   80101ce0 <readi>
80101f6a:	83 c4 10             	add    $0x10,%esp
80101f6d:	83 f8 10             	cmp    $0x10,%eax
80101f70:	75 48                	jne    80101fba <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101f72:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f77:	74 df                	je     80101f58 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101f79:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f7c:	83 ec 04             	sub    $0x4,%esp
80101f7f:	6a 0e                	push   $0xe
80101f81:	50                   	push   %eax
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	e8 66 2b 00 00       	call   80104af0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101f8a:	83 c4 10             	add    $0x10,%esp
80101f8d:	85 c0                	test   %eax,%eax
80101f8f:	75 c7                	jne    80101f58 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101f91:	8b 45 10             	mov    0x10(%ebp),%eax
80101f94:	85 c0                	test   %eax,%eax
80101f96:	74 05                	je     80101f9d <dirlookup+0x6d>
        *poff = off;
80101f98:	8b 45 10             	mov    0x10(%ebp),%eax
80101f9b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101f9d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101fa1:	8b 03                	mov    (%ebx),%eax
80101fa3:	e8 78 f6 ff ff       	call   80101620 <iget>
    }
  }

  return 0;
}
80101fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5f                   	pop    %edi
80101fae:	5d                   	pop    %ebp
80101faf:	c3                   	ret    
80101fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101fb3:	31 c0                	xor    %eax,%eax
}
80101fb5:	5b                   	pop    %ebx
80101fb6:	5e                   	pop    %esi
80101fb7:	5f                   	pop    %edi
80101fb8:	5d                   	pop    %ebp
80101fb9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 d9 77 10 80       	push   $0x801077d9
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101fc7:	83 ec 0c             	sub    $0xc,%esp
80101fca:	68 c7 77 10 80       	push   $0x801077c7
80101fcf:	e8 9c e3 ff ff       	call   80100370 <panic>
80101fd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fe0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	89 cf                	mov    %ecx,%edi
80101fe8:	89 c3                	mov    %eax,%ebx
80101fea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101fed:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ff0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ff3:	0f 84 53 01 00 00    	je     8010214c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ff9:	e8 42 1b 00 00       	call   80103b40 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ffe:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102001:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80102004:	68 e0 19 11 80       	push   $0x801119e0
80102009:	e8 b2 28 00 00       	call   801048c0 <acquire>
  ip->ref++;
8010200e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102012:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80102019:	e8 52 29 00 00       	call   80104970 <release>
8010201e:	83 c4 10             	add    $0x10,%esp
80102021:	eb 08                	jmp    8010202b <namex+0x4b>
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80102028:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010202b:	0f b6 03             	movzbl (%ebx),%eax
8010202e:	3c 2f                	cmp    $0x2f,%al
80102030:	74 f6                	je     80102028 <namex+0x48>
    path++;
  if(*path == 0)
80102032:	84 c0                	test   %al,%al
80102034:	0f 84 e3 00 00 00    	je     8010211d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010203a:	0f b6 03             	movzbl (%ebx),%eax
8010203d:	89 da                	mov    %ebx,%edx
8010203f:	84 c0                	test   %al,%al
80102041:	0f 84 ac 00 00 00    	je     801020f3 <namex+0x113>
80102047:	3c 2f                	cmp    $0x2f,%al
80102049:	75 09                	jne    80102054 <namex+0x74>
8010204b:	e9 a3 00 00 00       	jmp    801020f3 <namex+0x113>
80102050:	84 c0                	test   %al,%al
80102052:	74 0a                	je     8010205e <namex+0x7e>
    path++;
80102054:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102057:	0f b6 02             	movzbl (%edx),%eax
8010205a:	3c 2f                	cmp    $0x2f,%al
8010205c:	75 f2                	jne    80102050 <namex+0x70>
8010205e:	89 d1                	mov    %edx,%ecx
80102060:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80102062:	83 f9 0d             	cmp    $0xd,%ecx
80102065:	0f 8e 8d 00 00 00    	jle    801020f8 <namex+0x118>
    memmove(name, s, DIRSIZ);
8010206b:	83 ec 04             	sub    $0x4,%esp
8010206e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102071:	6a 0e                	push   $0xe
80102073:	53                   	push   %ebx
80102074:	57                   	push   %edi
80102075:	e8 f6 29 00 00       	call   80104a70 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
8010207a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
8010207d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80102080:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102082:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102085:	75 11                	jne    80102098 <namex+0xb8>
80102087:	89 f6                	mov    %esi,%esi
80102089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102090:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102093:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102096:	74 f8                	je     80102090 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102098:	83 ec 0c             	sub    $0xc,%esp
8010209b:	56                   	push   %esi
8010209c:	e8 5f f9 ff ff       	call   80101a00 <ilock>
    if(ip->type != T_DIR){
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020a9:	0f 85 7f 00 00 00    	jne    8010212e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020af:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020b2:	85 d2                	test   %edx,%edx
801020b4:	74 09                	je     801020bf <namex+0xdf>
801020b6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020b9:	0f 84 a3 00 00 00    	je     80102162 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020bf:	83 ec 04             	sub    $0x4,%esp
801020c2:	6a 00                	push   $0x0
801020c4:	57                   	push   %edi
801020c5:	56                   	push   %esi
801020c6:	e8 65 fe ff ff       	call   80101f30 <dirlookup>
801020cb:	83 c4 10             	add    $0x10,%esp
801020ce:	85 c0                	test   %eax,%eax
801020d0:	74 5c                	je     8010212e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020d2:	83 ec 0c             	sub    $0xc,%esp
801020d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020d8:	56                   	push   %esi
801020d9:	e8 02 fa ff ff       	call   80101ae0 <iunlock>
  iput(ip);
801020de:	89 34 24             	mov    %esi,(%esp)
801020e1:	e8 4a fa ff ff       	call   80101b30 <iput>
801020e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020e9:	83 c4 10             	add    $0x10,%esp
801020ec:	89 c6                	mov    %eax,%esi
801020ee:	e9 38 ff ff ff       	jmp    8010202b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801020f3:	31 c9                	xor    %ecx,%ecx
801020f5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801020f8:	83 ec 04             	sub    $0x4,%esp
801020fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020fe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102101:	51                   	push   %ecx
80102102:	53                   	push   %ebx
80102103:	57                   	push   %edi
80102104:	e8 67 29 00 00       	call   80104a70 <memmove>
    name[len] = 0;
80102109:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010210c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010210f:	83 c4 10             	add    $0x10,%esp
80102112:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80102116:	89 d3                	mov    %edx,%ebx
80102118:	e9 65 ff ff ff       	jmp    80102082 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010211d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102120:	85 c0                	test   %eax,%eax
80102122:	75 54                	jne    80102178 <namex+0x198>
80102124:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80102126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102129:	5b                   	pop    %ebx
8010212a:	5e                   	pop    %esi
8010212b:	5f                   	pop    %edi
8010212c:	5d                   	pop    %ebp
8010212d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010212e:	83 ec 0c             	sub    $0xc,%esp
80102131:	56                   	push   %esi
80102132:	e8 a9 f9 ff ff       	call   80101ae0 <iunlock>
  iput(ip);
80102137:	89 34 24             	mov    %esi,(%esp)
8010213a:	e8 f1 f9 ff ff       	call   80101b30 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
8010213f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102142:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102145:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102147:	5b                   	pop    %ebx
80102148:	5e                   	pop    %esi
80102149:	5f                   	pop    %edi
8010214a:	5d                   	pop    %ebp
8010214b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
8010214c:	ba 01 00 00 00       	mov    $0x1,%edx
80102151:	b8 01 00 00 00       	mov    $0x1,%eax
80102156:	e8 c5 f4 ff ff       	call   80101620 <iget>
8010215b:	89 c6                	mov    %eax,%esi
8010215d:	e9 c9 fe ff ff       	jmp    8010202b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80102162:	83 ec 0c             	sub    $0xc,%esp
80102165:	56                   	push   %esi
80102166:	e8 75 f9 ff ff       	call   80101ae0 <iunlock>
      return ip;
8010216b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8010216e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80102171:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	56                   	push   %esi
8010217c:	e8 af f9 ff ff       	call   80101b30 <iput>
    return 0;
80102181:	83 c4 10             	add    $0x10,%esp
80102184:	31 c0                	xor    %eax,%eax
80102186:	eb 9e                	jmp    80102126 <namex+0x146>
80102188:	90                   	nop
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 20             	sub    $0x20,%esp
80102199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010219c:	6a 00                	push   $0x0
8010219e:	ff 75 0c             	pushl  0xc(%ebp)
801021a1:	53                   	push   %ebx
801021a2:	e8 89 fd ff ff       	call   80101f30 <dirlookup>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	85 c0                	test   %eax,%eax
801021ac:	75 67                	jne    80102215 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801021b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021b4:	85 ff                	test   %edi,%edi
801021b6:	74 29                	je     801021e1 <dirlink+0x51>
801021b8:	31 ff                	xor    %edi,%edi
801021ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021bd:	eb 09                	jmp    801021c8 <dirlink+0x38>
801021bf:	90                   	nop
801021c0:	83 c7 10             	add    $0x10,%edi
801021c3:	39 7b 58             	cmp    %edi,0x58(%ebx)
801021c6:	76 19                	jbe    801021e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c8:	6a 10                	push   $0x10
801021ca:	57                   	push   %edi
801021cb:	56                   	push   %esi
801021cc:	53                   	push   %ebx
801021cd:	e8 0e fb ff ff       	call   80101ce0 <readi>
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	83 f8 10             	cmp    $0x10,%eax
801021d8:	75 4e                	jne    80102228 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
801021da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021df:	75 df                	jne    801021c0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801021e1:	8d 45 da             	lea    -0x26(%ebp),%eax
801021e4:	83 ec 04             	sub    $0x4,%esp
801021e7:	6a 0e                	push   $0xe
801021e9:	ff 75 0c             	pushl  0xc(%ebp)
801021ec:	50                   	push   %eax
801021ed:	e8 6e 29 00 00       	call   80104b60 <strncpy>
  de.inum = inum;
801021f2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f5:	6a 10                	push   $0x10
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
801021fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fe:	e8 dd fb ff ff       	call   80101de0 <writei>
80102203:	83 c4 20             	add    $0x20,%esp
80102206:	83 f8 10             	cmp    $0x10,%eax
80102209:	75 2a                	jne    80102235 <dirlink+0xa5>
    panic("dirlink");

  return 0;
8010220b:	31 c0                	xor    %eax,%eax
}
8010220d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102210:	5b                   	pop    %ebx
80102211:	5e                   	pop    %esi
80102212:	5f                   	pop    %edi
80102213:	5d                   	pop    %ebp
80102214:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80102215:	83 ec 0c             	sub    $0xc,%esp
80102218:	50                   	push   %eax
80102219:	e8 12 f9 ff ff       	call   80101b30 <iput>
    return -1;
8010221e:	83 c4 10             	add    $0x10,%esp
80102221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102226:	eb e5                	jmp    8010220d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 e8 77 10 80       	push   $0x801077e8
80102230:	e8 3b e1 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 f2 7d 10 80       	push   $0x80107df2
8010223d:	e8 2e e1 ff ff       	call   80100370 <panic>
80102242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102250:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102251:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102253:	89 e5                	mov    %esp,%ebp
80102255:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102258:	8b 45 08             	mov    0x8(%ebp),%eax
8010225b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010225e:	e8 7d fd ff ff       	call   80101fe0 <namex>
}
80102263:	c9                   	leave  
80102264:	c3                   	ret    
80102265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102270:	55                   	push   %ebp
  return namex(path, 1, name);
80102271:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102276:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010227b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010227e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010227f:	e9 5c fd ff ff       	jmp    80101fe0 <namex>
80102284:	66 90                	xchg   %ax,%ax
80102286:	66 90                	xchg   %ax,%ax
80102288:	66 90                	xchg   %ax,%ax
8010228a:	66 90                	xchg   %ax,%ax
8010228c:	66 90                	xchg   %ax,%ax
8010228e:	66 90                	xchg   %ax,%ax

80102290 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102290:	55                   	push   %ebp
  if(b == 0)
80102291:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102293:	89 e5                	mov    %esp,%ebp
80102295:	56                   	push   %esi
80102296:	53                   	push   %ebx
  if(b == 0)
80102297:	0f 84 ad 00 00 00    	je     8010234a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010229d:	8b 58 08             	mov    0x8(%eax),%ebx
801022a0:	89 c1                	mov    %eax,%ecx
801022a2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022a8:	0f 87 8f 00 00 00    	ja     8010233d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ae:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022b3:	90                   	nop
801022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022b9:	83 e0 c0             	and    $0xffffffc0,%eax
801022bc:	3c 40                	cmp    $0x40,%al
801022be:	75 f8                	jne    801022b8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c0:	31 f6                	xor    %esi,%esi
801022c2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022c7:	89 f0                	mov    %esi,%eax
801022c9:	ee                   	out    %al,(%dx)
801022ca:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022cf:	b8 01 00 00 00       	mov    $0x1,%eax
801022d4:	ee                   	out    %al,(%dx)
801022d5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022da:	89 d8                	mov    %ebx,%eax
801022dc:	ee                   	out    %al,(%dx)
801022dd:	89 d8                	mov    %ebx,%eax
801022df:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022e4:	c1 f8 08             	sar    $0x8,%eax
801022e7:	ee                   	out    %al,(%dx)
801022e8:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022ed:	89 f0                	mov    %esi,%eax
801022ef:	ee                   	out    %al,(%dx)
801022f0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
801022f4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022f9:	83 e0 01             	and    $0x1,%eax
801022fc:	c1 e0 04             	shl    $0x4,%eax
801022ff:	83 c8 e0             	or     $0xffffffe0,%eax
80102302:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102303:	f6 01 04             	testb  $0x4,(%ecx)
80102306:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010230b:	75 13                	jne    80102320 <idestart+0x90>
8010230d:	b8 20 00 00 00       	mov    $0x20,%eax
80102312:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102313:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102316:	5b                   	pop    %ebx
80102317:	5e                   	pop    %esi
80102318:	5d                   	pop    %ebp
80102319:	c3                   	ret    
8010231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102320:	b8 30 00 00 00       	mov    $0x30,%eax
80102325:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102326:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010232b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010232e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102333:	fc                   	cld    
80102334:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102339:	5b                   	pop    %ebx
8010233a:	5e                   	pop    %esi
8010233b:	5d                   	pop    %ebp
8010233c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010233d:	83 ec 0c             	sub    $0xc,%esp
80102340:	68 54 78 10 80       	push   $0x80107854
80102345:	e8 26 e0 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010234a:	83 ec 0c             	sub    $0xc,%esp
8010234d:	68 4b 78 10 80       	push   $0x8010784b
80102352:	e8 19 e0 ff ff       	call   80100370 <panic>
80102357:	89 f6                	mov    %esi,%esi
80102359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102360 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102366:	68 66 78 10 80       	push   $0x80107866
8010236b:	68 80 b5 10 80       	push   $0x8010b580
80102370:	e8 eb 23 00 00       	call   80104760 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102375:	58                   	pop    %eax
80102376:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010237b:	5a                   	pop    %edx
8010237c:	83 e8 01             	sub    $0x1,%eax
8010237f:	50                   	push   %eax
80102380:	6a 0e                	push   $0xe
80102382:	e8 a9 02 00 00       	call   80102630 <ioapicenable>
80102387:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010238a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010238f:	90                   	nop
80102390:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102391:	83 e0 c0             	and    $0xffffffc0,%eax
80102394:	3c 40                	cmp    $0x40,%al
80102396:	75 f8                	jne    80102390 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102398:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010239d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023a2:	ee                   	out    %al,(%dx)
801023a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ad:	eb 06                	jmp    801023b5 <ideinit+0x55>
801023af:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801023b0:	83 e9 01             	sub    $0x1,%ecx
801023b3:	74 0f                	je     801023c4 <ideinit+0x64>
801023b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023b6:	84 c0                	test   %al,%al
801023b8:	74 f6                	je     801023b0 <ideinit+0x50>
      havedisk1 = 1;
801023ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801023c1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023c4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023c9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023ce:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801023cf:	c9                   	leave  
801023d0:	c3                   	ret    
801023d1:	eb 0d                	jmp    801023e0 <ideintr>
801023d3:	90                   	nop
801023d4:	90                   	nop
801023d5:	90                   	nop
801023d6:	90                   	nop
801023d7:	90                   	nop
801023d8:	90                   	nop
801023d9:	90                   	nop
801023da:	90                   	nop
801023db:	90                   	nop
801023dc:	90                   	nop
801023dd:	90                   	nop
801023de:	90                   	nop
801023df:	90                   	nop

801023e0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	57                   	push   %edi
801023e4:	56                   	push   %esi
801023e5:	53                   	push   %ebx
801023e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023e9:	68 80 b5 10 80       	push   $0x8010b580
801023ee:	e8 cd 24 00 00       	call   801048c0 <acquire>

  if((b = idequeue) == 0){
801023f3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801023f9:	83 c4 10             	add    $0x10,%esp
801023fc:	85 db                	test   %ebx,%ebx
801023fe:	74 34                	je     80102434 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102400:	8b 43 58             	mov    0x58(%ebx),%eax
80102403:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102408:	8b 33                	mov    (%ebx),%esi
8010240a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102410:	74 3e                	je     80102450 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102412:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102415:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102418:	83 ce 02             	or     $0x2,%esi
8010241b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010241d:	53                   	push   %ebx
8010241e:	e8 5d 20 00 00       	call   80104480 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102423:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102428:	83 c4 10             	add    $0x10,%esp
8010242b:	85 c0                	test   %eax,%eax
8010242d:	74 05                	je     80102434 <ideintr+0x54>
    idestart(idequeue);
8010242f:	e8 5c fe ff ff       	call   80102290 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102434:	83 ec 0c             	sub    $0xc,%esp
80102437:	68 80 b5 10 80       	push   $0x8010b580
8010243c:	e8 2f 25 00 00       	call   80104970 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102441:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102444:	5b                   	pop    %ebx
80102445:	5e                   	pop    %esi
80102446:	5f                   	pop    %edi
80102447:	5d                   	pop    %ebp
80102448:	c3                   	ret    
80102449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102450:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102455:	8d 76 00             	lea    0x0(%esi),%esi
80102458:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102459:	89 c1                	mov    %eax,%ecx
8010245b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010245e:	80 f9 40             	cmp    $0x40,%cl
80102461:	75 f5                	jne    80102458 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102463:	a8 21                	test   $0x21,%al
80102465:	75 ab                	jne    80102412 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102467:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010246a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010246f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102474:	fc                   	cld    
80102475:	f3 6d                	rep insl (%dx),%es:(%edi)
80102477:	8b 33                	mov    (%ebx),%esi
80102479:	eb 97                	jmp    80102412 <ideintr+0x32>
8010247b:	90                   	nop
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102480 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 10             	sub    $0x10,%esp
80102487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010248a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010248d:	50                   	push   %eax
8010248e:	e8 7d 22 00 00       	call   80104710 <holdingsleep>
80102493:	83 c4 10             	add    $0x10,%esp
80102496:	85 c0                	test   %eax,%eax
80102498:	0f 84 ad 00 00 00    	je     8010254b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010249e:	8b 03                	mov    (%ebx),%eax
801024a0:	83 e0 06             	and    $0x6,%eax
801024a3:	83 f8 02             	cmp    $0x2,%eax
801024a6:	0f 84 b9 00 00 00    	je     80102565 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024ac:	8b 53 04             	mov    0x4(%ebx),%edx
801024af:	85 d2                	test   %edx,%edx
801024b1:	74 0d                	je     801024c0 <iderw+0x40>
801024b3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801024b8:	85 c0                	test   %eax,%eax
801024ba:	0f 84 98 00 00 00    	je     80102558 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 80 b5 10 80       	push   $0x8010b580
801024c8:	e8 f3 23 00 00       	call   801048c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024cd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801024d3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801024d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024dd:	85 d2                	test   %edx,%edx
801024df:	75 09                	jne    801024ea <iderw+0x6a>
801024e1:	eb 58                	jmp    8010253b <iderw+0xbb>
801024e3:	90                   	nop
801024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e8:	89 c2                	mov    %eax,%edx
801024ea:	8b 42 58             	mov    0x58(%edx),%eax
801024ed:	85 c0                	test   %eax,%eax
801024ef:	75 f7                	jne    801024e8 <iderw+0x68>
801024f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024f6:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
801024fc:	74 44                	je     80102542 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024fe:	8b 03                	mov    (%ebx),%eax
80102500:	83 e0 06             	and    $0x6,%eax
80102503:	83 f8 02             	cmp    $0x2,%eax
80102506:	74 23                	je     8010252b <iderw+0xab>
80102508:	90                   	nop
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102510:	83 ec 08             	sub    $0x8,%esp
80102513:	68 80 b5 10 80       	push   $0x8010b580
80102518:	53                   	push   %ebx
80102519:	e8 a2 1d 00 00       	call   801042c0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010251e:	8b 03                	mov    (%ebx),%eax
80102520:	83 c4 10             	add    $0x10,%esp
80102523:	83 e0 06             	and    $0x6,%eax
80102526:	83 f8 02             	cmp    $0x2,%eax
80102529:	75 e5                	jne    80102510 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010252b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102535:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102536:	e9 35 24 00 00       	jmp    80104970 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010253b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102540:	eb b2                	jmp    801024f4 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102542:	89 d8                	mov    %ebx,%eax
80102544:	e8 47 fd ff ff       	call   80102290 <idestart>
80102549:	eb b3                	jmp    801024fe <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010254b:	83 ec 0c             	sub    $0xc,%esp
8010254e:	68 6a 78 10 80       	push   $0x8010786a
80102553:	e8 18 de ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 95 78 10 80       	push   $0x80107895
80102560:	e8 0b de ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102565:	83 ec 0c             	sub    $0xc,%esp
80102568:	68 80 78 10 80       	push   $0x80107880
8010256d:	e8 fe dd ff ff       	call   80100370 <panic>
80102572:	66 90                	xchg   %ax,%ax
80102574:	66 90                	xchg   %ax,%ax
80102576:	66 90                	xchg   %ax,%ax
80102578:	66 90                	xchg   %ax,%ax
8010257a:	66 90                	xchg   %ax,%ax
8010257c:	66 90                	xchg   %ax,%ax
8010257e:	66 90                	xchg   %ax,%ax

80102580 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102580:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102581:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102588:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010258b:	89 e5                	mov    %esp,%ebp
8010258d:	56                   	push   %esi
8010258e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010258f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102596:	00 00 00 
  return ioapic->data;
80102599:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010259f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025a2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025a8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ae:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025b5:	89 f0                	mov    %esi,%eax
801025b7:	c1 e8 10             	shr    $0x10,%eax
801025ba:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801025bd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025c0:	c1 e8 18             	shr    $0x18,%eax
801025c3:	39 d0                	cmp    %edx,%eax
801025c5:	74 16                	je     801025dd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 b4 78 10 80       	push   $0x801078b4
801025cf:	e8 8c e0 ff ff       	call   80100660 <cprintf>
801025d4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801025da:	83 c4 10             	add    $0x10,%esp
801025dd:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025e0:	ba 10 00 00 00       	mov    $0x10,%edx
801025e5:	b8 20 00 00 00       	mov    $0x20,%eax
801025ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801025f0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801025f2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025f8:	89 c3                	mov    %eax,%ebx
801025fa:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102600:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102603:	89 59 10             	mov    %ebx,0x10(%ecx)
80102606:	8d 5a 01             	lea    0x1(%edx),%ebx
80102609:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010260c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010260e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102610:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102616:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010261d:	75 d1                	jne    801025f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010261f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102622:	5b                   	pop    %ebx
80102623:	5e                   	pop    %esi
80102624:	5d                   	pop    %ebp
80102625:	c3                   	ret    
80102626:	8d 76 00             	lea    0x0(%esi),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102630:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102631:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102637:	89 e5                	mov    %esp,%ebp
80102639:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010263c:	8d 50 20             	lea    0x20(%eax),%edx
8010263f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102643:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102645:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010264b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010264e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102651:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102654:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102656:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010265b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010265e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	66 90                	xchg   %ax,%ax
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	53                   	push   %ebx
80102674:	83 ec 04             	sub    $0x4,%esp
80102677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010267a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102680:	75 70                	jne    801026f2 <kfree+0x82>
80102682:	81 fb a8 68 11 80    	cmp    $0x801168a8,%ebx
80102688:	72 68                	jb     801026f2 <kfree+0x82>
8010268a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102690:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102695:	77 5b                	ja     801026f2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102697:	83 ec 04             	sub    $0x4,%esp
8010269a:	68 00 10 00 00       	push   $0x1000
8010269f:	6a 01                	push   $0x1
801026a1:	53                   	push   %ebx
801026a2:	e8 19 23 00 00       	call   801049c0 <memset>

  if(kmem.use_lock)
801026a7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026ad:	83 c4 10             	add    $0x10,%esp
801026b0:	85 d2                	test   %edx,%edx
801026b2:	75 2c                	jne    801026e0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026b4:	a1 78 36 11 80       	mov    0x80113678,%eax
801026b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026bb:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801026c0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801026c6:	85 c0                	test   %eax,%eax
801026c8:	75 06                	jne    801026d0 <kfree+0x60>
    release(&kmem.lock);
}
801026ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026cd:	c9                   	leave  
801026ce:	c3                   	ret    
801026cf:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801026d0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801026d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026da:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801026db:	e9 90 22 00 00       	jmp    80104970 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 40 36 11 80       	push   $0x80113640
801026e8:	e8 d3 21 00 00       	call   801048c0 <acquire>
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	eb c2                	jmp    801026b4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801026f2:	83 ec 0c             	sub    $0xc,%esp
801026f5:	68 e6 78 10 80       	push   $0x801078e6
801026fa:	e8 71 dc ff ff       	call   80100370 <panic>
801026ff:	90                   	nop

80102700 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102705:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102708:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010270b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102711:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102717:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010271d:	39 de                	cmp    %ebx,%esi
8010271f:	72 23                	jb     80102744 <freerange+0x44>
80102721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102728:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010272e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102731:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102737:	50                   	push   %eax
80102738:	e8 33 ff ff ff       	call   80102670 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	39 f3                	cmp    %esi,%ebx
80102742:	76 e4                	jbe    80102728 <freerange+0x28>
    kfree(p);
}
80102744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102747:	5b                   	pop    %ebx
80102748:	5e                   	pop    %esi
80102749:	5d                   	pop    %ebp
8010274a:	c3                   	ret    
8010274b:	90                   	nop
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	56                   	push   %esi
80102754:	53                   	push   %ebx
80102755:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102758:	83 ec 08             	sub    $0x8,%esp
8010275b:	68 ec 78 10 80       	push   $0x801078ec
80102760:	68 40 36 11 80       	push   $0x80113640
80102765:	e8 f6 1f 00 00       	call   80104760 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010276a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102770:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102777:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010277a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102780:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102786:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010278c:	39 de                	cmp    %ebx,%esi
8010278e:	72 1c                	jb     801027ac <kinit1+0x5c>
    kfree(p);
80102790:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102796:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102799:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010279f:	50                   	push   %eax
801027a0:	e8 cb fe ff ff       	call   80102670 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a5:	83 c4 10             	add    $0x10,%esp
801027a8:	39 de                	cmp    %ebx,%esi
801027aa:	73 e4                	jae    80102790 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801027ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027af:	5b                   	pop    %ebx
801027b0:	5e                   	pop    %esi
801027b1:	5d                   	pop    %ebp
801027b2:	c3                   	ret    
801027b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	56                   	push   %esi
801027c4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027c5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801027c8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027dd:	39 de                	cmp    %ebx,%esi
801027df:	72 23                	jb     80102804 <kinit2+0x44>
801027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027ee:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027f7:	50                   	push   %eax
801027f8:	e8 73 fe ff ff       	call   80102670 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	39 de                	cmp    %ebx,%esi
80102802:	73 e4                	jae    801027e8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102804:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010280b:	00 00 00 
}
8010280e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102811:	5b                   	pop    %ebx
80102812:	5e                   	pop    %esi
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	53                   	push   %ebx
80102824:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102827:	a1 74 36 11 80       	mov    0x80113674,%eax
8010282c:	85 c0                	test   %eax,%eax
8010282e:	75 30                	jne    80102860 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102830:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102836:	85 db                	test   %ebx,%ebx
80102838:	74 1c                	je     80102856 <kalloc+0x36>
    kmem.freelist = r->next;
8010283a:	8b 13                	mov    (%ebx),%edx
8010283c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102842:	85 c0                	test   %eax,%eax
80102844:	74 10                	je     80102856 <kalloc+0x36>
    release(&kmem.lock);
80102846:	83 ec 0c             	sub    $0xc,%esp
80102849:	68 40 36 11 80       	push   $0x80113640
8010284e:	e8 1d 21 00 00       	call   80104970 <release>
80102853:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102856:	89 d8                	mov    %ebx,%eax
80102858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010285b:	c9                   	leave  
8010285c:	c3                   	ret    
8010285d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102860:	83 ec 0c             	sub    $0xc,%esp
80102863:	68 40 36 11 80       	push   $0x80113640
80102868:	e8 53 20 00 00       	call   801048c0 <acquire>
  r = kmem.freelist;
8010286d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102873:	83 c4 10             	add    $0x10,%esp
80102876:	a1 74 36 11 80       	mov    0x80113674,%eax
8010287b:	85 db                	test   %ebx,%ebx
8010287d:	75 bb                	jne    8010283a <kalloc+0x1a>
8010287f:	eb c1                	jmp    80102842 <kalloc+0x22>
80102881:	66 90                	xchg   %ax,%ax
80102883:	66 90                	xchg   %ax,%ax
80102885:	66 90                	xchg   %ax,%ax
80102887:	66 90                	xchg   %ax,%ax
80102889:	66 90                	xchg   %ax,%ax
8010288b:	66 90                	xchg   %ax,%ax
8010288d:	66 90                	xchg   %ax,%ax
8010288f:	90                   	nop

80102890 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102890:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102891:	ba 64 00 00 00       	mov    $0x64,%edx
80102896:	89 e5                	mov    %esp,%ebp
80102898:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102899:	a8 01                	test   $0x1,%al
8010289b:	0f 84 af 00 00 00    	je     80102950 <kbdgetc+0xc0>
801028a1:	ba 60 00 00 00       	mov    $0x60,%edx
801028a6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028a7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028aa:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028b0:	74 7e                	je     80102930 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028b2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028b4:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028ba:	79 24                	jns    801028e0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028bc:	f6 c1 40             	test   $0x40,%cl
801028bf:	75 05                	jne    801028c6 <kbdgetc+0x36>
801028c1:	89 c2                	mov    %eax,%edx
801028c3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028c6:	0f b6 82 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%eax
801028cd:	83 c8 40             	or     $0x40,%eax
801028d0:	0f b6 c0             	movzbl %al,%eax
801028d3:	f7 d0                	not    %eax
801028d5:	21 c8                	and    %ecx,%eax
801028d7:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801028dc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028de:	5d                   	pop    %ebp
801028df:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028e0:	f6 c1 40             	test   $0x40,%cl
801028e3:	74 09                	je     801028ee <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028e5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028e8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028eb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801028ee:	0f b6 82 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%eax
801028f5:	09 c1                	or     %eax,%ecx
801028f7:	0f b6 82 20 79 10 80 	movzbl -0x7fef86e0(%edx),%eax
801028fe:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102900:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102902:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102908:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010290b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010290e:	8b 04 85 00 79 10 80 	mov    -0x7fef8700(,%eax,4),%eax
80102915:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102919:	74 c3                	je     801028de <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010291b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010291e:	83 fa 19             	cmp    $0x19,%edx
80102921:	77 1d                	ja     80102940 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102923:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102926:	5d                   	pop    %ebp
80102927:	c3                   	ret    
80102928:	90                   	nop
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102930:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102932:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102939:	5d                   	pop    %ebp
8010293a:	c3                   	ret    
8010293b:	90                   	nop
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102940:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102943:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102946:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102947:	83 f9 19             	cmp    $0x19,%ecx
8010294a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010294d:	c3                   	ret    
8010294e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102955:	5d                   	pop    %ebp
80102956:	c3                   	ret    
80102957:	89 f6                	mov    %esi,%esi
80102959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102960 <kbdintr>:

void
kbdintr(void)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102966:	68 90 28 10 80       	push   $0x80102890
8010296b:	e8 80 de ff ff       	call   801007f0 <consoleintr>
}
80102970:	83 c4 10             	add    $0x10,%esp
80102973:	c9                   	leave  
80102974:	c3                   	ret    
80102975:	66 90                	xchg   %ax,%ax
80102977:	66 90                	xchg   %ax,%ax
80102979:	66 90                	xchg   %ax,%ax
8010297b:	66 90                	xchg   %ax,%ax
8010297d:	66 90                	xchg   %ax,%ax
8010297f:	90                   	nop

80102980 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102980:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102985:	55                   	push   %ebp
80102986:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102988:	85 c0                	test   %eax,%eax
8010298a:	0f 84 c8 00 00 00    	je     80102a58 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102990:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102997:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010299d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029b4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029c1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029de:	8b 50 30             	mov    0x30(%eax),%edx
801029e1:	c1 ea 10             	shr    $0x10,%edx
801029e4:	80 fa 03             	cmp    $0x3,%dl
801029e7:	77 77                	ja     80102a60 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a00:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a27:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a34:	8b 50 20             	mov    0x20(%eax),%edx
80102a37:	89 f6                	mov    %esi,%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a46:	80 e6 10             	and    $0x10,%dh
80102a49:	75 f5                	jne    80102a40 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a58:	5d                   	pop    %ebp
80102a59:	c3                   	ret    
80102a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
80102a6d:	e9 77 ff ff ff       	jmp    801029e9 <lapicinit+0x69>
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102a80:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102a88:	85 c0                	test   %eax,%eax
80102a8a:	74 0c                	je     80102a98 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102a8c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102a8f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102a90:	c1 e8 18             	shr    $0x18,%eax
}
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102a98:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102a9a:	5d                   	pop    %ebp
80102a9b:	c3                   	ret    
80102a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102aa0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102aa0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102aa5:	55                   	push   %ebp
80102aa6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102aa8:	85 c0                	test   %eax,%eax
80102aaa:	74 0d                	je     80102ab9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ab3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102ab9:	5d                   	pop    %ebp
80102aba:	c3                   	ret    
80102abb:	90                   	nop
80102abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ac0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
}
80102ac3:	5d                   	pop    %ebp
80102ac4:	c3                   	ret    
80102ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ad0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad1:	ba 70 00 00 00       	mov    $0x70,%edx
80102ad6:	b8 0f 00 00 00       	mov    $0xf,%eax
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	53                   	push   %ebx
80102ade:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ae1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ae4:	ee                   	out    %al,(%dx)
80102ae5:	ba 71 00 00 00       	mov    $0x71,%edx
80102aea:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102af0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102af2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102af5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102afb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102afd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b00:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b03:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b05:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b08:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b0e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b19:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b26:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b33:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b3c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b45:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b4e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b57:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102b5a:	5b                   	pop    %ebx
80102b5b:	5d                   	pop    %ebp
80102b5c:	c3                   	ret    
80102b5d:	8d 76 00             	lea    0x0(%esi),%esi

80102b60 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b60:	55                   	push   %ebp
80102b61:	ba 70 00 00 00       	mov    $0x70,%edx
80102b66:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b6b:	89 e5                	mov    %esp,%ebp
80102b6d:	57                   	push   %edi
80102b6e:	56                   	push   %esi
80102b6f:	53                   	push   %ebx
80102b70:	83 ec 4c             	sub    $0x4c,%esp
80102b73:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b74:	ba 71 00 00 00       	mov    $0x71,%edx
80102b79:	ec                   	in     (%dx),%al
80102b7a:	83 e0 04             	and    $0x4,%eax
80102b7d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b80:	31 db                	xor    %ebx,%ebx
80102b82:	88 45 b7             	mov    %al,-0x49(%ebp)
80102b85:	bf 70 00 00 00       	mov    $0x70,%edi
80102b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b90:	89 d8                	mov    %ebx,%eax
80102b92:	89 fa                	mov    %edi,%edx
80102b94:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b95:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b9a:	89 ca                	mov    %ecx,%edx
80102b9c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102b9d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba0:	89 fa                	mov    %edi,%edx
80102ba2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ba5:	b8 02 00 00 00       	mov    $0x2,%eax
80102baa:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bab:	89 ca                	mov    %ecx,%edx
80102bad:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102bae:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb1:	89 fa                	mov    %edi,%edx
80102bb3:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bb6:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbc:	89 ca                	mov    %ecx,%edx
80102bbe:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102bbf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc2:	89 fa                	mov    %edi,%edx
80102bc4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bc7:	b8 07 00 00 00       	mov    $0x7,%eax
80102bcc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcd:	89 ca                	mov    %ecx,%edx
80102bcf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102bd0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd3:	89 fa                	mov    %edi,%edx
80102bd5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bd8:	b8 08 00 00 00       	mov    $0x8,%eax
80102bdd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bde:	89 ca                	mov    %ecx,%edx
80102be0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102be1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be4:	89 fa                	mov    %edi,%edx
80102be6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102be9:	b8 09 00 00 00       	mov    $0x9,%eax
80102bee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bef:	89 ca                	mov    %ecx,%edx
80102bf1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102bf2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf5:	89 fa                	mov    %edi,%edx
80102bf7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102bfa:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bff:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c00:	89 ca                	mov    %ecx,%edx
80102c02:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c03:	84 c0                	test   %al,%al
80102c05:	78 89                	js     80102b90 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c07:	89 d8                	mov    %ebx,%eax
80102c09:	89 fa                	mov    %edi,%edx
80102c0b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c0f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 fa                	mov    %edi,%edx
80102c14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c17:	b8 02 00 00 00       	mov    $0x2,%eax
80102c1c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1d:	89 ca                	mov    %ecx,%edx
80102c1f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c20:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c23:	89 fa                	mov    %edi,%edx
80102c25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c28:	b8 04 00 00 00       	mov    $0x4,%eax
80102c2d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2e:	89 ca                	mov    %ecx,%edx
80102c30:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c31:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 fa                	mov    %edi,%edx
80102c36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c39:	b8 07 00 00 00       	mov    $0x7,%eax
80102c3e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3f:	89 ca                	mov    %ecx,%edx
80102c41:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c42:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c45:	89 fa                	mov    %edi,%edx
80102c47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c4f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c50:	89 ca                	mov    %ecx,%edx
80102c52:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c53:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c56:	89 fa                	mov    %edi,%edx
80102c58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c60:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c61:	89 ca                	mov    %ecx,%edx
80102c63:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c64:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c67:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102c6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c6d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c70:	6a 18                	push   $0x18
80102c72:	56                   	push   %esi
80102c73:	50                   	push   %eax
80102c74:	e8 97 1d 00 00       	call   80104a10 <memcmp>
80102c79:	83 c4 10             	add    $0x10,%esp
80102c7c:	85 c0                	test   %eax,%eax
80102c7e:	0f 85 0c ff ff ff    	jne    80102b90 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102c84:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102c88:	75 78                	jne    80102d02 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c8d:	89 c2                	mov    %eax,%edx
80102c8f:	83 e0 0f             	and    $0xf,%eax
80102c92:	c1 ea 04             	shr    $0x4,%edx
80102c95:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c98:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c9b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ca1:	89 c2                	mov    %eax,%edx
80102ca3:	83 e0 0f             	and    $0xf,%eax
80102ca6:	c1 ea 04             	shr    $0x4,%edx
80102ca9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cac:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102caf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cb2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cb5:	89 c2                	mov    %eax,%edx
80102cb7:	83 e0 0f             	and    $0xf,%eax
80102cba:	c1 ea 04             	shr    $0x4,%edx
80102cbd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cc6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cc9:	89 c2                	mov    %eax,%edx
80102ccb:	83 e0 0f             	and    $0xf,%eax
80102cce:	c1 ea 04             	shr    $0x4,%edx
80102cd1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cda:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cdd:	89 c2                	mov    %eax,%edx
80102cdf:	83 e0 0f             	and    $0xf,%eax
80102ce2:	c1 ea 04             	shr    $0x4,%edx
80102ce5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ceb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cee:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cf1:	89 c2                	mov    %eax,%edx
80102cf3:	83 e0 0f             	and    $0xf,%eax
80102cf6:	c1 ea 04             	shr    $0x4,%edx
80102cf9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cff:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d02:	8b 75 08             	mov    0x8(%ebp),%esi
80102d05:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d08:	89 06                	mov    %eax,(%esi)
80102d0a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d0d:	89 46 04             	mov    %eax,0x4(%esi)
80102d10:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d13:	89 46 08             	mov    %eax,0x8(%esi)
80102d16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d19:	89 46 0c             	mov    %eax,0xc(%esi)
80102d1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d1f:	89 46 10             	mov    %eax,0x10(%esi)
80102d22:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d25:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d28:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d32:	5b                   	pop    %ebx
80102d33:	5e                   	pop    %esi
80102d34:	5f                   	pop    %edi
80102d35:	5d                   	pop    %ebp
80102d36:	c3                   	ret    
80102d37:	66 90                	xchg   %ax,%ax
80102d39:	66 90                	xchg   %ax,%ax
80102d3b:	66 90                	xchg   %ax,%ax
80102d3d:	66 90                	xchg   %ax,%ax
80102d3f:	90                   	nop

80102d40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d40:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102d46:	85 c9                	test   %ecx,%ecx
80102d48:	0f 8e 85 00 00 00    	jle    80102dd3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102d4e:	55                   	push   %ebp
80102d4f:	89 e5                	mov    %esp,%ebp
80102d51:	57                   	push   %edi
80102d52:	56                   	push   %esi
80102d53:	53                   	push   %ebx
80102d54:	31 db                	xor    %ebx,%ebx
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d60:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102d65:	83 ec 08             	sub    $0x8,%esp
80102d68:	01 d8                	add    %ebx,%eax
80102d6a:	83 c0 01             	add    $0x1,%eax
80102d6d:	50                   	push   %eax
80102d6e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102d74:	e8 57 d3 ff ff       	call   801000d0 <bread>
80102d79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d7b:	58                   	pop    %eax
80102d7c:	5a                   	pop    %edx
80102d7d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102d84:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d8d:	e8 3e d3 ff ff       	call   801000d0 <bread>
80102d92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d97:	83 c4 0c             	add    $0xc,%esp
80102d9a:	68 00 02 00 00       	push   $0x200
80102d9f:	50                   	push   %eax
80102da0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102da3:	50                   	push   %eax
80102da4:	e8 c7 1c 00 00       	call   80104a70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102da9:	89 34 24             	mov    %esi,(%esp)
80102dac:	e8 ef d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102db1:	89 3c 24             	mov    %edi,(%esp)
80102db4:	e8 27 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102db9:	89 34 24             	mov    %esi,(%esp)
80102dbc:	e8 1f d4 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102dca:	7f 94                	jg     80102d60 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcf:	5b                   	pop    %ebx
80102dd0:	5e                   	pop    %esi
80102dd1:	5f                   	pop    %edi
80102dd2:	5d                   	pop    %ebp
80102dd3:	f3 c3                	repz ret 
80102dd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102de0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102de7:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ded:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102df3:	e8 d8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102df8:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102dfe:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e01:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e03:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e05:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e08:	7e 1f                	jle    80102e29 <write_head+0x49>
80102e0a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e11:	31 d2                	xor    %edx,%edx
80102e13:	90                   	nop
80102e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e18:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e1e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e22:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e25:	39 c2                	cmp    %eax,%edx
80102e27:	75 ef                	jne    80102e18 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e29:	83 ec 0c             	sub    $0xc,%esp
80102e2c:	53                   	push   %ebx
80102e2d:	e8 6e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e32:	89 1c 24             	mov    %ebx,(%esp)
80102e35:	e8 a6 d3 ff ff       	call   801001e0 <brelse>
}
80102e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3d:	c9                   	leave  
80102e3e:	c3                   	ret    
80102e3f:	90                   	nop

80102e40 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 2c             	sub    $0x2c,%esp
80102e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e4a:	68 20 7b 10 80       	push   $0x80107b20
80102e4f:	68 80 36 11 80       	push   $0x80113680
80102e54:	e8 07 19 00 00       	call   80104760 <initlock>
  readsb(dev, &sb);
80102e59:	58                   	pop    %eax
80102e5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e5d:	5a                   	pop    %edx
80102e5e:	50                   	push   %eax
80102e5f:	53                   	push   %ebx
80102e60:	e8 5b e9 ff ff       	call   801017c0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e65:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e68:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e6b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102e6c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e72:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e78:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e7d:	5a                   	pop    %edx
80102e7e:	50                   	push   %eax
80102e7f:	53                   	push   %ebx
80102e80:	e8 4b d2 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102e85:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e88:	83 c4 10             	add    $0x10,%esp
80102e8b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102e8d:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102e93:	7e 1c                	jle    80102eb1 <initlog+0x71>
80102e95:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102e9c:	31 d2                	xor    %edx,%edx
80102e9e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ea0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ea4:	83 c2 04             	add    $0x4,%edx
80102ea7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ead:	39 da                	cmp    %ebx,%edx
80102eaf:	75 ef                	jne    80102ea0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102eb1:	83 ec 0c             	sub    $0xc,%esp
80102eb4:	50                   	push   %eax
80102eb5:	e8 26 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eba:	e8 81 fe ff ff       	call   80102d40 <install_trans>
  log.lh.n = 0;
80102ebf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ec6:	00 00 00 
  write_head(); // clear the log
80102ec9:	e8 12 ff ff ff       	call   80102de0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102ece:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ed1:	c9                   	leave  
80102ed2:	c3                   	ret    
80102ed3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ee0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ee6:	68 80 36 11 80       	push   $0x80113680
80102eeb:	e8 d0 19 00 00       	call   801048c0 <acquire>
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	eb 18                	jmp    80102f0d <begin_op+0x2d>
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 80 36 11 80       	push   $0x80113680
80102f00:	68 80 36 11 80       	push   $0x80113680
80102f05:	e8 b6 13 00 00       	call   801042c0 <sleep>
80102f0a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f0d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f12:	85 c0                	test   %eax,%eax
80102f14:	75 e2                	jne    80102ef8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f16:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f21:	83 c0 01             	add    $0x1,%eax
80102f24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f2a:	83 fa 1e             	cmp    $0x1e,%edx
80102f2d:	7f c9                	jg     80102ef8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f2f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f32:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102f37:	68 80 36 11 80       	push   $0x80113680
80102f3c:	e8 2f 1a 00 00       	call   80104970 <release>
      break;
    }
  }
}
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	c9                   	leave  
80102f45:	c3                   	ret    
80102f46:	8d 76 00             	lea    0x0(%esi),%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	57                   	push   %edi
80102f54:	56                   	push   %esi
80102f55:	53                   	push   %ebx
80102f56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f59:	68 80 36 11 80       	push   $0x80113680
80102f5e:	e8 5d 19 00 00       	call   801048c0 <acquire>
  log.outstanding -= 1;
80102f63:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102f68:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102f6e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102f71:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102f74:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102f76:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102f7b:	0f 85 23 01 00 00    	jne    801030a4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f81:	85 c0                	test   %eax,%eax
80102f83:	0f 85 f7 00 00 00    	jne    80103080 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f89:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102f8c:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102f93:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f96:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f98:	68 80 36 11 80       	push   $0x80113680
80102f9d:	e8 ce 19 00 00       	call   80104970 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fa2:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102fa8:	83 c4 10             	add    $0x10,%esp
80102fab:	85 c9                	test   %ecx,%ecx
80102fad:	0f 8e 8a 00 00 00    	jle    8010303d <end_op+0xed>
80102fb3:	90                   	nop
80102fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fb8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102fbd:	83 ec 08             	sub    $0x8,%esp
80102fc0:	01 d8                	add    %ebx,%eax
80102fc2:	83 c0 01             	add    $0x1,%eax
80102fc5:	50                   	push   %eax
80102fc6:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fcc:	e8 ff d0 ff ff       	call   801000d0 <bread>
80102fd1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fd3:	58                   	pop    %eax
80102fd4:	5a                   	pop    %edx
80102fd5:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102fdc:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102fe2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fe5:	e8 e6 d0 ff ff       	call   801000d0 <bread>
80102fea:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fec:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fef:	83 c4 0c             	add    $0xc,%esp
80102ff2:	68 00 02 00 00       	push   $0x200
80102ff7:	50                   	push   %eax
80102ff8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ffb:	50                   	push   %eax
80102ffc:	e8 6f 1a 00 00       	call   80104a70 <memmove>
    bwrite(to);  // write the log
80103001:	89 34 24             	mov    %esi,(%esp)
80103004:	e8 97 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103009:	89 3c 24             	mov    %edi,(%esp)
8010300c:	e8 cf d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103011:	89 34 24             	mov    %esi,(%esp)
80103014:	e8 c7 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80103022:	7c 94                	jl     80102fb8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103024:	e8 b7 fd ff ff       	call   80102de0 <write_head>
    install_trans(); // Now install writes to home locations
80103029:	e8 12 fd ff ff       	call   80102d40 <install_trans>
    log.lh.n = 0;
8010302e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103035:	00 00 00 
    write_head();    // Erase the transaction from the log
80103038:	e8 a3 fd ff ff       	call   80102de0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010303d:	83 ec 0c             	sub    $0xc,%esp
80103040:	68 80 36 11 80       	push   $0x80113680
80103045:	e8 76 18 00 00       	call   801048c0 <acquire>
    log.committing = 0;
    wakeup(&log);
8010304a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103051:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103058:	00 00 00 
    wakeup(&log);
8010305b:	e8 20 14 00 00       	call   80104480 <wakeup>
    release(&log.lock);
80103060:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103067:	e8 04 19 00 00       	call   80104970 <release>
8010306c:	83 c4 10             	add    $0x10,%esp
  }
}
8010306f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103072:	5b                   	pop    %ebx
80103073:	5e                   	pop    %esi
80103074:	5f                   	pop    %edi
80103075:	5d                   	pop    %ebp
80103076:	c3                   	ret    
80103077:	89 f6                	mov    %esi,%esi
80103079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103080:	83 ec 0c             	sub    $0xc,%esp
80103083:	68 80 36 11 80       	push   $0x80113680
80103088:	e8 f3 13 00 00       	call   80104480 <wakeup>
  }
  release(&log.lock);
8010308d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103094:	e8 d7 18 00 00       	call   80104970 <release>
80103099:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
8010309c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801030a4:	83 ec 0c             	sub    $0xc,%esp
801030a7:	68 24 7b 10 80       	push   $0x80107b24
801030ac:	e8 bf d2 ff ff       	call   80100370 <panic>
801030b1:	eb 0d                	jmp    801030c0 <log_write>
801030b3:	90                   	nop
801030b4:	90                   	nop
801030b5:	90                   	nop
801030b6:	90                   	nop
801030b7:	90                   	nop
801030b8:	90                   	nop
801030b9:	90                   	nop
801030ba:	90                   	nop
801030bb:	90                   	nop
801030bc:	90                   	nop
801030bd:	90                   	nop
801030be:	90                   	nop
801030bf:	90                   	nop

801030c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	53                   	push   %ebx
801030c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030c7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030d0:	83 fa 1d             	cmp    $0x1d,%edx
801030d3:	0f 8f 97 00 00 00    	jg     80103170 <log_write+0xb0>
801030d9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801030de:	83 e8 01             	sub    $0x1,%eax
801030e1:	39 c2                	cmp    %eax,%edx
801030e3:	0f 8d 87 00 00 00    	jge    80103170 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030e9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801030ee:	85 c0                	test   %eax,%eax
801030f0:	0f 8e 87 00 00 00    	jle    8010317d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030f6:	83 ec 0c             	sub    $0xc,%esp
801030f9:	68 80 36 11 80       	push   $0x80113680
801030fe:	e8 bd 17 00 00       	call   801048c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103103:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103109:	83 c4 10             	add    $0x10,%esp
8010310c:	83 fa 00             	cmp    $0x0,%edx
8010310f:	7e 50                	jle    80103161 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103111:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103114:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103116:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
8010311c:	75 0b                	jne    80103129 <log_write+0x69>
8010311e:	eb 38                	jmp    80103158 <log_write+0x98>
80103120:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103127:	74 2f                	je     80103158 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103129:	83 c0 01             	add    $0x1,%eax
8010312c:	39 d0                	cmp    %edx,%eax
8010312e:	75 f0                	jne    80103120 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103130:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103137:	83 c2 01             	add    $0x1,%edx
8010313a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80103140:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103143:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
8010314a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010314d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010314e:	e9 1d 18 00 00       	jmp    80104970 <release>
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103158:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
8010315f:	eb df                	jmp    80103140 <log_write+0x80>
80103161:	8b 43 08             	mov    0x8(%ebx),%eax
80103164:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103169:	75 d5                	jne    80103140 <log_write+0x80>
8010316b:	eb ca                	jmp    80103137 <log_write+0x77>
8010316d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103170:	83 ec 0c             	sub    $0xc,%esp
80103173:	68 33 7b 10 80       	push   $0x80107b33
80103178:	e8 f3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010317d:	83 ec 0c             	sub    $0xc,%esp
80103180:	68 49 7b 10 80       	push   $0x80107b49
80103185:	e8 e6 d1 ff ff       	call   80100370 <panic>
8010318a:	66 90                	xchg   %ax,%ax
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103197:	e8 84 09 00 00       	call   80103b20 <cpuid>
8010319c:	89 c3                	mov    %eax,%ebx
8010319e:	e8 7d 09 00 00       	call   80103b20 <cpuid>
801031a3:	83 ec 04             	sub    $0x4,%esp
801031a6:	53                   	push   %ebx
801031a7:	50                   	push   %eax
801031a8:	68 64 7b 10 80       	push   $0x80107b64
801031ad:	e8 ae d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031b2:	e8 c9 2c 00 00       	call   80105e80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031b7:	e8 e4 08 00 00       	call   80103aa0 <mycpu>
801031bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031be:	b8 01 00 00 00       	mov    $0x1,%eax
801031c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ca:	e8 91 0c 00 00       	call   80103e60 <scheduler>
801031cf:	90                   	nop

801031d0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031d6:	e8 c5 3d 00 00       	call   80106fa0 <switchkvm>
  seginit();
801031db:	e8 c0 3c 00 00       	call   80106ea0 <seginit>
  lapicinit();
801031e0:	e8 9b f7 ff ff       	call   80102980 <lapicinit>
  mpmain();
801031e5:	e8 a6 ff ff ff       	call   80103190 <mpmain>
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801031f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031f4:	83 e4 f0             	and    $0xfffffff0,%esp
801031f7:	ff 71 fc             	pushl  -0x4(%ecx)
801031fa:	55                   	push   %ebp
801031fb:	89 e5                	mov    %esp,%ebp
801031fd:	53                   	push   %ebx
801031fe:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801031ff:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103204:	83 ec 08             	sub    $0x8,%esp
80103207:	68 00 00 40 80       	push   $0x80400000
8010320c:	68 a8 68 11 80       	push   $0x801168a8
80103211:	e8 3a f5 ff ff       	call   80102750 <kinit1>
  kvmalloc();      // kernel page table
80103216:	e8 25 42 00 00       	call   80107440 <kvmalloc>
  mpinit();        // detect other processors
8010321b:	e8 70 01 00 00       	call   80103390 <mpinit>
  lapicinit();     // interrupt controller
80103220:	e8 5b f7 ff ff       	call   80102980 <lapicinit>
  seginit();       // segment descriptors
80103225:	e8 76 3c 00 00       	call   80106ea0 <seginit>
  picinit();       // disable pic
8010322a:	e8 31 03 00 00       	call   80103560 <picinit>
  ioapicinit();    // another interrupt controller
8010322f:	e8 4c f3 ff ff       	call   80102580 <ioapicinit>
  consoleinit();   // console hardware
80103234:	e8 67 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103239:	e8 32 2f 00 00       	call   80106170 <uartinit>
  pinit();         // process table
8010323e:	e8 3d 08 00 00       	call   80103a80 <pinit>
  tvinit();        // trap vectors
80103243:	e8 98 2b 00 00       	call   80105de0 <tvinit>
  binit();         // buffer cache
80103248:	e8 f3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010324d:	e8 9e de ff ff       	call   801010f0 <fileinit>
  ideinit();       // disk 
80103252:	e8 09 f1 ff ff       	call   80102360 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103257:	83 c4 0c             	add    $0xc,%esp
8010325a:	68 8a 00 00 00       	push   $0x8a
8010325f:	68 8c b4 10 80       	push   $0x8010b48c
80103264:	68 00 70 00 80       	push   $0x80007000
80103269:	e8 02 18 00 00       	call   80104a70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010326e:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103275:	00 00 00 
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	05 80 37 11 80       	add    $0x80113780,%eax
80103280:	39 d8                	cmp    %ebx,%eax
80103282:	76 6f                	jbe    801032f3 <main+0x103>
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103288:	e8 13 08 00 00       	call   80103aa0 <mycpu>
8010328d:	39 d8                	cmp    %ebx,%eax
8010328f:	74 49                	je     801032da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103291:	e8 8a f5 ff ff       	call   80102820 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103296:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
8010329b:	c7 05 f8 6f 00 80 d0 	movl   $0x801031d0,0x80006ff8
801032a2:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032a5:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032ac:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801032af:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032b4:	0f b6 03             	movzbl (%ebx),%eax
801032b7:	83 ec 08             	sub    $0x8,%esp
801032ba:	68 00 70 00 00       	push   $0x7000
801032bf:	50                   	push   %eax
801032c0:	e8 0b f8 ff ff       	call   80102ad0 <lapicstartap>
801032c5:	83 c4 10             	add    $0x10,%esp
801032c8:	90                   	nop
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032d6:	85 c0                	test   %eax,%eax
801032d8:	74 f6                	je     801032d0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801032da:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032e1:	00 00 00 
801032e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032ea:	05 80 37 11 80       	add    $0x80113780,%eax
801032ef:	39 c3                	cmp    %eax,%ebx
801032f1:	72 95                	jb     80103288 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032f3:	83 ec 08             	sub    $0x8,%esp
801032f6:	68 00 00 00 8e       	push   $0x8e000000
801032fb:	68 00 00 40 80       	push   $0x80400000
80103300:	e8 bb f4 ff ff       	call   801027c0 <kinit2>
  userinit();      // first user process
80103305:	e8 66 08 00 00       	call   80103b70 <userinit>
  mpmain();        // finish this processor's setup
8010330a:	e8 81 fe ff ff       	call   80103190 <mpmain>
8010330f:	90                   	nop

80103310 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103315:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010331b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010331c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010331f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103322:	39 de                	cmp    %ebx,%esi
80103324:	73 48                	jae    8010336e <mpsearch1+0x5e>
80103326:	8d 76 00             	lea    0x0(%esi),%esi
80103329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103330:	83 ec 04             	sub    $0x4,%esp
80103333:	8d 7e 10             	lea    0x10(%esi),%edi
80103336:	6a 04                	push   $0x4
80103338:	68 78 7b 10 80       	push   $0x80107b78
8010333d:	56                   	push   %esi
8010333e:	e8 cd 16 00 00       	call   80104a10 <memcmp>
80103343:	83 c4 10             	add    $0x10,%esp
80103346:	85 c0                	test   %eax,%eax
80103348:	75 1e                	jne    80103368 <mpsearch1+0x58>
8010334a:	8d 7e 10             	lea    0x10(%esi),%edi
8010334d:	89 f2                	mov    %esi,%edx
8010334f:	31 c9                	xor    %ecx,%ecx
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103358:	0f b6 02             	movzbl (%edx),%eax
8010335b:	83 c2 01             	add    $0x1,%edx
8010335e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103360:	39 fa                	cmp    %edi,%edx
80103362:	75 f4                	jne    80103358 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103364:	84 c9                	test   %cl,%cl
80103366:	74 10                	je     80103378 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103368:	39 fb                	cmp    %edi,%ebx
8010336a:	89 fe                	mov    %edi,%esi
8010336c:	77 c2                	ja     80103330 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010336e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103371:	31 c0                	xor    %eax,%eax
}
80103373:	5b                   	pop    %ebx
80103374:	5e                   	pop    %esi
80103375:	5f                   	pop    %edi
80103376:	5d                   	pop    %ebp
80103377:	c3                   	ret    
80103378:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010337b:	89 f0                	mov    %esi,%eax
8010337d:	5b                   	pop    %ebx
8010337e:	5e                   	pop    %esi
8010337f:	5f                   	pop    %edi
80103380:	5d                   	pop    %ebp
80103381:	c3                   	ret    
80103382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103399:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033a7:	c1 e0 08             	shl    $0x8,%eax
801033aa:	09 d0                	or     %edx,%eax
801033ac:	c1 e0 04             	shl    $0x4,%eax
801033af:	85 c0                	test   %eax,%eax
801033b1:	75 1b                	jne    801033ce <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801033b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033c1:	c1 e0 08             	shl    $0x8,%eax
801033c4:	09 d0                	or     %edx,%eax
801033c6:	c1 e0 0a             	shl    $0xa,%eax
801033c9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801033ce:	ba 00 04 00 00       	mov    $0x400,%edx
801033d3:	e8 38 ff ff ff       	call   80103310 <mpsearch1>
801033d8:	85 c0                	test   %eax,%eax
801033da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033dd:	0f 84 37 01 00 00    	je     8010351a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033e6:	8b 58 04             	mov    0x4(%eax),%ebx
801033e9:	85 db                	test   %ebx,%ebx
801033eb:	0f 84 43 01 00 00    	je     80103534 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801033f7:	83 ec 04             	sub    $0x4,%esp
801033fa:	6a 04                	push   $0x4
801033fc:	68 7d 7b 10 80       	push   $0x80107b7d
80103401:	56                   	push   %esi
80103402:	e8 09 16 00 00       	call   80104a10 <memcmp>
80103407:	83 c4 10             	add    $0x10,%esp
8010340a:	85 c0                	test   %eax,%eax
8010340c:	0f 85 22 01 00 00    	jne    80103534 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103412:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103419:	3c 01                	cmp    $0x1,%al
8010341b:	74 08                	je     80103425 <mpinit+0x95>
8010341d:	3c 04                	cmp    $0x4,%al
8010341f:	0f 85 0f 01 00 00    	jne    80103534 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103425:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010342c:	85 ff                	test   %edi,%edi
8010342e:	74 21                	je     80103451 <mpinit+0xc1>
80103430:	31 d2                	xor    %edx,%edx
80103432:	31 c0                	xor    %eax,%eax
80103434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103438:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010343f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103440:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103443:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103445:	39 c7                	cmp    %eax,%edi
80103447:	75 ef                	jne    80103438 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103449:	84 d2                	test   %dl,%dl
8010344b:	0f 85 e3 00 00 00    	jne    80103534 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103451:	85 f6                	test   %esi,%esi
80103453:	0f 84 db 00 00 00    	je     80103534 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103459:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010345f:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103464:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010346b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103471:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103476:	01 d6                	add    %edx,%esi
80103478:	90                   	nop
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103480:	39 c6                	cmp    %eax,%esi
80103482:	76 23                	jbe    801034a7 <mpinit+0x117>
80103484:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103487:	80 fa 04             	cmp    $0x4,%dl
8010348a:	0f 87 c0 00 00 00    	ja     80103550 <mpinit+0x1c0>
80103490:	ff 24 95 bc 7b 10 80 	jmp    *-0x7fef8444(,%edx,4)
80103497:	89 f6                	mov    %esi,%esi
80103499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034a0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a3:	39 c6                	cmp    %eax,%esi
801034a5:	77 dd                	ja     80103484 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034a7:	85 db                	test   %ebx,%ebx
801034a9:	0f 84 92 00 00 00    	je     80103541 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034b6:	74 15                	je     801034cd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034b8:	ba 22 00 00 00       	mov    $0x22,%edx
801034bd:	b8 70 00 00 00       	mov    $0x70,%eax
801034c2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034c3:	ba 23 00 00 00       	mov    $0x23,%edx
801034c8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034c9:	83 c8 01             	or     $0x1,%eax
801034cc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801034cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034d0:	5b                   	pop    %ebx
801034d1:	5e                   	pop    %esi
801034d2:	5f                   	pop    %edi
801034d3:	5d                   	pop    %ebp
801034d4:	c3                   	ret    
801034d5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801034d8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801034de:	83 f9 07             	cmp    $0x7,%ecx
801034e1:	7f 19                	jg     801034fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801034e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801034ed:	83 c1 01             	add    $0x1,%ecx
801034f0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034f6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801034fc:	83 c0 14             	add    $0x14,%eax
      continue;
801034ff:	e9 7c ff ff ff       	jmp    80103480 <mpinit+0xf0>
80103504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103508:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010350c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010350f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103515:	e9 66 ff ff ff       	jmp    80103480 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010351a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010351f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103524:	e8 e7 fd ff ff       	call   80103310 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103529:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010352b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010352e:	0f 85 af fe ff ff    	jne    801033e3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103534:	83 ec 0c             	sub    $0xc,%esp
80103537:	68 82 7b 10 80       	push   $0x80107b82
8010353c:	e8 2f ce ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103541:	83 ec 0c             	sub    $0xc,%esp
80103544:	68 9c 7b 10 80       	push   $0x80107b9c
80103549:	e8 22 ce ff ff       	call   80100370 <panic>
8010354e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103550:	31 db                	xor    %ebx,%ebx
80103552:	e9 30 ff ff ff       	jmp    80103487 <mpinit+0xf7>
80103557:	66 90                	xchg   %ax,%ax
80103559:	66 90                	xchg   %ax,%ax
8010355b:	66 90                	xchg   %ax,%ax
8010355d:	66 90                	xchg   %ax,%ax
8010355f:	90                   	nop

80103560 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103560:	55                   	push   %ebp
80103561:	ba 21 00 00 00       	mov    $0x21,%edx
80103566:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010356b:	89 e5                	mov    %esp,%ebp
8010356d:	ee                   	out    %al,(%dx)
8010356e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103573:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103574:	5d                   	pop    %ebp
80103575:	c3                   	ret    
80103576:	66 90                	xchg   %ax,%ax
80103578:	66 90                	xchg   %ax,%ax
8010357a:	66 90                	xchg   %ax,%ax
8010357c:	66 90                	xchg   %ax,%ax
8010357e:	66 90                	xchg   %ax,%ax

80103580 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	57                   	push   %edi
80103584:	56                   	push   %esi
80103585:	53                   	push   %ebx
80103586:	83 ec 0c             	sub    $0xc,%esp
80103589:	8b 75 08             	mov    0x8(%ebp),%esi
8010358c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010358f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103595:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010359b:	e8 70 db ff ff       	call   80101110 <filealloc>
801035a0:	85 c0                	test   %eax,%eax
801035a2:	89 06                	mov    %eax,(%esi)
801035a4:	0f 84 a8 00 00 00    	je     80103652 <pipealloc+0xd2>
801035aa:	e8 61 db ff ff       	call   80101110 <filealloc>
801035af:	85 c0                	test   %eax,%eax
801035b1:	89 03                	mov    %eax,(%ebx)
801035b3:	0f 84 87 00 00 00    	je     80103640 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035b9:	e8 62 f2 ff ff       	call   80102820 <kalloc>
801035be:	85 c0                	test   %eax,%eax
801035c0:	89 c7                	mov    %eax,%edi
801035c2:	0f 84 b0 00 00 00    	je     80103678 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035c8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801035cb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035d2:	00 00 00 
  p->writeopen = 1;
801035d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035dc:	00 00 00 
  p->nwrite = 0;
801035df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035e6:	00 00 00 
  p->nread = 0;
801035e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035f0:	00 00 00 
  initlock(&p->lock, "pipe");
801035f3:	68 d0 7b 10 80       	push   $0x80107bd0
801035f8:	50                   	push   %eax
801035f9:	e8 62 11 00 00       	call   80104760 <initlock>
  (*f0)->type = FD_PIPE;
801035fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103600:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103603:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103609:	8b 06                	mov    (%esi),%eax
8010360b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010360f:	8b 06                	mov    (%esi),%eax
80103611:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103615:	8b 06                	mov    (%esi),%eax
80103617:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010361a:	8b 03                	mov    (%ebx),%eax
8010361c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103622:	8b 03                	mov    (%ebx),%eax
80103624:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103628:	8b 03                	mov    (%ebx),%eax
8010362a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010362e:	8b 03                	mov    (%ebx),%eax
80103630:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103633:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103636:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103638:	5b                   	pop    %ebx
80103639:	5e                   	pop    %esi
8010363a:	5f                   	pop    %edi
8010363b:	5d                   	pop    %ebp
8010363c:	c3                   	ret    
8010363d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103640:	8b 06                	mov    (%esi),%eax
80103642:	85 c0                	test   %eax,%eax
80103644:	74 1e                	je     80103664 <pipealloc+0xe4>
    fileclose(*f0);
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	50                   	push   %eax
8010364a:	e8 81 db ff ff       	call   801011d0 <fileclose>
8010364f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103652:	8b 03                	mov    (%ebx),%eax
80103654:	85 c0                	test   %eax,%eax
80103656:	74 0c                	je     80103664 <pipealloc+0xe4>
    fileclose(*f1);
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	50                   	push   %eax
8010365c:	e8 6f db ff ff       	call   801011d0 <fileclose>
80103661:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103664:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103678:	8b 06                	mov    (%esi),%eax
8010367a:	85 c0                	test   %eax,%eax
8010367c:	75 c8                	jne    80103646 <pipealloc+0xc6>
8010367e:	eb d2                	jmp    80103652 <pipealloc+0xd2>

80103680 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	56                   	push   %esi
80103684:	53                   	push   %ebx
80103685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103688:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	53                   	push   %ebx
8010368f:	e8 2c 12 00 00       	call   801048c0 <acquire>
  if(writable){
80103694:	83 c4 10             	add    $0x10,%esp
80103697:	85 f6                	test   %esi,%esi
80103699:	74 45                	je     801036e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010369b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036a1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801036a4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036ab:	00 00 00 
    wakeup(&p->nread);
801036ae:	50                   	push   %eax
801036af:	e8 cc 0d 00 00       	call   80104480 <wakeup>
801036b4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036b7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036bd:	85 d2                	test   %edx,%edx
801036bf:	75 0a                	jne    801036cb <pipeclose+0x4b>
801036c1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036c7:	85 c0                	test   %eax,%eax
801036c9:	74 35                	je     80103700 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d1:	5b                   	pop    %ebx
801036d2:	5e                   	pop    %esi
801036d3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036d4:	e9 97 12 00 00       	jmp    80104970 <release>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801036e0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801036e6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801036e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036f0:	00 00 00 
    wakeup(&p->nwrite);
801036f3:	50                   	push   %eax
801036f4:	e8 87 0d 00 00       	call   80104480 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb b9                	jmp    801036b7 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 67 12 00 00       	call   80104970 <release>
    kfree((char*)p);
80103709:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010370c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010370f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103712:	5b                   	pop    %ebx
80103713:	5e                   	pop    %esi
80103714:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103715:	e9 56 ef ff ff       	jmp    80102670 <kfree>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103720 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	57                   	push   %edi
80103724:	56                   	push   %esi
80103725:	53                   	push   %ebx
80103726:	83 ec 28             	sub    $0x28,%esp
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010372c:	53                   	push   %ebx
8010372d:	e8 8e 11 00 00       	call   801048c0 <acquire>
  for(i = 0; i < n; i++){
80103732:	8b 45 10             	mov    0x10(%ebp),%eax
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	85 c0                	test   %eax,%eax
8010373a:	0f 8e b9 00 00 00    	jle    801037f9 <pipewrite+0xd9>
80103740:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103743:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103749:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103755:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103758:	03 4d 10             	add    0x10(%ebp),%ecx
8010375b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010375e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103764:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010376a:	39 d0                	cmp    %edx,%eax
8010376c:	74 38                	je     801037a6 <pipewrite+0x86>
8010376e:	eb 59                	jmp    801037c9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103770:	e8 cb 03 00 00       	call   80103b40 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	75 34                	jne    801037b0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	57                   	push   %edi
80103780:	e8 fb 0c 00 00       	call   80104480 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103785:	58                   	pop    %eax
80103786:	5a                   	pop    %edx
80103787:	53                   	push   %ebx
80103788:	56                   	push   %esi
80103789:	e8 32 0b 00 00       	call   801042c0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010378e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103794:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010379a:	83 c4 10             	add    $0x10,%esp
8010379d:	05 00 02 00 00       	add    $0x200,%eax
801037a2:	39 c2                	cmp    %eax,%edx
801037a4:	75 2a                	jne    801037d0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801037a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ac:	85 c0                	test   %eax,%eax
801037ae:	75 c0                	jne    80103770 <pipewrite+0x50>
        release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	53                   	push   %ebx
801037b4:	e8 b7 11 00 00       	call   80104970 <release>
        return -1;
801037b9:	83 c4 10             	add    $0x10,%esp
801037bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	5b                   	pop    %ebx
801037c5:	5e                   	pop    %esi
801037c6:	5f                   	pop    %edi
801037c7:	5d                   	pop    %ebp
801037c8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c9:	89 c2                	mov    %eax,%edx
801037cb:	90                   	nop
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801037d3:	8d 42 01             	lea    0x1(%edx),%eax
801037d6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801037da:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037e0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037e6:	0f b6 09             	movzbl (%ecx),%ecx
801037e9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801037ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801037f0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801037f3:	0f 85 65 ff ff ff    	jne    8010375e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037ff:	83 ec 0c             	sub    $0xc,%esp
80103802:	50                   	push   %eax
80103803:	e8 78 0c 00 00       	call   80104480 <wakeup>
  release(&p->lock);
80103808:	89 1c 24             	mov    %ebx,(%esp)
8010380b:	e8 60 11 00 00       	call   80104970 <release>
  return n;
80103810:	83 c4 10             	add    $0x10,%esp
80103813:	8b 45 10             	mov    0x10(%ebp),%eax
80103816:	eb a9                	jmp    801037c1 <pipewrite+0xa1>
80103818:	90                   	nop
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103820 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	57                   	push   %edi
80103824:	56                   	push   %esi
80103825:	53                   	push   %ebx
80103826:	83 ec 18             	sub    $0x18,%esp
80103829:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010382c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010382f:	53                   	push   %ebx
80103830:	e8 8b 10 00 00       	call   801048c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010383e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103844:	75 6a                	jne    801038b0 <piperead+0x90>
80103846:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010384c:	85 f6                	test   %esi,%esi
8010384e:	0f 84 cc 00 00 00    	je     80103920 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103854:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010385a:	eb 2d                	jmp    80103889 <piperead+0x69>
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103860:	83 ec 08             	sub    $0x8,%esp
80103863:	53                   	push   %ebx
80103864:	56                   	push   %esi
80103865:	e8 56 0a 00 00       	call   801042c0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010386a:	83 c4 10             	add    $0x10,%esp
8010386d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103873:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103879:	75 35                	jne    801038b0 <piperead+0x90>
8010387b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103881:	85 d2                	test   %edx,%edx
80103883:	0f 84 97 00 00 00    	je     80103920 <piperead+0x100>
    if(myproc()->killed){
80103889:	e8 b2 02 00 00       	call   80103b40 <myproc>
8010388e:	8b 48 24             	mov    0x24(%eax),%ecx
80103891:	85 c9                	test   %ecx,%ecx
80103893:	74 cb                	je     80103860 <piperead+0x40>
      release(&p->lock);
80103895:	83 ec 0c             	sub    $0xc,%esp
80103898:	53                   	push   %ebx
80103899:	e8 d2 10 00 00       	call   80104970 <release>
      return -1;
8010389e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038a1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801038a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038a9:	5b                   	pop    %ebx
801038aa:	5e                   	pop    %esi
801038ab:	5f                   	pop    %edi
801038ac:	5d                   	pop    %ebp
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038b0:	8b 45 10             	mov    0x10(%ebp),%eax
801038b3:	85 c0                	test   %eax,%eax
801038b5:	7e 69                	jle    80103920 <piperead+0x100>
    if(p->nread == p->nwrite)
801038b7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038bd:	31 c9                	xor    %ecx,%ecx
801038bf:	eb 15                	jmp    801038d6 <piperead+0xb6>
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ce:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801038d4:	74 5a                	je     80103930 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038d6:	8d 70 01             	lea    0x1(%eax),%esi
801038d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801038de:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801038e4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801038e9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038ec:	83 c1 01             	add    $0x1,%ecx
801038ef:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801038f2:	75 d4                	jne    801038c8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038f4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	50                   	push   %eax
801038fe:	e8 7d 0b 00 00       	call   80104480 <wakeup>
  release(&p->lock);
80103903:	89 1c 24             	mov    %ebx,(%esp)
80103906:	e8 65 10 00 00       	call   80104970 <release>
  return i;
8010390b:	8b 45 10             	mov    0x10(%ebp),%eax
8010390e:	83 c4 10             	add    $0x10,%esp
}
80103911:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103914:	5b                   	pop    %ebx
80103915:	5e                   	pop    %esi
80103916:	5f                   	pop    %edi
80103917:	5d                   	pop    %ebp
80103918:	c3                   	ret    
80103919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103920:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103927:	eb cb                	jmp    801038f4 <piperead+0xd4>
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103930:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103933:	eb bf                	jmp    801038f4 <piperead+0xd4>
80103935:	66 90                	xchg   %ax,%ax
80103937:	66 90                	xchg   %ax,%ax
80103939:	66 90                	xchg   %ax,%ax
8010393b:	66 90                	xchg   %ax,%ax
8010393d:	66 90                	xchg   %ax,%ax
8010393f:	90                   	nop

80103940 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103944:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103949:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010394c:	68 20 3d 11 80       	push   $0x80113d20
80103951:	e8 6a 0f 00 00       	call   801048c0 <acquire>
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	eb 17                	jmp    80103972 <allocproc+0x32>
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103960:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103966:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
8010396c:	0f 84 9e 00 00 00    	je     80103a10 <allocproc+0xd0>
    if(p->state == UNUSED)
80103972:	8b 43 0c             	mov    0xc(%ebx),%eax
80103975:	85 c0                	test   %eax,%eax
80103977:	75 e7                	jne    80103960 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103979:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
8010397e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103981:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
80103988:	68 20 3d 11 80       	push   $0x80113d20
found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  /////////////////////////////////////////
  //항상 레벨 0에 들어가고 우선순위는 0이다.
  p->queuelevel = 0;
8010398d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103994:	00 00 00 
  p->priority = 0;
80103997:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->tickleft = 4;
8010399e:	c7 83 84 00 00 00 04 	movl   $0x4,0x84(%ebx)
801039a5:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039a8:	8d 50 01             	lea    0x1(%eax),%edx
801039ab:	89 43 10             	mov    %eax,0x10(%ebx)
  p->queuelevel = 0;
  p->priority = 0;
  p->tickleft = 4;

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
801039ae:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801039b5:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039b8:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
801039be:	e8 ad 0f 00 00       	call   80104970 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039c3:	e8 58 ee ff ff       	call   80102820 <kalloc>
801039c8:	83 c4 10             	add    $0x10,%esp
801039cb:	85 c0                	test   %eax,%eax
801039cd:	89 43 08             	mov    %eax,0x8(%ebx)
801039d0:	74 55                	je     80103a27 <allocproc+0xe7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039d2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039d8:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801039db:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039e0:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801039e3:	c7 40 14 cf 5d 10 80 	movl   $0x80105dcf,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ea:	6a 14                	push   $0x14
801039ec:	6a 00                	push   $0x0
801039ee:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801039ef:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039f2:	e8 c9 0f 00 00       	call   801049c0 <memset>
  p->context->eip = (uint)forkret;
801039f7:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039fa:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801039fd:	c7 40 10 30 3a 10 80 	movl   $0x80103a30,0x10(%eax)

  return p;
80103a04:	89 d8                	mov    %ebx,%eax
}
80103a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a09:	c9                   	leave  
80103a0a:	c3                   	ret    
80103a0b:	90                   	nop
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	68 20 3d 11 80       	push   $0x80113d20
80103a18:	e8 53 0f 00 00       	call   80104970 <release>
  return 0;
80103a1d:	83 c4 10             	add    $0x10,%esp
80103a20:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a25:	c9                   	leave  
80103a26:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103a27:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a2e:	eb d6                	jmp    80103a06 <allocproc+0xc6>

80103a30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a36:	68 20 3d 11 80       	push   $0x80113d20
80103a3b:	e8 30 0f 00 00       	call   80104970 <release>

  if (first) {
80103a40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	75 04                	jne    80103a50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a4c:	c9                   	leave  
80103a4d:	c3                   	ret    
80103a4e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103a50:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103a53:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a5a:	00 00 00 
    iinit(ROOTDEV);
80103a5d:	6a 01                	push   $0x1
80103a5f:	e8 9c dd ff ff       	call   80101800 <iinit>
    initlog(ROOTDEV);
80103a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a6b:	e8 d0 f3 ff ff       	call   80102e40 <initlog>
80103a70:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a73:	c9                   	leave  
80103a74:	c3                   	ret    
80103a75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a80 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a86:	68 d5 7b 10 80       	push   $0x80107bd5
80103a8b:	68 20 3d 11 80       	push   $0x80113d20
80103a90:	e8 cb 0c 00 00       	call   80104760 <initlock>
}
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c9                   	leave  
80103a99:	c3                   	ret    
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103aa0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aa5:	9c                   	pushf  
80103aa6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103aa7:	f6 c4 02             	test   $0x2,%ah
80103aaa:	75 5b                	jne    80103b07 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103aac:	e8 cf ef ff ff       	call   80102a80 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ab1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103ab7:	85 f6                	test   %esi,%esi
80103ab9:	7e 3f                	jle    80103afa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103abb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103ac2:	39 d0                	cmp    %edx,%eax
80103ac4:	74 30                	je     80103af6 <mycpu+0x56>
80103ac6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103acb:	31 d2                	xor    %edx,%edx
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ad0:	83 c2 01             	add    $0x1,%edx
80103ad3:	39 f2                	cmp    %esi,%edx
80103ad5:	74 23                	je     80103afa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103ad7:	0f b6 19             	movzbl (%ecx),%ebx
80103ada:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ae0:	39 d8                	cmp    %ebx,%eax
80103ae2:	75 ec                	jne    80103ad0 <mycpu+0x30>
      return &cpus[i];
80103ae4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103aea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aed:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103aee:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103af3:	5e                   	pop    %esi
80103af4:	5d                   	pop    %ebp
80103af5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103af6:	31 d2                	xor    %edx,%edx
80103af8:	eb ea                	jmp    80103ae4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103afa:	83 ec 0c             	sub    $0xc,%esp
80103afd:	68 dc 7b 10 80       	push   $0x80107bdc
80103b02:	e8 69 c8 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b07:	83 ec 0c             	sub    $0xc,%esp
80103b0a:	68 b8 7c 10 80       	push   $0x80107cb8
80103b0f:	e8 5c c8 ff ff       	call   80100370 <panic>
80103b14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b20 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b26:	e8 75 ff ff ff       	call   80103aa0 <mycpu>
80103b2b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103b30:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103b31:	c1 f8 04             	sar    $0x4,%eax
80103b34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b3a:	c3                   	ret    
80103b3b:	90                   	nop
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b40 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b47:	e8 94 0c 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80103b4c:	e8 4f ff ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103b51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b57:	e8 c4 0c 00 00       	call   80104820 <popcli>
  return p;
}
80103b5c:	83 c4 04             	add    $0x4,%esp
80103b5f:	89 d8                	mov    %ebx,%eax
80103b61:	5b                   	pop    %ebx
80103b62:	5d                   	pop    %ebp
80103b63:	c3                   	ret    
80103b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b70 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	53                   	push   %ebx
80103b74:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b77:	e8 c4 fd ff ff       	call   80103940 <allocproc>
80103b7c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103b7e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103b83:	e8 38 38 00 00       	call   801073c0 <setupkvm>
80103b88:	85 c0                	test   %eax,%eax
80103b8a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b8d:	0f 84 bd 00 00 00    	je     80103c50 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b93:	83 ec 04             	sub    $0x4,%esp
80103b96:	68 2c 00 00 00       	push   $0x2c
80103b9b:	68 60 b4 10 80       	push   $0x8010b460
80103ba0:	50                   	push   %eax
80103ba1:	e8 2a 35 00 00       	call   801070d0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103ba6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103ba9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103baf:	6a 4c                	push   $0x4c
80103bb1:	6a 00                	push   $0x0
80103bb3:	ff 73 18             	pushl  0x18(%ebx)
80103bb6:	e8 05 0e 00 00       	call   801049c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bc3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bc8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bcf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bdd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103be1:	8b 43 18             	mov    0x18(%ebx),%eax
80103be4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103be8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bec:	8b 43 18             	mov    0x18(%ebx),%eax
80103bef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c00:	8b 43 18             	mov    0x18(%ebx),%eax
80103c03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	68 05 7c 10 80       	push   $0x80107c05
80103c14:	50                   	push   %eax
80103c15:	e8 a6 0f 00 00       	call   80104bc0 <safestrcpy>
  p->cwd = namei("/");
80103c1a:	c7 04 24 0e 7c 10 80 	movl   $0x80107c0e,(%esp)
80103c21:	e8 2a e6 ff ff       	call   80102250 <namei>
80103c26:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c29:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c30:	e8 8b 0c 00 00       	call   801048c0 <acquire>

  p->state = RUNNABLE;
80103c35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103c3c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c43:	e8 28 0d 00 00       	call   80104970 <release>
}
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c4e:	c9                   	leave  
80103c4f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	68 ec 7b 10 80       	push   $0x80107bec
80103c58:	e8 13 c7 ff ff       	call   80100370 <panic>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi

80103c60 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c68:	e8 73 0b 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80103c6d:	e8 2e fe ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103c72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c78:	e8 a3 0b 00 00       	call   80104820 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103c7d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103c80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c82:	7e 34                	jle    80103cb8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c84:	83 ec 04             	sub    $0x4,%esp
80103c87:	01 c6                	add    %eax,%esi
80103c89:	56                   	push   %esi
80103c8a:	50                   	push   %eax
80103c8b:	ff 73 04             	pushl  0x4(%ebx)
80103c8e:	e8 7d 35 00 00       	call   80107210 <allocuvm>
80103c93:	83 c4 10             	add    $0x10,%esp
80103c96:	85 c0                	test   %eax,%eax
80103c98:	74 36                	je     80103cd0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103c9a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103c9d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 1b 33 00 00       	call   80106fc0 <switchuvm>
  return 0;
80103ca5:	83 c4 10             	add    $0x10,%esp
80103ca8:	31 c0                	xor    %eax,%eax
}
80103caa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cad:	5b                   	pop    %ebx
80103cae:	5e                   	pop    %esi
80103caf:	5d                   	pop    %ebp
80103cb0:	c3                   	ret    
80103cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103cb8:	74 e0                	je     80103c9a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cba:	83 ec 04             	sub    $0x4,%esp
80103cbd:	01 c6                	add    %eax,%esi
80103cbf:	56                   	push   %esi
80103cc0:	50                   	push   %eax
80103cc1:	ff 73 04             	pushl  0x4(%ebx)
80103cc4:	e8 47 36 00 00       	call   80107310 <deallocuvm>
80103cc9:	83 c4 10             	add    $0x10,%esp
80103ccc:	85 c0                	test   %eax,%eax
80103cce:	75 ca                	jne    80103c9a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cd5:	eb d3                	jmp    80103caa <growproc+0x4a>
80103cd7:	89 f6                	mov    %esi,%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ce9:	e8 f2 0a 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80103cee:	e8 ad fd ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103cf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf9:	e8 22 0b 00 00       	call   80104820 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103cfe:	e8 3d fc ff ff       	call   80103940 <allocproc>
80103d03:	85 c0                	test   %eax,%eax
80103d05:	89 c7                	mov    %eax,%edi
80103d07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d0a:	0f 84 b5 00 00 00    	je     80103dc5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d10:	83 ec 08             	sub    $0x8,%esp
80103d13:	ff 33                	pushl  (%ebx)
80103d15:	ff 73 04             	pushl  0x4(%ebx)
80103d18:	e8 73 37 00 00       	call   80107490 <copyuvm>
80103d1d:	83 c4 10             	add    $0x10,%esp
80103d20:	85 c0                	test   %eax,%eax
80103d22:	89 47 04             	mov    %eax,0x4(%edi)
80103d25:	0f 84 a1 00 00 00    	je     80103dcc <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103d2b:	8b 03                	mov    (%ebx),%eax
80103d2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d30:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d32:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d35:	89 c8                	mov    %ecx,%eax
80103d37:	8b 79 18             	mov    0x18(%ecx),%edi
80103d3a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d3d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103d44:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103d46:	8b 40 18             	mov    0x18(%eax),%eax
80103d49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103d50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d54:	85 c0                	test   %eax,%eax
80103d56:	74 13                	je     80103d6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	50                   	push   %eax
80103d5c:	e8 1f d4 ff ff       	call   80101180 <filedup>
80103d61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103d6b:	83 c6 01             	add    $0x1,%esi
80103d6e:	83 fe 10             	cmp    $0x10,%esi
80103d71:	75 dd                	jne    80103d50 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d79:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103d7c:	e8 4f dc ff ff       	call   801019d0 <idup>
80103d81:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d84:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103d87:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	53                   	push   %ebx
80103d90:	50                   	push   %eax
80103d91:	e8 2a 0e 00 00       	call   80104bc0 <safestrcpy>

  pid = np->pid;
80103d96:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103d99:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103da0:	e8 1b 0b 00 00       	call   801048c0 <acquire>

  np->state = RUNNABLE;
80103da5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103dac:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103db3:	e8 b8 0b 00 00       	call   80104970 <release>

  return pid;
80103db8:	83 c4 10             	add    $0x10,%esp
80103dbb:	89 d8                	mov    %ebx,%eax
}
80103dbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc0:	5b                   	pop    %ebx
80103dc1:	5e                   	pop    %esi
80103dc2:	5f                   	pop    %edi
80103dc3:	5d                   	pop    %ebp
80103dc4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dca:	eb f1                	jmp    80103dbd <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103dcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103dcf:	83 ec 0c             	sub    $0xc,%esp
80103dd2:	ff 77 08             	pushl  0x8(%edi)
80103dd5:	e8 96 e8 ff ff       	call   80102670 <kfree>
    np->kstack = 0;
80103dda:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103de1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103de8:	83 c4 10             	add    $0x10,%esp
80103deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103df0:	eb cb                	jmp    80103dbd <fork+0xdd>
80103df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <priority_boosting>:
//      via swtch back to the scheduler.


void 
priority_boosting(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103e06:	68 20 3d 11 80       	push   $0x80113d20
80103e0b:	e8 b0 0a 00 00       	call   801048c0 <acquire>
80103e10:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e13:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e18:	90                   	nop
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103e20:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103e27:	00 00 00 
        p->tickleft=4;
80103e2a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103e31:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e34:	05 8c 00 00 00       	add    $0x8c,%eax
80103e39:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80103e3e:	75 e0                	jne    80103e20 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	68 20 3d 11 80       	push   $0x80113d20
80103e48:	e8 23 0b 00 00       	call   80104970 <release>
}
80103e4d:	83 c4 10             	add    $0x10,%esp
80103e50:	c9                   	leave  
80103e51:	c3                   	ret    
80103e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <scheduler>:
*/


void
scheduler(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103e69:	e8 32 fc ff ff       	call   80103aa0 <mycpu>
80103e6e:	8d 78 04             	lea    0x4(%eax),%edi
80103e71:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e73:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e7a:	00 00 00 
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103e80:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e81:	83 ec 0c             	sub    $0xc,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e84:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e89:	68 20 3d 11 80       	push   $0x80113d20
80103e8e:	e8 2d 0a 00 00       	call   801048c0 <acquire>
80103e93:	83 c4 10             	add    $0x10,%esp
80103e96:	eb 16                	jmp    80103eae <scheduler+0x4e>
80103e98:	90                   	nop
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ea6:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80103eac:	74 4a                	je     80103ef8 <scheduler+0x98>
      if(p->state != RUNNABLE) continue;
80103eae:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103eb2:	75 ec                	jne    80103ea0 <scheduler+0x40>
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103eb4:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE) continue;
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103eb7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ebd:	53                   	push   %ebx
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebe:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ec4:	e8 f7 30 00 00       	call   80106fc0 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103ec9:	58                   	pop    %eax
80103eca:	5a                   	pop    %edx
80103ecb:	ff 73 90             	pushl  -0x70(%ebx)
80103ece:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103ecf:	c7 43 80 04 00 00 00 	movl   $0x4,-0x80(%ebx)
      swtch(&(c->scheduler), p->context);
80103ed6:	e8 40 0d 00 00       	call   80104c1b <swtch>
      switchkvm();
80103edb:	e8 c0 30 00 00       	call   80106fa0 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ee0:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee3:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ee9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ef0:	00 00 00 
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef3:	75 b9                	jne    80103eae <scheduler+0x4e>
80103ef5:	8d 76 00             	lea    0x0(%esi),%esi
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	68 20 3d 11 80       	push   $0x80113d20
80103f00:	e8 6b 0a 00 00       	call   80104970 <release>
    #endif
  }
80103f05:	83 c4 10             	add    $0x10,%esp
80103f08:	e9 73 ff ff ff       	jmp    80103e80 <scheduler+0x20>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f15:	e8 c6 08 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80103f1a:	e8 81 fb ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103f1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f25:	e8 f6 08 00 00       	call   80104820 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 20 3d 11 80       	push   $0x80113d20
80103f32:	e8 59 09 00 00       	call   80104890 <holding>
80103f37:	83 c4 10             	add    $0x10,%esp
80103f3a:	85 c0                	test   %eax,%eax
80103f3c:	74 4f                	je     80103f8d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103f3e:	e8 5d fb ff ff       	call   80103aa0 <mycpu>
80103f43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f4a:	75 68                	jne    80103fb4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103f4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f50:	74 55                	je     80103fa7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f52:	9c                   	pushf  
80103f53:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103f54:	f6 c4 02             	test   $0x2,%ah
80103f57:	75 41                	jne    80103f9a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f59:	e8 42 fb ff ff       	call   80103aa0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f5e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f67:	e8 34 fb ff ff       	call   80103aa0 <mycpu>
80103f6c:	83 ec 08             	sub    $0x8,%esp
80103f6f:	ff 70 04             	pushl  0x4(%eax)
80103f72:	53                   	push   %ebx
80103f73:	e8 a3 0c 00 00       	call   80104c1b <swtch>
  mycpu()->intena = intena;
80103f78:	e8 23 fb ff ff       	call   80103aa0 <mycpu>
}
80103f7d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103f80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f89:	5b                   	pop    %ebx
80103f8a:	5e                   	pop    %esi
80103f8b:	5d                   	pop    %ebp
80103f8c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103f8d:	83 ec 0c             	sub    $0xc,%esp
80103f90:	68 10 7c 10 80       	push   $0x80107c10
80103f95:	e8 d6 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 3c 7c 10 80       	push   $0x80107c3c
80103fa2:	e8 c9 c3 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	68 2e 7c 10 80       	push   $0x80107c2e
80103faf:	e8 bc c3 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 22 7c 10 80       	push   $0x80107c22
80103fbc:	e8 af c3 ff ff       	call   80100370 <panic>
80103fc1:	eb 0d                	jmp    80103fd0 <exit>
80103fc3:	90                   	nop
80103fc4:	90                   	nop
80103fc5:	90                   	nop
80103fc6:	90                   	nop
80103fc7:	90                   	nop
80103fc8:	90                   	nop
80103fc9:	90                   	nop
80103fca:	90                   	nop
80103fcb:	90                   	nop
80103fcc:	90                   	nop
80103fcd:	90                   	nop
80103fce:	90                   	nop
80103fcf:	90                   	nop

80103fd0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	57                   	push   %edi
80103fd4:	56                   	push   %esi
80103fd5:	53                   	push   %ebx
80103fd6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103fd9:	e8 02 08 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80103fde:	e8 bd fa ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80103fe3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fe9:	e8 32 08 00 00       	call   80104820 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103fee:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103ff4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ff7:	8d 7e 68             	lea    0x68(%esi),%edi
80103ffa:	0f 84 f1 00 00 00    	je     801040f1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104000:	8b 03                	mov    (%ebx),%eax
80104002:	85 c0                	test   %eax,%eax
80104004:	74 12                	je     80104018 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	50                   	push   %eax
8010400a:	e8 c1 d1 ff ff       	call   801011d0 <fileclose>
      curproc->ofile[fd] = 0;
8010400f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104015:	83 c4 10             	add    $0x10,%esp
80104018:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010401b:	39 df                	cmp    %ebx,%edi
8010401d:	75 e1                	jne    80104000 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010401f:	e8 bc ee ff ff       	call   80102ee0 <begin_op>
  iput(curproc->cwd);
80104024:	83 ec 0c             	sub    $0xc,%esp
80104027:	ff 76 68             	pushl  0x68(%esi)
8010402a:	e8 01 db ff ff       	call   80101b30 <iput>
  end_op();
8010402f:	e8 1c ef ff ff       	call   80102f50 <end_op>
  curproc->cwd = 0;
80104034:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010403b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104042:	e8 79 08 00 00       	call   801048c0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104047:	8b 56 14             	mov    0x14(%esi),%edx
8010404a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104052:	eb 10                	jmp    80104064 <exit+0x94>
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104058:	05 8c 00 00 00       	add    $0x8c,%eax
8010405d:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104062:	74 1e                	je     80104082 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104064:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104068:	75 ee                	jne    80104058 <exit+0x88>
8010406a:	3b 50 20             	cmp    0x20(%eax),%edx
8010406d:	75 e9                	jne    80104058 <exit+0x88>
      p->state = RUNNABLE;
8010406f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104076:	05 8c 00 00 00       	add    $0x8c,%eax
8010407b:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104080:	75 e2                	jne    80104064 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104082:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104088:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010408d:	eb 0f                	jmp    8010409e <exit+0xce>
8010408f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104090:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80104096:	81 fa 54 60 11 80    	cmp    $0x80116054,%edx
8010409c:	74 3a                	je     801040d8 <exit+0x108>
    if(p->parent == curproc){
8010409e:	39 72 14             	cmp    %esi,0x14(%edx)
801040a1:	75 ed                	jne    80104090 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801040a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801040a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040aa:	75 e4                	jne    80104090 <exit+0xc0>
801040ac:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801040b1:	eb 11                	jmp    801040c4 <exit+0xf4>
801040b3:	90                   	nop
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b8:	05 8c 00 00 00       	add    $0x8c,%eax
801040bd:	3d 54 60 11 80       	cmp    $0x80116054,%eax
801040c2:	74 cc                	je     80104090 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801040c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040c8:	75 ee                	jne    801040b8 <exit+0xe8>
801040ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801040cd:	75 e9                	jne    801040b8 <exit+0xe8>
      p->state = RUNNABLE;
801040cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040d6:	eb e0                	jmp    801040b8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801040d8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801040df:	e8 2c fe ff ff       	call   80103f10 <sched>
  panic("zombie exit");
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	68 5d 7c 10 80       	push   $0x80107c5d
801040ec:	e8 7f c2 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
801040f1:	83 ec 0c             	sub    $0xc,%esp
801040f4:	68 50 7c 10 80       	push   $0x80107c50
801040f9:	e8 72 c2 ff ff       	call   80100370 <panic>
801040fe:	66 90                	xchg   %ax,%ax

80104100 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104107:	68 20 3d 11 80       	push   $0x80113d20
8010410c:	e8 af 07 00 00       	call   801048c0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104111:	e8 ca 06 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80104116:	e8 85 f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010411b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104121:	e8 fa 06 00 00       	call   80104820 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
80104126:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010412d:	e8 de fd ff ff       	call   80103f10 <sched>
  release(&ptable.lock);
80104132:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104139:	e8 32 08 00 00       	call   80104970 <release>
}
8010413e:	83 c4 10             	add    $0x10,%esp
80104141:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104144:	c9                   	leave  
80104145:	c3                   	ret    
80104146:	8d 76 00             	lea    0x0(%esi),%esi
80104149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104150 <getlev>:

int             
getlev(void)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104157:	e8 84 06 00 00       	call   801047e0 <pushcli>
  c = mycpu();
8010415c:	e8 3f f9 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104161:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104167:	e8 b4 06 00 00       	call   80104820 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
8010416c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104172:	83 c4 04             	add    $0x4,%esp
80104175:	5b                   	pop    %ebx
80104176:	5d                   	pop    %ebp
80104177:	c3                   	ret    
80104178:	90                   	nop
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104180 <getadmin>:

int
getadmin(char *password)
{
80104180:	55                   	push   %ebp
  char my_number[10] = "2016025823";
80104181:	b8 32 33 00 00       	mov    $0x3332,%eax
  int flag = 0;
80104186:	31 d2                	xor    %edx,%edx
  return myproc()->queuelevel;
}

int
getadmin(char *password)
{
80104188:	89 e5                	mov    %esp,%ebp
8010418a:	53                   	push   %ebx
8010418b:	83 ec 14             	sub    $0x14,%esp
8010418e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char my_number[10] = "2016025823";
80104191:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80104195:	c7 45 ee 32 30 31 36 	movl   $0x36313032,-0x12(%ebp)
8010419c:	c7 45 f2 30 32 35 38 	movl   $0x38353230,-0xe(%ebp)
  int flag = 0;
  for(int i=0;i<10;i++){
801041a3:	31 c0                	xor    %eax,%eax
801041a5:	8d 76 00             	lea    0x0(%esi),%esi
    if(my_number[i] == password[i]) flag++;
801041a8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801041ac:	38 4c 05 ee          	cmp    %cl,-0x12(%ebp,%eax,1)
801041b0:	0f 94 c1             	sete   %cl
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801041b3:	83 c0 01             	add    $0x1,%eax
    if(my_number[i] == password[i]) flag++;
801041b6:	0f b6 c9             	movzbl %cl,%ecx
801041b9:	01 ca                	add    %ecx,%edx
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801041bb:	83 f8 0a             	cmp    $0xa,%eax
801041be:	75 e8                	jne    801041a8 <getadmin+0x28>
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
801041c0:	83 fa 0a             	cmp    $0xa,%edx
801041c3:	75 2b                	jne    801041f0 <getadmin+0x70>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041c5:	e8 16 06 00 00       	call   801047e0 <pushcli>
  c = mycpu();
801041ca:	e8 d1 f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801041cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041d5:	e8 46 06 00 00       	call   80104820 <popcli>
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
801041da:	31 c0                	xor    %eax,%eax
  int flag = 0;
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
801041dc:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801041e3:	00 00 00 
    return 0;
  }
  else{
    return -1;
  }
}
801041e6:	83 c4 14             	add    $0x14,%esp
801041e9:	5b                   	pop    %ebx
801041ea:	5d                   	pop    %ebp
801041eb:	c3                   	ret    
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f0:	83 c4 14             	add    $0x14,%esp
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
  }
  else{
    return -1;
801041f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801041f8:	5b                   	pop    %ebx
801041f9:	5d                   	pop    %ebp
801041fa:	c3                   	ret    
801041fb:	90                   	nop
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <setpriority>:

int             
setpriority(int pid, int priority)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	53                   	push   %ebx
80104206:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104209:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
  }
}

int             
setpriority(int pid, int priority)
{
8010420d:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104210:	0f 87 97 00 00 00    	ja     801042ad <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
80104216:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104219:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
8010421e:	68 20 3d 11 80       	push   $0x80113d20
80104223:	e8 98 06 00 00       	call   801048c0 <acquire>
80104228:	83 c4 10             	add    $0x10,%esp
8010422b:	eb 11                	jmp    8010423e <setpriority+0x3e>
8010422d:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104230:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104236:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
8010423c:	74 52                	je     80104290 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
8010423e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104241:	75 ed                	jne    80104230 <setpriority+0x30>
80104243:	8b 43 14             	mov    0x14(%ebx),%eax
80104246:	8b 50 10             	mov    0x10(%eax),%edx
80104249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010424c:	e8 8f 05 00 00       	call   801047e0 <pushcli>
  c = mycpu();
80104251:	e8 4a f8 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
80104256:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010425c:	e8 bf 05 00 00       	call   80104820 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
80104261:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104264:	3b 57 10             	cmp    0x10(%edi),%edx
80104267:	75 c7                	jne    80104230 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104269:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
8010426c:	83 ec 0c             	sub    $0xc,%esp
8010426f:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104274:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
80104277:	e8 f4 06 00 00       	call   80104970 <release>

      return 0;
8010427c:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
8010427f:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
80104282:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
80104284:	5b                   	pop    %ebx
80104285:	5e                   	pop    %esi
80104286:	5f                   	pop    %edi
80104287:	5d                   	pop    %ebp
80104288:	c3                   	ret    
80104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
80104290:	83 ec 0c             	sub    $0xc,%esp
80104293:	68 20 3d 11 80       	push   $0x80113d20
80104298:	e8 d3 06 00 00       	call   80104970 <release>
  return -1;
8010429d:	83 c4 10             	add    $0x10,%esp
801042a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042a8:	5b                   	pop    %ebx
801042a9:	5e                   	pop    %esi
801042aa:	5f                   	pop    %edi
801042ab:	5d                   	pop    %ebp
801042ac:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801042ad:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801042b2:	eb f1                	jmp    801042a5 <setpriority+0xa5>
801042b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801042c0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
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
801042cf:	e8 0c 05 00 00       	call   801047e0 <pushcli>
  c = mycpu();
801042d4:	e8 c7 f7 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
801042d9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042df:	e8 3c 05 00 00       	call   80104820 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
801042e4:	85 db                	test   %ebx,%ebx
801042e6:	0f 84 87 00 00 00    	je     80104373 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
801042ec:	85 f6                	test   %esi,%esi
801042ee:	74 76                	je     80104366 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042f0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801042f6:	74 50                	je     80104348 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 20 3d 11 80       	push   $0x80113d20
80104300:	e8 bb 05 00 00       	call   801048c0 <acquire>
    release(lk);
80104305:	89 34 24             	mov    %esi,(%esp)
80104308:	e8 63 06 00 00       	call   80104970 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010430d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104310:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104317:	e8 f4 fb ff ff       	call   80103f10 <sched>
  // Tidy up.
  p->chan = 0;
8010431c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104323:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010432a:	e8 41 06 00 00       	call   80104970 <release>
    acquire(lk);
8010432f:	89 75 08             	mov    %esi,0x8(%ebp)
80104332:	83 c4 10             	add    $0x10,%esp
  }
}
80104335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104338:	5b                   	pop    %ebx
80104339:	5e                   	pop    %esi
8010433a:	5f                   	pop    %edi
8010433b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010433c:	e9 7f 05 00 00       	jmp    801048c0 <acquire>
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104348:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010434b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104352:	e8 b9 fb ff ff       	call   80103f10 <sched>
  // Tidy up.
  p->chan = 0;
80104357:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010435e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104361:	5b                   	pop    %ebx
80104362:	5e                   	pop    %esi
80104363:	5f                   	pop    %edi
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	68 6f 7c 10 80       	push   $0x80107c6f
8010436e:	e8 fd bf ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104373:	83 ec 0c             	sub    $0xc,%esp
80104376:	68 69 7c 10 80       	push   $0x80107c69
8010437b:	e8 f0 bf ff ff       	call   80100370 <panic>

80104380 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104385:	e8 56 04 00 00       	call   801047e0 <pushcli>
  c = mycpu();
8010438a:	e8 11 f7 ff ff       	call   80103aa0 <mycpu>
  p = c->proc;
8010438f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104395:	e8 86 04 00 00       	call   80104820 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 20 3d 11 80       	push   $0x80113d20
801043a2:	e8 19 05 00 00       	call   801048c0 <acquire>
801043a7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801043aa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ac:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801043b1:	eb 13                	jmp    801043c6 <wait+0x46>
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801043be:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
801043c4:	74 22                	je     801043e8 <wait+0x68>
      if(p->parent != curproc)
801043c6:	39 73 14             	cmp    %esi,0x14(%ebx)
801043c9:	75 ed                	jne    801043b8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801043cb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043cf:	74 35                	je     80104406 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
801043d7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043dc:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
801043e2:	75 e2                	jne    801043c6 <wait+0x46>
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801043e8:	85 c0                	test   %eax,%eax
801043ea:	74 70                	je     8010445c <wait+0xdc>
801043ec:	8b 46 24             	mov    0x24(%esi),%eax
801043ef:	85 c0                	test   %eax,%eax
801043f1:	75 69                	jne    8010445c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043f3:	83 ec 08             	sub    $0x8,%esp
801043f6:	68 20 3d 11 80       	push   $0x80113d20
801043fb:	56                   	push   %esi
801043fc:	e8 bf fe ff ff       	call   801042c0 <sleep>
  }
80104401:	83 c4 10             	add    $0x10,%esp
80104404:	eb a4                	jmp    801043aa <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104406:	83 ec 0c             	sub    $0xc,%esp
80104409:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010440c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010440f:	e8 5c e2 ff ff       	call   80102670 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104414:	5a                   	pop    %edx
80104415:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104418:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010441f:	e8 1c 2f 00 00       	call   80107340 <freevm>
        p->pid = 0;
80104424:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010442b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104432:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104436:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010443d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104444:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010444b:	e8 20 05 00 00       	call   80104970 <release>
        return pid;
80104450:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104453:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104456:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104458:	5b                   	pop    %ebx
80104459:	5e                   	pop    %esi
8010445a:	5d                   	pop    %ebp
8010445b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010445c:	83 ec 0c             	sub    $0xc,%esp
8010445f:	68 20 3d 11 80       	push   $0x80113d20
80104464:	e8 07 05 00 00       	call   80104970 <release>
      return -1;
80104469:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010446c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010446f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104474:	5b                   	pop    %ebx
80104475:	5e                   	pop    %esi
80104476:	5d                   	pop    %ebp
80104477:	c3                   	ret    
80104478:	90                   	nop
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 10             	sub    $0x10,%esp
80104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010448a:	68 20 3d 11 80       	push   $0x80113d20
8010448f:	e8 2c 04 00 00       	call   801048c0 <acquire>
80104494:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104497:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010449c:	eb 0e                	jmp    801044ac <wakeup+0x2c>
8010449e:	66 90                	xchg   %ax,%ax
801044a0:	05 8c 00 00 00       	add    $0x8c,%eax
801044a5:	3d 54 60 11 80       	cmp    $0x80116054,%eax
801044aa:	74 1e                	je     801044ca <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801044ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044b0:	75 ee                	jne    801044a0 <wakeup+0x20>
801044b2:	3b 58 20             	cmp    0x20(%eax),%ebx
801044b5:	75 e9                	jne    801044a0 <wakeup+0x20>
      p->state = RUNNABLE;
801044b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044be:	05 8c 00 00 00       	add    $0x8c,%eax
801044c3:	3d 54 60 11 80       	cmp    $0x80116054,%eax
801044c8:	75 e2                	jne    801044ac <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801044ca:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801044d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801044d5:	e9 96 04 00 00       	jmp    80104970 <release>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	53                   	push   %ebx
801044e4:	83 ec 10             	sub    $0x10,%esp
801044e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ea:	68 20 3d 11 80       	push   $0x80113d20
801044ef:	e8 cc 03 00 00       	call   801048c0 <acquire>
801044f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044fc:	eb 0e                	jmp    8010450c <kill+0x2c>
801044fe:	66 90                	xchg   %ax,%ax
80104500:	05 8c 00 00 00       	add    $0x8c,%eax
80104505:	3d 54 60 11 80       	cmp    $0x80116054,%eax
8010450a:	74 3c                	je     80104548 <kill+0x68>
    if(p->pid == pid){
8010450c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010450f:	75 ef                	jne    80104500 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104511:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104515:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010451c:	74 1a                	je     80104538 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	68 20 3d 11 80       	push   $0x80113d20
80104526:	e8 45 04 00 00       	call   80104970 <release>
      return 0;
8010452b:	83 c4 10             	add    $0x10,%esp
8010452e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104530:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104533:	c9                   	leave  
80104534:	c3                   	ret    
80104535:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104538:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010453f:	eb dd                	jmp    8010451e <kill+0x3e>
80104541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104548:	83 ec 0c             	sub    $0xc,%esp
8010454b:	68 20 3d 11 80       	push   $0x80113d20
80104550:	e8 1b 04 00 00       	call   80104970 <release>
  return -1;
80104555:	83 c4 10             	add    $0x10,%esp
80104558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010455d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104560:	c9                   	leave  
80104561:	c3                   	ret    
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	57                   	push   %edi
80104574:	56                   	push   %esi
80104575:	53                   	push   %ebx
80104576:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104579:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010457e:	83 ec 3c             	sub    $0x3c,%esp
80104581:	eb 27                	jmp    801045aa <procdump+0x3a>
80104583:	90                   	nop
80104584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 0b 80 10 80       	push   $0x8010800b
80104590:	e8 cb c0 ff ff       	call   80100660 <cprintf>
80104595:	83 c4 10             	add    $0x10,%esp
80104598:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010459e:	81 fb c0 60 11 80    	cmp    $0x801160c0,%ebx
801045a4:	0f 84 7e 00 00 00    	je     80104628 <procdump+0xb8>
    if(p->state == UNUSED)
801045aa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801045ad:	85 c0                	test   %eax,%eax
801045af:	74 e7                	je     80104598 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045b1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801045b4:	ba 80 7c 10 80       	mov    $0x80107c80,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045b9:	77 11                	ja     801045cc <procdump+0x5c>
801045bb:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801045c2:	b8 80 7c 10 80       	mov    $0x80107c80,%eax
801045c7:	85 d2                	test   %edx,%edx
801045c9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801045cc:	53                   	push   %ebx
801045cd:	52                   	push   %edx
801045ce:	ff 73 a4             	pushl  -0x5c(%ebx)
801045d1:	68 84 7c 10 80       	push   $0x80107c84
801045d6:	e8 85 c0 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801045db:	83 c4 10             	add    $0x10,%esp
801045de:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045e2:	75 a4                	jne    80104588 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045e4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045e7:	83 ec 08             	sub    $0x8,%esp
801045ea:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045ed:	50                   	push   %eax
801045ee:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045f1:	8b 40 0c             	mov    0xc(%eax),%eax
801045f4:	83 c0 08             	add    $0x8,%eax
801045f7:	50                   	push   %eax
801045f8:	e8 83 01 00 00       	call   80104780 <getcallerpcs>
801045fd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104600:	8b 17                	mov    (%edi),%edx
80104602:	85 d2                	test   %edx,%edx
80104604:	74 82                	je     80104588 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104606:	83 ec 08             	sub    $0x8,%esp
80104609:	83 c7 04             	add    $0x4,%edi
8010460c:	52                   	push   %edx
8010460d:	68 c1 76 10 80       	push   $0x801076c1
80104612:	e8 49 c0 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104617:	83 c4 10             	add    $0x10,%esp
8010461a:	39 f7                	cmp    %esi,%edi
8010461c:	75 e2                	jne    80104600 <procdump+0x90>
8010461e:	e9 65 ff ff ff       	jmp    80104588 <procdump+0x18>
80104623:	90                   	nop
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104628:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010462b:	5b                   	pop    %ebx
8010462c:	5e                   	pop    %esi
8010462d:	5f                   	pop    %edi
8010462e:	5d                   	pop    %ebp
8010462f:	c3                   	ret    

80104630 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010463a:	68 f8 7c 10 80       	push   $0x80107cf8
8010463f:	8d 43 04             	lea    0x4(%ebx),%eax
80104642:	50                   	push   %eax
80104643:	e8 18 01 00 00       	call   80104760 <initlock>
  lk->name = name;
80104648:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010464b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104651:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104654:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010465b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010465e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104661:	c9                   	leave  
80104662:	c3                   	ret    
80104663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	8d 73 04             	lea    0x4(%ebx),%esi
8010467e:	56                   	push   %esi
8010467f:	e8 3c 02 00 00       	call   801048c0 <acquire>
  while (lk->locked) {
80104684:	8b 13                	mov    (%ebx),%edx
80104686:	83 c4 10             	add    $0x10,%esp
80104689:	85 d2                	test   %edx,%edx
8010468b:	74 16                	je     801046a3 <acquiresleep+0x33>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104690:	83 ec 08             	sub    $0x8,%esp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	e8 26 fc ff ff       	call   801042c0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010469a:	8b 03                	mov    (%ebx),%eax
8010469c:	83 c4 10             	add    $0x10,%esp
8010469f:	85 c0                	test   %eax,%eax
801046a1:	75 ed                	jne    80104690 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801046a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046a9:	e8 92 f4 ff ff       	call   80103b40 <myproc>
801046ae:	8b 40 10             	mov    0x10(%eax),%eax
801046b1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046b4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046ba:	5b                   	pop    %ebx
801046bb:	5e                   	pop    %esi
801046bc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801046bd:	e9 ae 02 00 00       	jmp    80104970 <release>
801046c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	8d 73 04             	lea    0x4(%ebx),%esi
801046de:	56                   	push   %esi
801046df:	e8 dc 01 00 00       	call   801048c0 <acquire>
  lk->locked = 0;
801046e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046f1:	89 1c 24             	mov    %ebx,(%esp)
801046f4:	e8 87 fd ff ff       	call   80104480 <wakeup>
  release(&lk->lk);
801046f9:	89 75 08             	mov    %esi,0x8(%ebp)
801046fc:	83 c4 10             	add    $0x10,%esp
}
801046ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104702:	5b                   	pop    %ebx
80104703:	5e                   	pop    %esi
80104704:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104705:	e9 66 02 00 00       	jmp    80104970 <release>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	31 ff                	xor    %edi,%edi
80104718:	83 ec 18             	sub    $0x18,%esp
8010471b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010471e:	8d 73 04             	lea    0x4(%ebx),%esi
80104721:	56                   	push   %esi
80104722:	e8 99 01 00 00       	call   801048c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104727:	8b 03                	mov    (%ebx),%eax
80104729:	83 c4 10             	add    $0x10,%esp
8010472c:	85 c0                	test   %eax,%eax
8010472e:	74 13                	je     80104743 <holdingsleep+0x33>
80104730:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104733:	e8 08 f4 ff ff       	call   80103b40 <myproc>
80104738:	39 58 10             	cmp    %ebx,0x10(%eax)
8010473b:	0f 94 c0             	sete   %al
8010473e:	0f b6 c0             	movzbl %al,%eax
80104741:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104743:	83 ec 0c             	sub    $0xc,%esp
80104746:	56                   	push   %esi
80104747:	e8 24 02 00 00       	call   80104970 <release>
  return r;
}
8010474c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474f:	89 f8                	mov    %edi,%eax
80104751:	5b                   	pop    %ebx
80104752:	5e                   	pop    %esi
80104753:	5f                   	pop    %edi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
80104756:	66 90                	xchg   %ax,%ax
80104758:	66 90                	xchg   %ax,%ax
8010475a:	66 90                	xchg   %ax,%ax
8010475c:	66 90                	xchg   %ax,%ax
8010475e:	66 90                	xchg   %ax,%ax

80104760 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104766:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104769:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010476f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104772:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104784:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010478a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010478d:	31 c0                	xor    %eax,%eax
8010478f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104790:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104796:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010479c:	77 1a                	ja     801047b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010479e:	8b 5a 04             	mov    0x4(%edx),%ebx
801047a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801047a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047a9:	83 f8 0a             	cmp    $0xa,%eax
801047ac:	75 e2                	jne    80104790 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047ae:	5b                   	pop    %ebx
801047af:	5d                   	pop    %ebp
801047b0:	c3                   	ret    
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801047b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801047bf:	83 c0 01             	add    $0x1,%eax
801047c2:	83 f8 0a             	cmp    $0xa,%eax
801047c5:	74 e7                	je     801047ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801047c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801047ce:	83 c0 01             	add    $0x1,%eax
801047d1:	83 f8 0a             	cmp    $0xa,%eax
801047d4:	75 e2                	jne    801047b8 <getcallerpcs+0x38>
801047d6:	eb d6                	jmp    801047ae <getcallerpcs+0x2e>
801047d8:	90                   	nop
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 04             	sub    $0x4,%esp
801047e7:	9c                   	pushf  
801047e8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801047e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047ea:	e8 b1 f2 ff ff       	call   80103aa0 <mycpu>
801047ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047f5:	85 c0                	test   %eax,%eax
801047f7:	75 11                	jne    8010480a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047ff:	e8 9c f2 ff ff       	call   80103aa0 <mycpu>
80104804:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010480a:	e8 91 f2 ff ff       	call   80103aa0 <mycpu>
8010480f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104816:	83 c4 04             	add    $0x4,%esp
80104819:	5b                   	pop    %ebx
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret    
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104820 <popcli>:

void
popcli(void)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104826:	9c                   	pushf  
80104827:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104828:	f6 c4 02             	test   $0x2,%ah
8010482b:	75 52                	jne    8010487f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010482d:	e8 6e f2 ff ff       	call   80103aa0 <mycpu>
80104832:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104838:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010483b:	85 d2                	test   %edx,%edx
8010483d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104843:	78 2d                	js     80104872 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104845:	e8 56 f2 ff ff       	call   80103aa0 <mycpu>
8010484a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104850:	85 d2                	test   %edx,%edx
80104852:	74 0c                	je     80104860 <popcli+0x40>
    sti();
}
80104854:	c9                   	leave  
80104855:	c3                   	ret    
80104856:	8d 76 00             	lea    0x0(%esi),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104860:	e8 3b f2 ff ff       	call   80103aa0 <mycpu>
80104865:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010486b:	85 c0                	test   %eax,%eax
8010486d:	74 e5                	je     80104854 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010486f:	fb                   	sti    
    sti();
}
80104870:	c9                   	leave  
80104871:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104872:	83 ec 0c             	sub    $0xc,%esp
80104875:	68 1a 7d 10 80       	push   $0x80107d1a
8010487a:	e8 f1 ba ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	68 03 7d 10 80       	push   $0x80107d03
80104887:	e8 e4 ba ff ff       	call   80100370 <panic>
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 75 08             	mov    0x8(%ebp),%esi
80104898:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010489a:	e8 41 ff ff ff       	call   801047e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010489f:	8b 06                	mov    (%esi),%eax
801048a1:	85 c0                	test   %eax,%eax
801048a3:	74 10                	je     801048b5 <holding+0x25>
801048a5:	8b 5e 08             	mov    0x8(%esi),%ebx
801048a8:	e8 f3 f1 ff ff       	call   80103aa0 <mycpu>
801048ad:	39 c3                	cmp    %eax,%ebx
801048af:	0f 94 c3             	sete   %bl
801048b2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801048b5:	e8 66 ff ff ff       	call   80104820 <popcli>
  return r;
}
801048ba:	89 d8                	mov    %ebx,%eax
801048bc:	5b                   	pop    %ebx
801048bd:	5e                   	pop    %esi
801048be:	5d                   	pop    %ebp
801048bf:	c3                   	ret    

801048c0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801048c7:	e8 14 ff ff ff       	call   801047e0 <pushcli>
  if(holding(lk))
801048cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	53                   	push   %ebx
801048d3:	e8 b8 ff ff ff       	call   80104890 <holding>
801048d8:	83 c4 10             	add    $0x10,%esp
801048db:	85 c0                	test   %eax,%eax
801048dd:	0f 85 7d 00 00 00    	jne    80104960 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801048e3:	ba 01 00 00 00       	mov    $0x1,%edx
801048e8:	eb 09                	jmp    801048f3 <acquire+0x33>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048f3:	89 d0                	mov    %edx,%eax
801048f5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801048f8:	85 c0                	test   %eax,%eax
801048fa:	75 f4                	jne    801048f0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801048fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104901:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104904:	e8 97 f1 ff ff       	call   80103aa0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104909:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010490b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010490e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104911:	31 c0                	xor    %eax,%eax
80104913:	90                   	nop
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104918:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010491e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104924:	77 1a                	ja     80104940 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104926:	8b 5a 04             	mov    0x4(%edx),%ebx
80104929:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010492c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010492f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104931:	83 f8 0a             	cmp    $0xa,%eax
80104934:	75 e2                	jne    80104918 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104939:	c9                   	leave  
8010493a:	c3                   	ret    
8010493b:	90                   	nop
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104940:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104947:	83 c0 01             	add    $0x1,%eax
8010494a:	83 f8 0a             	cmp    $0xa,%eax
8010494d:	74 e7                	je     80104936 <acquire+0x76>
    pcs[i] = 0;
8010494f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104956:	83 c0 01             	add    $0x1,%eax
80104959:	83 f8 0a             	cmp    $0xa,%eax
8010495c:	75 e2                	jne    80104940 <acquire+0x80>
8010495e:	eb d6                	jmp    80104936 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 21 7d 10 80       	push   $0x80107d21
80104968:	e8 03 ba ff ff       	call   80100370 <panic>
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 10             	sub    $0x10,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010497a:	53                   	push   %ebx
8010497b:	e8 10 ff ff ff       	call   80104890 <holding>
80104980:	83 c4 10             	add    $0x10,%esp
80104983:	85 c0                	test   %eax,%eax
80104985:	74 22                	je     801049a9 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104987:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010498e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104995:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010499a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801049a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a3:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801049a4:	e9 77 fe ff ff       	jmp    80104820 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801049a9:	83 ec 0c             	sub    $0xc,%esp
801049ac:	68 29 7d 10 80       	push   $0x80107d29
801049b1:	e8 ba b9 ff ff       	call   80100370 <panic>
801049b6:	66 90                	xchg   %ax,%ax
801049b8:	66 90                	xchg   %ax,%ax
801049ba:	66 90                	xchg   %ax,%ax
801049bc:	66 90                	xchg   %ax,%ax
801049be:	66 90                	xchg   %ax,%ax

801049c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	53                   	push   %ebx
801049c5:	8b 55 08             	mov    0x8(%ebp),%edx
801049c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049cb:	f6 c2 03             	test   $0x3,%dl
801049ce:	75 05                	jne    801049d5 <memset+0x15>
801049d0:	f6 c1 03             	test   $0x3,%cl
801049d3:	74 13                	je     801049e8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801049d5:	89 d7                	mov    %edx,%edi
801049d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801049da:	fc                   	cld    
801049db:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049dd:	5b                   	pop    %ebx
801049de:	89 d0                	mov    %edx,%eax
801049e0:	5f                   	pop    %edi
801049e1:	5d                   	pop    %ebp
801049e2:	c3                   	ret    
801049e3:	90                   	nop
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801049e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801049ec:	c1 e9 02             	shr    $0x2,%ecx
801049ef:	89 fb                	mov    %edi,%ebx
801049f1:	89 f8                	mov    %edi,%eax
801049f3:	c1 e3 18             	shl    $0x18,%ebx
801049f6:	c1 e0 10             	shl    $0x10,%eax
801049f9:	09 d8                	or     %ebx,%eax
801049fb:	09 f8                	or     %edi,%eax
801049fd:	c1 e7 08             	shl    $0x8,%edi
80104a00:	09 f8                	or     %edi,%eax
80104a02:	89 d7                	mov    %edx,%edi
80104a04:	fc                   	cld    
80104a05:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a07:	5b                   	pop    %ebx
80104a08:	89 d0                	mov    %edx,%eax
80104a0a:	5f                   	pop    %edi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret    
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	57                   	push   %edi
80104a14:	56                   	push   %esi
80104a15:	8b 45 10             	mov    0x10(%ebp),%eax
80104a18:	53                   	push   %ebx
80104a19:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a1f:	85 c0                	test   %eax,%eax
80104a21:	74 29                	je     80104a4c <memcmp+0x3c>
    if(*s1 != *s2)
80104a23:	0f b6 13             	movzbl (%ebx),%edx
80104a26:	0f b6 0e             	movzbl (%esi),%ecx
80104a29:	38 d1                	cmp    %dl,%cl
80104a2b:	75 2b                	jne    80104a58 <memcmp+0x48>
80104a2d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104a30:	31 c0                	xor    %eax,%eax
80104a32:	eb 14                	jmp    80104a48 <memcmp+0x38>
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a38:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104a3d:	83 c0 01             	add    $0x1,%eax
80104a40:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a44:	38 ca                	cmp    %cl,%dl
80104a46:	75 10                	jne    80104a58 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a48:	39 f8                	cmp    %edi,%eax
80104a4a:	75 ec                	jne    80104a38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a4c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104a4d:	31 c0                	xor    %eax,%eax
}
80104a4f:	5e                   	pop    %esi
80104a50:	5f                   	pop    %edi
80104a51:	5d                   	pop    %ebp
80104a52:	c3                   	ret    
80104a53:	90                   	nop
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104a58:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104a5b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104a5c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104a5e:	5e                   	pop    %esi
80104a5f:	5f                   	pop    %edi
80104a60:	5d                   	pop    %ebp
80104a61:	c3                   	ret    
80104a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
80104a75:	8b 45 08             	mov    0x8(%ebp),%eax
80104a78:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a7e:	39 c6                	cmp    %eax,%esi
80104a80:	73 2e                	jae    80104ab0 <memmove+0x40>
80104a82:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104a85:	39 c8                	cmp    %ecx,%eax
80104a87:	73 27                	jae    80104ab0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104a89:	85 db                	test   %ebx,%ebx
80104a8b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104a8e:	74 17                	je     80104aa7 <memmove+0x37>
      *--d = *--s;
80104a90:	29 d9                	sub    %ebx,%ecx
80104a92:	89 cb                	mov    %ecx,%ebx
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a98:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a9c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104a9f:	83 ea 01             	sub    $0x1,%edx
80104aa2:	83 fa ff             	cmp    $0xffffffff,%edx
80104aa5:	75 f1                	jne    80104a98 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104aa7:	5b                   	pop    %ebx
80104aa8:	5e                   	pop    %esi
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    
80104aab:	90                   	nop
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104ab0:	31 d2                	xor    %edx,%edx
80104ab2:	85 db                	test   %ebx,%ebx
80104ab4:	74 f1                	je     80104aa7 <memmove+0x37>
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104ac0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104ac4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ac7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104aca:	39 d3                	cmp    %edx,%ebx
80104acc:	75 f2                	jne    80104ac0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104ace:	5b                   	pop    %ebx
80104acf:	5e                   	pop    %esi
80104ad0:	5d                   	pop    %ebp
80104ad1:	c3                   	ret    
80104ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104ae3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ae4:	eb 8a                	jmp    80104a70 <memmove>
80104ae6:	8d 76 00             	lea    0x0(%esi),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104af8:	53                   	push   %ebx
80104af9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104aff:	85 c9                	test   %ecx,%ecx
80104b01:	74 37                	je     80104b3a <strncmp+0x4a>
80104b03:	0f b6 17             	movzbl (%edi),%edx
80104b06:	0f b6 1e             	movzbl (%esi),%ebx
80104b09:	84 d2                	test   %dl,%dl
80104b0b:	74 3f                	je     80104b4c <strncmp+0x5c>
80104b0d:	38 d3                	cmp    %dl,%bl
80104b0f:	75 3b                	jne    80104b4c <strncmp+0x5c>
80104b11:	8d 47 01             	lea    0x1(%edi),%eax
80104b14:	01 cf                	add    %ecx,%edi
80104b16:	eb 1b                	jmp    80104b33 <strncmp+0x43>
80104b18:	90                   	nop
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b20:	0f b6 10             	movzbl (%eax),%edx
80104b23:	84 d2                	test   %dl,%dl
80104b25:	74 21                	je     80104b48 <strncmp+0x58>
80104b27:	0f b6 19             	movzbl (%ecx),%ebx
80104b2a:	83 c0 01             	add    $0x1,%eax
80104b2d:	89 ce                	mov    %ecx,%esi
80104b2f:	38 da                	cmp    %bl,%dl
80104b31:	75 19                	jne    80104b4c <strncmp+0x5c>
80104b33:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104b35:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104b38:	75 e6                	jne    80104b20 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b3a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104b3b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104b3d:	5e                   	pop    %esi
80104b3e:	5f                   	pop    %edi
80104b3f:	5d                   	pop    %ebp
80104b40:	c3                   	ret    
80104b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b48:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b4c:	0f b6 c2             	movzbl %dl,%eax
80104b4f:	29 d8                	sub    %ebx,%eax
}
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d 76 00             	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 45 08             	mov    0x8(%ebp),%eax
80104b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b6e:	89 c2                	mov    %eax,%edx
80104b70:	eb 19                	jmp    80104b8b <strncpy+0x2b>
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	83 c3 01             	add    $0x1,%ebx
80104b7b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b7f:	83 c2 01             	add    $0x1,%edx
80104b82:	84 c9                	test   %cl,%cl
80104b84:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b87:	74 09                	je     80104b92 <strncpy+0x32>
80104b89:	89 f1                	mov    %esi,%ecx
80104b8b:	85 c9                	test   %ecx,%ecx
80104b8d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b90:	7f e6                	jg     80104b78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b92:	31 c9                	xor    %ecx,%ecx
80104b94:	85 f6                	test   %esi,%esi
80104b96:	7e 17                	jle    80104baf <strncpy+0x4f>
80104b98:	90                   	nop
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ba0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ba4:	89 f3                	mov    %esi,%ebx
80104ba6:	83 c1 01             	add    $0x1,%ecx
80104ba9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104bab:	85 db                	test   %ebx,%ebx
80104bad:	7f f1                	jg     80104ba0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104baf:	5b                   	pop    %ebx
80104bb0:	5e                   	pop    %esi
80104bb1:	5d                   	pop    %ebp
80104bb2:	c3                   	ret    
80104bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104bce:	85 c9                	test   %ecx,%ecx
80104bd0:	7e 26                	jle    80104bf8 <safestrcpy+0x38>
80104bd2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104bd6:	89 c1                	mov    %eax,%ecx
80104bd8:	eb 17                	jmp    80104bf1 <safestrcpy+0x31>
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104be0:	83 c2 01             	add    $0x1,%edx
80104be3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104be7:	83 c1 01             	add    $0x1,%ecx
80104bea:	84 db                	test   %bl,%bl
80104bec:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104bef:	74 04                	je     80104bf5 <safestrcpy+0x35>
80104bf1:	39 f2                	cmp    %esi,%edx
80104bf3:	75 eb                	jne    80104be0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bf5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104bf8:	5b                   	pop    %ebx
80104bf9:	5e                   	pop    %esi
80104bfa:	5d                   	pop    %ebp
80104bfb:	c3                   	ret    
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c00 <strlen>:

int
strlen(const char *s)
{
80104c00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c01:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104c08:	80 3a 00             	cmpb   $0x0,(%edx)
80104c0b:	74 0c                	je     80104c19 <strlen+0x19>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
80104c10:	83 c0 01             	add    $0x1,%eax
80104c13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c17:	75 f7                	jne    80104c10 <strlen+0x10>
    ;
  return n;
}
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    

80104c1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c23:	55                   	push   %ebp
  pushl %ebx
80104c24:	53                   	push   %ebx
  pushl %esi
80104c25:	56                   	push   %esi
  pushl %edi
80104c26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c2b:	5f                   	pop    %edi
  popl %esi
80104c2c:	5e                   	pop    %esi
  popl %ebx
80104c2d:	5b                   	pop    %ebx
  popl %ebp
80104c2e:	5d                   	pop    %ebp
  ret
80104c2f:	c3                   	ret    

80104c30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c3a:	e8 01 ef ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3f:	8b 00                	mov    (%eax),%eax
80104c41:	39 d8                	cmp    %ebx,%eax
80104c43:	76 1b                	jbe    80104c60 <fetchint+0x30>
80104c45:	8d 53 04             	lea    0x4(%ebx),%edx
80104c48:	39 d0                	cmp    %edx,%eax
80104c4a:	72 14                	jb     80104c60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4f:	8b 13                	mov    (%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	83 c4 04             	add    $0x4,%esp
80104c58:	5b                   	pop    %ebx
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    
80104c5b:	90                   	nop
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c65:	eb ee                	jmp    80104c55 <fetchint+0x25>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c7a:	e8 c1 ee ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz)
80104c7f:	39 18                	cmp    %ebx,(%eax)
80104c81:	76 29                	jbe    80104cac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c86:	89 da                	mov    %ebx,%edx
80104c88:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c8a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c8c:	39 c3                	cmp    %eax,%ebx
80104c8e:	73 1c                	jae    80104cac <fetchstr+0x3c>
    if(*s == 0)
80104c90:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c93:	75 10                	jne    80104ca5 <fetchstr+0x35>
80104c95:	eb 29                	jmp    80104cc0 <fetchstr+0x50>
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ca0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ca3:	74 1b                	je     80104cc0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104ca5:	83 c2 01             	add    $0x1,%edx
80104ca8:	39 d0                	cmp    %edx,%eax
80104caa:	77 f4                	ja     80104ca0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104cac:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104cb4:	5b                   	pop    %ebx
80104cb5:	5d                   	pop    %ebp
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cc0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104cc3:	89 d0                	mov    %edx,%eax
80104cc5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104cc7:	5b                   	pop    %ebx
80104cc8:	5d                   	pop    %ebp
80104cc9:	c3                   	ret    
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd5:	e8 66 ee ff ff       	call   80103b40 <myproc>
80104cda:	8b 40 18             	mov    0x18(%eax),%eax
80104cdd:	8b 55 08             	mov    0x8(%ebp),%edx
80104ce0:	8b 40 44             	mov    0x44(%eax),%eax
80104ce3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104ce6:	e8 55 ee ff ff       	call   80103b40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ceb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ced:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cf0:	39 c6                	cmp    %eax,%esi
80104cf2:	73 1c                	jae    80104d10 <argint+0x40>
80104cf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cf7:	39 d0                	cmp    %edx,%eax
80104cf9:	72 15                	jb     80104d10 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104d01:	89 10                	mov    %edx,(%eax)
  return 0;
80104d03:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104d05:	5b                   	pop    %ebx
80104d06:	5e                   	pop    %esi
80104d07:	5d                   	pop    %ebp
80104d08:	c3                   	ret    
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d15:	eb ee                	jmp    80104d05 <argint+0x35>
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	83 ec 10             	sub    $0x10,%esp
80104d28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d2b:	e8 10 ee ff ff       	call   80103b40 <myproc>
80104d30:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104d32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d35:	83 ec 08             	sub    $0x8,%esp
80104d38:	50                   	push   %eax
80104d39:	ff 75 08             	pushl  0x8(%ebp)
80104d3c:	e8 8f ff ff ff       	call   80104cd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d41:	c1 e8 1f             	shr    $0x1f,%eax
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	84 c0                	test   %al,%al
80104d49:	75 2d                	jne    80104d78 <argptr+0x58>
80104d4b:	89 d8                	mov    %ebx,%eax
80104d4d:	c1 e8 1f             	shr    $0x1f,%eax
80104d50:	84 c0                	test   %al,%al
80104d52:	75 24                	jne    80104d78 <argptr+0x58>
80104d54:	8b 16                	mov    (%esi),%edx
80104d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d59:	39 c2                	cmp    %eax,%edx
80104d5b:	76 1b                	jbe    80104d78 <argptr+0x58>
80104d5d:	01 c3                	add    %eax,%ebx
80104d5f:	39 da                	cmp    %ebx,%edx
80104d61:	72 15                	jb     80104d78 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104d63:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d66:	89 02                	mov    %eax,(%edx)
  return 0;
80104d68:	31 c0                	xor    %eax,%eax
}
80104d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d6d:	5b                   	pop    %ebx
80104d6e:	5e                   	pop    %esi
80104d6f:	5d                   	pop    %ebp
80104d70:	c3                   	ret    
80104d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d7d:	eb eb                	jmp    80104d6a <argptr+0x4a>
80104d7f:	90                   	nop

80104d80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d89:	50                   	push   %eax
80104d8a:	ff 75 08             	pushl  0x8(%ebp)
80104d8d:	e8 3e ff ff ff       	call   80104cd0 <argint>
80104d92:	83 c4 10             	add    $0x10,%esp
80104d95:	85 c0                	test   %eax,%eax
80104d97:	78 17                	js     80104db0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d99:	83 ec 08             	sub    $0x8,%esp
80104d9c:	ff 75 0c             	pushl  0xc(%ebp)
80104d9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104da2:	e8 c9 fe ff ff       	call   80104c70 <fetchstr>
80104da7:	83 c4 10             	add    $0x10,%esp
}
80104daa:	c9                   	leave  
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104db5:	c9                   	leave  
80104db6:	c3                   	ret    
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <syscall>:
[SYS_exec2] sys_exec2,
};

void
syscall(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104dc5:	e8 76 ed ff ff       	call   80103b40 <myproc>

  num = curproc->tf->eax;
80104dca:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104dcd:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dcf:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dd5:	83 fa 19             	cmp    $0x19,%edx
80104dd8:	77 1e                	ja     80104df8 <syscall+0x38>
80104dda:	8b 14 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%edx
80104de1:	85 d2                	test   %edx,%edx
80104de3:	74 13                	je     80104df8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104de5:	ff d2                	call   *%edx
80104de7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ded:	5b                   	pop    %ebx
80104dee:	5e                   	pop    %esi
80104def:	5d                   	pop    %ebp
80104df0:	c3                   	ret    
80104df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104df8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104df9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104dfc:	50                   	push   %eax
80104dfd:	ff 73 10             	pushl  0x10(%ebx)
80104e00:	68 31 7d 10 80       	push   $0x80107d31
80104e05:	e8 56 b8 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104e0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104e17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e1a:	5b                   	pop    %ebx
80104e1b:	5e                   	pop    %esi
80104e1c:	5d                   	pop    %ebp
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e26:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e29:	83 ec 34             	sub    $0x34,%esp
80104e2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e32:	56                   	push   %esi
80104e33:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e3a:	e8 31 d4 ff ff       	call   80102270 <nameiparent>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	0f 84 f6 00 00 00    	je     80104f40 <create+0x120>
    return 0;
  ilock(dp);
80104e4a:	83 ec 0c             	sub    $0xc,%esp
80104e4d:	89 c7                	mov    %eax,%edi
80104e4f:	50                   	push   %eax
80104e50:	e8 ab cb ff ff       	call   80101a00 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e55:	83 c4 0c             	add    $0xc,%esp
80104e58:	6a 00                	push   $0x0
80104e5a:	56                   	push   %esi
80104e5b:	57                   	push   %edi
80104e5c:	e8 cf d0 ff ff       	call   80101f30 <dirlookup>
80104e61:	83 c4 10             	add    $0x10,%esp
80104e64:	85 c0                	test   %eax,%eax
80104e66:	89 c3                	mov    %eax,%ebx
80104e68:	74 56                	je     80104ec0 <create+0xa0>
    iunlockput(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	57                   	push   %edi
80104e6e:	e8 1d ce ff ff       	call   80101c90 <iunlockput>
    ilock(ip);
80104e73:	89 1c 24             	mov    %ebx,(%esp)
80104e76:	e8 85 cb ff ff       	call   80101a00 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e7b:	83 c4 10             	add    $0x10,%esp
80104e7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e83:	75 1b                	jne    80104ea0 <create+0x80>
80104e85:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104e8a:	89 d8                	mov    %ebx,%eax
80104e8c:	75 12                	jne    80104ea0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e91:	5b                   	pop    %ebx
80104e92:	5e                   	pop    %esi
80104e93:	5f                   	pop    %edi
80104e94:	5d                   	pop    %ebp
80104e95:	c3                   	ret    
80104e96:	8d 76 00             	lea    0x0(%esi),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
80104ea3:	53                   	push   %ebx
80104ea4:	e8 e7 cd ff ff       	call   80101c90 <iunlockput>
    return 0;
80104ea9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104eaf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eb1:	5b                   	pop    %ebx
80104eb2:	5e                   	pop    %esi
80104eb3:	5f                   	pop    %edi
80104eb4:	5d                   	pop    %ebp
80104eb5:	c3                   	ret    
80104eb6:	8d 76 00             	lea    0x0(%esi),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104ec0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ec4:	83 ec 08             	sub    $0x8,%esp
80104ec7:	50                   	push   %eax
80104ec8:	ff 37                	pushl  (%edi)
80104eca:	e8 c1 c9 ff ff       	call   80101890 <ialloc>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	89 c3                	mov    %eax,%ebx
80104ed6:	0f 84 cc 00 00 00    	je     80104fa8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	50                   	push   %eax
80104ee0:	e8 1b cb ff ff       	call   80101a00 <ilock>
  ip->major = major;
80104ee5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ee9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104eed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ef1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104ef5:	b8 01 00 00 00       	mov    $0x1,%eax
80104efa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104efe:	89 1c 24             	mov    %ebx,(%esp)
80104f01:	e8 4a ca ff ff       	call   80101950 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f0e:	74 40                	je     80104f50 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104f10:	83 ec 04             	sub    $0x4,%esp
80104f13:	ff 73 04             	pushl  0x4(%ebx)
80104f16:	56                   	push   %esi
80104f17:	57                   	push   %edi
80104f18:	e8 73 d2 ff ff       	call   80102190 <dirlink>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 77                	js     80104f9b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	57                   	push   %edi
80104f28:	e8 63 cd ff ff       	call   80101c90 <iunlockput>

  return ip;
80104f2d:	83 c4 10             	add    $0x10,%esp
}
80104f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104f33:	89 d8                	mov    %ebx,%eax
}
80104f35:	5b                   	pop    %ebx
80104f36:	5e                   	pop    %esi
80104f37:	5f                   	pop    %edi
80104f38:	5d                   	pop    %ebp
80104f39:	c3                   	ret    
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104f40:	31 c0                	xor    %eax,%eax
80104f42:	e9 47 ff ff ff       	jmp    80104e8e <create+0x6e>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104f50:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	57                   	push   %edi
80104f59:	e8 f2 c9 ff ff       	call   80101950 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f5e:	83 c4 0c             	add    $0xc,%esp
80104f61:	ff 73 04             	pushl  0x4(%ebx)
80104f64:	68 e8 7d 10 80       	push   $0x80107de8
80104f69:	53                   	push   %ebx
80104f6a:	e8 21 d2 ff ff       	call   80102190 <dirlink>
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	85 c0                	test   %eax,%eax
80104f74:	78 18                	js     80104f8e <create+0x16e>
80104f76:	83 ec 04             	sub    $0x4,%esp
80104f79:	ff 77 04             	pushl  0x4(%edi)
80104f7c:	68 e7 7d 10 80       	push   $0x80107de7
80104f81:	53                   	push   %ebx
80104f82:	e8 09 d2 ff ff       	call   80102190 <dirlink>
80104f87:	83 c4 10             	add    $0x10,%esp
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	79 82                	jns    80104f10 <create+0xf0>
      panic("create dots");
80104f8e:	83 ec 0c             	sub    $0xc,%esp
80104f91:	68 db 7d 10 80       	push   $0x80107ddb
80104f96:	e8 d5 b3 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104f9b:	83 ec 0c             	sub    $0xc,%esp
80104f9e:	68 ea 7d 10 80       	push   $0x80107dea
80104fa3:	e8 c8 b3 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	68 cc 7d 10 80       	push   $0x80107dcc
80104fb0:	e8 bb b3 ff ff       	call   80100370 <panic>
80104fb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
80104fc5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104fca:	89 d3                	mov    %edx,%ebx
80104fcc:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fcf:	50                   	push   %eax
80104fd0:	6a 00                	push   $0x0
80104fd2:	e8 f9 fc ff ff       	call   80104cd0 <argint>
80104fd7:	83 c4 10             	add    $0x10,%esp
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	78 32                	js     80105010 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fde:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fe2:	77 2c                	ja     80105010 <argfd.constprop.0+0x50>
80104fe4:	e8 57 eb ff ff       	call   80103b40 <myproc>
80104fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	74 1c                	je     80105010 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104ff4:	85 f6                	test   %esi,%esi
80104ff6:	74 02                	je     80104ffa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ff8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104ffa:	85 db                	test   %ebx,%ebx
80104ffc:	74 22                	je     80105020 <argfd.constprop.0+0x60>
    *pf = f;
80104ffe:	89 03                	mov    %eax,(%ebx)
  return 0;
80105000:	31 c0                	xor    %eax,%eax
}
80105002:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105010:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105018:	5b                   	pop    %ebx
80105019:	5e                   	pop    %esi
8010501a:	5d                   	pop    %ebp
8010501b:	c3                   	ret    
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105020:	31 c0                	xor    %eax,%eax
80105022:	eb de                	jmp    80105002 <argfd.constprop.0+0x42>
80105024:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010502a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105030 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105030:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105031:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	56                   	push   %esi
80105036:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105037:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010503a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010503d:	e8 7e ff ff ff       	call   80104fc0 <argfd.constprop.0>
80105042:	85 c0                	test   %eax,%eax
80105044:	78 1a                	js     80105060 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105046:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105048:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010504b:	e8 f0 ea ff ff       	call   80103b40 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105050:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105054:	85 d2                	test   %edx,%edx
80105056:	74 18                	je     80105070 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105058:	83 c3 01             	add    $0x1,%ebx
8010505b:	83 fb 10             	cmp    $0x10,%ebx
8010505e:	75 f0                	jne    80105050 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105060:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105068:	5b                   	pop    %ebx
80105069:	5e                   	pop    %esi
8010506a:	5d                   	pop    %ebp
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105070:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	ff 75 f4             	pushl  -0xc(%ebp)
8010507a:	e8 01 c1 ff ff       	call   80101180 <filedup>
  return fd;
8010507f:	83 c4 10             	add    $0x10,%esp
}
80105082:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105085:	89 d8                	mov    %ebx,%eax
}
80105087:	5b                   	pop    %ebx
80105088:	5e                   	pop    %esi
80105089:	5d                   	pop    %ebp
8010508a:	c3                   	ret    
8010508b:	90                   	nop
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <sys_read>:

int
sys_read(void)
{
80105090:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105091:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105093:	89 e5                	mov    %esp,%ebp
80105095:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105098:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010509b:	e8 20 ff ff ff       	call   80104fc0 <argfd.constprop.0>
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 4c                	js     801050f0 <sys_read+0x60>
801050a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	50                   	push   %eax
801050ab:	6a 02                	push   $0x2
801050ad:	e8 1e fc ff ff       	call   80104cd0 <argint>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 37                	js     801050f0 <sys_read+0x60>
801050b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050bc:	83 ec 04             	sub    $0x4,%esp
801050bf:	ff 75 f0             	pushl  -0x10(%ebp)
801050c2:	50                   	push   %eax
801050c3:	6a 01                	push   $0x1
801050c5:	e8 56 fc ff ff       	call   80104d20 <argptr>
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	85 c0                	test   %eax,%eax
801050cf:	78 1f                	js     801050f0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801050d1:	83 ec 04             	sub    $0x4,%esp
801050d4:	ff 75 f0             	pushl  -0x10(%ebp)
801050d7:	ff 75 f4             	pushl  -0xc(%ebp)
801050da:	ff 75 ec             	pushl  -0x14(%ebp)
801050dd:	e8 0e c2 ff ff       	call   801012f0 <fileread>
801050e2:	83 c4 10             	add    $0x10,%esp
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105100 <sys_write>:

int
sys_write(void)
{
80105100:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105101:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105108:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010510b:	e8 b0 fe ff ff       	call   80104fc0 <argfd.constprop.0>
80105110:	85 c0                	test   %eax,%eax
80105112:	78 4c                	js     80105160 <sys_write+0x60>
80105114:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105117:	83 ec 08             	sub    $0x8,%esp
8010511a:	50                   	push   %eax
8010511b:	6a 02                	push   $0x2
8010511d:	e8 ae fb ff ff       	call   80104cd0 <argint>
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	85 c0                	test   %eax,%eax
80105127:	78 37                	js     80105160 <sys_write+0x60>
80105129:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512c:	83 ec 04             	sub    $0x4,%esp
8010512f:	ff 75 f0             	pushl  -0x10(%ebp)
80105132:	50                   	push   %eax
80105133:	6a 01                	push   $0x1
80105135:	e8 e6 fb ff ff       	call   80104d20 <argptr>
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	85 c0                	test   %eax,%eax
8010513f:	78 1f                	js     80105160 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105141:	83 ec 04             	sub    $0x4,%esp
80105144:	ff 75 f0             	pushl  -0x10(%ebp)
80105147:	ff 75 f4             	pushl  -0xc(%ebp)
8010514a:	ff 75 ec             	pushl  -0x14(%ebp)
8010514d:	e8 2e c2 ff ff       	call   80101380 <filewrite>
80105152:	83 c4 10             	add    $0x10,%esp
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105170 <sys_close>:

int
sys_close(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105176:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105179:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010517c:	e8 3f fe ff ff       	call   80104fc0 <argfd.constprop.0>
80105181:	85 c0                	test   %eax,%eax
80105183:	78 2b                	js     801051b0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105185:	e8 b6 e9 ff ff       	call   80103b40 <myproc>
8010518a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010518d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105190:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105197:	00 
  fileclose(f);
80105198:	ff 75 f4             	pushl  -0xc(%ebp)
8010519b:	e8 30 c0 ff ff       	call   801011d0 <fileclose>
  return 0;
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	31 c0                	xor    %eax,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051c0 <sys_fstat>:

int
sys_fstat(void)
{
801051c0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051c1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051cb:	e8 f0 fd ff ff       	call   80104fc0 <argfd.constprop.0>
801051d0:	85 c0                	test   %eax,%eax
801051d2:	78 2c                	js     80105200 <sys_fstat+0x40>
801051d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051d7:	83 ec 04             	sub    $0x4,%esp
801051da:	6a 14                	push   $0x14
801051dc:	50                   	push   %eax
801051dd:	6a 01                	push   $0x1
801051df:	e8 3c fb ff ff       	call   80104d20 <argptr>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	78 15                	js     80105200 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801051eb:	83 ec 08             	sub    $0x8,%esp
801051ee:	ff 75 f4             	pushl  -0xc(%ebp)
801051f1:	ff 75 f0             	pushl  -0x10(%ebp)
801051f4:	e8 a7 c0 ff ff       	call   801012a0 <filestat>
801051f9:	83 c4 10             	add    $0x10,%esp
}
801051fc:	c9                   	leave  
801051fd:	c3                   	ret    
801051fe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
80105215:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105216:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105219:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 5c fb ff ff       	call   80104d80 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 fb 00 00 00    	js     8010532a <sys_link+0x11a>
8010522f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105232:	83 ec 08             	sub    $0x8,%esp
80105235:	50                   	push   %eax
80105236:	6a 01                	push   $0x1
80105238:	e8 43 fb ff ff       	call   80104d80 <argstr>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	0f 88 e2 00 00 00    	js     8010532a <sys_link+0x11a>
    return -1;

  begin_op();
80105248:	e8 93 dc ff ff       	call   80102ee0 <begin_op>
  if((ip = namei(old)) == 0){
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	ff 75 d4             	pushl  -0x2c(%ebp)
80105253:	e8 f8 cf ff ff       	call   80102250 <namei>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	85 c0                	test   %eax,%eax
8010525d:	89 c3                	mov    %eax,%ebx
8010525f:	0f 84 f3 00 00 00    	je     80105358 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	50                   	push   %eax
80105269:	e8 92 c7 ff ff       	call   80101a00 <ilock>
  if(ip->type == T_DIR){
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105276:	0f 84 c4 00 00 00    	je     80105340 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010527c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105281:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105284:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105287:	53                   	push   %ebx
80105288:	e8 c3 c6 ff ff       	call   80101950 <iupdate>
  iunlock(ip);
8010528d:	89 1c 24             	mov    %ebx,(%esp)
80105290:	e8 4b c8 ff ff       	call   80101ae0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105295:	58                   	pop    %eax
80105296:	5a                   	pop    %edx
80105297:	57                   	push   %edi
80105298:	ff 75 d0             	pushl  -0x30(%ebp)
8010529b:	e8 d0 cf ff ff       	call   80102270 <nameiparent>
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	85 c0                	test   %eax,%eax
801052a5:	89 c6                	mov    %eax,%esi
801052a7:	74 5b                	je     80105304 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 4e c7 ff ff       	call   80101a00 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	8b 03                	mov    (%ebx),%eax
801052b7:	39 06                	cmp    %eax,(%esi)
801052b9:	75 3d                	jne    801052f8 <sys_link+0xe8>
801052bb:	83 ec 04             	sub    $0x4,%esp
801052be:	ff 73 04             	pushl  0x4(%ebx)
801052c1:	57                   	push   %edi
801052c2:	56                   	push   %esi
801052c3:	e8 c8 ce ff ff       	call   80102190 <dirlink>
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	85 c0                	test   %eax,%eax
801052cd:	78 29                	js     801052f8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801052cf:	83 ec 0c             	sub    $0xc,%esp
801052d2:	56                   	push   %esi
801052d3:	e8 b8 c9 ff ff       	call   80101c90 <iunlockput>
  iput(ip);
801052d8:	89 1c 24             	mov    %ebx,(%esp)
801052db:	e8 50 c8 ff ff       	call   80101b30 <iput>

  end_op();
801052e0:	e8 6b dc ff ff       	call   80102f50 <end_op>

  return 0;
801052e5:	83 c4 10             	add    $0x10,%esp
801052e8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801052ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ed:	5b                   	pop    %ebx
801052ee:	5e                   	pop    %esi
801052ef:	5f                   	pop    %edi
801052f0:	5d                   	pop    %ebp
801052f1:	c3                   	ret    
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	56                   	push   %esi
801052fc:	e8 8f c9 ff ff       	call   80101c90 <iunlockput>
    goto bad;
80105301:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	53                   	push   %ebx
80105308:	e8 f3 c6 ff ff       	call   80101a00 <ilock>
  ip->nlink--;
8010530d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105312:	89 1c 24             	mov    %ebx,(%esp)
80105315:	e8 36 c6 ff ff       	call   80101950 <iupdate>
  iunlockput(ip);
8010531a:	89 1c 24             	mov    %ebx,(%esp)
8010531d:	e8 6e c9 ff ff       	call   80101c90 <iunlockput>
  end_op();
80105322:	e8 29 dc ff ff       	call   80102f50 <end_op>
  return -1;
80105327:	83 c4 10             	add    $0x10,%esp
}
8010532a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010532d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105332:	5b                   	pop    %ebx
80105333:	5e                   	pop    %esi
80105334:	5f                   	pop    %edi
80105335:	5d                   	pop    %ebp
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	53                   	push   %ebx
80105344:	e8 47 c9 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105349:	e8 02 dc ff ff       	call   80102f50 <end_op>
    return -1;
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105356:	eb 92                	jmp    801052ea <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105358:	e8 f3 db ff ff       	call   80102f50 <end_op>
    return -1;
8010535d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105362:	eb 86                	jmp    801052ea <sys_link+0xda>
80105364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010536a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105370 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105376:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105379:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010537c:	50                   	push   %eax
8010537d:	6a 00                	push   $0x0
8010537f:	e8 fc f9 ff ff       	call   80104d80 <argstr>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	0f 88 82 01 00 00    	js     80105511 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010538f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105392:	e8 49 db ff ff       	call   80102ee0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	53                   	push   %ebx
8010539b:	ff 75 c0             	pushl  -0x40(%ebp)
8010539e:	e8 cd ce ff ff       	call   80102270 <nameiparent>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053ab:	0f 84 6a 01 00 00    	je     8010551b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
801053b1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	56                   	push   %esi
801053b8:	e8 43 c6 ff ff       	call   80101a00 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053bd:	58                   	pop    %eax
801053be:	5a                   	pop    %edx
801053bf:	68 e8 7d 10 80       	push   $0x80107de8
801053c4:	53                   	push   %ebx
801053c5:	e8 46 cb ff ff       	call   80101f10 <namecmp>
801053ca:	83 c4 10             	add    $0x10,%esp
801053cd:	85 c0                	test   %eax,%eax
801053cf:	0f 84 fc 00 00 00    	je     801054d1 <sys_unlink+0x161>
801053d5:	83 ec 08             	sub    $0x8,%esp
801053d8:	68 e7 7d 10 80       	push   $0x80107de7
801053dd:	53                   	push   %ebx
801053de:	e8 2d cb ff ff       	call   80101f10 <namecmp>
801053e3:	83 c4 10             	add    $0x10,%esp
801053e6:	85 c0                	test   %eax,%eax
801053e8:	0f 84 e3 00 00 00    	je     801054d1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801053ee:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053f1:	83 ec 04             	sub    $0x4,%esp
801053f4:	50                   	push   %eax
801053f5:	53                   	push   %ebx
801053f6:	56                   	push   %esi
801053f7:	e8 34 cb ff ff       	call   80101f30 <dirlookup>
801053fc:	83 c4 10             	add    $0x10,%esp
801053ff:	85 c0                	test   %eax,%eax
80105401:	89 c3                	mov    %eax,%ebx
80105403:	0f 84 c8 00 00 00    	je     801054d1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105409:	83 ec 0c             	sub    $0xc,%esp
8010540c:	50                   	push   %eax
8010540d:	e8 ee c5 ff ff       	call   80101a00 <ilock>

  if(ip->nlink < 1)
80105412:	83 c4 10             	add    $0x10,%esp
80105415:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010541a:	0f 8e 24 01 00 00    	jle    80105544 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105420:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105425:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105428:	74 66                	je     80105490 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010542a:	83 ec 04             	sub    $0x4,%esp
8010542d:	6a 10                	push   $0x10
8010542f:	6a 00                	push   $0x0
80105431:	56                   	push   %esi
80105432:	e8 89 f5 ff ff       	call   801049c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105437:	6a 10                	push   $0x10
80105439:	ff 75 c4             	pushl  -0x3c(%ebp)
8010543c:	56                   	push   %esi
8010543d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105440:	e8 9b c9 ff ff       	call   80101de0 <writei>
80105445:	83 c4 20             	add    $0x20,%esp
80105448:	83 f8 10             	cmp    $0x10,%eax
8010544b:	0f 85 e6 00 00 00    	jne    80105537 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105451:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105456:	0f 84 9c 00 00 00    	je     801054f8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105462:	e8 29 c8 ff ff       	call   80101c90 <iunlockput>

  ip->nlink--;
80105467:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010546c:	89 1c 24             	mov    %ebx,(%esp)
8010546f:	e8 dc c4 ff ff       	call   80101950 <iupdate>
  iunlockput(ip);
80105474:	89 1c 24             	mov    %ebx,(%esp)
80105477:	e8 14 c8 ff ff       	call   80101c90 <iunlockput>

  end_op();
8010547c:	e8 cf da ff ff       	call   80102f50 <end_op>

  return 0;
80105481:	83 c4 10             	add    $0x10,%esp
80105484:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105489:	5b                   	pop    %ebx
8010548a:	5e                   	pop    %esi
8010548b:	5f                   	pop    %edi
8010548c:	5d                   	pop    %ebp
8010548d:	c3                   	ret    
8010548e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105490:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105494:	76 94                	jbe    8010542a <sys_unlink+0xba>
80105496:	bf 20 00 00 00       	mov    $0x20,%edi
8010549b:	eb 0f                	jmp    801054ac <sys_unlink+0x13c>
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
801054a0:	83 c7 10             	add    $0x10,%edi
801054a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801054a6:	0f 83 7e ff ff ff    	jae    8010542a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054ac:	6a 10                	push   $0x10
801054ae:	57                   	push   %edi
801054af:	56                   	push   %esi
801054b0:	53                   	push   %ebx
801054b1:	e8 2a c8 ff ff       	call   80101ce0 <readi>
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	83 f8 10             	cmp    $0x10,%eax
801054bc:	75 6c                	jne    8010552a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054be:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054c3:	74 db                	je     801054a0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801054c5:	83 ec 0c             	sub    $0xc,%esp
801054c8:	53                   	push   %ebx
801054c9:	e8 c2 c7 ff ff       	call   80101c90 <iunlockput>
    goto bad;
801054ce:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801054d1:	83 ec 0c             	sub    $0xc,%esp
801054d4:	ff 75 b4             	pushl  -0x4c(%ebp)
801054d7:	e8 b4 c7 ff ff       	call   80101c90 <iunlockput>
  end_op();
801054dc:	e8 6f da ff ff       	call   80102f50 <end_op>
  return -1;
801054e1:	83 c4 10             	add    $0x10,%esp
}
801054e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801054e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ec:	5b                   	pop    %ebx
801054ed:	5e                   	pop    %esi
801054ee:	5f                   	pop    %edi
801054ef:	5d                   	pop    %ebp
801054f0:	c3                   	ret    
801054f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801054f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801054fb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801054fe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105503:	50                   	push   %eax
80105504:	e8 47 c4 ff ff       	call   80101950 <iupdate>
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	e9 4b ff ff ff       	jmp    8010545c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105516:	e9 6b ff ff ff       	jmp    80105486 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010551b:	e8 30 da ff ff       	call   80102f50 <end_op>
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105525:	e9 5c ff ff ff       	jmp    80105486 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	68 0c 7e 10 80       	push   $0x80107e0c
80105532:	e8 39 ae ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105537:	83 ec 0c             	sub    $0xc,%esp
8010553a:	68 1e 7e 10 80       	push   $0x80107e1e
8010553f:	e8 2c ae ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	68 fa 7d 10 80       	push   $0x80107dfa
8010554c:	e8 1f ae ff ff       	call   80100370 <panic>
80105551:	eb 0d                	jmp    80105560 <sys_open>
80105553:	90                   	nop
80105554:	90                   	nop
80105555:	90                   	nop
80105556:	90                   	nop
80105557:	90                   	nop
80105558:	90                   	nop
80105559:	90                   	nop
8010555a:	90                   	nop
8010555b:	90                   	nop
8010555c:	90                   	nop
8010555d:	90                   	nop
8010555e:	90                   	nop
8010555f:	90                   	nop

80105560 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105566:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105569:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010556c:	50                   	push   %eax
8010556d:	6a 00                	push   $0x0
8010556f:	e8 0c f8 ff ff       	call   80104d80 <argstr>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	85 c0                	test   %eax,%eax
80105579:	0f 88 9e 00 00 00    	js     8010561d <sys_open+0xbd>
8010557f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105582:	83 ec 08             	sub    $0x8,%esp
80105585:	50                   	push   %eax
80105586:	6a 01                	push   $0x1
80105588:	e8 43 f7 ff ff       	call   80104cd0 <argint>
8010558d:	83 c4 10             	add    $0x10,%esp
80105590:	85 c0                	test   %eax,%eax
80105592:	0f 88 85 00 00 00    	js     8010561d <sys_open+0xbd>
    return -1;

  begin_op();
80105598:	e8 43 d9 ff ff       	call   80102ee0 <begin_op>

  if(omode & O_CREATE){
8010559d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055a1:	0f 85 89 00 00 00    	jne    80105630 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055a7:	83 ec 0c             	sub    $0xc,%esp
801055aa:	ff 75 e0             	pushl  -0x20(%ebp)
801055ad:	e8 9e cc ff ff       	call   80102250 <namei>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	85 c0                	test   %eax,%eax
801055b7:	89 c6                	mov    %eax,%esi
801055b9:	0f 84 8e 00 00 00    	je     8010564d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	50                   	push   %eax
801055c3:	e8 38 c4 ff ff       	call   80101a00 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055d0:	0f 84 d2 00 00 00    	je     801056a8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055d6:	e8 35 bb ff ff       	call   80101110 <filealloc>
801055db:	85 c0                	test   %eax,%eax
801055dd:	89 c7                	mov    %eax,%edi
801055df:	74 2b                	je     8010560c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055e1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801055e3:	e8 58 e5 ff ff       	call   80103b40 <myproc>
801055e8:	90                   	nop
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801055f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055f4:	85 d2                	test   %edx,%edx
801055f6:	74 68                	je     80105660 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055f8:	83 c3 01             	add    $0x1,%ebx
801055fb:	83 fb 10             	cmp    $0x10,%ebx
801055fe:	75 f0                	jne    801055f0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105600:	83 ec 0c             	sub    $0xc,%esp
80105603:	57                   	push   %edi
80105604:	e8 c7 bb ff ff       	call   801011d0 <fileclose>
80105609:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	56                   	push   %esi
80105610:	e8 7b c6 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105615:	e8 36 d9 ff ff       	call   80102f50 <end_op>
    return -1;
8010561a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010561d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105625:	5b                   	pop    %ebx
80105626:	5e                   	pop    %esi
80105627:	5f                   	pop    %edi
80105628:	5d                   	pop    %ebp
80105629:	c3                   	ret    
8010562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105636:	31 c9                	xor    %ecx,%ecx
80105638:	6a 00                	push   $0x0
8010563a:	ba 02 00 00 00       	mov    $0x2,%edx
8010563f:	e8 dc f7 ff ff       	call   80104e20 <create>
    if(ip == 0){
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105649:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010564b:	75 89                	jne    801055d6 <sys_open+0x76>
      end_op();
8010564d:	e8 fe d8 ff ff       	call   80102f50 <end_op>
      return -1;
80105652:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105657:	eb 43                	jmp    8010569c <sys_open+0x13c>
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105663:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105667:	56                   	push   %esi
80105668:	e8 73 c4 ff ff       	call   80101ae0 <iunlock>
  end_op();
8010566d:	e8 de d8 ff ff       	call   80102f50 <end_op>

  f->type = FD_INODE;
80105672:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010567b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010567e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105681:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105688:	89 d0                	mov    %edx,%eax
8010568a:	83 e0 01             	and    $0x1,%eax
8010568d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105690:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105693:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105696:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010569a:	89 d8                	mov    %ebx,%eax
}
8010569c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010569f:	5b                   	pop    %ebx
801056a0:	5e                   	pop    %esi
801056a1:	5f                   	pop    %edi
801056a2:	5d                   	pop    %ebp
801056a3:	c3                   	ret    
801056a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801056a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056ab:	85 c9                	test   %ecx,%ecx
801056ad:	0f 84 23 ff ff ff    	je     801055d6 <sys_open+0x76>
801056b3:	e9 54 ff ff ff       	jmp    8010560c <sys_open+0xac>
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056c6:	e8 15 d8 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ce:	83 ec 08             	sub    $0x8,%esp
801056d1:	50                   	push   %eax
801056d2:	6a 00                	push   $0x0
801056d4:	e8 a7 f6 ff ff       	call   80104d80 <argstr>
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	85 c0                	test   %eax,%eax
801056de:	78 30                	js     80105710 <sys_mkdir+0x50>
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e6:	31 c9                	xor    %ecx,%ecx
801056e8:	6a 00                	push   $0x0
801056ea:	ba 01 00 00 00       	mov    $0x1,%edx
801056ef:	e8 2c f7 ff ff       	call   80104e20 <create>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	74 15                	je     80105710 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056fb:	83 ec 0c             	sub    $0xc,%esp
801056fe:	50                   	push   %eax
801056ff:	e8 8c c5 ff ff       	call   80101c90 <iunlockput>
  end_op();
80105704:	e8 47 d8 ff ff       	call   80102f50 <end_op>
  return 0;
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	31 c0                	xor    %eax,%eax
}
8010570e:	c9                   	leave  
8010570f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105710:	e8 3b d8 ff ff       	call   80102f50 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_mknod>:

int
sys_mknod(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105726:	e8 b5 d7 ff ff       	call   80102ee0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010572b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010572e:	83 ec 08             	sub    $0x8,%esp
80105731:	50                   	push   %eax
80105732:	6a 00                	push   $0x0
80105734:	e8 47 f6 ff ff       	call   80104d80 <argstr>
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	85 c0                	test   %eax,%eax
8010573e:	78 60                	js     801057a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105740:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105743:	83 ec 08             	sub    $0x8,%esp
80105746:	50                   	push   %eax
80105747:	6a 01                	push   $0x1
80105749:	e8 82 f5 ff ff       	call   80104cd0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	85 c0                	test   %eax,%eax
80105753:	78 4b                	js     801057a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105755:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105758:	83 ec 08             	sub    $0x8,%esp
8010575b:	50                   	push   %eax
8010575c:	6a 02                	push   $0x2
8010575e:	e8 6d f5 ff ff       	call   80104cd0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	78 36                	js     801057a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010576a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010576e:	83 ec 0c             	sub    $0xc,%esp
80105771:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105775:	ba 03 00 00 00       	mov    $0x3,%edx
8010577a:	50                   	push   %eax
8010577b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010577e:	e8 9d f6 ff ff       	call   80104e20 <create>
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	74 16                	je     801057a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010578a:	83 ec 0c             	sub    $0xc,%esp
8010578d:	50                   	push   %eax
8010578e:	e8 fd c4 ff ff       	call   80101c90 <iunlockput>
  end_op();
80105793:	e8 b8 d7 ff ff       	call   80102f50 <end_op>
  return 0;
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	31 c0                	xor    %eax,%eax
}
8010579d:	c9                   	leave  
8010579e:	c3                   	ret    
8010579f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801057a0:	e8 ab d7 ff ff       	call   80102f50 <end_op>
    return -1;
801057a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_chdir>:

int
sys_chdir(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	56                   	push   %esi
801057b4:	53                   	push   %ebx
801057b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057b8:	e8 83 e3 ff ff       	call   80103b40 <myproc>
801057bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057bf:	e8 1c d7 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c7:	83 ec 08             	sub    $0x8,%esp
801057ca:	50                   	push   %eax
801057cb:	6a 00                	push   $0x0
801057cd:	e8 ae f5 ff ff       	call   80104d80 <argstr>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	78 77                	js     80105850 <sys_chdir+0xa0>
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	ff 75 f4             	pushl  -0xc(%ebp)
801057df:	e8 6c ca ff ff       	call   80102250 <namei>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	89 c3                	mov    %eax,%ebx
801057eb:	74 63                	je     80105850 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	50                   	push   %eax
801057f1:	e8 0a c2 ff ff       	call   80101a00 <ilock>
  if(ip->type != T_DIR){
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057fe:	75 30                	jne    80105830 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	53                   	push   %ebx
80105804:	e8 d7 c2 ff ff       	call   80101ae0 <iunlock>
  iput(curproc->cwd);
80105809:	58                   	pop    %eax
8010580a:	ff 76 68             	pushl  0x68(%esi)
8010580d:	e8 1e c3 ff ff       	call   80101b30 <iput>
  end_op();
80105812:	e8 39 d7 ff ff       	call   80102f50 <end_op>
  curproc->cwd = ip;
80105817:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	31 c0                	xor    %eax,%eax
}
8010581f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105822:	5b                   	pop    %ebx
80105823:	5e                   	pop    %esi
80105824:	5d                   	pop    %ebp
80105825:	c3                   	ret    
80105826:	8d 76 00             	lea    0x0(%esi),%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	53                   	push   %ebx
80105834:	e8 57 c4 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105839:	e8 12 d7 ff ff       	call   80102f50 <end_op>
    return -1;
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105846:	eb d7                	jmp    8010581f <sys_chdir+0x6f>
80105848:	90                   	nop
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105850:	e8 fb d6 ff ff       	call   80102f50 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	eb c3                	jmp    8010581f <sys_chdir+0x6f>
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105866:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010586c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105872:	50                   	push   %eax
80105873:	6a 00                	push   $0x0
80105875:	e8 06 f5 ff ff       	call   80104d80 <argstr>
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	85 c0                	test   %eax,%eax
8010587f:	78 7f                	js     80105900 <sys_exec+0xa0>
80105881:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105887:	83 ec 08             	sub    $0x8,%esp
8010588a:	50                   	push   %eax
8010588b:	6a 01                	push   $0x1
8010588d:	e8 3e f4 ff ff       	call   80104cd0 <argint>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	78 67                	js     80105900 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105899:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010589f:	83 ec 04             	sub    $0x4,%esp
801058a2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801058a8:	68 80 00 00 00       	push   $0x80
801058ad:	6a 00                	push   $0x0
801058af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058b5:	50                   	push   %eax
801058b6:	31 db                	xor    %ebx,%ebx
801058b8:	e8 03 f1 ff ff       	call   801049c0 <memset>
801058bd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058c0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058c6:	83 ec 08             	sub    $0x8,%esp
801058c9:	57                   	push   %edi
801058ca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801058cd:	50                   	push   %eax
801058ce:	e8 5d f3 ff ff       	call   80104c30 <fetchint>
801058d3:	83 c4 10             	add    $0x10,%esp
801058d6:	85 c0                	test   %eax,%eax
801058d8:	78 26                	js     80105900 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801058da:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058e0:	85 c0                	test   %eax,%eax
801058e2:	74 2c                	je     80105910 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058e4:	83 ec 08             	sub    $0x8,%esp
801058e7:	56                   	push   %esi
801058e8:	50                   	push   %eax
801058e9:	e8 82 f3 ff ff       	call   80104c70 <fetchstr>
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	85 c0                	test   %eax,%eax
801058f3:	78 0b                	js     80105900 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801058f5:	83 c3 01             	add    $0x1,%ebx
801058f8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801058fb:	83 fb 20             	cmp    $0x20,%ebx
801058fe:	75 c0                	jne    801058c0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105900:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105908:	5b                   	pop    %ebx
80105909:	5e                   	pop    %esi
8010590a:	5f                   	pop    %edi
8010590b:	5d                   	pop    %ebp
8010590c:	c3                   	ret    
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105910:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105916:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105919:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105920:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105924:	50                   	push   %eax
80105925:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010592b:	e8 c0 b0 ff ff       	call   801009f0 <exec>
80105930:	83 c4 10             	add    $0x10,%esp
}
80105933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5f                   	pop    %edi
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	90                   	nop
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_exec2>:


int
sys_exec2(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105946:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
8010594c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105952:	50                   	push   %eax
80105953:	6a 00                	push   $0x0
80105955:	e8 26 f4 ff ff       	call   80104d80 <argstr>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	85 c0                	test   %eax,%eax
8010595f:	78 7f                	js     801059e0 <sys_exec2+0xa0>
80105961:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105967:	83 ec 08             	sub    $0x8,%esp
8010596a:	50                   	push   %eax
8010596b:	6a 01                	push   $0x1
8010596d:	e8 5e f3 ff ff       	call   80104cd0 <argint>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	78 67                	js     801059e0 <sys_exec2+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105979:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010597f:	83 ec 04             	sub    $0x4,%esp
80105982:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105988:	68 80 00 00 00       	push   $0x80
8010598d:	6a 00                	push   $0x0
8010598f:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105995:	50                   	push   %eax
80105996:	31 db                	xor    %ebx,%ebx
80105998:	e8 23 f0 ff ff       	call   801049c0 <memset>
8010599d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059a0:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
801059a6:	83 ec 08             	sub    $0x8,%esp
801059a9:	57                   	push   %edi
801059aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801059ad:	50                   	push   %eax
801059ae:	e8 7d f2 ff ff       	call   80104c30 <fetchint>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	85 c0                	test   %eax,%eax
801059b8:	78 26                	js     801059e0 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
801059ba:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059c0:	85 c0                	test   %eax,%eax
801059c2:	74 2c                	je     801059f0 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059c4:	83 ec 08             	sub    $0x8,%esp
801059c7:	56                   	push   %esi
801059c8:	50                   	push   %eax
801059c9:	e8 a2 f2 ff ff       	call   80104c70 <fetchstr>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	78 0b                	js     801059e0 <sys_exec2+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801059d5:	83 c3 01             	add    $0x1,%ebx
801059d8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801059db:	83 fb 20             	cmp    $0x20,%ebx
801059de:	75 c0                	jne    801059a0 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
801059e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801059e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
801059e8:	5b                   	pop    %ebx
801059e9:	5e                   	pop    %esi
801059ea:	5f                   	pop    %edi
801059eb:	5d                   	pop    %ebp
801059ec:	c3                   	ret    
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
801059f0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801059f6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801059f9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a00:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105a04:	50                   	push   %eax
80105a05:	6a 02                	push   $0x2
80105a07:	e8 c4 f2 ff ff       	call   80104cd0 <argint>
80105a0c:	83 c4 10             	add    $0x10,%esp
80105a0f:	85 c0                	test   %eax,%eax
80105a11:	78 cd                	js     801059e0 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105a13:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a19:	83 ec 04             	sub    $0x4,%esp
80105a1c:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105a22:	50                   	push   %eax
80105a23:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105a29:	e8 22 b3 ff ff       	call   80100d50 <exec2>
80105a2e:	83 c4 10             	add    $0x10,%esp
}
80105a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a34:	5b                   	pop    %ebx
80105a35:	5e                   	pop    %esi
80105a36:	5f                   	pop    %edi
80105a37:	5d                   	pop    %ebp
80105a38:	c3                   	ret    
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_pipe>:

int
sys_pipe(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a46:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105a49:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a4c:	6a 08                	push   $0x8
80105a4e:	50                   	push   %eax
80105a4f:	6a 00                	push   $0x0
80105a51:	e8 ca f2 ff ff       	call   80104d20 <argptr>
80105a56:	83 c4 10             	add    $0x10,%esp
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	78 4a                	js     80105aa7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a5d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	50                   	push   %eax
80105a64:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a67:	50                   	push   %eax
80105a68:	e8 13 db ff ff       	call   80103580 <pipealloc>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 33                	js     80105aa7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105a74:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a76:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105a79:	e8 c2 e0 ff ff       	call   80103b40 <myproc>
80105a7e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105a80:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a84:	85 f6                	test   %esi,%esi
80105a86:	74 30                	je     80105ab8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105a88:	83 c3 01             	add    $0x1,%ebx
80105a8b:	83 fb 10             	cmp    $0x10,%ebx
80105a8e:	75 f0                	jne    80105a80 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	ff 75 e0             	pushl  -0x20(%ebp)
80105a96:	e8 35 b7 ff ff       	call   801011d0 <fileclose>
    fileclose(wf);
80105a9b:	58                   	pop    %eax
80105a9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a9f:	e8 2c b7 ff ff       	call   801011d0 <fileclose>
    return -1;
80105aa4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105aaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105aaf:	5b                   	pop    %ebx
80105ab0:	5e                   	pop    %esi
80105ab1:	5f                   	pop    %edi
80105ab2:	5d                   	pop    %ebp
80105ab3:	c3                   	ret    
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105ab8:	8d 73 08             	lea    0x8(%ebx),%esi
80105abb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105abf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105ac2:	e8 79 e0 ff ff       	call   80103b40 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105ac7:	31 d2                	xor    %edx,%edx
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ad0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ad4:	85 c9                	test   %ecx,%ecx
80105ad6:	74 18                	je     80105af0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ad8:	83 c2 01             	add    $0x1,%edx
80105adb:	83 fa 10             	cmp    $0x10,%edx
80105ade:	75 f0                	jne    80105ad0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105ae0:	e8 5b e0 ff ff       	call   80103b40 <myproc>
80105ae5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105aec:	00 
80105aed:	eb a1                	jmp    80105a90 <sys_pipe+0x50>
80105aef:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105af0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105af4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105af7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105af9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105afc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105aff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105b02:	31 c0                	xor    %eax,%eax
}
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret    
80105b09:	66 90                	xchg   %ax,%ax
80105b0b:	66 90                	xchg   %ax,%ax
80105b0d:	66 90                	xchg   %ax,%ax
80105b0f:	90                   	nop

80105b10 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b13:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105b14:	e9 c7 e1 ff ff       	jmp    80103ce0 <fork>
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_exit>:
}

int
sys_exit(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b26:	e8 a5 e4 ff ff       	call   80103fd0 <exit>
  return 0;  // not reached
}
80105b2b:	31 c0                	xor    %eax,%eax
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    
80105b2f:	90                   	nop

80105b30 <sys_wait>:

int
sys_wait(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b33:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105b34:	e9 47 e8 ff ff       	jmp    80104380 <wait>
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_kill>:
}

int
sys_kill(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b49:	50                   	push   %eax
80105b4a:	6a 00                	push   $0x0
80105b4c:	e8 7f f1 ff ff       	call   80104cd0 <argint>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	85 c0                	test   %eax,%eax
80105b56:	78 18                	js     80105b70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b5e:	e8 7d e9 ff ff       	call   801044e0 <kill>
80105b63:	83 c4 10             	add    $0x10,%esp
}
80105b66:	c9                   	leave  
80105b67:	c3                   	ret    
80105b68:	90                   	nop
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b80 <sys_getpid>:

int
sys_getpid(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b86:	e8 b5 df ff ff       	call   80103b40 <myproc>
80105b8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b8e:	c9                   	leave  
80105b8f:	c3                   	ret    

80105b90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105b97:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b9a:	50                   	push   %eax
80105b9b:	6a 00                	push   $0x0
80105b9d:	e8 2e f1 ff ff       	call   80104cd0 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	78 27                	js     80105bd0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ba9:	e8 92 df ff ff       	call   80103b40 <myproc>
  if(growproc(n) < 0)
80105bae:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105bb1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105bb3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb6:	e8 a5 e0 ff ff       	call   80103c60 <growproc>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	78 0e                	js     80105bd0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105bc2:	89 d8                	mov    %ebx,%eax
}
80105bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc7:	c9                   	leave  
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd5:	eb ed                	jmp    80105bc4 <sys_sbrk+0x34>
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105be0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	53                   	push   %ebx
80105be4:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105be7:	e8 54 df ff ff       	call   80103b40 <myproc>
80105bec:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105bf3:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105bf6:	e8 45 df ff ff       	call   80103b40 <myproc>
80105bfb:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105c02:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105c05:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c08:	83 ec 08             	sub    $0x8,%esp
80105c0b:	50                   	push   %eax
80105c0c:	6a 00                	push   $0x0
80105c0e:	e8 bd f0 ff ff       	call   80104cd0 <argint>
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	0f 88 89 00 00 00    	js     80105ca7 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	68 60 60 11 80       	push   $0x80116060
80105c26:	e8 95 ec ff ff       	call   801048c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c2e:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105c31:	8b 1d a0 68 11 80    	mov    0x801168a0,%ebx
  while(ticks - ticks0 < n){
80105c37:	85 d2                	test   %edx,%edx
80105c39:	75 26                	jne    80105c61 <sys_sleep+0x81>
80105c3b:	eb 53                	jmp    80105c90 <sys_sleep+0xb0>
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c40:	83 ec 08             	sub    $0x8,%esp
80105c43:	68 60 60 11 80       	push   $0x80116060
80105c48:	68 a0 68 11 80       	push   $0x801168a0
80105c4d:	e8 6e e6 ff ff       	call   801042c0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c52:	a1 a0 68 11 80       	mov    0x801168a0,%eax
80105c57:	83 c4 10             	add    $0x10,%esp
80105c5a:	29 d8                	sub    %ebx,%eax
80105c5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c5f:	73 2f                	jae    80105c90 <sys_sleep+0xb0>
    if(myproc()->killed){
80105c61:	e8 da de ff ff       	call   80103b40 <myproc>
80105c66:	8b 40 24             	mov    0x24(%eax),%eax
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	74 d3                	je     80105c40 <sys_sleep+0x60>
      release(&tickslock);
80105c6d:	83 ec 0c             	sub    $0xc,%esp
80105c70:	68 60 60 11 80       	push   $0x80116060
80105c75:	e8 f6 ec ff ff       	call   80104970 <release>
      return -1;
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c85:	c9                   	leave  
80105c86:	c3                   	ret    
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	68 60 60 11 80       	push   $0x80116060
80105c98:	e8 d3 ec ff ff       	call   80104970 <release>
  return 0;
80105c9d:	83 c4 10             	add    $0x10,%esp
80105ca0:	31 c0                	xor    %eax,%eax
}
80105ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca5:	c9                   	leave  
80105ca6:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80105ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cac:	eb d4                	jmp    80105c82 <sys_sleep+0xa2>
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	53                   	push   %ebx
80105cb4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105cb7:	68 60 60 11 80       	push   $0x80116060
80105cbc:	e8 ff eb ff ff       	call   801048c0 <acquire>
  xticks = ticks;
80105cc1:	8b 1d a0 68 11 80    	mov    0x801168a0,%ebx
  release(&tickslock);
80105cc7:	c7 04 24 60 60 11 80 	movl   $0x80116060,(%esp)
80105cce:	e8 9d ec ff ff       	call   80104970 <release>
  return xticks;
}
80105cd3:	89 d8                	mov    %ebx,%eax
80105cd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cd8:	c9                   	leave  
80105cd9:	c3                   	ret    
80105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ce0 <sys_yield>:

void 
sys_yield()
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80105ce6:	e8 55 de ff ff       	call   80103b40 <myproc>
80105ceb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105cf2:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
80105cf5:	e8 46 de ff ff       	call   80103b40 <myproc>
80105cfa:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105d01:	00 00 00 
  yield();
}
80105d04:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
80105d05:	e9 f6 e3 ff ff       	jmp    80104100 <yield>
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d10 <sys_getlev>:
}

int             
sys_getlev(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
  return getlev();
}
80105d13:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
80105d14:	e9 37 e4 ff ff       	jmp    80104150 <getlev>
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105d26:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 9f ef ff ff       	call   80104cd0 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 28                	js     80105d60 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
80105d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d3b:	83 ec 08             	sub    $0x8,%esp
80105d3e:	50                   	push   %eax
80105d3f:	6a 01                	push   $0x1
80105d41:	e8 8a ef ff ff       	call   80104cd0 <argint>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	78 23                	js     80105d70 <sys_setpriority+0x50>
	return setpriority(pid,priority);
80105d4d:	83 ec 08             	sub    $0x8,%esp
80105d50:	ff 75 f4             	pushl  -0xc(%ebp)
80105d53:	ff 75 f0             	pushl  -0x10(%ebp)
80105d56:	e8 a5 e4 ff ff       	call   80104200 <setpriority>
80105d5b:	83 c4 10             	add    $0x10,%esp
}
80105d5e:	c9                   	leave  
80105d5f:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
80105d70:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    
80105d77:	89 f6                	mov    %esi,%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d80 <sys_getadmin>:


int
sys_getadmin(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105d86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d89:	50                   	push   %eax
80105d8a:	6a 00                	push   $0x0
80105d8c:	e8 ef ef ff ff       	call   80104d80 <argstr>
80105d91:	83 c4 10             	add    $0x10,%esp
80105d94:	85 c0                	test   %eax,%eax
80105d96:	78 18                	js     80105db0 <sys_getadmin+0x30>
  return getadmin(student_number);
80105d98:	83 ec 0c             	sub    $0xc,%esp
80105d9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d9e:	e8 dd e3 ff ff       	call   80104180 <getadmin>
80105da3:	83 c4 10             	add    $0x10,%esp
}
80105da6:	c9                   	leave  
80105da7:	c3                   	ret    
80105da8:	90                   	nop
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    

80105db7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105db7:	1e                   	push   %ds
  pushl %es
80105db8:	06                   	push   %es
  pushl %fs
80105db9:	0f a0                	push   %fs
  pushl %gs
80105dbb:	0f a8                	push   %gs
  pushal
80105dbd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105dbe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105dc2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105dc4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105dc6:	54                   	push   %esp
  call trap
80105dc7:	e8 e4 00 00 00       	call   80105eb0 <trap>
  addl $4, %esp
80105dcc:	83 c4 04             	add    $0x4,%esp

80105dcf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105dcf:	61                   	popa   
  popl %gs
80105dd0:	0f a9                	pop    %gs
  popl %fs
80105dd2:	0f a1                	pop    %fs
  popl %es
80105dd4:	07                   	pop    %es
  popl %ds
80105dd5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105dd6:	83 c4 08             	add    $0x8,%esp
  iret
80105dd9:	cf                   	iret   
80105dda:	66 90                	xchg   %ax,%ax
80105ddc:	66 90                	xchg   %ax,%ax
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105de0:	31 c0                	xor    %eax,%eax
80105de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105de8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105def:	b9 08 00 00 00       	mov    $0x8,%ecx
80105df4:	c6 04 c5 a4 60 11 80 	movb   $0x0,-0x7fee9f5c(,%eax,8)
80105dfb:	00 
80105dfc:	66 89 0c c5 a2 60 11 	mov    %cx,-0x7fee9f5e(,%eax,8)
80105e03:	80 
80105e04:	c6 04 c5 a5 60 11 80 	movb   $0x8e,-0x7fee9f5b(,%eax,8)
80105e0b:	8e 
80105e0c:	66 89 14 c5 a0 60 11 	mov    %dx,-0x7fee9f60(,%eax,8)
80105e13:	80 
80105e14:	c1 ea 10             	shr    $0x10,%edx
80105e17:	66 89 14 c5 a6 60 11 	mov    %dx,-0x7fee9f5a(,%eax,8)
80105e1e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105e1f:	83 c0 01             	add    $0x1,%eax
80105e22:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e27:	75 bf                	jne    80105de8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e29:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e2a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e2f:	89 e5                	mov    %esp,%ebp
80105e31:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e34:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105e39:	68 2d 7e 10 80       	push   $0x80107e2d
80105e3e:	68 60 60 11 80       	push   $0x80116060
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e43:	66 89 15 a2 62 11 80 	mov    %dx,0x801162a2
80105e4a:	c6 05 a4 62 11 80 00 	movb   $0x0,0x801162a4
80105e51:	66 a3 a0 62 11 80    	mov    %ax,0x801162a0
80105e57:	c1 e8 10             	shr    $0x10,%eax
80105e5a:	c6 05 a5 62 11 80 ef 	movb   $0xef,0x801162a5
80105e61:	66 a3 a6 62 11 80    	mov    %ax,0x801162a6

  initlock(&tickslock, "time");
80105e67:	e8 f4 e8 ff ff       	call   80104760 <initlock>
}
80105e6c:	83 c4 10             	add    $0x10,%esp
80105e6f:	c9                   	leave  
80105e70:	c3                   	ret    
80105e71:	eb 0d                	jmp    80105e80 <idtinit>
80105e73:	90                   	nop
80105e74:	90                   	nop
80105e75:	90                   	nop
80105e76:	90                   	nop
80105e77:	90                   	nop
80105e78:	90                   	nop
80105e79:	90                   	nop
80105e7a:	90                   	nop
80105e7b:	90                   	nop
80105e7c:	90                   	nop
80105e7d:	90                   	nop
80105e7e:	90                   	nop
80105e7f:	90                   	nop

80105e80 <idtinit>:

void
idtinit(void)
{
80105e80:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105e81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e86:	89 e5                	mov    %esp,%ebp
80105e88:	83 ec 10             	sub    $0x10,%esp
80105e8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e8f:	b8 a0 60 11 80       	mov    $0x801160a0,%eax
80105e94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e98:	c1 e8 10             	shr    $0x10,%eax
80105e9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105e9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ea2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105eb0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	57                   	push   %edi
80105eb4:	56                   	push   %esi
80105eb5:	53                   	push   %ebx
80105eb6:	83 ec 1c             	sub    $0x1c,%esp
80105eb9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105ebc:	8b 47 30             	mov    0x30(%edi),%eax
80105ebf:	83 f8 40             	cmp    $0x40,%eax
80105ec2:	0f 84 88 01 00 00    	je     80106050 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ec8:	83 e8 20             	sub    $0x20,%eax
80105ecb:	83 f8 1f             	cmp    $0x1f,%eax
80105ece:	77 10                	ja     80105ee0 <trap+0x30>
80105ed0:	ff 24 85 d4 7e 10 80 	jmp    *-0x7fef812c(,%eax,4)
80105ed7:	89 f6                	mov    %esi,%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ee0:	e8 5b dc ff ff       	call   80103b40 <myproc>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	0f 84 d7 01 00 00    	je     801060c4 <trap+0x214>
80105eed:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ef1:	0f 84 cd 01 00 00    	je     801060c4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ef7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105efa:	8b 57 38             	mov    0x38(%edi),%edx
80105efd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105f00:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105f03:	e8 18 dc ff ff       	call   80103b20 <cpuid>
80105f08:	8b 77 34             	mov    0x34(%edi),%esi
80105f0b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105f0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f11:	e8 2a dc ff ff       	call   80103b40 <myproc>
80105f16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f19:	e8 22 dc ff ff       	call   80103b40 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f1e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f21:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f24:	51                   	push   %ecx
80105f25:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f26:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f29:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f2c:	56                   	push   %esi
80105f2d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f2e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f31:	52                   	push   %edx
80105f32:	ff 70 10             	pushl  0x10(%eax)
80105f35:	68 90 7e 10 80       	push   $0x80107e90
80105f3a:	e8 21 a7 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f3f:	83 c4 20             	add    $0x20,%esp
80105f42:	e8 f9 db ff ff       	call   80103b40 <myproc>
80105f47:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105f4e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f50:	e8 eb db ff ff       	call   80103b40 <myproc>
80105f55:	85 c0                	test   %eax,%eax
80105f57:	74 0c                	je     80105f65 <trap+0xb5>
80105f59:	e8 e2 db ff ff       	call   80103b40 <myproc>
80105f5e:	8b 50 24             	mov    0x24(%eax),%edx
80105f61:	85 d2                	test   %edx,%edx
80105f63:	75 4b                	jne    80105fb0 <trap+0x100>
  }
  
  if(ticks%100 == 0) priority_boosting();

  #else
  if(myproc() && myproc()->state == RUNNING &&
80105f65:	e8 d6 db ff ff       	call   80103b40 <myproc>
80105f6a:	85 c0                	test   %eax,%eax
80105f6c:	74 0b                	je     80105f79 <trap+0xc9>
80105f6e:	e8 cd db ff ff       	call   80103b40 <myproc>
80105f73:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f77:	74 4f                	je     80105fc8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f79:	e8 c2 db ff ff       	call   80103b40 <myproc>
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	74 1d                	je     80105f9f <trap+0xef>
80105f82:	e8 b9 db ff ff       	call   80103b40 <myproc>
80105f87:	8b 40 24             	mov    0x24(%eax),%eax
80105f8a:	85 c0                	test   %eax,%eax
80105f8c:	74 11                	je     80105f9f <trap+0xef>
80105f8e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f92:	83 e0 03             	and    $0x3,%eax
80105f95:	66 83 f8 03          	cmp    $0x3,%ax
80105f99:	0f 84 da 00 00 00    	je     80106079 <trap+0x1c9>
    exit();
}
80105f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa2:	5b                   	pop    %ebx
80105fa3:	5e                   	pop    %esi
80105fa4:	5f                   	pop    %edi
80105fa5:	5d                   	pop    %ebp
80105fa6:	c3                   	ret    
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fb0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fb4:	83 e0 03             	and    $0x3,%eax
80105fb7:	66 83 f8 03          	cmp    $0x3,%ax
80105fbb:	75 a8                	jne    80105f65 <trap+0xb5>
    exit();
80105fbd:	e8 0e e0 ff ff       	call   80103fd0 <exit>
80105fc2:	eb a1                	jmp    80105f65 <trap+0xb5>
80105fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  
  if(ticks%100 == 0) priority_boosting();

  #else
  if(myproc() && myproc()->state == RUNNING &&
80105fc8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105fcc:	75 ab                	jne    80105f79 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105fce:	e8 2d e1 ff ff       	call   80104100 <yield>
80105fd3:	eb a4                	jmp    80105f79 <trap+0xc9>
80105fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105fd8:	e8 43 db ff ff       	call   80103b20 <cpuid>
80105fdd:	85 c0                	test   %eax,%eax
80105fdf:	0f 84 ab 00 00 00    	je     80106090 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105fe5:	e8 b6 ca ff ff       	call   80102aa0 <lapiceoi>
    break;
80105fea:	e9 61 ff ff ff       	jmp    80105f50 <trap+0xa0>
80105fef:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105ff0:	e8 6b c9 ff ff       	call   80102960 <kbdintr>
    lapiceoi();
80105ff5:	e8 a6 ca ff ff       	call   80102aa0 <lapiceoi>
    break;
80105ffa:	e9 51 ff ff ff       	jmp    80105f50 <trap+0xa0>
80105fff:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106000:	e8 5b 02 00 00       	call   80106260 <uartintr>
    lapiceoi();
80106005:	e8 96 ca ff ff       	call   80102aa0 <lapiceoi>
    break;
8010600a:	e9 41 ff ff ff       	jmp    80105f50 <trap+0xa0>
8010600f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106010:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106014:	8b 77 38             	mov    0x38(%edi),%esi
80106017:	e8 04 db ff ff       	call   80103b20 <cpuid>
8010601c:	56                   	push   %esi
8010601d:	53                   	push   %ebx
8010601e:	50                   	push   %eax
8010601f:	68 38 7e 10 80       	push   $0x80107e38
80106024:	e8 37 a6 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106029:	e8 72 ca ff ff       	call   80102aa0 <lapiceoi>
    break;
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	e9 1a ff ff ff       	jmp    80105f50 <trap+0xa0>
80106036:	8d 76 00             	lea    0x0(%esi),%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106040:	e8 9b c3 ff ff       	call   801023e0 <ideintr>
80106045:	eb 9e                	jmp    80105fe5 <trap+0x135>
80106047:	89 f6                	mov    %esi,%esi
80106049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106050:	e8 eb da ff ff       	call   80103b40 <myproc>
80106055:	8b 58 24             	mov    0x24(%eax),%ebx
80106058:	85 db                	test   %ebx,%ebx
8010605a:	75 2c                	jne    80106088 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010605c:	e8 df da ff ff       	call   80103b40 <myproc>
80106061:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106064:	e8 57 ed ff ff       	call   80104dc0 <syscall>
    if(myproc()->killed)
80106069:	e8 d2 da ff ff       	call   80103b40 <myproc>
8010606e:	8b 48 24             	mov    0x24(%eax),%ecx
80106071:	85 c9                	test   %ecx,%ecx
80106073:	0f 84 26 ff ff ff    	je     80105f9f <trap+0xef>
    yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106079:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010607c:	5b                   	pop    %ebx
8010607d:	5e                   	pop    %esi
8010607e:	5f                   	pop    %edi
8010607f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106080:	e9 4b df ff ff       	jmp    80103fd0 <exit>
80106085:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106088:	e8 43 df ff ff       	call   80103fd0 <exit>
8010608d:	eb cd                	jmp    8010605c <trap+0x1ac>
8010608f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	68 60 60 11 80       	push   $0x80116060
80106098:	e8 23 e8 ff ff       	call   801048c0 <acquire>
      ticks++;
      wakeup(&ticks);
8010609d:	c7 04 24 a0 68 11 80 	movl   $0x801168a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801060a4:	83 05 a0 68 11 80 01 	addl   $0x1,0x801168a0
      wakeup(&ticks);
801060ab:	e8 d0 e3 ff ff       	call   80104480 <wakeup>
      release(&tickslock);
801060b0:	c7 04 24 60 60 11 80 	movl   $0x80116060,(%esp)
801060b7:	e8 b4 e8 ff ff       	call   80104970 <release>
801060bc:	83 c4 10             	add    $0x10,%esp
801060bf:	e9 21 ff ff ff       	jmp    80105fe5 <trap+0x135>
801060c4:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801060ca:	e8 51 da ff ff       	call   80103b20 <cpuid>
801060cf:	83 ec 0c             	sub    $0xc,%esp
801060d2:	56                   	push   %esi
801060d3:	53                   	push   %ebx
801060d4:	50                   	push   %eax
801060d5:	ff 77 30             	pushl  0x30(%edi)
801060d8:	68 5c 7e 10 80       	push   $0x80107e5c
801060dd:	e8 7e a5 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801060e2:	83 c4 14             	add    $0x14,%esp
801060e5:	68 32 7e 10 80       	push   $0x80107e32
801060ea:	e8 81 a2 ff ff       	call   80100370 <panic>
801060ef:	90                   	nop

801060f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060f0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801060f5:	55                   	push   %ebp
801060f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060f8:	85 c0                	test   %eax,%eax
801060fa:	74 1c                	je     80106118 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106101:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106102:	a8 01                	test   $0x1,%al
80106104:	74 12                	je     80106118 <uartgetc+0x28>
80106106:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010610c:	0f b6 c0             	movzbl %al,%eax
}
8010610f:	5d                   	pop    %ebp
80106110:	c3                   	ret    
80106111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010611d:	5d                   	pop    %ebp
8010611e:	c3                   	ret    
8010611f:	90                   	nop

80106120 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	57                   	push   %edi
80106124:	56                   	push   %esi
80106125:	53                   	push   %ebx
80106126:	89 c7                	mov    %eax,%edi
80106128:	bb 80 00 00 00       	mov    $0x80,%ebx
8010612d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106132:	83 ec 0c             	sub    $0xc,%esp
80106135:	eb 1b                	jmp    80106152 <uartputc.part.0+0x32>
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	6a 0a                	push   $0xa
80106145:	e8 76 c9 ff ff       	call   80102ac0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010614a:	83 c4 10             	add    $0x10,%esp
8010614d:	83 eb 01             	sub    $0x1,%ebx
80106150:	74 07                	je     80106159 <uartputc.part.0+0x39>
80106152:	89 f2                	mov    %esi,%edx
80106154:	ec                   	in     (%dx),%al
80106155:	a8 20                	test   $0x20,%al
80106157:	74 e7                	je     80106140 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106159:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615e:	89 f8                	mov    %edi,%eax
80106160:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
80106168:	c3                   	ret    
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106170 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106170:	55                   	push   %ebp
80106171:	31 c9                	xor    %ecx,%ecx
80106173:	89 c8                	mov    %ecx,%eax
80106175:	89 e5                	mov    %esp,%ebp
80106177:	57                   	push   %edi
80106178:	56                   	push   %esi
80106179:	53                   	push   %ebx
8010617a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010617f:	89 da                	mov    %ebx,%edx
80106181:	83 ec 0c             	sub    $0xc,%esp
80106184:	ee                   	out    %al,(%dx)
80106185:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010618a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010618f:	89 fa                	mov    %edi,%edx
80106191:	ee                   	out    %al,(%dx)
80106192:	b8 0c 00 00 00       	mov    $0xc,%eax
80106197:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010619c:	ee                   	out    %al,(%dx)
8010619d:	be f9 03 00 00       	mov    $0x3f9,%esi
801061a2:	89 c8                	mov    %ecx,%eax
801061a4:	89 f2                	mov    %esi,%edx
801061a6:	ee                   	out    %al,(%dx)
801061a7:	b8 03 00 00 00       	mov    $0x3,%eax
801061ac:	89 fa                	mov    %edi,%edx
801061ae:	ee                   	out    %al,(%dx)
801061af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061b4:	89 c8                	mov    %ecx,%eax
801061b6:	ee                   	out    %al,(%dx)
801061b7:	b8 01 00 00 00       	mov    $0x1,%eax
801061bc:	89 f2                	mov    %esi,%edx
801061be:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061c4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801061c5:	3c ff                	cmp    $0xff,%al
801061c7:	74 5a                	je     80106223 <uartinit+0xb3>
    return;
  uart = 1;
801061c9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061d0:	00 00 00 
801061d3:	89 da                	mov    %ebx,%edx
801061d5:	ec                   	in     (%dx),%al
801061d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061db:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801061dc:	83 ec 08             	sub    $0x8,%esp
801061df:	bb 54 7f 10 80       	mov    $0x80107f54,%ebx
801061e4:	6a 00                	push   $0x0
801061e6:	6a 04                	push   $0x4
801061e8:	e8 43 c4 ff ff       	call   80102630 <ioapicenable>
801061ed:	83 c4 10             	add    $0x10,%esp
801061f0:	b8 78 00 00 00       	mov    $0x78,%eax
801061f5:	eb 13                	jmp    8010620a <uartinit+0x9a>
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106200:	83 c3 01             	add    $0x1,%ebx
80106203:	0f be 03             	movsbl (%ebx),%eax
80106206:	84 c0                	test   %al,%al
80106208:	74 19                	je     80106223 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010620a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106210:	85 d2                	test   %edx,%edx
80106212:	74 ec                	je     80106200 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106214:	83 c3 01             	add    $0x1,%ebx
80106217:	e8 04 ff ff ff       	call   80106120 <uartputc.part.0>
8010621c:	0f be 03             	movsbl (%ebx),%eax
8010621f:	84 c0                	test   %al,%al
80106221:	75 e7                	jne    8010620a <uartinit+0x9a>
    uartputc(*p);
}
80106223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106226:	5b                   	pop    %ebx
80106227:	5e                   	pop    %esi
80106228:	5f                   	pop    %edi
80106229:	5d                   	pop    %ebp
8010622a:	c3                   	ret    
8010622b:	90                   	nop
8010622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106230:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106236:	55                   	push   %ebp
80106237:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106239:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010623b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010623e:	74 10                	je     80106250 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106240:	5d                   	pop    %ebp
80106241:	e9 da fe ff ff       	jmp    80106120 <uartputc.part.0>
80106246:	8d 76 00             	lea    0x0(%esi),%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106250:	5d                   	pop    %ebp
80106251:	c3                   	ret    
80106252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106260 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106266:	68 f0 60 10 80       	push   $0x801060f0
8010626b:	e8 80 a5 ff ff       	call   801007f0 <consoleintr>
}
80106270:	83 c4 10             	add    $0x10,%esp
80106273:	c9                   	leave  
80106274:	c3                   	ret    

80106275 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $0
80106277:	6a 00                	push   $0x0
  jmp alltraps
80106279:	e9 39 fb ff ff       	jmp    80105db7 <alltraps>

8010627e <vector1>:
.globl vector1
vector1:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $1
80106280:	6a 01                	push   $0x1
  jmp alltraps
80106282:	e9 30 fb ff ff       	jmp    80105db7 <alltraps>

80106287 <vector2>:
.globl vector2
vector2:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $2
80106289:	6a 02                	push   $0x2
  jmp alltraps
8010628b:	e9 27 fb ff ff       	jmp    80105db7 <alltraps>

80106290 <vector3>:
.globl vector3
vector3:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $3
80106292:	6a 03                	push   $0x3
  jmp alltraps
80106294:	e9 1e fb ff ff       	jmp    80105db7 <alltraps>

80106299 <vector4>:
.globl vector4
vector4:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $4
8010629b:	6a 04                	push   $0x4
  jmp alltraps
8010629d:	e9 15 fb ff ff       	jmp    80105db7 <alltraps>

801062a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $5
801062a4:	6a 05                	push   $0x5
  jmp alltraps
801062a6:	e9 0c fb ff ff       	jmp    80105db7 <alltraps>

801062ab <vector6>:
.globl vector6
vector6:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $6
801062ad:	6a 06                	push   $0x6
  jmp alltraps
801062af:	e9 03 fb ff ff       	jmp    80105db7 <alltraps>

801062b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $7
801062b6:	6a 07                	push   $0x7
  jmp alltraps
801062b8:	e9 fa fa ff ff       	jmp    80105db7 <alltraps>

801062bd <vector8>:
.globl vector8
vector8:
  pushl $8
801062bd:	6a 08                	push   $0x8
  jmp alltraps
801062bf:	e9 f3 fa ff ff       	jmp    80105db7 <alltraps>

801062c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $9
801062c6:	6a 09                	push   $0x9
  jmp alltraps
801062c8:	e9 ea fa ff ff       	jmp    80105db7 <alltraps>

801062cd <vector10>:
.globl vector10
vector10:
  pushl $10
801062cd:	6a 0a                	push   $0xa
  jmp alltraps
801062cf:	e9 e3 fa ff ff       	jmp    80105db7 <alltraps>

801062d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062d4:	6a 0b                	push   $0xb
  jmp alltraps
801062d6:	e9 dc fa ff ff       	jmp    80105db7 <alltraps>

801062db <vector12>:
.globl vector12
vector12:
  pushl $12
801062db:	6a 0c                	push   $0xc
  jmp alltraps
801062dd:	e9 d5 fa ff ff       	jmp    80105db7 <alltraps>

801062e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062e2:	6a 0d                	push   $0xd
  jmp alltraps
801062e4:	e9 ce fa ff ff       	jmp    80105db7 <alltraps>

801062e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062e9:	6a 0e                	push   $0xe
  jmp alltraps
801062eb:	e9 c7 fa ff ff       	jmp    80105db7 <alltraps>

801062f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $15
801062f2:	6a 0f                	push   $0xf
  jmp alltraps
801062f4:	e9 be fa ff ff       	jmp    80105db7 <alltraps>

801062f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $16
801062fb:	6a 10                	push   $0x10
  jmp alltraps
801062fd:	e9 b5 fa ff ff       	jmp    80105db7 <alltraps>

80106302 <vector17>:
.globl vector17
vector17:
  pushl $17
80106302:	6a 11                	push   $0x11
  jmp alltraps
80106304:	e9 ae fa ff ff       	jmp    80105db7 <alltraps>

80106309 <vector18>:
.globl vector18
vector18:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $18
8010630b:	6a 12                	push   $0x12
  jmp alltraps
8010630d:	e9 a5 fa ff ff       	jmp    80105db7 <alltraps>

80106312 <vector19>:
.globl vector19
vector19:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $19
80106314:	6a 13                	push   $0x13
  jmp alltraps
80106316:	e9 9c fa ff ff       	jmp    80105db7 <alltraps>

8010631b <vector20>:
.globl vector20
vector20:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $20
8010631d:	6a 14                	push   $0x14
  jmp alltraps
8010631f:	e9 93 fa ff ff       	jmp    80105db7 <alltraps>

80106324 <vector21>:
.globl vector21
vector21:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $21
80106326:	6a 15                	push   $0x15
  jmp alltraps
80106328:	e9 8a fa ff ff       	jmp    80105db7 <alltraps>

8010632d <vector22>:
.globl vector22
vector22:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $22
8010632f:	6a 16                	push   $0x16
  jmp alltraps
80106331:	e9 81 fa ff ff       	jmp    80105db7 <alltraps>

80106336 <vector23>:
.globl vector23
vector23:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $23
80106338:	6a 17                	push   $0x17
  jmp alltraps
8010633a:	e9 78 fa ff ff       	jmp    80105db7 <alltraps>

8010633f <vector24>:
.globl vector24
vector24:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $24
80106341:	6a 18                	push   $0x18
  jmp alltraps
80106343:	e9 6f fa ff ff       	jmp    80105db7 <alltraps>

80106348 <vector25>:
.globl vector25
vector25:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $25
8010634a:	6a 19                	push   $0x19
  jmp alltraps
8010634c:	e9 66 fa ff ff       	jmp    80105db7 <alltraps>

80106351 <vector26>:
.globl vector26
vector26:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $26
80106353:	6a 1a                	push   $0x1a
  jmp alltraps
80106355:	e9 5d fa ff ff       	jmp    80105db7 <alltraps>

8010635a <vector27>:
.globl vector27
vector27:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $27
8010635c:	6a 1b                	push   $0x1b
  jmp alltraps
8010635e:	e9 54 fa ff ff       	jmp    80105db7 <alltraps>

80106363 <vector28>:
.globl vector28
vector28:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $28
80106365:	6a 1c                	push   $0x1c
  jmp alltraps
80106367:	e9 4b fa ff ff       	jmp    80105db7 <alltraps>

8010636c <vector29>:
.globl vector29
vector29:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $29
8010636e:	6a 1d                	push   $0x1d
  jmp alltraps
80106370:	e9 42 fa ff ff       	jmp    80105db7 <alltraps>

80106375 <vector30>:
.globl vector30
vector30:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $30
80106377:	6a 1e                	push   $0x1e
  jmp alltraps
80106379:	e9 39 fa ff ff       	jmp    80105db7 <alltraps>

8010637e <vector31>:
.globl vector31
vector31:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $31
80106380:	6a 1f                	push   $0x1f
  jmp alltraps
80106382:	e9 30 fa ff ff       	jmp    80105db7 <alltraps>

80106387 <vector32>:
.globl vector32
vector32:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $32
80106389:	6a 20                	push   $0x20
  jmp alltraps
8010638b:	e9 27 fa ff ff       	jmp    80105db7 <alltraps>

80106390 <vector33>:
.globl vector33
vector33:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $33
80106392:	6a 21                	push   $0x21
  jmp alltraps
80106394:	e9 1e fa ff ff       	jmp    80105db7 <alltraps>

80106399 <vector34>:
.globl vector34
vector34:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $34
8010639b:	6a 22                	push   $0x22
  jmp alltraps
8010639d:	e9 15 fa ff ff       	jmp    80105db7 <alltraps>

801063a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $35
801063a4:	6a 23                	push   $0x23
  jmp alltraps
801063a6:	e9 0c fa ff ff       	jmp    80105db7 <alltraps>

801063ab <vector36>:
.globl vector36
vector36:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $36
801063ad:	6a 24                	push   $0x24
  jmp alltraps
801063af:	e9 03 fa ff ff       	jmp    80105db7 <alltraps>

801063b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $37
801063b6:	6a 25                	push   $0x25
  jmp alltraps
801063b8:	e9 fa f9 ff ff       	jmp    80105db7 <alltraps>

801063bd <vector38>:
.globl vector38
vector38:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $38
801063bf:	6a 26                	push   $0x26
  jmp alltraps
801063c1:	e9 f1 f9 ff ff       	jmp    80105db7 <alltraps>

801063c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $39
801063c8:	6a 27                	push   $0x27
  jmp alltraps
801063ca:	e9 e8 f9 ff ff       	jmp    80105db7 <alltraps>

801063cf <vector40>:
.globl vector40
vector40:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $40
801063d1:	6a 28                	push   $0x28
  jmp alltraps
801063d3:	e9 df f9 ff ff       	jmp    80105db7 <alltraps>

801063d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $41
801063da:	6a 29                	push   $0x29
  jmp alltraps
801063dc:	e9 d6 f9 ff ff       	jmp    80105db7 <alltraps>

801063e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $42
801063e3:	6a 2a                	push   $0x2a
  jmp alltraps
801063e5:	e9 cd f9 ff ff       	jmp    80105db7 <alltraps>

801063ea <vector43>:
.globl vector43
vector43:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $43
801063ec:	6a 2b                	push   $0x2b
  jmp alltraps
801063ee:	e9 c4 f9 ff ff       	jmp    80105db7 <alltraps>

801063f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $44
801063f5:	6a 2c                	push   $0x2c
  jmp alltraps
801063f7:	e9 bb f9 ff ff       	jmp    80105db7 <alltraps>

801063fc <vector45>:
.globl vector45
vector45:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $45
801063fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106400:	e9 b2 f9 ff ff       	jmp    80105db7 <alltraps>

80106405 <vector46>:
.globl vector46
vector46:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $46
80106407:	6a 2e                	push   $0x2e
  jmp alltraps
80106409:	e9 a9 f9 ff ff       	jmp    80105db7 <alltraps>

8010640e <vector47>:
.globl vector47
vector47:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $47
80106410:	6a 2f                	push   $0x2f
  jmp alltraps
80106412:	e9 a0 f9 ff ff       	jmp    80105db7 <alltraps>

80106417 <vector48>:
.globl vector48
vector48:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $48
80106419:	6a 30                	push   $0x30
  jmp alltraps
8010641b:	e9 97 f9 ff ff       	jmp    80105db7 <alltraps>

80106420 <vector49>:
.globl vector49
vector49:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $49
80106422:	6a 31                	push   $0x31
  jmp alltraps
80106424:	e9 8e f9 ff ff       	jmp    80105db7 <alltraps>

80106429 <vector50>:
.globl vector50
vector50:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $50
8010642b:	6a 32                	push   $0x32
  jmp alltraps
8010642d:	e9 85 f9 ff ff       	jmp    80105db7 <alltraps>

80106432 <vector51>:
.globl vector51
vector51:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $51
80106434:	6a 33                	push   $0x33
  jmp alltraps
80106436:	e9 7c f9 ff ff       	jmp    80105db7 <alltraps>

8010643b <vector52>:
.globl vector52
vector52:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $52
8010643d:	6a 34                	push   $0x34
  jmp alltraps
8010643f:	e9 73 f9 ff ff       	jmp    80105db7 <alltraps>

80106444 <vector53>:
.globl vector53
vector53:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $53
80106446:	6a 35                	push   $0x35
  jmp alltraps
80106448:	e9 6a f9 ff ff       	jmp    80105db7 <alltraps>

8010644d <vector54>:
.globl vector54
vector54:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $54
8010644f:	6a 36                	push   $0x36
  jmp alltraps
80106451:	e9 61 f9 ff ff       	jmp    80105db7 <alltraps>

80106456 <vector55>:
.globl vector55
vector55:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $55
80106458:	6a 37                	push   $0x37
  jmp alltraps
8010645a:	e9 58 f9 ff ff       	jmp    80105db7 <alltraps>

8010645f <vector56>:
.globl vector56
vector56:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $56
80106461:	6a 38                	push   $0x38
  jmp alltraps
80106463:	e9 4f f9 ff ff       	jmp    80105db7 <alltraps>

80106468 <vector57>:
.globl vector57
vector57:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $57
8010646a:	6a 39                	push   $0x39
  jmp alltraps
8010646c:	e9 46 f9 ff ff       	jmp    80105db7 <alltraps>

80106471 <vector58>:
.globl vector58
vector58:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $58
80106473:	6a 3a                	push   $0x3a
  jmp alltraps
80106475:	e9 3d f9 ff ff       	jmp    80105db7 <alltraps>

8010647a <vector59>:
.globl vector59
vector59:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $59
8010647c:	6a 3b                	push   $0x3b
  jmp alltraps
8010647e:	e9 34 f9 ff ff       	jmp    80105db7 <alltraps>

80106483 <vector60>:
.globl vector60
vector60:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $60
80106485:	6a 3c                	push   $0x3c
  jmp alltraps
80106487:	e9 2b f9 ff ff       	jmp    80105db7 <alltraps>

8010648c <vector61>:
.globl vector61
vector61:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $61
8010648e:	6a 3d                	push   $0x3d
  jmp alltraps
80106490:	e9 22 f9 ff ff       	jmp    80105db7 <alltraps>

80106495 <vector62>:
.globl vector62
vector62:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $62
80106497:	6a 3e                	push   $0x3e
  jmp alltraps
80106499:	e9 19 f9 ff ff       	jmp    80105db7 <alltraps>

8010649e <vector63>:
.globl vector63
vector63:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $63
801064a0:	6a 3f                	push   $0x3f
  jmp alltraps
801064a2:	e9 10 f9 ff ff       	jmp    80105db7 <alltraps>

801064a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $64
801064a9:	6a 40                	push   $0x40
  jmp alltraps
801064ab:	e9 07 f9 ff ff       	jmp    80105db7 <alltraps>

801064b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $65
801064b2:	6a 41                	push   $0x41
  jmp alltraps
801064b4:	e9 fe f8 ff ff       	jmp    80105db7 <alltraps>

801064b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $66
801064bb:	6a 42                	push   $0x42
  jmp alltraps
801064bd:	e9 f5 f8 ff ff       	jmp    80105db7 <alltraps>

801064c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $67
801064c4:	6a 43                	push   $0x43
  jmp alltraps
801064c6:	e9 ec f8 ff ff       	jmp    80105db7 <alltraps>

801064cb <vector68>:
.globl vector68
vector68:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $68
801064cd:	6a 44                	push   $0x44
  jmp alltraps
801064cf:	e9 e3 f8 ff ff       	jmp    80105db7 <alltraps>

801064d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $69
801064d6:	6a 45                	push   $0x45
  jmp alltraps
801064d8:	e9 da f8 ff ff       	jmp    80105db7 <alltraps>

801064dd <vector70>:
.globl vector70
vector70:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $70
801064df:	6a 46                	push   $0x46
  jmp alltraps
801064e1:	e9 d1 f8 ff ff       	jmp    80105db7 <alltraps>

801064e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $71
801064e8:	6a 47                	push   $0x47
  jmp alltraps
801064ea:	e9 c8 f8 ff ff       	jmp    80105db7 <alltraps>

801064ef <vector72>:
.globl vector72
vector72:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $72
801064f1:	6a 48                	push   $0x48
  jmp alltraps
801064f3:	e9 bf f8 ff ff       	jmp    80105db7 <alltraps>

801064f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $73
801064fa:	6a 49                	push   $0x49
  jmp alltraps
801064fc:	e9 b6 f8 ff ff       	jmp    80105db7 <alltraps>

80106501 <vector74>:
.globl vector74
vector74:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $74
80106503:	6a 4a                	push   $0x4a
  jmp alltraps
80106505:	e9 ad f8 ff ff       	jmp    80105db7 <alltraps>

8010650a <vector75>:
.globl vector75
vector75:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $75
8010650c:	6a 4b                	push   $0x4b
  jmp alltraps
8010650e:	e9 a4 f8 ff ff       	jmp    80105db7 <alltraps>

80106513 <vector76>:
.globl vector76
vector76:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $76
80106515:	6a 4c                	push   $0x4c
  jmp alltraps
80106517:	e9 9b f8 ff ff       	jmp    80105db7 <alltraps>

8010651c <vector77>:
.globl vector77
vector77:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $77
8010651e:	6a 4d                	push   $0x4d
  jmp alltraps
80106520:	e9 92 f8 ff ff       	jmp    80105db7 <alltraps>

80106525 <vector78>:
.globl vector78
vector78:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $78
80106527:	6a 4e                	push   $0x4e
  jmp alltraps
80106529:	e9 89 f8 ff ff       	jmp    80105db7 <alltraps>

8010652e <vector79>:
.globl vector79
vector79:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $79
80106530:	6a 4f                	push   $0x4f
  jmp alltraps
80106532:	e9 80 f8 ff ff       	jmp    80105db7 <alltraps>

80106537 <vector80>:
.globl vector80
vector80:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $80
80106539:	6a 50                	push   $0x50
  jmp alltraps
8010653b:	e9 77 f8 ff ff       	jmp    80105db7 <alltraps>

80106540 <vector81>:
.globl vector81
vector81:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $81
80106542:	6a 51                	push   $0x51
  jmp alltraps
80106544:	e9 6e f8 ff ff       	jmp    80105db7 <alltraps>

80106549 <vector82>:
.globl vector82
vector82:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $82
8010654b:	6a 52                	push   $0x52
  jmp alltraps
8010654d:	e9 65 f8 ff ff       	jmp    80105db7 <alltraps>

80106552 <vector83>:
.globl vector83
vector83:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $83
80106554:	6a 53                	push   $0x53
  jmp alltraps
80106556:	e9 5c f8 ff ff       	jmp    80105db7 <alltraps>

8010655b <vector84>:
.globl vector84
vector84:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $84
8010655d:	6a 54                	push   $0x54
  jmp alltraps
8010655f:	e9 53 f8 ff ff       	jmp    80105db7 <alltraps>

80106564 <vector85>:
.globl vector85
vector85:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $85
80106566:	6a 55                	push   $0x55
  jmp alltraps
80106568:	e9 4a f8 ff ff       	jmp    80105db7 <alltraps>

8010656d <vector86>:
.globl vector86
vector86:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $86
8010656f:	6a 56                	push   $0x56
  jmp alltraps
80106571:	e9 41 f8 ff ff       	jmp    80105db7 <alltraps>

80106576 <vector87>:
.globl vector87
vector87:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $87
80106578:	6a 57                	push   $0x57
  jmp alltraps
8010657a:	e9 38 f8 ff ff       	jmp    80105db7 <alltraps>

8010657f <vector88>:
.globl vector88
vector88:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $88
80106581:	6a 58                	push   $0x58
  jmp alltraps
80106583:	e9 2f f8 ff ff       	jmp    80105db7 <alltraps>

80106588 <vector89>:
.globl vector89
vector89:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $89
8010658a:	6a 59                	push   $0x59
  jmp alltraps
8010658c:	e9 26 f8 ff ff       	jmp    80105db7 <alltraps>

80106591 <vector90>:
.globl vector90
vector90:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $90
80106593:	6a 5a                	push   $0x5a
  jmp alltraps
80106595:	e9 1d f8 ff ff       	jmp    80105db7 <alltraps>

8010659a <vector91>:
.globl vector91
vector91:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $91
8010659c:	6a 5b                	push   $0x5b
  jmp alltraps
8010659e:	e9 14 f8 ff ff       	jmp    80105db7 <alltraps>

801065a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $92
801065a5:	6a 5c                	push   $0x5c
  jmp alltraps
801065a7:	e9 0b f8 ff ff       	jmp    80105db7 <alltraps>

801065ac <vector93>:
.globl vector93
vector93:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $93
801065ae:	6a 5d                	push   $0x5d
  jmp alltraps
801065b0:	e9 02 f8 ff ff       	jmp    80105db7 <alltraps>

801065b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $94
801065b7:	6a 5e                	push   $0x5e
  jmp alltraps
801065b9:	e9 f9 f7 ff ff       	jmp    80105db7 <alltraps>

801065be <vector95>:
.globl vector95
vector95:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $95
801065c0:	6a 5f                	push   $0x5f
  jmp alltraps
801065c2:	e9 f0 f7 ff ff       	jmp    80105db7 <alltraps>

801065c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $96
801065c9:	6a 60                	push   $0x60
  jmp alltraps
801065cb:	e9 e7 f7 ff ff       	jmp    80105db7 <alltraps>

801065d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $97
801065d2:	6a 61                	push   $0x61
  jmp alltraps
801065d4:	e9 de f7 ff ff       	jmp    80105db7 <alltraps>

801065d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $98
801065db:	6a 62                	push   $0x62
  jmp alltraps
801065dd:	e9 d5 f7 ff ff       	jmp    80105db7 <alltraps>

801065e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $99
801065e4:	6a 63                	push   $0x63
  jmp alltraps
801065e6:	e9 cc f7 ff ff       	jmp    80105db7 <alltraps>

801065eb <vector100>:
.globl vector100
vector100:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $100
801065ed:	6a 64                	push   $0x64
  jmp alltraps
801065ef:	e9 c3 f7 ff ff       	jmp    80105db7 <alltraps>

801065f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $101
801065f6:	6a 65                	push   $0x65
  jmp alltraps
801065f8:	e9 ba f7 ff ff       	jmp    80105db7 <alltraps>

801065fd <vector102>:
.globl vector102
vector102:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $102
801065ff:	6a 66                	push   $0x66
  jmp alltraps
80106601:	e9 b1 f7 ff ff       	jmp    80105db7 <alltraps>

80106606 <vector103>:
.globl vector103
vector103:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $103
80106608:	6a 67                	push   $0x67
  jmp alltraps
8010660a:	e9 a8 f7 ff ff       	jmp    80105db7 <alltraps>

8010660f <vector104>:
.globl vector104
vector104:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $104
80106611:	6a 68                	push   $0x68
  jmp alltraps
80106613:	e9 9f f7 ff ff       	jmp    80105db7 <alltraps>

80106618 <vector105>:
.globl vector105
vector105:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $105
8010661a:	6a 69                	push   $0x69
  jmp alltraps
8010661c:	e9 96 f7 ff ff       	jmp    80105db7 <alltraps>

80106621 <vector106>:
.globl vector106
vector106:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $106
80106623:	6a 6a                	push   $0x6a
  jmp alltraps
80106625:	e9 8d f7 ff ff       	jmp    80105db7 <alltraps>

8010662a <vector107>:
.globl vector107
vector107:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $107
8010662c:	6a 6b                	push   $0x6b
  jmp alltraps
8010662e:	e9 84 f7 ff ff       	jmp    80105db7 <alltraps>

80106633 <vector108>:
.globl vector108
vector108:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $108
80106635:	6a 6c                	push   $0x6c
  jmp alltraps
80106637:	e9 7b f7 ff ff       	jmp    80105db7 <alltraps>

8010663c <vector109>:
.globl vector109
vector109:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $109
8010663e:	6a 6d                	push   $0x6d
  jmp alltraps
80106640:	e9 72 f7 ff ff       	jmp    80105db7 <alltraps>

80106645 <vector110>:
.globl vector110
vector110:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $110
80106647:	6a 6e                	push   $0x6e
  jmp alltraps
80106649:	e9 69 f7 ff ff       	jmp    80105db7 <alltraps>

8010664e <vector111>:
.globl vector111
vector111:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $111
80106650:	6a 6f                	push   $0x6f
  jmp alltraps
80106652:	e9 60 f7 ff ff       	jmp    80105db7 <alltraps>

80106657 <vector112>:
.globl vector112
vector112:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $112
80106659:	6a 70                	push   $0x70
  jmp alltraps
8010665b:	e9 57 f7 ff ff       	jmp    80105db7 <alltraps>

80106660 <vector113>:
.globl vector113
vector113:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $113
80106662:	6a 71                	push   $0x71
  jmp alltraps
80106664:	e9 4e f7 ff ff       	jmp    80105db7 <alltraps>

80106669 <vector114>:
.globl vector114
vector114:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $114
8010666b:	6a 72                	push   $0x72
  jmp alltraps
8010666d:	e9 45 f7 ff ff       	jmp    80105db7 <alltraps>

80106672 <vector115>:
.globl vector115
vector115:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $115
80106674:	6a 73                	push   $0x73
  jmp alltraps
80106676:	e9 3c f7 ff ff       	jmp    80105db7 <alltraps>

8010667b <vector116>:
.globl vector116
vector116:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $116
8010667d:	6a 74                	push   $0x74
  jmp alltraps
8010667f:	e9 33 f7 ff ff       	jmp    80105db7 <alltraps>

80106684 <vector117>:
.globl vector117
vector117:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $117
80106686:	6a 75                	push   $0x75
  jmp alltraps
80106688:	e9 2a f7 ff ff       	jmp    80105db7 <alltraps>

8010668d <vector118>:
.globl vector118
vector118:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $118
8010668f:	6a 76                	push   $0x76
  jmp alltraps
80106691:	e9 21 f7 ff ff       	jmp    80105db7 <alltraps>

80106696 <vector119>:
.globl vector119
vector119:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $119
80106698:	6a 77                	push   $0x77
  jmp alltraps
8010669a:	e9 18 f7 ff ff       	jmp    80105db7 <alltraps>

8010669f <vector120>:
.globl vector120
vector120:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $120
801066a1:	6a 78                	push   $0x78
  jmp alltraps
801066a3:	e9 0f f7 ff ff       	jmp    80105db7 <alltraps>

801066a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $121
801066aa:	6a 79                	push   $0x79
  jmp alltraps
801066ac:	e9 06 f7 ff ff       	jmp    80105db7 <alltraps>

801066b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $122
801066b3:	6a 7a                	push   $0x7a
  jmp alltraps
801066b5:	e9 fd f6 ff ff       	jmp    80105db7 <alltraps>

801066ba <vector123>:
.globl vector123
vector123:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $123
801066bc:	6a 7b                	push   $0x7b
  jmp alltraps
801066be:	e9 f4 f6 ff ff       	jmp    80105db7 <alltraps>

801066c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $124
801066c5:	6a 7c                	push   $0x7c
  jmp alltraps
801066c7:	e9 eb f6 ff ff       	jmp    80105db7 <alltraps>

801066cc <vector125>:
.globl vector125
vector125:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $125
801066ce:	6a 7d                	push   $0x7d
  jmp alltraps
801066d0:	e9 e2 f6 ff ff       	jmp    80105db7 <alltraps>

801066d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $126
801066d7:	6a 7e                	push   $0x7e
  jmp alltraps
801066d9:	e9 d9 f6 ff ff       	jmp    80105db7 <alltraps>

801066de <vector127>:
.globl vector127
vector127:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $127
801066e0:	6a 7f                	push   $0x7f
  jmp alltraps
801066e2:	e9 d0 f6 ff ff       	jmp    80105db7 <alltraps>

801066e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $128
801066e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066ee:	e9 c4 f6 ff ff       	jmp    80105db7 <alltraps>

801066f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $129
801066f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066fa:	e9 b8 f6 ff ff       	jmp    80105db7 <alltraps>

801066ff <vector130>:
.globl vector130
vector130:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $130
80106701:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106706:	e9 ac f6 ff ff       	jmp    80105db7 <alltraps>

8010670b <vector131>:
.globl vector131
vector131:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $131
8010670d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106712:	e9 a0 f6 ff ff       	jmp    80105db7 <alltraps>

80106717 <vector132>:
.globl vector132
vector132:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $132
80106719:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010671e:	e9 94 f6 ff ff       	jmp    80105db7 <alltraps>

80106723 <vector133>:
.globl vector133
vector133:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $133
80106725:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010672a:	e9 88 f6 ff ff       	jmp    80105db7 <alltraps>

8010672f <vector134>:
.globl vector134
vector134:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $134
80106731:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106736:	e9 7c f6 ff ff       	jmp    80105db7 <alltraps>

8010673b <vector135>:
.globl vector135
vector135:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $135
8010673d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106742:	e9 70 f6 ff ff       	jmp    80105db7 <alltraps>

80106747 <vector136>:
.globl vector136
vector136:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $136
80106749:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010674e:	e9 64 f6 ff ff       	jmp    80105db7 <alltraps>

80106753 <vector137>:
.globl vector137
vector137:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $137
80106755:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010675a:	e9 58 f6 ff ff       	jmp    80105db7 <alltraps>

8010675f <vector138>:
.globl vector138
vector138:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $138
80106761:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106766:	e9 4c f6 ff ff       	jmp    80105db7 <alltraps>

8010676b <vector139>:
.globl vector139
vector139:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $139
8010676d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106772:	e9 40 f6 ff ff       	jmp    80105db7 <alltraps>

80106777 <vector140>:
.globl vector140
vector140:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $140
80106779:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010677e:	e9 34 f6 ff ff       	jmp    80105db7 <alltraps>

80106783 <vector141>:
.globl vector141
vector141:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $141
80106785:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010678a:	e9 28 f6 ff ff       	jmp    80105db7 <alltraps>

8010678f <vector142>:
.globl vector142
vector142:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $142
80106791:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106796:	e9 1c f6 ff ff       	jmp    80105db7 <alltraps>

8010679b <vector143>:
.globl vector143
vector143:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $143
8010679d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067a2:	e9 10 f6 ff ff       	jmp    80105db7 <alltraps>

801067a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $144
801067a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067ae:	e9 04 f6 ff ff       	jmp    80105db7 <alltraps>

801067b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $145
801067b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ba:	e9 f8 f5 ff ff       	jmp    80105db7 <alltraps>

801067bf <vector146>:
.globl vector146
vector146:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $146
801067c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067c6:	e9 ec f5 ff ff       	jmp    80105db7 <alltraps>

801067cb <vector147>:
.globl vector147
vector147:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $147
801067cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067d2:	e9 e0 f5 ff ff       	jmp    80105db7 <alltraps>

801067d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $148
801067d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067de:	e9 d4 f5 ff ff       	jmp    80105db7 <alltraps>

801067e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $149
801067e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ea:	e9 c8 f5 ff ff       	jmp    80105db7 <alltraps>

801067ef <vector150>:
.globl vector150
vector150:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $150
801067f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067f6:	e9 bc f5 ff ff       	jmp    80105db7 <alltraps>

801067fb <vector151>:
.globl vector151
vector151:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $151
801067fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106802:	e9 b0 f5 ff ff       	jmp    80105db7 <alltraps>

80106807 <vector152>:
.globl vector152
vector152:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $152
80106809:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010680e:	e9 a4 f5 ff ff       	jmp    80105db7 <alltraps>

80106813 <vector153>:
.globl vector153
vector153:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $153
80106815:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010681a:	e9 98 f5 ff ff       	jmp    80105db7 <alltraps>

8010681f <vector154>:
.globl vector154
vector154:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $154
80106821:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106826:	e9 8c f5 ff ff       	jmp    80105db7 <alltraps>

8010682b <vector155>:
.globl vector155
vector155:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $155
8010682d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106832:	e9 80 f5 ff ff       	jmp    80105db7 <alltraps>

80106837 <vector156>:
.globl vector156
vector156:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $156
80106839:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010683e:	e9 74 f5 ff ff       	jmp    80105db7 <alltraps>

80106843 <vector157>:
.globl vector157
vector157:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $157
80106845:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010684a:	e9 68 f5 ff ff       	jmp    80105db7 <alltraps>

8010684f <vector158>:
.globl vector158
vector158:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $158
80106851:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106856:	e9 5c f5 ff ff       	jmp    80105db7 <alltraps>

8010685b <vector159>:
.globl vector159
vector159:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $159
8010685d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106862:	e9 50 f5 ff ff       	jmp    80105db7 <alltraps>

80106867 <vector160>:
.globl vector160
vector160:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $160
80106869:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010686e:	e9 44 f5 ff ff       	jmp    80105db7 <alltraps>

80106873 <vector161>:
.globl vector161
vector161:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $161
80106875:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010687a:	e9 38 f5 ff ff       	jmp    80105db7 <alltraps>

8010687f <vector162>:
.globl vector162
vector162:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $162
80106881:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106886:	e9 2c f5 ff ff       	jmp    80105db7 <alltraps>

8010688b <vector163>:
.globl vector163
vector163:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $163
8010688d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106892:	e9 20 f5 ff ff       	jmp    80105db7 <alltraps>

80106897 <vector164>:
.globl vector164
vector164:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $164
80106899:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010689e:	e9 14 f5 ff ff       	jmp    80105db7 <alltraps>

801068a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $165
801068a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068aa:	e9 08 f5 ff ff       	jmp    80105db7 <alltraps>

801068af <vector166>:
.globl vector166
vector166:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $166
801068b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068b6:	e9 fc f4 ff ff       	jmp    80105db7 <alltraps>

801068bb <vector167>:
.globl vector167
vector167:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $167
801068bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068c2:	e9 f0 f4 ff ff       	jmp    80105db7 <alltraps>

801068c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $168
801068c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068ce:	e9 e4 f4 ff ff       	jmp    80105db7 <alltraps>

801068d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $169
801068d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068da:	e9 d8 f4 ff ff       	jmp    80105db7 <alltraps>

801068df <vector170>:
.globl vector170
vector170:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $170
801068e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068e6:	e9 cc f4 ff ff       	jmp    80105db7 <alltraps>

801068eb <vector171>:
.globl vector171
vector171:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $171
801068ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068f2:	e9 c0 f4 ff ff       	jmp    80105db7 <alltraps>

801068f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $172
801068f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068fe:	e9 b4 f4 ff ff       	jmp    80105db7 <alltraps>

80106903 <vector173>:
.globl vector173
vector173:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $173
80106905:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010690a:	e9 a8 f4 ff ff       	jmp    80105db7 <alltraps>

8010690f <vector174>:
.globl vector174
vector174:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $174
80106911:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106916:	e9 9c f4 ff ff       	jmp    80105db7 <alltraps>

8010691b <vector175>:
.globl vector175
vector175:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $175
8010691d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106922:	e9 90 f4 ff ff       	jmp    80105db7 <alltraps>

80106927 <vector176>:
.globl vector176
vector176:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $176
80106929:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010692e:	e9 84 f4 ff ff       	jmp    80105db7 <alltraps>

80106933 <vector177>:
.globl vector177
vector177:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $177
80106935:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010693a:	e9 78 f4 ff ff       	jmp    80105db7 <alltraps>

8010693f <vector178>:
.globl vector178
vector178:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $178
80106941:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106946:	e9 6c f4 ff ff       	jmp    80105db7 <alltraps>

8010694b <vector179>:
.globl vector179
vector179:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $179
8010694d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106952:	e9 60 f4 ff ff       	jmp    80105db7 <alltraps>

80106957 <vector180>:
.globl vector180
vector180:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $180
80106959:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010695e:	e9 54 f4 ff ff       	jmp    80105db7 <alltraps>

80106963 <vector181>:
.globl vector181
vector181:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $181
80106965:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010696a:	e9 48 f4 ff ff       	jmp    80105db7 <alltraps>

8010696f <vector182>:
.globl vector182
vector182:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $182
80106971:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106976:	e9 3c f4 ff ff       	jmp    80105db7 <alltraps>

8010697b <vector183>:
.globl vector183
vector183:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $183
8010697d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106982:	e9 30 f4 ff ff       	jmp    80105db7 <alltraps>

80106987 <vector184>:
.globl vector184
vector184:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $184
80106989:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010698e:	e9 24 f4 ff ff       	jmp    80105db7 <alltraps>

80106993 <vector185>:
.globl vector185
vector185:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $185
80106995:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010699a:	e9 18 f4 ff ff       	jmp    80105db7 <alltraps>

8010699f <vector186>:
.globl vector186
vector186:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $186
801069a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069a6:	e9 0c f4 ff ff       	jmp    80105db7 <alltraps>

801069ab <vector187>:
.globl vector187
vector187:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $187
801069ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069b2:	e9 00 f4 ff ff       	jmp    80105db7 <alltraps>

801069b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $188
801069b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069be:	e9 f4 f3 ff ff       	jmp    80105db7 <alltraps>

801069c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $189
801069c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069ca:	e9 e8 f3 ff ff       	jmp    80105db7 <alltraps>

801069cf <vector190>:
.globl vector190
vector190:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $190
801069d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069d6:	e9 dc f3 ff ff       	jmp    80105db7 <alltraps>

801069db <vector191>:
.globl vector191
vector191:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $191
801069dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069e2:	e9 d0 f3 ff ff       	jmp    80105db7 <alltraps>

801069e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $192
801069e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069ee:	e9 c4 f3 ff ff       	jmp    80105db7 <alltraps>

801069f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $193
801069f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069fa:	e9 b8 f3 ff ff       	jmp    80105db7 <alltraps>

801069ff <vector194>:
.globl vector194
vector194:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $194
80106a01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a06:	e9 ac f3 ff ff       	jmp    80105db7 <alltraps>

80106a0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $195
80106a0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a12:	e9 a0 f3 ff ff       	jmp    80105db7 <alltraps>

80106a17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $196
80106a19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a1e:	e9 94 f3 ff ff       	jmp    80105db7 <alltraps>

80106a23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $197
80106a25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a2a:	e9 88 f3 ff ff       	jmp    80105db7 <alltraps>

80106a2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $198
80106a31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a36:	e9 7c f3 ff ff       	jmp    80105db7 <alltraps>

80106a3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $199
80106a3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a42:	e9 70 f3 ff ff       	jmp    80105db7 <alltraps>

80106a47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $200
80106a49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a4e:	e9 64 f3 ff ff       	jmp    80105db7 <alltraps>

80106a53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $201
80106a55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a5a:	e9 58 f3 ff ff       	jmp    80105db7 <alltraps>

80106a5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $202
80106a61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a66:	e9 4c f3 ff ff       	jmp    80105db7 <alltraps>

80106a6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $203
80106a6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a72:	e9 40 f3 ff ff       	jmp    80105db7 <alltraps>

80106a77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $204
80106a79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a7e:	e9 34 f3 ff ff       	jmp    80105db7 <alltraps>

80106a83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $205
80106a85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a8a:	e9 28 f3 ff ff       	jmp    80105db7 <alltraps>

80106a8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $206
80106a91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a96:	e9 1c f3 ff ff       	jmp    80105db7 <alltraps>

80106a9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $207
80106a9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106aa2:	e9 10 f3 ff ff       	jmp    80105db7 <alltraps>

80106aa7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $208
80106aa9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106aae:	e9 04 f3 ff ff       	jmp    80105db7 <alltraps>

80106ab3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $209
80106ab5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aba:	e9 f8 f2 ff ff       	jmp    80105db7 <alltraps>

80106abf <vector210>:
.globl vector210
vector210:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $210
80106ac1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ac6:	e9 ec f2 ff ff       	jmp    80105db7 <alltraps>

80106acb <vector211>:
.globl vector211
vector211:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $211
80106acd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ad2:	e9 e0 f2 ff ff       	jmp    80105db7 <alltraps>

80106ad7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $212
80106ad9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ade:	e9 d4 f2 ff ff       	jmp    80105db7 <alltraps>

80106ae3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $213
80106ae5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aea:	e9 c8 f2 ff ff       	jmp    80105db7 <alltraps>

80106aef <vector214>:
.globl vector214
vector214:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $214
80106af1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106af6:	e9 bc f2 ff ff       	jmp    80105db7 <alltraps>

80106afb <vector215>:
.globl vector215
vector215:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $215
80106afd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b02:	e9 b0 f2 ff ff       	jmp    80105db7 <alltraps>

80106b07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $216
80106b09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b0e:	e9 a4 f2 ff ff       	jmp    80105db7 <alltraps>

80106b13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $217
80106b15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b1a:	e9 98 f2 ff ff       	jmp    80105db7 <alltraps>

80106b1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $218
80106b21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b26:	e9 8c f2 ff ff       	jmp    80105db7 <alltraps>

80106b2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $219
80106b2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b32:	e9 80 f2 ff ff       	jmp    80105db7 <alltraps>

80106b37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $220
80106b39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b3e:	e9 74 f2 ff ff       	jmp    80105db7 <alltraps>

80106b43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $221
80106b45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b4a:	e9 68 f2 ff ff       	jmp    80105db7 <alltraps>

80106b4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $222
80106b51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b56:	e9 5c f2 ff ff       	jmp    80105db7 <alltraps>

80106b5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $223
80106b5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b62:	e9 50 f2 ff ff       	jmp    80105db7 <alltraps>

80106b67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $224
80106b69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b6e:	e9 44 f2 ff ff       	jmp    80105db7 <alltraps>

80106b73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $225
80106b75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b7a:	e9 38 f2 ff ff       	jmp    80105db7 <alltraps>

80106b7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $226
80106b81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b86:	e9 2c f2 ff ff       	jmp    80105db7 <alltraps>

80106b8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $227
80106b8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b92:	e9 20 f2 ff ff       	jmp    80105db7 <alltraps>

80106b97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $228
80106b99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b9e:	e9 14 f2 ff ff       	jmp    80105db7 <alltraps>

80106ba3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $229
80106ba5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106baa:	e9 08 f2 ff ff       	jmp    80105db7 <alltraps>

80106baf <vector230>:
.globl vector230
vector230:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $230
80106bb1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106bb6:	e9 fc f1 ff ff       	jmp    80105db7 <alltraps>

80106bbb <vector231>:
.globl vector231
vector231:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $231
80106bbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bc2:	e9 f0 f1 ff ff       	jmp    80105db7 <alltraps>

80106bc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $232
80106bc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bce:	e9 e4 f1 ff ff       	jmp    80105db7 <alltraps>

80106bd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $233
80106bd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bda:	e9 d8 f1 ff ff       	jmp    80105db7 <alltraps>

80106bdf <vector234>:
.globl vector234
vector234:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $234
80106be1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106be6:	e9 cc f1 ff ff       	jmp    80105db7 <alltraps>

80106beb <vector235>:
.globl vector235
vector235:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $235
80106bed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bf2:	e9 c0 f1 ff ff       	jmp    80105db7 <alltraps>

80106bf7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $236
80106bf9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bfe:	e9 b4 f1 ff ff       	jmp    80105db7 <alltraps>

80106c03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $237
80106c05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c0a:	e9 a8 f1 ff ff       	jmp    80105db7 <alltraps>

80106c0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $238
80106c11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c16:	e9 9c f1 ff ff       	jmp    80105db7 <alltraps>

80106c1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $239
80106c1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c22:	e9 90 f1 ff ff       	jmp    80105db7 <alltraps>

80106c27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $240
80106c29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c2e:	e9 84 f1 ff ff       	jmp    80105db7 <alltraps>

80106c33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $241
80106c35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c3a:	e9 78 f1 ff ff       	jmp    80105db7 <alltraps>

80106c3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $242
80106c41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c46:	e9 6c f1 ff ff       	jmp    80105db7 <alltraps>

80106c4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $243
80106c4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c52:	e9 60 f1 ff ff       	jmp    80105db7 <alltraps>

80106c57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $244
80106c59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c5e:	e9 54 f1 ff ff       	jmp    80105db7 <alltraps>

80106c63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $245
80106c65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c6a:	e9 48 f1 ff ff       	jmp    80105db7 <alltraps>

80106c6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $246
80106c71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c76:	e9 3c f1 ff ff       	jmp    80105db7 <alltraps>

80106c7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $247
80106c7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c82:	e9 30 f1 ff ff       	jmp    80105db7 <alltraps>

80106c87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $248
80106c89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c8e:	e9 24 f1 ff ff       	jmp    80105db7 <alltraps>

80106c93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $249
80106c95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c9a:	e9 18 f1 ff ff       	jmp    80105db7 <alltraps>

80106c9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $250
80106ca1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ca6:	e9 0c f1 ff ff       	jmp    80105db7 <alltraps>

80106cab <vector251>:
.globl vector251
vector251:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $251
80106cad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106cb2:	e9 00 f1 ff ff       	jmp    80105db7 <alltraps>

80106cb7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $252
80106cb9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cbe:	e9 f4 f0 ff ff       	jmp    80105db7 <alltraps>

80106cc3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $253
80106cc5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cca:	e9 e8 f0 ff ff       	jmp    80105db7 <alltraps>

80106ccf <vector254>:
.globl vector254
vector254:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $254
80106cd1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cd6:	e9 dc f0 ff ff       	jmp    80105db7 <alltraps>

80106cdb <vector255>:
.globl vector255
vector255:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $255
80106cdd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ce2:	e9 d0 f0 ff ff       	jmp    80105db7 <alltraps>
80106ce7:	66 90                	xchg   %ax,%ax
80106ce9:	66 90                	xchg   %ax,%ax
80106ceb:	66 90                	xchg   %ax,%ax
80106ced:	66 90                	xchg   %ax,%ax
80106cef:	90                   	nop

80106cf0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106cf8:	c1 ea 16             	shr    $0x16,%edx
80106cfb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cfe:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106d01:	8b 07                	mov    (%edi),%eax
80106d03:	a8 01                	test   $0x1,%al
80106d05:	74 29                	je     80106d30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d0c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d15:	c1 eb 0a             	shr    $0xa,%ebx
80106d18:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106d1e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106d21:	5b                   	pop    %ebx
80106d22:	5e                   	pop    %esi
80106d23:	5f                   	pop    %edi
80106d24:	5d                   	pop    %ebp
80106d25:	c3                   	ret    
80106d26:	8d 76 00             	lea    0x0(%esi),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d30:	85 c9                	test   %ecx,%ecx
80106d32:	74 2c                	je     80106d60 <walkpgdir+0x70>
80106d34:	e8 e7 ba ff ff       	call   80102820 <kalloc>
80106d39:	85 c0                	test   %eax,%eax
80106d3b:	89 c6                	mov    %eax,%esi
80106d3d:	74 21                	je     80106d60 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106d3f:	83 ec 04             	sub    $0x4,%esp
80106d42:	68 00 10 00 00       	push   $0x1000
80106d47:	6a 00                	push   $0x0
80106d49:	50                   	push   %eax
80106d4a:	e8 71 dc ff ff       	call   801049c0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d4f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d55:	83 c4 10             	add    $0x10,%esp
80106d58:	83 c8 07             	or     $0x7,%eax
80106d5b:	89 07                	mov    %eax,(%edi)
80106d5d:	eb b3                	jmp    80106d12 <walkpgdir+0x22>
80106d5f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106d63:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret    
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d76:	89 d3                	mov    %edx,%ebx
80106d78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d7e:	83 ec 1c             	sub    $0x1c,%esp
80106d81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d96:	29 df                	sub    %ebx,%edi
80106d98:	83 c8 01             	or     $0x1,%eax
80106d9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d9e:	eb 15                	jmp    80106db5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106da0:	f6 00 01             	testb  $0x1,(%eax)
80106da3:	75 45                	jne    80106dea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106da5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106da8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106dab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dad:	74 31                	je     80106de0 <mappages+0x70>
      break;
    a += PGSIZE;
80106daf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106dbd:	89 da                	mov    %ebx,%edx
80106dbf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106dc2:	e8 29 ff ff ff       	call   80106cf0 <walkpgdir>
80106dc7:	85 c0                	test   %eax,%eax
80106dc9:	75 d5                	jne    80106da0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dd3:	5b                   	pop    %ebx
80106dd4:	5e                   	pop    %esi
80106dd5:	5f                   	pop    %edi
80106dd6:	5d                   	pop    %ebp
80106dd7:	c3                   	ret    
80106dd8:	90                   	nop
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106dea:	83 ec 0c             	sub    $0xc,%esp
80106ded:	68 5c 7f 10 80       	push   $0x80107f5c
80106df2:	e8 79 95 ff ff       	call   80100370 <panic>
80106df7:	89 f6                	mov    %esi,%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e0c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e14:	83 ec 1c             	sub    $0x1c,%esp
80106e17:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e1a:	39 d3                	cmp    %edx,%ebx
80106e1c:	73 66                	jae    80106e84 <deallocuvm.part.0+0x84>
80106e1e:	89 d6                	mov    %edx,%esi
80106e20:	eb 3d                	jmp    80106e5f <deallocuvm.part.0+0x5f>
80106e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e28:	8b 10                	mov    (%eax),%edx
80106e2a:	f6 c2 01             	test   $0x1,%dl
80106e2d:	74 26                	je     80106e55 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e35:	74 58                	je     80106e8f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e37:	83 ec 0c             	sub    $0xc,%esp
80106e3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e43:	52                   	push   %edx
80106e44:	e8 27 b8 ff ff       	call   80102670 <kfree>
      *pte = 0;
80106e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e4c:	83 c4 10             	add    $0x10,%esp
80106e4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e5b:	39 f3                	cmp    %esi,%ebx
80106e5d:	73 25                	jae    80106e84 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e5f:	31 c9                	xor    %ecx,%ecx
80106e61:	89 da                	mov    %ebx,%edx
80106e63:	89 f8                	mov    %edi,%eax
80106e65:	e8 86 fe ff ff       	call   80106cf0 <walkpgdir>
    if(!pte)
80106e6a:	85 c0                	test   %eax,%eax
80106e6c:	75 ba                	jne    80106e28 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e6e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e74:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e80:	39 f3                	cmp    %esi,%ebx
80106e82:	72 db                	jb     80106e5f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8a:	5b                   	pop    %ebx
80106e8b:	5e                   	pop    %esi
80106e8c:	5f                   	pop    %edi
80106e8d:	5d                   	pop    %ebp
80106e8e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106e8f:	83 ec 0c             	sub    $0xc,%esp
80106e92:	68 e6 78 10 80       	push   $0x801078e6
80106e97:	e8 d4 94 ff ff       	call   80100370 <panic>
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ea0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106ea6:	e8 75 cc ff ff       	call   80103b20 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106eb1:	31 c9                	xor    %ecx,%ecx
80106eb3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106eb8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106ebf:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ec6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ecb:	31 c9                	xor    %ecx,%ecx
80106ecd:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ed4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ed9:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ee0:	31 c9                	xor    %ecx,%ecx
80106ee2:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106ee9:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ef0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ef5:	31 c9                	xor    %ecx,%ecx
80106ef7:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106efe:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106f05:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f0a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106f11:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106f18:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f1f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80106f26:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
80106f2d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80106f34:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f3b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80106f42:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80106f49:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80106f50:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f57:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
80106f5e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80106f65:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
80106f6c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80106f73:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106f7a:	05 f0 37 11 80       	add    $0x801137f0,%eax
80106f7f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106f83:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f87:	c1 e8 10             	shr    $0x10,%eax
80106f8a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106f8e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f91:	0f 01 10             	lgdtl  (%eax)
}
80106f94:	c9                   	leave  
80106f95:	c3                   	ret    
80106f96:	8d 76 00             	lea    0x0(%esi),%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fa0:	a1 a4 68 11 80       	mov    0x801168a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106fa5:	55                   	push   %ebp
80106fa6:	89 e5                	mov    %esp,%ebp
80106fa8:	05 00 00 00 80       	add    $0x80000000,%eax
80106fad:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106fb0:	5d                   	pop    %ebp
80106fb1:	c3                   	ret    
80106fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fc0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106fcc:	85 f6                	test   %esi,%esi
80106fce:	0f 84 cd 00 00 00    	je     801070a1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106fd4:	8b 46 08             	mov    0x8(%esi),%eax
80106fd7:	85 c0                	test   %eax,%eax
80106fd9:	0f 84 dc 00 00 00    	je     801070bb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106fdf:	8b 7e 04             	mov    0x4(%esi),%edi
80106fe2:	85 ff                	test   %edi,%edi
80106fe4:	0f 84 c4 00 00 00    	je     801070ae <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106fea:	e8 f1 d7 ff ff       	call   801047e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fef:	e8 ac ca ff ff       	call   80103aa0 <mycpu>
80106ff4:	89 c3                	mov    %eax,%ebx
80106ff6:	e8 a5 ca ff ff       	call   80103aa0 <mycpu>
80106ffb:	89 c7                	mov    %eax,%edi
80106ffd:	e8 9e ca ff ff       	call   80103aa0 <mycpu>
80107002:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107005:	83 c7 08             	add    $0x8,%edi
80107008:	e8 93 ca ff ff       	call   80103aa0 <mycpu>
8010700d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107010:	83 c0 08             	add    $0x8,%eax
80107013:	ba 67 00 00 00       	mov    $0x67,%edx
80107018:	c1 e8 18             	shr    $0x18,%eax
8010701b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107022:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107029:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107030:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107037:	83 c1 08             	add    $0x8,%ecx
8010703a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107040:	c1 e9 10             	shr    $0x10,%ecx
80107043:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107049:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010704e:	e8 4d ca ff ff       	call   80103aa0 <mycpu>
80107053:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010705a:	e8 41 ca ff ff       	call   80103aa0 <mycpu>
8010705f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107064:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107068:	e8 33 ca ff ff       	call   80103aa0 <mycpu>
8010706d:	8b 56 08             	mov    0x8(%esi),%edx
80107070:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107076:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107079:	e8 22 ca ff ff       	call   80103aa0 <mycpu>
8010707e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107082:	b8 28 00 00 00       	mov    $0x28,%eax
80107087:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010708a:	8b 46 04             	mov    0x4(%esi),%eax
8010708d:	05 00 00 00 80       	add    $0x80000000,%eax
80107092:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107098:	5b                   	pop    %ebx
80107099:	5e                   	pop    %esi
8010709a:	5f                   	pop    %edi
8010709b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010709c:	e9 7f d7 ff ff       	jmp    80104820 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801070a1:	83 ec 0c             	sub    $0xc,%esp
801070a4:	68 62 7f 10 80       	push   $0x80107f62
801070a9:	e8 c2 92 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801070ae:	83 ec 0c             	sub    $0xc,%esp
801070b1:	68 8d 7f 10 80       	push   $0x80107f8d
801070b6:	e8 b5 92 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801070bb:	83 ec 0c             	sub    $0xc,%esp
801070be:	68 78 7f 10 80       	push   $0x80107f78
801070c3:	e8 a8 92 ff ff       	call   80100370 <panic>
801070c8:	90                   	nop
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
801070d9:	8b 75 10             	mov    0x10(%ebp),%esi
801070dc:	8b 45 08             	mov    0x8(%ebp),%eax
801070df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801070e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801070eb:	77 49                	ja     80107136 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801070ed:	e8 2e b7 ff ff       	call   80102820 <kalloc>
  memset(mem, 0, PGSIZE);
801070f2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801070f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070f7:	68 00 10 00 00       	push   $0x1000
801070fc:	6a 00                	push   $0x0
801070fe:	50                   	push   %eax
801070ff:	e8 bc d8 ff ff       	call   801049c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107104:	58                   	pop    %eax
80107105:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010710b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107110:	5a                   	pop    %edx
80107111:	6a 06                	push   $0x6
80107113:	50                   	push   %eax
80107114:	31 d2                	xor    %edx,%edx
80107116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107119:	e8 52 fc ff ff       	call   80106d70 <mappages>
  memmove(mem, init, sz);
8010711e:	89 75 10             	mov    %esi,0x10(%ebp)
80107121:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107124:	83 c4 10             	add    $0x10,%esp
80107127:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010712a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010712d:	5b                   	pop    %ebx
8010712e:	5e                   	pop    %esi
8010712f:	5f                   	pop    %edi
80107130:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107131:	e9 3a d9 ff ff       	jmp    80104a70 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107136:	83 ec 0c             	sub    $0xc,%esp
80107139:	68 a1 7f 10 80       	push   $0x80107fa1
8010713e:	e8 2d 92 ff ff       	call   80100370 <panic>
80107143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107150 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107159:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107160:	0f 85 91 00 00 00    	jne    801071f7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107166:	8b 75 18             	mov    0x18(%ebp),%esi
80107169:	31 db                	xor    %ebx,%ebx
8010716b:	85 f6                	test   %esi,%esi
8010716d:	75 1a                	jne    80107189 <loaduvm+0x39>
8010716f:	eb 6f                	jmp    801071e0 <loaduvm+0x90>
80107171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107178:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010717e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107184:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107187:	76 57                	jbe    801071e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107189:	8b 55 0c             	mov    0xc(%ebp),%edx
8010718c:	8b 45 08             	mov    0x8(%ebp),%eax
8010718f:	31 c9                	xor    %ecx,%ecx
80107191:	01 da                	add    %ebx,%edx
80107193:	e8 58 fb ff ff       	call   80106cf0 <walkpgdir>
80107198:	85 c0                	test   %eax,%eax
8010719a:	74 4e                	je     801071ea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010719c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010719e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801071a1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801071a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071ab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071b1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071b4:	01 d9                	add    %ebx,%ecx
801071b6:	05 00 00 00 80       	add    $0x80000000,%eax
801071bb:	57                   	push   %edi
801071bc:	51                   	push   %ecx
801071bd:	50                   	push   %eax
801071be:	ff 75 10             	pushl  0x10(%ebp)
801071c1:	e8 1a ab ff ff       	call   80101ce0 <readi>
801071c6:	83 c4 10             	add    $0x10,%esp
801071c9:	39 c7                	cmp    %eax,%edi
801071cb:	74 ab                	je     80107178 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801071cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801071d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801071e3:	31 c0                	xor    %eax,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801071ea:	83 ec 0c             	sub    $0xc,%esp
801071ed:	68 bb 7f 10 80       	push   $0x80107fbb
801071f2:	e8 79 91 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801071f7:	83 ec 0c             	sub    $0xc,%esp
801071fa:	68 5c 80 10 80       	push   $0x8010805c
801071ff:	e8 6c 91 ff ff       	call   80100370 <panic>
80107204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010720a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107210 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 0c             	sub    $0xc,%esp
80107219:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010721c:	85 ff                	test   %edi,%edi
8010721e:	0f 88 ca 00 00 00    	js     801072ee <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107224:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107227:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010722a:	0f 82 82 00 00 00    	jb     801072b2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107230:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107236:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010723c:	39 df                	cmp    %ebx,%edi
8010723e:	77 43                	ja     80107283 <allocuvm+0x73>
80107240:	e9 bb 00 00 00       	jmp    80107300 <allocuvm+0xf0>
80107245:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107248:	83 ec 04             	sub    $0x4,%esp
8010724b:	68 00 10 00 00       	push   $0x1000
80107250:	6a 00                	push   $0x0
80107252:	50                   	push   %eax
80107253:	e8 68 d7 ff ff       	call   801049c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107258:	58                   	pop    %eax
80107259:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010725f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107264:	5a                   	pop    %edx
80107265:	6a 06                	push   $0x6
80107267:	50                   	push   %eax
80107268:	89 da                	mov    %ebx,%edx
8010726a:	8b 45 08             	mov    0x8(%ebp),%eax
8010726d:	e8 fe fa ff ff       	call   80106d70 <mappages>
80107272:	83 c4 10             	add    $0x10,%esp
80107275:	85 c0                	test   %eax,%eax
80107277:	78 47                	js     801072c0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107279:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010727f:	39 df                	cmp    %ebx,%edi
80107281:	76 7d                	jbe    80107300 <allocuvm+0xf0>
    mem = kalloc();
80107283:	e8 98 b5 ff ff       	call   80102820 <kalloc>
    if(mem == 0){
80107288:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010728a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010728c:	75 ba                	jne    80107248 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010728e:	83 ec 0c             	sub    $0xc,%esp
80107291:	68 d9 7f 10 80       	push   $0x80107fd9
80107296:	e8 c5 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010729b:	83 c4 10             	add    $0x10,%esp
8010729e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801072a1:	76 4b                	jbe    801072ee <allocuvm+0xde>
801072a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072a6:	8b 45 08             	mov    0x8(%ebp),%eax
801072a9:	89 fa                	mov    %edi,%edx
801072ab:	e8 50 fb ff ff       	call   80106e00 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801072b0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801072b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801072c0:	83 ec 0c             	sub    $0xc,%esp
801072c3:	68 f1 7f 10 80       	push   $0x80107ff1
801072c8:	e8 93 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801072cd:	83 c4 10             	add    $0x10,%esp
801072d0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801072d3:	76 0d                	jbe    801072e2 <allocuvm+0xd2>
801072d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072d8:	8b 45 08             	mov    0x8(%ebp),%eax
801072db:	89 fa                	mov    %edi,%edx
801072dd:	e8 1e fb ff ff       	call   80106e00 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801072e2:	83 ec 0c             	sub    $0xc,%esp
801072e5:	56                   	push   %esi
801072e6:	e8 85 b3 ff ff       	call   80102670 <kfree>
      return 0;
801072eb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801072ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801072f1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801072f3:	5b                   	pop    %ebx
801072f4:	5e                   	pop    %esi
801072f5:	5f                   	pop    %edi
801072f6:	5d                   	pop    %ebp
801072f7:	c3                   	ret    
801072f8:	90                   	nop
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107300:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107303:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    
8010730a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107310 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	8b 55 0c             	mov    0xc(%ebp),%edx
80107316:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107319:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010731c:	39 d1                	cmp    %edx,%ecx
8010731e:	73 10                	jae    80107330 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107320:	5d                   	pop    %ebp
80107321:	e9 da fa ff ff       	jmp    80106e00 <deallocuvm.part.0>
80107326:	8d 76 00             	lea    0x0(%esi),%esi
80107329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107330:	89 d0                	mov    %edx,%eax
80107332:	5d                   	pop    %ebp
80107333:	c3                   	ret    
80107334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010733a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107340 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 0c             	sub    $0xc,%esp
80107349:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010734c:	85 f6                	test   %esi,%esi
8010734e:	74 59                	je     801073a9 <freevm+0x69>
80107350:	31 c9                	xor    %ecx,%ecx
80107352:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107357:	89 f0                	mov    %esi,%eax
80107359:	e8 a2 fa ff ff       	call   80106e00 <deallocuvm.part.0>
8010735e:	89 f3                	mov    %esi,%ebx
80107360:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107366:	eb 0f                	jmp    80107377 <freevm+0x37>
80107368:	90                   	nop
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107370:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107373:	39 fb                	cmp    %edi,%ebx
80107375:	74 23                	je     8010739a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107377:	8b 03                	mov    (%ebx),%eax
80107379:	a8 01                	test   $0x1,%al
8010737b:	74 f3                	je     80107370 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010737d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107382:	83 ec 0c             	sub    $0xc,%esp
80107385:	83 c3 04             	add    $0x4,%ebx
80107388:	05 00 00 00 80       	add    $0x80000000,%eax
8010738d:	50                   	push   %eax
8010738e:	e8 dd b2 ff ff       	call   80102670 <kfree>
80107393:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107396:	39 fb                	cmp    %edi,%ebx
80107398:	75 dd                	jne    80107377 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010739a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010739d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a0:	5b                   	pop    %ebx
801073a1:	5e                   	pop    %esi
801073a2:	5f                   	pop    %edi
801073a3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801073a4:	e9 c7 b2 ff ff       	jmp    80102670 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801073a9:	83 ec 0c             	sub    $0xc,%esp
801073ac:	68 0d 80 10 80       	push   $0x8010800d
801073b1:	e8 ba 8f ff ff       	call   80100370 <panic>
801073b6:	8d 76 00             	lea    0x0(%esi),%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073c0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	56                   	push   %esi
801073c4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801073c5:	e8 56 b4 ff ff       	call   80102820 <kalloc>
801073ca:	85 c0                	test   %eax,%eax
801073cc:	74 6a                	je     80107438 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801073ce:	83 ec 04             	sub    $0x4,%esp
801073d1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801073d8:	68 00 10 00 00       	push   $0x1000
801073dd:	6a 00                	push   $0x0
801073df:	50                   	push   %eax
801073e0:	e8 db d5 ff ff       	call   801049c0 <memset>
801073e5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073e8:	8b 43 04             	mov    0x4(%ebx),%eax
801073eb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073ee:	83 ec 08             	sub    $0x8,%esp
801073f1:	8b 13                	mov    (%ebx),%edx
801073f3:	ff 73 0c             	pushl  0xc(%ebx)
801073f6:	50                   	push   %eax
801073f7:	29 c1                	sub    %eax,%ecx
801073f9:	89 f0                	mov    %esi,%eax
801073fb:	e8 70 f9 ff ff       	call   80106d70 <mappages>
80107400:	83 c4 10             	add    $0x10,%esp
80107403:	85 c0                	test   %eax,%eax
80107405:	78 19                	js     80107420 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107407:	83 c3 10             	add    $0x10,%ebx
8010740a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107410:	75 d6                	jne    801073e8 <setupkvm+0x28>
80107412:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107414:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107417:	5b                   	pop    %ebx
80107418:	5e                   	pop    %esi
80107419:	5d                   	pop    %ebp
8010741a:	c3                   	ret    
8010741b:	90                   	nop
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107420:	83 ec 0c             	sub    $0xc,%esp
80107423:	56                   	push   %esi
80107424:	e8 17 ff ff ff       	call   80107340 <freevm>
      return 0;
80107429:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010742c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010742f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107431:	5b                   	pop    %ebx
80107432:	5e                   	pop    %esi
80107433:	5d                   	pop    %ebp
80107434:	c3                   	ret    
80107435:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107438:	31 c0                	xor    %eax,%eax
8010743a:	eb d8                	jmp    80107414 <setupkvm+0x54>
8010743c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107440 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107446:	e8 75 ff ff ff       	call   801073c0 <setupkvm>
8010744b:	a3 a4 68 11 80       	mov    %eax,0x801168a4
80107450:	05 00 00 00 80       	add    $0x80000000,%eax
80107455:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107458:	c9                   	leave  
80107459:	c3                   	ret    
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107460 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107460:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107461:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107463:	89 e5                	mov    %esp,%ebp
80107465:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107468:	8b 55 0c             	mov    0xc(%ebp),%edx
8010746b:	8b 45 08             	mov    0x8(%ebp),%eax
8010746e:	e8 7d f8 ff ff       	call   80106cf0 <walkpgdir>
  if(pte == 0)
80107473:	85 c0                	test   %eax,%eax
80107475:	74 05                	je     8010747c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107477:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010747a:	c9                   	leave  
8010747b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010747c:	83 ec 0c             	sub    $0xc,%esp
8010747f:	68 1e 80 10 80       	push   $0x8010801e
80107484:	e8 e7 8e ff ff       	call   80100370 <panic>
80107489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107490 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107499:	e8 22 ff ff ff       	call   801073c0 <setupkvm>
8010749e:	85 c0                	test   %eax,%eax
801074a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074a3:	0f 84 c5 00 00 00    	je     8010756e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074ac:	85 c9                	test   %ecx,%ecx
801074ae:	0f 84 9c 00 00 00    	je     80107550 <copyuvm+0xc0>
801074b4:	31 ff                	xor    %edi,%edi
801074b6:	eb 4a                	jmp    80107502 <copyuvm+0x72>
801074b8:	90                   	nop
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074c0:	83 ec 04             	sub    $0x4,%esp
801074c3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801074c9:	68 00 10 00 00       	push   $0x1000
801074ce:	53                   	push   %ebx
801074cf:	50                   	push   %eax
801074d0:	e8 9b d5 ff ff       	call   80104a70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074d5:	58                   	pop    %eax
801074d6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074dc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074e1:	5a                   	pop    %edx
801074e2:	ff 75 e4             	pushl  -0x1c(%ebp)
801074e5:	50                   	push   %eax
801074e6:	89 fa                	mov    %edi,%edx
801074e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074eb:	e8 80 f8 ff ff       	call   80106d70 <mappages>
801074f0:	83 c4 10             	add    $0x10,%esp
801074f3:	85 c0                	test   %eax,%eax
801074f5:	78 69                	js     80107560 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074f7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801074fd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107500:	76 4e                	jbe    80107550 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107502:	8b 45 08             	mov    0x8(%ebp),%eax
80107505:	31 c9                	xor    %ecx,%ecx
80107507:	89 fa                	mov    %edi,%edx
80107509:	e8 e2 f7 ff ff       	call   80106cf0 <walkpgdir>
8010750e:	85 c0                	test   %eax,%eax
80107510:	74 6d                	je     8010757f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107512:	8b 00                	mov    (%eax),%eax
80107514:	a8 01                	test   $0x1,%al
80107516:	74 5a                	je     80107572 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107518:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010751a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010751f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107528:	e8 f3 b2 ff ff       	call   80102820 <kalloc>
8010752d:	85 c0                	test   %eax,%eax
8010752f:	89 c6                	mov    %eax,%esi
80107531:	75 8d                	jne    801074c0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107533:	83 ec 0c             	sub    $0xc,%esp
80107536:	ff 75 e0             	pushl  -0x20(%ebp)
80107539:	e8 02 fe ff ff       	call   80107340 <freevm>
  return 0;
8010753e:	83 c4 10             	add    $0x10,%esp
80107541:	31 c0                	xor    %eax,%eax
}
80107543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107546:	5b                   	pop    %ebx
80107547:	5e                   	pop    %esi
80107548:	5f                   	pop    %edi
80107549:	5d                   	pop    %ebp
8010754a:	c3                   	ret    
8010754b:	90                   	nop
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107553:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107556:	5b                   	pop    %ebx
80107557:	5e                   	pop    %esi
80107558:	5f                   	pop    %edi
80107559:	5d                   	pop    %ebp
8010755a:	c3                   	ret    
8010755b:	90                   	nop
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107560:	83 ec 0c             	sub    $0xc,%esp
80107563:	56                   	push   %esi
80107564:	e8 07 b1 ff ff       	call   80102670 <kfree>
      goto bad;
80107569:	83 c4 10             	add    $0x10,%esp
8010756c:	eb c5                	jmp    80107533 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010756e:	31 c0                	xor    %eax,%eax
80107570:	eb d1                	jmp    80107543 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107572:	83 ec 0c             	sub    $0xc,%esp
80107575:	68 42 80 10 80       	push   $0x80108042
8010757a:	e8 f1 8d ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010757f:	83 ec 0c             	sub    $0xc,%esp
80107582:	68 28 80 10 80       	push   $0x80108028
80107587:	e8 e4 8d ff ff       	call   80100370 <panic>
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107590 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107590:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107591:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107593:	89 e5                	mov    %esp,%ebp
80107595:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107598:	8b 55 0c             	mov    0xc(%ebp),%edx
8010759b:	8b 45 08             	mov    0x8(%ebp),%eax
8010759e:	e8 4d f7 ff ff       	call   80106cf0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801075a3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801075a5:	89 c2                	mov    %eax,%edx
801075a7:	83 e2 05             	and    $0x5,%edx
801075aa:	83 fa 05             	cmp    $0x5,%edx
801075ad:	75 11                	jne    801075c0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801075af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801075b4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801075b5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801075ba:	c3                   	ret    
801075bb:	90                   	nop
801075bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801075c0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801075c2:	c9                   	leave  
801075c3:	c3                   	ret    
801075c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 1c             	sub    $0x1c,%esp
801075d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801075dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075e2:	85 db                	test   %ebx,%ebx
801075e4:	75 40                	jne    80107626 <copyout+0x56>
801075e6:	eb 70                	jmp    80107658 <copyout+0x88>
801075e8:	90                   	nop
801075e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801075f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075f3:	89 f1                	mov    %esi,%ecx
801075f5:	29 d1                	sub    %edx,%ecx
801075f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801075fd:	39 d9                	cmp    %ebx,%ecx
801075ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107602:	29 f2                	sub    %esi,%edx
80107604:	83 ec 04             	sub    $0x4,%esp
80107607:	01 d0                	add    %edx,%eax
80107609:	51                   	push   %ecx
8010760a:	57                   	push   %edi
8010760b:	50                   	push   %eax
8010760c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010760f:	e8 5c d4 ff ff       	call   80104a70 <memmove>
    len -= n;
    buf += n;
80107614:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107617:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010761a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107620:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107622:	29 cb                	sub    %ecx,%ebx
80107624:	74 32                	je     80107658 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107626:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107628:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010762b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010762e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107634:	56                   	push   %esi
80107635:	ff 75 08             	pushl  0x8(%ebp)
80107638:	e8 53 ff ff ff       	call   80107590 <uva2ka>
    if(pa0 == 0)
8010763d:	83 c4 10             	add    $0x10,%esp
80107640:	85 c0                	test   %eax,%eax
80107642:	75 ac                	jne    801075f0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107644:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010764c:	5b                   	pop    %ebx
8010764d:	5e                   	pop    %esi
8010764e:	5f                   	pop    %edi
8010764f:	5d                   	pop    %ebp
80107650:	c3                   	ret    
80107651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107658:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010765b:	31 c0                	xor    %eax,%eax
}
8010765d:	5b                   	pop    %ebx
8010765e:	5e                   	pop    %esi
8010765f:	5f                   	pop    %edi
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    
