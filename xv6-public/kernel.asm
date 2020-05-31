
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
8010004c:	68 a0 77 10 80       	push   $0x801077a0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 d5 47 00 00       	call   80104830 <initlock>

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
80100092:	68 a7 77 10 80       	push   $0x801077a7
80100097:	50                   	push   %eax
80100098:	e8 63 46 00 00       	call   80104700 <initsleeplock>
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
801000e4:	e8 a7 48 00 00       	call   80104990 <acquire>

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
80100162:	e8 d9 48 00 00       	call   80104a40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 45 00 00       	call   80104740 <acquiresleep>
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
80100193:	68 ae 77 10 80       	push   $0x801077ae
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
801001ae:	e8 2d 46 00 00       	call   801047e0 <holdingsleep>
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
801001cc:	68 bf 77 10 80       	push   $0x801077bf
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
801001ef:	e8 ec 45 00 00       	call   801047e0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 45 00 00       	call   801047a0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 80 47 00 00       	call   80104990 <acquire>
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
8010025c:	e9 df 47 00 00       	jmp    80104a40 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 77 10 80       	push   $0x801077c6
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
8010028c:	e8 ff 46 00 00       	call   80104990 <acquire>
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
801002bd:	e8 ce 40 00 00       	call   80104390 <sleep>

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
801002e6:	e8 55 47 00 00       	call   80104a40 <release>
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
80100346:	e8 f5 46 00 00       	call   80104a40 <release>
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
80100392:	68 cd 77 10 80       	push   $0x801077cd
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 2f 81 10 80 	movl   $0x8010812f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 93 44 00 00       	call   80104850 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 e1 77 10 80       	push   $0x801077e1
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
8010041a:	e8 31 5f 00 00       	call   80106350 <uartputc>
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
801004d3:	e8 78 5e 00 00       	call   80106350 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 6c 5e 00 00       	call   80106350 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 60 5e 00 00       	call   80106350 <uartputc>
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
80100514:	e8 27 46 00 00       	call   80104b40 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 62 45 00 00       	call   80104a90 <memset>
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
80100540:	68 e5 77 10 80       	push   $0x801077e5
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
801005b1:	0f b6 92 10 78 10 80 	movzbl -0x7fef87f0(%edx),%edx
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
8010061b:	e8 70 43 00 00       	call   80104990 <acquire>
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
80100647:	e8 f4 43 00 00       	call   80104a40 <release>
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
8010070d:	e8 2e 43 00 00       	call   80104a40 <release>
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
80100788:	b8 f8 77 10 80       	mov    $0x801077f8,%eax
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
801007c8:	e8 c3 41 00 00       	call   80104990 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 ff 77 10 80       	push   $0x801077ff
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
80100803:	e8 88 41 00 00       	call   80104990 <acquire>
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
80100868:	e8 d3 41 00 00       	call   80104a40 <release>
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
801008f6:	e8 55 3c 00 00       	call   80104550 <wakeup>
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
80100977:	e9 c4 3c 00 00       	jmp    80104640 <procdump>
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
801009a6:	68 08 78 10 80       	push   $0x80107808
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 7b 3e 00 00       	call   80104830 <initlock>

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
80100a74:	e8 67 6a 00 00       	call   801074e0 <setupkvm>
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
80100b04:	e8 27 68 00 00       	call   80107330 <allocuvm>
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
80100b3a:	e8 31 67 00 00       	call   80107270 <loaduvm>
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
80100b59:	e8 02 69 00 00       	call   80107460 <freevm>
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
80100b95:	e8 96 67 00 00       	call   80107330 <allocuvm>
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
80100bac:	e8 af 68 00 00       	call   80107460 <freevm>
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
80100bc6:	68 21 78 10 80       	push   $0x80107821
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
80100bf1:	e8 8a 69 00 00       	call   80107580 <clearpteu>
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
80100c2d:	e8 9e 40 00 00       	call   80104cd0 <strlen>
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
80100c40:	e8 8b 40 00 00       	call   80104cd0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 9a 6a 00 00       	call   801076f0 <copyout>
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
80100cbb:	e8 30 6a 00 00       	call   801076f0 <copyout>
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
80100d00:	e8 8b 3f 00 00       	call   80104c90 <safestrcpy>

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
80100d2c:	e8 af 63 00 00       	call   801070e0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 27 67 00 00       	call   80107460 <freevm>
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
80100e0a:	e8 21 65 00 00       	call   80107330 <allocuvm>
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
80100e29:	e8 32 66 00 00       	call   80107460 <freevm>
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
80100e50:	e8 8b 66 00 00       	call   801074e0 <setupkvm>
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
80100eec:	e8 3f 64 00 00       	call   80107330 <allocuvm>
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
80100f22:	e8 49 63 00 00       	call   80107270 <loaduvm>
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
80100f41:	e8 1a 65 00 00       	call   80107460 <freevm>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	e9 66 fe ff ff       	jmp    80100db4 <exec2+0x64>
  }

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100f4e:	e8 fd 1f 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100f53:	83 ec 0c             	sub    $0xc,%esp
80100f56:	68 21 78 10 80       	push   $0x80107821
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
80100f80:	e8 fb 65 00 00       	call   80107580 <clearpteu>
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
80100fb5:	e8 16 3d 00 00       	call   80104cd0 <strlen>
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
80100fc8:	e8 03 3d 00 00       	call   80104cd0 <strlen>
80100fcd:	83 c0 01             	add    $0x1,%eax
80100fd0:	50                   	push   %eax
80100fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fd4:	ff 34 b8             	pushl  (%eax,%edi,4)
80100fd7:	53                   	push   %ebx
80100fd8:	56                   	push   %esi
80100fd9:	e8 12 67 00 00       	call   801076f0 <copyout>
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
80101043:	e8 a8 66 00 00       	call   801076f0 <copyout>
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
80101080:	e8 0b 3c 00 00       	call   80104c90 <safestrcpy>

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
801010b4:	e8 27 60 00 00       	call   801070e0 <switchuvm>
  freevm(oldpgdir);
801010b9:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010bf:	89 04 24             	mov    %eax,(%esp)
801010c2:	e8 99 63 00 00       	call   80107460 <freevm>
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
801010f6:	68 2d 78 10 80       	push   $0x8010782d
801010fb:	68 c0 0f 11 80       	push   $0x80110fc0
80101100:	e8 2b 37 00 00       	call   80104830 <initlock>
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
80101121:	e8 6a 38 00 00       	call   80104990 <acquire>
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
80101151:	e8 ea 38 00 00       	call   80104a40 <release>
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
80101168:	e8 d3 38 00 00       	call   80104a40 <release>
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
8010118f:	e8 fc 37 00 00       	call   80104990 <acquire>
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
801011ac:	e8 8f 38 00 00       	call   80104a40 <release>
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
801011bb:	68 34 78 10 80       	push   $0x80107834
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
801011e1:	e8 aa 37 00 00       	call   80104990 <acquire>
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
8010120c:	e9 2f 38 00 00       	jmp    80104a40 <release>
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
80101238:	e8 03 38 00 00       	call   80104a40 <release>

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
80101292:	68 3c 78 10 80       	push   $0x8010783c
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
80101372:	68 46 78 10 80       	push   $0x80107846
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
80101484:	68 4f 78 10 80       	push   $0x8010784f
80101489:	e8 e2 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010148e:	83 ec 0c             	sub    $0xc,%esp
80101491:	68 55 78 10 80       	push   $0x80107855
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
80101505:	68 5f 78 10 80       	push   $0x8010785f
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
801015b2:	68 72 78 10 80       	push   $0x80107872
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
801015f5:	e8 96 34 00 00       	call   80104a90 <memset>
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
8010163a:	e8 51 33 00 00       	call   80104990 <acquire>
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
80101682:	e8 b9 33 00 00       	call   80104a40 <release>
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
801016cf:	e8 6c 33 00 00       	call   80104a40 <release>

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
801016e4:	68 88 78 10 80       	push   $0x80107888
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
801017aa:	68 98 78 10 80       	push   $0x80107898
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
801017e1:	e8 5a 33 00 00       	call   80104b40 <memmove>
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
8010180c:	68 ab 78 10 80       	push   $0x801078ab
80101811:	68 e0 19 11 80       	push   $0x801119e0
80101816:	e8 15 30 00 00       	call   80104830 <initlock>
8010181b:	83 c4 10             	add    $0x10,%esp
8010181e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101820:	83 ec 08             	sub    $0x8,%esp
80101823:	68 b2 78 10 80       	push   $0x801078b2
80101828:	53                   	push   %ebx
80101829:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010182f:	e8 cc 2e 00 00       	call   80104700 <initsleeplock>
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
80101879:	68 18 79 10 80       	push   $0x80107918
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
8010190e:	e8 7d 31 00 00       	call   80104a90 <memset>
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
80101943:	68 b8 78 10 80       	push   $0x801078b8
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
801019b1:	e8 8a 31 00 00       	call   80104b40 <memmove>
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
801019df:	e8 ac 2f 00 00       	call   80104990 <acquire>
  ip->ref++;
801019e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019e8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801019ef:	e8 4c 30 00 00       	call   80104a40 <release>
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
80101a22:	e8 19 2d 00 00       	call   80104740 <acquiresleep>

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
80101a98:	e8 a3 30 00 00       	call   80104b40 <memmove>
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
80101abd:	68 d0 78 10 80       	push   $0x801078d0
80101ac2:	e8 a9 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101ac7:	83 ec 0c             	sub    $0xc,%esp
80101aca:	68 ca 78 10 80       	push   $0x801078ca
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
80101af3:	e8 e8 2c 00 00       	call   801047e0 <holdingsleep>
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
80101b0f:	e9 8c 2c 00 00       	jmp    801047a0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	68 df 78 10 80       	push   $0x801078df
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
80101b40:	e8 fb 2b 00 00       	call   80104740 <acquiresleep>
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
80101b5a:	e8 41 2c 00 00       	call   801047a0 <releasesleep>

  acquire(&icache.lock);
80101b5f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b66:	e8 25 2e 00 00       	call   80104990 <acquire>
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
80101b80:	e9 bb 2e 00 00       	jmp    80104a40 <release>
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101b88:	83 ec 0c             	sub    $0xc,%esp
80101b8b:	68 e0 19 11 80       	push   $0x801119e0
80101b90:	e8 fb 2d 00 00       	call   80104990 <acquire>
    int r = ip->ref;
80101b95:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101b98:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101b9f:	e8 9c 2e 00 00       	call   80104a40 <release>
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
80101d88:	e8 b3 2d 00 00       	call   80104b40 <memmove>
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
80101e84:	e8 b7 2c 00 00       	call   80104b40 <memmove>
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
80101f1e:	e8 9d 2c 00 00       	call   80104bc0 <strncmp>
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
80101f85:	e8 36 2c 00 00       	call   80104bc0 <strncmp>
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
80101fbd:	68 f9 78 10 80       	push   $0x801078f9
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101fc7:	83 ec 0c             	sub    $0xc,%esp
80101fca:	68 e7 78 10 80       	push   $0x801078e7
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
80102009:	e8 82 29 00 00       	call   80104990 <acquire>
  ip->ref++;
8010200e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102012:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80102019:	e8 22 2a 00 00       	call   80104a40 <release>
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
80102075:	e8 c6 2a 00 00       	call   80104b40 <memmove>
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
80102104:	e8 37 2a 00 00       	call   80104b40 <memmove>
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
801021ed:	e8 3e 2a 00 00       	call   80104c30 <strncpy>
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
8010222b:	68 08 79 10 80       	push   $0x80107908
80102230:	e8 3b e1 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 16 7f 10 80       	push   $0x80107f16
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
80102340:	68 74 79 10 80       	push   $0x80107974
80102345:	e8 26 e0 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010234a:	83 ec 0c             	sub    $0xc,%esp
8010234d:	68 6b 79 10 80       	push   $0x8010796b
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
80102366:	68 86 79 10 80       	push   $0x80107986
8010236b:	68 80 b5 10 80       	push   $0x8010b580
80102370:	e8 bb 24 00 00       	call   80104830 <initlock>
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
801023ee:	e8 9d 25 00 00       	call   80104990 <acquire>

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
8010241e:	e8 2d 21 00 00       	call   80104550 <wakeup>

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
8010243c:	e8 ff 25 00 00       	call   80104a40 <release>
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
8010248e:	e8 4d 23 00 00       	call   801047e0 <holdingsleep>
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
801024c8:	e8 c3 24 00 00       	call   80104990 <acquire>

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
80102519:	e8 72 1e 00 00       	call   80104390 <sleep>
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
80102536:	e9 05 25 00 00       	jmp    80104a40 <release>

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
8010254e:	68 8a 79 10 80       	push   $0x8010798a
80102553:	e8 18 de ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 b5 79 10 80       	push   $0x801079b5
80102560:	e8 0b de ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102565:	83 ec 0c             	sub    $0xc,%esp
80102568:	68 a0 79 10 80       	push   $0x801079a0
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
801025ca:	68 d4 79 10 80       	push   $0x801079d4
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
80102682:	81 fb a8 69 11 80    	cmp    $0x801169a8,%ebx
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
801026a2:	e8 e9 23 00 00       	call   80104a90 <memset>

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
801026db:	e9 60 23 00 00       	jmp    80104a40 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	68 40 36 11 80       	push   $0x80113640
801026e8:	e8 a3 22 00 00       	call   80104990 <acquire>
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	eb c2                	jmp    801026b4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801026f2:	83 ec 0c             	sub    $0xc,%esp
801026f5:	68 06 7a 10 80       	push   $0x80107a06
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
8010275b:	68 0c 7a 10 80       	push   $0x80107a0c
80102760:	68 40 36 11 80       	push   $0x80113640
80102765:	e8 c6 20 00 00       	call   80104830 <initlock>

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
8010284e:	e8 ed 21 00 00       	call   80104a40 <release>
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
80102868:	e8 23 21 00 00       	call   80104990 <acquire>
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
801028c6:	0f b6 82 40 7b 10 80 	movzbl -0x7fef84c0(%edx),%eax
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
801028ee:	0f b6 82 40 7b 10 80 	movzbl -0x7fef84c0(%edx),%eax
801028f5:	09 c1                	or     %eax,%ecx
801028f7:	0f b6 82 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%eax
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
8010290e:	8b 04 85 20 7a 10 80 	mov    -0x7fef85e0(,%eax,4),%eax
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
80102c74:	e8 67 1e 00 00       	call   80104ae0 <memcmp>
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
80102da4:	e8 97 1d 00 00       	call   80104b40 <memmove>
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
80102e4a:	68 40 7c 10 80       	push   $0x80107c40
80102e4f:	68 80 36 11 80       	push   $0x80113680
80102e54:	e8 d7 19 00 00       	call   80104830 <initlock>
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
80102eeb:	e8 a0 1a 00 00       	call   80104990 <acquire>
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	eb 18                	jmp    80102f0d <begin_op+0x2d>
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 80 36 11 80       	push   $0x80113680
80102f00:	68 80 36 11 80       	push   $0x80113680
80102f05:	e8 86 14 00 00       	call   80104390 <sleep>
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
80102f3c:	e8 ff 1a 00 00       	call   80104a40 <release>
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
80102f5e:	e8 2d 1a 00 00       	call   80104990 <acquire>
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
80102f9d:	e8 9e 1a 00 00       	call   80104a40 <release>
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
80102ffc:	e8 3f 1b 00 00       	call   80104b40 <memmove>
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
80103045:	e8 46 19 00 00       	call   80104990 <acquire>
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
8010305b:	e8 f0 14 00 00       	call   80104550 <wakeup>
    release(&log.lock);
80103060:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103067:	e8 d4 19 00 00       	call   80104a40 <release>
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
80103088:	e8 c3 14 00 00       	call   80104550 <wakeup>
  }
  release(&log.lock);
8010308d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103094:	e8 a7 19 00 00       	call   80104a40 <release>
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
801030a7:	68 44 7c 10 80       	push   $0x80107c44
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
801030fe:	e8 8d 18 00 00       	call   80104990 <acquire>
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
8010314e:	e9 ed 18 00 00       	jmp    80104a40 <release>
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
80103173:	68 53 7c 10 80       	push   $0x80107c53
80103178:	e8 f3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010317d:	83 ec 0c             	sub    $0xc,%esp
80103180:	68 69 7c 10 80       	push   $0x80107c69
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
801031a8:	68 84 7c 10 80       	push   $0x80107c84
801031ad:	e8 ae d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031b2:	e8 e9 2d 00 00       	call   80105fa0 <idtinit>
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
801031d6:	e8 e5 3e 00 00       	call   801070c0 <switchkvm>
  seginit();
801031db:	e8 e0 3d 00 00       	call   80106fc0 <seginit>
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
8010320c:	68 a8 69 11 80       	push   $0x801169a8
80103211:	e8 3a f5 ff ff       	call   80102750 <kinit1>
  kvmalloc();      // kernel page table
80103216:	e8 45 43 00 00       	call   80107560 <kvmalloc>
  mpinit();        // detect other processors
8010321b:	e8 70 01 00 00       	call   80103390 <mpinit>
  lapicinit();     // interrupt controller
80103220:	e8 5b f7 ff ff       	call   80102980 <lapicinit>
  seginit();       // segment descriptors
80103225:	e8 96 3d 00 00       	call   80106fc0 <seginit>
  picinit();       // disable pic
8010322a:	e8 31 03 00 00       	call   80103560 <picinit>
  ioapicinit();    // another interrupt controller
8010322f:	e8 4c f3 ff ff       	call   80102580 <ioapicinit>
  consoleinit();   // console hardware
80103234:	e8 67 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103239:	e8 52 30 00 00       	call   80106290 <uartinit>
  pinit();         // process table
8010323e:	e8 4d 08 00 00       	call   80103a90 <pinit>
  tvinit();        // trap vectors
80103243:	e8 b8 2c 00 00       	call   80105f00 <tvinit>
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
80103269:	e8 d2 18 00 00       	call   80104b40 <memmove>

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
80103338:	68 98 7c 10 80       	push   $0x80107c98
8010333d:	56                   	push   %esi
8010333e:	e8 9d 17 00 00       	call   80104ae0 <memcmp>
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
801033fc:	68 9d 7c 10 80       	push   $0x80107c9d
80103401:	56                   	push   %esi
80103402:	e8 d9 16 00 00       	call   80104ae0 <memcmp>
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
80103490:	ff 24 95 dc 7c 10 80 	jmp    *-0x7fef8324(,%edx,4)
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
80103537:	68 a2 7c 10 80       	push   $0x80107ca2
8010353c:	e8 2f ce ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103541:	83 ec 0c             	sub    $0xc,%esp
80103544:	68 bc 7c 10 80       	push   $0x80107cbc
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
801035f3:	68 f0 7c 10 80       	push   $0x80107cf0
801035f8:	50                   	push   %eax
801035f9:	e8 32 12 00 00       	call   80104830 <initlock>
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
8010368f:	e8 fc 12 00 00       	call   80104990 <acquire>
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
801036af:	e8 9c 0e 00 00       	call   80104550 <wakeup>
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
801036d4:	e9 67 13 00 00       	jmp    80104a40 <release>
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
801036f4:	e8 57 0e 00 00       	call   80104550 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb b9                	jmp    801036b7 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 37 13 00 00       	call   80104a40 <release>
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
8010372d:	e8 5e 12 00 00       	call   80104990 <acquire>
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
80103780:	e8 cb 0d 00 00       	call   80104550 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103785:	58                   	pop    %eax
80103786:	5a                   	pop    %edx
80103787:	53                   	push   %ebx
80103788:	56                   	push   %esi
80103789:	e8 02 0c 00 00       	call   80104390 <sleep>
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
801037b4:	e8 87 12 00 00       	call   80104a40 <release>
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
80103803:	e8 48 0d 00 00       	call   80104550 <wakeup>
  release(&p->lock);
80103808:	89 1c 24             	mov    %ebx,(%esp)
8010380b:	e8 30 12 00 00       	call   80104a40 <release>
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
80103830:	e8 5b 11 00 00       	call   80104990 <acquire>
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
80103865:	e8 26 0b 00 00       	call   80104390 <sleep>
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
80103899:	e8 a2 11 00 00       	call   80104a40 <release>
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
801038fe:	e8 4d 0c 00 00       	call   80104550 <wakeup>
  release(&p->lock);
80103903:	89 1c 24             	mov    %ebx,(%esp)
80103906:	e8 35 11 00 00       	call   80104a40 <release>
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
80103951:	e8 3a 10 00 00       	call   80104990 <acquire>
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	eb 17                	jmp    80103972 <allocproc+0x32>
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103960:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103966:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
8010396c:	0f 84 a6 00 00 00    	je     80103a18 <allocproc+0xd8>
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
  p->limit_sz = -1;
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
  p->limit_sz = -1;
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
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039c2:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  p->limit_sz = -1;
  //////////////////////////////////////////

  release(&ptable.lock);
801039c8:	e8 73 10 00 00       	call   80104a40 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039cd:	e8 4e ee ff ff       	call   80102820 <kalloc>
801039d2:	83 c4 10             	add    $0x10,%esp
801039d5:	85 c0                	test   %eax,%eax
801039d7:	89 43 08             	mov    %eax,0x8(%ebx)
801039da:	74 53                	je     80103a2f <allocproc+0xef>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039dc:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039e2:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801039e5:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039ea:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801039ed:	c7 40 14 ef 5e 10 80 	movl   $0x80105eef,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039f4:	6a 14                	push   $0x14
801039f6:	6a 00                	push   $0x0
801039f8:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801039f9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039fc:	e8 8f 10 00 00       	call   80104a90 <memset>
  p->context->eip = (uint)forkret;
80103a01:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a04:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103a07:	c7 40 10 40 3a 10 80 	movl   $0x80103a40,0x10(%eax)

  return p;
80103a0e:	89 d8                	mov    %ebx,%eax
}
80103a10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a13:	c9                   	leave  
80103a14:	c3                   	ret    
80103a15:	8d 76 00             	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	68 20 3d 11 80       	push   $0x80113d20
80103a20:	e8 1b 10 00 00       	call   80104a40 <release>
  return 0;
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2d:	c9                   	leave  
80103a2e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103a2f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a36:	eb d8                	jmp    80103a10 <allocproc+0xd0>
80103a38:	90                   	nop
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

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
80103a4b:	e8 f0 0f 00 00       	call   80104a40 <release>

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
80103a96:	68 f5 7c 10 80       	push   $0x80107cf5
80103a9b:	68 20 3d 11 80       	push   $0x80113d20
80103aa0:	e8 8b 0d 00 00       	call   80104830 <initlock>
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
80103b0d:	68 fc 7c 10 80       	push   $0x80107cfc
80103b12:	e8 59 c8 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b17:	83 ec 0c             	sub    $0xc,%esp
80103b1a:	68 d8 7d 10 80       	push   $0x80107dd8
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
80103b57:	e8 54 0d 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103b5c:	e8 4f ff ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103b61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b67:	e8 84 0d 00 00       	call   801048f0 <popcli>
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
80103b93:	e8 48 39 00 00       	call   801074e0 <setupkvm>
80103b98:	85 c0                	test   %eax,%eax
80103b9a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b9d:	0f 84 bd 00 00 00    	je     80103c60 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ba3:	83 ec 04             	sub    $0x4,%esp
80103ba6:	68 2c 00 00 00       	push   $0x2c
80103bab:	68 60 b4 10 80       	push   $0x8010b460
80103bb0:	50                   	push   %eax
80103bb1:	e8 3a 36 00 00       	call   801071f0 <inituvm>
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
80103bc6:	e8 c5 0e 00 00       	call   80104a90 <memset>
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
80103c1f:	68 25 7d 10 80       	push   $0x80107d25
80103c24:	50                   	push   %eax
80103c25:	e8 66 10 00 00       	call   80104c90 <safestrcpy>
  p->cwd = namei("/");
80103c2a:	c7 04 24 2e 7d 10 80 	movl   $0x80107d2e,(%esp)
80103c31:	e8 1a e6 ff ff       	call   80102250 <namei>
80103c36:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c39:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c40:	e8 4b 0d 00 00       	call   80104990 <acquire>

  p->state = RUNNABLE;
80103c45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103c4c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c53:	e8 e8 0d 00 00       	call   80104a40 <release>
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
80103c63:	68 0c 7d 10 80       	push   $0x80107d0c
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
80103c78:	e8 33 0c 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103c7d:	e8 2e fe ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103c82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c88:	e8 63 0c 00 00       	call   801048f0 <popcli>
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
80103cb0:	e8 7b 36 00 00       	call   80107330 <allocuvm>
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
80103cc2:	e8 19 34 00 00       	call   801070e0 <switchuvm>
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
80103ce4:	e8 47 37 00 00       	call   80107430 <deallocuvm>
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
80103d09:	e8 a2 0b 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103d0e:	e8 9d fd ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103d13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d19:	e8 d2 0b 00 00       	call   801048f0 <popcli>
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
80103d38:	e8 73 38 00 00       	call   801075b0 <copyuvm>
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
80103db1:	e8 da 0e 00 00       	call   80104c90 <safestrcpy>

  pid = np->pid;
80103db6:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103db9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dc0:	e8 cb 0b 00 00       	call   80104990 <acquire>

  np->state = RUNNABLE;
80103dc5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103dcc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dd3:	e8 68 0c 00 00       	call   80104a40 <release>

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
80103e2b:	e8 60 0b 00 00       	call   80104990 <acquire>
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
80103e54:	05 90 00 00 00       	add    $0x90,%eax
80103e59:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80103e5e:	75 e0                	jne    80103e40 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	68 20 3d 11 80       	push   $0x80113d20
80103e68:	e8 d3 0b 00 00       	call   80104a40 <release>
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
80103eae:	e8 dd 0a 00 00       	call   80104990 <acquire>
80103eb3:	83 c4 10             	add    $0x10,%esp
80103eb6:	eb 16                	jmp    80103ece <scheduler+0x4e>
80103eb8:	90                   	nop
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103ec6:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
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
80103ede:	81 c3 90 00 00 00    	add    $0x90,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ee4:	e8 f7 31 00 00       	call   801070e0 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103ee9:	58                   	pop    %eax
80103eea:	5a                   	pop    %edx
80103eeb:	ff 73 8c             	pushl  -0x74(%ebx)
80103eee:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103eef:	c7 83 7c ff ff ff 04 	movl   $0x4,-0x84(%ebx)
80103ef6:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103ef9:	e8 ed 0d 00 00       	call   80104ceb <swtch>
      switchkvm();
