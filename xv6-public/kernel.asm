
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
8010002d:	b8 80 32 10 80       	mov    $0x80103280,%eax
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
8010004c:	68 e0 7a 10 80       	push   $0x80107ae0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 b5 4a 00 00       	call   80104b10 <initlock>

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
80100092:	68 e7 7a 10 80       	push   $0x80107ae7
80100097:	50                   	push   %eax
80100098:	e8 43 49 00 00       	call   801049e0 <initsleeplock>
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
801000e4:	e8 87 4b 00 00       	call   80104c70 <acquire>

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
80100162:	e8 b9 4b 00 00       	call   80104d20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 48 00 00       	call   80104a20 <acquiresleep>
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
8010017e:	e8 8d 23 00 00       	call   80102510 <iderw>
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
80100193:	68 ee 7a 10 80       	push   $0x80107aee
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
801001ae:	e8 0d 49 00 00       	call   80104ac0 <holdingsleep>
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
801001c4:	e9 47 23 00 00       	jmp    80102510 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 7a 10 80       	push   $0x80107aff
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
801001ef:	e8 cc 48 00 00       	call   80104ac0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 48 00 00       	call   80104a80 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 60 4a 00 00       	call   80104c70 <acquire>
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
8010025c:	e9 bf 4a 00 00       	jmp    80104d20 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 7b 10 80       	push   $0x80107b06
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
80100280:	e8 eb 18 00 00       	call   80101b70 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 df 49 00 00       	call   80104c70 <acquire>
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
801002bd:	e8 9e 43 00 00       	call   80104660 <sleep>

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
801002d2:	e8 29 39 00 00       	call   80103c00 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 35 4a 00 00       	call   80104d20 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 9d 17 00 00       	call   80101a90 <ilock>
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
80100346:	e8 d5 49 00 00       	call   80104d20 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 3d 17 00 00       	call   80101a90 <ilock>

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
80100389:	e8 82 27 00 00       	call   80102b10 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 0d 7b 10 80       	push   $0x80107b0d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 d7 84 10 80 	movl   $0x801084d7,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 73 47 00 00       	call   80104b30 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 21 7b 10 80       	push   $0x80107b21
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
8010041a:	e8 61 62 00 00       	call   80106680 <uartputc>
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
801004d3:	e8 a8 61 00 00       	call   80106680 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 9c 61 00 00       	call   80106680 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 90 61 00 00       	call   80106680 <uartputc>
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
80100514:	e8 07 49 00 00       	call   80104e20 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 42 48 00 00       	call   80104d70 <memset>
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
80100540:	68 25 7b 10 80       	push   $0x80107b25
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
801005b1:	0f b6 92 50 7b 10 80 	movzbl -0x7fef84b0(%edx),%edx
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
8010060f:	e8 5c 15 00 00       	call   80101b70 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 50 46 00 00       	call   80104c70 <acquire>
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
80100647:	e8 d4 46 00 00       	call   80104d20 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 14 00 00       	call   80101a90 <ilock>

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
8010070d:	e8 0e 46 00 00       	call   80104d20 <release>
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
80100788:	b8 38 7b 10 80       	mov    $0x80107b38,%eax
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
801007c8:	e8 a3 44 00 00       	call   80104c70 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 3f 7b 10 80       	push   $0x80107b3f
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
80100803:	e8 68 44 00 00       	call   80104c70 <acquire>
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
80100868:	e8 b3 44 00 00       	call   80104d20 <release>
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
801008f6:	e8 35 3f 00 00       	call   80104830 <wakeup>
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
80100977:	e9 a4 3f 00 00       	jmp    80104920 <procdump>
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
801009a6:	68 48 7b 10 80       	push   $0x80107b48
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 5b 41 00 00       	call   80104b10 <initlock>

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
801009d9:	e8 e2 1c 00 00       	call   801026c0 <ioapicenable>
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
801009fc:	e8 ff 31 00 00       	call   80103c00 <myproc>

  //cprintf("%s , %s \n",path,*argv);

  //for shard memory
  if(curproc->shared_memory_address==0) curproc->shared_memory_address = kalloc();
80100a01:	8b 88 98 00 00 00    	mov    0x98(%eax),%ecx
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a07:	89 c6                	mov    %eax,%esi

  //cprintf("%s , %s \n",path,*argv);

  //for shard memory
  if(curproc->shared_memory_address==0) curproc->shared_memory_address = kalloc();
80100a09:	85 c9                	test   %ecx,%ecx
80100a0b:	0f 84 6f 01 00 00    	je     80100b80 <exec+0x190>

  begin_op();
80100a11:	e8 5a 25 00 00       	call   80102f70 <begin_op>

  if((ip = namei(path)) == 0){
80100a16:	83 ec 0c             	sub    $0xc,%esp
80100a19:	ff 75 08             	pushl  0x8(%ebp)
80100a1c:	e8 bf 18 00 00       	call   801022e0 <namei>
80100a21:	83 c4 10             	add    $0x10,%esp
80100a24:	85 c0                	test   %eax,%eax
80100a26:	89 c3                	mov    %eax,%ebx
80100a28:	0f 84 c4 01 00 00    	je     80100bf2 <exec+0x202>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a2e:	83 ec 0c             	sub    $0xc,%esp
80100a31:	50                   	push   %eax
80100a32:	e8 59 10 00 00       	call   80101a90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a37:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a3d:	6a 34                	push   $0x34
80100a3f:	6a 00                	push   $0x0
80100a41:	50                   	push   %eax
80100a42:	53                   	push   %ebx
80100a43:	e8 28 13 00 00       	call   80101d70 <readi>
80100a48:	83 c4 20             	add    $0x20,%esp
80100a4b:	83 f8 34             	cmp    $0x34,%eax
80100a4e:	74 20                	je     80100a70 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a50:	83 ec 0c             	sub    $0xc,%esp
80100a53:	53                   	push   %ebx
80100a54:	e8 c7 12 00 00       	call   80101d20 <iunlockput>
    end_op();
80100a59:	e8 82 25 00 00       	call   80102fe0 <end_op>
80100a5e:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a69:	5b                   	pop    %ebx
80100a6a:	5e                   	pop    %esi
80100a6b:	5f                   	pop    %edi
80100a6c:	5d                   	pop    %ebp
80100a6d:	c3                   	ret    
80100a6e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a77:	45 4c 46 
80100a7a:	75 d4                	jne    80100a50 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a7c:	e8 af 6d 00 00       	call   80107830 <setupkvm>
80100a81:	85 c0                	test   %eax,%eax
80100a83:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a89:	74 c5                	je     80100a50 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a92:	00 
80100a93:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100a99:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100aa0:	00 00 00 
80100aa3:	0f 84 ed 00 00 00    	je     80100b96 <exec+0x1a6>
80100aa9:	31 c0                	xor    %eax,%eax
80100aab:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100ab1:	89 c6                	mov    %eax,%esi
80100ab3:	eb 18                	jmp    80100acd <exec+0xdd>
80100ab5:	8d 76 00             	lea    0x0(%esi),%esi
80100ab8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100abf:	83 c6 01             	add    $0x1,%esi
80100ac2:	83 c7 20             	add    $0x20,%edi
80100ac5:	39 f0                	cmp    %esi,%eax
80100ac7:	0f 8e c3 00 00 00    	jle    80100b90 <exec+0x1a0>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100acd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ad3:	6a 20                	push   $0x20
80100ad5:	57                   	push   %edi
80100ad6:	50                   	push   %eax
80100ad7:	53                   	push   %ebx
80100ad8:	e8 93 12 00 00       	call   80101d70 <readi>
80100add:	83 c4 10             	add    $0x10,%esp
80100ae0:	83 f8 20             	cmp    $0x20,%eax
80100ae3:	75 7b                	jne    80100b60 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ae5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aec:	75 ca                	jne    80100ab8 <exec+0xc8>
      continue;
    if(ph.memsz < ph.filesz)
80100aee:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100af4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100afa:	72 64                	jb     80100b60 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100afc:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b02:	72 5c                	jb     80100b60 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b04:	83 ec 04             	sub    $0x4,%esp
80100b07:	50                   	push   %eax
80100b08:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b0e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b14:	e8 67 6b 00 00       	call   80107680 <allocuvm>
80100b19:	83 c4 10             	add    $0x10,%esp
80100b1c:	85 c0                	test   %eax,%eax
80100b1e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b24:	74 3a                	je     80100b60 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b26:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b2c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b31:	75 2d                	jne    80100b60 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b33:	83 ec 0c             	sub    $0xc,%esp
80100b36:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b3c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b42:	53                   	push   %ebx
80100b43:	50                   	push   %eax
80100b44:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b4a:	e8 71 6a 00 00       	call   801075c0 <loaduvm>
80100b4f:	83 c4 20             	add    $0x20,%esp
80100b52:	85 c0                	test   %eax,%eax
80100b54:	0f 89 5e ff ff ff    	jns    80100ab8 <exec+0xc8>
80100b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b60:	83 ec 0c             	sub    $0xc,%esp
80100b63:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b69:	e8 42 6c 00 00       	call   801077b0 <freevm>
80100b6e:	83 c4 10             	add    $0x10,%esp
80100b71:	e9 da fe ff ff       	jmp    80100a50 <exec+0x60>
80100b76:	8d 76 00             	lea    0x0(%esi),%esi
80100b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct proc *curproc = myproc();

  //cprintf("%s , %s \n",path,*argv);

  //for shard memory
  if(curproc->shared_memory_address==0) curproc->shared_memory_address = kalloc();
80100b80:	e8 2b 1d 00 00       	call   801028b0 <kalloc>
80100b85:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
80100b8b:	e9 81 fe ff ff       	jmp    80100a11 <exec+0x21>
80100b90:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b96:	83 ec 0c             	sub    $0xc,%esp
80100b99:	53                   	push   %ebx
80100b9a:	e8 81 11 00 00       	call   80101d20 <iunlockput>
  end_op();
80100b9f:	e8 3c 24 00 00       	call   80102fe0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100ba4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100baa:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100bad:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bb7:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100bbd:	52                   	push   %edx
80100bbe:	50                   	push   %eax
80100bbf:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bc5:	e8 b6 6a 00 00       	call   80107680 <allocuvm>
80100bca:	83 c4 10             	add    $0x10,%esp
80100bcd:	85 c0                	test   %eax,%eax
80100bcf:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bd5:	75 3a                	jne    80100c11 <exec+0x221>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bd7:	83 ec 0c             	sub    $0xc,%esp
80100bda:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100be0:	e8 cb 6b 00 00       	call   801077b0 <freevm>
80100be5:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 74 fe ff ff       	jmp    80100a66 <exec+0x76>
  if(curproc->shared_memory_address==0) curproc->shared_memory_address = kalloc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bf2:	e8 e9 23 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100bf7:	83 ec 0c             	sub    $0xc,%esp
80100bfa:	68 61 7b 10 80       	push   $0x80107b61
80100bff:	e8 5c fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c04:	83 c4 10             	add    $0x10,%esp
80100c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c0c:	e9 55 fe ff ff       	jmp    80100a66 <exec+0x76>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c11:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100c17:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c1a:	31 ff                	xor    %edi,%edi
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c1c:	89 d8                	mov    %ebx,%eax
80100c1e:	2d 00 20 00 00       	sub    $0x2000,%eax
80100c23:	50                   	push   %eax
80100c24:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c2a:	e8 a1 6c 00 00       	call   801078d0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c32:	83 c4 10             	add    $0x10,%esp
80100c35:	8b 00                	mov    (%eax),%eax
80100c37:	85 c0                	test   %eax,%eax
80100c39:	0f 84 54 01 00 00    	je     80100d93 <exec+0x3a3>
80100c3f:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c45:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c4b:	eb 08                	jmp    80100c55 <exec+0x265>
80100c4d:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%s \n",argv[argc]);
    if(argc >= MAXARG)
80100c50:	83 ff 20             	cmp    $0x20,%edi
80100c53:	74 82                	je     80100bd7 <exec+0x1e7>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c55:	83 ec 0c             	sub    $0xc,%esp
80100c58:	50                   	push   %eax
80100c59:	e8 52 43 00 00       	call   80104fb0 <strlen>
80100c5e:	f7 d0                	not    %eax
80100c60:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c62:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c65:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  //cprintf("%s \n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c66:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c69:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c6c:	e8 3f 43 00 00       	call   80104fb0 <strlen>
80100c71:	83 c0 01             	add    $0x1,%eax
80100c74:	50                   	push   %eax
80100c75:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c78:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c7b:	53                   	push   %ebx
80100c7c:	56                   	push   %esi
80100c7d:	e8 be 6d 00 00       	call   80107a40 <copyout>
80100c82:	83 c4 20             	add    $0x20,%esp
80100c85:	85 c0                	test   %eax,%eax
80100c87:	0f 88 4a ff ff ff    	js     80100bd7 <exec+0x1e7>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c90:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c97:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c9a:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ca0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca3:	85 c0                	test   %eax,%eax
80100ca5:	75 a9                	jne    80100c50 <exec+0x260>
80100ca7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cad:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cb4:	89 da                	mov    %ebx,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100cb6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cbd:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100cc1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cc8:	ff ff ff 
  ustack[1] = argc;
80100ccb:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cd1:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100cd3:	83 c0 0c             	add    $0xc,%eax
80100cd6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cd8:	50                   	push   %eax
80100cd9:	51                   	push   %ecx
80100cda:	53                   	push   %ebx
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ce1:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ce7:	e8 54 6d 00 00       	call   80107a40 <copyout>
80100cec:	83 c4 10             	add    $0x10,%esp
80100cef:	85 c0                	test   %eax,%eax
80100cf1:	0f 88 e0 fe ff ff    	js     80100bd7 <exec+0x1e7>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cfa:	0f b6 10             	movzbl (%eax),%edx
80100cfd:	84 d2                	test   %dl,%dl
80100cff:	74 19                	je     80100d1a <exec+0x32a>
80100d01:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d04:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100d07:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d0a:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100d0d:	0f 44 c8             	cmove  %eax,%ecx
80100d10:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d13:	84 d2                	test   %dl,%dl
80100d15:	75 f0                	jne    80100d07 <exec+0x317>
80100d17:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d1a:	50                   	push   %eax
80100d1b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d1e:	6a 10                	push   $0x10
80100d20:	ff 75 08             	pushl  0x8(%ebp)
80100d23:	50                   	push   %eax
80100d24:	e8 47 42 00 00       	call   80104f70 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d29:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d2c:	8b 56 18             	mov    0x18(%esi),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d2f:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80100d35:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d3b:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100d3e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d44:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100d46:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d4c:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100d4f:	8b 56 18             	mov    0x18(%esi),%edx
80100d52:	89 5a 44             	mov    %ebx,0x44(%edx)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
80100d55:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80100d5c:	00 00 00 
  curproc->limit_sz = 0;
80100d5f:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
80100d66:	00 00 00 
  curproc->custom_stack_size = 1;
80100d69:	c7 86 8c 00 00 00 01 	movl   $0x1,0x8c(%esi)
80100d70:	00 00 00 


  switchuvm(curproc);
80100d73:	89 34 24             	mov    %esi,(%esp)
80100d76:	e8 b5 66 00 00       	call   80107430 <switchuvm>
  freevm(oldpgdir);
80100d7b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d81:	89 04 24             	mov    %eax,(%esp)
80100d84:	e8 27 6a 00 00       	call   801077b0 <freevm>
  return 0;
80100d89:	83 c4 10             	add    $0x10,%esp
80100d8c:	31 c0                	xor    %eax,%eax
80100d8e:	e9 d3 fc ff ff       	jmp    80100a66 <exec+0x76>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d93:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100d99:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d9f:	e9 09 ff ff ff       	jmp    80100cad <exec+0x2bd>
80100da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100db0 <exec2>:
}


int
exec2(char *path, char **argv, int stacksize)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	57                   	push   %edi
80100db4:	56                   	push   %esi
80100db5:	53                   	push   %ebx
80100db6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100dbc:	e8 3f 2e 00 00       	call   80103c00 <myproc>

  //for shard memory
  if(curproc->shared_memory_address==0)curproc->shared_memory_address = kalloc();
80100dc1:	8b 98 98 00 00 00    	mov    0x98(%eax),%ebx
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100dc7:	89 c6                	mov    %eax,%esi

  //for shard memory
  if(curproc->shared_memory_address==0)curproc->shared_memory_address = kalloc();
80100dc9:	85 db                	test   %ebx,%ebx
80100dcb:	0f 84 ef 01 00 00    	je     80100fc0 <exec2+0x210>

  //cprintf("%s , %s, %d\n",path,*argv,stacksize);
  //cprintf("exec : %d\n",stacksize);

  //admin mode가 아닐때
  if (curproc->admin_mode==0){
80100dd1:	8b 8e 88 00 00 00    	mov    0x88(%esi),%ecx
80100dd7:	85 c9                	test   %ecx,%ecx
80100dd9:	0f 84 c3 00 00 00    	je     80100ea2 <exec2+0xf2>
    return -1;
  }

  begin_op();
80100ddf:	e8 8c 21 00 00       	call   80102f70 <begin_op>

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
80100de4:	83 ec 0c             	sub    $0xc,%esp
80100de7:	ff 75 08             	pushl  0x8(%ebp)
80100dea:	e8 f1 14 00 00       	call   801022e0 <namei>
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	85 c0                	test   %eax,%eax
80100df4:	89 c3                	mov    %eax,%ebx
80100df6:	0f 84 d4 01 00 00    	je     80100fd0 <exec2+0x220>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	50                   	push   %eax
80100e00:	e8 8b 0c 00 00       	call   80101a90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100e05:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100e0b:	6a 34                	push   $0x34
80100e0d:	6a 00                	push   $0x0
80100e0f:	50                   	push   %eax
80100e10:	53                   	push   %ebx
80100e11:	e8 5a 0f 00 00       	call   80101d70 <readi>
80100e16:	83 c4 20             	add    $0x20,%esp
80100e19:	83 f8 34             	cmp    $0x34,%eax
80100e1c:	0f 84 8e 00 00 00    	je     80100eb0 <exec2+0x100>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100e22:	83 ec 0c             	sub    $0xc,%esp
80100e25:	53                   	push   %ebx
80100e26:	e8 f5 0e 00 00       	call   80101d20 <iunlockput>
    end_op();
80100e2b:	e8 b0 21 00 00       	call   80102fe0 <end_op>
80100e30:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e3b:	5b                   	pop    %ebx
80100e3c:	5e                   	pop    %esi
80100e3d:	5f                   	pop    %edi
80100e3e:	5d                   	pop    %ebp
80100e3f:	c3                   	ret    
80100e40:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100e46:	83 ec 0c             	sub    $0xc,%esp
80100e49:	53                   	push   %ebx
80100e4a:	e8 d1 0e 00 00       	call   80101d20 <iunlockput>
  end_op();
80100e4f:	e8 8c 21 00 00       	call   80102fe0 <end_op>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e54:	8b 4d 10             	mov    0x10(%ebp),%ecx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
80100e57:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e5d:	83 c4 0c             	add    $0xc,%esp
80100e60:	8d 59 01             	lea    0x1(%ecx),%ebx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
80100e63:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e6d:	c1 e3 0c             	shl    $0xc,%ebx
80100e70:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100e73:	52                   	push   %edx
80100e74:	50                   	push   %eax
80100e75:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e7b:	e8 00 68 00 00       	call   80107680 <allocuvm>
80100e80:	83 c4 10             	add    $0x10,%esp
80100e83:	85 c0                	test   %eax,%eax
80100e85:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e8b:	0f 85 59 01 00 00    	jne    80100fea <exec2+0x23a>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100e91:	83 ec 0c             	sub    $0xc,%esp
80100e94:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e9a:	e8 11 69 00 00       	call   801077b0 <freevm>
80100e9f:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100eaa:	5b                   	pop    %ebx
80100eab:	5e                   	pop    %esi
80100eac:	5f                   	pop    %edi
80100ead:	5d                   	pop    %ebp
80100eae:	c3                   	ret    
80100eaf:	90                   	nop
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100eb0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100eb7:	45 4c 46 
80100eba:	0f 85 62 ff ff ff    	jne    80100e22 <exec2+0x72>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100ec0:	e8 6b 69 00 00       	call   80107830 <setupkvm>
80100ec5:	85 c0                	test   %eax,%eax
80100ec7:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ecd:	0f 84 4f ff ff ff    	je     80100e22 <exec2+0x72>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ed3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100eda:	00 
80100edb:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100ee1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ee8:	00 00 00 
80100eeb:	0f 84 55 ff ff ff    	je     80100e46 <exec2+0x96>
80100ef1:	31 c0                	xor    %eax,%eax
80100ef3:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100ef9:	89 c6                	mov    %eax,%esi
80100efb:	eb 18                	jmp    80100f15 <exec2+0x165>
80100efd:	8d 76 00             	lea    0x0(%esi),%esi
80100f00:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f07:	83 c6 01             	add    $0x1,%esi
80100f0a:	83 c7 20             	add    $0x20,%edi
80100f0d:	39 f0                	cmp    %esi,%eax
80100f0f:	0f 8e 2b ff ff ff    	jle    80100e40 <exec2+0x90>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100f15:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100f1b:	6a 20                	push   $0x20
80100f1d:	57                   	push   %edi
80100f1e:	50                   	push   %eax
80100f1f:	53                   	push   %ebx
80100f20:	e8 4b 0e 00 00       	call   80101d70 <readi>
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 f8 20             	cmp    $0x20,%eax
80100f2b:	75 7b                	jne    80100fa8 <exec2+0x1f8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100f2d:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100f34:	75 ca                	jne    80100f00 <exec2+0x150>
      continue;
    if(ph.memsz < ph.filesz)
80100f36:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100f3c:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100f42:	72 64                	jb     80100fa8 <exec2+0x1f8>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100f44:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100f4a:	72 5c                	jb     80100fa8 <exec2+0x1f8>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100f4c:	83 ec 04             	sub    $0x4,%esp
80100f4f:	50                   	push   %eax
80100f50:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f56:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f5c:	e8 1f 67 00 00       	call   80107680 <allocuvm>
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	85 c0                	test   %eax,%eax
80100f66:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f6c:	74 3a                	je     80100fa8 <exec2+0x1f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100f6e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f74:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f79:	75 2d                	jne    80100fa8 <exec2+0x1f8>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f7b:	83 ec 0c             	sub    $0xc,%esp
80100f7e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100f84:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100f8a:	53                   	push   %ebx
80100f8b:	50                   	push   %eax
80100f8c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f92:	e8 29 66 00 00       	call   801075c0 <loaduvm>
80100f97:	83 c4 20             	add    $0x20,%esp
80100f9a:	85 c0                	test   %eax,%eax
80100f9c:	0f 89 5e ff ff ff    	jns    80100f00 <exec2+0x150>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fb1:	e8 fa 67 00 00       	call   801077b0 <freevm>
80100fb6:	83 c4 10             	add    $0x10,%esp
80100fb9:	e9 64 fe ff ff       	jmp    80100e22 <exec2+0x72>
80100fbe:	66 90                	xchg   %ax,%ax
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();

  //for shard memory
  if(curproc->shared_memory_address==0)curproc->shared_memory_address = kalloc();
80100fc0:	e8 eb 18 00 00       	call   801028b0 <kalloc>
80100fc5:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
80100fcb:	e9 01 fe ff ff       	jmp    80100dd1 <exec2+0x21>
  begin_op();

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
80100fd0:	e8 0b 20 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100fd5:	83 ec 0c             	sub    $0xc,%esp
80100fd8:	68 61 7b 10 80       	push   $0x80107b61
80100fdd:	e8 7e f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100fe2:	83 c4 10             	add    $0x10,%esp
80100fe5:	e9 b8 fe ff ff       	jmp    80100ea2 <exec2+0xf2>

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
80100fea:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100ff0:	83 ec 08             	sub    $0x8,%esp
80100ff3:	89 f8                	mov    %edi,%eax
80100ff5:	29 d8                	sub    %ebx,%eax
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ff7:	89 fb                	mov    %edi,%ebx
80100ff9:	31 ff                	xor    %edi,%edi

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
80100ffb:	50                   	push   %eax
80100ffc:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101002:	e8 c9 68 00 00       	call   801078d0 <clearpteu>
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010100a:	83 c4 10             	add    $0x10,%esp
8010100d:	8b 00                	mov    (%eax),%eax
8010100f:	85 c0                	test   %eax,%eax
80101011:	0f 84 58 01 00 00    	je     8010116f <exec2+0x3bf>
80101017:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
8010101d:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101023:	eb 0c                	jmp    80101031 <exec2+0x281>
80101025:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%s\n",argv[argc]);
    if(argc >= MAXARG)
80101028:	83 ff 20             	cmp    $0x20,%edi
8010102b:	0f 84 60 fe ff ff    	je     80100e91 <exec2+0xe1>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101031:	83 ec 0c             	sub    $0xc,%esp
80101034:	50                   	push   %eax
80101035:	e8 76 3f 00 00       	call   80104fb0 <strlen>
8010103a:	f7 d0                	not    %eax
8010103c:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010103e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101041:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  //cprintf("%s\n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101042:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101045:	ff 34 b8             	pushl  (%eax,%edi,4)
80101048:	e8 63 3f 00 00       	call   80104fb0 <strlen>
8010104d:	83 c0 01             	add    $0x1,%eax
80101050:	50                   	push   %eax
80101051:	8b 45 0c             	mov    0xc(%ebp),%eax
80101054:	ff 34 b8             	pushl  (%eax,%edi,4)
80101057:	53                   	push   %ebx
80101058:	56                   	push   %esi
80101059:	e8 e2 69 00 00       	call   80107a40 <copyout>
8010105e:	83 c4 20             	add    $0x20,%esp
80101061:	85 c0                	test   %eax,%eax
80101063:	0f 88 28 fe ff ff    	js     80100e91 <exec2+0xe1>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101069:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
8010106c:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101073:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80101076:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010107c:	8b 04 b8             	mov    (%eax,%edi,4),%eax
8010107f:	85 c0                	test   %eax,%eax
80101081:	75 a5                	jne    80101028 <exec2+0x278>
80101083:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101089:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101090:	89 da                	mov    %ebx,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80101092:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101099:	00 00 00 00 

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
8010109d:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801010a4:	ff ff ff 
  ustack[1] = argc;
801010a7:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010ad:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
801010af:	83 c0 0c             	add    $0xc,%eax
801010b2:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010b4:	50                   	push   %eax
801010b5:	51                   	push   %ecx
801010b6:	53                   	push   %ebx
801010b7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010bd:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010c3:	e8 78 69 00 00       	call   80107a40 <copyout>
801010c8:	83 c4 10             	add    $0x10,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	0f 88 be fd ff ff    	js     80100e91 <exec2+0xe1>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010d3:	8b 45 08             	mov    0x8(%ebp),%eax
801010d6:	0f b6 10             	movzbl (%eax),%edx
801010d9:	84 d2                	test   %dl,%dl
801010db:	74 1a                	je     801010f7 <exec2+0x347>
801010dd:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
801010e0:	80 fa 2f             	cmp    $0x2f,%dl
801010e3:	89 c2                	mov    %eax,%edx
801010e5:	0f 45 55 08          	cmovne 0x8(%ebp),%edx
801010e9:	83 c0 01             	add    $0x1,%eax
801010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010ef:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
801010f3:	84 d2                	test   %dl,%dl
801010f5:	75 e9                	jne    801010e0 <exec2+0x330>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010f7:	50                   	push   %eax
801010f8:	8d 46 6c             	lea    0x6c(%esi),%eax
801010fb:	6a 10                	push   $0x10
801010fd:	ff 75 08             	pushl  0x8(%ebp)
80101100:	50                   	push   %eax
80101101:	e8 6a 3e 00 00       	call   80104f70 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80101106:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80101109:	8b 56 18             	mov    0x18(%esi),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
8010110c:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80101112:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80101118:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
8010111b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80101121:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80101123:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  curproc->tf->esp = sp;

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
  curproc->limit_sz = 0;
  curproc->custom_stack_size = stacksize;
80101129:	8b 45 10             	mov    0x10(%ebp),%eax

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
8010112c:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
8010112f:	8b 56 18             	mov    0x18(%esi),%edx
80101132:	89 5a 44             	mov    %ebx,0x44(%edx)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
  curproc->limit_sz = 0;
  curproc->custom_stack_size = stacksize;
80101135:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
8010113b:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101142:	00 00 00 
  curproc->limit_sz = 0;
80101145:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
8010114c:	00 00 00 
  curproc->custom_stack_size = stacksize;

  //cprintf("initailizing done\n");

  switchuvm(curproc);
8010114f:	89 34 24             	mov    %esi,(%esp)
80101152:	e8 d9 62 00 00       	call   80107430 <switchuvm>
  freevm(oldpgdir);
80101157:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
8010115d:	89 04 24             	mov    %eax,(%esp)
80101160:	e8 4b 66 00 00       	call   801077b0 <freevm>
  return 0;
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	31 c0                	xor    %eax,%eax
8010116a:	e9 c9 fc ff ff       	jmp    80100e38 <exec2+0x88>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010116f:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80101175:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
8010117b:	e9 09 ff ff ff       	jmp    80101089 <exec2+0x2d9>

80101180 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101186:	68 6d 7b 10 80       	push   $0x80107b6d
8010118b:	68 c0 0f 11 80       	push   $0x80110fc0
80101190:	e8 7b 39 00 00       	call   80104b10 <initlock>
}
80101195:	83 c4 10             	add    $0x10,%esp
80101198:	c9                   	leave  
80101199:	c3                   	ret    
8010119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011a0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011a4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
801011a9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
801011ac:	68 c0 0f 11 80       	push   $0x80110fc0
801011b1:	e8 ba 3a 00 00       	call   80104c70 <acquire>
801011b6:	83 c4 10             	add    $0x10,%esp
801011b9:	eb 10                	jmp    801011cb <filealloc+0x2b>
801011bb:	90                   	nop
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011c0:	83 c3 18             	add    $0x18,%ebx
801011c3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
801011c9:	74 25                	je     801011f0 <filealloc+0x50>
    if(f->ref == 0){
801011cb:	8b 43 04             	mov    0x4(%ebx),%eax
801011ce:	85 c0                	test   %eax,%eax
801011d0:	75 ee                	jne    801011c0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801011d2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
801011d5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801011dc:	68 c0 0f 11 80       	push   $0x80110fc0
801011e1:	e8 3a 3b 00 00       	call   80104d20 <release>
      return f;
801011e6:	89 d8                	mov    %ebx,%eax
801011e8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
801011eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011ee:	c9                   	leave  
801011ef:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
801011f0:	83 ec 0c             	sub    $0xc,%esp
801011f3:	68 c0 0f 11 80       	push   $0x80110fc0
801011f8:	e8 23 3b 00 00       	call   80104d20 <release>
  return 0;
801011fd:	83 c4 10             	add    $0x10,%esp
80101200:	31 c0                	xor    %eax,%eax
}
80101202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101205:	c9                   	leave  
80101206:	c3                   	ret    
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	53                   	push   %ebx
80101214:	83 ec 10             	sub    $0x10,%esp
80101217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010121a:	68 c0 0f 11 80       	push   $0x80110fc0
8010121f:	e8 4c 3a 00 00       	call   80104c70 <acquire>
  if(f->ref < 1)
80101224:	8b 43 04             	mov    0x4(%ebx),%eax
80101227:	83 c4 10             	add    $0x10,%esp
8010122a:	85 c0                	test   %eax,%eax
8010122c:	7e 1a                	jle    80101248 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010122e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101231:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80101234:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101237:	68 c0 0f 11 80       	push   $0x80110fc0
8010123c:	e8 df 3a 00 00       	call   80104d20 <release>
  return f;
}
80101241:	89 d8                	mov    %ebx,%eax
80101243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101246:	c9                   	leave  
80101247:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80101248:	83 ec 0c             	sub    $0xc,%esp
8010124b:	68 74 7b 10 80       	push   $0x80107b74
80101250:	e8 1b f1 ff ff       	call   80100370 <panic>
80101255:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 28             	sub    $0x28,%esp
80101269:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
8010126c:	68 c0 0f 11 80       	push   $0x80110fc0
80101271:	e8 fa 39 00 00       	call   80104c70 <acquire>
  if(f->ref < 1)
80101276:	8b 47 04             	mov    0x4(%edi),%eax
80101279:	83 c4 10             	add    $0x10,%esp
8010127c:	85 c0                	test   %eax,%eax
8010127e:	0f 8e 9b 00 00 00    	jle    8010131f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101284:	83 e8 01             	sub    $0x1,%eax
80101287:	85 c0                	test   %eax,%eax
80101289:	89 47 04             	mov    %eax,0x4(%edi)
8010128c:	74 1a                	je     801012a8 <fileclose+0x48>
    release(&ftable.lock);
8010128e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101295:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101298:	5b                   	pop    %ebx
80101299:	5e                   	pop    %esi
8010129a:	5f                   	pop    %edi
8010129b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
8010129c:	e9 7f 3a 00 00       	jmp    80104d20 <release>
801012a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
801012a8:	0f b6 47 09          	movzbl 0x9(%edi),%eax
801012ac:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012ae:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012b1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
801012b4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801012bd:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012c0:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012c8:	e8 53 3a 00 00       	call   80104d20 <release>

  if(ff.type == FD_PIPE)
801012cd:	83 c4 10             	add    $0x10,%esp
801012d0:	83 fb 01             	cmp    $0x1,%ebx
801012d3:	74 13                	je     801012e8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012d5:	83 fb 02             	cmp    $0x2,%ebx
801012d8:	74 26                	je     80101300 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
801012e8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012ec:	83 ec 08             	sub    $0x8,%esp
801012ef:	53                   	push   %ebx
801012f0:	56                   	push   %esi
801012f1:	e8 1a 24 00 00       	call   80103710 <pipeclose>
801012f6:	83 c4 10             	add    $0x10,%esp
801012f9:	eb df                	jmp    801012da <fileclose+0x7a>
801012fb:	90                   	nop
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101300:	e8 6b 1c 00 00       	call   80102f70 <begin_op>
    iput(ff.ip);
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	ff 75 e0             	pushl  -0x20(%ebp)
8010130b:	e8 b0 08 00 00       	call   80101bc0 <iput>
    end_op();
80101310:	83 c4 10             	add    $0x10,%esp
  }
}
80101313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101316:	5b                   	pop    %ebx
80101317:	5e                   	pop    %esi
80101318:	5f                   	pop    %edi
80101319:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
8010131a:	e9 c1 1c 00 00       	jmp    80102fe0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010131f:	83 ec 0c             	sub    $0xc,%esp
80101322:	68 7c 7b 10 80       	push   $0x80107b7c
80101327:	e8 44 f0 ff ff       	call   80100370 <panic>
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101330 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	53                   	push   %ebx
80101334:	83 ec 04             	sub    $0x4,%esp
80101337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010133a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010133d:	75 31                	jne    80101370 <filestat+0x40>
    ilock(f->ip);
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	ff 73 10             	pushl  0x10(%ebx)
80101345:	e8 46 07 00 00       	call   80101a90 <ilock>
    stati(f->ip, st);
8010134a:	58                   	pop    %eax
8010134b:	5a                   	pop    %edx
8010134c:	ff 75 0c             	pushl  0xc(%ebp)
8010134f:	ff 73 10             	pushl  0x10(%ebx)
80101352:	e8 e9 09 00 00       	call   80101d40 <stati>
    iunlock(f->ip);
80101357:	59                   	pop    %ecx
80101358:	ff 73 10             	pushl  0x10(%ebx)
8010135b:	e8 10 08 00 00       	call   80101b70 <iunlock>
    return 0;
80101360:	83 c4 10             	add    $0x10,%esp
80101363:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101368:	c9                   	leave  
80101369:	c3                   	ret    
8010136a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80101370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101378:	c9                   	leave  
80101379:	c3                   	ret    
8010137a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101380 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010138c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010138f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101392:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101396:	74 60                	je     801013f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101398:	8b 03                	mov    (%ebx),%eax
8010139a:	83 f8 01             	cmp    $0x1,%eax
8010139d:	74 41                	je     801013e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010139f:	83 f8 02             	cmp    $0x2,%eax
801013a2:	75 5b                	jne    801013ff <fileread+0x7f>
    ilock(f->ip);
801013a4:	83 ec 0c             	sub    $0xc,%esp
801013a7:	ff 73 10             	pushl  0x10(%ebx)
801013aa:	e8 e1 06 00 00       	call   80101a90 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013af:	57                   	push   %edi
801013b0:	ff 73 14             	pushl  0x14(%ebx)
801013b3:	56                   	push   %esi
801013b4:	ff 73 10             	pushl  0x10(%ebx)
801013b7:	e8 b4 09 00 00       	call   80101d70 <readi>
801013bc:	83 c4 20             	add    $0x20,%esp
801013bf:	85 c0                	test   %eax,%eax
801013c1:	89 c6                	mov    %eax,%esi
801013c3:	7e 03                	jle    801013c8 <fileread+0x48>
      f->off += r;
801013c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013c8:	83 ec 0c             	sub    $0xc,%esp
801013cb:	ff 73 10             	pushl  0x10(%ebx)
801013ce:	e8 9d 07 00 00       	call   80101b70 <iunlock>
    return r;
801013d3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013d6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
801013d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013db:	5b                   	pop    %ebx
801013dc:	5e                   	pop    %esi
801013dd:	5f                   	pop    %edi
801013de:	5d                   	pop    %ebp
801013df:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
801013e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801013e3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
801013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e9:	5b                   	pop    %ebx
801013ea:	5e                   	pop    %esi
801013eb:	5f                   	pop    %edi
801013ec:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
801013ed:	e9 be 24 00 00       	jmp    801038b0 <piperead>
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
801013f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013fd:	eb d9                	jmp    801013d8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	68 86 7b 10 80       	push   $0x80107b86
80101407:	e8 64 ef ff ff       	call   80100370 <panic>
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101410 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	83 ec 1c             	sub    $0x1c,%esp
80101419:	8b 75 08             	mov    0x8(%ebp),%esi
8010141c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010141f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101423:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101426:	8b 45 10             	mov    0x10(%ebp),%eax
80101429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010142c:	0f 84 aa 00 00 00    	je     801014dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101432:	8b 06                	mov    (%esi),%eax
80101434:	83 f8 01             	cmp    $0x1,%eax
80101437:	0f 84 c2 00 00 00    	je     801014ff <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010143d:	83 f8 02             	cmp    $0x2,%eax
80101440:	0f 85 d8 00 00 00    	jne    8010151e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101449:	31 ff                	xor    %edi,%edi
8010144b:	85 c0                	test   %eax,%eax
8010144d:	7f 34                	jg     80101483 <filewrite+0x73>
8010144f:	e9 9c 00 00 00       	jmp    801014f0 <filewrite+0xe0>
80101454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101458:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010145b:	83 ec 0c             	sub    $0xc,%esp
8010145e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101461:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101464:	e8 07 07 00 00       	call   80101b70 <iunlock>
      end_op();
80101469:	e8 72 1b 00 00       	call   80102fe0 <end_op>
8010146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101471:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101474:	39 d8                	cmp    %ebx,%eax
80101476:	0f 85 95 00 00 00    	jne    80101511 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010147c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010147e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101481:	7e 6d                	jle    801014f0 <filewrite+0xe0>
      int n1 = n - i;
80101483:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101486:	b8 00 06 00 00       	mov    $0x600,%eax
8010148b:	29 fb                	sub    %edi,%ebx
8010148d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101493:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101496:	e8 d5 1a 00 00       	call   80102f70 <begin_op>
      ilock(f->ip);
8010149b:	83 ec 0c             	sub    $0xc,%esp
8010149e:	ff 76 10             	pushl  0x10(%esi)
801014a1:	e8 ea 05 00 00       	call   80101a90 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014a9:	53                   	push   %ebx
801014aa:	ff 76 14             	pushl  0x14(%esi)
801014ad:	01 f8                	add    %edi,%eax
801014af:	50                   	push   %eax
801014b0:	ff 76 10             	pushl  0x10(%esi)
801014b3:	e8 b8 09 00 00       	call   80101e70 <writei>
801014b8:	83 c4 20             	add    $0x20,%esp
801014bb:	85 c0                	test   %eax,%eax
801014bd:	7f 99                	jg     80101458 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801014bf:	83 ec 0c             	sub    $0xc,%esp
801014c2:	ff 76 10             	pushl  0x10(%esi)
801014c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014c8:	e8 a3 06 00 00       	call   80101b70 <iunlock>
      end_op();
801014cd:	e8 0e 1b 00 00       	call   80102fe0 <end_op>

      if(r < 0)
801014d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	85 c0                	test   %eax,%eax
801014da:	74 98                	je     80101474 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801014dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801014e4:	5b                   	pop    %ebx
801014e5:	5e                   	pop    %esi
801014e6:	5f                   	pop    %edi
801014e7:	5d                   	pop    %ebp
801014e8:	c3                   	ret    
801014e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014f0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801014f3:	75 e7                	jne    801014dc <filewrite+0xcc>
  }
  panic("filewrite");
}
801014f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f8:	89 f8                	mov    %edi,%eax
801014fa:	5b                   	pop    %ebx
801014fb:	5e                   	pop    %esi
801014fc:	5f                   	pop    %edi
801014fd:	5d                   	pop    %ebp
801014fe:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801014ff:	8b 46 0c             	mov    0xc(%esi),%eax
80101502:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101508:	5b                   	pop    %ebx
80101509:	5e                   	pop    %esi
8010150a:	5f                   	pop    %edi
8010150b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010150c:	e9 9f 22 00 00       	jmp    801037b0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101511:	83 ec 0c             	sub    $0xc,%esp
80101514:	68 8f 7b 10 80       	push   $0x80107b8f
80101519:	e8 52 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010151e:	83 ec 0c             	sub    $0xc,%esp
80101521:	68 95 7b 10 80       	push   $0x80107b95
80101526:	e8 45 ee ff ff       	call   80100370 <panic>
8010152b:	66 90                	xchg   %ax,%ax
8010152d:	66 90                	xchg   %ax,%ax
8010152f:	90                   	nop

80101530 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101537:	c1 ea 0c             	shr    $0xc,%edx
8010153a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	52                   	push   %edx
80101544:	50                   	push   %eax
80101545:	e8 86 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010154a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010154c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101552:	ba 01 00 00 00       	mov    $0x1,%edx
80101557:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010155a:	c1 fb 03             	sar    $0x3,%ebx
8010155d:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101560:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101562:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101567:	85 d1                	test   %edx,%ecx
80101569:	74 27                	je     80101592 <bfree+0x62>
8010156b:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010156d:	f7 d2                	not    %edx
8010156f:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101571:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101574:	21 d0                	and    %edx,%eax
80101576:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010157a:	56                   	push   %esi
8010157b:	e8 d0 1b 00 00       	call   80103150 <log_write>
  brelse(bp);
80101580:	89 34 24             	mov    %esi,(%esp)
80101583:	e8 58 ec ff ff       	call   801001e0 <brelse>
}
80101588:	83 c4 10             	add    $0x10,%esp
8010158b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010158e:	5b                   	pop    %ebx
8010158f:	5e                   	pop    %esi
80101590:	5d                   	pop    %ebp
80101591:	c3                   	ret    

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101592:	83 ec 0c             	sub    $0xc,%esp
80101595:	68 9f 7b 10 80       	push   $0x80107b9f
8010159a:	e8 d1 ed ff ff       	call   80100370 <panic>
8010159f:	90                   	nop

801015a0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015a9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801015af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015b2:	85 c9                	test   %ecx,%ecx
801015b4:	0f 84 85 00 00 00    	je     8010163f <balloc+0x9f>
801015ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801015c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015c4:	83 ec 08             	sub    $0x8,%esp
801015c7:	89 f0                	mov    %esi,%eax
801015c9:	c1 f8 0c             	sar    $0xc,%eax
801015cc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801015d2:	50                   	push   %eax
801015d3:	ff 75 d8             	pushl  -0x28(%ebp)
801015d6:	e8 f5 ea ff ff       	call   801000d0 <bread>
801015db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801015de:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801015e3:	83 c4 10             	add    $0x10,%esp
801015e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015e9:	31 c0                	xor    %eax,%eax
801015eb:	eb 2d                	jmp    8010161a <balloc+0x7a>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801015f0:	89 c1                	mov    %eax,%ecx
801015f2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801015fa:	83 e1 07             	and    $0x7,%ecx
801015fd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015ff:	89 c1                	mov    %eax,%ecx
80101601:	c1 f9 03             	sar    $0x3,%ecx
80101604:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101609:	85 d7                	test   %edx,%edi
8010160b:	74 43                	je     80101650 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010160d:	83 c0 01             	add    $0x1,%eax
80101610:	83 c6 01             	add    $0x1,%esi
80101613:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101618:	74 05                	je     8010161f <balloc+0x7f>
8010161a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010161d:	72 d1                	jb     801015f0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 e4             	pushl  -0x1c(%ebp)
80101625:	e8 b6 eb ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010162a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
80101634:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101637:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010163d:	77 82                	ja     801015c1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010163f:	83 ec 0c             	sub    $0xc,%esp
80101642:	68 b2 7b 10 80       	push   $0x80107bb2
80101647:	e8 24 ed ff ff       	call   80100370 <panic>
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101650:	09 fa                	or     %edi,%edx
80101652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101655:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101658:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010165c:	57                   	push   %edi
8010165d:	e8 ee 1a 00 00       	call   80103150 <log_write>
        brelse(bp);
80101662:	89 3c 24             	mov    %edi,(%esp)
80101665:	e8 76 eb ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010166a:	58                   	pop    %eax
8010166b:	5a                   	pop    %edx
8010166c:	56                   	push   %esi
8010166d:	ff 75 d8             	pushl  -0x28(%ebp)
80101670:	e8 5b ea ff ff       	call   801000d0 <bread>
80101675:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101677:	8d 40 5c             	lea    0x5c(%eax),%eax
8010167a:	83 c4 0c             	add    $0xc,%esp
8010167d:	68 00 02 00 00       	push   $0x200
80101682:	6a 00                	push   $0x0
80101684:	50                   	push   %eax
80101685:	e8 e6 36 00 00       	call   80104d70 <memset>
  log_write(bp);
8010168a:	89 1c 24             	mov    %ebx,(%esp)
8010168d:	e8 be 1a 00 00       	call   80103150 <log_write>
  brelse(bp);
80101692:	89 1c 24             	mov    %ebx,(%esp)
80101695:	e8 46 eb ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010169a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010169d:	89 f0                	mov    %esi,%eax
8010169f:	5b                   	pop    %ebx
801016a0:	5e                   	pop    %esi
801016a1:	5f                   	pop    %edi
801016a2:	5d                   	pop    %ebp
801016a3:	c3                   	ret    
801016a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801016aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801016b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	57                   	push   %edi
801016b4:	56                   	push   %esi
801016b5:	53                   	push   %ebx
801016b6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016b8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016ba:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016bf:	83 ec 28             	sub    $0x28,%esp
801016c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801016c5:	68 e0 19 11 80       	push   $0x801119e0
801016ca:	e8 a1 35 00 00       	call   80104c70 <acquire>
801016cf:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016d5:	eb 1b                	jmp    801016f2 <iget+0x42>
801016d7:	89 f6                	mov    %esi,%esi
801016d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801016e0:	85 f6                	test   %esi,%esi
801016e2:	74 44                	je     80101728 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016ea:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801016f0:	74 4e                	je     80101740 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016f5:	85 c9                	test   %ecx,%ecx
801016f7:	7e e7                	jle    801016e0 <iget+0x30>
801016f9:	39 3b                	cmp    %edi,(%ebx)
801016fb:	75 e3                	jne    801016e0 <iget+0x30>
801016fd:	39 53 04             	cmp    %edx,0x4(%ebx)
80101700:	75 de                	jne    801016e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101702:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101705:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101708:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010170a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010170f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101712:	e8 09 36 00 00       	call   80104d20 <release>
      return ip;
80101717:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010171a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010171d:	89 f0                	mov    %esi,%eax
8010171f:	5b                   	pop    %ebx
80101720:	5e                   	pop    %esi
80101721:	5f                   	pop    %edi
80101722:	5d                   	pop    %ebp
80101723:	c3                   	ret    
80101724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101728:	85 c9                	test   %ecx,%ecx
8010172a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010172d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101733:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101739:	75 b7                	jne    801016f2 <iget+0x42>
8010173b:	90                   	nop
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101740:	85 f6                	test   %esi,%esi
80101742:	74 2d                	je     80101771 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101744:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101747:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101749:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010174c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101753:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010175a:	68 e0 19 11 80       	push   $0x801119e0
8010175f:	e8 bc 35 00 00       	call   80104d20 <release>

  return ip;
80101764:	83 c4 10             	add    $0x10,%esp
}
80101767:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010176a:	89 f0                	mov    %esi,%eax
8010176c:	5b                   	pop    %ebx
8010176d:	5e                   	pop    %esi
8010176e:	5f                   	pop    %edi
8010176f:	5d                   	pop    %ebp
80101770:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101771:	83 ec 0c             	sub    $0xc,%esp
80101774:	68 c8 7b 10 80       	push   $0x80107bc8
80101779:	e8 f2 eb ff ff       	call   80100370 <panic>
8010177e:	66 90                	xchg   %ax,%ax

80101780 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	89 c6                	mov    %eax,%esi
80101788:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010178b:	83 fa 0b             	cmp    $0xb,%edx
8010178e:	77 18                	ja     801017a8 <bmap+0x28>
80101790:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101793:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101796:	85 c0                	test   %eax,%eax
80101798:	74 76                	je     80101810 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010179a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010179d:	5b                   	pop    %ebx
8010179e:	5e                   	pop    %esi
8010179f:	5f                   	pop    %edi
801017a0:	5d                   	pop    %ebp
801017a1:	c3                   	ret    
801017a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801017a8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801017ab:	83 fb 7f             	cmp    $0x7f,%ebx
801017ae:	0f 87 83 00 00 00    	ja     80101837 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801017b4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 6a                	je     80101828 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801017be:	83 ec 08             	sub    $0x8,%esp
801017c1:	50                   	push   %eax
801017c2:	ff 36                	pushl  (%esi)
801017c4:	e8 07 e9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801017c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801017cd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801017d0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801017d2:	8b 1a                	mov    (%edx),%ebx
801017d4:	85 db                	test   %ebx,%ebx
801017d6:	75 1d                	jne    801017f5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801017d8:	8b 06                	mov    (%esi),%eax
801017da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801017dd:	e8 be fd ff ff       	call   801015a0 <balloc>
801017e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801017e5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801017e8:	89 c3                	mov    %eax,%ebx
801017ea:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801017ec:	57                   	push   %edi
801017ed:	e8 5e 19 00 00       	call   80103150 <log_write>
801017f2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801017f5:	83 ec 0c             	sub    $0xc,%esp
801017f8:	57                   	push   %edi
801017f9:	e8 e2 e9 ff ff       	call   801001e0 <brelse>
801017fe:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101801:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101804:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101806:	5b                   	pop    %ebx
80101807:	5e                   	pop    %esi
80101808:	5f                   	pop    %edi
80101809:	5d                   	pop    %ebp
8010180a:	c3                   	ret    
8010180b:	90                   	nop
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101810:	8b 06                	mov    (%esi),%eax
80101812:	e8 89 fd ff ff       	call   801015a0 <balloc>
80101817:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010181a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181d:	5b                   	pop    %ebx
8010181e:	5e                   	pop    %esi
8010181f:	5f                   	pop    %edi
80101820:	5d                   	pop    %ebp
80101821:	c3                   	ret    
80101822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101828:	8b 06                	mov    (%esi),%eax
8010182a:	e8 71 fd ff ff       	call   801015a0 <balloc>
8010182f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101835:	eb 87                	jmp    801017be <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 d8 7b 10 80       	push   $0x80107bd8
8010183f:	e8 2c eb ff ff       	call   80100370 <panic>
80101844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010184a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101850 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101858:	83 ec 08             	sub    $0x8,%esp
8010185b:	6a 01                	push   $0x1
8010185d:	ff 75 08             	pushl  0x8(%ebp)
80101860:	e8 6b e8 ff ff       	call   801000d0 <bread>
80101865:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101867:	8d 40 5c             	lea    0x5c(%eax),%eax
8010186a:	83 c4 0c             	add    $0xc,%esp
8010186d:	6a 1c                	push   $0x1c
8010186f:	50                   	push   %eax
80101870:	56                   	push   %esi
80101871:	e8 aa 35 00 00       	call   80104e20 <memmove>
  brelse(bp);
80101876:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101879:	83 c4 10             	add    $0x10,%esp
}
8010187c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010187f:	5b                   	pop    %ebx
80101880:	5e                   	pop    %esi
80101881:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101882:	e9 59 e9 ff ff       	jmp    801001e0 <brelse>
80101887:	89 f6                	mov    %esi,%esi
80101889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101890 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	53                   	push   %ebx
80101894:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101899:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010189c:	68 eb 7b 10 80       	push   $0x80107beb
801018a1:	68 e0 19 11 80       	push   $0x801119e0
801018a6:	e8 65 32 00 00       	call   80104b10 <initlock>
801018ab:	83 c4 10             	add    $0x10,%esp
801018ae:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	68 f2 7b 10 80       	push   $0x80107bf2
801018b8:	53                   	push   %ebx
801018b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018bf:	e8 1c 31 00 00       	call   801049e0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801018cd:	75 e1                	jne    801018b0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801018cf:	83 ec 08             	sub    $0x8,%esp
801018d2:	68 c0 19 11 80       	push   $0x801119c0
801018d7:	ff 75 08             	pushl  0x8(%ebp)
801018da:	e8 71 ff ff ff       	call   80101850 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018df:	ff 35 d8 19 11 80    	pushl  0x801119d8
801018e5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801018eb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801018f1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801018f7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801018fd:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101903:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101909:	68 58 7c 10 80       	push   $0x80107c58
8010190e:	e8 4d ed ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101913:	83 c4 30             	add    $0x30,%esp
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101929:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101930:	8b 45 0c             	mov    0xc(%ebp),%eax
80101933:	8b 75 08             	mov    0x8(%ebp),%esi
80101936:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101939:	0f 86 91 00 00 00    	jbe    801019d0 <ialloc+0xb0>
8010193f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101944:	eb 21                	jmp    80101967 <ialloc+0x47>
80101946:	8d 76 00             	lea    0x0(%esi),%esi
80101949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101950:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101953:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101956:	57                   	push   %edi
80101957:	e8 84 e8 ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010195c:	83 c4 10             	add    $0x10,%esp
8010195f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101965:	76 69                	jbe    801019d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101967:	89 d8                	mov    %ebx,%eax
80101969:	83 ec 08             	sub    $0x8,%esp
8010196c:	c1 e8 03             	shr    $0x3,%eax
8010196f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101975:	50                   	push   %eax
80101976:	56                   	push   %esi
80101977:	e8 54 e7 ff ff       	call   801000d0 <bread>
8010197c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010197e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101980:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101983:	83 e0 07             	and    $0x7,%eax
80101986:	c1 e0 06             	shl    $0x6,%eax
80101989:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010198d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101991:	75 bd                	jne    80101950 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101993:	83 ec 04             	sub    $0x4,%esp
80101996:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101999:	6a 40                	push   $0x40
8010199b:	6a 00                	push   $0x0
8010199d:	51                   	push   %ecx
8010199e:	e8 cd 33 00 00       	call   80104d70 <memset>
      dip->type = type;
801019a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801019ad:	89 3c 24             	mov    %edi,(%esp)
801019b0:	e8 9b 17 00 00       	call   80103150 <log_write>
      brelse(bp);
801019b5:	89 3c 24             	mov    %edi,(%esp)
801019b8:	e8 23 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801019bd:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801019c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801019c3:	89 da                	mov    %ebx,%edx
801019c5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801019c7:	5b                   	pop    %ebx
801019c8:	5e                   	pop    %esi
801019c9:	5f                   	pop    %edi
801019ca:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801019cb:	e9 e0 fc ff ff       	jmp    801016b0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	68 f8 7b 10 80       	push   $0x80107bf8
801019d8:	e8 93 e9 ff ff       	call   80100370 <panic>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi

801019e0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	56                   	push   %esi
801019e4:	53                   	push   %ebx
801019e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019e8:	83 ec 08             	sub    $0x8,%esp
801019eb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ee:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019f1:	c1 e8 03             	shr    $0x3,%eax
801019f4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801019fa:	50                   	push   %eax
801019fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801019fe:	e8 cd e6 ff ff       	call   801000d0 <bread>
80101a03:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a05:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101a08:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a0c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a0f:	83 e0 07             	and    $0x7,%eax
80101a12:	c1 e0 06             	shl    $0x6,%eax
80101a15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a19:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a1c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a20:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101a23:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a27:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a2b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101a2f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a33:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101a37:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a3a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a3d:	6a 34                	push   $0x34
80101a3f:	53                   	push   %ebx
80101a40:	50                   	push   %eax
80101a41:	e8 da 33 00 00       	call   80104e20 <memmove>
  log_write(bp);
80101a46:	89 34 24             	mov    %esi,(%esp)
80101a49:	e8 02 17 00 00       	call   80103150 <log_write>
  brelse(bp);
80101a4e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a51:	83 c4 10             	add    $0x10,%esp
}
80101a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a57:	5b                   	pop    %ebx
80101a58:	5e                   	pop    %esi
80101a59:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101a5a:	e9 81 e7 ff ff       	jmp    801001e0 <brelse>
80101a5f:	90                   	nop

80101a60 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	53                   	push   %ebx
80101a64:	83 ec 10             	sub    $0x10,%esp
80101a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a6a:	68 e0 19 11 80       	push   $0x801119e0
80101a6f:	e8 fc 31 00 00       	call   80104c70 <acquire>
  ip->ref++;
80101a74:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a78:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a7f:	e8 9c 32 00 00       	call   80104d20 <release>
  return ip;
}
80101a84:	89 d8                	mov    %ebx,%eax
80101a86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a89:	c9                   	leave  
80101a8a:	c3                   	ret    
80101a8b:	90                   	nop
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a90 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	56                   	push   %esi
80101a94:	53                   	push   %ebx
80101a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a98:	85 db                	test   %ebx,%ebx
80101a9a:	0f 84 b7 00 00 00    	je     80101b57 <ilock+0xc7>
80101aa0:	8b 53 08             	mov    0x8(%ebx),%edx
80101aa3:	85 d2                	test   %edx,%edx
80101aa5:	0f 8e ac 00 00 00    	jle    80101b57 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
80101aab:	8d 43 0c             	lea    0xc(%ebx),%eax
80101aae:	83 ec 0c             	sub    $0xc,%esp
80101ab1:	50                   	push   %eax
80101ab2:	e8 69 2f 00 00       	call   80104a20 <acquiresleep>

  if(ip->valid == 0){
80101ab7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	85 c0                	test   %eax,%eax
80101abf:	74 0f                	je     80101ad0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ac4:	5b                   	pop    %ebx
80101ac5:	5e                   	pop    %esi
80101ac6:	5d                   	pop    %ebp
80101ac7:	c3                   	ret    
80101ac8:	90                   	nop
80101ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ad0:	8b 43 04             	mov    0x4(%ebx),%eax
80101ad3:	83 ec 08             	sub    $0x8,%esp
80101ad6:	c1 e8 03             	shr    $0x3,%eax
80101ad9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101adf:	50                   	push   %eax
80101ae0:	ff 33                	pushl  (%ebx)
80101ae2:	e8 e9 e5 ff ff       	call   801000d0 <bread>
80101ae7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ae9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aec:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101aef:	83 e0 07             	and    $0x7,%eax
80101af2:	c1 e0 06             	shl    $0x6,%eax
80101af5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101af9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101afc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101aff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b03:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b07:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b0b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b0f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b13:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b17:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b1b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b1e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b21:	6a 34                	push   $0x34
80101b23:	50                   	push   %eax
80101b24:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b27:	50                   	push   %eax
80101b28:	e8 f3 32 00 00       	call   80104e20 <memmove>
    brelse(bp);
80101b2d:	89 34 24             	mov    %esi,(%esp)
80101b30:	e8 ab e6 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101b35:	83 c4 10             	add    $0x10,%esp
80101b38:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
80101b3d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101b44:	0f 85 77 ff ff ff    	jne    80101ac1 <ilock+0x31>
      panic("ilock: no type");
80101b4a:	83 ec 0c             	sub    $0xc,%esp
80101b4d:	68 10 7c 10 80       	push   $0x80107c10
80101b52:	e8 19 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101b57:	83 ec 0c             	sub    $0xc,%esp
80101b5a:	68 0a 7c 10 80       	push   $0x80107c0a
80101b5f:	e8 0c e8 ff ff       	call   80100370 <panic>
80101b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b70 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	56                   	push   %esi
80101b74:	53                   	push   %ebx
80101b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b78:	85 db                	test   %ebx,%ebx
80101b7a:	74 28                	je     80101ba4 <iunlock+0x34>
80101b7c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b7f:	83 ec 0c             	sub    $0xc,%esp
80101b82:	56                   	push   %esi
80101b83:	e8 38 2f 00 00       	call   80104ac0 <holdingsleep>
80101b88:	83 c4 10             	add    $0x10,%esp
80101b8b:	85 c0                	test   %eax,%eax
80101b8d:	74 15                	je     80101ba4 <iunlock+0x34>
80101b8f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b92:	85 c0                	test   %eax,%eax
80101b94:	7e 0e                	jle    80101ba4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101b96:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b9c:	5b                   	pop    %ebx
80101b9d:	5e                   	pop    %esi
80101b9e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
80101b9f:	e9 dc 2e 00 00       	jmp    80104a80 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	68 1f 7c 10 80       	push   $0x80107c1f
80101bac:	e8 bf e7 ff ff       	call   80100370 <panic>
80101bb1:	eb 0d                	jmp    80101bc0 <iput>
80101bb3:	90                   	nop
80101bb4:	90                   	nop
80101bb5:	90                   	nop
80101bb6:	90                   	nop
80101bb7:	90                   	nop
80101bb8:	90                   	nop
80101bb9:	90                   	nop
80101bba:	90                   	nop
80101bbb:	90                   	nop
80101bbc:	90                   	nop
80101bbd:	90                   	nop
80101bbe:	90                   	nop
80101bbf:	90                   	nop

80101bc0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 28             	sub    $0x28,%esp
80101bc9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
80101bcc:	8d 7e 0c             	lea    0xc(%esi),%edi
80101bcf:	57                   	push   %edi
80101bd0:	e8 4b 2e 00 00       	call   80104a20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101bd5:	8b 56 4c             	mov    0x4c(%esi),%edx
80101bd8:	83 c4 10             	add    $0x10,%esp
80101bdb:	85 d2                	test   %edx,%edx
80101bdd:	74 07                	je     80101be6 <iput+0x26>
80101bdf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101be4:	74 32                	je     80101c18 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101be6:	83 ec 0c             	sub    $0xc,%esp
80101be9:	57                   	push   %edi
80101bea:	e8 91 2e 00 00       	call   80104a80 <releasesleep>

  acquire(&icache.lock);
80101bef:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bf6:	e8 75 30 00 00       	call   80104c70 <acquire>
  ip->ref--;
80101bfb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101bff:	83 c4 10             	add    $0x10,%esp
80101c02:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0c:	5b                   	pop    %ebx
80101c0d:	5e                   	pop    %esi
80101c0e:	5f                   	pop    %edi
80101c0f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101c10:	e9 0b 31 00 00       	jmp    80104d20 <release>
80101c15:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101c18:	83 ec 0c             	sub    $0xc,%esp
80101c1b:	68 e0 19 11 80       	push   $0x801119e0
80101c20:	e8 4b 30 00 00       	call   80104c70 <acquire>
    int r = ip->ref;
80101c25:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101c28:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c2f:	e8 ec 30 00 00       	call   80104d20 <release>
    if(r == 1){
80101c34:	83 c4 10             	add    $0x10,%esp
80101c37:	83 fb 01             	cmp    $0x1,%ebx
80101c3a:	75 aa                	jne    80101be6 <iput+0x26>
80101c3c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101c42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c45:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101c48:	89 cf                	mov    %ecx,%edi
80101c4a:	eb 0b                	jmp    80101c57 <iput+0x97>
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c50:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c53:	39 fb                	cmp    %edi,%ebx
80101c55:	74 19                	je     80101c70 <iput+0xb0>
    if(ip->addrs[i]){
80101c57:	8b 13                	mov    (%ebx),%edx
80101c59:	85 d2                	test   %edx,%edx
80101c5b:	74 f3                	je     80101c50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c5d:	8b 06                	mov    (%esi),%eax
80101c5f:	e8 cc f8 ff ff       	call   80101530 <bfree>
      ip->addrs[i] = 0;
80101c64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101c6a:	eb e4                	jmp    80101c50 <iput+0x90>
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c70:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101c76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c79:	85 c0                	test   %eax,%eax
80101c7b:	75 33                	jne    80101cb0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c7d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101c80:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101c87:	56                   	push   %esi
80101c88:	e8 53 fd ff ff       	call   801019e0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101c8d:	31 c0                	xor    %eax,%eax
80101c8f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101c93:	89 34 24             	mov    %esi,(%esp)
80101c96:	e8 45 fd ff ff       	call   801019e0 <iupdate>
      ip->valid = 0;
80101c9b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	e9 3c ff ff ff       	jmp    80101be6 <iput+0x26>
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cb0:	83 ec 08             	sub    $0x8,%esp
80101cb3:	50                   	push   %eax
80101cb4:	ff 36                	pushl  (%esi)
80101cb6:	e8 15 e4 ff ff       	call   801000d0 <bread>
80101cbb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101cc1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101cc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101cc7:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101cca:	83 c4 10             	add    $0x10,%esp
80101ccd:	89 cf                	mov    %ecx,%edi
80101ccf:	eb 0e                	jmp    80101cdf <iput+0x11f>
80101cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cd8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101cdb:	39 fb                	cmp    %edi,%ebx
80101cdd:	74 0f                	je     80101cee <iput+0x12e>
      if(a[j])
80101cdf:	8b 13                	mov    (%ebx),%edx
80101ce1:	85 d2                	test   %edx,%edx
80101ce3:	74 f3                	je     80101cd8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101ce5:	8b 06                	mov    (%esi),%eax
80101ce7:	e8 44 f8 ff ff       	call   80101530 <bfree>
80101cec:	eb ea                	jmp    80101cd8 <iput+0x118>
    }
    brelse(bp);
80101cee:	83 ec 0c             	sub    $0xc,%esp
80101cf1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101cf4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cf7:	e8 e4 e4 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cfc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101d02:	8b 06                	mov    (%esi),%eax
80101d04:	e8 27 f8 ff ff       	call   80101530 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d09:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101d10:	00 00 00 
80101d13:	83 c4 10             	add    $0x10,%esp
80101d16:	e9 62 ff ff ff       	jmp    80101c7d <iput+0xbd>
80101d1b:	90                   	nop
80101d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d20 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	53                   	push   %ebx
80101d24:	83 ec 10             	sub    $0x10,%esp
80101d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101d2a:	53                   	push   %ebx
80101d2b:	e8 40 fe ff ff       	call   80101b70 <iunlock>
  iput(ip);
80101d30:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d33:	83 c4 10             	add    $0x10,%esp
}
80101d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d39:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101d3a:	e9 81 fe ff ff       	jmp    80101bc0 <iput>
80101d3f:	90                   	nop

80101d40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	8b 55 08             	mov    0x8(%ebp),%edx
80101d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101d49:	8b 0a                	mov    (%edx),%ecx
80101d4b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101d4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d51:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d54:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d58:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d5b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d5f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d63:	8b 52 58             	mov    0x58(%edx),%edx
80101d66:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d69:	5d                   	pop    %ebp
80101d6a:	c3                   	ret    
80101d6b:	90                   	nop
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	83 ec 1c             	sub    $0x1c,%esp
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101d7f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d87:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d8a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101d8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d93:	0f 84 a7 00 00 00    	je     80101e40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d9c:	8b 40 58             	mov    0x58(%eax),%eax
80101d9f:	39 f0                	cmp    %esi,%eax
80101da1:	0f 82 c1 00 00 00    	jb     80101e68 <readi+0xf8>
80101da7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101daa:	89 fa                	mov    %edi,%edx
80101dac:	01 f2                	add    %esi,%edx
80101dae:	0f 82 b4 00 00 00    	jb     80101e68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101db4:	89 c1                	mov    %eax,%ecx
80101db6:	29 f1                	sub    %esi,%ecx
80101db8:	39 d0                	cmp    %edx,%eax
80101dba:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dbd:	31 ff                	xor    %edi,%edi
80101dbf:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101dc1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dc4:	74 6d                	je     80101e33 <readi+0xc3>
80101dc6:	8d 76 00             	lea    0x0(%esi),%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dd0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101dd3:	89 f2                	mov    %esi,%edx
80101dd5:	c1 ea 09             	shr    $0x9,%edx
80101dd8:	89 d8                	mov    %ebx,%eax
80101dda:	e8 a1 f9 ff ff       	call   80101780 <bmap>
80101ddf:	83 ec 08             	sub    $0x8,%esp
80101de2:	50                   	push   %eax
80101de3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101de5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dea:	e8 e1 e2 ff ff       	call   801000d0 <bread>
80101def:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df4:	89 f1                	mov    %esi,%ecx
80101df6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101dfc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101dff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101e02:	29 cb                	sub    %ecx,%ebx
80101e04:	29 f8                	sub    %edi,%eax
80101e06:	39 c3                	cmp    %eax,%ebx
80101e08:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101e0b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101e0f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e10:	01 df                	add    %ebx,%edi
80101e12:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101e14:	50                   	push   %eax
80101e15:	ff 75 e0             	pushl  -0x20(%ebp)
80101e18:	e8 03 30 00 00       	call   80104e20 <memmove>
    brelse(bp);
80101e1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e20:	89 14 24             	mov    %edx,(%esp)
80101e23:	e8 b8 e3 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e31:	77 9d                	ja     80101dd0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101e33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e39:	5b                   	pop    %ebx
80101e3a:	5e                   	pop    %esi
80101e3b:	5f                   	pop    %edi
80101e3c:	5d                   	pop    %ebp
80101e3d:	c3                   	ret    
80101e3e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e44:	66 83 f8 09          	cmp    $0x9,%ax
80101e48:	77 1e                	ja     80101e68 <readi+0xf8>
80101e4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101e51:	85 c0                	test   %eax,%eax
80101e53:	74 13                	je     80101e68 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101e55:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101e58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e5b:	5b                   	pop    %ebx
80101e5c:	5e                   	pop    %esi
80101e5d:	5f                   	pop    %edi
80101e5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101e5f:	ff e0                	jmp    *%eax
80101e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e6d:	eb c7                	jmp    80101e36 <readi+0xc6>
80101e6f:	90                   	nop

80101e70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 1c             	sub    $0x1c,%esp
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e93:	0f 84 b7 00 00 00    	je     80101f50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e9f:	0f 82 eb 00 00 00    	jb     80101f90 <writei+0x120>
80101ea5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ea8:	89 f8                	mov    %edi,%eax
80101eaa:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101eac:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101eb1:	0f 87 d9 00 00 00    	ja     80101f90 <writei+0x120>
80101eb7:	39 c6                	cmp    %eax,%esi
80101eb9:	0f 87 d1 00 00 00    	ja     80101f90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ebf:	85 ff                	test   %edi,%edi
80101ec1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ec8:	74 78                	je     80101f42 <writei+0xd2>
80101eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ed0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ed3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ed5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eda:	c1 ea 09             	shr    $0x9,%edx
80101edd:	89 f8                	mov    %edi,%eax
80101edf:	e8 9c f8 ff ff       	call   80101780 <bmap>
80101ee4:	83 ec 08             	sub    $0x8,%esp
80101ee7:	50                   	push   %eax
80101ee8:	ff 37                	pushl  (%edi)
80101eea:	e8 e1 e1 ff ff       	call   801000d0 <bread>
80101eef:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ef4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ef7:	89 f1                	mov    %esi,%ecx
80101ef9:	83 c4 0c             	add    $0xc,%esp
80101efc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101f02:	29 cb                	sub    %ecx,%ebx
80101f04:	39 c3                	cmp    %eax,%ebx
80101f06:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101f09:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101f0d:	53                   	push   %ebx
80101f0e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f11:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101f13:	50                   	push   %eax
80101f14:	e8 07 2f 00 00       	call   80104e20 <memmove>
    log_write(bp);
80101f19:	89 3c 24             	mov    %edi,(%esp)
80101f1c:	e8 2f 12 00 00       	call   80103150 <log_write>
    brelse(bp);
80101f21:	89 3c 24             	mov    %edi,(%esp)
80101f24:	e8 b7 e2 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f2c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f2f:	83 c4 10             	add    $0x10,%esp
80101f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f35:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101f38:	77 96                	ja     80101ed0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101f3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f3d:	3b 70 58             	cmp    0x58(%eax),%esi
80101f40:	77 36                	ja     80101f78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f48:	5b                   	pop    %ebx
80101f49:	5e                   	pop    %esi
80101f4a:	5f                   	pop    %edi
80101f4b:	5d                   	pop    %ebp
80101f4c:	c3                   	ret    
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f54:	66 83 f8 09          	cmp    $0x9,%ax
80101f58:	77 36                	ja     80101f90 <writei+0x120>
80101f5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101f61:	85 c0                	test   %eax,%eax
80101f63:	74 2b                	je     80101f90 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101f65:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6b:	5b                   	pop    %ebx
80101f6c:	5e                   	pop    %esi
80101f6d:	5f                   	pop    %edi
80101f6e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101f6f:	ff e0                	jmp    *%eax
80101f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101f78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f7b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101f7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f81:	50                   	push   %eax
80101f82:	e8 59 fa ff ff       	call   801019e0 <iupdate>
80101f87:	83 c4 10             	add    $0x10,%esp
80101f8a:	eb b6                	jmp    80101f42 <writei+0xd2>
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f95:	eb ae                	jmp    80101f45 <writei+0xd5>
80101f97:	89 f6                	mov    %esi,%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101fa6:	6a 0e                	push   $0xe
80101fa8:	ff 75 0c             	pushl  0xc(%ebp)
80101fab:	ff 75 08             	pushl  0x8(%ebp)
80101fae:	e8 ed 2e 00 00       	call   80104ea0 <strncmp>
}
80101fb3:	c9                   	leave  
80101fb4:	c3                   	ret    
80101fb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 1c             	sub    $0x1c,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101fcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101fd1:	0f 85 80 00 00 00    	jne    80102057 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101fd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101fda:	31 ff                	xor    %edi,%edi
80101fdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fdf:	85 d2                	test   %edx,%edx
80101fe1:	75 0d                	jne    80101ff0 <dirlookup+0x30>
80101fe3:	eb 5b                	jmp    80102040 <dirlookup+0x80>
80101fe5:	8d 76 00             	lea    0x0(%esi),%esi
80101fe8:	83 c7 10             	add    $0x10,%edi
80101feb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101fee:	76 50                	jbe    80102040 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff0:	6a 10                	push   $0x10
80101ff2:	57                   	push   %edi
80101ff3:	56                   	push   %esi
80101ff4:	53                   	push   %ebx
80101ff5:	e8 76 fd ff ff       	call   80101d70 <readi>
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	83 f8 10             	cmp    $0x10,%eax
80102000:	75 48                	jne    8010204a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80102002:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102007:	74 df                	je     80101fe8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80102009:	8d 45 da             	lea    -0x26(%ebp),%eax
8010200c:	83 ec 04             	sub    $0x4,%esp
8010200f:	6a 0e                	push   $0xe
80102011:	50                   	push   %eax
80102012:	ff 75 0c             	pushl  0xc(%ebp)
80102015:	e8 86 2e 00 00       	call   80104ea0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	85 c0                	test   %eax,%eax
8010201f:	75 c7                	jne    80101fe8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80102021:	8b 45 10             	mov    0x10(%ebp),%eax
80102024:	85 c0                	test   %eax,%eax
80102026:	74 05                	je     8010202d <dirlookup+0x6d>
        *poff = off;
80102028:	8b 45 10             	mov    0x10(%ebp),%eax
8010202b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
8010202d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80102031:	8b 03                	mov    (%ebx),%eax
80102033:	e8 78 f6 ff ff       	call   801016b0 <iget>
    }
  }

  return 0;
}
80102038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5f                   	pop    %edi
8010203e:	5d                   	pop    %ebp
8010203f:	c3                   	ret    
80102040:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102043:	31 c0                	xor    %eax,%eax
}
80102045:	5b                   	pop    %ebx
80102046:	5e                   	pop    %esi
80102047:	5f                   	pop    %edi
80102048:	5d                   	pop    %ebp
80102049:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
8010204a:	83 ec 0c             	sub    $0xc,%esp
8010204d:	68 39 7c 10 80       	push   $0x80107c39
80102052:	e8 19 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80102057:	83 ec 0c             	sub    $0xc,%esp
8010205a:	68 27 7c 10 80       	push   $0x80107c27
8010205f:	e8 0c e3 ff ff       	call   80100370 <panic>
80102064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010206a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102070 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	89 cf                	mov    %ecx,%edi
80102078:	89 c3                	mov    %eax,%ebx
8010207a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010207d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102080:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80102083:	0f 84 53 01 00 00    	je     801021dc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102089:	e8 72 1b 00 00       	call   80103c00 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
8010208e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102091:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80102094:	68 e0 19 11 80       	push   $0x801119e0
80102099:	e8 d2 2b 00 00       	call   80104c70 <acquire>
  ip->ref++;
8010209e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801020a2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801020a9:	e8 72 2c 00 00       	call   80104d20 <release>
801020ae:	83 c4 10             	add    $0x10,%esp
801020b1:	eb 08                	jmp    801020bb <namex+0x4b>
801020b3:	90                   	nop
801020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
801020b8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801020bb:	0f b6 03             	movzbl (%ebx),%eax
801020be:	3c 2f                	cmp    $0x2f,%al
801020c0:	74 f6                	je     801020b8 <namex+0x48>
    path++;
  if(*path == 0)
801020c2:	84 c0                	test   %al,%al
801020c4:	0f 84 e3 00 00 00    	je     801021ad <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801020ca:	0f b6 03             	movzbl (%ebx),%eax
801020cd:	89 da                	mov    %ebx,%edx
801020cf:	84 c0                	test   %al,%al
801020d1:	0f 84 ac 00 00 00    	je     80102183 <namex+0x113>
801020d7:	3c 2f                	cmp    $0x2f,%al
801020d9:	75 09                	jne    801020e4 <namex+0x74>
801020db:	e9 a3 00 00 00       	jmp    80102183 <namex+0x113>
801020e0:	84 c0                	test   %al,%al
801020e2:	74 0a                	je     801020ee <namex+0x7e>
    path++;
801020e4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801020e7:	0f b6 02             	movzbl (%edx),%eax
801020ea:	3c 2f                	cmp    $0x2f,%al
801020ec:	75 f2                	jne    801020e0 <namex+0x70>
801020ee:	89 d1                	mov    %edx,%ecx
801020f0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
801020f2:	83 f9 0d             	cmp    $0xd,%ecx
801020f5:	0f 8e 8d 00 00 00    	jle    80102188 <namex+0x118>
    memmove(name, s, DIRSIZ);
801020fb:	83 ec 04             	sub    $0x4,%esp
801020fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102101:	6a 0e                	push   $0xe
80102103:	53                   	push   %ebx
80102104:	57                   	push   %edi
80102105:	e8 16 2d 00 00       	call   80104e20 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
8010210a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
8010210d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80102110:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102112:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102115:	75 11                	jne    80102128 <namex+0xb8>
80102117:	89 f6                	mov    %esi,%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102120:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102123:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102126:	74 f8                	je     80102120 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	56                   	push   %esi
8010212c:	e8 5f f9 ff ff       	call   80101a90 <ilock>
    if(ip->type != T_DIR){
80102131:	83 c4 10             	add    $0x10,%esp
80102134:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102139:	0f 85 7f 00 00 00    	jne    801021be <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010213f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102142:	85 d2                	test   %edx,%edx
80102144:	74 09                	je     8010214f <namex+0xdf>
80102146:	80 3b 00             	cmpb   $0x0,(%ebx)
80102149:	0f 84 a3 00 00 00    	je     801021f2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010214f:	83 ec 04             	sub    $0x4,%esp
80102152:	6a 00                	push   $0x0
80102154:	57                   	push   %edi
80102155:	56                   	push   %esi
80102156:	e8 65 fe ff ff       	call   80101fc0 <dirlookup>
8010215b:	83 c4 10             	add    $0x10,%esp
8010215e:	85 c0                	test   %eax,%eax
80102160:	74 5c                	je     801021be <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102162:	83 ec 0c             	sub    $0xc,%esp
80102165:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102168:	56                   	push   %esi
80102169:	e8 02 fa ff ff       	call   80101b70 <iunlock>
  iput(ip);
8010216e:	89 34 24             	mov    %esi,(%esp)
80102171:	e8 4a fa ff ff       	call   80101bc0 <iput>
80102176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	89 c6                	mov    %eax,%esi
8010217e:	e9 38 ff ff ff       	jmp    801020bb <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102183:	31 c9                	xor    %ecx,%ecx
80102185:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80102188:	83 ec 04             	sub    $0x4,%esp
8010218b:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010218e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102191:	51                   	push   %ecx
80102192:	53                   	push   %ebx
80102193:	57                   	push   %edi
80102194:	e8 87 2c 00 00       	call   80104e20 <memmove>
    name[len] = 0;
80102199:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010219c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010219f:	83 c4 10             	add    $0x10,%esp
801021a2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801021a6:	89 d3                	mov    %edx,%ebx
801021a8:	e9 65 ff ff ff       	jmp    80102112 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801021ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021b0:	85 c0                	test   %eax,%eax
801021b2:	75 54                	jne    80102208 <namex+0x198>
801021b4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
801021b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b9:	5b                   	pop    %ebx
801021ba:	5e                   	pop    %esi
801021bb:	5f                   	pop    %edi
801021bc:	5d                   	pop    %ebp
801021bd:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801021be:	83 ec 0c             	sub    $0xc,%esp
801021c1:	56                   	push   %esi
801021c2:	e8 a9 f9 ff ff       	call   80101b70 <iunlock>
  iput(ip);
801021c7:	89 34 24             	mov    %esi,(%esp)
801021ca:	e8 f1 f9 ff ff       	call   80101bc0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
801021cf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
801021d5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021d7:	5b                   	pop    %ebx
801021d8:	5e                   	pop    %esi
801021d9:	5f                   	pop    %edi
801021da:	5d                   	pop    %ebp
801021db:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
801021dc:	ba 01 00 00 00       	mov    $0x1,%edx
801021e1:	b8 01 00 00 00       	mov    $0x1,%eax
801021e6:	e8 c5 f4 ff ff       	call   801016b0 <iget>
801021eb:	89 c6                	mov    %eax,%esi
801021ed:	e9 c9 fe ff ff       	jmp    801020bb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
801021f2:	83 ec 0c             	sub    $0xc,%esp
801021f5:	56                   	push   %esi
801021f6:	e8 75 f9 ff ff       	call   80101b70 <iunlock>
      return ip;
801021fb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
801021fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80102201:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102203:	5b                   	pop    %ebx
80102204:	5e                   	pop    %esi
80102205:	5f                   	pop    %edi
80102206:	5d                   	pop    %ebp
80102207:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80102208:	83 ec 0c             	sub    $0xc,%esp
8010220b:	56                   	push   %esi
8010220c:	e8 af f9 ff ff       	call   80101bc0 <iput>
    return 0;
80102211:	83 c4 10             	add    $0x10,%esp
80102214:	31 c0                	xor    %eax,%eax
80102216:	eb 9e                	jmp    801021b6 <namex+0x146>
80102218:	90                   	nop
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	57                   	push   %edi
80102224:	56                   	push   %esi
80102225:	53                   	push   %ebx
80102226:	83 ec 20             	sub    $0x20,%esp
80102229:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010222c:	6a 00                	push   $0x0
8010222e:	ff 75 0c             	pushl  0xc(%ebp)
80102231:	53                   	push   %ebx
80102232:	e8 89 fd ff ff       	call   80101fc0 <dirlookup>
80102237:	83 c4 10             	add    $0x10,%esp
8010223a:	85 c0                	test   %eax,%eax
8010223c:	75 67                	jne    801022a5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010223e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102241:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102244:	85 ff                	test   %edi,%edi
80102246:	74 29                	je     80102271 <dirlink+0x51>
80102248:	31 ff                	xor    %edi,%edi
8010224a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010224d:	eb 09                	jmp    80102258 <dirlink+0x38>
8010224f:	90                   	nop
80102250:	83 c7 10             	add    $0x10,%edi
80102253:	39 7b 58             	cmp    %edi,0x58(%ebx)
80102256:	76 19                	jbe    80102271 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102258:	6a 10                	push   $0x10
8010225a:	57                   	push   %edi
8010225b:	56                   	push   %esi
8010225c:	53                   	push   %ebx
8010225d:	e8 0e fb ff ff       	call   80101d70 <readi>
80102262:	83 c4 10             	add    $0x10,%esp
80102265:	83 f8 10             	cmp    $0x10,%eax
80102268:	75 4e                	jne    801022b8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
8010226a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010226f:	75 df                	jne    80102250 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102271:	8d 45 da             	lea    -0x26(%ebp),%eax
80102274:	83 ec 04             	sub    $0x4,%esp
80102277:	6a 0e                	push   $0xe
80102279:	ff 75 0c             	pushl  0xc(%ebp)
8010227c:	50                   	push   %eax
8010227d:	e8 8e 2c 00 00       	call   80104f10 <strncpy>
  de.inum = inum;
80102282:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102285:	6a 10                	push   $0x10
80102287:	57                   	push   %edi
80102288:	56                   	push   %esi
80102289:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
8010228a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010228e:	e8 dd fb ff ff       	call   80101e70 <writei>
80102293:	83 c4 20             	add    $0x20,%esp
80102296:	83 f8 10             	cmp    $0x10,%eax
80102299:	75 2a                	jne    801022c5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
8010229b:	31 c0                	xor    %eax,%eax
}
8010229d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a0:	5b                   	pop    %ebx
801022a1:	5e                   	pop    %esi
801022a2:	5f                   	pop    %edi
801022a3:	5d                   	pop    %ebp
801022a4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
801022a5:	83 ec 0c             	sub    $0xc,%esp
801022a8:	50                   	push   %eax
801022a9:	e8 12 f9 ff ff       	call   80101bc0 <iput>
    return -1;
801022ae:	83 c4 10             	add    $0x10,%esp
801022b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b6:	eb e5                	jmp    8010229d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
801022b8:	83 ec 0c             	sub    $0xc,%esp
801022bb:	68 48 7c 10 80       	push   $0x80107c48
801022c0:	e8 ab e0 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
801022c5:	83 ec 0c             	sub    $0xc,%esp
801022c8:	68 be 82 10 80       	push   $0x801082be
801022cd:	e8 9e e0 ff ff       	call   80100370 <panic>
801022d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
801022e0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022e1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
801022e3:	89 e5                	mov    %esp,%ebp
801022e5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022e8:	8b 45 08             	mov    0x8(%ebp),%eax
801022eb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801022ee:	e8 7d fd ff ff       	call   80102070 <namex>
}
801022f3:	c9                   	leave  
801022f4:	c3                   	ret    
801022f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102300:	55                   	push   %ebp
  return namex(path, 1, name);
80102301:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102306:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102308:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010230b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010230e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010230f:	e9 5c fd ff ff       	jmp    80102070 <namex>
80102314:	66 90                	xchg   %ax,%ax
80102316:	66 90                	xchg   %ax,%ax
80102318:	66 90                	xchg   %ax,%ax
8010231a:	66 90                	xchg   %ax,%ax
8010231c:	66 90                	xchg   %ax,%ax
8010231e:	66 90                	xchg   %ax,%ax

80102320 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102320:	55                   	push   %ebp
  if(b == 0)
80102321:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102323:	89 e5                	mov    %esp,%ebp
80102325:	56                   	push   %esi
80102326:	53                   	push   %ebx
  if(b == 0)
80102327:	0f 84 ad 00 00 00    	je     801023da <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010232d:	8b 58 08             	mov    0x8(%eax),%ebx
80102330:	89 c1                	mov    %eax,%ecx
80102332:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102338:	0f 87 8f 00 00 00    	ja     801023cd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010233e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102343:	90                   	nop
80102344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102348:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102349:	83 e0 c0             	and    $0xffffffc0,%eax
8010234c:	3c 40                	cmp    $0x40,%al
8010234e:	75 f8                	jne    80102348 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102350:	31 f6                	xor    %esi,%esi
80102352:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102357:	89 f0                	mov    %esi,%eax
80102359:	ee                   	out    %al,(%dx)
8010235a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010235f:	b8 01 00 00 00       	mov    $0x1,%eax
80102364:	ee                   	out    %al,(%dx)
80102365:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010236a:	89 d8                	mov    %ebx,%eax
8010236c:	ee                   	out    %al,(%dx)
8010236d:	89 d8                	mov    %ebx,%eax
8010236f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102374:	c1 f8 08             	sar    $0x8,%eax
80102377:	ee                   	out    %al,(%dx)
80102378:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010237d:	89 f0                	mov    %esi,%eax
8010237f:	ee                   	out    %al,(%dx)
80102380:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102384:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102389:	83 e0 01             	and    $0x1,%eax
8010238c:	c1 e0 04             	shl    $0x4,%eax
8010238f:	83 c8 e0             	or     $0xffffffe0,%eax
80102392:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102393:	f6 01 04             	testb  $0x4,(%ecx)
80102396:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010239b:	75 13                	jne    801023b0 <idestart+0x90>
8010239d:	b8 20 00 00 00       	mov    $0x20,%eax
801023a2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a6:	5b                   	pop    %ebx
801023a7:	5e                   	pop    %esi
801023a8:	5d                   	pop    %ebp
801023a9:	c3                   	ret    
801023aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023b0:	b8 30 00 00 00       	mov    $0x30,%eax
801023b5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
801023b6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
801023bb:	8d 71 5c             	lea    0x5c(%ecx),%esi
801023be:	b9 80 00 00 00       	mov    $0x80,%ecx
801023c3:	fc                   	cld    
801023c4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023c9:	5b                   	pop    %ebx
801023ca:	5e                   	pop    %esi
801023cb:	5d                   	pop    %ebp
801023cc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801023cd:	83 ec 0c             	sub    $0xc,%esp
801023d0:	68 b4 7c 10 80       	push   $0x80107cb4
801023d5:	e8 96 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801023da:	83 ec 0c             	sub    $0xc,%esp
801023dd:	68 ab 7c 10 80       	push   $0x80107cab
801023e2:	e8 89 df ff ff       	call   80100370 <panic>
801023e7:	89 f6                	mov    %esi,%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801023f6:	68 c6 7c 10 80       	push   $0x80107cc6
801023fb:	68 80 b5 10 80       	push   $0x8010b580
80102400:	e8 0b 27 00 00       	call   80104b10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102405:	58                   	pop    %eax
80102406:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010240b:	5a                   	pop    %edx
8010240c:	83 e8 01             	sub    $0x1,%eax
8010240f:	50                   	push   %eax
80102410:	6a 0e                	push   $0xe
80102412:	e8 a9 02 00 00       	call   801026c0 <ioapicenable>
80102417:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010241a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010241f:	90                   	nop
80102420:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102421:	83 e0 c0             	and    $0xffffffc0,%eax
80102424:	3c 40                	cmp    $0x40,%al
80102426:	75 f8                	jne    80102420 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102428:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010242d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102432:	ee                   	out    %al,(%dx)
80102433:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102438:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010243d:	eb 06                	jmp    80102445 <ideinit+0x55>
8010243f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102440:	83 e9 01             	sub    $0x1,%ecx
80102443:	74 0f                	je     80102454 <ideinit+0x64>
80102445:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102446:	84 c0                	test   %al,%al
80102448:	74 f6                	je     80102440 <ideinit+0x50>
      havedisk1 = 1;
8010244a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102451:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102454:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102459:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010245e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010245f:	c9                   	leave  
80102460:	c3                   	ret    
80102461:	eb 0d                	jmp    80102470 <ideintr>
80102463:	90                   	nop
80102464:	90                   	nop
80102465:	90                   	nop
80102466:	90                   	nop
80102467:	90                   	nop
80102468:	90                   	nop
80102469:	90                   	nop
8010246a:	90                   	nop
8010246b:	90                   	nop
8010246c:	90                   	nop
8010246d:	90                   	nop
8010246e:	90                   	nop
8010246f:	90                   	nop

80102470 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	57                   	push   %edi
80102474:	56                   	push   %esi
80102475:	53                   	push   %ebx
80102476:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102479:	68 80 b5 10 80       	push   $0x8010b580
8010247e:	e8 ed 27 00 00       	call   80104c70 <acquire>

  if((b = idequeue) == 0){
80102483:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102489:	83 c4 10             	add    $0x10,%esp
8010248c:	85 db                	test   %ebx,%ebx
8010248e:	74 34                	je     801024c4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102490:	8b 43 58             	mov    0x58(%ebx),%eax
80102493:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102498:	8b 33                	mov    (%ebx),%esi
8010249a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801024a0:	74 3e                	je     801024e0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024a2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801024a5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024a8:	83 ce 02             	or     $0x2,%esi
801024ab:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801024ad:	53                   	push   %ebx
801024ae:	e8 7d 23 00 00       	call   80104830 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024b3:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024b8:	83 c4 10             	add    $0x10,%esp
801024bb:	85 c0                	test   %eax,%eax
801024bd:	74 05                	je     801024c4 <ideintr+0x54>
    idestart(idequeue);
801024bf:	e8 5c fe ff ff       	call   80102320 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	68 80 b5 10 80       	push   $0x8010b580
801024cc:	e8 4f 28 00 00       	call   80104d20 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801024d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024d4:	5b                   	pop    %ebx
801024d5:	5e                   	pop    %esi
801024d6:	5f                   	pop    %edi
801024d7:	5d                   	pop    %ebp
801024d8:	c3                   	ret    
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024e5:	8d 76 00             	lea    0x0(%esi),%esi
801024e8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024e9:	89 c1                	mov    %eax,%ecx
801024eb:	83 e1 c0             	and    $0xffffffc0,%ecx
801024ee:	80 f9 40             	cmp    $0x40,%cl
801024f1:	75 f5                	jne    801024e8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024f3:	a8 21                	test   $0x21,%al
801024f5:	75 ab                	jne    801024a2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801024f7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801024fa:	b9 80 00 00 00       	mov    $0x80,%ecx
801024ff:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102504:	fc                   	cld    
80102505:	f3 6d                	rep insl (%dx),%es:(%edi)
80102507:	8b 33                	mov    (%ebx),%esi
80102509:	eb 97                	jmp    801024a2 <ideintr+0x32>
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102510 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 10             	sub    $0x10,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010251a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010251d:	50                   	push   %eax
8010251e:	e8 9d 25 00 00       	call   80104ac0 <holdingsleep>
80102523:	83 c4 10             	add    $0x10,%esp
80102526:	85 c0                	test   %eax,%eax
80102528:	0f 84 ad 00 00 00    	je     801025db <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 e0 06             	and    $0x6,%eax
80102533:	83 f8 02             	cmp    $0x2,%eax
80102536:	0f 84 b9 00 00 00    	je     801025f5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010253c:	8b 53 04             	mov    0x4(%ebx),%edx
8010253f:	85 d2                	test   %edx,%edx
80102541:	74 0d                	je     80102550 <iderw+0x40>
80102543:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102548:	85 c0                	test   %eax,%eax
8010254a:	0f 84 98 00 00 00    	je     801025e8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 80 b5 10 80       	push   $0x8010b580
80102558:	e8 13 27 00 00       	call   80104c70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010255d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102563:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102566:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010256d:	85 d2                	test   %edx,%edx
8010256f:	75 09                	jne    8010257a <iderw+0x6a>
80102571:	eb 58                	jmp    801025cb <iderw+0xbb>
80102573:	90                   	nop
80102574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102578:	89 c2                	mov    %eax,%edx
8010257a:	8b 42 58             	mov    0x58(%edx),%eax
8010257d:	85 c0                	test   %eax,%eax
8010257f:	75 f7                	jne    80102578 <iderw+0x68>
80102581:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102584:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102586:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010258c:	74 44                	je     801025d2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 e0 06             	and    $0x6,%eax
80102593:	83 f8 02             	cmp    $0x2,%eax
80102596:	74 23                	je     801025bb <iderw+0xab>
80102598:	90                   	nop
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801025a0:	83 ec 08             	sub    $0x8,%esp
801025a3:	68 80 b5 10 80       	push   $0x8010b580
801025a8:	53                   	push   %ebx
801025a9:	e8 b2 20 00 00       	call   80104660 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025ae:	8b 03                	mov    (%ebx),%eax
801025b0:	83 c4 10             	add    $0x10,%esp
801025b3:	83 e0 06             	and    $0x6,%eax
801025b6:	83 f8 02             	cmp    $0x2,%eax
801025b9:	75 e5                	jne    801025a0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801025bb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801025c6:	e9 55 27 00 00       	jmp    80104d20 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025cb:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025d0:	eb b2                	jmp    80102584 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801025d2:	89 d8                	mov    %ebx,%eax
801025d4:	e8 47 fd ff ff       	call   80102320 <idestart>
801025d9:	eb b3                	jmp    8010258e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801025db:	83 ec 0c             	sub    $0xc,%esp
801025de:	68 ca 7c 10 80       	push   $0x80107cca
801025e3:	e8 88 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 f5 7c 10 80       	push   $0x80107cf5
801025f0:	e8 7b dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025f5:	83 ec 0c             	sub    $0xc,%esp
801025f8:	68 e0 7c 10 80       	push   $0x80107ce0
801025fd:	e8 6e dd ff ff       	call   80100370 <panic>
80102602:	66 90                	xchg   %ax,%ax
80102604:	66 90                	xchg   %ax,%ax
80102606:	66 90                	xchg   %ax,%ax
80102608:	66 90                	xchg   %ax,%ax
8010260a:	66 90                	xchg   %ax,%ax
8010260c:	66 90                	xchg   %ax,%ax
8010260e:	66 90                	xchg   %ax,%ax

80102610 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102610:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102611:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102618:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010261b:	89 e5                	mov    %esp,%ebp
8010261d:	56                   	push   %esi
8010261e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010261f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102626:	00 00 00 
  return ioapic->data;
80102629:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010262f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102632:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102638:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010263e:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102645:	89 f0                	mov    %esi,%eax
80102647:	c1 e8 10             	shr    $0x10,%eax
8010264a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010264d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102650:	c1 e8 18             	shr    $0x18,%eax
80102653:	39 d0                	cmp    %edx,%eax
80102655:	74 16                	je     8010266d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 14 7d 10 80       	push   $0x80107d14
8010265f:	e8 fc df ff ff       	call   80100660 <cprintf>
80102664:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010266a:	83 c4 10             	add    $0x10,%esp
8010266d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102670:	ba 10 00 00 00       	mov    $0x10,%edx
80102675:	b8 20 00 00 00       	mov    $0x20,%eax
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102680:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102682:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102688:	89 c3                	mov    %eax,%ebx
8010268a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102690:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102693:	89 59 10             	mov    %ebx,0x10(%ecx)
80102696:	8d 5a 01             	lea    0x1(%edx),%ebx
80102699:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010269c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010269e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801026a0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801026a6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801026ad:	75 d1                	jne    80102680 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b2:	5b                   	pop    %ebx
801026b3:	5e                   	pop    %esi
801026b4:	5d                   	pop    %ebp
801026b5:	c3                   	ret    
801026b6:	8d 76 00             	lea    0x0(%esi),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026c0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026c1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801026c7:	89 e5                	mov    %esp,%ebp
801026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026cc:	8d 50 20             	lea    0x20(%eax),%edx
801026cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026d5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026de:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026e1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026e6:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026eb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801026ee:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret    
801026f3:	66 90                	xchg   %ax,%ax
801026f5:	66 90                	xchg   %ax,%ax
801026f7:	66 90                	xchg   %ax,%ax
801026f9:	66 90                	xchg   %ax,%ax
801026fb:	66 90                	xchg   %ax,%ax
801026fd:	66 90                	xchg   %ax,%ax
801026ff:	90                   	nop

80102700 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
80102707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010270a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102710:	75 70                	jne    80102782 <kfree+0x82>
80102712:	81 fb a8 6c 11 80    	cmp    $0x80116ca8,%ebx
80102718:	72 68                	jb     80102782 <kfree+0x82>
8010271a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102720:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102725:	77 5b                	ja     80102782 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102727:	83 ec 04             	sub    $0x4,%esp
8010272a:	68 00 10 00 00       	push   $0x1000
8010272f:	6a 01                	push   $0x1
80102731:	53                   	push   %ebx
80102732:	e8 39 26 00 00       	call   80104d70 <memset>

  if(kmem.use_lock)
80102737:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	85 d2                	test   %edx,%edx
80102742:	75 2c                	jne    80102770 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102744:	a1 78 36 11 80       	mov    0x80113678,%eax
80102749:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010274b:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102750:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102756:	85 c0                	test   %eax,%eax
80102758:	75 06                	jne    80102760 <kfree+0x60>
    release(&kmem.lock);
}
8010275a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010275d:	c9                   	leave  
8010275e:	c3                   	ret    
8010275f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102760:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010276b:	e9 b0 25 00 00       	jmp    80104d20 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	68 40 36 11 80       	push   $0x80113640
80102778:	e8 f3 24 00 00       	call   80104c70 <acquire>
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	eb c2                	jmp    80102744 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102782:	83 ec 0c             	sub    $0xc,%esp
80102785:	68 46 7d 10 80       	push   $0x80107d46
8010278a:	e8 e1 db ff ff       	call   80100370 <panic>
8010278f:	90                   	nop

80102790 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102795:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102798:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010279b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ad:	39 de                	cmp    %ebx,%esi
801027af:	72 23                	jb     801027d4 <freerange+0x44>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027be:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027c7:	50                   	push   %eax
801027c8:	e8 33 ff ff ff       	call   80102700 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	39 f3                	cmp    %esi,%ebx
801027d2:	76 e4                	jbe    801027b8 <freerange+0x28>
    kfree(p);
}
801027d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027d7:	5b                   	pop    %ebx
801027d8:	5e                   	pop    %esi
801027d9:	5d                   	pop    %ebp
801027da:	c3                   	ret    
801027db:	90                   	nop
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	56                   	push   %esi
801027e4:	53                   	push   %ebx
801027e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027e8:	83 ec 08             	sub    $0x8,%esp
801027eb:	68 4c 7d 10 80       	push   $0x80107d4c
801027f0:	68 40 36 11 80       	push   $0x80113640
801027f5:	e8 16 23 00 00       	call   80104b10 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027fd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102800:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102807:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010280a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102810:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102816:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010281c:	39 de                	cmp    %ebx,%esi
8010281e:	72 1c                	jb     8010283c <kinit1+0x5c>
    kfree(p);
80102820:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102826:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102829:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010282f:	50                   	push   %eax
80102830:	e8 cb fe ff ff       	call   80102700 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102835:	83 c4 10             	add    $0x10,%esp
80102838:	39 de                	cmp    %ebx,%esi
8010283a:	73 e4                	jae    80102820 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010283c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010283f:	5b                   	pop    %ebx
80102840:	5e                   	pop    %esi
80102841:	5d                   	pop    %ebp
80102842:	c3                   	ret    
80102843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	56                   	push   %esi
80102854:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102855:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102858:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010285b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102861:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102867:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010286d:	39 de                	cmp    %ebx,%esi
8010286f:	72 23                	jb     80102894 <kinit2+0x44>
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102878:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010287e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102881:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102887:	50                   	push   %eax
80102888:	e8 73 fe ff ff       	call   80102700 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010288d:	83 c4 10             	add    $0x10,%esp
80102890:	39 de                	cmp    %ebx,%esi
80102892:	73 e4                	jae    80102878 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102894:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010289b:	00 00 00 
}
8010289e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028a1:	5b                   	pop    %ebx
801028a2:	5e                   	pop    %esi
801028a3:	5d                   	pop    %ebp
801028a4:	c3                   	ret    
801028a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	53                   	push   %ebx
801028b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801028b7:	a1 74 36 11 80       	mov    0x80113674,%eax
801028bc:	85 c0                	test   %eax,%eax
801028be:	75 30                	jne    801028f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801028c0:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801028c6:	85 db                	test   %ebx,%ebx
801028c8:	74 1c                	je     801028e6 <kalloc+0x36>
    kmem.freelist = r->next;
801028ca:	8b 13                	mov    (%ebx),%edx
801028cc:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801028d2:	85 c0                	test   %eax,%eax
801028d4:	74 10                	je     801028e6 <kalloc+0x36>
    release(&kmem.lock);
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	68 40 36 11 80       	push   $0x80113640
801028de:	e8 3d 24 00 00       	call   80104d20 <release>
801028e3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801028e6:	89 d8                	mov    %ebx,%eax
801028e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028eb:	c9                   	leave  
801028ec:	c3                   	ret    
801028ed:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801028f0:	83 ec 0c             	sub    $0xc,%esp
801028f3:	68 40 36 11 80       	push   $0x80113640
801028f8:	e8 73 23 00 00       	call   80104c70 <acquire>
  r = kmem.freelist;
801028fd:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102903:	83 c4 10             	add    $0x10,%esp
80102906:	a1 74 36 11 80       	mov    0x80113674,%eax
8010290b:	85 db                	test   %ebx,%ebx
8010290d:	75 bb                	jne    801028ca <kalloc+0x1a>
8010290f:	eb c1                	jmp    801028d2 <kalloc+0x22>
80102911:	66 90                	xchg   %ax,%ax
80102913:	66 90                	xchg   %ax,%ax
80102915:	66 90                	xchg   %ax,%ax
80102917:	66 90                	xchg   %ax,%ax
80102919:	66 90                	xchg   %ax,%ax
8010291b:	66 90                	xchg   %ax,%ax
8010291d:	66 90                	xchg   %ax,%ax
8010291f:	90                   	nop

80102920 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102920:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102921:	ba 64 00 00 00       	mov    $0x64,%edx
80102926:	89 e5                	mov    %esp,%ebp
80102928:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102929:	a8 01                	test   $0x1,%al
8010292b:	0f 84 af 00 00 00    	je     801029e0 <kbdgetc+0xc0>
80102931:	ba 60 00 00 00       	mov    $0x60,%edx
80102936:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102937:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010293a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102940:	74 7e                	je     801029c0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102942:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102944:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010294a:	79 24                	jns    80102970 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010294c:	f6 c1 40             	test   $0x40,%cl
8010294f:	75 05                	jne    80102956 <kbdgetc+0x36>
80102951:	89 c2                	mov    %eax,%edx
80102953:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102956:	0f b6 82 80 7e 10 80 	movzbl -0x7fef8180(%edx),%eax
8010295d:	83 c8 40             	or     $0x40,%eax
80102960:	0f b6 c0             	movzbl %al,%eax
80102963:	f7 d0                	not    %eax
80102965:	21 c8                	and    %ecx,%eax
80102967:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010296c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010296e:	5d                   	pop    %ebp
8010296f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102970:	f6 c1 40             	test   $0x40,%cl
80102973:	74 09                	je     8010297e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102975:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102978:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010297b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010297e:	0f b6 82 80 7e 10 80 	movzbl -0x7fef8180(%edx),%eax
80102985:	09 c1                	or     %eax,%ecx
80102987:	0f b6 82 80 7d 10 80 	movzbl -0x7fef8280(%edx),%eax
8010298e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102990:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102992:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102998:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010299b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010299e:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
801029a5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029a9:	74 c3                	je     8010296e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801029ab:	8d 50 9f             	lea    -0x61(%eax),%edx
801029ae:	83 fa 19             	cmp    $0x19,%edx
801029b1:	77 1d                	ja     801029d0 <kbdgetc+0xb0>
      c += 'A' - 'a';
801029b3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029b6:	5d                   	pop    %ebp
801029b7:	c3                   	ret    
801029b8:	90                   	nop
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801029c0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801029c2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029c9:	5d                   	pop    %ebp
801029ca:	c3                   	ret    
801029cb:	90                   	nop
801029cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801029d0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029d3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801029d6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801029d7:	83 f9 19             	cmp    $0x19,%ecx
801029da:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801029dd:	c3                   	ret    
801029de:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801029e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029e5:	5d                   	pop    %ebp
801029e6:	c3                   	ret    
801029e7:	89 f6                	mov    %esi,%esi
801029e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029f0 <kbdintr>:

void
kbdintr(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029f6:	68 20 29 10 80       	push   $0x80102920
801029fb:	e8 f0 dd ff ff       	call   801007f0 <consoleintr>
}
80102a00:	83 c4 10             	add    $0x10,%esp
80102a03:	c9                   	leave  
80102a04:	c3                   	ret    
80102a05:	66 90                	xchg   %ax,%ax
80102a07:	66 90                	xchg   %ax,%ax
80102a09:	66 90                	xchg   %ax,%ax
80102a0b:	66 90                	xchg   %ax,%ax
80102a0d:	66 90                	xchg   %ax,%ax
80102a0f:	90                   	nop

80102a10 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a10:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102a15:	55                   	push   %ebp
80102a16:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a18:	85 c0                	test   %eax,%eax
80102a1a:	0f 84 c8 00 00 00    	je     80102ae8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a20:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a27:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a2d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a3a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a41:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a44:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a47:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a4e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a51:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a54:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a5b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a61:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a68:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a6e:	8b 50 30             	mov    0x30(%eax),%edx
80102a71:	c1 ea 10             	shr    $0x10,%edx
80102a74:	80 fa 03             	cmp    $0x3,%dl
80102a77:	77 77                	ja     80102af0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a79:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a86:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a8d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a90:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a93:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a9a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aa0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102aa7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aaa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ab4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ac1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac4:	8b 50 20             	mov    0x20(%eax),%edx
80102ac7:	89 f6                	mov    %esi,%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ad0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ad6:	80 e6 10             	and    $0x10,%dh
80102ad9:	75 f5                	jne    80102ad0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102adb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ae2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ae8:	5d                   	pop    %ebp
80102ae9:	c3                   	ret    
80102aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102af0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102af7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102afa:	8b 50 20             	mov    0x20(%eax),%edx
80102afd:	e9 77 ff ff ff       	jmp    80102a79 <lapicinit+0x69>
80102b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b10 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102b10:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102b15:	55                   	push   %ebp
80102b16:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b18:	85 c0                	test   %eax,%eax
80102b1a:	74 0c                	je     80102b28 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102b1c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102b1f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102b20:	c1 e8 18             	shr    $0x18,%eax
}
80102b23:	c3                   	ret    
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102b28:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102b2a:	5d                   	pop    %ebp
80102b2b:	c3                   	ret    
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b30:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b35:	55                   	push   %ebp
80102b36:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b38:	85 c0                	test   %eax,%eax
80102b3a:	74 0d                	je     80102b49 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b3c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b43:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b46:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102b49:	5d                   	pop    %ebp
80102b4a:	c3                   	ret    
80102b4b:	90                   	nop
80102b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b50 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
}
80102b53:	5d                   	pop    %ebp
80102b54:	c3                   	ret    
80102b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b60:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b61:	ba 70 00 00 00       	mov    $0x70,%edx
80102b66:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b6b:	89 e5                	mov    %esp,%ebp
80102b6d:	53                   	push   %ebx
80102b6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b74:	ee                   	out    %al,(%dx)
80102b75:	ba 71 00 00 00       	mov    $0x71,%edx
80102b7a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b7f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b80:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b82:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b85:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b8b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b8d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b90:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b93:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b95:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b98:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b9e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102ba3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bb3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bb9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bc0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bc6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bcc:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bcf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bd5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bd8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bde:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102be1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102be7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102bea:	5b                   	pop    %ebx
80102beb:	5d                   	pop    %ebp
80102bec:	c3                   	ret    
80102bed:	8d 76 00             	lea    0x0(%esi),%esi

80102bf0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bf0:	55                   	push   %ebp
80102bf1:	ba 70 00 00 00       	mov    $0x70,%edx
80102bf6:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bfb:	89 e5                	mov    %esp,%ebp
80102bfd:	57                   	push   %edi
80102bfe:	56                   	push   %esi
80102bff:	53                   	push   %ebx
80102c00:	83 ec 4c             	sub    $0x4c,%esp
80102c03:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c04:	ba 71 00 00 00       	mov    $0x71,%edx
80102c09:	ec                   	in     (%dx),%al
80102c0a:	83 e0 04             	and    $0x4,%eax
80102c0d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c10:	31 db                	xor    %ebx,%ebx
80102c12:	88 45 b7             	mov    %al,-0x49(%ebp)
80102c15:	bf 70 00 00 00       	mov    $0x70,%edi
80102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c20:	89 d8                	mov    %ebx,%eax
80102c22:	89 fa                	mov    %edi,%edx
80102c24:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c25:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c2a:	89 ca                	mov    %ecx,%edx
80102c2c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c2d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c30:	89 fa                	mov    %edi,%edx
80102c32:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c35:	b8 02 00 00 00       	mov    $0x2,%eax
80102c3a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3b:	89 ca                	mov    %ecx,%edx
80102c3d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c3e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c41:	89 fa                	mov    %edi,%edx
80102c43:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c46:	b8 04 00 00 00       	mov    $0x4,%eax
80102c4b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4c:	89 ca                	mov    %ecx,%edx
80102c4e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c4f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c52:	89 fa                	mov    %edi,%edx
80102c54:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c57:	b8 07 00 00 00       	mov    $0x7,%eax
80102c5c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5d:	89 ca                	mov    %ecx,%edx
80102c5f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c60:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c63:	89 fa                	mov    %edi,%edx
80102c65:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c68:	b8 08 00 00 00       	mov    $0x8,%eax
80102c6d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6e:	89 ca                	mov    %ecx,%edx
80102c70:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c71:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c74:	89 fa                	mov    %edi,%edx
80102c76:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c79:	b8 09 00 00 00       	mov    $0x9,%eax
80102c7e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7f:	89 ca                	mov    %ecx,%edx
80102c81:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c82:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c85:	89 fa                	mov    %edi,%edx
80102c87:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c8a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c8f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c90:	89 ca                	mov    %ecx,%edx
80102c92:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c93:	84 c0                	test   %al,%al
80102c95:	78 89                	js     80102c20 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c97:	89 d8                	mov    %ebx,%eax
80102c99:	89 fa                	mov    %edi,%edx
80102c9b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9c:	89 ca                	mov    %ecx,%edx
80102c9e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c9f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca2:	89 fa                	mov    %edi,%edx
80102ca4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ca7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102cb0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb3:	89 fa                	mov    %edi,%edx
80102cb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cbd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102cc1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 fa                	mov    %edi,%edx
80102cc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccf:	89 ca                	mov    %ecx,%edx
80102cd1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102cd2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd5:	89 fa                	mov    %edi,%edx
80102cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cda:	b8 08 00 00 00       	mov    $0x8,%eax
80102cdf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce0:	89 ca                	mov    %ecx,%edx
80102ce2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102ce3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce6:	89 fa                	mov    %edi,%edx
80102ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ceb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cf0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf1:	89 ca                	mov    %ecx,%edx
80102cf3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102cf4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cf7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cfd:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d00:	6a 18                	push   $0x18
80102d02:	56                   	push   %esi
80102d03:	50                   	push   %eax
80102d04:	e8 b7 20 00 00       	call   80104dc0 <memcmp>
80102d09:	83 c4 10             	add    $0x10,%esp
80102d0c:	85 c0                	test   %eax,%eax
80102d0e:	0f 85 0c ff ff ff    	jne    80102c20 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102d14:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102d18:	75 78                	jne    80102d92 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d1a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d1d:	89 c2                	mov    %eax,%edx
80102d1f:	83 e0 0f             	and    $0xf,%eax
80102d22:	c1 ea 04             	shr    $0x4,%edx
80102d25:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d28:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d2e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d31:	89 c2                	mov    %eax,%edx
80102d33:	83 e0 0f             	and    $0xf,%eax
80102d36:	c1 ea 04             	shr    $0x4,%edx
80102d39:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d42:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d45:	89 c2                	mov    %eax,%edx
80102d47:	83 e0 0f             	and    $0xf,%eax
80102d4a:	c1 ea 04             	shr    $0x4,%edx
80102d4d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d50:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d53:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d59:	89 c2                	mov    %eax,%edx
80102d5b:	83 e0 0f             	and    $0xf,%eax
80102d5e:	c1 ea 04             	shr    $0x4,%edx
80102d61:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d64:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d67:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d6d:	89 c2                	mov    %eax,%edx
80102d6f:	83 e0 0f             	and    $0xf,%eax
80102d72:	c1 ea 04             	shr    $0x4,%edx
80102d75:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d78:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d81:	89 c2                	mov    %eax,%edx
80102d83:	83 e0 0f             	and    $0xf,%eax
80102d86:	c1 ea 04             	shr    $0x4,%edx
80102d89:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d8f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d92:	8b 75 08             	mov    0x8(%ebp),%esi
80102d95:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d98:	89 06                	mov    %eax,(%esi)
80102d9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d9d:	89 46 04             	mov    %eax,0x4(%esi)
80102da0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102da3:	89 46 08             	mov    %eax,0x8(%esi)
80102da6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102da9:	89 46 0c             	mov    %eax,0xc(%esi)
80102dac:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102daf:	89 46 10             	mov    %eax,0x10(%esi)
80102db2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102db8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc2:	5b                   	pop    %ebx
80102dc3:	5e                   	pop    %esi
80102dc4:	5f                   	pop    %edi
80102dc5:	5d                   	pop    %ebp
80102dc6:	c3                   	ret    
80102dc7:	66 90                	xchg   %ax,%ax
80102dc9:	66 90                	xchg   %ax,%ax
80102dcb:	66 90                	xchg   %ax,%ax
80102dcd:	66 90                	xchg   %ax,%ax
80102dcf:	90                   	nop

80102dd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dd0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dd6:	85 c9                	test   %ecx,%ecx
80102dd8:	0f 8e 85 00 00 00    	jle    80102e63 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102dde:	55                   	push   %ebp
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	57                   	push   %edi
80102de2:	56                   	push   %esi
80102de3:	53                   	push   %ebx
80102de4:	31 db                	xor    %ebx,%ebx
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102df0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102df5:	83 ec 08             	sub    $0x8,%esp
80102df8:	01 d8                	add    %ebx,%eax
80102dfa:	83 c0 01             	add    $0x1,%eax
80102dfd:	50                   	push   %eax
80102dfe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e04:	e8 c7 d2 ff ff       	call   801000d0 <bread>
80102e09:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e0b:	58                   	pop    %eax
80102e0c:	5a                   	pop    %edx
80102e0d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e14:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e1d:	e8 ae d2 ff ff       	call   801000d0 <bread>
80102e22:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e24:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e27:	83 c4 0c             	add    $0xc,%esp
80102e2a:	68 00 02 00 00       	push   $0x200
80102e2f:	50                   	push   %eax
80102e30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e33:	50                   	push   %eax
80102e34:	e8 e7 1f 00 00       	call   80104e20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e39:	89 34 24             	mov    %esi,(%esp)
80102e3c:	e8 5f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e41:	89 3c 24             	mov    %edi,(%esp)
80102e44:	e8 97 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e49:	89 34 24             	mov    %esi,(%esp)
80102e4c:	e8 8f d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102e5a:	7f 94                	jg     80102df0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	f3 c3                	repz ret 
80102e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e77:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e7d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e83:	e8 48 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e88:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e8e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e91:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e93:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e95:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e98:	7e 1f                	jle    80102eb9 <write_head+0x49>
80102e9a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ea1:	31 d2                	xor    %edx,%edx
80102ea3:	90                   	nop
80102ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ea8:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102eae:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102eb2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102eb5:	39 c2                	cmp    %eax,%edx
80102eb7:	75 ef                	jne    80102ea8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102eb9:	83 ec 0c             	sub    $0xc,%esp
80102ebc:	53                   	push   %ebx
80102ebd:	e8 de d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ec2:	89 1c 24             	mov    %ebx,(%esp)
80102ec5:	e8 16 d3 ff ff       	call   801001e0 <brelse>
}
80102eca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ecd:	c9                   	leave  
80102ece:	c3                   	ret    
80102ecf:	90                   	nop

80102ed0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 2c             	sub    $0x2c,%esp
80102ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102eda:	68 80 7f 10 80       	push   $0x80107f80
80102edf:	68 80 36 11 80       	push   $0x80113680
80102ee4:	e8 27 1c 00 00       	call   80104b10 <initlock>
  readsb(dev, &sb);
80102ee9:	58                   	pop    %eax
80102eea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102eed:	5a                   	pop    %edx
80102eee:	50                   	push   %eax
80102eef:	53                   	push   %ebx
80102ef0:	e8 5b e9 ff ff       	call   80101850 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ef5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102efb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102efc:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f02:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f08:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 bb d1 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f15:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f18:	83 c4 10             	add    $0x10,%esp
80102f1b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f1d:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102f23:	7e 1c                	jle    80102f41 <initlog+0x71>
80102f25:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102f2c:	31 d2                	xor    %edx,%edx
80102f2e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f30:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f34:	83 c2 04             	add    $0x4,%edx
80102f37:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102f3d:	39 da                	cmp    %ebx,%edx
80102f3f:	75 ef                	jne    80102f30 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102f41:	83 ec 0c             	sub    $0xc,%esp
80102f44:	50                   	push   %eax
80102f45:	e8 96 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f4a:	e8 81 fe ff ff       	call   80102dd0 <install_trans>
  log.lh.n = 0;
80102f4f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f56:	00 00 00 
  write_head(); // clear the log
80102f59:	e8 12 ff ff ff       	call   80102e70 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f61:	c9                   	leave  
80102f62:	c3                   	ret    
80102f63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f76:	68 80 36 11 80       	push   $0x80113680
80102f7b:	e8 f0 1c 00 00       	call   80104c70 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 80 36 11 80       	push   $0x80113680
80102f90:	68 80 36 11 80       	push   $0x80113680
80102f95:	e8 c6 16 00 00       	call   80104660 <sleep>
80102f9a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f9d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	75 e2                	jne    80102f88 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fa6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102fab:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102fb1:	83 c0 01             	add    $0x1,%eax
80102fb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fba:	83 fa 1e             	cmp    $0x1e,%edx
80102fbd:	7f c9                	jg     80102f88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fbf:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102fc2:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102fc7:	68 80 36 11 80       	push   $0x80113680
80102fcc:	e8 4f 1d 00 00       	call   80104d20 <release>
      break;
    }
  }
}
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	c9                   	leave  
80102fd5:	c3                   	ret    
80102fd6:	8d 76 00             	lea    0x0(%esi),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fe9:	68 80 36 11 80       	push   $0x80113680
80102fee:	e8 7d 1c 00 00       	call   80104c70 <acquire>
  log.outstanding -= 1;
80102ff3:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102ff8:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102ffe:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103001:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80103004:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103006:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
8010300b:	0f 85 23 01 00 00    	jne    80103134 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103011:	85 c0                	test   %eax,%eax
80103013:	0f 85 f7 00 00 00    	jne    80103110 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103019:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
8010301c:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80103023:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80103026:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103028:	68 80 36 11 80       	push   $0x80113680
8010302d:	e8 ee 1c 00 00       	call   80104d20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103032:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103038:	83 c4 10             	add    $0x10,%esp
8010303b:	85 c9                	test   %ecx,%ecx
8010303d:	0f 8e 8a 00 00 00    	jle    801030cd <end_op+0xed>
80103043:	90                   	nop
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103048:	a1 b4 36 11 80       	mov    0x801136b4,%eax
8010304d:	83 ec 08             	sub    $0x8,%esp
80103050:	01 d8                	add    %ebx,%eax
80103052:	83 c0 01             	add    $0x1,%eax
80103055:	50                   	push   %eax
80103056:	ff 35 c4 36 11 80    	pushl  0x801136c4
8010305c:	e8 6f d0 ff ff       	call   801000d0 <bread>
80103061:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103063:	58                   	pop    %eax
80103064:	5a                   	pop    %edx
80103065:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
8010306c:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103072:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103075:	e8 56 d0 ff ff       	call   801000d0 <bread>
8010307a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010307c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010307f:	83 c4 0c             	add    $0xc,%esp
80103082:	68 00 02 00 00       	push   $0x200
80103087:	50                   	push   %eax
80103088:	8d 46 5c             	lea    0x5c(%esi),%eax
8010308b:	50                   	push   %eax
8010308c:	e8 8f 1d 00 00       	call   80104e20 <memmove>
    bwrite(to);  // write the log
80103091:	89 34 24             	mov    %esi,(%esp)
80103094:	e8 07 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103099:	89 3c 24             	mov    %edi,(%esp)
8010309c:	e8 3f d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030a1:	89 34 24             	mov    %esi,(%esp)
801030a4:	e8 37 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
801030b2:	7c 94                	jl     80103048 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030b4:	e8 b7 fd ff ff       	call   80102e70 <write_head>
    install_trans(); // Now install writes to home locations
801030b9:	e8 12 fd ff ff       	call   80102dd0 <install_trans>
    log.lh.n = 0;
801030be:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
801030c5:	00 00 00 
    write_head();    // Erase the transaction from the log
801030c8:	e8 a3 fd ff ff       	call   80102e70 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
801030cd:	83 ec 0c             	sub    $0xc,%esp
801030d0:	68 80 36 11 80       	push   $0x80113680
801030d5:	e8 96 1b 00 00       	call   80104c70 <acquire>
    log.committing = 0;
    wakeup(&log);
801030da:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
801030e1:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
801030e8:	00 00 00 
    wakeup(&log);
801030eb:	e8 40 17 00 00       	call   80104830 <wakeup>
    release(&log.lock);
801030f0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030f7:	e8 24 1c 00 00       	call   80104d20 <release>
801030fc:	83 c4 10             	add    $0x10,%esp
  }
}
801030ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103102:	5b                   	pop    %ebx
80103103:	5e                   	pop    %esi
80103104:	5f                   	pop    %edi
80103105:	5d                   	pop    %ebp
80103106:	c3                   	ret    
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103110:	83 ec 0c             	sub    $0xc,%esp
80103113:	68 80 36 11 80       	push   $0x80113680
80103118:	e8 13 17 00 00       	call   80104830 <wakeup>
  }
  release(&log.lock);
8010311d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103124:	e8 f7 1b 00 00       	call   80104d20 <release>
80103129:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
8010312c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312f:	5b                   	pop    %ebx
80103130:	5e                   	pop    %esi
80103131:	5f                   	pop    %edi
80103132:	5d                   	pop    %ebp
80103133:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80103134:	83 ec 0c             	sub    $0xc,%esp
80103137:	68 84 7f 10 80       	push   $0x80107f84
8010313c:	e8 2f d2 ff ff       	call   80100370 <panic>
80103141:	eb 0d                	jmp    80103150 <log_write>
80103143:	90                   	nop
80103144:	90                   	nop
80103145:	90                   	nop
80103146:	90                   	nop
80103147:	90                   	nop
80103148:	90                   	nop
80103149:	90                   	nop
8010314a:	90                   	nop
8010314b:	90                   	nop
8010314c:	90                   	nop
8010314d:	90                   	nop
8010314e:	90                   	nop
8010314f:	90                   	nop

80103150 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103157:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010315d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103160:	83 fa 1d             	cmp    $0x1d,%edx
80103163:	0f 8f 97 00 00 00    	jg     80103200 <log_write+0xb0>
80103169:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010316e:	83 e8 01             	sub    $0x1,%eax
80103171:	39 c2                	cmp    %eax,%edx
80103173:	0f 8d 87 00 00 00    	jge    80103200 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103179:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010317e:	85 c0                	test   %eax,%eax
80103180:	0f 8e 87 00 00 00    	jle    8010320d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103186:	83 ec 0c             	sub    $0xc,%esp
80103189:	68 80 36 11 80       	push   $0x80113680
8010318e:	e8 dd 1a 00 00       	call   80104c70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103193:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	83 fa 00             	cmp    $0x0,%edx
8010319f:	7e 50                	jle    801031f1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031a1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031a4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031a6:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
801031ac:	75 0b                	jne    801031b9 <log_write+0x69>
801031ae:	eb 38                	jmp    801031e8 <log_write+0x98>
801031b0:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
801031b7:	74 2f                	je     801031e8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031b9:	83 c0 01             	add    $0x1,%eax
801031bc:	39 d0                	cmp    %edx,%eax
801031be:	75 f0                	jne    801031b0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801031c0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
801031c7:	83 c2 01             	add    $0x1,%edx
801031ca:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
801031d0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031d3:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
801031da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031dd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
801031de:	e9 3d 1b 00 00       	jmp    80104d20 <release>
801031e3:	90                   	nop
801031e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801031e8:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
801031ef:	eb df                	jmp    801031d0 <log_write+0x80>
801031f1:	8b 43 08             	mov    0x8(%ebx),%eax
801031f4:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
801031f9:	75 d5                	jne    801031d0 <log_write+0x80>
801031fb:	eb ca                	jmp    801031c7 <log_write+0x77>
801031fd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 93 7f 10 80       	push   $0x80107f93
80103208:	e8 63 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 a9 7f 10 80       	push   $0x80107fa9
80103215:	e8 56 d1 ff ff       	call   80100370 <panic>
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	53                   	push   %ebx
80103224:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103227:	e8 b4 09 00 00       	call   80103be0 <cpuid>
8010322c:	89 c3                	mov    %eax,%ebx
8010322e:	e8 ad 09 00 00       	call   80103be0 <cpuid>
80103233:	83 ec 04             	sub    $0x4,%esp
80103236:	53                   	push   %ebx
80103237:	50                   	push   %eax
80103238:	68 c4 7f 10 80       	push   $0x80107fc4
8010323d:	e8 1e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103242:	e8 89 30 00 00       	call   801062d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103247:	e8 14 09 00 00       	call   80103b60 <mycpu>
8010324c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010324e:	b8 01 00 00 00       	mov    $0x1,%eax
80103253:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010325a:	e8 01 0d 00 00       	call   80103f60 <scheduler>
8010325f:	90                   	nop

80103260 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103266:	e8 a5 41 00 00       	call   80107410 <switchkvm>
  seginit();
8010326b:	e8 d0 3e 00 00       	call   80107140 <seginit>
  lapicinit();
80103270:	e8 9b f7 ff ff       	call   80102a10 <lapicinit>
  mpmain();
80103275:	e8 a6 ff ff ff       	call   80103220 <mpmain>
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103280:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103284:	83 e4 f0             	and    $0xfffffff0,%esp
80103287:	ff 71 fc             	pushl  -0x4(%ecx)
8010328a:	55                   	push   %ebp
8010328b:	89 e5                	mov    %esp,%ebp
8010328d:	53                   	push   %ebx
8010328e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010328f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103294:	83 ec 08             	sub    $0x8,%esp
80103297:	68 00 00 40 80       	push   $0x80400000
8010329c:	68 a8 6c 11 80       	push   $0x80116ca8
801032a1:	e8 3a f5 ff ff       	call   801027e0 <kinit1>
  kvmalloc();      // kernel page table
801032a6:	e8 05 46 00 00       	call   801078b0 <kvmalloc>
  mpinit();        // detect other processors
801032ab:	e8 70 01 00 00       	call   80103420 <mpinit>
  lapicinit();     // interrupt controller
801032b0:	e8 5b f7 ff ff       	call   80102a10 <lapicinit>
  seginit();       // segment descriptors
801032b5:	e8 86 3e 00 00       	call   80107140 <seginit>
  picinit();       // disable pic
801032ba:	e8 31 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
801032bf:	e8 4c f3 ff ff       	call   80102610 <ioapicinit>
  consoleinit();   // console hardware
801032c4:	e8 d7 d6 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
801032c9:	e8 f2 32 00 00       	call   801065c0 <uartinit>
  pinit();         // process table
801032ce:	e8 6d 08 00 00       	call   80103b40 <pinit>
  tvinit();        // trap vectors
801032d3:	e8 58 2f 00 00       	call   80106230 <tvinit>
  binit();         // buffer cache
801032d8:	e8 63 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032dd:	e8 9e de ff ff       	call   80101180 <fileinit>
  ideinit();       // disk 
801032e2:	e8 09 f1 ff ff       	call   801023f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032e7:	83 c4 0c             	add    $0xc,%esp
801032ea:	68 8a 00 00 00       	push   $0x8a
801032ef:	68 8c b4 10 80       	push   $0x8010b48c
801032f4:	68 00 70 00 80       	push   $0x80007000
801032f9:	e8 22 1b 00 00       	call   80104e20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032fe:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103305:	00 00 00 
80103308:	83 c4 10             	add    $0x10,%esp
8010330b:	05 80 37 11 80       	add    $0x80113780,%eax
80103310:	39 d8                	cmp    %ebx,%eax
80103312:	76 6f                	jbe    80103383 <main+0x103>
80103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103318:	e8 43 08 00 00       	call   80103b60 <mycpu>
8010331d:	39 d8                	cmp    %ebx,%eax
8010331f:	74 49                	je     8010336a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103321:	e8 8a f5 ff ff       	call   801028b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103326:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
8010332b:	c7 05 f8 6f 00 80 60 	movl   $0x80103260,0x80006ff8
80103332:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103335:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010333c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010333f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103344:	0f b6 03             	movzbl (%ebx),%eax
80103347:	83 ec 08             	sub    $0x8,%esp
8010334a:	68 00 70 00 00       	push   $0x7000
8010334f:	50                   	push   %eax
80103350:	e8 0b f8 ff ff       	call   80102b60 <lapicstartap>
80103355:	83 c4 10             	add    $0x10,%esp
80103358:	90                   	nop
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103360:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103366:	85 c0                	test   %eax,%eax
80103368:	74 f6                	je     80103360 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010336a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103371:	00 00 00 
80103374:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010337a:	05 80 37 11 80       	add    $0x80113780,%eax
8010337f:	39 c3                	cmp    %eax,%ebx
80103381:	72 95                	jb     80103318 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103383:	83 ec 08             	sub    $0x8,%esp
80103386:	68 00 00 00 8e       	push   $0x8e000000
8010338b:	68 00 00 40 80       	push   $0x80400000
80103390:	e8 bb f4 ff ff       	call   80102850 <kinit2>
  userinit();      // first user process
80103395:	e8 96 08 00 00       	call   80103c30 <userinit>
  mpmain();        // finish this processor's setup
8010339a:	e8 81 fe ff ff       	call   80103220 <mpmain>
8010339f:	90                   	nop

801033a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033ab:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801033ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033af:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801033b2:	39 de                	cmp    %ebx,%esi
801033b4:	73 48                	jae    801033fe <mpsearch1+0x5e>
801033b6:	8d 76 00             	lea    0x0(%esi),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033c0:	83 ec 04             	sub    $0x4,%esp
801033c3:	8d 7e 10             	lea    0x10(%esi),%edi
801033c6:	6a 04                	push   $0x4
801033c8:	68 d8 7f 10 80       	push   $0x80107fd8
801033cd:	56                   	push   %esi
801033ce:	e8 ed 19 00 00       	call   80104dc0 <memcmp>
801033d3:	83 c4 10             	add    $0x10,%esp
801033d6:	85 c0                	test   %eax,%eax
801033d8:	75 1e                	jne    801033f8 <mpsearch1+0x58>
801033da:	8d 7e 10             	lea    0x10(%esi),%edi
801033dd:	89 f2                	mov    %esi,%edx
801033df:	31 c9                	xor    %ecx,%ecx
801033e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
801033e8:	0f b6 02             	movzbl (%edx),%eax
801033eb:	83 c2 01             	add    $0x1,%edx
801033ee:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801033f0:	39 fa                	cmp    %edi,%edx
801033f2:	75 f4                	jne    801033e8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033f4:	84 c9                	test   %cl,%cl
801033f6:	74 10                	je     80103408 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801033f8:	39 fb                	cmp    %edi,%ebx
801033fa:	89 fe                	mov    %edi,%esi
801033fc:	77 c2                	ja     801033c0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801033fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103401:	31 c0                	xor    %eax,%eax
}
80103403:	5b                   	pop    %ebx
80103404:	5e                   	pop    %esi
80103405:	5f                   	pop    %edi
80103406:	5d                   	pop    %ebp
80103407:	c3                   	ret    
80103408:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010340b:	89 f0                	mov    %esi,%eax
8010340d:	5b                   	pop    %ebx
8010340e:	5e                   	pop    %esi
8010340f:	5f                   	pop    %edi
80103410:	5d                   	pop    %ebp
80103411:	c3                   	ret    
80103412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103420 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103429:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103430:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103437:	c1 e0 08             	shl    $0x8,%eax
8010343a:	09 d0                	or     %edx,%eax
8010343c:	c1 e0 04             	shl    $0x4,%eax
8010343f:	85 c0                	test   %eax,%eax
80103441:	75 1b                	jne    8010345e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103443:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010344a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103451:	c1 e0 08             	shl    $0x8,%eax
80103454:	09 d0                	or     %edx,%eax
80103456:	c1 e0 0a             	shl    $0xa,%eax
80103459:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010345e:	ba 00 04 00 00       	mov    $0x400,%edx
80103463:	e8 38 ff ff ff       	call   801033a0 <mpsearch1>
80103468:	85 c0                	test   %eax,%eax
8010346a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010346d:	0f 84 37 01 00 00    	je     801035aa <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103476:	8b 58 04             	mov    0x4(%eax),%ebx
80103479:	85 db                	test   %ebx,%ebx
8010347b:	0f 84 43 01 00 00    	je     801035c4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103481:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103487:	83 ec 04             	sub    $0x4,%esp
8010348a:	6a 04                	push   $0x4
8010348c:	68 dd 7f 10 80       	push   $0x80107fdd
80103491:	56                   	push   %esi
80103492:	e8 29 19 00 00       	call   80104dc0 <memcmp>
80103497:	83 c4 10             	add    $0x10,%esp
8010349a:	85 c0                	test   %eax,%eax
8010349c:	0f 85 22 01 00 00    	jne    801035c4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801034a2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034a9:	3c 01                	cmp    $0x1,%al
801034ab:	74 08                	je     801034b5 <mpinit+0x95>
801034ad:	3c 04                	cmp    $0x4,%al
801034af:	0f 85 0f 01 00 00    	jne    801035c4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801034b5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034bc:	85 ff                	test   %edi,%edi
801034be:	74 21                	je     801034e1 <mpinit+0xc1>
801034c0:	31 d2                	xor    %edx,%edx
801034c2:	31 c0                	xor    %eax,%eax
801034c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801034c8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801034cf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034d0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034d3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034d5:	39 c7                	cmp    %eax,%edi
801034d7:	75 ef                	jne    801034c8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801034d9:	84 d2                	test   %dl,%dl
801034db:	0f 85 e3 00 00 00    	jne    801035c4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801034e1:	85 f6                	test   %esi,%esi
801034e3:	0f 84 db 00 00 00    	je     801035c4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034e9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034ef:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034fb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103501:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103506:	01 d6                	add    %edx,%esi
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103510:	39 c6                	cmp    %eax,%esi
80103512:	76 23                	jbe    80103537 <mpinit+0x117>
80103514:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103517:	80 fa 04             	cmp    $0x4,%dl
8010351a:	0f 87 c0 00 00 00    	ja     801035e0 <mpinit+0x1c0>
80103520:	ff 24 95 1c 80 10 80 	jmp    *-0x7fef7fe4(,%edx,4)
80103527:	89 f6                	mov    %esi,%esi
80103529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103530:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103533:	39 c6                	cmp    %eax,%esi
80103535:	77 dd                	ja     80103514 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103537:	85 db                	test   %ebx,%ebx
80103539:	0f 84 92 00 00 00    	je     801035d1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010353f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103542:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103546:	74 15                	je     8010355d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103548:	ba 22 00 00 00       	mov    $0x22,%edx
8010354d:	b8 70 00 00 00       	mov    $0x70,%eax
80103552:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103553:	ba 23 00 00 00       	mov    $0x23,%edx
80103558:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103559:	83 c8 01             	or     $0x1,%eax
8010355c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010355d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103560:	5b                   	pop    %ebx
80103561:	5e                   	pop    %esi
80103562:	5f                   	pop    %edi
80103563:	5d                   	pop    %ebp
80103564:	c3                   	ret    
80103565:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103568:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010356e:	83 f9 07             	cmp    $0x7,%ecx
80103571:	7f 19                	jg     8010358c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103573:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103577:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010357d:	83 c1 01             	add    $0x1,%ecx
80103580:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103586:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010358c:	83 c0 14             	add    $0x14,%eax
      continue;
8010358f:	e9 7c ff ff ff       	jmp    80103510 <mpinit+0xf0>
80103594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103598:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010359c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010359f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
801035a5:	e9 66 ff ff ff       	jmp    80103510 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035aa:	ba 00 00 01 00       	mov    $0x10000,%edx
801035af:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035b4:	e8 e7 fd ff ff       	call   801033a0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035b9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035be:	0f 85 af fe ff ff    	jne    80103473 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801035c4:	83 ec 0c             	sub    $0xc,%esp
801035c7:	68 e2 7f 10 80       	push   $0x80107fe2
801035cc:	e8 9f cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801035d1:	83 ec 0c             	sub    $0xc,%esp
801035d4:	68 fc 7f 10 80       	push   $0x80107ffc
801035d9:	e8 92 cd ff ff       	call   80100370 <panic>
801035de:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801035e0:	31 db                	xor    %ebx,%ebx
801035e2:	e9 30 ff ff ff       	jmp    80103517 <mpinit+0xf7>
801035e7:	66 90                	xchg   %ax,%ax
801035e9:	66 90                	xchg   %ax,%ax
801035eb:	66 90                	xchg   %ax,%ax
801035ed:	66 90                	xchg   %ax,%ax
801035ef:	90                   	nop

801035f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035f0:	55                   	push   %ebp
801035f1:	ba 21 00 00 00       	mov    $0x21,%edx
801035f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035fb:	89 e5                	mov    %esp,%ebp
801035fd:	ee                   	out    %al,(%dx)
801035fe:	ba a1 00 00 00       	mov    $0xa1,%edx
80103603:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103604:	5d                   	pop    %ebp
80103605:	c3                   	ret    
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	8b 75 08             	mov    0x8(%ebp),%esi
8010361c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010361f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103625:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010362b:	e8 70 db ff ff       	call   801011a0 <filealloc>
80103630:	85 c0                	test   %eax,%eax
80103632:	89 06                	mov    %eax,(%esi)
80103634:	0f 84 a8 00 00 00    	je     801036e2 <pipealloc+0xd2>
8010363a:	e8 61 db ff ff       	call   801011a0 <filealloc>
8010363f:	85 c0                	test   %eax,%eax
80103641:	89 03                	mov    %eax,(%ebx)
80103643:	0f 84 87 00 00 00    	je     801036d0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103649:	e8 62 f2 ff ff       	call   801028b0 <kalloc>
8010364e:	85 c0                	test   %eax,%eax
80103650:	89 c7                	mov    %eax,%edi
80103652:	0f 84 b0 00 00 00    	je     80103708 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103658:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010365b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103662:	00 00 00 
  p->writeopen = 1;
80103665:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010366c:	00 00 00 
  p->nwrite = 0;
8010366f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103676:	00 00 00 
  p->nread = 0;
80103679:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103680:	00 00 00 
  initlock(&p->lock, "pipe");
80103683:	68 30 80 10 80       	push   $0x80108030
80103688:	50                   	push   %eax
80103689:	e8 82 14 00 00       	call   80104b10 <initlock>
  (*f0)->type = FD_PIPE;
8010368e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103690:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103693:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103699:	8b 06                	mov    (%esi),%eax
8010369b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010369f:	8b 06                	mov    (%esi),%eax
801036a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036a5:	8b 06                	mov    (%esi),%eax
801036a7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036aa:	8b 03                	mov    (%ebx),%eax
801036ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036b2:	8b 03                	mov    (%ebx),%eax
801036b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036b8:	8b 03                	mov    (%ebx),%eax
801036ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036be:	8b 03                	mov    (%ebx),%eax
801036c0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036c6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036c8:	5b                   	pop    %ebx
801036c9:	5e                   	pop    %esi
801036ca:	5f                   	pop    %edi
801036cb:	5d                   	pop    %ebp
801036cc:	c3                   	ret    
801036cd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036d0:	8b 06                	mov    (%esi),%eax
801036d2:	85 c0                	test   %eax,%eax
801036d4:	74 1e                	je     801036f4 <pipealloc+0xe4>
    fileclose(*f0);
801036d6:	83 ec 0c             	sub    $0xc,%esp
801036d9:	50                   	push   %eax
801036da:	e8 81 db ff ff       	call   80101260 <fileclose>
801036df:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036e2:	8b 03                	mov    (%ebx),%eax
801036e4:	85 c0                	test   %eax,%eax
801036e6:	74 0c                	je     801036f4 <pipealloc+0xe4>
    fileclose(*f1);
801036e8:	83 ec 0c             	sub    $0xc,%esp
801036eb:	50                   	push   %eax
801036ec:	e8 6f db ff ff       	call   80101260 <fileclose>
801036f1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801036f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036fc:	5b                   	pop    %ebx
801036fd:	5e                   	pop    %esi
801036fe:	5f                   	pop    %edi
801036ff:	5d                   	pop    %ebp
80103700:	c3                   	ret    
80103701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103708:	8b 06                	mov    (%esi),%eax
8010370a:	85 c0                	test   %eax,%eax
8010370c:	75 c8                	jne    801036d6 <pipealloc+0xc6>
8010370e:	eb d2                	jmp    801036e2 <pipealloc+0xd2>

80103710 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103718:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	53                   	push   %ebx
8010371f:	e8 4c 15 00 00       	call   80104c70 <acquire>
  if(writable){
80103724:	83 c4 10             	add    $0x10,%esp
80103727:	85 f6                	test   %esi,%esi
80103729:	74 45                	je     80103770 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010372b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103731:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103734:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010373b:	00 00 00 
    wakeup(&p->nread);
8010373e:	50                   	push   %eax
8010373f:	e8 ec 10 00 00       	call   80104830 <wakeup>
80103744:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103747:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010374d:	85 d2                	test   %edx,%edx
8010374f:	75 0a                	jne    8010375b <pipeclose+0x4b>
80103751:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103757:	85 c0                	test   %eax,%eax
80103759:	74 35                	je     80103790 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010375b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010375e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103761:	5b                   	pop    %ebx
80103762:	5e                   	pop    %esi
80103763:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103764:	e9 b7 15 00 00       	jmp    80104d20 <release>
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103770:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103776:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103779:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103780:	00 00 00 
    wakeup(&p->nwrite);
80103783:	50                   	push   %eax
80103784:	e8 a7 10 00 00       	call   80104830 <wakeup>
80103789:	83 c4 10             	add    $0x10,%esp
8010378c:	eb b9                	jmp    80103747 <pipeclose+0x37>
8010378e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	53                   	push   %ebx
80103794:	e8 87 15 00 00       	call   80104d20 <release>
    kfree((char*)p);
80103799:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010379c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801037a5:	e9 56 ef ff ff       	jmp    80102700 <kfree>
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037b0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
801037b5:	53                   	push   %ebx
801037b6:	83 ec 28             	sub    $0x28,%esp
801037b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037bc:	53                   	push   %ebx
801037bd:	e8 ae 14 00 00       	call   80104c70 <acquire>
  for(i = 0; i < n; i++){
801037c2:	8b 45 10             	mov    0x10(%ebp),%eax
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	85 c0                	test   %eax,%eax
801037ca:	0f 8e b9 00 00 00    	jle    80103889 <pipewrite+0xd9>
801037d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037d3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037df:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037e5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037e8:	03 4d 10             	add    0x10(%ebp),%ecx
801037eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037ee:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037f4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037fa:	39 d0                	cmp    %edx,%eax
801037fc:	74 38                	je     80103836 <pipewrite+0x86>
801037fe:	eb 59                	jmp    80103859 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103800:	e8 fb 03 00 00       	call   80103c00 <myproc>
80103805:	8b 48 24             	mov    0x24(%eax),%ecx
80103808:	85 c9                	test   %ecx,%ecx
8010380a:	75 34                	jne    80103840 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010380c:	83 ec 0c             	sub    $0xc,%esp
8010380f:	57                   	push   %edi
80103810:	e8 1b 10 00 00       	call   80104830 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103815:	58                   	pop    %eax
80103816:	5a                   	pop    %edx
80103817:	53                   	push   %ebx
80103818:	56                   	push   %esi
80103819:	e8 42 0e 00 00       	call   80104660 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010381e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103824:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	05 00 02 00 00       	add    $0x200,%eax
80103832:	39 c2                	cmp    %eax,%edx
80103834:	75 2a                	jne    80103860 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103836:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010383c:	85 c0                	test   %eax,%eax
8010383e:	75 c0                	jne    80103800 <pipewrite+0x50>
        release(&p->lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
80103843:	53                   	push   %ebx
80103844:	e8 d7 14 00 00       	call   80104d20 <release>
        return -1;
80103849:	83 c4 10             	add    $0x10,%esp
8010384c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103854:	5b                   	pop    %ebx
80103855:	5e                   	pop    %esi
80103856:	5f                   	pop    %edi
80103857:	5d                   	pop    %ebp
80103858:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103859:	89 c2                	mov    %eax,%edx
8010385b:	90                   	nop
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103860:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103863:	8d 42 01             	lea    0x1(%edx),%eax
80103866:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010386a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103870:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103876:	0f b6 09             	movzbl (%ecx),%ecx
80103879:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010387d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103880:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103883:	0f 85 65 ff ff ff    	jne    801037ee <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103889:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010388f:	83 ec 0c             	sub    $0xc,%esp
80103892:	50                   	push   %eax
80103893:	e8 98 0f 00 00       	call   80104830 <wakeup>
  release(&p->lock);
80103898:	89 1c 24             	mov    %ebx,(%esp)
8010389b:	e8 80 14 00 00       	call   80104d20 <release>
  return n;
801038a0:	83 c4 10             	add    $0x10,%esp
801038a3:	8b 45 10             	mov    0x10(%ebp),%eax
801038a6:	eb a9                	jmp    80103851 <pipewrite+0xa1>
801038a8:	90                   	nop
801038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038b0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 18             	sub    $0x18,%esp
801038b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038bf:	53                   	push   %ebx
801038c0:	e8 ab 13 00 00       	call   80104c70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ce:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801038d4:	75 6a                	jne    80103940 <piperead+0x90>
801038d6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801038dc:	85 f6                	test   %esi,%esi
801038de:	0f 84 cc 00 00 00    	je     801039b0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038e4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801038ea:	eb 2d                	jmp    80103919 <piperead+0x69>
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038f0:	83 ec 08             	sub    $0x8,%esp
801038f3:	53                   	push   %ebx
801038f4:	56                   	push   %esi
801038f5:	e8 66 0d 00 00       	call   80104660 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038fa:	83 c4 10             	add    $0x10,%esp
801038fd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103903:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103909:	75 35                	jne    80103940 <piperead+0x90>
8010390b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103911:	85 d2                	test   %edx,%edx
80103913:	0f 84 97 00 00 00    	je     801039b0 <piperead+0x100>
    if(myproc()->killed){
80103919:	e8 e2 02 00 00       	call   80103c00 <myproc>
8010391e:	8b 48 24             	mov    0x24(%eax),%ecx
80103921:	85 c9                	test   %ecx,%ecx
80103923:	74 cb                	je     801038f0 <piperead+0x40>
      release(&p->lock);
80103925:	83 ec 0c             	sub    $0xc,%esp
80103928:	53                   	push   %ebx
80103929:	e8 f2 13 00 00       	call   80104d20 <release>
      return -1;
8010392e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103931:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103934:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5f                   	pop    %edi
8010393c:	5d                   	pop    %ebp
8010393d:	c3                   	ret    
8010393e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103940:	8b 45 10             	mov    0x10(%ebp),%eax
80103943:	85 c0                	test   %eax,%eax
80103945:	7e 69                	jle    801039b0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103947:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010394d:	31 c9                	xor    %ecx,%ecx
8010394f:	eb 15                	jmp    80103966 <piperead+0xb6>
80103951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103958:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010395e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103964:	74 5a                	je     801039c0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103966:	8d 70 01             	lea    0x1(%eax),%esi
80103969:	25 ff 01 00 00       	and    $0x1ff,%eax
8010396e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103974:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103979:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010397c:	83 c1 01             	add    $0x1,%ecx
8010397f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103982:	75 d4                	jne    80103958 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103984:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010398a:	83 ec 0c             	sub    $0xc,%esp
8010398d:	50                   	push   %eax
8010398e:	e8 9d 0e 00 00       	call   80104830 <wakeup>
  release(&p->lock);
80103993:	89 1c 24             	mov    %ebx,(%esp)
80103996:	e8 85 13 00 00       	call   80104d20 <release>
  return i;
8010399b:	8b 45 10             	mov    0x10(%ebp),%eax
8010399e:	83 c4 10             	add    $0x10,%esp
}
801039a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a4:	5b                   	pop    %ebx
801039a5:	5e                   	pop    %esi
801039a6:	5f                   	pop    %edi
801039a7:	5d                   	pop    %ebp
801039a8:	c3                   	ret    
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039b0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801039b7:	eb cb                	jmp    80103984 <piperead+0xd4>
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039c0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801039c3:	eb bf                	jmp    80103984 <piperead+0xd4>
801039c5:	66 90                	xchg   %ax,%ax
801039c7:	66 90                	xchg   %ax,%ax
801039c9:	66 90                	xchg   %ax,%ax
801039cb:	66 90                	xchg   %ax,%ax
801039cd:	66 90                	xchg   %ax,%ax
801039cf:	90                   	nop

801039d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039d9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801039dc:	68 20 3d 11 80       	push   $0x80113d20
801039e1:	e8 8a 12 00 00       	call   80104c70 <acquire>
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 17                	jmp    80103a02 <allocproc+0x32>
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801039f6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801039fc:	0f 84 c6 00 00 00    	je     80103ac8 <allocproc+0xf8>
    if(p->state == UNUSED)
80103a02:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a05:	85 c0                	test   %eax,%eax
80103a07:	75 e7                	jne    801039f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a09:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->start_time_tick = ticks;
  //공유메모리
  p->shared_memory_address = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
80103a0e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103a11:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->start_time_tick = ticks;
  //공유메모리
  p->shared_memory_address = 0;
  //////////////////////////////////////////

  release(&ptable.lock);
80103a18:	68 20 3d 11 80       	push   $0x80113d20
found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  /////////////////////////////////////////
  //항상 레벨 0에 들어가고 우선순위는 0이다.
  p->queuelevel = 0;
80103a1d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a24:	00 00 00 
  p->priority = 0;
80103a27:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->tickleft = 4;
80103a2e:	c7 83 84 00 00 00 04 	movl   $0x4,0x84(%ebx)
80103a35:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a38:	8d 50 01             	lea    0x1(%eax),%edx
80103a3b:	89 43 10             	mov    %eax,0x10(%ebx)
  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  p->limit_sz = 0;
  p->custom_stack_size = 1;
  //시작시간 
  p->start_time_tick = ticks;
80103a3e:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
  p->queuelevel = 0;
  p->priority = 0;
  p->tickleft = 4;

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
80103a43:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103a4a:	00 00 00 
  p->limit_sz = 0;
80103a4d:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103a54:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a57:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->tickleft = 4;

  //프로세스를 생성할 때는 admin모드는 꺼져있다.
  p->admin_mode = 0;
  p->limit_sz = 0;
  p->custom_stack_size = 1;
80103a5d:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80103a64:	00 00 00 
  //시작시간 
  p->start_time_tick = ticks;
80103a67:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
  //공유메모리
  p->shared_memory_address = 0;
80103a6d:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103a74:	00 00 00 
  //////////////////////////////////////////

  release(&ptable.lock);
80103a77:	e8 a4 12 00 00       	call   80104d20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a7c:	e8 2f ee ff ff       	call   801028b0 <kalloc>
80103a81:	83 c4 10             	add    $0x10,%esp
80103a84:	85 c0                	test   %eax,%eax
80103a86:	89 43 08             	mov    %eax,0x8(%ebx)
80103a89:	74 54                	je     80103adf <allocproc+0x10f>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a8b:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a91:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103a94:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a99:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103a9c:	c7 40 14 1c 62 10 80 	movl   $0x8010621c,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103aa3:	6a 14                	push   $0x14
80103aa5:	6a 00                	push   $0x0
80103aa7:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103aa8:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103aab:	e8 c0 12 00 00       	call   80104d70 <memset>
  p->context->eip = (uint)forkret;
80103ab0:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103ab3:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103ab6:	c7 40 10 f0 3a 10 80 	movl   $0x80103af0,0x10(%eax)

  return p;
80103abd:	89 d8                	mov    %ebx,%eax
}
80103abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac2:	c9                   	leave  
80103ac3:	c3                   	ret    
80103ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 20 3d 11 80       	push   $0x80113d20
80103ad0:	e8 4b 12 00 00       	call   80104d20 <release>
  return 0;
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103add:	c9                   	leave  
80103ade:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103adf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ae6:	eb d7                	jmp    80103abf <allocproc+0xef>
80103ae8:	90                   	nop
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103af0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103af6:	68 20 3d 11 80       	push   $0x80113d20
80103afb:	e8 20 12 00 00       	call   80104d20 <release>

  if (first) {
80103b00:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	85 c0                	test   %eax,%eax
80103b0a:	75 04                	jne    80103b10 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b0c:	c9                   	leave  
80103b0d:	c3                   	ret    
80103b0e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103b10:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103b13:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b1a:	00 00 00 
    iinit(ROOTDEV);
80103b1d:	6a 01                	push   $0x1
80103b1f:	e8 6c dd ff ff       	call   80101890 <iinit>
    initlog(ROOTDEV);
80103b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b2b:	e8 a0 f3 ff ff       	call   80102ed0 <initlog>
80103b30:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b33:	c9                   	leave  
80103b34:	c3                   	ret    
80103b35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b40 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b46:	68 35 80 10 80       	push   $0x80108035
80103b4b:	68 20 3d 11 80       	push   $0x80113d20
80103b50:	e8 bb 0f 00 00       	call   80104b10 <initlock>
}
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	c9                   	leave  
80103b59:	c3                   	ret    
80103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b60 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b65:	9c                   	pushf  
80103b66:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103b67:	f6 c4 02             	test   $0x2,%ah
80103b6a:	75 5b                	jne    80103bc7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103b6c:	e8 9f ef ff ff       	call   80102b10 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b71:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103b77:	85 f6                	test   %esi,%esi
80103b79:	7e 3f                	jle    80103bba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b7b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103b82:	39 d0                	cmp    %edx,%eax
80103b84:	74 30                	je     80103bb6 <mycpu+0x56>
80103b86:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103b8b:	31 d2                	xor    %edx,%edx
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b90:	83 c2 01             	add    $0x1,%edx
80103b93:	39 f2                	cmp    %esi,%edx
80103b95:	74 23                	je     80103bba <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b97:	0f b6 19             	movzbl (%ecx),%ebx
80103b9a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ba0:	39 d8                	cmp    %ebx,%eax
80103ba2:	75 ec                	jne    80103b90 <mycpu+0x30>
      return &cpus[i];
80103ba4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103baa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bad:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103bae:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103bb3:	5e                   	pop    %esi
80103bb4:	5d                   	pop    %ebp
80103bb5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bb6:	31 d2                	xor    %edx,%edx
80103bb8:	eb ea                	jmp    80103ba4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103bba:	83 ec 0c             	sub    $0xc,%esp
80103bbd:	68 3c 80 10 80       	push   $0x8010803c
80103bc2:	e8 a9 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103bc7:	83 ec 0c             	sub    $0xc,%esp
80103bca:	68 44 81 10 80       	push   $0x80108144
80103bcf:	e8 9c c7 ff ff       	call   80100370 <panic>
80103bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103be0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103be6:	e8 75 ff ff ff       	call   80103b60 <mycpu>
80103beb:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103bf0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103bf1:	c1 f8 04             	sar    $0x4,%eax
80103bf4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bfa:	c3                   	ret    
80103bfb:	90                   	nop
80103bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c00 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	53                   	push   %ebx
80103c04:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c07:	e8 84 0f 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103c0c:	e8 4f ff ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103c11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c17:	e8 b4 0f 00 00       	call   80104bd0 <popcli>
  return p;
}
80103c1c:	83 c4 04             	add    $0x4,%esp
80103c1f:	89 d8                	mov    %ebx,%eax
80103c21:	5b                   	pop    %ebx
80103c22:	5d                   	pop    %ebp
80103c23:	c3                   	ret    
80103c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c30 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103c37:	e8 94 fd ff ff       	call   801039d0 <allocproc>
80103c3c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103c3e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103c43:	e8 e8 3b 00 00       	call   80107830 <setupkvm>
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c4d:	0f 84 bd 00 00 00    	je     80103d10 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c53:	83 ec 04             	sub    $0x4,%esp
80103c56:	68 2c 00 00 00       	push   $0x2c
80103c5b:	68 60 b4 10 80       	push   $0x8010b460
80103c60:	50                   	push   %eax
80103c61:	e8 da 38 00 00       	call   80107540 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103c66:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103c69:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c6f:	6a 4c                	push   $0x4c
80103c71:	6a 00                	push   $0x0
80103c73:	ff 73 18             	pushl  0x18(%ebx)
80103c76:	e8 f5 10 00 00       	call   80104d70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c7b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c7e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c83:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c88:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c8b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c8f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c92:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c96:	8b 43 18             	mov    0x18(%ebx),%eax
80103c99:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c9d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ca1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ca8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cac:	8b 43 18             	mov    0x18(%ebx),%eax
80103caf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103cc0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cca:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ccd:	6a 10                	push   $0x10
80103ccf:	68 65 80 10 80       	push   $0x80108065
80103cd4:	50                   	push   %eax
80103cd5:	e8 96 12 00 00       	call   80104f70 <safestrcpy>
  p->cwd = namei("/");
80103cda:	c7 04 24 6e 80 10 80 	movl   $0x8010806e,(%esp)
80103ce1:	e8 fa e5 ff ff       	call   801022e0 <namei>
80103ce6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ce9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cf0:	e8 7b 0f 00 00       	call   80104c70 <acquire>

  p->state = RUNNABLE;
80103cf5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103cfc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d03:	e8 18 10 00 00       	call   80104d20 <release>
}
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0e:	c9                   	leave  
80103d0f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	68 4c 80 10 80       	push   $0x8010804c
80103d18:	e8 53 c6 ff ff       	call   80100370 <panic>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi

80103d20 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
80103d25:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d28:	e8 63 0e 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103d2d:	e8 2e fe ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103d32:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d38:	e8 93 0e 00 00       	call   80104bd0 <popcli>
  struct proc *curproc = myproc();

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
80103d3d:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103d43:	8b 03                	mov    (%ebx),%eax

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
80103d45:	85 d2                	test   %edx,%edx
80103d47:	74 07                	je     80103d50 <growproc+0x30>
80103d49:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80103d4c:	39 d1                	cmp    %edx,%ecx
80103d4e:	77 50                	ja     80103da0 <growproc+0x80>
    return -1;
  }
  if(n > 0){
80103d50:	83 fe 00             	cmp    $0x0,%esi
80103d53:	7e 33                	jle    80103d88 <growproc+0x68>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d55:	83 ec 04             	sub    $0x4,%esp
80103d58:	01 c6                	add    %eax,%esi
80103d5a:	56                   	push   %esi
80103d5b:	50                   	push   %eax
80103d5c:	ff 73 04             	pushl  0x4(%ebx)
80103d5f:	e8 1c 39 00 00       	call   80107680 <allocuvm>
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	85 c0                	test   %eax,%eax
80103d69:	74 35                	je     80103da0 <growproc+0x80>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103d6b:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103d6e:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d70:	53                   	push   %ebx
80103d71:	e8 ba 36 00 00       	call   80107430 <switchuvm>
  return 0;
80103d76:	83 c4 10             	add    $0x10,%esp
80103d79:	31 c0                	xor    %eax,%eax
}
80103d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d7e:	5b                   	pop    %ebx
80103d7f:	5e                   	pop    %esi
80103d80:	5d                   	pop    %ebp
80103d81:	c3                   	ret    
80103d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  }
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103d88:	74 e1                	je     80103d6b <growproc+0x4b>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d8a:	83 ec 04             	sub    $0x4,%esp
80103d8d:	01 c6                	add    %eax,%esi
80103d8f:	56                   	push   %esi
80103d90:	50                   	push   %eax
80103d91:	ff 73 04             	pushl  0x4(%ebx)
80103d94:	e8 e7 39 00 00       	call   80107780 <deallocuvm>
80103d99:	83 c4 10             	add    $0x10,%esp
80103d9c:	85 c0                	test   %eax,%eax
80103d9e:	75 cb                	jne    80103d6b <growproc+0x4b>

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
    return -1;
80103da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103da5:	eb d4                	jmp    80103d7b <growproc+0x5b>
80103da7:	89 f6                	mov    %esi,%esi
80103da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103db0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103db9:	e8 d2 0d 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80103dbe:	e8 9d fd ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103dc3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc9:	e8 02 0e 00 00       	call   80104bd0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103dce:	e8 fd fb ff ff       	call   801039d0 <allocproc>
80103dd3:	85 c0                	test   %eax,%eax
80103dd5:	89 c7                	mov    %eax,%edi
80103dd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dda:	0f 84 e5 00 00 00    	je     80103ec5 <fork+0x115>
    return -1;
  }

  //새 페이지 할당 및  주소 저장
  np->shared_memory_address = kalloc();
80103de0:	e8 cb ea ff ff       	call   801028b0 <kalloc>


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103de5:	83 ec 08             	sub    $0x8,%esp
  if((np = allocproc()) == 0){
    return -1;
  }

  //새 페이지 할당 및  주소 저장
  np->shared_memory_address = kalloc();
80103de8:	89 87 98 00 00 00    	mov    %eax,0x98(%edi)


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dee:	ff 33                	pushl  (%ebx)
80103df0:	ff 73 04             	pushl  0x4(%ebx)
80103df3:	e8 08 3b 00 00       	call   80107900 <copyuvm>
80103df8:	83 c4 10             	add    $0x10,%esp
80103dfb:	85 c0                	test   %eax,%eax
80103dfd:	89 47 04             	mov    %eax,0x4(%edi)
80103e00:	0f 84 c6 00 00 00    	je     80103ecc <fork+0x11c>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103e06:	8b 03                	mov    (%ebx),%eax
80103e08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103e0b:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103e10:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103e12:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103e15:	8b 7a 18             	mov    0x18(%edx),%edi
80103e18:	8b 73 18             	mov    0x18(%ebx),%esi
80103e1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103e1d:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  //부모 프로세스와 같은 값으로 설정해준다.
  np->admin_mode = curproc->admin_mode;
80103e1f:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103e25:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  np->limit_sz = curproc->limit_sz;
80103e2b:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80103e31:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
  np->custom_stack_size = curproc->custom_stack_size;
80103e37:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103e3d:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103e43:	8b 42 18             	mov    0x18(%edx),%eax
80103e46:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103e50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e54:	85 c0                	test   %eax,%eax
80103e56:	74 13                	je     80103e6b <fork+0xbb>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e58:	83 ec 0c             	sub    $0xc,%esp
80103e5b:	50                   	push   %eax
80103e5c:	e8 af d3 ff ff       	call   80101210 <filedup>
80103e61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103e6b:	83 c6 01             	add    $0x1,%esi
80103e6e:	83 fe 10             	cmp    $0x10,%esi
80103e71:	75 dd                	jne    80103e50 <fork+0xa0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e79:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e7c:	e8 df db ff ff       	call   80101a60 <idup>
80103e81:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e84:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e87:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e8d:	6a 10                	push   $0x10
80103e8f:	53                   	push   %ebx
80103e90:	50                   	push   %eax
80103e91:	e8 da 10 00 00       	call   80104f70 <safestrcpy>

  pid = np->pid;
80103e96:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103e99:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ea0:	e8 cb 0d 00 00       	call   80104c70 <acquire>

  np->state = RUNNABLE;
80103ea5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103eac:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103eb3:	e8 68 0e 00 00       	call   80104d20 <release>

  return pid;
80103eb8:	83 c4 10             	add    $0x10,%esp
80103ebb:	89 d8                	mov    %ebx,%eax
}
80103ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec0:	5b                   	pop    %ebx
80103ec1:	5e                   	pop    %esi
80103ec2:	5f                   	pop    %edi
80103ec3:	5d                   	pop    %ebp
80103ec4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eca:	eb f1                	jmp    80103ebd <fork+0x10d>
  np->shared_memory_address = kalloc();


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103ecc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ecf:	83 ec 0c             	sub    $0xc,%esp
80103ed2:	ff 73 08             	pushl  0x8(%ebx)
80103ed5:	e8 26 e8 ff ff       	call   80102700 <kfree>
    np->kstack = 0;
80103eda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ee1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ee8:	83 c4 10             	add    $0x10,%esp
80103eeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ef0:	eb cb                	jmp    80103ebd <fork+0x10d>
80103ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <priority_boosting>:
//      via swtch back to the scheduler.


void 
priority_boosting(void)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103f06:	68 20 3d 11 80       	push   $0x80113d20
80103f0b:	e8 60 0d 00 00       	call   80104c70 <acquire>
80103f10:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f13:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f18:	90                   	nop
80103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103f20:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103f27:	00 00 00 
        p->tickleft=4;
80103f2a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103f31:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f34:	05 9c 00 00 00       	add    $0x9c,%eax
80103f39:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103f3e:	75 e0                	jne    80103f20 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	68 20 3d 11 80       	push   $0x80113d20
80103f48:	e8 d3 0d 00 00       	call   80104d20 <release>
}
80103f4d:	83 c4 10             	add    $0x10,%esp
80103f50:	c9                   	leave  
80103f51:	c3                   	ret    
80103f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <scheduler>:
*/


void
scheduler(void)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	57                   	push   %edi
80103f64:	56                   	push   %esi
80103f65:	53                   	push   %ebx
80103f66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103f69:	e8 f2 fb ff ff       	call   80103b60 <mycpu>
80103f6e:	8d 78 04             	lea    0x4(%eax),%edi
80103f71:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f73:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f7a:	00 00 00 
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103f80:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f81:	83 ec 0c             	sub    $0xc,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f84:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f89:	68 20 3d 11 80       	push   $0x80113d20
80103f8e:	e8 dd 0c 00 00       	call   80104c70 <acquire>
80103f93:	83 c4 10             	add    $0x10,%esp
80103f96:	eb 16                	jmp    80103fae <scheduler+0x4e>
80103f98:	90                   	nop
80103f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103fa6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80103fac:	74 52                	je     80104000 <scheduler+0xa0>
      if(p->state != RUNNABLE) continue;
80103fae:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fb2:	75 ec                	jne    80103fa0 <scheduler+0x40>
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103fb4:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE) continue;
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103fb7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fbd:	53                   	push   %ebx
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbe:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103fc4:	e8 67 34 00 00       	call   80107430 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103fc9:	58                   	pop    %eax
80103fca:	5a                   	pop    %edx
80103fcb:	ff 73 80             	pushl  -0x80(%ebx)
80103fce:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103fcf:	c7 83 70 ff ff ff 04 	movl   $0x4,-0x90(%ebx)
80103fd6:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103fd9:	e8 ed 0f 00 00       	call   80104fcb <swtch>
      switchkvm();
80103fde:	e8 2d 34 00 00       	call   80107410 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103fe3:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103fec:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ff3:	00 00 00 
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff6:	75 b6                	jne    80103fae <scheduler+0x4e>
80103ff8:	90                   	nop
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	68 20 3d 11 80       	push   $0x80113d20
80104008:	e8 13 0d 00 00       	call   80104d20 <release>
    #endif
  }
8010400d:	83 c4 10             	add    $0x10,%esp
80104010:	e9 6b ff ff ff       	jmp    80103f80 <scheduler+0x20>
80104015:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104020 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
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
80104025:	e8 66 0b 00 00       	call   80104b90 <pushcli>
  c = mycpu();
8010402a:	e8 31 fb ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010402f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104035:	e8 96 0b 00 00       	call   80104bd0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 20 3d 11 80       	push   $0x80113d20
80104042:	e8 f9 0b 00 00       	call   80104c40 <holding>
80104047:	83 c4 10             	add    $0x10,%esp
8010404a:	85 c0                	test   %eax,%eax
8010404c:	74 4f                	je     8010409d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
8010404e:	e8 0d fb ff ff       	call   80103b60 <mycpu>
80104053:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010405a:	75 68                	jne    801040c4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010405c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104060:	74 55                	je     801040b7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104062:	9c                   	pushf  
80104063:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80104064:	f6 c4 02             	test   $0x2,%ah
80104067:	75 41                	jne    801040aa <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80104069:	e8 f2 fa ff ff       	call   80103b60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010406e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80104071:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104077:	e8 e4 fa ff ff       	call   80103b60 <mycpu>
8010407c:	83 ec 08             	sub    $0x8,%esp
8010407f:	ff 70 04             	pushl  0x4(%eax)
80104082:	53                   	push   %ebx
80104083:	e8 43 0f 00 00       	call   80104fcb <swtch>
  mycpu()->intena = intena;
80104088:	e8 d3 fa ff ff       	call   80103b60 <mycpu>
}
8010408d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104090:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104096:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104099:	5b                   	pop    %ebx
8010409a:	5e                   	pop    %esi
8010409b:	5d                   	pop    %ebp
8010409c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010409d:	83 ec 0c             	sub    $0xc,%esp
801040a0:	68 70 80 10 80       	push   $0x80108070
801040a5:	e8 c6 c2 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 9c 80 10 80       	push   $0x8010809c
801040b2:	e8 b9 c2 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
801040b7:	83 ec 0c             	sub    $0xc,%esp
801040ba:	68 8e 80 10 80       	push   $0x8010808e
801040bf:	e8 ac c2 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	68 82 80 10 80       	push   $0x80108082
801040cc:	e8 9f c2 ff ff       	call   80100370 <panic>
801040d1:	eb 0d                	jmp    801040e0 <exit>
801040d3:	90                   	nop
801040d4:	90                   	nop
801040d5:	90                   	nop
801040d6:	90                   	nop
801040d7:	90                   	nop
801040d8:	90                   	nop
801040d9:	90                   	nop
801040da:	90                   	nop
801040db:	90                   	nop
801040dc:	90                   	nop
801040dd:	90                   	nop
801040de:	90                   	nop
801040df:	90                   	nop

801040e0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040e9:	e8 a2 0a 00 00       	call   80104b90 <pushcli>
  c = mycpu();
801040ee:	e8 6d fa ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801040f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040f9:	e8 d2 0a 00 00       	call   80104bd0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
801040fe:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104104:	8d 5e 28             	lea    0x28(%esi),%ebx
80104107:	8d 7e 68             	lea    0x68(%esi),%edi
8010410a:	0f 84 f1 00 00 00    	je     80104201 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104110:	8b 03                	mov    (%ebx),%eax
80104112:	85 c0                	test   %eax,%eax
80104114:	74 12                	je     80104128 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104116:	83 ec 0c             	sub    $0xc,%esp
80104119:	50                   	push   %eax
8010411a:	e8 41 d1 ff ff       	call   80101260 <fileclose>
      curproc->ofile[fd] = 0;
8010411f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104125:	83 c4 10             	add    $0x10,%esp
80104128:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010412b:	39 df                	cmp    %ebx,%edi
8010412d:	75 e1                	jne    80104110 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010412f:	e8 3c ee ff ff       	call   80102f70 <begin_op>
  iput(curproc->cwd);
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	ff 76 68             	pushl  0x68(%esi)
8010413a:	e8 81 da ff ff       	call   80101bc0 <iput>
  end_op();
8010413f:	e8 9c ee ff ff       	call   80102fe0 <end_op>
  curproc->cwd = 0;
80104144:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010414b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104152:	e8 19 0b 00 00       	call   80104c70 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104157:	8b 56 14             	mov    0x14(%esi),%edx
8010415a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104162:	eb 10                	jmp    80104174 <exit+0x94>
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104168:	05 9c 00 00 00       	add    $0x9c,%eax
8010416d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104172:	74 1e                	je     80104192 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104174:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104178:	75 ee                	jne    80104168 <exit+0x88>
8010417a:	3b 50 20             	cmp    0x20(%eax),%edx
8010417d:	75 e9                	jne    80104168 <exit+0x88>
      p->state = RUNNABLE;
8010417f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104186:	05 9c 00 00 00       	add    $0x9c,%eax
8010418b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104190:	75 e2                	jne    80104174 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104192:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104198:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010419d:	eb 0f                	jmp    801041ae <exit+0xce>
8010419f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
801041a6:	81 fa 54 64 11 80    	cmp    $0x80116454,%edx
801041ac:	74 3a                	je     801041e8 <exit+0x108>
    if(p->parent == curproc){
801041ae:	39 72 14             	cmp    %esi,0x14(%edx)
801041b1:	75 ed                	jne    801041a0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801041b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801041b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041ba:	75 e4                	jne    801041a0 <exit+0xc0>
801041bc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041c1:	eb 11                	jmp    801041d4 <exit+0xf4>
801041c3:	90                   	nop
801041c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c8:	05 9c 00 00 00       	add    $0x9c,%eax
801041cd:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801041d2:	74 cc                	je     801041a0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801041d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041d8:	75 ee                	jne    801041c8 <exit+0xe8>
801041da:	3b 48 20             	cmp    0x20(%eax),%ecx
801041dd:	75 e9                	jne    801041c8 <exit+0xe8>
      p->state = RUNNABLE;
801041df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041e6:	eb e0                	jmp    801041c8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801041e8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801041ef:	e8 2c fe ff ff       	call   80104020 <sched>
  panic("zombie exit");
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	68 bd 80 10 80       	push   $0x801080bd
801041fc:	e8 6f c1 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104201:	83 ec 0c             	sub    $0xc,%esp
80104204:	68 b0 80 10 80       	push   $0x801080b0
80104209:	e8 62 c1 ff ff       	call   80100370 <panic>
8010420e:	66 90                	xchg   %ax,%ax

80104210 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104217:	68 20 3d 11 80       	push   $0x80113d20
8010421c:	e8 4f 0a 00 00       	call   80104c70 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104221:	e8 6a 09 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80104226:	e8 35 f9 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010422b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104231:	e8 9a 09 00 00       	call   80104bd0 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
80104236:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010423d:	e8 de fd ff ff       	call   80104020 <sched>
  release(&ptable.lock);
80104242:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104249:	e8 d2 0a 00 00       	call   80104d20 <release>
}
8010424e:	83 c4 10             	add    $0x10,%esp
80104251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104254:	c9                   	leave  
80104255:	c3                   	ret    
80104256:	8d 76 00             	lea    0x0(%esi),%esi
80104259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104260 <getlev>:

int             
getlev(void)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104267:	e8 24 09 00 00       	call   80104b90 <pushcli>
  c = mycpu();
8010426c:	e8 ef f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104271:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104277:	e8 54 09 00 00       	call   80104bd0 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
8010427c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104282:	83 c4 04             	add    $0x4,%esp
80104285:	5b                   	pop    %ebx
80104286:	5d                   	pop    %ebp
80104287:	c3                   	ret    
80104288:	90                   	nop
80104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104290 <getadmin>:

int
getadmin(char *password)
{
80104290:	55                   	push   %ebp
  char my_number[10] = "2016025823";
80104291:	b8 32 33 00 00       	mov    $0x3332,%eax
  int flag = 0;
80104296:	31 d2                	xor    %edx,%edx
  return myproc()->queuelevel;
}

int
getadmin(char *password)
{
80104298:	89 e5                	mov    %esp,%ebp
8010429a:	53                   	push   %ebx
8010429b:	83 ec 14             	sub    $0x14,%esp
8010429e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char my_number[10] = "2016025823";
801042a1:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
801042a5:	c7 45 ee 32 30 31 36 	movl   $0x36313032,-0x12(%ebp)
801042ac:	c7 45 f2 30 32 35 38 	movl   $0x38353230,-0xe(%ebp)
  int flag = 0;
  for(int i=0;i<10;i++){
801042b3:	31 c0                	xor    %eax,%eax
801042b5:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
801042b8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801042bc:	38 4c 05 ee          	cmp    %cl,-0x12(%ebp,%eax,1)
801042c0:	0f 94 c1             	sete   %cl
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801042c3:	83 c0 01             	add    $0x1,%eax
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
801042c6:	0f b6 c9             	movzbl %cl,%ecx
801042c9:	01 ca                	add    %ecx,%edx
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801042cb:	83 f8 0a             	cmp    $0xa,%eax
801042ce:	75 e8                	jne    801042b8 <getadmin+0x28>
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
801042d0:	83 fa 0a             	cmp    $0xa,%edx
801042d3:	75 2b                	jne    80104300 <getadmin+0x70>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801042d5:	e8 b6 08 00 00       	call   80104b90 <pushcli>
  c = mycpu();
801042da:	e8 81 f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801042df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e5:	e8 e6 08 00 00       	call   80104bd0 <popcli>
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
801042ea:	31 c0                	xor    %eax,%eax
  for(int i=0;i<10;i++){
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
801042ec:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801042f3:	00 00 00 
    return 0;
  }
  else{
    return -1;
  }
}
801042f6:	83 c4 14             	add    $0x14,%esp
801042f9:	5b                   	pop    %ebx
801042fa:	5d                   	pop    %ebp
801042fb:	c3                   	ret    
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104300:	83 c4 14             	add    $0x14,%esp
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
  }
  else{
    return -1;
80104303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80104308:	5b                   	pop    %ebx
80104309:	5d                   	pop    %ebp
8010430a:	c3                   	ret    
8010430b:	90                   	nop
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104310 <setmemorylimit>:

int 
setmemorylimit(int pid, int limit)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	8b 7d 08             	mov    0x8(%ebp),%edi
8010431c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010431f:	e8 6c 08 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80104324:	e8 37 f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104329:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010432f:	e8 9c 08 00 00       	call   80104bd0 <popcli>

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
80104334:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010433a:	85 c0                	test   %eax,%eax
8010433c:	74 5c                	je     8010439a <setmemorylimit+0x8a>
8010433e:	89 f0                	mov    %esi,%eax
80104340:	c1 e8 1f             	shr    $0x1f,%eax
80104343:	84 c0                	test   %al,%al
80104345:	75 53                	jne    8010439a <setmemorylimit+0x8a>
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
80104347:	83 ec 0c             	sub    $0xc,%esp
int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
8010434a:	31 db                	xor    %ebx,%ebx
  struct proc *p;
  acquire(&ptable.lock);
8010434c:	68 20 3d 11 80       	push   $0x80113d20
80104351:	e8 1a 09 00 00       	call   80104c70 <acquire>
80104356:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104359:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010435e:	66 90                	xchg   %ax,%ax
    if(p->pid == pid) target = p;
80104360:	39 78 10             	cmp    %edi,0x10(%eax)
80104363:	0f 44 d8             	cmove  %eax,%ebx
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104366:	05 9c 00 00 00       	add    $0x9c,%eax
8010436b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104370:	75 ee                	jne    80104360 <setmemorylimit+0x50>
    if(p->pid == pid) target = p;
  }
	release(&ptable.lock);
80104372:	83 ec 0c             	sub    $0xc,%esp
80104375:	68 20 3d 11 80       	push   $0x80113d20
8010437a:	e8 a1 09 00 00       	call   80104d20 <release>
  //해당 pid가 없을 때
  if(target==0) return -1;
8010437f:	83 c4 10             	add    $0x10,%esp
80104382:	85 db                	test   %ebx,%ebx
80104384:	74 14                	je     8010439a <setmemorylimit+0x8a>

  //기존 사이즈보다 더 작은 Limit을 주려고 할때

  if(target->sz > limit) return -1;
80104386:	39 33                	cmp    %esi,(%ebx)
80104388:	77 10                	ja     8010439a <setmemorylimit+0x8a>
  target->limit_sz = limit;
8010438a:	89 b3 90 00 00 00    	mov    %esi,0x90(%ebx)
  return 0;
80104390:	31 c0                	xor    %eax,%eax
}
80104392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104395:	5b                   	pop    %ebx
80104396:	5e                   	pop    %esi
80104397:	5f                   	pop    %edi
80104398:	5d                   	pop    %ebp
80104399:	c3                   	ret    

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
8010439a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010439f:	eb f1                	jmp    80104392 <setmemorylimit+0x82>
801043a1:	eb 0d                	jmp    801043b0 <getshmem>
801043a3:	90                   	nop
801043a4:	90                   	nop
801043a5:	90                   	nop
801043a6:	90                   	nop
801043a7:	90                   	nop
801043a8:	90                   	nop
801043a9:	90                   	nop
801043aa:	90                   	nop
801043ab:	90                   	nop
801043ac:	90                   	nop
801043ad:	90                   	nop
801043ae:	90                   	nop
801043af:	90                   	nop

801043b0 <getshmem>:
  return 0;
}

char*
getshmem(int pid)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	53                   	push   %ebx
  struct proc *p;
  char * return_address = 0;
801043b6:	31 ff                	xor    %edi,%edi
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043b8:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  return 0;
}

char*
getshmem(int pid)
{
801043bd:	83 ec 28             	sub    $0x28,%esp
801043c0:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
801043c3:	68 20 3d 11 80       	push   $0x80113d20
801043c8:	e8 a3 08 00 00       	call   80104c70 <acquire>
801043cd:	83 c4 10             	add    $0x10,%esp
801043d0:	eb 14                	jmp    801043e6 <getshmem+0x36>
801043d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801043de:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801043e4:	74 7b                	je     80104461 <getshmem+0xb1>
    if(p->pid == pid) {
801043e6:	39 73 10             	cmp    %esi,0x10(%ebx)
801043e9:	75 ed                	jne    801043d8 <getshmem+0x28>
      return_address = p->shared_memory_address;
801043eb:	8b bb 98 00 00 00    	mov    0x98(%ebx),%edi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043f1:	e8 9a 07 00 00       	call   80104b90 <pushcli>
  c = mycpu();
801043f6:	e8 65 f7 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801043fb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80104404:	e8 c7 07 00 00       	call   80104bd0 <popcli>
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid) {
      return_address = p->shared_memory_address;
      //본인 프로세스의 접근할 때 - 읽기, 쓰기
      if(p->pid == myproc()->pid){
80104409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010440c:	3b 70 10             	cmp    0x10(%eax),%esi
8010440f:	74 6f                	je     80104480 <getshmem+0xd0>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104411:	e8 7a 07 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80104416:	e8 45 f7 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010441b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104421:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
80104427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
8010442a:	e8 a1 07 00 00       	call   80104bd0 <popcli>
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
      }
      //다른 프로세스에 접근 할 때 - 읽기
      else{
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
8010442f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104432:	89 fa                	mov    %edi,%edx
80104434:	83 ec 04             	sub    $0x4,%esp
80104437:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010443d:	6a 01                	push   $0x1
8010443f:	52                   	push   %edx
80104440:	ff 70 04             	pushl  0x4(%eax)
80104443:	e8 f8 2d 00 00       	call   80107240 <walkpgdir>
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
80104448:	8b 4b fc             	mov    -0x4(%ebx),%ecx
8010444b:	83 c4 10             	add    $0x10,%esp
8010444e:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80104454:	83 ca 05             	or     $0x5,%edx
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104457:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
      }
      //다른 프로세스에 접근 할 때 - 읽기
      else{
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
8010445d:	89 10                	mov    %edx,(%eax)
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445f:	75 85                	jne    801043e6 <getshmem+0x36>
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
      }
    }
  }
  release(&ptable.lock);
80104461:	83 ec 0c             	sub    $0xc,%esp
80104464:	68 20 3d 11 80       	push   $0x80113d20
80104469:	e8 b2 08 00 00       	call   80104d20 <release>
  return return_address;
}
8010446e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104471:	89 f8                	mov    %edi,%eax
80104473:	5b                   	pop    %ebx
80104474:	5e                   	pop    %esi
80104475:	5f                   	pop    %edi
80104476:	5d                   	pop    %ebp
80104477:	c3                   	ret    
80104478:	90                   	nop
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104480:	e8 0b 07 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80104485:	e8 d6 f6 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010448a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80104493:	e8 38 07 00 00       	call   80104bd0 <popcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid) {
      return_address = p->shared_memory_address;
      //본인 프로세스의 접근할 때 - 읽기, 쓰기
      if(p->pid == myproc()->pid){
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
80104498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010449b:	89 fa                	mov    %edi,%edx
8010449d:	83 ec 04             	sub    $0x4,%esp
801044a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801044a6:	6a 01                	push   $0x1
801044a8:	52                   	push   %edx
801044a9:	ff 70 04             	pushl  0x4(%eax)
801044ac:	e8 8f 2d 00 00       	call   80107240 <walkpgdir>
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
801044b1:	8b 8b 98 00 00 00    	mov    0x98(%ebx),%ecx
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
801044c0:	83 ca 07             	or     $0x7,%edx
801044c3:	89 10                	mov    %edx,(%eax)
801044c5:	e9 0e ff ff ff       	jmp    801043d8 <getshmem+0x28>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <list>:
}


int
list()
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801044d9:	83 ec 10             	sub    $0x10,%esp
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
801044dc:	68 6c 81 10 80       	push   $0x8010816c
801044e1:	e8 7a c1 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  acquire(&ptable.lock);
801044e6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801044ed:	e8 7e 07 00 00       	call   80104c70 <acquire>
801044f2:	83 c4 10             	add    $0x10,%esp
801044f5:	eb 3a                	jmp    80104531 <list+0x61>
801044f7:	89 f6                	mov    %esi,%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   if(p->pid != 0 || p->state !=UNUSED){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
80104500:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80104505:	2b 43 28             	sub    0x28(%ebx),%eax
80104508:	83 ec 08             	sub    $0x8,%esp
8010450b:	ff 73 24             	pushl  0x24(%ebx)
8010450e:	ff 73 94             	pushl  -0x6c(%ebx)
80104511:	50                   	push   %eax
80104512:	ff 73 a4             	pushl  -0x5c(%ebx)
80104515:	53                   	push   %ebx
80104516:	68 c9 80 10 80       	push   $0x801080c9
8010451b:	e8 40 c1 ff ff       	call   80100660 <cprintf>
80104520:	83 c4 20             	add    $0x20,%esp
80104523:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104529:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
8010452f:	74 50                	je     80104581 <list+0xb1>
   if(p->pid != 0 || p->state !=UNUSED){
80104531:	8b 53 a4             	mov    -0x5c(%ebx),%edx
80104534:	85 d2                	test   %edx,%edx
80104536:	75 07                	jne    8010453f <list+0x6f>
80104538:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010453b:	85 c0                	test   %eax,%eax
8010453d:	74 e4                	je     80104523 <list+0x53>
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
8010453f:	83 ec 0c             	sub    $0xc,%esp
80104542:	53                   	push   %ebx
80104543:	e8 68 0a 00 00       	call   80104fb0 <strlen>
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	83 f8 06             	cmp    $0x6,%eax
8010454e:	7f b0                	jg     80104500 <list+0x30>
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
80104550:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80104555:	2b 43 28             	sub    0x28(%ebx),%eax
80104558:	83 ec 08             	sub    $0x8,%esp
8010455b:	ff 73 24             	pushl  0x24(%ebx)
8010455e:	ff 73 94             	pushl  -0x6c(%ebx)
80104561:	50                   	push   %eax
80104562:	ff 73 a4             	pushl  -0x5c(%ebx)
80104565:	53                   	push   %ebx
80104566:	68 df 80 10 80       	push   $0x801080df
8010456b:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104571:	e8 ea c0 ff ff       	call   80100660 <cprintf>
80104576:	83 c4 20             	add    $0x20,%esp
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104579:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
8010457f:	75 b0                	jne    80104531 <list+0x61>
   if(p->pid != 0 || p->state !=UNUSED){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
    }
  }
	release(&ptable.lock);
80104581:	83 ec 0c             	sub    $0xc,%esp
80104584:	68 20 3d 11 80       	push   $0x80113d20
80104589:	e8 92 07 00 00       	call   80104d20 <release>
  return 0;
}
8010458e:	31 c0                	xor    %eax,%eax
80104590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104593:	c9                   	leave  
80104594:	c3                   	ret    
80104595:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <setpriority>:


int             
setpriority(int pid, int priority)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801045a9:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
}


int             
setpriority(int pid, int priority)
{
801045ad:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801045b0:	0f 87 97 00 00 00    	ja     8010464d <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801045b6:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801045b9:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801045be:	68 20 3d 11 80       	push   $0x80113d20
801045c3:	e8 a8 06 00 00       	call   80104c70 <acquire>
801045c8:	83 c4 10             	add    $0x10,%esp
801045cb:	eb 11                	jmp    801045de <setpriority+0x3e>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801045d0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801045d6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801045dc:	74 52                	je     80104630 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
801045de:	39 73 10             	cmp    %esi,0x10(%ebx)
801045e1:	75 ed                	jne    801045d0 <setpriority+0x30>
801045e3:	8b 43 14             	mov    0x14(%ebx),%eax
801045e6:	8b 50 10             	mov    0x10(%eax),%edx
801045e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801045ec:	e8 9f 05 00 00       	call   80104b90 <pushcli>
  c = mycpu();
801045f1:	e8 6a f5 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801045f6:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801045fc:	e8 cf 05 00 00       	call   80104bd0 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
80104601:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104604:	3b 57 10             	cmp    0x10(%edi),%edx
80104607:	75 c7                	jne    801045d0 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104609:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
8010460c:	83 ec 0c             	sub    $0xc,%esp
8010460f:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104614:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
80104617:	e8 04 07 00 00       	call   80104d20 <release>

      return 0;
8010461c:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
8010461f:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
80104622:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
80104624:	5b                   	pop    %ebx
80104625:	5e                   	pop    %esi
80104626:	5f                   	pop    %edi
80104627:	5d                   	pop    %ebp
80104628:	c3                   	ret    
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 20 3d 11 80       	push   $0x80113d20
80104638:	e8 e3 06 00 00       	call   80104d20 <release>
  return -1;
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104645:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104648:	5b                   	pop    %ebx
80104649:	5e                   	pop    %esi
8010464a:	5f                   	pop    %edi
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
8010464d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104652:	eb f1                	jmp    80104645 <setpriority+0xa5>
80104654:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010465a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104660 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	56                   	push   %esi
80104665:	53                   	push   %ebx
80104666:	83 ec 0c             	sub    $0xc,%esp
80104669:	8b 7d 08             	mov    0x8(%ebp),%edi
8010466c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010466f:	e8 1c 05 00 00       	call   80104b90 <pushcli>
  c = mycpu();
80104674:	e8 e7 f4 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104679:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010467f:	e8 4c 05 00 00       	call   80104bd0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104684:	85 db                	test   %ebx,%ebx
80104686:	0f 84 87 00 00 00    	je     80104713 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010468c:	85 f6                	test   %esi,%esi
8010468e:	74 76                	je     80104706 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104690:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104696:	74 50                	je     801046e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 20 3d 11 80       	push   $0x80113d20
801046a0:	e8 cb 05 00 00       	call   80104c70 <acquire>
    release(lk);
801046a5:	89 34 24             	mov    %esi,(%esp)
801046a8:	e8 73 06 00 00       	call   80104d20 <release>
  }
  // Go to sleep.
  p->chan = chan;
801046ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046b7:	e8 64 f9 ff ff       	call   80104020 <sched>
  // Tidy up.
  p->chan = 0;
801046bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801046c3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801046ca:	e8 51 06 00 00       	call   80104d20 <release>
    acquire(lk);
801046cf:	89 75 08             	mov    %esi,0x8(%ebp)
801046d2:	83 c4 10             	add    $0x10,%esp
  }
}
801046d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046d8:	5b                   	pop    %ebx
801046d9:	5e                   	pop    %esi
801046da:	5f                   	pop    %edi
801046db:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801046dc:	e9 8f 05 00 00       	jmp    80104c70 <acquire>
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801046e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046f2:	e8 29 f9 ff ff       	call   80104020 <sched>
  // Tidy up.
  p->chan = 0;
801046f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801046fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104701:	5b                   	pop    %ebx
80104702:	5e                   	pop    %esi
80104703:	5f                   	pop    %edi
80104704:	5d                   	pop    %ebp
80104705:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	68 fc 80 10 80       	push   $0x801080fc
8010470e:	e8 5d bc ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104713:	83 ec 0c             	sub    $0xc,%esp
80104716:	68 f6 80 10 80       	push   $0x801080f6
8010471b:	e8 50 bc ff ff       	call   80100370 <panic>

80104720 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104725:	e8 66 04 00 00       	call   80104b90 <pushcli>
  c = mycpu();
8010472a:	e8 31 f4 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010472f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104735:	e8 96 04 00 00       	call   80104bd0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 20 3d 11 80       	push   $0x80113d20
80104742:	e8 29 05 00 00       	call   80104c70 <acquire>
80104747:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010474a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010474c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104751:	eb 13                	jmp    80104766 <wait+0x46>
80104753:	90                   	nop
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104758:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010475e:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104764:	74 22                	je     80104788 <wait+0x68>
      if(p->parent != curproc)
80104766:	39 73 14             	cmp    %esi,0x14(%ebx)
80104769:	75 ed                	jne    80104758 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010476b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010476f:	74 35                	je     801047a6 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104771:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104777:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010477c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104782:	75 e2                	jne    80104766 <wait+0x46>
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104788:	85 c0                	test   %eax,%eax
8010478a:	74 7c                	je     80104808 <wait+0xe8>
8010478c:	8b 46 24             	mov    0x24(%esi),%eax
8010478f:	85 c0                	test   %eax,%eax
80104791:	75 75                	jne    80104808 <wait+0xe8>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104793:	83 ec 08             	sub    $0x8,%esp
80104796:	68 20 3d 11 80       	push   $0x80113d20
8010479b:	56                   	push   %esi
8010479c:	e8 bf fe ff ff       	call   80104660 <sleep>
  }
801047a1:	83 c4 10             	add    $0x10,%esp
801047a4:	eb a4                	jmp    8010474a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801047a6:	83 ec 0c             	sub    $0xc,%esp
801047a9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801047ac:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801047af:	e8 4c df ff ff       	call   80102700 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801047b4:	5a                   	pop    %edx
801047b5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801047b8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801047bf:	e8 ec 2f 00 00       	call   801077b0 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
		kfree(p->shared_memory_address);
801047c4:	59                   	pop    %ecx
801047c5:	ff b3 98 00 00 00    	pushl  0x98(%ebx)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
801047cb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801047d2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047d9:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801047dd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047e4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		kfree(p->shared_memory_address);
801047eb:	e8 10 df ff ff       	call   80102700 <kfree>
        release(&ptable.lock);
801047f0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801047f7:	e8 24 05 00 00       	call   80104d20 <release>
        return pid;
801047fc:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
		kfree(p->shared_memory_address);
        release(&ptable.lock);
        return pid;
80104802:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104804:	5b                   	pop    %ebx
80104805:	5e                   	pop    %esi
80104806:	5d                   	pop    %ebp
80104807:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	68 20 3d 11 80       	push   $0x80113d20
80104810:	e8 0b 05 00 00       	call   80104d20 <release>
      return -1;
80104815:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104818:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010481b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104820:	5b                   	pop    %ebx
80104821:	5e                   	pop    %esi
80104822:	5d                   	pop    %ebp
80104823:	c3                   	ret    
80104824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010482a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104830 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 10             	sub    $0x10,%esp
80104837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010483a:	68 20 3d 11 80       	push   $0x80113d20
8010483f:	e8 2c 04 00 00       	call   80104c70 <acquire>
80104844:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104847:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010484c:	eb 0e                	jmp    8010485c <wakeup+0x2c>
8010484e:	66 90                	xchg   %ax,%ax
80104850:	05 9c 00 00 00       	add    $0x9c,%eax
80104855:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010485a:	74 1e                	je     8010487a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010485c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104860:	75 ee                	jne    80104850 <wakeup+0x20>
80104862:	3b 58 20             	cmp    0x20(%eax),%ebx
80104865:	75 e9                	jne    80104850 <wakeup+0x20>
      p->state = RUNNABLE;
80104867:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010486e:	05 9c 00 00 00       	add    $0x9c,%eax
80104873:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104878:	75 e2                	jne    8010485c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010487a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104881:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104884:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104885:	e9 96 04 00 00       	jmp    80104d20 <release>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 10             	sub    $0x10,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010489a:	68 20 3d 11 80       	push   $0x80113d20
8010489f:	e8 cc 03 00 00       	call   80104c70 <acquire>
801048a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048a7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801048ac:	eb 0e                	jmp    801048bc <kill+0x2c>
801048ae:	66 90                	xchg   %ax,%ax
801048b0:	05 9c 00 00 00       	add    $0x9c,%eax
801048b5:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801048ba:	74 3c                	je     801048f8 <kill+0x68>
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
801048bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801048bf:	75 ef                	jne    801048b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801048c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
801048c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801048cc:	74 1a                	je     801048e8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801048ce:	83 ec 0c             	sub    $0xc,%esp
801048d1:	68 20 3d 11 80       	push   $0x80113d20
801048d6:	e8 45 04 00 00       	call   80104d20 <release>
      return 0;
801048db:	83 c4 10             	add    $0x10,%esp
801048de:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801048e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e3:	c9                   	leave  
801048e4:	c3                   	ret    
801048e5:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801048e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048ef:	eb dd                	jmp    801048ce <kill+0x3e>
801048f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	68 20 3d 11 80       	push   $0x80113d20
80104900:	e8 1b 04 00 00       	call   80104d20 <release>
  return -1;
80104905:	83 c4 10             	add    $0x10,%esp
80104908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010490d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104910:	c9                   	leave  
80104911:	c3                   	ret    
80104912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	56                   	push   %esi
80104925:	53                   	push   %ebx
80104926:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104929:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010492e:	83 ec 3c             	sub    $0x3c,%esp
80104931:	eb 27                	jmp    8010495a <procdump+0x3a>
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104938:	83 ec 0c             	sub    $0xc,%esp
8010493b:	68 d7 84 10 80       	push   $0x801084d7
80104940:	e8 1b bd ff ff       	call   80100660 <cprintf>
80104945:	83 c4 10             	add    $0x10,%esp
80104948:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010494e:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
80104954:	0f 84 7e 00 00 00    	je     801049d8 <procdump+0xb8>
    if(p->state == UNUSED)
8010495a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010495d:	85 c0                	test   %eax,%eax
8010495f:	74 e7                	je     80104948 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104961:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104964:	ba 0d 81 10 80       	mov    $0x8010810d,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104969:	77 11                	ja     8010497c <procdump+0x5c>
8010496b:	8b 14 85 a0 81 10 80 	mov    -0x7fef7e60(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104972:	b8 0d 81 10 80       	mov    $0x8010810d,%eax
80104977:	85 d2                	test   %edx,%edx
80104979:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010497c:	53                   	push   %ebx
8010497d:	52                   	push   %edx
8010497e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104981:	68 11 81 10 80       	push   $0x80108111
80104986:	e8 d5 bc ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010498b:	83 c4 10             	add    $0x10,%esp
8010498e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104992:	75 a4                	jne    80104938 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104994:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104997:	83 ec 08             	sub    $0x8,%esp
8010499a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010499d:	50                   	push   %eax
8010499e:	8b 43 b0             	mov    -0x50(%ebx),%eax
801049a1:	8b 40 0c             	mov    0xc(%eax),%eax
801049a4:	83 c0 08             	add    $0x8,%eax
801049a7:	50                   	push   %eax
801049a8:	e8 83 01 00 00       	call   80104b30 <getcallerpcs>
801049ad:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801049b0:	8b 17                	mov    (%edi),%edx
801049b2:	85 d2                	test   %edx,%edx
801049b4:	74 82                	je     80104938 <procdump+0x18>
        cprintf(" %p", pc[i]);
801049b6:	83 ec 08             	sub    $0x8,%esp
801049b9:	83 c7 04             	add    $0x4,%edi
801049bc:	52                   	push   %edx
801049bd:	68 21 7b 10 80       	push   $0x80107b21
801049c2:	e8 99 bc ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801049c7:	83 c4 10             	add    $0x10,%esp
801049ca:	39 f7                	cmp    %esi,%edi
801049cc:	75 e2                	jne    801049b0 <procdump+0x90>
801049ce:	e9 65 ff ff ff       	jmp    80104938 <procdump+0x18>
801049d3:	90                   	nop
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801049d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049db:	5b                   	pop    %ebx
801049dc:	5e                   	pop    %esi
801049dd:	5f                   	pop    %edi
801049de:	5d                   	pop    %ebp
801049df:	c3                   	ret    

801049e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 0c             	sub    $0xc,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049ea:	68 b8 81 10 80       	push   $0x801081b8
801049ef:	8d 43 04             	lea    0x4(%ebx),%eax
801049f2:	50                   	push   %eax
801049f3:	e8 18 01 00 00       	call   80104b10 <initlock>
  lk->name = name;
801049f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a01:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104a04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80104a0b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104a0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a11:	c9                   	leave  
80104a12:	c3                   	ret    
80104a13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a2e:	56                   	push   %esi
80104a2f:	e8 3c 02 00 00       	call   80104c70 <acquire>
  while (lk->locked) {
80104a34:	8b 13                	mov    (%ebx),%edx
80104a36:	83 c4 10             	add    $0x10,%esp
80104a39:	85 d2                	test   %edx,%edx
80104a3b:	74 16                	je     80104a53 <acquiresleep+0x33>
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104a40:	83 ec 08             	sub    $0x8,%esp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	e8 16 fc ff ff       	call   80104660 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104a4a:	8b 03                	mov    (%ebx),%eax
80104a4c:	83 c4 10             	add    $0x10,%esp
80104a4f:	85 c0                	test   %eax,%eax
80104a51:	75 ed                	jne    80104a40 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104a53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a59:	e8 a2 f1 ff ff       	call   80103c00 <myproc>
80104a5e:	8b 40 10             	mov    0x10(%eax),%eax
80104a61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a6a:	5b                   	pop    %ebx
80104a6b:	5e                   	pop    %esi
80104a6c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104a6d:	e9 ae 02 00 00       	jmp    80104d20 <release>
80104a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a88:	83 ec 0c             	sub    $0xc,%esp
80104a8b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a8e:	56                   	push   %esi
80104a8f:	e8 dc 01 00 00       	call   80104c70 <acquire>
  lk->locked = 0;
80104a94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104aa1:	89 1c 24             	mov    %ebx,(%esp)
80104aa4:	e8 87 fd ff ff       	call   80104830 <wakeup>
  release(&lk->lk);
80104aa9:	89 75 08             	mov    %esi,0x8(%ebp)
80104aac:	83 c4 10             	add    $0x10,%esp
}
80104aaf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab2:	5b                   	pop    %ebx
80104ab3:	5e                   	pop    %esi
80104ab4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104ab5:	e9 66 02 00 00       	jmp    80104d20 <release>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	31 ff                	xor    %edi,%edi
80104ac8:	83 ec 18             	sub    $0x18,%esp
80104acb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ace:	8d 73 04             	lea    0x4(%ebx),%esi
80104ad1:	56                   	push   %esi
80104ad2:	e8 99 01 00 00       	call   80104c70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ad7:	8b 03                	mov    (%ebx),%eax
80104ad9:	83 c4 10             	add    $0x10,%esp
80104adc:	85 c0                	test   %eax,%eax
80104ade:	74 13                	je     80104af3 <holdingsleep+0x33>
80104ae0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ae3:	e8 18 f1 ff ff       	call   80103c00 <myproc>
80104ae8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aeb:	0f 94 c0             	sete   %al
80104aee:	0f b6 c0             	movzbl %al,%eax
80104af1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104af3:	83 ec 0c             	sub    $0xc,%esp
80104af6:	56                   	push   %esi
80104af7:	e8 24 02 00 00       	call   80104d20 <release>
  return r;
}
80104afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aff:	89 f8                	mov    %edi,%eax
80104b01:	5b                   	pop    %ebx
80104b02:	5e                   	pop    %esi
80104b03:	5f                   	pop    %edi
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104b1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104b22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    
80104b2b:	90                   	nop
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b34:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b3a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104b3d:	31 c0                	xor    %eax,%eax
80104b3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b40:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b4c:	77 1a                	ja     80104b68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b4e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b51:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b54:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104b57:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b59:	83 f8 0a             	cmp    $0xa,%eax
80104b5c:	75 e2                	jne    80104b40 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b5e:	5b                   	pop    %ebx
80104b5f:	5d                   	pop    %ebp
80104b60:	c3                   	ret    
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104b68:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b6f:	83 c0 01             	add    $0x1,%eax
80104b72:	83 f8 0a             	cmp    $0xa,%eax
80104b75:	74 e7                	je     80104b5e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104b77:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b7e:	83 c0 01             	add    $0x1,%eax
80104b81:	83 f8 0a             	cmp    $0xa,%eax
80104b84:	75 e2                	jne    80104b68 <getcallerpcs+0x38>
80104b86:	eb d6                	jmp    80104b5e <getcallerpcs+0x2e>
80104b88:	90                   	nop
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	9c                   	pushf  
80104b98:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104b99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b9a:	e8 c1 ef ff ff       	call   80103b60 <mycpu>
80104b9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ba5:	85 c0                	test   %eax,%eax
80104ba7:	75 11                	jne    80104bba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104ba9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104baf:	e8 ac ef ff ff       	call   80103b60 <mycpu>
80104bb4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104bba:	e8 a1 ef ff ff       	call   80103b60 <mycpu>
80104bbf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104bc6:	83 c4 04             	add    $0x4,%esp
80104bc9:	5b                   	pop    %ebx
80104bca:	5d                   	pop    %ebp
80104bcb:	c3                   	ret    
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <popcli>:

void
popcli(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bd6:	9c                   	pushf  
80104bd7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bd8:	f6 c4 02             	test   $0x2,%ah
80104bdb:	75 52                	jne    80104c2f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104bdd:	e8 7e ef ff ff       	call   80103b60 <mycpu>
80104be2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104be8:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104beb:	85 d2                	test   %edx,%edx
80104bed:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104bf3:	78 2d                	js     80104c22 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bf5:	e8 66 ef ff ff       	call   80103b60 <mycpu>
80104bfa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c00:	85 d2                	test   %edx,%edx
80104c02:	74 0c                	je     80104c10 <popcli+0x40>
    sti();
}
80104c04:	c9                   	leave  
80104c05:	c3                   	ret    
80104c06:	8d 76 00             	lea    0x0(%esi),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c10:	e8 4b ef ff ff       	call   80103b60 <mycpu>
80104c15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	74 e5                	je     80104c04 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104c1f:	fb                   	sti    
    sti();
}
80104c20:	c9                   	leave  
80104c21:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104c22:	83 ec 0c             	sub    $0xc,%esp
80104c25:	68 da 81 10 80       	push   $0x801081da
80104c2a:	e8 41 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	68 c3 81 10 80       	push   $0x801081c3
80104c37:	e8 34 b7 ff ff       	call   80100370 <panic>
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	8b 75 08             	mov    0x8(%ebp),%esi
80104c48:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104c4a:	e8 41 ff ff ff       	call   80104b90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c4f:	8b 06                	mov    (%esi),%eax
80104c51:	85 c0                	test   %eax,%eax
80104c53:	74 10                	je     80104c65 <holding+0x25>
80104c55:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c58:	e8 03 ef ff ff       	call   80103b60 <mycpu>
80104c5d:	39 c3                	cmp    %eax,%ebx
80104c5f:	0f 94 c3             	sete   %bl
80104c62:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104c65:	e8 66 ff ff ff       	call   80104bd0 <popcli>
  return r;
}
80104c6a:	89 d8                	mov    %ebx,%eax
80104c6c:	5b                   	pop    %ebx
80104c6d:	5e                   	pop    %esi
80104c6e:	5d                   	pop    %ebp
80104c6f:	c3                   	ret    

80104c70 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c77:	e8 14 ff ff ff       	call   80104b90 <pushcli>
  if(holding(lk))
80104c7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c7f:	83 ec 0c             	sub    $0xc,%esp
80104c82:	53                   	push   %ebx
80104c83:	e8 b8 ff ff ff       	call   80104c40 <holding>
80104c88:	83 c4 10             	add    $0x10,%esp
80104c8b:	85 c0                	test   %eax,%eax
80104c8d:	0f 85 7d 00 00 00    	jne    80104d10 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c93:	ba 01 00 00 00       	mov    $0x1,%edx
80104c98:	eb 09                	jmp    80104ca3 <acquire+0x33>
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ca0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ca3:	89 d0                	mov    %edx,%eax
80104ca5:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104ca8:	85 c0                	test   %eax,%eax
80104caa:	75 f4                	jne    80104ca0 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104cac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104cb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cb4:	e8 a7 ee ff ff       	call   80103b60 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104cb9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104cbb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104cbe:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cc1:	31 c0                	xor    %eax,%eax
80104cc3:	90                   	nop
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cc8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104cce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cd4:	77 1a                	ja     80104cf0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cd6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104cd9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cdc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104cdf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ce1:	83 f8 0a             	cmp    $0xa,%eax
80104ce4:	75 e2                	jne    80104cc8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104ce6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce9:	c9                   	leave  
80104cea:	c3                   	ret    
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104cf0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104cf7:	83 c0 01             	add    $0x1,%eax
80104cfa:	83 f8 0a             	cmp    $0xa,%eax
80104cfd:	74 e7                	je     80104ce6 <acquire+0x76>
    pcs[i] = 0;
80104cff:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d06:	83 c0 01             	add    $0x1,%eax
80104d09:	83 f8 0a             	cmp    $0xa,%eax
80104d0c:	75 e2                	jne    80104cf0 <acquire+0x80>
80104d0e:	eb d6                	jmp    80104ce6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	68 e1 81 10 80       	push   $0x801081e1
80104d18:	e8 53 b6 ff ff       	call   80100370 <panic>
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi

80104d20 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 10             	sub    $0x10,%esp
80104d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d2a:	53                   	push   %ebx
80104d2b:	e8 10 ff ff ff       	call   80104c40 <holding>
80104d30:	83 c4 10             	add    $0x10,%esp
80104d33:	85 c0                	test   %eax,%eax
80104d35:	74 22                	je     80104d59 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104d37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104d45:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104d50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d53:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104d54:	e9 77 fe ff ff       	jmp    80104bd0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104d59:	83 ec 0c             	sub    $0xc,%esp
80104d5c:	68 e9 81 10 80       	push   $0x801081e9
80104d61:	e8 0a b6 ff ff       	call   80100370 <panic>
80104d66:	66 90                	xchg   %ax,%ax
80104d68:	66 90                	xchg   %ax,%ax
80104d6a:	66 90                	xchg   %ax,%ax
80104d6c:	66 90                	xchg   %ax,%ax
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	53                   	push   %ebx
80104d75:	8b 55 08             	mov    0x8(%ebp),%edx
80104d78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d7b:	f6 c2 03             	test   $0x3,%dl
80104d7e:	75 05                	jne    80104d85 <memset+0x15>
80104d80:	f6 c1 03             	test   $0x3,%cl
80104d83:	74 13                	je     80104d98 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104d85:	89 d7                	mov    %edx,%edi
80104d87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d8a:	fc                   	cld    
80104d8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d8d:	5b                   	pop    %ebx
80104d8e:	89 d0                	mov    %edx,%eax
80104d90:	5f                   	pop    %edi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret    
80104d93:	90                   	nop
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104d98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104d9c:	c1 e9 02             	shr    $0x2,%ecx
80104d9f:	89 fb                	mov    %edi,%ebx
80104da1:	89 f8                	mov    %edi,%eax
80104da3:	c1 e3 18             	shl    $0x18,%ebx
80104da6:	c1 e0 10             	shl    $0x10,%eax
80104da9:	09 d8                	or     %ebx,%eax
80104dab:	09 f8                	or     %edi,%eax
80104dad:	c1 e7 08             	shl    $0x8,%edi
80104db0:	09 f8                	or     %edi,%eax
80104db2:	89 d7                	mov    %edx,%edi
80104db4:	fc                   	cld    
80104db5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104db7:	5b                   	pop    %ebx
80104db8:	89 d0                	mov    %edx,%eax
80104dba:	5f                   	pop    %edi
80104dbb:	5d                   	pop    %ebp
80104dbc:	c3                   	ret    
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi

80104dc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
80104dc5:	8b 45 10             	mov    0x10(%ebp),%eax
80104dc8:	53                   	push   %ebx
80104dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104dcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104dcf:	85 c0                	test   %eax,%eax
80104dd1:	74 29                	je     80104dfc <memcmp+0x3c>
    if(*s1 != *s2)
80104dd3:	0f b6 13             	movzbl (%ebx),%edx
80104dd6:	0f b6 0e             	movzbl (%esi),%ecx
80104dd9:	38 d1                	cmp    %dl,%cl
80104ddb:	75 2b                	jne    80104e08 <memcmp+0x48>
80104ddd:	8d 78 ff             	lea    -0x1(%eax),%edi
80104de0:	31 c0                	xor    %eax,%eax
80104de2:	eb 14                	jmp    80104df8 <memcmp+0x38>
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104de8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104ded:	83 c0 01             	add    $0x1,%eax
80104df0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104df4:	38 ca                	cmp    %cl,%dl
80104df6:	75 10                	jne    80104e08 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104df8:	39 f8                	cmp    %edi,%eax
80104dfa:	75 ec                	jne    80104de8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104dfc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104dfd:	31 c0                	xor    %eax,%eax
}
80104dff:	5e                   	pop    %esi
80104e00:	5f                   	pop    %edi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	90                   	nop
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104e08:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104e0b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104e0c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104e0e:	5e                   	pop    %esi
80104e0f:	5f                   	pop    %edi
80104e10:	5d                   	pop    %ebp
80104e11:	c3                   	ret    
80104e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
80104e25:	8b 45 08             	mov    0x8(%ebp),%eax
80104e28:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e2e:	39 c6                	cmp    %eax,%esi
80104e30:	73 2e                	jae    80104e60 <memmove+0x40>
80104e32:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104e35:	39 c8                	cmp    %ecx,%eax
80104e37:	73 27                	jae    80104e60 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104e39:	85 db                	test   %ebx,%ebx
80104e3b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104e3e:	74 17                	je     80104e57 <memmove+0x37>
      *--d = *--s;
80104e40:	29 d9                	sub    %ebx,%ecx
80104e42:	89 cb                	mov    %ecx,%ebx
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e48:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104e4c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104e4f:	83 ea 01             	sub    $0x1,%edx
80104e52:	83 fa ff             	cmp    $0xffffffff,%edx
80104e55:	75 f1                	jne    80104e48 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e57:	5b                   	pop    %ebx
80104e58:	5e                   	pop    %esi
80104e59:	5d                   	pop    %ebp
80104e5a:	c3                   	ret    
80104e5b:	90                   	nop
80104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e60:	31 d2                	xor    %edx,%edx
80104e62:	85 db                	test   %ebx,%ebx
80104e64:	74 f1                	je     80104e57 <memmove+0x37>
80104e66:	8d 76 00             	lea    0x0(%esi),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104e70:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104e74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e77:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e7a:	39 d3                	cmp    %edx,%ebx
80104e7c:	75 f2                	jne    80104e70 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104e7e:	5b                   	pop    %ebx
80104e7f:	5e                   	pop    %esi
80104e80:	5d                   	pop    %ebp
80104e81:	c3                   	ret    
80104e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e93:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e94:	eb 8a                	jmp    80104e20 <memmove>
80104e96:	8d 76 00             	lea    0x0(%esi),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
80104ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ea8:	53                   	push   %ebx
80104ea9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104eac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104eaf:	85 c9                	test   %ecx,%ecx
80104eb1:	74 37                	je     80104eea <strncmp+0x4a>
80104eb3:	0f b6 17             	movzbl (%edi),%edx
80104eb6:	0f b6 1e             	movzbl (%esi),%ebx
80104eb9:	84 d2                	test   %dl,%dl
80104ebb:	74 3f                	je     80104efc <strncmp+0x5c>
80104ebd:	38 d3                	cmp    %dl,%bl
80104ebf:	75 3b                	jne    80104efc <strncmp+0x5c>
80104ec1:	8d 47 01             	lea    0x1(%edi),%eax
80104ec4:	01 cf                	add    %ecx,%edi
80104ec6:	eb 1b                	jmp    80104ee3 <strncmp+0x43>
80104ec8:	90                   	nop
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed0:	0f b6 10             	movzbl (%eax),%edx
80104ed3:	84 d2                	test   %dl,%dl
80104ed5:	74 21                	je     80104ef8 <strncmp+0x58>
80104ed7:	0f b6 19             	movzbl (%ecx),%ebx
80104eda:	83 c0 01             	add    $0x1,%eax
80104edd:	89 ce                	mov    %ecx,%esi
80104edf:	38 da                	cmp    %bl,%dl
80104ee1:	75 19                	jne    80104efc <strncmp+0x5c>
80104ee3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104ee5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104ee8:	75 e6                	jne    80104ed0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104eea:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104eeb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104eed:	5e                   	pop    %esi
80104eee:	5f                   	pop    %edi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret    
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104efc:	0f b6 c2             	movzbl %dl,%eax
80104eff:	29 d8                	sub    %ebx,%eax
}
80104f01:	5b                   	pop    %ebx
80104f02:	5e                   	pop    %esi
80104f03:	5f                   	pop    %edi
80104f04:	5d                   	pop    %ebp
80104f05:	c3                   	ret    
80104f06:	8d 76 00             	lea    0x0(%esi),%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	56                   	push   %esi
80104f14:	53                   	push   %ebx
80104f15:	8b 45 08             	mov    0x8(%ebp),%eax
80104f18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104f1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f1e:	89 c2                	mov    %eax,%edx
80104f20:	eb 19                	jmp    80104f3b <strncpy+0x2b>
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f28:	83 c3 01             	add    $0x1,%ebx
80104f2b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104f2f:	83 c2 01             	add    $0x1,%edx
80104f32:	84 c9                	test   %cl,%cl
80104f34:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f37:	74 09                	je     80104f42 <strncpy+0x32>
80104f39:	89 f1                	mov    %esi,%ecx
80104f3b:	85 c9                	test   %ecx,%ecx
80104f3d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104f40:	7f e6                	jg     80104f28 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f42:	31 c9                	xor    %ecx,%ecx
80104f44:	85 f6                	test   %esi,%esi
80104f46:	7e 17                	jle    80104f5f <strncpy+0x4f>
80104f48:	90                   	nop
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f50:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104f54:	89 f3                	mov    %esi,%ebx
80104f56:	83 c1 01             	add    $0x1,%ecx
80104f59:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104f5b:	85 db                	test   %ebx,%ebx
80104f5d:	7f f1                	jg     80104f50 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104f5f:	5b                   	pop    %ebx
80104f60:	5e                   	pop    %esi
80104f61:	5d                   	pop    %ebp
80104f62:	c3                   	ret    
80104f63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
80104f75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f78:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f7e:	85 c9                	test   %ecx,%ecx
80104f80:	7e 26                	jle    80104fa8 <safestrcpy+0x38>
80104f82:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f86:	89 c1                	mov    %eax,%ecx
80104f88:	eb 17                	jmp    80104fa1 <safestrcpy+0x31>
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f90:	83 c2 01             	add    $0x1,%edx
80104f93:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f97:	83 c1 01             	add    $0x1,%ecx
80104f9a:	84 db                	test   %bl,%bl
80104f9c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f9f:	74 04                	je     80104fa5 <safestrcpy+0x35>
80104fa1:	39 f2                	cmp    %esi,%edx
80104fa3:	75 eb                	jne    80104f90 <safestrcpy+0x20>
    ;
  *s = 0;
80104fa5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104fa8:	5b                   	pop    %ebx
80104fa9:	5e                   	pop    %esi
80104faa:	5d                   	pop    %ebp
80104fab:	c3                   	ret    
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <strlen>:

int
strlen(const char *s)
{
80104fb0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104fb1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104fb3:	89 e5                	mov    %esp,%ebp
80104fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104fb8:	80 3a 00             	cmpb   $0x0,(%edx)
80104fbb:	74 0c                	je     80104fc9 <strlen+0x19>
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
80104fc0:	83 c0 01             	add    $0x1,%eax
80104fc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104fc7:	75 f7                	jne    80104fc0 <strlen+0x10>
    ;
  return n;
}
80104fc9:	5d                   	pop    %ebp
80104fca:	c3                   	ret    

80104fcb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fcb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fcf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104fd3:	55                   	push   %ebp
  pushl %ebx
80104fd4:	53                   	push   %ebx
  pushl %esi
80104fd5:	56                   	push   %esi
  pushl %edi
80104fd6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fd7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fd9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104fdb:	5f                   	pop    %edi
  popl %esi
80104fdc:	5e                   	pop    %esi
  popl %ebx
80104fdd:	5b                   	pop    %ebx
  popl %ebp
80104fde:	5d                   	pop    %ebp
  ret
80104fdf:	c3                   	ret    

80104fe0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	53                   	push   %ebx
80104fe4:	83 ec 04             	sub    $0x4,%esp
80104fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104fea:	e8 11 ec ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fef:	8b 00                	mov    (%eax),%eax
80104ff1:	39 d8                	cmp    %ebx,%eax
80104ff3:	76 1b                	jbe    80105010 <fetchint+0x30>
80104ff5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ff8:	39 d0                	cmp    %edx,%eax
80104ffa:	72 14                	jb     80105010 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fff:	8b 13                	mov    (%ebx),%edx
80105001:	89 10                	mov    %edx,(%eax)
  return 0;
80105003:	31 c0                	xor    %eax,%eax
}
80105005:	83 c4 04             	add    $0x4,%esp
80105008:	5b                   	pop    %ebx
80105009:	5d                   	pop    %ebp
8010500a:	c3                   	ret    
8010500b:	90                   	nop
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105015:	eb ee                	jmp    80105005 <fetchint+0x25>
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 04             	sub    $0x4,%esp
80105027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010502a:	e8 d1 eb ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz)
8010502f:	39 18                	cmp    %ebx,(%eax)
80105031:	76 29                	jbe    8010505c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105036:	89 da                	mov    %ebx,%edx
80105038:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010503a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010503c:	39 c3                	cmp    %eax,%ebx
8010503e:	73 1c                	jae    8010505c <fetchstr+0x3c>
    if(*s == 0)
80105040:	80 3b 00             	cmpb   $0x0,(%ebx)
80105043:	75 10                	jne    80105055 <fetchstr+0x35>
80105045:	eb 29                	jmp    80105070 <fetchstr+0x50>
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105050:	80 3a 00             	cmpb   $0x0,(%edx)
80105053:	74 1b                	je     80105070 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105055:	83 c2 01             	add    $0x1,%edx
80105058:	39 d0                	cmp    %edx,%eax
8010505a:	77 f4                	ja     80105050 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010505c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010505f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80105064:	5b                   	pop    %ebx
80105065:	5d                   	pop    %ebp
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105070:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80105073:	89 d0                	mov    %edx,%eax
80105075:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105077:	5b                   	pop    %ebx
80105078:	5d                   	pop    %ebp
80105079:	c3                   	ret    
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105080 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105085:	e8 76 eb ff ff       	call   80103c00 <myproc>
8010508a:	8b 40 18             	mov    0x18(%eax),%eax
8010508d:	8b 55 08             	mov    0x8(%ebp),%edx
80105090:	8b 40 44             	mov    0x44(%eax),%eax
80105093:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80105096:	e8 65 eb ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010509b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010509d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050a0:	39 c6                	cmp    %eax,%esi
801050a2:	73 1c                	jae    801050c0 <argint+0x40>
801050a4:	8d 53 08             	lea    0x8(%ebx),%edx
801050a7:	39 d0                	cmp    %edx,%eax
801050a9:	72 15                	jb     801050c0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801050ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ae:	8b 53 04             	mov    0x4(%ebx),%edx
801050b1:	89 10                	mov    %edx,(%eax)
  return 0;
801050b3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5d                   	pop    %ebp
801050b8:	c3                   	ret    
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb ee                	jmp    801050b5 <argint+0x35>
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
801050d5:	83 ec 10             	sub    $0x10,%esp
801050d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050db:	e8 20 eb ff ff       	call   80103c00 <myproc>
801050e0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801050e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050e5:	83 ec 08             	sub    $0x8,%esp
801050e8:	50                   	push   %eax
801050e9:	ff 75 08             	pushl  0x8(%ebp)
801050ec:	e8 8f ff ff ff       	call   80105080 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050f1:	c1 e8 1f             	shr    $0x1f,%eax
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	84 c0                	test   %al,%al
801050f9:	75 2d                	jne    80105128 <argptr+0x58>
801050fb:	89 d8                	mov    %ebx,%eax
801050fd:	c1 e8 1f             	shr    $0x1f,%eax
80105100:	84 c0                	test   %al,%al
80105102:	75 24                	jne    80105128 <argptr+0x58>
80105104:	8b 16                	mov    (%esi),%edx
80105106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105109:	39 c2                	cmp    %eax,%edx
8010510b:	76 1b                	jbe    80105128 <argptr+0x58>
8010510d:	01 c3                	add    %eax,%ebx
8010510f:	39 da                	cmp    %ebx,%edx
80105111:	72 15                	jb     80105128 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105113:	8b 55 0c             	mov    0xc(%ebp),%edx
80105116:	89 02                	mov    %eax,(%edx)
  return 0;
80105118:	31 c0                	xor    %eax,%eax
}
8010511a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010511d:	5b                   	pop    %ebx
8010511e:	5e                   	pop    %esi
8010511f:	5d                   	pop    %ebp
80105120:	c3                   	ret    
80105121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512d:	eb eb                	jmp    8010511a <argptr+0x4a>
8010512f:	90                   	nop

80105130 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105136:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105139:	50                   	push   %eax
8010513a:	ff 75 08             	pushl  0x8(%ebp)
8010513d:	e8 3e ff ff ff       	call   80105080 <argint>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	78 17                	js     80105160 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105149:	83 ec 08             	sub    $0x8,%esp
8010514c:	ff 75 0c             	pushl  0xc(%ebp)
8010514f:	ff 75 f4             	pushl  -0xc(%ebp)
80105152:	e8 c9 fe ff ff       	call   80105020 <fetchstr>
80105157:	83 c4 10             	add    $0x10,%esp
}
8010515a:	c9                   	leave  
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105170 <syscall>:
[SYS_getshmem] sys_getshmem,
};

void
syscall(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105175:	e8 86 ea ff ff       	call   80103c00 <myproc>

  num = curproc->tf->eax;
8010517a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010517d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010517f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105182:	8d 50 ff             	lea    -0x1(%eax),%edx
80105185:	83 fa 1c             	cmp    $0x1c,%edx
80105188:	77 1e                	ja     801051a8 <syscall+0x38>
8010518a:	8b 14 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%edx
80105191:	85 d2                	test   %edx,%edx
80105193:	74 13                	je     801051a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105195:	ff d2                	call   *%edx
80105197:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010519a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010519d:	5b                   	pop    %ebx
8010519e:	5e                   	pop    %esi
8010519f:	5d                   	pop    %ebp
801051a0:	c3                   	ret    
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801051a8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051a9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801051ac:	50                   	push   %eax
801051ad:	ff 73 10             	pushl  0x10(%ebx)
801051b0:	68 f1 81 10 80       	push   $0x801081f1
801051b5:	e8 a6 b4 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801051ba:	8b 43 18             	mov    0x18(%ebx),%eax
801051bd:	83 c4 10             	add    $0x10,%esp
801051c0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801051c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ca:	5b                   	pop    %ebx
801051cb:	5e                   	pop    %esi
801051cc:	5d                   	pop    %ebp
801051cd:	c3                   	ret    
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
801051d5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051d6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051d9:	83 ec 34             	sub    $0x34,%esp
801051dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051e2:	56                   	push   %esi
801051e3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051ea:	e8 11 d1 ff ff       	call   80102300 <nameiparent>
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	85 c0                	test   %eax,%eax
801051f4:	0f 84 f6 00 00 00    	je     801052f0 <create+0x120>
    return 0;
  ilock(dp);
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	89 c7                	mov    %eax,%edi
801051ff:	50                   	push   %eax
80105200:	e8 8b c8 ff ff       	call   80101a90 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105205:	83 c4 0c             	add    $0xc,%esp
80105208:	6a 00                	push   $0x0
8010520a:	56                   	push   %esi
8010520b:	57                   	push   %edi
8010520c:	e8 af cd ff ff       	call   80101fc0 <dirlookup>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	85 c0                	test   %eax,%eax
80105216:	89 c3                	mov    %eax,%ebx
80105218:	74 56                	je     80105270 <create+0xa0>
    iunlockput(dp);
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	57                   	push   %edi
8010521e:	e8 fd ca ff ff       	call   80101d20 <iunlockput>
    ilock(ip);
80105223:	89 1c 24             	mov    %ebx,(%esp)
80105226:	e8 65 c8 ff ff       	call   80101a90 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010522b:	83 c4 10             	add    $0x10,%esp
8010522e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105233:	75 1b                	jne    80105250 <create+0x80>
80105235:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010523a:	89 d8                	mov    %ebx,%eax
8010523c:	75 12                	jne    80105250 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010523e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105241:	5b                   	pop    %ebx
80105242:	5e                   	pop    %esi
80105243:	5f                   	pop    %edi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	53                   	push   %ebx
80105254:	e8 c7 ca ff ff       	call   80101d20 <iunlockput>
    return 0;
80105259:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010525c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010525f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105261:	5b                   	pop    %ebx
80105262:	5e                   	pop    %esi
80105263:	5f                   	pop    %edi
80105264:	5d                   	pop    %ebp
80105265:	c3                   	ret    
80105266:	8d 76 00             	lea    0x0(%esi),%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105270:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105274:	83 ec 08             	sub    $0x8,%esp
80105277:	50                   	push   %eax
80105278:	ff 37                	pushl  (%edi)
8010527a:	e8 a1 c6 ff ff       	call   80101920 <ialloc>
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	85 c0                	test   %eax,%eax
80105284:	89 c3                	mov    %eax,%ebx
80105286:	0f 84 cc 00 00 00    	je     80105358 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010528c:	83 ec 0c             	sub    $0xc,%esp
8010528f:	50                   	push   %eax
80105290:	e8 fb c7 ff ff       	call   80101a90 <ilock>
  ip->major = major;
80105295:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105299:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010529d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801052a1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801052a5:	b8 01 00 00 00       	mov    $0x1,%eax
801052aa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801052ae:	89 1c 24             	mov    %ebx,(%esp)
801052b1:	e8 2a c7 ff ff       	call   801019e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801052be:	74 40                	je     80105300 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801052c0:	83 ec 04             	sub    $0x4,%esp
801052c3:	ff 73 04             	pushl  0x4(%ebx)
801052c6:	56                   	push   %esi
801052c7:	57                   	push   %edi
801052c8:	e8 53 cf ff ff       	call   80102220 <dirlink>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 77                	js     8010534b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	57                   	push   %edi
801052d8:	e8 43 ca ff ff       	call   80101d20 <iunlockput>

  return ip;
801052dd:	83 c4 10             	add    $0x10,%esp
}
801052e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801052e3:	89 d8                	mov    %ebx,%eax
}
801052e5:	5b                   	pop    %ebx
801052e6:	5e                   	pop    %esi
801052e7:	5f                   	pop    %edi
801052e8:	5d                   	pop    %ebp
801052e9:	c3                   	ret    
801052ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801052f0:	31 c0                	xor    %eax,%eax
801052f2:	e9 47 ff ff ff       	jmp    8010523e <create+0x6e>
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105300:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105305:	83 ec 0c             	sub    $0xc,%esp
80105308:	57                   	push   %edi
80105309:	e8 d2 c6 ff ff       	call   801019e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010530e:	83 c4 0c             	add    $0xc,%esp
80105311:	ff 73 04             	pushl  0x4(%ebx)
80105314:	68 b4 82 10 80       	push   $0x801082b4
80105319:	53                   	push   %ebx
8010531a:	e8 01 cf ff ff       	call   80102220 <dirlink>
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	85 c0                	test   %eax,%eax
80105324:	78 18                	js     8010533e <create+0x16e>
80105326:	83 ec 04             	sub    $0x4,%esp
80105329:	ff 77 04             	pushl  0x4(%edi)
8010532c:	68 b3 82 10 80       	push   $0x801082b3
80105331:	53                   	push   %ebx
80105332:	e8 e9 ce ff ff       	call   80102220 <dirlink>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	85 c0                	test   %eax,%eax
8010533c:	79 82                	jns    801052c0 <create+0xf0>
      panic("create dots");
8010533e:	83 ec 0c             	sub    $0xc,%esp
80105341:	68 a7 82 10 80       	push   $0x801082a7
80105346:	e8 25 b0 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010534b:	83 ec 0c             	sub    $0xc,%esp
8010534e:	68 b6 82 10 80       	push   $0x801082b6
80105353:	e8 18 b0 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105358:	83 ec 0c             	sub    $0xc,%esp
8010535b:	68 98 82 10 80       	push   $0x80108298
80105360:	e8 0b b0 ff ff       	call   80100370 <panic>
80105365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	53                   	push   %ebx
80105375:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105377:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010537a:	89 d3                	mov    %edx,%ebx
8010537c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010537f:	50                   	push   %eax
80105380:	6a 00                	push   $0x0
80105382:	e8 f9 fc ff ff       	call   80105080 <argint>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	78 32                	js     801053c0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010538e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105392:	77 2c                	ja     801053c0 <argfd.constprop.0+0x50>
80105394:	e8 67 e8 ff ff       	call   80103c00 <myproc>
80105399:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010539c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053a0:	85 c0                	test   %eax,%eax
801053a2:	74 1c                	je     801053c0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801053a4:	85 f6                	test   %esi,%esi
801053a6:	74 02                	je     801053aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801053a8:	89 16                	mov    %edx,(%esi)
  if(pf)
801053aa:	85 db                	test   %ebx,%ebx
801053ac:	74 22                	je     801053d0 <argfd.constprop.0+0x60>
    *pf = f;
801053ae:	89 03                	mov    %eax,(%ebx)
  return 0;
801053b0:	31 c0                	xor    %eax,%eax
}
801053b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b5:	5b                   	pop    %ebx
801053b6:	5e                   	pop    %esi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801053c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801053c8:	5b                   	pop    %ebx
801053c9:	5e                   	pop    %esi
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801053d0:	31 c0                	xor    %eax,%eax
801053d2:	eb de                	jmp    801053b2 <argfd.constprop.0+0x42>
801053d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801053e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801053e0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053e1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	56                   	push   %esi
801053e6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801053ea:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053ed:	e8 7e ff ff ff       	call   80105370 <argfd.constprop.0>
801053f2:	85 c0                	test   %eax,%eax
801053f4:	78 1a                	js     80105410 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053f6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801053f8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801053fb:	e8 00 e8 ff ff       	call   80103c00 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105400:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105404:	85 d2                	test   %edx,%edx
80105406:	74 18                	je     80105420 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105408:	83 c3 01             	add    $0x1,%ebx
8010540b:	83 fb 10             	cmp    $0x10,%ebx
8010540e:	75 f0                	jne    80105400 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105410:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105418:	5b                   	pop    %ebx
80105419:	5e                   	pop    %esi
8010541a:	5d                   	pop    %ebp
8010541b:	c3                   	ret    
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105420:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	ff 75 f4             	pushl  -0xc(%ebp)
8010542a:	e8 e1 bd ff ff       	call   80101210 <filedup>
  return fd;
8010542f:	83 c4 10             	add    $0x10,%esp
}
80105432:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105435:	89 d8                	mov    %ebx,%eax
}
80105437:	5b                   	pop    %ebx
80105438:	5e                   	pop    %esi
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    
8010543b:	90                   	nop
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_read>:

int
sys_read(void)
{
80105440:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105441:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105443:	89 e5                	mov    %esp,%ebp
80105445:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105448:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010544b:	e8 20 ff ff ff       	call   80105370 <argfd.constprop.0>
80105450:	85 c0                	test   %eax,%eax
80105452:	78 4c                	js     801054a0 <sys_read+0x60>
80105454:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	50                   	push   %eax
8010545b:	6a 02                	push   $0x2
8010545d:	e8 1e fc ff ff       	call   80105080 <argint>
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	85 c0                	test   %eax,%eax
80105467:	78 37                	js     801054a0 <sys_read+0x60>
80105469:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546c:	83 ec 04             	sub    $0x4,%esp
8010546f:	ff 75 f0             	pushl  -0x10(%ebp)
80105472:	50                   	push   %eax
80105473:	6a 01                	push   $0x1
80105475:	e8 56 fc ff ff       	call   801050d0 <argptr>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	85 c0                	test   %eax,%eax
8010547f:	78 1f                	js     801054a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105481:	83 ec 04             	sub    $0x4,%esp
80105484:	ff 75 f0             	pushl  -0x10(%ebp)
80105487:	ff 75 f4             	pushl  -0xc(%ebp)
8010548a:	ff 75 ec             	pushl  -0x14(%ebp)
8010548d:	e8 ee be ff ff       	call   80101380 <fileread>
80105492:	83 c4 10             	add    $0x10,%esp
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_write>:

int
sys_write(void)
{
801054b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054b1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
801054b3:	89 e5                	mov    %esp,%ebp
801054b5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054bb:	e8 b0 fe ff ff       	call   80105370 <argfd.constprop.0>
801054c0:	85 c0                	test   %eax,%eax
801054c2:	78 4c                	js     80105510 <sys_write+0x60>
801054c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054c7:	83 ec 08             	sub    $0x8,%esp
801054ca:	50                   	push   %eax
801054cb:	6a 02                	push   $0x2
801054cd:	e8 ae fb ff ff       	call   80105080 <argint>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 37                	js     80105510 <sys_write+0x60>
801054d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054dc:	83 ec 04             	sub    $0x4,%esp
801054df:	ff 75 f0             	pushl  -0x10(%ebp)
801054e2:	50                   	push   %eax
801054e3:	6a 01                	push   $0x1
801054e5:	e8 e6 fb ff ff       	call   801050d0 <argptr>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	85 c0                	test   %eax,%eax
801054ef:	78 1f                	js     80105510 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801054f1:	83 ec 04             	sub    $0x4,%esp
801054f4:	ff 75 f0             	pushl  -0x10(%ebp)
801054f7:	ff 75 f4             	pushl  -0xc(%ebp)
801054fa:	ff 75 ec             	pushl  -0x14(%ebp)
801054fd:	e8 0e bf ff ff       	call   80101410 <filewrite>
80105502:	83 c4 10             	add    $0x10,%esp
}
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105515:	c9                   	leave  
80105516:	c3                   	ret    
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <sys_close>:

int
sys_close(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105526:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105529:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010552c:	e8 3f fe ff ff       	call   80105370 <argfd.constprop.0>
80105531:	85 c0                	test   %eax,%eax
80105533:	78 2b                	js     80105560 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105535:	e8 c6 e6 ff ff       	call   80103c00 <myproc>
8010553a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010553d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105540:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105547:	00 
  fileclose(f);
80105548:	ff 75 f4             	pushl  -0xc(%ebp)
8010554b:	e8 10 bd ff ff       	call   80101260 <fileclose>
  return 0;
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	31 c0                	xor    %eax,%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <sys_fstat>:

int
sys_fstat(void)
{
80105570:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105571:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105573:	89 e5                	mov    %esp,%ebp
80105575:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105578:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010557b:	e8 f0 fd ff ff       	call   80105370 <argfd.constprop.0>
80105580:	85 c0                	test   %eax,%eax
80105582:	78 2c                	js     801055b0 <sys_fstat+0x40>
80105584:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105587:	83 ec 04             	sub    $0x4,%esp
8010558a:	6a 14                	push   $0x14
8010558c:	50                   	push   %eax
8010558d:	6a 01                	push   $0x1
8010558f:	e8 3c fb ff ff       	call   801050d0 <argptr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	78 15                	js     801055b0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010559b:	83 ec 08             	sub    $0x8,%esp
8010559e:	ff 75 f4             	pushl  -0xc(%ebp)
801055a1:	ff 75 f0             	pushl  -0x10(%ebp)
801055a4:	e8 87 bd ff ff       	call   80101330 <filestat>
801055a9:	83 c4 10             	add    $0x10,%esp
}
801055ac:	c9                   	leave  
801055ad:	c3                   	ret    
801055ae:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055c9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055cc:	50                   	push   %eax
801055cd:	6a 00                	push   $0x0
801055cf:	e8 5c fb ff ff       	call   80105130 <argstr>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	0f 88 fb 00 00 00    	js     801056da <sys_link+0x11a>
801055df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055e2:	83 ec 08             	sub    $0x8,%esp
801055e5:	50                   	push   %eax
801055e6:	6a 01                	push   $0x1
801055e8:	e8 43 fb ff ff       	call   80105130 <argstr>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	0f 88 e2 00 00 00    	js     801056da <sys_link+0x11a>
    return -1;

  begin_op();
801055f8:	e8 73 d9 ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	ff 75 d4             	pushl  -0x2c(%ebp)
80105603:	e8 d8 cc ff ff       	call   801022e0 <namei>
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	85 c0                	test   %eax,%eax
8010560d:	89 c3                	mov    %eax,%ebx
8010560f:	0f 84 f3 00 00 00    	je     80105708 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105615:	83 ec 0c             	sub    $0xc,%esp
80105618:	50                   	push   %eax
80105619:	e8 72 c4 ff ff       	call   80101a90 <ilock>
  if(ip->type == T_DIR){
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105626:	0f 84 c4 00 00 00    	je     801056f0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010562c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105631:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105634:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105637:	53                   	push   %ebx
80105638:	e8 a3 c3 ff ff       	call   801019e0 <iupdate>
  iunlock(ip);
8010563d:	89 1c 24             	mov    %ebx,(%esp)
80105640:	e8 2b c5 ff ff       	call   80101b70 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105645:	58                   	pop    %eax
80105646:	5a                   	pop    %edx
80105647:	57                   	push   %edi
80105648:	ff 75 d0             	pushl  -0x30(%ebp)
8010564b:	e8 b0 cc ff ff       	call   80102300 <nameiparent>
80105650:	83 c4 10             	add    $0x10,%esp
80105653:	85 c0                	test   %eax,%eax
80105655:	89 c6                	mov    %eax,%esi
80105657:	74 5b                	je     801056b4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105659:	83 ec 0c             	sub    $0xc,%esp
8010565c:	50                   	push   %eax
8010565d:	e8 2e c4 ff ff       	call   80101a90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	8b 03                	mov    (%ebx),%eax
80105667:	39 06                	cmp    %eax,(%esi)
80105669:	75 3d                	jne    801056a8 <sys_link+0xe8>
8010566b:	83 ec 04             	sub    $0x4,%esp
8010566e:	ff 73 04             	pushl  0x4(%ebx)
80105671:	57                   	push   %edi
80105672:	56                   	push   %esi
80105673:	e8 a8 cb ff ff       	call   80102220 <dirlink>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	85 c0                	test   %eax,%eax
8010567d:	78 29                	js     801056a8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010567f:	83 ec 0c             	sub    $0xc,%esp
80105682:	56                   	push   %esi
80105683:	e8 98 c6 ff ff       	call   80101d20 <iunlockput>
  iput(ip);
80105688:	89 1c 24             	mov    %ebx,(%esp)
8010568b:	e8 30 c5 ff ff       	call   80101bc0 <iput>

  end_op();
80105690:	e8 4b d9 ff ff       	call   80102fe0 <end_op>

  return 0;
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010569a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010569d:	5b                   	pop    %ebx
8010569e:	5e                   	pop    %esi
8010569f:	5f                   	pop    %edi
801056a0:	5d                   	pop    %ebp
801056a1:	c3                   	ret    
801056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801056a8:	83 ec 0c             	sub    $0xc,%esp
801056ab:	56                   	push   %esi
801056ac:	e8 6f c6 ff ff       	call   80101d20 <iunlockput>
    goto bad;
801056b1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	53                   	push   %ebx
801056b8:	e8 d3 c3 ff ff       	call   80101a90 <ilock>
  ip->nlink--;
801056bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056c2:	89 1c 24             	mov    %ebx,(%esp)
801056c5:	e8 16 c3 ff ff       	call   801019e0 <iupdate>
  iunlockput(ip);
801056ca:	89 1c 24             	mov    %ebx,(%esp)
801056cd:	e8 4e c6 ff ff       	call   80101d20 <iunlockput>
  end_op();
801056d2:	e8 09 d9 ff ff       	call   80102fe0 <end_op>
  return -1;
801056d7:	83 c4 10             	add    $0x10,%esp
}
801056da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801056dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e2:	5b                   	pop    %ebx
801056e3:	5e                   	pop    %esi
801056e4:	5f                   	pop    %edi
801056e5:	5d                   	pop    %ebp
801056e6:	c3                   	ret    
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 27 c6 ff ff       	call   80101d20 <iunlockput>
    end_op();
801056f9:	e8 e2 d8 ff ff       	call   80102fe0 <end_op>
    return -1;
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105706:	eb 92                	jmp    8010569a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105708:	e8 d3 d8 ff ff       	call   80102fe0 <end_op>
    return -1;
8010570d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105712:	eb 86                	jmp    8010569a <sys_link+0xda>
80105714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010571a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105720 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	56                   	push   %esi
80105725:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105726:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105729:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010572c:	50                   	push   %eax
8010572d:	6a 00                	push   $0x0
8010572f:	e8 fc f9 ff ff       	call   80105130 <argstr>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	85 c0                	test   %eax,%eax
80105739:	0f 88 82 01 00 00    	js     801058c1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010573f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105742:	e8 29 d8 ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105747:	83 ec 08             	sub    $0x8,%esp
8010574a:	53                   	push   %ebx
8010574b:	ff 75 c0             	pushl  -0x40(%ebp)
8010574e:	e8 ad cb ff ff       	call   80102300 <nameiparent>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010575b:	0f 84 6a 01 00 00    	je     801058cb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105761:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	56                   	push   %esi
80105768:	e8 23 c3 ff ff       	call   80101a90 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010576d:	58                   	pop    %eax
8010576e:	5a                   	pop    %edx
8010576f:	68 b4 82 10 80       	push   $0x801082b4
80105774:	53                   	push   %ebx
80105775:	e8 26 c8 ff ff       	call   80101fa0 <namecmp>
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	85 c0                	test   %eax,%eax
8010577f:	0f 84 fc 00 00 00    	je     80105881 <sys_unlink+0x161>
80105785:	83 ec 08             	sub    $0x8,%esp
80105788:	68 b3 82 10 80       	push   $0x801082b3
8010578d:	53                   	push   %ebx
8010578e:	e8 0d c8 ff ff       	call   80101fa0 <namecmp>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	0f 84 e3 00 00 00    	je     80105881 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010579e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057a1:	83 ec 04             	sub    $0x4,%esp
801057a4:	50                   	push   %eax
801057a5:	53                   	push   %ebx
801057a6:	56                   	push   %esi
801057a7:	e8 14 c8 ff ff       	call   80101fc0 <dirlookup>
801057ac:	83 c4 10             	add    $0x10,%esp
801057af:	85 c0                	test   %eax,%eax
801057b1:	89 c3                	mov    %eax,%ebx
801057b3:	0f 84 c8 00 00 00    	je     80105881 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801057b9:	83 ec 0c             	sub    $0xc,%esp
801057bc:	50                   	push   %eax
801057bd:	e8 ce c2 ff ff       	call   80101a90 <ilock>

  if(ip->nlink < 1)
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057ca:	0f 8e 24 01 00 00    	jle    801058f4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801057d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057d5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801057d8:	74 66                	je     80105840 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801057da:	83 ec 04             	sub    $0x4,%esp
801057dd:	6a 10                	push   $0x10
801057df:	6a 00                	push   $0x0
801057e1:	56                   	push   %esi
801057e2:	e8 89 f5 ff ff       	call   80104d70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057e7:	6a 10                	push   $0x10
801057e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057ec:	56                   	push   %esi
801057ed:	ff 75 b4             	pushl  -0x4c(%ebp)
801057f0:	e8 7b c6 ff ff       	call   80101e70 <writei>
801057f5:	83 c4 20             	add    $0x20,%esp
801057f8:	83 f8 10             	cmp    $0x10,%eax
801057fb:	0f 85 e6 00 00 00    	jne    801058e7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105801:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105806:	0f 84 9c 00 00 00    	je     801058a8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105812:	e8 09 c5 ff ff       	call   80101d20 <iunlockput>

  ip->nlink--;
80105817:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010581c:	89 1c 24             	mov    %ebx,(%esp)
8010581f:	e8 bc c1 ff ff       	call   801019e0 <iupdate>
  iunlockput(ip);
80105824:	89 1c 24             	mov    %ebx,(%esp)
80105827:	e8 f4 c4 ff ff       	call   80101d20 <iunlockput>

  end_op();
8010582c:	e8 af d7 ff ff       	call   80102fe0 <end_op>

  return 0;
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105839:	5b                   	pop    %ebx
8010583a:	5e                   	pop    %esi
8010583b:	5f                   	pop    %edi
8010583c:	5d                   	pop    %ebp
8010583d:	c3                   	ret    
8010583e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105840:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105844:	76 94                	jbe    801057da <sys_unlink+0xba>
80105846:	bf 20 00 00 00       	mov    $0x20,%edi
8010584b:	eb 0f                	jmp    8010585c <sys_unlink+0x13c>
8010584d:	8d 76 00             	lea    0x0(%esi),%esi
80105850:	83 c7 10             	add    $0x10,%edi
80105853:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105856:	0f 83 7e ff ff ff    	jae    801057da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010585c:	6a 10                	push   $0x10
8010585e:	57                   	push   %edi
8010585f:	56                   	push   %esi
80105860:	53                   	push   %ebx
80105861:	e8 0a c5 ff ff       	call   80101d70 <readi>
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	83 f8 10             	cmp    $0x10,%eax
8010586c:	75 6c                	jne    801058da <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010586e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105873:	74 db                	je     80105850 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105875:	83 ec 0c             	sub    $0xc,%esp
80105878:	53                   	push   %ebx
80105879:	e8 a2 c4 ff ff       	call   80101d20 <iunlockput>
    goto bad;
8010587e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105881:	83 ec 0c             	sub    $0xc,%esp
80105884:	ff 75 b4             	pushl  -0x4c(%ebp)
80105887:	e8 94 c4 ff ff       	call   80101d20 <iunlockput>
  end_op();
8010588c:	e8 4f d7 ff ff       	call   80102fe0 <end_op>
  return -1;
80105891:	83 c4 10             	add    $0x10,%esp
}
80105894:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010589c:	5b                   	pop    %ebx
8010589d:	5e                   	pop    %esi
8010589e:	5f                   	pop    %edi
8010589f:	5d                   	pop    %ebp
801058a0:	c3                   	ret    
801058a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801058a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801058ab:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801058ae:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801058b3:	50                   	push   %eax
801058b4:	e8 27 c1 ff ff       	call   801019e0 <iupdate>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	e9 4b ff ff ff       	jmp    8010580c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801058c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c6:	e9 6b ff ff ff       	jmp    80105836 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801058cb:	e8 10 d7 ff ff       	call   80102fe0 <end_op>
    return -1;
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d5:	e9 5c ff ff ff       	jmp    80105836 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	68 d8 82 10 80       	push   $0x801082d8
801058e2:	e8 89 aa ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801058e7:	83 ec 0c             	sub    $0xc,%esp
801058ea:	68 ea 82 10 80       	push   $0x801082ea
801058ef:	e8 7c aa ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801058f4:	83 ec 0c             	sub    $0xc,%esp
801058f7:	68 c6 82 10 80       	push   $0x801082c6
801058fc:	e8 6f aa ff ff       	call   80100370 <panic>
80105901:	eb 0d                	jmp    80105910 <sys_open>
80105903:	90                   	nop
80105904:	90                   	nop
80105905:	90                   	nop
80105906:	90                   	nop
80105907:	90                   	nop
80105908:	90                   	nop
80105909:	90                   	nop
8010590a:	90                   	nop
8010590b:	90                   	nop
8010590c:	90                   	nop
8010590d:	90                   	nop
8010590e:	90                   	nop
8010590f:	90                   	nop

80105910 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105916:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105919:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010591c:	50                   	push   %eax
8010591d:	6a 00                	push   $0x0
8010591f:	e8 0c f8 ff ff       	call   80105130 <argstr>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	0f 88 9e 00 00 00    	js     801059cd <sys_open+0xbd>
8010592f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105932:	83 ec 08             	sub    $0x8,%esp
80105935:	50                   	push   %eax
80105936:	6a 01                	push   $0x1
80105938:	e8 43 f7 ff ff       	call   80105080 <argint>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	0f 88 85 00 00 00    	js     801059cd <sys_open+0xbd>
    return -1;

  begin_op();
80105948:	e8 23 d6 ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
8010594d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105951:	0f 85 89 00 00 00    	jne    801059e0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105957:	83 ec 0c             	sub    $0xc,%esp
8010595a:	ff 75 e0             	pushl  -0x20(%ebp)
8010595d:	e8 7e c9 ff ff       	call   801022e0 <namei>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	89 c6                	mov    %eax,%esi
80105969:	0f 84 8e 00 00 00    	je     801059fd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010596f:	83 ec 0c             	sub    $0xc,%esp
80105972:	50                   	push   %eax
80105973:	e8 18 c1 ff ff       	call   80101a90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105978:	83 c4 10             	add    $0x10,%esp
8010597b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105980:	0f 84 d2 00 00 00    	je     80105a58 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105986:	e8 15 b8 ff ff       	call   801011a0 <filealloc>
8010598b:	85 c0                	test   %eax,%eax
8010598d:	89 c7                	mov    %eax,%edi
8010598f:	74 2b                	je     801059bc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105991:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105993:	e8 68 e2 ff ff       	call   80103c00 <myproc>
80105998:	90                   	nop
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801059a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801059a4:	85 d2                	test   %edx,%edx
801059a6:	74 68                	je     80105a10 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059a8:	83 c3 01             	add    $0x1,%ebx
801059ab:	83 fb 10             	cmp    $0x10,%ebx
801059ae:	75 f0                	jne    801059a0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	57                   	push   %edi
801059b4:	e8 a7 b8 ff ff       	call   80101260 <fileclose>
801059b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801059bc:	83 ec 0c             	sub    $0xc,%esp
801059bf:	56                   	push   %esi
801059c0:	e8 5b c3 ff ff       	call   80101d20 <iunlockput>
    end_op();
801059c5:	e8 16 d6 ff ff       	call   80102fe0 <end_op>
    return -1;
801059ca:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801059cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801059d5:	5b                   	pop    %ebx
801059d6:	5e                   	pop    %esi
801059d7:	5f                   	pop    %edi
801059d8:	5d                   	pop    %ebp
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059e6:	31 c9                	xor    %ecx,%ecx
801059e8:	6a 00                	push   $0x0
801059ea:	ba 02 00 00 00       	mov    $0x2,%edx
801059ef:	e8 dc f7 ff ff       	call   801051d0 <create>
    if(ip == 0){
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801059f9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059fb:	75 89                	jne    80105986 <sys_open+0x76>
      end_op();
801059fd:	e8 de d5 ff ff       	call   80102fe0 <end_op>
      return -1;
80105a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a07:	eb 43                	jmp    80105a4c <sys_open+0x13c>
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a10:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105a13:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a17:	56                   	push   %esi
80105a18:	e8 53 c1 ff ff       	call   80101b70 <iunlock>
  end_op();
80105a1d:	e8 be d5 ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
80105a22:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a2b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105a2e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105a31:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a38:	89 d0                	mov    %edx,%eax
80105a3a:	83 e0 01             	and    $0x1,%eax
80105a3d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a40:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a43:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a46:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105a4a:	89 d8                	mov    %ebx,%eax
}
80105a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a4f:	5b                   	pop    %ebx
80105a50:	5e                   	pop    %esi
80105a51:	5f                   	pop    %edi
80105a52:	5d                   	pop    %ebp
80105a53:	c3                   	ret    
80105a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a58:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a5b:	85 c9                	test   %ecx,%ecx
80105a5d:	0f 84 23 ff ff ff    	je     80105986 <sys_open+0x76>
80105a63:	e9 54 ff ff ff       	jmp    801059bc <sys_open+0xac>
80105a68:	90                   	nop
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a70 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a76:	e8 f5 d4 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a7e:	83 ec 08             	sub    $0x8,%esp
80105a81:	50                   	push   %eax
80105a82:	6a 00                	push   $0x0
80105a84:	e8 a7 f6 ff ff       	call   80105130 <argstr>
80105a89:	83 c4 10             	add    $0x10,%esp
80105a8c:	85 c0                	test   %eax,%eax
80105a8e:	78 30                	js     80105ac0 <sys_mkdir+0x50>
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a96:	31 c9                	xor    %ecx,%ecx
80105a98:	6a 00                	push   $0x0
80105a9a:	ba 01 00 00 00       	mov    $0x1,%edx
80105a9f:	e8 2c f7 ff ff       	call   801051d0 <create>
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	74 15                	je     80105ac0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105aab:	83 ec 0c             	sub    $0xc,%esp
80105aae:	50                   	push   %eax
80105aaf:	e8 6c c2 ff ff       	call   80101d20 <iunlockput>
  end_op();
80105ab4:	e8 27 d5 ff ff       	call   80102fe0 <end_op>
  return 0;
80105ab9:	83 c4 10             	add    $0x10,%esp
80105abc:	31 c0                	xor    %eax,%eax
}
80105abe:	c9                   	leave  
80105abf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105ac0:	e8 1b d5 ff ff       	call   80102fe0 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105aca:	c9                   	leave  
80105acb:	c3                   	ret    
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_mknod>:

int
sys_mknod(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ad6:	e8 95 d4 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105adb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ade:	83 ec 08             	sub    $0x8,%esp
80105ae1:	50                   	push   %eax
80105ae2:	6a 00                	push   $0x0
80105ae4:	e8 47 f6 ff ff       	call   80105130 <argstr>
80105ae9:	83 c4 10             	add    $0x10,%esp
80105aec:	85 c0                	test   %eax,%eax
80105aee:	78 60                	js     80105b50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105af0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105af3:	83 ec 08             	sub    $0x8,%esp
80105af6:	50                   	push   %eax
80105af7:	6a 01                	push   $0x1
80105af9:	e8 82 f5 ff ff       	call   80105080 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	85 c0                	test   %eax,%eax
80105b03:	78 4b                	js     80105b50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105b05:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	50                   	push   %eax
80105b0c:	6a 02                	push   $0x2
80105b0e:	e8 6d f5 ff ff       	call   80105080 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	85 c0                	test   %eax,%eax
80105b18:	78 36                	js     80105b50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105b1a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b1e:	83 ec 0c             	sub    $0xc,%esp
80105b21:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b25:	ba 03 00 00 00       	mov    $0x3,%edx
80105b2a:	50                   	push   %eax
80105b2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b2e:	e8 9d f6 ff ff       	call   801051d0 <create>
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 c0                	test   %eax,%eax
80105b38:	74 16                	je     80105b50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b3a:	83 ec 0c             	sub    $0xc,%esp
80105b3d:	50                   	push   %eax
80105b3e:	e8 dd c1 ff ff       	call   80101d20 <iunlockput>
  end_op();
80105b43:	e8 98 d4 ff ff       	call   80102fe0 <end_op>
  return 0;
80105b48:	83 c4 10             	add    $0x10,%esp
80105b4b:	31 c0                	xor    %eax,%eax
}
80105b4d:	c9                   	leave  
80105b4e:	c3                   	ret    
80105b4f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105b50:	e8 8b d4 ff ff       	call   80102fe0 <end_op>
    return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105b5a:	c9                   	leave  
80105b5b:	c3                   	ret    
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_chdir>:

int
sys_chdir(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	56                   	push   %esi
80105b64:	53                   	push   %ebx
80105b65:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b68:	e8 93 e0 ff ff       	call   80103c00 <myproc>
80105b6d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b6f:	e8 fc d3 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b77:	83 ec 08             	sub    $0x8,%esp
80105b7a:	50                   	push   %eax
80105b7b:	6a 00                	push   $0x0
80105b7d:	e8 ae f5 ff ff       	call   80105130 <argstr>
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	85 c0                	test   %eax,%eax
80105b87:	78 77                	js     80105c00 <sys_chdir+0xa0>
80105b89:	83 ec 0c             	sub    $0xc,%esp
80105b8c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b8f:	e8 4c c7 ff ff       	call   801022e0 <namei>
80105b94:	83 c4 10             	add    $0x10,%esp
80105b97:	85 c0                	test   %eax,%eax
80105b99:	89 c3                	mov    %eax,%ebx
80105b9b:	74 63                	je     80105c00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	50                   	push   %eax
80105ba1:	e8 ea be ff ff       	call   80101a90 <ilock>
  if(ip->type != T_DIR){
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bae:	75 30                	jne    80105be0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	53                   	push   %ebx
80105bb4:	e8 b7 bf ff ff       	call   80101b70 <iunlock>
  iput(curproc->cwd);
80105bb9:	58                   	pop    %eax
80105bba:	ff 76 68             	pushl  0x68(%esi)
80105bbd:	e8 fe bf ff ff       	call   80101bc0 <iput>
  end_op();
80105bc2:	e8 19 d4 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
80105bc7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105bca:	83 c4 10             	add    $0x10,%esp
80105bcd:	31 c0                	xor    %eax,%eax
}
80105bcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bd2:	5b                   	pop    %ebx
80105bd3:	5e                   	pop    %esi
80105bd4:	5d                   	pop    %ebp
80105bd5:	c3                   	ret    
80105bd6:	8d 76 00             	lea    0x0(%esi),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	53                   	push   %ebx
80105be4:	e8 37 c1 ff ff       	call   80101d20 <iunlockput>
    end_op();
80105be9:	e8 f2 d3 ff ff       	call   80102fe0 <end_op>
    return -1;
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf6:	eb d7                	jmp    80105bcf <sys_chdir+0x6f>
80105bf8:	90                   	nop
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105c00:	e8 db d3 ff ff       	call   80102fe0 <end_op>
    return -1;
80105c05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0a:	eb c3                	jmp    80105bcf <sys_chdir+0x6f>
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c16:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105c1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c22:	50                   	push   %eax
80105c23:	6a 00                	push   $0x0
80105c25:	e8 06 f5 ff ff       	call   80105130 <argstr>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	78 7f                	js     80105cb0 <sys_exec+0xa0>
80105c31:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c37:	83 ec 08             	sub    $0x8,%esp
80105c3a:	50                   	push   %eax
80105c3b:	6a 01                	push   $0x1
80105c3d:	e8 3e f4 ff ff       	call   80105080 <argint>
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	85 c0                	test   %eax,%eax
80105c47:	78 67                	js     80105cb0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c49:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c4f:	83 ec 04             	sub    $0x4,%esp
80105c52:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105c58:	68 80 00 00 00       	push   $0x80
80105c5d:	6a 00                	push   $0x0
80105c5f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c65:	50                   	push   %eax
80105c66:	31 db                	xor    %ebx,%ebx
80105c68:	e8 03 f1 ff ff       	call   80104d70 <memset>
80105c6d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c70:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c76:	83 ec 08             	sub    $0x8,%esp
80105c79:	57                   	push   %edi
80105c7a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105c7d:	50                   	push   %eax
80105c7e:	e8 5d f3 ff ff       	call   80104fe0 <fetchint>
80105c83:	83 c4 10             	add    $0x10,%esp
80105c86:	85 c0                	test   %eax,%eax
80105c88:	78 26                	js     80105cb0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105c8a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c90:	85 c0                	test   %eax,%eax
80105c92:	74 2c                	je     80105cc0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c94:	83 ec 08             	sub    $0x8,%esp
80105c97:	56                   	push   %esi
80105c98:	50                   	push   %eax
80105c99:	e8 82 f3 ff ff       	call   80105020 <fetchstr>
80105c9e:	83 c4 10             	add    $0x10,%esp
80105ca1:	85 c0                	test   %eax,%eax
80105ca3:	78 0b                	js     80105cb0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105ca5:	83 c3 01             	add    $0x1,%ebx
80105ca8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105cab:	83 fb 20             	cmp    $0x20,%ebx
80105cae:	75 c0                	jne    80105c70 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105cb8:	5b                   	pop    %ebx
80105cb9:	5e                   	pop    %esi
80105cba:	5f                   	pop    %edi
80105cbb:	5d                   	pop    %ebp
80105cbc:	c3                   	ret    
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cc0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105cc6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105cc9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cd0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cd4:	50                   	push   %eax
80105cd5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105cdb:	e8 10 ad ff ff       	call   801009f0 <exec>
80105ce0:	83 c4 10             	add    $0x10,%esp
}
80105ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce6:	5b                   	pop    %ebx
80105ce7:	5e                   	pop    %esi
80105ce8:	5f                   	pop    %edi
80105ce9:	5d                   	pop    %ebp
80105cea:	c3                   	ret    
80105ceb:	90                   	nop
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_exec2>:


int
sys_exec2(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cf6:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
80105cfc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d02:	50                   	push   %eax
80105d03:	6a 00                	push   $0x0
80105d05:	e8 26 f4 ff ff       	call   80105130 <argstr>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	78 7f                	js     80105d90 <sys_exec2+0xa0>
80105d11:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105d17:	83 ec 08             	sub    $0x8,%esp
80105d1a:	50                   	push   %eax
80105d1b:	6a 01                	push   $0x1
80105d1d:	e8 5e f3 ff ff       	call   80105080 <argint>
80105d22:	83 c4 10             	add    $0x10,%esp
80105d25:	85 c0                	test   %eax,%eax
80105d27:	78 67                	js     80105d90 <sys_exec2+0xa0>
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
80105d29:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d2f:	83 ec 04             	sub    $0x4,%esp
80105d32:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105d38:	68 80 00 00 00       	push   $0x80
80105d3d:	6a 00                	push   $0x0
80105d3f:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105d45:	50                   	push   %eax
80105d46:	31 db                	xor    %ebx,%ebx
80105d48:	e8 23 f0 ff ff       	call   80104d70 <memset>
80105d4d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d50:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105d56:	83 ec 08             	sub    $0x8,%esp
80105d59:	57                   	push   %edi
80105d5a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105d5d:	50                   	push   %eax
80105d5e:	e8 7d f2 ff ff       	call   80104fe0 <fetchint>
80105d63:	83 c4 10             	add    $0x10,%esp
80105d66:	85 c0                	test   %eax,%eax
80105d68:	78 26                	js     80105d90 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
80105d6a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d70:	85 c0                	test   %eax,%eax
80105d72:	74 2c                	je     80105da0 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d74:	83 ec 08             	sub    $0x8,%esp
80105d77:	56                   	push   %esi
80105d78:	50                   	push   %eax
80105d79:	e8 a2 f2 ff ff       	call   80105020 <fetchstr>
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	85 c0                	test   %eax,%eax
80105d83:	78 0b                	js     80105d90 <sys_exec2+0xa0>
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105d85:	83 c3 01             	add    $0x1,%ebx
80105d88:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105d8b:	83 fb 20             	cmp    $0x20,%ebx
80105d8e:	75 c0                	jne    80105d50 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105d93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105d98:	5b                   	pop    %ebx
80105d99:	5e                   	pop    %esi
80105d9a:	5f                   	pop    %edi
80105d9b:	5d                   	pop    %ebp
80105d9c:	c3                   	ret    
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105da0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105da6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105da9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105db0:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105db4:	50                   	push   %eax
80105db5:	6a 02                	push   $0x2
80105db7:	e8 c4 f2 ff ff       	call   80105080 <argint>
80105dbc:	83 c4 10             	add    $0x10,%esp
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	78 cd                	js     80105d90 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105dc3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105dc9:	83 ec 04             	sub    $0x4,%esp
80105dcc:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105dd2:	50                   	push   %eax
80105dd3:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105dd9:	e8 d2 af ff ff       	call   80100db0 <exec2>
80105dde:	83 c4 10             	add    $0x10,%esp
}
80105de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de4:	5b                   	pop    %ebx
80105de5:	5e                   	pop    %esi
80105de6:	5f                   	pop    %edi
80105de7:	5d                   	pop    %ebp
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105df0 <sys_pipe>:

int
sys_pipe(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105df6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105df9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dfc:	6a 08                	push   $0x8
80105dfe:	50                   	push   %eax
80105dff:	6a 00                	push   $0x0
80105e01:	e8 ca f2 ff ff       	call   801050d0 <argptr>
80105e06:	83 c4 10             	add    $0x10,%esp
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	78 4a                	js     80105e57 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e0d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e10:	83 ec 08             	sub    $0x8,%esp
80105e13:	50                   	push   %eax
80105e14:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e17:	50                   	push   %eax
80105e18:	e8 f3 d7 ff ff       	call   80103610 <pipealloc>
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	85 c0                	test   %eax,%eax
80105e22:	78 33                	js     80105e57 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e24:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e26:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e29:	e8 d2 dd ff ff       	call   80103c00 <myproc>
80105e2e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105e30:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e34:	85 f6                	test   %esi,%esi
80105e36:	74 30                	je     80105e68 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e38:	83 c3 01             	add    $0x1,%ebx
80105e3b:	83 fb 10             	cmp    $0x10,%ebx
80105e3e:	75 f0                	jne    80105e30 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e40:	83 ec 0c             	sub    $0xc,%esp
80105e43:	ff 75 e0             	pushl  -0x20(%ebp)
80105e46:	e8 15 b4 ff ff       	call   80101260 <fileclose>
    fileclose(wf);
80105e4b:	58                   	pop    %eax
80105e4c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e4f:	e8 0c b4 ff ff       	call   80101260 <fileclose>
    return -1;
80105e54:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105e5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e5f:	5b                   	pop    %ebx
80105e60:	5e                   	pop    %esi
80105e61:	5f                   	pop    %edi
80105e62:	5d                   	pop    %ebp
80105e63:	c3                   	ret    
80105e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e68:	8d 73 08             	lea    0x8(%ebx),%esi
80105e6b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e72:	e8 89 dd ff ff       	call   80103c00 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105e77:	31 d2                	xor    %edx,%edx
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e80:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e84:	85 c9                	test   %ecx,%ecx
80105e86:	74 18                	je     80105ea0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e88:	83 c2 01             	add    $0x1,%edx
80105e8b:	83 fa 10             	cmp    $0x10,%edx
80105e8e:	75 f0                	jne    80105e80 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105e90:	e8 6b dd ff ff       	call   80103c00 <myproc>
80105e95:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e9c:	00 
80105e9d:	eb a1                	jmp    80105e40 <sys_pipe+0x50>
80105e9f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105ea0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ea7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105eb2:	31 c0                	xor    %eax,%eax
}
80105eb4:	5b                   	pop    %ebx
80105eb5:	5e                   	pop    %esi
80105eb6:	5f                   	pop    %edi
80105eb7:	5d                   	pop    %ebp
80105eb8:	c3                   	ret    
80105eb9:	66 90                	xchg   %ax,%ax
80105ebb:	66 90                	xchg   %ax,%ax
80105ebd:	66 90                	xchg   %ax,%ax
80105ebf:	90                   	nop

80105ec0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ec3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ec4:	e9 e7 de ff ff       	jmp    80103db0 <fork>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <sys_exit>:
}

int
sys_exit(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ed6:	e8 05 e2 ff ff       	call   801040e0 <exit>
  return 0;  // not reached
}
80105edb:	31 c0                	xor    %eax,%eax
80105edd:	c9                   	leave  
80105ede:	c3                   	ret    
80105edf:	90                   	nop

80105ee0 <sys_wait>:

int
sys_wait(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ee3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105ee4:	e9 37 e8 ff ff       	jmp    80104720 <wait>
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_kill>:
}

int
sys_kill(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ef9:	50                   	push   %eax
80105efa:	6a 00                	push   $0x0
80105efc:	e8 7f f1 ff ff       	call   80105080 <argint>
80105f01:	83 c4 10             	add    $0x10,%esp
80105f04:	85 c0                	test   %eax,%eax
80105f06:	78 18                	js     80105f20 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f0e:	e8 7d e9 ff ff       	call   80104890 <kill>
80105f13:	83 c4 10             	add    $0x10,%esp
}
80105f16:	c9                   	leave  
80105f17:	c3                   	ret    
80105f18:	90                   	nop
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105f25:	c9                   	leave  
80105f26:	c3                   	ret    
80105f27:	89 f6                	mov    %esi,%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f30 <sys_getpid>:

int
sys_getpid(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f36:	e8 c5 dc ff ff       	call   80103c00 <myproc>
80105f3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f3e:	c9                   	leave  
80105f3f:	c3                   	ret    

80105f40 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105f47:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 2e f1 ff ff       	call   80105080 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	78 27                	js     80105f80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f59:	e8 a2 dc ff ff       	call   80103c00 <myproc>
  if(growproc(n) < 0)
80105f5e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105f61:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f63:	ff 75 f4             	pushl  -0xc(%ebp)
80105f66:	e8 b5 dd ff ff       	call   80103d20 <growproc>
80105f6b:	83 c4 10             	add    $0x10,%esp
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	78 0e                	js     80105f80 <sys_sbrk+0x40>
    return -1;
  return addr;
80105f72:	89 d8                	mov    %ebx,%eax
}
80105f74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f77:	c9                   	leave  
80105f78:	c3                   	ret    
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f85:	eb ed                	jmp    80105f74 <sys_sbrk+0x34>
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f90 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	53                   	push   %ebx
80105f94:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105f97:	e8 64 dc ff ff       	call   80103c00 <myproc>
80105f9c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105fa3:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105fa6:	e8 55 dc ff ff       	call   80103c00 <myproc>
80105fab:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105fb2:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105fb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fb8:	83 ec 08             	sub    $0x8,%esp
80105fbb:	50                   	push   %eax
80105fbc:	6a 00                	push   $0x0
80105fbe:	e8 bd f0 ff ff       	call   80105080 <argint>
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	85 c0                	test   %eax,%eax
80105fc8:	0f 88 89 00 00 00    	js     80106057 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105fce:	83 ec 0c             	sub    $0xc,%esp
80105fd1:	68 60 64 11 80       	push   $0x80116460
80105fd6:	e8 95 ec ff ff       	call   80104c70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fde:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105fe1:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105fe7:	85 d2                	test   %edx,%edx
80105fe9:	75 26                	jne    80106011 <sys_sleep+0x81>
80105feb:	eb 53                	jmp    80106040 <sys_sleep+0xb0>
80105fed:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ff0:	83 ec 08             	sub    $0x8,%esp
80105ff3:	68 60 64 11 80       	push   $0x80116460
80105ff8:	68 a0 6c 11 80       	push   $0x80116ca0
80105ffd:	e8 5e e6 ff ff       	call   80104660 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106002:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80106007:	83 c4 10             	add    $0x10,%esp
8010600a:	29 d8                	sub    %ebx,%eax
8010600c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010600f:	73 2f                	jae    80106040 <sys_sleep+0xb0>
    if(myproc()->killed){
80106011:	e8 ea db ff ff       	call   80103c00 <myproc>
80106016:	8b 40 24             	mov    0x24(%eax),%eax
80106019:	85 c0                	test   %eax,%eax
8010601b:	74 d3                	je     80105ff0 <sys_sleep+0x60>
      release(&tickslock);
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	68 60 64 11 80       	push   $0x80116460
80106025:	e8 f6 ec ff ff       	call   80104d20 <release>
      return -1;
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80106032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	68 60 64 11 80       	push   $0x80116460
80106048:	e8 d3 ec ff ff       	call   80104d20 <release>
  return 0;
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	31 c0                	xor    %eax,%eax
}
80106052:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106055:	c9                   	leave  
80106056:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80106057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010605c:	eb d4                	jmp    80106032 <sys_sleep+0xa2>
8010605e:	66 90                	xchg   %ax,%ax

80106060 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	53                   	push   %ebx
80106064:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106067:	68 60 64 11 80       	push   $0x80116460
8010606c:	e8 ff eb ff ff       	call   80104c70 <acquire>
  xticks = ticks;
80106071:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80106077:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
8010607e:	e8 9d ec ff ff       	call   80104d20 <release>
  return xticks;
}
80106083:	89 d8                	mov    %ebx,%eax
80106085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106088:	c9                   	leave  
80106089:	c3                   	ret    
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106090 <sys_yield>:

void 
sys_yield()
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80106096:	e8 65 db ff ff       	call   80103c00 <myproc>
8010609b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801060a2:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
801060a5:	e8 56 db ff ff       	call   80103c00 <myproc>
801060aa:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
801060b1:	00 00 00 
  yield();
}
801060b4:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
801060b5:	e9 56 e1 ff ff       	jmp    80104210 <yield>
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060c0 <sys_getlev>:
}

int             
sys_getlev(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
  return getlev();
}
801060c3:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
801060c4:	e9 97 e1 ff ff       	jmp    80104260 <getlev>
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
801060d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060d9:	50                   	push   %eax
801060da:	6a 00                	push   $0x0
801060dc:	e8 9f ef ff ff       	call   80105080 <argint>
801060e1:	83 c4 10             	add    $0x10,%esp
801060e4:	85 c0                	test   %eax,%eax
801060e6:	78 28                	js     80106110 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
801060e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060eb:	83 ec 08             	sub    $0x8,%esp
801060ee:	50                   	push   %eax
801060ef:	6a 01                	push   $0x1
801060f1:	e8 8a ef ff ff       	call   80105080 <argint>
801060f6:	83 c4 10             	add    $0x10,%esp
801060f9:	85 c0                	test   %eax,%eax
801060fb:	78 23                	js     80106120 <sys_setpriority+0x50>
	return setpriority(pid,priority);
801060fd:	83 ec 08             	sub    $0x8,%esp
80106100:	ff 75 f4             	pushl  -0xc(%ebp)
80106103:	ff 75 f0             	pushl  -0x10(%ebp)
80106106:	e8 95 e4 ff ff       	call   801045a0 <setpriority>
8010610b:	83 c4 10             	add    $0x10,%esp
}
8010610e:	c9                   	leave  
8010610f:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80106110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
80106115:	c9                   	leave  
80106116:	c3                   	ret    
80106117:	89 f6                	mov    %esi,%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
80106120:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
80106125:	c9                   	leave  
80106126:	c3                   	ret    
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106130 <sys_getadmin>:


int
sys_getadmin(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80106136:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106139:	50                   	push   %eax
8010613a:	6a 00                	push   $0x0
8010613c:	e8 ef ef ff ff       	call   80105130 <argstr>
80106141:	83 c4 10             	add    $0x10,%esp
80106144:	85 c0                	test   %eax,%eax
80106146:	78 18                	js     80106160 <sys_getadmin+0x30>
  return getadmin(student_number);
80106148:	83 ec 0c             	sub    $0xc,%esp
8010614b:	ff 75 f4             	pushl  -0xc(%ebp)
8010614e:	e8 3d e1 ff ff       	call   80104290 <getadmin>
80106153:	83 c4 10             	add    $0x10,%esp
}
80106156:	c9                   	leave  
80106157:	c3                   	ret    
80106158:	90                   	nop
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80106160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80106165:	c9                   	leave  
80106166:	c3                   	ret    
80106167:	89 f6                	mov    %esi,%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106170 <sys_setmemorylimit>:

int
sys_setmemorylimit(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 20             	sub    $0x20,%esp
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80106176:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106179:	50                   	push   %eax
8010617a:	6a 00                	push   $0x0
8010617c:	e8 ff ee ff ff       	call   80105080 <argint>
80106181:	83 c4 10             	add    $0x10,%esp
80106184:	85 c0                	test   %eax,%eax
80106186:	78 28                	js     801061b0 <sys_setmemorylimit+0x40>
80106188:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010618b:	83 ec 08             	sub    $0x8,%esp
8010618e:	50                   	push   %eax
8010618f:	6a 01                	push   $0x1
80106191:	e8 ea ee ff ff       	call   80105080 <argint>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	78 13                	js     801061b0 <sys_setmemorylimit+0x40>
  return setmemorylimit(pid,limit);
8010619d:	83 ec 08             	sub    $0x8,%esp
801061a0:	ff 75 f4             	pushl  -0xc(%ebp)
801061a3:	ff 75 f0             	pushl  -0x10(%ebp)
801061a6:	e8 65 e1 ff ff       	call   80104310 <setmemorylimit>
801061ab:	83 c4 10             	add    $0x10,%esp
}
801061ae:	c9                   	leave  
801061af:	c3                   	ret    

int
sys_setmemorylimit(void)
{
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
801061b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return setmemorylimit(pid,limit);
}
801061b5:	c9                   	leave  
801061b6:	c3                   	ret    
801061b7:	89 f6                	mov    %esi,%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061c0 <sys_list>:

int
sys_list(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
  return list();
}
801061c3:	5d                   	pop    %ebp
}

int
sys_list(void)
{
  return list();
801061c4:	e9 07 e3 ff ff       	jmp    801044d0 <list>
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061d0 <sys_getshmem>:
}

char*
sys_getshmem(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0,&pid)<0) return 0;
801061d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061d9:	50                   	push   %eax
801061da:	6a 00                	push   $0x0
801061dc:	e8 9f ee ff ff       	call   80105080 <argint>
801061e1:	83 c4 10             	add    $0x10,%esp
801061e4:	85 c0                	test   %eax,%eax
801061e6:	78 18                	js     80106200 <sys_getshmem+0x30>
  return getshmem(pid);
801061e8:	83 ec 0c             	sub    $0xc,%esp
801061eb:	ff 75 f4             	pushl  -0xc(%ebp)
801061ee:	e8 bd e1 ff ff       	call   801043b0 <getshmem>
801061f3:	83 c4 10             	add    $0x10,%esp
}
801061f6:	c9                   	leave  
801061f7:	c3                   	ret    
801061f8:	90                   	nop
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char*
sys_getshmem(void)
{
  int pid;
  if(argint(0,&pid)<0) return 0;
80106200:	31 c0                	xor    %eax,%eax
  return getshmem(pid);
}
80106202:	c9                   	leave  
80106203:	c3                   	ret    

80106204 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106204:	1e                   	push   %ds
  pushl %es
80106205:	06                   	push   %es
  pushl %fs
80106206:	0f a0                	push   %fs
  pushl %gs
80106208:	0f a8                	push   %gs
  pushal
8010620a:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010620b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010620f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106211:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106213:	54                   	push   %esp
  call trap
80106214:	e8 e7 00 00 00       	call   80106300 <trap>
  addl $4, %esp
80106219:	83 c4 04             	add    $0x4,%esp

8010621c <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010621c:	61                   	popa   
  popl %gs
8010621d:	0f a9                	pop    %gs
  popl %fs
8010621f:	0f a1                	pop    %fs
  popl %es
80106221:	07                   	pop    %es
  popl %ds
80106222:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106223:	83 c4 08             	add    $0x8,%esp
  iret
80106226:	cf                   	iret   
80106227:	66 90                	xchg   %ax,%ax
80106229:	66 90                	xchg   %ax,%ax
8010622b:	66 90                	xchg   %ax,%ax
8010622d:	66 90                	xchg   %ax,%ax
8010622f:	90                   	nop

80106230 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106230:	31 c0                	xor    %eax,%eax
80106232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106238:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010623f:	b9 08 00 00 00       	mov    $0x8,%ecx
80106244:	c6 04 c5 a4 64 11 80 	movb   $0x0,-0x7fee9b5c(,%eax,8)
8010624b:	00 
8010624c:	66 89 0c c5 a2 64 11 	mov    %cx,-0x7fee9b5e(,%eax,8)
80106253:	80 
80106254:	c6 04 c5 a5 64 11 80 	movb   $0x8e,-0x7fee9b5b(,%eax,8)
8010625b:	8e 
8010625c:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
80106263:	80 
80106264:	c1 ea 10             	shr    $0x10,%edx
80106267:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
8010626e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010626f:	83 c0 01             	add    $0x1,%eax
80106272:	3d 00 01 00 00       	cmp    $0x100,%eax
80106277:	75 bf                	jne    80106238 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106279:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010627a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010627f:	89 e5                	mov    %esp,%ebp
80106281:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106284:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106289:	68 f9 82 10 80       	push   $0x801082f9
8010628e:	68 60 64 11 80       	push   $0x80116460
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106293:	66 89 15 a2 66 11 80 	mov    %dx,0x801166a2
8010629a:	c6 05 a4 66 11 80 00 	movb   $0x0,0x801166a4
801062a1:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
801062a7:	c1 e8 10             	shr    $0x10,%eax
801062aa:	c6 05 a5 66 11 80 ef 	movb   $0xef,0x801166a5
801062b1:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6

  initlock(&tickslock, "time");
801062b7:	e8 54 e8 ff ff       	call   80104b10 <initlock>
}
801062bc:	83 c4 10             	add    $0x10,%esp
801062bf:	c9                   	leave  
801062c0:	c3                   	ret    
801062c1:	eb 0d                	jmp    801062d0 <idtinit>
801062c3:	90                   	nop
801062c4:	90                   	nop
801062c5:	90                   	nop
801062c6:	90                   	nop
801062c7:	90                   	nop
801062c8:	90                   	nop
801062c9:	90                   	nop
801062ca:	90                   	nop
801062cb:	90                   	nop
801062cc:	90                   	nop
801062cd:	90                   	nop
801062ce:	90                   	nop
801062cf:	90                   	nop

801062d0 <idtinit>:

void
idtinit(void)
{
801062d0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801062d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062d6:	89 e5                	mov    %esp,%ebp
801062d8:	83 ec 10             	sub    $0x10,%esp
801062db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062df:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
801062e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062e8:	c1 e8 10             	shr    $0x10,%eax
801062eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801062ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062f5:	c9                   	leave  
801062f6:	c3                   	ret    
801062f7:	89 f6                	mov    %esi,%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106300 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	57                   	push   %edi
80106304:	56                   	push   %esi
80106305:	53                   	push   %ebx
80106306:	83 ec 1c             	sub    $0x1c,%esp
80106309:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010630c:	8b 47 30             	mov    0x30(%edi),%eax
8010630f:	83 f8 40             	cmp    $0x40,%eax
80106312:	0f 84 88 01 00 00    	je     801064a0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106318:	83 e8 20             	sub    $0x20,%eax
8010631b:	83 f8 1f             	cmp    $0x1f,%eax
8010631e:	77 10                	ja     80106330 <trap+0x30>
80106320:	ff 24 85 a0 83 10 80 	jmp    *-0x7fef7c60(,%eax,4)
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106330:	e8 cb d8 ff ff       	call   80103c00 <myproc>
80106335:	85 c0                	test   %eax,%eax
80106337:	0f 84 d7 01 00 00    	je     80106514 <trap+0x214>
8010633d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106341:	0f 84 cd 01 00 00    	je     80106514 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106347:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010634a:	8b 57 38             	mov    0x38(%edi),%edx
8010634d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106350:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106353:	e8 88 d8 ff ff       	call   80103be0 <cpuid>
80106358:	8b 77 34             	mov    0x34(%edi),%esi
8010635b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010635e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106361:	e8 9a d8 ff ff       	call   80103c00 <myproc>
80106366:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106369:	e8 92 d8 ff ff       	call   80103c00 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010636e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106371:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106374:	51                   	push   %ecx
80106375:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106376:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106379:	ff 75 e4             	pushl  -0x1c(%ebp)
8010637c:	56                   	push   %esi
8010637d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010637e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106381:	52                   	push   %edx
80106382:	ff 70 10             	pushl  0x10(%eax)
80106385:	68 5c 83 10 80       	push   $0x8010835c
8010638a:	e8 d1 a2 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010638f:	83 c4 20             	add    $0x20,%esp
80106392:	e8 69 d8 ff ff       	call   80103c00 <myproc>
80106397:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010639e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063a0:	e8 5b d8 ff ff       	call   80103c00 <myproc>
801063a5:	85 c0                	test   %eax,%eax
801063a7:	74 0c                	je     801063b5 <trap+0xb5>
801063a9:	e8 52 d8 ff ff       	call   80103c00 <myproc>
801063ae:	8b 50 24             	mov    0x24(%eax),%edx
801063b1:	85 d2                	test   %edx,%edx
801063b3:	75 4b                	jne    80106400 <trap+0x100>
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
801063b5:	e8 46 d8 ff ff       	call   80103c00 <myproc>
801063ba:	85 c0                	test   %eax,%eax
801063bc:	74 0b                	je     801063c9 <trap+0xc9>
801063be:	e8 3d d8 ff ff       	call   80103c00 <myproc>
801063c3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801063c7:	74 4f                	je     80106418 <trap+0x118>
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063c9:	e8 32 d8 ff ff       	call   80103c00 <myproc>
801063ce:	85 c0                	test   %eax,%eax
801063d0:	74 1d                	je     801063ef <trap+0xef>
801063d2:	e8 29 d8 ff ff       	call   80103c00 <myproc>
801063d7:	8b 40 24             	mov    0x24(%eax),%eax
801063da:	85 c0                	test   %eax,%eax
801063dc:	74 11                	je     801063ef <trap+0xef>
801063de:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063e2:	83 e0 03             	and    $0x3,%eax
801063e5:	66 83 f8 03          	cmp    $0x3,%ax
801063e9:	0f 84 da 00 00 00    	je     801064c9 <trap+0x1c9>
    exit();
}
801063ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f2:	5b                   	pop    %ebx
801063f3:	5e                   	pop    %esi
801063f4:	5f                   	pop    %edi
801063f5:	5d                   	pop    %ebp
801063f6:	c3                   	ret    
801063f7:	89 f6                	mov    %esi,%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106400:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106404:	83 e0 03             	and    $0x3,%eax
80106407:	66 83 f8 03          	cmp    $0x3,%ax
8010640b:	75 a8                	jne    801063b5 <trap+0xb5>
    exit();
8010640d:	e8 ce dc ff ff       	call   801040e0 <exit>
80106412:	eb a1                	jmp    801063b5 <trap+0xb5>
80106414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
80106418:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010641c:	75 ab                	jne    801063c9 <trap+0xc9>
8010641e:	e8 ed dd ff ff       	call   80104210 <yield>
80106423:	eb a4                	jmp    801063c9 <trap+0xc9>
80106425:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106428:	e8 b3 d7 ff ff       	call   80103be0 <cpuid>
8010642d:	85 c0                	test   %eax,%eax
8010642f:	0f 84 ab 00 00 00    	je     801064e0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106435:	e8 f6 c6 ff ff       	call   80102b30 <lapiceoi>
    break;
8010643a:	e9 61 ff ff ff       	jmp    801063a0 <trap+0xa0>
8010643f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106440:	e8 ab c5 ff ff       	call   801029f0 <kbdintr>
    lapiceoi();
80106445:	e8 e6 c6 ff ff       	call   80102b30 <lapiceoi>
    break;
8010644a:	e9 51 ff ff ff       	jmp    801063a0 <trap+0xa0>
8010644f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106450:	e8 5b 02 00 00       	call   801066b0 <uartintr>
    lapiceoi();
80106455:	e8 d6 c6 ff ff       	call   80102b30 <lapiceoi>
    break;
8010645a:	e9 41 ff ff ff       	jmp    801063a0 <trap+0xa0>
8010645f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106460:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106464:	8b 77 38             	mov    0x38(%edi),%esi
80106467:	e8 74 d7 ff ff       	call   80103be0 <cpuid>
8010646c:	56                   	push   %esi
8010646d:	53                   	push   %ebx
8010646e:	50                   	push   %eax
8010646f:	68 04 83 10 80       	push   $0x80108304
80106474:	e8 e7 a1 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106479:	e8 b2 c6 ff ff       	call   80102b30 <lapiceoi>
    break;
8010647e:	83 c4 10             	add    $0x10,%esp
80106481:	e9 1a ff ff ff       	jmp    801063a0 <trap+0xa0>
80106486:	8d 76 00             	lea    0x0(%esi),%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106490:	e8 db bf ff ff       	call   80102470 <ideintr>
80106495:	eb 9e                	jmp    80106435 <trap+0x135>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801064a0:	e8 5b d7 ff ff       	call   80103c00 <myproc>
801064a5:	8b 58 24             	mov    0x24(%eax),%ebx
801064a8:	85 db                	test   %ebx,%ebx
801064aa:	75 2c                	jne    801064d8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
801064ac:	e8 4f d7 ff ff       	call   80103c00 <myproc>
801064b1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801064b4:	e8 b7 ec ff ff       	call   80105170 <syscall>
    if(myproc()->killed)
801064b9:	e8 42 d7 ff ff       	call   80103c00 <myproc>
801064be:	8b 48 24             	mov    0x24(%eax),%ecx
801064c1:	85 c9                	test   %ecx,%ecx
801064c3:	0f 84 26 ff ff ff    	je     801063ef <trap+0xef>
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801064c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064cc:	5b                   	pop    %ebx
801064cd:	5e                   	pop    %esi
801064ce:	5f                   	pop    %edi
801064cf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801064d0:	e9 0b dc ff ff       	jmp    801040e0 <exit>
801064d5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801064d8:	e8 03 dc ff ff       	call   801040e0 <exit>
801064dd:	eb cd                	jmp    801064ac <trap+0x1ac>
801064df:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	68 60 64 11 80       	push   $0x80116460
801064e8:	e8 83 e7 ff ff       	call   80104c70 <acquire>
      ticks++;
      wakeup(&ticks);
801064ed:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801064f4:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      wakeup(&ticks);
801064fb:	e8 30 e3 ff ff       	call   80104830 <wakeup>
      release(&tickslock);
80106500:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
80106507:	e8 14 e8 ff ff       	call   80104d20 <release>
8010650c:	83 c4 10             	add    $0x10,%esp
8010650f:	e9 21 ff ff ff       	jmp    80106435 <trap+0x135>
80106514:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106517:	8b 5f 38             	mov    0x38(%edi),%ebx
8010651a:	e8 c1 d6 ff ff       	call   80103be0 <cpuid>
8010651f:	83 ec 0c             	sub    $0xc,%esp
80106522:	56                   	push   %esi
80106523:	53                   	push   %ebx
80106524:	50                   	push   %eax
80106525:	ff 77 30             	pushl  0x30(%edi)
80106528:	68 28 83 10 80       	push   $0x80108328
8010652d:	e8 2e a1 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106532:	83 c4 14             	add    $0x14,%esp
80106535:	68 fe 82 10 80       	push   $0x801082fe
8010653a:	e8 31 9e ff ff       	call   80100370 <panic>
8010653f:	90                   	nop

80106540 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106540:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106545:	55                   	push   %ebp
80106546:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106548:	85 c0                	test   %eax,%eax
8010654a:	74 1c                	je     80106568 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010654c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106551:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106552:	a8 01                	test   $0x1,%al
80106554:	74 12                	je     80106568 <uartgetc+0x28>
80106556:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010655c:	0f b6 c0             	movzbl %al,%eax
}
8010655f:	5d                   	pop    %ebp
80106560:	c3                   	ret    
80106561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106568:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010656d:	5d                   	pop    %ebp
8010656e:	c3                   	ret    
8010656f:	90                   	nop

80106570 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
80106575:	53                   	push   %ebx
80106576:	89 c7                	mov    %eax,%edi
80106578:	bb 80 00 00 00       	mov    $0x80,%ebx
8010657d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106582:	83 ec 0c             	sub    $0xc,%esp
80106585:	eb 1b                	jmp    801065a2 <uartputc.part.0+0x32>
80106587:	89 f6                	mov    %esi,%esi
80106589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	6a 0a                	push   $0xa
80106595:	e8 b6 c5 ff ff       	call   80102b50 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010659a:	83 c4 10             	add    $0x10,%esp
8010659d:	83 eb 01             	sub    $0x1,%ebx
801065a0:	74 07                	je     801065a9 <uartputc.part.0+0x39>
801065a2:	89 f2                	mov    %esi,%edx
801065a4:	ec                   	in     (%dx),%al
801065a5:	a8 20                	test   $0x20,%al
801065a7:	74 e7                	je     80106590 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ae:	89 f8                	mov    %edi,%eax
801065b0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
801065b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b4:	5b                   	pop    %ebx
801065b5:	5e                   	pop    %esi
801065b6:	5f                   	pop    %edi
801065b7:	5d                   	pop    %ebp
801065b8:	c3                   	ret    
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065c0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801065c0:	55                   	push   %ebp
801065c1:	31 c9                	xor    %ecx,%ecx
801065c3:	89 c8                	mov    %ecx,%eax
801065c5:	89 e5                	mov    %esp,%ebp
801065c7:	57                   	push   %edi
801065c8:	56                   	push   %esi
801065c9:	53                   	push   %ebx
801065ca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065cf:	89 da                	mov    %ebx,%edx
801065d1:	83 ec 0c             	sub    $0xc,%esp
801065d4:	ee                   	out    %al,(%dx)
801065d5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065df:	89 fa                	mov    %edi,%edx
801065e1:	ee                   	out    %al,(%dx)
801065e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ec:	ee                   	out    %al,(%dx)
801065ed:	be f9 03 00 00       	mov    $0x3f9,%esi
801065f2:	89 c8                	mov    %ecx,%eax
801065f4:	89 f2                	mov    %esi,%edx
801065f6:	ee                   	out    %al,(%dx)
801065f7:	b8 03 00 00 00       	mov    $0x3,%eax
801065fc:	89 fa                	mov    %edi,%edx
801065fe:	ee                   	out    %al,(%dx)
801065ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106604:	89 c8                	mov    %ecx,%eax
80106606:	ee                   	out    %al,(%dx)
80106607:	b8 01 00 00 00       	mov    $0x1,%eax
8010660c:	89 f2                	mov    %esi,%edx
8010660e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010660f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106614:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106615:	3c ff                	cmp    $0xff,%al
80106617:	74 5a                	je     80106673 <uartinit+0xb3>
    return;
  uart = 1;
80106619:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106620:	00 00 00 
80106623:	89 da                	mov    %ebx,%edx
80106625:	ec                   	in     (%dx),%al
80106626:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010662b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010662c:	83 ec 08             	sub    $0x8,%esp
8010662f:	bb 20 84 10 80       	mov    $0x80108420,%ebx
80106634:	6a 00                	push   $0x0
80106636:	6a 04                	push   $0x4
80106638:	e8 83 c0 ff ff       	call   801026c0 <ioapicenable>
8010663d:	83 c4 10             	add    $0x10,%esp
80106640:	b8 78 00 00 00       	mov    $0x78,%eax
80106645:	eb 13                	jmp    8010665a <uartinit+0x9a>
80106647:	89 f6                	mov    %esi,%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106650:	83 c3 01             	add    $0x1,%ebx
80106653:	0f be 03             	movsbl (%ebx),%eax
80106656:	84 c0                	test   %al,%al
80106658:	74 19                	je     80106673 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010665a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106660:	85 d2                	test   %edx,%edx
80106662:	74 ec                	je     80106650 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106664:	83 c3 01             	add    $0x1,%ebx
80106667:	e8 04 ff ff ff       	call   80106570 <uartputc.part.0>
8010666c:	0f be 03             	movsbl (%ebx),%eax
8010666f:	84 c0                	test   %al,%al
80106671:	75 e7                	jne    8010665a <uartinit+0x9a>
    uartputc(*p);
}
80106673:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106676:	5b                   	pop    %ebx
80106677:	5e                   	pop    %esi
80106678:	5f                   	pop    %edi
80106679:	5d                   	pop    %ebp
8010667a:	c3                   	ret    
8010667b:	90                   	nop
8010667c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106680 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106680:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106686:	55                   	push   %ebp
80106687:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106689:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010668b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010668e:	74 10                	je     801066a0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106690:	5d                   	pop    %ebp
80106691:	e9 da fe ff ff       	jmp    80106570 <uartputc.part.0>
80106696:	8d 76 00             	lea    0x0(%esi),%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801066a0:	5d                   	pop    %ebp
801066a1:	c3                   	ret    
801066a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066b0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801066b6:	68 40 65 10 80       	push   $0x80106540
801066bb:	e8 30 a1 ff ff       	call   801007f0 <consoleintr>
}
801066c0:	83 c4 10             	add    $0x10,%esp
801066c3:	c9                   	leave  
801066c4:	c3                   	ret    

801066c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $0
801066c7:	6a 00                	push   $0x0
  jmp alltraps
801066c9:	e9 36 fb ff ff       	jmp    80106204 <alltraps>

801066ce <vector1>:
.globl vector1
vector1:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $1
801066d0:	6a 01                	push   $0x1
  jmp alltraps
801066d2:	e9 2d fb ff ff       	jmp    80106204 <alltraps>

801066d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $2
801066d9:	6a 02                	push   $0x2
  jmp alltraps
801066db:	e9 24 fb ff ff       	jmp    80106204 <alltraps>

801066e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $3
801066e2:	6a 03                	push   $0x3
  jmp alltraps
801066e4:	e9 1b fb ff ff       	jmp    80106204 <alltraps>

801066e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $4
801066eb:	6a 04                	push   $0x4
  jmp alltraps
801066ed:	e9 12 fb ff ff       	jmp    80106204 <alltraps>

801066f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $5
801066f4:	6a 05                	push   $0x5
  jmp alltraps
801066f6:	e9 09 fb ff ff       	jmp    80106204 <alltraps>

801066fb <vector6>:
.globl vector6
vector6:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $6
801066fd:	6a 06                	push   $0x6
  jmp alltraps
801066ff:	e9 00 fb ff ff       	jmp    80106204 <alltraps>

80106704 <vector7>:
.globl vector7
vector7:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $7
80106706:	6a 07                	push   $0x7
  jmp alltraps
80106708:	e9 f7 fa ff ff       	jmp    80106204 <alltraps>

8010670d <vector8>:
.globl vector8
vector8:
  pushl $8
8010670d:	6a 08                	push   $0x8
  jmp alltraps
8010670f:	e9 f0 fa ff ff       	jmp    80106204 <alltraps>

80106714 <vector9>:
.globl vector9
vector9:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $9
80106716:	6a 09                	push   $0x9
  jmp alltraps
80106718:	e9 e7 fa ff ff       	jmp    80106204 <alltraps>

8010671d <vector10>:
.globl vector10
vector10:
  pushl $10
8010671d:	6a 0a                	push   $0xa
  jmp alltraps
8010671f:	e9 e0 fa ff ff       	jmp    80106204 <alltraps>

80106724 <vector11>:
.globl vector11
vector11:
  pushl $11
80106724:	6a 0b                	push   $0xb
  jmp alltraps
80106726:	e9 d9 fa ff ff       	jmp    80106204 <alltraps>

8010672b <vector12>:
.globl vector12
vector12:
  pushl $12
8010672b:	6a 0c                	push   $0xc
  jmp alltraps
8010672d:	e9 d2 fa ff ff       	jmp    80106204 <alltraps>

80106732 <vector13>:
.globl vector13
vector13:
  pushl $13
80106732:	6a 0d                	push   $0xd
  jmp alltraps
80106734:	e9 cb fa ff ff       	jmp    80106204 <alltraps>

80106739 <vector14>:
.globl vector14
vector14:
  pushl $14
80106739:	6a 0e                	push   $0xe
  jmp alltraps
8010673b:	e9 c4 fa ff ff       	jmp    80106204 <alltraps>

80106740 <vector15>:
.globl vector15
vector15:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $15
80106742:	6a 0f                	push   $0xf
  jmp alltraps
80106744:	e9 bb fa ff ff       	jmp    80106204 <alltraps>

80106749 <vector16>:
.globl vector16
vector16:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $16
8010674b:	6a 10                	push   $0x10
  jmp alltraps
8010674d:	e9 b2 fa ff ff       	jmp    80106204 <alltraps>

80106752 <vector17>:
.globl vector17
vector17:
  pushl $17
80106752:	6a 11                	push   $0x11
  jmp alltraps
80106754:	e9 ab fa ff ff       	jmp    80106204 <alltraps>

80106759 <vector18>:
.globl vector18
vector18:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $18
8010675b:	6a 12                	push   $0x12
  jmp alltraps
8010675d:	e9 a2 fa ff ff       	jmp    80106204 <alltraps>

80106762 <vector19>:
.globl vector19
vector19:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $19
80106764:	6a 13                	push   $0x13
  jmp alltraps
80106766:	e9 99 fa ff ff       	jmp    80106204 <alltraps>

8010676b <vector20>:
.globl vector20
vector20:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $20
8010676d:	6a 14                	push   $0x14
  jmp alltraps
8010676f:	e9 90 fa ff ff       	jmp    80106204 <alltraps>

80106774 <vector21>:
.globl vector21
vector21:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $21
80106776:	6a 15                	push   $0x15
  jmp alltraps
80106778:	e9 87 fa ff ff       	jmp    80106204 <alltraps>

8010677d <vector22>:
.globl vector22
vector22:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $22
8010677f:	6a 16                	push   $0x16
  jmp alltraps
80106781:	e9 7e fa ff ff       	jmp    80106204 <alltraps>

80106786 <vector23>:
.globl vector23
vector23:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $23
80106788:	6a 17                	push   $0x17
  jmp alltraps
8010678a:	e9 75 fa ff ff       	jmp    80106204 <alltraps>

8010678f <vector24>:
.globl vector24
vector24:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $24
80106791:	6a 18                	push   $0x18
  jmp alltraps
80106793:	e9 6c fa ff ff       	jmp    80106204 <alltraps>

80106798 <vector25>:
.globl vector25
vector25:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $25
8010679a:	6a 19                	push   $0x19
  jmp alltraps
8010679c:	e9 63 fa ff ff       	jmp    80106204 <alltraps>

801067a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $26
801067a3:	6a 1a                	push   $0x1a
  jmp alltraps
801067a5:	e9 5a fa ff ff       	jmp    80106204 <alltraps>

801067aa <vector27>:
.globl vector27
vector27:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $27
801067ac:	6a 1b                	push   $0x1b
  jmp alltraps
801067ae:	e9 51 fa ff ff       	jmp    80106204 <alltraps>

801067b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $28
801067b5:	6a 1c                	push   $0x1c
  jmp alltraps
801067b7:	e9 48 fa ff ff       	jmp    80106204 <alltraps>

801067bc <vector29>:
.globl vector29
vector29:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $29
801067be:	6a 1d                	push   $0x1d
  jmp alltraps
801067c0:	e9 3f fa ff ff       	jmp    80106204 <alltraps>

801067c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $30
801067c7:	6a 1e                	push   $0x1e
  jmp alltraps
801067c9:	e9 36 fa ff ff       	jmp    80106204 <alltraps>

801067ce <vector31>:
.globl vector31
vector31:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $31
801067d0:	6a 1f                	push   $0x1f
  jmp alltraps
801067d2:	e9 2d fa ff ff       	jmp    80106204 <alltraps>

801067d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $32
801067d9:	6a 20                	push   $0x20
  jmp alltraps
801067db:	e9 24 fa ff ff       	jmp    80106204 <alltraps>

801067e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $33
801067e2:	6a 21                	push   $0x21
  jmp alltraps
801067e4:	e9 1b fa ff ff       	jmp    80106204 <alltraps>

801067e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $34
801067eb:	6a 22                	push   $0x22
  jmp alltraps
801067ed:	e9 12 fa ff ff       	jmp    80106204 <alltraps>

801067f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $35
801067f4:	6a 23                	push   $0x23
  jmp alltraps
801067f6:	e9 09 fa ff ff       	jmp    80106204 <alltraps>

801067fb <vector36>:
.globl vector36
vector36:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $36
801067fd:	6a 24                	push   $0x24
  jmp alltraps
801067ff:	e9 00 fa ff ff       	jmp    80106204 <alltraps>

80106804 <vector37>:
.globl vector37
vector37:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $37
80106806:	6a 25                	push   $0x25
  jmp alltraps
80106808:	e9 f7 f9 ff ff       	jmp    80106204 <alltraps>

8010680d <vector38>:
.globl vector38
vector38:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $38
8010680f:	6a 26                	push   $0x26
  jmp alltraps
80106811:	e9 ee f9 ff ff       	jmp    80106204 <alltraps>

80106816 <vector39>:
.globl vector39
vector39:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $39
80106818:	6a 27                	push   $0x27
  jmp alltraps
8010681a:	e9 e5 f9 ff ff       	jmp    80106204 <alltraps>

8010681f <vector40>:
.globl vector40
vector40:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $40
80106821:	6a 28                	push   $0x28
  jmp alltraps
80106823:	e9 dc f9 ff ff       	jmp    80106204 <alltraps>

80106828 <vector41>:
.globl vector41
vector41:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $41
8010682a:	6a 29                	push   $0x29
  jmp alltraps
8010682c:	e9 d3 f9 ff ff       	jmp    80106204 <alltraps>

80106831 <vector42>:
.globl vector42
vector42:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $42
80106833:	6a 2a                	push   $0x2a
  jmp alltraps
80106835:	e9 ca f9 ff ff       	jmp    80106204 <alltraps>

8010683a <vector43>:
.globl vector43
vector43:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $43
8010683c:	6a 2b                	push   $0x2b
  jmp alltraps
8010683e:	e9 c1 f9 ff ff       	jmp    80106204 <alltraps>

80106843 <vector44>:
.globl vector44
vector44:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $44
80106845:	6a 2c                	push   $0x2c
  jmp alltraps
80106847:	e9 b8 f9 ff ff       	jmp    80106204 <alltraps>

8010684c <vector45>:
.globl vector45
vector45:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $45
8010684e:	6a 2d                	push   $0x2d
  jmp alltraps
80106850:	e9 af f9 ff ff       	jmp    80106204 <alltraps>

80106855 <vector46>:
.globl vector46
vector46:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $46
80106857:	6a 2e                	push   $0x2e
  jmp alltraps
80106859:	e9 a6 f9 ff ff       	jmp    80106204 <alltraps>

8010685e <vector47>:
.globl vector47
vector47:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $47
80106860:	6a 2f                	push   $0x2f
  jmp alltraps
80106862:	e9 9d f9 ff ff       	jmp    80106204 <alltraps>

80106867 <vector48>:
.globl vector48
vector48:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $48
80106869:	6a 30                	push   $0x30
  jmp alltraps
8010686b:	e9 94 f9 ff ff       	jmp    80106204 <alltraps>

80106870 <vector49>:
.globl vector49
vector49:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $49
80106872:	6a 31                	push   $0x31
  jmp alltraps
80106874:	e9 8b f9 ff ff       	jmp    80106204 <alltraps>

80106879 <vector50>:
.globl vector50
vector50:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $50
8010687b:	6a 32                	push   $0x32
  jmp alltraps
8010687d:	e9 82 f9 ff ff       	jmp    80106204 <alltraps>

80106882 <vector51>:
.globl vector51
vector51:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $51
80106884:	6a 33                	push   $0x33
  jmp alltraps
80106886:	e9 79 f9 ff ff       	jmp    80106204 <alltraps>

8010688b <vector52>:
.globl vector52
vector52:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $52
8010688d:	6a 34                	push   $0x34
  jmp alltraps
8010688f:	e9 70 f9 ff ff       	jmp    80106204 <alltraps>

80106894 <vector53>:
.globl vector53
vector53:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $53
80106896:	6a 35                	push   $0x35
  jmp alltraps
80106898:	e9 67 f9 ff ff       	jmp    80106204 <alltraps>

8010689d <vector54>:
.globl vector54
vector54:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $54
8010689f:	6a 36                	push   $0x36
  jmp alltraps
801068a1:	e9 5e f9 ff ff       	jmp    80106204 <alltraps>

801068a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $55
801068a8:	6a 37                	push   $0x37
  jmp alltraps
801068aa:	e9 55 f9 ff ff       	jmp    80106204 <alltraps>

801068af <vector56>:
.globl vector56
vector56:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $56
801068b1:	6a 38                	push   $0x38
  jmp alltraps
801068b3:	e9 4c f9 ff ff       	jmp    80106204 <alltraps>

801068b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $57
801068ba:	6a 39                	push   $0x39
  jmp alltraps
801068bc:	e9 43 f9 ff ff       	jmp    80106204 <alltraps>

801068c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $58
801068c3:	6a 3a                	push   $0x3a
  jmp alltraps
801068c5:	e9 3a f9 ff ff       	jmp    80106204 <alltraps>

801068ca <vector59>:
.globl vector59
vector59:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $59
801068cc:	6a 3b                	push   $0x3b
  jmp alltraps
801068ce:	e9 31 f9 ff ff       	jmp    80106204 <alltraps>

801068d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $60
801068d5:	6a 3c                	push   $0x3c
  jmp alltraps
801068d7:	e9 28 f9 ff ff       	jmp    80106204 <alltraps>

801068dc <vector61>:
.globl vector61
vector61:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $61
801068de:	6a 3d                	push   $0x3d
  jmp alltraps
801068e0:	e9 1f f9 ff ff       	jmp    80106204 <alltraps>

801068e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $62
801068e7:	6a 3e                	push   $0x3e
  jmp alltraps
801068e9:	e9 16 f9 ff ff       	jmp    80106204 <alltraps>

801068ee <vector63>:
.globl vector63
vector63:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $63
801068f0:	6a 3f                	push   $0x3f
  jmp alltraps
801068f2:	e9 0d f9 ff ff       	jmp    80106204 <alltraps>

801068f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $64
801068f9:	6a 40                	push   $0x40
  jmp alltraps
801068fb:	e9 04 f9 ff ff       	jmp    80106204 <alltraps>

80106900 <vector65>:
.globl vector65
vector65:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $65
80106902:	6a 41                	push   $0x41
  jmp alltraps
80106904:	e9 fb f8 ff ff       	jmp    80106204 <alltraps>

80106909 <vector66>:
.globl vector66
vector66:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $66
8010690b:	6a 42                	push   $0x42
  jmp alltraps
8010690d:	e9 f2 f8 ff ff       	jmp    80106204 <alltraps>

80106912 <vector67>:
.globl vector67
vector67:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $67
80106914:	6a 43                	push   $0x43
  jmp alltraps
80106916:	e9 e9 f8 ff ff       	jmp    80106204 <alltraps>

8010691b <vector68>:
.globl vector68
vector68:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $68
8010691d:	6a 44                	push   $0x44
  jmp alltraps
8010691f:	e9 e0 f8 ff ff       	jmp    80106204 <alltraps>

80106924 <vector69>:
.globl vector69
vector69:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $69
80106926:	6a 45                	push   $0x45
  jmp alltraps
80106928:	e9 d7 f8 ff ff       	jmp    80106204 <alltraps>

8010692d <vector70>:
.globl vector70
vector70:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $70
8010692f:	6a 46                	push   $0x46
  jmp alltraps
80106931:	e9 ce f8 ff ff       	jmp    80106204 <alltraps>

80106936 <vector71>:
.globl vector71
vector71:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $71
80106938:	6a 47                	push   $0x47
  jmp alltraps
8010693a:	e9 c5 f8 ff ff       	jmp    80106204 <alltraps>

8010693f <vector72>:
.globl vector72
vector72:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $72
80106941:	6a 48                	push   $0x48
  jmp alltraps
80106943:	e9 bc f8 ff ff       	jmp    80106204 <alltraps>

80106948 <vector73>:
.globl vector73
vector73:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $73
8010694a:	6a 49                	push   $0x49
  jmp alltraps
8010694c:	e9 b3 f8 ff ff       	jmp    80106204 <alltraps>

80106951 <vector74>:
.globl vector74
vector74:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $74
80106953:	6a 4a                	push   $0x4a
  jmp alltraps
80106955:	e9 aa f8 ff ff       	jmp    80106204 <alltraps>

8010695a <vector75>:
.globl vector75
vector75:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $75
8010695c:	6a 4b                	push   $0x4b
  jmp alltraps
8010695e:	e9 a1 f8 ff ff       	jmp    80106204 <alltraps>

80106963 <vector76>:
.globl vector76
vector76:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $76
80106965:	6a 4c                	push   $0x4c
  jmp alltraps
80106967:	e9 98 f8 ff ff       	jmp    80106204 <alltraps>

8010696c <vector77>:
.globl vector77
vector77:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $77
8010696e:	6a 4d                	push   $0x4d
  jmp alltraps
80106970:	e9 8f f8 ff ff       	jmp    80106204 <alltraps>

80106975 <vector78>:
.globl vector78
vector78:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $78
80106977:	6a 4e                	push   $0x4e
  jmp alltraps
80106979:	e9 86 f8 ff ff       	jmp    80106204 <alltraps>

8010697e <vector79>:
.globl vector79
vector79:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $79
80106980:	6a 4f                	push   $0x4f
  jmp alltraps
80106982:	e9 7d f8 ff ff       	jmp    80106204 <alltraps>

80106987 <vector80>:
.globl vector80
vector80:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $80
80106989:	6a 50                	push   $0x50
  jmp alltraps
8010698b:	e9 74 f8 ff ff       	jmp    80106204 <alltraps>

80106990 <vector81>:
.globl vector81
vector81:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $81
80106992:	6a 51                	push   $0x51
  jmp alltraps
80106994:	e9 6b f8 ff ff       	jmp    80106204 <alltraps>

80106999 <vector82>:
.globl vector82
vector82:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $82
8010699b:	6a 52                	push   $0x52
  jmp alltraps
8010699d:	e9 62 f8 ff ff       	jmp    80106204 <alltraps>

801069a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $83
801069a4:	6a 53                	push   $0x53
  jmp alltraps
801069a6:	e9 59 f8 ff ff       	jmp    80106204 <alltraps>

801069ab <vector84>:
.globl vector84
vector84:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $84
801069ad:	6a 54                	push   $0x54
  jmp alltraps
801069af:	e9 50 f8 ff ff       	jmp    80106204 <alltraps>

801069b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $85
801069b6:	6a 55                	push   $0x55
  jmp alltraps
801069b8:	e9 47 f8 ff ff       	jmp    80106204 <alltraps>

801069bd <vector86>:
.globl vector86
vector86:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $86
801069bf:	6a 56                	push   $0x56
  jmp alltraps
801069c1:	e9 3e f8 ff ff       	jmp    80106204 <alltraps>

801069c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $87
801069c8:	6a 57                	push   $0x57
  jmp alltraps
801069ca:	e9 35 f8 ff ff       	jmp    80106204 <alltraps>

801069cf <vector88>:
.globl vector88
vector88:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $88
801069d1:	6a 58                	push   $0x58
  jmp alltraps
801069d3:	e9 2c f8 ff ff       	jmp    80106204 <alltraps>

801069d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $89
801069da:	6a 59                	push   $0x59
  jmp alltraps
801069dc:	e9 23 f8 ff ff       	jmp    80106204 <alltraps>

801069e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $90
801069e3:	6a 5a                	push   $0x5a
  jmp alltraps
801069e5:	e9 1a f8 ff ff       	jmp    80106204 <alltraps>

801069ea <vector91>:
.globl vector91
vector91:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $91
801069ec:	6a 5b                	push   $0x5b
  jmp alltraps
801069ee:	e9 11 f8 ff ff       	jmp    80106204 <alltraps>

801069f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $92
801069f5:	6a 5c                	push   $0x5c
  jmp alltraps
801069f7:	e9 08 f8 ff ff       	jmp    80106204 <alltraps>

801069fc <vector93>:
.globl vector93
vector93:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $93
801069fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106a00:	e9 ff f7 ff ff       	jmp    80106204 <alltraps>

80106a05 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $94
80106a07:	6a 5e                	push   $0x5e
  jmp alltraps
80106a09:	e9 f6 f7 ff ff       	jmp    80106204 <alltraps>

80106a0e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $95
80106a10:	6a 5f                	push   $0x5f
  jmp alltraps
80106a12:	e9 ed f7 ff ff       	jmp    80106204 <alltraps>

80106a17 <vector96>:
.globl vector96
vector96:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $96
80106a19:	6a 60                	push   $0x60
  jmp alltraps
80106a1b:	e9 e4 f7 ff ff       	jmp    80106204 <alltraps>

80106a20 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $97
80106a22:	6a 61                	push   $0x61
  jmp alltraps
80106a24:	e9 db f7 ff ff       	jmp    80106204 <alltraps>

80106a29 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $98
80106a2b:	6a 62                	push   $0x62
  jmp alltraps
80106a2d:	e9 d2 f7 ff ff       	jmp    80106204 <alltraps>

80106a32 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $99
80106a34:	6a 63                	push   $0x63
  jmp alltraps
80106a36:	e9 c9 f7 ff ff       	jmp    80106204 <alltraps>

80106a3b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $100
80106a3d:	6a 64                	push   $0x64
  jmp alltraps
80106a3f:	e9 c0 f7 ff ff       	jmp    80106204 <alltraps>

80106a44 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $101
80106a46:	6a 65                	push   $0x65
  jmp alltraps
80106a48:	e9 b7 f7 ff ff       	jmp    80106204 <alltraps>

80106a4d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $102
80106a4f:	6a 66                	push   $0x66
  jmp alltraps
80106a51:	e9 ae f7 ff ff       	jmp    80106204 <alltraps>

80106a56 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $103
80106a58:	6a 67                	push   $0x67
  jmp alltraps
80106a5a:	e9 a5 f7 ff ff       	jmp    80106204 <alltraps>

80106a5f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $104
80106a61:	6a 68                	push   $0x68
  jmp alltraps
80106a63:	e9 9c f7 ff ff       	jmp    80106204 <alltraps>

80106a68 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $105
80106a6a:	6a 69                	push   $0x69
  jmp alltraps
80106a6c:	e9 93 f7 ff ff       	jmp    80106204 <alltraps>

80106a71 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $106
80106a73:	6a 6a                	push   $0x6a
  jmp alltraps
80106a75:	e9 8a f7 ff ff       	jmp    80106204 <alltraps>

80106a7a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $107
80106a7c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a7e:	e9 81 f7 ff ff       	jmp    80106204 <alltraps>

80106a83 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $108
80106a85:	6a 6c                	push   $0x6c
  jmp alltraps
80106a87:	e9 78 f7 ff ff       	jmp    80106204 <alltraps>

80106a8c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $109
80106a8e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a90:	e9 6f f7 ff ff       	jmp    80106204 <alltraps>

80106a95 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $110
80106a97:	6a 6e                	push   $0x6e
  jmp alltraps
80106a99:	e9 66 f7 ff ff       	jmp    80106204 <alltraps>

80106a9e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $111
80106aa0:	6a 6f                	push   $0x6f
  jmp alltraps
80106aa2:	e9 5d f7 ff ff       	jmp    80106204 <alltraps>

80106aa7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $112
80106aa9:	6a 70                	push   $0x70
  jmp alltraps
80106aab:	e9 54 f7 ff ff       	jmp    80106204 <alltraps>

80106ab0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $113
80106ab2:	6a 71                	push   $0x71
  jmp alltraps
80106ab4:	e9 4b f7 ff ff       	jmp    80106204 <alltraps>

80106ab9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $114
80106abb:	6a 72                	push   $0x72
  jmp alltraps
80106abd:	e9 42 f7 ff ff       	jmp    80106204 <alltraps>

80106ac2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $115
80106ac4:	6a 73                	push   $0x73
  jmp alltraps
80106ac6:	e9 39 f7 ff ff       	jmp    80106204 <alltraps>

80106acb <vector116>:
.globl vector116
vector116:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $116
80106acd:	6a 74                	push   $0x74
  jmp alltraps
80106acf:	e9 30 f7 ff ff       	jmp    80106204 <alltraps>

80106ad4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $117
80106ad6:	6a 75                	push   $0x75
  jmp alltraps
80106ad8:	e9 27 f7 ff ff       	jmp    80106204 <alltraps>

80106add <vector118>:
.globl vector118
vector118:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $118
80106adf:	6a 76                	push   $0x76
  jmp alltraps
80106ae1:	e9 1e f7 ff ff       	jmp    80106204 <alltraps>

80106ae6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $119
80106ae8:	6a 77                	push   $0x77
  jmp alltraps
80106aea:	e9 15 f7 ff ff       	jmp    80106204 <alltraps>

80106aef <vector120>:
.globl vector120
vector120:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $120
80106af1:	6a 78                	push   $0x78
  jmp alltraps
80106af3:	e9 0c f7 ff ff       	jmp    80106204 <alltraps>

80106af8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $121
80106afa:	6a 79                	push   $0x79
  jmp alltraps
80106afc:	e9 03 f7 ff ff       	jmp    80106204 <alltraps>

80106b01 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $122
80106b03:	6a 7a                	push   $0x7a
  jmp alltraps
80106b05:	e9 fa f6 ff ff       	jmp    80106204 <alltraps>

80106b0a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $123
80106b0c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b0e:	e9 f1 f6 ff ff       	jmp    80106204 <alltraps>

80106b13 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $124
80106b15:	6a 7c                	push   $0x7c
  jmp alltraps
80106b17:	e9 e8 f6 ff ff       	jmp    80106204 <alltraps>

80106b1c <vector125>:
.globl vector125
vector125:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $125
80106b1e:	6a 7d                	push   $0x7d
  jmp alltraps
80106b20:	e9 df f6 ff ff       	jmp    80106204 <alltraps>

80106b25 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $126
80106b27:	6a 7e                	push   $0x7e
  jmp alltraps
80106b29:	e9 d6 f6 ff ff       	jmp    80106204 <alltraps>

80106b2e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $127
80106b30:	6a 7f                	push   $0x7f
  jmp alltraps
80106b32:	e9 cd f6 ff ff       	jmp    80106204 <alltraps>

80106b37 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $128
80106b39:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b3e:	e9 c1 f6 ff ff       	jmp    80106204 <alltraps>

80106b43 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $129
80106b45:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b4a:	e9 b5 f6 ff ff       	jmp    80106204 <alltraps>

80106b4f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $130
80106b51:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b56:	e9 a9 f6 ff ff       	jmp    80106204 <alltraps>

80106b5b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $131
80106b5d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b62:	e9 9d f6 ff ff       	jmp    80106204 <alltraps>

80106b67 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $132
80106b69:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b6e:	e9 91 f6 ff ff       	jmp    80106204 <alltraps>

80106b73 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $133
80106b75:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b7a:	e9 85 f6 ff ff       	jmp    80106204 <alltraps>

80106b7f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $134
80106b81:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b86:	e9 79 f6 ff ff       	jmp    80106204 <alltraps>

80106b8b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $135
80106b8d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b92:	e9 6d f6 ff ff       	jmp    80106204 <alltraps>

80106b97 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $136
80106b99:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b9e:	e9 61 f6 ff ff       	jmp    80106204 <alltraps>

80106ba3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $137
80106ba5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106baa:	e9 55 f6 ff ff       	jmp    80106204 <alltraps>

80106baf <vector138>:
.globl vector138
vector138:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $138
80106bb1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106bb6:	e9 49 f6 ff ff       	jmp    80106204 <alltraps>

80106bbb <vector139>:
.globl vector139
vector139:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $139
80106bbd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106bc2:	e9 3d f6 ff ff       	jmp    80106204 <alltraps>

80106bc7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $140
80106bc9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106bce:	e9 31 f6 ff ff       	jmp    80106204 <alltraps>

80106bd3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $141
80106bd5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106bda:	e9 25 f6 ff ff       	jmp    80106204 <alltraps>

80106bdf <vector142>:
.globl vector142
vector142:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $142
80106be1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106be6:	e9 19 f6 ff ff       	jmp    80106204 <alltraps>

80106beb <vector143>:
.globl vector143
vector143:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $143
80106bed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bf2:	e9 0d f6 ff ff       	jmp    80106204 <alltraps>

80106bf7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $144
80106bf9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bfe:	e9 01 f6 ff ff       	jmp    80106204 <alltraps>

80106c03 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $145
80106c05:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c0a:	e9 f5 f5 ff ff       	jmp    80106204 <alltraps>

80106c0f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $146
80106c11:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c16:	e9 e9 f5 ff ff       	jmp    80106204 <alltraps>

80106c1b <vector147>:
.globl vector147
vector147:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $147
80106c1d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c22:	e9 dd f5 ff ff       	jmp    80106204 <alltraps>

80106c27 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $148
80106c29:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c2e:	e9 d1 f5 ff ff       	jmp    80106204 <alltraps>

80106c33 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $149
80106c35:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c3a:	e9 c5 f5 ff ff       	jmp    80106204 <alltraps>

80106c3f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $150
80106c41:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c46:	e9 b9 f5 ff ff       	jmp    80106204 <alltraps>

80106c4b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $151
80106c4d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c52:	e9 ad f5 ff ff       	jmp    80106204 <alltraps>

80106c57 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $152
80106c59:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c5e:	e9 a1 f5 ff ff       	jmp    80106204 <alltraps>

80106c63 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $153
80106c65:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c6a:	e9 95 f5 ff ff       	jmp    80106204 <alltraps>

80106c6f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $154
80106c71:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c76:	e9 89 f5 ff ff       	jmp    80106204 <alltraps>

80106c7b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $155
80106c7d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c82:	e9 7d f5 ff ff       	jmp    80106204 <alltraps>

80106c87 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $156
80106c89:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c8e:	e9 71 f5 ff ff       	jmp    80106204 <alltraps>

80106c93 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $157
80106c95:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c9a:	e9 65 f5 ff ff       	jmp    80106204 <alltraps>

80106c9f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $158
80106ca1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ca6:	e9 59 f5 ff ff       	jmp    80106204 <alltraps>

80106cab <vector159>:
.globl vector159
vector159:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $159
80106cad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106cb2:	e9 4d f5 ff ff       	jmp    80106204 <alltraps>

80106cb7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $160
80106cb9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106cbe:	e9 41 f5 ff ff       	jmp    80106204 <alltraps>

80106cc3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $161
80106cc5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106cca:	e9 35 f5 ff ff       	jmp    80106204 <alltraps>

80106ccf <vector162>:
.globl vector162
vector162:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $162
80106cd1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106cd6:	e9 29 f5 ff ff       	jmp    80106204 <alltraps>

80106cdb <vector163>:
.globl vector163
vector163:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $163
80106cdd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ce2:	e9 1d f5 ff ff       	jmp    80106204 <alltraps>

80106ce7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $164
80106ce9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cee:	e9 11 f5 ff ff       	jmp    80106204 <alltraps>

80106cf3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $165
80106cf5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cfa:	e9 05 f5 ff ff       	jmp    80106204 <alltraps>

80106cff <vector166>:
.globl vector166
vector166:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $166
80106d01:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d06:	e9 f9 f4 ff ff       	jmp    80106204 <alltraps>

80106d0b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $167
80106d0d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d12:	e9 ed f4 ff ff       	jmp    80106204 <alltraps>

80106d17 <vector168>:
.globl vector168
vector168:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $168
80106d19:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d1e:	e9 e1 f4 ff ff       	jmp    80106204 <alltraps>

80106d23 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $169
80106d25:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d2a:	e9 d5 f4 ff ff       	jmp    80106204 <alltraps>

80106d2f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $170
80106d31:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d36:	e9 c9 f4 ff ff       	jmp    80106204 <alltraps>

80106d3b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $171
80106d3d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d42:	e9 bd f4 ff ff       	jmp    80106204 <alltraps>

80106d47 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $172
80106d49:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d4e:	e9 b1 f4 ff ff       	jmp    80106204 <alltraps>

80106d53 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $173
80106d55:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d5a:	e9 a5 f4 ff ff       	jmp    80106204 <alltraps>

80106d5f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $174
80106d61:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d66:	e9 99 f4 ff ff       	jmp    80106204 <alltraps>

80106d6b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $175
80106d6d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d72:	e9 8d f4 ff ff       	jmp    80106204 <alltraps>

80106d77 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $176
80106d79:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d7e:	e9 81 f4 ff ff       	jmp    80106204 <alltraps>

80106d83 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $177
80106d85:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d8a:	e9 75 f4 ff ff       	jmp    80106204 <alltraps>

80106d8f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $178
80106d91:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d96:	e9 69 f4 ff ff       	jmp    80106204 <alltraps>

80106d9b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $179
80106d9d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106da2:	e9 5d f4 ff ff       	jmp    80106204 <alltraps>

80106da7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $180
80106da9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106dae:	e9 51 f4 ff ff       	jmp    80106204 <alltraps>

80106db3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $181
80106db5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106dba:	e9 45 f4 ff ff       	jmp    80106204 <alltraps>

80106dbf <vector182>:
.globl vector182
vector182:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $182
80106dc1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106dc6:	e9 39 f4 ff ff       	jmp    80106204 <alltraps>

80106dcb <vector183>:
.globl vector183
vector183:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $183
80106dcd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106dd2:	e9 2d f4 ff ff       	jmp    80106204 <alltraps>

80106dd7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $184
80106dd9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dde:	e9 21 f4 ff ff       	jmp    80106204 <alltraps>

80106de3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $185
80106de5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dea:	e9 15 f4 ff ff       	jmp    80106204 <alltraps>

80106def <vector186>:
.globl vector186
vector186:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $186
80106df1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106df6:	e9 09 f4 ff ff       	jmp    80106204 <alltraps>

80106dfb <vector187>:
.globl vector187
vector187:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $187
80106dfd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e02:	e9 fd f3 ff ff       	jmp    80106204 <alltraps>

80106e07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $188
80106e09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e0e:	e9 f1 f3 ff ff       	jmp    80106204 <alltraps>

80106e13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $189
80106e15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e1a:	e9 e5 f3 ff ff       	jmp    80106204 <alltraps>

80106e1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $190
80106e21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e26:	e9 d9 f3 ff ff       	jmp    80106204 <alltraps>

80106e2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $191
80106e2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e32:	e9 cd f3 ff ff       	jmp    80106204 <alltraps>

80106e37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $192
80106e39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e3e:	e9 c1 f3 ff ff       	jmp    80106204 <alltraps>

80106e43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $193
80106e45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e4a:	e9 b5 f3 ff ff       	jmp    80106204 <alltraps>

80106e4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $194
80106e51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e56:	e9 a9 f3 ff ff       	jmp    80106204 <alltraps>

80106e5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $195
80106e5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e62:	e9 9d f3 ff ff       	jmp    80106204 <alltraps>

80106e67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $196
80106e69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e6e:	e9 91 f3 ff ff       	jmp    80106204 <alltraps>

80106e73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $197
80106e75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e7a:	e9 85 f3 ff ff       	jmp    80106204 <alltraps>

80106e7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $198
80106e81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e86:	e9 79 f3 ff ff       	jmp    80106204 <alltraps>

80106e8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $199
80106e8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e92:	e9 6d f3 ff ff       	jmp    80106204 <alltraps>

80106e97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $200
80106e99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e9e:	e9 61 f3 ff ff       	jmp    80106204 <alltraps>

80106ea3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $201
80106ea5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106eaa:	e9 55 f3 ff ff       	jmp    80106204 <alltraps>

80106eaf <vector202>:
.globl vector202
vector202:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $202
80106eb1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106eb6:	e9 49 f3 ff ff       	jmp    80106204 <alltraps>

80106ebb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $203
80106ebd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ec2:	e9 3d f3 ff ff       	jmp    80106204 <alltraps>

80106ec7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $204
80106ec9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ece:	e9 31 f3 ff ff       	jmp    80106204 <alltraps>

80106ed3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $205
80106ed5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106eda:	e9 25 f3 ff ff       	jmp    80106204 <alltraps>

80106edf <vector206>:
.globl vector206
vector206:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $206
80106ee1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ee6:	e9 19 f3 ff ff       	jmp    80106204 <alltraps>

80106eeb <vector207>:
.globl vector207
vector207:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $207
80106eed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ef2:	e9 0d f3 ff ff       	jmp    80106204 <alltraps>

80106ef7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $208
80106ef9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106efe:	e9 01 f3 ff ff       	jmp    80106204 <alltraps>

80106f03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $209
80106f05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f0a:	e9 f5 f2 ff ff       	jmp    80106204 <alltraps>

80106f0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $210
80106f11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f16:	e9 e9 f2 ff ff       	jmp    80106204 <alltraps>

80106f1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $211
80106f1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f22:	e9 dd f2 ff ff       	jmp    80106204 <alltraps>

80106f27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $212
80106f29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f2e:	e9 d1 f2 ff ff       	jmp    80106204 <alltraps>

80106f33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $213
80106f35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f3a:	e9 c5 f2 ff ff       	jmp    80106204 <alltraps>

80106f3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $214
80106f41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f46:	e9 b9 f2 ff ff       	jmp    80106204 <alltraps>

80106f4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $215
80106f4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f52:	e9 ad f2 ff ff       	jmp    80106204 <alltraps>

80106f57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $216
80106f59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f5e:	e9 a1 f2 ff ff       	jmp    80106204 <alltraps>

80106f63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $217
80106f65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f6a:	e9 95 f2 ff ff       	jmp    80106204 <alltraps>

80106f6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $218
80106f71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f76:	e9 89 f2 ff ff       	jmp    80106204 <alltraps>

80106f7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $219
80106f7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f82:	e9 7d f2 ff ff       	jmp    80106204 <alltraps>

80106f87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $220
80106f89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f8e:	e9 71 f2 ff ff       	jmp    80106204 <alltraps>

80106f93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $221
80106f95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f9a:	e9 65 f2 ff ff       	jmp    80106204 <alltraps>

80106f9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $222
80106fa1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106fa6:	e9 59 f2 ff ff       	jmp    80106204 <alltraps>

80106fab <vector223>:
.globl vector223
vector223:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $223
80106fad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106fb2:	e9 4d f2 ff ff       	jmp    80106204 <alltraps>

80106fb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $224
80106fb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106fbe:	e9 41 f2 ff ff       	jmp    80106204 <alltraps>

80106fc3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $225
80106fc5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106fca:	e9 35 f2 ff ff       	jmp    80106204 <alltraps>

80106fcf <vector226>:
.globl vector226
vector226:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $226
80106fd1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fd6:	e9 29 f2 ff ff       	jmp    80106204 <alltraps>

80106fdb <vector227>:
.globl vector227
vector227:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $227
80106fdd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fe2:	e9 1d f2 ff ff       	jmp    80106204 <alltraps>

80106fe7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $228
80106fe9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fee:	e9 11 f2 ff ff       	jmp    80106204 <alltraps>

80106ff3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $229
80106ff5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106ffa:	e9 05 f2 ff ff       	jmp    80106204 <alltraps>

80106fff <vector230>:
.globl vector230
vector230:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $230
80107001:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107006:	e9 f9 f1 ff ff       	jmp    80106204 <alltraps>

8010700b <vector231>:
.globl vector231
vector231:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $231
8010700d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107012:	e9 ed f1 ff ff       	jmp    80106204 <alltraps>

80107017 <vector232>:
.globl vector232
vector232:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $232
80107019:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010701e:	e9 e1 f1 ff ff       	jmp    80106204 <alltraps>

80107023 <vector233>:
.globl vector233
vector233:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $233
80107025:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010702a:	e9 d5 f1 ff ff       	jmp    80106204 <alltraps>

8010702f <vector234>:
.globl vector234
vector234:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $234
80107031:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107036:	e9 c9 f1 ff ff       	jmp    80106204 <alltraps>

8010703b <vector235>:
.globl vector235
vector235:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $235
8010703d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107042:	e9 bd f1 ff ff       	jmp    80106204 <alltraps>

80107047 <vector236>:
.globl vector236
vector236:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $236
80107049:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010704e:	e9 b1 f1 ff ff       	jmp    80106204 <alltraps>

80107053 <vector237>:
.globl vector237
vector237:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $237
80107055:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010705a:	e9 a5 f1 ff ff       	jmp    80106204 <alltraps>

8010705f <vector238>:
.globl vector238
vector238:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $238
80107061:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107066:	e9 99 f1 ff ff       	jmp    80106204 <alltraps>

8010706b <vector239>:
.globl vector239
vector239:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $239
8010706d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107072:	e9 8d f1 ff ff       	jmp    80106204 <alltraps>

80107077 <vector240>:
.globl vector240
vector240:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $240
80107079:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010707e:	e9 81 f1 ff ff       	jmp    80106204 <alltraps>

80107083 <vector241>:
.globl vector241
vector241:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $241
80107085:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010708a:	e9 75 f1 ff ff       	jmp    80106204 <alltraps>

8010708f <vector242>:
.globl vector242
vector242:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $242
80107091:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107096:	e9 69 f1 ff ff       	jmp    80106204 <alltraps>

8010709b <vector243>:
.globl vector243
vector243:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $243
8010709d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801070a2:	e9 5d f1 ff ff       	jmp    80106204 <alltraps>

801070a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $244
801070a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801070ae:	e9 51 f1 ff ff       	jmp    80106204 <alltraps>

801070b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $245
801070b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801070ba:	e9 45 f1 ff ff       	jmp    80106204 <alltraps>

801070bf <vector246>:
.globl vector246
vector246:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $246
801070c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801070c6:	e9 39 f1 ff ff       	jmp    80106204 <alltraps>

801070cb <vector247>:
.globl vector247
vector247:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $247
801070cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070d2:	e9 2d f1 ff ff       	jmp    80106204 <alltraps>

801070d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $248
801070d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070de:	e9 21 f1 ff ff       	jmp    80106204 <alltraps>

801070e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $249
801070e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070ea:	e9 15 f1 ff ff       	jmp    80106204 <alltraps>

801070ef <vector250>:
.globl vector250
vector250:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $250
801070f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070f6:	e9 09 f1 ff ff       	jmp    80106204 <alltraps>

801070fb <vector251>:
.globl vector251
vector251:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $251
801070fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107102:	e9 fd f0 ff ff       	jmp    80106204 <alltraps>

80107107 <vector252>:
.globl vector252
vector252:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $252
80107109:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010710e:	e9 f1 f0 ff ff       	jmp    80106204 <alltraps>

80107113 <vector253>:
.globl vector253
vector253:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $253
80107115:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010711a:	e9 e5 f0 ff ff       	jmp    80106204 <alltraps>

8010711f <vector254>:
.globl vector254
vector254:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $254
80107121:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107126:	e9 d9 f0 ff ff       	jmp    80106204 <alltraps>

8010712b <vector255>:
.globl vector255
vector255:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $255
8010712d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107132:	e9 cd f0 ff ff       	jmp    80106204 <alltraps>
80107137:	66 90                	xchg   %ax,%ax
80107139:	66 90                	xchg   %ax,%ax
8010713b:	66 90                	xchg   %ax,%ax
8010713d:	66 90                	xchg   %ax,%ax
8010713f:	90                   	nop

80107140 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107146:	e8 95 ca ff ff       	call   80103be0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010714b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107151:	31 c9                	xor    %ecx,%ecx
80107153:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107158:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
8010715f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107166:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010716b:	31 c9                	xor    %ecx,%ecx
8010716d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107174:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107179:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107180:	31 c9                	xor    %ecx,%ecx
80107182:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80107189:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107190:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107195:	31 c9                	xor    %ecx,%ecx
80107197:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010719e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801071a5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071aa:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
801071b1:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
801071b8:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071bf:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
801071c6:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
801071cd:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
801071d4:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071db:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
801071e2:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
801071e9:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
801071f0:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071f7:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
801071fe:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80107205:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
8010720c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80107213:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010721a:	05 f0 37 11 80       	add    $0x801137f0,%eax
8010721f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107223:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107227:	c1 e8 10             	shr    $0x10,%eax
8010722a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010722e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107231:	0f 01 10             	lgdtl  (%eax)
}
80107234:	c9                   	leave  
80107235:	c3                   	ret    
80107236:	8d 76 00             	lea    0x0(%esi),%esi
80107239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107240 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010724c:	8b 55 08             	mov    0x8(%ebp),%edx
8010724f:	89 df                	mov    %ebx,%edi
80107251:	c1 ef 16             	shr    $0x16,%edi
80107254:	8d 3c ba             	lea    (%edx,%edi,4),%edi
  if(*pde & PTE_P){
80107257:	8b 07                	mov    (%edi),%eax
80107259:	a8 01                	test   $0x1,%al
8010725b:	74 23                	je     80107280 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010725d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107262:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107268:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010726b:	c1 eb 0a             	shr    $0xa,%ebx
8010726e:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80107274:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107277:	5b                   	pop    %ebx
80107278:	5e                   	pop    %esi
80107279:	5f                   	pop    %edi
8010727a:	5d                   	pop    %ebp
8010727b:	c3                   	ret    
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107280:	8b 45 10             	mov    0x10(%ebp),%eax
80107283:	85 c0                	test   %eax,%eax
80107285:	74 31                	je     801072b8 <walkpgdir+0x78>
80107287:	e8 24 b6 ff ff       	call   801028b0 <kalloc>
8010728c:	85 c0                	test   %eax,%eax
8010728e:	89 c6                	mov    %eax,%esi
80107290:	74 26                	je     801072b8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107292:	83 ec 04             	sub    $0x4,%esp
80107295:	68 00 10 00 00       	push   $0x1000
8010729a:	6a 00                	push   $0x0
8010729c:	50                   	push   %eax
8010729d:	e8 ce da ff ff       	call   80104d70 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072a2:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801072a8:	83 c4 10             	add    $0x10,%esp
801072ab:	83 c8 07             	or     $0x7,%eax
801072ae:	89 07                	mov    %eax,(%edi)
801072b0:	eb b6                	jmp    80107268 <walkpgdir+0x28>
801072b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  return &pgtab[PTX(va)];
}
801072b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801072bb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801072bd:	5b                   	pop    %ebx
801072be:	5e                   	pop    %esi
801072bf:	5f                   	pop    %edi
801072c0:	5d                   	pop    %ebp
801072c1:	c3                   	ret    
801072c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072d6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072da:	56                   	push   %esi
801072db:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801072dc:	89 d6                	mov    %edx,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072e3:	83 ec 1c             	sub    $0x1c,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801072e6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072ef:	8b 45 08             	mov    0x8(%ebp),%eax
801072f2:	29 f0                	sub    %esi,%eax
801072f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801072f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801072fa:	83 c8 01             	or     $0x1,%eax
801072fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107300:	eb 1b                	jmp    8010731d <mappages+0x4d>
80107302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107308:	f6 00 01             	testb  $0x1,(%eax)
8010730b:	75 45                	jne    80107352 <mappages+0x82>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010730d:	0b 5d dc             	or     -0x24(%ebp),%ebx
    if(a == last)
80107310:	3b 75 e0             	cmp    -0x20(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107313:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80107315:	74 31                	je     80107348 <mappages+0x78>
      break;
    a += PGSIZE;
80107317:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010731d:	83 ec 04             	sub    $0x4,%esp
80107320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107323:	6a 01                	push   $0x1
80107325:	56                   	push   %esi
80107326:	57                   	push   %edi
80107327:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
8010732a:	e8 11 ff ff ff       	call   80107240 <walkpgdir>
8010732f:	83 c4 10             	add    $0x10,%esp
80107332:	85 c0                	test   %eax,%eax
80107334:	75 d2                	jne    80107308 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107336:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80107339:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010733e:	5b                   	pop    %ebx
8010733f:	5e                   	pop    %esi
80107340:	5f                   	pop    %edi
80107341:	5d                   	pop    %ebp
80107342:	c3                   	ret    
80107343:	90                   	nop
80107344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107348:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010734b:	31 c0                	xor    %eax,%eax
}
8010734d:	5b                   	pop    %ebx
8010734e:	5e                   	pop    %esi
8010734f:	5f                   	pop    %edi
80107350:	5d                   	pop    %ebp
80107351:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80107352:	83 ec 0c             	sub    $0xc,%esp
80107355:	68 28 84 10 80       	push   $0x80108428
8010735a:	e8 11 90 ff ff       	call   80100370 <panic>
8010735f:	90                   	nop

80107360 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107368:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010736e:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107370:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107376:	83 ec 1c             	sub    $0x1c,%esp
80107379:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010737c:	39 da                	cmp    %ebx,%edx
8010737e:	73 6a                	jae    801073ea <deallocuvm.part.0+0x8a>
80107380:	89 d7                	mov    %edx,%edi
80107382:	eb 3b                	jmp    801073bf <deallocuvm.part.0+0x5f>
80107384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107388:	8b 08                	mov    (%eax),%ecx
8010738a:	f6 c1 01             	test   $0x1,%cl
8010738d:	74 26                	je     801073b5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010738f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107395:	74 5e                	je     801073f5 <deallocuvm.part.0+0x95>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107397:	83 ec 0c             	sub    $0xc,%esp
8010739a:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
801073a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073a3:	51                   	push   %ecx
801073a4:	e8 57 b3 ff ff       	call   80102700 <kfree>
      *pte = 0;
801073a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073ac:	83 c4 10             	add    $0x10,%esp
801073af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801073b5:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073bb:	39 df                	cmp    %ebx,%edi
801073bd:	73 2b                	jae    801073ea <deallocuvm.part.0+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
801073bf:	83 ec 04             	sub    $0x4,%esp
801073c2:	6a 00                	push   $0x0
801073c4:	57                   	push   %edi
801073c5:	56                   	push   %esi
801073c6:	e8 75 fe ff ff       	call   80107240 <walkpgdir>
    if(!pte)
801073cb:	83 c4 10             	add    $0x10,%esp
801073ce:	85 c0                	test   %eax,%eax
801073d0:	75 b6                	jne    80107388 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073d2:	89 fa                	mov    %edi,%edx
801073d4:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801073da:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801073e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073e6:	39 df                	cmp    %ebx,%edi
801073e8:	72 d5                	jb     801073bf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801073ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f0:	5b                   	pop    %ebx
801073f1:	5e                   	pop    %esi
801073f2:	5f                   	pop    %edi
801073f3:	5d                   	pop    %ebp
801073f4:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801073f5:	83 ec 0c             	sub    $0xc,%esp
801073f8:	68 46 7d 10 80       	push   $0x80107d46
801073fd:	e8 6e 8f ff ff       	call   80100370 <panic>
80107402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107410:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107415:	55                   	push   %ebp
80107416:	89 e5                	mov    %esp,%ebp
80107418:	05 00 00 00 80       	add    $0x80000000,%eax
8010741d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107420:	5d                   	pop    %ebp
80107421:	c3                   	ret    
80107422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
80107439:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010743c:	85 f6                	test   %esi,%esi
8010743e:	0f 84 cd 00 00 00    	je     80107511 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107444:	8b 46 08             	mov    0x8(%esi),%eax
80107447:	85 c0                	test   %eax,%eax
80107449:	0f 84 dc 00 00 00    	je     8010752b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010744f:	8b 7e 04             	mov    0x4(%esi),%edi
80107452:	85 ff                	test   %edi,%edi
80107454:	0f 84 c4 00 00 00    	je     8010751e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010745a:	e8 31 d7 ff ff       	call   80104b90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010745f:	e8 fc c6 ff ff       	call   80103b60 <mycpu>
80107464:	89 c3                	mov    %eax,%ebx
80107466:	e8 f5 c6 ff ff       	call   80103b60 <mycpu>
8010746b:	89 c7                	mov    %eax,%edi
8010746d:	e8 ee c6 ff ff       	call   80103b60 <mycpu>
80107472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107475:	83 c7 08             	add    $0x8,%edi
80107478:	e8 e3 c6 ff ff       	call   80103b60 <mycpu>
8010747d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107480:	83 c0 08             	add    $0x8,%eax
80107483:	ba 67 00 00 00       	mov    $0x67,%edx
80107488:	c1 e8 18             	shr    $0x18,%eax
8010748b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107492:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107499:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801074a0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801074a7:	83 c1 08             	add    $0x8,%ecx
801074aa:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801074b0:	c1 e9 10             	shr    $0x10,%ecx
801074b3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801074be:	e8 9d c6 ff ff       	call   80103b60 <mycpu>
801074c3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074ca:	e8 91 c6 ff ff       	call   80103b60 <mycpu>
801074cf:	b9 10 00 00 00       	mov    $0x10,%ecx
801074d4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074d8:	e8 83 c6 ff ff       	call   80103b60 <mycpu>
801074dd:	8b 56 08             	mov    0x8(%esi),%edx
801074e0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801074e6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074e9:	e8 72 c6 ff ff       	call   80103b60 <mycpu>
801074ee:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801074f2:	b8 28 00 00 00       	mov    $0x28,%eax
801074f7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074fa:	8b 46 04             	mov    0x4(%esi),%eax
801074fd:	05 00 00 00 80       	add    $0x80000000,%eax
80107502:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107508:	5b                   	pop    %ebx
80107509:	5e                   	pop    %esi
8010750a:	5f                   	pop    %edi
8010750b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010750c:	e9 bf d6 ff ff       	jmp    80104bd0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107511:	83 ec 0c             	sub    $0xc,%esp
80107514:	68 2e 84 10 80       	push   $0x8010842e
80107519:	e8 52 8e ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010751e:	83 ec 0c             	sub    $0xc,%esp
80107521:	68 59 84 10 80       	push   $0x80108459
80107526:	e8 45 8e ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010752b:	83 ec 0c             	sub    $0xc,%esp
8010752e:	68 44 84 10 80       	push   $0x80108444
80107533:	e8 38 8e ff ff       	call   80100370 <panic>
80107538:	90                   	nop
80107539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107540 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 1c             	sub    $0x1c,%esp
80107549:	8b 75 10             	mov    0x10(%ebp),%esi
8010754c:	8b 45 08             	mov    0x8(%ebp),%eax
8010754f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107552:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010755b:	77 49                	ja     801075a6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010755d:	e8 4e b3 ff ff       	call   801028b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107562:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107565:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107567:	68 00 10 00 00       	push   $0x1000
8010756c:	6a 00                	push   $0x0
8010756e:	50                   	push   %eax
8010756f:	e8 fc d7 ff ff       	call   80104d70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107574:	58                   	pop    %eax
80107575:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010757b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107580:	5a                   	pop    %edx
80107581:	6a 06                	push   $0x6
80107583:	50                   	push   %eax
80107584:	31 d2                	xor    %edx,%edx
80107586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107589:	e8 42 fd ff ff       	call   801072d0 <mappages>
  memmove(mem, init, sz);
8010758e:	89 75 10             	mov    %esi,0x10(%ebp)
80107591:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107594:	83 c4 10             	add    $0x10,%esp
80107597:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010759a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759d:	5b                   	pop    %ebx
8010759e:	5e                   	pop    %esi
8010759f:	5f                   	pop    %edi
801075a0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801075a1:	e9 7a d8 ff ff       	jmp    80104e20 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 6d 84 10 80       	push   $0x8010846d
801075ae:	e8 bd 8d ff ff       	call   80100370 <panic>
801075b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	57                   	push   %edi
801075c4:	56                   	push   %esi
801075c5:	53                   	push   %ebx
801075c6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801075c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801075d0:	0f 85 99 00 00 00    	jne    8010766f <loaduvm+0xaf>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801075d6:	8b 5d 18             	mov    0x18(%ebp),%ebx
801075d9:	31 ff                	xor    %edi,%edi
801075db:	85 db                	test   %ebx,%ebx
801075dd:	75 1a                	jne    801075f9 <loaduvm+0x39>
801075df:	eb 77                	jmp    80107658 <loaduvm+0x98>
801075e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075ee:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801075f4:	39 7d 18             	cmp    %edi,0x18(%ebp)
801075f7:	76 5f                	jbe    80107658 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801075f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801075fc:	83 ec 04             	sub    $0x4,%esp
801075ff:	6a 00                	push   $0x0
80107601:	01 f8                	add    %edi,%eax
80107603:	50                   	push   %eax
80107604:	ff 75 08             	pushl  0x8(%ebp)
80107607:	e8 34 fc ff ff       	call   80107240 <walkpgdir>
8010760c:	83 c4 10             	add    $0x10,%esp
8010760f:	85 c0                	test   %eax,%eax
80107611:	74 4f                	je     80107662 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107613:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107615:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107618:	be 00 10 00 00       	mov    $0x1000,%esi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010761d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107622:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107628:	0f 46 f3             	cmovbe %ebx,%esi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010762b:	01 f9                	add    %edi,%ecx
8010762d:	05 00 00 00 80       	add    $0x80000000,%eax
80107632:	56                   	push   %esi
80107633:	51                   	push   %ecx
80107634:	50                   	push   %eax
80107635:	ff 75 10             	pushl  0x10(%ebp)
80107638:	e8 33 a7 ff ff       	call   80101d70 <readi>
8010763d:	83 c4 10             	add    $0x10,%esp
80107640:	39 c6                	cmp    %eax,%esi
80107642:	74 a4                	je     801075e8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107644:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
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
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010765b:	31 c0                	xor    %eax,%eax
}
8010765d:	5b                   	pop    %ebx
8010765e:	5e                   	pop    %esi
8010765f:	5f                   	pop    %edi
80107660:	5d                   	pop    %ebp
80107661:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107662:	83 ec 0c             	sub    $0xc,%esp
80107665:	68 87 84 10 80       	push   $0x80108487
8010766a:	e8 01 8d ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010766f:	83 ec 0c             	sub    $0xc,%esp
80107672:	68 28 85 10 80       	push   $0x80108528
80107677:	e8 f4 8c ff ff       	call   80100370 <panic>
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107680 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	57                   	push   %edi
80107684:	56                   	push   %esi
80107685:	53                   	push   %ebx
80107686:	83 ec 0c             	sub    $0xc,%esp
80107689:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010768c:	85 ff                	test   %edi,%edi
8010768e:	0f 88 ca 00 00 00    	js     8010775e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107694:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107697:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010769a:	0f 82 82 00 00 00    	jb     80107722 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
801076a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801076a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801076ac:	39 df                	cmp    %ebx,%edi
801076ae:	77 43                	ja     801076f3 <allocuvm+0x73>
801076b0:	e9 bb 00 00 00       	jmp    80107770 <allocuvm+0xf0>
801076b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801076b8:	83 ec 04             	sub    $0x4,%esp
801076bb:	68 00 10 00 00       	push   $0x1000
801076c0:	6a 00                	push   $0x0
801076c2:	50                   	push   %eax
801076c3:	e8 a8 d6 ff ff       	call   80104d70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801076c8:	58                   	pop    %eax
801076c9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076cf:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076d4:	5a                   	pop    %edx
801076d5:	6a 06                	push   $0x6
801076d7:	50                   	push   %eax
801076d8:	89 da                	mov    %ebx,%edx
801076da:	8b 45 08             	mov    0x8(%ebp),%eax
801076dd:	e8 ee fb ff ff       	call   801072d0 <mappages>
801076e2:	83 c4 10             	add    $0x10,%esp
801076e5:	85 c0                	test   %eax,%eax
801076e7:	78 47                	js     80107730 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801076e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076ef:	39 df                	cmp    %ebx,%edi
801076f1:	76 7d                	jbe    80107770 <allocuvm+0xf0>
    mem = kalloc();
801076f3:	e8 b8 b1 ff ff       	call   801028b0 <kalloc>
    if(mem == 0){
801076f8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801076fa:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801076fc:	75 ba                	jne    801076b8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801076fe:	83 ec 0c             	sub    $0xc,%esp
80107701:	68 a5 84 10 80       	push   $0x801084a5
80107706:	e8 55 8f ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010770b:	83 c4 10             	add    $0x10,%esp
8010770e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107711:	76 4b                	jbe    8010775e <allocuvm+0xde>
80107713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107716:	8b 45 08             	mov    0x8(%ebp),%eax
80107719:	89 fa                	mov    %edi,%edx
8010771b:	e8 40 fc ff ff       	call   80107360 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107720:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107722:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107725:	5b                   	pop    %ebx
80107726:	5e                   	pop    %esi
80107727:	5f                   	pop    %edi
80107728:	5d                   	pop    %ebp
80107729:	c3                   	ret    
8010772a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107730:	83 ec 0c             	sub    $0xc,%esp
80107733:	68 bd 84 10 80       	push   $0x801084bd
80107738:	e8 23 8f ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010773d:	83 c4 10             	add    $0x10,%esp
80107740:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107743:	76 0d                	jbe    80107752 <allocuvm+0xd2>
80107745:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107748:	8b 45 08             	mov    0x8(%ebp),%eax
8010774b:	89 fa                	mov    %edi,%edx
8010774d:	e8 0e fc ff ff       	call   80107360 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107752:	83 ec 0c             	sub    $0xc,%esp
80107755:	56                   	push   %esi
80107756:	e8 a5 af ff ff       	call   80102700 <kfree>
      return 0;
8010775b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010775e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107761:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107763:	5b                   	pop    %ebx
80107764:	5e                   	pop    %esi
80107765:	5f                   	pop    %edi
80107766:	5d                   	pop    %ebp
80107767:	c3                   	ret    
80107768:	90                   	nop
80107769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107770:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107773:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107775:	5b                   	pop    %ebx
80107776:	5e                   	pop    %esi
80107777:	5f                   	pop    %edi
80107778:	5d                   	pop    %ebp
80107779:	c3                   	ret    
8010777a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107780 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	8b 55 0c             	mov    0xc(%ebp),%edx
80107786:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107789:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010778c:	39 d1                	cmp    %edx,%ecx
8010778e:	73 10                	jae    801077a0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107790:	5d                   	pop    %ebp
80107791:	e9 ca fb ff ff       	jmp    80107360 <deallocuvm.part.0>
80107796:	8d 76 00             	lea    0x0(%esi),%esi
80107799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801077a0:	89 d0                	mov    %edx,%eax
801077a2:	5d                   	pop    %ebp
801077a3:	c3                   	ret    
801077a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801077b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 0c             	sub    $0xc,%esp
801077b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801077bc:	85 f6                	test   %esi,%esi
801077be:	74 59                	je     80107819 <freevm+0x69>
801077c0:	31 c9                	xor    %ecx,%ecx
801077c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801077c7:	89 f0                	mov    %esi,%eax
801077c9:	e8 92 fb ff ff       	call   80107360 <deallocuvm.part.0>
801077ce:	89 f3                	mov    %esi,%ebx
801077d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077d6:	eb 0f                	jmp    801077e7 <freevm+0x37>
801077d8:	90                   	nop
801077d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077e3:	39 fb                	cmp    %edi,%ebx
801077e5:	74 23                	je     8010780a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077e7:	8b 03                	mov    (%ebx),%eax
801077e9:	a8 01                	test   $0x1,%al
801077eb:	74 f3                	je     801077e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801077ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077f2:	83 ec 0c             	sub    $0xc,%esp
801077f5:	83 c3 04             	add    $0x4,%ebx
801077f8:	05 00 00 00 80       	add    $0x80000000,%eax
801077fd:	50                   	push   %eax
801077fe:	e8 fd ae ff ff       	call   80102700 <kfree>
80107803:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107806:	39 fb                	cmp    %edi,%ebx
80107808:	75 dd                	jne    801077e7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010780a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010780d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107810:	5b                   	pop    %ebx
80107811:	5e                   	pop    %esi
80107812:	5f                   	pop    %edi
80107813:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107814:	e9 e7 ae ff ff       	jmp    80102700 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107819:	83 ec 0c             	sub    $0xc,%esp
8010781c:	68 d9 84 10 80       	push   $0x801084d9
80107821:	e8 4a 8b ff ff       	call   80100370 <panic>
80107826:	8d 76 00             	lea    0x0(%esi),%esi
80107829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107830 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	56                   	push   %esi
80107834:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107835:	e8 76 b0 ff ff       	call   801028b0 <kalloc>
8010783a:	85 c0                	test   %eax,%eax
8010783c:	74 6a                	je     801078a8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010783e:	83 ec 04             	sub    $0x4,%esp
80107841:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107843:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107848:	68 00 10 00 00       	push   $0x1000
8010784d:	6a 00                	push   $0x0
8010784f:	50                   	push   %eax
80107850:	e8 1b d5 ff ff       	call   80104d70 <memset>
80107855:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107858:	8b 43 04             	mov    0x4(%ebx),%eax
8010785b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010785e:	83 ec 08             	sub    $0x8,%esp
80107861:	8b 13                	mov    (%ebx),%edx
80107863:	ff 73 0c             	pushl  0xc(%ebx)
80107866:	50                   	push   %eax
80107867:	29 c1                	sub    %eax,%ecx
80107869:	89 f0                	mov    %esi,%eax
8010786b:	e8 60 fa ff ff       	call   801072d0 <mappages>
80107870:	83 c4 10             	add    $0x10,%esp
80107873:	85 c0                	test   %eax,%eax
80107875:	78 19                	js     80107890 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107877:	83 c3 10             	add    $0x10,%ebx
8010787a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107880:	75 d6                	jne    80107858 <setupkvm+0x28>
80107882:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107887:	5b                   	pop    %ebx
80107888:	5e                   	pop    %esi
80107889:	5d                   	pop    %ebp
8010788a:	c3                   	ret    
8010788b:	90                   	nop
8010788c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107890:	83 ec 0c             	sub    $0xc,%esp
80107893:	56                   	push   %esi
80107894:	e8 17 ff ff ff       	call   801077b0 <freevm>
      return 0;
80107899:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010789c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010789f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801078a1:	5b                   	pop    %ebx
801078a2:	5e                   	pop    %esi
801078a3:	5d                   	pop    %ebp
801078a4:	c3                   	ret    
801078a5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801078a8:	31 c0                	xor    %eax,%eax
801078aa:	eb d8                	jmp    80107884 <setupkvm+0x54>
801078ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078b0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801078b6:	e8 75 ff ff ff       	call   80107830 <setupkvm>
801078bb:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
801078c0:	05 00 00 00 80       	add    $0x80000000,%eax
801078c5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801078c8:	c9                   	leave  
801078c9:	c3                   	ret    
801078ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078d6:	6a 00                	push   $0x0
801078d8:	ff 75 0c             	pushl  0xc(%ebp)
801078db:	ff 75 08             	pushl  0x8(%ebp)
801078de:	e8 5d f9 ff ff       	call   80107240 <walkpgdir>
  if(pte == 0)
801078e3:	83 c4 10             	add    $0x10,%esp
801078e6:	85 c0                	test   %eax,%eax
801078e8:	74 05                	je     801078ef <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801078ea:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078ed:	c9                   	leave  
801078ee:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801078ef:	83 ec 0c             	sub    $0xc,%esp
801078f2:	68 ea 84 10 80       	push   $0x801084ea
801078f7:	e8 74 8a ff ff       	call   80100370 <panic>
801078fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107900 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	56                   	push   %esi
80107905:	53                   	push   %ebx
80107906:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107909:	e8 22 ff ff ff       	call   80107830 <setupkvm>
8010790e:	85 c0                	test   %eax,%eax
80107910:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107913:	0f 84 c5 00 00 00    	je     801079de <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010791c:	85 c9                	test   %ecx,%ecx
8010791e:	0f 84 9c 00 00 00    	je     801079c0 <copyuvm+0xc0>
80107924:	31 ff                	xor    %edi,%edi
80107926:	eb 4a                	jmp    80107972 <copyuvm+0x72>
80107928:	90                   	nop
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107930:	83 ec 04             	sub    $0x4,%esp
80107933:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107939:	68 00 10 00 00       	push   $0x1000
8010793e:	53                   	push   %ebx
8010793f:	50                   	push   %eax
80107940:	e8 db d4 ff ff       	call   80104e20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107945:	58                   	pop    %eax
80107946:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010794c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107951:	5a                   	pop    %edx
80107952:	ff 75 e4             	pushl  -0x1c(%ebp)
80107955:	50                   	push   %eax
80107956:	89 fa                	mov    %edi,%edx
80107958:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010795b:	e8 70 f9 ff ff       	call   801072d0 <mappages>
80107960:	83 c4 10             	add    $0x10,%esp
80107963:	85 c0                	test   %eax,%eax
80107965:	78 69                	js     801079d0 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107967:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010796d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107970:	76 4e                	jbe    801079c0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107972:	83 ec 04             	sub    $0x4,%esp
80107975:	6a 00                	push   $0x0
80107977:	57                   	push   %edi
80107978:	ff 75 08             	pushl  0x8(%ebp)
8010797b:	e8 c0 f8 ff ff       	call   80107240 <walkpgdir>
80107980:	83 c4 10             	add    $0x10,%esp
80107983:	85 c0                	test   %eax,%eax
80107985:	74 68                	je     801079ef <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107987:	8b 00                	mov    (%eax),%eax
80107989:	a8 01                	test   $0x1,%al
8010798b:	74 55                	je     801079e2 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010798d:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010798f:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107994:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
8010799a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010799d:	e8 0e af ff ff       	call   801028b0 <kalloc>
801079a2:	85 c0                	test   %eax,%eax
801079a4:	89 c6                	mov    %eax,%esi
801079a6:	75 88                	jne    80107930 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801079a8:	83 ec 0c             	sub    $0xc,%esp
801079ab:	ff 75 e0             	pushl  -0x20(%ebp)
801079ae:	e8 fd fd ff ff       	call   801077b0 <freevm>
  return 0;
801079b3:	83 c4 10             	add    $0x10,%esp
801079b6:	31 c0                	xor    %eax,%eax
}
801079b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bb:	5b                   	pop    %ebx
801079bc:	5e                   	pop    %esi
801079bd:	5f                   	pop    %edi
801079be:	5d                   	pop    %ebp
801079bf:	c3                   	ret    
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801079c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079c6:	5b                   	pop    %ebx
801079c7:	5e                   	pop    %esi
801079c8:	5f                   	pop    %edi
801079c9:	5d                   	pop    %ebp
801079ca:	c3                   	ret    
801079cb:	90                   	nop
801079cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
801079d0:	83 ec 0c             	sub    $0xc,%esp
801079d3:	56                   	push   %esi
801079d4:	e8 27 ad ff ff       	call   80102700 <kfree>
      goto bad;
801079d9:	83 c4 10             	add    $0x10,%esp
801079dc:	eb ca                	jmp    801079a8 <copyuvm+0xa8>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801079de:	31 c0                	xor    %eax,%eax
801079e0:	eb d6                	jmp    801079b8 <copyuvm+0xb8>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801079e2:	83 ec 0c             	sub    $0xc,%esp
801079e5:	68 0e 85 10 80       	push   $0x8010850e
801079ea:	e8 81 89 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801079ef:	83 ec 0c             	sub    $0xc,%esp
801079f2:	68 f4 84 10 80       	push   $0x801084f4
801079f7:	e8 74 89 ff ff       	call   80100370 <panic>
801079fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a06:	6a 00                	push   $0x0
80107a08:	ff 75 0c             	pushl  0xc(%ebp)
80107a0b:	ff 75 08             	pushl  0x8(%ebp)
80107a0e:	e8 2d f8 ff ff       	call   80107240 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a13:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107a15:	83 c4 10             	add    $0x10,%esp
80107a18:	89 c2                	mov    %eax,%edx
80107a1a:	83 e2 05             	and    $0x5,%edx
80107a1d:	83 fa 05             	cmp    $0x5,%edx
80107a20:	75 0e                	jne    80107a30 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107a22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107a27:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107a28:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107a2d:	c3                   	ret    
80107a2e:	66 90                	xchg   %ax,%ax

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107a30:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a32:	c9                   	leave  
80107a33:	c3                   	ret    
80107a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	57                   	push   %edi
80107a44:	56                   	push   %esi
80107a45:	53                   	push   %ebx
80107a46:	83 ec 1c             	sub    $0x1c,%esp
80107a49:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a52:	85 db                	test   %ebx,%ebx
80107a54:	75 40                	jne    80107a96 <copyout+0x56>
80107a56:	eb 70                	jmp    80107ac8 <copyout+0x88>
80107a58:	90                   	nop
80107a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a63:	89 f1                	mov    %esi,%ecx
80107a65:	29 d1                	sub    %edx,%ecx
80107a67:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107a6d:	39 d9                	cmp    %ebx,%ecx
80107a6f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a72:	29 f2                	sub    %esi,%edx
80107a74:	83 ec 04             	sub    $0x4,%esp
80107a77:	01 d0                	add    %edx,%eax
80107a79:	51                   	push   %ecx
80107a7a:	57                   	push   %edi
80107a7b:	50                   	push   %eax
80107a7c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107a7f:	e8 9c d3 ff ff       	call   80104e20 <memmove>
    len -= n;
    buf += n;
80107a84:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a87:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107a8a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107a90:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a92:	29 cb                	sub    %ecx,%ebx
80107a94:	74 32                	je     80107ac8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107a96:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a98:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107a9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107a9e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107aa4:	56                   	push   %esi
80107aa5:	ff 75 08             	pushl  0x8(%ebp)
80107aa8:	e8 53 ff ff ff       	call   80107a00 <uva2ka>
    if(pa0 == 0)
80107aad:	83 c4 10             	add    $0x10,%esp
80107ab0:	85 c0                	test   %eax,%eax
80107ab2:	75 ac                	jne    80107a60 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107abc:	5b                   	pop    %ebx
80107abd:	5e                   	pop    %esi
80107abe:	5f                   	pop    %edi
80107abf:	5d                   	pop    %ebp
80107ac0:	c3                   	ret    
80107ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107acb:	31 c0                	xor    %eax,%eax
}
80107acd:	5b                   	pop    %ebx
80107ace:	5e                   	pop    %esi
80107acf:	5f                   	pop    %edi
80107ad0:	5d                   	pop    %ebp
80107ad1:	c3                   	ret    
