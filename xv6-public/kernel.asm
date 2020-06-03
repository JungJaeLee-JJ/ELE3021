
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
8010004c:	68 80 78 10 80       	push   $0x80107880
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 95 48 00 00       	call   801048f0 <initlock>

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
80100092:	68 87 78 10 80       	push   $0x80107887
80100097:	50                   	push   %eax
80100098:	e8 23 47 00 00       	call   801047c0 <initsleeplock>
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
801000e4:	e8 67 49 00 00       	call   80104a50 <acquire>

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
80100162:	e8 99 49 00 00       	call   80104b00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 46 00 00       	call   80104800 <acquiresleep>
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
80100193:	68 8e 78 10 80       	push   $0x8010788e
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
801001ae:	e8 ed 46 00 00       	call   801048a0 <holdingsleep>
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
801001cc:	68 9f 78 10 80       	push   $0x8010789f
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
801001ef:	e8 ac 46 00 00       	call   801048a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 46 00 00       	call   80104860 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 48 00 00       	call   80104a50 <acquire>
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
8010025c:	e9 9f 48 00 00       	jmp    80104b00 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 78 10 80       	push   $0x801078a6
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
8010028c:	e8 bf 47 00 00       	call   80104a50 <acquire>
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
801002bd:	e8 8e 41 00 00       	call   80104450 <sleep>

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
801002d2:	e8 79 38 00 00       	call   80103b50 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 15 48 00 00       	call   80104b00 <release>
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
80100346:	e8 b5 47 00 00       	call   80104b00 <release>
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
80100392:	68 ad 78 10 80       	push   $0x801078ad
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 73 82 10 80 	movl   $0x80108273,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 53 45 00 00       	call   80104910 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 c1 78 10 80       	push   $0x801078c1
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
8010041a:	e8 21 60 00 00       	call   80106440 <uartputc>
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
801004d3:	e8 68 5f 00 00       	call   80106440 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 5c 5f 00 00       	call   80106440 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 50 5f 00 00       	call   80106440 <uartputc>
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
80100514:	e8 e7 46 00 00       	call   80104c00 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 22 46 00 00       	call   80104b50 <memset>
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
80100540:	68 c5 78 10 80       	push   $0x801078c5
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
801005b1:	0f b6 92 f0 78 10 80 	movzbl -0x7fef8710(%edx),%edx
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
8010061b:	e8 30 44 00 00       	call   80104a50 <acquire>
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
80100647:	e8 b4 44 00 00       	call   80104b00 <release>
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
8010070d:	e8 ee 43 00 00       	call   80104b00 <release>
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
80100788:	b8 d8 78 10 80       	mov    $0x801078d8,%eax
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
801007c8:	e8 83 42 00 00       	call   80104a50 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 df 78 10 80       	push   $0x801078df
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
80100803:	e8 48 42 00 00       	call   80104a50 <acquire>
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
80100868:	e8 93 42 00 00       	call   80104b00 <release>
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
801008f6:	e8 15 3d 00 00       	call   80104610 <wakeup>
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
80100977:	e9 84 3d 00 00       	jmp    80104700 <procdump>
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
801009a6:	68 e8 78 10 80       	push   $0x801078e8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 3b 3f 00 00       	call   801048f0 <initlock>

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
801009fc:	e8 4f 31 00 00       	call   80103b50 <myproc>
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
80100a74:	e8 57 6b 00 00       	call   801075d0 <setupkvm>
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
80100b04:	e8 17 69 00 00       	call   80107420 <allocuvm>
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
80100b3a:	e8 21 68 00 00       	call   80107360 <loaduvm>
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
80100b59:	e8 f2 69 00 00       	call   80107550 <freevm>
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
80100b95:	e8 86 68 00 00       	call   80107420 <allocuvm>
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
80100bac:	e8 9f 69 00 00       	call   80107550 <freevm>
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
80100bc6:	68 01 79 10 80       	push   $0x80107901
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
80100bf1:	e8 7a 6a 00 00       	call   80107670 <clearpteu>
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
80100c2d:	e8 5e 41 00 00       	call   80104d90 <strlen>
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
80100c40:	e8 4b 41 00 00       	call   80104d90 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 8a 6b 00 00       	call   801077e0 <copyout>
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
80100cbb:	e8 20 6b 00 00       	call   801077e0 <copyout>
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
80100d00:	e8 4b 40 00 00       	call   80104d50 <safestrcpy>

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
80100d2c:	e8 9f 64 00 00       	call   801071d0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 17 68 00 00       	call   80107550 <freevm>
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
80100d5c:	e8 ef 2d 00 00       	call   80103b50 <myproc>

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
80100e0a:	e8 11 66 00 00       	call   80107420 <allocuvm>
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
80100e29:	e8 22 67 00 00       	call   80107550 <freevm>
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
80100e50:	e8 7b 67 00 00       	call   801075d0 <setupkvm>
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
80100eec:	e8 2f 65 00 00       	call   80107420 <allocuvm>
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
80100f22:	e8 39 64 00 00       	call   80107360 <loaduvm>
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
80100f41:	e8 0a 66 00 00       	call   80107550 <freevm>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	e9 66 fe ff ff       	jmp    80100db4 <exec2+0x64>
  }

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100f4e:	e8 fd 1f 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100f53:	83 ec 0c             	sub    $0xc,%esp
80100f56:	68 01 79 10 80       	push   $0x80107901
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
80100f80:	e8 eb 66 00 00       	call   80107670 <clearpteu>
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
80100fb5:	e8 d6 3d 00 00       	call   80104d90 <strlen>
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
80100fc8:	e8 c3 3d 00 00       	call   80104d90 <strlen>
80100fcd:	83 c0 01             	add    $0x1,%eax
80100fd0:	50                   	push   %eax
80100fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fd4:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fd7:	53                   	push   %ebx
80100fd8:	56                   	push   %esi
80100fd9:	e8 02 68 00 00       	call   801077e0 <copyout>
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
80101043:	e8 98 67 00 00       	call   801077e0 <copyout>
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
80101080:	e8 cb 3c 00 00       	call   80104d50 <safestrcpy>

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
801010b4:	e8 17 61 00 00       	call   801071d0 <switchuvm>
  freevm(oldpgdir);
801010b9:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010bf:	89 04 24             	mov    %eax,(%esp)
801010c2:	e8 89 64 00 00       	call   80107550 <freevm>
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
801010f6:	68 0d 79 10 80       	push   $0x8010790d
801010fb:	68 c0 0f 11 80       	push   $0x80110fc0
80101100:	e8 eb 37 00 00       	call   801048f0 <initlock>
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
80101121:	e8 2a 39 00 00       	call   80104a50 <acquire>
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
80101151:	e8 aa 39 00 00       	call   80104b00 <release>
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
80101168:	e8 93 39 00 00       	call   80104b00 <release>
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
8010118f:	e8 bc 38 00 00       	call   80104a50 <acquire>
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
801011ac:	e8 4f 39 00 00       	call   80104b00 <release>
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
801011bb:	68 14 79 10 80       	push   $0x80107914
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
801011e1:	e8 6a 38 00 00       	call   80104a50 <acquire>
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
8010120c:	e9 ef 38 00 00       	jmp    80104b00 <release>
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
80101238:	e8 c3 38 00 00       	call   80104b00 <release>

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
80101292:	68 1c 79 10 80       	push   $0x8010791c
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
80101372:	68 26 79 10 80       	push   $0x80107926
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
80101484:	68 2f 79 10 80       	push   $0x8010792f
80101489:	e8 e2 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010148e:	83 ec 0c             	sub    $0xc,%esp
80101491:	68 35 79 10 80       	push   $0x80107935
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
80101505:	68 3f 79 10 80       	push   $0x8010793f
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
801015b2:	68 52 79 10 80       	push   $0x80107952
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
801015f5:	e8 56 35 00 00       	call   80104b50 <memset>
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
8010163a:	e8 11 34 00 00       	call   80104a50 <acquire>
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
80101682:	e8 79 34 00 00       	call   80104b00 <release>
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
801016cf:	e8 2c 34 00 00       	call   80104b00 <release>

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
801016e4:	68 68 79 10 80       	push   $0x80107968
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
801017aa:	68 78 79 10 80       	push   $0x80107978
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
801017e1:	e8 1a 34 00 00       	call   80104c00 <memmove>
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
8010180c:	68 8b 79 10 80       	push   $0x8010798b
80101811:	68 e0 19 11 80       	push   $0x801119e0
80101816:	e8 d5 30 00 00       	call   801048f0 <initlock>
8010181b:	83 c4 10             	add    $0x10,%esp
8010181e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101820:	83 ec 08             	sub    $0x8,%esp
80101823:	68 92 79 10 80       	push   $0x80107992
80101828:	53                   	push   %ebx
80101829:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010182f:	e8 8c 2f 00 00       	call   801047c0 <initsleeplock>
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
80101879:	68 f8 79 10 80       	push   $0x801079f8
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
8010190e:	e8 3d 32 00 00       	call   80104b50 <memset>
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
80101943:	68 98 79 10 80       	push   $0x80107998
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
801019b1:	e8 4a 32 00 00       	call   80104c00 <memmove>
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
801019df:	e8 6c 30 00 00       	call   80104a50 <acquire>
  ip->ref++;
801019e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019e8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801019ef:	e8 0c 31 00 00       	call   80104b00 <release>
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
80101a22:	e8 d9 2d 00 00       	call   80104800 <acquiresleep>

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
80101a98:	e8 63 31 00 00       	call   80104c00 <memmove>
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
80101abd:	68 b0 79 10 80       	push   $0x801079b0
80101ac2:	e8 a9 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101ac7:	83 ec 0c             	sub    $0xc,%esp
80101aca:	68 aa 79 10 80       	push   $0x801079aa
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
80101af3:	e8 a8 2d 00 00       	call   801048a0 <holdingsleep>
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
80101b0f:	e9 4c 2d 00 00       	jmp    80104860 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	68 bf 79 10 80       	push   $0x801079bf
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
80101b40:	e8 bb 2c 00 00       	call   80104800 <acquiresleep>
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
80101b5a:	e8 01 2d 00 00       	call   80104860 <releasesleep>

  acquire(&icache.lock);
80101b5f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b66:	e8 e5 2e 00 00       	call   80104a50 <acquire>
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
80101b80:	e9 7b 2f 00 00       	jmp    80104b00 <release>
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	68 e0 19 11 80       	push   $0x801119e0
80101b90:	e8 bb 2e 00 00       	call   80104a50 <acquire>
    int r = ip->ref;
80101b95:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101b98:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b9f:	e8 5c 2f 00 00       	call   80104b00 <release>
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
80101d88:	e8 73 2e 00 00       	call   80104c00 <memmove>
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
80101e84:	e8 77 2d 00 00       	call   80104c00 <memmove>
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
80101f1e:	e8 5d 2d 00 00       	call   80104c80 <strncmp>
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
80101f85:	e8 f6 2c 00 00       	call   80104c80 <strncmp>
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
80101fbd:	68 d9 79 10 80       	push   $0x801079d9
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101fc7:	83 ec 0c             	sub    $0xc,%esp
80101fca:	68 c7 79 10 80       	push   $0x801079c7
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
80101ff9:	e8 52 1b 00 00       	call   80103b50 <myproc>
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
80102009:	e8 42 2a 00 00       	call   80104a50 <acquire>
  ip->ref++;
8010200e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102012:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80102019:	e8 e2 2a 00 00       	call   80104b00 <release>
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
80102075:	e8 86 2b 00 00       	call   80104c00 <memmove>
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
80102104:	e8 f7 2a 00 00       	call   80104c00 <memmove>
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
801021ed:	e8 fe 2a 00 00       	call   80104cf0 <strncpy>
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
8010222b:	68 e8 79 10 80       	push   $0x801079e8
80102230:	e8 3b e1 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 5a 80 10 80       	push   $0x8010805a
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
80102340:	68 54 7a 10 80       	push   $0x80107a54
80102345:	e8 26 e0 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010234a:	83 ec 0c             	sub    $0xc,%esp
8010234d:	68 4b 7a 10 80       	push   $0x80107a4b
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
80102366:	68 66 7a 10 80       	push   $0x80107a66
8010236b:	68 80 b5 10 80       	push   $0x8010b580
80102370:	e8 7b 25 00 00       	call   801048f0 <initlock>
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
801023ee:	e8 5d 26 00 00       	call   80104a50 <acquire>

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
8010241e:	e8 ed 21 00 00       	call   80104610 <wakeup>

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
8010243c:	e8 bf 26 00 00       	call   80104b00 <release>
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
8010248e:	e8 0d 24 00 00       	call   801048a0 <holdingsleep>
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
801024c8:	e8 83 25 00 00       	call   80104a50 <acquire>

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
80102519:	e8 32 1f 00 00       	call   80104450 <sleep>
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
80102536:	e9 c5 25 00 00       	jmp    80104b00 <release>

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
8010254e:	68 6a 7a 10 80       	push   $0x80107a6a
80102553:	e8 18 de ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 95 7a 10 80       	push   $0x80107a95
80102560:	e8 0b de ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102565:	83 ec 0c             	sub    $0xc,%esp
80102568:	68 80 7a 10 80       	push   $0x80107a80
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
801025ca:	68 b4 7a 10 80       	push   $0x80107ab4
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
80102682:	81 fb a8 6a 11 80    	cmp    $0x80116aa8,%ebx
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
801026a2:	e8 a9 24 00 00       	call   80104b50 <memset>

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
801026db:	e9 20 24 00 00       	jmp    80104b00 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 40 36 11 80       	push   $0x80113640
801026e8:	e8 63 23 00 00       	call   80104a50 <acquire>
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	eb c2                	jmp    801026b4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801026f2:	83 ec 0c             	sub    $0xc,%esp
801026f5:	68 e6 7a 10 80       	push   $0x80107ae6
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
8010275b:	68 ec 7a 10 80       	push   $0x80107aec
80102760:	68 40 36 11 80       	push   $0x80113640
80102765:	e8 86 21 00 00       	call   801048f0 <initlock>

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
8010284e:	e8 ad 22 00 00       	call   80104b00 <release>
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
80102868:	e8 e3 21 00 00       	call   80104a50 <acquire>
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
801028c6:	0f b6 82 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%eax
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
801028ee:	0f b6 82 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%eax
801028f5:	09 c1                	or     %eax,%ecx
801028f7:	0f b6 82 20 7b 10 80 	movzbl -0x7fef84e0(%edx),%eax
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
8010290e:	8b 04 85 00 7b 10 80 	mov    -0x7fef8500(,%eax,4),%eax
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
80102c74:	e8 27 1f 00 00       	call   80104ba0 <memcmp>
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
80102da4:	e8 57 1e 00 00       	call   80104c00 <memmove>
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
80102e4a:	68 20 7d 10 80       	push   $0x80107d20
80102e4f:	68 80 36 11 80       	push   $0x80113680
80102e54:	e8 97 1a 00 00       	call   801048f0 <initlock>
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
80102eeb:	e8 60 1b 00 00       	call   80104a50 <acquire>
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	eb 18                	jmp    80102f0d <begin_op+0x2d>
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 80 36 11 80       	push   $0x80113680
80102f00:	68 80 36 11 80       	push   $0x80113680
80102f05:	e8 46 15 00 00       	call   80104450 <sleep>
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
80102f3c:	e8 bf 1b 00 00       	call   80104b00 <release>
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
80102f5e:	e8 ed 1a 00 00       	call   80104a50 <acquire>
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
80102f9d:	e8 5e 1b 00 00       	call   80104b00 <release>
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
80102ffc:	e8 ff 1b 00 00       	call   80104c00 <memmove>
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
80103045:	e8 06 1a 00 00       	call   80104a50 <acquire>
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
8010305b:	e8 b0 15 00 00       	call   80104610 <wakeup>
    release(&log.lock);
80103060:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103067:	e8 94 1a 00 00       	call   80104b00 <release>
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
80103088:	e8 83 15 00 00       	call   80104610 <wakeup>
  }
  release(&log.lock);
8010308d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103094:	e8 67 1a 00 00       	call   80104b00 <release>
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
801030a7:	68 24 7d 10 80       	push   $0x80107d24
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
801030fe:	e8 4d 19 00 00       	call   80104a50 <acquire>
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
8010314e:	e9 ad 19 00 00       	jmp    80104b00 <release>
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
80103173:	68 33 7d 10 80       	push   $0x80107d33
80103178:	e8 f3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010317d:	83 ec 0c             	sub    $0xc,%esp
80103180:	68 49 7d 10 80       	push   $0x80107d49
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
80103197:	e8 94 09 00 00       	call   80103b30 <cpuid>
8010319c:	89 c3                	mov    %eax,%ebx
8010319e:	e8 8d 09 00 00       	call   80103b30 <cpuid>
801031a3:	83 ec 04             	sub    $0x4,%esp
801031a6:	53                   	push   %ebx
801031a7:	50                   	push   %eax
801031a8:	68 64 7d 10 80       	push   $0x80107d64
801031ad:	e8 ae d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031b2:	e8 b9 2e 00 00       	call   80106070 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031b7:	e8 f4 08 00 00       	call   80103ab0 <mycpu>
801031bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031be:	b8 01 00 00 00       	mov    $0x1,%eax
801031c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ca:	e8 b1 0c 00 00       	call   80103e80 <scheduler>
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
801031d6:	e8 d5 3f 00 00       	call   801071b0 <switchkvm>
  seginit();
801031db:	e8 d0 3e 00 00       	call   801070b0 <seginit>
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
8010320c:	68 a8 6a 11 80       	push   $0x80116aa8
80103211:	e8 3a f5 ff ff       	call   80102750 <kinit1>
  kvmalloc();      // kernel page table
80103216:	e8 35 44 00 00       	call   80107650 <kvmalloc>
  mpinit();        // detect other processors
8010321b:	e8 70 01 00 00       	call   80103390 <mpinit>
  lapicinit();     // interrupt controller
80103220:	e8 5b f7 ff ff       	call   80102980 <lapicinit>
  seginit();       // segment descriptors
80103225:	e8 86 3e 00 00       	call   801070b0 <seginit>
  picinit();       // disable pic
8010322a:	e8 31 03 00 00       	call   80103560 <picinit>
  ioapicinit();    // another interrupt controller
8010322f:	e8 4c f3 ff ff       	call   80102580 <ioapicinit>
  consoleinit();   // console hardware
80103234:	e8 67 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103239:	e8 42 31 00 00       	call   80106380 <uartinit>
  pinit();         // process table
8010323e:	e8 4d 08 00 00       	call   80103a90 <pinit>
  tvinit();        // trap vectors
80103243:	e8 88 2d 00 00       	call   80105fd0 <tvinit>
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
80103269:	e8 92 19 00 00       	call   80104c00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010326e:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103275:	00 00 00 
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	05 80 37 11 80       	add    $0x80113780,%eax
80103280:	39 d8                	cmp    %ebx,%eax
80103282:	76 6f                	jbe    801032f3 <main+0x103>
80103284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103288:	e8 23 08 00 00       	call   80103ab0 <mycpu>
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
80103305:	e8 76 08 00 00       	call   80103b80 <userinit>
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
80103338:	68 78 7d 10 80       	push   $0x80107d78
8010333d:	56                   	push   %esi
8010333e:	e8 5d 18 00 00       	call   80104ba0 <memcmp>
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
801033fc:	68 7d 7d 10 80       	push   $0x80107d7d
80103401:	56                   	push   %esi
80103402:	e8 99 17 00 00       	call   80104ba0 <memcmp>
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
80103490:	ff 24 95 bc 7d 10 80 	jmp    *-0x7fef8244(,%edx,4)
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
80103537:	68 82 7d 10 80       	push   $0x80107d82
8010353c:	e8 2f ce ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103541:	83 ec 0c             	sub    $0xc,%esp
80103544:	68 9c 7d 10 80       	push   $0x80107d9c
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
801035f3:	68 d0 7d 10 80       	push   $0x80107dd0
801035f8:	50                   	push   %eax
801035f9:	e8 f2 12 00 00       	call   801048f0 <initlock>
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
8010368f:	e8 bc 13 00 00       	call   80104a50 <acquire>
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
801036af:	e8 5c 0f 00 00       	call   80104610 <wakeup>
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
801036d4:	e9 27 14 00 00       	jmp    80104b00 <release>
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
801036f4:	e8 17 0f 00 00       	call   80104610 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb b9                	jmp    801036b7 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 f7 13 00 00       	call   80104b00 <release>
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
8010372d:	e8 1e 13 00 00       	call   80104a50 <acquire>
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
80103770:	e8 db 03 00 00       	call   80103b50 <myproc>
80103775:	8b 48 24             	mov    0x24(%eax),%ecx
80103778:	85 c9                	test   %ecx,%ecx
8010377a:	75 34                	jne    801037b0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	57                   	push   %edi
80103780:	e8 8b 0e 00 00       	call   80104610 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103785:	58                   	pop    %eax
80103786:	5a                   	pop    %edx
80103787:	53                   	push   %ebx
80103788:	56                   	push   %esi
80103789:	e8 c2 0c 00 00       	call   80104450 <sleep>
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
801037b4:	e8 47 13 00 00       	call   80104b00 <release>
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
80103803:	e8 08 0e 00 00       	call   80104610 <wakeup>
  release(&p->lock);
80103808:	89 1c 24             	mov    %ebx,(%esp)
8010380b:	e8 f0 12 00 00       	call   80104b00 <release>
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
80103830:	e8 1b 12 00 00       	call   80104a50 <acquire>
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
80103865:	e8 e6 0b 00 00       	call   80104450 <sleep>
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
80103889:	e8 c2 02 00 00       	call   80103b50 <myproc>
8010388e:	8b 48 24             	mov    0x24(%eax),%ecx
80103891:	85 c9                	test   %ecx,%ecx
80103893:	74 cb                	je     80103860 <piperead+0x40>
      release(&p->lock);
80103895:	83 ec 0c             	sub    $0xc,%esp
80103898:	53                   	push   %ebx
80103899:	e8 62 12 00 00       	call   80104b00 <release>
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
801038fe:	e8 0d 0d 00 00       	call   80104610 <wakeup>
  release(&p->lock);
80103903:	89 1c 24             	mov    %ebx,(%esp)
80103906:	e8 f5 11 00 00       	call   80104b00 <release>
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
80103951:	e8 fa 10 00 00       	call   80104a50 <acquire>
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	eb 17                	jmp    80103972 <allocproc+0x32>
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103960:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103966:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
8010396c:	0f 84 ae 00 00 00    	je     80103a20 <allocproc+0xe0>
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
  p->limit_sz = -1;
  //시작시간 
  p->tick = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
8010397e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103981:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->limit_sz = -1;
  //시작시간 
  p->tick = 0;
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
  p->limit_sz = -1;
801039b8:	c7 83 8c 00 00 00 ff 	movl   $0xffffffff,0x8c(%ebx)
801039bf:	ff ff ff 
  //시작시간 
  p->tick = 0;
801039c2:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801039c9:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039cc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->limit_sz = -1;
  //시작시간 
  p->tick = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
801039d2:	e8 29 11 00 00       	call   80104b00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039d7:	e8 44 ee ff ff       	call   80102820 <kalloc>
801039dc:	83 c4 10             	add    $0x10,%esp
801039df:	85 c0                	test   %eax,%eax
801039e1:	89 43 08             	mov    %eax,0x8(%ebx)
801039e4:	74 51                	je     80103a37 <allocproc+0xf7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ec:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801039ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039f4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801039f7:	c7 40 14 c1 5f 10 80 	movl   $0x80105fc1,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039fe:	6a 14                	push   $0x14
80103a00:	6a 00                	push   $0x0
80103a02:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103a03:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a06:	e8 45 11 00 00       	call   80104b50 <memset>
  p->context->eip = (uint)forkret;
80103a0b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a0e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103a11:	c7 40 10 40 3a 10 80 	movl   $0x80103a40,0x10(%eax)

  return p;
80103a18:	89 d8                	mov    %ebx,%eax
}
80103a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1d:	c9                   	leave  
80103a1e:	c3                   	ret    
80103a1f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103a20:	83 ec 0c             	sub    $0xc,%esp
80103a23:	68 20 3d 11 80       	push   $0x80113d20
80103a28:	e8 d3 10 00 00       	call   80104b00 <release>
  return 0;
80103a2d:	83 c4 10             	add    $0x10,%esp
80103a30:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a35:	c9                   	leave  
80103a36:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103a37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a3e:	eb da                	jmp    80103a1a <allocproc+0xda>

80103a40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a46:	68 20 3d 11 80       	push   $0x80113d20
80103a4b:	e8 b0 10 00 00       	call   80104b00 <release>

  if (first) {
80103a50:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	75 04                	jne    80103a60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a5c:	c9                   	leave  
80103a5d:	c3                   	ret    
80103a5e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103a60:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103a63:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a6a:	00 00 00 
    iinit(ROOTDEV);
80103a6d:	6a 01                	push   $0x1
80103a6f:	e8 8c dd ff ff       	call   80101800 <iinit>
    initlog(ROOTDEV);
80103a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a7b:	e8 c0 f3 ff ff       	call   80102e40 <initlog>
80103a80:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a83:	c9                   	leave  
80103a84:	c3                   	ret    
80103a85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a90 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a96:	68 d5 7d 10 80       	push   $0x80107dd5
80103a9b:	68 20 3d 11 80       	push   $0x80113d20
80103aa0:	e8 4b 0e 00 00       	call   801048f0 <initlock>
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	c9                   	leave  
80103aa9:	c3                   	ret    
80103aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ab0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab5:	9c                   	pushf  
80103ab6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103ab7:	f6 c4 02             	test   $0x2,%ah
80103aba:	75 5b                	jne    80103b17 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103abc:	e8 bf ef ff ff       	call   80102a80 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ac1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103ac7:	85 f6                	test   %esi,%esi
80103ac9:	7e 3f                	jle    80103b0a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103acb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103ad2:	39 d0                	cmp    %edx,%eax
80103ad4:	74 30                	je     80103b06 <mycpu+0x56>
80103ad6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103adb:	31 d2                	xor    %edx,%edx
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ae0:	83 c2 01             	add    $0x1,%edx
80103ae3:	39 f2                	cmp    %esi,%edx
80103ae5:	74 23                	je     80103b0a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103ae7:	0f b6 19             	movzbl (%ecx),%ebx
80103aea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103af0:	39 d8                	cmp    %ebx,%eax
80103af2:	75 ec                	jne    80103ae0 <mycpu+0x30>
      return &cpus[i];
80103af4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103afd:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103afe:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103b03:	5e                   	pop    %esi
80103b04:	5d                   	pop    %ebp
80103b05:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b06:	31 d2                	xor    %edx,%edx
80103b08:	eb ea                	jmp    80103af4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103b0a:	83 ec 0c             	sub    $0xc,%esp
80103b0d:	68 dc 7d 10 80       	push   $0x80107ddc
80103b12:	e8 59 c8 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b17:	83 ec 0c             	sub    $0xc,%esp
80103b1a:	68 e4 7e 10 80       	push   $0x80107ee4
80103b1f:	e8 4c c8 ff ff       	call   80100370 <panic>
80103b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b30 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b36:	e8 75 ff ff ff       	call   80103ab0 <mycpu>
80103b3b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103b40:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103b41:	c1 f8 04             	sar    $0x4,%eax
80103b44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b4a:	c3                   	ret    
80103b4b:	90                   	nop
80103b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b50 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b57:	e8 14 0e 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103b5c:	e8 4f ff ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103b61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b67:	e8 44 0e 00 00       	call   801049b0 <popcli>
  return p;
}
80103b6c:	83 c4 04             	add    $0x4,%esp
80103b6f:	89 d8                	mov    %ebx,%eax
80103b71:	5b                   	pop    %ebx
80103b72:	5d                   	pop    %ebp
80103b73:	c3                   	ret    
80103b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b80 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b87:	e8 b4 fd ff ff       	call   80103940 <allocproc>
80103b8c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103b8e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103b93:	e8 38 3a 00 00       	call   801075d0 <setupkvm>
80103b98:	85 c0                	test   %eax,%eax
80103b9a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b9d:	0f 84 bd 00 00 00    	je     80103c60 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	68 2c 00 00 00       	push   $0x2c
80103bab:	68 60 b4 10 80       	push   $0x8010b460
80103bb0:	50                   	push   %eax
80103bb1:	e8 2a 37 00 00       	call   801072e0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103bb6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103bb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bbf:	6a 4c                	push   $0x4c
80103bc1:	6a 00                	push   $0x0
80103bc3:	ff 73 18             	pushl  0x18(%ebx)
80103bc6:	e8 85 0f 00 00       	call   80104b50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bcb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bd3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bd8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bdf:	8b 43 18             	mov    0x18(%ebx),%eax
80103be2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bf1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bf8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bfc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c06:	8b 43 18             	mov    0x18(%ebx),%eax
80103c09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c10:	8b 43 18             	mov    0x18(%ebx),%eax
80103c13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	68 05 7e 10 80       	push   $0x80107e05
80103c24:	50                   	push   %eax
80103c25:	e8 26 11 00 00       	call   80104d50 <safestrcpy>
  p->cwd = namei("/");