80103efe:	e8 bd 31 00 00       	call   801070c0 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f03:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
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
80103f28:	e8 13 0b 00 00       	call   80104a40 <release>
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
80103f45:	e8 66 09 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80103f4a:	e8 61 fb ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80103f4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f55:	e8 96 09 00 00       	call   801048f0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 3d 11 80       	push   $0x80113d20
80103f62:	e8 f9 09 00 00       	call   80104960 <holding>
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
80103fa3:	e8 43 0d 00 00       	call   80104ceb <swtch>
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
80103fc0:	68 30 7d 10 80       	push   $0x80107d30
80103fc5:	e8 a6 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 5c 7d 10 80       	push   $0x80107d5c
80103fd2:	e8 99 c3 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 4e 7d 10 80       	push   $0x80107d4e
80103fdf:	e8 8c c3 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 42 7d 10 80       	push   $0x80107d42
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
80104009:	e8 a2 08 00 00       	call   801048b0 <pushcli>
  c = mycpu();
8010400e:	e8 9d fa ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104019:	e8 d2 08 00 00       	call   801048f0 <popcli>
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
80104072:	e8 19 09 00 00       	call   80104990 <acquire>

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
80104088:	05 90 00 00 00       	add    $0x90,%eax
8010408d:	3d 54 61 11 80       	cmp    $0x80116154,%eax
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
801040a6:	05 90 00 00 00       	add    $0x90,%eax
801040ab:	3d 54 61 11 80       	cmp    $0x80116154,%eax
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
801040c0:	81 c2 90 00 00 00    	add    $0x90,%edx
801040c6:	81 fa 54 61 11 80    	cmp    $0x80116154,%edx
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
801040e8:	05 90 00 00 00       	add    $0x90,%eax
801040ed:	3d 54 61 11 80       	cmp    $0x80116154,%eax
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
80104117:	68 7d 7d 10 80       	push   $0x80107d7d
8010411c:	e8 4f c2 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104121:	83 ec 0c             	sub    $0xc,%esp
80104124:	68 70 7d 10 80       	push   $0x80107d70
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
8010413c:	e8 4f 08 00 00       	call   80104990 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104141:	e8 6a 07 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80104146:	e8 65 f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 9a 07 00 00       	call   801048f0 <popcli>
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
80104169:	e8 d2 08 00 00       	call   80104a40 <release>
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
80104187:	e8 24 07 00 00       	call   801048b0 <pushcli>
  c = mycpu();
8010418c:	e8 1f f9 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104191:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104197:	e8 54 07 00 00       	call   801048f0 <popcli>
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
801041f5:	e8 b6 06 00 00       	call   801048b0 <pushcli>
  c = mycpu();
801041fa:	e8 b1 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801041ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104205:	e8 e6 06 00 00       	call   801048f0 <popcli>
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
8010423f:	e8 6c 06 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80104244:	e8 67 f8 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104249:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010424f:	e8 9c 06 00 00       	call   801048f0 <popcli>

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
80104271:	e8 1a 07 00 00       	call   80104990 <acquire>
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
80104286:	05 90 00 00 00       	add    $0x90,%eax
8010428b:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80104290:	75 ee                	jne    80104280 <setmemorylimit+0x50>
    if(p->pid == pid) target = p;
  }
	release(&ptable.lock);
80104292:	83 ec 0c             	sub    $0xc,%esp
80104295:	68 20 3d 11 80       	push   $0x80113d20
8010429a:	e8 a1 07 00 00       	call   80104a40 <release>
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
801042c1:	eb 0d                	jmp    801042d0 <setpriority>
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

801042d0 <setpriority>:



int             
setpriority(int pid, int priority)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801042d9:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)



int             
setpriority(int pid, int priority)
{
801042dd:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801042e0:	0f 87 97 00 00 00    	ja     8010437d <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801042e6:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801042e9:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801042ee:	68 20 3d 11 80       	push   $0x80113d20
801042f3:	e8 98 06 00 00       	call   80104990 <acquire>
801042f8:	83 c4 10             	add    $0x10,%esp
801042fb:	eb 11                	jmp    8010430e <setpriority+0x3e>
801042fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104300:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104306:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
8010430c:	74 52                	je     80104360 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
8010430e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104311:	75 ed                	jne    80104300 <setpriority+0x30>
80104313:	8b 43 14             	mov    0x14(%ebx),%eax
80104316:	8b 50 10             	mov    0x10(%eax),%edx
80104319:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010431c:	e8 8f 05 00 00       	call   801048b0 <pushcli>
  c = mycpu();
80104321:	e8 8a f7 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
80104326:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010432c:	e8 bf 05 00 00       	call   801048f0 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
80104331:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104334:	3b 57 10             	cmp    0x10(%edi),%edx
80104337:	75 c7                	jne    80104300 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104339:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
8010433c:	83 ec 0c             	sub    $0xc,%esp
8010433f:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104344:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
80104347:	e8 f4 06 00 00       	call   80104a40 <release>

      return 0;
8010434c:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
8010434f:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
80104352:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
80104354:	5b                   	pop    %ebx
80104355:	5e                   	pop    %esi
80104356:	5f                   	pop    %edi
80104357:	5d                   	pop    %ebp
80104358:	c3                   	ret    
80104359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	68 20 3d 11 80       	push   $0x80113d20
80104368:	e8 d3 06 00 00       	call   80104a40 <release>
  return -1;
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104378:	5b                   	pop    %ebx
80104379:	5e                   	pop    %esi
8010437a:	5f                   	pop    %edi
8010437b:	5d                   	pop    %ebp
8010437c:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
8010437d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104382:	eb f1                	jmp    80104375 <setpriority+0xa5>
80104384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010438a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104390 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	56                   	push   %esi
80104395:	53                   	push   %ebx
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	8b 7d 08             	mov    0x8(%ebp),%edi
8010439c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010439f:	e8 0c 05 00 00       	call   801048b0 <pushcli>
  c = mycpu();
801043a4:	e8 07 f7 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
801043a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043af:	e8 3c 05 00 00       	call   801048f0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
801043b4:	85 db                	test   %ebx,%ebx
801043b6:	0f 84 87 00 00 00    	je     80104443 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
801043bc:	85 f6                	test   %esi,%esi
801043be:	74 76                	je     80104436 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043c0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801043c6:	74 50                	je     80104418 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	68 20 3d 11 80       	push   $0x80113d20
801043d0:	e8 bb 05 00 00       	call   80104990 <acquire>
    release(lk);
801043d5:	89 34 24             	mov    %esi,(%esp)
801043d8:	e8 63 06 00 00       	call   80104a40 <release>
  }
  // Go to sleep.
  p->chan = chan;
801043dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043e7:	e8 54 fb ff ff       	call   80103f40 <sched>
  // Tidy up.
  p->chan = 0;
801043ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801043f3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801043fa:	e8 41 06 00 00       	call   80104a40 <release>
    acquire(lk);
801043ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104402:	83 c4 10             	add    $0x10,%esp
  }
}
80104405:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104408:	5b                   	pop    %ebx
80104409:	5e                   	pop    %esi
8010440a:	5f                   	pop    %edi
8010440b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010440c:	e9 7f 05 00 00       	jmp    80104990 <acquire>
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104418:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010441b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104422:	e8 19 fb ff ff       	call   80103f40 <sched>
  // Tidy up.
  p->chan = 0;
80104427:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010442e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104431:	5b                   	pop    %ebx
80104432:	5e                   	pop    %esi
80104433:	5f                   	pop    %edi
80104434:	5d                   	pop    %ebp
80104435:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	68 8f 7d 10 80       	push   $0x80107d8f
8010443e:	e8 2d bf ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104443:	83 ec 0c             	sub    $0xc,%esp
80104446:	68 89 7d 10 80       	push   $0x80107d89
8010444b:	e8 20 bf ff ff       	call   80100370 <panic>

80104450 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104455:	e8 56 04 00 00       	call   801048b0 <pushcli>
  c = mycpu();
8010445a:	e8 51 f6 ff ff       	call   80103ab0 <mycpu>
  p = c->proc;
8010445f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104465:	e8 86 04 00 00       	call   801048f0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010446a:	83 ec 0c             	sub    $0xc,%esp
8010446d:	68 20 3d 11 80       	push   $0x80113d20
80104472:	e8 19 05 00 00       	call   80104990 <acquire>
80104477:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010447a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010447c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104481:	eb 13                	jmp    80104496 <wait+0x46>
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104488:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010448e:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
80104494:	74 22                	je     801044b8 <wait+0x68>
      if(p->parent != curproc)
80104496:	39 73 14             	cmp    %esi,0x14(%ebx)
80104499:	75 ed                	jne    80104488 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010449b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010449f:	74 35                	je     801044d6 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
801044a7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ac:	81 fb 54 61 11 80    	cmp    $0x80116154,%ebx
801044b2:	75 e2                	jne    80104496 <wait+0x46>
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801044b8:	85 c0                	test   %eax,%eax
801044ba:	74 70                	je     8010452c <wait+0xdc>
801044bc:	8b 46 24             	mov    0x24(%esi),%eax
801044bf:	85 c0                	test   %eax,%eax
801044c1:	75 69                	jne    8010452c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044c3:	83 ec 08             	sub    $0x8,%esp
801044c6:	68 20 3d 11 80       	push   $0x80113d20
801044cb:	56                   	push   %esi
801044cc:	e8 bf fe ff ff       	call   80104390 <sleep>
  }
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	eb a4                	jmp    8010447a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801044d6:	83 ec 0c             	sub    $0xc,%esp
801044d9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801044dc:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044df:	e8 8c e1 ff ff       	call   80102670 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801044e4:	5a                   	pop    %edx
801044e5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801044e8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044ef:	e8 6c 2f 00 00       	call   80107460 <freevm>
        p->pid = 0;
801044f4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044fb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104502:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104506:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010450d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104514:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010451b:	e8 20 05 00 00       	call   80104a40 <release>
        return pid;
80104520:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104523:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104526:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104528:	5b                   	pop    %ebx
80104529:	5e                   	pop    %esi
8010452a:	5d                   	pop    %ebp
8010452b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010452c:	83 ec 0c             	sub    $0xc,%esp
8010452f:	68 20 3d 11 80       	push   $0x80113d20
80104534:	e8 07 05 00 00       	call   80104a40 <release>
      return -1;
80104539:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010453c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010453f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104544:	5b                   	pop    %ebx
80104545:	5e                   	pop    %esi
80104546:	5d                   	pop    %ebp
80104547:	c3                   	ret    
80104548:	90                   	nop
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104550 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 10             	sub    $0x10,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010455a:	68 20 3d 11 80       	push   $0x80113d20
8010455f:	e8 2c 04 00 00       	call   80104990 <acquire>
80104564:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104567:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010456c:	eb 0e                	jmp    8010457c <wakeup+0x2c>
8010456e:	66 90                	xchg   %ax,%ax
80104570:	05 90 00 00 00       	add    $0x90,%eax
80104575:	3d 54 61 11 80       	cmp    $0x80116154,%eax
8010457a:	74 1e                	je     8010459a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010457c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104580:	75 ee                	jne    80104570 <wakeup+0x20>
80104582:	3b 58 20             	cmp    0x20(%eax),%ebx
80104585:	75 e9                	jne    80104570 <wakeup+0x20>
      p->state = RUNNABLE;
80104587:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010458e:	05 90 00 00 00       	add    $0x90,%eax
80104593:	3d 54 61 11 80       	cmp    $0x80116154,%eax
80104598:	75 e2                	jne    8010457c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010459a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801045a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045a5:	e9 96 04 00 00       	jmp    80104a40 <release>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 10             	sub    $0x10,%esp
801045b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045ba:	68 20 3d 11 80       	push   $0x80113d20
801045bf:	e8 cc 03 00 00       	call   80104990 <acquire>
801045c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045c7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801045cc:	eb 0e                	jmp    801045dc <kill+0x2c>
801045ce:	66 90                	xchg   %ax,%ax
801045d0:	05 90 00 00 00       	add    $0x90,%eax
801045d5:	3d 54 61 11 80       	cmp    $0x80116154,%eax
801045da:	74 3c                	je     80104618 <kill+0x68>
    if(p->pid == pid){
801045dc:	39 58 10             	cmp    %ebx,0x10(%eax)
801045df:	75 ef                	jne    801045d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045e1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801045e5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045ec:	74 1a                	je     80104608 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801045ee:	83 ec 0c             	sub    $0xc,%esp
801045f1:	68 20 3d 11 80       	push   $0x80113d20
801045f6:	e8 45 04 00 00       	call   80104a40 <release>
      return 0;
801045fb:	83 c4 10             	add    $0x10,%esp
801045fe:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104600:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104603:	c9                   	leave  
80104604:	c3                   	ret    
80104605:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104608:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010460f:	eb dd                	jmp    801045ee <kill+0x3e>
80104611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104618:	83 ec 0c             	sub    $0xc,%esp
8010461b:	68 20 3d 11 80       	push   $0x80113d20
80104620:	e8 1b 04 00 00       	call   80104a40 <release>
  return -1;
80104625:	83 c4 10             	add    $0x10,%esp
80104628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010462d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104630:	c9                   	leave  
80104631:	c3                   	ret    
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	56                   	push   %esi
80104645:	53                   	push   %ebx
80104646:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104649:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010464e:	83 ec 3c             	sub    $0x3c,%esp
80104651:	eb 27                	jmp    8010467a <procdump+0x3a>
80104653:	90                   	nop
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 2f 81 10 80       	push   $0x8010812f
80104660:	e8 fb bf ff ff       	call   80100660 <cprintf>
80104665:	83 c4 10             	add    $0x10,%esp
80104668:	81 c3 90 00 00 00    	add    $0x90,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010466e:	81 fb c0 61 11 80    	cmp    $0x801161c0,%ebx
80104674:	0f 84 7e 00 00 00    	je     801046f8 <procdump+0xb8>
    if(p->state == UNUSED)
8010467a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010467d:	85 c0                	test   %eax,%eax
8010467f:	74 e7                	je     80104668 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104681:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104684:	ba a0 7d 10 80       	mov    $0x80107da0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104689:	77 11                	ja     8010469c <procdump+0x5c>
8010468b:	8b 14 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104692:	b8 a0 7d 10 80       	mov    $0x80107da0,%eax
80104697:	85 d2                	test   %edx,%edx
80104699:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010469c:	53                   	push   %ebx
8010469d:	52                   	push   %edx
8010469e:	ff 73 a4             	pushl  -0x5c(%ebx)
801046a1:	68 a4 7d 10 80       	push   $0x80107da4
801046a6:	e8 b5 bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801046ab:	83 c4 10             	add    $0x10,%esp
801046ae:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046b2:	75 a4                	jne    80104658 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046b7:	83 ec 08             	sub    $0x8,%esp
801046ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046bd:	50                   	push   %eax
801046be:	8b 43 b0             	mov    -0x50(%ebx),%eax
801046c1:	8b 40 0c             	mov    0xc(%eax),%eax
801046c4:	83 c0 08             	add    $0x8,%eax
801046c7:	50                   	push   %eax
801046c8:	e8 83 01 00 00       	call   80104850 <getcallerpcs>
801046cd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801046d0:	8b 17                	mov    (%edi),%edx
801046d2:	85 d2                	test   %edx,%edx
801046d4:	74 82                	je     80104658 <procdump+0x18>
        cprintf(" %p", pc[i]);
801046d6:	83 ec 08             	sub    $0x8,%esp
801046d9:	83 c7 04             	add    $0x4,%edi
801046dc:	52                   	push   %edx
801046dd:	68 e1 77 10 80       	push   $0x801077e1
801046e2:	e8 79 bf ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801046e7:	83 c4 10             	add    $0x10,%esp
801046ea:	39 f7                	cmp    %esi,%edi
801046ec:	75 e2                	jne    801046d0 <procdump+0x90>
801046ee:	e9 65 ff ff ff       	jmp    80104658 <procdump+0x18>
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801046f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046fb:	5b                   	pop    %ebx
801046fc:	5e                   	pop    %esi
801046fd:	5f                   	pop    %edi
801046fe:	5d                   	pop    %ebp
801046ff:	c3                   	ret    

80104700 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 0c             	sub    $0xc,%esp
80104707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010470a:	68 18 7e 10 80       	push   $0x80107e18
8010470f:	8d 43 04             	lea    0x4(%ebx),%eax
80104712:	50                   	push   %eax
80104713:	e8 18 01 00 00       	call   80104830 <initlock>
  lk->name = name;
80104718:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010471b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104721:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104724:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010472b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010472e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104731:	c9                   	leave  
80104732:	c3                   	ret    
80104733:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	8d 73 04             	lea    0x4(%ebx),%esi
8010474e:	56                   	push   %esi
8010474f:	e8 3c 02 00 00       	call   80104990 <acquire>
  while (lk->locked) {
80104754:	8b 13                	mov    (%ebx),%edx
80104756:	83 c4 10             	add    $0x10,%esp
80104759:	85 d2                	test   %edx,%edx
8010475b:	74 16                	je     80104773 <acquiresleep+0x33>
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104760:	83 ec 08             	sub    $0x8,%esp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	e8 26 fc ff ff       	call   80104390 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010476a:	8b 03                	mov    (%ebx),%eax
8010476c:	83 c4 10             	add    $0x10,%esp
8010476f:	85 c0                	test   %eax,%eax
80104771:	75 ed                	jne    80104760 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104773:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104779:	e8 d2 f3 ff ff       	call   80103b50 <myproc>
8010477e:	8b 40 10             	mov    0x10(%eax),%eax
80104781:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104784:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104787:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010478a:	5b                   	pop    %ebx
8010478b:	5e                   	pop    %esi
8010478c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010478d:	e9 ae 02 00 00       	jmp    80104a40 <release>
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	8d 73 04             	lea    0x4(%ebx),%esi
801047ae:	56                   	push   %esi
801047af:	e8 dc 01 00 00       	call   80104990 <acquire>
  lk->locked = 0;
801047b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047c1:	89 1c 24             	mov    %ebx,(%esp)
801047c4:	e8 87 fd ff ff       	call   80104550 <wakeup>
  release(&lk->lk);
801047c9:	89 75 08             	mov    %esi,0x8(%ebp)
801047cc:	83 c4 10             	add    $0x10,%esp
}
801047cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d2:	5b                   	pop    %ebx
801047d3:	5e                   	pop    %esi
801047d4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801047d5:	e9 66 02 00 00       	jmp    80104a40 <release>
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	31 ff                	xor    %edi,%edi
801047e8:	83 ec 18             	sub    $0x18,%esp
801047eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047ee:	8d 73 04             	lea    0x4(%ebx),%esi
801047f1:	56                   	push   %esi
801047f2:	e8 99 01 00 00       	call   80104990 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047f7:	8b 03                	mov    (%ebx),%eax
801047f9:	83 c4 10             	add    $0x10,%esp
801047fc:	85 c0                	test   %eax,%eax
801047fe:	74 13                	je     80104813 <holdingsleep+0x33>
80104800:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104803:	e8 48 f3 ff ff       	call   80103b50 <myproc>
80104808:	39 58 10             	cmp    %ebx,0x10(%eax)
8010480b:	0f 94 c0             	sete   %al
8010480e:	0f b6 c0             	movzbl %al,%eax
80104811:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104813:	83 ec 0c             	sub    $0xc,%esp
80104816:	56                   	push   %esi
80104817:	e8 24 02 00 00       	call   80104a40 <release>
  return r;
}
8010481c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010481f:	89 f8                	mov    %edi,%eax
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5f                   	pop    %edi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	66 90                	xchg   %ax,%ax
80104828:	66 90                	xchg   %ax,%ax
8010482a:	66 90                	xchg   %ax,%ax
8010482c:	66 90                	xchg   %ax,%ax
8010482e:	66 90                	xchg   %ax,%ax

80104830 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104836:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010483f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104842:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104854:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104857:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010485a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010485d:	31 c0                	xor    %eax,%eax
8010485f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104860:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104866:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010486c:	77 1a                	ja     80104888 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010486e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104871:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104874:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104877:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104879:	83 f8 0a             	cmp    $0xa,%eax
8010487c:	75 e2                	jne    80104860 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010487e:	5b                   	pop    %ebx
8010487f:	5d                   	pop    %ebp
80104880:	c3                   	ret    
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104888:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010488f:	83 c0 01             	add    $0x1,%eax
80104892:	83 f8 0a             	cmp    $0xa,%eax
80104895:	74 e7                	je     8010487e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104897:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010489e:	83 c0 01             	add    $0x1,%eax
801048a1:	83 f8 0a             	cmp    $0xa,%eax
801048a4:	75 e2                	jne    80104888 <getcallerpcs+0x38>
801048a6:	eb d6                	jmp    8010487e <getcallerpcs+0x2e>
801048a8:	90                   	nop
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
801048b7:	9c                   	pushf  
801048b8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801048b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ba:	e8 f1 f1 ff ff       	call   80103ab0 <mycpu>
801048bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048c5:	85 c0                	test   %eax,%eax
801048c7:	75 11                	jne    801048da <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048cf:	e8 dc f1 ff ff       	call   80103ab0 <mycpu>
801048d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048da:	e8 d1 f1 ff ff       	call   80103ab0 <mycpu>
801048df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048e6:	83 c4 04             	add    $0x4,%esp
801048e9:	5b                   	pop    %ebx
801048ea:	5d                   	pop    %ebp
801048eb:	c3                   	ret    
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <popcli>:

void
popcli(void)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048f6:	9c                   	pushf  
801048f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048f8:	f6 c4 02             	test   $0x2,%ah
801048fb:	75 52                	jne    8010494f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048fd:	e8 ae f1 ff ff       	call   80103ab0 <mycpu>
80104902:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104908:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010490b:	85 d2                	test   %edx,%edx
8010490d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104913:	78 2d                	js     80104942 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104915:	e8 96 f1 ff ff       	call   80103ab0 <mycpu>
8010491a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104920:	85 d2                	test   %edx,%edx
80104922:	74 0c                	je     80104930 <popcli+0x40>
    sti();
}
80104924:	c9                   	leave  
80104925:	c3                   	ret    
80104926:	8d 76 00             	lea    0x0(%esi),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104930:	e8 7b f1 ff ff       	call   80103ab0 <mycpu>
80104935:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010493b:	85 c0                	test   %eax,%eax
8010493d:	74 e5                	je     80104924 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010493f:	fb                   	sti    
    sti();
}
80104940:	c9                   	leave  
80104941:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104942:	83 ec 0c             	sub    $0xc,%esp
80104945:	68 3a 7e 10 80       	push   $0x80107e3a
8010494a:	e8 21 ba ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010494f:	83 ec 0c             	sub    $0xc,%esp
80104952:	68 23 7e 10 80       	push   $0x80107e23
80104957:	e8 14 ba ff ff       	call   80100370 <panic>
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104960 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	8b 75 08             	mov    0x8(%ebp),%esi
80104968:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010496a:	e8 41 ff ff ff       	call   801048b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010496f:	8b 06                	mov    (%esi),%eax
80104971:	85 c0                	test   %eax,%eax
80104973:	74 10                	je     80104985 <holding+0x25>
80104975:	8b 5e 08             	mov    0x8(%esi),%ebx
80104978:	e8 33 f1 ff ff       	call   80103ab0 <mycpu>
8010497d:	39 c3                	cmp    %eax,%ebx
8010497f:	0f 94 c3             	sete   %bl
80104982:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104985:	e8 66 ff ff ff       	call   801048f0 <popcli>
  return r;
}
8010498a:	89 d8                	mov    %ebx,%eax
8010498c:	5b                   	pop    %ebx
8010498d:	5e                   	pop    %esi
8010498e:	5d                   	pop    %ebp
8010498f:	c3                   	ret    

80104990 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104997:	e8 14 ff ff ff       	call   801048b0 <pushcli>
  if(holding(lk))
8010499c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010499f:	83 ec 0c             	sub    $0xc,%esp
801049a2:	53                   	push   %ebx
801049a3:	e8 b8 ff ff ff       	call   80104960 <holding>
801049a8:	83 c4 10             	add    $0x10,%esp
801049ab:	85 c0                	test   %eax,%eax
801049ad:	0f 85 7d 00 00 00    	jne    80104a30 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801049b3:	ba 01 00 00 00       	mov    $0x1,%edx
801049b8:	eb 09                	jmp    801049c3 <acquire+0x33>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049c3:	89 d0                	mov    %edx,%eax
801049c5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049c8:	85 c0                	test   %eax,%eax
801049ca:	75 f4                	jne    801049c0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049d4:	e8 d7 f0 ff ff       	call   80103ab0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801049d9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801049db:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801049de:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049e1:	31 c0                	xor    %eax,%eax
801049e3:	90                   	nop
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049e8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801049ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049f4:	77 1a                	ja     80104a10 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049f6:	8b 5a 04             	mov    0x4(%edx),%ebx
801049f9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049fc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801049ff:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a01:	83 f8 0a             	cmp    $0xa,%eax
80104a04:	75 e2                	jne    801049e8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a09:	c9                   	leave  
80104a0a:	c3                   	ret    
80104a0b:	90                   	nop
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104a10:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a17:	83 c0 01             	add    $0x1,%eax
80104a1a:	83 f8 0a             	cmp    $0xa,%eax
80104a1d:	74 e7                	je     80104a06 <acquire+0x76>
    pcs[i] = 0;
80104a1f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a26:	83 c0 01             	add    $0x1,%eax
80104a29:	83 f8 0a             	cmp    $0xa,%eax
80104a2c:	75 e2                	jne    80104a10 <acquire+0x80>
80104a2e:	eb d6                	jmp    80104a06 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104a30:	83 ec 0c             	sub    $0xc,%esp
80104a33:	68 41 7e 10 80       	push   $0x80107e41
80104a38:	e8 33 b9 ff ff       	call   80100370 <panic>
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi

80104a40 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a4a:	53                   	push   %ebx
80104a4b:	e8 10 ff ff ff       	call   80104960 <holding>
80104a50:	83 c4 10             	add    $0x10,%esp
80104a53:	85 c0                	test   %eax,%eax
80104a55:	74 22                	je     80104a79 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104a57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a65:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104a70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a73:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104a74:	e9 77 fe ff ff       	jmp    801048f0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104a79:	83 ec 0c             	sub    $0xc,%esp
80104a7c:	68 49 7e 10 80       	push   $0x80107e49
80104a81:	e8 ea b8 ff ff       	call   80100370 <panic>
80104a86:	66 90                	xchg   %ax,%ax
80104a88:	66 90                	xchg   %ax,%ax
80104a8a:	66 90                	xchg   %ax,%ax
80104a8c:	66 90                	xchg   %ax,%ax
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	53                   	push   %ebx
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
80104a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a9b:	f6 c2 03             	test   $0x3,%dl
80104a9e:	75 05                	jne    80104aa5 <memset+0x15>
80104aa0:	f6 c1 03             	test   $0x3,%cl
80104aa3:	74 13                	je     80104ab8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104aa5:	89 d7                	mov    %edx,%edi
80104aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aaa:	fc                   	cld    
80104aab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104aad:	5b                   	pop    %ebx
80104aae:	89 d0                	mov    %edx,%eax
80104ab0:	5f                   	pop    %edi
80104ab1:	5d                   	pop    %ebp
80104ab2:	c3                   	ret    
80104ab3:	90                   	nop
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104ab8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104abc:	c1 e9 02             	shr    $0x2,%ecx
80104abf:	89 fb                	mov    %edi,%ebx
80104ac1:	89 f8                	mov    %edi,%eax
80104ac3:	c1 e3 18             	shl    $0x18,%ebx
80104ac6:	c1 e0 10             	shl    $0x10,%eax
80104ac9:	09 d8                	or     %ebx,%eax
80104acb:	09 f8                	or     %edi,%eax
80104acd:	c1 e7 08             	shl    $0x8,%edi
80104ad0:	09 f8                	or     %edi,%eax
80104ad2:	89 d7                	mov    %edx,%edi
80104ad4:	fc                   	cld    
80104ad5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ad7:	5b                   	pop    %ebx
80104ad8:	89 d0                	mov    %edx,%eax
80104ada:	5f                   	pop    %edi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi

80104ae0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	8b 45 10             	mov    0x10(%ebp),%eax
80104ae8:	53                   	push   %ebx
80104ae9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104aec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104aef:	85 c0                	test   %eax,%eax
80104af1:	74 29                	je     80104b1c <memcmp+0x3c>
    if(*s1 != *s2)
80104af3:	0f b6 13             	movzbl (%ebx),%edx
80104af6:	0f b6 0e             	movzbl (%esi),%ecx
80104af9:	38 d1                	cmp    %dl,%cl
80104afb:	75 2b                	jne    80104b28 <memcmp+0x48>
80104afd:	8d 78 ff             	lea    -0x1(%eax),%edi
80104b00:	31 c0                	xor    %eax,%eax
80104b02:	eb 14                	jmp    80104b18 <memcmp+0x38>
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b08:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104b0d:	83 c0 01             	add    $0x1,%eax
80104b10:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104b14:	38 ca                	cmp    %cl,%dl
80104b16:	75 10                	jne    80104b28 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b18:	39 f8                	cmp    %edi,%eax
80104b1a:	75 ec                	jne    80104b08 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b1c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104b1d:	31 c0                	xor    %eax,%eax
}
80104b1f:	5e                   	pop    %esi
80104b20:	5f                   	pop    %edi
80104b21:	5d                   	pop    %ebp
80104b22:	c3                   	ret    
80104b23:	90                   	nop
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104b28:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104b2b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104b2c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104b2e:	5e                   	pop    %esi
80104b2f:	5f                   	pop    %edi
80104b30:	5d                   	pop    %ebp
80104b31:	c3                   	ret    
80104b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
80104b45:	8b 45 08             	mov    0x8(%ebp),%eax
80104b48:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b4e:	39 c6                	cmp    %eax,%esi
80104b50:	73 2e                	jae    80104b80 <memmove+0x40>
80104b52:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104b55:	39 c8                	cmp    %ecx,%eax
80104b57:	73 27                	jae    80104b80 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104b59:	85 db                	test   %ebx,%ebx
80104b5b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104b5e:	74 17                	je     80104b77 <memmove+0x37>
      *--d = *--s;
80104b60:	29 d9                	sub    %ebx,%ecx
80104b62:	89 cb                	mov    %ecx,%ebx
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b68:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b6c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104b6f:	83 ea 01             	sub    $0x1,%edx
80104b72:	83 fa ff             	cmp    $0xffffffff,%edx
80104b75:	75 f1                	jne    80104b68 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b77:	5b                   	pop    %ebx
80104b78:	5e                   	pop    %esi
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret    
80104b7b:	90                   	nop
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b80:	31 d2                	xor    %edx,%edx
80104b82:	85 db                	test   %ebx,%ebx
80104b84:	74 f1                	je     80104b77 <memmove+0x37>
80104b86:	8d 76 00             	lea    0x0(%esi),%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104b90:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104b94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b97:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b9a:	39 d3                	cmp    %edx,%ebx
80104b9c:	75 f2                	jne    80104b90 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104b9e:	5b                   	pop    %ebx
80104b9f:	5e                   	pop    %esi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret    
80104ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104bb3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104bb4:	eb 8a                	jmp    80104b40 <memmove>
80104bb6:	8d 76 00             	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bc8:	53                   	push   %ebx
80104bc9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bcf:	85 c9                	test   %ecx,%ecx
80104bd1:	74 37                	je     80104c0a <strncmp+0x4a>
80104bd3:	0f b6 17             	movzbl (%edi),%edx
80104bd6:	0f b6 1e             	movzbl (%esi),%ebx
80104bd9:	84 d2                	test   %dl,%dl
80104bdb:	74 3f                	je     80104c1c <strncmp+0x5c>
80104bdd:	38 d3                	cmp    %dl,%bl
80104bdf:	75 3b                	jne    80104c1c <strncmp+0x5c>
80104be1:	8d 47 01             	lea    0x1(%edi),%eax
80104be4:	01 cf                	add    %ecx,%edi
80104be6:	eb 1b                	jmp    80104c03 <strncmp+0x43>
80104be8:	90                   	nop
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf0:	0f b6 10             	movzbl (%eax),%edx
80104bf3:	84 d2                	test   %dl,%dl
80104bf5:	74 21                	je     80104c18 <strncmp+0x58>
80104bf7:	0f b6 19             	movzbl (%ecx),%ebx
80104bfa:	83 c0 01             	add    $0x1,%eax
80104bfd:	89 ce                	mov    %ecx,%esi
80104bff:	38 da                	cmp    %bl,%dl
80104c01:	75 19                	jne    80104c1c <strncmp+0x5c>
80104c03:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104c05:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104c08:	75 e6                	jne    80104bf0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c0a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104c0b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104c0d:	5e                   	pop    %esi
80104c0e:	5f                   	pop    %edi
80104c0f:	5d                   	pop    %ebp
80104c10:	c3                   	ret    
80104c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c18:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104c1c:	0f b6 c2             	movzbl %dl,%eax
80104c1f:	29 d8                	sub    %ebx,%eax
}
80104c21:	5b                   	pop    %ebx
80104c22:	5e                   	pop    %esi
80104c23:	5f                   	pop    %edi
80104c24:	5d                   	pop    %ebp
80104c25:	c3                   	ret    
80104c26:	8d 76 00             	lea    0x0(%esi),%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 45 08             	mov    0x8(%ebp),%eax
80104c38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c3e:	89 c2                	mov    %eax,%edx
80104c40:	eb 19                	jmp    80104c5b <strncpy+0x2b>
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	83 c3 01             	add    $0x1,%ebx
80104c4b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c4f:	83 c2 01             	add    $0x1,%edx
80104c52:	84 c9                	test   %cl,%cl
80104c54:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c57:	74 09                	je     80104c62 <strncpy+0x32>
80104c59:	89 f1                	mov    %esi,%ecx
80104c5b:	85 c9                	test   %ecx,%ecx
80104c5d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c60:	7f e6                	jg     80104c48 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c62:	31 c9                	xor    %ecx,%ecx
80104c64:	85 f6                	test   %esi,%esi
80104c66:	7e 17                	jle    80104c7f <strncpy+0x4f>
80104c68:	90                   	nop
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c70:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c74:	89 f3                	mov    %esi,%ebx
80104c76:	83 c1 01             	add    $0x1,%ecx
80104c79:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104c7b:	85 db                	test   %ebx,%ebx
80104c7d:	7f f1                	jg     80104c70 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104c7f:	5b                   	pop    %ebx
80104c80:	5e                   	pop    %esi
80104c81:	5d                   	pop    %ebp
80104c82:	c3                   	ret    
80104c83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c98:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c9e:	85 c9                	test   %ecx,%ecx
80104ca0:	7e 26                	jle    80104cc8 <safestrcpy+0x38>
80104ca2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ca6:	89 c1                	mov    %eax,%ecx
80104ca8:	eb 17                	jmp    80104cc1 <safestrcpy+0x31>
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104cb0:	83 c2 01             	add    $0x1,%edx
80104cb3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104cb7:	83 c1 01             	add    $0x1,%ecx
80104cba:	84 db                	test   %bl,%bl
80104cbc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104cbf:	74 04                	je     80104cc5 <safestrcpy+0x35>
80104cc1:	39 f2                	cmp    %esi,%edx
80104cc3:	75 eb                	jne    80104cb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cc5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104cc8:	5b                   	pop    %ebx
80104cc9:	5e                   	pop    %esi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <strlen>:

int
strlen(const char *s)
{
80104cd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cd1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104cd8:	80 3a 00             	cmpb   $0x0,(%edx)
80104cdb:	74 0c                	je     80104ce9 <strlen+0x19>
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	83 c0 01             	add    $0x1,%eax
80104ce3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ce7:	75 f7                	jne    80104ce0 <strlen+0x10>
    ;
  return n;
}
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    

80104ceb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ceb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104cef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104cf3:	55                   	push   %ebp
  pushl %ebx
80104cf4:	53                   	push   %ebx
  pushl %esi
80104cf5:	56                   	push   %esi
  pushl %edi
80104cf6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cf7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cf9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104cfb:	5f                   	pop    %edi
  popl %esi
80104cfc:	5e                   	pop    %esi
  popl %ebx
80104cfd:	5b                   	pop    %ebx
  popl %ebp
80104cfe:	5d                   	pop    %ebp
  ret
80104cff:	c3                   	ret    

80104d00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d0a:	e8 41 ee ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d0f:	8b 00                	mov    (%eax),%eax
80104d11:	39 d8                	cmp    %ebx,%eax
80104d13:	76 1b                	jbe    80104d30 <fetchint+0x30>
80104d15:	8d 53 04             	lea    0x4(%ebx),%edx
80104d18:	39 d0                	cmp    %edx,%eax
80104d1a:	72 14                	jb     80104d30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1f:	8b 13                	mov    (%ebx),%edx
80104d21:	89 10                	mov    %edx,(%eax)
  return 0;
80104d23:	31 c0                	xor    %eax,%eax
}
80104d25:	83 c4 04             	add    $0x4,%esp
80104d28:	5b                   	pop    %ebx
80104d29:	5d                   	pop    %ebp
80104d2a:	c3                   	ret    
80104d2b:	90                   	nop
80104d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d35:	eb ee                	jmp    80104d25 <fetchint+0x25>
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 04             	sub    $0x4,%esp
80104d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d4a:	e8 01 ee ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz)
80104d4f:	39 18                	cmp    %ebx,(%eax)
80104d51:	76 29                	jbe    80104d7c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d56:	89 da                	mov    %ebx,%edx
80104d58:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d5a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d5c:	39 c3                	cmp    %eax,%ebx
80104d5e:	73 1c                	jae    80104d7c <fetchstr+0x3c>
    if(*s == 0)
80104d60:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d63:	75 10                	jne    80104d75 <fetchstr+0x35>
80104d65:	eb 29                	jmp    80104d90 <fetchstr+0x50>
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d70:	80 3a 00             	cmpb   $0x0,(%edx)
80104d73:	74 1b                	je     80104d90 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104d75:	83 c2 01             	add    $0x1,%edx
80104d78:	39 d0                	cmp    %edx,%eax
80104d7a:	77 f4                	ja     80104d70 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104d7c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104d7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104d84:	5b                   	pop    %ebx
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d90:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104d93:	89 d0                	mov    %edx,%eax
80104d95:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104d97:	5b                   	pop    %ebx
80104d98:	5d                   	pop    %ebp
80104d99:	c3                   	ret    
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104da5:	e8 a6 ed ff ff       	call   80103b50 <myproc>
80104daa:	8b 40 18             	mov    0x18(%eax),%eax
80104dad:	8b 55 08             	mov    0x8(%ebp),%edx
80104db0:	8b 40 44             	mov    0x44(%eax),%eax
80104db3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104db6:	e8 95 ed ff ff       	call   80103b50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbb:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dbd:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dc0:	39 c6                	cmp    %eax,%esi
80104dc2:	73 1c                	jae    80104de0 <argint+0x40>
80104dc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104dc7:	39 d0                	cmp    %edx,%eax
80104dc9:	72 15                	jb     80104de0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dce:	8b 53 04             	mov    0x4(%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret    
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ee                	jmp    80104dd5 <argint+0x35>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	83 ec 10             	sub    $0x10,%esp
80104df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dfb:	e8 50 ed ff ff       	call   80103b50 <myproc>
80104e00:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104e02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e05:	83 ec 08             	sub    $0x8,%esp
80104e08:	50                   	push   %eax
80104e09:	ff 75 08             	pushl  0x8(%ebp)
80104e0c:	e8 8f ff ff ff       	call   80104da0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e11:	c1 e8 1f             	shr    $0x1f,%eax
80104e14:	83 c4 10             	add    $0x10,%esp
80104e17:	84 c0                	test   %al,%al
80104e19:	75 2d                	jne    80104e48 <argptr+0x58>
80104e1b:	89 d8                	mov    %ebx,%eax
80104e1d:	c1 e8 1f             	shr    $0x1f,%eax
80104e20:	84 c0                	test   %al,%al
80104e22:	75 24                	jne    80104e48 <argptr+0x58>
80104e24:	8b 16                	mov    (%esi),%edx
80104e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e29:	39 c2                	cmp    %eax,%edx
80104e2b:	76 1b                	jbe    80104e48 <argptr+0x58>
80104e2d:	01 c3                	add    %eax,%ebx
80104e2f:	39 da                	cmp    %ebx,%edx
80104e31:	72 15                	jb     80104e48 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104e33:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e36:	89 02                	mov    %eax,(%edx)
  return 0;
80104e38:	31 c0                	xor    %eax,%eax
}
80104e3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e3d:	5b                   	pop    %ebx
80104e3e:	5e                   	pop    %esi
80104e3f:	5d                   	pop    %ebp
80104e40:	c3                   	ret    
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4d:	eb eb                	jmp    80104e3a <argptr+0x4a>
80104e4f:	90                   	nop

80104e50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e59:	50                   	push   %eax
80104e5a:	ff 75 08             	pushl  0x8(%ebp)
80104e5d:	e8 3e ff ff ff       	call   80104da0 <argint>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 17                	js     80104e80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e69:	83 ec 08             	sub    $0x8,%esp
80104e6c:	ff 75 0c             	pushl  0xc(%ebp)
80104e6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e72:	e8 c9 fe ff ff       	call   80104d40 <fetchstr>
80104e77:	83 c4 10             	add    $0x10,%esp
}
80104e7a:	c9                   	leave  
80104e7b:	c3                   	ret    
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <syscall>:
[SYS_setmemorylimit] sys_setmemorylimit,
};

void
syscall(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104e95:	e8 b6 ec ff ff       	call   80103b50 <myproc>

  num = curproc->tf->eax;
80104e9a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104e9d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e9f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ea2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ea5:	83 fa 1a             	cmp    $0x1a,%edx
80104ea8:	77 1e                	ja     80104ec8 <syscall+0x38>
80104eaa:	8b 14 85 80 7e 10 80 	mov    -0x7fef8180(,%eax,4),%edx
80104eb1:	85 d2                	test   %edx,%edx
80104eb3:	74 13                	je     80104ec8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104eb5:	ff d2                	call   *%edx
80104eb7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104eba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ebd:	5b                   	pop    %ebx
80104ebe:	5e                   	pop    %esi
80104ebf:	5d                   	pop    %ebp
80104ec0:	c3                   	ret    
80104ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104ec8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ec9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104ecc:	50                   	push   %eax
80104ecd:	ff 73 10             	pushl  0x10(%ebx)
80104ed0:	68 51 7e 10 80       	push   $0x80107e51
80104ed5:	e8 86 b7 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104eda:	8b 43 18             	mov    0x18(%ebx),%eax
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104ee7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eea:	5b                   	pop    %ebx
80104eeb:	5e                   	pop    %esi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret    
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	57                   	push   %edi
80104ef4:	56                   	push   %esi
80104ef5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ef6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ef9:	83 ec 34             	sub    $0x34,%esp
80104efc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104eff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f02:	56                   	push   %esi
80104f03:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f04:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f0a:	e8 61 d3 ff ff       	call   80102270 <nameiparent>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	85 c0                	test   %eax,%eax
80104f14:	0f 84 f6 00 00 00    	je     80105010 <create+0x120>
    return 0;
  ilock(dp);
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	89 c7                	mov    %eax,%edi
80104f1f:	50                   	push   %eax
80104f20:	e8 db ca ff ff       	call   80101a00 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104f25:	83 c4 0c             	add    $0xc,%esp
80104f28:	6a 00                	push   $0x0
80104f2a:	56                   	push   %esi
80104f2b:	57                   	push   %edi
80104f2c:	e8 ff cf ff ff       	call   80101f30 <dirlookup>
80104f31:	83 c4 10             	add    $0x10,%esp
80104f34:	85 c0                	test   %eax,%eax
80104f36:	89 c3                	mov    %eax,%ebx
80104f38:	74 56                	je     80104f90 <create+0xa0>
    iunlockput(dp);
80104f3a:	83 ec 0c             	sub    $0xc,%esp
80104f3d:	57                   	push   %edi
80104f3e:	e8 4d cd ff ff       	call   80101c90 <iunlockput>
    ilock(ip);
80104f43:	89 1c 24             	mov    %ebx,(%esp)
80104f46:	e8 b5 ca ff ff       	call   80101a00 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f4b:	83 c4 10             	add    $0x10,%esp
80104f4e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f53:	75 1b                	jne    80104f70 <create+0x80>
80104f55:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104f5a:	89 d8                	mov    %ebx,%eax
80104f5c:	75 12                	jne    80104f70 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f61:	5b                   	pop    %ebx
80104f62:	5e                   	pop    %esi
80104f63:	5f                   	pop    %edi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	8d 76 00             	lea    0x0(%esi),%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104f70:	83 ec 0c             	sub    $0xc,%esp
80104f73:	53                   	push   %ebx
80104f74:	e8 17 cd ff ff       	call   80101c90 <iunlockput>
    return 0;
80104f79:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104f7f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f81:	5b                   	pop    %ebx
80104f82:	5e                   	pop    %esi
80104f83:	5f                   	pop    %edi
80104f84:	5d                   	pop    %ebp
80104f85:	c3                   	ret    
80104f86:	8d 76 00             	lea    0x0(%esi),%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104f90:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f94:	83 ec 08             	sub    $0x8,%esp
80104f97:	50                   	push   %eax
80104f98:	ff 37                	pushl  (%edi)
80104f9a:	e8 f1 c8 ff ff       	call   80101890 <ialloc>
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	89 c3                	mov    %eax,%ebx
80104fa6:	0f 84 cc 00 00 00    	je     80105078 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104fac:	83 ec 0c             	sub    $0xc,%esp
80104faf:	50                   	push   %eax
80104fb0:	e8 4b ca ff ff       	call   80101a00 <ilock>
  ip->major = major;
80104fb5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104fb9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104fbd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104fc1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104fc5:	b8 01 00 00 00       	mov    $0x1,%eax
80104fca:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104fce:	89 1c 24             	mov    %ebx,(%esp)
80104fd1:	e8 7a c9 ff ff       	call   80101950 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104fd6:	83 c4 10             	add    $0x10,%esp
80104fd9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104fde:	74 40                	je     80105020 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104fe0:	83 ec 04             	sub    $0x4,%esp
80104fe3:	ff 73 04             	pushl  0x4(%ebx)
80104fe6:	56                   	push   %esi
80104fe7:	57                   	push   %edi
80104fe8:	e8 a3 d1 ff ff       	call   80102190 <dirlink>
80104fed:	83 c4 10             	add    $0x10,%esp
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	78 77                	js     8010506b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	57                   	push   %edi
80104ff8:	e8 93 cc ff ff       	call   80101c90 <iunlockput>

  return ip;
80104ffd:	83 c4 10             	add    $0x10,%esp
}
80105000:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105003:	89 d8                	mov    %ebx,%eax
}
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5f                   	pop    %edi
80105008:	5d                   	pop    %ebp
80105009:	c3                   	ret    
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105010:	31 c0                	xor    %eax,%eax
80105012:	e9 47 ff ff ff       	jmp    80104f5e <create+0x6e>
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105020:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105025:	83 ec 0c             	sub    $0xc,%esp
80105028:	57                   	push   %edi
80105029:	e8 22 c9 ff ff       	call   80101950 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010502e:	83 c4 0c             	add    $0xc,%esp
80105031:	ff 73 04             	pushl  0x4(%ebx)
80105034:	68 0c 7f 10 80       	push   $0x80107f0c
80105039:	53                   	push   %ebx
8010503a:	e8 51 d1 ff ff       	call   80102190 <dirlink>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	85 c0                	test   %eax,%eax
80105044:	78 18                	js     8010505e <create+0x16e>
80105046:	83 ec 04             	sub    $0x4,%esp
80105049:	ff 77 04             	pushl  0x4(%edi)
8010504c:	68 0b 7f 10 80       	push   $0x80107f0b
80105051:	53                   	push   %ebx
80105052:	e8 39 d1 ff ff       	call   80102190 <dirlink>
80105057:	83 c4 10             	add    $0x10,%esp
8010505a:	85 c0                	test   %eax,%eax
8010505c:	79 82                	jns    80104fe0 <create+0xf0>
      panic("create dots");
8010505e:	83 ec 0c             	sub    $0xc,%esp
80105061:	68 ff 7e 10 80       	push   $0x80107eff
80105066:	e8 05 b3 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010506b:	83 ec 0c             	sub    $0xc,%esp
8010506e:	68 0e 7f 10 80       	push   $0x80107f0e
80105073:	e8 f8 b2 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105078:	83 ec 0c             	sub    $0xc,%esp
8010507b:	68 f0 7e 10 80       	push   $0x80107ef0
80105080:	e8 eb b2 ff ff       	call   80100370 <panic>
80105085:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
80105095:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105097:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010509a:	89 d3                	mov    %edx,%ebx
8010509c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010509f:	50                   	push   %eax
801050a0:	6a 00                	push   $0x0
801050a2:	e8 f9 fc ff ff       	call   80104da0 <argint>
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	85 c0                	test   %eax,%eax
801050ac:	78 32                	js     801050e0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050b2:	77 2c                	ja     801050e0 <argfd.constprop.0+0x50>
801050b4:	e8 97 ea ff ff       	call   80103b50 <myproc>
801050b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050c0:	85 c0                	test   %eax,%eax
801050c2:	74 1c                	je     801050e0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801050c4:	85 f6                	test   %esi,%esi
801050c6:	74 02                	je     801050ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801050c8:	89 16                	mov    %edx,(%esi)
  if(pf)
801050ca:	85 db                	test   %ebx,%ebx
801050cc:	74 22                	je     801050f0 <argfd.constprop.0+0x60>
    *pf = f;
801050ce:	89 03                	mov    %eax,(%ebx)
  return 0;
801050d0:	31 c0                	xor    %eax,%eax
}
801050d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d5:	5b                   	pop    %ebx
801050d6:	5e                   	pop    %esi
801050d7:	5d                   	pop    %ebp
801050d8:	c3                   	ret    
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801050e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801050e8:	5b                   	pop    %ebx
801050e9:	5e                   	pop    %esi
801050ea:	5d                   	pop    %ebp
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801050f0:	31 c0                	xor    %eax,%eax
801050f2:	eb de                	jmp    801050d2 <argfd.constprop.0+0x42>
801050f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105100 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105100:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105101:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	56                   	push   %esi
80105106:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105107:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010510a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010510d:	e8 7e ff ff ff       	call   80105090 <argfd.constprop.0>
80105112:	85 c0                	test   %eax,%eax
80105114:	78 1a                	js     80105130 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105116:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105118:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010511b:	e8 30 ea ff ff       	call   80103b50 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	74 18                	je     80105140 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	75 f0                	jne    80105120 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105130:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105138:	5b                   	pop    %ebx
80105139:	5e                   	pop    %esi
8010513a:	5d                   	pop    %ebp
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105140:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	ff 75 f4             	pushl  -0xc(%ebp)
8010514a:	e8 31 c0 ff ff       	call   80101180 <filedup>
  return fd;
8010514f:	83 c4 10             	add    $0x10,%esp
}
80105152:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105155:	89 d8                	mov    %ebx,%eax
}
80105157:	5b                   	pop    %ebx
80105158:	5e                   	pop    %esi
80105159:	5d                   	pop    %ebp
8010515a:	c3                   	ret    
8010515b:	90                   	nop
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_read>:

int
sys_read(void)
{
80105160:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105161:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105168:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010516b:	e8 20 ff ff ff       	call   80105090 <argfd.constprop.0>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 4c                	js     801051c0 <sys_read+0x60>
80105174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105177:	83 ec 08             	sub    $0x8,%esp
8010517a:	50                   	push   %eax
8010517b:	6a 02                	push   $0x2
8010517d:	e8 1e fc ff ff       	call   80104da0 <argint>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 37                	js     801051c0 <sys_read+0x60>
80105189:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518c:	83 ec 04             	sub    $0x4,%esp
8010518f:	ff 75 f0             	pushl  -0x10(%ebp)
80105192:	50                   	push   %eax
80105193:	6a 01                	push   $0x1
80105195:	e8 56 fc ff ff       	call   80104df0 <argptr>
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	85 c0                	test   %eax,%eax
8010519f:	78 1f                	js     801051c0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801051a1:	83 ec 04             	sub    $0x4,%esp
801051a4:	ff 75 f0             	pushl  -0x10(%ebp)
801051a7:	ff 75 f4             	pushl  -0xc(%ebp)
801051aa:	ff 75 ec             	pushl  -0x14(%ebp)
801051ad:	e8 3e c1 ff ff       	call   801012f0 <fileread>
801051b2:	83 c4 10             	add    $0x10,%esp
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_write>:

int
sys_write(void)
{
801051d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051db:	e8 b0 fe ff ff       	call   80105090 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 4c                	js     80105230 <sys_write+0x60>
801051e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 02                	push   $0x2
801051ed:	e8 ae fb ff ff       	call   80104da0 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 37                	js     80105230 <sys_write+0x60>
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	83 ec 04             	sub    $0x4,%esp
801051ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105202:	50                   	push   %eax
80105203:	6a 01                	push   $0x1
80105205:	e8 e6 fb ff ff       	call   80104df0 <argptr>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	78 1f                	js     80105230 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	ff 75 f0             	pushl  -0x10(%ebp)
80105217:	ff 75 f4             	pushl  -0xc(%ebp)
8010521a:	ff 75 ec             	pushl  -0x14(%ebp)
8010521d:	e8 5e c1 ff ff       	call   80101380 <filewrite>
80105222:	83 c4 10             	add    $0x10,%esp
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_close>:

int
sys_close(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105246:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105249:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524c:	e8 3f fe ff ff       	call   80105090 <argfd.constprop.0>
80105251:	85 c0                	test   %eax,%eax
80105253:	78 2b                	js     80105280 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105255:	e8 f6 e8 ff ff       	call   80103b50 <myproc>
8010525a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010525d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105260:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105267:	00 
  fileclose(f);
80105268:	ff 75 f4             	pushl  -0xc(%ebp)
8010526b:	e8 60 bf ff ff       	call   801011d0 <fileclose>
  return 0;
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	31 c0                	xor    %eax,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_fstat>:

int
sys_fstat(void)
{
80105290:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105291:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105298:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010529b:	e8 f0 fd ff ff       	call   80105090 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 2c                	js     801052d0 <sys_fstat+0x40>
801052a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a7:	83 ec 04             	sub    $0x4,%esp
801052aa:	6a 14                	push   $0x14
801052ac:	50                   	push   %eax
801052ad:	6a 01                	push   $0x1
801052af:	e8 3c fb ff ff       	call   80104df0 <argptr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	78 15                	js     801052d0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801052bb:	83 ec 08             	sub    $0x8,%esp
801052be:	ff 75 f4             	pushl  -0xc(%ebp)
801052c1:	ff 75 f0             	pushl  -0x10(%ebp)
801052c4:	e8 d7 bf ff ff       	call   801012a0 <filestat>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	c9                   	leave  
801052cd:	c3                   	ret    
801052ce:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052e6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052e9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ec:	50                   	push   %eax
801052ed:	6a 00                	push   $0x0
801052ef:	e8 5c fb ff ff       	call   80104e50 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	0f 88 fb 00 00 00    	js     801053fa <sys_link+0x11a>
801052ff:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105302:	83 ec 08             	sub    $0x8,%esp
80105305:	50                   	push   %eax
80105306:	6a 01                	push   $0x1
80105308:	e8 43 fb ff ff       	call   80104e50 <argstr>
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	85 c0                	test   %eax,%eax
80105312:	0f 88 e2 00 00 00    	js     801053fa <sys_link+0x11a>
    return -1;

  begin_op();
80105318:	e8 c3 db ff ff       	call   80102ee0 <begin_op>
  if((ip = namei(old)) == 0){
8010531d:	83 ec 0c             	sub    $0xc,%esp
80105320:	ff 75 d4             	pushl  -0x2c(%ebp)
80105323:	e8 28 cf ff ff       	call   80102250 <namei>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c3                	mov    %eax,%ebx
8010532f:	0f 84 f3 00 00 00    	je     80105428 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 c2 c6 ff ff       	call   80101a00 <ilock>
  if(ip->type == T_DIR){
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105346:	0f 84 c4 00 00 00    	je     80105410 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010534c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105354:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105357:	53                   	push   %ebx
80105358:	e8 f3 c5 ff ff       	call   80101950 <iupdate>
  iunlock(ip);
8010535d:	89 1c 24             	mov    %ebx,(%esp)
80105360:	e8 7b c7 ff ff       	call   80101ae0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105365:	58                   	pop    %eax
80105366:	5a                   	pop    %edx
80105367:	57                   	push   %edi
80105368:	ff 75 d0             	pushl  -0x30(%ebp)
8010536b:	e8 00 cf ff ff       	call   80102270 <nameiparent>
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	85 c0                	test   %eax,%eax
80105375:	89 c6                	mov    %eax,%esi
80105377:	74 5b                	je     801053d4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	50                   	push   %eax
8010537d:	e8 7e c6 ff ff       	call   80101a00 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	8b 03                	mov    (%ebx),%eax
80105387:	39 06                	cmp    %eax,(%esi)
80105389:	75 3d                	jne    801053c8 <sys_link+0xe8>
8010538b:	83 ec 04             	sub    $0x4,%esp
8010538e:	ff 73 04             	pushl  0x4(%ebx)
80105391:	57                   	push   %edi
80105392:	56                   	push   %esi
80105393:	e8 f8 cd ff ff       	call   80102190 <dirlink>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	78 29                	js     801053c8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	56                   	push   %esi
801053a3:	e8 e8 c8 ff ff       	call   80101c90 <iunlockput>
  iput(ip);
801053a8:	89 1c 24             	mov    %ebx,(%esp)
801053ab:	e8 80 c7 ff ff       	call   80101b30 <iput>

  end_op();
801053b0:	e8 9b db ff ff       	call   80102f50 <end_op>

  return 0;
801053b5:	83 c4 10             	add    $0x10,%esp
801053b8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053bd:	5b                   	pop    %ebx
801053be:	5e                   	pop    %esi
801053bf:	5f                   	pop    %edi
801053c0:	5d                   	pop    %ebp
801053c1:	c3                   	ret    
801053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	56                   	push   %esi
801053cc:	e8 bf c8 ff ff       	call   80101c90 <iunlockput>
    goto bad;
801053d1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	53                   	push   %ebx
801053d8:	e8 23 c6 ff ff       	call   80101a00 <ilock>
  ip->nlink--;
801053dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053e2:	89 1c 24             	mov    %ebx,(%esp)
801053e5:	e8 66 c5 ff ff       	call   80101950 <iupdate>
  iunlockput(ip);
801053ea:	89 1c 24             	mov    %ebx,(%esp)
801053ed:	e8 9e c8 ff ff       	call   80101c90 <iunlockput>
  end_op();
801053f2:	e8 59 db ff ff       	call   80102f50 <end_op>
  return -1;
801053f7:	83 c4 10             	add    $0x10,%esp
}
801053fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801053fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5f                   	pop    %edi
80105405:	5d                   	pop    %ebp
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	53                   	push   %ebx
80105414:	e8 77 c8 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105419:	e8 32 db ff ff       	call   80102f50 <end_op>
    return -1;
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb 92                	jmp    801053ba <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105428:	e8 23 db ff ff       	call   80102f50 <end_op>
    return -1;
8010542d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105432:	eb 86                	jmp    801053ba <sys_link+0xda>
80105434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010543a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105440 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105446:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105449:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010544c:	50                   	push   %eax
8010544d:	6a 00                	push   $0x0
8010544f:	e8 fc f9 ff ff       	call   80104e50 <argstr>
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	85 c0                	test   %eax,%eax
80105459:	0f 88 82 01 00 00    	js     801055e1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010545f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105462:	e8 79 da ff ff       	call   80102ee0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105467:	83 ec 08             	sub    $0x8,%esp
8010546a:	53                   	push   %ebx
8010546b:	ff 75 c0             	pushl  -0x40(%ebp)
8010546e:	e8 fd cd ff ff       	call   80102270 <nameiparent>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010547b:	0f 84 6a 01 00 00    	je     801055eb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105481:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	56                   	push   %esi
80105488:	e8 73 c5 ff ff       	call   80101a00 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010548d:	58                   	pop    %eax
8010548e:	5a                   	pop    %edx
8010548f:	68 0c 7f 10 80       	push   $0x80107f0c
80105494:	53                   	push   %ebx
80105495:	e8 76 ca ff ff       	call   80101f10 <namecmp>
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	85 c0                	test   %eax,%eax
8010549f:	0f 84 fc 00 00 00    	je     801055a1 <sys_unlink+0x161>
801054a5:	83 ec 08             	sub    $0x8,%esp
801054a8:	68 0b 7f 10 80       	push   $0x80107f0b
801054ad:	53                   	push   %ebx
801054ae:	e8 5d ca ff ff       	call   80101f10 <namecmp>
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	0f 84 e3 00 00 00    	je     801055a1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801054be:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054c1:	83 ec 04             	sub    $0x4,%esp
801054c4:	50                   	push   %eax
801054c5:	53                   	push   %ebx
801054c6:	56                   	push   %esi
801054c7:	e8 64 ca ff ff       	call   80101f30 <dirlookup>
801054cc:	83 c4 10             	add    $0x10,%esp
801054cf:	85 c0                	test   %eax,%eax
801054d1:	89 c3                	mov    %eax,%ebx
801054d3:	0f 84 c8 00 00 00    	je     801055a1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	50                   	push   %eax
801054dd:	e8 1e c5 ff ff       	call   80101a00 <ilock>

  if(ip->nlink < 1)
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054ea:	0f 8e 24 01 00 00    	jle    80105614 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801054f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054f5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801054f8:	74 66                	je     80105560 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801054fa:	83 ec 04             	sub    $0x4,%esp
801054fd:	6a 10                	push   $0x10
801054ff:	6a 00                	push   $0x0
80105501:	56                   	push   %esi
80105502:	e8 89 f5 ff ff       	call   80104a90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105507:	6a 10                	push   $0x10
80105509:	ff 75 c4             	pushl  -0x3c(%ebp)
8010550c:	56                   	push   %esi
8010550d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105510:	e8 cb c8 ff ff       	call   80101de0 <writei>
80105515:	83 c4 20             	add    $0x20,%esp
80105518:	83 f8 10             	cmp    $0x10,%eax
8010551b:	0f 85 e6 00 00 00    	jne    80105607 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105521:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105526:	0f 84 9c 00 00 00    	je     801055c8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105532:	e8 59 c7 ff ff       	call   80101c90 <iunlockput>

  ip->nlink--;
80105537:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010553c:	89 1c 24             	mov    %ebx,(%esp)
8010553f:	e8 0c c4 ff ff       	call   80101950 <iupdate>
  iunlockput(ip);
80105544:	89 1c 24             	mov    %ebx,(%esp)
80105547:	e8 44 c7 ff ff       	call   80101c90 <iunlockput>

  end_op();
8010554c:	e8 ff d9 ff ff       	call   80102f50 <end_op>

  return 0;
80105551:	83 c4 10             	add    $0x10,%esp
80105554:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105556:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105559:	5b                   	pop    %ebx
8010555a:	5e                   	pop    %esi
8010555b:	5f                   	pop    %edi
8010555c:	5d                   	pop    %ebp
8010555d:	c3                   	ret    
8010555e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105560:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105564:	76 94                	jbe    801054fa <sys_unlink+0xba>
80105566:	bf 20 00 00 00       	mov    $0x20,%edi
8010556b:	eb 0f                	jmp    8010557c <sys_unlink+0x13c>
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
80105570:	83 c7 10             	add    $0x10,%edi
80105573:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105576:	0f 83 7e ff ff ff    	jae    801054fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010557c:	6a 10                	push   $0x10
8010557e:	57                   	push   %edi
8010557f:	56                   	push   %esi
80105580:	53                   	push   %ebx
80105581:	e8 5a c7 ff ff       	call   80101ce0 <readi>
80105586:	83 c4 10             	add    $0x10,%esp
80105589:	83 f8 10             	cmp    $0x10,%eax
8010558c:	75 6c                	jne    801055fa <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010558e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105593:	74 db                	je     80105570 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105595:	83 ec 0c             	sub    $0xc,%esp
80105598:	53                   	push   %ebx
80105599:	e8 f2 c6 ff ff       	call   80101c90 <iunlockput>
    goto bad;
8010559e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801055a1:	83 ec 0c             	sub    $0xc,%esp
801055a4:	ff 75 b4             	pushl  -0x4c(%ebp)
801055a7:	e8 e4 c6 ff ff       	call   80101c90 <iunlockput>
  end_op();
801055ac:	e8 9f d9 ff ff       	call   80102f50 <end_op>
  return -1;
801055b1:	83 c4 10             	add    $0x10,%esp
}
801055b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801055b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055bc:	5b                   	pop    %ebx
801055bd:	5e                   	pop    %esi
801055be:	5f                   	pop    %edi
801055bf:	5d                   	pop    %ebp
801055c0:	c3                   	ret    
801055c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801055c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801055cb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801055ce:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801055d3:	50                   	push   %eax
801055d4:	e8 77 c3 ff ff       	call   80101950 <iupdate>
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	e9 4b ff ff ff       	jmp    8010552c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801055e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e6:	e9 6b ff ff ff       	jmp    80105556 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801055eb:	e8 60 d9 ff ff       	call   80102f50 <end_op>
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f5:	e9 5c ff ff ff       	jmp    80105556 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801055fa:	83 ec 0c             	sub    $0xc,%esp
801055fd:	68 30 7f 10 80       	push   $0x80107f30
80105602:	e8 69 ad ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105607:	83 ec 0c             	sub    $0xc,%esp
8010560a:	68 42 7f 10 80       	push   $0x80107f42
8010560f:	e8 5c ad ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105614:	83 ec 0c             	sub    $0xc,%esp
80105617:	68 1e 7f 10 80       	push   $0x80107f1e
8010561c:	e8 4f ad ff ff       	call   80100370 <panic>
80105621:	eb 0d                	jmp    80105630 <sys_open>
80105623:	90                   	nop
80105624:	90                   	nop
80105625:	90                   	nop
80105626:	90                   	nop
80105627:	90                   	nop
80105628:	90                   	nop
80105629:	90                   	nop
8010562a:	90                   	nop
8010562b:	90                   	nop
8010562c:	90                   	nop
8010562d:	90                   	nop
8010562e:	90                   	nop
8010562f:	90                   	nop

80105630 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	56                   	push   %esi
80105635:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105636:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105639:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010563c:	50                   	push   %eax
8010563d:	6a 00                	push   $0x0
8010563f:	e8 0c f8 ff ff       	call   80104e50 <argstr>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
80105649:	0f 88 9e 00 00 00    	js     801056ed <sys_open+0xbd>
8010564f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105652:	83 ec 08             	sub    $0x8,%esp
80105655:	50                   	push   %eax
80105656:	6a 01                	push   $0x1
80105658:	e8 43 f7 ff ff       	call   80104da0 <argint>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	0f 88 85 00 00 00    	js     801056ed <sys_open+0xbd>
    return -1;

  begin_op();
80105668:	e8 73 d8 ff ff       	call   80102ee0 <begin_op>

  if(omode & O_CREATE){
8010566d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105671:	0f 85 89 00 00 00    	jne    80105700 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105677:	83 ec 0c             	sub    $0xc,%esp
8010567a:	ff 75 e0             	pushl  -0x20(%ebp)
8010567d:	e8 ce cb ff ff       	call   80102250 <namei>
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	85 c0                	test   %eax,%eax
80105687:	89 c6                	mov    %eax,%esi
80105689:	0f 84 8e 00 00 00    	je     8010571d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	50                   	push   %eax
80105693:	e8 68 c3 ff ff       	call   80101a00 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056a0:	0f 84 d2 00 00 00    	je     80105778 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056a6:	e8 65 ba ff ff       	call   80101110 <filealloc>
801056ab:	85 c0                	test   %eax,%eax
801056ad:	89 c7                	mov    %eax,%edi
801056af:	74 2b                	je     801056dc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801056b1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801056b3:	e8 98 e4 ff ff       	call   80103b50 <myproc>
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801056c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056c4:	85 d2                	test   %edx,%edx
801056c6:	74 68                	je     80105730 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801056c8:	83 c3 01             	add    $0x1,%ebx
801056cb:	83 fb 10             	cmp    $0x10,%ebx
801056ce:	75 f0                	jne    801056c0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	57                   	push   %edi
801056d4:	e8 f7 ba ff ff       	call   801011d0 <fileclose>
801056d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	56                   	push   %esi
801056e0:	e8 ab c5 ff ff       	call   80101c90 <iunlockput>
    end_op();
801056e5:	e8 66 d8 ff ff       	call   80102f50 <end_op>
    return -1;
801056ea:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801056ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801056f5:	5b                   	pop    %ebx
801056f6:	5e                   	pop    %esi
801056f7:	5f                   	pop    %edi
801056f8:	5d                   	pop    %ebp
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105706:	31 c9                	xor    %ecx,%ecx
80105708:	6a 00                	push   $0x0
8010570a:	ba 02 00 00 00       	mov    $0x2,%edx
8010570f:	e8 dc f7 ff ff       	call   80104ef0 <create>
    if(ip == 0){
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105719:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010571b:	75 89                	jne    801056a6 <sys_open+0x76>
      end_op();
8010571d:	e8 2e d8 ff ff       	call   80102f50 <end_op>
      return -1;
80105722:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105727:	eb 43                	jmp    8010576c <sys_open+0x13c>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105733:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105737:	56                   	push   %esi
80105738:	e8 a3 c3 ff ff       	call   80101ae0 <iunlock>
  end_op();
8010573d:	e8 0e d8 ff ff       	call   80102f50 <end_op>

  f->type = FD_INODE;
80105742:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105748:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010574b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010574e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105751:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105758:	89 d0                	mov    %edx,%eax
8010575a:	83 e0 01             	and    $0x1,%eax
8010575d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105760:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105763:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105766:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010576a:	89 d8                	mov    %ebx,%eax
}
8010576c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010576f:	5b                   	pop    %ebx
80105770:	5e                   	pop    %esi
80105771:	5f                   	pop    %edi
80105772:	5d                   	pop    %ebp
80105773:	c3                   	ret    
80105774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105778:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010577b:	85 c9                	test   %ecx,%ecx
8010577d:	0f 84 23 ff ff ff    	je     801056a6 <sys_open+0x76>
80105783:	e9 54 ff ff ff       	jmp    801056dc <sys_open+0xac>
80105788:	90                   	nop
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105796:	e8 45 d7 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010579b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 a7 f6 ff ff       	call   80104e50 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 30                	js     801057e0 <sys_mkdir+0x50>
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	6a 00                	push   $0x0
801057ba:	ba 01 00 00 00       	mov    $0x1,%edx
801057bf:	e8 2c f7 ff ff       	call   80104ef0 <create>
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
801057c9:	74 15                	je     801057e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057cb:	83 ec 0c             	sub    $0xc,%esp
801057ce:	50                   	push   %eax
801057cf:	e8 bc c4 ff ff       	call   80101c90 <iunlockput>
  end_op();
801057d4:	e8 77 d7 ff ff       	call   80102f50 <end_op>
  return 0;
801057d9:	83 c4 10             	add    $0x10,%esp
801057dc:	31 c0                	xor    %eax,%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801057e0:	e8 6b d7 ff ff       	call   80102f50 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_mknod>:

int
sys_mknod(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057f6:	e8 e5 d6 ff ff       	call   80102ee0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fe:	83 ec 08             	sub    $0x8,%esp
80105801:	50                   	push   %eax
80105802:	6a 00                	push   $0x0
80105804:	e8 47 f6 ff ff       	call   80104e50 <argstr>
80105809:	83 c4 10             	add    $0x10,%esp
8010580c:	85 c0                	test   %eax,%eax
8010580e:	78 60                	js     80105870 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105810:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105813:	83 ec 08             	sub    $0x8,%esp
80105816:	50                   	push   %eax
80105817:	6a 01                	push   $0x1
80105819:	e8 82 f5 ff ff       	call   80104da0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	85 c0                	test   %eax,%eax
80105823:	78 4b                	js     80105870 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105825:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105828:	83 ec 08             	sub    $0x8,%esp
8010582b:	50                   	push   %eax
8010582c:	6a 02                	push   $0x2
8010582e:	e8 6d f5 ff ff       	call   80104da0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	78 36                	js     80105870 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010583a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010583e:	83 ec 0c             	sub    $0xc,%esp
80105841:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105845:	ba 03 00 00 00       	mov    $0x3,%edx
8010584a:	50                   	push   %eax
8010584b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010584e:	e8 9d f6 ff ff       	call   80104ef0 <create>
80105853:	83 c4 10             	add    $0x10,%esp
80105856:	85 c0                	test   %eax,%eax
80105858:	74 16                	je     80105870 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010585a:	83 ec 0c             	sub    $0xc,%esp
8010585d:	50                   	push   %eax
8010585e:	e8 2d c4 ff ff       	call   80101c90 <iunlockput>
  end_op();
80105863:	e8 e8 d6 ff ff       	call   80102f50 <end_op>
  return 0;
80105868:	83 c4 10             	add    $0x10,%esp
8010586b:	31 c0                	xor    %eax,%eax
}
8010586d:	c9                   	leave  
8010586e:	c3                   	ret    
8010586f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105870:	e8 db d6 ff ff       	call   80102f50 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_chdir>:

int
sys_chdir(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	53                   	push   %ebx
80105885:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105888:	e8 c3 e2 ff ff       	call   80103b50 <myproc>
8010588d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010588f:	e8 4c d6 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105894:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105897:	83 ec 08             	sub    $0x8,%esp
8010589a:	50                   	push   %eax
8010589b:	6a 00                	push   $0x0
8010589d:	e8 ae f5 ff ff       	call   80104e50 <argstr>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 77                	js     80105920 <sys_chdir+0xa0>
801058a9:	83 ec 0c             	sub    $0xc,%esp
801058ac:	ff 75 f4             	pushl  -0xc(%ebp)
801058af:	e8 9c c9 ff ff       	call   80102250 <namei>
801058b4:	83 c4 10             	add    $0x10,%esp
801058b7:	85 c0                	test   %eax,%eax
801058b9:	89 c3                	mov    %eax,%ebx
801058bb:	74 63                	je     80105920 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058bd:	83 ec 0c             	sub    $0xc,%esp
801058c0:	50                   	push   %eax
801058c1:	e8 3a c1 ff ff       	call   80101a00 <ilock>
  if(ip->type != T_DIR){
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ce:	75 30                	jne    80105900 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	53                   	push   %ebx
801058d4:	e8 07 c2 ff ff       	call   80101ae0 <iunlock>
  iput(curproc->cwd);
801058d9:	58                   	pop    %eax
801058da:	ff 76 68             	pushl  0x68(%esi)
801058dd:	e8 4e c2 ff ff       	call   80101b30 <iput>
  end_op();
801058e2:	e8 69 d6 ff ff       	call   80102f50 <end_op>
  curproc->cwd = ip;
801058e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	31 c0                	xor    %eax,%eax
}
801058ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5d                   	pop    %ebp
801058f5:	c3                   	ret    
801058f6:	8d 76 00             	lea    0x0(%esi),%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	53                   	push   %ebx
80105904:	e8 87 c3 ff ff       	call   80101c90 <iunlockput>
    end_op();
80105909:	e8 42 d6 ff ff       	call   80102f50 <end_op>
    return -1;
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105916:	eb d7                	jmp    801058ef <sys_chdir+0x6f>
80105918:	90                   	nop
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105920:	e8 2b d6 ff ff       	call   80102f50 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592a:	eb c3                	jmp    801058ef <sys_chdir+0x6f>
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
80105935:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105936:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010593c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105942:	50                   	push   %eax
80105943:	6a 00                	push   $0x0
80105945:	e8 06 f5 ff ff       	call   80104e50 <argstr>
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	85 c0                	test   %eax,%eax
8010594f:	78 7f                	js     801059d0 <sys_exec+0xa0>
80105951:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105957:	83 ec 08             	sub    $0x8,%esp
8010595a:	50                   	push   %eax
8010595b:	6a 01                	push   $0x1
8010595d:	e8 3e f4 ff ff       	call   80104da0 <argint>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 67                	js     801059d0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105969:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010596f:	83 ec 04             	sub    $0x4,%esp
80105972:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105978:	68 80 00 00 00       	push   $0x80
8010597d:	6a 00                	push   $0x0
8010597f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105985:	50                   	push   %eax
80105986:	31 db                	xor    %ebx,%ebx
80105988:	e8 03 f1 ff ff       	call   80104a90 <memset>
8010598d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105990:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105996:	83 ec 08             	sub    $0x8,%esp
80105999:	57                   	push   %edi
8010599a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010599d:	50                   	push   %eax
8010599e:	e8 5d f3 ff ff       	call   80104d00 <fetchint>
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 c0                	test   %eax,%eax
801059a8:	78 26                	js     801059d0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801059aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059b0:	85 c0                	test   %eax,%eax
801059b2:	74 2c                	je     801059e0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059b4:	83 ec 08             	sub    $0x8,%esp
801059b7:	56                   	push   %esi
801059b8:	50                   	push   %eax
801059b9:	e8 82 f3 ff ff       	call   80104d40 <fetchstr>
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	85 c0                	test   %eax,%eax
801059c3:	78 0b                	js     801059d0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801059c5:	83 c3 01             	add    $0x1,%ebx
801059c8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801059cb:	83 fb 20             	cmp    $0x20,%ebx
801059ce:	75 c0                	jne    80105990 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801059d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801059d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801059d8:	5b                   	pop    %ebx
801059d9:	5e                   	pop    %esi
801059da:	5f                   	pop    %edi
801059db:	5d                   	pop    %ebp
801059dc:	c3                   	ret    
801059dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801059e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059e6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801059e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059f0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801059f4:	50                   	push   %eax
801059f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059fb:	e8 f0 af ff ff       	call   801009f0 <exec>
80105a00:	83 c4 10             	add    $0x10,%esp
}
80105a03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a06:	5b                   	pop    %ebx
80105a07:	5e                   	pop    %esi
80105a08:	5f                   	pop    %edi
80105a09:	5d                   	pop    %ebp
80105a0a:	c3                   	ret    
80105a0b:	90                   	nop
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_exec2>:


int
sys_exec2(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a16:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
80105a1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a22:	50                   	push   %eax
80105a23:	6a 00                	push   $0x0
80105a25:	e8 26 f4 ff ff       	call   80104e50 <argstr>
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	85 c0                	test   %eax,%eax
80105a2f:	78 7f                	js     80105ab0 <sys_exec2+0xa0>
80105a31:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105a37:	83 ec 08             	sub    $0x8,%esp
80105a3a:	50                   	push   %eax
80105a3b:	6a 01                	push   $0x1
80105a3d:	e8 5e f3 ff ff       	call   80104da0 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 67                	js     80105ab0 <sys_exec2+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a49:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a4f:	83 ec 04             	sub    $0x4,%esp
80105a52:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a58:	68 80 00 00 00       	push   $0x80
80105a5d:	6a 00                	push   $0x0
80105a5f:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105a65:	50                   	push   %eax
80105a66:	31 db                	xor    %ebx,%ebx
80105a68:	e8 23 f0 ff ff       	call   80104a90 <memset>
80105a6d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a70:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105a76:	83 ec 08             	sub    $0x8,%esp
80105a79:	57                   	push   %edi
80105a7a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a7d:	50                   	push   %eax
80105a7e:	e8 7d f2 ff ff       	call   80104d00 <fetchint>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	78 26                	js     80105ab0 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
80105a8a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a90:	85 c0                	test   %eax,%eax
80105a92:	74 2c                	je     80105ac0 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a94:	83 ec 08             	sub    $0x8,%esp
80105a97:	56                   	push   %esi
80105a98:	50                   	push   %eax
80105a99:	e8 a2 f2 ff ff       	call   80104d40 <fetchstr>
80105a9e:	83 c4 10             	add    $0x10,%esp
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	78 0b                	js     80105ab0 <sys_exec2+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105aa5:	83 c3 01             	add    $0x1,%ebx
80105aa8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105aab:	83 fb 20             	cmp    $0x20,%ebx
80105aae:	75 c0                	jne    80105a70 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105ab0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105ab8:	5b                   	pop    %ebx
80105ab9:	5e                   	pop    %esi
80105aba:	5f                   	pop    %edi
80105abb:	5d                   	pop    %ebp
80105abc:	c3                   	ret    
80105abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105ac0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ac6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105ac9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ad0:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105ad4:	50                   	push   %eax
80105ad5:	6a 02                	push   $0x2
80105ad7:	e8 c4 f2 ff ff       	call   80104da0 <argint>
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	78 cd                	js     80105ab0 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105ae3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ae9:	83 ec 04             	sub    $0x4,%esp
80105aec:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105af2:	50                   	push   %eax
80105af3:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105af9:	e8 52 b2 ff ff       	call   80100d50 <exec2>
80105afe:	83 c4 10             	add    $0x10,%esp
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret    
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_pipe>:

int
sys_pipe(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b16:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105b19:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b1c:	6a 08                	push   $0x8
80105b1e:	50                   	push   %eax
80105b1f:	6a 00                	push   $0x0
80105b21:	e8 ca f2 ff ff       	call   80104df0 <argptr>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	78 4a                	js     80105b77 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	50                   	push   %eax
80105b34:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b37:	50                   	push   %eax
80105b38:	e8 43 da ff ff       	call   80103580 <pipealloc>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	85 c0                	test   %eax,%eax
80105b42:	78 33                	js     80105b77 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b44:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b46:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b49:	e8 02 e0 ff ff       	call   80103b50 <myproc>
80105b4e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105b50:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b54:	85 f6                	test   %esi,%esi
80105b56:	74 30                	je     80105b88 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b58:	83 c3 01             	add    $0x1,%ebx
80105b5b:	83 fb 10             	cmp    $0x10,%ebx
80105b5e:	75 f0                	jne    80105b50 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	ff 75 e0             	pushl  -0x20(%ebp)
80105b66:	e8 65 b6 ff ff       	call   801011d0 <fileclose>
    fileclose(wf);
80105b6b:	58                   	pop    %eax
80105b6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b6f:	e8 5c b6 ff ff       	call   801011d0 <fileclose>
    return -1;
80105b74:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105b7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b7f:	5b                   	pop    %ebx
80105b80:	5e                   	pop    %esi
80105b81:	5f                   	pop    %edi
80105b82:	5d                   	pop    %ebp
80105b83:	c3                   	ret    
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b88:	8d 73 08             	lea    0x8(%ebx),%esi
80105b8b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b92:	e8 b9 df ff ff       	call   80103b50 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105b97:	31 d2                	xor    %edx,%edx
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ba0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ba4:	85 c9                	test   %ecx,%ecx
80105ba6:	74 18                	je     80105bc0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ba8:	83 c2 01             	add    $0x1,%edx
80105bab:	83 fa 10             	cmp    $0x10,%edx
80105bae:	75 f0                	jne    80105ba0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105bb0:	e8 9b df ff ff       	call   80103b50 <myproc>
80105bb5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bbc:	00 
80105bbd:	eb a1                	jmp    80105b60 <sys_pipe+0x50>
80105bbf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105bc0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105bc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bc7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105bc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bcc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105bd2:	31 c0                	xor    %eax,%eax
}
80105bd4:	5b                   	pop    %ebx
80105bd5:	5e                   	pop    %esi
80105bd6:	5f                   	pop    %edi
80105bd7:	5d                   	pop    %ebp
80105bd8:	c3                   	ret    
80105bd9:	66 90                	xchg   %ax,%ax
80105bdb:	66 90                	xchg   %ax,%ax
80105bdd:	66 90                	xchg   %ax,%ax
80105bdf:	90                   	nop

80105be0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105be3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105be4:	e9 17 e1 ff ff       	jmp    80103d00 <fork>
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_exit>:
}

int
sys_exit(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105bf6:	e8 05 e4 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105bfb:	31 c0                	xor    %eax,%eax
80105bfd:	c9                   	leave  
80105bfe:	c3                   	ret    
80105bff:	90                   	nop

80105c00 <sys_wait>:

int
sys_wait(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c03:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105c04:	e9 47 e8 ff ff       	jmp    80104450 <wait>
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_kill>:
}

int
sys_kill(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c19:	50                   	push   %eax
80105c1a:	6a 00                	push   $0x0
80105c1c:	e8 7f f1 ff ff       	call   80104da0 <argint>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	78 18                	js     80105c40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c2e:	e8 7d e9 ff ff       	call   801045b0 <kill>
80105c33:	83 c4 10             	add    $0x10,%esp
}
80105c36:	c9                   	leave  
80105c37:	c3                   	ret    
80105c38:	90                   	nop
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105c45:	c9                   	leave  
80105c46:	c3                   	ret    
80105c47:	89 f6                	mov    %esi,%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c50 <sys_getpid>:

int
sys_getpid(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c56:	e8 f5 de ff ff       	call   80103b50 <myproc>
80105c5b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c5e:	c9                   	leave  
80105c5f:	c3                   	ret    

80105c60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105c67:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c6a:	50                   	push   %eax
80105c6b:	6a 00                	push   $0x0
80105c6d:	e8 2e f1 ff ff       	call   80104da0 <argint>
80105c72:	83 c4 10             	add    $0x10,%esp
80105c75:	85 c0                	test   %eax,%eax
80105c77:	78 27                	js     80105ca0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c79:	e8 d2 de ff ff       	call   80103b50 <myproc>
  if(growproc(n) < 0)
80105c7e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105c81:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c83:	ff 75 f4             	pushl  -0xc(%ebp)
80105c86:	e8 e5 df ff ff       	call   80103c70 <growproc>
80105c8b:	83 c4 10             	add    $0x10,%esp
80105c8e:	85 c0                	test   %eax,%eax
80105c90:	78 0e                	js     80105ca0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105c92:	89 d8                	mov    %ebx,%eax
}
80105c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c97:	c9                   	leave  
80105c98:	c3                   	ret    
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca5:	eb ed                	jmp    80105c94 <sys_sbrk+0x34>
80105ca7:	89 f6                	mov    %esi,%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cb0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	53                   	push   %ebx
80105cb4:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105cb7:	e8 94 de ff ff       	call   80103b50 <myproc>
80105cbc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105cc3:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105cc6:	e8 85 de ff ff       	call   80103b50 <myproc>
80105ccb:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105cd2:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105cd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd8:	83 ec 08             	sub    $0x8,%esp
80105cdb:	50                   	push   %eax
80105cdc:	6a 00                	push   $0x0
80105cde:	e8 bd f0 ff ff       	call   80104da0 <argint>
80105ce3:	83 c4 10             	add    $0x10,%esp
80105ce6:	85 c0                	test   %eax,%eax
80105ce8:	0f 88 89 00 00 00    	js     80105d77 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105cee:	83 ec 0c             	sub    $0xc,%esp
80105cf1:	68 60 61 11 80       	push   $0x80116160
80105cf6:	e8 95 ec ff ff       	call   80104990 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cfe:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105d01:	8b 1d a0 69 11 80    	mov    0x801169a0,%ebx
  while(ticks - ticks0 < n){
80105d07:	85 d2                	test   %edx,%edx
80105d09:	75 26                	jne    80105d31 <sys_sleep+0x81>
80105d0b:	eb 53                	jmp    80105d60 <sys_sleep+0xb0>
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	68 60 61 11 80       	push   $0x80116160
80105d18:	68 a0 69 11 80       	push   $0x801169a0
80105d1d:	e8 6e e6 ff ff       	call   80104390 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d22:	a1 a0 69 11 80       	mov    0x801169a0,%eax
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	29 d8                	sub    %ebx,%eax
80105d2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d2f:	73 2f                	jae    80105d60 <sys_sleep+0xb0>
    if(myproc()->killed){
80105d31:	e8 1a de ff ff       	call   80103b50 <myproc>
80105d36:	8b 40 24             	mov    0x24(%eax),%eax
80105d39:	85 c0                	test   %eax,%eax
80105d3b:	74 d3                	je     80105d10 <sys_sleep+0x60>
      release(&tickslock);
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	68 60 61 11 80       	push   $0x80116160
80105d45:	e8 f6 ec ff ff       	call   80104a40 <release>
      return -1;
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	68 60 61 11 80       	push   $0x80116160
80105d68:	e8 d3 ec ff ff       	call   80104a40 <release>
  return 0;
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	31 c0                	xor    %eax,%eax
}
80105d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80105d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7c:	eb d4                	jmp    80105d52 <sys_sleep+0xa2>
80105d7e:	66 90                	xchg   %ax,%ax

80105d80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	53                   	push   %ebx
80105d84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d87:	68 60 61 11 80       	push   $0x80116160
80105d8c:	e8 ff eb ff ff       	call   80104990 <acquire>
  xticks = ticks;
80105d91:	8b 1d a0 69 11 80    	mov    0x801169a0,%ebx
  release(&tickslock);
80105d97:	c7 04 24 60 61 11 80 	movl   $0x80116160,(%esp)
80105d9e:	e8 9d ec ff ff       	call   80104a40 <release>
  return xticks;
}
80105da3:	89 d8                	mov    %ebx,%eax
80105da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da8:	c9                   	leave  
80105da9:	c3                   	ret    
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105db0 <sys_yield>:

void 
sys_yield()
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80105db6:	e8 95 dd ff ff       	call   80103b50 <myproc>
80105dbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105dc2:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
80105dc5:	e8 86 dd ff ff       	call   80103b50 <myproc>
80105dca:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105dd1:	00 00 00 
  yield();
}
80105dd4:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
80105dd5:	e9 56 e3 ff ff       	jmp    80104130 <yield>
80105dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105de0 <sys_getlev>:
}

int             
sys_getlev(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
  return getlev();
}
80105de3:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
80105de4:	e9 97 e3 ff ff       	jmp    80104180 <getlev>
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105df0 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105df6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df9:	50                   	push   %eax
80105dfa:	6a 00                	push   $0x0
80105dfc:	e8 9f ef ff ff       	call   80104da0 <argint>
80105e01:	83 c4 10             	add    $0x10,%esp
80105e04:	85 c0                	test   %eax,%eax
80105e06:	78 28                	js     80105e30 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
80105e08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e0b:	83 ec 08             	sub    $0x8,%esp
80105e0e:	50                   	push   %eax
80105e0f:	6a 01                	push   $0x1
80105e11:	e8 8a ef ff ff       	call   80104da0 <argint>
80105e16:	83 c4 10             	add    $0x10,%esp
80105e19:	85 c0                	test   %eax,%eax
80105e1b:	78 23                	js     80105e40 <sys_setpriority+0x50>
	return setpriority(pid,priority);
80105e1d:	83 ec 08             	sub    $0x8,%esp
80105e20:	ff 75 f4             	pushl  -0xc(%ebp)
80105e23:	ff 75 f0             	pushl  -0x10(%ebp)
80105e26:	e8 a5 e4 ff ff       	call   801042d0 <setpriority>
80105e2b:	83 c4 10             	add    $0x10,%esp
}
80105e2e:	c9                   	leave  
80105e2f:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
80105e40:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e50 <sys_getadmin>:


int
sys_getadmin(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e59:	50                   	push   %eax
80105e5a:	6a 00                	push   $0x0
80105e5c:	e8 ef ef ff ff       	call   80104e50 <argstr>
80105e61:	83 c4 10             	add    $0x10,%esp
80105e64:	85 c0                	test   %eax,%eax
80105e66:	78 18                	js     80105e80 <sys_getadmin+0x30>
  return getadmin(student_number);
80105e68:	83 ec 0c             	sub    $0xc,%esp
80105e6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e6e:	e8 3d e3 ff ff       	call   801041b0 <getadmin>
80105e73:	83 c4 10             	add    $0x10,%esp
}
80105e76:	c9                   	leave  
80105e77:	c3                   	ret    
80105e78:	90                   	nop
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80105e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e90 <sys_setmemorylimit>:

int
sys_setmemorylimit(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 20             	sub    $0x20,%esp
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80105e96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e99:	50                   	push   %eax
80105e9a:	6a 00                	push   $0x0
80105e9c:	e8 ff ee ff ff       	call   80104da0 <argint>
80105ea1:	83 c4 10             	add    $0x10,%esp
80105ea4:	85 c0                	test   %eax,%eax
80105ea6:	78 28                	js     80105ed0 <sys_setmemorylimit+0x40>
80105ea8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eab:	83 ec 08             	sub    $0x8,%esp
80105eae:	50                   	push   %eax
80105eaf:	6a 01                	push   $0x1
80105eb1:	e8 ea ee ff ff       	call   80104da0 <argint>
80105eb6:	83 c4 10             	add    $0x10,%esp
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	78 13                	js     80105ed0 <sys_setmemorylimit+0x40>
  return setmemorylimit(pid,limit);
80105ebd:	83 ec 08             	sub    $0x8,%esp
80105ec0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ec3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ec6:	e8 65 e3 ff ff       	call   80104230 <setmemorylimit>
80105ecb:	83 c4 10             	add    $0x10,%esp
80105ece:	c9                   	leave  
80105ecf:	c3                   	ret    

int
sys_setmemorylimit(void)
{
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80105ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return setmemorylimit(pid,limit);
80105ed5:	c9                   	leave  
80105ed6:	c3                   	ret    

80105ed7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ed7:	1e                   	push   %ds
  pushl %es
80105ed8:	06                   	push   %es
  pushl %fs
80105ed9:	0f a0                	push   %fs
  pushl %gs
80105edb:	0f a8                	push   %gs
  pushal
80105edd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ede:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ee2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ee4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ee6:	54                   	push   %esp
  call trap
80105ee7:	e8 e4 00 00 00       	call   80105fd0 <trap>
  addl $4, %esp
80105eec:	83 c4 04             	add    $0x4,%esp

80105eef <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105eef:	61                   	popa   
  popl %gs
80105ef0:	0f a9                	pop    %gs
  popl %fs
80105ef2:	0f a1                	pop    %fs
  popl %es
80105ef4:	07                   	pop    %es
  popl %ds
80105ef5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ef6:	83 c4 08             	add    $0x8,%esp
  iret
80105ef9:	cf                   	iret   
80105efa:	66 90                	xchg   %ax,%ax
80105efc:	66 90                	xchg   %ax,%ax
80105efe:	66 90                	xchg   %ax,%ax

80105f00 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105f00:	31 c0                	xor    %eax,%eax
80105f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f08:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f0f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105f14:	c6 04 c5 a4 61 11 80 	movb   $0x0,-0x7fee9e5c(,%eax,8)
80105f1b:	00 
80105f1c:	66 89 0c c5 a2 61 11 	mov    %cx,-0x7fee9e5e(,%eax,8)
80105f23:	80 
80105f24:	c6 04 c5 a5 61 11 80 	movb   $0x8e,-0x7fee9e5b(,%eax,8)
80105f2b:	8e 
80105f2c:	66 89 14 c5 a0 61 11 	mov    %dx,-0x7fee9e60(,%eax,8)
80105f33:	80 
80105f34:	c1 ea 10             	shr    $0x10,%edx
80105f37:	66 89 14 c5 a6 61 11 	mov    %dx,-0x7fee9e5a(,%eax,8)
80105f3e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105f3f:	83 c0 01             	add    $0x1,%eax
80105f42:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f47:	75 bf                	jne    80105f08 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f49:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f4a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f4f:	89 e5                	mov    %esp,%ebp
80105f51:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f54:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f59:	68 51 7f 10 80       	push   $0x80107f51
80105f5e:	68 60 61 11 80       	push   $0x80116160
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f63:	66 89 15 a2 63 11 80 	mov    %dx,0x801163a2
80105f6a:	c6 05 a4 63 11 80 00 	movb   $0x0,0x801163a4
80105f71:	66 a3 a0 63 11 80    	mov    %ax,0x801163a0
80105f77:	c1 e8 10             	shr    $0x10,%eax
80105f7a:	c6 05 a5 63 11 80 ef 	movb   $0xef,0x801163a5
80105f81:	66 a3 a6 63 11 80    	mov    %ax,0x801163a6

  initlock(&tickslock, "time");
80105f87:	e8 a4 e8 ff ff       	call   80104830 <initlock>
}
80105f8c:	83 c4 10             	add    $0x10,%esp
80105f8f:	c9                   	leave  
80105f90:	c3                   	ret    
80105f91:	eb 0d                	jmp    80105fa0 <idtinit>
80105f93:	90                   	nop
80105f94:	90                   	nop
80105f95:	90                   	nop
80105f96:	90                   	nop
80105f97:	90                   	nop
80105f98:	90                   	nop
80105f99:	90                   	nop
80105f9a:	90                   	nop
80105f9b:	90                   	nop
80105f9c:	90                   	nop
80105f9d:	90                   	nop
80105f9e:	90                   	nop
80105f9f:	90                   	nop

80105fa0 <idtinit>:

void
idtinit(void)
{
80105fa0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105fa1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fa6:	89 e5                	mov    %esp,%ebp
80105fa8:	83 ec 10             	sub    $0x10,%esp
80105fab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105faf:	b8 a0 61 11 80       	mov    $0x801161a0,%eax
80105fb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fb8:	c1 e8 10             	shr    $0x10,%eax
80105fbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105fbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fc5:	c9                   	leave  
80105fc6:	c3                   	ret    
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	57                   	push   %edi
80105fd4:	56                   	push   %esi
80105fd5:	53                   	push   %ebx
80105fd6:	83 ec 1c             	sub    $0x1c,%esp
80105fd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105fdc:	8b 47 30             	mov    0x30(%edi),%eax
80105fdf:	83 f8 40             	cmp    $0x40,%eax
80105fe2:	0f 84 88 01 00 00    	je     80106170 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105fe8:	83 e8 20             	sub    $0x20,%eax
80105feb:	83 f8 1f             	cmp    $0x1f,%eax
80105fee:	77 10                	ja     80106000 <trap+0x30>
80105ff0:	ff 24 85 f8 7f 10 80 	jmp    *-0x7fef8008(,%eax,4)
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106000:	e8 4b db ff ff       	call   80103b50 <myproc>
80106005:	85 c0                	test   %eax,%eax
80106007:	0f 84 d7 01 00 00    	je     801061e4 <trap+0x214>
8010600d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106011:	0f 84 cd 01 00 00    	je     801061e4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106017:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010601a:	8b 57 38             	mov    0x38(%edi),%edx
8010601d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106020:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106023:	e8 08 db ff ff       	call   80103b30 <cpuid>
80106028:	8b 77 34             	mov    0x34(%edi),%esi
8010602b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010602e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106031:	e8 1a db ff ff       	call   80103b50 <myproc>
80106036:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106039:	e8 12 db ff ff       	call   80103b50 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010603e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106041:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106044:	51                   	push   %ecx
80106045:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106046:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106049:	ff 75 e4             	pushl  -0x1c(%ebp)
8010604c:	56                   	push   %esi
8010604d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010604e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106051:	52                   	push   %edx
80106052:	ff 70 10             	pushl  0x10(%eax)
80106055:	68 b4 7f 10 80       	push   $0x80107fb4
8010605a:	e8 01 a6 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010605f:	83 c4 20             	add    $0x20,%esp
80106062:	e8 e9 da ff ff       	call   80103b50 <myproc>
80106067:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010606e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106070:	e8 db da ff ff       	call   80103b50 <myproc>
80106075:	85 c0                	test   %eax,%eax
80106077:	74 0c                	je     80106085 <trap+0xb5>
80106079:	e8 d2 da ff ff       	call   80103b50 <myproc>
8010607e:	8b 50 24             	mov    0x24(%eax),%edx
80106081:	85 d2                	test   %edx,%edx
80106083:	75 4b                	jne    801060d0 <trap+0x100>
  }
  
  if(ticks%100 == 0) priority_boosting();

  #else
  if(myproc() && myproc()->state == RUNNING &&
80106085:	e8 c6 da ff ff       	call   80103b50 <myproc>
8010608a:	85 c0                	test   %eax,%eax
8010608c:	74 0b                	je     80106099 <trap+0xc9>
8010608e:	e8 bd da ff ff       	call   80103b50 <myproc>
80106093:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106097:	74 4f                	je     801060e8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106099:	e8 b2 da ff ff       	call   80103b50 <myproc>
8010609e:	85 c0                	test   %eax,%eax
801060a0:	74 1d                	je     801060bf <trap+0xef>
801060a2:	e8 a9 da ff ff       	call   80103b50 <myproc>
801060a7:	8b 40 24             	mov    0x24(%eax),%eax
801060aa:	85 c0                	test   %eax,%eax
801060ac:	74 11                	je     801060bf <trap+0xef>
801060ae:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060b2:	83 e0 03             	and    $0x3,%eax
801060b5:	66 83 f8 03          	cmp    $0x3,%ax
801060b9:	0f 84 da 00 00 00    	je     80106199 <trap+0x1c9>
    exit();
}
801060bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c2:	5b                   	pop    %ebx
801060c3:	5e                   	pop    %esi
801060c4:	5f                   	pop    %edi
801060c5:	5d                   	pop    %ebp
801060c6:	c3                   	ret    
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060d0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060d4:	83 e0 03             	and    $0x3,%eax
801060d7:	66 83 f8 03          	cmp    $0x3,%ax
801060db:	75 a8                	jne    80106085 <trap+0xb5>
    exit();
801060dd:	e8 1e df ff ff       	call   80104000 <exit>
801060e2:	eb a1                	jmp    80106085 <trap+0xb5>
801060e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  
  if(ticks%100 == 0) priority_boosting();

  #else
  if(myproc() && myproc()->state == RUNNING &&
801060e8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801060ec:	75 ab                	jne    80106099 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801060ee:	e8 3d e0 ff ff       	call   80104130 <yield>
801060f3:	eb a4                	jmp    80106099 <trap+0xc9>
801060f5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801060f8:	e8 33 da ff ff       	call   80103b30 <cpuid>
801060fd:	85 c0                	test   %eax,%eax
801060ff:	0f 84 ab 00 00 00    	je     801061b0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106105:	e8 96 c9 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010610a:	e9 61 ff ff ff       	jmp    80106070 <trap+0xa0>
8010610f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106110:	e8 4b c8 ff ff       	call   80102960 <kbdintr>
    lapiceoi();
80106115:	e8 86 c9 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010611a:	e9 51 ff ff ff       	jmp    80106070 <trap+0xa0>
8010611f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106120:	e8 5b 02 00 00       	call   80106380 <uartintr>
    lapiceoi();
80106125:	e8 76 c9 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010612a:	e9 41 ff ff ff       	jmp    80106070 <trap+0xa0>
8010612f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106130:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106134:	8b 77 38             	mov    0x38(%edi),%esi
80106137:	e8 f4 d9 ff ff       	call   80103b30 <cpuid>
8010613c:	56                   	push   %esi
8010613d:	53                   	push   %ebx
8010613e:	50                   	push   %eax
8010613f:	68 5c 7f 10 80       	push   $0x80107f5c
80106144:	e8 17 a5 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106149:	e8 52 c9 ff ff       	call   80102aa0 <lapiceoi>
    break;
8010614e:	83 c4 10             	add    $0x10,%esp
80106151:	e9 1a ff ff ff       	jmp    80106070 <trap+0xa0>
80106156:	8d 76 00             	lea    0x0(%esi),%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106160:	e8 7b c2 ff ff       	call   801023e0 <ideintr>
80106165:	eb 9e                	jmp    80106105 <trap+0x135>
80106167:	89 f6                	mov    %esi,%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106170:	e8 db d9 ff ff       	call   80103b50 <myproc>
80106175:	8b 58 24             	mov    0x24(%eax),%ebx
80106178:	85 db                	test   %ebx,%ebx
8010617a:	75 2c                	jne    801061a8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010617c:	e8 cf d9 ff ff       	call   80103b50 <myproc>
80106181:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106184:	e8 07 ed ff ff       	call   80104e90 <syscall>
    if(myproc()->killed)
80106189:	e8 c2 d9 ff ff       	call   80103b50 <myproc>
8010618e:	8b 48 24             	mov    0x24(%eax),%ecx
80106191:	85 c9                	test   %ecx,%ecx
80106193:	0f 84 26 ff ff ff    	je     801060bf <trap+0xef>
    yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106199:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010619c:	5b                   	pop    %ebx
8010619d:	5e                   	pop    %esi
8010619e:	5f                   	pop    %edi
8010619f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801061a0:	e9 5b de ff ff       	jmp    80104000 <exit>
801061a5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801061a8:	e8 53 de ff ff       	call   80104000 <exit>
801061ad:	eb cd                	jmp    8010617c <trap+0x1ac>
801061af:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	68 60 61 11 80       	push   $0x80116160
801061b8:	e8 d3 e7 ff ff       	call   80104990 <acquire>
      ticks++;
      wakeup(&ticks);
801061bd:	c7 04 24 a0 69 11 80 	movl   $0x801169a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801061c4:	83 05 a0 69 11 80 01 	addl   $0x1,0x801169a0
      wakeup(&ticks);
801061cb:	e8 80 e3 ff ff       	call   80104550 <wakeup>
      release(&tickslock);
801061d0:	c7 04 24 60 61 11 80 	movl   $0x80116160,(%esp)
801061d7:	e8 64 e8 ff ff       	call   80104a40 <release>
801061dc:	83 c4 10             	add    $0x10,%esp
801061df:	e9 21 ff ff ff       	jmp    80106105 <trap+0x135>
801061e4:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061e7:	8b 5f 38             	mov    0x38(%edi),%ebx
801061ea:	e8 41 d9 ff ff       	call   80103b30 <cpuid>
801061ef:	83 ec 0c             	sub    $0xc,%esp
801061f2:	56                   	push   %esi
801061f3:	53                   	push   %ebx
801061f4:	50                   	push   %eax
801061f5:	ff 77 30             	pushl  0x30(%edi)
801061f8:	68 80 7f 10 80       	push   $0x80107f80
801061fd:	e8 5e a4 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106202:	83 c4 14             	add    $0x14,%esp
80106205:	68 56 7f 10 80       	push   $0x80107f56
8010620a:	e8 61 a1 ff ff       	call   80100370 <panic>
8010620f:	90                   	nop

80106210 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106210:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106215:	55                   	push   %ebp
80106216:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106218:	85 c0                	test   %eax,%eax
8010621a:	74 1c                	je     80106238 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010621c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106221:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106222:	a8 01                	test   $0x1,%al
80106224:	74 12                	je     80106238 <uartgetc+0x28>
80106226:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010622b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010622c:	0f b6 c0             	movzbl %al,%eax
}
8010622f:	5d                   	pop    %ebp
80106230:	c3                   	ret    
80106231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010623d:	5d                   	pop    %ebp
8010623e:	c3                   	ret    
8010623f:	90                   	nop

80106240 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	57                   	push   %edi
80106244:	56                   	push   %esi
80106245:	53                   	push   %ebx
80106246:	89 c7                	mov    %eax,%edi
80106248:	bb 80 00 00 00       	mov    $0x80,%ebx
8010624d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106252:	83 ec 0c             	sub    $0xc,%esp
80106255:	eb 1b                	jmp    80106272 <uartputc.part.0+0x32>
80106257:	89 f6                	mov    %esi,%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106260:	83 ec 0c             	sub    $0xc,%esp
80106263:	6a 0a                	push   $0xa
80106265:	e8 56 c8 ff ff       	call   80102ac0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010626a:	83 c4 10             	add    $0x10,%esp
8010626d:	83 eb 01             	sub    $0x1,%ebx
80106270:	74 07                	je     80106279 <uartputc.part.0+0x39>
80106272:	89 f2                	mov    %esi,%edx
80106274:	ec                   	in     (%dx),%al
80106275:	a8 20                	test   $0x20,%al
80106277:	74 e7                	je     80106260 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106279:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010627e:	89 f8                	mov    %edi,%eax
80106280:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106281:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106284:	5b                   	pop    %ebx
80106285:	5e                   	pop    %esi
80106286:	5f                   	pop    %edi
80106287:	5d                   	pop    %ebp
80106288:	c3                   	ret    
80106289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106290 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106290:	55                   	push   %ebp
80106291:	31 c9                	xor    %ecx,%ecx
80106293:	89 c8                	mov    %ecx,%eax
80106295:	89 e5                	mov    %esp,%ebp
80106297:	57                   	push   %edi
80106298:	56                   	push   %esi
80106299:	53                   	push   %ebx
8010629a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010629f:	89 da                	mov    %ebx,%edx
801062a1:	83 ec 0c             	sub    $0xc,%esp
801062a4:	ee                   	out    %al,(%dx)
801062a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062af:	89 fa                	mov    %edi,%edx
801062b1:	ee                   	out    %al,(%dx)
801062b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062bc:	ee                   	out    %al,(%dx)
801062bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801062c2:	89 c8                	mov    %ecx,%eax
801062c4:	89 f2                	mov    %esi,%edx
801062c6:	ee                   	out    %al,(%dx)
801062c7:	b8 03 00 00 00       	mov    $0x3,%eax
801062cc:	89 fa                	mov    %edi,%edx
801062ce:	ee                   	out    %al,(%dx)
801062cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062d4:	89 c8                	mov    %ecx,%eax
801062d6:	ee                   	out    %al,(%dx)
801062d7:	b8 01 00 00 00       	mov    $0x1,%eax
801062dc:	89 f2                	mov    %esi,%edx
801062de:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062e4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801062e5:	3c ff                	cmp    $0xff,%al
801062e7:	74 5a                	je     80106343 <uartinit+0xb3>
    return;
  uart = 1;
801062e9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801062f0:	00 00 00 
801062f3:	89 da                	mov    %ebx,%edx
801062f5:	ec                   	in     (%dx),%al
801062f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801062fc:	83 ec 08             	sub    $0x8,%esp
801062ff:	bb 78 80 10 80       	mov    $0x80108078,%ebx
80106304:	6a 00                	push   $0x0
80106306:	6a 04                	push   $0x4
80106308:	e8 23 c3 ff ff       	call   80102630 <ioapicenable>
8010630d:	83 c4 10             	add    $0x10,%esp
80106310:	b8 78 00 00 00       	mov    $0x78,%eax
80106315:	eb 13                	jmp    8010632a <uartinit+0x9a>
80106317:	89 f6                	mov    %esi,%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106320:	83 c3 01             	add    $0x1,%ebx
80106323:	0f be 03             	movsbl (%ebx),%eax
80106326:	84 c0                	test   %al,%al
80106328:	74 19                	je     80106343 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010632a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106330:	85 d2                	test   %edx,%edx
80106332:	74 ec                	je     80106320 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106334:	83 c3 01             	add    $0x1,%ebx
80106337:	e8 04 ff ff ff       	call   80106240 <uartputc.part.0>
8010633c:	0f be 03             	movsbl (%ebx),%eax
8010633f:	84 c0                	test   %al,%al
80106341:	75 e7                	jne    8010632a <uartinit+0x9a>
    uartputc(*p);
}
80106343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106346:	5b                   	pop    %ebx
80106347:	5e                   	pop    %esi
80106348:	5f                   	pop    %edi
80106349:	5d                   	pop    %ebp
8010634a:	c3                   	ret    
8010634b:	90                   	nop
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106350 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106350:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106356:	55                   	push   %ebp
80106357:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106359:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010635b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010635e:	74 10                	je     80106370 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106360:	5d                   	pop    %ebp
80106361:	e9 da fe ff ff       	jmp    80106240 <uartputc.part.0>
80106366:	8d 76 00             	lea    0x0(%esi),%esi
80106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106370:	5d                   	pop    %ebp
80106371:	c3                   	ret    
80106372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106380 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106386:	68 10 62 10 80       	push   $0x80106210
8010638b:	e8 60 a4 ff ff       	call   801007f0 <consoleintr>
}
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	c9                   	leave  
80106394:	c3                   	ret    

80106395 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $0
80106397:	6a 00                	push   $0x0
  jmp alltraps
80106399:	e9 39 fb ff ff       	jmp    80105ed7 <alltraps>

8010639e <vector1>:
.globl vector1
vector1:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $1
801063a0:	6a 01                	push   $0x1
  jmp alltraps
801063a2:	e9 30 fb ff ff       	jmp    80105ed7 <alltraps>

801063a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $2
801063a9:	6a 02                	push   $0x2
  jmp alltraps
801063ab:	e9 27 fb ff ff       	jmp    80105ed7 <alltraps>

801063b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $3
801063b2:	6a 03                	push   $0x3
  jmp alltraps
801063b4:	e9 1e fb ff ff       	jmp    80105ed7 <alltraps>

801063b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $4
801063bb:	6a 04                	push   $0x4
  jmp alltraps
801063bd:	e9 15 fb ff ff       	jmp    80105ed7 <alltraps>

801063c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $5
801063c4:	6a 05                	push   $0x5
  jmp alltraps
801063c6:	e9 0c fb ff ff       	jmp    80105ed7 <alltraps>

801063cb <vector6>:
.globl vector6
vector6:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $6
801063cd:	6a 06                	push   $0x6
  jmp alltraps
801063cf:	e9 03 fb ff ff       	jmp    80105ed7 <alltraps>

801063d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $7
801063d6:	6a 07                	push   $0x7
  jmp alltraps
801063d8:	e9 fa fa ff ff       	jmp    80105ed7 <alltraps>

801063dd <vector8>:
.globl vector8
vector8:
  pushl $8
801063dd:	6a 08                	push   $0x8
  jmp alltraps
801063df:	e9 f3 fa ff ff       	jmp    80105ed7 <alltraps>

801063e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $9
801063e6:	6a 09                	push   $0x9
  jmp alltraps
801063e8:	e9 ea fa ff ff       	jmp    80105ed7 <alltraps>

801063ed <vector10>:
.globl vector10
vector10:
  pushl $10
801063ed:	6a 0a                	push   $0xa
  jmp alltraps
801063ef:	e9 e3 fa ff ff       	jmp    80105ed7 <alltraps>

801063f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801063f4:	6a 0b                	push   $0xb
  jmp alltraps
801063f6:	e9 dc fa ff ff       	jmp    80105ed7 <alltraps>

801063fb <vector12>:
.globl vector12
vector12:
  pushl $12
801063fb:	6a 0c                	push   $0xc
  jmp alltraps
801063fd:	e9 d5 fa ff ff       	jmp    80105ed7 <alltraps>

80106402 <vector13>:
.globl vector13
vector13:
  pushl $13
80106402:	6a 0d                	push   $0xd
  jmp alltraps
80106404:	e9 ce fa ff ff       	jmp    80105ed7 <alltraps>

80106409 <vector14>:
.globl vector14
vector14:
  pushl $14
80106409:	6a 0e                	push   $0xe
  jmp alltraps
8010640b:	e9 c7 fa ff ff       	jmp    80105ed7 <alltraps>

80106410 <vector15>:
.globl vector15
vector15:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $15
80106412:	6a 0f                	push   $0xf
  jmp alltraps
80106414:	e9 be fa ff ff       	jmp    80105ed7 <alltraps>

80106419 <vector16>:
.globl vector16
vector16:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $16
8010641b:	6a 10                	push   $0x10
  jmp alltraps
8010641d:	e9 b5 fa ff ff       	jmp    80105ed7 <alltraps>

80106422 <vector17>:
.globl vector17
vector17:
  pushl $17
80106422:	6a 11                	push   $0x11
  jmp alltraps
80106424:	e9 ae fa ff ff       	jmp    80105ed7 <alltraps>

80106429 <vector18>:
.globl vector18
vector18:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $18
8010642b:	6a 12                	push   $0x12
  jmp alltraps
8010642d:	e9 a5 fa ff ff       	jmp    80105ed7 <alltraps>

80106432 <vector19>:
.globl vector19
vector19:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $19
80106434:	6a 13                	push   $0x13
  jmp alltraps
80106436:	e9 9c fa ff ff       	jmp    80105ed7 <alltraps>

8010643b <vector20>:
.globl vector20
vector20:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $20
8010643d:	6a 14                	push   $0x14
  jmp alltraps
8010643f:	e9 93 fa ff ff       	jmp    80105ed7 <alltraps>

80106444 <vector21>:
.globl vector21
vector21:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $21
80106446:	6a 15                	push   $0x15
  jmp alltraps
80106448:	e9 8a fa ff ff       	jmp    80105ed7 <alltraps>

8010644d <vector22>:
.globl vector22
vector22:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $22
8010644f:	6a 16                	push   $0x16
  jmp alltraps
80106451:	e9 81 fa ff ff       	jmp    80105ed7 <alltraps>

80106456 <vector23>:
.globl vector23
vector23:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $23
80106458:	6a 17                	push   $0x17
  jmp alltraps
8010645a:	e9 78 fa ff ff       	jmp    80105ed7 <alltraps>

8010645f <vector24>:
.globl vector24
vector24:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $24
80106461:	6a 18                	push   $0x18
  jmp alltraps
80106463:	e9 6f fa ff ff       	jmp    80105ed7 <alltraps>

80106468 <vector25>:
.globl vector25
vector25:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $25
8010646a:	6a 19                	push   $0x19
  jmp alltraps
8010646c:	e9 66 fa ff ff       	jmp    80105ed7 <alltraps>

80106471 <vector26>:
.globl vector26
vector26:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $26
80106473:	6a 1a                	push   $0x1a
  jmp alltraps
80106475:	e9 5d fa ff ff       	jmp    80105ed7 <alltraps>

8010647a <vector27>:
.globl vector27
vector27:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $27
8010647c:	6a 1b                	push   $0x1b
  jmp alltraps
8010647e:	e9 54 fa ff ff       	jmp    80105ed7 <alltraps>

80106483 <vector28>:
.globl vector28
vector28:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $28
80106485:	6a 1c                	push   $0x1c
  jmp alltraps
80106487:	e9 4b fa ff ff       	jmp    80105ed7 <alltraps>

8010648c <vector29>:
.globl vector29
vector29:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $29
8010648e:	6a 1d                	push   $0x1d
  jmp alltraps
80106490:	e9 42 fa ff ff       	jmp    80105ed7 <alltraps>

80106495 <vector30>:
.globl vector30
vector30:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $30
80106497:	6a 1e                	push   $0x1e
  jmp alltraps
80106499:	e9 39 fa ff ff       	jmp    80105ed7 <alltraps>

8010649e <vector31>:
.globl vector31
vector31:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $31
801064a0:	6a 1f                	push   $0x1f
  jmp alltraps
801064a2:	e9 30 fa ff ff       	jmp    80105ed7 <alltraps>

801064a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $32
801064a9:	6a 20                	push   $0x20
  jmp alltraps
801064ab:	e9 27 fa ff ff       	jmp    80105ed7 <alltraps>

801064b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $33
801064b2:	6a 21                	push   $0x21
  jmp alltraps
801064b4:	e9 1e fa ff ff       	jmp    80105ed7 <alltraps>

801064b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $34
801064bb:	6a 22                	push   $0x22
  jmp alltraps
801064bd:	e9 15 fa ff ff       	jmp    80105ed7 <alltraps>

801064c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $35
801064c4:	6a 23                	push   $0x23
  jmp alltraps
801064c6:	e9 0c fa ff ff       	jmp    80105ed7 <alltraps>

801064cb <vector36>:
.globl vector36
vector36:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $36
801064cd:	6a 24                	push   $0x24
  jmp alltraps
801064cf:	e9 03 fa ff ff       	jmp    80105ed7 <alltraps>

801064d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $37
801064d6:	6a 25                	push   $0x25
  jmp alltraps
801064d8:	e9 fa f9 ff ff       	jmp    80105ed7 <alltraps>

801064dd <vector38>:
.globl vector38
vector38:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $38
801064df:	6a 26                	push   $0x26
  jmp alltraps
801064e1:	e9 f1 f9 ff ff       	jmp    80105ed7 <alltraps>

801064e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $39
801064e8:	6a 27                	push   $0x27
  jmp alltraps
801064ea:	e9 e8 f9 ff ff       	jmp    80105ed7 <alltraps>

801064ef <vector40>:
.globl vector40
vector40:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $40
801064f1:	6a 28                	push   $0x28
  jmp alltraps
801064f3:	e9 df f9 ff ff       	jmp    80105ed7 <alltraps>

801064f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $41
801064fa:	6a 29                	push   $0x29
  jmp alltraps
801064fc:	e9 d6 f9 ff ff       	jmp    80105ed7 <alltraps>

80106501 <vector42>:
.globl vector42
vector42:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $42
80106503:	6a 2a                	push   $0x2a
  jmp alltraps
80106505:	e9 cd f9 ff ff       	jmp    80105ed7 <alltraps>

8010650a <vector43>:
.globl vector43
vector43:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $43
8010650c:	6a 2b                	push   $0x2b
  jmp alltraps
8010650e:	e9 c4 f9 ff ff       	jmp    80105ed7 <alltraps>

80106513 <vector44>:
.globl vector44
vector44:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $44
80106515:	6a 2c                	push   $0x2c
  jmp alltraps
80106517:	e9 bb f9 ff ff       	jmp    80105ed7 <alltraps>

8010651c <vector45>:
.globl vector45
vector45:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $45
8010651e:	6a 2d                	push   $0x2d
  jmp alltraps
80106520:	e9 b2 f9 ff ff       	jmp    80105ed7 <alltraps>

80106525 <vector46>:
.globl vector46
vector46:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $46
80106527:	6a 2e                	push   $0x2e
  jmp alltraps
80106529:	e9 a9 f9 ff ff       	jmp    80105ed7 <alltraps>

8010652e <vector47>:
.globl vector47
vector47:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $47
80106530:	6a 2f                	push   $0x2f
  jmp alltraps
80106532:	e9 a0 f9 ff ff       	jmp    80105ed7 <alltraps>

80106537 <vector48>:
.globl vector48
vector48:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $48
80106539:	6a 30                	push   $0x30
  jmp alltraps
8010653b:	e9 97 f9 ff ff       	jmp    80105ed7 <alltraps>

80106540 <vector49>:
.globl vector49
vector49:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $49
80106542:	6a 31                	push   $0x31
  jmp alltraps
80106544:	e9 8e f9 ff ff       	jmp    80105ed7 <alltraps>

80106549 <vector50>:
.globl vector50
vector50:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $50
8010654b:	6a 32                	push   $0x32
  jmp alltraps
8010654d:	e9 85 f9 ff ff       	jmp    80105ed7 <alltraps>

80106552 <vector51>:
.globl vector51
vector51:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $51
80106554:	6a 33                	push   $0x33
  jmp alltraps
80106556:	e9 7c f9 ff ff       	jmp    80105ed7 <alltraps>

8010655b <vector52>:
.globl vector52
vector52:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $52
8010655d:	6a 34                	push   $0x34
  jmp alltraps
8010655f:	e9 73 f9 ff ff       	jmp    80105ed7 <alltraps>

80106564 <vector53>:
.globl vector53
vector53:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $53
80106566:	6a 35                	push   $0x35
  jmp alltraps
80106568:	e9 6a f9 ff ff       	jmp    80105ed7 <alltraps>

8010656d <vector54>:
.globl vector54
vector54:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $54
8010656f:	6a 36                	push   $0x36
  jmp alltraps
80106571:	e9 61 f9 ff ff       	jmp    80105ed7 <alltraps>

80106576 <vector55>:
.globl vector55
vector55:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $55
80106578:	6a 37                	push   $0x37
  jmp alltraps
8010657a:	e9 58 f9 ff ff       	jmp    80105ed7 <alltraps>

8010657f <vector56>:
.globl vector56
vector56:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $56
80106581:	6a 38                	push   $0x38
  jmp alltraps
80106583:	e9 4f f9 ff ff       	jmp    80105ed7 <alltraps>

80106588 <vector57>:
.globl vector57
vector57:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $57
8010658a:	6a 39                	push   $0x39
  jmp alltraps
8010658c:	e9 46 f9 ff ff       	jmp    80105ed7 <alltraps>

80106591 <vector58>:
.globl vector58
vector58:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $58
80106593:	6a 3a                	push   $0x3a
  jmp alltraps
80106595:	e9 3d f9 ff ff       	jmp    80105ed7 <alltraps>

8010659a <vector59>:
.globl vector59
vector59:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $59
8010659c:	6a 3b                	push   $0x3b
  jmp alltraps
8010659e:	e9 34 f9 ff ff       	jmp    80105ed7 <alltraps>

801065a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $60
801065a5:	6a 3c                	push   $0x3c
  jmp alltraps
801065a7:	e9 2b f9 ff ff       	jmp    80105ed7 <alltraps>

801065ac <vector61>:
.globl vector61
vector61:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $61
801065ae:	6a 3d                	push   $0x3d
  jmp alltraps
801065b0:	e9 22 f9 ff ff       	jmp    80105ed7 <alltraps>

801065b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $62
801065b7:	6a 3e                	push   $0x3e
  jmp alltraps
801065b9:	e9 19 f9 ff ff       	jmp    80105ed7 <alltraps>

801065be <vector63>:
.globl vector63
vector63:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $63
801065c0:	6a 3f                	push   $0x3f
  jmp alltraps
801065c2:	e9 10 f9 ff ff       	jmp    80105ed7 <alltraps>

801065c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $64
801065c9:	6a 40                	push   $0x40
  jmp alltraps
801065cb:	e9 07 f9 ff ff       	jmp    80105ed7 <alltraps>

801065d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $65
801065d2:	6a 41                	push   $0x41
  jmp alltraps
801065d4:	e9 fe f8 ff ff       	jmp    80105ed7 <alltraps>

801065d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $66
801065db:	6a 42                	push   $0x42
  jmp alltraps
801065dd:	e9 f5 f8 ff ff       	jmp    80105ed7 <alltraps>

801065e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $67
801065e4:	6a 43                	push   $0x43
  jmp alltraps
801065e6:	e9 ec f8 ff ff       	jmp    80105ed7 <alltraps>

801065eb <vector68>:
.globl vector68
vector68:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $68
801065ed:	6a 44                	push   $0x44
  jmp alltraps
801065ef:	e9 e3 f8 ff ff       	jmp    80105ed7 <alltraps>

801065f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $69
801065f6:	6a 45                	push   $0x45
  jmp alltraps
801065f8:	e9 da f8 ff ff       	jmp    80105ed7 <alltraps>

801065fd <vector70>:
.globl vector70
vector70:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $70
801065ff:	6a 46                	push   $0x46
  jmp alltraps
80106601:	e9 d1 f8 ff ff       	jmp    80105ed7 <alltraps>

80106606 <vector71>:
.globl vector71
vector71:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $71
80106608:	6a 47                	push   $0x47
  jmp alltraps
8010660a:	e9 c8 f8 ff ff       	jmp    80105ed7 <alltraps>

8010660f <vector72>:
.globl vector72
vector72:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $72
80106611:	6a 48                	push   $0x48
  jmp alltraps
80106613:	e9 bf f8 ff ff       	jmp    80105ed7 <alltraps>

80106618 <vector73>:
.globl vector73
vector73:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $73
8010661a:	6a 49                	push   $0x49
  jmp alltraps
8010661c:	e9 b6 f8 ff ff       	jmp    80105ed7 <alltraps>

80106621 <vector74>:
.globl vector74
vector74:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $74
80106623:	6a 4a                	push   $0x4a
  jmp alltraps
80106625:	e9 ad f8 ff ff       	jmp    80105ed7 <alltraps>

8010662a <vector75>:
.globl vector75
vector75:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $75
8010662c:	6a 4b                	push   $0x4b
  jmp alltraps
8010662e:	e9 a4 f8 ff ff       	jmp    80105ed7 <alltraps>

80106633 <vector76>:
.globl vector76
vector76:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $76
80106635:	6a 4c                	push   $0x4c
  jmp alltraps
80106637:	e9 9b f8 ff ff       	jmp    80105ed7 <alltraps>

8010663c <vector77>:
.globl vector77
vector77:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $77
8010663e:	6a 4d                	push   $0x4d
  jmp alltraps
80106640:	e9 92 f8 ff ff       	jmp    80105ed7 <alltraps>

80106645 <vector78>:
.globl vector78
vector78:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $78
80106647:	6a 4e                	push   $0x4e
  jmp alltraps
80106649:	e9 89 f8 ff ff       	jmp    80105ed7 <alltraps>

8010664e <vector79>:
.globl vector79
vector79:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $79
80106650:	6a 4f                	push   $0x4f
  jmp alltraps
80106652:	e9 80 f8 ff ff       	jmp    80105ed7 <alltraps>

80106657 <vector80>:
.globl vector80
vector80:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $80
80106659:	6a 50                	push   $0x50
  jmp alltraps
8010665b:	e9 77 f8 ff ff       	jmp    80105ed7 <alltraps>

80106660 <vector81>:
.globl vector81
vector81:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $81
80106662:	6a 51                	push   $0x51
  jmp alltraps
80106664:	e9 6e f8 ff ff       	jmp    80105ed7 <alltraps>

80106669 <vector82>:
.globl vector82
vector82:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $82
8010666b:	6a 52                	push   $0x52
  jmp alltraps
8010666d:	e9 65 f8 ff ff       	jmp    80105ed7 <alltraps>

80106672 <vector83>:
.globl vector83
vector83:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $83
80106674:	6a 53                	push   $0x53
  jmp alltraps
80106676:	e9 5c f8 ff ff       	jmp    80105ed7 <alltraps>

8010667b <vector84>:
.globl vector84
vector84:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $84
8010667d:	6a 54                	push   $0x54
  jmp alltraps
8010667f:	e9 53 f8 ff ff       	jmp    80105ed7 <alltraps>

80106684 <vector85>:
.globl vector85
vector85:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $85
80106686:	6a 55                	push   $0x55
  jmp alltraps
80106688:	e9 4a f8 ff ff       	jmp    80105ed7 <alltraps>

8010668d <vector86>:
.globl vector86
vector86:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $86
8010668f:	6a 56                	push   $0x56
  jmp alltraps
80106691:	e9 41 f8 ff ff       	jmp    80105ed7 <alltraps>

80106696 <vector87>:
.globl vector87
vector87:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $87
80106698:	6a 57                	push   $0x57
  jmp alltraps
8010669a:	e9 38 f8 ff ff       	jmp    80105ed7 <alltraps>

8010669f <vector88>:
.globl vector88
vector88:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $88
801066a1:	6a 58                	push   $0x58
  jmp alltraps
801066a3:	e9 2f f8 ff ff       	jmp    80105ed7 <alltraps>

801066a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $89
801066aa:	6a 59                	push   $0x59
  jmp alltraps
801066ac:	e9 26 f8 ff ff       	jmp    80105ed7 <alltraps>

801066b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $90
801066b3:	6a 5a                	push   $0x5a
  jmp alltraps
801066b5:	e9 1d f8 ff ff       	jmp    80105ed7 <alltraps>

801066ba <vector91>:
.globl vector91
vector91:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $91
801066bc:	6a 5b                	push   $0x5b
  jmp alltraps
801066be:	e9 14 f8 ff ff       	jmp    80105ed7 <alltraps>

801066c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $92
801066c5:	6a 5c                	push   $0x5c
  jmp alltraps
801066c7:	e9 0b f8 ff ff       	jmp    80105ed7 <alltraps>

801066cc <vector93>:
.globl vector93
vector93:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $93
801066ce:	6a 5d                	push   $0x5d
  jmp alltraps
801066d0:	e9 02 f8 ff ff       	jmp    80105ed7 <alltraps>

801066d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $94
801066d7:	6a 5e                	push   $0x5e
  jmp alltraps
801066d9:	e9 f9 f7 ff ff       	jmp    80105ed7 <alltraps>

801066de <vector95>:
.globl vector95
vector95:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $95
801066e0:	6a 5f                	push   $0x5f
  jmp alltraps
801066e2:	e9 f0 f7 ff ff       	jmp    80105ed7 <alltraps>

801066e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $96
801066e9:	6a 60                	push   $0x60
  jmp alltraps
801066eb:	e9 e7 f7 ff ff       	jmp    80105ed7 <alltraps>

801066f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $97
801066f2:	6a 61                	push   $0x61
  jmp alltraps
801066f4:	e9 de f7 ff ff       	jmp    80105ed7 <alltraps>

801066f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $98
801066fb:	6a 62                	push   $0x62
  jmp alltraps
801066fd:	e9 d5 f7 ff ff       	jmp    80105ed7 <alltraps>

80106702 <vector99>:
.globl vector99
vector99:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $99
80106704:	6a 63                	push   $0x63
  jmp alltraps
80106706:	e9 cc f7 ff ff       	jmp    80105ed7 <alltraps>

8010670b <vector100>:
.globl vector100
vector100:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $100
8010670d:	6a 64                	push   $0x64
  jmp alltraps
8010670f:	e9 c3 f7 ff ff       	jmp    80105ed7 <alltraps>

80106714 <vector101>:
.globl vector101
vector101:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $101
80106716:	6a 65                	push   $0x65
  jmp alltraps
80106718:	e9 ba f7 ff ff       	jmp    80105ed7 <alltraps>

8010671d <vector102>:
.globl vector102
vector102:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $102
8010671f:	6a 66                	push   $0x66
  jmp alltraps
80106721:	e9 b1 f7 ff ff       	jmp    80105ed7 <alltraps>

80106726 <vector103>:
.globl vector103
vector103:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $103
80106728:	6a 67                	push   $0x67
  jmp alltraps
8010672a:	e9 a8 f7 ff ff       	jmp    80105ed7 <alltraps>

8010672f <vector104>:
.globl vector104
vector104:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $104
80106731:	6a 68                	push   $0x68
  jmp alltraps
80106733:	e9 9f f7 ff ff       	jmp    80105ed7 <alltraps>

80106738 <vector105>:
.globl vector105
vector105:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $105
8010673a:	6a 69                	push   $0x69
  jmp alltraps
8010673c:	e9 96 f7 ff ff       	jmp    80105ed7 <alltraps>

80106741 <vector106>:
.globl vector106
vector106:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $106
80106743:	6a 6a                	push   $0x6a
  jmp alltraps
80106745:	e9 8d f7 ff ff       	jmp    80105ed7 <alltraps>

8010674a <vector107>:
.globl vector107
vector107:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $107
8010674c:	6a 6b                	push   $0x6b
  jmp alltraps
8010674e:	e9 84 f7 ff ff       	jmp    80105ed7 <alltraps>

80106753 <vector108>:
.globl vector108
vector108:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $108
80106755:	6a 6c                	push   $0x6c
  jmp alltraps
80106757:	e9 7b f7 ff ff       	jmp    80105ed7 <alltraps>

8010675c <vector109>:
.globl vector109
vector109:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $109
8010675e:	6a 6d                	push   $0x6d
  jmp alltraps
80106760:	e9 72 f7 ff ff       	jmp    80105ed7 <alltraps>

80106765 <vector110>:
.globl vector110
vector110:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $110
80106767:	6a 6e                	push   $0x6e
  jmp alltraps
80106769:	e9 69 f7 ff ff       	jmp    80105ed7 <alltraps>

8010676e <vector111>:
.globl vector111
vector111:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $111
80106770:	6a 6f                	push   $0x6f
  jmp alltraps
80106772:	e9 60 f7 ff ff       	jmp    80105ed7 <alltraps>

80106777 <vector112>:
.globl vector112
vector112:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $112
80106779:	6a 70                	push   $0x70
  jmp alltraps
8010677b:	e9 57 f7 ff ff       	jmp    80105ed7 <alltraps>

80106780 <vector113>:
.globl vector113
vector113:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $113
80106782:	6a 71                	push   $0x71
  jmp alltraps
80106784:	e9 4e f7 ff ff       	jmp    80105ed7 <alltraps>

80106789 <vector114>:
.globl vector114
vector114:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $114
8010678b:	6a 72                	push   $0x72
  jmp alltraps
8010678d:	e9 45 f7 ff ff       	jmp    80105ed7 <alltraps>

80106792 <vector115>:
.globl vector115
vector115:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $115
80106794:	6a 73                	push   $0x73
  jmp alltraps
80106796:	e9 3c f7 ff ff       	jmp    80105ed7 <alltraps>

8010679b <vector116>:
.globl vector116
vector116:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $116
8010679d:	6a 74                	push   $0x74
  jmp alltraps
8010679f:	e9 33 f7 ff ff       	jmp    80105ed7 <alltraps>

801067a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $117
801067a6:	6a 75                	push   $0x75
  jmp alltraps
801067a8:	e9 2a f7 ff ff       	jmp    80105ed7 <alltraps>

801067ad <vector118>:
.globl vector118
vector118:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $118
801067af:	6a 76                	push   $0x76
  jmp alltraps
801067b1:	e9 21 f7 ff ff       	jmp    80105ed7 <alltraps>

801067b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $119
801067b8:	6a 77                	push   $0x77
  jmp alltraps
801067ba:	e9 18 f7 ff ff       	jmp    80105ed7 <alltraps>

801067bf <vector120>:
.globl vector120
vector120:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $120
801067c1:	6a 78                	push   $0x78
  jmp alltraps
801067c3:	e9 0f f7 ff ff       	jmp    80105ed7 <alltraps>

801067c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $121
801067ca:	6a 79                	push   $0x79
  jmp alltraps
801067cc:	e9 06 f7 ff ff       	jmp    80105ed7 <alltraps>

801067d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $122
801067d3:	6a 7a                	push   $0x7a
  jmp alltraps
801067d5:	e9 fd f6 ff ff       	jmp    80105ed7 <alltraps>

801067da <vector123>:
.globl vector123
vector123:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $123
801067dc:	6a 7b                	push   $0x7b
  jmp alltraps
801067de:	e9 f4 f6 ff ff       	jmp    80105ed7 <alltraps>

801067e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $124
801067e5:	6a 7c                	push   $0x7c
  jmp alltraps
801067e7:	e9 eb f6 ff ff       	jmp    80105ed7 <alltraps>

801067ec <vector125>:
.globl vector125
vector125:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $125
801067ee:	6a 7d                	push   $0x7d
  jmp alltraps
801067f0:	e9 e2 f6 ff ff       	jmp    80105ed7 <alltraps>

801067f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $126
801067f7:	6a 7e                	push   $0x7e
  jmp alltraps
801067f9:	e9 d9 f6 ff ff       	jmp    80105ed7 <alltraps>

801067fe <vector127>:
.globl vector127
vector127:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $127
80106800:	6a 7f                	push   $0x7f
  jmp alltraps
80106802:	e9 d0 f6 ff ff       	jmp    80105ed7 <alltraps>

80106807 <vector128>:
.globl vector128
vector128:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $128
80106809:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010680e:	e9 c4 f6 ff ff       	jmp    80105ed7 <alltraps>

80106813 <vector129>:
.globl vector129
vector129:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $129
80106815:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010681a:	e9 b8 f6 ff ff       	jmp    80105ed7 <alltraps>

8010681f <vector130>:
.globl vector130
vector130:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $130
80106821:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106826:	e9 ac f6 ff ff       	jmp    80105ed7 <alltraps>

8010682b <vector131>:
.globl vector131
vector131:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $131
8010682d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106832:	e9 a0 f6 ff ff       	jmp    80105ed7 <alltraps>

80106837 <vector132>:
.globl vector132
vector132:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $132
80106839:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010683e:	e9 94 f6 ff ff       	jmp    80105ed7 <alltraps>

80106843 <vector133>:
.globl vector133
vector133:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $133
80106845:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010684a:	e9 88 f6 ff ff       	jmp    80105ed7 <alltraps>

8010684f <vector134>:
.globl vector134
vector134:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $134
80106851:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106856:	e9 7c f6 ff ff       	jmp    80105ed7 <alltraps>

8010685b <vector135>:
.globl vector135
vector135:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $135
8010685d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106862:	e9 70 f6 ff ff       	jmp    80105ed7 <alltraps>

80106867 <vector136>:
.globl vector136
vector136:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $136
80106869:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010686e:	e9 64 f6 ff ff       	jmp    80105ed7 <alltraps>

80106873 <vector137>:
.globl vector137
vector137:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $137
80106875:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010687a:	e9 58 f6 ff ff       	jmp    80105ed7 <alltraps>

8010687f <vector138>:
.globl vector138
vector138:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $138
80106881:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106886:	e9 4c f6 ff ff       	jmp    80105ed7 <alltraps>

8010688b <vector139>:
.globl vector139
vector139:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $139
8010688d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106892:	e9 40 f6 ff ff       	jmp    80105ed7 <alltraps>

80106897 <vector140>:
.globl vector140
vector140:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $140
80106899:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010689e:	e9 34 f6 ff ff       	jmp    80105ed7 <alltraps>

801068a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $141
801068a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068aa:	e9 28 f6 ff ff       	jmp    80105ed7 <alltraps>

801068af <vector142>:
.globl vector142
vector142:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $142
801068b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068b6:	e9 1c f6 ff ff       	jmp    80105ed7 <alltraps>

801068bb <vector143>:
.globl vector143
vector143:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $143
801068bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068c2:	e9 10 f6 ff ff       	jmp    80105ed7 <alltraps>

801068c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $144
801068c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068ce:	e9 04 f6 ff ff       	jmp    80105ed7 <alltraps>

801068d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $145
801068d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068da:	e9 f8 f5 ff ff       	jmp    80105ed7 <alltraps>

801068df <vector146>:
.globl vector146
vector146:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $146
801068e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068e6:	e9 ec f5 ff ff       	jmp    80105ed7 <alltraps>

801068eb <vector147>:
.globl vector147
vector147:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $147
801068ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801068f2:	e9 e0 f5 ff ff       	jmp    80105ed7 <alltraps>

801068f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $148
801068f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068fe:	e9 d4 f5 ff ff       	jmp    80105ed7 <alltraps>

80106903 <vector149>:
.globl vector149
vector149:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $149
80106905:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010690a:	e9 c8 f5 ff ff       	jmp    80105ed7 <alltraps>

8010690f <vector150>:
.globl vector150
vector150:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $150
80106911:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106916:	e9 bc f5 ff ff       	jmp    80105ed7 <alltraps>

8010691b <vector151>:
.globl vector151
vector151:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $151
8010691d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106922:	e9 b0 f5 ff ff       	jmp    80105ed7 <alltraps>

80106927 <vector152>:
.globl vector152
vector152:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $152
80106929:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010692e:	e9 a4 f5 ff ff       	jmp    80105ed7 <alltraps>

80106933 <vector153>:
.globl vector153
vector153:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $153
80106935:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010693a:	e9 98 f5 ff ff       	jmp    80105ed7 <alltraps>

8010693f <vector154>:
.globl vector154
vector154:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $154
80106941:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106946:	e9 8c f5 ff ff       	jmp    80105ed7 <alltraps>

8010694b <vector155>:
.globl vector155
vector155:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $155
8010694d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106952:	e9 80 f5 ff ff       	jmp    80105ed7 <alltraps>

80106957 <vector156>:
.globl vector156
vector156:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $156
80106959:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010695e:	e9 74 f5 ff ff       	jmp    80105ed7 <alltraps>

80106963 <vector157>:
.globl vector157
vector157:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $157
80106965:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010696a:	e9 68 f5 ff ff       	jmp    80105ed7 <alltraps>

8010696f <vector158>:
.globl vector158
vector158:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $158
80106971:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106976:	e9 5c f5 ff ff       	jmp    80105ed7 <alltraps>

8010697b <vector159>:
.globl vector159
vector159:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $159
8010697d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106982:	e9 50 f5 ff ff       	jmp    80105ed7 <alltraps>

80106987 <vector160>:
.globl vector160
vector160:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $160
80106989:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010698e:	e9 44 f5 ff ff       	jmp    80105ed7 <alltraps>

80106993 <vector161>:
.globl vector161
vector161:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $161
80106995:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010699a:	e9 38 f5 ff ff       	jmp    80105ed7 <alltraps>

8010699f <vector162>:
.globl vector162
vector162:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $162
801069a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069a6:	e9 2c f5 ff ff       	jmp    80105ed7 <alltraps>

801069ab <vector163>:
.globl vector163
vector163:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $163
801069ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069b2:	e9 20 f5 ff ff       	jmp    80105ed7 <alltraps>

801069b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $164
801069b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069be:	e9 14 f5 ff ff       	jmp    80105ed7 <alltraps>

801069c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $165
801069c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069ca:	e9 08 f5 ff ff       	jmp    80105ed7 <alltraps>

801069cf <vector166>:
.globl vector166
vector166:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $166
801069d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069d6:	e9 fc f4 ff ff       	jmp    80105ed7 <alltraps>

801069db <vector167>:
.globl vector167
vector167:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $167
801069dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069e2:	e9 f0 f4 ff ff       	jmp    80105ed7 <alltraps>

801069e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $168
801069e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069ee:	e9 e4 f4 ff ff       	jmp    80105ed7 <alltraps>

801069f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $169
801069f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801069fa:	e9 d8 f4 ff ff       	jmp    80105ed7 <alltraps>

801069ff <vector170>:
.globl vector170
vector170:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $170
80106a01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a06:	e9 cc f4 ff ff       	jmp    80105ed7 <alltraps>

80106a0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $171
80106a0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a12:	e9 c0 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $172
80106a19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a1e:	e9 b4 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $173
80106a25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a2a:	e9 a8 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $174
80106a31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a36:	e9 9c f4 ff ff       	jmp    80105ed7 <alltraps>

80106a3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $175
80106a3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a42:	e9 90 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $176
80106a49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a4e:	e9 84 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $177
80106a55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a5a:	e9 78 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $178
80106a61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a66:	e9 6c f4 ff ff       	jmp    80105ed7 <alltraps>

80106a6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $179
80106a6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a72:	e9 60 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $180
80106a79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a7e:	e9 54 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $181
80106a85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a8a:	e9 48 f4 ff ff       	jmp    80105ed7 <alltraps>

80106a8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $182
80106a91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a96:	e9 3c f4 ff ff       	jmp    80105ed7 <alltraps>

80106a9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $183
80106a9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106aa2:	e9 30 f4 ff ff       	jmp    80105ed7 <alltraps>

80106aa7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $184
80106aa9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106aae:	e9 24 f4 ff ff       	jmp    80105ed7 <alltraps>

80106ab3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $185
80106ab5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106aba:	e9 18 f4 ff ff       	jmp    80105ed7 <alltraps>

80106abf <vector186>:
.globl vector186
vector186:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $186
80106ac1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ac6:	e9 0c f4 ff ff       	jmp    80105ed7 <alltraps>

80106acb <vector187>:
.globl vector187
vector187:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $187
80106acd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ad2:	e9 00 f4 ff ff       	jmp    80105ed7 <alltraps>

80106ad7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $188
80106ad9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ade:	e9 f4 f3 ff ff       	jmp    80105ed7 <alltraps>

80106ae3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $189
80106ae5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106aea:	e9 e8 f3 ff ff       	jmp    80105ed7 <alltraps>

80106aef <vector190>:
.globl vector190
vector190:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $190
80106af1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106af6:	e9 dc f3 ff ff       	jmp    80105ed7 <alltraps>

80106afb <vector191>:
.globl vector191
vector191:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $191
80106afd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b02:	e9 d0 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $192
80106b09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b0e:	e9 c4 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $193
80106b15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b1a:	e9 b8 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $194
80106b21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b26:	e9 ac f3 ff ff       	jmp    80105ed7 <alltraps>

80106b2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $195
80106b2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b32:	e9 a0 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $196
80106b39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b3e:	e9 94 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $197
80106b45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b4a:	e9 88 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $198
80106b51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b56:	e9 7c f3 ff ff       	jmp    80105ed7 <alltraps>

80106b5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $199
80106b5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b62:	e9 70 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $200
80106b69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b6e:	e9 64 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $201
80106b75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b7a:	e9 58 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $202
80106b81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b86:	e9 4c f3 ff ff       	jmp    80105ed7 <alltraps>

80106b8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $203
80106b8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b92:	e9 40 f3 ff ff       	jmp    80105ed7 <alltraps>

80106b97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $204
80106b99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b9e:	e9 34 f3 ff ff       	jmp    80105ed7 <alltraps>

80106ba3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $205
80106ba5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106baa:	e9 28 f3 ff ff       	jmp    80105ed7 <alltraps>

80106baf <vector206>:
.globl vector206
vector206:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $206
80106bb1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bb6:	e9 1c f3 ff ff       	jmp    80105ed7 <alltraps>

80106bbb <vector207>:
.globl vector207
vector207:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $207
80106bbd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106bc2:	e9 10 f3 ff ff       	jmp    80105ed7 <alltraps>

80106bc7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $208
80106bc9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bce:	e9 04 f3 ff ff       	jmp    80105ed7 <alltraps>

80106bd3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $209
80106bd5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bda:	e9 f8 f2 ff ff       	jmp    80105ed7 <alltraps>

80106bdf <vector210>:
.globl vector210
vector210:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $210
80106be1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106be6:	e9 ec f2 ff ff       	jmp    80105ed7 <alltraps>

80106beb <vector211>:
.globl vector211
vector211:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $211
80106bed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106bf2:	e9 e0 f2 ff ff       	jmp    80105ed7 <alltraps>

80106bf7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $212
80106bf9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106bfe:	e9 d4 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $213
80106c05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c0a:	e9 c8 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $214
80106c11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c16:	e9 bc f2 ff ff       	jmp    80105ed7 <alltraps>

80106c1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $215
80106c1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c22:	e9 b0 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $216
80106c29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c2e:	e9 a4 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $217
80106c35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c3a:	e9 98 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $218
80106c41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c46:	e9 8c f2 ff ff       	jmp    80105ed7 <alltraps>

80106c4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $219
80106c4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c52:	e9 80 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $220
80106c59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c5e:	e9 74 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $221
80106c65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c6a:	e9 68 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $222
80106c71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c76:	e9 5c f2 ff ff       	jmp    80105ed7 <alltraps>

80106c7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $223
80106c7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c82:	e9 50 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $224
80106c89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c8e:	e9 44 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $225
80106c95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c9a:	e9 38 f2 ff ff       	jmp    80105ed7 <alltraps>

80106c9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $226
80106ca1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ca6:	e9 2c f2 ff ff       	jmp    80105ed7 <alltraps>

80106cab <vector227>:
.globl vector227
vector227:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $227
80106cad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cb2:	e9 20 f2 ff ff       	jmp    80105ed7 <alltraps>

80106cb7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $228
80106cb9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cbe:	e9 14 f2 ff ff       	jmp    80105ed7 <alltraps>

80106cc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $229
80106cc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cca:	e9 08 f2 ff ff       	jmp    80105ed7 <alltraps>

80106ccf <vector230>:
.globl vector230
vector230:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $230
80106cd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106cd6:	e9 fc f1 ff ff       	jmp    80105ed7 <alltraps>

80106cdb <vector231>:
.globl vector231
vector231:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $231
80106cdd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ce2:	e9 f0 f1 ff ff       	jmp    80105ed7 <alltraps>

80106ce7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $232
80106ce9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106cee:	e9 e4 f1 ff ff       	jmp    80105ed7 <alltraps>

80106cf3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $233
80106cf5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106cfa:	e9 d8 f1 ff ff       	jmp    80105ed7 <alltraps>

80106cff <vector234>:
.globl vector234
vector234:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $234
80106d01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d06:	e9 cc f1 ff ff       	jmp    80105ed7 <alltraps>

80106d0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $235
80106d0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d12:	e9 c0 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $236
80106d19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d1e:	e9 b4 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $237
80106d25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d2a:	e9 a8 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $238
80106d31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d36:	e9 9c f1 ff ff       	jmp    80105ed7 <alltraps>

80106d3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $239
80106d3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d42:	e9 90 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $240
80106d49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d4e:	e9 84 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $241
80106d55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d5a:	e9 78 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $242
80106d61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d66:	e9 6c f1 ff ff       	jmp    80105ed7 <alltraps>

80106d6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $243
80106d6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d72:	e9 60 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $244
80106d79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d7e:	e9 54 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $245
80106d85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d8a:	e9 48 f1 ff ff       	jmp    80105ed7 <alltraps>

80106d8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $246
80106d91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d96:	e9 3c f1 ff ff       	jmp    80105ed7 <alltraps>

80106d9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $247
80106d9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106da2:	e9 30 f1 ff ff       	jmp    80105ed7 <alltraps>

80106da7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $248
80106da9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dae:	e9 24 f1 ff ff       	jmp    80105ed7 <alltraps>

80106db3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $249
80106db5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dba:	e9 18 f1 ff ff       	jmp    80105ed7 <alltraps>

80106dbf <vector250>:
.globl vector250
vector250:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $250
80106dc1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106dc6:	e9 0c f1 ff ff       	jmp    80105ed7 <alltraps>

80106dcb <vector251>:
.globl vector251
vector251:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $251
80106dcd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106dd2:	e9 00 f1 ff ff       	jmp    80105ed7 <alltraps>

80106dd7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $252
80106dd9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106dde:	e9 f4 f0 ff ff       	jmp    80105ed7 <alltraps>

80106de3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $253
80106de5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106dea:	e9 e8 f0 ff ff       	jmp    80105ed7 <alltraps>

80106def <vector254>:
.globl vector254
vector254:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $254
80106df1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106df6:	e9 dc f0 ff ff       	jmp    80105ed7 <alltraps>

80106dfb <vector255>:
.globl vector255
vector255:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $255
80106dfd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e02:	e9 d0 f0 ff ff       	jmp    80105ed7 <alltraps>
80106e07:	66 90                	xchg   %ax,%ax
80106e09:	66 90                	xchg   %ax,%ax
80106e0b:	66 90                	xchg   %ax,%ax
80106e0d:	66 90                	xchg   %ax,%ax
80106e0f:	90                   	nop

80106e10 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e18:	c1 ea 16             	shr    $0x16,%edx
80106e1b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e1e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106e21:	8b 07                	mov    (%edi),%eax
80106e23:	a8 01                	test   $0x1,%al
80106e25:	74 29                	je     80106e50 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e2c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e35:	c1 eb 0a             	shr    $0xa,%ebx
80106e38:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106e3e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106e41:	5b                   	pop    %ebx
80106e42:	5e                   	pop    %esi
80106e43:	5f                   	pop    %edi
80106e44:	5d                   	pop    %ebp
80106e45:	c3                   	ret    
80106e46:	8d 76 00             	lea    0x0(%esi),%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e50:	85 c9                	test   %ecx,%ecx
80106e52:	74 2c                	je     80106e80 <walkpgdir+0x70>
80106e54:	e8 c7 b9 ff ff       	call   80102820 <kalloc>
80106e59:	85 c0                	test   %eax,%eax
80106e5b:	89 c6                	mov    %eax,%esi
80106e5d:	74 21                	je     80106e80 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106e5f:	83 ec 04             	sub    $0x4,%esp
80106e62:	68 00 10 00 00       	push   $0x1000
80106e67:	6a 00                	push   $0x0
80106e69:	50                   	push   %eax
80106e6a:	e8 21 dc ff ff       	call   80104a90 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e6f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e75:	83 c4 10             	add    $0x10,%esp
80106e78:	83 c8 07             	or     $0x7,%eax
80106e7b:	89 07                	mov    %eax,(%edi)
80106e7d:	eb b3                	jmp    80106e32 <walkpgdir+0x22>
80106e7f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106e83:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e96:	89 d3                	mov    %edx,%ebx
80106e98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e9e:	83 ec 1c             	sub    $0x1c,%esp
80106ea1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ea4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ea8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106eb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eb6:	29 df                	sub    %ebx,%edi
80106eb8:	83 c8 01             	or     $0x1,%eax
80106ebb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ebe:	eb 15                	jmp    80106ed5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106ec0:	f6 00 01             	testb  $0x1,(%eax)
80106ec3:	75 45                	jne    80106f0a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ec5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ec8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ecb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ecd:	74 31                	je     80106f00 <mappages+0x70>
      break;
    a += PGSIZE;
80106ecf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ed5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106edd:	89 da                	mov    %ebx,%edx
80106edf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ee2:	e8 29 ff ff ff       	call   80106e10 <walkpgdir>
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	75 d5                	jne    80106ec0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106ef3:	5b                   	pop    %ebx
80106ef4:	5e                   	pop    %esi
80106ef5:	5f                   	pop    %edi
80106ef6:	5d                   	pop    %ebp
80106ef7:	c3                   	ret    
80106ef8:	90                   	nop
80106ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106f03:	31 c0                	xor    %eax,%eax
}
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106f0a:	83 ec 0c             	sub    $0xc,%esp
80106f0d:	68 80 80 10 80       	push   $0x80108080
80106f12:	e8 59 94 ff ff       	call   80100370 <panic>
80106f17:	89 f6                	mov    %esi,%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f2c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f2e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f34:	83 ec 1c             	sub    $0x1c,%esp
80106f37:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f3a:	39 d3                	cmp    %edx,%ebx
80106f3c:	73 66                	jae    80106fa4 <deallocuvm.part.0+0x84>
80106f3e:	89 d6                	mov    %edx,%esi
80106f40:	eb 3d                	jmp    80106f7f <deallocuvm.part.0+0x5f>
80106f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f48:	8b 10                	mov    (%eax),%edx
80106f4a:	f6 c2 01             	test   $0x1,%dl
80106f4d:	74 26                	je     80106f75 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f4f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106f55:	74 58                	je     80106faf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106f57:	83 ec 0c             	sub    $0xc,%esp
80106f5a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f63:	52                   	push   %edx
80106f64:	e8 07 b7 ff ff       	call   80102670 <kfree>
      *pte = 0;
80106f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f6c:	83 c4 10             	add    $0x10,%esp
80106f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f75:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f7b:	39 f3                	cmp    %esi,%ebx
80106f7d:	73 25                	jae    80106fa4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f7f:	31 c9                	xor    %ecx,%ecx
80106f81:	89 da                	mov    %ebx,%edx
80106f83:	89 f8                	mov    %edi,%eax
80106f85:	e8 86 fe ff ff       	call   80106e10 <walkpgdir>
    if(!pte)
80106f8a:	85 c0                	test   %eax,%eax
80106f8c:	75 ba                	jne    80106f48 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f8e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106f94:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f9a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fa0:	39 f3                	cmp    %esi,%ebx
80106fa2:	72 db                	jb     80106f7f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106faa:	5b                   	pop    %ebx
80106fab:	5e                   	pop    %esi
80106fac:	5f                   	pop    %edi
80106fad:	5d                   	pop    %ebp
80106fae:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106faf:	83 ec 0c             	sub    $0xc,%esp
80106fb2:	68 06 7a 10 80       	push   $0x80107a06
80106fb7:	e8 b4 93 ff ff       	call   80100370 <panic>
80106fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106fc6:	e8 65 cb ff ff       	call   80103b30 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106fcb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106fd1:	31 c9                	xor    %ecx,%ecx
80106fd3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106fd8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106fdf:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fe6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106feb:	31 c9                	xor    %ecx,%ecx
80106fed:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ff4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ff9:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107000:	31 c9                	xor    %ecx,%ecx
80107002:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80107009:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107010:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107015:	31 c9                	xor    %ecx,%ecx
80107017:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010701e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107025:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010702a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80107031:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80107038:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010703f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80107046:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
8010704d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80107054:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010705b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80107062:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80107069:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80107070:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107077:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
8010707e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80107085:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
8010708c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80107093:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010709a:	05 f0 37 11 80       	add    $0x801137f0,%eax
8010709f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801070a3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070a7:	c1 e8 10             	shr    $0x10,%eax
801070aa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801070ae:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070b1:	0f 01 10             	lgdtl  (%eax)
}
801070b4:	c9                   	leave  
801070b5:	c3                   	ret    
801070b6:	8d 76 00             	lea    0x0(%esi),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070c0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070c0:	a1 a4 69 11 80       	mov    0x801169a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801070c5:	55                   	push   %ebp
801070c6:	89 e5                	mov    %esp,%ebp
801070c8:	05 00 00 00 80       	add    $0x80000000,%eax
801070cd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801070d0:	5d                   	pop    %ebp
801070d1:	c3                   	ret    
801070d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801070ec:	85 f6                	test   %esi,%esi
801070ee:	0f 84 cd 00 00 00    	je     801071c1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801070f4:	8b 46 08             	mov    0x8(%esi),%eax
801070f7:	85 c0                	test   %eax,%eax
801070f9:	0f 84 dc 00 00 00    	je     801071db <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801070ff:	8b 7e 04             	mov    0x4(%esi),%edi
80107102:	85 ff                	test   %edi,%edi
80107104:	0f 84 c4 00 00 00    	je     801071ce <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010710a:	e8 a1 d7 ff ff       	call   801048b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010710f:	e8 9c c9 ff ff       	call   80103ab0 <mycpu>
80107114:	89 c3                	mov    %eax,%ebx
80107116:	e8 95 c9 ff ff       	call   80103ab0 <mycpu>
8010711b:	89 c7                	mov    %eax,%edi
8010711d:	e8 8e c9 ff ff       	call   80103ab0 <mycpu>
80107122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107125:	83 c7 08             	add    $0x8,%edi
80107128:	e8 83 c9 ff ff       	call   80103ab0 <mycpu>
8010712d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107130:	83 c0 08             	add    $0x8,%eax
80107133:	ba 67 00 00 00       	mov    $0x67,%edx
80107138:	c1 e8 18             	shr    $0x18,%eax
8010713b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107142:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107149:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107150:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107157:	83 c1 08             	add    $0x8,%ecx
8010715a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107160:	c1 e9 10             	shr    $0x10,%ecx
80107163:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107169:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010716e:	e8 3d c9 ff ff       	call   80103ab0 <mycpu>
80107173:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010717a:	e8 31 c9 ff ff       	call   80103ab0 <mycpu>
8010717f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107184:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107188:	e8 23 c9 ff ff       	call   80103ab0 <mycpu>
8010718d:	8b 56 08             	mov    0x8(%esi),%edx
80107190:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107196:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107199:	e8 12 c9 ff ff       	call   80103ab0 <mycpu>
8010719e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801071a2:	b8 28 00 00 00       	mov    $0x28,%eax
801071a7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071aa:	8b 46 04             	mov    0x4(%esi),%eax
801071ad:	05 00 00 00 80       	add    $0x80000000,%eax
801071b2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801071b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b8:	5b                   	pop    %ebx
801071b9:	5e                   	pop    %esi
801071ba:	5f                   	pop    %edi
801071bb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801071bc:	e9 2f d7 ff ff       	jmp    801048f0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801071c1:	83 ec 0c             	sub    $0xc,%esp
801071c4:	68 86 80 10 80       	push   $0x80108086
801071c9:	e8 a2 91 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801071ce:	83 ec 0c             	sub    $0xc,%esp
801071d1:	68 b1 80 10 80       	push   $0x801080b1
801071d6:	e8 95 91 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801071db:	83 ec 0c             	sub    $0xc,%esp
801071de:	68 9c 80 10 80       	push   $0x8010809c
801071e3:	e8 88 91 ff ff       	call   80100370 <panic>
801071e8:	90                   	nop
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071f0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 75 10             	mov    0x10(%ebp),%esi
801071fc:	8b 45 08             	mov    0x8(%ebp),%eax
801071ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107202:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010720b:	77 49                	ja     80107256 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010720d:	e8 0e b6 ff ff       	call   80102820 <kalloc>
  memset(mem, 0, PGSIZE);
