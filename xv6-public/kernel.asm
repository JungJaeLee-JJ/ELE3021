
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 40 72 10 80       	push   $0x80107240
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 a5 43 00 00       	call   80104400 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 72 10 80       	push   $0x80107247
80100097:	50                   	push   %eax
80100098:	e8 33 42 00 00       	call   801042d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

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
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 77 44 00 00       	call   80104560 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 a9 44 00 00       	call   80104610 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 41 00 00       	call   80104310 <acquiresleep>
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
8010017e:	e8 5d 1f 00 00       	call   801020e0 <iderw>
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
80100193:	68 4e 72 10 80       	push   $0x8010724e
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
801001ae:	e8 fd 41 00 00       	call   801043b0 <holdingsleep>
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
801001c4:	e9 17 1f 00 00       	jmp    801020e0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 72 10 80       	push   $0x8010725f
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
801001ef:	e8 bc 41 00 00       	call   801043b0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 41 00 00       	call   80104370 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 50 43 00 00       	call   80104560 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
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
8010025c:	e9 af 43 00 00       	jmp    80104610 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 72 10 80       	push   $0x80107266
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
80100280:	e8 bb 14 00 00       	call   80101740 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 cf 42 00 00       	call   80104560 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 9e 3c 00 00       	call   80103f60 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 c9 34 00 00       	call   801037a0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 25 43 00 00       	call   80104610 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 6d 13 00 00       	call   80101660 <ilock>
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
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
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
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 c5 42 00 00       	call   80104610 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 0d 13 00 00       	call   80101660 <ilock>

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
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
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
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
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
80100389:	e8 52 23 00 00       	call   801026e0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 6d 72 10 80       	push   $0x8010726d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 c3 7b 10 80 	movl   $0x80107bc3,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 63 40 00 00       	call   80104420 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 81 72 10 80       	push   $0x80107281
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
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
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
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
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
8010041a:	e8 e1 59 00 00       	call   80105e00 <uartputc>
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
801004d3:	e8 28 59 00 00       	call   80105e00 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 1c 59 00 00       	call   80105e00 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 10 59 00 00       	call   80105e00 <uartputc>
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
80100514:	e8 f7 41 00 00       	call   80104710 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 32 41 00 00       	call   80104660 <memset>
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
80100540:	68 85 72 10 80       	push   $0x80107285
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
801005b1:	0f b6 92 b0 72 10 80 	movzbl -0x7fef8d50(%edx),%edx
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
8010060f:	e8 2c 11 00 00       	call   80101740 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 40 3f 00 00       	call   80104560 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 c4 3f 00 00       	call   80104610 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 10 00 00       	call   80101660 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 fe 3e 00 00       	call   80104610 <release>
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
80100788:	b8 98 72 10 80       	mov    $0x80107298,%eax
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
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 93 3d 00 00       	call   80104560 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 9f 72 10 80       	push   $0x8010729f
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
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 58 3d 00 00       	call   80104560 <acquire>
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
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 a3 3d 00 00       	call   80104610 <release>
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
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
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
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
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
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 25 38 00 00       	call   80104120 <wakeup>
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
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
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
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
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
80100977:	e9 94 38 00 00       	jmp    80104210 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
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
801009a6:	68 a8 72 10 80       	push   $0x801072a8
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 4b 3a 00 00       	call   80104400 <initlock>

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
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 b2 18 00 00       	call   80102290 <ioapicenable>
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
801009fc:	e8 9f 2d 00 00       	call   801037a0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 34 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 99 14 00 00       	call   80101eb0 <namei>
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
80100a28:	e8 33 0c 00 00       	call   80101660 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 02 0f 00 00       	call   80101940 <readi>
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
80100a4a:	e8 a1 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a4f:	e8 5c 21 00 00       	call   80102bb0 <end_op>
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
80100a74:	e8 17 65 00 00       	call   80106f90 <setupkvm>
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
80100ac8:	e8 73 0e 00 00       	call   80101940 <readi>
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
80100b04:	e8 d7 62 00 00       	call   80106de0 <allocuvm>
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
80100b3a:	e8 e1 61 00 00       	call   80106d20 <loaduvm>
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
80100b59:	e8 b2 63 00 00       	call   80106f10 <freevm>
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
80100b6a:	e8 81 0d 00 00       	call   801018f0 <iunlockput>
  end_op();
80100b6f:	e8 3c 20 00 00       	call   80102bb0 <end_op>
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
80100b95:	e8 46 62 00 00       	call   80106de0 <allocuvm>
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
80100bac:	e8 5f 63 00 00       	call   80106f10 <freevm>
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
80100bbe:	e8 ed 1f 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 c1 72 10 80       	push   $0x801072c1
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
80100bf1:	e8 3a 64 00 00       	call   80107030 <clearpteu>
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
80100c2d:	e8 6e 3c 00 00       	call   801048a0 <strlen>
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
80100c40:	e8 5b 3c 00 00       	call   801048a0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 4a 65 00 00       	call   801071a0 <copyout>
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
80100cbb:	e8 e0 64 00 00       	call   801071a0 <copyout>
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
80100d00:	e8 5b 3b 00 00       	call   80104860 <safestrcpy>

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
80100d2c:	e8 5f 5e 00 00       	call   80106b90 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 d7 61 00 00       	call   80106f10 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 cd 72 10 80       	push   $0x801072cd
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 9b 36 00 00       	call   80104400 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 da 37 00 00       	call   80104560 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 5a 38 00 00       	call   80104610 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 43 38 00 00       	call   80104610 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 6c 37 00 00       	call   80104560 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 ff 37 00 00       	call   80104610 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 d4 72 10 80       	push   $0x801072d4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 1a 37 00 00       	call   80104560 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 9f 37 00 00       	jmp    80104610 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 73 37 00 00       	call   80104610 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 1a 24 00 00       	call   801032e0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 6b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 b0 08 00 00       	call   80101790 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 c1 1c 00 00       	jmp    80102bb0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 dc 72 10 80       	push   $0x801072dc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 46 07 00 00       	call   80101660 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 e9 09 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 10 08 00 00       	call   80101740 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 e1 06 00 00       	call   80101660 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 b4 09 00 00       	call   80101940 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 9d 07 00 00       	call   80101740 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 be 24 00 00       	jmp    80103480 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 e6 72 10 80       	push   $0x801072e6
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 07 07 00 00       	call   80101740 <iunlock>
      end_op();
80101039:	e8 72 1b 00 00       	call   80102bb0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 d5 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 ea 05 00 00       	call   80101660 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 b8 09 00 00       	call   80101a40 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 a3 06 00 00       	call   80101740 <iunlock>
      end_op();
8010109d:	e8 0e 1b 00 00       	call   80102bb0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 9f 22 00 00       	jmp    80103380 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 ef 72 10 80       	push   $0x801072ef
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 f5 72 10 80       	push   $0x801072f5
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	56                   	push   %esi
80101104:	53                   	push   %ebx
80101105:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101107:	c1 ea 0c             	shr    $0xc,%edx
8010110a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101110:	83 ec 08             	sub    $0x8,%esp
80101113:	52                   	push   %edx
80101114:	50                   	push   %eax
80101115:	e8 b6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010111a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010111c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
80101127:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112a:	c1 fb 03             	sar    $0x3,%ebx
8010112d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101130:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101132:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101137:	85 d1                	test   %edx,%ecx
80101139:	74 27                	je     80101162 <bfree+0x62>
8010113b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010113d:	f7 d2                	not    %edx
8010113f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101141:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101144:	21 d0                	and    %edx,%eax
80101146:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010114a:	56                   	push   %esi
8010114b:	e8 d0 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101150:	89 34 24             	mov    %esi,(%esp)
80101153:	e8 88 f0 ff ff       	call   801001e0 <brelse>
}
80101158:	83 c4 10             	add    $0x10,%esp
8010115b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010115e:	5b                   	pop    %ebx
8010115f:	5e                   	pop    %esi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101162:	83 ec 0c             	sub    $0xc,%esp
80101165:	68 ff 72 10 80       	push   $0x801072ff
8010116a:	e8 01 f2 ff ff       	call   80100370 <panic>
8010116f:	90                   	nop

80101170 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	57                   	push   %edi
80101174:	56                   	push   %esi
80101175:	53                   	push   %ebx
80101176:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101179:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010117f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101182:	85 c9                	test   %ecx,%ecx
80101184:	0f 84 85 00 00 00    	je     8010120f <balloc+0x9f>
8010118a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101191:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	89 f0                	mov    %esi,%eax
80101199:	c1 f8 0c             	sar    $0xc,%eax
8010119c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011a2:	50                   	push   %eax
801011a3:	ff 75 d8             	pushl  -0x28(%ebp)
801011a6:	e8 25 ef ff ff       	call   801000d0 <bread>
801011ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ae:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011b3:	83 c4 10             	add    $0x10,%esp
801011b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b9:	31 c0                	xor    %eax,%eax
801011bb:	eb 2d                	jmp    801011ea <balloc+0x7a>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011c0:	89 c1                	mov    %eax,%ecx
801011c2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ca:	83 e1 07             	and    $0x7,%ecx
801011cd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011cf:	89 c1                	mov    %eax,%ecx
801011d1:	c1 f9 03             	sar    $0x3,%ecx
801011d4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011d9:	85 d7                	test   %edx,%edi
801011db:	74 43                	je     80101220 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011dd:	83 c0 01             	add    $0x1,%eax
801011e0:	83 c6 01             	add    $0x1,%esi
801011e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011e8:	74 05                	je     801011ef <balloc+0x7f>
801011ea:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ed:	72 d1                	jb     801011c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011fa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101201:	83 c4 10             	add    $0x10,%esp
80101204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101207:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010120d:	77 82                	ja     80101191 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	68 12 73 10 80       	push   $0x80107312
80101217:	e8 54 f1 ff ff       	call   80100370 <panic>
8010121c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101220:	09 fa                	or     %edi,%edx
80101222:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101225:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101228:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010122c:	57                   	push   %edi
8010122d:	e8 ee 1a 00 00       	call   80102d20 <log_write>
        brelse(bp);
80101232:	89 3c 24             	mov    %edi,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010123a:	58                   	pop    %eax
8010123b:	5a                   	pop    %edx
8010123c:	56                   	push   %esi
8010123d:	ff 75 d8             	pushl  -0x28(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101247:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124a:	83 c4 0c             	add    $0xc,%esp
8010124d:	68 00 02 00 00       	push   $0x200
80101252:	6a 00                	push   $0x0
80101254:	50                   	push   %eax
80101255:	e8 06 34 00 00       	call   80104660 <memset>
  log_write(bp);
8010125a:	89 1c 24             	mov    %ebx,(%esp)
8010125d:	e8 be 1a 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101262:	89 1c 24             	mov    %ebx,(%esp)
80101265:	e8 76 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010127a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101280 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101288:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101295:	68 e0 09 11 80       	push   $0x801109e0
8010129a:	e8 c1 32 00 00       	call   80104560 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 1b                	jmp    801012c2 <iget+0x42>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 44                	je     801012f8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ba:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012c0:	74 4e                	je     80101310 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c5:	85 c9                	test   %ecx,%ecx
801012c7:	7e e7                	jle    801012b0 <iget+0x30>
801012c9:	39 3b                	cmp    %edi,(%ebx)
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012d0:	75 de                	jne    801012b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012d2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012d5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012d8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012da:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012df:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012e2:	e8 29 33 00 00       	call   80104610 <release>
      return ip;
801012e7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ed:	89 f0                	mov    %esi,%eax
801012ef:	5b                   	pop    %ebx
801012f0:	5e                   	pop    %esi
801012f1:	5f                   	pop    %edi
801012f2:	5d                   	pop    %ebp
801012f3:	c3                   	ret    
801012f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 c9                	test   %ecx,%ecx
801012fa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fd:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101303:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101309:	75 b7                	jne    801012c2 <iget+0x42>
8010130b:	90                   	nop
8010130c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101310:	85 f6                	test   %esi,%esi
80101312:	74 2d                	je     80101341 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101314:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101317:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101319:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010131c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101323:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010132a:	68 e0 09 11 80       	push   $0x801109e0
8010132f:	e8 dc 32 00 00       	call   80104610 <release>

  return ip;
80101334:	83 c4 10             	add    $0x10,%esp
}
80101337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	5b                   	pop    %ebx
8010133d:	5e                   	pop    %esi
8010133e:	5f                   	pop    %edi
8010133f:	5d                   	pop    %ebp
80101340:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	68 28 73 10 80       	push   $0x80107328
80101349:	e8 22 f0 ff ff       	call   80100370 <panic>
8010134e:	66 90                	xchg   %ax,%ax

80101350 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	89 c6                	mov    %eax,%esi
80101358:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010135b:	83 fa 0b             	cmp    $0xb,%edx
8010135e:	77 18                	ja     80101378 <bmap+0x28>
80101360:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101363:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101366:	85 c0                	test   %eax,%eax
80101368:	74 76                	je     801013e0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101378:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010137b:	83 fb 7f             	cmp    $0x7f,%ebx
8010137e:	0f 87 83 00 00 00    	ja     80101407 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101384:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010138a:	85 c0                	test   %eax,%eax
8010138c:	74 6a                	je     801013f8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010138e:	83 ec 08             	sub    $0x8,%esp
80101391:	50                   	push   %eax
80101392:	ff 36                	pushl  (%esi)
80101394:	e8 37 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101399:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010139d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013a0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a2:	8b 1a                	mov    (%edx),%ebx
801013a4:	85 db                	test   %ebx,%ebx
801013a6:	75 1d                	jne    801013c5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ad:	e8 be fd ff ff       	call   80101170 <balloc>
801013b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013b5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013b8:	89 c3                	mov    %eax,%ebx
801013ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013bc:	57                   	push   %edi
801013bd:	e8 5e 19 00 00       	call   80102d20 <log_write>
801013c2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	57                   	push   %edi
801013c9:	e8 12 ee ff ff       	call   801001e0 <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013d4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    
801013db:	90                   	nop
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 06                	mov    (%esi),%eax
801013e2:	e8 89 fd ff ff       	call   80101170 <balloc>
801013e7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 06                	mov    (%esi),%eax
801013fa:	e8 71 fd ff ff       	call   80101170 <balloc>
801013ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101405:	eb 87                	jmp    8010138e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101407:	83 ec 0c             	sub    $0xc,%esp
8010140a:	68 38 73 10 80       	push   $0x80107338
8010140f:	e8 5c ef ff ff       	call   80100370 <panic>
80101414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010141a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101420 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101428:	83 ec 08             	sub    $0x8,%esp
8010142b:	6a 01                	push   $0x1
8010142d:	ff 75 08             	pushl  0x8(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
80101435:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101437:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143a:	83 c4 0c             	add    $0xc,%esp
8010143d:	6a 1c                	push   $0x1c
8010143f:	50                   	push   %eax
80101440:	56                   	push   %esi
80101441:	e8 ca 32 00 00       	call   80104710 <memmove>
  brelse(bp);
80101446:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101449:	83 c4 10             	add    $0x10,%esp
}
8010144c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101452:	e9 89 ed ff ff       	jmp    801001e0 <brelse>
80101457:	89 f6                	mov    %esi,%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	68 4b 73 10 80       	push   $0x8010734b
80101471:	68 e0 09 11 80       	push   $0x801109e0
80101476:	e8 85 2f 00 00       	call   80104400 <initlock>
8010147b:	83 c4 10             	add    $0x10,%esp
8010147e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	83 ec 08             	sub    $0x8,%esp
80101483:	68 52 73 10 80       	push   $0x80107352
80101488:	53                   	push   %ebx
80101489:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010148f:	e8 3c 2e 00 00       	call   801042d0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101494:	83 c4 10             	add    $0x10,%esp
80101497:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149d:	75 e1                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149f:	83 ec 08             	sub    $0x8,%esp
801014a2:	68 c0 09 11 80       	push   $0x801109c0
801014a7:	ff 75 08             	pushl  0x8(%ebp)
801014aa:	e8 71 ff ff ff       	call   80101420 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014af:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014b5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014bb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014c1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014c7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014cd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014d3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014d9:	68 b8 73 10 80       	push   $0x801073b8
801014de:	e8 7d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014e3:	83 c4 30             	add    $0x30,%esp
801014e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e9:	c9                   	leave  
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014f0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	53                   	push   %ebx
801014f6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
80101503:	8b 75 08             	mov    0x8(%ebp),%esi
80101506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	0f 86 91 00 00 00    	jbe    801015a0 <ialloc+0xb0>
8010150f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101514:	eb 21                	jmp    80101537 <ialloc+0x47>
80101516:	8d 76 00             	lea    0x0(%esi),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101520:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101523:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101526:	57                   	push   %edi
80101527:	e8 b4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101535:	76 69                	jbe    801015a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101537:	89 d8                	mov    %ebx,%eax
80101539:	83 ec 08             	sub    $0x8,%esp
8010153c:	c1 e8 03             	shr    $0x3,%eax
8010153f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101545:	50                   	push   %eax
80101546:	56                   	push   %esi
80101547:	e8 84 eb ff ff       	call   801000d0 <bread>
8010154c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010154e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101550:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101553:	83 e0 07             	and    $0x7,%eax
80101556:	c1 e0 06             	shl    $0x6,%eax
80101559:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010155d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101561:	75 bd                	jne    80101520 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101563:	83 ec 04             	sub    $0x4,%esp
80101566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101569:	6a 40                	push   $0x40
8010156b:	6a 00                	push   $0x0
8010156d:	51                   	push   %ecx
8010156e:	e8 ed 30 00 00       	call   80104660 <memset>
      dip->type = type;
80101573:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101577:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010157a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010157d:	89 3c 24             	mov    %edi,(%esp)
80101580:	e8 9b 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
80101585:	89 3c 24             	mov    %edi,(%esp)
80101588:	e8 53 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010158d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101590:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101593:	89 da                	mov    %ebx,%edx
80101595:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101597:	5b                   	pop    %ebx
80101598:	5e                   	pop    %esi
80101599:	5f                   	pop    %edi
8010159a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010159b:	e9 e0 fc ff ff       	jmp    80101280 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015a0:	83 ec 0c             	sub    $0xc,%esp
801015a3:	68 58 73 10 80       	push   $0x80107358
801015a8:	e8 c3 ed ff ff       	call   80100370 <panic>
801015ad:	8d 76 00             	lea    0x0(%esi),%esi

801015b0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015be:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c1:	c1 e8 03             	shr    $0x3,%eax
801015c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ca:	50                   	push   %eax
801015cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ce:	e8 fd ea ff ff       	call   801000d0 <bread>
801015d3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015df:	83 e0 07             	and    $0x7,%eax
801015e2:	c1 e0 06             	shl    $0x6,%eax
801015e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015f0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101603:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101607:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010160a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160d:	6a 34                	push   $0x34
8010160f:	53                   	push   %ebx
80101610:	50                   	push   %eax
80101611:	e8 fa 30 00 00       	call   80104710 <memmove>
  log_write(bp);
80101616:	89 34 24             	mov    %esi,(%esp)
80101619:	e8 02 17 00 00       	call   80102d20 <log_write>
  brelse(bp);
8010161e:	89 75 08             	mov    %esi,0x8(%ebp)
80101621:	83 c4 10             	add    $0x10,%esp
}
80101624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010162a:	e9 b1 eb ff ff       	jmp    801001e0 <brelse>
8010162f:	90                   	nop

80101630 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	53                   	push   %ebx
80101634:	83 ec 10             	sub    $0x10,%esp
80101637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010163a:	68 e0 09 11 80       	push   $0x801109e0
8010163f:	e8 1c 2f 00 00       	call   80104560 <acquire>
  ip->ref++;
80101644:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101648:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010164f:	e8 bc 2f 00 00       	call   80104610 <release>
  return ip;
}
80101654:	89 d8                	mov    %ebx,%eax
80101656:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101659:	c9                   	leave  
8010165a:	c3                   	ret    
8010165b:	90                   	nop
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101668:	85 db                	test   %ebx,%ebx
8010166a:	0f 84 b7 00 00 00    	je     80101727 <ilock+0xc7>
80101670:	8b 53 08             	mov    0x8(%ebx),%edx
80101673:	85 d2                	test   %edx,%edx
80101675:	0f 8e ac 00 00 00    	jle    80101727 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010167b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	50                   	push   %eax
80101682:	e8 89 2c 00 00       	call   80104310 <acquiresleep>

  if(ip->valid == 0){
80101687:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010168a:	83 c4 10             	add    $0x10,%esp
8010168d:	85 c0                	test   %eax,%eax
8010168f:	74 0f                	je     801016a0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101691:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101694:	5b                   	pop    %ebx
80101695:	5e                   	pop    %esi
80101696:	5d                   	pop    %ebp
80101697:	c3                   	ret    
80101698:	90                   	nop
80101699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a0:	8b 43 04             	mov    0x4(%ebx),%eax
801016a3:	83 ec 08             	sub    $0x8,%esp
801016a6:	c1 e8 03             	shr    $0x3,%eax
801016a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016af:	50                   	push   %eax
801016b0:	ff 33                	pushl  (%ebx)
801016b2:	e8 19 ea ff ff       	call   801000d0 <bread>
801016b7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016c9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016f1:	6a 34                	push   $0x34
801016f3:	50                   	push   %eax
801016f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016f7:	50                   	push   %eax
801016f8:	e8 13 30 00 00       	call   80104710 <memmove>
    brelse(bp);
801016fd:	89 34 24             	mov    %esi,(%esp)
80101700:	e8 db ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010170d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101714:	0f 85 77 ff ff ff    	jne    80101691 <ilock+0x31>
      panic("ilock: no type");
8010171a:	83 ec 0c             	sub    $0xc,%esp
8010171d:	68 70 73 10 80       	push   $0x80107370
80101722:	e8 49 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	68 6a 73 10 80       	push   $0x8010736a
8010172f:	e8 3c ec ff ff       	call   80100370 <panic>
80101734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010173a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101740 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	74 28                	je     80101774 <iunlock+0x34>
8010174c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010174f:	83 ec 0c             	sub    $0xc,%esp
80101752:	56                   	push   %esi
80101753:	e8 58 2c 00 00       	call   801043b0 <holdingsleep>
80101758:	83 c4 10             	add    $0x10,%esp
8010175b:	85 c0                	test   %eax,%eax
8010175d:	74 15                	je     80101774 <iunlock+0x34>
8010175f:	8b 43 08             	mov    0x8(%ebx),%eax
80101762:	85 c0                	test   %eax,%eax
80101764:	7e 0e                	jle    80101774 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101766:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101769:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010176f:	e9 fc 2b 00 00       	jmp    80104370 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101774:	83 ec 0c             	sub    $0xc,%esp
80101777:	68 7f 73 10 80       	push   $0x8010737f
8010177c:	e8 ef eb ff ff       	call   80100370 <panic>
80101781:	eb 0d                	jmp    80101790 <iput>
80101783:	90                   	nop
80101784:	90                   	nop
80101785:	90                   	nop
80101786:	90                   	nop
80101787:	90                   	nop
80101788:	90                   	nop
80101789:	90                   	nop
8010178a:	90                   	nop
8010178b:	90                   	nop
8010178c:	90                   	nop
8010178d:	90                   	nop
8010178e:	90                   	nop
8010178f:	90                   	nop

80101790 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	57                   	push   %edi
80101794:	56                   	push   %esi
80101795:	53                   	push   %ebx
80101796:	83 ec 28             	sub    $0x28,%esp
80101799:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010179c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010179f:	57                   	push   %edi
801017a0:	e8 6b 2b 00 00       	call   80104310 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017a5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 d2                	test   %edx,%edx
801017ad:	74 07                	je     801017b6 <iput+0x26>
801017af:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017b4:	74 32                	je     801017e8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017b6:	83 ec 0c             	sub    $0xc,%esp
801017b9:	57                   	push   %edi
801017ba:	e8 b1 2b 00 00       	call   80104370 <releasesleep>

  acquire(&icache.lock);
801017bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017c6:	e8 95 2d 00 00       	call   80104560 <acquire>
  ip->ref--;
801017cb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017dc:	5b                   	pop    %ebx
801017dd:	5e                   	pop    %esi
801017de:	5f                   	pop    %edi
801017df:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017e0:	e9 2b 2e 00 00       	jmp    80104610 <release>
801017e5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 e0 09 11 80       	push   $0x801109e0
801017f0:	e8 6b 2d 00 00       	call   80104560 <acquire>
    int r = ip->ref;
801017f5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017f8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017ff:	e8 0c 2e 00 00       	call   80104610 <release>
    if(r == 1){
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	83 fb 01             	cmp    $0x1,%ebx
8010180a:	75 aa                	jne    801017b6 <iput+0x26>
8010180c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101812:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101815:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101818:	89 cf                	mov    %ecx,%edi
8010181a:	eb 0b                	jmp    80101827 <iput+0x97>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0xb0>
    if(ip->addrs[i]){
80101827:	8b 13                	mov    (%ebx),%edx
80101829:	85 d2                	test   %edx,%edx
8010182b:	74 f3                	je     80101820 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010182d:	8b 06                	mov    (%esi),%eax
8010182f:	e8 cc f8 ff ff       	call   80101100 <bfree>
      ip->addrs[i] = 0;
80101834:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010183a:	eb e4                	jmp    80101820 <iput+0x90>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101849:	85 c0                	test   %eax,%eax
8010184b:	75 33                	jne    80101880 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010184d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101850:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101857:	56                   	push   %esi
80101858:	e8 53 fd ff ff       	call   801015b0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010185d:	31 c0                	xor    %eax,%eax
8010185f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101863:	89 34 24             	mov    %esi,(%esp)
80101866:	e8 45 fd ff ff       	call   801015b0 <iupdate>
      ip->valid = 0;
8010186b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101872:	83 c4 10             	add    $0x10,%esp
80101875:	e9 3c ff ff ff       	jmp    801017b6 <iput+0x26>
8010187a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	50                   	push   %eax
80101884:	ff 36                	pushl  (%esi)
80101886:	e8 45 e8 ff ff       	call   801000d0 <bread>
8010188b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101891:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101897:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010189a:	83 c4 10             	add    $0x10,%esp
8010189d:	89 cf                	mov    %ecx,%edi
8010189f:	eb 0e                	jmp    801018af <iput+0x11f>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018ab:	39 fb                	cmp    %edi,%ebx
801018ad:	74 0f                	je     801018be <iput+0x12e>
      if(a[j])
801018af:	8b 13                	mov    (%ebx),%edx
801018b1:	85 d2                	test   %edx,%edx
801018b3:	74 f3                	je     801018a8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018b5:	8b 06                	mov    (%esi),%eax
801018b7:	e8 44 f8 ff ff       	call   80101100 <bfree>
801018bc:	eb ea                	jmp    801018a8 <iput+0x118>
    }
    brelse(bp);
801018be:	83 ec 0c             	sub    $0xc,%esp
801018c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018c7:	e8 14 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018cc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d2:	8b 06                	mov    (%esi),%eax
801018d4:	e8 27 f8 ff ff       	call   80101100 <bfree>
    ip->addrs[NDIRECT] = 0;
801018d9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e0:	00 00 00 
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	e9 62 ff ff ff       	jmp    8010184d <iput+0xbd>
801018eb:	90                   	nop
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	53                   	push   %ebx
801018fb:	e8 40 fe ff ff       	call   80101740 <iunlock>
  iput(ip);
80101900:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101903:	83 c4 10             	add    $0x10,%esp
}
80101906:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101909:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 81 fe ff ff       	jmp    80101790 <iput>
8010190f:	90                   	nop

80101910 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 1c             	sub    $0x1c,%esp
80101949:	8b 45 08             	mov    0x8(%ebp),%eax
8010194c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101952:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101957:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010195d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101960:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101963:	0f 84 a7 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101969:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010196c:	8b 40 58             	mov    0x58(%eax),%eax
8010196f:	39 f0                	cmp    %esi,%eax
80101971:	0f 82 c1 00 00 00    	jb     80101a38 <readi+0xf8>
80101977:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010197a:	89 fa                	mov    %edi,%edx
8010197c:	01 f2                	add    %esi,%edx
8010197e:	0f 82 b4 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101984:	89 c1                	mov    %eax,%ecx
80101986:	29 f1                	sub    %esi,%ecx
80101988:	39 d0                	cmp    %edx,%eax
8010198a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198d:	31 ff                	xor    %edi,%edi
8010198f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101991:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101994:	74 6d                	je     80101a03 <readi+0xc3>
80101996:	8d 76 00             	lea    0x0(%esi),%esi
80101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019a3:	89 f2                	mov    %esi,%edx
801019a5:	c1 ea 09             	shr    $0x9,%edx
801019a8:	89 d8                	mov    %ebx,%eax
801019aa:	e8 a1 f9 ff ff       	call   80101350 <bmap>
801019af:	83 ec 08             	sub    $0x8,%esp
801019b2:	50                   	push   %eax
801019b3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019b5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ba:	e8 11 e7 ff ff       	call   801000d0 <bread>
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019c4:	89 f1                	mov    %esi,%ecx
801019c6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019cc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d2:	29 cb                	sub    %ecx,%ebx
801019d4:	29 f8                	sub    %edi,%eax
801019d6:	39 c3                	cmp    %eax,%ebx
801019d8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019db:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019df:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e0:	01 df                	add    %ebx,%edi
801019e2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019e4:	50                   	push   %eax
801019e5:	ff 75 e0             	pushl  -0x20(%ebp)
801019e8:	e8 23 2d 00 00       	call   80104710 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a01:	77 9d                	ja     801019a0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a09:	5b                   	pop    %ebx
80101a0a:	5e                   	pop    %esi
80101a0b:	5f                   	pop    %edi
80101a0c:	5d                   	pop    %ebp
80101a0d:	c3                   	ret    
80101a0e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2b:	5b                   	pop    %ebx
80101a2c:	5e                   	pop    %esi
80101a2d:	5f                   	pop    %edi
80101a2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a2f:	ff e0                	jmp    *%eax
80101a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c7                	jmp    80101a06 <readi+0xc6>
80101a3f:	90                   	nop

80101a40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 1c             	sub    $0x1c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a60:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 eb 00 00 00    	jb     80101b60 <writei+0x120>
80101a75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a78:	89 f8                	mov    %edi,%eax
80101a7a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a7c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a81:	0f 87 d9 00 00 00    	ja     80101b60 <writei+0x120>
80101a87:	39 c6                	cmp    %eax,%esi
80101a89:	0f 87 d1 00 00 00    	ja     80101b60 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8f:	85 ff                	test   %edi,%edi
80101a91:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a98:	74 78                	je     80101b12 <writei+0xd2>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aa3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aaa:	c1 ea 09             	shr    $0x9,%edx
80101aad:	89 f8                	mov    %edi,%eax
80101aaf:	e8 9c f8 ff ff       	call   80101350 <bmap>
80101ab4:	83 ec 08             	sub    $0x8,%esp
80101ab7:	50                   	push   %eax
80101ab8:	ff 37                	pushl  (%edi)
80101aba:	e8 11 e6 ff ff       	call   801000d0 <bread>
80101abf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ac4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ac7:	89 f1                	mov    %esi,%ecx
80101ac9:	83 c4 0c             	add    $0xc,%esp
80101acc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ad2:	29 cb                	sub    %ecx,%ebx
80101ad4:	39 c3                	cmp    %eax,%ebx
80101ad6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101add:	53                   	push   %ebx
80101ade:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	50                   	push   %eax
80101ae4:	e8 27 2c 00 00       	call   80104710 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aff:	83 c4 10             	add    $0x10,%esp
80101b02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b05:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b08:	77 96                	ja     80101aa0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b10:	77 36                	ja     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b18:	5b                   	pop    %ebx
80101b19:	5e                   	pop    %esi
80101b1a:	5f                   	pop    %edi
80101b1b:	5d                   	pop    %ebp
80101b1c:	c3                   	ret    
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 36                	ja     80101b60 <writei+0x120>
80101b2a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 2b                	je     80101b60 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b51:	50                   	push   %eax
80101b52:	e8 59 fa ff ff       	call   801015b0 <iupdate>
80101b57:	83 c4 10             	add    $0x10,%esp
80101b5a:	eb b6                	jmp    80101b12 <writei+0xd2>
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b65:	eb ae                	jmp    80101b15 <writei+0xd5>
80101b67:	89 f6                	mov    %esi,%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	6a 0e                	push   $0xe
80101b78:	ff 75 0c             	pushl  0xc(%ebp)
80101b7b:	ff 75 08             	pushl  0x8(%ebp)
80101b7e:	e8 0d 2c 00 00       	call   80104790 <strncmp>
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ba1:	0f 85 80 00 00 00    	jne    80101c27 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8b 53 58             	mov    0x58(%ebx),%edx
80101baa:	31 ff                	xor    %edi,%edi
80101bac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101baf:	85 d2                	test   %edx,%edx
80101bb1:	75 0d                	jne    80101bc0 <dirlookup+0x30>
80101bb3:	eb 5b                	jmp    80101c10 <dirlookup+0x80>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
80101bb8:	83 c7 10             	add    $0x10,%edi
80101bbb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bbe:	76 50                	jbe    80101c10 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bc0:	6a 10                	push   $0x10
80101bc2:	57                   	push   %edi
80101bc3:	56                   	push   %esi
80101bc4:	53                   	push   %ebx
80101bc5:	e8 76 fd ff ff       	call   80101940 <readi>
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	83 f8 10             	cmp    $0x10,%eax
80101bd0:	75 48                	jne    80101c1a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bd7:	74 df                	je     80101bb8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bd9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bdc:	83 ec 04             	sub    $0x4,%esp
80101bdf:	6a 0e                	push   $0xe
80101be1:	50                   	push   %eax
80101be2:	ff 75 0c             	pushl  0xc(%ebp)
80101be5:	e8 a6 2b 00 00       	call   80104790 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bea:	83 c4 10             	add    $0x10,%esp
80101bed:	85 c0                	test   %eax,%eax
80101bef:	75 c7                	jne    80101bb8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bf1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	74 05                	je     80101bfd <dirlookup+0x6d>
        *poff = off;
80101bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bfb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bfd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c01:	8b 03                	mov    (%ebx),%eax
80101c03:	e8 78 f6 ff ff       	call   80101280 <iget>
    }
  }

  return 0;
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
80101c0f:	c3                   	ret    
80101c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c13:	31 c0                	xor    %eax,%eax
}
80101c15:	5b                   	pop    %ebx
80101c16:	5e                   	pop    %esi
80101c17:	5f                   	pop    %edi
80101c18:	5d                   	pop    %ebp
80101c19:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c1a:	83 ec 0c             	sub    $0xc,%esp
80101c1d:	68 99 73 10 80       	push   $0x80107399
80101c22:	e8 49 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c27:	83 ec 0c             	sub    $0xc,%esp
80101c2a:	68 87 73 10 80       	push   $0x80107387
80101c2f:	e8 3c e7 ff ff       	call   80100370 <panic>
80101c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	89 cf                	mov    %ecx,%edi
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c4d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c53:	0f 84 53 01 00 00    	je     80101dac <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c59:	e8 42 1b 00 00       	call   801037a0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c5e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c61:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c64:	68 e0 09 11 80       	push   $0x801109e0
80101c69:	e8 f2 28 00 00       	call   80104560 <acquire>
  ip->ref++;
80101c6e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c72:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c79:	e8 92 29 00 00       	call   80104610 <release>
80101c7e:	83 c4 10             	add    $0x10,%esp
80101c81:	eb 08                	jmp    80101c8b <namex+0x4b>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c88:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c8b:	0f b6 03             	movzbl (%ebx),%eax
80101c8e:	3c 2f                	cmp    $0x2f,%al
80101c90:	74 f6                	je     80101c88 <namex+0x48>
    path++;
  if(*path == 0)
80101c92:	84 c0                	test   %al,%al
80101c94:	0f 84 e3 00 00 00    	je     80101d7d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c9a:	0f b6 03             	movzbl (%ebx),%eax
80101c9d:	89 da                	mov    %ebx,%edx
80101c9f:	84 c0                	test   %al,%al
80101ca1:	0f 84 ac 00 00 00    	je     80101d53 <namex+0x113>
80101ca7:	3c 2f                	cmp    $0x2f,%al
80101ca9:	75 09                	jne    80101cb4 <namex+0x74>
80101cab:	e9 a3 00 00 00       	jmp    80101d53 <namex+0x113>
80101cb0:	84 c0                	test   %al,%al
80101cb2:	74 0a                	je     80101cbe <namex+0x7e>
    path++;