80103c2a:	c7 04 24 0e 7e 10 80 	movl   $0x80107e0e,(%esp)
80103c31:	e8 1a e6 ff ff       	call   80102250 <namei>
80103c36:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c39:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c40:	e8 0b 0e 00 00       	call   80104a50 <acquire>

  p->state = RUNNABLE;
80103c45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103c4c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c53:	e8 a8 0e 00 00       	call   80104b00 <release>
}
80103c58:	83 c4 10             	add    $0x10,%esp
80103c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c5e:	c9                   	leave  
80103c5f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	68 ec 7d 10 80       	push   $0x80107dec
80103c68:	e8 03 c7 ff ff       	call   80100370 <panic>
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi

80103c70 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	56                   	push   %esi
80103c74:	53                   	push   %ebx
80103c75:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c78:	e8 f3 0c 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103c7d:	e8 2e fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c88:	e8 23 0d 00 00       	call   801049b0 <popcli>
  struct proc *curproc = myproc();

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz != -1 && n+sz >curproc->limit_sz ){
80103c8d:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103c93:	8b 03                	mov    (%ebx),%eax

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz != -1 && n+sz >curproc->limit_sz ){
80103c95:	83 fa ff             	cmp    $0xffffffff,%edx
80103c98:	74 07                	je     80103ca1 <growproc+0x31>
80103c9a:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80103c9d:	39 d1                	cmp    %edx,%ecx
80103c9f:	77 4f                	ja     80103cf0 <growproc+0x80>
    return -1;
  }
  if(n > 0){
80103ca1:	83 fe 00             	cmp    $0x0,%esi
80103ca4:	7e 32                	jle    80103cd8 <growproc+0x68>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca6:	83 ec 04             	sub    $0x4,%esp
80103ca9:	01 c6                	add    %eax,%esi
80103cab:	56                   	push   %esi
80103cac:	50                   	push   %eax
80103cad:	ff 73 04             	pushl  0x4(%ebx)
80103cb0:	e8 6b 37 00 00       	call   80107420 <allocuvm>
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	85 c0                	test   %eax,%eax
80103cba:	74 34                	je     80103cf0 <growproc+0x80>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103cbc:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103cbf:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cc1:	53                   	push   %ebx
80103cc2:	e8 09 35 00 00       	call   801071d0 <switchuvm>
  return 0;
80103cc7:	83 c4 10             	add    $0x10,%esp
80103cca:	31 c0                	xor    %eax,%eax
}
80103ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ccf:	5b                   	pop    %ebx
80103cd0:	5e                   	pop    %esi
80103cd1:	5d                   	pop    %ebp
80103cd2:	c3                   	ret    
80103cd3:	90                   	nop
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  }
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103cd8:	74 e2                	je     80103cbc <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cda:	83 ec 04             	sub    $0x4,%esp
80103cdd:	01 c6                	add    %eax,%esi
80103cdf:	56                   	push   %esi
80103ce0:	50                   	push   %eax
80103ce1:	ff 73 04             	pushl  0x4(%ebx)
80103ce4:	e8 37 38 00 00       	call   80107520 <deallocuvm>
80103ce9:	83 c4 10             	add    $0x10,%esp
80103cec:	85 c0                	test   %eax,%eax
80103cee:	75 cc                	jne    80103cbc <growproc+0x4c>

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz != -1 && n+sz >curproc->limit_sz ){
    return -1;
80103cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cf5:	eb d5                	jmp    80103ccc <growproc+0x5c>
80103cf7:	89 f6                	mov    %esi,%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d09:	e8 62 0c 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103d0e:	e8 9d fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103d13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d19:	e8 92 0c 00 00       	call   801049b0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103d1e:	e8 1d fc ff ff       	call   80103940 <allocproc>
80103d23:	85 c0                	test   %eax,%eax
80103d25:	89 c7                	mov    %eax,%edi
80103d27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d2a:	0f 84 b5 00 00 00    	je     80103de5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d30:	83 ec 08             	sub    $0x8,%esp
80103d33:	ff 33                	pushl  (%ebx)
80103d35:	ff 73 04             	pushl  0x4(%ebx)
80103d38:	e8 63 39 00 00       	call   801076a0 <copyuvm>
80103d3d:	83 c4 10             	add    $0x10,%esp
80103d40:	85 c0                	test   %eax,%eax
80103d42:	89 47 04             	mov    %eax,0x4(%edi)
80103d45:	0f 84 a1 00 00 00    	je     80103dec <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103d4b:	8b 03                	mov    (%ebx),%eax
80103d4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d50:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d52:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d55:	89 c8                	mov    %ecx,%eax
80103d57:	8b 79 18             	mov    0x18(%ecx),%edi
80103d5a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d5d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103d64:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103d66:	8b 40 18             	mov    0x18(%eax),%eax
80103d69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103d70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d74:	85 c0                	test   %eax,%eax
80103d76:	74 13                	je     80103d8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d78:	83 ec 0c             	sub    $0xc,%esp
80103d7b:	50                   	push   %eax
80103d7c:	e8 ff d3 ff ff       	call   80101180 <filedup>
80103d81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d84:	83 c4 10             	add    $0x10,%esp
80103d87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103d8b:	83 c6 01             	add    $0x1,%esi
80103d8e:	83 fe 10             	cmp    $0x10,%esi
80103d91:	75 dd                	jne    80103d70 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103d93:	83 ec 0c             	sub    $0xc,%esp
80103d96:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d99:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103d9c:	e8 2f dc ff ff       	call   801019d0 <idup>
80103da1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103da4:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103da7:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103daa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dad:	6a 10                	push   $0x10
80103daf:	53                   	push   %ebx
80103db0:	50                   	push   %eax
80103db1:	e8 9a 0f 00 00       	call   80104d50 <safestrcpy>

  pid = np->pid;
80103db6:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103db9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dc0:	e8 8b 0c 00 00       	call   80104a50 <acquire>

  np->state = RUNNABLE;
80103dc5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103dcc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dd3:	e8 28 0d 00 00       	call   80104b00 <release>

  return pid;
80103dd8:	83 c4 10             	add    $0x10,%esp
80103ddb:	89 d8                	mov    %ebx,%eax
}
80103ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de0:	5b                   	pop    %ebx
80103de1:	5e                   	pop    %esi
80103de2:	5f                   	pop    %edi
80103de3:	5d                   	pop    %ebp
80103de4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103de5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dea:	eb f1                	jmp    80103ddd <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103dec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103def:	83 ec 0c             	sub    $0xc,%esp
80103df2:	ff 77 08             	pushl  0x8(%edi)
80103df5:	e8 76 e8 ff ff       	call   80102670 <kfree>
    np->kstack = 0;
80103dfa:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103e01:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103e08:	83 c4 10             	add    $0x10,%esp
80103e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e10:	eb cb                	jmp    80103ddd <fork+0xdd>
80103e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <priority_boosting>:
//      via swtch back to the scheduler.


void 
priority_boosting(void)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103e26:	68 20 3d 11 80       	push   $0x80113d20
80103e2b:	e8 20 0c 00 00       	call   80104a50 <acquire>
80103e30:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e33:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e38:	90                   	nop
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103e40:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103e47:	00 00 00 
        p->tickleft=4;
80103e4a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103e51:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e54:	05 94 00 00 00       	add    $0x94,%eax
80103e59:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80103e5e:	75 e0                	jne    80103e40 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	68 20 3d 11 80       	push   $0x80113d20
80103e68:	e8 93 0c 00 00       	call   80104b00 <release>
}
80103e6d:	83 c4 10             	add    $0x10,%esp
80103e70:	c9                   	leave  
80103e71:	c3                   	ret    
80103e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <scheduler>:
*/


void
scheduler(void)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103e89:	e8 22 fc ff ff       	call   80103ab0 <mycpu>
80103e8e:	8d 78 04             	lea    0x4(%eax),%edi
80103e91:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e93:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e9a:	00 00 00 
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ea0:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ea1:	83 ec 0c             	sub    $0xc,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ea9:	68 20 3d 11 80       	push   $0x80113d20
80103eae:	e8 9d 0b 00 00       	call   80104a50 <acquire>
80103eb3:	83 c4 10             	add    $0x10,%esp
80103eb6:	eb 16                	jmp    80103ece <scheduler+0x4e>
80103eb8:	90                   	nop
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103ec6:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
80103ecc:	74 52                	je     80103f20 <scheduler+0xa0>
      if(p->state != RUNNABLE) continue;
80103ece:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ed2:	75 ec                	jne    80103ec0 <scheduler+0x40>
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE) continue;
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103ed7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103edd:	53                   	push   %ebx
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ede:	81 c3 94 00 00 00    	add    $0x94,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ee4:	e8 e7 32 00 00       	call   801071d0 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103ee9:	58                   	pop    %eax
80103eea:	5a                   	pop    %edx
80103eeb:	ff 73 88             	pushl  -0x78(%ebx)
80103eee:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103eef:	c7 83 78 ff ff ff 04 	movl   $0x4,-0x88(%ebx)
80103ef6:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103ef9:	e8 ad 0e 00 00       	call   80104dab <swtch>
      switchkvm();
80103efe:	e8 ad 32 00 00       	call   801071b0 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f03:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f0c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f13:	00 00 00 
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	75 b6                	jne    80103ece <scheduler+0x4e>
80103f18:	90                   	nop
80103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	68 20 3d 11 80       	push   $0x80113d20
80103f28:	e8 d3 0b 00 00       	call   80104b00 <release>
    #endif
  }
80103f2d:	83 c4 10             	add    $0x10,%esp
80103f30:	e9 6b ff ff ff       	jmp    80103ea0 <scheduler+0x20>
80103f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f40 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f45:	e8 26 0a 00 00       	call   80104970 <pushcli>
  c = mycpu();
80103f4a:	e8 61 fb ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103f4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f55:	e8 56 0a 00 00       	call   801049b0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 3d 11 80       	push   $0x80113d20
80103f62:	e8 b9 0a 00 00       	call   80104a20 <holding>
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	74 4f                	je     80103fbd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103f6e:	e8 3d fb ff ff       	call   80103ab0 <mycpu>
80103f73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f7a:	75 68                	jne    80103fe4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103f7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f80:	74 55                	je     80103fd7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f82:	9c                   	pushf  
80103f83:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103f84:	f6 c4 02             	test   $0x2,%ah
80103f87:	75 41                	jne    80103fca <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f89:	e8 22 fb ff ff       	call   80103ab0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f8e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f97:	e8 14 fb ff ff       	call   80103ab0 <mycpu>
80103f9c:	83 ec 08             	sub    $0x8,%esp
80103f9f:	ff 70 04             	pushl  0x4(%eax)
80103fa2:	53                   	push   %ebx
80103fa3:	e8 03 0e 00 00       	call   80104dab <swtch>
  mycpu()->intena = intena;
80103fa8:	e8 03 fb ff ff       	call   80103ab0 <mycpu>
}
80103fad:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103fb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
80103fbc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103fbd:	83 ec 0c             	sub    $0xc,%esp
80103fc0:	68 10 7e 10 80       	push   $0x80107e10
80103fc5:	e8 a6 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 3c 7e 10 80       	push   $0x80107e3c
80103fd2:	e8 99 c3 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 2e 7e 10 80       	push   $0x80107e2e
80103fdf:	e8 8c c3 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 22 7e 10 80       	push   $0x80107e22
80103fec:	e8 7f c3 ff ff       	call   80100370 <panic>
80103ff1:	eb 0d                	jmp    80104000 <exit>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104009:	e8 62 09 00 00       	call   80104970 <pushcli>
  c = mycpu();
8010400e:	e8 9d fa ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104019:	e8 92 09 00 00       	call   801049b0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010401e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104024:	8d 5e 28             	lea    0x28(%esi),%ebx
80104027:	8d 7e 68             	lea    0x68(%esi),%edi
8010402a:	0f 84 f1 00 00 00    	je     80104121 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104030:	8b 03                	mov    (%ebx),%eax
80104032:	85 c0                	test   %eax,%eax
80104034:	74 12                	je     80104048 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	50                   	push   %eax
8010403a:	e8 91 d1 ff ff       	call   801011d0 <fileclose>
      curproc->ofile[fd] = 0;
8010403f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010404b:	39 df                	cmp    %ebx,%edi
8010404d:	75 e1                	jne    80104030 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010404f:	e8 8c ee ff ff       	call   80102ee0 <begin_op>
  iput(curproc->cwd);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	ff 76 68             	pushl  0x68(%esi)
8010405a:	e8 d1 da ff ff       	call   80101b30 <iput>
  end_op();
8010405f:	e8 ec ee ff ff       	call   80102f50 <end_op>
  curproc->cwd = 0;
80104064:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010406b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104072:	e8 d9 09 00 00       	call   80104a50 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104077:	8b 56 14             	mov    0x14(%esi),%edx
8010407a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104082:	eb 10                	jmp    80104094 <exit+0x94>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104088:	05 94 00 00 00       	add    $0x94,%eax
8010408d:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80104092:	74 1e                	je     801040b2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104094:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104098:	75 ee                	jne    80104088 <exit+0x88>
8010409a:	3b 50 20             	cmp    0x20(%eax),%edx
8010409d:	75 e9                	jne    80104088 <exit+0x88>
      p->state = RUNNABLE;
8010409f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a6:	05 94 00 00 00       	add    $0x94,%eax
801040ab:	3d 54 62 11 80       	cmp    $0x80116254,%eax
801040b0:	75 e2                	jne    80104094 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801040b2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801040b8:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
801040bd:	eb 0f                	jmp    801040ce <exit+0xce>
801040bf:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c0:	81 c2 94 00 00 00    	add    $0x94,%edx
801040c6:	81 fa 54 62 11 80    	cmp    $0x80116254,%edx
801040cc:	74 3a                	je     80104108 <exit+0x108>
    if(p->parent == curproc){
801040ce:	39 72 14             	cmp    %esi,0x14(%edx)
801040d1:	75 ed                	jne    801040c0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801040d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801040d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040da:	75 e4                	jne    801040c0 <exit+0xc0>
801040dc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801040e1:	eb 11                	jmp    801040f4 <exit+0xf4>
801040e3:	90                   	nop
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e8:	05 94 00 00 00       	add    $0x94,%eax
801040ed:	3d 54 62 11 80       	cmp    $0x80116254,%eax
801040f2:	74 cc                	je     801040c0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801040f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040f8:	75 ee                	jne    801040e8 <exit+0xe8>
801040fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801040fd:	75 e9                	jne    801040e8 <exit+0xe8>
      p->state = RUNNABLE;
801040ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104106:	eb e0                	jmp    801040e8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104108:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010410f:	e8 2c fe ff ff       	call   80103f40 <sched>
  panic("zombie exit");
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	68 5d 7e 10 80       	push   $0x80107e5d
8010411c:	e8 4f c2 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104121:	83 ec 0c             	sub    $0xc,%esp
80104124:	68 50 7e 10 80       	push   $0x80107e50
80104129:	e8 42 c2 ff ff       	call   80100370 <panic>
8010412e:	66 90                	xchg   %ax,%ax

80104130 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 20 3d 11 80       	push   $0x80113d20
8010413c:	e8 0f 09 00 00       	call   80104a50 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104141:	e8 2a 08 00 00       	call   80104970 <pushcli>
  c = mycpu();
80104146:	e8 65 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 5a 08 00 00       	call   801049b0 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 de fd ff ff       	call   80103f40 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104169:	e8 92 09 00 00       	call   80104b00 <release>
}
8010416e:	83 c4 10             	add    $0x10,%esp
80104171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104174:	c9                   	leave  
80104175:	c3                   	ret    
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <getlev>:

int             
getlev(void)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104187:	e8 e4 07 00 00       	call   80104970 <pushcli>
  c = mycpu();
8010418c:	e8 1f f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104191:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104197:	e8 14 08 00 00       	call   801049b0 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
8010419c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
801041a2:	83 c4 04             	add    $0x4,%esp
801041a5:	5b                   	pop    %ebx
801041a6:	5d                   	pop    %ebp
801041a7:	c3                   	ret    
801041a8:	90                   	nop
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041b0 <getadmin>:

int
getadmin(char *password)
{
801041b0:	55                   	push   %ebp
  char my_number[10] = "2016025823";
801041b1:	b8 32 33 00 00       	mov    $0x3332,%eax
  int flag = 0;
801041b6:	31 d2                	xor    %edx,%edx
  return myproc()->queuelevel;
}

int
getadmin(char *password)
{
801041b8:	89 e5                	mov    %esp,%ebp
801041ba:	53                   	push   %ebx
801041bb:	83 ec 14             	sub    $0x14,%esp
801041be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char my_number[10] = "2016025823";
801041c1:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
801041c5:	c7 45 ee 32 30 31 36 	movl   $0x36313032,-0x12(%ebp)
801041cc:	c7 45 f2 30 32 35 38 	movl   $0x38353230,-0xe(%ebp)
  int flag = 0;
  for(int i=0;i<10;i++){
801041d3:	31 c0                	xor    %eax,%eax
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
    if(my_number[i] == password[i]) flag++;
801041d8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801041dc:	38 4c 05 ee          	cmp    %cl,-0x12(%ebp,%eax,1)
801041e0:	0f 94 c1             	sete   %cl
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801041e3:	83 c0 01             	add    $0x1,%eax
    if(my_number[i] == password[i]) flag++;
801041e6:	0f b6 c9             	movzbl %cl,%ecx
801041e9:	01 ca                	add    %ecx,%edx
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801041eb:	83 f8 0a             	cmp    $0xa,%eax
801041ee:	75 e8                	jne    801041d8 <getadmin+0x28>
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
801041f0:	83 fa 0a             	cmp    $0xa,%edx
801041f3:	75 2b                	jne    80104220 <getadmin+0x70>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041f5:	e8 76 07 00 00       	call   80104970 <pushcli>
  c = mycpu();
801041fa:	e8 b1 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801041ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104205:	e8 a6 07 00 00       	call   801049b0 <popcli>
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
8010420a:	31 c0                	xor    %eax,%eax
  int flag = 0;
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
8010420c:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
80104213:	00 00 00 
    return 0;
  }
  else{
    return -1;
  }
}
80104216:	83 c4 14             	add    $0x14,%esp
80104219:	5b                   	pop    %ebx
8010421a:	5d                   	pop    %ebp
8010421b:	c3                   	ret    
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104220:	83 c4 14             	add    $0x14,%esp
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
  }
  else{
    return -1;
80104223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80104228:	5b                   	pop    %ebx
80104229:	5d                   	pop    %ebp
8010422a:	c3                   	ret    
8010422b:	90                   	nop
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104230 <setmemorylimit>:

int 
setmemorylimit(int pid, int limit)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	8b 7d 08             	mov    0x8(%ebp),%edi
8010423c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010423f:	e8 2c 07 00 00       	call   80104970 <pushcli>
  c = mycpu();
80104244:	e8 67 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104249:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010424f:	e8 5c 07 00 00       	call   801049b0 <popcli>

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
80104254:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010425a:	85 c0                	test   %eax,%eax
8010425c:	74 5c                	je     801042ba <setmemorylimit+0x8a>
8010425e:	89 f0                	mov    %esi,%eax
80104260:	c1 e8 1f             	shr    $0x1f,%eax
80104263:	84 c0                	test   %al,%al
80104265:	75 53                	jne    801042ba <setmemorylimit+0x8a>
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
80104267:	83 ec 0c             	sub    $0xc,%esp
int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
8010426a:	31 db                	xor    %ebx,%ebx
  struct proc *p;
  acquire(&ptable.lock);
8010426c:	68 20 3d 11 80       	push   $0x80113d20
80104271:	e8 da 07 00 00       	call   80104a50 <acquire>
80104276:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104279:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010427e:	66 90                	xchg   %ax,%ax
    if(p->pid == pid) target = p;
80104280:	39 78 10             	cmp    %edi,0x10(%eax)
80104283:	0f 44 d8             	cmove  %eax,%ebx
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104286:	05 94 00 00 00       	add    $0x94,%eax
8010428b:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80104290:	75 ee                	jne    80104280 <setmemorylimit+0x50>
    if(p->pid == pid) target = p;
  }
	release(&ptable.lock);
80104292:	83 ec 0c             	sub    $0xc,%esp
80104295:	68 20 3d 11 80       	push   $0x80113d20
8010429a:	e8 61 08 00 00       	call   80104b00 <release>
  //해당 pid가 없을 때
  if(target==0) return -1;
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	85 db                	test   %ebx,%ebx
801042a4:	74 14                	je     801042ba <setmemorylimit+0x8a>

  //기존 사이즈보다 더 작은 Limit을 주려고 할때

  if(target->sz > limit) return -1;
801042a6:	39 33                	cmp    %esi,(%ebx)
801042a8:	77 10                	ja     801042ba <setmemorylimit+0x8a>
  target->limit_sz = limit;
801042aa:	89 b3 8c 00 00 00    	mov    %esi,0x8c(%ebx)
  return 0;
801042b0:	31 c0                	xor    %eax,%eax
}
801042b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b5:	5b                   	pop    %ebx
801042b6:	5e                   	pop    %esi
801042b7:	5f                   	pop    %edi
801042b8:	5d                   	pop    %ebp
801042b9:	c3                   	ret    

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
801042ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042bf:	eb f1                	jmp    801042b2 <setmemorylimit+0x82>
801042c1:	eb 0d                	jmp    801042d0 <list>
801042c3:	90                   	nop
801042c4:	90                   	nop
801042c5:	90                   	nop
801042c6:	90                   	nop
801042c7:	90                   	nop
801042c8:	90                   	nop
801042c9:	90                   	nop
801042ca:	90                   	nop
801042cb:	90                   	nop
801042cc:	90                   	nop
801042cd:	90                   	nop
801042ce:	90                   	nop
801042cf:	90                   	nop

801042d0 <list>:
}


int
list()
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801042d9:	83 ec 10             	sub    $0x10,%esp
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
801042dc:	68 0c 7f 10 80       	push   $0x80107f0c
801042e1:	e8 7a c3 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  acquire(&ptable.lock);
801042e6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042ed:	e8 5e 07 00 00       	call   80104a50 <acquire>
801042f2:	83 c4 10             	add    $0x10,%esp
801042f5:	eb 17                	jmp    8010430e <list+0x3e>
801042f7:	89 f6                	mov    %esi,%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104300:	81 c3 94 00 00 00    	add    $0x94,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104306:	81 fb c0 62 11 80    	cmp    $0x801162c0,%ebx
8010430c:	74 43                	je     80104351 <list+0x81>
   if(p->pid != 0){
8010430e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104311:	85 c0                	test   %eax,%eax
80104313:	74 eb                	je     80104300 <list+0x30>
	   if(strlen(p->name)>4) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,p->tick,p->sz,p->limit_sz);
80104315:	83 ec 0c             	sub    $0xc,%esp
80104318:	53                   	push   %ebx
80104319:	e8 72 0a 00 00       	call   80104d90 <strlen>
8010431e:	83 c4 10             	add    $0x10,%esp
80104321:	83 f8 04             	cmp    $0x4,%eax
80104324:	7e 42                	jle    80104368 <list+0x98>
80104326:	83 ec 08             	sub    $0x8,%esp
80104329:	ff 73 20             	pushl  0x20(%ebx)
8010432c:	ff 73 94             	pushl  -0x6c(%ebx)
8010432f:	ff 73 24             	pushl  0x24(%ebx)
80104332:	ff 73 a4             	pushl  -0x5c(%ebx)
80104335:	53                   	push   %ebx
80104336:	68 69 7e 10 80       	push   $0x80107e69
8010433b:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104341:	e8 1a c3 ff ff       	call   80100660 <cprintf>
80104346:	83 c4 20             	add    $0x20,%esp
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104349:	81 fb c0 62 11 80    	cmp    $0x801162c0,%ebx
8010434f:	75 bd                	jne    8010430e <list+0x3e>
   if(p->pid != 0){
	   if(strlen(p->name)>4) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,p->tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,p->tick,p->sz,p->limit_sz );
    }
  }
	release(&ptable.lock);
80104351:	83 ec 0c             	sub    $0xc,%esp
80104354:	68 20 3d 11 80       	push   $0x80113d20
80104359:	e8 a2 07 00 00       	call   80104b00 <release>
  return 0;
}
8010435e:	31 c0                	xor    %eax,%eax
80104360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104363:	c9                   	leave  
80104364:	c3                   	ret    
80104365:	8d 76 00             	lea    0x0(%esi),%esi
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   if(p->pid != 0){
	   if(strlen(p->name)>4) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,p->tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,p->tick,p->sz,p->limit_sz );
80104368:	83 ec 08             	sub    $0x8,%esp
8010436b:	ff 73 20             	pushl  0x20(%ebx)
8010436e:	ff 73 94             	pushl  -0x6c(%ebx)
80104371:	ff 73 24             	pushl  0x24(%ebx)
80104374:	ff 73 a4             	pushl  -0x5c(%ebx)
80104377:	53                   	push   %ebx
80104378:	68 7f 7e 10 80       	push   $0x80107e7f
8010437d:	e8 de c2 ff ff       	call   80100660 <cprintf>
80104382:	83 c4 20             	add    $0x20,%esp
80104385:	e9 76 ff ff ff       	jmp    80104300 <list+0x30>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <setpriority>:
}


int             
setpriority(int pid, int priority)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	56                   	push   %esi
80104395:	53                   	push   %ebx
80104396:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104399:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
}


int             
setpriority(int pid, int priority)
{
8010439d:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801043a0:	0f 87 97 00 00 00    	ja     8010443d <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801043a6:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801043a9:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801043ae:	68 20 3d 11 80       	push   $0x80113d20
801043b3:	e8 98 06 00 00       	call   80104a50 <acquire>
801043b8:	83 c4 10             	add    $0x10,%esp
801043bb:	eb 11                	jmp    801043ce <setpriority+0x3e>
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801043c0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801043c6:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
801043cc:	74 52                	je     80104420 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
801043ce:	39 73 10             	cmp    %esi,0x10(%ebx)
801043d1:	75 ed                	jne    801043c0 <setpriority+0x30>
801043d3:	8b 43 14             	mov    0x14(%ebx),%eax
801043d6:	8b 50 10             	mov    0x10(%eax),%edx
801043d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043dc:	e8 8f 05 00 00       	call   80104970 <pushcli>
  c = mycpu();
801043e1:	e8 ca f6 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801043e6:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801043ec:	e8 bf 05 00 00       	call   801049b0 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
801043f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043f4:	3b 57 10             	cmp    0x10(%edi),%edx
801043f7:	75 c7                	jne    801043c0 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
801043f9:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
801043fc:	83 ec 0c             	sub    $0xc,%esp
801043ff:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104404:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
80104407:	e8 f4 06 00 00       	call   80104b00 <release>

      return 0;
8010440c:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
8010440f:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
80104412:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
80104414:	5b                   	pop    %ebx
80104415:	5e                   	pop    %esi
80104416:	5f                   	pop    %edi
80104417:	5d                   	pop    %ebp
80104418:	c3                   	ret    
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 20 3d 11 80       	push   $0x80113d20
80104428:	e8 d3 06 00 00       	call   80104b00 <release>
  return -1;
8010442d:	83 c4 10             	add    $0x10,%esp
80104430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104435:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104438:	5b                   	pop    %ebx
80104439:	5e                   	pop    %esi
8010443a:	5f                   	pop    %edi
8010443b:	5d                   	pop    %ebp
8010443c:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
8010443d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104442:	eb f1                	jmp    80104435 <setpriority+0xa5>
80104444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010444a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104450 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	56                   	push   %esi
80104455:	53                   	push   %ebx
80104456:	83 ec 0c             	sub    $0xc,%esp
80104459:	8b 7d 08             	mov    0x8(%ebp),%edi
8010445c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010445f:	e8 0c 05 00 00       	call   80104970 <pushcli>
  c = mycpu();
80104464:	e8 47 f6 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104469:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010446f:	e8 3c 05 00 00       	call   801049b0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104474:	85 db                	test   %ebx,%ebx
80104476:	0f 84 87 00 00 00    	je     80104503 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010447c:	85 f6                	test   %esi,%esi
8010447e:	74 76                	je     801044f6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104480:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104486:	74 50                	je     801044d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	68 20 3d 11 80       	push   $0x80113d20
80104490:	e8 bb 05 00 00       	call   80104a50 <acquire>
    release(lk);
80104495:	89 34 24             	mov    %esi,(%esp)
80104498:	e8 63 06 00 00       	call   80104b00 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010449d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044a7:	e8 94 fa ff ff       	call   80103f40 <sched>
  // Tidy up.
  p->chan = 0;
801044ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801044b3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801044ba:	e8 41 06 00 00       	call   80104b00 <release>
    acquire(lk);
801044bf:	89 75 08             	mov    %esi,0x8(%ebp)
801044c2:	83 c4 10             	add    $0x10,%esp
  }
}
801044c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044c8:	5b                   	pop    %ebx
801044c9:	5e                   	pop    %esi
801044ca:	5f                   	pop    %edi
801044cb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801044cc:	e9 7f 05 00 00       	jmp    80104a50 <acquire>
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801044d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044e2:	e8 59 fa ff ff       	call   80103f40 <sched>
  // Tidy up.
  p->chan = 0;