80107212:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107215:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107217:	68 00 10 00 00       	push   $0x1000
8010721c:	6a 00                	push   $0x0
8010721e:	50                   	push   %eax
8010721f:	e8 6c d8 ff ff       	call   80104a90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107224:	58                   	pop    %eax
80107225:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010722b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107230:	5a                   	pop    %edx
80107231:	6a 06                	push   $0x6
80107233:	50                   	push   %eax
80107234:	31 d2                	xor    %edx,%edx
80107236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107239:	e8 52 fc ff ff       	call   80106e90 <mappages>
  memmove(mem, init, sz);
8010723e:	89 75 10             	mov    %esi,0x10(%ebp)
80107241:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107244:	83 c4 10             	add    $0x10,%esp
80107247:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010724a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724d:	5b                   	pop    %ebx
8010724e:	5e                   	pop    %esi
8010724f:	5f                   	pop    %edi
80107250:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107251:	e9 ea d8 ff ff       	jmp    80104b40 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107256:	83 ec 0c             	sub    $0xc,%esp
80107259:	68 c5 80 10 80       	push   $0x801080c5
8010725e:	e8 0d 91 ff ff       	call   80100370 <panic>
80107263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107270 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107279:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107280:	0f 85 91 00 00 00    	jne    80107317 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107286:	8b 75 18             	mov    0x18(%ebp),%esi
80107289:	31 db                	xor    %ebx,%ebx
8010728b:	85 f6                	test   %esi,%esi
8010728d:	75 1a                	jne    801072a9 <loaduvm+0x39>
8010728f:	eb 6f                	jmp    80107300 <loaduvm+0x90>
80107291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107298:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010729e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801072a4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801072a7:	76 57                	jbe    80107300 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801072ac:	8b 45 08             	mov    0x8(%ebp),%eax
801072af:	31 c9                	xor    %ecx,%ecx
801072b1:	01 da                	add    %ebx,%edx
801072b3:	e8 58 fb ff ff       	call   80106e10 <walkpgdir>
801072b8:	85 c0                	test   %eax,%eax
801072ba:	74 4e                	je     8010730a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801072bc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072be:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801072c1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801072c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072cb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072d1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072d4:	01 d9                	add    %ebx,%ecx
801072d6:	05 00 00 00 80       	add    $0x80000000,%eax
801072db:	57                   	push   %edi
801072dc:	51                   	push   %ecx
801072dd:	50                   	push   %eax
801072de:	ff 75 10             	pushl  0x10(%ebp)
801072e1:	e8 fa a9 ff ff       	call   80101ce0 <readi>
801072e6:	83 c4 10             	add    $0x10,%esp
801072e9:	39 c7                	cmp    %eax,%edi
801072eb:	74 ab                	je     80107298 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801072ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801072f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
801072fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107300:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107303:	31 c0                	xor    %eax,%eax
}
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010730a:	83 ec 0c             	sub    $0xc,%esp
8010730d:	68 df 80 10 80       	push   $0x801080df
80107312:	e8 59 90 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107317:	83 ec 0c             	sub    $0xc,%esp
8010731a:	68 80 81 10 80       	push   $0x80108180
8010731f:	e8 4c 90 ff ff       	call   80100370 <panic>
80107324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010732a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107330 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 0c             	sub    $0xc,%esp
80107339:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010733c:	85 ff                	test   %edi,%edi
8010733e:	0f 88 ca 00 00 00    	js     8010740e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107344:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107347:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010734a:	0f 82 82 00 00 00    	jb     801073d2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107350:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107356:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010735c:	39 df                	cmp    %ebx,%edi
8010735e:	77 43                	ja     801073a3 <allocuvm+0x73>
80107360:	e9 bb 00 00 00       	jmp    80107420 <allocuvm+0xf0>
80107365:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107368:	83 ec 04             	sub    $0x4,%esp
8010736b:	68 00 10 00 00       	push   $0x1000
80107370:	6a 00                	push   $0x0
80107372:	50                   	push   %eax
80107373:	e8 18 d7 ff ff       	call   80104a90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107378:	58                   	pop    %eax
80107379:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010737f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107384:	5a                   	pop    %edx
80107385:	6a 06                	push   $0x6
80107387:	50                   	push   %eax
80107388:	89 da                	mov    %ebx,%edx
8010738a:	8b 45 08             	mov    0x8(%ebp),%eax
8010738d:	e8 fe fa ff ff       	call   80106e90 <mappages>
80107392:	83 c4 10             	add    $0x10,%esp
80107395:	85 c0                	test   %eax,%eax
80107397:	78 47                	js     801073e0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107399:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010739f:	39 df                	cmp    %ebx,%edi
801073a1:	76 7d                	jbe    80107420 <allocuvm+0xf0>
    mem = kalloc();