80101cb4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb7:	0f b6 02             	movzbl (%edx),%eax
80101cba:	3c 2f                	cmp    $0x2f,%al
80101cbc:	75 f2                	jne    80101cb0 <namex+0x70>
80101cbe:	89 d1                	mov    %edx,%ecx
80101cc0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cc2:	83 f9 0d             	cmp    $0xd,%ecx
80101cc5:	0f 8e 8d 00 00 00    	jle    80101d58 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ccb:	83 ec 04             	sub    $0x4,%esp
80101cce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cd1:	6a 0e                	push   $0xe
80101cd3:	53                   	push   %ebx
80101cd4:	57                   	push   %edi
80101cd5:	e8 36 2a 00 00       	call   80104710 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cdd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101ce0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ce5:	75 11                	jne    80101cf8 <namex+0xb8>
80101ce7:	89 f6                	mov    %esi,%esi
80101ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cf6:	74 f8                	je     80101cf0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	56                   	push   %esi
80101cfc:	e8 5f f9 ff ff       	call   80101660 <ilock>
    if(ip->type != T_DIR){
80101d01:	83 c4 10             	add    $0x10,%esp
80101d04:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d09:	0f 85 7f 00 00 00    	jne    80101d8e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d12:	85 d2                	test   %edx,%edx
80101d14:	74 09                	je     80101d1f <namex+0xdf>
80101d16:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d19:	0f 84 a3 00 00 00    	je     80101dc2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d1f:	83 ec 04             	sub    $0x4,%esp
80101d22:	6a 00                	push   $0x0
80101d24:	57                   	push   %edi
80101d25:	56                   	push   %esi
80101d26:	e8 65 fe ff ff       	call   80101b90 <dirlookup>
80101d2b:	83 c4 10             	add    $0x10,%esp
80101d2e:	85 c0                	test   %eax,%eax
80101d30:	74 5c                	je     80101d8e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d32:	83 ec 0c             	sub    $0xc,%esp
80101d35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d38:	56                   	push   %esi
80101d39:	e8 02 fa ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d3e:	89 34 24             	mov    %esi,(%esp)
80101d41:	e8 4a fa ff ff       	call   80101790 <iput>
80101d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d49:	83 c4 10             	add    $0x10,%esp
80101d4c:	89 c6                	mov    %eax,%esi
80101d4e:	e9 38 ff ff ff       	jmp    80101c8b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d53:	31 c9                	xor    %ecx,%ecx
80101d55:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d58:	83 ec 04             	sub    $0x4,%esp
80101d5b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d5e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d61:	51                   	push   %ecx
80101d62:	53                   	push   %ebx
80101d63:	57                   	push   %edi
80101d64:	e8 a7 29 00 00       	call   80104710 <memmove>
    name[len] = 0;
80101d69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d76:	89 d3                	mov    %edx,%ebx
80101d78:	e9 65 ff ff ff       	jmp    80101ce2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d80:	85 c0                	test   %eax,%eax
80101d82:	75 54                	jne    80101dd8 <namex+0x198>
80101d84:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d89:	5b                   	pop    %ebx
80101d8a:	5e                   	pop    %esi
80101d8b:	5f                   	pop    %edi
80101d8c:	5d                   	pop    %ebp
80101d8d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	56                   	push   %esi
80101d92:	e8 a9 f9 ff ff       	call   80101740 <iunlock>
  iput(ip);
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 f1 f9 ff ff       	call   80101790 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d9f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101da5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da7:	5b                   	pop    %ebx
80101da8:	5e                   	pop    %esi
80101da9:	5f                   	pop    %edi
80101daa:	5d                   	pop    %ebp
80101dab:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dac:	ba 01 00 00 00       	mov    $0x1,%edx
80101db1:	b8 01 00 00 00       	mov    $0x1,%eax
80101db6:	e8 c5 f4 ff ff       	call   80101280 <iget>
80101dbb:	89 c6                	mov    %eax,%esi
80101dbd:	e9 c9 fe ff ff       	jmp    80101c8b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	56                   	push   %esi
80101dc6:	e8 75 f9 ff ff       	call   80101740 <iunlock>
      return ip;
80101dcb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dd1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd3:	5b                   	pop    %ebx
80101dd4:	5e                   	pop    %esi
80101dd5:	5f                   	pop    %edi
80101dd6:	5d                   	pop    %ebp
80101dd7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 af f9 ff ff       	call   80101790 <iput>
    return 0;
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	31 c0                	xor    %eax,%eax
80101de6:	eb 9e                	jmp    80101d86 <namex+0x146>
80101de8:	90                   	nop
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 20             	sub    $0x20,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dfc:	6a 00                	push   $0x0
80101dfe:	ff 75 0c             	pushl  0xc(%ebp)
80101e01:	53                   	push   %ebx
80101e02:	e8 89 fd ff ff       	call   80101b90 <dirlookup>
80101e07:	83 c4 10             	add    $0x10,%esp
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	75 67                	jne    80101e75 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e14:	85 ff                	test   %edi,%edi
80101e16:	74 29                	je     80101e41 <dirlink+0x51>
80101e18:	31 ff                	xor    %edi,%edi
80101e1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e1d:	eb 09                	jmp    80101e28 <dirlink+0x38>
80101e1f:	90                   	nop
80101e20:	83 c7 10             	add    $0x10,%edi
80101e23:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e26:	76 19                	jbe    80101e41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e28:	6a 10                	push   $0x10
80101e2a:	57                   	push   %edi
80101e2b:	56                   	push   %esi
80101e2c:	53                   	push   %ebx
80101e2d:	e8 0e fb ff ff       	call   80101940 <readi>
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	83 f8 10             	cmp    $0x10,%eax
80101e38:	75 4e                	jne    80101e88 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e3f:	75 df                	jne    80101e20 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e41:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e44:	83 ec 04             	sub    $0x4,%esp
80101e47:	6a 0e                	push   $0xe
80101e49:	ff 75 0c             	pushl  0xc(%ebp)
80101e4c:	50                   	push   %eax
80101e4d:	e8 ae 29 00 00       	call   80104800 <strncpy>
  de.inum = inum;
80101e52:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e55:	6a 10                	push   $0x10
80101e57:	57                   	push   %edi
80101e58:	56                   	push   %esi
80101e59:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5e:	e8 dd fb ff ff       	call   80101a40 <writei>
80101e63:	83 c4 20             	add    $0x20,%esp
80101e66:	83 f8 10             	cmp    $0x10,%eax
80101e69:	75 2a                	jne    80101e95 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e6b:	31 c0                	xor    %eax,%eax
}
80101e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	50                   	push   %eax
80101e79:	e8 12 f9 ff ff       	call   80101790 <iput>
    return -1;
80101e7e:	83 c4 10             	add    $0x10,%esp
80101e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e86:	eb e5                	jmp    80101e6d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	68 a8 73 10 80       	push   $0x801073a8
80101e90:	e8 db e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e95:	83 ec 0c             	sub    $0xc,%esp
80101e98:	68 aa 79 10 80       	push   $0x801079aa
80101e9d:	e8 ce e4 ff ff       	call   80100370 <panic>
80101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101eb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101eb3:	89 e5                	mov    %esp,%ebp
80101eb5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ebe:	e8 7d fd ff ff       	call   80101c40 <namex>
}
80101ec3:	c9                   	leave  
80101ec4:	c3                   	ret    
80101ec5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ed0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ed0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ed1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ed6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ed8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ede:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101edf:	e9 5c fd ff ff       	jmp    80101c40 <namex>
80101ee4:	66 90                	xchg   %ax,%ax
80101ee6:	66 90                	xchg   %ax,%ax
80101ee8:	66 90                	xchg   %ax,%ax
80101eea:	66 90                	xchg   %ax,%ax
80101eec:	66 90                	xchg   %ax,%ax
80101eee:	66 90                	xchg   %ax,%ax

80101ef0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef0:	55                   	push   %ebp
  if(b == 0)
80101ef1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	56                   	push   %esi
80101ef6:	53                   	push   %ebx
  if(b == 0)
80101ef7:	0f 84 ad 00 00 00    	je     80101faa <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101efd:	8b 58 08             	mov    0x8(%eax),%ebx
80101f00:	89 c1                	mov    %eax,%ecx
80101f02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f08:	0f 87 8f 00 00 00    	ja     80101f9d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f0e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f13:	90                   	nop
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f18:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f19:	83 e0 c0             	and    $0xffffffc0,%eax
80101f1c:	3c 40                	cmp    $0x40,%al
80101f1e:	75 f8                	jne    80101f18 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f20:	31 f6                	xor    %esi,%esi
80101f22:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f27:	89 f0                	mov    %esi,%eax
80101f29:	ee                   	out    %al,(%dx)
80101f2a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f2f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f34:	ee                   	out    %al,(%dx)
80101f35:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f3a:	89 d8                	mov    %ebx,%eax
80101f3c:	ee                   	out    %al,(%dx)
80101f3d:	89 d8                	mov    %ebx,%eax
80101f3f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f44:	c1 f8 08             	sar    $0x8,%eax
80101f47:	ee                   	out    %al,(%dx)
80101f48:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f4d:	89 f0                	mov    %esi,%eax
80101f4f:	ee                   	out    %al,(%dx)
80101f50:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f59:	83 e0 01             	and    $0x1,%eax
80101f5c:	c1 e0 04             	shl    $0x4,%eax
80101f5f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f62:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f63:	f6 01 04             	testb  $0x4,(%ecx)
80101f66:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f6b:	75 13                	jne    80101f80 <idestart+0x90>
80101f6d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f72:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f76:	5b                   	pop    %ebx
80101f77:	5e                   	pop    %esi
80101f78:	5d                   	pop    %ebp
80101f79:	c3                   	ret    
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f80:	b8 30 00 00 00       	mov    $0x30,%eax
80101f85:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f86:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f8b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f8e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f93:	fc                   	cld    
80101f94:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5d                   	pop    %ebp
80101f9c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f9d:	83 ec 0c             	sub    $0xc,%esp
80101fa0:	68 14 74 10 80       	push   $0x80107414
80101fa5:	e8 c6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101faa:	83 ec 0c             	sub    $0xc,%esp
80101fad:	68 0b 74 10 80       	push   $0x8010740b
80101fb2:	e8 b9 e3 ff ff       	call   80100370 <panic>
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fc6:	68 26 74 10 80       	push   $0x80107426
80101fcb:	68 80 a5 10 80       	push   $0x8010a580
80101fd0:	e8 2b 24 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fd5:	58                   	pop    %eax
80101fd6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fdb:	5a                   	pop    %edx
80101fdc:	83 e8 01             	sub    $0x1,%eax
80101fdf:	50                   	push   %eax
80101fe0:	6a 0e                	push   $0xe
80101fe2:	e8 a9 02 00 00       	call   80102290 <ioapicenable>
80101fe7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fef:	90                   	nop
80101ff0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff1:	83 e0 c0             	and    $0xffffffc0,%eax
80101ff4:	3c 40                	cmp    $0x40,%al
80101ff6:	75 f8                	jne    80101ff0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ff8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ffd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102002:	ee                   	out    %al,(%dx)
80102003:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102008:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010200d:	eb 06                	jmp    80102015 <ideinit+0x55>
8010200f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102010:	83 e9 01             	sub    $0x1,%ecx
80102013:	74 0f                	je     80102024 <ideinit+0x64>
80102015:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102016:	84 c0                	test   %al,%al
80102018:	74 f6                	je     80102010 <ideinit+0x50>
      havedisk1 = 1;
8010201a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102021:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102024:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102029:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010202e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010202f:	c9                   	leave  
80102030:	c3                   	ret    
80102031:	eb 0d                	jmp    80102040 <ideintr>
80102033:	90                   	nop
80102034:	90                   	nop
80102035:	90                   	nop
80102036:	90                   	nop
80102037:	90                   	nop
80102038:	90                   	nop
80102039:	90                   	nop
8010203a:	90                   	nop
8010203b:	90                   	nop
8010203c:	90                   	nop
8010203d:	90                   	nop
8010203e:	90                   	nop
8010203f:	90                   	nop

80102040 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102049:	68 80 a5 10 80       	push   $0x8010a580
8010204e:	e8 0d 25 00 00       	call   80104560 <acquire>

  if((b = idequeue) == 0){
80102053:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102059:	83 c4 10             	add    $0x10,%esp
8010205c:	85 db                	test   %ebx,%ebx
8010205e:	74 34                	je     80102094 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102060:	8b 43 58             	mov    0x58(%ebx),%eax
80102063:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102068:	8b 33                	mov    (%ebx),%esi
8010206a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102070:	74 3e                	je     801020b0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102072:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102075:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102078:	83 ce 02             	or     $0x2,%esi
8010207b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010207d:	53                   	push   %ebx
8010207e:	e8 9d 20 00 00       	call   80104120 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102083:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	74 05                	je     80102094 <ideintr+0x54>
    idestart(idequeue);
8010208f:	e8 5c fe ff ff       	call   80101ef0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102094:	83 ec 0c             	sub    $0xc,%esp
80102097:	68 80 a5 10 80       	push   $0x8010a580
8010209c:	e8 6f 25 00 00       	call   80104610 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b5:	8d 76 00             	lea    0x0(%esi),%esi
801020b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b9:	89 c1                	mov    %eax,%ecx
801020bb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020be:	80 f9 40             	cmp    $0x40,%cl
801020c1:	75 f5                	jne    801020b8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020c3:	a8 21                	test   $0x21,%al
801020c5:	75 ab                	jne    80102072 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020c7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ca:	b9 80 00 00 00       	mov    $0x80,%ecx
801020cf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020d4:	fc                   	cld    
801020d5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	eb 97                	jmp    80102072 <ideintr+0x32>
801020db:	90                   	nop
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	53                   	push   %ebx
801020e4:	83 ec 10             	sub    $0x10,%esp
801020e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801020ed:	50                   	push   %eax
801020ee:	e8 bd 22 00 00       	call   801043b0 <holdingsleep>
801020f3:	83 c4 10             	add    $0x10,%esp
801020f6:	85 c0                	test   %eax,%eax
801020f8:	0f 84 ad 00 00 00    	je     801021ab <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020fe:	8b 03                	mov    (%ebx),%eax
80102100:	83 e0 06             	and    $0x6,%eax
80102103:	83 f8 02             	cmp    $0x2,%eax
80102106:	0f 84 b9 00 00 00    	je     801021c5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010210c:	8b 53 04             	mov    0x4(%ebx),%edx
8010210f:	85 d2                	test   %edx,%edx
80102111:	74 0d                	je     80102120 <iderw+0x40>
80102113:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102118:	85 c0                	test   %eax,%eax
8010211a:	0f 84 98 00 00 00    	je     801021b8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102120:	83 ec 0c             	sub    $0xc,%esp
80102123:	68 80 a5 10 80       	push   $0x8010a580
80102128:	e8 33 24 00 00       	call   80104560 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010212d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102133:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102136:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	85 d2                	test   %edx,%edx
8010213f:	75 09                	jne    8010214a <iderw+0x6a>
80102141:	eb 58                	jmp    8010219b <iderw+0xbb>
80102143:	90                   	nop
80102144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102148:	89 c2                	mov    %eax,%edx
8010214a:	8b 42 58             	mov    0x58(%edx),%eax
8010214d:	85 c0                	test   %eax,%eax
8010214f:	75 f7                	jne    80102148 <iderw+0x68>
80102151:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102154:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102156:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010215c:	74 44                	je     801021a2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	74 23                	je     8010218b <iderw+0xab>
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102170:	83 ec 08             	sub    $0x8,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	53                   	push   %ebx
80102179:	e8 e2 1d 00 00       	call   80103f60 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	83 e0 06             	and    $0x6,%eax
80102186:	83 f8 02             	cmp    $0x2,%eax
80102189:	75 e5                	jne    80102170 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010218b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102195:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102196:	e9 75 24 00 00       	jmp    80104610 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021a0:	eb b2                	jmp    80102154 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021a2:	89 d8                	mov    %ebx,%eax
801021a4:	e8 47 fd ff ff       	call   80101ef0 <idestart>
801021a9:	eb b3                	jmp    8010215e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021ab:	83 ec 0c             	sub    $0xc,%esp
801021ae:	68 2a 74 10 80       	push   $0x8010742a
801021b3:	e8 b8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	68 55 74 10 80       	push   $0x80107455
801021c0:	e8 ab e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	68 40 74 10 80       	push   $0x80107440
801021cd:	e8 9e e1 ff ff       	call   80100370 <panic>
801021d2:	66 90                	xchg   %ax,%ax
801021d4:	66 90                	xchg   %ax,%ax
801021d6:	66 90                	xchg   %ax,%ax
801021d8:	66 90                	xchg   %ax,%ax
801021da:	66 90                	xchg   %ax,%ax
801021dc:	66 90                	xchg   %ax,%ax
801021de:	66 90                	xchg   %ax,%ax

801021e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021e8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021eb:	89 e5                	mov    %esp,%ebp
801021ed:	56                   	push   %esi
801021ee:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021f6:	00 00 00 
  return ioapic->data;
801021f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021ff:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102202:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102208:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102215:	89 f0                	mov    %esi,%eax
80102217:	c1 e8 10             	shr    $0x10,%eax
8010221a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010221d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102220:	c1 e8 18             	shr    $0x18,%eax
80102223:	39 d0                	cmp    %edx,%eax
80102225:	74 16                	je     8010223d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 74 74 10 80       	push   $0x80107474
8010222f:	e8 2c e4 ff ff       	call   80100660 <cprintf>
80102234:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	ba 10 00 00 00       	mov    $0x10,%edx
80102245:	b8 20 00 00 00       	mov    $0x20,%eax
8010224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102250:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102252:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102258:	89 c3                	mov    %eax,%ebx
8010225a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102260:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102263:	89 59 10             	mov    %ebx,0x10(%ecx)
80102266:	8d 5a 01             	lea    0x1(%edx),%ebx
80102269:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102270:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102276:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227d:	75 d1                	jne    80102250 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010227f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
80102286:	8d 76 00             	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102290:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102291:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102297:	89 e5                	mov    %esp,%ebp
80102299:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010229c:	8d 50 20             	lea    0x20(%eax),%edx
8010229f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ae:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b6:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022bb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022be:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022c1:	5d                   	pop    %ebp
801022c2:	c3                   	ret    
801022c3:	66 90                	xchg   %ax,%ax
801022c5:	66 90                	xchg   %ax,%ax
801022c7:	66 90                	xchg   %ax,%ax
801022c9:	66 90                	xchg   %ax,%ax
801022cb:	66 90                	xchg   %ax,%ax
801022cd:	66 90                	xchg   %ax,%ax
801022cf:	90                   	nop

801022d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 04             	sub    $0x4,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022e0:	75 70                	jne    80102352 <kfree+0x82>
801022e2:	81 fb c8 57 11 80    	cmp    $0x801157c8,%ebx
801022e8:	72 68                	jb     80102352 <kfree+0x82>
801022ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022f5:	77 5b                	ja     80102352 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022f7:	83 ec 04             	sub    $0x4,%esp
801022fa:	68 00 10 00 00       	push   $0x1000
801022ff:	6a 01                	push   $0x1
80102301:	53                   	push   %ebx
80102302:	e8 59 23 00 00       	call   80104660 <memset>

  if(kmem.use_lock)
80102307:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 d2                	test   %edx,%edx
80102312:	75 2c                	jne    80102340 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102314:	a1 78 26 11 80       	mov    0x80112678,%eax
80102319:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010231b:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102320:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102326:	85 c0                	test   %eax,%eax
80102328:	75 06                	jne    80102330 <kfree+0x60>
    release(&kmem.lock);
}
8010232a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232d:	c9                   	leave  
8010232e:	c3                   	ret    
8010232f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102330:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010233b:	e9 d0 22 00 00       	jmp    80104610 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 40 26 11 80       	push   $0x80112640
80102348:	e8 13 22 00 00       	call   80104560 <acquire>
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	eb c2                	jmp    80102314 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102352:	83 ec 0c             	sub    $0xc,%esp
80102355:	68 a6 74 10 80       	push   $0x801074a6
8010235a:	e8 11 e0 ff ff       	call   80100370 <panic>
8010235f:	90                   	nop

80102360 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102365:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102368:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010236b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102371:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102377:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010237d:	39 de                	cmp    %ebx,%esi
8010237f:	72 23                	jb     801023a4 <freerange+0x44>
80102381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102388:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010238e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102391:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102397:	50                   	push   %eax
80102398:	e8 33 ff ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	39 f3                	cmp    %esi,%ebx
801023a2:	76 e4                	jbe    80102388 <freerange+0x28>
    kfree(p);
}
801023a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a7:	5b                   	pop    %ebx
801023a8:	5e                   	pop    %esi
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023b8:	83 ec 08             	sub    $0x8,%esp
801023bb:	68 ac 74 10 80       	push   $0x801074ac
801023c0:	68 40 26 11 80       	push   $0x80112640
801023c5:	e8 36 20 00 00       	call   80104400 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023d0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ec:	39 de                	cmp    %ebx,%esi
801023ee:	72 1c                	jb     8010240c <kinit1+0x5c>
    kfree(p);
801023f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ff:	50                   	push   %eax
80102400:	e8 cb fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102405:	83 c4 10             	add    $0x10,%esp
80102408:	39 de                	cmp    %ebx,%esi
8010240a:	73 e4                	jae    801023f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010240c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010240f:	5b                   	pop    %ebx
80102410:	5e                   	pop    %esi
80102411:	5d                   	pop    %ebp
80102412:	c3                   	ret    
80102413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102425:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010242b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102431:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102437:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243d:	39 de                	cmp    %ebx,%esi
8010243f:	72 23                	jb     80102464 <kinit2+0x44>
80102441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102448:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010244e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102451:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102457:	50                   	push   %eax
80102458:	e8 73 fe ff ff       	call   801022d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 e4                	jae    80102448 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102464:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010246b:	00 00 00 
}
8010246e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102487:	a1 74 26 11 80       	mov    0x80112674,%eax
8010248c:	85 c0                	test   %eax,%eax
8010248e:	75 30                	jne    801024c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102490:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102496:	85 db                	test   %ebx,%ebx
80102498:	74 1c                	je     801024b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010249a:	8b 13                	mov    (%ebx),%edx
8010249c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024a2:	85 c0                	test   %eax,%eax
801024a4:	74 10                	je     801024b6 <kalloc+0x36>
    release(&kmem.lock);
801024a6:	83 ec 0c             	sub    $0xc,%esp
801024a9:	68 40 26 11 80       	push   $0x80112640
801024ae:	e8 5d 21 00 00       	call   80104610 <release>
801024b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024b6:	89 d8                	mov    %ebx,%eax
801024b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 40 26 11 80       	push   $0x80112640
801024c8:	e8 93 20 00 00       	call   80104560 <acquire>
  r = kmem.freelist;
801024cd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024db:	85 db                	test   %ebx,%ebx
801024dd:	75 bb                	jne    8010249a <kalloc+0x1a>
801024df:	eb c1                	jmp    801024a2 <kalloc+0x22>
801024e1:	66 90                	xchg   %ax,%ax
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f1:	ba 64 00 00 00       	mov    $0x64,%edx
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f9:	a8 01                	test   $0x1,%al
801024fb:	0f 84 af 00 00 00    	je     801025b0 <kbdgetc+0xc0>
80102501:	ba 60 00 00 00       	mov    $0x60,%edx
80102506:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102507:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010250a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102510:	74 7e                	je     80102590 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102512:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010251a:	79 24                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010251c:	f6 c1 40             	test   $0x40,%cl
8010251f:	75 05                	jne    80102526 <kbdgetc+0x36>
80102521:	89 c2                	mov    %eax,%edx
80102523:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102526:	0f b6 82 e0 75 10 80 	movzbl -0x7fef8a20(%edx),%eax
8010252d:	83 c8 40             	or     $0x40,%eax
80102530:	0f b6 c0             	movzbl %al,%eax
80102533:	f7 d0                	not    %eax
80102535:	21 c8                	and    %ecx,%eax
80102537:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010253e:	5d                   	pop    %ebp
8010253f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102540:	f6 c1 40             	test   $0x40,%cl
80102543:	74 09                	je     8010254e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102545:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102548:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010254e:	0f b6 82 e0 75 10 80 	movzbl -0x7fef8a20(%edx),%eax
80102555:	09 c1                	or     %eax,%ecx
80102557:	0f b6 82 e0 74 10 80 	movzbl -0x7fef8b20(%edx),%eax
8010255e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102560:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102562:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102568:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010256b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010256e:	8b 04 85 c0 74 10 80 	mov    -0x7fef8b40(,%eax,4),%eax
80102575:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102579:	74 c3                	je     8010253e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010257b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010257e:	83 fa 19             	cmp    $0x19,%edx
80102581:	77 1d                	ja     801025a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102583:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102586:	5d                   	pop    %ebp
80102587:	c3                   	ret    
80102588:	90                   	nop
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102590:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102592:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	90                   	nop
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025a7:	83 f9 19             	cmp    $0x19,%ecx
801025aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b5:	5d                   	pop    %ebp
801025b6:	c3                   	ret    
801025b7:	89 f6                	mov    %esi,%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <kbdintr>:

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025c6:	68 f0 24 10 80       	push   $0x801024f0
801025cb:	e8 20 e2 ff ff       	call   801007f0 <consoleintr>
}
801025d0:	83 c4 10             	add    $0x10,%esp
801025d3:	c9                   	leave  
801025d4:	c3                   	ret    
801025d5:	66 90                	xchg   %ax,%ax
801025d7:	66 90                	xchg   %ax,%ax
801025d9:	66 90                	xchg   %ax,%ax
801025db:	66 90                	xchg   %ax,%ax
801025dd:	66 90                	xchg   %ax,%ax
801025df:	90                   	nop

801025e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025e5:	55                   	push   %ebp
801025e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025e8:	85 c0                	test   %eax,%eax
801025ea:	0f 84 c8 00 00 00    	je     801026b8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102604:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102607:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102611:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102614:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102617:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010261e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102621:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102624:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010262b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102631:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102638:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010263e:	8b 50 30             	mov    0x30(%eax),%edx
80102641:	c1 ea 10             	shr    $0x10,%edx
80102644:	80 fa 03             	cmp    $0x3,%dl
80102647:	77 77                	ja     801026c0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102649:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102650:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102653:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102656:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102660:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102663:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102677:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102691:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026a6:	80 e6 10             	and    $0x10,%dh
801026a9:	75 f5                	jne    801026a0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026b8:	5d                   	pop    %ebp
801026b9:	c3                   	ret    
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	e9 77 ff ff ff       	jmp    80102649 <lapicinit+0x69>
801026d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026e0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	74 0c                	je     801026f8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026ec:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ef:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026f0:	c1 e8 18             	shr    $0x18,%eax
}
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026f8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026fa:	5d                   	pop    %ebp
801026fb:	c3                   	ret    
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102700:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102705:	55                   	push   %ebp
80102706:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102708:	85 c0                	test   %eax,%eax
8010270a:	74 0d                	je     80102719 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102713:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102716:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	90                   	nop
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
}
80102723:	5d                   	pop    %ebp
80102724:	c3                   	ret    
80102725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102730:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102731:	ba 70 00 00 00       	mov    $0x70,%edx
80102736:	b8 0f 00 00 00       	mov    $0xf,%eax
8010273b:	89 e5                	mov    %esp,%ebp
8010273d:	53                   	push   %ebx
8010273e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102741:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102744:	ee                   	out    %al,(%dx)
80102745:	ba 71 00 00 00       	mov    $0x71,%edx
8010274a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010274f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102750:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102752:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102755:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010275b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010275d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102760:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102765:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102768:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102773:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102779:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102783:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102789:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102790:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102796:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010279c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027a5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ba:	5b                   	pop    %ebx
801027bb:	5d                   	pop    %ebp
801027bc:	c3                   	ret    
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027c0:	55                   	push   %ebp
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	57                   	push   %edi
801027ce:	56                   	push   %esi
801027cf:	53                   	push   %ebx
801027d0:	83 ec 4c             	sub    $0x4c,%esp
801027d3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d4:	ba 71 00 00 00       	mov    $0x71,%edx
801027d9:	ec                   	in     (%dx),%al
801027da:	83 e0 04             	and    $0x4,%eax
801027dd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e0:	31 db                	xor    %ebx,%ebx
801027e2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027e5:	bf 70 00 00 00       	mov    $0x70,%edi
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f0:	89 d8                	mov    %ebx,%eax
801027f2:	89 fa                	mov    %edi,%edx
801027f4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027fa:	89 ca                	mov    %ecx,%edx
801027fc:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027fd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102800:	89 fa                	mov    %edi,%edx
80102802:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102805:	b8 02 00 00 00       	mov    $0x2,%eax
8010280a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280b:	89 ca                	mov    %ecx,%edx
8010280d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010280e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102811:	89 fa                	mov    %edi,%edx
80102813:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102816:	b8 04 00 00 00       	mov    $0x4,%eax
8010281b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281c:	89 ca                	mov    %ecx,%edx
8010281e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010281f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102822:	89 fa                	mov    %edi,%edx
80102824:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102827:	b8 07 00 00 00       	mov    $0x7,%eax
8010282c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282d:	89 ca                	mov    %ecx,%edx
8010282f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102830:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102833:	89 fa                	mov    %edi,%edx
80102835:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102838:	b8 08 00 00 00       	mov    $0x8,%eax
8010283d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283e:	89 ca                	mov    %ecx,%edx
80102840:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102841:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102844:	89 fa                	mov    %edi,%edx
80102846:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102849:	b8 09 00 00 00       	mov    $0x9,%eax
8010284e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284f:	89 ca                	mov    %ecx,%edx
80102851:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102852:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102855:	89 fa                	mov    %edi,%edx
80102857:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010285a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010285f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102863:	84 c0                	test   %al,%al
80102865:	78 89                	js     801027f0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102867:	89 d8                	mov    %ebx,%eax
80102869:	89 fa                	mov    %edi,%edx
8010286b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102872:	89 fa                	mov    %edi,%edx
80102874:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102877:	b8 02 00 00 00       	mov    $0x2,%eax
8010287c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	89 ca                	mov    %ecx,%edx
8010287f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102880:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102883:	89 fa                	mov    %edi,%edx
80102885:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102888:	b8 04 00 00 00       	mov    $0x4,%eax
8010288d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288e:	89 ca                	mov    %ecx,%edx
80102890:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102891:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102894:	89 fa                	mov    %edi,%edx
80102896:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102899:	b8 07 00 00 00       	mov    $0x7,%eax
8010289e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289f:	89 ca                	mov    %ecx,%edx
801028a1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a5:	89 fa                	mov    %edi,%edx
801028a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028aa:	b8 08 00 00 00       	mov    $0x8,%eax
801028af:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b0:	89 ca                	mov    %ecx,%edx
801028b2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b6:	89 fa                	mov    %edi,%edx
801028b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028bb:	b8 09 00 00 00       	mov    $0x9,%eax
801028c0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c1:	89 ca                	mov    %ecx,%edx
801028c3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028c7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028cd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028d0:	6a 18                	push   $0x18
801028d2:	56                   	push   %esi
801028d3:	50                   	push   %eax
801028d4:	e8 d7 1d 00 00       	call   801046b0 <memcmp>
801028d9:	83 c4 10             	add    $0x10,%esp
801028dc:	85 c0                	test   %eax,%eax
801028de:	0f 85 0c ff ff ff    	jne    801027f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028e4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028e8:	75 78                	jne    80102962 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ed:	89 c2                	mov    %eax,%edx
801028ef:	83 e0 0f             	and    $0xf,%eax
801028f2:	c1 ea 04             	shr    $0x4,%edx
801028f5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028fe:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102901:	89 c2                	mov    %eax,%edx
80102903:	83 e0 0f             	and    $0xf,%eax
80102906:	c1 ea 04             	shr    $0x4,%edx
80102909:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102912:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102915:	89 c2                	mov    %eax,%edx
80102917:	83 e0 0f             	and    $0xf,%eax
8010291a:	c1 ea 04             	shr    $0x4,%edx
8010291d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102920:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102923:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102926:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102929:	89 c2                	mov    %eax,%edx
8010292b:	83 e0 0f             	and    $0xf,%eax
8010292e:	c1 ea 04             	shr    $0x4,%edx
80102931:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102934:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102937:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010293a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010293d:	89 c2                	mov    %eax,%edx
8010293f:	83 e0 0f             	and    $0xf,%eax
80102942:	c1 ea 04             	shr    $0x4,%edx
80102945:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102948:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010294e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102951:	89 c2                	mov    %eax,%edx
80102953:	83 e0 0f             	and    $0xf,%eax
80102956:	c1 ea 04             	shr    $0x4,%edx
80102959:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102962:	8b 75 08             	mov    0x8(%ebp),%esi
80102965:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102968:	89 06                	mov    %eax,(%esi)
8010296a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010296d:	89 46 04             	mov    %eax,0x4(%esi)
80102970:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102973:	89 46 08             	mov    %eax,0x8(%esi)
80102976:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102979:	89 46 0c             	mov    %eax,0xc(%esi)
8010297c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297f:	89 46 10             	mov    %eax,0x10(%esi)
80102982:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102985:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102988:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010298f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102992:	5b                   	pop    %ebx
80102993:	5e                   	pop    %esi
80102994:	5f                   	pop    %edi
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	66 90                	xchg   %ax,%ax
80102999:	66 90                	xchg   %ax,%ax
8010299b:	66 90                	xchg   %ax,%ax
8010299d:	66 90                	xchg   %ax,%ax
8010299f:	90                   	nop

801029a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029a0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801029a6:	85 c9                	test   %ecx,%ecx
801029a8:	0f 8e 85 00 00 00    	jle    80102a33 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029ae:	55                   	push   %ebp
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	31 db                	xor    %ebx,%ebx
801029b6:	83 ec 0c             	sub    $0xc,%esp
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029c0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029c5:	83 ec 08             	sub    $0x8,%esp
801029c8:	01 d8                	add    %ebx,%eax
801029ca:	83 c0 01             	add    $0x1,%eax
801029cd:	50                   	push   %eax
801029ce:	ff 35 c4 26 11 80    	pushl  0x801126c4
801029d4:	e8 f7 d6 ff ff       	call   801000d0 <bread>
801029d9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029db:	58                   	pop    %eax
801029dc:	5a                   	pop    %edx
801029dd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801029e4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ed:	e8 de d6 ff ff       	call   801000d0 <bread>
801029f2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029f4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029f7:	83 c4 0c             	add    $0xc,%esp
801029fa:	68 00 02 00 00       	push   $0x200
801029ff:	50                   	push   %eax
80102a00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a03:	50                   	push   %eax
80102a04:	e8 07 1d 00 00       	call   80104710 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a09:	89 34 24             	mov    %esi,(%esp)
80102a0c:	e8 8f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a11:	89 3c 24             	mov    %edi,(%esp)
80102a14:	e8 c7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 bf d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a2a:	7f 94                	jg     801029c0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a2f:	5b                   	pop    %ebx
80102a30:	5e                   	pop    %esi
80102a31:	5f                   	pop    %edi
80102a32:	5d                   	pop    %ebp
80102a33:	f3 c3                	repz ret 
80102a35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	53                   	push   %ebx
80102a44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a53:	e8 78 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a58:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a5e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a61:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a63:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a65:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a68:	7e 1f                	jle    80102a89 <write_head+0x49>
80102a6a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a71:	31 d2                	xor    %edx,%edx
80102a73:	90                   	nop
80102a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a78:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102a7e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a82:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a85:	39 c2                	cmp    %eax,%edx
80102a87:	75 ef                	jne    80102a78 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a89:	83 ec 0c             	sub    $0xc,%esp
80102a8c:	53                   	push   %ebx
80102a8d:	e8 0e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a92:	89 1c 24             	mov    %ebx,(%esp)
80102a95:	e8 46 d7 ff ff       	call   801001e0 <brelse>
}
80102a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9d:	c9                   	leave  
80102a9e:	c3                   	ret    
80102a9f:	90                   	nop

80102aa0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	53                   	push   %ebx
80102aa4:	83 ec 2c             	sub    $0x2c,%esp
80102aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aaa:	68 e0 76 10 80       	push   $0x801076e0
80102aaf:	68 80 26 11 80       	push   $0x80112680
80102ab4:	e8 47 19 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102ab9:	58                   	pop    %eax
80102aba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102abd:	5a                   	pop    %edx
80102abe:	50                   	push   %eax
80102abf:	53                   	push   %ebx
80102ac0:	e8 5b e9 ff ff       	call   80101420 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102acc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102add:	5a                   	pop    %edx
80102ade:	50                   	push   %eax
80102adf:	53                   	push   %ebx
80102ae0:	e8 eb d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ae5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ae8:	83 c4 10             	add    $0x10,%esp
80102aeb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102aed:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102af3:	7e 1c                	jle    80102b11 <initlog+0x71>
80102af5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102afc:	31 d2                	xor    %edx,%edx
80102afe:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b04:	83 c2 04             	add    $0x4,%edx
80102b07:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b0d:	39 da                	cmp    %ebx,%edx
80102b0f:	75 ef                	jne    80102b00 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b11:	83 ec 0c             	sub    $0xc,%esp
80102b14:	50                   	push   %eax
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b1a:	e8 81 fe ff ff       	call   801029a0 <install_trans>
  log.lh.n = 0;
80102b1f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b26:	00 00 00 
  write_head(); // clear the log
80102b29:	e8 12 ff ff ff       	call   80102a40 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b31:	c9                   	leave  
80102b32:	c3                   	ret    
80102b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b46:	68 80 26 11 80       	push   $0x80112680
80102b4b:	e8 10 1a 00 00       	call   80104560 <acquire>
80102b50:	83 c4 10             	add    $0x10,%esp
80102b53:	eb 18                	jmp    80102b6d <begin_op+0x2d>
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	68 80 26 11 80       	push   $0x80112680
80102b60:	68 80 26 11 80       	push   $0x80112680
80102b65:	e8 f6 13 00 00       	call   80103f60 <sleep>
80102b6a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	75 e2                	jne    80102b58 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b81:	83 c0 01             	add    $0x1,%eax
80102b84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b8a:	83 fa 1e             	cmp    $0x1e,%edx
80102b8d:	7f c9                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b97:	68 80 26 11 80       	push   $0x80112680
80102b9c:	e8 6f 1a 00 00       	call   80104610 <release>
      break;
    }
  }
}
80102ba1:	83 c4 10             	add    $0x10,%esp
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	68 80 26 11 80       	push   $0x80112680
80102bbe:	e8 9d 19 00 00       	call   80104560 <acquire>
  log.outstanding -= 1;
80102bc3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bc8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102bce:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bd6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bdb:	0f 85 23 01 00 00    	jne    80102d04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102be1:	85 c0                	test   %eax,%eax
80102be3:	0f 85 f7 00 00 00    	jne    80102ce0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bec:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bf3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bf6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf8:	68 80 26 11 80       	push   $0x80112680
80102bfd:	e8 0e 1a 00 00       	call   80104610 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c02:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c08:	83 c4 10             	add    $0x10,%esp
80102c0b:	85 c9                	test   %ecx,%ecx
80102c0d:	0f 8e 8a 00 00 00    	jle    80102c9d <end_op+0xed>
80102c13:	90                   	nop
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c18:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c1d:	83 ec 08             	sub    $0x8,%esp
80102c20:	01 d8                	add    %ebx,%eax
80102c22:	83 c0 01             	add    $0x1,%eax
80102c25:	50                   	push   %eax
80102c26:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c2c:	e8 9f d4 ff ff       	call   801000d0 <bread>
80102c31:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c33:	58                   	pop    %eax
80102c34:	5a                   	pop    %edx
80102c35:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c3c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c42:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c45:	e8 86 d4 ff ff       	call   801000d0 <bread>
80102c4a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c4c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c4f:	83 c4 0c             	add    $0xc,%esp
80102c52:	68 00 02 00 00       	push   $0x200
80102c57:	50                   	push   %eax
80102c58:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5b:	50                   	push   %eax
80102c5c:	e8 af 1a 00 00       	call   80104710 <memmove>
    bwrite(to);  // write the log
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 37 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c69:	89 3c 24             	mov    %edi,(%esp)
80102c6c:	e8 6f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 67 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c79:	83 c4 10             	add    $0x10,%esp
80102c7c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c82:	7c 94                	jl     80102c18 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 b7 fd ff ff       	call   80102a40 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 12 fd ff ff       	call   801029a0 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 a3 fd ff ff       	call   80102a40 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c9d:	83 ec 0c             	sub    $0xc,%esp
80102ca0:	68 80 26 11 80       	push   $0x80112680
80102ca5:	e8 b6 18 00 00       	call   80104560 <acquire>
    log.committing = 0;
    wakeup(&log);
80102caa:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cb1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cb8:	00 00 00 
    wakeup(&log);
80102cbb:	e8 60 14 00 00       	call   80104120 <wakeup>
    release(&log.lock);
80102cc0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc7:	e8 44 19 00 00       	call   80104610 <release>
80102ccc:	83 c4 10             	add    $0x10,%esp
  }
}
80102ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cd2:	5b                   	pop    %ebx
80102cd3:	5e                   	pop    %esi
80102cd4:	5f                   	pop    %edi
80102cd5:	5d                   	pop    %ebp
80102cd6:	c3                   	ret    
80102cd7:	89 f6                	mov    %esi,%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102ce0:	83 ec 0c             	sub    $0xc,%esp
80102ce3:	68 80 26 11 80       	push   $0x80112680
80102ce8:	e8 33 14 00 00       	call   80104120 <wakeup>
  }
  release(&log.lock);