801044e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801044ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044f1:	5b                   	pop    %ebx
801044f2:	5e                   	pop    %esi
801044f3:	5f                   	pop    %edi
801044f4:	5d                   	pop    %ebp
801044f5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
801044f6:	83 ec 0c             	sub    $0xc,%esp
801044f9:	68 9c 7e 10 80       	push   $0x80107e9c
801044fe:	e8 6d be ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104503:	83 ec 0c             	sub    $0xc,%esp
80104506:	68 96 7e 10 80       	push   $0x80107e96
8010450b:	e8 60 be ff ff       	call   80100370 <panic>

80104510 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104515:	e8 56 04 00 00       	call   80104970 <pushcli>
  c = mycpu();
8010451a:	e8 91 f5 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010451f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104525:	e8 86 04 00 00       	call   801049b0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	68 20 3d 11 80       	push   $0x80113d20
80104532:	e8 19 05 00 00       	call   80104a50 <acquire>
80104537:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010453a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104541:	eb 13                	jmp    80104556 <wait+0x46>
80104543:	90                   	nop
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104548:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010454e:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
80104554:	74 22                	je     80104578 <wait+0x68>
      if(p->parent != curproc)
80104556:	39 73 14             	cmp    %esi,0x14(%ebx)
80104559:	75 ed                	jne    80104548 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010455b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010455f:	74 35                	je     80104596 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104561:	81 c3 94 00 00 00    	add    $0x94,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104567:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010456c:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
80104572:	75 e2                	jne    80104556 <wait+0x46>
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104578:	85 c0                	test   %eax,%eax
8010457a:	74 70                	je     801045ec <wait+0xdc>
8010457c:	8b 46 24             	mov    0x24(%esi),%eax
8010457f:	85 c0                	test   %eax,%eax
80104581:	75 69                	jne    801045ec <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104583:	83 ec 08             	sub    $0x8,%esp
80104586:	68 20 3d 11 80       	push   $0x80113d20
8010458b:	56                   	push   %esi
8010458c:	e8 bf fe ff ff       	call   80104450 <sleep>
  }
80104591:	83 c4 10             	add    $0x10,%esp
80104594:	eb a4                	jmp    8010453a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010459c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010459f:	e8 cc e0 ff ff       	call   80102670 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801045a4:	5a                   	pop    %edx
801045a5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801045a8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045af:	e8 9c 2f 00 00       	call   80107550 <freevm>
        p->pid = 0;
801045b4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801045bb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801045c2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801045c6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801045cd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045d4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801045db:	e8 20 05 00 00       	call   80104b00 <release>
        return pid;
801045e0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
801045e6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045e8:	5b                   	pop    %ebx
801045e9:	5e                   	pop    %esi
801045ea:	5d                   	pop    %ebp
801045eb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	68 20 3d 11 80       	push   $0x80113d20
801045f4:	e8 07 05 00 00       	call   80104b00 <release>
      return -1;
801045f9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
801045ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104604:	5b                   	pop    %ebx
80104605:	5e                   	pop    %esi
80104606:	5d                   	pop    %ebp
80104607:	c3                   	ret    
80104608:	90                   	nop
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104610 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 10             	sub    $0x10,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010461a:	68 20 3d 11 80       	push   $0x80113d20
8010461f:	e8 2c 04 00 00       	call   80104a50 <acquire>
80104624:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104627:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010462c:	eb 0e                	jmp    8010463c <wakeup+0x2c>
8010462e:	66 90                	xchg   %ax,%ax
80104630:	05 94 00 00 00       	add    $0x94,%eax
80104635:	3d 54 62 11 80       	cmp    $0x80116254,%eax
8010463a:	74 1e                	je     8010465a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010463c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104640:	75 ee                	jne    80104630 <wakeup+0x20>
80104642:	3b 58 20             	cmp    0x20(%eax),%ebx
80104645:	75 e9                	jne    80104630 <wakeup+0x20>
      p->state = RUNNABLE;
80104647:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464e:	05 94 00 00 00       	add    $0x94,%eax
80104653:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80104658:	75 e2                	jne    8010463c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010465a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104664:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104665:	e9 96 04 00 00       	jmp    80104b00 <release>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 10             	sub    $0x10,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010467a:	68 20 3d 11 80       	push   $0x80113d20
8010467f:	e8 cc 03 00 00       	call   80104a50 <acquire>
80104684:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104687:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010468c:	eb 0e                	jmp    8010469c <kill+0x2c>
8010468e:	66 90                	xchg   %ax,%ax
80104690:	05 94 00 00 00       	add    $0x94,%eax
80104695:	3d 54 62 11 80       	cmp    $0x80116254,%eax
8010469a:	74 3c                	je     801046d8 <kill+0x68>
    if(p->pid == pid){
8010469c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010469f:	75 ef                	jne    80104690 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801046a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046ac:	74 1a                	je     801046c8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801046ae:	83 ec 0c             	sub    $0xc,%esp
801046b1:	68 20 3d 11 80       	push   $0x80113d20
801046b6:	e8 45 04 00 00       	call   80104b00 <release>
      return 0;
801046bb:	83 c4 10             	add    $0x10,%esp
801046be:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801046c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c3:	c9                   	leave  
801046c4:	c3                   	ret    
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801046c8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046cf:	eb dd                	jmp    801046ae <kill+0x3e>
801046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 20 3d 11 80       	push   $0x80113d20
801046e0:	e8 1b 04 00 00       	call   80104b00 <release>
  return -1;
801046e5:	83 c4 10             	add    $0x10,%esp
801046e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104709:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010470e:	83 ec 3c             	sub    $0x3c,%esp
80104711:	eb 27                	jmp    8010473a <procdump+0x3a>
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	68 73 82 10 80       	push   $0x80108273
80104720:	e8 3b bf ff ff       	call   80100660 <cprintf>
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	81 c3 94 00 00 00    	add    $0x94,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472e:	81 fb c0 62 11 80    	cmp    $0x801162c0,%ebx
80104734:	0f 84 7e 00 00 00    	je     801047b8 <procdump+0xb8>
    if(p->state == UNUSED)
8010473a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010473d:	85 c0                	test   %eax,%eax
8010473f:	74 e7                	je     80104728 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104741:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104744:	ba ad 7e 10 80       	mov    $0x80107ead,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104749:	77 11                	ja     8010475c <procdump+0x5c>
8010474b:	8b 14 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104752:	b8 ad 7e 10 80       	mov    $0x80107ead,%eax
80104757:	85 d2                	test   %edx,%edx
80104759:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010475c:	53                   	push   %ebx
8010475d:	52                   	push   %edx
8010475e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104761:	68 b1 7e 10 80       	push   $0x80107eb1
80104766:	e8 f5 be ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010476b:	83 c4 10             	add    $0x10,%esp
8010476e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104772:	75 a4                	jne    80104718 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104774:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104777:	83 ec 08             	sub    $0x8,%esp
8010477a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010477d:	50                   	push   %eax
8010477e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104781:	8b 40 0c             	mov    0xc(%eax),%eax
80104784:	83 c0 08             	add    $0x8,%eax
80104787:	50                   	push   %eax
80104788:	e8 83 01 00 00       	call   80104910 <getcallerpcs>
8010478d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104790:	8b 17                	mov    (%edi),%edx
80104792:	85 d2                	test   %edx,%edx
80104794:	74 82                	je     80104718 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104796:	83 ec 08             	sub    $0x8,%esp
80104799:	83 c7 04             	add    $0x4,%edi
8010479c:	52                   	push   %edx
8010479d:	68 c1 78 10 80       	push   $0x801078c1
801047a2:	e8 b9 be ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801047a7:	83 c4 10             	add    $0x10,%esp
801047aa:	39 f7                	cmp    %esi,%edi
801047ac:	75 e2                	jne    80104790 <procdump+0x90>
801047ae:	e9 65 ff ff ff       	jmp    80104718 <procdump+0x18>
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801047b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047bb:	5b                   	pop    %ebx
801047bc:	5e                   	pop    %esi
801047bd:	5f                   	pop    %edi
801047be:	5d                   	pop    %ebp
801047bf:	c3                   	ret    

801047c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047ca:	68 58 7f 10 80       	push   $0x80107f58
801047cf:	8d 43 04             	lea    0x4(%ebx),%eax
801047d2:	50                   	push   %eax
801047d3:	e8 18 01 00 00       	call   801048f0 <initlock>
  lk->name = name;
801047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047e1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801047e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801047eb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801047ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f1:	c9                   	leave  
801047f2:	c3                   	ret    
801047f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	8d 73 04             	lea    0x4(%ebx),%esi
8010480e:	56                   	push   %esi
8010480f:	e8 3c 02 00 00       	call   80104a50 <acquire>
  while (lk->locked) {
80104814:	8b 13                	mov    (%ebx),%edx
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 d2                	test   %edx,%edx
8010481b:	74 16                	je     80104833 <acquiresleep+0x33>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104820:	83 ec 08             	sub    $0x8,%esp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	e8 26 fc ff ff       	call   80104450 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010482a:	8b 03                	mov    (%ebx),%eax
8010482c:	83 c4 10             	add    $0x10,%esp
8010482f:	85 c0                	test   %eax,%eax
80104831:	75 ed                	jne    80104820 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104833:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104839:	e8 12 f3 ff ff       	call   80103b50 <myproc>
8010483e:	8b 40 10             	mov    0x10(%eax),%eax
80104841:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104844:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104847:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010484d:	e9 ae 02 00 00       	jmp    80104b00 <release>
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	8d 73 04             	lea    0x4(%ebx),%esi
8010486e:	56                   	push   %esi
8010486f:	e8 dc 01 00 00       	call   80104a50 <acquire>
  lk->locked = 0;
80104874:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010487a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104881:	89 1c 24             	mov    %ebx,(%esp)
80104884:	e8 87 fd ff ff       	call   80104610 <wakeup>
  release(&lk->lk);
80104889:	89 75 08             	mov    %esi,0x8(%ebp)
8010488c:	83 c4 10             	add    $0x10,%esp
}
8010488f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104895:	e9 66 02 00 00       	jmp    80104b00 <release>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	53                   	push   %ebx
801048a6:	31 ff                	xor    %edi,%edi
801048a8:	83 ec 18             	sub    $0x18,%esp
801048ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048ae:	8d 73 04             	lea    0x4(%ebx),%esi
801048b1:	56                   	push   %esi
801048b2:	e8 99 01 00 00       	call   80104a50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048b7:	8b 03                	mov    (%ebx),%eax
801048b9:	83 c4 10             	add    $0x10,%esp
801048bc:	85 c0                	test   %eax,%eax
801048be:	74 13                	je     801048d3 <holdingsleep+0x33>
801048c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048c3:	e8 88 f2 ff ff       	call   80103b50 <myproc>
801048c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048cb:	0f 94 c0             	sete   %al
801048ce:	0f b6 c0             	movzbl %al,%eax
801048d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801048d3:	83 ec 0c             	sub    $0xc,%esp
801048d6:	56                   	push   %esi
801048d7:	e8 24 02 00 00       	call   80104b00 <release>
  return r;
}
801048dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048df:	89 f8                	mov    %edi,%eax
801048e1:	5b                   	pop    %ebx
801048e2:	5e                   	pop    %esi
801048e3:	5f                   	pop    %edi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	66 90                	xchg   %ax,%ax
801048e8:	66 90                	xchg   %ax,%ax
801048ea:	66 90                	xchg   %ax,%ax
801048ec:	66 90                	xchg   %ax,%ax
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801048ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104902:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret    
8010490b:	90                   	nop
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104910 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104914:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010491a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010491d:	31 c0                	xor    %eax,%eax
8010491f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104920:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104926:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010492c:	77 1a                	ja     80104948 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010492e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104931:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104934:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104937:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104939:	83 f8 0a             	cmp    $0xa,%eax
8010493c:	75 e2                	jne    80104920 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010493e:	5b                   	pop    %ebx
8010493f:	5d                   	pop    %ebp
80104940:	c3                   	ret    
80104941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104948:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010494f:	83 c0 01             	add    $0x1,%eax
80104952:	83 f8 0a             	cmp    $0xa,%eax
80104955:	74 e7                	je     8010493e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104957:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010495e:	83 c0 01             	add    $0x1,%eax
80104961:	83 f8 0a             	cmp    $0xa,%eax
80104964:	75 e2                	jne    80104948 <getcallerpcs+0x38>
80104966:	eb d6                	jmp    8010493e <getcallerpcs+0x2e>
80104968:	90                   	nop
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104970 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	9c                   	pushf  
80104978:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104979:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010497a:	e8 31 f1 ff ff       	call   80103ab0 <mycpu>
8010497f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104985:	85 c0                	test   %eax,%eax
80104987:	75 11                	jne    8010499a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104989:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010498f:	e8 1c f1 ff ff       	call   80103ab0 <mycpu>
80104994:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010499a:	e8 11 f1 ff ff       	call   80103ab0 <mycpu>
8010499f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049a6:	83 c4 04             	add    $0x4,%esp
801049a9:	5b                   	pop    %ebx
801049aa:	5d                   	pop    %ebp
801049ab:	c3                   	ret    
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049b0 <popcli>:

void
popcli(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049b6:	9c                   	pushf  
801049b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049b8:	f6 c4 02             	test   $0x2,%ah
801049bb:	75 52                	jne    80104a0f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049bd:	e8 ee f0 ff ff       	call   80103ab0 <mycpu>
801049c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801049c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801049cb:	85 d2                	test   %edx,%edx
801049cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801049d3:	78 2d                	js     80104a02 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049d5:	e8 d6 f0 ff ff       	call   80103ab0 <mycpu>
801049da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049e0:	85 d2                	test   %edx,%edx
801049e2:	74 0c                	je     801049f0 <popcli+0x40>
    sti();
}
801049e4:	c9                   	leave  
801049e5:	c3                   	ret    
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049f0:	e8 bb f0 ff ff       	call   80103ab0 <mycpu>
801049f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049fb:	85 c0                	test   %eax,%eax
801049fd:	74 e5                	je     801049e4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801049ff:	fb                   	sti    
    sti();
}
80104a00:	c9                   	leave  
80104a01:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104a02:	83 ec 0c             	sub    $0xc,%esp
80104a05:	68 7a 7f 10 80       	push   $0x80107f7a
80104a0a:	e8 61 b9 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104a0f:	83 ec 0c             	sub    $0xc,%esp
80104a12:	68 63 7f 10 80       	push   $0x80107f63
80104a17:	e8 54 b9 ff ff       	call   80100370 <panic>
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a20 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 75 08             	mov    0x8(%ebp),%esi
80104a28:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104a2a:	e8 41 ff ff ff       	call   80104970 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a2f:	8b 06                	mov    (%esi),%eax
80104a31:	85 c0                	test   %eax,%eax
80104a33:	74 10                	je     80104a45 <holding+0x25>
80104a35:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a38:	e8 73 f0 ff ff       	call   80103ab0 <mycpu>
80104a3d:	39 c3                	cmp    %eax,%ebx
80104a3f:	0f 94 c3             	sete   %bl
80104a42:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a45:	e8 66 ff ff ff       	call   801049b0 <popcli>
  return r;
}
80104a4a:	89 d8                	mov    %ebx,%eax
80104a4c:	5b                   	pop    %ebx
80104a4d:	5e                   	pop    %esi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a57:	e8 14 ff ff ff       	call   80104970 <pushcli>
  if(holding(lk))
80104a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	53                   	push   %ebx
80104a63:	e8 b8 ff ff ff       	call   80104a20 <holding>
80104a68:	83 c4 10             	add    $0x10,%esp
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	0f 85 7d 00 00 00    	jne    80104af0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104a73:	ba 01 00 00 00       	mov    $0x1,%edx
80104a78:	eb 09                	jmp    80104a83 <acquire+0x33>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a83:	89 d0                	mov    %edx,%eax
80104a85:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104a88:	85 c0                	test   %eax,%eax
80104a8a:	75 f4                	jne    80104a80 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104a8c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a94:	e8 17 f0 ff ff       	call   80103ab0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a99:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104a9b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a9e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aa1:	31 c0                	xor    %eax,%eax
80104aa3:	90                   	nop
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104aa8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104aae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ab4:	77 1a                	ja     80104ad0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ab6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ab9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104abc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104abf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ac1:	83 f8 0a             	cmp    $0xa,%eax
80104ac4:	75 e2                	jne    80104aa8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac9:	c9                   	leave  
80104aca:	c3                   	ret    
80104acb:	90                   	nop
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104ad0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ad7:	83 c0 01             	add    $0x1,%eax
80104ada:	83 f8 0a             	cmp    $0xa,%eax
80104add:	74 e7                	je     80104ac6 <acquire+0x76>
    pcs[i] = 0;
80104adf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ae6:	83 c0 01             	add    $0x1,%eax
80104ae9:	83 f8 0a             	cmp    $0xa,%eax
80104aec:	75 e2                	jne    80104ad0 <acquire+0x80>
80104aee:	eb d6                	jmp    80104ac6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	68 81 7f 10 80       	push   $0x80107f81
80104af8:	e8 73 b8 ff ff       	call   80100370 <panic>
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 10             	sub    $0x10,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b0a:	53                   	push   %ebx
80104b0b:	e8 10 ff ff ff       	call   80104a20 <holding>
80104b10:	83 c4 10             	add    $0x10,%esp
80104b13:	85 c0                	test   %eax,%eax
80104b15:	74 22                	je     80104b39 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104b17:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b1e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104b25:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b33:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104b34:	e9 77 fe ff ff       	jmp    801049b0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104b39:	83 ec 0c             	sub    $0xc,%esp
80104b3c:	68 89 7f 10 80       	push   $0x80107f89
80104b41:	e8 2a b8 ff ff       	call   80100370 <panic>
80104b46:	66 90                	xchg   %ax,%ax
80104b48:	66 90                	xchg   %ax,%ax
80104b4a:	66 90                	xchg   %ax,%ax
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	53                   	push   %ebx
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
80104b58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b5b:	f6 c2 03             	test   $0x3,%dl
80104b5e:	75 05                	jne    80104b65 <memset+0x15>
80104b60:	f6 c1 03             	test   $0x3,%cl
80104b63:	74 13                	je     80104b78 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104b65:	89 d7                	mov    %edx,%edi
80104b67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6a:	fc                   	cld    
80104b6b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b6d:	5b                   	pop    %ebx
80104b6e:	89 d0                	mov    %edx,%eax
80104b70:	5f                   	pop    %edi
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	90                   	nop
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104b78:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104b7c:	c1 e9 02             	shr    $0x2,%ecx
80104b7f:	89 fb                	mov    %edi,%ebx
80104b81:	89 f8                	mov    %edi,%eax
80104b83:	c1 e3 18             	shl    $0x18,%ebx
80104b86:	c1 e0 10             	shl    $0x10,%eax
80104b89:	09 d8                	or     %ebx,%eax
80104b8b:	09 f8                	or     %edi,%eax
80104b8d:	c1 e7 08             	shl    $0x8,%edi
80104b90:	09 f8                	or     %edi,%eax
80104b92:	89 d7                	mov    %edx,%edi
80104b94:	fc                   	cld    
80104b95:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b97:	5b                   	pop    %ebx
80104b98:	89 d0                	mov    %edx,%eax
80104b9a:	5f                   	pop    %edi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ba0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	57                   	push   %edi
80104ba4:	56                   	push   %esi
80104ba5:	8b 45 10             	mov    0x10(%ebp),%eax
80104ba8:	53                   	push   %ebx
80104ba9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104bac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	74 29                	je     80104bdc <memcmp+0x3c>
    if(*s1 != *s2)
80104bb3:	0f b6 13             	movzbl (%ebx),%edx
80104bb6:	0f b6 0e             	movzbl (%esi),%ecx
80104bb9:	38 d1                	cmp    %dl,%cl
80104bbb:	75 2b                	jne    80104be8 <memcmp+0x48>
80104bbd:	8d 78 ff             	lea    -0x1(%eax),%edi
80104bc0:	31 c0                	xor    %eax,%eax
80104bc2:	eb 14                	jmp    80104bd8 <memcmp+0x38>
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104bcd:	83 c0 01             	add    $0x1,%eax
80104bd0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bd4:	38 ca                	cmp    %cl,%dl
80104bd6:	75 10                	jne    80104be8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bd8:	39 f8                	cmp    %edi,%eax
80104bda:	75 ec                	jne    80104bc8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bdc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104bdd:	31 c0                	xor    %eax,%eax
}
80104bdf:	5e                   	pop    %esi
80104be0:	5f                   	pop    %edi
80104be1:	5d                   	pop    %ebp
80104be2:	c3                   	ret    
80104be3:	90                   	nop
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104be8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104beb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bec:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104bee:	5e                   	pop    %esi
80104bef:	5f                   	pop    %edi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret    
80104bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 45 08             	mov    0x8(%ebp),%eax
80104c08:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c0e:	39 c6                	cmp    %eax,%esi
80104c10:	73 2e                	jae    80104c40 <memmove+0x40>
80104c12:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104c15:	39 c8                	cmp    %ecx,%eax
80104c17:	73 27                	jae    80104c40 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104c19:	85 db                	test   %ebx,%ebx
80104c1b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104c1e:	74 17                	je     80104c37 <memmove+0x37>
      *--d = *--s;
80104c20:	29 d9                	sub    %ebx,%ecx
80104c22:	89 cb                	mov    %ecx,%ebx
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c28:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c2c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104c2f:	83 ea 01             	sub    $0x1,%edx
80104c32:	83 fa ff             	cmp    $0xffffffff,%edx
80104c35:	75 f1                	jne    80104c28 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c37:	5b                   	pop    %ebx
80104c38:	5e                   	pop    %esi
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    
80104c3b:	90                   	nop
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c40:	31 d2                	xor    %edx,%edx
80104c42:	85 db                	test   %ebx,%ebx
80104c44:	74 f1                	je     80104c37 <memmove+0x37>
80104c46:	8d 76 00             	lea    0x0(%esi),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104c50:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104c54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c57:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c5a:	39 d3                	cmp    %edx,%ebx
80104c5c:	75 f2                	jne    80104c50 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104c5e:	5b                   	pop    %ebx
80104c5f:	5e                   	pop    %esi
80104c60:	5d                   	pop    %ebp
80104c61:	c3                   	ret    
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c73:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c74:	eb 8a                	jmp    80104c00 <memmove>
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c88:	53                   	push   %ebx
80104c89:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c8f:	85 c9                	test   %ecx,%ecx
80104c91:	74 37                	je     80104cca <strncmp+0x4a>
80104c93:	0f b6 17             	movzbl (%edi),%edx
80104c96:	0f b6 1e             	movzbl (%esi),%ebx
80104c99:	84 d2                	test   %dl,%dl
80104c9b:	74 3f                	je     80104cdc <strncmp+0x5c>
80104c9d:	38 d3                	cmp    %dl,%bl
80104c9f:	75 3b                	jne    80104cdc <strncmp+0x5c>
80104ca1:	8d 47 01             	lea    0x1(%edi),%eax
80104ca4:	01 cf                	add    %ecx,%edi
80104ca6:	eb 1b                	jmp    80104cc3 <strncmp+0x43>
80104ca8:	90                   	nop
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	0f b6 10             	movzbl (%eax),%edx
80104cb3:	84 d2                	test   %dl,%dl
80104cb5:	74 21                	je     80104cd8 <strncmp+0x58>
80104cb7:	0f b6 19             	movzbl (%ecx),%ebx
80104cba:	83 c0 01             	add    $0x1,%eax
80104cbd:	89 ce                	mov    %ecx,%esi
80104cbf:	38 da                	cmp    %bl,%dl
80104cc1:	75 19                	jne    80104cdc <strncmp+0x5c>
80104cc3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104cc5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104cc8:	75 e6                	jne    80104cb0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cca:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104ccb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104ccd:	5e                   	pop    %esi
80104cce:	5f                   	pop    %edi
80104ccf:	5d                   	pop    %ebp
80104cd0:	c3                   	ret    
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104cdc:	0f b6 c2             	movzbl %dl,%eax
80104cdf:	29 d8                	sub    %ebx,%eax
}
80104ce1:	5b                   	pop    %ebx
80104ce2:	5e                   	pop    %esi
80104ce3:	5f                   	pop    %edi
80104ce4:	5d                   	pop    %ebp
80104ce5:	c3                   	ret    
80104ce6:	8d 76 00             	lea    0x0(%esi),%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
80104cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104cfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cfe:	89 c2                	mov    %eax,%edx
80104d00:	eb 19                	jmp    80104d1b <strncpy+0x2b>
80104d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d08:	83 c3 01             	add    $0x1,%ebx
80104d0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104d0f:	83 c2 01             	add    $0x1,%edx
80104d12:	84 c9                	test   %cl,%cl
80104d14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d17:	74 09                	je     80104d22 <strncpy+0x32>
80104d19:	89 f1                	mov    %esi,%ecx
80104d1b:	85 c9                	test   %ecx,%ecx
80104d1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d20:	7f e6                	jg     80104d08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d22:	31 c9                	xor    %ecx,%ecx
80104d24:	85 f6                	test   %esi,%esi
80104d26:	7e 17                	jle    80104d3f <strncpy+0x4f>
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d34:	89 f3                	mov    %esi,%ebx
80104d36:	83 c1 01             	add    $0x1,%ecx
80104d39:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104d3b:	85 db                	test   %ebx,%ebx
80104d3d:	7f f1                	jg     80104d30 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104d3f:	5b                   	pop    %ebx
80104d40:	5e                   	pop    %esi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    
80104d43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d58:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d5e:	85 c9                	test   %ecx,%ecx
80104d60:	7e 26                	jle    80104d88 <safestrcpy+0x38>
80104d62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d66:	89 c1                	mov    %eax,%ecx
80104d68:	eb 17                	jmp    80104d81 <safestrcpy+0x31>
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d70:	83 c2 01             	add    $0x1,%edx
80104d73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d77:	83 c1 01             	add    $0x1,%ecx
80104d7a:	84 db                	test   %bl,%bl
80104d7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d7f:	74 04                	je     80104d85 <safestrcpy+0x35>
80104d81:	39 f2                	cmp    %esi,%edx
80104d83:	75 eb                	jne    80104d70 <safestrcpy+0x20>
    ;
  *s = 0;
80104d85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d88:	5b                   	pop    %ebx
80104d89:	5e                   	pop    %esi
80104d8a:	5d                   	pop    %ebp
80104d8b:	c3                   	ret    
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d90 <strlen>:

int
strlen(const char *s)
{
80104d90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d91:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104d93:	89 e5                	mov    %esp,%ebp
80104d95:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104d98:	80 3a 00             	cmpb   $0x0,(%edx)
80104d9b:	74 0c                	je     80104da9 <strlen+0x19>
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
80104da0:	83 c0 01             	add    $0x1,%eax
80104da3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104da7:	75 f7                	jne    80104da0 <strlen+0x10>
    ;
  return n;
}
80104da9:	5d                   	pop    %ebp
80104daa:	c3                   	ret    

80104dab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104dab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104daf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104db3:	55                   	push   %ebp
  pushl %ebx
80104db4:	53                   	push   %ebx
  pushl %esi
80104db5:	56                   	push   %esi
  pushl %edi
80104db6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104db7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104db9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104dbb:	5f                   	pop    %edi
  popl %esi
80104dbc:	5e                   	pop    %esi
  popl %ebx
80104dbd:	5b                   	pop    %ebx
  popl %ebp
80104dbe:	5d                   	pop    %ebp
  ret
80104dbf:	c3                   	ret    

80104dc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
80104dc4:	83 ec 04             	sub    $0x4,%esp
80104dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dca:	e8 81 ed ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dcf:	8b 00                	mov    (%eax),%eax
80104dd1:	39 d8                	cmp    %ebx,%eax
80104dd3:	76 1b                	jbe    80104df0 <fetchint+0x30>
80104dd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dd8:	39 d0                	cmp    %edx,%eax
80104dda:	72 14                	jb     80104df0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ddf:	8b 13                	mov    (%ebx),%edx
80104de1:	89 10                	mov    %edx,(%eax)
  return 0;
80104de3:	31 c0                	xor    %eax,%eax
}
80104de5:	83 c4 04             	add    $0x4,%esp
80104de8:	5b                   	pop    %ebx
80104de9:	5d                   	pop    %ebp
80104dea:	c3                   	ret    
80104deb:	90                   	nop
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df5:	eb ee                	jmp    80104de5 <fetchint+0x25>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
80104e04:	83 ec 04             	sub    $0x4,%esp
80104e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e0a:	e8 41 ed ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz)
80104e0f:	39 18                	cmp    %ebx,(%eax)
80104e11:	76 29                	jbe    80104e3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e16:	89 da                	mov    %ebx,%edx
80104e18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e1c:	39 c3                	cmp    %eax,%ebx
80104e1e:	73 1c                	jae    80104e3c <fetchstr+0x3c>
    if(*s == 0)