801073a3:	e8 78 b4 ff ff       	call   80102820 <kalloc>
    if(mem == 0){
801073a8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801073aa:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801073ac:	75 ba                	jne    80107368 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801073ae:	83 ec 0c             	sub    $0xc,%esp
801073b1:	68 fd 80 10 80       	push   $0x801080fd
801073b6:	e8 a5 92 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801073bb:	83 c4 10             	add    $0x10,%esp
801073be:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073c1:	76 4b                	jbe    8010740e <allocuvm+0xde>
801073c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073c6:	8b 45 08             	mov    0x8(%ebp),%eax
801073c9:	89 fa                	mov    %edi,%edx
801073cb:	e8 50 fb ff ff       	call   80106f20 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801073d0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801073d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d5:	5b                   	pop    %ebx
801073d6:	5e                   	pop    %esi
801073d7:	5f                   	pop    %edi
801073d8:	5d                   	pop    %ebp
801073d9:	c3                   	ret    
801073da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 15 81 10 80       	push   $0x80108115
801073e8:	e8 73 92 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801073ed:	83 c4 10             	add    $0x10,%esp
801073f0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073f3:	76 0d                	jbe    80107402 <allocuvm+0xd2>
801073f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801073f8:	8b 45 08             	mov    0x8(%ebp),%eax
801073fb:	89 fa                	mov    %edi,%edx
801073fd:	e8 1e fb ff ff       	call   80106f20 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107402:	83 ec 0c             	sub    $0xc,%esp
80107405:	56                   	push   %esi
80107406:	e8 65 b2 ff ff       	call   80102670 <kfree>
      return 0;
8010740b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010740e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107411:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107413:	5b                   	pop    %ebx
80107414:	5e                   	pop    %esi
80107415:	5f                   	pop    %edi
80107416:	5d                   	pop    %ebp
80107417:	c3                   	ret    
80107418:	90                   	nop
80107419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107420:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107423:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107425:	5b                   	pop    %ebx
80107426:	5e                   	pop    %esi
80107427:	5f                   	pop    %edi
80107428:	5d                   	pop    %ebp
80107429:	c3                   	ret    
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107430 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	8b 55 0c             	mov    0xc(%ebp),%edx
80107436:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107439:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010743c:	39 d1                	cmp    %edx,%ecx
8010743e:	73 10                	jae    80107450 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107440:	5d                   	pop    %ebp
80107441:	e9 da fa ff ff       	jmp    80106f20 <deallocuvm.part.0>
80107446:	8d 76 00             	lea    0x0(%esi),%esi
80107449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107450:	89 d0                	mov    %edx,%eax
80107452:	5d                   	pop    %ebp
80107453:	c3                   	ret    
80107454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010745a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107460 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 0c             	sub    $0xc,%esp
80107469:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010746c:	85 f6                	test   %esi,%esi
8010746e:	74 59                	je     801074c9 <freevm+0x69>
80107470:	31 c9                	xor    %ecx,%ecx
80107472:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107477:	89 f0                	mov    %esi,%eax
80107479:	e8 a2 fa ff ff       	call   80106f20 <deallocuvm.part.0>
8010747e:	89 f3                	mov    %esi,%ebx
80107480:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107486:	eb 0f                	jmp    80107497 <freevm+0x37>
80107488:	90                   	nop
80107489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107490:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107493:	39 fb                	cmp    %edi,%ebx
80107495:	74 23                	je     801074ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107497:	8b 03                	mov    (%ebx),%eax
80107499:	a8 01                	test   $0x1,%al
8010749b:	74 f3                	je     80107490 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010749d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074a2:	83 ec 0c             	sub    $0xc,%esp
801074a5:	83 c3 04             	add    $0x4,%ebx
801074a8:	05 00 00 00 80       	add    $0x80000000,%eax
801074ad:	50                   	push   %eax
801074ae:	e8 bd b1 ff ff       	call   80102670 <kfree>
801074b3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074b6:	39 fb                	cmp    %edi,%ebx
801074b8:	75 dd                	jne    80107497 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801074ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c0:	5b                   	pop    %ebx
801074c1:	5e                   	pop    %esi
801074c2:	5f                   	pop    %edi
801074c3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801074c4:	e9 a7 b1 ff ff       	jmp    80102670 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801074c9:	83 ec 0c             	sub    $0xc,%esp
801074cc:	68 31 81 10 80       	push   $0x80108131
801074d1:	e8 9a 8e ff ff       	call   80100370 <panic>
801074d6:	8d 76 00             	lea    0x0(%esi),%esi
801074d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074e0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	56                   	push   %esi
801074e4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801074e5:	e8 36 b3 ff ff       	call   80102820 <kalloc>
801074ea:	85 c0                	test   %eax,%eax
801074ec:	74 6a                	je     80107558 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801074ee:	83 ec 04             	sub    $0x4,%esp
801074f1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801074f8:	68 00 10 00 00       	push   $0x1000
801074fd:	6a 00                	push   $0x0
801074ff:	50                   	push   %eax
80107500:	e8 8b d5 ff ff       	call   80104a90 <memset>
80107505:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107508:	8b 43 04             	mov    0x4(%ebx),%eax
8010750b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010750e:	83 ec 08             	sub    $0x8,%esp
80107511:	8b 13                	mov    (%ebx),%edx
80107513:	ff 73 0c             	pushl  0xc(%ebx)
80107516:	50                   	push   %eax
80107517:	29 c1                	sub    %eax,%ecx
80107519:	89 f0                	mov    %esi,%eax
8010751b:	e8 70 f9 ff ff       	call   80106e90 <mappages>
80107520:	83 c4 10             	add    $0x10,%esp
80107523:	85 c0                	test   %eax,%eax
80107525:	78 19                	js     80107540 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107527:	83 c3 10             	add    $0x10,%ebx
8010752a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107530:	75 d6                	jne    80107508 <setupkvm+0x28>
80107532:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107534:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107537:	5b                   	pop    %ebx
80107538:	5e                   	pop    %esi
80107539:	5d                   	pop    %ebp
8010753a:	c3                   	ret    
8010753b:	90                   	nop
8010753c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107540:	83 ec 0c             	sub    $0xc,%esp
80107543:	56                   	push   %esi
80107544:	e8 17 ff ff ff       	call   80107460 <freevm>
      return 0;
80107549:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010754c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010754f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107551:	5b                   	pop    %ebx
80107552:	5e                   	pop    %esi
80107553:	5d                   	pop    %ebp
80107554:	c3                   	ret    
80107555:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107558:	31 c0                	xor    %eax,%eax
8010755a:	eb d8                	jmp    80107534 <setupkvm+0x54>
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107560 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107566:	e8 75 ff ff ff       	call   801074e0 <setupkvm>
8010756b:	a3 a4 69 11 80       	mov    %eax,0x801169a4
80107570:	05 00 00 00 80       	add    $0x80000000,%eax
80107575:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107578:	c9                   	leave  
80107579:	c3                   	ret    
8010757a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107580 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107580:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107581:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107583:	89 e5                	mov    %esp,%ebp
80107585:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107588:	8b 55 0c             	mov    0xc(%ebp),%edx
8010758b:	8b 45 08             	mov    0x8(%ebp),%eax
8010758e:	e8 7d f8 ff ff       	call   80106e10 <walkpgdir>
  if(pte == 0)
80107593:	85 c0                	test   %eax,%eax
80107595:	74 05                	je     8010759c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107597:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010759a:	c9                   	leave  
8010759b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010759c:	83 ec 0c             	sub    $0xc,%esp
8010759f:	68 42 81 10 80       	push   $0x80108142
801075a4:	e8 c7 8d ff ff       	call   80100370 <panic>
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075b9:	e8 22 ff ff ff       	call   801074e0 <setupkvm>
801075be:	85 c0                	test   %eax,%eax
801075c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075c3:	0f 84 c5 00 00 00    	je     8010768e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075cc:	85 c9                	test   %ecx,%ecx
801075ce:	0f 84 9c 00 00 00    	je     80107670 <copyuvm+0xc0>
801075d4:	31 ff                	xor    %edi,%edi
801075d6:	eb 4a                	jmp    80107622 <copyuvm+0x72>
801075d8:	90                   	nop
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801075e0:	83 ec 04             	sub    $0x4,%esp
801075e3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801075e9:	68 00 10 00 00       	push   $0x1000
801075ee:	53                   	push   %ebx
801075ef:	50                   	push   %eax
801075f0:	e8 4b d5 ff ff       	call   80104b40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075f5:	58                   	pop    %eax
801075f6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075fc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107601:	5a                   	pop    %edx
80107602:	ff 75 e4             	pushl  -0x1c(%ebp)
80107605:	50                   	push   %eax
80107606:	89 fa                	mov    %edi,%edx
80107608:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010760b:	e8 80 f8 ff ff       	call   80106e90 <mappages>
80107610:	83 c4 10             	add    $0x10,%esp
80107613:	85 c0                	test   %eax,%eax
80107615:	78 69                	js     80107680 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107617:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010761d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107620:	76 4e                	jbe    80107670 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107622:	8b 45 08             	mov    0x8(%ebp),%eax
80107625:	31 c9                	xor    %ecx,%ecx
80107627:	89 fa                	mov    %edi,%edx
80107629:	e8 e2 f7 ff ff       	call   80106e10 <walkpgdir>
8010762e:	85 c0                	test   %eax,%eax
80107630:	74 6d                	je     8010769f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107632:	8b 00                	mov    (%eax),%eax
80107634:	a8 01                	test   $0x1,%al
80107636:	74 5a                	je     80107692 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107638:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010763a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010763f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107648:	e8 d3 b1 ff ff       	call   80102820 <kalloc>
8010764d:	85 c0                	test   %eax,%eax
8010764f:	89 c6                	mov    %eax,%esi
80107651:	75 8d                	jne    801075e0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107653:	83 ec 0c             	sub    $0xc,%esp
80107656:	ff 75 e0             	pushl  -0x20(%ebp)
80107659:	e8 02 fe ff ff       	call   80107460 <freevm>
  return 0;
8010765e:	83 c4 10             	add    $0x10,%esp
80107661:	31 c0                	xor    %eax,%eax
}
80107663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107666:	5b                   	pop    %ebx
80107667:	5e                   	pop    %esi
80107668:	5f                   	pop    %edi
80107669:	5d                   	pop    %ebp
8010766a:	c3                   	ret    
8010766b:	90                   	nop
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107673:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107676:	5b                   	pop    %ebx
80107677:	5e                   	pop    %esi
80107678:	5f                   	pop    %edi
80107679:	5d                   	pop    %ebp
8010767a:	c3                   	ret    
8010767b:	90                   	nop
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107680:	83 ec 0c             	sub    $0xc,%esp
80107683:	56                   	push   %esi
80107684:	e8 e7 af ff ff       	call   80102670 <kfree>
      goto bad;