80102ced:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cf4:	e8 17 19 00 00       	call   80104610 <release>
80102cf9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d04:	83 ec 0c             	sub    $0xc,%esp
80102d07:	68 e4 76 10 80       	push   $0x801076e4
80102d0c:	e8 5f d6 ff ff       	call   80100370 <panic>
80102d11:	eb 0d                	jmp    80102d20 <log_write>
80102d13:	90                   	nop
80102d14:	90                   	nop
80102d15:	90                   	nop
80102d16:	90                   	nop
80102d17:	90                   	nop
80102d18:	90                   	nop
80102d19:	90                   	nop
80102d1a:	90                   	nop
80102d1b:	90                   	nop
80102d1c:	90                   	nop
80102d1d:	90                   	nop
80102d1e:	90                   	nop
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d30:	83 fa 1d             	cmp    $0x1d,%edx
80102d33:	0f 8f 97 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d39:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d3e:	83 e8 01             	sub    $0x1,%eax
80102d41:	39 c2                	cmp    %eax,%edx
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 87 00 00 00    	jle    80102ddd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	68 80 26 11 80       	push   $0x80112680
80102d5e:	e8 fd 17 00 00       	call   80104560 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d63:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d69:	83 c4 10             	add    $0x10,%esp
80102d6c:	83 fa 00             	cmp    $0x0,%edx
80102d6f:	7e 50                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d71:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d74:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d76:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102d7c:	75 0b                	jne    80102d89 <log_write+0x69>
80102d7e:	eb 38                	jmp    80102db8 <log_write+0x98>
80102d80:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dad:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dae:	e9 5d 18 00 00       	jmp    80104610 <release>
80102db3:	90                   	nop
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 f3 76 10 80       	push   $0x801076f3
80102dd8:	e8 93 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddd:	83 ec 0c             	sub    $0xc,%esp
80102de0:	68 09 77 10 80       	push   $0x80107709
80102de5:	e8 86 d5 ff ff       	call   80100370 <panic>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102df7:	e8 84 09 00 00       	call   80103780 <cpuid>
80102dfc:	89 c3                	mov    %eax,%ebx
80102dfe:	e8 7d 09 00 00       	call   80103780 <cpuid>
80102e03:	83 ec 04             	sub    $0x4,%esp
80102e06:	53                   	push   %ebx
80102e07:	50                   	push   %eax
80102e08:	68 24 77 10 80       	push   $0x80107724
80102e0d:	e8 4e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e12:	e8 99 2b 00 00       	call   801059b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e17:	e8 e4 08 00 00       	call   80103700 <mycpu>
80102e1c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e1e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e2a:	e8 a1 0c 00 00       	call   80103ad0 <scheduler>
80102e2f:	90                   	nop

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 35 3d 00 00       	call   80106b70 <switchkvm>
  seginit();
80102e3b:	e8 30 3c 00 00       	call   80106a70 <seginit>
  lapicinit();
80102e40:	e8 9b f7 ff ff       	call   801025e0 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	ff 71 fc             	pushl  -0x4(%ecx)
80102e5a:	55                   	push   %ebp
80102e5b:	89 e5                	mov    %esp,%ebp
80102e5d:	53                   	push   %ebx
80102e5e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e5f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e64:	83 ec 08             	sub    $0x8,%esp
80102e67:	68 00 00 40 80       	push   $0x80400000
80102e6c:	68 c8 57 11 80       	push   $0x801157c8
80102e71:	e8 3a f5 ff ff       	call   801023b0 <kinit1>
  kvmalloc();      // kernel page table
80102e76:	e8 95 41 00 00       	call   80107010 <kvmalloc>
  mpinit();        // detect other processors
80102e7b:	e8 70 01 00 00       	call   80102ff0 <mpinit>
  lapicinit();     // interrupt controller
80102e80:	e8 5b f7 ff ff       	call   801025e0 <lapicinit>
  seginit();       // segment descriptors
80102e85:	e8 e6 3b 00 00       	call   80106a70 <seginit>
  picinit();       // disable pic
80102e8a:	e8 31 03 00 00       	call   801031c0 <picinit>
  ioapicinit();    // another interrupt controller
80102e8f:	e8 4c f3 ff ff       	call   801021e0 <ioapicinit>
  consoleinit();   // console hardware
80102e94:	e8 07 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e99:	e8 a2 2e 00 00       	call   80105d40 <uartinit>
  pinit();         // process table
80102e9e:	e8 3d 08 00 00       	call   801036e0 <pinit>
  tvinit();        // trap vectors
80102ea3:	e8 68 2a 00 00       	call   80105910 <tvinit>
  binit();         // buffer cache
80102ea8:	e8 93 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ead:	e8 9e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102eb2:	e8 09 f1 ff ff       	call   80101fc0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eb7:	83 c4 0c             	add    $0xc,%esp
80102eba:	68 8a 00 00 00       	push   $0x8a
80102ebf:	68 8c a4 10 80       	push   $0x8010a48c
80102ec4:	68 00 70 00 80       	push   $0x80007000
80102ec9:	e8 42 18 00 00       	call   80104710 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ece:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed5:	00 00 00 
80102ed8:	83 c4 10             	add    $0x10,%esp
80102edb:	05 80 27 11 80       	add    $0x80112780,%eax
80102ee0:	39 d8                	cmp    %ebx,%eax
80102ee2:	76 6f                	jbe    80102f53 <main+0x103>
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ee8:	e8 13 08 00 00       	call   80103700 <mycpu>
80102eed:	39 d8                	cmp    %ebx,%eax
80102eef:	74 49                	je     80102f3a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ef1:	e8 8a f5 ff ff       	call   80102480 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ef6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102efb:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f02:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f05:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f0c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f0f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f14:	0f b6 03             	movzbl (%ebx),%eax
80102f17:	83 ec 08             	sub    $0x8,%esp
80102f1a:	68 00 70 00 00       	push   $0x7000
80102f1f:	50                   	push   %eax
80102f20:	e8 0b f8 ff ff       	call   80102730 <lapicstartap>
80102f25:	83 c4 10             	add    $0x10,%esp
80102f28:	90                   	nop
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 f6                	je     80102f30 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f3a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f41:	00 00 00 
80102f44:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f4a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f4f:	39 c3                	cmp    %eax,%ebx
80102f51:	72 95                	jb     80102ee8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f53:	83 ec 08             	sub    $0x8,%esp
80102f56:	68 00 00 00 8e       	push   $0x8e000000
80102f5b:	68 00 00 40 80       	push   $0x80400000
80102f60:	e8 bb f4 ff ff       	call   80102420 <kinit2>
  userinit();      // first user process
80102f65:	e8 66 08 00 00       	call   801037d0 <userinit>
  mpmain();        // finish this processor's setup
80102f6a:	e8 81 fe ff ff       	call   80102df0 <mpmain>
80102f6f:	90                   	nop

80102f70 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	57                   	push   %edi
80102f74:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f75:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f7c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f7f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f82:	39 de                	cmp    %ebx,%esi
80102f84:	73 48                	jae    80102fce <mpsearch1+0x5e>
80102f86:	8d 76 00             	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f90:	83 ec 04             	sub    $0x4,%esp
80102f93:	8d 7e 10             	lea    0x10(%esi),%edi
80102f96:	6a 04                	push   $0x4
80102f98:	68 38 77 10 80       	push   $0x80107738
80102f9d:	56                   	push   %esi
80102f9e:	e8 0d 17 00 00       	call   801046b0 <memcmp>
80102fa3:	83 c4 10             	add    $0x10,%esp
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	75 1e                	jne    80102fc8 <mpsearch1+0x58>
80102faa:	8d 7e 10             	lea    0x10(%esi),%edi
80102fad:	89 f2                	mov    %esi,%edx
80102faf:	31 c9                	xor    %ecx,%ecx
80102fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fb8:	0f b6 02             	movzbl (%edx),%eax
80102fbb:	83 c2 01             	add    $0x1,%edx
80102fbe:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fc0:	39 fa                	cmp    %edi,%edx
80102fc2:	75 f4                	jne    80102fb8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc4:	84 c9                	test   %cl,%cl
80102fc6:	74 10                	je     80102fd8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc8:	39 fb                	cmp    %edi,%ebx
80102fca:	89 fe                	mov    %edi,%esi
80102fcc:	77 c2                	ja     80102f90 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fd1:	31 c0                	xor    %eax,%eax
}
80102fd3:	5b                   	pop    %ebx
80102fd4:	5e                   	pop    %esi
80102fd5:	5f                   	pop    %edi
80102fd6:	5d                   	pop    %ebp
80102fd7:	c3                   	ret    
80102fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fdb:	89 f0                	mov    %esi,%eax
80102fdd:	5b                   	pop    %ebx
80102fde:	5e                   	pop    %esi
80102fdf:	5f                   	pop    %edi
80102fe0:	5d                   	pop    %ebp
80102fe1:	c3                   	ret    
80102fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	57                   	push   %edi
80102ff4:	56                   	push   %esi
80102ff5:	53                   	push   %ebx
80102ff6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ff9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103000:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103007:	c1 e0 08             	shl    $0x8,%eax
8010300a:	09 d0                	or     %edx,%eax
8010300c:	c1 e0 04             	shl    $0x4,%eax
8010300f:	85 c0                	test   %eax,%eax
80103011:	75 1b                	jne    8010302e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103013:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010301a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103021:	c1 e0 08             	shl    $0x8,%eax
80103024:	09 d0                	or     %edx,%eax
80103026:	c1 e0 0a             	shl    $0xa,%eax
80103029:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010302e:	ba 00 04 00 00       	mov    $0x400,%edx
80103033:	e8 38 ff ff ff       	call   80102f70 <mpsearch1>
80103038:	85 c0                	test   %eax,%eax
8010303a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010303d:	0f 84 37 01 00 00    	je     8010317a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103046:	8b 58 04             	mov    0x4(%eax),%ebx
80103049:	85 db                	test   %ebx,%ebx
8010304b:	0f 84 43 01 00 00    	je     80103194 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103051:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103057:	83 ec 04             	sub    $0x4,%esp
8010305a:	6a 04                	push   $0x4
8010305c:	68 3d 77 10 80       	push   $0x8010773d
80103061:	56                   	push   %esi
80103062:	e8 49 16 00 00       	call   801046b0 <memcmp>
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c0                	test   %eax,%eax
8010306c:	0f 85 22 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103072:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103079:	3c 01                	cmp    $0x1,%al
8010307b:	74 08                	je     80103085 <mpinit+0x95>
8010307d:	3c 04                	cmp    $0x4,%al
8010307f:	0f 85 0f 01 00 00    	jne    80103194 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103085:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010308c:	85 ff                	test   %edi,%edi
8010308e:	74 21                	je     801030b1 <mpinit+0xc1>
80103090:	31 d2                	xor    %edx,%edx
80103092:	31 c0                	xor    %eax,%eax
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103098:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010309f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030a3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a5:	39 c7                	cmp    %eax,%edi
801030a7:	75 ef                	jne    80103098 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030a9:	84 d2                	test   %dl,%dl
801030ab:	0f 85 e3 00 00 00    	jne    80103194 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030b1:	85 f6                	test   %esi,%esi
801030b3:	0f 84 db 00 00 00    	je     80103194 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030b9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030bf:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030c4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030cb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030d1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d6:	01 d6                	add    %edx,%esi
801030d8:	90                   	nop
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e0:	39 c6                	cmp    %eax,%esi
801030e2:	76 23                	jbe    80103107 <mpinit+0x117>
801030e4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030e7:	80 fa 04             	cmp    $0x4,%dl
801030ea:	0f 87 c0 00 00 00    	ja     801031b0 <mpinit+0x1c0>
801030f0:	ff 24 95 7c 77 10 80 	jmp    *-0x7fef8884(,%edx,4)
801030f7:	89 f6                	mov    %esi,%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103100:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103103:	39 c6                	cmp    %eax,%esi
80103105:	77 dd                	ja     801030e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103107:	85 db                	test   %ebx,%ebx
80103109:	0f 84 92 00 00 00    	je     801031a1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103112:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103116:	74 15                	je     8010312d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103118:	ba 22 00 00 00       	mov    $0x22,%edx
8010311d:	b8 70 00 00 00       	mov    $0x70,%eax
80103122:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103123:	ba 23 00 00 00       	mov    $0x23,%edx
80103128:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103129:	83 c8 01             	or     $0x1,%eax
8010312c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010312d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103130:	5b                   	pop    %ebx
80103131:	5e                   	pop    %esi
80103132:	5f                   	pop    %edi
80103133:	5d                   	pop    %ebp
80103134:	c3                   	ret    
80103135:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103138:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010313e:	83 f9 07             	cmp    $0x7,%ecx
80103141:	7f 19                	jg     8010315c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103143:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103147:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010314d:	83 c1 01             	add    $0x1,%ecx
80103150:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103156:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010315c:	83 c0 14             	add    $0x14,%eax
      continue;
8010315f:	e9 7c ff ff ff       	jmp    801030e0 <mpinit+0xf0>
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010316c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010316f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103175:	e9 66 ff ff ff       	jmp    801030e0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010317a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010317f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103184:	e8 e7 fd ff ff       	call   80102f70 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103189:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010318e:	0f 85 af fe ff ff    	jne    80103043 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103194:	83 ec 0c             	sub    $0xc,%esp
80103197:	68 42 77 10 80       	push   $0x80107742
8010319c:	e8 cf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031a1:	83 ec 0c             	sub    $0xc,%esp
801031a4:	68 5c 77 10 80       	push   $0x8010775c
801031a9:	e8 c2 d1 ff ff       	call   80100370 <panic>
801031ae:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031b0:	31 db                	xor    %ebx,%ebx
801031b2:	e9 30 ff ff ff       	jmp    801030e7 <mpinit+0xf7>
801031b7:	66 90                	xchg   %ax,%ax
801031b9:	66 90                	xchg   %ax,%ax
801031bb:	66 90                	xchg   %ax,%ax
801031bd:	66 90                	xchg   %ax,%ax
801031bf:	90                   	nop

801031c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031c0:	55                   	push   %ebp
801031c1:	ba 21 00 00 00       	mov    $0x21,%edx
801031c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	ee                   	out    %al,(%dx)
801031ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801031d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031d4:	5d                   	pop    %ebp
801031d5:	c3                   	ret    
801031d6:	66 90                	xchg   %ax,%ax
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 0c             	sub    $0xc,%esp
801031e9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031fb:	e8 70 db ff ff       	call   80100d70 <filealloc>
80103200:	85 c0                	test   %eax,%eax
80103202:	89 06                	mov    %eax,(%esi)
80103204:	0f 84 a8 00 00 00    	je     801032b2 <pipealloc+0xd2>
8010320a:	e8 61 db ff ff       	call   80100d70 <filealloc>
8010320f:	85 c0                	test   %eax,%eax
80103211:	89 03                	mov    %eax,(%ebx)
80103213:	0f 84 87 00 00 00    	je     801032a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103219:	e8 62 f2 ff ff       	call   80102480 <kalloc>
8010321e:	85 c0                	test   %eax,%eax
80103220:	89 c7                	mov    %eax,%edi
80103222:	0f 84 b0 00 00 00    	je     801032d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103228:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010322b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103232:	00 00 00 
  p->writeopen = 1;
80103235:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010323c:	00 00 00 
  p->nwrite = 0;
8010323f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103246:	00 00 00 
  p->nread = 0;
80103249:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103250:	00 00 00 
  initlock(&p->lock, "pipe");
80103253:	68 90 77 10 80       	push   $0x80107790
80103258:	50                   	push   %eax
80103259:	e8 a2 11 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
8010325e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103260:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103263:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103269:	8b 06                	mov    (%esi),%eax
8010326b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010326f:	8b 06                	mov    (%esi),%eax
80103271:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103275:	8b 06                	mov    (%esi),%eax
80103277:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010327a:	8b 03                	mov    (%ebx),%eax
8010327c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103282:	8b 03                	mov    (%ebx),%eax
80103284:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103288:	8b 03                	mov    (%ebx),%eax
8010328a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010328e:	8b 03                	mov    (%ebx),%eax
80103290:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103296:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103298:	5b                   	pop    %ebx
80103299:	5e                   	pop    %esi
8010329a:	5f                   	pop    %edi
8010329b:	5d                   	pop    %ebp
8010329c:	c3                   	ret    
8010329d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032a0:	8b 06                	mov    (%esi),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 1e                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f0);
801032a6:	83 ec 0c             	sub    $0xc,%esp
801032a9:	50                   	push   %eax
801032aa:	e8 81 db ff ff       	call   80100e30 <fileclose>
801032af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032b2:	8b 03                	mov    (%ebx),%eax
801032b4:	85 c0                	test   %eax,%eax
801032b6:	74 0c                	je     801032c4 <pipealloc+0xe4>
    fileclose(*f1);
801032b8:	83 ec 0c             	sub    $0xc,%esp
801032bb:	50                   	push   %eax
801032bc:	e8 6f db ff ff       	call   80100e30 <fileclose>
801032c1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5f                   	pop    %edi
801032cf:	5d                   	pop    %ebp
801032d0:	c3                   	ret    
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032d8:	8b 06                	mov    (%esi),%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 c8                	jne    801032a6 <pipealloc+0xc6>
801032de:	eb d2                	jmp    801032b2 <pipealloc+0xd2>

801032e0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	56                   	push   %esi
801032e4:	53                   	push   %ebx
801032e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032eb:	83 ec 0c             	sub    $0xc,%esp
801032ee:	53                   	push   %ebx
801032ef:	e8 6c 12 00 00       	call   80104560 <acquire>
  if(writable){
801032f4:	83 c4 10             	add    $0x10,%esp
801032f7:	85 f6                	test   %esi,%esi
801032f9:	74 45                	je     80103340 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032fb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103301:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103304:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010330b:	00 00 00 
    wakeup(&p->nread);
8010330e:	50                   	push   %eax
8010330f:	e8 0c 0e 00 00       	call   80104120 <wakeup>
80103314:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103317:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010331d:	85 d2                	test   %edx,%edx
8010331f:	75 0a                	jne    8010332b <pipeclose+0x4b>
80103321:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103327:	85 c0                	test   %eax,%eax
80103329:	74 35                	je     80103360 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010332b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010332e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103331:	5b                   	pop    %ebx
80103332:	5e                   	pop    %esi
80103333:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103334:	e9 d7 12 00 00       	jmp    80104610 <release>
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103340:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103346:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103349:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103350:	00 00 00 
    wakeup(&p->nwrite);
80103353:	50                   	push   %eax
80103354:	e8 c7 0d 00 00       	call   80104120 <wakeup>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	eb b9                	jmp    80103317 <pipeclose+0x37>
8010335e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	53                   	push   %ebx
80103364:	e8 a7 12 00 00       	call   80104610 <release>
    kfree((char*)p);
80103369:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010336c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010336f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103375:	e9 56 ef ff ff       	jmp    801022d0 <kfree>
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103380 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103380:	55                   	push   %ebp
80103381:	89 e5                	mov    %esp,%ebp
80103383:	57                   	push   %edi
80103384:	56                   	push   %esi
80103385:	53                   	push   %ebx
80103386:	83 ec 28             	sub    $0x28,%esp
80103389:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010338c:	53                   	push   %ebx
8010338d:	e8 ce 11 00 00       	call   80104560 <acquire>
  for(i = 0; i < n; i++){
80103392:	8b 45 10             	mov    0x10(%ebp),%eax
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	85 c0                	test   %eax,%eax
8010339a:	0f 8e b9 00 00 00    	jle    80103459 <pipewrite+0xd9>
801033a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033a3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033af:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033b8:	03 4d 10             	add    0x10(%ebp),%ecx
801033bb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033be:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033c4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ca:	39 d0                	cmp    %edx,%eax
801033cc:	74 38                	je     80103406 <pipewrite+0x86>
801033ce:	eb 59                	jmp    80103429 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033d0:	e8 cb 03 00 00       	call   801037a0 <myproc>
801033d5:	8b 48 24             	mov    0x24(%eax),%ecx
801033d8:	85 c9                	test   %ecx,%ecx
801033da:	75 34                	jne    80103410 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033dc:	83 ec 0c             	sub    $0xc,%esp
801033df:	57                   	push   %edi
801033e0:	e8 3b 0d 00 00       	call   80104120 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033e5:	58                   	pop    %eax
801033e6:	5a                   	pop    %edx
801033e7:	53                   	push   %ebx
801033e8:	56                   	push   %esi
801033e9:	e8 72 0b 00 00       	call   80103f60 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033fa:	83 c4 10             	add    $0x10,%esp
801033fd:	05 00 02 00 00       	add    $0x200,%eax
80103402:	39 c2                	cmp    %eax,%edx
80103404:	75 2a                	jne    80103430 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103406:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010340c:	85 c0                	test   %eax,%eax
8010340e:	75 c0                	jne    801033d0 <pipewrite+0x50>
        release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 f7 11 00 00       	call   80104610 <release>
        return -1;
80103419:	83 c4 10             	add    $0x10,%esp
8010341c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103424:	5b                   	pop    %ebx
80103425:	5e                   	pop    %esi
80103426:	5f                   	pop    %edi
80103427:	5d                   	pop    %ebp
80103428:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103429:	89 c2                	mov    %eax,%edx
8010342b:	90                   	nop
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103430:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103433:	8d 42 01             	lea    0x1(%edx),%eax
80103436:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010343a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103440:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103446:	0f b6 09             	movzbl (%ecx),%ecx
80103449:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010344d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103450:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103453:	0f 85 65 ff ff ff    	jne    801033be <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103459:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010345f:	83 ec 0c             	sub    $0xc,%esp
80103462:	50                   	push   %eax
80103463:	e8 b8 0c 00 00       	call   80104120 <wakeup>
  release(&p->lock);
80103468:	89 1c 24             	mov    %ebx,(%esp)
8010346b:	e8 a0 11 00 00       	call   80104610 <release>
  return n;
80103470:	83 c4 10             	add    $0x10,%esp
80103473:	8b 45 10             	mov    0x10(%ebp),%eax
80103476:	eb a9                	jmp    80103421 <pipewrite+0xa1>
80103478:	90                   	nop
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103480 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 18             	sub    $0x18,%esp
80103489:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010348f:	53                   	push   %ebx
80103490:	e8 cb 10 00 00       	call   80104560 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103495:	83 c4 10             	add    $0x10,%esp
80103498:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010349e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034a4:	75 6a                	jne    80103510 <piperead+0x90>
801034a6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034ac:	85 f6                	test   %esi,%esi
801034ae:	0f 84 cc 00 00 00    	je     80103580 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034b4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ba:	eb 2d                	jmp    801034e9 <piperead+0x69>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034c0:	83 ec 08             	sub    $0x8,%esp
801034c3:	53                   	push   %ebx
801034c4:	56                   	push   %esi
801034c5:	e8 96 0a 00 00       	call   80103f60 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034d3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034d9:	75 35                	jne    80103510 <piperead+0x90>
801034db:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034e1:	85 d2                	test   %edx,%edx
801034e3:	0f 84 97 00 00 00    	je     80103580 <piperead+0x100>
    if(myproc()->killed){
801034e9:	e8 b2 02 00 00       	call   801037a0 <myproc>
801034ee:	8b 48 24             	mov    0x24(%eax),%ecx
801034f1:	85 c9                	test   %ecx,%ecx
801034f3:	74 cb                	je     801034c0 <piperead+0x40>
      release(&p->lock);
801034f5:	83 ec 0c             	sub    $0xc,%esp
801034f8:	53                   	push   %ebx
801034f9:	e8 12 11 00 00       	call   80104610 <release>
      return -1;
801034fe:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103501:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103509:	5b                   	pop    %ebx
8010350a:	5e                   	pop    %esi
8010350b:	5f                   	pop    %edi
8010350c:	5d                   	pop    %ebp
8010350d:	c3                   	ret    
8010350e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103510:	8b 45 10             	mov    0x10(%ebp),%eax
80103513:	85 c0                	test   %eax,%eax
80103515:	7e 69                	jle    80103580 <piperead+0x100>
    if(p->nread == p->nwrite)
80103517:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010351d:	31 c9                	xor    %ecx,%ecx
8010351f:	eb 15                	jmp    80103536 <piperead+0xb6>
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103528:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103534:	74 5a                	je     80103590 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103536:	8d 70 01             	lea    0x1(%eax),%esi
80103539:	25 ff 01 00 00       	and    $0x1ff,%eax
8010353e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103544:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103549:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010354c:	83 c1 01             	add    $0x1,%ecx
8010354f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103552:	75 d4                	jne    80103528 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103554:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	50                   	push   %eax
8010355e:	e8 bd 0b 00 00       	call   80104120 <wakeup>
  release(&p->lock);
80103563:	89 1c 24             	mov    %ebx,(%esp)
80103566:	e8 a5 10 00 00       	call   80104610 <release>
  return i;
8010356b:	8b 45 10             	mov    0x10(%ebp),%eax
8010356e:	83 c4 10             	add    $0x10,%esp
}
80103571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103574:	5b                   	pop    %ebx
80103575:	5e                   	pop    %esi
80103576:	5f                   	pop    %edi
80103577:	5d                   	pop    %ebp
80103578:	c3                   	ret    
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103580:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103587:	eb cb                	jmp    80103554 <piperead+0xd4>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103590:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103593:	eb bf                	jmp    80103554 <piperead+0xd4>
80103595:	66 90                	xchg   %ax,%ax
80103597:	66 90                	xchg   %ax,%ax
80103599:	66 90                	xchg   %ax,%ax
8010359b:	66 90                	xchg   %ax,%ax
8010359d:	66 90                	xchg   %ax,%ax
8010359f:	90                   	nop

801035a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035a4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035a9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035ac:	68 40 2d 11 80       	push   $0x80112d40
801035b1:	e8 aa 0f 00 00       	call   80104560 <acquire>
801035b6:	83 c4 10             	add    $0x10,%esp
801035b9:	eb 17                	jmp    801035d2 <allocproc+0x32>
801035bb:	90                   	nop
801035bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035c0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801035c6:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
801035cc:	0f 84 96 00 00 00    	je     80103668 <allocproc+0xc8>
    if(p->state == UNUSED)
801035d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801035d5:	85 c0                	test   %eax,%eax
801035d7:	75 e7                	jne    801035c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035d9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->queuelevel = 0;
  p->priority = 0;
  p->tickleft = 4;
  //////////////////////////////////////////

  release(&ptable.lock);
801035de:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->queuelevel = 0;
  p->priority = 0;
  p->tickleft = 4;
  //////////////////////////////////////////

  release(&ptable.lock);
801035e8:	68 40 2d 11 80       	push   $0x80112d40
found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  /////////////////////////////////////////
  //항상 레벨 0에 들어가고 우선순위는 0이다.
  p->queuelevel = 0;
801035ed:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801035f4:	00 00 00 
  p->priority = 0;
801035f7:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->tickleft = 4;
801035fe:	c7 83 84 00 00 00 04 	movl   $0x4,0x84(%ebx)
80103605:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103608:	8d 50 01             	lea    0x1(%eax),%edx
8010360b:	89 43 10             	mov    %eax,0x10(%ebx)
8010360e:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  p->queuelevel = 0;
  p->priority = 0;
  p->tickleft = 4;
  //////////////////////////////////////////

  release(&ptable.lock);
80103614:	e8 f7 0f 00 00       	call   80104610 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103619:	e8 62 ee ff ff       	call   80102480 <kalloc>
8010361e:	83 c4 10             	add    $0x10,%esp
80103621:	85 c0                	test   %eax,%eax
80103623:	89 43 08             	mov    %eax,0x8(%ebx)
80103626:	74 57                	je     8010367f <allocproc+0xdf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103628:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010362e:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103631:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103636:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103639:	c7 40 14 01 59 10 80 	movl   $0x80105901,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103640:	6a 14                	push   $0x14
80103642:	6a 00                	push   $0x0
80103644:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103645:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103648:	e8 13 10 00 00       	call   80104660 <memset>
  p->context->eip = (uint)forkret;
8010364d:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103650:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103653:	c7 40 10 90 36 10 80 	movl   $0x80103690,0x10(%eax)

  return p;
8010365a:	89 d8                	mov    %ebx,%eax
}
8010365c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010365f:	c9                   	leave  
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	68 40 2d 11 80       	push   $0x80112d40
80103670:	e8 9b 0f 00 00       	call   80104610 <release>
  return 0;
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
8010367a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010367d:	c9                   	leave  
8010367e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010367f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103686:	eb d4                	jmp    8010365c <allocproc+0xbc>
80103688:	90                   	nop
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103690 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103696:	68 40 2d 11 80       	push   $0x80112d40
8010369b:	e8 70 0f 00 00       	call   80104610 <release>

  if (first) {
801036a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 c0                	test   %eax,%eax
801036aa:	75 04                	jne    801036b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036ac:	c9                   	leave  
801036ad:	c3                   	ret    
801036ae:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036b0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036b3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036ba:	00 00 00 
    iinit(ROOTDEV);
801036bd:	6a 01                	push   $0x1
801036bf:	e8 9c dd ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801036c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036cb:	e8 d0 f3 ff ff       	call   80102aa0 <initlog>
801036d0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036d3:	c9                   	leave  
801036d4:	c3                   	ret    
801036d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036e6:	68 95 77 10 80       	push   $0x80107795
801036eb:	68 40 2d 11 80       	push   $0x80112d40
801036f0:	e8 0b 0d 00 00       	call   80104400 <initlock>
}
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	c9                   	leave  
801036f9:	c3                   	ret    
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103700 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103705:	9c                   	pushf  
80103706:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103707:	f6 c4 02             	test   $0x2,%ah
8010370a:	75 5b                	jne    80103767 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010370c:	e8 cf ef ff ff       	call   801026e0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103711:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103717:	85 f6                	test   %esi,%esi
80103719:	7e 3f                	jle    8010375a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010371b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103722:	39 d0                	cmp    %edx,%eax
80103724:	74 30                	je     80103756 <mycpu+0x56>
80103726:	b9 30 28 11 80       	mov    $0x80112830,%ecx
8010372b:	31 d2                	xor    %edx,%edx
8010372d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103730:	83 c2 01             	add    $0x1,%edx
80103733:	39 f2                	cmp    %esi,%edx
80103735:	74 23                	je     8010375a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103737:	0f b6 19             	movzbl (%ecx),%ebx
8010373a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103740:	39 d8                	cmp    %ebx,%eax
80103742:	75 ec                	jne    80103730 <mycpu+0x30>
      return &cpus[i];
80103744:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010374a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010374d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010374e:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
80103755:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103756:	31 d2                	xor    %edx,%edx
80103758:	eb ea                	jmp    80103744 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	68 9c 77 10 80       	push   $0x8010779c
80103762:	e8 09 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103767:	83 ec 0c             	sub    $0xc,%esp
8010376a:	68 78 78 10 80       	push   $0x80107878
8010376f:	e8 fc cb ff ff       	call   80100370 <panic>
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103786:	e8 75 ff ff ff       	call   80103700 <mycpu>
8010378b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103790:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103791:	c1 f8 04             	sar    $0x4,%eax
80103794:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010379a:	c3                   	ret    
8010379b:	90                   	nop
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037a0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
801037a4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801037a7:	e8 d4 0c 00 00       	call   80104480 <pushcli>
  c = mycpu();
801037ac:	e8 4f ff ff ff       	call   80103700 <mycpu>
  p = c->proc;
801037b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037b7:	e8 04 0d 00 00       	call   801044c0 <popcli>
  return p;
}
801037bc:	83 c4 04             	add    $0x4,%esp
801037bf:	89 d8                	mov    %ebx,%eax
801037c1:	5b                   	pop    %ebx
801037c2:	5d                   	pop    %ebp
801037c3:	c3                   	ret    
801037c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037d0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
801037d4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037d7:	e8 c4 fd ff ff       	call   801035a0 <allocproc>
801037dc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801037de:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037e3:	e8 a8 37 00 00       	call   80106f90 <setupkvm>
801037e8:	85 c0                	test   %eax,%eax
801037ea:	89 43 04             	mov    %eax,0x4(%ebx)
801037ed:	0f 84 bd 00 00 00    	je     801038b0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037f3:	83 ec 04             	sub    $0x4,%esp
801037f6:	68 2c 00 00 00       	push   $0x2c
801037fb:	68 60 a4 10 80       	push   $0x8010a460
80103800:	50                   	push   %eax
80103801:	e8 9a 34 00 00       	call   80106ca0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103806:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103809:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010380f:	6a 4c                	push   $0x4c
80103811:	6a 00                	push   $0x0
80103813:	ff 73 18             	pushl  0x18(%ebx)
80103816:	e8 45 0e 00 00       	call   80104660 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010381b:	8b 43 18             	mov    0x18(%ebx),%eax
8010381e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103823:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103828:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010382b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010382f:	8b 43 18             	mov    0x18(%ebx),%eax
80103832:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103836:	8b 43 18             	mov    0x18(%ebx),%eax
80103839:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010383d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103841:	8b 43 18             	mov    0x18(%ebx),%eax
80103844:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103848:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010384c:	8b 43 18             	mov    0x18(%ebx),%eax
8010384f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103856:	8b 43 18             	mov    0x18(%ebx),%eax
80103859:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103860:	8b 43 18             	mov    0x18(%ebx),%eax
80103863:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010386a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010386d:	6a 10                	push   $0x10
8010386f:	68 c5 77 10 80       	push   $0x801077c5
80103874:	50                   	push   %eax
80103875:	e8 e6 0f 00 00       	call   80104860 <safestrcpy>
  p->cwd = namei("/");
8010387a:	c7 04 24 ce 77 10 80 	movl   $0x801077ce,(%esp)
80103881:	e8 2a e6 ff ff       	call   80101eb0 <namei>
80103886:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103889:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103890:	e8 cb 0c 00 00       	call   80104560 <acquire>

  p->state = RUNNABLE;
80103895:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010389c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801038a3:	e8 68 0d 00 00       	call   80104610 <release>
}
801038a8:	83 c4 10             	add    $0x10,%esp
801038ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ae:	c9                   	leave  
801038af:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	68 ac 77 10 80       	push   $0x801077ac
801038b8:	e8 b3 ca ff ff       	call   80100370 <panic>
801038bd:	8d 76 00             	lea    0x0(%esi),%esi

801038c0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801038c8:	e8 b3 0b 00 00       	call   80104480 <pushcli>
  c = mycpu();
801038cd:	e8 2e fe ff ff       	call   80103700 <mycpu>
  p = c->proc;
801038d2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038d8:	e8 e3 0b 00 00       	call   801044c0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
801038dd:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
801038e0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801038e2:	7e 34                	jle    80103918 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038e4:	83 ec 04             	sub    $0x4,%esp
801038e7:	01 c6                	add    %eax,%esi
801038e9:	56                   	push   %esi
801038ea:	50                   	push   %eax
801038eb:	ff 73 04             	pushl  0x4(%ebx)
801038ee:	e8 ed 34 00 00       	call   80106de0 <allocuvm>
801038f3:	83 c4 10             	add    $0x10,%esp
801038f6:	85 c0                	test   %eax,%eax
801038f8:	74 36                	je     80103930 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801038fa:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038fd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038ff:	53                   	push   %ebx
80103900:	e8 8b 32 00 00       	call   80106b90 <switchuvm>
  return 0;
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	31 c0                	xor    %eax,%eax
}
8010390a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010390d:	5b                   	pop    %ebx
8010390e:	5e                   	pop    %esi
8010390f:	5d                   	pop    %ebp
80103910:	c3                   	ret    
80103911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103918:	74 e0                	je     801038fa <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010391a:	83 ec 04             	sub    $0x4,%esp
8010391d:	01 c6                	add    %eax,%esi
8010391f:	56                   	push   %esi
80103920:	50                   	push   %eax
80103921:	ff 73 04             	pushl  0x4(%ebx)
80103924:	e8 b7 35 00 00       	call   80106ee0 <deallocuvm>
80103929:	83 c4 10             	add    $0x10,%esp
8010392c:	85 c0                	test   %eax,%eax
8010392e:	75 ca                	jne    801038fa <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103935:	eb d3                	jmp    8010390a <growproc+0x4a>
80103937:	89 f6                	mov    %esi,%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103949:	e8 32 0b 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010394e:	e8 ad fd ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103953:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103959:	e8 62 0b 00 00       	call   801044c0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010395e:	e8 3d fc ff ff       	call   801035a0 <allocproc>
80103963:	85 c0                	test   %eax,%eax
80103965:	89 c7                	mov    %eax,%edi
80103967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010396a:	0f 84 b5 00 00 00    	je     80103a25 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103970:	83 ec 08             	sub    $0x8,%esp
80103973:	ff 33                	pushl  (%ebx)
80103975:	ff 73 04             	pushl  0x4(%ebx)
80103978:	e8 e3 36 00 00       	call   80107060 <copyuvm>
8010397d:	83 c4 10             	add    $0x10,%esp
80103980:	85 c0                	test   %eax,%eax
80103982:	89 47 04             	mov    %eax,0x4(%edi)
80103985:	0f 84 a1 00 00 00    	je     80103a2c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010398b:	8b 03                	mov    (%ebx),%eax
8010398d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103990:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103992:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103995:	89 c8                	mov    %ecx,%eax
80103997:	8b 79 18             	mov    0x18(%ecx),%edi
8010399a:	8b 73 18             	mov    0x18(%ebx),%esi
8010399d:	b9 13 00 00 00       	mov    $0x13,%ecx
801039a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039a4:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039a6:	8b 40 18             	mov    0x18(%eax),%eax
801039a9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801039b0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	74 13                	je     801039cb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	50                   	push   %eax
801039bc:	e8 1f d4 ff ff       	call   80100de0 <filedup>
801039c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039c4:	83 c4 10             	add    $0x10,%esp
801039c7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039cb:	83 c6 01             	add    $0x1,%esi
801039ce:	83 fe 10             	cmp    $0x10,%esi
801039d1:	75 dd                	jne    801039b0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039d3:	83 ec 0c             	sub    $0xc,%esp
801039d6:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039d9:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039dc:	e8 4f dc ff ff       	call   80101630 <idup>
801039e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039e4:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039e7:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039ea:	8d 47 6c             	lea    0x6c(%edi),%eax
801039ed:	6a 10                	push   $0x10
801039ef:	53                   	push   %ebx
801039f0:	50                   	push   %eax
801039f1:	e8 6a 0e 00 00       	call   80104860 <safestrcpy>

  pid = np->pid;
801039f6:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039f9:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103a00:	e8 5b 0b 00 00       	call   80104560 <acquire>

  np->state = RUNNABLE;
80103a05:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a0c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103a13:	e8 f8 0b 00 00       	call   80104610 <release>

  return pid;
80103a18:	83 c4 10             	add    $0x10,%esp
80103a1b:	89 d8                	mov    %ebx,%eax
}
80103a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a20:	5b                   	pop    %ebx
80103a21:	5e                   	pop    %esi
80103a22:	5f                   	pop    %edi
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a2a:	eb f1                	jmp    80103a1d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a2f:	83 ec 0c             	sub    $0xc,%esp
80103a32:	ff 77 08             	pushl  0x8(%edi)
80103a35:	e8 96 e8 ff ff       	call   801022d0 <kfree>
    np->kstack = 0;
80103a3a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a41:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a48:	83 c4 10             	add    $0x10,%esp
80103a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a50:	eb cb                	jmp    80103a1d <fork+0xdd>
80103a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <priority_boosting>:
struct proc *each_level_last_process[MLFQ_K];
#endif

void 
priority_boosting(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103a66:	68 40 2d 11 80       	push   $0x80112d40
80103a6b:	e8 f0 0a 00 00       	call   80104560 <acquire>
80103a70:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a73:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103a78:	90                   	nop
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103a80:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103a87:	00 00 00 
        p->tickleft=4;
80103a8a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103a91:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a94:	05 88 00 00 00       	add    $0x88,%eax
80103a99:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103a9e:	75 e0                	jne    80103a80 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
  for(int i=1;i<MLFQ_K;i++) each_level_last_process[i]=0;
	release(&ptable.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        p->queuelevel=0;
        p->tickleft=4;
  }
  for(int i=1;i<MLFQ_K;i++) each_level_last_process[i]=0;
80103aa3:	c7 05 24 2d 11 80 00 	movl   $0x0,0x80112d24
80103aaa:	00 00 00 
80103aad:	c7 05 28 2d 11 80 00 	movl   $0x0,0x80112d28
80103ab4:	00 00 00 
	release(&ptable.lock);
80103ab7:	68 40 2d 11 80       	push   $0x80112d40
80103abc:	e8 4f 0b 00 00       	call   80104610 <release>
}
80103ac1:	83 c4 10             	add    $0x10,%esp
80103ac4:	c9                   	leave  
80103ac5:	c3                   	ret    
80103ac6:	8d 76 00             	lea    0x0(%esi),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <scheduler>:
*/