80104e20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e23:	75 10                	jne    80104e35 <fetchstr+0x35>
80104e25:	eb 29                	jmp    80104e50 <fetchstr+0x50>
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e30:	80 3a 00             	cmpb   $0x0,(%edx)
80104e33:	74 1b                	je     80104e50 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104e35:	83 c2 01             	add    $0x1,%edx
80104e38:	39 d0                	cmp    %edx,%eax
80104e3a:	77 f4                	ja     80104e30 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e3c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e44:	5b                   	pop    %ebx
80104e45:	5d                   	pop    %ebp
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e50:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104e53:	89 d0                	mov    %edx,%eax
80104e55:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e57:	5b                   	pop    %ebx
80104e58:	5d                   	pop    %ebp
80104e59:	c3                   	ret    
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e65:	e8 e6 ec ff ff       	call   80103b50 <myproc>
80104e6a:	8b 40 18             	mov    0x18(%eax),%eax
80104e6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e70:	8b 40 44             	mov    0x44(%eax),%eax
80104e73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104e76:	e8 d5 ec ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e7b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e7d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e80:	39 c6                	cmp    %eax,%esi
80104e82:	73 1c                	jae    80104ea0 <argint+0x40>
80104e84:	8d 53 08             	lea    0x8(%ebx),%edx
80104e87:	39 d0                	cmp    %edx,%eax
80104e89:	72 15                	jb     80104ea0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e91:	89 10                	mov    %edx,(%eax)
  return 0;
80104e93:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5d                   	pop    %ebp
80104e98:	c3                   	ret    
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea5:	eb ee                	jmp    80104e95 <argint+0x35>
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
80104eb5:	83 ec 10             	sub    $0x10,%esp
80104eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ebb:	e8 90 ec ff ff       	call   80103b50 <myproc>
80104ec0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ec2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ec5:	83 ec 08             	sub    $0x8,%esp
80104ec8:	50                   	push   %eax
80104ec9:	ff 75 08             	pushl  0x8(%ebp)
80104ecc:	e8 8f ff ff ff       	call   80104e60 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ed1:	c1 e8 1f             	shr    $0x1f,%eax
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	84 c0                	test   %al,%al
80104ed9:	75 2d                	jne    80104f08 <argptr+0x58>
80104edb:	89 d8                	mov    %ebx,%eax
80104edd:	c1 e8 1f             	shr    $0x1f,%eax
80104ee0:	84 c0                	test   %al,%al
80104ee2:	75 24                	jne    80104f08 <argptr+0x58>
80104ee4:	8b 16                	mov    (%esi),%edx
80104ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee9:	39 c2                	cmp    %eax,%edx
80104eeb:	76 1b                	jbe    80104f08 <argptr+0x58>
80104eed:	01 c3                	add    %eax,%ebx
80104eef:	39 da                	cmp    %ebx,%edx
80104ef1:	72 15                	jb     80104f08 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ef6:	89 02                	mov    %eax,(%edx)
  return 0;
80104ef8:	31 c0                	xor    %eax,%eax
}
80104efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104efd:	5b                   	pop    %ebx
80104efe:	5e                   	pop    %esi
80104eff:	5d                   	pop    %ebp
80104f00:	c3                   	ret    
80104f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f0d:	eb eb                	jmp    80104efa <argptr+0x4a>
80104f0f:	90                   	nop

80104f10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f19:	50                   	push   %eax
80104f1a:	ff 75 08             	pushl  0x8(%ebp)
80104f1d:	e8 3e ff ff ff       	call   80104e60 <argint>
80104f22:	83 c4 10             	add    $0x10,%esp
80104f25:	85 c0                	test   %eax,%eax
80104f27:	78 17                	js     80104f40 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f29:	83 ec 08             	sub    $0x8,%esp
80104f2c:	ff 75 0c             	pushl  0xc(%ebp)
80104f2f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f32:	e8 c9 fe ff ff       	call   80104e00 <fetchstr>
80104f37:	83 c4 10             	add    $0x10,%esp
}
80104f3a:	c9                   	leave  
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <syscall>:
[SYS_list] sys_list,
};

void
syscall(void)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104f55:	e8 f6 eb ff ff       	call   80103b50 <myproc>

  num = curproc->tf->eax;
80104f5a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104f5d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f5f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f62:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f65:	83 fa 1b             	cmp    $0x1b,%edx
80104f68:	77 1e                	ja     80104f88 <syscall+0x38>
80104f6a:	8b 14 85 c0 7f 10 80 	mov    -0x7fef8040(,%eax,4),%edx
80104f71:	85 d2                	test   %edx,%edx
80104f73:	74 13                	je     80104f88 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f75:	ff d2                	call   *%edx
80104f77:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f7d:	5b                   	pop    %ebx
80104f7e:	5e                   	pop    %esi
80104f7f:	5d                   	pop    %ebp
80104f80:	c3                   	ret    
80104f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f88:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f89:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f8c:	50                   	push   %eax
80104f8d:	ff 73 10             	pushl  0x10(%ebx)
80104f90:	68 91 7f 10 80       	push   $0x80107f91
80104f95:	e8 c6 b6 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104f9a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104fa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104faa:	5b                   	pop    %ebx
80104fab:	5e                   	pop    %esi
80104fac:	5d                   	pop    %ebp
80104fad:	c3                   	ret    
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fb6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fb9:	83 ec 34             	sub    $0x34,%esp
80104fbc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fc2:	56                   	push   %esi
80104fc3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fc4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fc7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fca:	e8 a1 d2 ff ff       	call   80102270 <nameiparent>
80104fcf:	83 c4 10             	add    $0x10,%esp
80104fd2:	85 c0                	test   %eax,%eax
80104fd4:	0f 84 f6 00 00 00    	je     801050d0 <create+0x120>
    return 0;
  ilock(dp);
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	89 c7                	mov    %eax,%edi
80104fdf:	50                   	push   %eax
80104fe0:	e8 1b ca ff ff       	call   80101a00 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fe5:	83 c4 0c             	add    $0xc,%esp
80104fe8:	6a 00                	push   $0x0
80104fea:	56                   	push   %esi
80104feb:	57                   	push   %edi
80104fec:	e8 3f cf ff ff       	call   80101f30 <dirlookup>
80104ff1:	83 c4 10             	add    $0x10,%esp
80104ff4:	85 c0                	test   %eax,%eax
80104ff6:	89 c3                	mov    %eax,%ebx
80104ff8:	74 56                	je     80105050 <create+0xa0>
    iunlockput(dp);
80104ffa:	83 ec 0c             	sub    $0xc,%esp
80104ffd:	57                   	push   %edi
80104ffe:	e8 8d cc ff ff       	call   80101c90 <iunlockput>
    ilock(ip);
80105003:	89 1c 24             	mov    %ebx,(%esp)
80105006:	e8 f5 c9 ff ff       	call   80101a00 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010500b:	83 c4 10             	add    $0x10,%esp
8010500e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105013:	75 1b                	jne    80105030 <create+0x80>
80105015:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010501a:	89 d8                	mov    %ebx,%eax
8010501c:	75 12                	jne    80105030 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010501e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105021:	5b                   	pop    %ebx
80105022:	5e                   	pop    %esi
80105023:	5f                   	pop    %edi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret    
80105026:	8d 76 00             	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105030:	83 ec 0c             	sub    $0xc,%esp
80105033:	53                   	push   %ebx
80105034:	e8 57 cc ff ff       	call   80101c90 <iunlockput>
    return 0;
80105039:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010503c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010503f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5f                   	pop    %edi
80105044:	5d                   	pop    %ebp
80105045:	c3                   	ret    
80105046:	8d 76 00             	lea    0x0(%esi),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105050:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105054:	83 ec 08             	sub    $0x8,%esp
80105057:	50                   	push   %eax
80105058:	ff 37                	pushl  (%edi)
8010505a:	e8 31 c8 ff ff       	call   80101890 <ialloc>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	89 c3                	mov    %eax,%ebx
80105066:	0f 84 cc 00 00 00    	je     80105138 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010506c:	83 ec 0c             	sub    $0xc,%esp
8010506f:	50                   	push   %eax
80105070:	e8 8b c9 ff ff       	call   80101a00 <ilock>
  ip->major = major;
80105075:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105079:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010507d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105081:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105085:	b8 01 00 00 00       	mov    $0x1,%eax
8010508a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010508e:	89 1c 24             	mov    %ebx,(%esp)
80105091:	e8 ba c8 ff ff       	call   80101950 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105096:	83 c4 10             	add    $0x10,%esp
80105099:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010509e:	74 40                	je     801050e0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801050a0:	83 ec 04             	sub    $0x4,%esp
801050a3:	ff 73 04             	pushl  0x4(%ebx)
801050a6:	56                   	push   %esi
801050a7:	57                   	push   %edi
801050a8:	e8 e3 d0 ff ff       	call   80102190 <dirlink>
801050ad:	83 c4 10             	add    $0x10,%esp
801050b0:	85 c0                	test   %eax,%eax
801050b2:	78 77                	js     8010512b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	57                   	push   %edi
801050b8:	e8 d3 cb ff ff       	call   80101c90 <iunlockput>

  return ip;
801050bd:	83 c4 10             	add    $0x10,%esp
}
801050c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801050c3:	89 d8                	mov    %ebx,%eax
}
801050c5:	5b                   	pop    %ebx
801050c6:	5e                   	pop    %esi
801050c7:	5f                   	pop    %edi
801050c8:	5d                   	pop    %ebp
801050c9:	c3                   	ret    
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801050d0:	31 c0                	xor    %eax,%eax
801050d2:	e9 47 ff ff ff       	jmp    8010501e <create+0x6e>
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801050e0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801050e5:	83 ec 0c             	sub    $0xc,%esp
801050e8:	57                   	push   %edi
801050e9:	e8 62 c8 ff ff       	call   80101950 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050ee:	83 c4 0c             	add    $0xc,%esp
801050f1:	ff 73 04             	pushl  0x4(%ebx)
801050f4:	68 50 80 10 80       	push   $0x80108050
801050f9:	53                   	push   %ebx
801050fa:	e8 91 d0 ff ff       	call   80102190 <dirlink>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	85 c0                	test   %eax,%eax
80105104:	78 18                	js     8010511e <create+0x16e>
80105106:	83 ec 04             	sub    $0x4,%esp
80105109:	ff 77 04             	pushl  0x4(%edi)
8010510c:	68 4f 80 10 80       	push   $0x8010804f
80105111:	53                   	push   %ebx
80105112:	e8 79 d0 ff ff       	call   80102190 <dirlink>
80105117:	83 c4 10             	add    $0x10,%esp
8010511a:	85 c0                	test   %eax,%eax
8010511c:	79 82                	jns    801050a0 <create+0xf0>
      panic("create dots");
8010511e:	83 ec 0c             	sub    $0xc,%esp
80105121:	68 43 80 10 80       	push   $0x80108043
80105126:	e8 45 b2 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010512b:	83 ec 0c             	sub    $0xc,%esp
8010512e:	68 52 80 10 80       	push   $0x80108052
80105133:	e8 38 b2 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	68 34 80 10 80       	push   $0x80108034
80105140:	e8 2b b2 ff ff       	call   80100370 <panic>
80105145:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105150 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
80105155:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105157:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010515a:	89 d3                	mov    %edx,%ebx
8010515c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010515f:	50                   	push   %eax
80105160:	6a 00                	push   $0x0
80105162:	e8 f9 fc ff ff       	call   80104e60 <argint>
80105167:	83 c4 10             	add    $0x10,%esp
8010516a:	85 c0                	test   %eax,%eax
8010516c:	78 32                	js     801051a0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010516e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105172:	77 2c                	ja     801051a0 <argfd.constprop.0+0x50>
80105174:	e8 d7 e9 ff ff       	call   80103b50 <myproc>
80105179:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010517c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105180:	85 c0                	test   %eax,%eax
80105182:	74 1c                	je     801051a0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105184:	85 f6                	test   %esi,%esi
80105186:	74 02                	je     8010518a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105188:	89 16                	mov    %edx,(%esi)
  if(pf)
8010518a:	85 db                	test   %ebx,%ebx
8010518c:	74 22                	je     801051b0 <argfd.constprop.0+0x60>
    *pf = f;
8010518e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105190:	31 c0                	xor    %eax,%eax
}
80105192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5d                   	pop    %ebp
80105198:	c3                   	ret    
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801051a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801051a8:	5b                   	pop    %ebx
801051a9:	5e                   	pop    %esi
801051aa:	5d                   	pop    %ebp
801051ab:	c3                   	ret    
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801051b0:	31 c0                	xor    %eax,%eax
801051b2:	eb de                	jmp    80105192 <argfd.constprop.0+0x42>
801051b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801051c0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801051c0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051c1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	56                   	push   %esi
801051c6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801051ca:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051cd:	e8 7e ff ff ff       	call   80105150 <argfd.constprop.0>
801051d2:	85 c0                	test   %eax,%eax
801051d4:	78 1a                	js     801051f0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051d6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801051d8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801051db:	e8 70 e9 ff ff       	call   80103b50 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801051e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051e4:	85 d2                	test   %edx,%edx
801051e6:	74 18                	je     80105200 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051e8:	83 c3 01             	add    $0x1,%ebx
801051eb:	83 fb 10             	cmp    $0x10,%ebx
801051ee:	75 f0                	jne    801051e0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801051f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801051f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801051f8:	5b                   	pop    %ebx
801051f9:	5e                   	pop    %esi
801051fa:	5d                   	pop    %ebp
801051fb:	c3                   	ret    
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105200:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	ff 75 f4             	pushl  -0xc(%ebp)
8010520a:	e8 71 bf ff ff       	call   80101180 <filedup>
  return fd;
8010520f:	83 c4 10             	add    $0x10,%esp
}
80105212:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105215:	89 d8                	mov    %ebx,%eax
}
80105217:	5b                   	pop    %ebx
80105218:	5e                   	pop    %esi
80105219:	5d                   	pop    %ebp
8010521a:	c3                   	ret    
8010521b:	90                   	nop
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_read>:

int
sys_read(void)
{
80105220:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105221:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105228:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010522b:	e8 20 ff ff ff       	call   80105150 <argfd.constprop.0>
80105230:	85 c0                	test   %eax,%eax
80105232:	78 4c                	js     80105280 <sys_read+0x60>
80105234:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	50                   	push   %eax
8010523b:	6a 02                	push   $0x2
8010523d:	e8 1e fc ff ff       	call   80104e60 <argint>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	85 c0                	test   %eax,%eax
80105247:	78 37                	js     80105280 <sys_read+0x60>
80105249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524c:	83 ec 04             	sub    $0x4,%esp
8010524f:	ff 75 f0             	pushl  -0x10(%ebp)
80105252:	50                   	push   %eax
80105253:	6a 01                	push   $0x1
80105255:	e8 56 fc ff ff       	call   80104eb0 <argptr>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	78 1f                	js     80105280 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105261:	83 ec 04             	sub    $0x4,%esp
80105264:	ff 75 f0             	pushl  -0x10(%ebp)
80105267:	ff 75 f4             	pushl  -0xc(%ebp)
8010526a:	ff 75 ec             	pushl  -0x14(%ebp)
8010526d:	e8 7e c0 ff ff       	call   801012f0 <fileread>
80105272:	83 c4 10             	add    $0x10,%esp
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_write>:

int
sys_write(void)
{
80105290:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105291:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105298:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010529b:	e8 b0 fe ff ff       	call   80105150 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 4c                	js     801052f0 <sys_write+0x60>
801052a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a7:	83 ec 08             	sub    $0x8,%esp
801052aa:	50                   	push   %eax
801052ab:	6a 02                	push   $0x2
801052ad:	e8 ae fb ff ff       	call   80104e60 <argint>
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	85 c0                	test   %eax,%eax
801052b7:	78 37                	js     801052f0 <sys_write+0x60>
801052b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052bc:	83 ec 04             	sub    $0x4,%esp
801052bf:	ff 75 f0             	pushl  -0x10(%ebp)
801052c2:	50                   	push   %eax
801052c3:	6a 01                	push   $0x1
801052c5:	e8 e6 fb ff ff       	call   80104eb0 <argptr>
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	85 c0                	test   %eax,%eax
801052cf:	78 1f                	js     801052f0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801052d1:	83 ec 04             	sub    $0x4,%esp
801052d4:	ff 75 f0             	pushl  -0x10(%ebp)
801052d7:	ff 75 f4             	pushl  -0xc(%ebp)
801052da:	ff 75 ec             	pushl  -0x14(%ebp)
801052dd:	e8 9e c0 ff ff       	call   80101380 <filewrite>
801052e2:	83 c4 10             	add    $0x10,%esp
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_close>:

int
sys_close(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105306:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105309:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010530c:	e8 3f fe ff ff       	call   80105150 <argfd.constprop.0>
80105311:	85 c0                	test   %eax,%eax
80105313:	78 2b                	js     80105340 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105315:	e8 36 e8 ff ff       	call   80103b50 <myproc>
8010531a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010531d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105320:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105327:	00 
  fileclose(f);
80105328:	ff 75 f4             	pushl  -0xc(%ebp)
8010532b:	e8 a0 be ff ff       	call   801011d0 <fileclose>
  return 0;
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	31 c0                	xor    %eax,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105345:	c9                   	leave  
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_fstat>:

int
sys_fstat(void)
{
80105350:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105351:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105353:	89 e5                	mov    %esp,%ebp
80105355:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105358:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010535b:	e8 f0 fd ff ff       	call   80105150 <argfd.constprop.0>
80105360:	85 c0                	test   %eax,%eax
80105362:	78 2c                	js     80105390 <sys_fstat+0x40>
80105364:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105367:	83 ec 04             	sub    $0x4,%esp
8010536a:	6a 14                	push   $0x14
8010536c:	50                   	push   %eax
8010536d:	6a 01                	push   $0x1
8010536f:	e8 3c fb ff ff       	call   80104eb0 <argptr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	78 15                	js     80105390 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010537b:	83 ec 08             	sub    $0x8,%esp
8010537e:	ff 75 f4             	pushl  -0xc(%ebp)
80105381:	ff 75 f0             	pushl  -0x10(%ebp)
80105384:	e8 17 bf ff ff       	call   801012a0 <filestat>
80105389:	83 c4 10             	add    $0x10,%esp
}
8010538c:	c9                   	leave  
8010538d:	c3                   	ret    
8010538e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801053a9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 5c fb ff ff       	call   80104f10 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 fb 00 00 00    	js     801054ba <sys_link+0x11a>
801053bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053c2:	83 ec 08             	sub    $0x8,%esp
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 43 fb ff ff       	call   80104f10 <argstr>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	0f 88 e2 00 00 00    	js     801054ba <sys_link+0x11a>
    return -1;

  begin_op();
801053d8:	e8 03 db ff ff       	call   80102ee0 <begin_op>
  if((ip = namei(old)) == 0){
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053e3:	e8 68 ce ff ff       	call   80102250 <namei>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	85 c0                	test   %eax,%eax
801053ed:	89 c3                	mov    %eax,%ebx
801053ef:	0f 84 f3 00 00 00    	je     801054e8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	50                   	push   %eax
801053f9:	e8 02 c6 ff ff       	call   80101a00 <ilock>
  if(ip->type == T_DIR){
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105406:	0f 84 c4 00 00 00    	je     801054d0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010540c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105411:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105414:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105417:	53                   	push   %ebx
80105418:	e8 33 c5 ff ff       	call   80101950 <iupdate>
  iunlock(ip);
8010541d:	89 1c 24             	mov    %ebx,(%esp)
80105420:	e8 bb c6 ff ff       	call   80101ae0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105425:	58                   	pop    %eax
80105426:	5a                   	pop    %edx
80105427:	57                   	push   %edi
80105428:	ff 75 d0             	pushl  -0x30(%ebp)
8010542b:	e8 40 ce ff ff       	call   80102270 <nameiparent>
80105430:	83 c4 10             	add    $0x10,%esp
80105433:	85 c0                	test   %eax,%eax
80105435:	89 c6                	mov    %eax,%esi
80105437:	74 5b                	je     80105494 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	50                   	push   %eax
8010543d:	e8 be c5 ff ff       	call   80101a00 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	8b 03                	mov    (%ebx),%eax
80105447:	39 06                	cmp    %eax,(%esi)
80105449:	75 3d                	jne    80105488 <sys_link+0xe8>
8010544b:	83 ec 04             	sub    $0x4,%esp
8010544e:	ff 73 04             	pushl  0x4(%ebx)
80105451:	57                   	push   %edi
80105452:	56                   	push   %esi
80105453:	e8 38 cd ff ff       	call   80102190 <dirlink>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	85 c0                	test   %eax,%eax
8010545d:	78 29                	js     80105488 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	56                   	push   %esi
80105463:	e8 28 c8 ff ff       	call   80101c90 <iunlockput>
  iput(ip);
80105468:	89 1c 24             	mov    %ebx,(%esp)
8010546b:	e8 c0 c6 ff ff       	call   80101b30 <iput>

  end_op();
80105470:	e8 db da ff ff       	call   80102f50 <end_op>

  return 0;
80105475:	83 c4 10             	add    $0x10,%esp
80105478:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010547a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010547d:	5b                   	pop    %ebx
8010547e:	5e                   	pop    %esi
8010547f:	5f                   	pop    %edi
80105480:	5d                   	pop    %ebp
80105481:	c3                   	ret    
80105482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	56                   	push   %esi
8010548c:	e8 ff c7 ff ff       	call   80101c90 <iunlockput>
    goto bad;
80105491:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105494:	83 ec 0c             	sub    $0xc,%esp
80105497:	53                   	push   %ebx
80105498:	e8 63 c5 ff ff       	call   80101a00 <ilock>
  ip->nlink--;
8010549d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054a2:	89 1c 24             	mov    %ebx,(%esp)
801054a5:	e8 a6 c4 ff ff       	call   80101950 <iupdate>
  iunlockput(ip);
801054aa:	89 1c 24             	mov    %ebx,(%esp)
801054ad:	e8 de c7 ff ff       	call   80101c90 <iunlockput>
  end_op();
801054b2:	e8 99 da ff ff       	call   80102f50 <end_op>
  return -1;
801054b7:	83 c4 10             	add    $0x10,%esp
}
801054ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801054bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054c2:	5b                   	pop    %ebx
801054c3:	5e                   	pop    %esi
801054c4:	5f                   	pop    %edi
801054c5:	5d                   	pop    %ebp
801054c6:	c3                   	ret    
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	53                   	push   %ebx
801054d4:	e8 b7 c7 ff ff       	call   80101c90 <iunlockput>
    end_op();
801054d9:	e8 72 da ff ff       	call   80102f50 <end_op>
    return -1;
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e6:	eb 92                	jmp    8010547a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801054e8:	e8 63 da ff ff       	call   80102f50 <end_op>
    return -1;
801054ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f2:	eb 86                	jmp    8010547a <sys_link+0xda>
801054f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105500 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105506:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105509:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010550c:	50                   	push   %eax
8010550d:	6a 00                	push   $0x0
8010550f:	e8 fc f9 ff ff       	call   80104f10 <argstr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	0f 88 82 01 00 00    	js     801056a1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010551f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105522:	e8 b9 d9 ff ff       	call   80102ee0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105527:	83 ec 08             	sub    $0x8,%esp
8010552a:	53                   	push   %ebx
8010552b:	ff 75 c0             	pushl  -0x40(%ebp)
8010552e:	e8 3d cd ff ff       	call   80102270 <nameiparent>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010553b:	0f 84 6a 01 00 00    	je     801056ab <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105541:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	56                   	push   %esi
80105548:	e8 b3 c4 ff ff       	call   80101a00 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010554d:	58                   	pop    %eax
8010554e:	5a                   	pop    %edx
8010554f:	68 50 80 10 80       	push   $0x80108050
80105554:	53                   	push   %ebx
80105555:	e8 b6 c9 ff ff       	call   80101f10 <namecmp>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 84 fc 00 00 00    	je     80105661 <sys_unlink+0x161>
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	68 4f 80 10 80       	push   $0x8010804f
8010556d:	53                   	push   %ebx
8010556e:	e8 9d c9 ff ff       	call   80101f10 <namecmp>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	0f 84 e3 00 00 00    	je     80105661 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010557e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105581:	83 ec 04             	sub    $0x4,%esp
80105584:	50                   	push   %eax
80105585:	53                   	push   %ebx
80105586:	56                   	push   %esi
80105587:	e8 a4 c9 ff ff       	call   80101f30 <dirlookup>
8010558c:	83 c4 10             	add    $0x10,%esp
8010558f:	85 c0                	test   %eax,%eax
80105591:	89 c3                	mov    %eax,%ebx
80105593:	0f 84 c8 00 00 00    	je     80105661 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105599:	83 ec 0c             	sub    $0xc,%esp
8010559c:	50                   	push   %eax
8010559d:	e8 5e c4 ff ff       	call   80101a00 <ilock>

  if(ip->nlink < 1)
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055aa:	0f 8e 24 01 00 00    	jle    801056d4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055b5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801055b8:	74 66                	je     80105620 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055ba:	83 ec 04             	sub    $0x4,%esp
801055bd:	6a 10                	push   $0x10
801055bf:	6a 00                	push   $0x0
801055c1:	56                   	push   %esi
801055c2:	e8 89 f5 ff ff       	call   80104b50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055c7:	6a 10                	push   $0x10
801055c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801055cc:	56                   	push   %esi
801055cd:	ff 75 b4             	pushl  -0x4c(%ebp)
801055d0:	e8 0b c8 ff ff       	call   80101de0 <writei>
801055d5:	83 c4 20             	add    $0x20,%esp
801055d8:	83 f8 10             	cmp    $0x10,%eax
801055db:	0f 85 e6 00 00 00    	jne    801056c7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055e6:	0f 84 9c 00 00 00    	je     80105688 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	ff 75 b4             	pushl  -0x4c(%ebp)
801055f2:	e8 99 c6 ff ff       	call   80101c90 <iunlockput>

  ip->nlink--;
801055f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055fc:	89 1c 24             	mov    %ebx,(%esp)
801055ff:	e8 4c c3 ff ff       	call   80101950 <iupdate>
  iunlockput(ip);
80105604:	89 1c 24             	mov    %ebx,(%esp)
80105607:	e8 84 c6 ff ff       	call   80101c90 <iunlockput>

  end_op();
8010560c:	e8 3f d9 ff ff       	call   80102f50 <end_op>

  return 0;
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105619:	5b                   	pop    %ebx
8010561a:	5e                   	pop    %esi
8010561b:	5f                   	pop    %edi
8010561c:	5d                   	pop    %ebp
8010561d:	c3                   	ret    
8010561e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105620:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105624:	76 94                	jbe    801055ba <sys_unlink+0xba>
80105626:	bf 20 00 00 00       	mov    $0x20,%edi
8010562b:	eb 0f                	jmp    8010563c <sys_unlink+0x13c>
8010562d:	8d 76 00             	lea    0x0(%esi),%esi
80105630:	83 c7 10             	add    $0x10,%edi
80105633:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105636:	0f 83 7e ff ff ff    	jae    801055ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010563c:	6a 10                	push   $0x10
8010563e:	57                   	push   %edi
8010563f:	56                   	push   %esi
80105640:	53                   	push   %ebx
80105641:	e8 9a c6 ff ff       	call   80101ce0 <readi>
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	83 f8 10             	cmp    $0x10,%eax
8010564c:	75 6c                	jne    801056ba <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010564e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105653:	74 db                	je     80105630 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105655:	83 ec 0c             	sub    $0xc,%esp
80105658:	53                   	push   %ebx
80105659:	e8 32 c6 ff ff       	call   80101c90 <iunlockput>
    goto bad;
8010565e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105661:	83 ec 0c             	sub    $0xc,%esp
80105664:	ff 75 b4             	pushl  -0x4c(%ebp)
80105667:	e8 24 c6 ff ff       	call   80101c90 <iunlockput>
  end_op();
8010566c:	e8 df d8 ff ff       	call   80102f50 <end_op>
  return -1;
80105671:	83 c4 10             	add    $0x10,%esp
}
80105674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567c:	5b                   	pop    %ebx
8010567d:	5e                   	pop    %esi
8010567e:	5f                   	pop    %edi
8010567f:	5d                   	pop    %ebp
80105680:	c3                   	ret    
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105688:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010568b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010568e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105693:	50                   	push   %eax
80105694:	e8 b7 c2 ff ff       	call   80101950 <iupdate>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	e9 4b ff ff ff       	jmp    801055ec <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a6:	e9 6b ff ff ff       	jmp    80105616 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801056ab:	e8 a0 d8 ff ff       	call   80102f50 <end_op>
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b5:	e9 5c ff ff ff       	jmp    80105616 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	68 74 80 10 80       	push   $0x80108074
801056c2:	e8 a9 ac ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801056c7:	83 ec 0c             	sub    $0xc,%esp
801056ca:	68 86 80 10 80       	push   $0x80108086
801056cf:	e8 9c ac ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801056d4:	83 ec 0c             	sub    $0xc,%esp
801056d7:	68 62 80 10 80       	push   $0x80108062
801056dc:	e8 8f ac ff ff       	call   80100370 <panic>
801056e1:	eb 0d                	jmp    801056f0 <sys_open>
801056e3:	90                   	nop
801056e4:	90                   	nop
801056e5:	90                   	nop
801056e6:	90                   	nop
801056e7:	90                   	nop
801056e8:	90                   	nop
801056e9:	90                   	nop
801056ea:	90                   	nop
801056eb:	90                   	nop
801056ec:	90                   	nop
801056ed:	90                   	nop
801056ee:	90                   	nop
801056ef:	90                   	nop

801056f0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801056f9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056fc:	50                   	push   %eax
801056fd:	6a 00                	push   $0x0
801056ff:	e8 0c f8 ff ff       	call   80104f10 <argstr>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	0f 88 9e 00 00 00    	js     801057ad <sys_open+0xbd>
8010570f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105712:	83 ec 08             	sub    $0x8,%esp
80105715:	50                   	push   %eax
80105716:	6a 01                	push   $0x1
80105718:	e8 43 f7 ff ff       	call   80104e60 <argint>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	0f 88 85 00 00 00    	js     801057ad <sys_open+0xbd>
    return -1;

  begin_op();
80105728:	e8 b3 d7 ff ff       	call   80102ee0 <begin_op>

  if(omode & O_CREATE){
8010572d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105731:	0f 85 89 00 00 00    	jne    801057c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105737:	83 ec 0c             	sub    $0xc,%esp
8010573a:	ff 75 e0             	pushl  -0x20(%ebp)
8010573d:	e8 0e cb ff ff       	call   80102250 <namei>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	89 c6                	mov    %eax,%esi
80105749:	0f 84 8e 00 00 00    	je     801057dd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010574f:	83 ec 0c             	sub    $0xc,%esp
80105752:	50                   	push   %eax
80105753:	e8 a8 c2 ff ff       	call   80101a00 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105760:	0f 84 d2 00 00 00    	je     80105838 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105766:	e8 a5 b9 ff ff       	call   80101110 <filealloc>
8010576b:	85 c0                	test   %eax,%eax
8010576d:	89 c7                	mov    %eax,%edi
8010576f:	74 2b                	je     8010579c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105771:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105773:	e8 d8 e3 ff ff       	call   80103b50 <myproc>
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105780:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105784:	85 d2                	test   %edx,%edx
80105786:	74 68                	je     801057f0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105788:	83 c3 01             	add    $0x1,%ebx
8010578b:	83 fb 10             	cmp    $0x10,%ebx
8010578e:	75 f0                	jne    80105780 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	57                   	push   %edi
80105794:	e8 37 ba ff ff       	call   801011d0 <fileclose>
80105799:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	56                   	push   %esi
801057a0:	e8 eb c4 ff ff       	call   80101c90 <iunlockput>
    end_op();
801057a5:	e8 a6 d7 ff ff       	call   80102f50 <end_op>
    return -1;
801057aa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801057ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801057b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801057b5:	5b                   	pop    %ebx
801057b6:	5e                   	pop    %esi
801057b7:	5f                   	pop    %edi
801057b8:	5d                   	pop    %ebp
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057c6:	31 c9                	xor    %ecx,%ecx
801057c8:	6a 00                	push   $0x0
801057ca:	ba 02 00 00 00       	mov    $0x2,%edx
801057cf:	e8 dc f7 ff ff       	call   80104fb0 <create>
    if(ip == 0){
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057db:	75 89                	jne    80105766 <sys_open+0x76>
      end_op();
801057dd:	e8 6e d7 ff ff       	call   80102f50 <end_op>
      return -1;
801057e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e7:	eb 43                	jmp    8010582c <sys_open+0x13c>
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801057f3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057f7:	56                   	push   %esi
801057f8:	e8 e3 c2 ff ff       	call   80101ae0 <iunlock>
  end_op();
801057fd:	e8 4e d7 ff ff       	call   80102f50 <end_op>

  f->type = FD_INODE;
80105802:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010580b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010580e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105811:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105818:	89 d0                	mov    %edx,%eax
8010581a:	83 e0 01             	and    $0x1,%eax
8010581d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105820:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105823:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105826:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010582a:	89 d8                	mov    %ebx,%eax
}
8010582c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010582f:	5b                   	pop    %ebx
80105830:	5e                   	pop    %esi
80105831:	5f                   	pop    %edi
80105832:	5d                   	pop    %ebp
80105833:	c3                   	ret    
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105838:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010583b:	85 c9                	test   %ecx,%ecx
8010583d:	0f 84 23 ff ff ff    	je     80105766 <sys_open+0x76>
80105843:	e9 54 ff ff ff       	jmp    8010579c <sys_open+0xac>
80105848:	90                   	nop
80105849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105856:	e8 85 d6 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010585b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585e:	83 ec 08             	sub    $0x8,%esp
80105861:	50                   	push   %eax
80105862:	6a 00                	push   $0x0
80105864:	e8 a7 f6 ff ff       	call   80104f10 <argstr>
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	85 c0                	test   %eax,%eax
8010586e:	78 30                	js     801058a0 <sys_mkdir+0x50>
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105876:	31 c9                	xor    %ecx,%ecx
80105878:	6a 00                	push   $0x0
8010587a:	ba 01 00 00 00       	mov    $0x1,%edx
8010587f:	e8 2c f7 ff ff       	call   80104fb0 <create>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	74 15                	je     801058a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010588b:	83 ec 0c             	sub    $0xc,%esp
8010588e:	50                   	push   %eax
8010588f:	e8 fc c3 ff ff       	call   80101c90 <iunlockput>
  end_op();
80105894:	e8 b7 d6 ff ff       	call   80102f50 <end_op>
  return 0;
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	31 c0                	xor    %eax,%eax
}
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801058a0:	e8 ab d6 ff ff       	call   80102f50 <end_op>
    return -1;
801058a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801058aa:	c9                   	leave  
801058ab:	c3                   	ret    
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_mknod>:

int
sys_mknod(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058b6:	e8 25 d6 ff ff       	call   80102ee0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058be:	83 ec 08             	sub    $0x8,%esp
801058c1:	50                   	push   %eax
801058c2:	6a 00                	push   $0x0
801058c4:	e8 47 f6 ff ff       	call   80104f10 <argstr>
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	85 c0                	test   %eax,%eax
801058ce:	78 60                	js     80105930 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d3:	83 ec 08             	sub    $0x8,%esp
801058d6:	50                   	push   %eax
801058d7:	6a 01                	push   $0x1
801058d9:	e8 82 f5 ff ff       	call   80104e60 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 4b                	js     80105930 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801058e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e8:	83 ec 08             	sub    $0x8,%esp
801058eb:	50                   	push   %eax
801058ec:	6a 02                	push   $0x2
801058ee:	e8 6d f5 ff ff       	call   80104e60 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 36                	js     80105930 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058fe:	83 ec 0c             	sub    $0xc,%esp
80105901:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105905:	ba 03 00 00 00       	mov    $0x3,%edx
8010590a:	50                   	push   %eax
8010590b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010590e:	e8 9d f6 ff ff       	call   80104fb0 <create>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	85 c0                	test   %eax,%eax
80105918:	74 16                	je     80105930 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010591a:	83 ec 0c             	sub    $0xc,%esp
8010591d:	50                   	push   %eax
8010591e:	e8 6d c3 ff ff       	call   80101c90 <iunlockput>
  end_op();
80105923:	e8 28 d6 ff ff       	call   80102f50 <end_op>
  return 0;
80105928:	83 c4 10             	add    $0x10,%esp
8010592b:	31 c0                	xor    %eax,%eax
}
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    
8010592f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105930:	e8 1b d6 ff ff       	call   80102f50 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_chdir>:

int
sys_chdir(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105948:	e8 03 e2 ff ff       	call   80103b50 <myproc>
8010594d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010594f:	e8 8c d5 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	83 ec 08             	sub    $0x8,%esp
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 ae f5 ff ff       	call   80104f10 <argstr>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 77                	js     801059e0 <sys_chdir+0xa0>
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	ff 75 f4             	pushl  -0xc(%ebp)
8010596f:	e8 dc c8 ff ff       	call   80102250 <namei>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	89 c3                	mov    %eax,%ebx
8010597b:	74 63                	je     801059e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	50                   	push   %eax
80105981:	e8 7a c0 ff ff       	call   80101a00 <ilock>
  if(ip->type != T_DIR){
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010598e:	75 30                	jne    801059c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	53                   	push   %ebx
80105994:	e8 47 c1 ff ff       	call   80101ae0 <iunlock>
  iput(curproc->cwd);
80105999:	58                   	pop    %eax
8010599a:	ff 76 68             	pushl  0x68(%esi)
8010599d:	e8 8e c1 ff ff       	call   80101b30 <iput>
  end_op();
801059a2:	e8 a9 d5 ff ff       	call   80102f50 <end_op>
  curproc->cwd = ip;
801059a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	31 c0                	xor    %eax,%eax
}
801059af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059b2:	5b                   	pop    %ebx
801059b3:	5e                   	pop    %esi
801059b4:	5d                   	pop    %ebp
801059b5:	c3                   	ret    
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	53                   	push   %ebx
801059c4:	e8 c7 c2 ff ff       	call   80101c90 <iunlockput>
    end_op();
801059c9:	e8 82 d5 ff ff       	call   80102f50 <end_op>
    return -1;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d6:	eb d7                	jmp    801059af <sys_chdir+0x6f>
801059d8:	90                   	nop
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801059e0:	e8 6b d5 ff ff       	call   80102f50 <end_op>
    return -1;
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ea:	eb c3                	jmp    801059af <sys_chdir+0x6f>
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801059fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a02:	50                   	push   %eax
80105a03:	6a 00                	push   $0x0
80105a05:	e8 06 f5 ff ff       	call   80104f10 <argstr>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	78 7f                	js     80105a90 <sys_exec+0xa0>
80105a11:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a17:	83 ec 08             	sub    $0x8,%esp
80105a1a:	50                   	push   %eax
80105a1b:	6a 01                	push   $0x1
80105a1d:	e8 3e f4 ff ff       	call   80104e60 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	78 67                	js     80105a90 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a29:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a2f:	83 ec 04             	sub    $0x4,%esp
80105a32:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a38:	68 80 00 00 00       	push   $0x80
80105a3d:	6a 00                	push   $0x0
80105a3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a45:	50                   	push   %eax
80105a46:	31 db                	xor    %ebx,%ebx
80105a48:	e8 03 f1 ff ff       	call   80104b50 <memset>
80105a4d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a50:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a56:	83 ec 08             	sub    $0x8,%esp
80105a59:	57                   	push   %edi
80105a5a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a5d:	50                   	push   %eax
80105a5e:	e8 5d f3 ff ff       	call   80104dc0 <fetchint>
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 26                	js     80105a90 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105a6a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a70:	85 c0                	test   %eax,%eax
80105a72:	74 2c                	je     80105aa0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a74:	83 ec 08             	sub    $0x8,%esp
80105a77:	56                   	push   %esi
80105a78:	50                   	push   %eax
80105a79:	e8 82 f3 ff ff       	call   80104e00 <fetchstr>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 0b                	js     80105a90 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105a85:	83 c3 01             	add    $0x1,%ebx
80105a88:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105a8b:	83 fb 20             	cmp    $0x20,%ebx
80105a8e:	75 c0                	jne    80105a50 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a98:	5b                   	pop    %ebx
80105a99:	5e                   	pop    %esi
80105a9a:	5f                   	pop    %edi
80105a9b:	5d                   	pop    %ebp
80105a9c:	c3                   	ret    
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105aa0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105aa6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105aa9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ab0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105ab4:	50                   	push   %eax
80105ab5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105abb:	e8 30 af ff ff       	call   801009f0 <exec>
80105ac0:	83 c4 10             	add    $0x10,%esp
}
80105ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ac6:	5b                   	pop    %ebx
80105ac7:	5e                   	pop    %esi
80105ac8:	5f                   	pop    %edi
80105ac9:	5d                   	pop    %ebp
80105aca:	c3                   	ret    
80105acb:	90                   	nop
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_exec2>:


int
sys_exec2(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ad6:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
80105adc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ae2:	50                   	push   %eax
80105ae3:	6a 00                	push   $0x0
80105ae5:	e8 26 f4 ff ff       	call   80104f10 <argstr>
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	85 c0                	test   %eax,%eax
80105aef:	78 7f                	js     80105b70 <sys_exec2+0xa0>
80105af1:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105af7:	83 ec 08             	sub    $0x8,%esp
80105afa:	50                   	push   %eax
80105afb:	6a 01                	push   $0x1
80105afd:	e8 5e f3 ff ff       	call   80104e60 <argint>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 67                	js     80105b70 <sys_exec2+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b09:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b0f:	83 ec 04             	sub    $0x4,%esp
80105b12:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105b18:	68 80 00 00 00       	push   $0x80
80105b1d:	6a 00                	push   $0x0
80105b1f:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105b25:	50                   	push   %eax
80105b26:	31 db                	xor    %ebx,%ebx
80105b28:	e8 23 f0 ff ff       	call   80104b50 <memset>
80105b2d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b30:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105b36:	83 ec 08             	sub    $0x8,%esp
80105b39:	57                   	push   %edi
80105b3a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105b3d:	50                   	push   %eax
80105b3e:	e8 7d f2 ff ff       	call   80104dc0 <fetchint>
80105b43:	83 c4 10             	add    $0x10,%esp
80105b46:	85 c0                	test   %eax,%eax
80105b48:	78 26                	js     80105b70 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
80105b4a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b50:	85 c0                	test   %eax,%eax
80105b52:	74 2c                	je     80105b80 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b54:	83 ec 08             	sub    $0x8,%esp
80105b57:	56                   	push   %esi
80105b58:	50                   	push   %eax
80105b59:	e8 a2 f2 ff ff       	call   80104e00 <fetchstr>
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	85 c0                	test   %eax,%eax
80105b63:	78 0b                	js     80105b70 <sys_exec2+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105b65:	83 c3 01             	add    $0x1,%ebx
80105b68:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105b6b:	83 fb 20             	cmp    $0x20,%ebx
80105b6e:	75 c0                	jne    80105b30 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105b78:	5b                   	pop    %ebx
80105b79:	5e                   	pop    %esi
80105b7a:	5f                   	pop    %edi
80105b7b:	5d                   	pop    %ebp
80105b7c:	c3                   	ret    
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105b80:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105b86:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105b89:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b90:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105b94:	50                   	push   %eax
80105b95:	6a 02                	push   $0x2
80105b97:	e8 c4 f2 ff ff       	call   80104e60 <argint>
80105b9c:	83 c4 10             	add    $0x10,%esp
80105b9f:	85 c0                	test   %eax,%eax
80105ba1:	78 cd                	js     80105b70 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105ba3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ba9:	83 ec 04             	sub    $0x4,%esp
80105bac:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105bb2:	50                   	push   %eax
80105bb3:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105bb9:	e8 92 b1 ff ff       	call   80100d50 <exec2>
80105bbe:	83 c4 10             	add    $0x10,%esp
}
80105bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc4:	5b                   	pop    %ebx
80105bc5:	5e                   	pop    %esi
80105bc6:	5f                   	pop    %edi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_pipe>:

int
sys_pipe(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bd6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105bd9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bdc:	6a 08                	push   $0x8
80105bde:	50                   	push   %eax
80105bdf:	6a 00                	push   $0x0
80105be1:	e8 ca f2 ff ff       	call   80104eb0 <argptr>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	78 4a                	js     80105c37 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105bed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	50                   	push   %eax
80105bf4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bf7:	50                   	push   %eax
80105bf8:	e8 83 d9 ff ff       	call   80103580 <pipealloc>
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	85 c0                	test   %eax,%eax
80105c02:	78 33                	js     80105c37 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c04:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c06:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105c09:	e8 42 df ff ff       	call   80103b50 <myproc>
80105c0e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105c10:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c14:	85 f6                	test   %esi,%esi
80105c16:	74 30                	je     80105c48 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c18:	83 c3 01             	add    $0x1,%ebx
80105c1b:	83 fb 10             	cmp    $0x10,%ebx
80105c1e:	75 f0                	jne    80105c10 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	ff 75 e0             	pushl  -0x20(%ebp)
80105c26:	e8 a5 b5 ff ff       	call   801011d0 <fileclose>
    fileclose(wf);
80105c2b:	58                   	pop    %eax
80105c2c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c2f:	e8 9c b5 ff ff       	call   801011d0 <fileclose>
    return -1;
80105c34:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105c3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c3f:	5b                   	pop    %ebx
80105c40:	5e                   	pop    %esi
80105c41:	5f                   	pop    %edi
80105c42:	5d                   	pop    %ebp
80105c43:	c3                   	ret    
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105c48:	8d 73 08             	lea    0x8(%ebx),%esi
80105c4b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c4f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105c52:	e8 f9 de ff ff       	call   80103b50 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105c57:	31 d2                	xor    %edx,%edx
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105c60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c64:	85 c9                	test   %ecx,%ecx
80105c66:	74 18                	je     80105c80 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c68:	83 c2 01             	add    $0x1,%edx
80105c6b:	83 fa 10             	cmp    $0x10,%edx
80105c6e:	75 f0                	jne    80105c60 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105c70:	e8 db de ff ff       	call   80103b50 <myproc>
80105c75:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c7c:	00 
80105c7d:	eb a1                	jmp    80105c20 <sys_pipe+0x50>
80105c7f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105c80:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c87:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c8c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105c8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105c92:	31 c0                	xor    %eax,%eax
}
80105c94:	5b                   	pop    %ebx
80105c95:	5e                   	pop    %esi
80105c96:	5f                   	pop    %edi
80105c97:	5d                   	pop    %ebp
80105c98:	c3                   	ret    
80105c99:	66 90                	xchg   %ax,%ax
80105c9b:	66 90                	xchg   %ax,%ax
80105c9d:	66 90                	xchg   %ax,%ax
80105c9f:	90                   	nop

80105ca0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ca3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ca4:	e9 57 e0 ff ff       	jmp    80103d00 <fork>
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_exit>:
}

int
sys_exit(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cb6:	e8 45 e3 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105cbb:	31 c0                	xor    %eax,%eax
80105cbd:	c9                   	leave  
80105cbe:	c3                   	ret    
80105cbf:	90                   	nop

80105cc0 <sys_wait>:

int
sys_wait(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105cc3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105cc4:	e9 47 e8 ff ff       	jmp    80104510 <wait>
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_kill>:
}

int
sys_kill(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 00                	push   $0x0
80105cdc:	e8 7f f1 ff ff       	call   80104e60 <argint>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	78 18                	js     80105d00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cee:	e8 7d e9 ff ff       	call   80104670 <kill>
80105cf3:	83 c4 10             	add    $0x10,%esp
}
80105cf6:	c9                   	leave  
80105cf7:	c3                   	ret    
80105cf8:	90                   	nop
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <sys_getpid>:

int
sys_getpid(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d16:	e8 35 de ff ff       	call   80103b50 <myproc>
80105d1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d1e:	c9                   	leave  
80105d1f:	c3                   	ret    

80105d20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105d27:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 2e f1 ff ff       	call   80104e60 <argint>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 27                	js     80105d60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d39:	e8 12 de ff ff       	call   80103b50 <myproc>
  if(growproc(n) < 0)
80105d3e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105d41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d43:	ff 75 f4             	pushl  -0xc(%ebp)
80105d46:	e8 25 df ff ff       	call   80103c70 <growproc>
80105d4b:	83 c4 10             	add    $0x10,%esp
80105d4e:	85 c0                	test   %eax,%eax
80105d50:	78 0e                	js     80105d60 <sys_sbrk+0x40>
    return -1;
  return addr;
80105d52:	89 d8                	mov    %ebx,%eax
}
80105d54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d57:	c9                   	leave  
80105d58:	c3                   	ret    
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d65:	eb ed                	jmp    80105d54 <sys_sbrk+0x34>
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
80105d74:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105d77:	e8 d4 dd ff ff       	call   80103b50 <myproc>
80105d7c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105d83:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105d86:	e8 c5 dd ff ff       	call   80103b50 <myproc>
80105d8b:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105d92:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105d95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	50                   	push   %eax
80105d9c:	6a 00                	push   $0x0
80105d9e:	e8 bd f0 ff ff       	call   80104e60 <argint>
80105da3:	83 c4 10             	add    $0x10,%esp
80105da6:	85 c0                	test   %eax,%eax
80105da8:	0f 88 89 00 00 00    	js     80105e37 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105dae:	83 ec 0c             	sub    $0xc,%esp
80105db1:	68 60 62 11 80       	push   $0x80116260
80105db6:	e8 95 ec ff ff       	call   80104a50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dbe:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105dc1:	8b 1d a0 6a 11 80    	mov    0x80116aa0,%ebx
  while(ticks - ticks0 < n){
80105dc7:	85 d2                	test   %edx,%edx
80105dc9:	75 26                	jne    80105df1 <sys_sleep+0x81>
80105dcb:	eb 53                	jmp    80105e20 <sys_sleep+0xb0>
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105dd0:	83 ec 08             	sub    $0x8,%esp
80105dd3:	68 60 62 11 80       	push   $0x80116260
80105dd8:	68 a0 6a 11 80       	push   $0x80116aa0
80105ddd:	e8 6e e6 ff ff       	call   80104450 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105de2:	a1 a0 6a 11 80       	mov    0x80116aa0,%eax
80105de7:	83 c4 10             	add    $0x10,%esp
80105dea:	29 d8                	sub    %ebx,%eax
80105dec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105def:	73 2f                	jae    80105e20 <sys_sleep+0xb0>
    if(myproc()->killed){
80105df1:	e8 5a dd ff ff       	call   80103b50 <myproc>
80105df6:	8b 40 24             	mov    0x24(%eax),%eax
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	74 d3                	je     80105dd0 <sys_sleep+0x60>
      release(&tickslock);
80105dfd:	83 ec 0c             	sub    $0xc,%esp
80105e00:	68 60 62 11 80       	push   $0x80116260
80105e05:	e8 f6 ec ff ff       	call   80104b00 <release>
      return -1;
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
80105e17:	89 f6                	mov    %esi,%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105e20:	83 ec 0c             	sub    $0xc,%esp
80105e23:	68 60 62 11 80       	push   $0x80116260
80105e28:	e8 d3 ec ff ff       	call   80104b00 <release>
  return 0;
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	31 c0                	xor    %eax,%eax
}
80105e32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80105e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3c:	eb d4                	jmp    80105e12 <sys_sleep+0xa2>
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	53                   	push   %ebx
80105e44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e47:	68 60 62 11 80       	push   $0x80116260
80105e4c:	e8 ff eb ff ff       	call   80104a50 <acquire>
  xticks = ticks;
80105e51:	8b 1d a0 6a 11 80    	mov    0x80116aa0,%ebx
  release(&tickslock);
80105e57:	c7 04 24 60 62 11 80 	movl   $0x80116260,(%esp)
80105e5e:	e8 9d ec ff ff       	call   80104b00 <release>
  return xticks;
}
80105e63:	89 d8                	mov    %ebx,%eax
80105e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e68:	c9                   	leave  
80105e69:	c3                   	ret    
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e70 <sys_yield>:

void 
sys_yield()
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80105e76:	e8 d5 dc ff ff       	call   80103b50 <myproc>
80105e7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105e82:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
80105e85:	e8 c6 dc ff ff       	call   80103b50 <myproc>
80105e8a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105e91:	00 00 00 
  yield();
}
80105e94:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
80105e95:	e9 96 e2 ff ff       	jmp    80104130 <yield>
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ea0 <sys_getlev>:
}

int             
sys_getlev(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
  return getlev();
}
80105ea3:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
80105ea4:	e9 d7 e2 ff ff       	jmp    80104180 <getlev>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105eb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	6a 00                	push   $0x0
80105ebc:	e8 9f ef ff ff       	call   80104e60 <argint>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	78 28                	js     80105ef0 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
80105ec8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ecb:	83 ec 08             	sub    $0x8,%esp
80105ece:	50                   	push   %eax
80105ecf:	6a 01                	push   $0x1
80105ed1:	e8 8a ef ff ff       	call   80104e60 <argint>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	78 23                	js     80105f00 <sys_setpriority+0x50>
	return setpriority(pid,priority);
80105edd:	83 ec 08             	sub    $0x8,%esp
80105ee0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ee3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ee6:	e8 a5 e4 ff ff       	call   80104390 <setpriority>
80105eeb:	83 c4 10             	add    $0x10,%esp
}
80105eee:	c9                   	leave  
80105eef:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
80105f00:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
80105f05:	c9                   	leave  
80105f06:	c3                   	ret    
80105f07:	89 f6                	mov    %esi,%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f10 <sys_getadmin>:


int
sys_getadmin(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105f16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f19:	50                   	push   %eax
80105f1a:	6a 00                	push   $0x0
80105f1c:	e8 ef ef ff ff       	call   80104f10 <argstr>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	78 18                	js     80105f40 <sys_getadmin+0x30>
  return getadmin(student_number);
80105f28:	83 ec 0c             	sub    $0xc,%esp
80105f2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f2e:	e8 7d e2 ff ff       	call   801041b0 <getadmin>
80105f33:	83 c4 10             	add    $0x10,%esp
}
80105f36:	c9                   	leave  
80105f37:	c3                   	ret    
80105f38:	90                   	nop
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <sys_setmemorylimit>:

int
sys_setmemorylimit(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	83 ec 20             	sub    $0x20,%esp
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80105f56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f59:	50                   	push   %eax
80105f5a:	6a 00                	push   $0x0
80105f5c:	e8 ff ee ff ff       	call   80104e60 <argint>
80105f61:	83 c4 10             	add    $0x10,%esp
80105f64:	85 c0                	test   %eax,%eax
80105f66:	78 28                	js     80105f90 <sys_setmemorylimit+0x40>
80105f68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f6b:	83 ec 08             	sub    $0x8,%esp
80105f6e:	50                   	push   %eax
80105f6f:	6a 01                	push   $0x1
80105f71:	e8 ea ee ff ff       	call   80104e60 <argint>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	78 13                	js     80105f90 <sys_setmemorylimit+0x40>
  return setmemorylimit(pid,limit);
80105f7d:	83 ec 08             	sub    $0x8,%esp
80105f80:	ff 75 f4             	pushl  -0xc(%ebp)
80105f83:	ff 75 f0             	pushl  -0x10(%ebp)
80105f86:	e8 a5 e2 ff ff       	call   80104230 <setmemorylimit>
80105f8b:	83 c4 10             	add    $0x10,%esp
}
80105f8e:	c9                   	leave  
80105f8f:	c3                   	ret    