80107689:	83 c4 10             	add    $0x10,%esp
8010768c:	eb c5                	jmp    80107653 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010768e:	31 c0                	xor    %eax,%eax
80107690:	eb d1                	jmp    80107663 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107692:	83 ec 0c             	sub    $0xc,%esp
80107695:	68 66 81 10 80       	push   $0x80108166
8010769a:	e8 d1 8c ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010769f:	83 ec 0c             	sub    $0xc,%esp
801076a2:	68 4c 81 10 80       	push   $0x8010814c
801076a7:	e8 c4 8c ff ff       	call   80100370 <panic>
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076b1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076b3:	89 e5                	mov    %esp,%ebp
801076b5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076bb:	8b 45 08             	mov    0x8(%ebp),%eax
801076be:	e8 4d f7 ff ff       	call   80106e10 <walkpgdir>
  if((*pte & PTE_P) == 0)
801076c3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801076c5:	89 c2                	mov    %eax,%edx
801076c7:	83 e2 05             	and    $0x5,%edx
801076ca:	83 fa 05             	cmp    $0x5,%edx
801076cd:	75 11                	jne    801076e0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801076cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801076d4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801076d5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801076da:	c3                   	ret    
801076db:	90                   	nop
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801076e0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801076e2:	c9                   	leave  
801076e3:	c3                   	ret    
801076e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801076f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	57                   	push   %edi
801076f4:	56                   	push   %esi
801076f5:	53                   	push   %ebx
801076f6:	83 ec 1c             	sub    $0x1c,%esp
801076f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801076fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107702:	85 db                	test   %ebx,%ebx
80107704:	75 40                	jne    80107746 <copyout+0x56>
80107706:	eb 70                	jmp    80107778 <copyout+0x88>
80107708:	90                   	nop
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107710:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107713:	89 f1                	mov    %esi,%ecx
80107715:	29 d1                	sub    %edx,%ecx
80107717:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010771d:	39 d9                	cmp    %ebx,%ecx
8010771f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107722:	29 f2                	sub    %esi,%edx
80107724:	83 ec 04             	sub    $0x4,%esp
80107727:	01 d0                	add    %edx,%eax
80107729:	51                   	push   %ecx
8010772a:	57                   	push   %edi
8010772b:	50                   	push   %eax
8010772c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010772f:	e8 0c d4 ff ff       	call   80104b40 <memmove>
    len -= n;
    buf += n;
80107734:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107737:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010773a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107740:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107742:	29 cb                	sub    %ecx,%ebx
80107744:	74 32                	je     80107778 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107746:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107748:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010774b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010774e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107754:	56                   	push   %esi
80107755:	ff 75 08             	pushl  0x8(%ebp)
80107758:	e8 53 ff ff ff       	call   801076b0 <uva2ka>
    if(pa0 == 0)
8010775d:	83 c4 10             	add    $0x10,%esp
80107760:	85 c0                	test   %eax,%eax
80107762:	75 ac                	jne    80107710 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107764:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010776c:	5b                   	pop    %ebx
8010776d:	5e                   	pop    %esi
8010776e:	5f                   	pop    %edi
8010776f:	5d                   	pop    %ebp
80107770:	c3                   	ret    
80107771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107778:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010777b:	31 c0                	xor    %eax,%eax
}
8010777d:	5b                   	pop    %ebx
8010777e:	5e                   	pop    %esi
8010777f:	5f                   	pop    %edi
80107780:	5d                   	pop    %ebp
80107781:	c3                   	ret    