void
scheduler(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103ad9:	e8 22 fc ff ff       	call   80103700 <mycpu>
  c->proc = 0;
80103ade:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ae5:	00 00 00 

void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
80103ae8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aeb:	83 c0 04             	add    $0x4,%eax
  c->proc = 0;

  #ifdef MLFQ_SCHED
  //struct proc *each_level_last_process[MLFQ_K];
  for(int i=0;i<MLFQ_K;i++) each_level_last_process[i]=0;
80103aee:	c7 05 20 2d 11 80 00 	movl   $0x0,0x80112d20
80103af5:	00 00 00 
80103af8:	c7 05 24 2d 11 80 00 	movl   $0x0,0x80112d24
80103aff:	00 00 00 
80103b02:	c7 05 28 2d 11 80 00 	movl   $0x0,0x80112d28
80103b09:	00 00 00 
80103b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103b0f:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b10:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b11:	83 ec 0c             	sub    $0xc,%esp
 
    #elif MLFQ_SCHED

    //초기값은 가장 높은 레벨의 큐(우선순위가 낮은)이다
    int selected_queue = MLFQ_K-1;
    struct proc * p_in_selected_queue = 0;
80103b14:	31 db                	xor    %ebx,%ebx
	
 
    #elif MLFQ_SCHED

    //초기값은 가장 높은 레벨의 큐(우선순위가 낮은)이다
    int selected_queue = MLFQ_K-1;
80103b16:	bf 02 00 00 00       	mov    $0x2,%edi

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b1b:	68 40 2d 11 80       	push   $0x80112d40
80103b20:	e8 3b 0a 00 00       	call   80104560 <acquire>
80103b25:	83 c4 10             	add    $0x10,%esp
    int selected_queue = MLFQ_K-1;
    struct proc * p_in_selected_queue = 0;
   
    
    //큐 레벨 측정
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b28:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103b2d:	eb 0d                	jmp    80103b3c <scheduler+0x6c>
80103b2f:	90                   	nop
80103b30:	05 88 00 00 00       	add    $0x88,%eax
80103b35:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103b3a:	74 24                	je     80103b60 <scheduler+0x90>
      if(p->state != RUNNABLE) continue;
80103b3c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b40:	75 ee                	jne    80103b30 <scheduler+0x60>
      if(selected_queue >= p->queuelevel) {
80103b42:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103b48:	39 f9                	cmp    %edi,%ecx
80103b4a:	7f e4                	jg     80103b30 <scheduler+0x60>
80103b4c:	89 c3                	mov    %eax,%ebx
    int selected_queue = MLFQ_K-1;
    struct proc * p_in_selected_queue = 0;
   
    
    //큐 레벨 측정
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b4e:	05 88 00 00 00       	add    $0x88,%eax
80103b53:	89 cf                	mov    %ecx,%edi
80103b55:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103b5a:	75 e0                	jne    80103b3c <scheduler+0x6c>
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
    }
	//cprintf("%d %d \n", selected_queue,p_in_selected_queue->pid);

    //기존에 큐에 스케줄링 했던게 없거나, 타임퀀텀 다 써서 찾아줘야 할 때
    if( each_level_last_process[selected_queue] == 0  || each_level_last_process[selected_queue]->queuelevel != selected_queue)
80103b60:	8b 34 bd 20 2d 11 80 	mov    -0x7feed2e0(,%edi,4),%esi
80103b67:	85 f6                	test   %esi,%esi
80103b69:	74 0c                	je     80103b77 <scheduler+0xa7>
80103b6b:	3b be 80 00 00 00    	cmp    0x80(%esi),%edi
80103b71:	0f 84 7c 00 00 00    	je     80103bf3 <scheduler+0x123>
80103b77:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103b7c:	eb 0e                	jmp    80103b8c <scheduler+0xbc>
80103b7e:	66 90                	xchg   %ax,%ax
    {
      //우선순위가 높은 거 찾기.
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b80:	05 88 00 00 00       	add    $0x88,%eax
80103b85:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103b8a:	74 34                	je     80103bc0 <scheduler+0xf0>
        //아까 고른 레벨의 큐에 들어있는 프로세스만 본다.
        if(p->state != RUNNABLE || p->queuelevel != selected_queue ) continue;
80103b8c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b90:	75 ee                	jne    80103b80 <scheduler+0xb0>
80103b92:	3b b8 80 00 00 00    	cmp    0x80(%eax),%edi
80103b98:	75 e6                	jne    80103b80 <scheduler+0xb0>
        if(p_in_selected_queue->priority < p->priority &&  p->tickleft >0){
80103b9a:	8b 50 7c             	mov    0x7c(%eax),%edx
80103b9d:	39 53 7c             	cmp    %edx,0x7c(%ebx)
80103ba0:	7d de                	jge    80103b80 <scheduler+0xb0>
80103ba2:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103ba8:	85 c9                	test   %ecx,%ecx
80103baa:	0f 4f d8             	cmovg  %eax,%ebx

    //기존에 큐에 스케줄링 했던게 없거나, 타임퀀텀 다 써서 찾아줘야 할 때
    if( each_level_last_process[selected_queue] == 0  || each_level_last_process[selected_queue]->queuelevel != selected_queue)
    {
      //우선순위가 높은 거 찾기.
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bad:	05 88 00 00 00       	add    $0x88,%eax
80103bb2:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103bb7:	75 d3                	jne    80103b8c <scheduler+0xbc>
80103bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p->state != RUNNABLE || p->queuelevel != selected_queue ) continue;
        if(p_in_selected_queue->priority < p->priority &&  p->tickleft >0){
          p_in_selected_queue = p;
        }
      }
	  cprintf("%d\n",p_in_selected_queue->pid);
80103bc0:	83 ec 08             	sub    $0x8,%esp
80103bc3:	ff 73 10             	pushl  0x10(%ebx)
80103bc6:	68 34 77 10 80       	push   $0x80107734
80103bcb:	e8 90 ca ff ff       	call   80100660 <cprintf>
80103bd0:	83 c4 10             	add    $0x10,%esp
    else if(each_level_last_process[selected_queue]->state == RUNNABLE)    {
      p_in_selected_queue = each_level_last_process[selected_queue];
    }

    //마지막 각 큐별 마지막 프로세스 기억
    if(p_in_selected_queue != 0 && p_in_selected_queue->state == RUNNABLE)
80103bd3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103bd7:	74 2a                	je     80103c03 <scheduler+0x133>
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    else
    {
      priority_boosting();
80103bd9:	e8 82 fe ff ff       	call   80103a60 <priority_boosting>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    #endif
    release(&ptable.lock);
80103bde:	83 ec 0c             	sub    $0xc,%esp
80103be1:	68 40 2d 11 80       	push   $0x80112d40
80103be6:	e8 25 0a 00 00       	call   80104610 <release>

  }
80103beb:	83 c4 10             	add    $0x10,%esp
80103bee:	e9 1d ff ff ff       	jmp    80103b10 <scheduler+0x40>
          p_in_selected_queue = p;
        }
      }
	  cprintf("%d\n",p_in_selected_queue->pid);
    }
    else if(each_level_last_process[selected_queue]->state == RUNNABLE)    {
80103bf3:	83 7e 0c 03          	cmpl   $0x3,0xc(%esi)
80103bf7:	74 0c                	je     80103c05 <scheduler+0x135>
      p_in_selected_queue = each_level_last_process[selected_queue];
    }

    //마지막 각 큐별 마지막 프로세스 기억
    if(p_in_selected_queue != 0 && p_in_selected_queue->state == RUNNABLE)
80103bf9:	85 db                	test   %ebx,%ebx
80103bfb:	74 dc                	je     80103bd9 <scheduler+0x109>
80103bfd:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c01:	75 d6                	jne    80103bd9 <scheduler+0x109>
80103c03:	89 de                	mov    %ebx,%esi
    {
      each_level_last_process[selected_queue] = p_in_selected_queue;

      //기존 스케줄링했던게 있을 때
      c->proc = p_in_selected_queue;
80103c05:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      switchuvm(p_in_selected_queue);
80103c08:	83 ec 0c             	sub    $0xc,%esp
    }

    //마지막 각 큐별 마지막 프로세스 기억
    if(p_in_selected_queue != 0 && p_in_selected_queue->state == RUNNABLE)
    {
      each_level_last_process[selected_queue] = p_in_selected_queue;
80103c0b:	89 34 bd 20 2d 11 80 	mov    %esi,-0x7feed2e0(,%edi,4)

      //기존 스케줄링했던게 있을 때
      c->proc = p_in_selected_queue;
80103c12:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
      switchuvm(p_in_selected_queue);
80103c18:	56                   	push   %esi
80103c19:	e8 72 2f 00 00       	call   80106b90 <switchuvm>
      p_in_selected_queue->state = RUNNING;      
80103c1e:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      swtch(&(c->scheduler), p_in_selected_queue->context);
80103c25:	58                   	pop    %eax
80103c26:	5a                   	pop    %edx
80103c27:	ff 76 1c             	pushl  0x1c(%esi)
80103c2a:	ff 75 e0             	pushl  -0x20(%ebp)
80103c2d:	e8 89 0c 00 00       	call   801048bb <swtch>
      switchkvm();
80103c32:	e8 39 2f 00 00       	call   80106b70 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103c37:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103c3e:	00 00 00 
80103c41:	83 c4 10             	add    $0x10,%esp
80103c44:	eb 98                	jmp    80103bde <scheduler+0x10e>
80103c46:	8d 76 00             	lea    0x0(%esi),%esi
80103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c50 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c55:	e8 26 08 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103c5a:	e8 a1 fa ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103c5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c65:	e8 56 08 00 00       	call   801044c0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103c6a:	83 ec 0c             	sub    $0xc,%esp
80103c6d:	68 40 2d 11 80       	push   $0x80112d40
80103c72:	e8 b9 08 00 00       	call   80104530 <holding>
80103c77:	83 c4 10             	add    $0x10,%esp
80103c7a:	85 c0                	test   %eax,%eax
80103c7c:	74 4f                	je     80103ccd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103c7e:	e8 7d fa ff ff       	call   80103700 <mycpu>
80103c83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c8a:	75 68                	jne    80103cf4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103c8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c90:	74 55                	je     80103ce7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c92:	9c                   	pushf  
80103c93:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103c94:	f6 c4 02             	test   $0x2,%ah
80103c97:	75 41                	jne    80103cda <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c99:	e8 62 fa ff ff       	call   80103700 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c9e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103ca1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ca7:	e8 54 fa ff ff       	call   80103700 <mycpu>
80103cac:	83 ec 08             	sub    $0x8,%esp
80103caf:	ff 70 04             	pushl  0x4(%eax)
80103cb2:	53                   	push   %ebx
80103cb3:	e8 03 0c 00 00       	call   801048bb <swtch>
  mycpu()->intena = intena;
80103cb8:	e8 43 fa ff ff       	call   80103700 <mycpu>
}
80103cbd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103cc0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc9:	5b                   	pop    %ebx
80103cca:	5e                   	pop    %esi
80103ccb:	5d                   	pop    %ebp
80103ccc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 d0 77 10 80       	push   $0x801077d0
80103cd5:	e8 96 c6 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 fc 77 10 80       	push   $0x801077fc
80103ce2:	e8 89 c6 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103ce7:	83 ec 0c             	sub    $0xc,%esp
80103cea:	68 ee 77 10 80       	push   $0x801077ee
80103cef:	e8 7c c6 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103cf4:	83 ec 0c             	sub    $0xc,%esp
80103cf7:	68 e2 77 10 80       	push   $0x801077e2
80103cfc:	e8 6f c6 ff ff       	call   80100370 <panic>
80103d01:	eb 0d                	jmp    80103d10 <exit>
80103d03:	90                   	nop
80103d04:	90                   	nop
80103d05:	90                   	nop
80103d06:	90                   	nop
80103d07:	90                   	nop
80103d08:	90                   	nop
80103d09:	90                   	nop
80103d0a:	90                   	nop
80103d0b:	90                   	nop
80103d0c:	90                   	nop
80103d0d:	90                   	nop
80103d0e:	90                   	nop
80103d0f:	90                   	nop

80103d10 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d19:	e8 62 07 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103d1e:	e8 dd f9 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103d23:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d29:	e8 92 07 00 00       	call   801044c0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103d2e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d34:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d37:	8d 7e 68             	lea    0x68(%esi),%edi
80103d3a:	0f 84 f1 00 00 00    	je     80103e31 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103d40:	8b 03                	mov    (%ebx),%eax
80103d42:	85 c0                	test   %eax,%eax
80103d44:	74 12                	je     80103d58 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d46:	83 ec 0c             	sub    $0xc,%esp
80103d49:	50                   	push   %eax
80103d4a:	e8 e1 d0 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103d5b:	39 df                	cmp    %ebx,%edi
80103d5d:	75 e1                	jne    80103d40 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103d5f:	e8 dc ed ff ff       	call   80102b40 <begin_op>
  iput(curproc->cwd);
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	ff 76 68             	pushl  0x68(%esi)
80103d6a:	e8 21 da ff ff       	call   80101790 <iput>
  end_op();
80103d6f:	e8 3c ee ff ff       	call   80102bb0 <end_op>
  curproc->cwd = 0;
80103d74:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103d7b:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103d82:	e8 d9 07 00 00       	call   80104560 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103d87:	8b 56 14             	mov    0x14(%esi),%edx
80103d8a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d8d:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103d92:	eb 10                	jmp    80103da4 <exit+0x94>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d98:	05 88 00 00 00       	add    $0x88,%eax
80103d9d:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103da2:	74 1e                	je     80103dc2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103da4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103da8:	75 ee                	jne    80103d98 <exit+0x88>
80103daa:	3b 50 20             	cmp    0x20(%eax),%edx
80103dad:	75 e9                	jne    80103d98 <exit+0x88>
      p->state = RUNNABLE;
80103daf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db6:	05 88 00 00 00       	add    $0x88,%eax
80103dbb:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103dc0:	75 e2                	jne    80103da4 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103dc2:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103dc8:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80103dcd:	eb 0f                	jmp    80103dde <exit+0xce>
80103dcf:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd0:	81 c2 88 00 00 00    	add    $0x88,%edx
80103dd6:	81 fa 74 4f 11 80    	cmp    $0x80114f74,%edx
80103ddc:	74 3a                	je     80103e18 <exit+0x108>
    if(p->parent == curproc){
80103dde:	39 72 14             	cmp    %esi,0x14(%edx)
80103de1:	75 ed                	jne    80103dd0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103de3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103de7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dea:	75 e4                	jne    80103dd0 <exit+0xc0>
80103dec:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103df1:	eb 11                	jmp    80103e04 <exit+0xf4>
80103df3:	90                   	nop
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df8:	05 88 00 00 00       	add    $0x88,%eax
80103dfd:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103e02:	74 cc                	je     80103dd0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e04:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e08:	75 ee                	jne    80103df8 <exit+0xe8>
80103e0a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e0d:	75 e9                	jne    80103df8 <exit+0xe8>
      p->state = RUNNABLE;
80103e0f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e16:	eb e0                	jmp    80103df8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103e18:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e1f:	e8 2c fe ff ff       	call   80103c50 <sched>
  panic("zombie exit");
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	68 1d 78 10 80       	push   $0x8010781d
80103e2c:	e8 3f c5 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103e31:	83 ec 0c             	sub    $0xc,%esp
80103e34:	68 10 78 10 80       	push   $0x80107810
80103e39:	e8 32 c5 ff ff       	call   80100370 <panic>
80103e3e:	66 90                	xchg   %ax,%ax

80103e40 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e47:	68 40 2d 11 80       	push   $0x80112d40
80103e4c:	e8 0f 07 00 00       	call   80104560 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e51:	e8 2a 06 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103e56:	e8 a5 f8 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103e5b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e61:	e8 5a 06 00 00       	call   801044c0 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
80103e66:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e6d:	e8 de fd ff ff       	call   80103c50 <sched>
  release(&ptable.lock);
80103e72:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e79:	e8 92 07 00 00       	call   80104610 <release>
}
80103e7e:	83 c4 10             	add    $0x10,%esp
80103e81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e84:	c9                   	leave  
80103e85:	c3                   	ret    
80103e86:	8d 76 00             	lea    0x0(%esi),%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <getlev>:

int             
getlev(void)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	53                   	push   %ebx
80103e94:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e97:	e8 e4 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103e9c:	e8 5f f8 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103ea1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea7:	e8 14 06 00 00       	call   801044c0 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
80103eac:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80103eb2:	83 c4 04             	add    $0x4,%esp
80103eb5:	5b                   	pop    %ebx
80103eb6:	5d                   	pop    %ebp
80103eb7:	c3                   	ret    
80103eb8:	90                   	nop
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <setpriority>:

int             
setpriority(int pid, int priority)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	8b 75 0c             	mov    0xc(%ebp),%esi
80103ecc:	8b 5d 08             	mov    0x8(%ebp),%ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ecf:	e8 ac 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103ed4:	e8 27 f8 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103ed9:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103edf:	e8 dc 05 00 00       	call   801044c0 <popcli>
int             
setpriority(int pid, int priority)
{
  struct proc *child;
  struct proc *parent = myproc();
  if(priority<0 || priority>10) return -2;
80103ee4:	83 fe 0a             	cmp    $0xa,%esi
80103ee7:	77 6c                	ja     80103f55 <setpriority+0x95>
  acquire(&ptable.lock);
80103ee9:	83 ec 0c             	sub    $0xc,%esp
80103eec:	68 40 2d 11 80       	push   $0x80112d40
80103ef1:	e8 6a 06 00 00       	call   80104560 <acquire>
80103ef6:	83 c4 10             	add    $0x10,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80103ef9:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80103efe:	eb 0c                	jmp    80103f0c <setpriority+0x4c>
80103f00:	05 88 00 00 00       	add    $0x88,%eax
80103f05:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80103f0a:	74 2c                	je     80103f38 <setpriority+0x78>
    if(child->pid == pid && child->parent == parent)
80103f0c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f0f:	75 ef                	jne    80103f00 <setpriority+0x40>
80103f11:	39 78 14             	cmp    %edi,0x14(%eax)
80103f14:	75 ea                	jne    80103f00 <setpriority+0x40>
    {
      child->priority=priority;
      release(&ptable.lock);
80103f16:	83 ec 0c             	sub    $0xc,%esp
  if(priority<0 || priority>10) return -2;
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
    if(child->pid == pid && child->parent == parent)
    {
      child->priority=priority;
80103f19:	89 70 7c             	mov    %esi,0x7c(%eax)
      release(&ptable.lock);
80103f1c:	68 40 2d 11 80       	push   $0x80112d40
80103f21:	e8 ea 06 00 00       	call   80104610 <release>
      return 0;
80103f26:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
80103f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
    if(child->pid == pid && child->parent == parent)
    {
      child->priority=priority;
      release(&ptable.lock);
      return 0;
80103f2c:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
80103f2e:	5b                   	pop    %ebx
80103f2f:	5e                   	pop    %esi
80103f30:	5f                   	pop    %edi
80103f31:	5d                   	pop    %ebp
80103f32:	c3                   	ret    
80103f33:	90                   	nop
80103f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      child->priority=priority;
      release(&ptable.lock);
      return 0;
    }
	}
  release(&ptable.lock);
80103f38:	83 ec 0c             	sub    $0xc,%esp
80103f3b:	68 40 2d 11 80       	push   $0x80112d40
80103f40:	e8 cb 06 00 00       	call   80104610 <release>
  return -1;
80103f45:	83 c4 10             	add    $0x10,%esp
80103f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f50:	5b                   	pop    %ebx
80103f51:	5e                   	pop    %esi
80103f52:	5f                   	pop    %edi
80103f53:	5d                   	pop    %ebp
80103f54:	c3                   	ret    
int             
setpriority(int pid, int priority)
{
  struct proc *child;
  struct proc *parent = myproc();
  if(priority<0 || priority>10) return -2;
80103f55:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103f5a:	eb f1                	jmp    80103f4d <setpriority+0x8d>
80103f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f60 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	57                   	push   %edi
80103f64:	56                   	push   %esi
80103f65:	53                   	push   %ebx
80103f66:	83 ec 0c             	sub    $0xc,%esp
80103f69:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f6f:	e8 0c 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f74:	e8 87 f7 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103f79:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f7f:	e8 3c 05 00 00       	call   801044c0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103f84:	85 db                	test   %ebx,%ebx
80103f86:	0f 84 87 00 00 00    	je     80104013 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103f8c:	85 f6                	test   %esi,%esi
80103f8e:	74 76                	je     80104006 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f90:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
80103f96:	74 50                	je     80103fe8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f98:	83 ec 0c             	sub    $0xc,%esp
80103f9b:	68 40 2d 11 80       	push   $0x80112d40
80103fa0:	e8 bb 05 00 00       	call   80104560 <acquire>
    release(lk);
80103fa5:	89 34 24             	mov    %esi,(%esp)
80103fa8:	e8 63 06 00 00       	call   80104610 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103fad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fb0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fb7:	e8 94 fc ff ff       	call   80103c50 <sched>
  // Tidy up.
  p->chan = 0;
80103fbc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103fc3:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103fca:	e8 41 06 00 00       	call   80104610 <release>
    acquire(lk);
80103fcf:	89 75 08             	mov    %esi,0x8(%ebp)
80103fd2:	83 c4 10             	add    $0x10,%esp
  }
}
80103fd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fd8:	5b                   	pop    %ebx
80103fd9:	5e                   	pop    %esi
80103fda:	5f                   	pop    %edi
80103fdb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103fdc:	e9 7f 05 00 00       	jmp    80104560 <acquire>
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103fe8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103feb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ff2:	e8 59 fc ff ff       	call   80103c50 <sched>
  // Tidy up.
  p->chan = 0;
80103ff7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104001:	5b                   	pop    %ebx
80104002:	5e                   	pop    %esi
80104003:	5f                   	pop    %edi
80104004:	5d                   	pop    %ebp
80104005:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	68 2f 78 10 80       	push   $0x8010782f
8010400e:	e8 5d c3 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104013:	83 ec 0c             	sub    $0xc,%esp
80104016:	68 29 78 10 80       	push   $0x80107829
8010401b:	e8 50 c3 ff ff       	call   80100370 <panic>

80104020 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104025:	e8 56 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010402a:	e8 d1 f6 ff ff       	call   80103700 <mycpu>
  p = c->proc;
8010402f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104035:	e8 86 04 00 00       	call   801044c0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 40 2d 11 80       	push   $0x80112d40
80104042:	e8 19 05 00 00       	call   80104560 <acquire>
80104047:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010404a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104051:	eb 13                	jmp    80104066 <wait+0x46>
80104053:	90                   	nop
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104058:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010405e:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80104064:	74 22                	je     80104088 <wait+0x68>
      if(p->parent != curproc)
80104066:	39 73 14             	cmp    %esi,0x14(%ebx)
80104069:	75 ed                	jne    80104058 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010406b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010406f:	74 35                	je     801040a6 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104071:	81 c3 88 00 00 00    	add    $0x88,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104077:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407c:	81 fb 74 4f 11 80    	cmp    $0x80114f74,%ebx
80104082:	75 e2                	jne    80104066 <wait+0x46>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104088:	85 c0                	test   %eax,%eax
8010408a:	74 70                	je     801040fc <wait+0xdc>
8010408c:	8b 46 24             	mov    0x24(%esi),%eax
8010408f:	85 c0                	test   %eax,%eax
80104091:	75 69                	jne    801040fc <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104093:	83 ec 08             	sub    $0x8,%esp
80104096:	68 40 2d 11 80       	push   $0x80112d40
8010409b:	56                   	push   %esi
8010409c:	e8 bf fe ff ff       	call   80103f60 <sleep>
  }
801040a1:	83 c4 10             	add    $0x10,%esp
801040a4:	eb a4                	jmp    8010404a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801040a6:	83 ec 0c             	sub    $0xc,%esp
801040a9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801040ac:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040af:	e8 1c e2 ff ff       	call   801022d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801040b4:	5a                   	pop    %edx
801040b5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801040b8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040bf:	e8 4c 2e 00 00       	call   80106f10 <freevm>
        p->pid = 0;
801040c4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040cb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040d2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040d6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040dd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040e4:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801040eb:	e8 20 05 00 00       	call   80104610 <release>
        return pid;
801040f0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
801040f6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040f8:	5b                   	pop    %ebx
801040f9:	5e                   	pop    %esi
801040fa:	5d                   	pop    %ebp
801040fb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801040fc:	83 ec 0c             	sub    $0xc,%esp
801040ff:	68 40 2d 11 80       	push   $0x80112d40
80104104:	e8 07 05 00 00       	call   80104610 <release>
      return -1;
80104109:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010410c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010410f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104114:	5b                   	pop    %ebx
80104115:	5e                   	pop    %esi
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 10             	sub    $0x10,%esp
80104127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010412a:	68 40 2d 11 80       	push   $0x80112d40
8010412f:	e8 2c 04 00 00       	call   80104560 <acquire>
80104134:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104137:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010413c:	eb 0e                	jmp    8010414c <wakeup+0x2c>
8010413e:	66 90                	xchg   %ax,%ax
80104140:	05 88 00 00 00       	add    $0x88,%eax
80104145:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
8010414a:	74 1e                	je     8010416a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010414c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104150:	75 ee                	jne    80104140 <wakeup+0x20>
80104152:	3b 58 20             	cmp    0x20(%eax),%ebx
80104155:	75 e9                	jne    80104140 <wakeup+0x20>
      p->state = RUNNABLE;
80104157:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415e:	05 88 00 00 00       	add    $0x88,%eax
80104163:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
80104168:	75 e2                	jne    8010414c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010416a:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80104171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104174:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104175:	e9 96 04 00 00       	jmp    80104610 <release>
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104180 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010418a:	68 40 2d 11 80       	push   $0x80112d40
8010418f:	e8 cc 03 00 00       	call   80104560 <acquire>
80104194:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104197:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010419c:	eb 0e                	jmp    801041ac <kill+0x2c>
8010419e:	66 90                	xchg   %ax,%ax
801041a0:	05 88 00 00 00       	add    $0x88,%eax
801041a5:	3d 74 4f 11 80       	cmp    $0x80114f74,%eax
801041aa:	74 3c                	je     801041e8 <kill+0x68>
    if(p->pid == pid){
801041ac:	39 58 10             	cmp    %ebx,0x10(%eax)
801041af:	75 ef                	jne    801041a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801041b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041bc:	74 1a                	je     801041d8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801041be:	83 ec 0c             	sub    $0xc,%esp
801041c1:	68 40 2d 11 80       	push   $0x80112d40
801041c6:	e8 45 04 00 00       	call   80104610 <release>
      return 0;
801041cb:	83 c4 10             	add    $0x10,%esp
801041ce:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801041d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d3:	c9                   	leave  
801041d4:	c3                   	ret    
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801041d8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041df:	eb dd                	jmp    801041be <kill+0x3e>
801041e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	68 40 2d 11 80       	push   $0x80112d40
801041f0:	e8 1b 04 00 00       	call   80104610 <release>
  return -1;
801041f5:	83 c4 10             	add    $0x10,%esp
801041f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104200:	c9                   	leave  
80104201:	c3                   	ret    
80104202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104219:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
8010421e:	83 ec 3c             	sub    $0x3c,%esp
80104221:	eb 27                	jmp    8010424a <procdump+0x3a>
80104223:	90                   	nop
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 c3 7b 10 80       	push   $0x80107bc3
80104230:	e8 2b c4 ff ff       	call   80100660 <cprintf>
80104235:	83 c4 10             	add    $0x10,%esp
80104238:	81 c3 88 00 00 00    	add    $0x88,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423e:	81 fb e0 4f 11 80    	cmp    $0x80114fe0,%ebx
80104244:	0f 84 7e 00 00 00    	je     801042c8 <procdump+0xb8>
    if(p->state == UNUSED)
8010424a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010424d:	85 c0                	test   %eax,%eax
8010424f:	74 e7                	je     80104238 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104251:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104254:	ba 40 78 10 80       	mov    $0x80107840,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104259:	77 11                	ja     8010426c <procdump+0x5c>
8010425b:	8b 14 85 a0 78 10 80 	mov    -0x7fef8760(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104262:	b8 40 78 10 80       	mov    $0x80107840,%eax
80104267:	85 d2                	test   %edx,%edx
80104269:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010426c:	53                   	push   %ebx
8010426d:	52                   	push   %edx
8010426e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104271:	68 44 78 10 80       	push   $0x80107844
80104276:	e8 e5 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010427b:	83 c4 10             	add    $0x10,%esp
8010427e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104282:	75 a4                	jne    80104228 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104284:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104287:	83 ec 08             	sub    $0x8,%esp
8010428a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010428d:	50                   	push   %eax
8010428e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104291:	8b 40 0c             	mov    0xc(%eax),%eax
80104294:	83 c0 08             	add    $0x8,%eax
80104297:	50                   	push   %eax
80104298:	e8 83 01 00 00       	call   80104420 <getcallerpcs>
8010429d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042a0:	8b 17                	mov    (%edi),%edx
801042a2:	85 d2                	test   %edx,%edx
801042a4:	74 82                	je     80104228 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042a6:	83 ec 08             	sub    $0x8,%esp
801042a9:	83 c7 04             	add    $0x4,%edi
801042ac:	52                   	push   %edx
801042ad:	68 81 72 10 80       	push   $0x80107281
801042b2:	e8 a9 c3 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	39 f7                	cmp    %esi,%edi
801042bc:	75 e2                	jne    801042a0 <procdump+0x90>
801042be:	e9 65 ff ff ff       	jmp    80104228 <procdump+0x18>
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801042c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042cb:	5b                   	pop    %ebx
801042cc:	5e                   	pop    %esi
801042cd:	5f                   	pop    %edi
801042ce:	5d                   	pop    %ebp
801042cf:	c3                   	ret    

801042d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042da:	68 b8 78 10 80       	push   $0x801078b8
801042df:	8d 43 04             	lea    0x4(%ebx),%eax
801042e2:	50                   	push   %eax
801042e3:	e8 18 01 00 00       	call   80104400 <initlock>
  lk->name = name;
801042e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042f1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801042f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801042fb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801042fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104301:	c9                   	leave  
80104302:	c3                   	ret    
80104303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	8d 73 04             	lea    0x4(%ebx),%esi
8010431e:	56                   	push   %esi
8010431f:	e8 3c 02 00 00       	call   80104560 <acquire>
  while (lk->locked) {
80104324:	8b 13                	mov    (%ebx),%edx
80104326:	83 c4 10             	add    $0x10,%esp
80104329:	85 d2                	test   %edx,%edx
8010432b:	74 16                	je     80104343 <acquiresleep+0x33>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	e8 26 fc ff ff       	call   80103f60 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010433a:	8b 03                	mov    (%ebx),%eax
8010433c:	83 c4 10             	add    $0x10,%esp
8010433f:	85 c0                	test   %eax,%eax
80104341:	75 ed                	jne    80104330 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104343:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104349:	e8 52 f4 ff ff       	call   801037a0 <myproc>
8010434e:	8b 40 10             	mov    0x10(%eax),%eax
80104351:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104354:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104357:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010435a:	5b                   	pop    %ebx
8010435b:	5e                   	pop    %esi
8010435c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010435d:	e9 ae 02 00 00       	jmp    80104610 <release>
80104362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	8d 73 04             	lea    0x4(%ebx),%esi
8010437e:	56                   	push   %esi
8010437f:	e8 dc 01 00 00       	call   80104560 <acquire>
  lk->locked = 0;
80104384:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010438a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104391:	89 1c 24             	mov    %ebx,(%esp)
80104394:	e8 87 fd ff ff       	call   80104120 <wakeup>
  release(&lk->lk);
80104399:	89 75 08             	mov    %esi,0x8(%ebp)
8010439c:	83 c4 10             	add    $0x10,%esp
}
8010439f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a2:	5b                   	pop    %ebx
801043a3:	5e                   	pop    %esi
801043a4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801043a5:	e9 66 02 00 00       	jmp    80104610 <release>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	53                   	push   %ebx
801043b6:	31 ff                	xor    %edi,%edi
801043b8:	83 ec 18             	sub    $0x18,%esp
801043bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043be:	8d 73 04             	lea    0x4(%ebx),%esi
801043c1:	56                   	push   %esi
801043c2:	e8 99 01 00 00       	call   80104560 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043c7:	8b 03                	mov    (%ebx),%eax
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	85 c0                	test   %eax,%eax
801043ce:	74 13                	je     801043e3 <holdingsleep+0x33>
801043d0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043d3:	e8 c8 f3 ff ff       	call   801037a0 <myproc>
801043d8:	39 58 10             	cmp    %ebx,0x10(%eax)
801043db:	0f 94 c0             	sete   %al
801043de:	0f b6 c0             	movzbl %al,%eax
801043e1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	56                   	push   %esi
801043e7:	e8 24 02 00 00       	call   80104610 <release>
  return r;
}
801043ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ef:	89 f8                	mov    %edi,%eax
801043f1:	5b                   	pop    %ebx
801043f2:	5e                   	pop    %esi
801043f3:	5f                   	pop    %edi
801043f4:	5d                   	pop    %ebp
801043f5:	c3                   	ret    
801043f6:	66 90                	xchg   %ax,%ax
801043f8:	66 90                	xchg   %ax,%ax
801043fa:	66 90                	xchg   %ax,%ax
801043fc:	66 90                	xchg   %ax,%ax
801043fe:	66 90                	xchg   %ax,%ax

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104406:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010440f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104419:	5d                   	pop    %ebp
8010441a:	c3                   	ret    
8010441b:	90                   	nop
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010442a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010442d:	31 c0                	xor    %eax,%eax
8010442f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104430:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104436:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010443c:	77 1a                	ja     80104458 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010443e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104441:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104444:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104447:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104449:	83 f8 0a             	cmp    $0xa,%eax
8010444c:	75 e2                	jne    80104430 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010444e:	5b                   	pop    %ebx
8010444f:	5d                   	pop    %ebp
80104450:	c3                   	ret    
80104451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104458:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010445f:	83 c0 01             	add    $0x1,%eax
80104462:	83 f8 0a             	cmp    $0xa,%eax
80104465:	74 e7                	je     8010444e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104467:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010446e:	83 c0 01             	add    $0x1,%eax
80104471:	83 f8 0a             	cmp    $0xa,%eax
80104474:	75 e2                	jne    80104458 <getcallerpcs+0x38>
80104476:	eb d6                	jmp    8010444e <getcallerpcs+0x2e>
80104478:	90                   	nop
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	9c                   	pushf  
80104488:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104489:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448a:	e8 71 f2 ff ff       	call   80103700 <mycpu>
8010448f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	75 11                	jne    801044aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104499:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010449f:	e8 5c f2 ff ff       	call   80103700 <mycpu>
801044a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801044aa:	e8 51 f2 ff ff       	call   80103700 <mycpu>
801044af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044b6:	83 c4 04             	add    $0x4,%esp
801044b9:	5b                   	pop    %ebx
801044ba:	5d                   	pop    %ebp
801044bb:	c3                   	ret    
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <popcli>:

void
popcli(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044c6:	9c                   	pushf  
801044c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044c8:	f6 c4 02             	test   $0x2,%ah
801044cb:	75 52                	jne    8010451f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044cd:	e8 2e f2 ff ff       	call   80103700 <mycpu>
801044d2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801044d8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801044db:	85 d2                	test   %edx,%edx
801044dd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801044e3:	78 2d                	js     80104512 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044e5:	e8 16 f2 ff ff       	call   80103700 <mycpu>
801044ea:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044f0:	85 d2                	test   %edx,%edx
801044f2:	74 0c                	je     80104500 <popcli+0x40>
    sti();
}
801044f4:	c9                   	leave  
801044f5:	c3                   	ret    
801044f6:	8d 76 00             	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104500:	e8 fb f1 ff ff       	call   80103700 <mycpu>
80104505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010450b:	85 c0                	test   %eax,%eax
8010450d:	74 e5                	je     801044f4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010450f:	fb                   	sti    
    sti();
}
80104510:	c9                   	leave  
80104511:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	68 da 78 10 80       	push   $0x801078da
8010451a:	e8 51 be ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	68 c3 78 10 80       	push   $0x801078c3
80104527:	e8 44 be ff ff       	call   80100370 <panic>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 75 08             	mov    0x8(%ebp),%esi
80104538:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010453a:	e8 41 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010453f:	8b 06                	mov    (%esi),%eax
80104541:	85 c0                	test   %eax,%eax
80104543:	74 10                	je     80104555 <holding+0x25>
80104545:	8b 5e 08             	mov    0x8(%esi),%ebx
80104548:	e8 b3 f1 ff ff       	call   80103700 <mycpu>
8010454d:	39 c3                	cmp    %eax,%ebx
8010454f:	0f 94 c3             	sete   %bl
80104552:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104555:	e8 66 ff ff ff       	call   801044c0 <popcli>
  return r;
}
8010455a:	89 d8                	mov    %ebx,%eax
8010455c:	5b                   	pop    %ebx
8010455d:	5e                   	pop    %esi
8010455e:	5d                   	pop    %ebp
8010455f:	c3                   	ret    

80104560 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104567:	e8 14 ff ff ff       	call   80104480 <pushcli>
  if(holding(lk))
8010456c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010456f:	83 ec 0c             	sub    $0xc,%esp
80104572:	53                   	push   %ebx
80104573:	e8 b8 ff ff ff       	call   80104530 <holding>
80104578:	83 c4 10             	add    $0x10,%esp
8010457b:	85 c0                	test   %eax,%eax
8010457d:	0f 85 7d 00 00 00    	jne    80104600 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104583:	ba 01 00 00 00       	mov    $0x1,%edx
80104588:	eb 09                	jmp    80104593 <acquire+0x33>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104590:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104593:	89 d0                	mov    %edx,%eax
80104595:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104598:	85 c0                	test   %eax,%eax
8010459a:	75 f4                	jne    80104590 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010459c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801045a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045a4:	e8 57 f1 ff ff       	call   80103700 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801045a9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801045ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801045ae:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045b1:	31 c0                	xor    %eax,%eax
801045b3:	90                   	nop
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045c4:	77 1a                	ja     801045e0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801045c9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045cc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801045cf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045d1:	83 f8 0a             	cmp    $0xa,%eax
801045d4:	75 e2                	jne    801045b8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801045d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d9:	c9                   	leave  
801045da:	c3                   	ret    
801045db:	90                   	nop
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801045e0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801045e7:	83 c0 01             	add    $0x1,%eax
801045ea:	83 f8 0a             	cmp    $0xa,%eax
801045ed:	74 e7                	je     801045d6 <acquire+0x76>
    pcs[i] = 0;
801045ef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801045f6:	83 c0 01             	add    $0x1,%eax
801045f9:	83 f8 0a             	cmp    $0xa,%eax
801045fc:	75 e2                	jne    801045e0 <acquire+0x80>
801045fe:	eb d6                	jmp    801045d6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	68 e1 78 10 80       	push   $0x801078e1
80104608:	e8 63 bd ff ff       	call   80100370 <panic>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi

80104610 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 10             	sub    $0x10,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010461a:	53                   	push   %ebx
8010461b:	e8 10 ff ff ff       	call   80104530 <holding>
80104620:	83 c4 10             	add    $0x10,%esp
80104623:	85 c0                	test   %eax,%eax
80104625:	74 22                	je     80104649 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104627:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010462e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104635:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010463a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104643:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104644:	e9 77 fe ff ff       	jmp    801044c0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104649:	83 ec 0c             	sub    $0xc,%esp
8010464c:	68 e9 78 10 80       	push   $0x801078e9
80104651:	e8 1a bd ff ff       	call   80100370 <panic>
80104656:	66 90                	xchg   %ax,%ax
80104658:	66 90                	xchg   %ax,%ax
8010465a:	66 90                	xchg   %ax,%ax
8010465c:	66 90                	xchg   %ax,%ax
8010465e:	66 90                	xchg   %ax,%ax

80104660 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	53                   	push   %ebx
80104665:	8b 55 08             	mov    0x8(%ebp),%edx
80104668:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010466b:	f6 c2 03             	test   $0x3,%dl
8010466e:	75 05                	jne    80104675 <memset+0x15>
80104670:	f6 c1 03             	test   $0x3,%cl
80104673:	74 13                	je     80104688 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104675:	89 d7                	mov    %edx,%edi
80104677:	8b 45 0c             	mov    0xc(%ebp),%eax
8010467a:	fc                   	cld    
8010467b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010467d:	5b                   	pop    %ebx
8010467e:	89 d0                	mov    %edx,%eax
80104680:	5f                   	pop    %edi
80104681:	5d                   	pop    %ebp
80104682:	c3                   	ret    
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104688:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010468c:	c1 e9 02             	shr    $0x2,%ecx
8010468f:	89 fb                	mov    %edi,%ebx
80104691:	89 f8                	mov    %edi,%eax
80104693:	c1 e3 18             	shl    $0x18,%ebx
80104696:	c1 e0 10             	shl    $0x10,%eax
80104699:	09 d8                	or     %ebx,%eax
8010469b:	09 f8                	or     %edi,%eax
8010469d:	c1 e7 08             	shl    $0x8,%edi
801046a0:	09 f8                	or     %edi,%eax
801046a2:	89 d7                	mov    %edx,%edi
801046a4:	fc                   	cld    
801046a5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046a7:	5b                   	pop    %ebx
801046a8:	89 d0                	mov    %edx,%eax
801046aa:	5f                   	pop    %edi
801046ab:	5d                   	pop    %ebp
801046ac:	c3                   	ret    
801046ad:	8d 76 00             	lea    0x0(%esi),%esi

801046b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	8b 45 10             	mov    0x10(%ebp),%eax
801046b8:	53                   	push   %ebx
801046b9:	8b 75 0c             	mov    0xc(%ebp),%esi
801046bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046bf:	85 c0                	test   %eax,%eax
801046c1:	74 29                	je     801046ec <memcmp+0x3c>
    if(*s1 != *s2)
801046c3:	0f b6 13             	movzbl (%ebx),%edx
801046c6:	0f b6 0e             	movzbl (%esi),%ecx
801046c9:	38 d1                	cmp    %dl,%cl
801046cb:	75 2b                	jne    801046f8 <memcmp+0x48>
801046cd:	8d 78 ff             	lea    -0x1(%eax),%edi
801046d0:	31 c0                	xor    %eax,%eax
801046d2:	eb 14                	jmp    801046e8 <memcmp+0x38>
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801046dd:	83 c0 01             	add    $0x1,%eax
801046e0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801046e4:	38 ca                	cmp    %cl,%dl
801046e6:	75 10                	jne    801046f8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046e8:	39 f8                	cmp    %edi,%eax
801046ea:	75 ec                	jne    801046d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801046ec:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801046ed:	31 c0                	xor    %eax,%eax
}
801046ef:	5e                   	pop    %esi
801046f0:	5f                   	pop    %edi
801046f1:	5d                   	pop    %ebp
801046f2:	c3                   	ret    
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801046f8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801046fb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801046fc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801046fe:	5e                   	pop    %esi
801046ff:	5f                   	pop    %edi
80104700:	5d                   	pop    %ebp
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 45 08             	mov    0x8(%ebp),%eax
80104718:	8b 75 0c             	mov    0xc(%ebp),%esi
8010471b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010471e:	39 c6                	cmp    %eax,%esi
80104720:	73 2e                	jae    80104750 <memmove+0x40>
80104722:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104725:	39 c8                	cmp    %ecx,%eax
80104727:	73 27                	jae    80104750 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104729:	85 db                	test   %ebx,%ebx
8010472b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010472e:	74 17                	je     80104747 <memmove+0x37>
      *--d = *--s;
80104730:	29 d9                	sub    %ebx,%ecx
80104732:	89 cb                	mov    %ecx,%ebx
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104738:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010473c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010473f:	83 ea 01             	sub    $0x1,%edx
80104742:	83 fa ff             	cmp    $0xffffffff,%edx
80104745:	75 f1                	jne    80104738 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104747:	5b                   	pop    %ebx
80104748:	5e                   	pop    %esi
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104750:	31 d2                	xor    %edx,%edx
80104752:	85 db                	test   %ebx,%ebx
80104754:	74 f1                	je     80104747 <memmove+0x37>
80104756:	8d 76 00             	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104760:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104764:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104767:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010476a:	39 d3                	cmp    %edx,%ebx
8010476c:	75 f2                	jne    80104760 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010476e:	5b                   	pop    %ebx
8010476f:	5e                   	pop    %esi
80104770:	5d                   	pop    %ebp
80104771:	c3                   	ret    
80104772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104783:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104784:	eb 8a                	jmp    80104710 <memmove>
80104786:	8d 76 00             	lea    0x0(%esi),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104798:	53                   	push   %ebx
80104799:	8b 7d 08             	mov    0x8(%ebp),%edi
8010479c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010479f:	85 c9                	test   %ecx,%ecx
801047a1:	74 37                	je     801047da <strncmp+0x4a>
801047a3:	0f b6 17             	movzbl (%edi),%edx
801047a6:	0f b6 1e             	movzbl (%esi),%ebx
801047a9:	84 d2                	test   %dl,%dl
801047ab:	74 3f                	je     801047ec <strncmp+0x5c>
801047ad:	38 d3                	cmp    %dl,%bl
801047af:	75 3b                	jne    801047ec <strncmp+0x5c>
801047b1:	8d 47 01             	lea    0x1(%edi),%eax
801047b4:	01 cf                	add    %ecx,%edi
801047b6:	eb 1b                	jmp    801047d3 <strncmp+0x43>
801047b8:	90                   	nop
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c0:	0f b6 10             	movzbl (%eax),%edx
801047c3:	84 d2                	test   %dl,%dl
801047c5:	74 21                	je     801047e8 <strncmp+0x58>
801047c7:	0f b6 19             	movzbl (%ecx),%ebx
801047ca:	83 c0 01             	add    $0x1,%eax
801047cd:	89 ce                	mov    %ecx,%esi
801047cf:	38 da                	cmp    %bl,%dl
801047d1:	75 19                	jne    801047ec <strncmp+0x5c>
801047d3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801047d5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801047d8:	75 e6                	jne    801047c0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047da:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801047db:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801047dd:	5e                   	pop    %esi
801047de:	5f                   	pop    %edi
801047df:	5d                   	pop    %ebp
801047e0:	c3                   	ret    
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047ec:	0f b6 c2             	movzbl %dl,%eax
801047ef:	29 d8                	sub    %ebx,%eax
}
801047f1:	5b                   	pop    %ebx
801047f2:	5e                   	pop    %esi
801047f3:	5f                   	pop    %edi
801047f4:	5d                   	pop    %ebp
801047f5:	c3                   	ret    
801047f6:	8d 76 00             	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 45 08             	mov    0x8(%ebp),%eax
80104808:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010480b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010480e:	89 c2                	mov    %eax,%edx
80104810:	eb 19                	jmp    8010482b <strncpy+0x2b>
80104812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104818:	83 c3 01             	add    $0x1,%ebx
8010481b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010481f:	83 c2 01             	add    $0x1,%edx
80104822:	84 c9                	test   %cl,%cl
80104824:	88 4a ff             	mov    %cl,-0x1(%edx)
80104827:	74 09                	je     80104832 <strncpy+0x32>
80104829:	89 f1                	mov    %esi,%ecx
8010482b:	85 c9                	test   %ecx,%ecx
8010482d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104830:	7f e6                	jg     80104818 <strncpy+0x18>
    ;
  while(n-- > 0)
80104832:	31 c9                	xor    %ecx,%ecx
80104834:	85 f6                	test   %esi,%esi
80104836:	7e 17                	jle    8010484f <strncpy+0x4f>
80104838:	90                   	nop
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104840:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104844:	89 f3                	mov    %esi,%ebx
80104846:	83 c1 01             	add    $0x1,%ecx
80104849:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010484b:	85 db                	test   %ebx,%ebx
8010484d:	7f f1                	jg     80104840 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010484f:	5b                   	pop    %ebx
80104850:	5e                   	pop    %esi
80104851:	5d                   	pop    %ebp
80104852:	c3                   	ret    
80104853:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104868:	8b 45 08             	mov    0x8(%ebp),%eax
8010486b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010486e:	85 c9                	test   %ecx,%ecx
80104870:	7e 26                	jle    80104898 <safestrcpy+0x38>
80104872:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104876:	89 c1                	mov    %eax,%ecx
80104878:	eb 17                	jmp    80104891 <safestrcpy+0x31>
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104880:	83 c2 01             	add    $0x1,%edx
80104883:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104887:	83 c1 01             	add    $0x1,%ecx
8010488a:	84 db                	test   %bl,%bl
8010488c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010488f:	74 04                	je     80104895 <safestrcpy+0x35>
80104891:	39 f2                	cmp    %esi,%edx
80104893:	75 eb                	jne    80104880 <safestrcpy+0x20>
    ;
  *s = 0;
80104895:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104898:	5b                   	pop    %ebx
80104899:	5e                   	pop    %esi
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <strlen>:

int
strlen(const char *s)
{
801048a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048a1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801048a3:	89 e5                	mov    %esp,%ebp
801048a5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801048a8:	80 3a 00             	cmpb   $0x0,(%edx)
801048ab:	74 0c                	je     801048b9 <strlen+0x19>
801048ad:	8d 76 00             	lea    0x0(%esi),%esi
801048b0:	83 c0 01             	add    $0x1,%eax
801048b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048b7:	75 f7                	jne    801048b0 <strlen+0x10>
    ;
  return n;
}
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    

801048bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048c3:	55                   	push   %ebp
  pushl %ebx
801048c4:	53                   	push   %ebx
  pushl %esi
801048c5:	56                   	push   %esi
  pushl %edi
801048c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048cb:	5f                   	pop    %edi
  popl %esi
801048cc:	5e                   	pop    %esi
  popl %ebx
801048cd:	5b                   	pop    %ebx
  popl %ebp
801048ce:	5d                   	pop    %ebp
  ret
801048cf:	c3                   	ret    

801048d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
801048d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048da:	e8 c1 ee ff ff       	call   801037a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048df:	8b 00                	mov    (%eax),%eax
801048e1:	39 d8                	cmp    %ebx,%eax
801048e3:	76 1b                	jbe    80104900 <fetchint+0x30>
801048e5:	8d 53 04             	lea    0x4(%ebx),%edx
801048e8:	39 d0                	cmp    %edx,%eax
801048ea:	72 14                	jb     80104900 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ef:	8b 13                	mov    (%ebx),%edx
801048f1:	89 10                	mov    %edx,(%eax)
  return 0;
801048f3:	31 c0                	xor    %eax,%eax
}
801048f5:	83 c4 04             	add    $0x4,%esp
801048f8:	5b                   	pop    %ebx
801048f9:	5d                   	pop    %ebp
801048fa:	c3                   	ret    
801048fb:	90                   	nop
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104905:	eb ee                	jmp    801048f5 <fetchint+0x25>
80104907:	89 f6                	mov    %esi,%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 04             	sub    $0x4,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010491a:	e8 81 ee ff ff       	call   801037a0 <myproc>

  if(addr >= curproc->sz)
8010491f:	39 18                	cmp    %ebx,(%eax)
80104921:	76 29                	jbe    8010494c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104926:	89 da                	mov    %ebx,%edx
80104928:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010492a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010492c:	39 c3                	cmp    %eax,%ebx
8010492e:	73 1c                	jae    8010494c <fetchstr+0x3c>
    if(*s == 0)
80104930:	80 3b 00             	cmpb   $0x0,(%ebx)
80104933:	75 10                	jne    80104945 <fetchstr+0x35>
80104935:	eb 29                	jmp    80104960 <fetchstr+0x50>
80104937:	89 f6                	mov    %esi,%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104940:	80 3a 00             	cmpb   $0x0,(%edx)
80104943:	74 1b                	je     80104960 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104945:	83 c2 01             	add    $0x1,%edx
80104948:	39 d0                	cmp    %edx,%eax
8010494a:	77 f4                	ja     80104940 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010494c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010494f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104954:	5b                   	pop    %ebx
80104955:	5d                   	pop    %ebp
80104956:	c3                   	ret    
80104957:	89 f6                	mov    %esi,%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104960:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104963:	89 d0                	mov    %edx,%eax
80104965:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104967:	5b                   	pop    %ebx
80104968:	5d                   	pop    %ebp
80104969:	c3                   	ret    
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104975:	e8 26 ee ff ff       	call   801037a0 <myproc>
8010497a:	8b 40 18             	mov    0x18(%eax),%eax
8010497d:	8b 55 08             	mov    0x8(%ebp),%edx
80104980:	8b 40 44             	mov    0x44(%eax),%eax
80104983:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104986:	e8 15 ee ff ff       	call   801037a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010498b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010498d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104990:	39 c6                	cmp    %eax,%esi
80104992:	73 1c                	jae    801049b0 <argint+0x40>
80104994:	8d 53 08             	lea    0x8(%ebx),%edx
80104997:	39 d0                	cmp    %edx,%eax
80104999:	72 15                	jb     801049b0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010499b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499e:	8b 53 04             	mov    0x4(%ebx),%edx
801049a1:	89 10                	mov    %edx,(%eax)
  return 0;
801049a3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801049a5:	5b                   	pop    %ebx
801049a6:	5e                   	pop    %esi
801049a7:	5d                   	pop    %ebp
801049a8:	c3                   	ret    
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b5:	eb ee                	jmp    801049a5 <argint+0x35>
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	83 ec 10             	sub    $0x10,%esp
801049c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049cb:	e8 d0 ed ff ff       	call   801037a0 <myproc>
801049d0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801049d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049d5:	83 ec 08             	sub    $0x8,%esp
801049d8:	50                   	push   %eax
801049d9:	ff 75 08             	pushl  0x8(%ebp)
801049dc:	e8 8f ff ff ff       	call   80104970 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049e1:	c1 e8 1f             	shr    $0x1f,%eax
801049e4:	83 c4 10             	add    $0x10,%esp
801049e7:	84 c0                	test   %al,%al
801049e9:	75 2d                	jne    80104a18 <argptr+0x58>
801049eb:	89 d8                	mov    %ebx,%eax
801049ed:	c1 e8 1f             	shr    $0x1f,%eax
801049f0:	84 c0                	test   %al,%al
801049f2:	75 24                	jne    80104a18 <argptr+0x58>
801049f4:	8b 16                	mov    (%esi),%edx
801049f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f9:	39 c2                	cmp    %eax,%edx
801049fb:	76 1b                	jbe    80104a18 <argptr+0x58>
801049fd:	01 c3                	add    %eax,%ebx
801049ff:	39 da                	cmp    %ebx,%edx
80104a01:	72 15                	jb     80104a18 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104a03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a06:	89 02                	mov    %eax,(%edx)
  return 0;
80104a08:	31 c0                	xor    %eax,%eax
}
80104a0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0d:	5b                   	pop    %ebx
80104a0e:	5e                   	pop    %esi
80104a0f:	5d                   	pop    %ebp
80104a10:	c3                   	ret    
80104a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a1d:	eb eb                	jmp    80104a0a <argptr+0x4a>
80104a1f:	90                   	nop

80104a20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a29:	50                   	push   %eax
80104a2a:	ff 75 08             	pushl  0x8(%ebp)
80104a2d:	e8 3e ff ff ff       	call   80104970 <argint>
80104a32:	83 c4 10             	add    $0x10,%esp
80104a35:	85 c0                	test   %eax,%eax
80104a37:	78 17                	js     80104a50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a39:	83 ec 08             	sub    $0x8,%esp
80104a3c:	ff 75 0c             	pushl  0xc(%ebp)
80104a3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104a42:	e8 c9 fe ff ff       	call   80104910 <fetchstr>
80104a47:	83 c4 10             	add    $0x10,%esp
}
80104a4a:	c9                   	leave  
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104a55:	c9                   	leave  
80104a56:	c3                   	ret    
80104a57:	89 f6                	mov    %esi,%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <syscall>:
[SYS_setpriority]  sys_setpriority,
};

void
syscall(void)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104a65:	e8 36 ed ff ff       	call   801037a0 <myproc>

  num = curproc->tf->eax;
80104a6a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104a6d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a6f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a72:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a75:	83 fa 17             	cmp    $0x17,%edx
80104a78:	77 1e                	ja     80104a98 <syscall+0x38>
80104a7a:	8b 14 85 20 79 10 80 	mov    -0x7fef86e0(,%eax,4),%edx
80104a81:	85 d2                	test   %edx,%edx
80104a83:	74 13                	je     80104a98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104a85:	ff d2                	call   *%edx
80104a87:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a8d:	5b                   	pop    %ebx
80104a8e:	5e                   	pop    %esi
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104a98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a99:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104a9c:	50                   	push   %eax
80104a9d:	ff 73 10             	pushl  0x10(%ebx)
80104aa0:	68 f1 78 10 80       	push   $0x801078f1
80104aa5:	e8 b6 bb ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104aaa:	8b 43 18             	mov    0x18(%ebx),%eax
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104ab7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aba:	5b                   	pop    %ebx
80104abb:	5e                   	pop    %esi
80104abc:	5d                   	pop    %ebp
80104abd:	c3                   	ret    
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ac6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ac9:	83 ec 34             	sub    $0x34,%esp
80104acc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ad2:	56                   	push   %esi
80104ad3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ad4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ad7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ada:	e8 f1 d3 ff ff       	call   80101ed0 <nameiparent>
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	85 c0                	test   %eax,%eax
80104ae4:	0f 84 f6 00 00 00    	je     80104be0 <create+0x120>
    return 0;
  ilock(dp);
80104aea:	83 ec 0c             	sub    $0xc,%esp
80104aed:	89 c7                	mov    %eax,%edi
80104aef:	50                   	push   %eax
80104af0:	e8 6b cb ff ff       	call   80101660 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104af5:	83 c4 0c             	add    $0xc,%esp
80104af8:	6a 00                	push   $0x0
80104afa:	56                   	push   %esi
80104afb:	57                   	push   %edi
80104afc:	e8 8f d0 ff ff       	call   80101b90 <dirlookup>
80104b01:	83 c4 10             	add    $0x10,%esp
80104b04:	85 c0                	test   %eax,%eax
80104b06:	89 c3                	mov    %eax,%ebx
80104b08:	74 56                	je     80104b60 <create+0xa0>
    iunlockput(dp);
80104b0a:	83 ec 0c             	sub    $0xc,%esp
80104b0d:	57                   	push   %edi
80104b0e:	e8 dd cd ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104b13:	89 1c 24             	mov    %ebx,(%esp)
80104b16:	e8 45 cb ff ff       	call   80101660 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b1b:	83 c4 10             	add    $0x10,%esp
80104b1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b23:	75 1b                	jne    80104b40 <create+0x80>
80104b25:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104b2a:	89 d8                	mov    %ebx,%eax
80104b2c:	75 12                	jne    80104b40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b31:	5b                   	pop    %ebx
80104b32:	5e                   	pop    %esi
80104b33:	5f                   	pop    %edi
80104b34:	5d                   	pop    %ebp
80104b35:	c3                   	ret    
80104b36:	8d 76 00             	lea    0x0(%esi),%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104b40:	83 ec 0c             	sub    $0xc,%esp
80104b43:	53                   	push   %ebx
80104b44:	e8 a7 cd ff ff       	call   801018f0 <iunlockput>
    return 0;
80104b49:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104b4f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d 76 00             	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104b60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b64:	83 ec 08             	sub    $0x8,%esp
80104b67:	50                   	push   %eax
80104b68:	ff 37                	pushl  (%edi)
80104b6a:	e8 81 c9 ff ff       	call   801014f0 <ialloc>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	89 c3                	mov    %eax,%ebx
80104b76:	0f 84 cc 00 00 00    	je     80104c48 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	50                   	push   %eax
80104b80:	e8 db ca ff ff       	call   80101660 <ilock>
  ip->major = major;
80104b85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b89:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104b8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104b91:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104b95:	b8 01 00 00 00       	mov    $0x1,%eax
80104b9a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104b9e:	89 1c 24             	mov    %ebx,(%esp)
80104ba1:	e8 0a ca ff ff       	call   801015b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104ba6:	83 c4 10             	add    $0x10,%esp
80104ba9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bae:	74 40                	je     80104bf0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104bb0:	83 ec 04             	sub    $0x4,%esp
80104bb3:	ff 73 04             	pushl  0x4(%ebx)
80104bb6:	56                   	push   %esi
80104bb7:	57                   	push   %edi
80104bb8:	e8 33 d2 ff ff       	call   80101df0 <dirlink>
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	78 77                	js     80104c3b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	57                   	push   %edi
80104bc8:	e8 23 cd ff ff       	call   801018f0 <iunlockput>

  return ip;
80104bcd:	83 c4 10             	add    $0x10,%esp
}
80104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104bd3:	89 d8                	mov    %ebx,%eax
}
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5f                   	pop    %edi
80104bd8:	5d                   	pop    %ebp
80104bd9:	c3                   	ret    
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104be0:	31 c0                	xor    %eax,%eax
80104be2:	e9 47 ff ff ff       	jmp    80104b2e <create+0x6e>
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104bf0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104bf5:	83 ec 0c             	sub    $0xc,%esp
80104bf8:	57                   	push   %edi
80104bf9:	e8 b2 c9 ff ff       	call   801015b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bfe:	83 c4 0c             	add    $0xc,%esp
80104c01:	ff 73 04             	pushl  0x4(%ebx)
80104c04:	68 a0 79 10 80       	push   $0x801079a0
80104c09:	53                   	push   %ebx
80104c0a:	e8 e1 d1 ff ff       	call   80101df0 <dirlink>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	78 18                	js     80104c2e <create+0x16e>
80104c16:	83 ec 04             	sub    $0x4,%esp
80104c19:	ff 77 04             	pushl  0x4(%edi)
80104c1c:	68 9f 79 10 80       	push   $0x8010799f
80104c21:	53                   	push   %ebx
80104c22:	e8 c9 d1 ff ff       	call   80101df0 <dirlink>
80104c27:	83 c4 10             	add    $0x10,%esp
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	79 82                	jns    80104bb0 <create+0xf0>
      panic("create dots");
80104c2e:	83 ec 0c             	sub    $0xc,%esp
80104c31:	68 93 79 10 80       	push   $0x80107993
80104c36:	e8 35 b7 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104c3b:	83 ec 0c             	sub    $0xc,%esp
80104c3e:	68 a2 79 10 80       	push   $0x801079a2
80104c43:	e8 28 b7 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104c48:	83 ec 0c             	sub    $0xc,%esp
80104c4b:	68 84 79 10 80       	push   $0x80107984
80104c50:	e8 1b b7 ff ff       	call   80100370 <panic>
80104c55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c67:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c6a:	89 d3                	mov    %edx,%ebx
80104c6c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c6f:	50                   	push   %eax
80104c70:	6a 00                	push   $0x0
80104c72:	e8 f9 fc ff ff       	call   80104970 <argint>
80104c77:	83 c4 10             	add    $0x10,%esp
80104c7a:	85 c0                	test   %eax,%eax
80104c7c:	78 32                	js     80104cb0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c82:	77 2c                	ja     80104cb0 <argfd.constprop.0+0x50>
80104c84:	e8 17 eb ff ff       	call   801037a0 <myproc>
80104c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c8c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c90:	85 c0                	test   %eax,%eax
80104c92:	74 1c                	je     80104cb0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104c94:	85 f6                	test   %esi,%esi
80104c96:	74 02                	je     80104c9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c98:	89 16                	mov    %edx,(%esi)
  if(pf)
80104c9a:	85 db                	test   %ebx,%ebx
80104c9c:	74 22                	je     80104cc0 <argfd.constprop.0+0x60>
    *pf = f;
80104c9e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104ca0:	31 c0                	xor    %eax,%eax
}
80104ca2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104cb8:	5b                   	pop    %ebx
80104cb9:	5e                   	pop    %esi
80104cba:	5d                   	pop    %ebp
80104cbb:	c3                   	ret    
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104cc0:	31 c0                	xor    %eax,%eax
80104cc2:	eb de                	jmp    80104ca2 <argfd.constprop.0+0x42>
80104cc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104cd0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104cd0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cd1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	56                   	push   %esi
80104cd6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104cda:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cdd:	e8 7e ff ff ff       	call   80104c60 <argfd.constprop.0>
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	78 1a                	js     80104d00 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104ce6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ce8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104ceb:	e8 b0 ea ff ff       	call   801037a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104cf0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cf4:	85 d2                	test   %edx,%edx
80104cf6:	74 18                	je     80104d10 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	83 fb 10             	cmp    $0x10,%ebx
80104cfe:	75 f0                	jne    80104cf0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104d08:	5b                   	pop    %ebx
80104d09:	5e                   	pop    %esi
80104d0a:	5d                   	pop    %ebp
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104d10:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	ff 75 f4             	pushl  -0xc(%ebp)
80104d1a:	e8 c1 c0 ff ff       	call   80100de0 <filedup>
  return fd;
80104d1f:	83 c4 10             	add    $0x10,%esp
}
80104d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104d25:	89 d8                	mov    %ebx,%eax
}
80104d27:	5b                   	pop    %ebx
80104d28:	5e                   	pop    %esi
80104d29:	5d                   	pop    %ebp
80104d2a:	c3                   	ret    
80104d2b:	90                   	nop
80104d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d30 <sys_read>:

int
sys_read(void)
{
80104d30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d31:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104d33:	89 e5                	mov    %esp,%ebp
80104d35:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3b:	e8 20 ff ff ff       	call   80104c60 <argfd.constprop.0>
80104d40:	85 c0                	test   %eax,%eax
80104d42:	78 4c                	js     80104d90 <sys_read+0x60>
80104d44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d47:	83 ec 08             	sub    $0x8,%esp
80104d4a:	50                   	push   %eax
80104d4b:	6a 02                	push   $0x2
80104d4d:	e8 1e fc ff ff       	call   80104970 <argint>
80104d52:	83 c4 10             	add    $0x10,%esp
80104d55:	85 c0                	test   %eax,%eax
80104d57:	78 37                	js     80104d90 <sys_read+0x60>
80104d59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d5c:	83 ec 04             	sub    $0x4,%esp
80104d5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d62:	50                   	push   %eax
80104d63:	6a 01                	push   $0x1
80104d65:	e8 56 fc ff ff       	call   801049c0 <argptr>
80104d6a:	83 c4 10             	add    $0x10,%esp
80104d6d:	85 c0                	test   %eax,%eax
80104d6f:	78 1f                	js     80104d90 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104d71:	83 ec 04             	sub    $0x4,%esp
80104d74:	ff 75 f0             	pushl  -0x10(%ebp)
80104d77:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d7d:	e8 ce c1 ff ff       	call   80100f50 <fileread>
80104d82:	83 c4 10             	add    $0x10,%esp
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <sys_write>:

int
sys_write(void)
{
80104da0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dab:	e8 b0 fe ff ff       	call   80104c60 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 4c                	js     80104e00 <sys_write+0x60>
80104db4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db7:	83 ec 08             	sub    $0x8,%esp
80104dba:	50                   	push   %eax
80104dbb:	6a 02                	push   $0x2
80104dbd:	e8 ae fb ff ff       	call   80104970 <argint>
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 37                	js     80104e00 <sys_write+0x60>
80104dc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dcc:	83 ec 04             	sub    $0x4,%esp
80104dcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd2:	50                   	push   %eax
80104dd3:	6a 01                	push   $0x1
80104dd5:	e8 e6 fb ff ff       	call   801049c0 <argptr>
80104dda:	83 c4 10             	add    $0x10,%esp
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	78 1f                	js     80104e00 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104de1:	83 ec 04             	sub    $0x4,%esp
80104de4:	ff 75 f0             	pushl  -0x10(%ebp)
80104de7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ded:	e8 ee c1 ff ff       	call   80100fe0 <filewrite>
80104df2:	83 c4 10             	add    $0x10,%esp
}
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <sys_close>:

int
sys_close(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104e16:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e1c:	e8 3f fe ff ff       	call   80104c60 <argfd.constprop.0>
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 2b                	js     80104e50 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104e25:	e8 76 e9 ff ff       	call   801037a0 <myproc>
80104e2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e2d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104e30:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e37:	00 
  fileclose(f);
80104e38:	ff 75 f4             	pushl  -0xc(%ebp)
80104e3b:	e8 f0 bf ff ff       	call   80100e30 <fileclose>
  return 0;
80104e40:	83 c4 10             	add    $0x10,%esp
80104e43:	31 c0                	xor    %eax,%eax
}
80104e45:	c9                   	leave  
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <sys_fstat>:

int
sys_fstat(void)
{
80104e60:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e61:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e63:	89 e5                	mov    %esp,%ebp
80104e65:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e6b:	e8 f0 fd ff ff       	call   80104c60 <argfd.constprop.0>
80104e70:	85 c0                	test   %eax,%eax
80104e72:	78 2c                	js     80104ea0 <sys_fstat+0x40>
80104e74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e77:	83 ec 04             	sub    $0x4,%esp
80104e7a:	6a 14                	push   $0x14
80104e7c:	50                   	push   %eax
80104e7d:	6a 01                	push   $0x1
80104e7f:	e8 3c fb ff ff       	call   801049c0 <argptr>
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	85 c0                	test   %eax,%eax
80104e89:	78 15                	js     80104ea0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104e8b:	83 ec 08             	sub    $0x8,%esp
80104e8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e91:	ff 75 f0             	pushl  -0x10(%ebp)
80104e94:	e8 67 c0 ff ff       	call   80100f00 <filestat>
80104e99:	83 c4 10             	add    $0x10,%esp
}
80104e9c:	c9                   	leave  
80104e9d:	c3                   	ret    
80104e9e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
80104eb5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104eb6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104eb9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ebc:	50                   	push   %eax
80104ebd:	6a 00                	push   $0x0
80104ebf:	e8 5c fb ff ff       	call   80104a20 <argstr>
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	0f 88 fb 00 00 00    	js     80104fca <sys_link+0x11a>
80104ecf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ed2:	83 ec 08             	sub    $0x8,%esp
80104ed5:	50                   	push   %eax
80104ed6:	6a 01                	push   $0x1
80104ed8:	e8 43 fb ff ff       	call   80104a20 <argstr>
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	0f 88 e2 00 00 00    	js     80104fca <sys_link+0x11a>
    return -1;

  begin_op();
80104ee8:	e8 53 dc ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ef3:	e8 b8 cf ff ff       	call   80101eb0 <namei>
80104ef8:	83 c4 10             	add    $0x10,%esp
80104efb:	85 c0                	test   %eax,%eax
80104efd:	89 c3                	mov    %eax,%ebx
80104eff:	0f 84 f3 00 00 00    	je     80104ff8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104f05:	83 ec 0c             	sub    $0xc,%esp
80104f08:	50                   	push   %eax
80104f09:	e8 52 c7 ff ff       	call   80101660 <ilock>
  if(ip->type == T_DIR){
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f16:	0f 84 c4 00 00 00    	je     80104fe0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104f1c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f21:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104f24:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104f27:	53                   	push   %ebx
80104f28:	e8 83 c6 ff ff       	call   801015b0 <iupdate>
  iunlock(ip);
80104f2d:	89 1c 24             	mov    %ebx,(%esp)
80104f30:	e8 0b c8 ff ff       	call   80101740 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104f35:	58                   	pop    %eax
80104f36:	5a                   	pop    %edx
80104f37:	57                   	push   %edi
80104f38:	ff 75 d0             	pushl  -0x30(%ebp)
80104f3b:	e8 90 cf ff ff       	call   80101ed0 <nameiparent>
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	85 c0                	test   %eax,%eax
80104f45:	89 c6                	mov    %eax,%esi
80104f47:	74 5b                	je     80104fa4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	50                   	push   %eax
80104f4d:	e8 0e c7 ff ff       	call   80101660 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f52:	83 c4 10             	add    $0x10,%esp
80104f55:	8b 03                	mov    (%ebx),%eax
80104f57:	39 06                	cmp    %eax,(%esi)
80104f59:	75 3d                	jne    80104f98 <sys_link+0xe8>
80104f5b:	83 ec 04             	sub    $0x4,%esp
80104f5e:	ff 73 04             	pushl  0x4(%ebx)
80104f61:	57                   	push   %edi
80104f62:	56                   	push   %esi
80104f63:	e8 88 ce ff ff       	call   80101df0 <dirlink>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	78 29                	js     80104f98 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f6f:	83 ec 0c             	sub    $0xc,%esp
80104f72:	56                   	push   %esi
80104f73:	e8 78 c9 ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80104f78:	89 1c 24             	mov    %ebx,(%esp)
80104f7b:	e8 10 c8 ff ff       	call   80101790 <iput>

  end_op();
80104f80:	e8 2b dc ff ff       	call   80102bb0 <end_op>

  return 0;
80104f85:	83 c4 10             	add    $0x10,%esp
80104f88:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f8d:	5b                   	pop    %ebx
80104f8e:	5e                   	pop    %esi
80104f8f:	5f                   	pop    %edi
80104f90:	5d                   	pop    %ebp
80104f91:	c3                   	ret    
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	56                   	push   %esi
80104f9c:	e8 4f c9 ff ff       	call   801018f0 <iunlockput>
    goto bad;
80104fa1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	53                   	push   %ebx
80104fa8:	e8 b3 c6 ff ff       	call   80101660 <ilock>
  ip->nlink--;
80104fad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fb2:	89 1c 24             	mov    %ebx,(%esp)
80104fb5:	e8 f6 c5 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80104fba:	89 1c 24             	mov    %ebx,(%esp)
80104fbd:	e8 2e c9 ff ff       	call   801018f0 <iunlockput>
  end_op();
80104fc2:	e8 e9 db ff ff       	call   80102bb0 <end_op>
  return -1;
80104fc7:	83 c4 10             	add    $0x10,%esp
}
80104fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fd2:	5b                   	pop    %ebx
80104fd3:	5e                   	pop    %esi
80104fd4:	5f                   	pop    %edi
80104fd5:	5d                   	pop    %ebp
80104fd6:	c3                   	ret    
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
80104fe3:	53                   	push   %ebx
80104fe4:	e8 07 c9 ff ff       	call   801018f0 <iunlockput>
    end_op();
80104fe9:	e8 c2 db ff ff       	call   80102bb0 <end_op>
    return -1;
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ff6:	eb 92                	jmp    80104f8a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104ff8:	e8 b3 db ff ff       	call   80102bb0 <end_op>
    return -1;
80104ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105002:	eb 86                	jmp    80104f8a <sys_link+0xda>
80105004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010500a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105010 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
80105015:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105016:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105019:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010501c:	50                   	push   %eax
8010501d:	6a 00                	push   $0x0
8010501f:	e8 fc f9 ff ff       	call   80104a20 <argstr>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 82 01 00 00    	js     801051b1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010502f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105032:	e8 09 db ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105037:	83 ec 08             	sub    $0x8,%esp
8010503a:	53                   	push   %ebx
8010503b:	ff 75 c0             	pushl  -0x40(%ebp)
8010503e:	e8 8d ce ff ff       	call   80101ed0 <nameiparent>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010504b:	0f 84 6a 01 00 00    	je     801051bb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105051:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	56                   	push   %esi
80105058:	e8 03 c6 ff ff       	call   80101660 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010505d:	58                   	pop    %eax
8010505e:	5a                   	pop    %edx
8010505f:	68 a0 79 10 80       	push   $0x801079a0
80105064:	53                   	push   %ebx
80105065:	e8 06 cb ff ff       	call   80101b70 <namecmp>
8010506a:	83 c4 10             	add    $0x10,%esp
8010506d:	85 c0                	test   %eax,%eax
8010506f:	0f 84 fc 00 00 00    	je     80105171 <sys_unlink+0x161>
80105075:	83 ec 08             	sub    $0x8,%esp
80105078:	68 9f 79 10 80       	push   $0x8010799f
8010507d:	53                   	push   %ebx
8010507e:	e8 ed ca ff ff       	call   80101b70 <namecmp>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	0f 84 e3 00 00 00    	je     80105171 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010508e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105091:	83 ec 04             	sub    $0x4,%esp
80105094:	50                   	push   %eax
80105095:	53                   	push   %ebx
80105096:	56                   	push   %esi
80105097:	e8 f4 ca ff ff       	call   80101b90 <dirlookup>
8010509c:	83 c4 10             	add    $0x10,%esp
8010509f:	85 c0                	test   %eax,%eax
801050a1:	89 c3                	mov    %eax,%ebx
801050a3:	0f 84 c8 00 00 00    	je     80105171 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801050a9:	83 ec 0c             	sub    $0xc,%esp
801050ac:	50                   	push   %eax
801050ad:	e8 ae c5 ff ff       	call   80101660 <ilock>

  if(ip->nlink < 1)
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ba:	0f 8e 24 01 00 00    	jle    801051e4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801050c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050c5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801050c8:	74 66                	je     80105130 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801050ca:	83 ec 04             	sub    $0x4,%esp
801050cd:	6a 10                	push   $0x10
801050cf:	6a 00                	push   $0x0
801050d1:	56                   	push   %esi
801050d2:	e8 89 f5 ff ff       	call   80104660 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050d7:	6a 10                	push   $0x10
801050d9:	ff 75 c4             	pushl  -0x3c(%ebp)
801050dc:	56                   	push   %esi
801050dd:	ff 75 b4             	pushl  -0x4c(%ebp)
801050e0:	e8 5b c9 ff ff       	call   80101a40 <writei>
801050e5:	83 c4 20             	add    $0x20,%esp
801050e8:	83 f8 10             	cmp    $0x10,%eax
801050eb:	0f 85 e6 00 00 00    	jne    801051d7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801050f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f6:	0f 84 9c 00 00 00    	je     80105198 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801050fc:	83 ec 0c             	sub    $0xc,%esp
801050ff:	ff 75 b4             	pushl  -0x4c(%ebp)
80105102:	e8 e9 c7 ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
80105107:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010510c:	89 1c 24             	mov    %ebx,(%esp)
8010510f:	e8 9c c4 ff ff       	call   801015b0 <iupdate>
  iunlockput(ip);
80105114:	89 1c 24             	mov    %ebx,(%esp)
80105117:	e8 d4 c7 ff ff       	call   801018f0 <iunlockput>

  end_op();
8010511c:	e8 8f da ff ff       	call   80102bb0 <end_op>

  return 0;
80105121:	83 c4 10             	add    $0x10,%esp
80105124:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5f                   	pop    %edi
8010512c:	5d                   	pop    %ebp
8010512d:	c3                   	ret    
8010512e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105130:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105134:	76 94                	jbe    801050ca <sys_unlink+0xba>
80105136:	bf 20 00 00 00       	mov    $0x20,%edi
8010513b:	eb 0f                	jmp    8010514c <sys_unlink+0x13c>
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
80105140:	83 c7 10             	add    $0x10,%edi
80105143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105146:	0f 83 7e ff ff ff    	jae    801050ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010514c:	6a 10                	push   $0x10
8010514e:	57                   	push   %edi
8010514f:	56                   	push   %esi
80105150:	53                   	push   %ebx
80105151:	e8 ea c7 ff ff       	call   80101940 <readi>
80105156:	83 c4 10             	add    $0x10,%esp
80105159:	83 f8 10             	cmp    $0x10,%eax
8010515c:	75 6c                	jne    801051ca <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010515e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105163:	74 db                	je     80105140 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	53                   	push   %ebx
80105169:	e8 82 c7 ff ff       	call   801018f0 <iunlockput>
    goto bad;
8010516e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105171:	83 ec 0c             	sub    $0xc,%esp
80105174:	ff 75 b4             	pushl  -0x4c(%ebp)
80105177:	e8 74 c7 ff ff       	call   801018f0 <iunlockput>
  end_op();
8010517c:	e8 2f da ff ff       	call   80102bb0 <end_op>
  return -1;
80105181:	83 c4 10             	add    $0x10,%esp
}
80105184:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010518c:	5b                   	pop    %ebx
8010518d:	5e                   	pop    %esi
8010518e:	5f                   	pop    %edi
8010518f:	5d                   	pop    %ebp
80105190:	c3                   	ret    
80105191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105198:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010519b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010519e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051a3:	50                   	push   %eax
801051a4:	e8 07 c4 ff ff       	call   801015b0 <iupdate>
801051a9:	83 c4 10             	add    $0x10,%esp
801051ac:	e9 4b ff ff ff       	jmp    801050fc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801051b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b6:	e9 6b ff ff ff       	jmp    80105126 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801051bb:	e8 f0 d9 ff ff       	call   80102bb0 <end_op>
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	e9 5c ff ff ff       	jmp    80105126 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801051ca:	83 ec 0c             	sub    $0xc,%esp
801051cd:	68 c4 79 10 80       	push   $0x801079c4
801051d2:	e8 99 b1 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	68 d6 79 10 80       	push   $0x801079d6
801051df:	e8 8c b1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	68 b2 79 10 80       	push   $0x801079b2
801051ec:	e8 7f b1 ff ff       	call   80100370 <panic>
801051f1:	eb 0d                	jmp    80105200 <sys_open>
801051f3:	90                   	nop
801051f4:	90                   	nop
801051f5:	90                   	nop
801051f6:	90                   	nop
801051f7:	90                   	nop
801051f8:	90                   	nop
801051f9:	90                   	nop
801051fa:	90                   	nop
801051fb:	90                   	nop
801051fc:	90                   	nop
801051fd:	90                   	nop
801051fe:	90                   	nop
801051ff:	90                   	nop