int
sys_setmemorylimit(void)
{
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80105f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return setmemorylimit(pid,limit);
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fa0 <sys_list>:

int
sys_list(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
  return list();
80105fa3:	5d                   	pop    %ebp
}

int
sys_list(void)
{
  return list();
80105fa4:	e9 27 e3 ff ff       	jmp    801042d0 <list>

80105fa9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105fa9:	1e                   	push   %ds
  pushl %es
80105faa:	06                   	push   %es
  pushl %fs
80105fab:	0f a0                	push   %fs
  pushl %gs
80105fad:	0f a8                	push   %gs
  pushal
80105faf:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105fb0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105fb4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105fb6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fb8:	54                   	push   %esp
  call trap
80105fb9:	e8 e2 00 00 00       	call   801060a0 <trap>
  addl $4, %esp
80105fbe:	83 c4 04             	add    $0x4,%esp

80105fc1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105fc1:	61                   	popa   
  popl %gs
80105fc2:	0f a9                	pop    %gs
  popl %fs
80105fc4:	0f a1                	pop    %fs
  popl %es
80105fc6:	07                   	pop    %es
  popl %ds
80105fc7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fc8:	83 c4 08             	add    $0x8,%esp
  iret
80105fcb:	cf                   	iret   
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105fd0:	31 c0                	xor    %eax,%eax
80105fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fd8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105fdf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105fe4:	c6 04 c5 a4 62 11 80 	movb   $0x0,-0x7fee9d5c(,%eax,8)
80105feb:	00 
80105fec:	66 89 0c c5 a2 62 11 	mov    %cx,-0x7fee9d5e(,%eax,8)
80105ff3:	80 
80105ff4:	c6 04 c5 a5 62 11 80 	movb   $0x8e,-0x7fee9d5b(,%eax,8)
80105ffb:	8e 
80105ffc:	66 89 14 c5 a0 62 11 	mov    %dx,-0x7fee9d60(,%eax,8)
80106003:	80 
80106004:	c1 ea 10             	shr    $0x10,%edx
80106007:	66 89 14 c5 a6 62 11 	mov    %dx,-0x7fee9d5a(,%eax,8)
8010600e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010600f:	83 c0 01             	add    $0x1,%eax
80106012:	3d 00 01 00 00       	cmp    $0x100,%eax
80106017:	75 bf                	jne    80105fd8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106019:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010601a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010601f:	89 e5                	mov    %esp,%ebp
80106021:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106024:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106029:	68 95 80 10 80       	push   $0x80108095
8010602e:	68 60 62 11 80       	push   $0x80116260
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106033:	66 89 15 a2 64 11 80 	mov    %dx,0x801164a2
8010603a:	c6 05 a4 64 11 80 00 	movb   $0x0,0x801164a4
80106041:	66 a3 a0 64 11 80    	mov    %ax,0x801164a0
80106047:	c1 e8 10             	shr    $0x10,%eax
8010604a:	c6 05 a5 64 11 80 ef 	movb   $0xef,0x801164a5
80106051:	66 a3 a6 64 11 80    	mov    %ax,0x801164a6

  initlock(&tickslock, "time");
80106057:	e8 94 e8 ff ff       	call   801048f0 <initlock>
}
8010605c:	83 c4 10             	add    $0x10,%esp
8010605f:	c9                   	leave  
80106060:	c3                   	ret    
80106061:	eb 0d                	jmp    80106070 <idtinit>
80106063:	90                   	nop
80106064:	90                   	nop
80106065:	90                   	nop
80106066:	90                   	nop
80106067:	90                   	nop
80106068:	90                   	nop
80106069:	90                   	nop
8010606a:	90                   	nop
8010606b:	90                   	nop
8010606c:	90                   	nop
8010606d:	90                   	nop
8010606e:	90                   	nop
8010606f:	90                   	nop

80106070 <idtinit>:

void
idtinit(void)
{
80106070:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106071:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106076:	89 e5                	mov    %esp,%ebp
80106078:	83 ec 10             	sub    $0x10,%esp
8010607b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010607f:	b8 a0 62 11 80       	mov    $0x801162a0,%eax
80106084:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106088:	c1 e8 10             	shr    $0x10,%eax
8010608b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010608f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106092:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106095:	c9                   	leave  
80106096:	c3                   	ret    
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
801060a6:	83 ec 1c             	sub    $0x1c,%esp
801060a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801060ac:	8b 47 30             	mov    0x30(%edi),%eax
801060af:	83 f8 40             	cmp    $0x40,%eax
801060b2:	0f 84 a8 01 00 00    	je     80106260 <trap+0x1c0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801060b8:	83 e8 20             	sub    $0x20,%eax
801060bb:	83 f8 1f             	cmp    $0x1f,%eax
801060be:	77 10                	ja     801060d0 <trap+0x30>
801060c0:	ff 24 85 3c 81 10 80 	jmp    *-0x7fef7ec4(,%eax,4)
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801060d0:	e8 7b da ff ff       	call   80103b50 <myproc>
801060d5:	85 c0                	test   %eax,%eax
801060d7:	0f 84 ea 01 00 00    	je     801062c7 <trap+0x227>
801060dd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801060e1:	0f 84 e0 01 00 00    	je     801062c7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060e7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ea:	8b 57 38             	mov    0x38(%edi),%edx
801060ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801060f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801060f3:	e8 38 da ff ff       	call   80103b30 <cpuid>
801060f8:	8b 77 34             	mov    0x34(%edi),%esi
801060fb:	8b 5f 30             	mov    0x30(%edi),%ebx
801060fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106101:	e8 4a da ff ff       	call   80103b50 <myproc>
80106106:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106109:	e8 42 da ff ff       	call   80103b50 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010610e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106111:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106114:	51                   	push   %ecx
80106115:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106116:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106119:	ff 75 e4             	pushl  -0x1c(%ebp)
8010611c:	56                   	push   %esi
8010611d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010611e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106121:	52                   	push   %edx
80106122:	ff 70 10             	pushl  0x10(%eax)
80106125:	68 f8 80 10 80       	push   $0x801080f8
8010612a:	e8 31 a5 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010612f:	83 c4 20             	add    $0x20,%esp
80106132:	e8 19 da ff ff       	call   80103b50 <myproc>
80106137:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010613e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106140:	e8 0b da ff ff       	call   80103b50 <myproc>
80106145:	85 c0                	test   %eax,%eax
80106147:	74 0c                	je     80106155 <trap+0xb5>
80106149:	e8 02 da ff ff       	call   80103b50 <myproc>
8010614e:	8b 50 24             	mov    0x24(%eax),%edx
80106151:	85 d2                	test   %edx,%edx
80106153:	75 4b                	jne    801061a0 <trap+0x100>
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING){
80106155:	e8 f6 d9 ff ff       	call   80103b50 <myproc>
8010615a:	85 c0                	test   %eax,%eax
8010615c:	74 0f                	je     8010616d <trap+0xcd>
8010615e:	e8 ed d9 ff ff       	call   80103b50 <myproc>
80106163:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106167:	0f 84 2b 01 00 00    	je     80106298 <trap+0x1f8>
	  myproc()->tick++;
     if(tf->trapno == T_IRQ0+IRQ_TIMER) yield();
  }
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010616d:	e8 de d9 ff ff       	call   80103b50 <myproc>
80106172:	85 c0                	test   %eax,%eax
80106174:	74 1d                	je     80106193 <trap+0xf3>
80106176:	e8 d5 d9 ff ff       	call   80103b50 <myproc>
8010617b:	8b 40 24             	mov    0x24(%eax),%eax
8010617e:	85 c0                	test   %eax,%eax
80106180:	74 11                	je     80106193 <trap+0xf3>
80106182:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106186:	83 e0 03             	and    $0x3,%eax
80106189:	66 83 f8 03          	cmp    $0x3,%ax
8010618d:	0f 84 f6 00 00 00    	je     80106289 <trap+0x1e9>
    exit();
}
80106193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106196:	5b                   	pop    %ebx
80106197:	5e                   	pop    %esi
80106198:	5f                   	pop    %edi
80106199:	5d                   	pop    %ebp
8010619a:	c3                   	ret    
8010619b:	90                   	nop
8010619c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061a0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801061a4:	83 e0 03             	and    $0x3,%eax
801061a7:	66 83 f8 03          	cmp    $0x3,%ax
801061ab:	75 a8                	jne    80106155 <trap+0xb5>
    exit();
801061ad:	e8 4e de ff ff       	call   80104000 <exit>
801061b2:	eb a1                	jmp    80106155 <trap+0xb5>
801061b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801061b8:	e8 23 c2 ff ff       	call   801023e0 <ideintr>
    lapiceoi();
801061bd:	e8 de c8 ff ff       	call   80102aa0 <lapiceoi>
    break;
801061c2:	e9 79 ff ff ff       	jmp    80106140 <trap+0xa0>
801061c7:	89 f6                	mov    %esi,%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801061d0:	e8 5b d9 ff ff       	call   80103b30 <cpuid>
801061d5:	85 c0                	test   %eax,%eax
801061d7:	75 e4                	jne    801061bd <trap+0x11d>
      acquire(&tickslock);
801061d9:	83 ec 0c             	sub    $0xc,%esp
801061dc:	68 60 62 11 80       	push   $0x80116260
801061e1:	e8 6a e8 ff ff       	call   80104a50 <acquire>
      ticks++;
      wakeup(&ticks);
801061e6:	c7 04 24 a0 6a 11 80 	movl   $0x80116aa0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801061ed:	83 05 a0 6a 11 80 01 	addl   $0x1,0x80116aa0
      wakeup(&ticks);
801061f4:	e8 17 e4 ff ff       	call   80104610 <wakeup>
      release(&tickslock);
801061f9:	c7 04 24 60 62 11 80 	movl   $0x80116260,(%esp)
80106200:	e8 fb e8 ff ff       	call   80104b00 <release>
80106205:	83 c4 10             	add    $0x10,%esp
80106208:	eb b3                	jmp    801061bd <trap+0x11d>
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106210:	e8 4b c7 ff ff       	call   80102960 <kbdintr>
    lapiceoi();
80106215:	e8 86 c8 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010621a:	e9 21 ff ff ff       	jmp    80106140 <trap+0xa0>
8010621f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106220:	e8 4b 02 00 00       	call   80106470 <uartintr>
    lapiceoi();
80106225:	e8 76 c8 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010622a:	e9 11 ff ff ff       	jmp    80106140 <trap+0xa0>
8010622f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106230:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106234:	8b 77 38             	mov    0x38(%edi),%esi
80106237:	e8 f4 d8 ff ff       	call   80103b30 <cpuid>
8010623c:	56                   	push   %esi
8010623d:	53                   	push   %ebx
8010623e:	50                   	push   %eax
8010623f:	68 a0 80 10 80       	push   $0x801080a0
80106244:	e8 17 a4 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106249:	e8 52 c8 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010624e:	83 c4 10             	add    $0x10,%esp
80106251:	e9 ea fe ff ff       	jmp    80106140 <trap+0xa0>
80106256:	8d 76 00             	lea    0x0(%esi),%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106260:	e8 eb d8 ff ff       	call   80103b50 <myproc>
80106265:	8b 58 24             	mov    0x24(%eax),%ebx
80106268:	85 db                	test   %ebx,%ebx
8010626a:	75 54                	jne    801062c0 <trap+0x220>
      exit();
    myproc()->tf = tf;
8010626c:	e8 df d8 ff ff       	call   80103b50 <myproc>
80106271:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106274:	e8 d7 ec ff ff       	call   80104f50 <syscall>
    if(myproc()->killed)
80106279:	e8 d2 d8 ff ff       	call   80103b50 <myproc>
8010627e:	8b 48 24             	mov    0x24(%eax),%ecx
80106281:	85 c9                	test   %ecx,%ecx
80106283:	0f 84 0a ff ff ff    	je     80106193 <trap+0xf3>
  }
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106289:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010628c:	5b                   	pop    %ebx
8010628d:	5e                   	pop    %esi
8010628e:	5f                   	pop    %edi
8010628f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106290:	e9 6b dd ff ff       	jmp    80104000 <exit>
80106295:	8d 76 00             	lea    0x0(%esi),%esi
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING){
	  myproc()->tick++;
80106298:	e8 b3 d8 ff ff       	call   80103b50 <myproc>
8010629d:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)
     if(tf->trapno == T_IRQ0+IRQ_TIMER) yield();
801062a4:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801062a8:	0f 85 bf fe ff ff    	jne    8010616d <trap+0xcd>
801062ae:	e8 7d de ff ff       	call   80104130 <yield>
801062b3:	e9 b5 fe ff ff       	jmp    8010616d <trap+0xcd>
801062b8:	90                   	nop
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801062c0:	e8 3b dd ff ff       	call   80104000 <exit>
801062c5:	eb a5                	jmp    8010626c <trap+0x1cc>
801062c7:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062ca:	8b 5f 38             	mov    0x38(%edi),%ebx
801062cd:	e8 5e d8 ff ff       	call   80103b30 <cpuid>
801062d2:	83 ec 0c             	sub    $0xc,%esp
801062d5:	56                   	push   %esi
801062d6:	53                   	push   %ebx
801062d7:	50                   	push   %eax
801062d8:	ff 77 30             	pushl  0x30(%edi)
801062db:	68 c4 80 10 80       	push   $0x801080c4
801062e0:	e8 7b a3 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801062e5:	83 c4 14             	add    $0x14,%esp
801062e8:	68 9a 80 10 80       	push   $0x8010809a
801062ed:	e8 7e a0 ff ff       	call   80100370 <panic>
801062f2:	66 90                	xchg   %ax,%ax
801062f4:	66 90                	xchg   %ax,%ax
801062f6:	66 90                	xchg   %ax,%ax
801062f8:	66 90                	xchg   %ax,%ax
801062fa:	66 90                	xchg   %ax,%ax
801062fc:	66 90                	xchg   %ax,%ax
801062fe:	66 90                	xchg   %ax,%ax

80106300 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106300:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106305:	55                   	push   %ebp
80106306:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106308:	85 c0                	test   %eax,%eax
8010630a:	74 1c                	je     80106328 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010630c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106311:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106312:	a8 01                	test   $0x1,%al
80106314:	74 12                	je     80106328 <uartgetc+0x28>
80106316:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010631b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010631c:	0f b6 c0             	movzbl %al,%eax
}
8010631f:	5d                   	pop    %ebp
80106320:	c3                   	ret    
80106321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010632d:	5d                   	pop    %ebp
8010632e:	c3                   	ret    
8010632f:	90                   	nop

80106330 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
80106333:	57                   	push   %edi
80106334:	56                   	push   %esi
80106335:	53                   	push   %ebx
80106336:	89 c7                	mov    %eax,%edi
80106338:	bb 80 00 00 00       	mov    $0x80,%ebx
8010633d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106342:	83 ec 0c             	sub    $0xc,%esp
80106345:	eb 1b                	jmp    80106362 <uartputc.part.0+0x32>
80106347:	89 f6                	mov    %esi,%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	6a 0a                	push   $0xa
80106355:	e8 66 c7 ff ff       	call   80102ac0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010635a:	83 c4 10             	add    $0x10,%esp
8010635d:	83 eb 01             	sub    $0x1,%ebx
80106360:	74 07                	je     80106369 <uartputc.part.0+0x39>
80106362:	89 f2                	mov    %esi,%edx
80106364:	ec                   	in     (%dx),%al
80106365:	a8 20                	test   $0x20,%al
80106367:	74 e7                	je     80106350 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106369:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010636e:	89 f8                	mov    %edi,%eax
80106370:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106374:	5b                   	pop    %ebx
80106375:	5e                   	pop    %esi
80106376:	5f                   	pop    %edi
80106377:	5d                   	pop    %ebp
80106378:	c3                   	ret    
80106379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106380 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106380:	55                   	push   %ebp
80106381:	31 c9                	xor    %ecx,%ecx
80106383:	89 c8                	mov    %ecx,%eax
80106385:	89 e5                	mov    %esp,%ebp
80106387:	57                   	push   %edi
80106388:	56                   	push   %esi
80106389:	53                   	push   %ebx
8010638a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010638f:	89 da                	mov    %ebx,%edx
80106391:	83 ec 0c             	sub    $0xc,%esp
80106394:	ee                   	out    %al,(%dx)
80106395:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010639a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010639f:	89 fa                	mov    %edi,%edx
801063a1:	ee                   	out    %al,(%dx)
801063a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801063a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ac:	ee                   	out    %al,(%dx)
801063ad:	be f9 03 00 00       	mov    $0x3f9,%esi
801063b2:	89 c8                	mov    %ecx,%eax
801063b4:	89 f2                	mov    %esi,%edx
801063b6:	ee                   	out    %al,(%dx)
801063b7:	b8 03 00 00 00       	mov    $0x3,%eax
801063bc:	89 fa                	mov    %edi,%edx
801063be:	ee                   	out    %al,(%dx)
801063bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063c4:	89 c8                	mov    %ecx,%eax
801063c6:	ee                   	out    %al,(%dx)
801063c7:	b8 01 00 00 00       	mov    $0x1,%eax
801063cc:	89 f2                	mov    %esi,%edx
801063ce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063d4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801063d5:	3c ff                	cmp    $0xff,%al
801063d7:	74 5a                	je     80106433 <uartinit+0xb3>
    return;
  uart = 1;
801063d9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801063e0:	00 00 00 
801063e3:	89 da                	mov    %ebx,%edx
801063e5:	ec                   	in     (%dx),%al
801063e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063eb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801063ec:	83 ec 08             	sub    $0x8,%esp
801063ef:	bb bc 81 10 80       	mov    $0x801081bc,%ebx
801063f4:	6a 00                	push   $0x0
801063f6:	6a 04                	push   $0x4
801063f8:	e8 33 c2 ff ff       	call   80102630 <ioapicenable>
801063fd:	83 c4 10             	add    $0x10,%esp
80106400:	b8 78 00 00 00       	mov    $0x78,%eax
80106405:	eb 13                	jmp    8010641a <uartinit+0x9a>
80106407:	89 f6                	mov    %esi,%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106410:	83 c3 01             	add    $0x1,%ebx
80106413:	0f be 03             	movsbl (%ebx),%eax
80106416:	84 c0                	test   %al,%al
80106418:	74 19                	je     80106433 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010641a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106420:	85 d2                	test   %edx,%edx
80106422:	74 ec                	je     80106410 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106424:	83 c3 01             	add    $0x1,%ebx
80106427:	e8 04 ff ff ff       	call   80106330 <uartputc.part.0>
8010642c:	0f be 03             	movsbl (%ebx),%eax
8010642f:	84 c0                	test   %al,%al
80106431:	75 e7                	jne    8010641a <uartinit+0x9a>
    uartputc(*p);
}
80106433:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106436:	5b                   	pop    %ebx
80106437:	5e                   	pop    %esi
80106438:	5f                   	pop    %edi
80106439:	5d                   	pop    %ebp
8010643a:	c3                   	ret    
8010643b:	90                   	nop
8010643c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106440 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106440:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106446:	55                   	push   %ebp
80106447:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106449:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010644b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010644e:	74 10                	je     80106460 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106450:	5d                   	pop    %ebp
80106451:	e9 da fe ff ff       	jmp    80106330 <uartputc.part.0>
80106456:	8d 76 00             	lea    0x0(%esi),%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106460:	5d                   	pop    %ebp
80106461:	c3                   	ret    
80106462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106470 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106476:	68 00 63 10 80       	push   $0x80106300
8010647b:	e8 70 a3 ff ff       	call   801007f0 <consoleintr>
}
80106480:	83 c4 10             	add    $0x10,%esp
80106483:	c9                   	leave  
80106484:	c3                   	ret    

80106485 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $0
80106487:	6a 00                	push   $0x0
  jmp alltraps
80106489:	e9 1b fb ff ff       	jmp    80105fa9 <alltraps>

8010648e <vector1>:
.globl vector1
vector1:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $1
80106490:	6a 01                	push   $0x1
  jmp alltraps
80106492:	e9 12 fb ff ff       	jmp    80105fa9 <alltraps>

80106497 <vector2>:
.globl vector2
vector2:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $2
80106499:	6a 02                	push   $0x2
  jmp alltraps
8010649b:	e9 09 fb ff ff       	jmp    80105fa9 <alltraps>

801064a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $3
801064a2:	6a 03                	push   $0x3
  jmp alltraps
801064a4:	e9 00 fb ff ff       	jmp    80105fa9 <alltraps>

801064a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $4
801064ab:	6a 04                	push   $0x4
  jmp alltraps
801064ad:	e9 f7 fa ff ff       	jmp    80105fa9 <alltraps>

801064b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $5
801064b4:	6a 05                	push   $0x5
  jmp alltraps
801064b6:	e9 ee fa ff ff       	jmp    80105fa9 <alltraps>

801064bb <vector6>:
.globl vector6
vector6:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $6
801064bd:	6a 06                	push   $0x6
  jmp alltraps
801064bf:	e9 e5 fa ff ff       	jmp    80105fa9 <alltraps>

801064c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $7
801064c6:	6a 07                	push   $0x7
  jmp alltraps
801064c8:	e9 dc fa ff ff       	jmp    80105fa9 <alltraps>

801064cd <vector8>:
.globl vector8
vector8:
  pushl $8
801064cd:	6a 08                	push   $0x8
  jmp alltraps
801064cf:	e9 d5 fa ff ff       	jmp    80105fa9 <alltraps>

801064d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $9
801064d6:	6a 09                	push   $0x9
  jmp alltraps
801064d8:	e9 cc fa ff ff       	jmp    80105fa9 <alltraps>

801064dd <vector10>:
.globl vector10
vector10:
  pushl $10
801064dd:	6a 0a                	push   $0xa
  jmp alltraps
801064df:	e9 c5 fa ff ff       	jmp    80105fa9 <alltraps>

801064e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801064e4:	6a 0b                	push   $0xb
  jmp alltraps
801064e6:	e9 be fa ff ff       	jmp    80105fa9 <alltraps>

801064eb <vector12>:
.globl vector12
vector12:
  pushl $12
801064eb:	6a 0c                	push   $0xc
  jmp alltraps
801064ed:	e9 b7 fa ff ff       	jmp    80105fa9 <alltraps>

801064f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801064f2:	6a 0d                	push   $0xd
  jmp alltraps
801064f4:	e9 b0 fa ff ff       	jmp    80105fa9 <alltraps>

801064f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801064f9:	6a 0e                	push   $0xe
  jmp alltraps
801064fb:	e9 a9 fa ff ff       	jmp    80105fa9 <alltraps>

80106500 <vector15>:
.globl vector15
vector15:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $15
80106502:	6a 0f                	push   $0xf
  jmp alltraps
80106504:	e9 a0 fa ff ff       	jmp    80105fa9 <alltraps>

80106509 <vector16>:
.globl vector16
vector16:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $16
8010650b:	6a 10                	push   $0x10
  jmp alltraps
8010650d:	e9 97 fa ff ff       	jmp    80105fa9 <alltraps>

80106512 <vector17>:
.globl vector17
vector17:
  pushl $17
80106512:	6a 11                	push   $0x11
  jmp alltraps
80106514:	e9 90 fa ff ff       	jmp    80105fa9 <alltraps>

80106519 <vector18>:
.globl vector18
vector18:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $18
8010651b:	6a 12                	push   $0x12
  jmp alltraps
8010651d:	e9 87 fa ff ff       	jmp    80105fa9 <alltraps>

80106522 <vector19>:
.globl vector19
vector19:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $19
80106524:	6a 13                	push   $0x13
  jmp alltraps
80106526:	e9 7e fa ff ff       	jmp    80105fa9 <alltraps>

8010652b <vector20>:
.globl vector20
vector20:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $20
8010652d:	6a 14                	push   $0x14
  jmp alltraps
8010652f:	e9 75 fa ff ff       	jmp    80105fa9 <alltraps>

80106534 <vector21>:
.globl vector21
vector21:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $21
80106536:	6a 15                	push   $0x15
  jmp alltraps
80106538:	e9 6c fa ff ff       	jmp    80105fa9 <alltraps>

8010653d <vector22>:
.globl vector22
vector22:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $22
8010653f:	6a 16                	push   $0x16
  jmp alltraps
80106541:	e9 63 fa ff ff       	jmp    80105fa9 <alltraps>

80106546 <vector23>:
.globl vector23
vector23:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $23
80106548:	6a 17                	push   $0x17
  jmp alltraps
8010654a:	e9 5a fa ff ff       	jmp    80105fa9 <alltraps>

8010654f <vector24>:
.globl vector24
vector24:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $24
80106551:	6a 18                	push   $0x18
  jmp alltraps
80106553:	e9 51 fa ff ff       	jmp    80105fa9 <alltraps>

80106558 <vector25>:
.globl vector25
vector25:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $25
8010655a:	6a 19                	push   $0x19
  jmp alltraps
8010655c:	e9 48 fa ff ff       	jmp    80105fa9 <alltraps>

80106561 <vector26>:
.globl vector26
vector26:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $26
80106563:	6a 1a                	push   $0x1a
  jmp alltraps
80106565:	e9 3f fa ff ff       	jmp    80105fa9 <alltraps>

8010656a <vector27>:
.globl vector27
vector27:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $27
8010656c:	6a 1b                	push   $0x1b
  jmp alltraps
8010656e:	e9 36 fa ff ff       	jmp    80105fa9 <alltraps>

80106573 <vector28>:
.globl vector28
vector28:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $28
80106575:	6a 1c                	push   $0x1c
  jmp alltraps
80106577:	e9 2d fa ff ff       	jmp    80105fa9 <alltraps>

8010657c <vector29>:
.globl vector29
vector29:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $29
8010657e:	6a 1d                	push   $0x1d
  jmp alltraps
80106580:	e9 24 fa ff ff       	jmp    80105fa9 <alltraps>

80106585 <vector30>:
.globl vector30
vector30:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $30
80106587:	6a 1e                	push   $0x1e
  jmp alltraps
80106589:	e9 1b fa ff ff       	jmp    80105fa9 <alltraps>

8010658e <vector31>:
.globl vector31
vector31:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $31
80106590:	6a 1f                	push   $0x1f
  jmp alltraps
80106592:	e9 12 fa ff ff       	jmp    80105fa9 <alltraps>

80106597 <vector32>:
.globl vector32
vector32:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $32
80106599:	6a 20                	push   $0x20
  jmp alltraps
8010659b:	e9 09 fa ff ff       	jmp    80105fa9 <alltraps>

801065a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $33
801065a2:	6a 21                	push   $0x21
  jmp alltraps
801065a4:	e9 00 fa ff ff       	jmp    80105fa9 <alltraps>

801065a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $34
801065ab:	6a 22                	push   $0x22
  jmp alltraps
801065ad:	e9 f7 f9 ff ff       	jmp    80105fa9 <alltraps>

801065b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $35
801065b4:	6a 23                	push   $0x23
  jmp alltraps
801065b6:	e9 ee f9 ff ff       	jmp    80105fa9 <alltraps>

801065bb <vector36>:
.globl vector36
vector36:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $36
801065bd:	6a 24                	push   $0x24
  jmp alltraps
801065bf:	e9 e5 f9 ff ff       	jmp    80105fa9 <alltraps>

801065c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $37
801065c6:	6a 25                	push   $0x25
  jmp alltraps
801065c8:	e9 dc f9 ff ff       	jmp    80105fa9 <alltraps>

801065cd <vector38>:
.globl vector38
vector38:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $38
801065cf:	6a 26                	push   $0x26
  jmp alltraps
801065d1:	e9 d3 f9 ff ff       	jmp    80105fa9 <alltraps>

801065d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $39
801065d8:	6a 27                	push   $0x27
  jmp alltraps
801065da:	e9 ca f9 ff ff       	jmp    80105fa9 <alltraps>

801065df <vector40>:
.globl vector40
vector40:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $40
801065e1:	6a 28                	push   $0x28
  jmp alltraps
801065e3:	e9 c1 f9 ff ff       	jmp    80105fa9 <alltraps>

801065e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $41
801065ea:	6a 29                	push   $0x29
  jmp alltraps
801065ec:	e9 b8 f9 ff ff       	jmp    80105fa9 <alltraps>

801065f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $42
801065f3:	6a 2a                	push   $0x2a
  jmp alltraps
801065f5:	e9 af f9 ff ff       	jmp    80105fa9 <alltraps>

801065fa <vector43>:
.globl vector43
vector43:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $43
801065fc:	6a 2b                	push   $0x2b
  jmp alltraps
801065fe:	e9 a6 f9 ff ff       	jmp    80105fa9 <alltraps>

80106603 <vector44>:
.globl vector44
vector44:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $44
80106605:	6a 2c                	push   $0x2c
  jmp alltraps
80106607:	e9 9d f9 ff ff       	jmp    80105fa9 <alltraps>

8010660c <vector45>:
.globl vector45
vector45:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $45
8010660e:	6a 2d                	push   $0x2d
  jmp alltraps
80106610:	e9 94 f9 ff ff       	jmp    80105fa9 <alltraps>

80106615 <vector46>:
.globl vector46
vector46:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $46
80106617:	6a 2e                	push   $0x2e
  jmp alltraps
80106619:	e9 8b f9 ff ff       	jmp    80105fa9 <alltraps>

8010661e <vector47>:
.globl vector47
vector47:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $47
80106620:	6a 2f                	push   $0x2f
  jmp alltraps
80106622:	e9 82 f9 ff ff       	jmp    80105fa9 <alltraps>

80106627 <vector48>:
.globl vector48
vector48:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $48
80106629:	6a 30                	push   $0x30
  jmp alltraps
8010662b:	e9 79 f9 ff ff       	jmp    80105fa9 <alltraps>

80106630 <vector49>:
.globl vector49
vector49:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $49
80106632:	6a 31                	push   $0x31
  jmp alltraps
80106634:	e9 70 f9 ff ff       	jmp    80105fa9 <alltraps>

80106639 <vector50>:
.globl vector50
vector50:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $50
8010663b:	6a 32                	push   $0x32
  jmp alltraps
8010663d:	e9 67 f9 ff ff       	jmp    80105fa9 <alltraps>

80106642 <vector51>:
.globl vector51
vector51:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $51
80106644:	6a 33                	push   $0x33
  jmp alltraps
80106646:	e9 5e f9 ff ff       	jmp    80105fa9 <alltraps>

8010664b <vector52>:
.globl vector52
vector52:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $52
8010664d:	6a 34                	push   $0x34
  jmp alltraps
8010664f:	e9 55 f9 ff ff       	jmp    80105fa9 <alltraps>

80106654 <vector53>:
.globl vector53
vector53:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $53
80106656:	6a 35                	push   $0x35
  jmp alltraps
80106658:	e9 4c f9 ff ff       	jmp    80105fa9 <alltraps>

8010665d <vector54>:
.globl vector54
vector54:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $54
8010665f:	6a 36                	push   $0x36
  jmp alltraps
80106661:	e9 43 f9 ff ff       	jmp    80105fa9 <alltraps>

80106666 <vector55>:
.globl vector55
vector55:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $55
80106668:	6a 37                	push   $0x37
  jmp alltraps
8010666a:	e9 3a f9 ff ff       	jmp    80105fa9 <alltraps>

8010666f <vector56>:
.globl vector56
vector56:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $56
80106671:	6a 38                	push   $0x38
  jmp alltraps
80106673:	e9 31 f9 ff ff       	jmp    80105fa9 <alltraps>

80106678 <vector57>:
.globl vector57
vector57:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $57
8010667a:	6a 39                	push   $0x39
  jmp alltraps
8010667c:	e9 28 f9 ff ff       	jmp    80105fa9 <alltraps>

80106681 <vector58>:
.globl vector58
vector58:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $58
80106683:	6a 3a                	push   $0x3a
  jmp alltraps
80106685:	e9 1f f9 ff ff       	jmp    80105fa9 <alltraps>

8010668a <vector59>:
.globl vector59
vector59:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $59
8010668c:	6a 3b                	push   $0x3b
  jmp alltraps
8010668e:	e9 16 f9 ff ff       	jmp    80105fa9 <alltraps>

80106693 <vector60>:
.globl vector60
vector60:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $60
80106695:	6a 3c                	push   $0x3c
  jmp alltraps
80106697:	e9 0d f9 ff ff       	jmp    80105fa9 <alltraps>

8010669c <vector61>:
.globl vector61
vector61:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $61
8010669e:	6a 3d                	push   $0x3d
  jmp alltraps
801066a0:	e9 04 f9 ff ff       	jmp    80105fa9 <alltraps>

801066a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $62
801066a7:	6a 3e                	push   $0x3e
  jmp alltraps
801066a9:	e9 fb f8 ff ff       	jmp    80105fa9 <alltraps>

801066ae <vector63>:
.globl vector63
vector63:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $63
801066b0:	6a 3f                	push   $0x3f
  jmp alltraps
801066b2:	e9 f2 f8 ff ff       	jmp    80105fa9 <alltraps>

801066b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $64
801066b9:	6a 40                	push   $0x40
  jmp alltraps
801066bb:	e9 e9 f8 ff ff       	jmp    80105fa9 <alltraps>

801066c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $65
801066c2:	6a 41                	push   $0x41
  jmp alltraps
801066c4:	e9 e0 f8 ff ff       	jmp    80105fa9 <alltraps>

801066c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $66
801066cb:	6a 42                	push   $0x42
  jmp alltraps
801066cd:	e9 d7 f8 ff ff       	jmp    80105fa9 <alltraps>

801066d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $67
801066d4:	6a 43                	push   $0x43
  jmp alltraps
801066d6:	e9 ce f8 ff ff       	jmp    80105fa9 <alltraps>

801066db <vector68>:
.globl vector68
vector68:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $68
801066dd:	6a 44                	push   $0x44
  jmp alltraps
801066df:	e9 c5 f8 ff ff       	jmp    80105fa9 <alltraps>

801066e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $69
801066e6:	6a 45                	push   $0x45
  jmp alltraps
801066e8:	e9 bc f8 ff ff       	jmp    80105fa9 <alltraps>

801066ed <vector70>:
.globl vector70
vector70:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $70
801066ef:	6a 46                	push   $0x46
  jmp alltraps
801066f1:	e9 b3 f8 ff ff       	jmp    80105fa9 <alltraps>

801066f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $71
801066f8:	6a 47                	push   $0x47
  jmp alltraps
801066fa:	e9 aa f8 ff ff       	jmp    80105fa9 <alltraps>

801066ff <vector72>:
.globl vector72
vector72:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $72
80106701:	6a 48                	push   $0x48
  jmp alltraps
80106703:	e9 a1 f8 ff ff       	jmp    80105fa9 <alltraps>

80106708 <vector73>:
.globl vector73
vector73:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $73
8010670a:	6a 49                	push   $0x49
  jmp alltraps
8010670c:	e9 98 f8 ff ff       	jmp    80105fa9 <alltraps>

80106711 <vector74>:
.globl vector74
vector74:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $74
80106713:	6a 4a                	push   $0x4a
  jmp alltraps
80106715:	e9 8f f8 ff ff       	jmp    80105fa9 <alltraps>

8010671a <vector75>:
.globl vector75
vector75:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $75
8010671c:	6a 4b                	push   $0x4b
  jmp alltraps
8010671e:	e9 86 f8 ff ff       	jmp    80105fa9 <alltraps>

80106723 <vector76>:
.globl vector76
vector76:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $76
80106725:	6a 4c                	push   $0x4c
  jmp alltraps
80106727:	e9 7d f8 ff ff       	jmp    80105fa9 <alltraps>

8010672c <vector77>:
.globl vector77
vector77:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $77
8010672e:	6a 4d                	push   $0x4d
  jmp alltraps
80106730:	e9 74 f8 ff ff       	jmp    80105fa9 <alltraps>

80106735 <vector78>:
.globl vector78
vector78:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $78
80106737:	6a 4e                	push   $0x4e
  jmp alltraps
80106739:	e9 6b f8 ff ff       	jmp    80105fa9 <alltraps>

8010673e <vector79>:
.globl vector79
vector79:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $79
80106740:	6a 4f                	push   $0x4f
  jmp alltraps
80106742:	e9 62 f8 ff ff       	jmp    80105fa9 <alltraps>

80106747 <vector80>:
.globl vector80
vector80:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $80
80106749:	6a 50                	push   $0x50
  jmp alltraps
8010674b:	e9 59 f8 ff ff       	jmp    80105fa9 <alltraps>

80106750 <vector81>:
.globl vector81
vector81:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $81
80106752:	6a 51                	push   $0x51
  jmp alltraps
80106754:	e9 50 f8 ff ff       	jmp    80105fa9 <alltraps>

80106759 <vector82>:
.globl vector82
vector82:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $82
8010675b:	6a 52                	push   $0x52
  jmp alltraps
8010675d:	e9 47 f8 ff ff       	jmp    80105fa9 <alltraps>

80106762 <vector83>:
.globl vector83
vector83:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $83
80106764:	6a 53                	push   $0x53
  jmp alltraps
80106766:	e9 3e f8 ff ff       	jmp    80105fa9 <alltraps>

8010676b <vector84>:
.globl vector84
vector84:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $84
8010676d:	6a 54                	push   $0x54
  jmp alltraps
8010676f:	e9 35 f8 ff ff       	jmp    80105fa9 <alltraps>

80106774 <vector85>:
.globl vector85
vector85:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $85
80106776:	6a 55                	push   $0x55
  jmp alltraps
80106778:	e9 2c f8 ff ff       	jmp    80105fa9 <alltraps>

8010677d <vector86>:
.globl vector86
vector86:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $86
8010677f:	6a 56                	push   $0x56
  jmp alltraps
80106781:	e9 23 f8 ff ff       	jmp    80105fa9 <alltraps>

80106786 <vector87>:
.globl vector87
vector87:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $87
80106788:	6a 57                	push   $0x57
  jmp alltraps
8010678a:	e9 1a f8 ff ff       	jmp    80105fa9 <alltraps>

8010678f <vector88>:
.globl vector88
vector88:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $88
80106791:	6a 58                	push   $0x58
  jmp alltraps
80106793:	e9 11 f8 ff ff       	jmp    80105fa9 <alltraps>

80106798 <vector89>:
.globl vector89
vector89:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $89
8010679a:	6a 59                	push   $0x59
  jmp alltraps
8010679c:	e9 08 f8 ff ff       	jmp    80105fa9 <alltraps>

801067a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $90
801067a3:	6a 5a                	push   $0x5a
  jmp alltraps
801067a5:	e9 ff f7 ff ff       	jmp    80105fa9 <alltraps>

801067aa <vector91>:
.globl vector91
vector91:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $91
801067ac:	6a 5b                	push   $0x5b
  jmp alltraps
801067ae:	e9 f6 f7 ff ff       	jmp    80105fa9 <alltraps>

801067b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $92
801067b5:	6a 5c                	push   $0x5c
  jmp alltraps
801067b7:	e9 ed f7 ff ff       	jmp    80105fa9 <alltraps>

801067bc <vector93>:
.globl vector93
vector93:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $93
801067be:	6a 5d                	push   $0x5d
  jmp alltraps
801067c0:	e9 e4 f7 ff ff       	jmp    80105fa9 <alltraps>

801067c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $94
801067c7:	6a 5e                	push   $0x5e
  jmp alltraps
801067c9:	e9 db f7 ff ff       	jmp    80105fa9 <alltraps>

801067ce <vector95>:
.globl vector95
vector95:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $95
801067d0:	6a 5f                	push   $0x5f
  jmp alltraps
801067d2:	e9 d2 f7 ff ff       	jmp    80105fa9 <alltraps>

801067d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $96
801067d9:	6a 60                	push   $0x60
  jmp alltraps
801067db:	e9 c9 f7 ff ff       	jmp    80105fa9 <alltraps>

801067e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $97
801067e2:	6a 61                	push   $0x61
  jmp alltraps
801067e4:	e9 c0 f7 ff ff       	jmp    80105fa9 <alltraps>

801067e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $98
801067eb:	6a 62                	push   $0x62
  jmp alltraps
801067ed:	e9 b7 f7 ff ff       	jmp    80105fa9 <alltraps>

801067f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $99
801067f4:	6a 63                	push   $0x63
  jmp alltraps
801067f6:	e9 ae f7 ff ff       	jmp    80105fa9 <alltraps>

801067fb <vector100>:
.globl vector100
vector100:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $100
801067fd:	6a 64                	push   $0x64
  jmp alltraps
801067ff:	e9 a5 f7 ff ff       	jmp    80105fa9 <alltraps>

80106804 <vector101>:
.globl vector101
vector101:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $101
80106806:	6a 65                	push   $0x65
  jmp alltraps
80106808:	e9 9c f7 ff ff       	jmp    80105fa9 <alltraps>

8010680d <vector102>:
.globl vector102
vector102:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $102
8010680f:	6a 66                	push   $0x66
  jmp alltraps
80106811:	e9 93 f7 ff ff       	jmp    80105fa9 <alltraps>

80106816 <vector103>:
.globl vector103
vector103:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $103
80106818:	6a 67                	push   $0x67
  jmp alltraps
8010681a:	e9 8a f7 ff ff       	jmp    80105fa9 <alltraps>

8010681f <vector104>:
.globl vector104
vector104:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $104
80106821:	6a 68                	push   $0x68
  jmp alltraps
80106823:	e9 81 f7 ff ff       	jmp    80105fa9 <alltraps>

80106828 <vector105>:
.globl vector105
vector105:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $105
8010682a:	6a 69                	push   $0x69
  jmp alltraps
8010682c:	e9 78 f7 ff ff       	jmp    80105fa9 <alltraps>

80106831 <vector106>:
.globl vector106
vector106:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $106
80106833:	6a 6a                	push   $0x6a
  jmp alltraps
80106835:	e9 6f f7 ff ff       	jmp    80105fa9 <alltraps>

8010683a <vector107>:
.globl vector107
vector107:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $107
8010683c:	6a 6b                	push   $0x6b
  jmp alltraps
8010683e:	e9 66 f7 ff ff       	jmp    80105fa9 <alltraps>

80106843 <vector108>:
.globl vector108
vector108:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $108
80106845:	6a 6c                	push   $0x6c
  jmp alltraps
80106847:	e9 5d f7 ff ff       	jmp    80105fa9 <alltraps>

8010684c <vector109>:
.globl vector109
vector109:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $109
8010684e:	6a 6d                	push   $0x6d
  jmp alltraps
80106850:	e9 54 f7 ff ff       	jmp    80105fa9 <alltraps>

80106855 <vector110>:
.globl vector110
vector110:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $110
80106857:	6a 6e                	push   $0x6e
  jmp alltraps
80106859:	e9 4b f7 ff ff       	jmp    80105fa9 <alltraps>

8010685e <vector111>:
.globl vector111
vector111:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $111
80106860:	6a 6f                	push   $0x6f
  jmp alltraps
80106862:	e9 42 f7 ff ff       	jmp    80105fa9 <alltraps>

80106867 <vector112>:
.globl vector112
vector112:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $112
80106869:	6a 70                	push   $0x70
  jmp alltraps
8010686b:	e9 39 f7 ff ff       	jmp    80105fa9 <alltraps>

80106870 <vector113>:
.globl vector113
vector113:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $113
80106872:	6a 71                	push   $0x71
  jmp alltraps
80106874:	e9 30 f7 ff ff       	jmp    80105fa9 <alltraps>

80106879 <vector114>:
.globl vector114
vector114:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $114
8010687b:	6a 72                	push   $0x72
  jmp alltraps
8010687d:	e9 27 f7 ff ff       	jmp    80105fa9 <alltraps>

80106882 <vector115>:
.globl vector115
vector115:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $115
80106884:	6a 73                	push   $0x73
  jmp alltraps
80106886:	e9 1e f7 ff ff       	jmp    80105fa9 <alltraps>

8010688b <vector116>:
.globl vector116
vector116:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $116
8010688d:	6a 74                	push   $0x74
  jmp alltraps
8010688f:	e9 15 f7 ff ff       	jmp    80105fa9 <alltraps>

80106894 <vector117>:
.globl vector117
vector117:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $117
80106896:	6a 75                	push   $0x75
  jmp alltraps
80106898:	e9 0c f7 ff ff       	jmp    80105fa9 <alltraps>

8010689d <vector118>:
.globl vector118
vector118:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $118
8010689f:	6a 76                	push   $0x76
  jmp alltraps
801068a1:	e9 03 f7 ff ff       	jmp    80105fa9 <alltraps>

801068a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $119
801068a8:	6a 77                	push   $0x77
  jmp alltraps
801068aa:	e9 fa f6 ff ff       	jmp    80105fa9 <alltraps>

801068af <vector120>:
.globl vector120
vector120:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $120
801068b1:	6a 78                	push   $0x78
  jmp alltraps
801068b3:	e9 f1 f6 ff ff       	jmp    80105fa9 <alltraps>

801068b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $121
801068ba:	6a 79                	push   $0x79
  jmp alltraps
801068bc:	e9 e8 f6 ff ff       	jmp    80105fa9 <alltraps>

801068c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $122
801068c3:	6a 7a                	push   $0x7a
  jmp alltraps
801068c5:	e9 df f6 ff ff       	jmp    80105fa9 <alltraps>

801068ca <vector123>:
.globl vector123
vector123:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $123
801068cc:	6a 7b                	push   $0x7b
  jmp alltraps
801068ce:	e9 d6 f6 ff ff       	jmp    80105fa9 <alltraps>

801068d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $124
801068d5:	6a 7c                	push   $0x7c
  jmp alltraps
801068d7:	e9 cd f6 ff ff       	jmp    80105fa9 <alltraps>

801068dc <vector125>:
.globl vector125
vector125:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $125
801068de:	6a 7d                	push   $0x7d
  jmp alltraps
801068e0:	e9 c4 f6 ff ff       	jmp    80105fa9 <alltraps>

801068e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $126
801068e7:	6a 7e                	push   $0x7e
  jmp alltraps
801068e9:	e9 bb f6 ff ff       	jmp    80105fa9 <alltraps>

801068ee <vector127>:
.globl vector127
vector127:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $127
801068f0:	6a 7f                	push   $0x7f
  jmp alltraps
801068f2:	e9 b2 f6 ff ff       	jmp    80105fa9 <alltraps>

801068f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $128
801068f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068fe:	e9 a6 f6 ff ff       	jmp    80105fa9 <alltraps>

80106903 <vector129>:
.globl vector129
vector129:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $129
80106905:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010690a:	e9 9a f6 ff ff       	jmp    80105fa9 <alltraps>

8010690f <vector130>:
.globl vector130
vector130:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $130
80106911:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106916:	e9 8e f6 ff ff       	jmp    80105fa9 <alltraps>

8010691b <vector131>:
.globl vector131
vector131:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $131
8010691d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106922:	e9 82 f6 ff ff       	jmp    80105fa9 <alltraps>

80106927 <vector132>:
.globl vector132
vector132:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $132
80106929:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010692e:	e9 76 f6 ff ff       	jmp    80105fa9 <alltraps>

80106933 <vector133>:
.globl vector133
vector133:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $133
80106935:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010693a:	e9 6a f6 ff ff       	jmp    80105fa9 <alltraps>

8010693f <vector134>:
.globl vector134
vector134:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $134
80106941:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106946:	e9 5e f6 ff ff       	jmp    80105fa9 <alltraps>

8010694b <vector135>:
.globl vector135
vector135:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $135
8010694d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106952:	e9 52 f6 ff ff       	jmp    80105fa9 <alltraps>

80106957 <vector136>:
.globl vector136
vector136:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $136
80106959:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010695e:	e9 46 f6 ff ff       	jmp    80105fa9 <alltraps>

80106963 <vector137>:
.globl vector137
vector137:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $137
80106965:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010696a:	e9 3a f6 ff ff       	jmp    80105fa9 <alltraps>

8010696f <vector138>:
.globl vector138
vector138:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $138
80106971:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106976:	e9 2e f6 ff ff       	jmp    80105fa9 <alltraps>

8010697b <vector139>:
.globl vector139
vector139:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $139
8010697d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106982:	e9 22 f6 ff ff       	jmp    80105fa9 <alltraps>

80106987 <vector140>:
.globl vector140
vector140:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $140
80106989:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010698e:	e9 16 f6 ff ff       	jmp    80105fa9 <alltraps>

80106993 <vector141>:
.globl vector141
vector141:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $141
80106995:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010699a:	e9 0a f6 ff ff       	jmp    80105fa9 <alltraps>

8010699f <vector142>:
.globl vector142
vector142:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $142
801069a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069a6:	e9 fe f5 ff ff       	jmp    80105fa9 <alltraps>

801069ab <vector143>:
.globl vector143
vector143:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $143
801069ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069b2:	e9 f2 f5 ff ff       	jmp    80105fa9 <alltraps>

801069b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $144
801069b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069be:	e9 e6 f5 ff ff       	jmp    80105fa9 <alltraps>

801069c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $145
801069c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069ca:	e9 da f5 ff ff       	jmp    80105fa9 <alltraps>

801069cf <vector146>:
.globl vector146
vector146:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $146
801069d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069d6:	e9 ce f5 ff ff       	jmp    80105fa9 <alltraps>

801069db <vector147>:
.globl vector147
vector147:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $147
801069dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069e2:	e9 c2 f5 ff ff       	jmp    80105fa9 <alltraps>

801069e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $148
801069e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069ee:	e9 b6 f5 ff ff       	jmp    80105fa9 <alltraps>

801069f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $149
801069f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069fa:	e9 aa f5 ff ff       	jmp    80105fa9 <alltraps>

801069ff <vector150>:
.globl vector150
vector150:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $150
80106a01:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a06:	e9 9e f5 ff ff       	jmp    80105fa9 <alltraps>

80106a0b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $151
80106a0d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a12:	e9 92 f5 ff ff       	jmp    80105fa9 <alltraps>

80106a17 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $152
80106a19:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a1e:	e9 86 f5 ff ff       	jmp    80105fa9 <alltraps>

80106a23 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $153
80106a25:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a2a:	e9 7a f5 ff ff       	jmp    80105fa9 <alltraps>

80106a2f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $154
80106a31:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a36:	e9 6e f5 ff ff       	jmp    80105fa9 <alltraps>

80106a3b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $155
80106a3d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a42:	e9 62 f5 ff ff       	jmp    80105fa9 <alltraps>

80106a47 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $156
80106a49:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a4e:	e9 56 f5 ff ff       	jmp    80105fa9 <alltraps>

80106a53 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $157
80106a55:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a5a:	e9 4a f5 ff ff       	jmp    80105fa9 <alltraps>

80106a5f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $158
80106a61:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a66:	e9 3e f5 ff ff       	jmp    80105fa9 <alltraps>

80106a6b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $159
80106a6d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a72:	e9 32 f5 ff ff       	jmp    80105fa9 <alltraps>

80106a77 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $160
80106a79:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a7e:	e9 26 f5 ff ff       	jmp    80105fa9 <alltraps>

80106a83 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $161
80106a85:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a8a:	e9 1a f5 ff ff       	jmp    80105fa9 <alltraps>

80106a8f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $162
80106a91:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a96:	e9 0e f5 ff ff       	jmp    80105fa9 <alltraps>

80106a9b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $163
80106a9d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106aa2:	e9 02 f5 ff ff       	jmp    80105fa9 <alltraps>

80106aa7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $164
80106aa9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106aae:	e9 f6 f4 ff ff       	jmp    80105fa9 <alltraps>

80106ab3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $165
80106ab5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106aba:	e9 ea f4 ff ff       	jmp    80105fa9 <alltraps>

80106abf <vector166>:
.globl vector166
vector166:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $166
80106ac1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ac6:	e9 de f4 ff ff       	jmp    80105fa9 <alltraps>

80106acb <vector167>:
.globl vector167
vector167:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $167
80106acd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ad2:	e9 d2 f4 ff ff       	jmp    80105fa9 <alltraps>

80106ad7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $168
80106ad9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ade:	e9 c6 f4 ff ff       	jmp    80105fa9 <alltraps>

80106ae3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $169
80106ae5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106aea:	e9 ba f4 ff ff       	jmp    80105fa9 <alltraps>

80106aef <vector170>:
.globl vector170
vector170:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $170
80106af1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106af6:	e9 ae f4 ff ff       	jmp    80105fa9 <alltraps>

80106afb <vector171>:
.globl vector171
vector171:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $171
80106afd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b02:	e9 a2 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b07 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $172
80106b09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b0e:	e9 96 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b13 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $173
80106b15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b1a:	e9 8a f4 ff ff       	jmp    80105fa9 <alltraps>

80106b1f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $174
80106b21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b26:	e9 7e f4 ff ff       	jmp    80105fa9 <alltraps>

80106b2b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $175
80106b2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b32:	e9 72 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b37 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $176
80106b39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b3e:	e9 66 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b43 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $177
80106b45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b4a:	e9 5a f4 ff ff       	jmp    80105fa9 <alltraps>

80106b4f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $178
80106b51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b56:	e9 4e f4 ff ff       	jmp    80105fa9 <alltraps>

80106b5b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $179
80106b5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b62:	e9 42 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b67 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $180
80106b69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b6e:	e9 36 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b73 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $181
80106b75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b7a:	e9 2a f4 ff ff       	jmp    80105fa9 <alltraps>

80106b7f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $182
80106b81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b86:	e9 1e f4 ff ff       	jmp    80105fa9 <alltraps>

80106b8b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $183
80106b8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b92:	e9 12 f4 ff ff       	jmp    80105fa9 <alltraps>

80106b97 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $184
80106b99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b9e:	e9 06 f4 ff ff       	jmp    80105fa9 <alltraps>

80106ba3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $185
80106ba5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106baa:	e9 fa f3 ff ff       	jmp    80105fa9 <alltraps>

80106baf <vector186>:
.globl vector186
vector186:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $186
80106bb1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106bb6:	e9 ee f3 ff ff       	jmp    80105fa9 <alltraps>

80106bbb <vector187>:
.globl vector187
vector187:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $187
80106bbd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106bc2:	e9 e2 f3 ff ff       	jmp    80105fa9 <alltraps>

80106bc7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $188
80106bc9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bce:	e9 d6 f3 ff ff       	jmp    80105fa9 <alltraps>

80106bd3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $189
80106bd5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bda:	e9 ca f3 ff ff       	jmp    80105fa9 <alltraps>

80106bdf <vector190>:
.globl vector190
vector190:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $190
80106be1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106be6:	e9 be f3 ff ff       	jmp    80105fa9 <alltraps>

80106beb <vector191>:
.globl vector191
vector191:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $191
80106bed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106bf2:	e9 b2 f3 ff ff       	jmp    80105fa9 <alltraps>

80106bf7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $192
80106bf9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106bfe:	e9 a6 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c03 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $193
80106c05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c0a:	e9 9a f3 ff ff       	jmp    80105fa9 <alltraps>

80106c0f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $194
80106c11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c16:	e9 8e f3 ff ff       	jmp    80105fa9 <alltraps>

80106c1b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $195
80106c1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c22:	e9 82 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c27 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $196
80106c29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c2e:	e9 76 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c33 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $197
80106c35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c3a:	e9 6a f3 ff ff       	jmp    80105fa9 <alltraps>

80106c3f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $198
80106c41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c46:	e9 5e f3 ff ff       	jmp    80105fa9 <alltraps>

80106c4b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $199
80106c4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c52:	e9 52 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c57 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $200
80106c59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c5e:	e9 46 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c63 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $201
80106c65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c6a:	e9 3a f3 ff ff       	jmp    80105fa9 <alltraps>

80106c6f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $202
80106c71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c76:	e9 2e f3 ff ff       	jmp    80105fa9 <alltraps>

80106c7b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $203
80106c7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c82:	e9 22 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c87 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $204
80106c89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c8e:	e9 16 f3 ff ff       	jmp    80105fa9 <alltraps>

80106c93 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $205
80106c95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c9a:	e9 0a f3 ff ff       	jmp    80105fa9 <alltraps>

80106c9f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $206
80106ca1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ca6:	e9 fe f2 ff ff       	jmp    80105fa9 <alltraps>

80106cab <vector207>:
.globl vector207
vector207:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $207
80106cad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106cb2:	e9 f2 f2 ff ff       	jmp    80105fa9 <alltraps>

80106cb7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $208
80106cb9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cbe:	e9 e6 f2 ff ff       	jmp    80105fa9 <alltraps>

80106cc3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $209
80106cc5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cca:	e9 da f2 ff ff       	jmp    80105fa9 <alltraps>

80106ccf <vector210>:
.globl vector210
vector210:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $210
80106cd1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106cd6:	e9 ce f2 ff ff       	jmp    80105fa9 <alltraps>

80106cdb <vector211>:
.globl vector211
vector211:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $211
80106cdd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ce2:	e9 c2 f2 ff ff       	jmp    80105fa9 <alltraps>

80106ce7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $212
80106ce9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cee:	e9 b6 f2 ff ff       	jmp    80105fa9 <alltraps>

80106cf3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $213
80106cf5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106cfa:	e9 aa f2 ff ff       	jmp    80105fa9 <alltraps>

80106cff <vector214>:
.globl vector214
vector214:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $214
80106d01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d06:	e9 9e f2 ff ff       	jmp    80105fa9 <alltraps>

80106d0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $215
80106d0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d12:	e9 92 f2 ff ff       	jmp    80105fa9 <alltraps>

80106d17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $216
80106d19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d1e:	e9 86 f2 ff ff       	jmp    80105fa9 <alltraps>

80106d23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $217
80106d25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d2a:	e9 7a f2 ff ff       	jmp    80105fa9 <alltraps>

80106d2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $218
80106d31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d36:	e9 6e f2 ff ff       	jmp    80105fa9 <alltraps>

80106d3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $219
80106d3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d42:	e9 62 f2 ff ff       	jmp    80105fa9 <alltraps>

80106d47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $220
80106d49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d4e:	e9 56 f2 ff ff       	jmp    80105fa9 <alltraps>

80106d53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $221
80106d55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d5a:	e9 4a f2 ff ff       	jmp    80105fa9 <alltraps>

80106d5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $222
80106d61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d66:	e9 3e f2 ff ff       	jmp    80105fa9 <alltraps>

80106d6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $223
80106d6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d72:	e9 32 f2 ff ff       	jmp    80105fa9 <alltraps>

80106d77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $224
80106d79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d7e:	e9 26 f2 ff ff       	jmp    80105fa9 <alltraps>

80106d83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $225
80106d85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d8a:	e9 1a f2 ff ff       	jmp    80105fa9 <alltraps>

80106d8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $226
80106d91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d96:	e9 0e f2 ff ff       	jmp    80105fa9 <alltraps>

80106d9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $227
80106d9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106da2:	e9 02 f2 ff ff       	jmp    80105fa9 <alltraps>

80106da7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $228
80106da9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106dae:	e9 f6 f1 ff ff       	jmp    80105fa9 <alltraps>

80106db3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $229
80106db5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dba:	e9 ea f1 ff ff       	jmp    80105fa9 <alltraps>

80106dbf <vector230>:
.globl vector230
vector230:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $230
80106dc1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106dc6:	e9 de f1 ff ff       	jmp    80105fa9 <alltraps>

80106dcb <vector231>:
.globl vector231
vector231:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $231
80106dcd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106dd2:	e9 d2 f1 ff ff       	jmp    80105fa9 <alltraps>

80106dd7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $232
80106dd9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dde:	e9 c6 f1 ff ff       	jmp    80105fa9 <alltraps>

80106de3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $233
80106de5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dea:	e9 ba f1 ff ff       	jmp    80105fa9 <alltraps>

80106def <vector234>:
.globl vector234
vector234:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $234
80106df1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106df6:	e9 ae f1 ff ff       	jmp    80105fa9 <alltraps>

80106dfb <vector235>:
.globl vector235
vector235:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $235
80106dfd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e02:	e9 a2 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $236
80106e09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e0e:	e9 96 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $237
80106e15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e1a:	e9 8a f1 ff ff       	jmp    80105fa9 <alltraps>

80106e1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $238
80106e21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e26:	e9 7e f1 ff ff       	jmp    80105fa9 <alltraps>

80106e2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $239
80106e2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e32:	e9 72 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $240
80106e39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e3e:	e9 66 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $241
80106e45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e4a:	e9 5a f1 ff ff       	jmp    80105fa9 <alltraps>

80106e4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $242
80106e51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e56:	e9 4e f1 ff ff       	jmp    80105fa9 <alltraps>

80106e5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $243
80106e5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e62:	e9 42 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $244
80106e69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e6e:	e9 36 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $245
80106e75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e7a:	e9 2a f1 ff ff       	jmp    80105fa9 <alltraps>

80106e7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $246
80106e81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e86:	e9 1e f1 ff ff       	jmp    80105fa9 <alltraps>

80106e8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $247
80106e8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e92:	e9 12 f1 ff ff       	jmp    80105fa9 <alltraps>

80106e97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $248
80106e99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e9e:	e9 06 f1 ff ff       	jmp    80105fa9 <alltraps>

80106ea3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $249
80106ea5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106eaa:	e9 fa f0 ff ff       	jmp    80105fa9 <alltraps>

80106eaf <vector250>:
.globl vector250
vector250:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $250
80106eb1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106eb6:	e9 ee f0 ff ff       	jmp    80105fa9 <alltraps>