80105200 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105206:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105209:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 0c f8 ff ff       	call   80104a20 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 9e 00 00 00    	js     801052bd <sys_open+0xbd>
8010521f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105222:	83 ec 08             	sub    $0x8,%esp
80105225:	50                   	push   %eax
80105226:	6a 01                	push   $0x1
80105228:	e8 43 f7 ff ff       	call   80104970 <argint>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	0f 88 85 00 00 00    	js     801052bd <sys_open+0xbd>
    return -1;

  begin_op();
80105238:	e8 03 d9 ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
8010523d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105241:	0f 85 89 00 00 00    	jne    801052d0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	ff 75 e0             	pushl  -0x20(%ebp)
8010524d:	e8 5e cc ff ff       	call   80101eb0 <namei>
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	85 c0                	test   %eax,%eax
80105257:	89 c6                	mov    %eax,%esi
80105259:	0f 84 8e 00 00 00    	je     801052ed <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	50                   	push   %eax
80105263:	e8 f8 c3 ff ff       	call   80101660 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105270:	0f 84 d2 00 00 00    	je     80105348 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105276:	e8 f5 ba ff ff       	call   80100d70 <filealloc>
8010527b:	85 c0                	test   %eax,%eax
8010527d:	89 c7                	mov    %eax,%edi
8010527f:	74 2b                	je     801052ac <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105281:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105283:	e8 18 e5 ff ff       	call   801037a0 <myproc>
80105288:	90                   	nop
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105290:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105294:	85 d2                	test   %edx,%edx
80105296:	74 68                	je     80105300 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105298:	83 c3 01             	add    $0x1,%ebx
8010529b:	83 fb 10             	cmp    $0x10,%ebx
8010529e:	75 f0                	jne    80105290 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	57                   	push   %edi
801052a4:	e8 87 bb ff ff       	call   80100e30 <fileclose>
801052a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	56                   	push   %esi
801052b0:	e8 3b c6 ff ff       	call   801018f0 <iunlockput>
    end_op();
801052b5:	e8 f6 d8 ff ff       	call   80102bb0 <end_op>
    return -1;
801052ba:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801052bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801052c5:	5b                   	pop    %ebx
801052c6:	5e                   	pop    %esi
801052c7:	5f                   	pop    %edi
801052c8:	5d                   	pop    %ebp
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052d6:	31 c9                	xor    %ecx,%ecx
801052d8:	6a 00                	push   $0x0
801052da:	ba 02 00 00 00       	mov    $0x2,%edx
801052df:	e8 dc f7 ff ff       	call   80104ac0 <create>
    if(ip == 0){
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801052e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052eb:	75 89                	jne    80105276 <sys_open+0x76>
      end_op();
801052ed:	e8 be d8 ff ff       	call   80102bb0 <end_op>
      return -1;
801052f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f7:	eb 43                	jmp    8010533c <sys_open+0x13c>
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105300:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105303:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105307:	56                   	push   %esi
80105308:	e8 33 c4 ff ff       	call   80101740 <iunlock>
  end_op();
8010530d:	e8 9e d8 ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
80105312:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105318:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010531b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010531e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105321:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105328:	89 d0                	mov    %edx,%eax
8010532a:	83 e0 01             	and    $0x1,%eax
8010532d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105330:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105333:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105336:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010533a:	89 d8                	mov    %ebx,%eax
}
8010533c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010533f:	5b                   	pop    %ebx
80105340:	5e                   	pop    %esi
80105341:	5f                   	pop    %edi
80105342:	5d                   	pop    %ebp
80105343:	c3                   	ret    
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105348:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010534b:	85 c9                	test   %ecx,%ecx
8010534d:	0f 84 23 ff ff ff    	je     80105276 <sys_open+0x76>
80105353:	e9 54 ff ff ff       	jmp    801052ac <sys_open+0xac>
80105358:	90                   	nop
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105366:	e8 d5 d7 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010536b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536e:	83 ec 08             	sub    $0x8,%esp
80105371:	50                   	push   %eax
80105372:	6a 00                	push   $0x0
80105374:	e8 a7 f6 ff ff       	call   80104a20 <argstr>
80105379:	83 c4 10             	add    $0x10,%esp
8010537c:	85 c0                	test   %eax,%eax
8010537e:	78 30                	js     801053b0 <sys_mkdir+0x50>
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105386:	31 c9                	xor    %ecx,%ecx
80105388:	6a 00                	push   $0x0
8010538a:	ba 01 00 00 00       	mov    $0x1,%edx
8010538f:	e8 2c f7 ff ff       	call   80104ac0 <create>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	85 c0                	test   %eax,%eax
80105399:	74 15                	je     801053b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010539b:	83 ec 0c             	sub    $0xc,%esp
8010539e:	50                   	push   %eax
8010539f:	e8 4c c5 ff ff       	call   801018f0 <iunlockput>
  end_op();
801053a4:	e8 07 d8 ff ff       	call   80102bb0 <end_op>
  return 0;
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	c9                   	leave  
801053af:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801053b0:	e8 fb d7 ff ff       	call   80102bb0 <end_op>
    return -1;
801053b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801053ba:	c9                   	leave  
801053bb:	c3                   	ret    
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053c0 <sys_mknod>:

int
sys_mknod(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053c6:	e8 75 d7 ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053ce:	83 ec 08             	sub    $0x8,%esp
801053d1:	50                   	push   %eax
801053d2:	6a 00                	push   $0x0
801053d4:	e8 47 f6 ff ff       	call   80104a20 <argstr>
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	85 c0                	test   %eax,%eax
801053de:	78 60                	js     80105440 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053e3:	83 ec 08             	sub    $0x8,%esp
801053e6:	50                   	push   %eax
801053e7:	6a 01                	push   $0x1
801053e9:	e8 82 f5 ff ff       	call   80104970 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	85 c0                	test   %eax,%eax
801053f3:	78 4b                	js     80105440 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801053f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053f8:	83 ec 08             	sub    $0x8,%esp
801053fb:	50                   	push   %eax
801053fc:	6a 02                	push   $0x2
801053fe:	e8 6d f5 ff ff       	call   80104970 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	78 36                	js     80105440 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010540a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010540e:	83 ec 0c             	sub    $0xc,%esp
80105411:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105415:	ba 03 00 00 00       	mov    $0x3,%edx
8010541a:	50                   	push   %eax
8010541b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010541e:	e8 9d f6 ff ff       	call   80104ac0 <create>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	74 16                	je     80105440 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010542a:	83 ec 0c             	sub    $0xc,%esp
8010542d:	50                   	push   %eax
8010542e:	e8 bd c4 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105433:	e8 78 d7 ff ff       	call   80102bb0 <end_op>
  return 0;
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	31 c0                	xor    %eax,%eax
}
8010543d:	c9                   	leave  
8010543e:	c3                   	ret    
8010543f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105440:	e8 6b d7 ff ff       	call   80102bb0 <end_op>
    return -1;
80105445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010544a:	c9                   	leave  
8010544b:	c3                   	ret    
8010544c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105450 <sys_chdir>:

int
sys_chdir(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	56                   	push   %esi
80105454:	53                   	push   %ebx
80105455:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105458:	e8 43 e3 ff ff       	call   801037a0 <myproc>
8010545d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010545f:	e8 dc d6 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105464:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105467:	83 ec 08             	sub    $0x8,%esp
8010546a:	50                   	push   %eax
8010546b:	6a 00                	push   $0x0
8010546d:	e8 ae f5 ff ff       	call   80104a20 <argstr>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	85 c0                	test   %eax,%eax
80105477:	78 77                	js     801054f0 <sys_chdir+0xa0>
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	ff 75 f4             	pushl  -0xc(%ebp)
8010547f:	e8 2c ca ff ff       	call   80101eb0 <namei>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	89 c3                	mov    %eax,%ebx
8010548b:	74 63                	je     801054f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	50                   	push   %eax
80105491:	e8 ca c1 ff ff       	call   80101660 <ilock>
  if(ip->type != T_DIR){
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010549e:	75 30                	jne    801054d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	53                   	push   %ebx
801054a4:	e8 97 c2 ff ff       	call   80101740 <iunlock>
  iput(curproc->cwd);
801054a9:	58                   	pop    %eax
801054aa:	ff 76 68             	pushl  0x68(%esi)
801054ad:	e8 de c2 ff ff       	call   80101790 <iput>
  end_op();
801054b2:	e8 f9 d6 ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
801054b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	31 c0                	xor    %eax,%eax
}
801054bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c2:	5b                   	pop    %ebx
801054c3:	5e                   	pop    %esi
801054c4:	5d                   	pop    %ebp
801054c5:	c3                   	ret    
801054c6:	8d 76 00             	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	53                   	push   %ebx
801054d4:	e8 17 c4 ff ff       	call   801018f0 <iunlockput>
    end_op();
801054d9:	e8 d2 d6 ff ff       	call   80102bb0 <end_op>
    return -1;
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e6:	eb d7                	jmp    801054bf <sys_chdir+0x6f>
801054e8:	90                   	nop
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801054f0:	e8 bb d6 ff ff       	call   80102bb0 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fa:	eb c3                	jmp    801054bf <sys_chdir+0x6f>
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105506:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010550c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105512:	50                   	push   %eax
80105513:	6a 00                	push   $0x0
80105515:	e8 06 f5 ff ff       	call   80104a20 <argstr>
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	85 c0                	test   %eax,%eax
8010551f:	78 7f                	js     801055a0 <sys_exec+0xa0>
80105521:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105527:	83 ec 08             	sub    $0x8,%esp
8010552a:	50                   	push   %eax
8010552b:	6a 01                	push   $0x1
8010552d:	e8 3e f4 ff ff       	call   80104970 <argint>
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	85 c0                	test   %eax,%eax
80105537:	78 67                	js     801055a0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105539:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010553f:	83 ec 04             	sub    $0x4,%esp
80105542:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105548:	68 80 00 00 00       	push   $0x80
8010554d:	6a 00                	push   $0x0
8010554f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105555:	50                   	push   %eax
80105556:	31 db                	xor    %ebx,%ebx
80105558:	e8 03 f1 ff ff       	call   80104660 <memset>
8010555d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105560:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105566:	83 ec 08             	sub    $0x8,%esp
80105569:	57                   	push   %edi
8010556a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010556d:	50                   	push   %eax
8010556e:	e8 5d f3 ff ff       	call   801048d0 <fetchint>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 26                	js     801055a0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010557a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105580:	85 c0                	test   %eax,%eax
80105582:	74 2c                	je     801055b0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105584:	83 ec 08             	sub    $0x8,%esp
80105587:	56                   	push   %esi
80105588:	50                   	push   %eax
80105589:	e8 82 f3 ff ff       	call   80104910 <fetchstr>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 0b                	js     801055a0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105595:	83 c3 01             	add    $0x1,%ebx
80105598:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010559b:	83 fb 20             	cmp    $0x20,%ebx
8010559e:	75 c0                	jne    80105560 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801055a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055a8:	5b                   	pop    %ebx
801055a9:	5e                   	pop    %esi
801055aa:	5f                   	pop    %edi
801055ab:	5d                   	pop    %ebp
801055ac:	c3                   	ret    
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055b0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055b6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801055b9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055c0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055c4:	50                   	push   %eax
801055c5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055cb:	e8 20 b4 ff ff       	call   801009f0 <exec>
801055d0:	83 c4 10             	add    $0x10,%esp
}
801055d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d6:	5b                   	pop    %ebx
801055d7:	5e                   	pop    %esi
801055d8:	5f                   	pop    %edi
801055d9:	5d                   	pop    %ebp
801055da:	c3                   	ret    
801055db:	90                   	nop
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_pipe>:

int
sys_pipe(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055e6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801055e9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055ec:	6a 08                	push   $0x8
801055ee:	50                   	push   %eax
801055ef:	6a 00                	push   $0x0
801055f1:	e8 ca f3 ff ff       	call   801049c0 <argptr>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	78 4a                	js     80105647 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801055fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	50                   	push   %eax
80105604:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105607:	50                   	push   %eax
80105608:	e8 d3 db ff ff       	call   801031e0 <pipealloc>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	85 c0                	test   %eax,%eax
80105612:	78 33                	js     80105647 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105614:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105616:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105619:	e8 82 e1 ff ff       	call   801037a0 <myproc>
8010561e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105620:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105624:	85 f6                	test   %esi,%esi
80105626:	74 30                	je     80105658 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105628:	83 c3 01             	add    $0x1,%ebx
8010562b:	83 fb 10             	cmp    $0x10,%ebx
8010562e:	75 f0                	jne    80105620 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	ff 75 e0             	pushl  -0x20(%ebp)
80105636:	e8 f5 b7 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010563b:	58                   	pop    %eax
8010563c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010563f:	e8 ec b7 ff ff       	call   80100e30 <fileclose>
    return -1;
80105644:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105647:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010564a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010564f:	5b                   	pop    %ebx
80105650:	5e                   	pop    %esi
80105651:	5f                   	pop    %edi
80105652:	5d                   	pop    %ebp
80105653:	c3                   	ret    
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105658:	8d 73 08             	lea    0x8(%ebx),%esi
8010565b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010565f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105662:	e8 39 e1 ff ff       	call   801037a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105667:	31 d2                	xor    %edx,%edx
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105670:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105674:	85 c9                	test   %ecx,%ecx
80105676:	74 18                	je     80105690 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105678:	83 c2 01             	add    $0x1,%edx
8010567b:	83 fa 10             	cmp    $0x10,%edx
8010567e:	75 f0                	jne    80105670 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105680:	e8 1b e1 ff ff       	call   801037a0 <myproc>
80105685:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010568c:	00 
8010568d:	eb a1                	jmp    80105630 <sys_pipe+0x50>
8010568f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105690:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105694:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105697:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105699:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010569c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010569f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801056a2:	31 c0                	xor    %eax,%eax
}
801056a4:	5b                   	pop    %ebx
801056a5:	5e                   	pop    %esi
801056a6:	5f                   	pop    %edi
801056a7:	5d                   	pop    %ebp
801056a8:	c3                   	ret    
801056a9:	66 90                	xchg   %ax,%ax
801056ab:	66 90                	xchg   %ax,%ax
801056ad:	66 90                	xchg   %ax,%ax
801056af:	90                   	nop

801056b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801056b3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801056b4:	e9 87 e2 ff ff       	jmp    80103940 <fork>
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_exit>:
}

int
sys_exit(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056c6:	e8 45 e6 ff ff       	call   80103d10 <exit>
  return 0;  // not reached
}
801056cb:	31 c0                	xor    %eax,%eax
801056cd:	c9                   	leave  
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <sys_wait>:

int
sys_wait(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801056d3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801056d4:	e9 47 e9 ff ff       	jmp    80104020 <wait>
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_kill>:
}

int
sys_kill(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801056e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 00                	push   $0x0
801056ec:	e8 7f f2 ff ff       	call   80104970 <argint>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	78 18                	js     80105710 <sys_kill+0x30>
    return -1;
  return kill(pid);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	ff 75 f4             	pushl  -0xc(%ebp)
801056fe:	e8 7d ea ff ff       	call   80104180 <kill>
80105703:	83 c4 10             	add    $0x10,%esp
}
80105706:	c9                   	leave  
80105707:	c3                   	ret    
80105708:	90                   	nop
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <sys_getpid>:

int
sys_getpid(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105726:	e8 75 e0 ff ff       	call   801037a0 <myproc>
8010572b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010572e:	c9                   	leave  
8010572f:	c3                   	ret    

80105730 <sys_sbrk>:

int
sys_sbrk(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105734:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105737:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010573a:	50                   	push   %eax
8010573b:	6a 00                	push   $0x0
8010573d:	e8 2e f2 ff ff       	call   80104970 <argint>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	78 27                	js     80105770 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105749:	e8 52 e0 ff ff       	call   801037a0 <myproc>
  if(growproc(n) < 0)
8010574e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105751:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105753:	ff 75 f4             	pushl  -0xc(%ebp)
80105756:	e8 65 e1 ff ff       	call   801038c0 <growproc>
8010575b:	83 c4 10             	add    $0x10,%esp
8010575e:	85 c0                	test   %eax,%eax
80105760:	78 0e                	js     80105770 <sys_sbrk+0x40>
    return -1;
  return addr;
80105762:	89 d8                	mov    %ebx,%eax
}
80105764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105767:	c9                   	leave  
80105768:	c3                   	ret    
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105775:	eb ed                	jmp    80105764 <sys_sbrk+0x34>
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105787:	e8 14 e0 ff ff       	call   801037a0 <myproc>
8010578c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105793:	00 00 00 
  myproc()->priority = 0;
80105796:	e8 05 e0 ff ff       	call   801037a0 <myproc>
8010579b:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  myproc()->tickleft = 4;
801057a2:	e8 f9 df ff ff       	call   801037a0 <myproc>
801057a7:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
801057ae:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
801057b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b4:	83 ec 08             	sub    $0x8,%esp
801057b7:	50                   	push   %eax
801057b8:	6a 00                	push   $0x0
801057ba:	e8 b1 f1 ff ff       	call   80104970 <argint>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	0f 88 8d 00 00 00    	js     80105857 <sys_sleep+0xd7>
    return -1;
  acquire(&tickslock);
801057ca:	83 ec 0c             	sub    $0xc,%esp
801057cd:	68 80 4f 11 80       	push   $0x80114f80
801057d2:	e8 89 ed ff ff       	call   80104560 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057da:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801057dd:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  while(ticks - ticks0 < n){
801057e3:	85 d2                	test   %edx,%edx
801057e5:	75 2a                	jne    80105811 <sys_sleep+0x91>
801057e7:	eb 57                	jmp    80105840 <sys_sleep+0xc0>
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	68 80 4f 11 80       	push   $0x80114f80
801057f8:	68 c0 57 11 80       	push   $0x801157c0
801057fd:	e8 5e e7 ff ff       	call   80103f60 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105802:	a1 c0 57 11 80       	mov    0x801157c0,%eax
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	29 d8                	sub    %ebx,%eax
8010580c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010580f:	73 2f                	jae    80105840 <sys_sleep+0xc0>
    if(myproc()->killed){
80105811:	e8 8a df ff ff       	call   801037a0 <myproc>
80105816:	8b 40 24             	mov    0x24(%eax),%eax
80105819:	85 c0                	test   %eax,%eax
8010581b:	74 d3                	je     801057f0 <sys_sleep+0x70>
      release(&tickslock);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	68 80 4f 11 80       	push   $0x80114f80
80105825:	e8 e6 ed ff ff       	call   80104610 <release>
      return -1;
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	68 80 4f 11 80       	push   $0x80114f80
80105848:	e8 c3 ed ff ff       	call   80104610 <release>
  return 0;
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	31 c0                	xor    %eax,%eax
}
80105852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105855:	c9                   	leave  
80105856:	c3                   	ret    
  myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	eb d4                	jmp    80105832 <sys_sleep+0xb2>
8010585e:	66 90                	xchg   %ax,%ax

80105860 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
80105864:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105867:	68 80 4f 11 80       	push   $0x80114f80
8010586c:	e8 ef ec ff ff       	call   80104560 <acquire>
  xticks = ticks;
80105871:	8b 1d c0 57 11 80    	mov    0x801157c0,%ebx
  release(&tickslock);
80105877:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
8010587e:	e8 8d ed ff ff       	call   80104610 <release>
  return xticks;
}
80105883:	89 d8                	mov    %ebx,%eax
80105885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105888:	c9                   	leave  
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105890 <sys_yield>:

void 
sys_yield()
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80105896:	e8 05 df ff ff       	call   801037a0 <myproc>
8010589b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801058a2:	00 00 00 
  myproc()->priority = 0;
801058a5:	e8 f6 de ff ff       	call   801037a0 <myproc>
801058aa:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  myproc()->tickleft = 4;
801058b1:	e8 ea de ff ff       	call   801037a0 <myproc>
801058b6:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
801058bd:	00 00 00 
  yield();
}
801058c0:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
801058c1:	e9 7a e5 ff ff       	jmp    80103e40 <yield>
801058c6:	8d 76 00             	lea    0x0(%esi),%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058d0 <sys_getlev>:
}

int             
sys_getlev()
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
  return getlev();
}
801058d3:	5d                   	pop    %ebp
}

int             
sys_getlev()
{
  return getlev();
801058d4:	e9 b7 e5 ff ff       	jmp    80103e90 <getlev>
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_setpriority>:
}

int             
sys_setpriority(int pid, int priority)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
 return setpriority(pid,priority);
}
801058e3:	5d                   	pop    %ebp
}

int             
sys_setpriority(int pid, int priority)
{
 return setpriority(pid,priority);
801058e4:	e9 d7 e5 ff ff       	jmp    80103ec0 <setpriority>

801058e9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058e9:	1e                   	push   %ds
  pushl %es
801058ea:	06                   	push   %es
  pushl %fs
801058eb:	0f a0                	push   %fs
  pushl %gs
801058ed:	0f a8                	push   %gs
  pushal
801058ef:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058f0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058f4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058f6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058f8:	54                   	push   %esp
  call trap
801058f9:	e8 e2 00 00 00       	call   801059e0 <trap>
  addl $4, %esp
801058fe:	83 c4 04             	add    $0x4,%esp

80105901 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105901:	61                   	popa   
  popl %gs
80105902:	0f a9                	pop    %gs
  popl %fs
80105904:	0f a1                	pop    %fs
  popl %es
80105906:	07                   	pop    %es
  popl %ds
80105907:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105908:	83 c4 08             	add    $0x8,%esp
  iret
8010590b:	cf                   	iret   
8010590c:	66 90                	xchg   %ax,%ax
8010590e:	66 90                	xchg   %ax,%ax

80105910 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105910:	31 c0                	xor    %eax,%eax
80105912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105918:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010591f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105924:	c6 04 c5 c4 4f 11 80 	movb   $0x0,-0x7feeb03c(,%eax,8)
8010592b:	00 
8010592c:	66 89 0c c5 c2 4f 11 	mov    %cx,-0x7feeb03e(,%eax,8)
80105933:	80 
80105934:	c6 04 c5 c5 4f 11 80 	movb   $0x8e,-0x7feeb03b(,%eax,8)
8010593b:	8e 
8010593c:	66 89 14 c5 c0 4f 11 	mov    %dx,-0x7feeb040(,%eax,8)
80105943:	80 
80105944:	c1 ea 10             	shr    $0x10,%edx
80105947:	66 89 14 c5 c6 4f 11 	mov    %dx,-0x7feeb03a(,%eax,8)
8010594e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010594f:	83 c0 01             	add    $0x1,%eax
80105952:	3d 00 01 00 00       	cmp    $0x100,%eax
80105957:	75 bf                	jne    80105918 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105959:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010595a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010595f:	89 e5                	mov    %esp,%ebp
80105961:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105964:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105969:	68 e5 79 10 80       	push   $0x801079e5
8010596e:	68 80 4f 11 80       	push   $0x80114f80
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105973:	66 89 15 c2 51 11 80 	mov    %dx,0x801151c2
8010597a:	c6 05 c4 51 11 80 00 	movb   $0x0,0x801151c4
80105981:	66 a3 c0 51 11 80    	mov    %ax,0x801151c0
80105987:	c1 e8 10             	shr    $0x10,%eax
8010598a:	c6 05 c5 51 11 80 ef 	movb   $0xef,0x801151c5
80105991:	66 a3 c6 51 11 80    	mov    %ax,0x801151c6

  initlock(&tickslock, "time");
80105997:	e8 64 ea ff ff       	call   80104400 <initlock>
}
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	c9                   	leave  
801059a0:	c3                   	ret    
801059a1:	eb 0d                	jmp    801059b0 <idtinit>
801059a3:	90                   	nop
801059a4:	90                   	nop
801059a5:	90                   	nop
801059a6:	90                   	nop
801059a7:	90                   	nop
801059a8:	90                   	nop
801059a9:	90                   	nop
801059aa:	90                   	nop
801059ab:	90                   	nop
801059ac:	90                   	nop
801059ad:	90                   	nop
801059ae:	90                   	nop
801059af:	90                   	nop

801059b0 <idtinit>:

void
idtinit(void)
{
801059b0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801059b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059b6:	89 e5                	mov    %esp,%ebp
801059b8:	83 ec 10             	sub    $0x10,%esp
801059bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059bf:	b8 c0 4f 11 80       	mov    $0x80114fc0,%eax
801059c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059c8:	c1 e8 10             	shr    $0x10,%eax
801059cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801059cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
801059e6:	83 ec 1c             	sub    $0x1c,%esp
801059e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801059ec:	8b 47 30             	mov    0x30(%edi),%eax
801059ef:	83 f8 40             	cmp    $0x40,%eax
801059f2:	0f 84 c8 01 00 00    	je     80105bc0 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059f8:	83 e8 20             	sub    $0x20,%eax
801059fb:	83 f8 1f             	cmp    $0x1f,%eax
801059fe:	77 10                	ja     80105a10 <trap+0x30>
80105a00:	ff 24 85 8c 7a 10 80 	jmp    *-0x7fef8574(,%eax,4)
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a10:	e8 8b dd ff ff       	call   801037a0 <myproc>
80105a15:	85 c0                	test   %eax,%eax
80105a17:	0f 84 74 02 00 00    	je     80105c91 <trap+0x2b1>
80105a1d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a21:	0f 84 6a 02 00 00    	je     80105c91 <trap+0x2b1>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a27:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a2a:	8b 57 38             	mov    0x38(%edi),%edx
80105a2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a30:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105a33:	e8 48 dd ff ff       	call   80103780 <cpuid>
80105a38:	8b 77 34             	mov    0x34(%edi),%esi
80105a3b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a41:	e8 5a dd ff ff       	call   801037a0 <myproc>
80105a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a49:	e8 52 dd ff ff       	call   801037a0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a54:	51                   	push   %ecx
80105a55:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a56:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a59:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a5c:	56                   	push   %esi
80105a5d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a5e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a61:	52                   	push   %edx
80105a62:	ff 70 10             	pushl  0x10(%eax)
80105a65:	68 48 7a 10 80       	push   $0x80107a48
80105a6a:	e8 f1 ab ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a6f:	83 c4 20             	add    $0x20,%esp
80105a72:	e8 29 dd ff ff       	call   801037a0 <myproc>
80105a77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a7e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a80:	e8 1b dd ff ff       	call   801037a0 <myproc>
80105a85:	85 c0                	test   %eax,%eax
80105a87:	74 0c                	je     80105a95 <trap+0xb5>
80105a89:	e8 12 dd ff ff       	call   801037a0 <myproc>
80105a8e:	8b 70 24             	mov    0x24(%eax),%esi
80105a91:	85 f6                	test   %esi,%esi
80105a93:	75 63                	jne    80105af8 <trap+0x118>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  #ifdef MLFQ_SCHED
   if(myproc() && myproc()->state == RUNNING){
80105a95:	e8 06 dd ff ff       	call   801037a0 <myproc>
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	74 0f                	je     80105aad <trap+0xcd>
80105a9e:	e8 fd dc ff ff       	call   801037a0 <myproc>
80105aa3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105aa7:	0f 84 4b 01 00 00    	je     80105bf8 <trap+0x218>
      else if(myproc()->tickleft <= 0 ){
         yield();
      }
  }
  
  if(ticks%100 == 0) priority_boosting();
80105aad:	8b 0d c0 57 11 80    	mov    0x801157c0,%ecx
80105ab3:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105ab8:	89 c8                	mov    %ecx,%eax
80105aba:	f7 e2                	mul    %edx
80105abc:	c1 ea 05             	shr    $0x5,%edx
80105abf:	6b d2 64             	imul   $0x64,%edx,%edx
80105ac2:	39 d1                	cmp    %edx,%ecx
80105ac4:	74 4a                	je     80105b10 <trap+0x130>
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ac6:	e8 d5 dc ff ff       	call   801037a0 <myproc>
80105acb:	85 c0                	test   %eax,%eax
80105acd:	74 1d                	je     80105aec <trap+0x10c>
80105acf:	e8 cc dc ff ff       	call   801037a0 <myproc>
80105ad4:	8b 40 24             	mov    0x24(%eax),%eax
80105ad7:	85 c0                	test   %eax,%eax
80105ad9:	74 11                	je     80105aec <trap+0x10c>
80105adb:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105adf:	83 e0 03             	and    $0x3,%eax
80105ae2:	66 83 f8 03          	cmp    $0x3,%ax
80105ae6:	0f 84 fd 00 00 00    	je     80105be9 <trap+0x209>
    exit();
}
80105aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aef:	5b                   	pop    %ebx
80105af0:	5e                   	pop    %esi
80105af1:	5f                   	pop    %edi
80105af2:	5d                   	pop    %ebp
80105af3:	c3                   	ret    
80105af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105af8:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105afc:	83 e0 03             	and    $0x3,%eax
80105aff:	66 83 f8 03          	cmp    $0x3,%ax
80105b03:	75 90                	jne    80105a95 <trap+0xb5>
    exit();
80105b05:	e8 06 e2 ff ff       	call   80103d10 <exit>
80105b0a:	eb 89                	jmp    80105a95 <trap+0xb5>
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      else if(myproc()->tickleft <= 0 ){
         yield();
      }
  }
  
  if(ticks%100 == 0) priority_boosting();
80105b10:	e8 4b df ff ff       	call   80103a60 <priority_boosting>
80105b15:	eb af                	jmp    80105ac6 <trap+0xe6>
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b20:	e8 1b c5 ff ff       	call   80102040 <ideintr>
    lapiceoi();
80105b25:	e8 d6 cb ff ff       	call   80102700 <lapiceoi>
    break;
80105b2a:	e9 51 ff ff ff       	jmp    80105a80 <trap+0xa0>
80105b2f:	90                   	nop
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105b30:	e8 4b dc ff ff       	call   80103780 <cpuid>
80105b35:	85 c0                	test   %eax,%eax
80105b37:	75 ec                	jne    80105b25 <trap+0x145>
      acquire(&tickslock);
80105b39:	83 ec 0c             	sub    $0xc,%esp
80105b3c:	68 80 4f 11 80       	push   $0x80114f80
80105b41:	e8 1a ea ff ff       	call   80104560 <acquire>
      ticks++;
      wakeup(&ticks);
80105b46:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105b4d:	83 05 c0 57 11 80 01 	addl   $0x1,0x801157c0
      wakeup(&ticks);
80105b54:	e8 c7 e5 ff ff       	call   80104120 <wakeup>
      release(&tickslock);
80105b59:	c7 04 24 80 4f 11 80 	movl   $0x80114f80,(%esp)
80105b60:	e8 ab ea ff ff       	call   80104610 <release>
80105b65:	83 c4 10             	add    $0x10,%esp
80105b68:	eb bb                	jmp    80105b25 <trap+0x145>
80105b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105b70:	e8 4b ca ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105b75:	e8 86 cb ff ff       	call   80102700 <lapiceoi>
    break;
80105b7a:	e9 01 ff ff ff       	jmp    80105a80 <trap+0xa0>
80105b7f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105b80:	e8 ab 02 00 00       	call   80105e30 <uartintr>
    lapiceoi();
80105b85:	e8 76 cb ff ff       	call   80102700 <lapiceoi>
    break;
80105b8a:	e9 f1 fe ff ff       	jmp    80105a80 <trap+0xa0>
80105b8f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b90:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105b94:	8b 77 38             	mov    0x38(%edi),%esi
80105b97:	e8 e4 db ff ff       	call   80103780 <cpuid>
80105b9c:	56                   	push   %esi
80105b9d:	53                   	push   %ebx
80105b9e:	50                   	push   %eax
80105b9f:	68 f0 79 10 80       	push   $0x801079f0
80105ba4:	e8 b7 aa ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105ba9:	e8 52 cb ff ff       	call   80102700 <lapiceoi>
    break;
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	e9 ca fe ff ff       	jmp    80105a80 <trap+0xa0>
80105bb6:	8d 76 00             	lea    0x0(%esi),%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105bc0:	e8 db db ff ff       	call   801037a0 <myproc>
80105bc5:	8b 40 24             	mov    0x24(%eax),%eax
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	75 74                	jne    80105c40 <trap+0x260>
      exit();
    myproc()->tf = tf;
80105bcc:	e8 cf db ff ff       	call   801037a0 <myproc>
80105bd1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105bd4:	e8 87 ee ff ff       	call   80104a60 <syscall>
    if(myproc()->killed)
80105bd9:	e8 c2 db ff ff       	call   801037a0 <myproc>
80105bde:	8b 78 24             	mov    0x24(%eax),%edi
80105be1:	85 ff                	test   %edi,%edi
80105be3:	0f 84 03 ff ff ff    	je     80105aec <trap+0x10c>
    yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bec:	5b                   	pop    %ebx
80105bed:	5e                   	pop    %esi
80105bee:	5f                   	pop    %edi
80105bef:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105bf0:	e9 1b e1 ff ff       	jmp    80103d10 <exit>
80105bf5:	8d 76 00             	lea    0x0(%esi),%esi
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  #ifdef MLFQ_SCHED
   if(myproc() && myproc()->state == RUNNING){

      if(myproc()->tickleft >= 0) myproc()->tickleft--;
80105bf8:	e8 a3 db ff ff       	call   801037a0 <myproc>
80105bfd:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
80105c03:	85 db                	test   %ebx,%ebx
80105c05:	78 0c                	js     80105c13 <trap+0x233>
80105c07:	e8 94 db ff ff       	call   801037a0 <myproc>
80105c0c:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
      //큐 레벨이 올라가야할때
      if(myproc()->queuelevel < MLFQ_K -1  &&  myproc()->tickleft == 0 ){
80105c13:	e8 88 db ff ff       	call   801037a0 <myproc>
80105c18:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80105c1f:	7e 2f                	jle    80105c50 <trap+0x270>
        myproc()->queuelevel++;
        myproc()->tickleft = 2 * myproc()->queuelevel + 4;
        yield();
      }
      else if(myproc()->tickleft <= 0 ){
80105c21:	e8 7a db ff ff       	call   801037a0 <myproc>
80105c26:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80105c2c:	85 d2                	test   %edx,%edx
80105c2e:	0f 8f 79 fe ff ff    	jg     80105aad <trap+0xcd>
         yield();
80105c34:	e8 07 e2 ff ff       	call   80103e40 <yield>
80105c39:	e9 6f fe ff ff       	jmp    80105aad <trap+0xcd>
80105c3e:	66 90                	xchg   %ax,%ax
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105c40:	e8 cb e0 ff ff       	call   80103d10 <exit>
80105c45:	eb 85                	jmp    80105bcc <trap+0x1ec>
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  #ifdef MLFQ_SCHED
   if(myproc() && myproc()->state == RUNNING){

      if(myproc()->tickleft >= 0) myproc()->tickleft--;
      //큐 레벨이 올라가야할때
      if(myproc()->queuelevel < MLFQ_K -1  &&  myproc()->tickleft == 0 ){
80105c50:	e8 4b db ff ff       	call   801037a0 <myproc>
80105c55:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105c5b:	85 c9                	test   %ecx,%ecx
80105c5d:	75 c2                	jne    80105c21 <trap+0x241>
        myproc()->queuelevel++;
80105c5f:	e8 3c db ff ff       	call   801037a0 <myproc>
80105c64:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
        myproc()->tickleft = 2 * myproc()->queuelevel + 4;
80105c6b:	e8 30 db ff ff       	call   801037a0 <myproc>
80105c70:	89 c3                	mov    %eax,%ebx
80105c72:	e8 29 db ff ff       	call   801037a0 <myproc>
80105c77:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105c7d:	8d 44 00 04          	lea    0x4(%eax,%eax,1),%eax
80105c81:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
        yield();
80105c87:	e8 b4 e1 ff ff       	call   80103e40 <yield>
80105c8c:	e9 1c fe ff ff       	jmp    80105aad <trap+0xcd>
80105c91:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c94:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c97:	e8 e4 da ff ff       	call   80103780 <cpuid>
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	56                   	push   %esi
80105ca0:	53                   	push   %ebx
80105ca1:	50                   	push   %eax
80105ca2:	ff 77 30             	pushl  0x30(%edi)
80105ca5:	68 14 7a 10 80       	push   $0x80107a14
80105caa:	e8 b1 a9 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105caf:	83 c4 14             	add    $0x14,%esp
80105cb2:	68 ea 79 10 80       	push   $0x801079ea
80105cb7:	e8 b4 a6 ff ff       	call   80100370 <panic>
80105cbc:	66 90                	xchg   %ax,%ax
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105cc0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105cc5:	55                   	push   %ebp
80105cc6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105cc8:	85 c0                	test   %eax,%eax
80105cca:	74 1c                	je     80105ce8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ccc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cd1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105cd2:	a8 01                	test   $0x1,%al
80105cd4:	74 12                	je     80105ce8 <uartgetc+0x28>
80105cd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cdb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cdc:	0f b6 c0             	movzbl %al,%eax
}
80105cdf:	5d                   	pop    %ebp
80105ce0:	c3                   	ret    
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105ced:	5d                   	pop    %ebp
80105cee:	c3                   	ret    
80105cef:	90                   	nop

80105cf0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
80105cf6:	89 c7                	mov    %eax,%edi
80105cf8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cfd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d02:	83 ec 0c             	sub    $0xc,%esp
80105d05:	eb 1b                	jmp    80105d22 <uartputc.part.0+0x32>
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	6a 0a                	push   $0xa
80105d15:	e8 06 ca ff ff       	call   80102720 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	83 eb 01             	sub    $0x1,%ebx
80105d20:	74 07                	je     80105d29 <uartputc.part.0+0x39>
80105d22:	89 f2                	mov    %esi,%edx
80105d24:	ec                   	in     (%dx),%al
80105d25:	a8 20                	test   $0x20,%al
80105d27:	74 e7                	je     80105d10 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d29:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d2e:	89 f8                	mov    %edi,%eax
80105d30:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d34:	5b                   	pop    %ebx
80105d35:	5e                   	pop    %esi
80105d36:	5f                   	pop    %edi
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d40 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105d40:	55                   	push   %ebp
80105d41:	31 c9                	xor    %ecx,%ecx
80105d43:	89 c8                	mov    %ecx,%eax
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	57                   	push   %edi
80105d48:	56                   	push   %esi
80105d49:	53                   	push   %ebx
80105d4a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d4f:	89 da                	mov    %ebx,%edx
80105d51:	83 ec 0c             	sub    $0xc,%esp
80105d54:	ee                   	out    %al,(%dx)
80105d55:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d5f:	89 fa                	mov    %edi,%edx
80105d61:	ee                   	out    %al,(%dx)
80105d62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d6c:	ee                   	out    %al,(%dx)
80105d6d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d72:	89 c8                	mov    %ecx,%eax
80105d74:	89 f2                	mov    %esi,%edx
80105d76:	ee                   	out    %al,(%dx)
80105d77:	b8 03 00 00 00       	mov    $0x3,%eax
80105d7c:	89 fa                	mov    %edi,%edx
80105d7e:	ee                   	out    %al,(%dx)
80105d7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d84:	89 c8                	mov    %ecx,%eax
80105d86:	ee                   	out    %al,(%dx)
80105d87:	b8 01 00 00 00       	mov    $0x1,%eax
80105d8c:	89 f2                	mov    %esi,%edx
80105d8e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d94:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105d95:	3c ff                	cmp    $0xff,%al
80105d97:	74 5a                	je     80105df3 <uartinit+0xb3>
    return;
  uart = 1;
80105d99:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105da0:	00 00 00 
80105da3:	89 da                	mov    %ebx,%edx
80105da5:	ec                   	in     (%dx),%al
80105da6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dab:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105dac:	83 ec 08             	sub    $0x8,%esp
80105daf:	bb 0c 7b 10 80       	mov    $0x80107b0c,%ebx
80105db4:	6a 00                	push   $0x0
80105db6:	6a 04                	push   $0x4
80105db8:	e8 d3 c4 ff ff       	call   80102290 <ioapicenable>
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	b8 78 00 00 00       	mov    $0x78,%eax
80105dc5:	eb 13                	jmp    80105dda <uartinit+0x9a>
80105dc7:	89 f6                	mov    %esi,%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105dd0:	83 c3 01             	add    $0x1,%ebx
80105dd3:	0f be 03             	movsbl (%ebx),%eax
80105dd6:	84 c0                	test   %al,%al
80105dd8:	74 19                	je     80105df3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105dda:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105de0:	85 d2                	test   %edx,%edx
80105de2:	74 ec                	je     80105dd0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105de4:	83 c3 01             	add    $0x1,%ebx
80105de7:	e8 04 ff ff ff       	call   80105cf0 <uartputc.part.0>
80105dec:	0f be 03             	movsbl (%ebx),%eax
80105def:	84 c0                	test   %al,%al
80105df1:	75 e7                	jne    80105dda <uartinit+0x9a>
    uartputc(*p);
}
80105df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df6:	5b                   	pop    %ebx
80105df7:	5e                   	pop    %esi
80105df8:	5f                   	pop    %edi
80105df9:	5d                   	pop    %ebp
80105dfa:	c3                   	ret    
80105dfb:	90                   	nop
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105e00:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e06:	55                   	push   %ebp
80105e07:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105e09:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105e0e:	74 10                	je     80105e20 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105e10:	5d                   	pop    %ebp
80105e11:	e9 da fe ff ff       	jmp    80105cf0 <uartputc.part.0>
80105e16:	8d 76 00             	lea    0x0(%esi),%esi
80105e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e20:	5d                   	pop    %ebp
80105e21:	c3                   	ret    
80105e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e30 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e36:	68 c0 5c 10 80       	push   $0x80105cc0
80105e3b:	e8 b0 a9 ff ff       	call   801007f0 <consoleintr>
}
80105e40:	83 c4 10             	add    $0x10,%esp
80105e43:	c9                   	leave  
80105e44:	c3                   	ret    

80105e45 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $0
80105e47:	6a 00                	push   $0x0
  jmp alltraps
80105e49:	e9 9b fa ff ff       	jmp    801058e9 <alltraps>

80105e4e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $1
80105e50:	6a 01                	push   $0x1
  jmp alltraps
80105e52:	e9 92 fa ff ff       	jmp    801058e9 <alltraps>

80105e57 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $2
80105e59:	6a 02                	push   $0x2
  jmp alltraps
80105e5b:	e9 89 fa ff ff       	jmp    801058e9 <alltraps>

80105e60 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $3
80105e62:	6a 03                	push   $0x3
  jmp alltraps
80105e64:	e9 80 fa ff ff       	jmp    801058e9 <alltraps>

80105e69 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $4
80105e6b:	6a 04                	push   $0x4
  jmp alltraps
80105e6d:	e9 77 fa ff ff       	jmp    801058e9 <alltraps>

80105e72 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $5
80105e74:	6a 05                	push   $0x5
  jmp alltraps
80105e76:	e9 6e fa ff ff       	jmp    801058e9 <alltraps>

80105e7b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $6
80105e7d:	6a 06                	push   $0x6
  jmp alltraps
80105e7f:	e9 65 fa ff ff       	jmp    801058e9 <alltraps>

80105e84 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $7
80105e86:	6a 07                	push   $0x7
  jmp alltraps
80105e88:	e9 5c fa ff ff       	jmp    801058e9 <alltraps>

80105e8d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e8d:	6a 08                	push   $0x8
  jmp alltraps
80105e8f:	e9 55 fa ff ff       	jmp    801058e9 <alltraps>

80105e94 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $9
80105e96:	6a 09                	push   $0x9
  jmp alltraps
80105e98:	e9 4c fa ff ff       	jmp    801058e9 <alltraps>

80105e9d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e9d:	6a 0a                	push   $0xa
  jmp alltraps
80105e9f:	e9 45 fa ff ff       	jmp    801058e9 <alltraps>

80105ea4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ea4:	6a 0b                	push   $0xb
  jmp alltraps
80105ea6:	e9 3e fa ff ff       	jmp    801058e9 <alltraps>

80105eab <vector12>:
.globl vector12
vector12:
  pushl $12
80105eab:	6a 0c                	push   $0xc
  jmp alltraps
80105ead:	e9 37 fa ff ff       	jmp    801058e9 <alltraps>

80105eb2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105eb2:	6a 0d                	push   $0xd
  jmp alltraps
80105eb4:	e9 30 fa ff ff       	jmp    801058e9 <alltraps>

80105eb9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105eb9:	6a 0e                	push   $0xe
  jmp alltraps
80105ebb:	e9 29 fa ff ff       	jmp    801058e9 <alltraps>

80105ec0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $15
80105ec2:	6a 0f                	push   $0xf
  jmp alltraps
80105ec4:	e9 20 fa ff ff       	jmp    801058e9 <alltraps>

80105ec9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $16
80105ecb:	6a 10                	push   $0x10
  jmp alltraps
80105ecd:	e9 17 fa ff ff       	jmp    801058e9 <alltraps>

80105ed2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ed2:	6a 11                	push   $0x11
  jmp alltraps
80105ed4:	e9 10 fa ff ff       	jmp    801058e9 <alltraps>

80105ed9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $18
80105edb:	6a 12                	push   $0x12
  jmp alltraps
80105edd:	e9 07 fa ff ff       	jmp    801058e9 <alltraps>

80105ee2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $19
80105ee4:	6a 13                	push   $0x13
  jmp alltraps
80105ee6:	e9 fe f9 ff ff       	jmp    801058e9 <alltraps>

80105eeb <vector20>:
.globl vector20
vector20:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $20
80105eed:	6a 14                	push   $0x14
  jmp alltraps
80105eef:	e9 f5 f9 ff ff       	jmp    801058e9 <alltraps>

80105ef4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $21
80105ef6:	6a 15                	push   $0x15
  jmp alltraps
80105ef8:	e9 ec f9 ff ff       	jmp    801058e9 <alltraps>

80105efd <vector22>:
.globl vector22
vector22:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $22
80105eff:	6a 16                	push   $0x16
  jmp alltraps
80105f01:	e9 e3 f9 ff ff       	jmp    801058e9 <alltraps>

80105f06 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $23
80105f08:	6a 17                	push   $0x17
  jmp alltraps
80105f0a:	e9 da f9 ff ff       	jmp    801058e9 <alltraps>

80105f0f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $24
80105f11:	6a 18                	push   $0x18
  jmp alltraps
80105f13:	e9 d1 f9 ff ff       	jmp    801058e9 <alltraps>

80105f18 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $25
80105f1a:	6a 19                	push   $0x19
  jmp alltraps
80105f1c:	e9 c8 f9 ff ff       	jmp    801058e9 <alltraps>

80105f21 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $26
80105f23:	6a 1a                	push   $0x1a
  jmp alltraps
80105f25:	e9 bf f9 ff ff       	jmp    801058e9 <alltraps>

80105f2a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $27
80105f2c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f2e:	e9 b6 f9 ff ff       	jmp    801058e9 <alltraps>

80105f33 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $28
80105f35:	6a 1c                	push   $0x1c
  jmp alltraps
80105f37:	e9 ad f9 ff ff       	jmp    801058e9 <alltraps>

80105f3c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $29
80105f3e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f40:	e9 a4 f9 ff ff       	jmp    801058e9 <alltraps>

80105f45 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $30
80105f47:	6a 1e                	push   $0x1e
  jmp alltraps
80105f49:	e9 9b f9 ff ff       	jmp    801058e9 <alltraps>

80105f4e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $31
80105f50:	6a 1f                	push   $0x1f
  jmp alltraps
80105f52:	e9 92 f9 ff ff       	jmp    801058e9 <alltraps>

80105f57 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $32
80105f59:	6a 20                	push   $0x20
  jmp alltraps
80105f5b:	e9 89 f9 ff ff       	jmp    801058e9 <alltraps>

80105f60 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $33
80105f62:	6a 21                	push   $0x21
  jmp alltraps
80105f64:	e9 80 f9 ff ff       	jmp    801058e9 <alltraps>

80105f69 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $34
80105f6b:	6a 22                	push   $0x22
  jmp alltraps
80105f6d:	e9 77 f9 ff ff       	jmp    801058e9 <alltraps>

80105f72 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $35
80105f74:	6a 23                	push   $0x23
  jmp alltraps
80105f76:	e9 6e f9 ff ff       	jmp    801058e9 <alltraps>

80105f7b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $36
80105f7d:	6a 24                	push   $0x24
  jmp alltraps
80105f7f:	e9 65 f9 ff ff       	jmp    801058e9 <alltraps>

80105f84 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $37
80105f86:	6a 25                	push   $0x25
  jmp alltraps
80105f88:	e9 5c f9 ff ff       	jmp    801058e9 <alltraps>

80105f8d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $38
80105f8f:	6a 26                	push   $0x26
  jmp alltraps
80105f91:	e9 53 f9 ff ff       	jmp    801058e9 <alltraps>

80105f96 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $39
80105f98:	6a 27                	push   $0x27
  jmp alltraps
80105f9a:	e9 4a f9 ff ff       	jmp    801058e9 <alltraps>

80105f9f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $40
80105fa1:	6a 28                	push   $0x28
  jmp alltraps
80105fa3:	e9 41 f9 ff ff       	jmp    801058e9 <alltraps>

80105fa8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $41
80105faa:	6a 29                	push   $0x29
  jmp alltraps
80105fac:	e9 38 f9 ff ff       	jmp    801058e9 <alltraps>

80105fb1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $42
80105fb3:	6a 2a                	push   $0x2a
  jmp alltraps
80105fb5:	e9 2f f9 ff ff       	jmp    801058e9 <alltraps>

80105fba <vector43>:
.globl vector43
vector43:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $43
80105fbc:	6a 2b                	push   $0x2b
  jmp alltraps
80105fbe:	e9 26 f9 ff ff       	jmp    801058e9 <alltraps>

80105fc3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $44
80105fc5:	6a 2c                	push   $0x2c
  jmp alltraps
80105fc7:	e9 1d f9 ff ff       	jmp    801058e9 <alltraps>

80105fcc <vector45>:
.globl vector45
vector45:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $45
80105fce:	6a 2d                	push   $0x2d
  jmp alltraps
80105fd0:	e9 14 f9 ff ff       	jmp    801058e9 <alltraps>

80105fd5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $46
80105fd7:	6a 2e                	push   $0x2e
  jmp alltraps
80105fd9:	e9 0b f9 ff ff       	jmp    801058e9 <alltraps>

80105fde <vector47>:
.globl vector47
vector47:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $47
80105fe0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fe2:	e9 02 f9 ff ff       	jmp    801058e9 <alltraps>

80105fe7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $48
80105fe9:	6a 30                	push   $0x30
  jmp alltraps
80105feb:	e9 f9 f8 ff ff       	jmp    801058e9 <alltraps>

80105ff0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $49
80105ff2:	6a 31                	push   $0x31
  jmp alltraps
80105ff4:	e9 f0 f8 ff ff       	jmp    801058e9 <alltraps>

80105ff9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $50
80105ffb:	6a 32                	push   $0x32
  jmp alltraps
80105ffd:	e9 e7 f8 ff ff       	jmp    801058e9 <alltraps>

80106002 <vector51>:
.globl vector51
vector51:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $51
80106004:	6a 33                	push   $0x33
  jmp alltraps
80106006:	e9 de f8 ff ff       	jmp    801058e9 <alltraps>

8010600b <vector52>:
.globl vector52
vector52:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $52
8010600d:	6a 34                	push   $0x34
  jmp alltraps
8010600f:	e9 d5 f8 ff ff       	jmp    801058e9 <alltraps>

80106014 <vector53>:
.globl vector53
vector53:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $53
80106016:	6a 35                	push   $0x35
  jmp alltraps
80106018:	e9 cc f8 ff ff       	jmp    801058e9 <alltraps>

8010601d <vector54>:
.globl vector54
vector54:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $54
8010601f:	6a 36                	push   $0x36
  jmp alltraps
80106021:	e9 c3 f8 ff ff       	jmp    801058e9 <alltraps>

80106026 <vector55>:
.globl vector55
vector55:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $55
80106028:	6a 37                	push   $0x37
  jmp alltraps
8010602a:	e9 ba f8 ff ff       	jmp    801058e9 <alltraps>

8010602f <vector56>:
.globl vector56
vector56:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $56
80106031:	6a 38                	push   $0x38
  jmp alltraps
80106033:	e9 b1 f8 ff ff       	jmp    801058e9 <alltraps>

80106038 <vector57>:
.globl vector57
vector57:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $57
8010603a:	6a 39                	push   $0x39
  jmp alltraps
8010603c:	e9 a8 f8 ff ff       	jmp    801058e9 <alltraps>

80106041 <vector58>:
.globl vector58
vector58:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $58
80106043:	6a 3a                	push   $0x3a
  jmp alltraps
80106045:	e9 9f f8 ff ff       	jmp    801058e9 <alltraps>

8010604a <vector59>:
.globl vector59
vector59:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $59
8010604c:	6a 3b                	push   $0x3b
  jmp alltraps
8010604e:	e9 96 f8 ff ff       	jmp    801058e9 <alltraps>

80106053 <vector60>:
.globl vector60
vector60:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $60
80106055:	6a 3c                	push   $0x3c
  jmp alltraps
80106057:	e9 8d f8 ff ff       	jmp    801058e9 <alltraps>

8010605c <vector61>:
.globl vector61
vector61:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $61
8010605e:	6a 3d                	push   $0x3d
  jmp alltraps
80106060:	e9 84 f8 ff ff       	jmp    801058e9 <alltraps>

80106065 <vector62>:
.globl vector62
vector62:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $62
80106067:	6a 3e                	push   $0x3e
  jmp alltraps
80106069:	e9 7b f8 ff ff       	jmp    801058e9 <alltraps>

8010606e <vector63>:
.globl vector63
vector63:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $63
80106070:	6a 3f                	push   $0x3f
  jmp alltraps
80106072:	e9 72 f8 ff ff       	jmp    801058e9 <alltraps>

80106077 <vector64>:
.globl vector64
vector64:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $64
80106079:	6a 40                	push   $0x40
  jmp alltraps
8010607b:	e9 69 f8 ff ff       	jmp    801058e9 <alltraps>

80106080 <vector65>:
.globl vector65
vector65:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $65
80106082:	6a 41                	push   $0x41
  jmp alltraps
80106084:	e9 60 f8 ff ff       	jmp    801058e9 <alltraps>

80106089 <vector66>:
.globl vector66
vector66:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $66
8010608b:	6a 42                	push   $0x42
  jmp alltraps
8010608d:	e9 57 f8 ff ff       	jmp    801058e9 <alltraps>

80106092 <vector67>:
.globl vector67
vector67:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $67
80106094:	6a 43                	push   $0x43
  jmp alltraps
80106096:	e9 4e f8 ff ff       	jmp    801058e9 <alltraps>

8010609b <vector68>:
.globl vector68
vector68:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $68
8010609d:	6a 44                	push   $0x44
  jmp alltraps
8010609f:	e9 45 f8 ff ff       	jmp    801058e9 <alltraps>

801060a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $69
801060a6:	6a 45                	push   $0x45
  jmp alltraps
801060a8:	e9 3c f8 ff ff       	jmp    801058e9 <alltraps>

801060ad <vector70>:
.globl vector70
vector70:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $70
801060af:	6a 46                	push   $0x46
  jmp alltraps
801060b1:	e9 33 f8 ff ff       	jmp    801058e9 <alltraps>

801060b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $71
801060b8:	6a 47                	push   $0x47
  jmp alltraps
801060ba:	e9 2a f8 ff ff       	jmp    801058e9 <alltraps>

801060bf <vector72>:
.globl vector72
vector72:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $72
801060c1:	6a 48                	push   $0x48
  jmp alltraps
801060c3:	e9 21 f8 ff ff       	jmp    801058e9 <alltraps>

801060c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $73
801060ca:	6a 49                	push   $0x49
  jmp alltraps
801060cc:	e9 18 f8 ff ff       	jmp    801058e9 <alltraps>

801060d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $74
801060d3:	6a 4a                	push   $0x4a
  jmp alltraps
801060d5:	e9 0f f8 ff ff       	jmp    801058e9 <alltraps>

801060da <vector75>:
.globl vector75
vector75:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $75
801060dc:	6a 4b                	push   $0x4b
  jmp alltraps
801060de:	e9 06 f8 ff ff       	jmp    801058e9 <alltraps>

801060e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $76
801060e5:	6a 4c                	push   $0x4c
  jmp alltraps
801060e7:	e9 fd f7 ff ff       	jmp    801058e9 <alltraps>

801060ec <vector77>:
.globl vector77
vector77:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $77
801060ee:	6a 4d                	push   $0x4d
  jmp alltraps
801060f0:	e9 f4 f7 ff ff       	jmp    801058e9 <alltraps>

801060f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $78
801060f7:	6a 4e                	push   $0x4e
  jmp alltraps
801060f9:	e9 eb f7 ff ff       	jmp    801058e9 <alltraps>

801060fe <vector79>:
.globl vector79
vector79:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $79
80106100:	6a 4f                	push   $0x4f
  jmp alltraps
80106102:	e9 e2 f7 ff ff       	jmp    801058e9 <alltraps>

80106107 <vector80>:
.globl vector80
vector80:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $80
80106109:	6a 50                	push   $0x50
  jmp alltraps
8010610b:	e9 d9 f7 ff ff       	jmp    801058e9 <alltraps>

80106110 <vector81>:
.globl vector81
vector81:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $81
80106112:	6a 51                	push   $0x51
  jmp alltraps
80106114:	e9 d0 f7 ff ff       	jmp    801058e9 <alltraps>

80106119 <vector82>:
.globl vector82
vector82:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $82
8010611b:	6a 52                	push   $0x52
  jmp alltraps
8010611d:	e9 c7 f7 ff ff       	jmp    801058e9 <alltraps>

80106122 <vector83>:
.globl vector83
vector83:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $83
80106124:	6a 53                	push   $0x53
  jmp alltraps
80106126:	e9 be f7 ff ff       	jmp    801058e9 <alltraps>

8010612b <vector84>:
.globl vector84
vector84:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $84
8010612d:	6a 54                	push   $0x54
  jmp alltraps
8010612f:	e9 b5 f7 ff ff       	jmp    801058e9 <alltraps>

80106134 <vector85>:
.globl vector85
vector85:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $85
80106136:	6a 55                	push   $0x55
  jmp alltraps
80106138:	e9 ac f7 ff ff       	jmp    801058e9 <alltraps>

8010613d <vector86>:
.globl vector86
vector86:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $86
8010613f:	6a 56                	push   $0x56
  jmp alltraps
80106141:	e9 a3 f7 ff ff       	jmp    801058e9 <alltraps>

80106146 <vector87>:
.globl vector87
vector87:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $87
80106148:	6a 57                	push   $0x57
  jmp alltraps
8010614a:	e9 9a f7 ff ff       	jmp    801058e9 <alltraps>

8010614f <vector88>:
.globl vector88
vector88:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $88
80106151:	6a 58                	push   $0x58
  jmp alltraps
80106153:	e9 91 f7 ff ff       	jmp    801058e9 <alltraps>

80106158 <vector89>:
.globl vector89
vector89:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $89
8010615a:	6a 59                	push   $0x59
  jmp alltraps
8010615c:	e9 88 f7 ff ff       	jmp    801058e9 <alltraps>

80106161 <vector90>:
.globl vector90
vector90:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $90
80106163:	6a 5a                	push   $0x5a
  jmp alltraps
80106165:	e9 7f f7 ff ff       	jmp    801058e9 <alltraps>

8010616a <vector91>:
.globl vector91
vector91:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $91
8010616c:	6a 5b                	push   $0x5b
  jmp alltraps
8010616e:	e9 76 f7 ff ff       	jmp    801058e9 <alltraps>

80106173 <vector92>:
.globl vector92
vector92:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $92
80106175:	6a 5c                	push   $0x5c
  jmp alltraps
80106177:	e9 6d f7 ff ff       	jmp    801058e9 <alltraps>

8010617c <vector93>:
.globl vector93
vector93:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $93
8010617e:	6a 5d                	push   $0x5d
  jmp alltraps
80106180:	e9 64 f7 ff ff       	jmp    801058e9 <alltraps>

80106185 <vector94>:
.globl vector94
vector94:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $94
80106187:	6a 5e                	push   $0x5e
  jmp alltraps
80106189:	e9 5b f7 ff ff       	jmp    801058e9 <alltraps>

8010618e <vector95>:
.globl vector95
vector95:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $95
80106190:	6a 5f                	push   $0x5f
  jmp alltraps
80106192:	e9 52 f7 ff ff       	jmp    801058e9 <alltraps>

80106197 <vector96>:
.globl vector96
vector96:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $96
80106199:	6a 60                	push   $0x60
  jmp alltraps
8010619b:	e9 49 f7 ff ff       	jmp    801058e9 <alltraps>

801061a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $97
801061a2:	6a 61                	push   $0x61
  jmp alltraps
801061a4:	e9 40 f7 ff ff       	jmp    801058e9 <alltraps>

801061a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $98
801061ab:	6a 62                	push   $0x62
  jmp alltraps
801061ad:	e9 37 f7 ff ff       	jmp    801058e9 <alltraps>

801061b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $99
801061b4:	6a 63                	push   $0x63
  jmp alltraps
801061b6:	e9 2e f7 ff ff       	jmp    801058e9 <alltraps>

801061bb <vector100>:
.globl vector100
vector100:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $100
801061bd:	6a 64                	push   $0x64
  jmp alltraps
801061bf:	e9 25 f7 ff ff       	jmp    801058e9 <alltraps>

801061c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $101
801061c6:	6a 65                	push   $0x65
  jmp alltraps
801061c8:	e9 1c f7 ff ff       	jmp    801058e9 <alltraps>

801061cd <vector102>:
.globl vector102
vector102:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $102
801061cf:	6a 66                	push   $0x66
  jmp alltraps
801061d1:	e9 13 f7 ff ff       	jmp    801058e9 <alltraps>

801061d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $103
801061d8:	6a 67                	push   $0x67
  jmp alltraps
801061da:	e9 0a f7 ff ff       	jmp    801058e9 <alltraps>

801061df <vector104>:
.globl vector104
vector104:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $104
801061e1:	6a 68                	push   $0x68
  jmp alltraps
801061e3:	e9 01 f7 ff ff       	jmp    801058e9 <alltraps>

801061e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $105
801061ea:	6a 69                	push   $0x69
  jmp alltraps
801061ec:	e9 f8 f6 ff ff       	jmp    801058e9 <alltraps>

801061f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $106
801061f3:	6a 6a                	push   $0x6a
  jmp alltraps
801061f5:	e9 ef f6 ff ff       	jmp    801058e9 <alltraps>

801061fa <vector107>:
.globl vector107
vector107:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $107
801061fc:	6a 6b                	push   $0x6b
  jmp alltraps
801061fe:	e9 e6 f6 ff ff       	jmp    801058e9 <alltraps>

80106203 <vector108>:
.globl vector108
vector108:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $108
80106205:	6a 6c                	push   $0x6c
  jmp alltraps
80106207:	e9 dd f6 ff ff       	jmp    801058e9 <alltraps>

8010620c <vector109>:
.globl vector109
vector109:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $109
8010620e:	6a 6d                	push   $0x6d
  jmp alltraps
80106210:	e9 d4 f6 ff ff       	jmp    801058e9 <alltraps>

80106215 <vector110>:
.globl vector110
vector110:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $110
80106217:	6a 6e                	push   $0x6e
  jmp alltraps
80106219:	e9 cb f6 ff ff       	jmp    801058e9 <alltraps>

8010621e <vector111>:
.globl vector111
vector111:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $111
80106220:	6a 6f                	push   $0x6f
  jmp alltraps
80106222:	e9 c2 f6 ff ff       	jmp    801058e9 <alltraps>

80106227 <vector112>:
.globl vector112
vector112:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $112
80106229:	6a 70                	push   $0x70
  jmp alltraps
8010622b:	e9 b9 f6 ff ff       	jmp    801058e9 <alltraps>

80106230 <vector113>:
.globl vector113
vector113:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $113
80106232:	6a 71                	push   $0x71
  jmp alltraps
80106234:	e9 b0 f6 ff ff       	jmp    801058e9 <alltraps>

80106239 <vector114>:
.globl vector114
vector114:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $114
8010623b:	6a 72                	push   $0x72
  jmp alltraps
8010623d:	e9 a7 f6 ff ff       	jmp    801058e9 <alltraps>

80106242 <vector115>:
.globl vector115
vector115:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $115
80106244:	6a 73                	push   $0x73
  jmp alltraps
80106246:	e9 9e f6 ff ff       	jmp    801058e9 <alltraps>

8010624b <vector116>:
.globl vector116
vector116:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $116
8010624d:	6a 74                	push   $0x74
  jmp alltraps
8010624f:	e9 95 f6 ff ff       	jmp    801058e9 <alltraps>

80106254 <vector117>:
.globl vector117
vector117:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $117
80106256:	6a 75                	push   $0x75
  jmp alltraps
80106258:	e9 8c f6 ff ff       	jmp    801058e9 <alltraps>

8010625d <vector118>:
.globl vector118
vector118:
  pushl $0
8010625d:	6a 00                	push   $0x0
  pushl $118
8010625f:	6a 76                	push   $0x76
  jmp alltraps
80106261:	e9 83 f6 ff ff       	jmp    801058e9 <alltraps>

80106266 <vector119>:
.globl vector119
vector119:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $119
80106268:	6a 77                	push   $0x77
  jmp alltraps
8010626a:	e9 7a f6 ff ff       	jmp    801058e9 <alltraps>

8010626f <vector120>:
.globl vector120
vector120:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $120
80106271:	6a 78                	push   $0x78
  jmp alltraps
80106273:	e9 71 f6 ff ff       	jmp    801058e9 <alltraps>

80106278 <vector121>:
.globl vector121
vector121:
  pushl $0
80106278:	6a 00                	push   $0x0
  pushl $121
8010627a:	6a 79                	push   $0x79
  jmp alltraps
8010627c:	e9 68 f6 ff ff       	jmp    801058e9 <alltraps>

80106281 <vector122>:
.globl vector122
vector122:
  pushl $0
80106281:	6a 00                	push   $0x0
  pushl $122
80106283:	6a 7a                	push   $0x7a
  jmp alltraps
80106285:	e9 5f f6 ff ff       	jmp    801058e9 <alltraps>

8010628a <vector123>:
.globl vector123
vector123:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $123
8010628c:	6a 7b                	push   $0x7b
  jmp alltraps
8010628e:	e9 56 f6 ff ff       	jmp    801058e9 <alltraps>

80106293 <vector124>:
.globl vector124
vector124:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $124
80106295:	6a 7c                	push   $0x7c
  jmp alltraps
80106297:	e9 4d f6 ff ff       	jmp    801058e9 <alltraps>

8010629c <vector125>:
.globl vector125
vector125:
  pushl $0
8010629c:	6a 00                	push   $0x0
  pushl $125
8010629e:	6a 7d                	push   $0x7d
  jmp alltraps
801062a0:	e9 44 f6 ff ff       	jmp    801058e9 <alltraps>

801062a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $126
801062a7:	6a 7e                	push   $0x7e
  jmp alltraps
801062a9:	e9 3b f6 ff ff       	jmp    801058e9 <alltraps>

801062ae <vector127>:
.globl vector127
vector127:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $127
801062b0:	6a 7f                	push   $0x7f
  jmp alltraps
801062b2:	e9 32 f6 ff ff       	jmp    801058e9 <alltraps>

801062b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $128
801062b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801062be:	e9 26 f6 ff ff       	jmp    801058e9 <alltraps>

801062c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $129
801062c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062ca:	e9 1a f6 ff ff       	jmp    801058e9 <alltraps>

801062cf <vector130>:
.globl vector130
vector130:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $130
801062d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062d6:	e9 0e f6 ff ff       	jmp    801058e9 <alltraps>

801062db <vector131>:
.globl vector131
vector131:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $131
801062dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062e2:	e9 02 f6 ff ff       	jmp    801058e9 <alltraps>

801062e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $132
801062e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062ee:	e9 f6 f5 ff ff       	jmp    801058e9 <alltraps>

801062f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $133
801062f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062fa:	e9 ea f5 ff ff       	jmp    801058e9 <alltraps>

801062ff <vector134>:
.globl vector134
vector134:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $134
80106301:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106306:	e9 de f5 ff ff       	jmp    801058e9 <alltraps>

8010630b <vector135>:
.globl vector135
vector135:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $135
8010630d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106312:	e9 d2 f5 ff ff       	jmp    801058e9 <alltraps>

80106317 <vector136>:
.globl vector136
vector136:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $136
80106319:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010631e:	e9 c6 f5 ff ff       	jmp    801058e9 <alltraps>

80106323 <vector137>:
.globl vector137
vector137:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $137
80106325:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010632a:	e9 ba f5 ff ff       	jmp    801058e9 <alltraps>

8010632f <vector138>:
.globl vector138
vector138:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $138
80106331:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106336:	e9 ae f5 ff ff       	jmp    801058e9 <alltraps>

8010633b <vector139>:
.globl vector139
vector139:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $139
8010633d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106342:	e9 a2 f5 ff ff       	jmp    801058e9 <alltraps>

80106347 <vector140>:
.globl vector140
vector140:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $140
80106349:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010634e:	e9 96 f5 ff ff       	jmp    801058e9 <alltraps>

80106353 <vector141>:
.globl vector141
vector141:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $141
80106355:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010635a:	e9 8a f5 ff ff       	jmp    801058e9 <alltraps>

8010635f <vector142>:
.globl vector142
vector142:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $142
80106361:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106366:	e9 7e f5 ff ff       	jmp    801058e9 <alltraps>

8010636b <vector143>:
.globl vector143
vector143:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $143
8010636d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106372:	e9 72 f5 ff ff       	jmp    801058e9 <alltraps>

80106377 <vector144>:
.globl vector144
vector144:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $144
80106379:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010637e:	e9 66 f5 ff ff       	jmp    801058e9 <alltraps>

80106383 <vector145>:
.globl vector145
vector145:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $145
80106385:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010638a:	e9 5a f5 ff ff       	jmp    801058e9 <alltraps>

8010638f <vector146>:
.globl vector146
vector146:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $146
80106391:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106396:	e9 4e f5 ff ff       	jmp    801058e9 <alltraps>

8010639b <vector147>:
.globl vector147
vector147:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $147
8010639d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801063a2:	e9 42 f5 ff ff       	jmp    801058e9 <alltraps>

801063a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $148
801063a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801063ae:	e9 36 f5 ff ff       	jmp    801058e9 <alltraps>

801063b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $149
801063b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801063ba:	e9 2a f5 ff ff       	jmp    801058e9 <alltraps>

801063bf <vector150>:
.globl vector150
vector150:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $150
801063c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063c6:	e9 1e f5 ff ff       	jmp    801058e9 <alltraps>

801063cb <vector151>:
.globl vector151
vector151:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $151
801063cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063d2:	e9 12 f5 ff ff       	jmp    801058e9 <alltraps>

801063d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $152
801063d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063de:	e9 06 f5 ff ff       	jmp    801058e9 <alltraps>

801063e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $153
801063e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063ea:	e9 fa f4 ff ff       	jmp    801058e9 <alltraps>

801063ef <vector154>:
.globl vector154
vector154:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $154
801063f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063f6:	e9 ee f4 ff ff       	jmp    801058e9 <alltraps>

801063fb <vector155>:
.globl vector155
vector155:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $155
801063fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106402:	e9 e2 f4 ff ff       	jmp    801058e9 <alltraps>

80106407 <vector156>:
.globl vector156
vector156:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $156
80106409:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010640e:	e9 d6 f4 ff ff       	jmp    801058e9 <alltraps>

80106413 <vector157>:
.globl vector157
vector157:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $157
80106415:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010641a:	e9 ca f4 ff ff       	jmp    801058e9 <alltraps>

8010641f <vector158>:
.globl vector158
vector158:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $158
80106421:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106426:	e9 be f4 ff ff       	jmp    801058e9 <alltraps>

8010642b <vector159>:
.globl vector159
vector159:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $159
8010642d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106432:	e9 b2 f4 ff ff       	jmp    801058e9 <alltraps>

80106437 <vector160>:
.globl vector160
vector160:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $160
80106439:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010643e:	e9 a6 f4 ff ff       	jmp    801058e9 <alltraps>

80106443 <vector161>:
.globl vector161
vector161:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $161
80106445:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010644a:	e9 9a f4 ff ff       	jmp    801058e9 <alltraps>

8010644f <vector162>:
.globl vector162
vector162:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $162
80106451:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106456:	e9 8e f4 ff ff       	jmp    801058e9 <alltraps>

8010645b <vector163>:
.globl vector163
vector163:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $163
8010645d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106462:	e9 82 f4 ff ff       	jmp    801058e9 <alltraps>

80106467 <vector164>:
.globl vector164
vector164:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $164
80106469:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010646e:	e9 76 f4 ff ff       	jmp    801058e9 <alltraps>

80106473 <vector165>:
.globl vector165
vector165:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $165
80106475:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010647a:	e9 6a f4 ff ff       	jmp    801058e9 <alltraps>

8010647f <vector166>:
.globl vector166
vector166:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $166
80106481:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106486:	e9 5e f4 ff ff       	jmp    801058e9 <alltraps>

8010648b <vector167>:
.globl vector167
vector167:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $167
8010648d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106492:	e9 52 f4 ff ff       	jmp    801058e9 <alltraps>

80106497 <vector168>:
.globl vector168
vector168:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $168
80106499:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010649e:	e9 46 f4 ff ff       	jmp    801058e9 <alltraps>

801064a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $169
801064a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801064aa:	e9 3a f4 ff ff       	jmp    801058e9 <alltraps>

801064af <vector170>:
.globl vector170
vector170:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $170
801064b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801064b6:	e9 2e f4 ff ff       	jmp    801058e9 <alltraps>

801064bb <vector171>:
.globl vector171
vector171:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $171
801064bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064c2:	e9 22 f4 ff ff       	jmp    801058e9 <alltraps>

801064c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $172
801064c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064ce:	e9 16 f4 ff ff       	jmp    801058e9 <alltraps>

801064d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $173
801064d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064da:	e9 0a f4 ff ff       	jmp    801058e9 <alltraps>

801064df <vector174>:
.globl vector174
vector174:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $174
801064e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064e6:	e9 fe f3 ff ff       	jmp    801058e9 <alltraps>

801064eb <vector175>:
.globl vector175
vector175:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $175
801064ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064f2:	e9 f2 f3 ff ff       	jmp    801058e9 <alltraps>

801064f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $176
801064f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064fe:	e9 e6 f3 ff ff       	jmp    801058e9 <alltraps>

80106503 <vector177>:
.globl vector177
vector177:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $177
80106505:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010650a:	e9 da f3 ff ff       	jmp    801058e9 <alltraps>

8010650f <vector178>:
.globl vector178
vector178:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $178
80106511:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106516:	e9 ce f3 ff ff       	jmp    801058e9 <alltraps>

8010651b <vector179>:
.globl vector179
vector179:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $179
8010651d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106522:	e9 c2 f3 ff ff       	jmp    801058e9 <alltraps>

80106527 <vector180>:
.globl vector180
vector180:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $180
80106529:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010652e:	e9 b6 f3 ff ff       	jmp    801058e9 <alltraps>

80106533 <vector181>:
.globl vector181
vector181:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $181
80106535:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010653a:	e9 aa f3 ff ff       	jmp    801058e9 <alltraps>

8010653f <vector182>:
.globl vector182
vector182:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $182
80106541:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106546:	e9 9e f3 ff ff       	jmp    801058e9 <alltraps>

8010654b <vector183>:
.globl vector183
vector183:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $183
8010654d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106552:	e9 92 f3 ff ff       	jmp    801058e9 <alltraps>

80106557 <vector184>:
.globl vector184
vector184:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $184
80106559:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010655e:	e9 86 f3 ff ff       	jmp    801058e9 <alltraps>

80106563 <vector185>:
.globl vector185
vector185:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $185
80106565:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010656a:	e9 7a f3 ff ff       	jmp    801058e9 <alltraps>

8010656f <vector186>:
.globl vector186
vector186:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $186
80106571:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106576:	e9 6e f3 ff ff       	jmp    801058e9 <alltraps>

8010657b <vector187>:
.globl vector187
vector187:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $187
8010657d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106582:	e9 62 f3 ff ff       	jmp    801058e9 <alltraps>

80106587 <vector188>:
.globl vector188
vector188:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $188
80106589:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010658e:	e9 56 f3 ff ff       	jmp    801058e9 <alltraps>

80106593 <vector189>:
.globl vector189
vector189:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $189
80106595:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010659a:	e9 4a f3 ff ff       	jmp    801058e9 <alltraps>

8010659f <vector190>:
.globl vector190
vector190:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $190
801065a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801065a6:	e9 3e f3 ff ff       	jmp    801058e9 <alltraps>

801065ab <vector191>:
.globl vector191
vector191:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $191
801065ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801065b2:	e9 32 f3 ff ff       	jmp    801058e9 <alltraps>

801065b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $192
801065b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801065be:	e9 26 f3 ff ff       	jmp    801058e9 <alltraps>

801065c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $193
801065c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065ca:	e9 1a f3 ff ff       	jmp    801058e9 <alltraps>

801065cf <vector194>:
.globl vector194
vector194:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $194
801065d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065d6:	e9 0e f3 ff ff       	jmp    801058e9 <alltraps>

801065db <vector195>:
.globl vector195
vector195:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $195
801065dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065e2:	e9 02 f3 ff ff       	jmp    801058e9 <alltraps>

801065e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $196
801065e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065ee:	e9 f6 f2 ff ff       	jmp    801058e9 <alltraps>

801065f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $197
801065f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065fa:	e9 ea f2 ff ff       	jmp    801058e9 <alltraps>

801065ff <vector198>:
.globl vector198
vector198:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $198
80106601:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106606:	e9 de f2 ff ff       	jmp    801058e9 <alltraps>

8010660b <vector199>:
.globl vector199
vector199:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $199
8010660d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106612:	e9 d2 f2 ff ff       	jmp    801058e9 <alltraps>

80106617 <vector200>:
.globl vector200
vector200:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $200
80106619:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010661e:	e9 c6 f2 ff ff       	jmp    801058e9 <alltraps>

80106623 <vector201>:
.globl vector201
vector201:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $201
80106625:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010662a:	e9 ba f2 ff ff       	jmp    801058e9 <alltraps>

8010662f <vector202>:
.globl vector202
vector202:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $202
80106631:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106636:	e9 ae f2 ff ff       	jmp    801058e9 <alltraps>

8010663b <vector203>:
.globl vector203
vector203:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $203
8010663d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106642:	e9 a2 f2 ff ff       	jmp    801058e9 <alltraps>

80106647 <vector204>:
.globl vector204
vector204:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $204
80106649:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010664e:	e9 96 f2 ff ff       	jmp    801058e9 <alltraps>

80106653 <vector205>:
.globl vector205
vector205:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $205
80106655:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010665a:	e9 8a f2 ff ff       	jmp    801058e9 <alltraps>

8010665f <vector206>:
.globl vector206
vector206:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $206
80106661:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106666:	e9 7e f2 ff ff       	jmp    801058e9 <alltraps>

8010666b <vector207>:
.globl vector207
vector207:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $207
8010666d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106672:	e9 72 f2 ff ff       	jmp    801058e9 <alltraps>

80106677 <vector208>:
.globl vector208
vector208:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $208
80106679:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010667e:	e9 66 f2 ff ff       	jmp    801058e9 <alltraps>

80106683 <vector209>:
.globl vector209
vector209:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $209
80106685:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010668a:	e9 5a f2 ff ff       	jmp    801058e9 <alltraps>

8010668f <vector210>:
.globl vector210
vector210:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $210
80106691:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106696:	e9 4e f2 ff ff       	jmp    801058e9 <alltraps>

8010669b <vector211>:
.globl vector211
vector211:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $211
8010669d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801066a2:	e9 42 f2 ff ff       	jmp    801058e9 <alltraps>

801066a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $212
801066a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801066ae:	e9 36 f2 ff ff       	jmp    801058e9 <alltraps>

801066b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $213
801066b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801066ba:	e9 2a f2 ff ff       	jmp    801058e9 <alltraps>

801066bf <vector214>:
.globl vector214
vector214:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $214
801066c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066c6:	e9 1e f2 ff ff       	jmp    801058e9 <alltraps>

801066cb <vector215>:
.globl vector215
vector215:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $215
801066cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066d2:	e9 12 f2 ff ff       	jmp    801058e9 <alltraps>

801066d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $216
801066d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066de:	e9 06 f2 ff ff       	jmp    801058e9 <alltraps>

801066e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $217
801066e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066ea:	e9 fa f1 ff ff       	jmp    801058e9 <alltraps>

801066ef <vector218>:
.globl vector218
vector218:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $218
801066f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066f6:	e9 ee f1 ff ff       	jmp    801058e9 <alltraps>

801066fb <vector219>:
.globl vector219
vector219:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $219
801066fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106702:	e9 e2 f1 ff ff       	jmp    801058e9 <alltraps>

80106707 <vector220>:
.globl vector220
vector220:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $220
80106709:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010670e:	e9 d6 f1 ff ff       	jmp    801058e9 <alltraps>

80106713 <vector221>:
.globl vector221
vector221:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $221
80106715:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010671a:	e9 ca f1 ff ff       	jmp    801058e9 <alltraps>

8010671f <vector222>:
.globl vector222
vector222:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $222
80106721:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106726:	e9 be f1 ff ff       	jmp    801058e9 <alltraps>

8010672b <vector223>:
.globl vector223
vector223:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $223
8010672d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106732:	e9 b2 f1 ff ff       	jmp    801058e9 <alltraps>

80106737 <vector224>:
.globl vector224
vector224:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $224
80106739:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010673e:	e9 a6 f1 ff ff       	jmp    801058e9 <alltraps>

80106743 <vector225>:
.globl vector225
vector225:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $225
80106745:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010674a:	e9 9a f1 ff ff       	jmp    801058e9 <alltraps>

8010674f <vector226>:
.globl vector226
vector226:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $226
80106751:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106756:	e9 8e f1 ff ff       	jmp    801058e9 <alltraps>

8010675b <vector227>:
.globl vector227
vector227:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $227
8010675d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106762:	e9 82 f1 ff ff       	jmp    801058e9 <alltraps>

80106767 <vector228>:
.globl vector228
vector228:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $228
80106769:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010676e:	e9 76 f1 ff ff       	jmp    801058e9 <alltraps>

80106773 <vector229>:
.globl vector229
vector229:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $229
80106775:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010677a:	e9 6a f1 ff ff       	jmp    801058e9 <alltraps>

8010677f <vector230>:
.globl vector230
vector230:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $230
80106781:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106786:	e9 5e f1 ff ff       	jmp    801058e9 <alltraps>

8010678b <vector231>:
.globl vector231
vector231:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $231
8010678d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106792:	e9 52 f1 ff ff       	jmp    801058e9 <alltraps>

80106797 <vector232>:
.globl vector232
vector232:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $232
80106799:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010679e:	e9 46 f1 ff ff       	jmp    801058e9 <alltraps>

801067a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $233
801067a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801067aa:	e9 3a f1 ff ff       	jmp    801058e9 <alltraps>

801067af <vector234>:
.globl vector234
vector234:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $234
801067b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801067b6:	e9 2e f1 ff ff       	jmp    801058e9 <alltraps>

801067bb <vector235>:
.globl vector235
vector235:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $235
801067bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067c2:	e9 22 f1 ff ff       	jmp    801058e9 <alltraps>

801067c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $236
801067c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067ce:	e9 16 f1 ff ff       	jmp    801058e9 <alltraps>

801067d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $237
801067d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067da:	e9 0a f1 ff ff       	jmp    801058e9 <alltraps>

801067df <vector238>:
.globl vector238
vector238:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $238
801067e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067e6:	e9 fe f0 ff ff       	jmp    801058e9 <alltraps>

801067eb <vector239>:
.globl vector239
vector239:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $239
801067ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067f2:	e9 f2 f0 ff ff       	jmp    801058e9 <alltraps>

801067f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $240
801067f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067fe:	e9 e6 f0 ff ff       	jmp    801058e9 <alltraps>

80106803 <vector241>:
.globl vector241
vector241:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $241
80106805:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010680a:	e9 da f0 ff ff       	jmp    801058e9 <alltraps>

8010680f <vector242>:
.globl vector242
vector242:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $242
80106811:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106816:	e9 ce f0 ff ff       	jmp    801058e9 <alltraps>

8010681b <vector243>:
.globl vector243
vector243:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $243
8010681d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106822:	e9 c2 f0 ff ff       	jmp    801058e9 <alltraps>

80106827 <vector244>:
.globl vector244
vector244:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $244
80106829:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010682e:	e9 b6 f0 ff ff       	jmp    801058e9 <alltraps>

80106833 <vector245>:
.globl vector245
vector245:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $245
80106835:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010683a:	e9 aa f0 ff ff       	jmp    801058e9 <alltraps>

8010683f <vector246>:
.globl vector246
vector246:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $246
80106841:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106846:	e9 9e f0 ff ff       	jmp    801058e9 <alltraps>

8010684b <vector247>:
.globl vector247
vector247:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $247
8010684d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106852:	e9 92 f0 ff ff       	jmp    801058e9 <alltraps>

80106857 <vector248>:
.globl vector248
vector248:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $248
80106859:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010685e:	e9 86 f0 ff ff       	jmp    801058e9 <alltraps>

80106863 <vector249>:
.globl vector249
vector249:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $249
80106865:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010686a:	e9 7a f0 ff ff       	jmp    801058e9 <alltraps>

8010686f <vector250>:
.globl vector250
vector250:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $250
80106871:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106876:	e9 6e f0 ff ff       	jmp    801058e9 <alltraps>

8010687b <vector251>:
.globl vector251
vector251:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $251
8010687d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106882:	e9 62 f0 ff ff       	jmp    801058e9 <alltraps>

80106887 <vector252>:
.globl vector252
vector252:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $252
80106889:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010688e:	e9 56 f0 ff ff       	jmp    801058e9 <alltraps>

80106893 <vector253>:
.globl vector253
vector253:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $253
80106895:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010689a:	e9 4a f0 ff ff       	jmp    801058e9 <alltraps>

8010689f <vector254>:
.globl vector254
vector254:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $254
801068a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801068a6:	e9 3e f0 ff ff       	jmp    801058e9 <alltraps>

801068ab <vector255>:
.globl vector255
vector255:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $255
801068ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801068b2:	e9 32 f0 ff ff       	jmp    801058e9 <alltraps>
801068b7:	66 90                	xchg   %ax,%ax
801068b9:	66 90                	xchg   %ax,%ax
801068bb:	66 90                	xchg   %ax,%ax
801068bd:	66 90                	xchg   %ax,%ax
801068bf:	90                   	nop

801068c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	57                   	push   %edi
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801068c8:	c1 ea 16             	shr    $0x16,%edx
801068cb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801068ce:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801068d1:	8b 07                	mov    (%edi),%eax
801068d3:	a8 01                	test   $0x1,%al
801068d5:	74 29                	je     80106900 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068dc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801068e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068e5:	c1 eb 0a             	shr    $0xa,%ebx
801068e8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
801068ee:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801068f1:	5b                   	pop    %ebx
801068f2:	5e                   	pop    %esi
801068f3:	5f                   	pop    %edi
801068f4:	5d                   	pop    %ebp
801068f5:	c3                   	ret    
801068f6:	8d 76 00             	lea    0x0(%esi),%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106900:	85 c9                	test   %ecx,%ecx
80106902:	74 2c                	je     80106930 <walkpgdir+0x70>
80106904:	e8 77 bb ff ff       	call   80102480 <kalloc>
80106909:	85 c0                	test   %eax,%eax
8010690b:	89 c6                	mov    %eax,%esi
8010690d:	74 21                	je     80106930 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010690f:	83 ec 04             	sub    $0x4,%esp
80106912:	68 00 10 00 00       	push   $0x1000
80106917:	6a 00                	push   $0x0
80106919:	50                   	push   %eax
8010691a:	e8 41 dd ff ff       	call   80104660 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010691f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106925:	83 c4 10             	add    $0x10,%esp
80106928:	83 c8 07             	or     $0x7,%eax
8010692b:	89 07                	mov    %eax,(%edi)
8010692d:	eb b3                	jmp    801068e2 <walkpgdir+0x22>
8010692f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106930:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106933:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106935:	5b                   	pop    %ebx
80106936:	5e                   	pop    %esi
80106937:	5f                   	pop    %edi
80106938:	5d                   	pop    %ebp
80106939:	c3                   	ret    
8010693a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106940 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106946:	89 d3                	mov    %edx,%ebx
80106948:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010694e:	83 ec 1c             	sub    $0x1c,%esp
80106951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106954:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106958:	8b 7d 08             	mov    0x8(%ebp),%edi
8010695b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106960:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106963:	8b 45 0c             	mov    0xc(%ebp),%eax
80106966:	29 df                	sub    %ebx,%edi
80106968:	83 c8 01             	or     $0x1,%eax
8010696b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010696e:	eb 15                	jmp    80106985 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106970:	f6 00 01             	testb  $0x1,(%eax)
80106973:	75 45                	jne    801069ba <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106975:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106978:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010697b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010697d:	74 31                	je     801069b0 <mappages+0x70>
      break;
    a += PGSIZE;
8010697f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106988:	b9 01 00 00 00       	mov    $0x1,%ecx
8010698d:	89 da                	mov    %ebx,%edx
8010698f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106992:	e8 29 ff ff ff       	call   801068c0 <walkpgdir>
80106997:	85 c0                	test   %eax,%eax
80106999:	75 d5                	jne    80106970 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010699b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010699e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801069a3:	5b                   	pop    %ebx
801069a4:	5e                   	pop    %esi
801069a5:	5f                   	pop    %edi
801069a6:	5d                   	pop    %ebp
801069a7:	c3                   	ret    
801069a8:	90                   	nop
801069a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801069b3:	31 c0                	xor    %eax,%eax
}
801069b5:	5b                   	pop    %ebx
801069b6:	5e                   	pop    %esi
801069b7:	5f                   	pop    %edi
801069b8:	5d                   	pop    %ebp
801069b9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801069ba:	83 ec 0c             	sub    $0xc,%esp
801069bd:	68 14 7b 10 80       	push   $0x80107b14
801069c2:	e8 a9 99 ff ff       	call   80100370 <panic>
801069c7:	89 f6                	mov    %esi,%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069dc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069e4:	83 ec 1c             	sub    $0x1c,%esp
801069e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801069ea:	39 d3                	cmp    %edx,%ebx
801069ec:	73 66                	jae    80106a54 <deallocuvm.part.0+0x84>
801069ee:	89 d6                	mov    %edx,%esi
801069f0:	eb 3d                	jmp    80106a2f <deallocuvm.part.0+0x5f>
801069f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801069f8:	8b 10                	mov    (%eax),%edx
801069fa:	f6 c2 01             	test   $0x1,%dl
801069fd:	74 26                	je     80106a25 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801069ff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a05:	74 58                	je     80106a5f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106a07:	83 ec 0c             	sub    $0xc,%esp
80106a0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a13:	52                   	push   %edx
80106a14:	e8 b7 b8 ff ff       	call   801022d0 <kfree>
      *pte = 0;