80106ebb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $251
80106ebd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ec2:	e9 e2 f0 ff ff       	jmp    80105fa9 <alltraps>

80106ec7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $252
80106ec9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ece:	e9 d6 f0 ff ff       	jmp    80105fa9 <alltraps>

80106ed3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $253
80106ed5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106eda:	e9 ca f0 ff ff       	jmp    80105fa9 <alltraps>

80106edf <vector254>:
.globl vector254
vector254:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $254
80106ee1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ee6:	e9 be f0 ff ff       	jmp    80105fa9 <alltraps>

80106eeb <vector255>:
.globl vector255
vector255:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $255
80106eed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ef2:	e9 b2 f0 ff ff       	jmp    80105fa9 <alltraps>
80106ef7:	66 90                	xchg   %ax,%ax
80106ef9:	66 90                	xchg   %ax,%ax
80106efb:	66 90                	xchg   %ax,%ax
80106efd:	66 90                	xchg   %ax,%ax
80106eff:	90                   	nop

80106f00 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106f08:	c1 ea 16             	shr    $0x16,%edx
80106f0b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106f0e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106f11:	8b 07                	mov    (%edi),%eax
80106f13:	a8 01                	test   $0x1,%al
80106f15:	74 29                	je     80106f40 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f1c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106f25:	c1 eb 0a             	shr    $0xa,%ebx
80106f28:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106f2e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106f31:	5b                   	pop    %ebx
80106f32:	5e                   	pop    %esi
80106f33:	5f                   	pop    %edi
80106f34:	5d                   	pop    %ebp
80106f35:	c3                   	ret    
80106f36:	8d 76 00             	lea    0x0(%esi),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f40:	85 c9                	test   %ecx,%ecx
80106f42:	74 2c                	je     80106f70 <walkpgdir+0x70>
80106f44:	e8 d7 b8 ff ff       	call   80102820 <kalloc>
80106f49:	85 c0                	test   %eax,%eax
80106f4b:	89 c6                	mov    %eax,%esi
80106f4d:	74 21                	je     80106f70 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106f4f:	83 ec 04             	sub    $0x4,%esp
80106f52:	68 00 10 00 00       	push   $0x1000
80106f57:	6a 00                	push   $0x0
80106f59:	50                   	push   %eax
80106f5a:	e8 f1 db ff ff       	call   80104b50 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f5f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f65:	83 c4 10             	add    $0x10,%esp
80106f68:	83 c8 07             	or     $0x7,%eax
80106f6b:	89 07                	mov    %eax,(%edi)
80106f6d:	eb b3                	jmp    80106f22 <walkpgdir+0x22>
80106f6f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106f73:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f80 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f86:	89 d3                	mov    %edx,%ebx
80106f88:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f8e:	83 ec 1c             	sub    $0x1c,%esp
80106f91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f94:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa6:	29 df                	sub    %ebx,%edi
80106fa8:	83 c8 01             	or     $0x1,%eax
80106fab:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fae:	eb 15                	jmp    80106fc5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106fb0:	f6 00 01             	testb  $0x1,(%eax)
80106fb3:	75 45                	jne    80106ffa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fb5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106fb8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fbb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106fbd:	74 31                	je     80106ff0 <mappages+0x70>
      break;
    a += PGSIZE;
80106fbf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fc8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106fcd:	89 da                	mov    %ebx,%edx
80106fcf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106fd2:	e8 29 ff ff ff       	call   80106f00 <walkpgdir>
80106fd7:	85 c0                	test   %eax,%eax
80106fd9:	75 d5                	jne    80106fb0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106fde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106fe3:	5b                   	pop    %ebx
80106fe4:	5e                   	pop    %esi
80106fe5:	5f                   	pop    %edi
80106fe6:	5d                   	pop    %ebp
80106fe7:	c3                   	ret    
80106fe8:	90                   	nop
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106ff3:	31 c0                	xor    %eax,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106ffa:	83 ec 0c             	sub    $0xc,%esp
80106ffd:	68 c4 81 10 80       	push   $0x801081c4
80107002:	e8 69 93 ff ff       	call   80100370 <panic>
80107007:	89 f6                	mov    %esi,%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107016:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010701c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010701e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107024:	83 ec 1c             	sub    $0x1c,%esp
80107027:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010702a:	39 d3                	cmp    %edx,%ebx
8010702c:	73 66                	jae    80107094 <deallocuvm.part.0+0x84>
8010702e:	89 d6                	mov    %edx,%esi
80107030:	eb 3d                	jmp    8010706f <deallocuvm.part.0+0x5f>
80107032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107038:	8b 10                	mov    (%eax),%edx
8010703a:	f6 c2 01             	test   $0x1,%dl
8010703d:	74 26                	je     80107065 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010703f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107045:	74 58                	je     8010709f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107047:	83 ec 0c             	sub    $0xc,%esp
8010704a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107050:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107053:	52                   	push   %edx
80107054:	e8 17 b6 ff ff       	call   80102670 <kfree>
      *pte = 0;
80107059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010705c:	83 c4 10             	add    $0x10,%esp
8010705f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107065:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010706b:	39 f3                	cmp    %esi,%ebx
8010706d:	73 25                	jae    80107094 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010706f:	31 c9                	xor    %ecx,%ecx
80107071:	89 da                	mov    %ebx,%edx
80107073:	89 f8                	mov    %edi,%eax
80107075:	e8 86 fe ff ff       	call   80106f00 <walkpgdir>
    if(!pte)
8010707a:	85 c0                	test   %eax,%eax
8010707c:	75 ba                	jne    80107038 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010707e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107084:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010708a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107090:	39 f3                	cmp    %esi,%ebx
80107092:	72 db                	jb     8010706f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107094:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107097:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709a:	5b                   	pop    %ebx
8010709b:	5e                   	pop    %esi
8010709c:	5f                   	pop    %edi
8010709d:	5d                   	pop    %ebp
8010709e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010709f:	83 ec 0c             	sub    $0xc,%esp
801070a2:	68 e6 7a 10 80       	push   $0x80107ae6
801070a7:	e8 c4 92 ff ff       	call   80100370 <panic>
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070b0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801070b6:	e8 75 ca ff ff       	call   80103b30 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070bb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070c1:	31 c9                	xor    %ecx,%ecx
801070c3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801070c8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
801070cf:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070d6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801070db:	31 c9                	xor    %ecx,%ecx
801070dd:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070e4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070e9:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070f0:	31 c9                	xor    %ecx,%ecx
801070f2:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
801070f9:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107100:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107105:	31 c9                	xor    %ecx,%ecx
80107107:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010710e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107115:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010711a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80107121:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80107128:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010712f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80107136:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
8010713d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80107144:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010714b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80107152:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80107159:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80107160:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107167:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
8010716e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80107175:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
8010717c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80107183:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010718a:	05 f0 37 11 80       	add    $0x801137f0,%eax
8010718f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107193:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107197:	c1 e8 10             	shr    $0x10,%eax
8010719a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010719e:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071a1:	0f 01 10             	lgdtl  (%eax)
}
801071a4:	c9                   	leave  
801071a5:	c3                   	ret    
801071a6:	8d 76 00             	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071b0:	a1 a4 6a 11 80       	mov    0x80116aa4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801071b5:	55                   	push   %ebp
801071b6:	89 e5                	mov    %esp,%ebp
801071b8:	05 00 00 00 80       	add    $0x80000000,%eax
801071bd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801071c0:	5d                   	pop    %ebp
801071c1:	c3                   	ret    
801071c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071d0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 1c             	sub    $0x1c,%esp
801071d9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801071dc:	85 f6                	test   %esi,%esi
801071de:	0f 84 cd 00 00 00    	je     801072b1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801071e4:	8b 46 08             	mov    0x8(%esi),%eax
801071e7:	85 c0                	test   %eax,%eax
801071e9:	0f 84 dc 00 00 00    	je     801072cb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801071ef:	8b 7e 04             	mov    0x4(%esi),%edi
801071f2:	85 ff                	test   %edi,%edi
801071f4:	0f 84 c4 00 00 00    	je     801072be <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801071fa:	e8 71 d7 ff ff       	call   80104970 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071ff:	e8 ac c8 ff ff       	call   80103ab0 <mycpu>
80107204:	89 c3                	mov    %eax,%ebx
80107206:	e8 a5 c8 ff ff       	call   80103ab0 <mycpu>
8010720b:	89 c7                	mov    %eax,%edi
8010720d:	e8 9e c8 ff ff       	call   80103ab0 <mycpu>
80107212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107215:	83 c7 08             	add    $0x8,%edi
80107218:	e8 93 c8 ff ff       	call   80103ab0 <mycpu>
8010721d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107220:	83 c0 08             	add    $0x8,%eax
80107223:	ba 67 00 00 00       	mov    $0x67,%edx
80107228:	c1 e8 18             	shr    $0x18,%eax
8010722b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107232:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107239:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107240:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107247:	83 c1 08             	add    $0x8,%ecx
8010724a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107250:	c1 e9 10             	shr    $0x10,%ecx
80107253:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107259:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010725e:	e8 4d c8 ff ff       	call   80103ab0 <mycpu>
80107263:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010726a:	e8 41 c8 ff ff       	call   80103ab0 <mycpu>
8010726f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107274:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107278:	e8 33 c8 ff ff       	call   80103ab0 <mycpu>
8010727d:	8b 56 08             	mov    0x8(%esi),%edx
80107280:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107286:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107289:	e8 22 c8 ff ff       	call   80103ab0 <mycpu>
8010728e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107292:	b8 28 00 00 00       	mov    $0x28,%eax
80107297:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010729a:	8b 46 04             	mov    0x4(%esi),%eax
8010729d:	05 00 00 00 80       	add    $0x80000000,%eax
801072a2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801072a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a8:	5b                   	pop    %ebx
801072a9:	5e                   	pop    %esi
801072aa:	5f                   	pop    %edi
801072ab:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801072ac:	e9 ff d6 ff ff       	jmp    801049b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801072b1:	83 ec 0c             	sub    $0xc,%esp
801072b4:	68 ca 81 10 80       	push   $0x801081ca
801072b9:	e8 b2 90 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801072be:	83 ec 0c             	sub    $0xc,%esp
801072c1:	68 f5 81 10 80       	push   $0x801081f5
801072c6:	e8 a5 90 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801072cb:	83 ec 0c             	sub    $0xc,%esp
801072ce:	68 e0 81 10 80       	push   $0x801081e0
801072d3:	e8 98 90 ff ff       	call   80100370 <panic>
801072d8:	90                   	nop
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
801072e9:	8b 75 10             	mov    0x10(%ebp),%esi
801072ec:	8b 45 08             	mov    0x8(%ebp),%eax
801072ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801072f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801072f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801072fb:	77 49                	ja     80107346 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801072fd:	e8 1e b5 ff ff       	call   80102820 <kalloc>
  memset(mem, 0, PGSIZE);
80107302:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107305:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107307:	68 00 10 00 00       	push   $0x1000
8010730c:	6a 00                	push   $0x0
8010730e:	50                   	push   %eax
8010730f:	e8 3c d8 ff ff       	call   80104b50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107314:	58                   	pop    %eax
80107315:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010731b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107320:	5a                   	pop    %edx
80107321:	6a 06                	push   $0x6
80107323:	50                   	push   %eax
80107324:	31 d2                	xor    %edx,%edx
80107326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107329:	e8 52 fc ff ff       	call   80106f80 <mappages>
  memmove(mem, init, sz);
8010732e:	89 75 10             	mov    %esi,0x10(%ebp)
80107331:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107334:	83 c4 10             	add    $0x10,%esp
80107337:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010733a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010733d:	5b                   	pop    %ebx
8010733e:	5e                   	pop    %esi
8010733f:	5f                   	pop    %edi
80107340:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107341:	e9 ba d8 ff ff       	jmp    80104c00 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107346:	83 ec 0c             	sub    $0xc,%esp
80107349:	68 09 82 10 80       	push   $0x80108209
8010734e:	e8 1d 90 ff ff       	call   80100370 <panic>
80107353:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107360 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107369:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107370:	0f 85 91 00 00 00    	jne    80107407 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107376:	8b 75 18             	mov    0x18(%ebp),%esi
80107379:	31 db                	xor    %ebx,%ebx
8010737b:	85 f6                	test   %esi,%esi
8010737d:	75 1a                	jne    80107399 <loaduvm+0x39>
8010737f:	eb 6f                	jmp    801073f0 <loaduvm+0x90>
80107381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107388:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010738e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107394:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107397:	76 57                	jbe    801073f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107399:	8b 55 0c             	mov    0xc(%ebp),%edx
8010739c:	8b 45 08             	mov    0x8(%ebp),%eax
8010739f:	31 c9                	xor    %ecx,%ecx
801073a1:	01 da                	add    %ebx,%edx
801073a3:	e8 58 fb ff ff       	call   80106f00 <walkpgdir>
801073a8:	85 c0                	test   %eax,%eax
801073aa:	74 4e                	je     801073fa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801073ac:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801073b1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801073b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801073bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073c1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073c4:	01 d9                	add    %ebx,%ecx
801073c6:	05 00 00 00 80       	add    $0x80000000,%eax
801073cb:	57                   	push   %edi
801073cc:	51                   	push   %ecx
801073cd:	50                   	push   %eax
801073ce:	ff 75 10             	pushl  0x10(%ebp)
801073d1:	e8 0a a9 ff ff       	call   80101ce0 <readi>
801073d6:	83 c4 10             	add    $0x10,%esp
801073d9:	39 c7                	cmp    %eax,%edi
801073db:	74 ab                	je     80107388 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801073dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801073e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801073e5:	5b                   	pop    %ebx
801073e6:	5e                   	pop    %esi
801073e7:	5f                   	pop    %edi
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    
801073ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801073f3:	31 c0                	xor    %eax,%eax
}
801073f5:	5b                   	pop    %ebx
801073f6:	5e                   	pop    %esi
801073f7:	5f                   	pop    %edi
801073f8:	5d                   	pop    %ebp
801073f9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801073fa:	83 ec 0c             	sub    $0xc,%esp
801073fd:	68 23 82 10 80       	push   $0x80108223
80107402:	e8 69 8f ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107407:	83 ec 0c             	sub    $0xc,%esp
8010740a:	68 c4 82 10 80       	push   $0x801082c4
8010740f:	e8 5c 8f ff ff       	call   80100370 <panic>
80107414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010741a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107420 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 0c             	sub    $0xc,%esp
80107429:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010742c:	85 ff                	test   %edi,%edi
8010742e:	0f 88 ca 00 00 00    	js     801074fe <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107434:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107437:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010743a:	0f 82 82 00 00 00    	jb     801074c2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107440:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107446:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010744c:	39 df                	cmp    %ebx,%edi
8010744e:	77 43                	ja     80107493 <allocuvm+0x73>
80107450:	e9 bb 00 00 00       	jmp    80107510 <allocuvm+0xf0>
80107455:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107458:	83 ec 04             	sub    $0x4,%esp
8010745b:	68 00 10 00 00       	push   $0x1000
80107460:	6a 00                	push   $0x0
80107462:	50                   	push   %eax
80107463:	e8 e8 d6 ff ff       	call   80104b50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107468:	58                   	pop    %eax
80107469:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010746f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107474:	5a                   	pop    %edx
80107475:	6a 06                	push   $0x6
80107477:	50                   	push   %eax
80107478:	89 da                	mov    %ebx,%edx
8010747a:	8b 45 08             	mov    0x8(%ebp),%eax
8010747d:	e8 fe fa ff ff       	call   80106f80 <mappages>
80107482:	83 c4 10             	add    $0x10,%esp
80107485:	85 c0                	test   %eax,%eax
80107487:	78 47                	js     801074d0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107489:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010748f:	39 df                	cmp    %ebx,%edi
80107491:	76 7d                	jbe    80107510 <allocuvm+0xf0>
    mem = kalloc();
80107493:	e8 88 b3 ff ff       	call   80102820 <kalloc>
    if(mem == 0){
80107498:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010749a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010749c:	75 ba                	jne    80107458 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010749e:	83 ec 0c             	sub    $0xc,%esp
801074a1:	68 41 82 10 80       	push   $0x80108241
801074a6:	e8 b5 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801074ab:	83 c4 10             	add    $0x10,%esp
801074ae:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801074b1:	76 4b                	jbe    801074fe <allocuvm+0xde>
801074b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074b6:	8b 45 08             	mov    0x8(%ebp),%eax
801074b9:	89 fa                	mov    %edi,%edx
801074bb:	e8 50 fb ff ff       	call   80107010 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801074c0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801074c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801074d0:	83 ec 0c             	sub    $0xc,%esp
801074d3:	68 59 82 10 80       	push   $0x80108259
801074d8:	e8 83 91 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801074dd:	83 c4 10             	add    $0x10,%esp
801074e0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801074e3:	76 0d                	jbe    801074f2 <allocuvm+0xd2>
801074e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074e8:	8b 45 08             	mov    0x8(%ebp),%eax
801074eb:	89 fa                	mov    %edi,%edx
801074ed:	e8 1e fb ff ff       	call   80107010 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801074f2:	83 ec 0c             	sub    $0xc,%esp
801074f5:	56                   	push   %esi
801074f6:	e8 75 b1 ff ff       	call   80102670 <kfree>
      return 0;
801074fb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801074fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107501:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107503:	5b                   	pop    %ebx
80107504:	5e                   	pop    %esi
80107505:	5f                   	pop    %edi
80107506:	5d                   	pop    %ebp
80107507:	c3                   	ret    
80107508:	90                   	nop
80107509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107510:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107513:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret    
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107520 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	8b 55 0c             	mov    0xc(%ebp),%edx
80107526:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107529:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010752c:	39 d1                	cmp    %edx,%ecx
8010752e:	73 10                	jae    80107540 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107530:	5d                   	pop    %ebp
80107531:	e9 da fa ff ff       	jmp    80107010 <deallocuvm.part.0>
80107536:	8d 76 00             	lea    0x0(%esi),%esi
80107539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107540:	89 d0                	mov    %edx,%eax
80107542:	5d                   	pop    %ebp
80107543:	c3                   	ret    
80107544:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010754a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107550 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 0c             	sub    $0xc,%esp
80107559:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010755c:	85 f6                	test   %esi,%esi
8010755e:	74 59                	je     801075b9 <freevm+0x69>
80107560:	31 c9                	xor    %ecx,%ecx
80107562:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107567:	89 f0                	mov    %esi,%eax
80107569:	e8 a2 fa ff ff       	call   80107010 <deallocuvm.part.0>
8010756e:	89 f3                	mov    %esi,%ebx
80107570:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107576:	eb 0f                	jmp    80107587 <freevm+0x37>
80107578:	90                   	nop
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107580:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107583:	39 fb                	cmp    %edi,%ebx
80107585:	74 23                	je     801075aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107587:	8b 03                	mov    (%ebx),%eax
80107589:	a8 01                	test   $0x1,%al
8010758b:	74 f3                	je     80107580 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010758d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107592:	83 ec 0c             	sub    $0xc,%esp
80107595:	83 c3 04             	add    $0x4,%ebx
80107598:	05 00 00 00 80       	add    $0x80000000,%eax
8010759d:	50                   	push   %eax
8010759e:	e8 cd b0 ff ff       	call   80102670 <kfree>
801075a3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801075a6:	39 fb                	cmp    %edi,%ebx
801075a8:	75 dd                	jne    80107587 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801075aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801075ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b0:	5b                   	pop    %ebx
801075b1:	5e                   	pop    %esi
801075b2:	5f                   	pop    %edi
801075b3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801075b4:	e9 b7 b0 ff ff       	jmp    80102670 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801075b9:	83 ec 0c             	sub    $0xc,%esp
801075bc:	68 75 82 10 80       	push   $0x80108275
801075c1:	e8 aa 8d ff ff       	call   80100370 <panic>
801075c6:	8d 76 00             	lea    0x0(%esi),%esi
801075c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075d0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	56                   	push   %esi
801075d4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801075d5:	e8 46 b2 ff ff       	call   80102820 <kalloc>
801075da:	85 c0                	test   %eax,%eax
801075dc:	74 6a                	je     80107648 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801075de:	83 ec 04             	sub    $0x4,%esp
801075e1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801075e8:	68 00 10 00 00       	push   $0x1000
801075ed:	6a 00                	push   $0x0
801075ef:	50                   	push   %eax
801075f0:	e8 5b d5 ff ff       	call   80104b50 <memset>
801075f5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075f8:	8b 43 04             	mov    0x4(%ebx),%eax
801075fb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075fe:	83 ec 08             	sub    $0x8,%esp
80107601:	8b 13                	mov    (%ebx),%edx
80107603:	ff 73 0c             	pushl  0xc(%ebx)
80107606:	50                   	push   %eax
80107607:	29 c1                	sub    %eax,%ecx
80107609:	89 f0                	mov    %esi,%eax
8010760b:	e8 70 f9 ff ff       	call   80106f80 <mappages>
80107610:	83 c4 10             	add    $0x10,%esp
80107613:	85 c0                	test   %eax,%eax
80107615:	78 19                	js     80107630 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107617:	83 c3 10             	add    $0x10,%ebx
8010761a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107620:	75 d6                	jne    801075f8 <setupkvm+0x28>
80107622:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107627:	5b                   	pop    %ebx
80107628:	5e                   	pop    %esi
80107629:	5d                   	pop    %ebp
8010762a:	c3                   	ret    
8010762b:	90                   	nop
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107630:	83 ec 0c             	sub    $0xc,%esp
80107633:	56                   	push   %esi
80107634:	e8 17 ff ff ff       	call   80107550 <freevm>
      return 0;
80107639:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010763c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010763f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107641:	5b                   	pop    %ebx
80107642:	5e                   	pop    %esi
80107643:	5d                   	pop    %ebp
80107644:	c3                   	ret    
80107645:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107648:	31 c0                	xor    %eax,%eax
8010764a:	eb d8                	jmp    80107624 <setupkvm+0x54>
8010764c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107650 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107656:	e8 75 ff ff ff       	call   801075d0 <setupkvm>
8010765b:	a3 a4 6a 11 80       	mov    %eax,0x80116aa4
80107660:	05 00 00 00 80       	add    $0x80000000,%eax
80107665:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107668:	c9                   	leave  
80107669:	c3                   	ret    
8010766a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107670 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107670:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107671:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107673:	89 e5                	mov    %esp,%ebp
80107675:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107678:	8b 55 0c             	mov    0xc(%ebp),%edx
8010767b:	8b 45 08             	mov    0x8(%ebp),%eax
8010767e:	e8 7d f8 ff ff       	call   80106f00 <walkpgdir>
  if(pte == 0)
80107683:	85 c0                	test   %eax,%eax
80107685:	74 05                	je     8010768c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107687:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010768a:	c9                   	leave  
8010768b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010768c:	83 ec 0c             	sub    $0xc,%esp
8010768f:	68 86 82 10 80       	push   $0x80108286
80107694:	e8 d7 8c ff ff       	call   80100370 <panic>
80107699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076a9:	e8 22 ff ff ff       	call   801075d0 <setupkvm>
801076ae:	85 c0                	test   %eax,%eax
801076b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076b3:	0f 84 c5 00 00 00    	je     8010777e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076bc:	85 c9                	test   %ecx,%ecx
801076be:	0f 84 9c 00 00 00    	je     80107760 <copyuvm+0xc0>
801076c4:	31 ff                	xor    %edi,%edi
801076c6:	eb 4a                	jmp    80107712 <copyuvm+0x72>
801076c8:	90                   	nop
801076c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076d0:	83 ec 04             	sub    $0x4,%esp
801076d3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801076d9:	68 00 10 00 00       	push   $0x1000
801076de:	53                   	push   %ebx
801076df:	50                   	push   %eax
801076e0:	e8 1b d5 ff ff       	call   80104c00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076e5:	58                   	pop    %eax
801076e6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076f1:	5a                   	pop    %edx
801076f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801076f5:	50                   	push   %eax
801076f6:	89 fa                	mov    %edi,%edx
801076f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076fb:	e8 80 f8 ff ff       	call   80106f80 <mappages>
80107700:	83 c4 10             	add    $0x10,%esp
80107703:	85 c0                	test   %eax,%eax
80107705:	78 69                	js     80107770 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107707:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010770d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107710:	76 4e                	jbe    80107760 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107712:	8b 45 08             	mov    0x8(%ebp),%eax
80107715:	31 c9                	xor    %ecx,%ecx
80107717:	89 fa                	mov    %edi,%edx
80107719:	e8 e2 f7 ff ff       	call   80106f00 <walkpgdir>
8010771e:	85 c0                	test   %eax,%eax
80107720:	74 6d                	je     8010778f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107722:	8b 00                	mov    (%eax),%eax
80107724:	a8 01                	test   $0x1,%al
80107726:	74 5a                	je     80107782 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107728:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010772a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010772f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107738:	e8 e3 b0 ff ff       	call   80102820 <kalloc>
8010773d:	85 c0                	test   %eax,%eax
8010773f:	89 c6                	mov    %eax,%esi
80107741:	75 8d                	jne    801076d0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107743:	83 ec 0c             	sub    $0xc,%esp
80107746:	ff 75 e0             	pushl  -0x20(%ebp)
80107749:	e8 02 fe ff ff       	call   80107550 <freevm>
  return 0;
8010774e:	83 c4 10             	add    $0x10,%esp
80107751:	31 c0                	xor    %eax,%eax
}
80107753:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107756:	5b                   	pop    %ebx
80107757:	5e                   	pop    %esi
80107758:	5f                   	pop    %edi
80107759:	5d                   	pop    %ebp
8010775a:	c3                   	ret    
8010775b:	90                   	nop
8010775c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107763:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107766:	5b                   	pop    %ebx
80107767:	5e                   	pop    %esi
80107768:	5f                   	pop    %edi
80107769:	5d                   	pop    %ebp
8010776a:	c3                   	ret    
8010776b:	90                   	nop
8010776c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	56                   	push   %esi
80107774:	e8 f7 ae ff ff       	call   80102670 <kfree>
      goto bad;
80107779:	83 c4 10             	add    $0x10,%esp
8010777c:	eb c5                	jmp    80107743 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010777e:	31 c0                	xor    %eax,%eax
80107780:	eb d1                	jmp    80107753 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107782:	83 ec 0c             	sub    $0xc,%esp
80107785:	68 aa 82 10 80       	push   $0x801082aa
8010778a:	e8 e1 8b ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010778f:	83 ec 0c             	sub    $0xc,%esp
80107792:	68 90 82 10 80       	push   $0x80108290
80107797:	e8 d4 8b ff ff       	call   80100370 <panic>
8010779c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077a1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077a3:	89 e5                	mov    %esp,%ebp
801077a5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ab:	8b 45 08             	mov    0x8(%ebp),%eax
801077ae:	e8 4d f7 ff ff       	call   80106f00 <walkpgdir>
  if((*pte & PTE_P) == 0)
801077b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801077b5:	89 c2                	mov    %eax,%edx
801077b7:	83 e2 05             	and    $0x5,%edx
801077ba:	83 fa 05             	cmp    $0x5,%edx
801077bd:	75 11                	jne    801077d0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801077bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801077c4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801077c5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801077ca:	c3                   	ret    
801077cb:	90                   	nop
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801077d0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801077d2:	c9                   	leave  
801077d3:	c3                   	ret    
801077d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801077e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 1c             	sub    $0x1c,%esp
801077e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801077ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077f2:	85 db                	test   %ebx,%ebx
801077f4:	75 40                	jne    80107836 <copyout+0x56>
801077f6:	eb 70                	jmp    80107868 <copyout+0x88>
801077f8:	90                   	nop
801077f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107800:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107803:	89 f1                	mov    %esi,%ecx
80107805:	29 d1                	sub    %edx,%ecx
80107807:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010780d:	39 d9                	cmp    %ebx,%ecx
8010780f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107812:	29 f2                	sub    %esi,%edx
80107814:	83 ec 04             	sub    $0x4,%esp
80107817:	01 d0                	add    %edx,%eax
80107819:	51                   	push   %ecx
8010781a:	57                   	push   %edi
8010781b:	50                   	push   %eax
8010781c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010781f:	e8 dc d3 ff ff       	call   80104c00 <memmove>
    len -= n;
    buf += n;
80107824:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107827:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010782a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107830:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107832:	29 cb                	sub    %ecx,%ebx
80107834:	74 32                	je     80107868 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107836:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107838:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010783b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010783e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107844:	56                   	push   %esi
80107845:	ff 75 08             	pushl  0x8(%ebp)
80107848:	e8 53 ff ff ff       	call   801077a0 <uva2ka>
    if(pa0 == 0)
8010784d:	83 c4 10             	add    $0x10,%esp
80107850:	85 c0                	test   %eax,%eax
80107852:	75 ac                	jne    80107800 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010785c:	5b                   	pop    %ebx
8010785d:	5e                   	pop    %esi
8010785e:	5f                   	pop    %edi
8010785f:	5d                   	pop    %ebp
80107860:	c3                   	ret    
80107861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107868:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010786b:	31 c0                	xor    %eax,%eax
}
8010786d:	5b                   	pop    %ebx
8010786e:	5e                   	pop    %esi
8010786f:	5f                   	pop    %edi
80107870:	5d                   	pop    %ebp
80107871:	c3                   	ret    