80106a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a1c:	83 c4 10             	add    $0x10,%esp
80106a1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a2b:	39 f3                	cmp    %esi,%ebx
80106a2d:	73 25                	jae    80106a54 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a2f:	31 c9                	xor    %ecx,%ecx
80106a31:	89 da                	mov    %ebx,%edx
80106a33:	89 f8                	mov    %edi,%eax
80106a35:	e8 86 fe ff ff       	call   801068c0 <walkpgdir>
    if(!pte)
80106a3a:	85 c0                	test   %eax,%eax
80106a3c:	75 ba                	jne    801069f8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a50:	39 f3                	cmp    %esi,%ebx
80106a52:	72 db                	jb     80106a2f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a5a:	5b                   	pop    %ebx
80106a5b:	5e                   	pop    %esi
80106a5c:	5f                   	pop    %edi
80106a5d:	5d                   	pop    %ebp
80106a5e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106a5f:	83 ec 0c             	sub    $0xc,%esp
80106a62:	68 a6 74 10 80       	push   $0x801074a6
80106a67:	e8 04 99 ff ff       	call   80100370 <panic>
80106a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a70 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106a76:	e8 05 cd ff ff       	call   80103780 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a81:	31 c9                	xor    %ecx,%ecx
80106a83:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106a88:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
80106a8f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a96:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106a9b:	31 c9                	xor    %ecx,%ecx
80106a9d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106aa4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106aa9:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ab0:	31 c9                	xor    %ecx,%ecx
80106ab2:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106ab9:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ac0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ac5:	31 c9                	xor    %ecx,%ecx
80106ac7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ace:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106ad5:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ada:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106ae1:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106ae8:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106aef:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106af6:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
80106afd:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106b04:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b0b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106b12:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106b19:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106b20:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b27:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
80106b2e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106b35:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
80106b3c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106b43:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106b4a:	05 f0 27 11 80       	add    $0x801127f0,%eax
80106b4f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106b53:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b57:	c1 e8 10             	shr    $0x10,%eax
80106b5a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106b5e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b61:	0f 01 10             	lgdtl  (%eax)
}
80106b64:	c9                   	leave  
80106b65:	c3                   	ret    
80106b66:	8d 76 00             	lea    0x0(%esi),%esi
80106b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b70 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b70:	a1 c4 57 11 80       	mov    0x801157c4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106b75:	55                   	push   %ebp
80106b76:	89 e5                	mov    %esp,%ebp
80106b78:	05 00 00 00 80       	add    $0x80000000,%eax
80106b7d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106b80:	5d                   	pop    %ebp
80106b81:	c3                   	ret    
80106b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b90 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
80106b95:	53                   	push   %ebx
80106b96:	83 ec 1c             	sub    $0x1c,%esp
80106b99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b9c:	85 f6                	test   %esi,%esi
80106b9e:	0f 84 cd 00 00 00    	je     80106c71 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106ba4:	8b 46 08             	mov    0x8(%esi),%eax
80106ba7:	85 c0                	test   %eax,%eax
80106ba9:	0f 84 dc 00 00 00    	je     80106c8b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106baf:	8b 7e 04             	mov    0x4(%esi),%edi
80106bb2:	85 ff                	test   %edi,%edi
80106bb4:	0f 84 c4 00 00 00    	je     80106c7e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106bba:	e8 c1 d8 ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bbf:	e8 3c cb ff ff       	call   80103700 <mycpu>
80106bc4:	89 c3                	mov    %eax,%ebx
80106bc6:	e8 35 cb ff ff       	call   80103700 <mycpu>
80106bcb:	89 c7                	mov    %eax,%edi
80106bcd:	e8 2e cb ff ff       	call   80103700 <mycpu>
80106bd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106bd5:	83 c7 08             	add    $0x8,%edi
80106bd8:	e8 23 cb ff ff       	call   80103700 <mycpu>
80106bdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106be0:	83 c0 08             	add    $0x8,%eax
80106be3:	ba 67 00 00 00       	mov    $0x67,%edx
80106be8:	c1 e8 18             	shr    $0x18,%eax
80106beb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106bf2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106bf9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106c00:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106c07:	83 c1 08             	add    $0x8,%ecx
80106c0a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c10:	c1 e9 10             	shr    $0x10,%ecx
80106c13:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c19:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106c1e:	e8 dd ca ff ff       	call   80103700 <mycpu>
80106c23:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c2a:	e8 d1 ca ff ff       	call   80103700 <mycpu>
80106c2f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106c34:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c38:	e8 c3 ca ff ff       	call   80103700 <mycpu>
80106c3d:	8b 56 08             	mov    0x8(%esi),%edx
80106c40:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106c46:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c49:	e8 b2 ca ff ff       	call   80103700 <mycpu>
80106c4e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106c52:	b8 28 00 00 00       	mov    $0x28,%eax
80106c57:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c5a:	8b 46 04             	mov    0x4(%esi),%eax
80106c5d:	05 00 00 00 80       	add    $0x80000000,%eax
80106c62:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c68:	5b                   	pop    %ebx
80106c69:	5e                   	pop    %esi
80106c6a:	5f                   	pop    %edi
80106c6b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106c6c:	e9 4f d8 ff ff       	jmp    801044c0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106c71:	83 ec 0c             	sub    $0xc,%esp
80106c74:	68 1a 7b 10 80       	push   $0x80107b1a
80106c79:	e8 f2 96 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106c7e:	83 ec 0c             	sub    $0xc,%esp
80106c81:	68 45 7b 10 80       	push   $0x80107b45
80106c86:	e8 e5 96 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106c8b:	83 ec 0c             	sub    $0xc,%esp
80106c8e:	68 30 7b 10 80       	push   $0x80107b30
80106c93:	e8 d8 96 ff ff       	call   80100370 <panic>
80106c98:	90                   	nop
80106c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 1c             	sub    $0x1c,%esp
80106ca9:	8b 75 10             	mov    0x10(%ebp),%esi
80106cac:	8b 45 08             	mov    0x8(%ebp),%eax
80106caf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106cb2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106cb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106cbb:	77 49                	ja     80106d06 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106cbd:	e8 be b7 ff ff       	call   80102480 <kalloc>
  memset(mem, 0, PGSIZE);
80106cc2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106cc5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106cc7:	68 00 10 00 00       	push   $0x1000
80106ccc:	6a 00                	push   $0x0
80106cce:	50                   	push   %eax
80106ccf:	e8 8c d9 ff ff       	call   80104660 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106cd4:	58                   	pop    %eax
80106cd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cdb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ce0:	5a                   	pop    %edx
80106ce1:	6a 06                	push   $0x6
80106ce3:	50                   	push   %eax
80106ce4:	31 d2                	xor    %edx,%edx
80106ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ce9:	e8 52 fc ff ff       	call   80106940 <mappages>
  memmove(mem, init, sz);
80106cee:	89 75 10             	mov    %esi,0x10(%ebp)
80106cf1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cf4:	83 c4 10             	add    $0x10,%esp
80106cf7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cfd:	5b                   	pop    %ebx
80106cfe:	5e                   	pop    %esi
80106cff:	5f                   	pop    %edi
80106d00:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106d01:	e9 0a da ff ff       	jmp    80104710 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106d06:	83 ec 0c             	sub    $0xc,%esp
80106d09:	68 59 7b 10 80       	push   $0x80107b59
80106d0e:	e8 5d 96 ff ff       	call   80100370 <panic>
80106d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106d29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106d30:	0f 85 91 00 00 00    	jne    80106dc7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106d36:	8b 75 18             	mov    0x18(%ebp),%esi
80106d39:	31 db                	xor    %ebx,%ebx
80106d3b:	85 f6                	test   %esi,%esi
80106d3d:	75 1a                	jne    80106d59 <loaduvm+0x39>
80106d3f:	eb 6f                	jmp    80106db0 <loaduvm+0x90>
80106d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106d54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106d57:	76 57                	jbe    80106db0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d5f:	31 c9                	xor    %ecx,%ecx
80106d61:	01 da                	add    %ebx,%edx
80106d63:	e8 58 fb ff ff       	call   801068c0 <walkpgdir>
80106d68:	85 c0                	test   %eax,%eax
80106d6a:	74 4e                	je     80106dba <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d6c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106d71:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106d76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d81:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d84:	01 d9                	add    %ebx,%ecx
80106d86:	05 00 00 00 80       	add    $0x80000000,%eax
80106d8b:	57                   	push   %edi
80106d8c:	51                   	push   %ecx
80106d8d:	50                   	push   %eax
80106d8e:	ff 75 10             	pushl  0x10(%ebp)
80106d91:	e8 aa ab ff ff       	call   80101940 <readi>
80106d96:	83 c4 10             	add    $0x10,%esp
80106d99:	39 c7                	cmp    %eax,%edi
80106d9b:	74 ab                	je     80106d48 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5f                   	pop    %edi
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106db3:	31 c0                	xor    %eax,%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106dba:	83 ec 0c             	sub    $0xc,%esp
80106dbd:	68 73 7b 10 80       	push   $0x80107b73
80106dc2:	e8 a9 95 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106dc7:	83 ec 0c             	sub    $0xc,%esp
80106dca:	68 14 7c 10 80       	push   $0x80107c14
80106dcf:	e8 9c 95 ff ff       	call   80100370 <panic>
80106dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106de0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 0c             	sub    $0xc,%esp
80106de9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106dec:	85 ff                	test   %edi,%edi
80106dee:	0f 88 ca 00 00 00    	js     80106ebe <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106df4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106dfa:	0f 82 82 00 00 00    	jb     80106e82 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106e00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e0c:	39 df                	cmp    %ebx,%edi
80106e0e:	77 43                	ja     80106e53 <allocuvm+0x73>
80106e10:	e9 bb 00 00 00       	jmp    80106ed0 <allocuvm+0xf0>
80106e15:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106e18:	83 ec 04             	sub    $0x4,%esp
80106e1b:	68 00 10 00 00       	push   $0x1000
80106e20:	6a 00                	push   $0x0
80106e22:	50                   	push   %eax
80106e23:	e8 38 d8 ff ff       	call   80104660 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e28:	58                   	pop    %eax
80106e29:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e2f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e34:	5a                   	pop    %edx
80106e35:	6a 06                	push   $0x6
80106e37:	50                   	push   %eax
80106e38:	89 da                	mov    %ebx,%edx
80106e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80106e3d:	e8 fe fa ff ff       	call   80106940 <mappages>
80106e42:	83 c4 10             	add    $0x10,%esp
80106e45:	85 c0                	test   %eax,%eax
80106e47:	78 47                	js     80106e90 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106e49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e4f:	39 df                	cmp    %ebx,%edi
80106e51:	76 7d                	jbe    80106ed0 <allocuvm+0xf0>
    mem = kalloc();
80106e53:	e8 28 b6 ff ff       	call   80102480 <kalloc>
    if(mem == 0){
80106e58:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106e5a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106e5c:	75 ba                	jne    80106e18 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106e5e:	83 ec 0c             	sub    $0xc,%esp
80106e61:	68 91 7b 10 80       	push   $0x80107b91
80106e66:	e8 f5 97 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e6b:	83 c4 10             	add    $0x10,%esp
80106e6e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e71:	76 4b                	jbe    80106ebe <allocuvm+0xde>
80106e73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e76:	8b 45 08             	mov    0x8(%ebp),%eax
80106e79:	89 fa                	mov    %edi,%edx
80106e7b:	e8 50 fb ff ff       	call   801069d0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106e80:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106e90:	83 ec 0c             	sub    $0xc,%esp
80106e93:	68 a9 7b 10 80       	push   $0x80107ba9
80106e98:	e8 c3 97 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106e9d:	83 c4 10             	add    $0x10,%esp
80106ea0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ea3:	76 0d                	jbe    80106eb2 <allocuvm+0xd2>
80106ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80106eab:	89 fa                	mov    %edi,%edx
80106ead:	e8 1e fb ff ff       	call   801069d0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106eb2:	83 ec 0c             	sub    $0xc,%esp
80106eb5:	56                   	push   %esi
80106eb6:	e8 15 b4 ff ff       	call   801022d0 <kfree>
      return 0;
80106ebb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106ec1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106ec3:	5b                   	pop    %ebx
80106ec4:	5e                   	pop    %esi
80106ec5:	5f                   	pop    %edi
80106ec6:	5d                   	pop    %ebp
80106ec7:	c3                   	ret    
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ed3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ee0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ee6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106eec:	39 d1                	cmp    %edx,%ecx
80106eee:	73 10                	jae    80106f00 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ef0:	5d                   	pop    %ebp
80106ef1:	e9 da fa ff ff       	jmp    801069d0 <deallocuvm.part.0>
80106ef6:	8d 76 00             	lea    0x0(%esi),%esi
80106ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106f00:	89 d0                	mov    %edx,%eax
80106f02:	5d                   	pop    %ebp
80106f03:	c3                   	ret    
80106f04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 0c             	sub    $0xc,%esp
80106f19:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f1c:	85 f6                	test   %esi,%esi
80106f1e:	74 59                	je     80106f79 <freevm+0x69>
80106f20:	31 c9                	xor    %ecx,%ecx
80106f22:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f27:	89 f0                	mov    %esi,%eax
80106f29:	e8 a2 fa ff ff       	call   801069d0 <deallocuvm.part.0>
80106f2e:	89 f3                	mov    %esi,%ebx
80106f30:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f36:	eb 0f                	jmp    80106f47 <freevm+0x37>
80106f38:	90                   	nop
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f40:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f43:	39 fb                	cmp    %edi,%ebx
80106f45:	74 23                	je     80106f6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f47:	8b 03                	mov    (%ebx),%eax
80106f49:	a8 01                	test   $0x1,%al
80106f4b:	74 f3                	je     80106f40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106f4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f52:	83 ec 0c             	sub    $0xc,%esp
80106f55:	83 c3 04             	add    $0x4,%ebx
80106f58:	05 00 00 00 80       	add    $0x80000000,%eax
80106f5d:	50                   	push   %eax
80106f5e:	e8 6d b3 ff ff       	call   801022d0 <kfree>
80106f63:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f66:	39 fb                	cmp    %edi,%ebx
80106f68:	75 dd                	jne    80106f47 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f70:	5b                   	pop    %ebx
80106f71:	5e                   	pop    %esi
80106f72:	5f                   	pop    %edi
80106f73:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106f74:	e9 57 b3 ff ff       	jmp    801022d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	68 c5 7b 10 80       	push   $0x80107bc5
80106f81:	e8 ea 93 ff ff       	call   80100370 <panic>
80106f86:	8d 76 00             	lea    0x0(%esi),%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	56                   	push   %esi
80106f94:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106f95:	e8 e6 b4 ff ff       	call   80102480 <kalloc>
80106f9a:	85 c0                	test   %eax,%eax
80106f9c:	74 6a                	je     80107008 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106f9e:	83 ec 04             	sub    $0x4,%esp
80106fa1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fa3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106fa8:	68 00 10 00 00       	push   $0x1000
80106fad:	6a 00                	push   $0x0
80106faf:	50                   	push   %eax
80106fb0:	e8 ab d6 ff ff       	call   80104660 <memset>
80106fb5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106fbb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fbe:	83 ec 08             	sub    $0x8,%esp
80106fc1:	8b 13                	mov    (%ebx),%edx
80106fc3:	ff 73 0c             	pushl  0xc(%ebx)
80106fc6:	50                   	push   %eax
80106fc7:	29 c1                	sub    %eax,%ecx
80106fc9:	89 f0                	mov    %esi,%eax
80106fcb:	e8 70 f9 ff ff       	call   80106940 <mappages>
80106fd0:	83 c4 10             	add    $0x10,%esp
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	78 19                	js     80106ff0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fd7:	83 c3 10             	add    $0x10,%ebx
80106fda:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106fe0:	75 d6                	jne    80106fb8 <setupkvm+0x28>
80106fe2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106fe4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fe7:	5b                   	pop    %ebx
80106fe8:	5e                   	pop    %esi
80106fe9:	5d                   	pop    %ebp
80106fea:	c3                   	ret    
80106feb:	90                   	nop
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106ff0:	83 ec 0c             	sub    $0xc,%esp
80106ff3:	56                   	push   %esi
80106ff4:	e8 17 ff ff ff       	call   80106f10 <freevm>
      return 0;
80106ff9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106fff:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107001:	5b                   	pop    %ebx
80107002:	5e                   	pop    %esi
80107003:	5d                   	pop    %ebp
80107004:	c3                   	ret    
80107005:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107008:	31 c0                	xor    %eax,%eax
8010700a:	eb d8                	jmp    80106fe4 <setupkvm+0x54>
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107016:	e8 75 ff ff ff       	call   80106f90 <setupkvm>
8010701b:	a3 c4 57 11 80       	mov    %eax,0x801157c4
80107020:	05 00 00 00 80       	add    $0x80000000,%eax
80107025:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107028:	c9                   	leave  
80107029:	c3                   	ret    
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107030 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107030:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107031:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107033:	89 e5                	mov    %esp,%ebp
80107035:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107038:	8b 55 0c             	mov    0xc(%ebp),%edx
8010703b:	8b 45 08             	mov    0x8(%ebp),%eax
8010703e:	e8 7d f8 ff ff       	call   801068c0 <walkpgdir>
  if(pte == 0)
80107043:	85 c0                	test   %eax,%eax
80107045:	74 05                	je     8010704c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107047:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010704a:	c9                   	leave  
8010704b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010704c:	83 ec 0c             	sub    $0xc,%esp
8010704f:	68 d6 7b 10 80       	push   $0x80107bd6
80107054:	e8 17 93 ff ff       	call   80100370 <panic>
80107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107060 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107069:	e8 22 ff ff ff       	call   80106f90 <setupkvm>
8010706e:	85 c0                	test   %eax,%eax
80107070:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107073:	0f 84 c5 00 00 00    	je     8010713e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010707c:	85 c9                	test   %ecx,%ecx
8010707e:	0f 84 9c 00 00 00    	je     80107120 <copyuvm+0xc0>
80107084:	31 ff                	xor    %edi,%edi
80107086:	eb 4a                	jmp    801070d2 <copyuvm+0x72>
80107088:	90                   	nop
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107090:	83 ec 04             	sub    $0x4,%esp
80107093:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107099:	68 00 10 00 00       	push   $0x1000
8010709e:	53                   	push   %ebx
8010709f:	50                   	push   %eax
801070a0:	e8 6b d6 ff ff       	call   80104710 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801070a5:	58                   	pop    %eax
801070a6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070b1:	5a                   	pop    %edx
801070b2:	ff 75 e4             	pushl  -0x1c(%ebp)
801070b5:	50                   	push   %eax
801070b6:	89 fa                	mov    %edi,%edx
801070b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070bb:	e8 80 f8 ff ff       	call   80106940 <mappages>
801070c0:	83 c4 10             	add    $0x10,%esp
801070c3:	85 c0                	test   %eax,%eax
801070c5:	78 69                	js     80107130 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070c7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070cd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801070d0:	76 4e                	jbe    80107120 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070d2:	8b 45 08             	mov    0x8(%ebp),%eax
801070d5:	31 c9                	xor    %ecx,%ecx
801070d7:	89 fa                	mov    %edi,%edx
801070d9:	e8 e2 f7 ff ff       	call   801068c0 <walkpgdir>
801070de:	85 c0                	test   %eax,%eax
801070e0:	74 6d                	je     8010714f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801070e2:	8b 00                	mov    (%eax),%eax
801070e4:	a8 01                	test   $0x1,%al
801070e6:	74 5a                	je     80107142 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070e8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801070ea:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070ef:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801070f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801070f8:	e8 83 b3 ff ff       	call   80102480 <kalloc>
801070fd:	85 c0                	test   %eax,%eax
801070ff:	89 c6                	mov    %eax,%esi
80107101:	75 8d                	jne    80107090 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107103:	83 ec 0c             	sub    $0xc,%esp
80107106:	ff 75 e0             	pushl  -0x20(%ebp)
80107109:	e8 02 fe ff ff       	call   80106f10 <freevm>
  return 0;
8010710e:	83 c4 10             	add    $0x10,%esp
80107111:	31 c0                	xor    %eax,%eax
}
80107113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107116:	5b                   	pop    %ebx
80107117:	5e                   	pop    %esi
80107118:	5f                   	pop    %edi
80107119:	5d                   	pop    %ebp
8010711a:	c3                   	ret    
8010711b:	90                   	nop
8010711c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107126:	5b                   	pop    %ebx
80107127:	5e                   	pop    %esi
80107128:	5f                   	pop    %edi
80107129:	5d                   	pop    %ebp
8010712a:	c3                   	ret    
8010712b:	90                   	nop
8010712c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107130:	83 ec 0c             	sub    $0xc,%esp
80107133:	56                   	push   %esi
80107134:	e8 97 b1 ff ff       	call   801022d0 <kfree>
      goto bad;
80107139:	83 c4 10             	add    $0x10,%esp
8010713c:	eb c5                	jmp    80107103 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010713e:	31 c0                	xor    %eax,%eax
80107140:	eb d1                	jmp    80107113 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107142:	83 ec 0c             	sub    $0xc,%esp
80107145:	68 fa 7b 10 80       	push   $0x80107bfa
8010714a:	e8 21 92 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010714f:	83 ec 0c             	sub    $0xc,%esp
80107152:	68 e0 7b 10 80       	push   $0x80107be0
80107157:	e8 14 92 ff ff       	call   80100370 <panic>
8010715c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107160 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107160:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107161:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107163:	89 e5                	mov    %esp,%ebp
80107165:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107168:	8b 55 0c             	mov    0xc(%ebp),%edx
8010716b:	8b 45 08             	mov    0x8(%ebp),%eax
8010716e:	e8 4d f7 ff ff       	call   801068c0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107173:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107175:	89 c2                	mov    %eax,%edx
80107177:	83 e2 05             	and    $0x5,%edx
8010717a:	83 fa 05             	cmp    $0x5,%edx
8010717d:	75 11                	jne    80107190 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010717f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107184:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107185:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010718a:	c3                   	ret    
8010718b:	90                   	nop
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107190:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107192:	c9                   	leave  
80107193:	c3                   	ret    
80107194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010719a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 1c             	sub    $0x1c,%esp
801071a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801071ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801071af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071b2:	85 db                	test   %ebx,%ebx
801071b4:	75 40                	jne    801071f6 <copyout+0x56>
801071b6:	eb 70                	jmp    80107228 <copyout+0x88>
801071b8:	90                   	nop
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801071c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071c3:	89 f1                	mov    %esi,%ecx
801071c5:	29 d1                	sub    %edx,%ecx
801071c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801071cd:	39 d9                	cmp    %ebx,%ecx
801071cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071d2:	29 f2                	sub    %esi,%edx
801071d4:	83 ec 04             	sub    $0x4,%esp
801071d7:	01 d0                	add    %edx,%eax
801071d9:	51                   	push   %ecx
801071da:	57                   	push   %edi
801071db:	50                   	push   %eax
801071dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801071df:	e8 2c d5 ff ff       	call   80104710 <memmove>
    len -= n;
    buf += n;
801071e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071e7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801071ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801071f0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071f2:	29 cb                	sub    %ecx,%ebx
801071f4:	74 32                	je     80107228 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801071f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801071f8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801071fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801071fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107204:	56                   	push   %esi
80107205:	ff 75 08             	pushl  0x8(%ebp)
80107208:	e8 53 ff ff ff       	call   80107160 <uva2ka>
    if(pa0 == 0)
8010720d:	83 c4 10             	add    $0x10,%esp
80107210:	85 c0                	test   %eax,%eax
80107212:	75 ac                	jne    801071c0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107214:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010721c:	5b                   	pop    %ebx
8010721d:	5e                   	pop    %esi
8010721e:	5f                   	pop    %edi
8010721f:	5d                   	pop    %ebp
80107220:	c3                   	ret    
80107221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107228:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010722b:	31 c0                	xor    %eax,%eax
}
8010722d:	5b                   	pop    %ebx
8010722e:	5e                   	pop    %esi
8010722f:	5f                   	pop    %edi
80107230:	5d                   	pop    %ebp
80107231:	c3                   	ret    
