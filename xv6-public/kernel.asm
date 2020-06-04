
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
8010004c:	68 c0 7a 10 80       	push   $0x80107ac0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 95 4a 00 00       	call   80104af0 <initlock>

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
80100092:	68 c7 7a 10 80       	push   $0x80107ac7
80100097:	50                   	push   %eax
80100098:	e8 23 49 00 00       	call   801049c0 <initsleeplock>
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
801000e4:	e8 67 4b 00 00       	call   80104c50 <acquire>

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
80100162:	e8 99 4b 00 00       	call   80104d00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 48 00 00       	call   80104a00 <acquiresleep>
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
80100193:	68 ce 7a 10 80       	push   $0x80107ace
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
801001ae:	e8 ed 48 00 00       	call   80104aa0 <holdingsleep>
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
801001cc:	68 df 7a 10 80       	push   $0x80107adf
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
801001ef:	e8 ac 48 00 00       	call   80104aa0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 48 00 00       	call   80104a60 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 4a 00 00       	call   80104c50 <acquire>
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
8010025c:	e9 9f 4a 00 00       	jmp    80104d00 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 7a 10 80       	push   $0x80107ae6
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
8010028c:	e8 bf 49 00 00       	call   80104c50 <acquire>
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
801002bd:	e8 8e 43 00 00       	call   80104650 <sleep>

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
801002d2:	e8 19 39 00 00       	call   80103bf0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 15 4a 00 00       	call   80104d00 <release>
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
80100346:	e8 b5 49 00 00       	call   80104d00 <release>
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
80100392:	68 ed 7a 10 80       	push   $0x80107aed
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
801003b8:	e8 53 47 00 00       	call   80104b10 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 01 7b 10 80       	push   $0x80107b01
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
8010041a:	e8 41 62 00 00       	call   80106660 <uartputc>
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
801004d3:	e8 88 61 00 00       	call   80106660 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 7c 61 00 00       	call   80106660 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 70 61 00 00       	call   80106660 <uartputc>
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
80100514:	e8 e7 48 00 00       	call   80104e00 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 22 48 00 00       	call   80104d50 <memset>
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
80100540:	68 05 7b 10 80       	push   $0x80107b05
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
801005b1:	0f b6 92 30 7b 10 80 	movzbl -0x7fef84d0(%edx),%edx
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
8010061b:	e8 30 46 00 00       	call   80104c50 <acquire>
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
80100647:	e8 b4 46 00 00       	call   80104d00 <release>
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
8010070d:	e8 ee 45 00 00       	call   80104d00 <release>
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
80100788:	b8 18 7b 10 80       	mov    $0x80107b18,%eax
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
801007c8:	e8 83 44 00 00       	call   80104c50 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 1f 7b 10 80       	push   $0x80107b1f
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
80100803:	e8 48 44 00 00       	call   80104c50 <acquire>
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
80100868:	e8 93 44 00 00       	call   80104d00 <release>
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
801008f6:	e8 15 3f 00 00       	call   80104810 <wakeup>
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
80100977:	e9 84 3f 00 00       	jmp    80104900 <procdump>
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
801009a6:	68 28 7b 10 80       	push   $0x80107b28
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 3b 41 00 00       	call   80104af0 <initlock>

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
801009fc:	e8 ef 31 00 00       	call   80103bf0 <myproc>
80100a01:	89 c6                	mov    %eax,%esi

  //cprintf("%s , %s \n",path,*argv);

  //for shard memory
  curproc->shared_memory_address = kalloc();
80100a03:	e8 a8 1e 00 00       	call   801028b0 <kalloc>
80100a08:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)

  begin_op();
80100a0e:	e8 5d 25 00 00       	call   80102f70 <begin_op>

  if((ip = namei(path)) == 0){
80100a13:	83 ec 0c             	sub    $0xc,%esp
80100a16:	ff 75 08             	pushl  0x8(%ebp)
80100a19:	e8 c2 18 00 00       	call   801022e0 <namei>
80100a1e:	83 c4 10             	add    $0x10,%esp
80100a21:	85 c0                	test   %eax,%eax
80100a23:	0f 84 af 01 00 00    	je     80100bd8 <exec+0x1e8>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a29:	83 ec 0c             	sub    $0xc,%esp
80100a2c:	89 c3                	mov    %eax,%ebx
80100a2e:	50                   	push   %eax
80100a2f:	e8 5c 10 00 00       	call   80101a90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a34:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a3a:	6a 34                	push   $0x34
80100a3c:	6a 00                	push   $0x0
80100a3e:	50                   	push   %eax
80100a3f:	53                   	push   %ebx
80100a40:	e8 2b 13 00 00       	call   80101d70 <readi>
80100a45:	83 c4 20             	add    $0x20,%esp
80100a48:	83 f8 34             	cmp    $0x34,%eax
80100a4b:	74 23                	je     80100a70 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a4d:	83 ec 0c             	sub    $0xc,%esp
80100a50:	53                   	push   %ebx
80100a51:	e8 ca 12 00 00       	call   80101d20 <iunlockput>
    end_op();
80100a56:	e8 85 25 00 00       	call   80102fe0 <end_op>
80100a5b:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a66:	5b                   	pop    %ebx
80100a67:	5e                   	pop    %esi
80100a68:	5f                   	pop    %edi
80100a69:	5d                   	pop    %ebp
80100a6a:	c3                   	ret    
80100a6b:	90                   	nop
80100a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a70:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a77:	45 4c 46 
80100a7a:	75 d1                	jne    80100a4d <exec+0x5d>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a7c:	e8 8f 6d 00 00       	call   80107810 <setupkvm>
80100a81:	85 c0                	test   %eax,%eax
80100a83:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a89:	74 c2                	je     80100a4d <exec+0x5d>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a8b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a92:	00 
80100a93:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100a99:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100aa0:	00 00 00 
80100aa3:	0f 84 d3 00 00 00    	je     80100b7c <exec+0x18c>
80100aa9:	31 c0                	xor    %eax,%eax
80100aab:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100ab1:	89 c6                	mov    %eax,%esi
80100ab3:	eb 18                	jmp    80100acd <exec+0xdd>
80100ab5:	8d 76 00             	lea    0x0(%esi),%esi
80100ab8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100abf:	83 c6 01             	add    $0x1,%esi
80100ac2:	83 c7 20             	add    $0x20,%edi
80100ac5:	39 f0                	cmp    %esi,%eax
80100ac7:	0f 8e a9 00 00 00    	jle    80100b76 <exec+0x186>
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
80100b14:	e8 47 6b 00 00       	call   80107660 <allocuvm>
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
80100b4a:	e8 51 6a 00 00       	call   801075a0 <loaduvm>
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
80100b69:	e8 22 6c 00 00       	call   80107790 <freevm>
80100b6e:	83 c4 10             	add    $0x10,%esp
80100b71:	e9 d7 fe ff ff       	jmp    80100a4d <exec+0x5d>
80100b76:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	53                   	push   %ebx
80100b80:	e8 9b 11 00 00       	call   80101d20 <iunlockput>
  end_op();
80100b85:	e8 56 24 00 00       	call   80102fe0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b8a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b90:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b93:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9d:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100ba3:	52                   	push   %edx
80100ba4:	50                   	push   %eax
80100ba5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bab:	e8 b0 6a 00 00       	call   80107660 <allocuvm>
80100bb0:	83 c4 10             	add    $0x10,%esp
80100bb3:	85 c0                	test   %eax,%eax
80100bb5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bbb:	75 3a                	jne    80100bf7 <exec+0x207>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bbd:	83 ec 0c             	sub    $0xc,%esp
80100bc0:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bc6:	e8 c5 6b 00 00       	call   80107790 <freevm>
80100bcb:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd3:	e9 8b fe ff ff       	jmp    80100a63 <exec+0x73>
  curproc->shared_memory_address = kalloc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bd8:	e8 03 24 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100bdd:	83 ec 0c             	sub    $0xc,%esp
80100be0:	68 41 7b 10 80       	push   $0x80107b41
80100be5:	e8 76 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bea:	83 c4 10             	add    $0x10,%esp
80100bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bf2:	e9 6c fe ff ff       	jmp    80100a63 <exec+0x73>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf7:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100bfd:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c00:	31 ff                	xor    %edi,%edi
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c02:	89 d8                	mov    %ebx,%eax
80100c04:	2d 00 20 00 00       	sub    $0x2000,%eax
80100c09:	50                   	push   %eax
80100c0a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c10:	e8 9b 6c 00 00       	call   801078b0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c15:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c18:	83 c4 10             	add    $0x10,%esp
80100c1b:	8b 00                	mov    (%eax),%eax
80100c1d:	85 c0                	test   %eax,%eax
80100c1f:	0f 84 56 01 00 00    	je     80100d7b <exec+0x38b>
80100c25:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c2b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c31:	eb 0a                	jmp    80100c3d <exec+0x24d>
80100c33:	90                   	nop
80100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  //cprintf("%s \n",argv[argc]);
    if(argc >= MAXARG)
80100c38:	83 ff 20             	cmp    $0x20,%edi
80100c3b:	74 80                	je     80100bbd <exec+0x1cd>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3d:	83 ec 0c             	sub    $0xc,%esp
80100c40:	50                   	push   %eax
80100c41:	e8 4a 43 00 00       	call   80104f90 <strlen>
80100c46:	f7 d0                	not    %eax
80100c48:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4d:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  //cprintf("%s \n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c4e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c51:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c54:	e8 37 43 00 00       	call   80104f90 <strlen>
80100c59:	83 c0 01             	add    $0x1,%eax
80100c5c:	50                   	push   %eax
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c63:	53                   	push   %ebx
80100c64:	56                   	push   %esi
80100c65:	e8 b6 6d 00 00       	call   80107a20 <copyout>
80100c6a:	83 c4 20             	add    $0x20,%esp
80100c6d:	85 c0                	test   %eax,%eax
80100c6f:	0f 88 48 ff ff ff    	js     80100bbd <exec+0x1cd>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c75:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c78:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c7f:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c82:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c8b:	85 c0                	test   %eax,%eax
80100c8d:	75 a9                	jne    80100c38 <exec+0x248>
80100c8f:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c95:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c9c:	89 da                	mov    %ebx,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c9e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100ca5:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ca9:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cb0:	ff ff ff 
  ustack[1] = argc;
80100cb3:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb9:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100cbb:	83 c0 0c             	add    $0xc,%eax
80100cbe:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc0:	50                   	push   %eax
80100cc1:	51                   	push   %ecx
80100cc2:	53                   	push   %ebx
80100cc3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc9:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ccf:	e8 4c 6d 00 00       	call   80107a20 <copyout>
80100cd4:	83 c4 10             	add    $0x10,%esp
80100cd7:	85 c0                	test   %eax,%eax
80100cd9:	0f 88 de fe ff ff    	js     80100bbd <exec+0x1cd>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80100ce2:	0f b6 10             	movzbl (%eax),%edx
80100ce5:	84 d2                	test   %dl,%dl
80100ce7:	74 19                	je     80100d02 <exec+0x312>
80100ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cec:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cef:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cf2:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cf5:	0f 44 c8             	cmove  %eax,%ecx
80100cf8:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cfb:	84 d2                	test   %dl,%dl
80100cfd:	75 f0                	jne    80100cef <exec+0x2ff>
80100cff:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d02:	50                   	push   %eax
80100d03:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d06:	6a 10                	push   $0x10
80100d08:	ff 75 08             	pushl  0x8(%ebp)
80100d0b:	50                   	push   %eax
80100d0c:	e8 3f 42 00 00       	call   80104f50 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d11:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d14:	8b 56 18             	mov    0x18(%esi),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d17:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80100d1d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d23:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100d26:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d2c:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100d2e:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d34:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100d37:	8b 56 18             	mov    0x18(%esi),%edx
80100d3a:	89 5a 44             	mov    %ebx,0x44(%edx)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
80100d3d:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80100d44:	00 00 00 
  curproc->limit_sz = 0;
80100d47:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
80100d4e:	00 00 00 
  curproc->custom_stack_size = 1;
80100d51:	c7 86 8c 00 00 00 01 	movl   $0x1,0x8c(%esi)
80100d58:	00 00 00 


  switchuvm(curproc);
80100d5b:	89 34 24             	mov    %esi,(%esp)
80100d5e:	e8 ad 66 00 00       	call   80107410 <switchuvm>
  freevm(oldpgdir);
80100d63:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d69:	89 04 24             	mov    %eax,(%esp)
80100d6c:	e8 1f 6a 00 00       	call   80107790 <freevm>
  return 0;
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	31 c0                	xor    %eax,%eax
80100d76:	e9 e8 fc ff ff       	jmp    80100a63 <exec+0x73>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d7b:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100d81:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d87:	e9 09 ff ff ff       	jmp    80100c95 <exec+0x2a5>
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d90 <exec2>:
}


int
exec2(char *path, char **argv, int stacksize)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	57                   	push   %edi
80100d94:	56                   	push   %esi
80100d95:	53                   	push   %ebx
80100d96:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100d9c:	e8 4f 2e 00 00       	call   80103bf0 <myproc>
80100da1:	89 c6                	mov    %eax,%esi

  //for shard memory
  curproc->shared_memory_address = kalloc();
80100da3:	e8 08 1b 00 00       	call   801028b0 <kalloc>

  //cprintf("%s , %s, %d\n",path,*argv,stacksize);
  //cprintf("exec : %d\n",stacksize);

  //admin mode가 아닐때
  if (curproc->admin_mode==0){
80100da8:	8b 8e 88 00 00 00    	mov    0x88(%esi),%ecx
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();

  //for shard memory
  curproc->shared_memory_address = kalloc();
80100dae:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)

  //cprintf("%s , %s, %d\n",path,*argv,stacksize);
  //cprintf("exec : %d\n",stacksize);

  //admin mode가 아닐때
  if (curproc->admin_mode==0){
80100db4:	85 c9                	test   %ecx,%ecx
80100db6:	0f 84 c3 00 00 00    	je     80100e7f <exec2+0xef>
    return -1;
  }

  begin_op();
80100dbc:	e8 af 21 00 00       	call   80102f70 <begin_op>

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	ff 75 08             	pushl  0x8(%ebp)
80100dc7:	e8 14 15 00 00       	call   801022e0 <namei>
80100dcc:	83 c4 10             	add    $0x10,%esp
80100dcf:	85 c0                	test   %eax,%eax
80100dd1:	89 c3                	mov    %eax,%ebx
80100dd3:	0f 84 c5 01 00 00    	je     80100f9e <exec2+0x20e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100dd9:	83 ec 0c             	sub    $0xc,%esp
80100ddc:	50                   	push   %eax
80100ddd:	e8 ae 0c 00 00       	call   80101a90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100de2:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100de8:	6a 34                	push   $0x34
80100dea:	6a 00                	push   $0x0
80100dec:	50                   	push   %eax
80100ded:	53                   	push   %ebx
80100dee:	e8 7d 0f 00 00       	call   80101d70 <readi>
80100df3:	83 c4 20             	add    $0x20,%esp
80100df6:	83 f8 34             	cmp    $0x34,%eax
80100df9:	0f 84 91 00 00 00    	je     80100e90 <exec2+0x100>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100dff:	83 ec 0c             	sub    $0xc,%esp
80100e02:	53                   	push   %ebx
80100e03:	e8 18 0f 00 00       	call   80101d20 <iunlockput>
    end_op();
80100e08:	e8 d3 21 00 00       	call   80102fe0 <end_op>
80100e0d:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e18:	5b                   	pop    %ebx
80100e19:	5e                   	pop    %esi
80100e1a:	5f                   	pop    %edi
80100e1b:	5d                   	pop    %ebp
80100e1c:	c3                   	ret    
80100e1d:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100e23:	83 ec 0c             	sub    $0xc,%esp
80100e26:	53                   	push   %ebx
80100e27:	e8 f4 0e 00 00       	call   80101d20 <iunlockput>
  end_op();
80100e2c:	e8 af 21 00 00       	call   80102fe0 <end_op>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e31:	8b 4d 10             	mov    0x10(%ebp),%ecx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
80100e34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e3a:	83 c4 0c             	add    $0xc,%esp
80100e3d:	8d 59 01             	lea    0x1(%ecx),%ebx

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
80100e40:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e45:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
80100e4a:	c1 e3 0c             	shl    $0xc,%ebx
80100e4d:	8d 14 18             	lea    (%eax,%ebx,1),%edx
80100e50:	52                   	push   %edx
80100e51:	50                   	push   %eax
80100e52:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e58:	e8 03 68 00 00       	call   80107660 <allocuvm>
80100e5d:	83 c4 10             	add    $0x10,%esp
80100e60:	85 c0                	test   %eax,%eax
80100e62:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e68:	0f 85 4a 01 00 00    	jne    80100fb8 <exec2+0x228>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100e6e:	83 ec 0c             	sub    $0xc,%esp
80100e71:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e77:	e8 14 69 00 00       	call   80107790 <freevm>
80100e7c:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
80100e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
80100e87:	5b                   	pop    %ebx
80100e88:	5e                   	pop    %esi
80100e89:	5f                   	pop    %edi
80100e8a:	5d                   	pop    %ebp
80100e8b:	c3                   	ret    
80100e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100e90:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e97:	45 4c 46 
80100e9a:	0f 85 5f ff ff ff    	jne    80100dff <exec2+0x6f>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100ea0:	e8 6b 69 00 00       	call   80107810 <setupkvm>
80100ea5:	85 c0                	test   %eax,%eax
80100ea7:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ead:	0f 84 4c ff ff ff    	je     80100dff <exec2+0x6f>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100eb3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100eba:	00 
80100ebb:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100ec1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ec8:	00 00 00 
80100ecb:	0f 84 52 ff ff ff    	je     80100e23 <exec2+0x93>
80100ed1:	31 c0                	xor    %eax,%eax
80100ed3:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100ed9:	89 c6                	mov    %eax,%esi
80100edb:	eb 18                	jmp    80100ef5 <exec2+0x165>
80100edd:	8d 76 00             	lea    0x0(%esi),%esi
80100ee0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ee7:	83 c6 01             	add    $0x1,%esi
80100eea:	83 c7 20             	add    $0x20,%edi
80100eed:	39 f0                	cmp    %esi,%eax
80100eef:	0f 8e 28 ff ff ff    	jle    80100e1d <exec2+0x8d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ef5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100efb:	6a 20                	push   $0x20
80100efd:	57                   	push   %edi
80100efe:	50                   	push   %eax
80100eff:	53                   	push   %ebx
80100f00:	e8 6b 0e 00 00       	call   80101d70 <readi>
80100f05:	83 c4 10             	add    $0x10,%esp
80100f08:	83 f8 20             	cmp    $0x20,%eax
80100f0b:	75 7b                	jne    80100f88 <exec2+0x1f8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100f0d:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100f14:	75 ca                	jne    80100ee0 <exec2+0x150>
      continue;
    if(ph.memsz < ph.filesz)
80100f16:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100f1c:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100f22:	72 64                	jb     80100f88 <exec2+0x1f8>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100f24:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100f2a:	72 5c                	jb     80100f88 <exec2+0x1f8>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100f2c:	83 ec 04             	sub    $0x4,%esp
80100f2f:	50                   	push   %eax
80100f30:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100f36:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f3c:	e8 1f 67 00 00       	call   80107660 <allocuvm>
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	85 c0                	test   %eax,%eax
80100f46:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f4c:	74 3a                	je     80100f88 <exec2+0x1f8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100f4e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100f54:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100f59:	75 2d                	jne    80100f88 <exec2+0x1f8>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100f5b:	83 ec 0c             	sub    $0xc,%esp
80100f5e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100f64:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100f6a:	53                   	push   %ebx
80100f6b:	50                   	push   %eax
80100f6c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f72:	e8 29 66 00 00       	call   801075a0 <loaduvm>
80100f77:	83 c4 20             	add    $0x20,%esp
80100f7a:	85 c0                	test   %eax,%eax
80100f7c:	0f 89 5e ff ff ff    	jns    80100ee0 <exec2+0x150>
80100f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f91:	e8 fa 67 00 00       	call   80107790 <freevm>
80100f96:	83 c4 10             	add    $0x10,%esp
80100f99:	e9 61 fe ff ff       	jmp    80100dff <exec2+0x6f>
  begin_op();

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
80100f9e:	e8 3d 20 00 00       	call   80102fe0 <end_op>
    cprintf("exec: fail\n");
80100fa3:	83 ec 0c             	sub    $0xc,%esp
80100fa6:	68 41 7b 10 80       	push   $0x80107b41
80100fab:	e8 b0 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100fb0:	83 c4 10             	add    $0x10,%esp
80100fb3:	e9 c7 fe ff ff       	jmp    80100e7f <exec2+0xef>

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
80100fb8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100fbe:	83 ec 08             	sub    $0x8,%esp
80100fc1:	29 d8                	sub    %ebx,%eax
80100fc3:	50                   	push   %eax
80100fc4:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fca:	e8 e1 68 00 00       	call   801078b0 <clearpteu>
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fd2:	83 c4 10             	add    $0x10,%esp
80100fd5:	8b 00                	mov    (%eax),%eax
80100fd7:	85 c0                	test   %eax,%eax
80100fd9:	0f 84 8d 01 00 00    	je     8010116c <exec2+0x3dc>
	  cprintf("%s\n",argv[argc]);
80100fdf:	83 ec 08             	sub    $0x8,%esp
80100fe2:	31 ff                	xor    %edi,%edi
80100fe4:	50                   	push   %eax
80100fe5:	68 4d 7b 10 80       	push   $0x80107b4d
80100fea:	e8 71 f6 ff ff       	call   80100660 <cprintf>
80100fef:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100ff5:	83 c4 10             	add    $0x10,%esp
80100ff8:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100ffe:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101004:	eb 24                	jmp    8010102a <exec2+0x29a>
80101006:	8d 76 00             	lea    0x0(%esi),%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101010:	83 ec 08             	sub    $0x8,%esp
80101013:	50                   	push   %eax
80101014:	68 4d 7b 10 80       	push   $0x80107b4d
80101019:	e8 42 f6 ff ff       	call   80100660 <cprintf>
    if(argc >= MAXARG)
8010101e:	83 c4 10             	add    $0x10,%esp
80101021:	83 ff 20             	cmp    $0x20,%edi
80101024:	0f 84 44 fe ff ff    	je     80100e6e <exec2+0xde>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010102a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	ff 34 b8             	pushl  (%eax,%edi,4)
80101033:	e8 58 3f 00 00       	call   80104f90 <strlen>
80101038:	f7 d0                	not    %eax
8010103a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010103c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010103f:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  cprintf("%s\n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101040:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101043:	ff 34 b8             	pushl  (%eax,%edi,4)
80101046:	e8 45 3f 00 00       	call   80104f90 <strlen>
8010104b:	83 c0 01             	add    $0x1,%eax
8010104e:	50                   	push   %eax
8010104f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101052:	ff 34 b8             	pushl  (%eax,%edi,4)
80101055:	53                   	push   %ebx
80101056:	56                   	push   %esi
80101057:	e8 c4 69 00 00       	call   80107a20 <copyout>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	85 c0                	test   %eax,%eax
80101061:	0f 88 07 fe ff ff    	js     80100e6e <exec2+0xde>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101067:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
8010106a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101071:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80101074:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010107a:	8b 04 b8             	mov    (%eax,%edi,4),%eax
8010107d:	85 c0                	test   %eax,%eax
8010107f:	75 8f                	jne    80101010 <exec2+0x280>
80101081:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101087:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
8010108e:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80101090:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101097:	00 00 00 00 

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
8010109b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801010a2:	ff ff ff 
  ustack[1] = argc;
801010a5:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010ab:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
801010ad:	83 c0 0c             	add    $0xc,%eax
801010b0:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010b2:	50                   	push   %eax
801010b3:	52                   	push   %edx
801010b4:	53                   	push   %ebx
801010b5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010bb:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010c1:	e8 5a 69 00 00       	call   80107a20 <copyout>
801010c6:	83 c4 10             	add    $0x10,%esp
801010c9:	85 c0                	test   %eax,%eax
801010cb:	0f 88 9d fd ff ff    	js     80100e6e <exec2+0xde>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010d1:	8b 45 08             	mov    0x8(%ebp),%eax
801010d4:	0f b6 10             	movzbl (%eax),%edx
801010d7:	84 d2                	test   %dl,%dl
801010d9:	74 19                	je     801010f4 <exec2+0x364>
801010db:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
801010de:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010e1:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
801010e4:	89 c1                	mov    %eax,%ecx
801010e6:	0f 45 4d 08          	cmovne 0x8(%ebp),%ecx
801010ea:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010ed:	84 d2                	test   %dl,%dl
    if(*s == '/')
      last = s+1;
801010ef:	89 4d 08             	mov    %ecx,0x8(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010f2:	75 ea                	jne    801010de <exec2+0x34e>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010f4:	50                   	push   %eax
801010f5:	8d 46 6c             	lea    0x6c(%esi),%eax
801010f8:	6a 10                	push   $0x10
801010fa:	ff 75 08             	pushl  0x8(%ebp)
801010fd:	50                   	push   %eax
801010fe:	e8 4d 3e 00 00       	call   80104f50 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80101103:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80101109:	8b 7e 04             	mov    0x4(%esi),%edi
  curproc->pgdir = pgdir;
8010110c:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
8010110f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80101115:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80101117:	8b 46 18             	mov    0x18(%esi),%eax
8010111a:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101120:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101123:	8b 46 18             	mov    0x18(%esi),%eax
80101126:	89 58 44             	mov    %ebx,0x44(%eax)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
  curproc->limit_sz = 0;
  curproc->custom_stack_size = stacksize;
80101129:	8b 45 10             	mov    0x10(%ebp),%eax
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
8010112c:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101133:	00 00 00 
  curproc->limit_sz = 0;
80101136:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
8010113d:	00 00 00 
  curproc->custom_stack_size = stacksize;
80101140:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)

  cprintf("initailizing done\n");
80101146:	c7 04 24 51 7b 10 80 	movl   $0x80107b51,(%esp)
8010114d:	e8 0e f5 ff ff       	call   80100660 <cprintf>

  switchuvm(curproc);
80101152:	89 34 24             	mov    %esi,(%esp)
80101155:	e8 b6 62 00 00       	call   80107410 <switchuvm>
  freevm(oldpgdir);
8010115a:	89 3c 24             	mov    %edi,(%esp)
8010115d:	e8 2e 66 00 00       	call   80107790 <freevm>
  return 0;
80101162:	83 c4 10             	add    $0x10,%esp
80101165:	31 c0                	xor    %eax,%eax
80101167:	e9 a9 fc ff ff       	jmp    80100e15 <exec2+0x85>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010116c:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80101172:	31 ff                	xor    %edi,%edi
80101174:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
8010117a:	e9 08 ff ff ff       	jmp    80101087 <exec2+0x2f7>
8010117f:	90                   	nop

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
80101186:	68 64 7b 10 80       	push   $0x80107b64
8010118b:	68 c0 0f 11 80       	push   $0x80110fc0
80101190:	e8 5b 39 00 00       	call   80104af0 <initlock>
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
801011b1:	e8 9a 3a 00 00       	call   80104c50 <acquire>
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
801011e1:	e8 1a 3b 00 00       	call   80104d00 <release>
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
801011f8:	e8 03 3b 00 00       	call   80104d00 <release>
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
8010121f:	e8 2c 3a 00 00       	call   80104c50 <acquire>
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
8010123c:	e8 bf 3a 00 00       	call   80104d00 <release>
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
8010124b:	68 6b 7b 10 80       	push   $0x80107b6b
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
80101271:	e8 da 39 00 00       	call   80104c50 <acquire>
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
8010129c:	e9 5f 3a 00 00       	jmp    80104d00 <release>
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
801012c8:	e8 33 3a 00 00       	call   80104d00 <release>

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
80101322:	68 73 7b 10 80       	push   $0x80107b73
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
80101402:	68 7d 7b 10 80       	push   $0x80107b7d
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
80101514:	68 86 7b 10 80       	push   $0x80107b86
80101519:	e8 52 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010151e:	83 ec 0c             	sub    $0xc,%esp
80101521:	68 8c 7b 10 80       	push   $0x80107b8c
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
80101595:	68 96 7b 10 80       	push   $0x80107b96
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
80101642:	68 a9 7b 10 80       	push   $0x80107ba9
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
80101685:	e8 c6 36 00 00       	call   80104d50 <memset>
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
801016ca:	e8 81 35 00 00       	call   80104c50 <acquire>
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
80101712:	e8 e9 35 00 00       	call   80104d00 <release>
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
8010175f:	e8 9c 35 00 00       	call   80104d00 <release>

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
80101774:	68 bf 7b 10 80       	push   $0x80107bbf
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
8010183a:	68 cf 7b 10 80       	push   $0x80107bcf
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
80101871:	e8 8a 35 00 00       	call   80104e00 <memmove>
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
8010189c:	68 e2 7b 10 80       	push   $0x80107be2
801018a1:	68 e0 19 11 80       	push   $0x801119e0
801018a6:	e8 45 32 00 00       	call   80104af0 <initlock>
801018ab:	83 c4 10             	add    $0x10,%esp
801018ae:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	68 e9 7b 10 80       	push   $0x80107be9
801018b8:	53                   	push   %ebx
801018b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018bf:	e8 fc 30 00 00       	call   801049c0 <initsleeplock>
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
80101909:	68 4c 7c 10 80       	push   $0x80107c4c
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
8010199e:	e8 ad 33 00 00       	call   80104d50 <memset>
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
801019d3:	68 ef 7b 10 80       	push   $0x80107bef
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
80101a41:	e8 ba 33 00 00       	call   80104e00 <memmove>
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
80101a6f:	e8 dc 31 00 00       	call   80104c50 <acquire>
  ip->ref++;
80101a74:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a78:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a7f:	e8 7c 32 00 00       	call   80104d00 <release>
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
80101ab2:	e8 49 2f 00 00       	call   80104a00 <acquiresleep>

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
80101b28:	e8 d3 32 00 00       	call   80104e00 <memmove>
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
80101b4d:	68 07 7c 10 80       	push   $0x80107c07
80101b52:	e8 19 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101b57:	83 ec 0c             	sub    $0xc,%esp
80101b5a:	68 01 7c 10 80       	push   $0x80107c01
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
80101b83:	e8 18 2f 00 00       	call   80104aa0 <holdingsleep>
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
80101b9f:	e9 bc 2e 00 00       	jmp    80104a60 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	68 16 7c 10 80       	push   $0x80107c16
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
80101bd0:	e8 2b 2e 00 00       	call   80104a00 <acquiresleep>
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
80101bea:	e8 71 2e 00 00       	call   80104a60 <releasesleep>

  acquire(&icache.lock);
80101bef:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bf6:	e8 55 30 00 00       	call   80104c50 <acquire>
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
80101c10:	e9 eb 30 00 00       	jmp    80104d00 <release>
80101c15:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101c18:	83 ec 0c             	sub    $0xc,%esp
80101c1b:	68 e0 19 11 80       	push   $0x801119e0
80101c20:	e8 2b 30 00 00       	call   80104c50 <acquire>
    int r = ip->ref;
80101c25:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101c28:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c2f:	e8 cc 30 00 00       	call   80104d00 <release>
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
80101e18:	e8 e3 2f 00 00       	call   80104e00 <memmove>
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
80101f14:	e8 e7 2e 00 00       	call   80104e00 <memmove>
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
80101fae:	e8 cd 2e 00 00       	call   80104e80 <strncmp>
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
80102015:	e8 66 2e 00 00       	call   80104e80 <strncmp>
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
8010204d:	68 30 7c 10 80       	push   $0x80107c30
80102052:	e8 19 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80102057:	83 ec 0c             	sub    $0xc,%esp
8010205a:	68 1e 7c 10 80       	push   $0x80107c1e
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
80102089:	e8 62 1b 00 00       	call   80103bf0 <myproc>
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
80102099:	e8 b2 2b 00 00       	call   80104c50 <acquire>
  ip->ref++;
8010209e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801020a2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801020a9:	e8 52 2c 00 00       	call   80104d00 <release>
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
80102105:	e8 f6 2c 00 00       	call   80104e00 <memmove>
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
80102194:	e8 67 2c 00 00       	call   80104e00 <memmove>
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
8010227d:	e8 6e 2c 00 00       	call   80104ef0 <strncpy>
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
801022bb:	68 3f 7c 10 80       	push   $0x80107c3f
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
801023d0:	68 a8 7c 10 80       	push   $0x80107ca8
801023d5:	e8 96 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801023da:	83 ec 0c             	sub    $0xc,%esp
801023dd:	68 9f 7c 10 80       	push   $0x80107c9f
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
801023f6:	68 ba 7c 10 80       	push   $0x80107cba
801023fb:	68 80 b5 10 80       	push   $0x8010b580
80102400:	e8 eb 26 00 00       	call   80104af0 <initlock>
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
8010247e:	e8 cd 27 00 00       	call   80104c50 <acquire>

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
801024ae:	e8 5d 23 00 00       	call   80104810 <wakeup>

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
801024cc:	e8 2f 28 00 00       	call   80104d00 <release>
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
8010251e:	e8 7d 25 00 00       	call   80104aa0 <holdingsleep>
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
80102558:	e8 f3 26 00 00       	call   80104c50 <acquire>

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
801025a9:	e8 a2 20 00 00       	call   80104650 <sleep>
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
801025c6:	e9 35 27 00 00       	jmp    80104d00 <release>

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
801025de:	68 be 7c 10 80       	push   $0x80107cbe
801025e3:	e8 88 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 e9 7c 10 80       	push   $0x80107ce9
801025f0:	e8 7b dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025f5:	83 ec 0c             	sub    $0xc,%esp
801025f8:	68 d4 7c 10 80       	push   $0x80107cd4
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
8010265a:	68 08 7d 10 80       	push   $0x80107d08
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
80102732:	e8 19 26 00 00       	call   80104d50 <memset>

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
8010276b:	e9 90 25 00 00       	jmp    80104d00 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	68 40 36 11 80       	push   $0x80113640
80102778:	e8 d3 24 00 00       	call   80104c50 <acquire>
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	eb c2                	jmp    80102744 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102782:	83 ec 0c             	sub    $0xc,%esp
80102785:	68 3a 7d 10 80       	push   $0x80107d3a
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
801027eb:	68 40 7d 10 80       	push   $0x80107d40
801027f0:	68 40 36 11 80       	push   $0x80113640
801027f5:	e8 f6 22 00 00       	call   80104af0 <initlock>

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
801028de:	e8 1d 24 00 00       	call   80104d00 <release>
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
801028f8:	e8 53 23 00 00       	call   80104c50 <acquire>
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
80102d04:	e8 97 20 00 00       	call   80104da0 <memcmp>
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
80102e34:	e8 c7 1f 00 00       	call   80104e00 <memmove>
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
80102ee4:	e8 07 1c 00 00       	call   80104af0 <initlock>
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
80102f7b:	e8 d0 1c 00 00       	call   80104c50 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 80 36 11 80       	push   $0x80113680
80102f90:	68 80 36 11 80       	push   $0x80113680
80102f95:	e8 b6 16 00 00       	call   80104650 <sleep>
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
80102fcc:	e8 2f 1d 00 00       	call   80104d00 <release>
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
80102fee:	e8 5d 1c 00 00       	call   80104c50 <acquire>
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
8010302d:	e8 ce 1c 00 00       	call   80104d00 <release>
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
8010308c:	e8 6f 1d 00 00       	call   80104e00 <memmove>
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
801030d5:	e8 76 1b 00 00       	call   80104c50 <acquire>
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
801030eb:	e8 20 17 00 00       	call   80104810 <wakeup>
    release(&log.lock);
801030f0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030f7:	e8 04 1c 00 00       	call   80104d00 <release>
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
80103118:	e8 f3 16 00 00       	call   80104810 <wakeup>
  }
  release(&log.lock);
8010311d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103124:	e8 d7 1b 00 00       	call   80104d00 <release>
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
8010318e:	e8 bd 1a 00 00       	call   80104c50 <acquire>
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
801031de:	e9 1d 1b 00 00       	jmp    80104d00 <release>
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
80103227:	e8 a4 09 00 00       	call   80103bd0 <cpuid>
8010322c:	89 c3                	mov    %eax,%ebx
8010322e:	e8 9d 09 00 00       	call   80103bd0 <cpuid>
80103233:	83 ec 04             	sub    $0x4,%esp
80103236:	53                   	push   %ebx
80103237:	50                   	push   %eax
80103238:	68 c4 7f 10 80       	push   $0x80107fc4
8010323d:	e8 1e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103242:	e8 69 30 00 00       	call   801062b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103247:	e8 04 09 00 00       	call   80103b50 <mycpu>
8010324c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010324e:	b8 01 00 00 00       	mov    $0x1,%eax
80103253:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010325a:	e8 f1 0c 00 00       	call   80103f50 <scheduler>
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
80103266:	e8 85 41 00 00       	call   801073f0 <switchkvm>
  seginit();
8010326b:	e8 b0 3e 00 00       	call   80107120 <seginit>
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
801032a6:	e8 e5 45 00 00       	call   80107890 <kvmalloc>
  mpinit();        // detect other processors
801032ab:	e8 70 01 00 00       	call   80103420 <mpinit>
  lapicinit();     // interrupt controller
801032b0:	e8 5b f7 ff ff       	call   80102a10 <lapicinit>
  seginit();       // segment descriptors
801032b5:	e8 66 3e 00 00       	call   80107120 <seginit>
  picinit();       // disable pic
801032ba:	e8 31 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
801032bf:	e8 4c f3 ff ff       	call   80102610 <ioapicinit>
  consoleinit();   // console hardware
801032c4:	e8 d7 d6 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
801032c9:	e8 d2 32 00 00       	call   801065a0 <uartinit>
  pinit();         // process table
801032ce:	e8 5d 08 00 00       	call   80103b30 <pinit>
  tvinit();        // trap vectors
801032d3:	e8 38 2f 00 00       	call   80106210 <tvinit>
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
801032f9:	e8 02 1b 00 00       	call   80104e00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032fe:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103305:	00 00 00 
80103308:	83 c4 10             	add    $0x10,%esp
8010330b:	05 80 37 11 80       	add    $0x80113780,%eax
80103310:	39 d8                	cmp    %ebx,%eax
80103312:	76 6f                	jbe    80103383 <main+0x103>
80103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103318:	e8 33 08 00 00       	call   80103b50 <mycpu>
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
80103395:	e8 86 08 00 00       	call   80103c20 <userinit>
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
801033ce:	e8 cd 19 00 00       	call   80104da0 <memcmp>
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
80103492:	e8 09 19 00 00       	call   80104da0 <memcmp>
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
80103689:	e8 62 14 00 00       	call   80104af0 <initlock>
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
8010371f:	e8 2c 15 00 00       	call   80104c50 <acquire>
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
8010373f:	e8 cc 10 00 00       	call   80104810 <wakeup>
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
80103764:	e9 97 15 00 00       	jmp    80104d00 <release>
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
80103784:	e8 87 10 00 00       	call   80104810 <wakeup>
80103789:	83 c4 10             	add    $0x10,%esp
8010378c:	eb b9                	jmp    80103747 <pipeclose+0x37>
8010378e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	53                   	push   %ebx
80103794:	e8 67 15 00 00       	call   80104d00 <release>
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
801037bd:	e8 8e 14 00 00       	call   80104c50 <acquire>
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
80103800:	e8 eb 03 00 00       	call   80103bf0 <myproc>
80103805:	8b 48 24             	mov    0x24(%eax),%ecx
80103808:	85 c9                	test   %ecx,%ecx
8010380a:	75 34                	jne    80103840 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010380c:	83 ec 0c             	sub    $0xc,%esp
8010380f:	57                   	push   %edi
80103810:	e8 fb 0f 00 00       	call   80104810 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103815:	58                   	pop    %eax
80103816:	5a                   	pop    %edx
80103817:	53                   	push   %ebx
80103818:	56                   	push   %esi
80103819:	e8 32 0e 00 00       	call   80104650 <sleep>
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
80103844:	e8 b7 14 00 00       	call   80104d00 <release>
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
80103893:	e8 78 0f 00 00       	call   80104810 <wakeup>
  release(&p->lock);
80103898:	89 1c 24             	mov    %ebx,(%esp)
8010389b:	e8 60 14 00 00       	call   80104d00 <release>
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
801038c0:	e8 8b 13 00 00       	call   80104c50 <acquire>
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
801038f5:	e8 56 0d 00 00       	call   80104650 <sleep>
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
80103919:	e8 d2 02 00 00       	call   80103bf0 <myproc>
8010391e:	8b 48 24             	mov    0x24(%eax),%ecx
80103921:	85 c9                	test   %ecx,%ecx
80103923:	74 cb                	je     801038f0 <piperead+0x40>
      release(&p->lock);
80103925:	83 ec 0c             	sub    $0xc,%esp
80103928:	53                   	push   %ebx
80103929:	e8 d2 13 00 00       	call   80104d00 <release>
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
8010398e:	e8 7d 0e 00 00       	call   80104810 <wakeup>
  release(&p->lock);
80103993:	89 1c 24             	mov    %ebx,(%esp)
80103996:	e8 65 13 00 00       	call   80104d00 <release>
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
801039e1:	e8 6a 12 00 00       	call   80104c50 <acquire>
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 17                	jmp    80103a02 <allocproc+0x32>
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801039f6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801039fc:	0f 84 be 00 00 00    	je     80103ac0 <allocproc+0xf0>
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
  p->custom_stack_size = 1;
  //시작시간 
  p->start_time_tick = ticks;
  //////////////////////////////////////////

  release(&ptable.lock);
80103a0e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103a11:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->custom_stack_size = 1;
  //시작시간 
  p->start_time_tick = ticks;
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
  //////////////////////////////////////////

  release(&ptable.lock);
80103a6d:	e8 8e 12 00 00       	call   80104d00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a72:	e8 39 ee ff ff       	call   801028b0 <kalloc>
80103a77:	83 c4 10             	add    $0x10,%esp
80103a7a:	85 c0                	test   %eax,%eax
80103a7c:	89 43 08             	mov    %eax,0x8(%ebx)
80103a7f:	74 56                	je     80103ad7 <allocproc+0x107>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a81:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a87:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103a8a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a8f:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103a92:	c7 40 14 fc 61 10 80 	movl   $0x801061fc,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a99:	6a 14                	push   $0x14
80103a9b:	6a 00                	push   $0x0
80103a9d:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103a9e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103aa1:	e8 aa 12 00 00       	call   80104d50 <memset>
  p->context->eip = (uint)forkret;
80103aa6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103aa9:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103aac:	c7 40 10 e0 3a 10 80 	movl   $0x80103ae0,0x10(%eax)

  return p;
80103ab3:	89 d8                	mov    %ebx,%eax
}
80103ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab8:	c9                   	leave  
80103ab9:	c3                   	ret    
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	68 20 3d 11 80       	push   $0x80113d20
80103ac8:	e8 33 12 00 00       	call   80104d00 <release>
  return 0;
80103acd:	83 c4 10             	add    $0x10,%esp
80103ad0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad5:	c9                   	leave  
80103ad6:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103ad7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ade:	eb d5                	jmp    80103ab5 <allocproc+0xe5>

80103ae0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ae6:	68 20 3d 11 80       	push   $0x80113d20
80103aeb:	e8 10 12 00 00       	call   80104d00 <release>

  if (first) {
80103af0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	85 c0                	test   %eax,%eax
80103afa:	75 04                	jne    80103b00 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103afc:	c9                   	leave  
80103afd:	c3                   	ret    
80103afe:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103b00:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103b03:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b0a:	00 00 00 
    iinit(ROOTDEV);
80103b0d:	6a 01                	push   $0x1
80103b0f:	e8 7c dd ff ff       	call   80101890 <iinit>
    initlog(ROOTDEV);
80103b14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b1b:	e8 b0 f3 ff ff       	call   80102ed0 <initlog>
80103b20:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b23:	c9                   	leave  
80103b24:	c3                   	ret    
80103b25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b30 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b36:	68 35 80 10 80       	push   $0x80108035
80103b3b:	68 20 3d 11 80       	push   $0x80113d20
80103b40:	e8 ab 0f 00 00       	call   80104af0 <initlock>
}
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	c9                   	leave  
80103b49:	c3                   	ret    
80103b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b50 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b55:	9c                   	pushf  
80103b56:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103b57:	f6 c4 02             	test   $0x2,%ah
80103b5a:	75 5b                	jne    80103bb7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103b5c:	e8 af ef ff ff       	call   80102b10 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b61:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103b67:	85 f6                	test   %esi,%esi
80103b69:	7e 3f                	jle    80103baa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b6b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103b72:	39 d0                	cmp    %edx,%eax
80103b74:	74 30                	je     80103ba6 <mycpu+0x56>
80103b76:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103b7b:	31 d2                	xor    %edx,%edx
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b80:	83 c2 01             	add    $0x1,%edx
80103b83:	39 f2                	cmp    %esi,%edx
80103b85:	74 23                	je     80103baa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b87:	0f b6 19             	movzbl (%ecx),%ebx
80103b8a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b90:	39 d8                	cmp    %ebx,%eax
80103b92:	75 ec                	jne    80103b80 <mycpu+0x30>
      return &cpus[i];
80103b94:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b9d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103b9e:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103ba3:	5e                   	pop    %esi
80103ba4:	5d                   	pop    %ebp
80103ba5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ba6:	31 d2                	xor    %edx,%edx
80103ba8:	eb ea                	jmp    80103b94 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 3c 80 10 80       	push   $0x8010803c
80103bb2:	e8 b9 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103bb7:	83 ec 0c             	sub    $0xc,%esp
80103bba:	68 44 81 10 80       	push   $0x80108144
80103bbf:	e8 ac c7 ff ff       	call   80100370 <panic>
80103bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bd0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103bd6:	e8 75 ff ff ff       	call   80103b50 <mycpu>
80103bdb:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103be0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103be1:	c1 f8 04             	sar    $0x4,%eax
80103be4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bea:	c3                   	ret    
80103beb:	90                   	nop
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	53                   	push   %ebx
80103bf4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bf7:	e8 74 0f 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80103bfc:	e8 4f ff ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103c01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c07:	e8 a4 0f 00 00       	call   80104bb0 <popcli>
  return p;
}
80103c0c:	83 c4 04             	add    $0x4,%esp
80103c0f:	89 d8                	mov    %ebx,%eax
80103c11:	5b                   	pop    %ebx
80103c12:	5d                   	pop    %ebp
80103c13:	c3                   	ret    
80103c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c20 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103c27:	e8 a4 fd ff ff       	call   801039d0 <allocproc>
80103c2c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103c2e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103c33:	e8 d8 3b 00 00       	call   80107810 <setupkvm>
80103c38:	85 c0                	test   %eax,%eax
80103c3a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c3d:	0f 84 bd 00 00 00    	je     80103d00 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c43:	83 ec 04             	sub    $0x4,%esp
80103c46:	68 2c 00 00 00       	push   $0x2c
80103c4b:	68 60 b4 10 80       	push   $0x8010b460
80103c50:	50                   	push   %eax
80103c51:	e8 ca 38 00 00       	call   80107520 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103c56:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103c59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c5f:	6a 4c                	push   $0x4c
80103c61:	6a 00                	push   $0x0
80103c63:	ff 73 18             	pushl  0x18(%ebx)
80103c66:	e8 e5 10 00 00       	call   80104d50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c73:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c78:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c86:	8b 43 18             	mov    0x18(%ebx),%eax
80103c89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c91:	8b 43 18             	mov    0x18(%ebx),%eax
80103c94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ca6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103cb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cbd:	6a 10                	push   $0x10
80103cbf:	68 65 80 10 80       	push   $0x80108065
80103cc4:	50                   	push   %eax
80103cc5:	e8 86 12 00 00       	call   80104f50 <safestrcpy>
  p->cwd = namei("/");
80103cca:	c7 04 24 6e 80 10 80 	movl   $0x8010806e,(%esp)
80103cd1:	e8 0a e6 ff ff       	call   801022e0 <namei>
80103cd6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103cd9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ce0:	e8 6b 0f 00 00       	call   80104c50 <acquire>

  p->state = RUNNABLE;
80103ce5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103cec:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cf3:	e8 08 10 00 00       	call   80104d00 <release>
}
80103cf8:	83 c4 10             	add    $0x10,%esp
80103cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cfe:	c9                   	leave  
80103cff:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	68 4c 80 10 80       	push   $0x8010804c
80103d08:	e8 63 c6 ff ff       	call   80100370 <panic>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi

80103d10 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d18:	e8 53 0e 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80103d1d:	e8 2e fe ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103d22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d28:	e8 83 0e 00 00       	call   80104bb0 <popcli>
  struct proc *curproc = myproc();

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
80103d2d:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103d33:	8b 03                	mov    (%ebx),%eax

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
80103d35:	85 d2                	test   %edx,%edx
80103d37:	74 07                	je     80103d40 <growproc+0x30>
80103d39:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80103d3c:	39 d1                	cmp    %edx,%ecx
80103d3e:	77 50                	ja     80103d90 <growproc+0x80>
    return -1;
  }
  if(n > 0){
80103d40:	83 fe 00             	cmp    $0x0,%esi
80103d43:	7e 33                	jle    80103d78 <growproc+0x68>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d45:	83 ec 04             	sub    $0x4,%esp
80103d48:	01 c6                	add    %eax,%esi
80103d4a:	56                   	push   %esi
80103d4b:	50                   	push   %eax
80103d4c:	ff 73 04             	pushl  0x4(%ebx)
80103d4f:	e8 0c 39 00 00       	call   80107660 <allocuvm>
80103d54:	83 c4 10             	add    $0x10,%esp
80103d57:	85 c0                	test   %eax,%eax
80103d59:	74 35                	je     80103d90 <growproc+0x80>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103d5b:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103d5e:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d60:	53                   	push   %ebx
80103d61:	e8 aa 36 00 00       	call   80107410 <switchuvm>
  return 0;
80103d66:	83 c4 10             	add    $0x10,%esp
80103d69:	31 c0                	xor    %eax,%eax
}
80103d6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6e:	5b                   	pop    %ebx
80103d6f:	5e                   	pop    %esi
80103d70:	5d                   	pop    %ebp
80103d71:	c3                   	ret    
80103d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  }
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103d78:	74 e1                	je     80103d5b <growproc+0x4b>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d7a:	83 ec 04             	sub    $0x4,%esp
80103d7d:	01 c6                	add    %eax,%esi
80103d7f:	56                   	push   %esi
80103d80:	50                   	push   %eax
80103d81:	ff 73 04             	pushl  0x4(%ebx)
80103d84:	e8 d7 39 00 00       	call   80107760 <deallocuvm>
80103d89:	83 c4 10             	add    $0x10,%esp
80103d8c:	85 c0                	test   %eax,%eax
80103d8e:	75 cb                	jne    80103d5b <growproc+0x4b>

  sz = curproc->sz;

  //limit가 설정이 되어 있고, 할당될 사이즈가 limit보다 더 커질려고 할 때 
  if (curproc->limit_sz !=0 && n+sz >curproc->limit_sz ){
    return -1;
80103d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d95:	eb d4                	jmp    80103d6b <growproc+0x5b>
80103d97:	89 f6                	mov    %esi,%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103da9:	e8 c2 0d 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80103dae:	e8 9d fd ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80103db3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db9:	e8 f2 0d 00 00       	call   80104bb0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103dbe:	e8 0d fc ff ff       	call   801039d0 <allocproc>
80103dc3:	85 c0                	test   %eax,%eax
80103dc5:	89 c7                	mov    %eax,%edi
80103dc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dca:	0f 84 e5 00 00 00    	je     80103eb5 <fork+0x115>
    return -1;
  }

  //커널 주소 저장
  curproc->shared_memory_address = kalloc();
80103dd0:	e8 db ea ff ff       	call   801028b0 <kalloc>


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dd5:	83 ec 08             	sub    $0x8,%esp
  if((np = allocproc()) == 0){
    return -1;
  }

  //커널 주소 저장
  curproc->shared_memory_address = kalloc();
80103dd8:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dde:	ff 33                	pushl  (%ebx)
80103de0:	ff 73 04             	pushl  0x4(%ebx)
80103de3:	e8 f8 3a 00 00       	call   801078e0 <copyuvm>
80103de8:	83 c4 10             	add    $0x10,%esp
80103deb:	85 c0                	test   %eax,%eax
80103ded:	89 47 04             	mov    %eax,0x4(%edi)
80103df0:	0f 84 c6 00 00 00    	je     80103ebc <fork+0x11c>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103df6:	8b 03                	mov    (%ebx),%eax
80103df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103dfb:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103e00:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103e02:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103e05:	8b 7a 18             	mov    0x18(%edx),%edi
80103e08:	8b 73 18             	mov    0x18(%ebx),%esi
80103e0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103e0d:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  //부모 프로세스와 같은 값으로 설정해준다.
  np->admin_mode = curproc->admin_mode;
80103e0f:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103e15:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  np->limit_sz = curproc->limit_sz;
80103e1b:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80103e21:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
  np->custom_stack_size = curproc->custom_stack_size;
80103e27:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103e2d:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103e33:	8b 42 18             	mov    0x18(%edx),%eax
80103e36:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103e40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e44:	85 c0                	test   %eax,%eax
80103e46:	74 13                	je     80103e5b <fork+0xbb>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	50                   	push   %eax
80103e4c:	e8 bf d3 ff ff       	call   80101210 <filedup>
80103e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103e5b:	83 c6 01             	add    $0x1,%esi
80103e5e:	83 fe 10             	cmp    $0x10,%esi
80103e61:	75 dd                	jne    80103e40 <fork+0xa0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e69:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e6c:	e8 ef db ff ff       	call   80101a60 <idup>
80103e71:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e74:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e77:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e7d:	6a 10                	push   $0x10
80103e7f:	53                   	push   %ebx
80103e80:	50                   	push   %eax
80103e81:	e8 ca 10 00 00       	call   80104f50 <safestrcpy>

  pid = np->pid;
80103e86:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103e89:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e90:	e8 bb 0d 00 00       	call   80104c50 <acquire>

  np->state = RUNNABLE;
80103e95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103e9c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ea3:	e8 58 0e 00 00       	call   80104d00 <release>

  return pid;
80103ea8:	83 c4 10             	add    $0x10,%esp
80103eab:	89 d8                	mov    %ebx,%eax
}
80103ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eb0:	5b                   	pop    %ebx
80103eb1:	5e                   	pop    %esi
80103eb2:	5f                   	pop    %edi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103eb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eba:	eb f1                	jmp    80103ead <fork+0x10d>
  curproc->shared_memory_address = kalloc();


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103ebc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ebf:	83 ec 0c             	sub    $0xc,%esp
80103ec2:	ff 77 08             	pushl  0x8(%edi)
80103ec5:	e8 36 e8 ff ff       	call   80102700 <kfree>
    np->kstack = 0;
80103eca:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103ed1:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103ed8:	83 c4 10             	add    $0x10,%esp
80103edb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ee0:	eb cb                	jmp    80103ead <fork+0x10d>
80103ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <priority_boosting>:
//      via swtch back to the scheduler.


void 
priority_boosting(void)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103ef6:	68 20 3d 11 80       	push   $0x80113d20
80103efb:	e8 50 0d 00 00       	call   80104c50 <acquire>
80103f00:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f03:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f08:	90                   	nop
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103f10:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103f17:	00 00 00 
        p->tickleft=4;
80103f1a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103f21:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f24:	05 9c 00 00 00       	add    $0x9c,%eax
80103f29:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103f2e:	75 e0                	jne    80103f10 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103f30:	83 ec 0c             	sub    $0xc,%esp
80103f33:	68 20 3d 11 80       	push   $0x80113d20
80103f38:	e8 c3 0d 00 00       	call   80104d00 <release>
}
80103f3d:	83 c4 10             	add    $0x10,%esp
80103f40:	c9                   	leave  
80103f41:	c3                   	ret    
80103f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f50 <scheduler>:
*/


void
scheduler(void)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103f59:	e8 f2 fb ff ff       	call   80103b50 <mycpu>
80103f5e:	8d 78 04             	lea    0x4(%eax),%edi
80103f61:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f63:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f6a:	00 00 00 
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103f70:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f71:	83 ec 0c             	sub    $0xc,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f74:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f79:	68 20 3d 11 80       	push   $0x80113d20
80103f7e:	e8 cd 0c 00 00       	call   80104c50 <acquire>
80103f83:	83 c4 10             	add    $0x10,%esp
80103f86:	eb 16                	jmp    80103f9e <scheduler+0x4e>
80103f88:	90                   	nop
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f90:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103f96:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80103f9c:	74 52                	je     80103ff0 <scheduler+0xa0>
      if(p->state != RUNNABLE) continue;
80103f9e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fa2:	75 ec                	jne    80103f90 <scheduler+0x40>
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103fa4:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE) continue;
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103fa7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fad:	53                   	push   %ebx
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fae:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103fb4:	e8 57 34 00 00       	call   80107410 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103fb9:	58                   	pop    %eax
80103fba:	5a                   	pop    %edx
80103fbb:	ff 73 80             	pushl  -0x80(%ebx)
80103fbe:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103fbf:	c7 83 70 ff ff ff 04 	movl   $0x4,-0x90(%ebx)
80103fc6:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103fc9:	e8 dd 0f 00 00       	call   80104fab <swtch>
      switchkvm();
80103fce:	e8 1d 34 00 00       	call   801073f0 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103fd3:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103fdc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fe3:	00 00 00 
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	75 b6                	jne    80103f9e <scheduler+0x4e>
80103fe8:	90                   	nop
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	68 20 3d 11 80       	push   $0x80113d20
80103ff8:	e8 03 0d 00 00       	call   80104d00 <release>
    #endif
  }
80103ffd:	83 c4 10             	add    $0x10,%esp
80104000:	e9 6b ff ff ff       	jmp    80103f70 <scheduler+0x20>
80104005:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104010 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104015:	e8 56 0b 00 00       	call   80104b70 <pushcli>
  c = mycpu();
8010401a:	e8 31 fb ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010401f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104025:	e8 86 0b 00 00       	call   80104bb0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 20 3d 11 80       	push   $0x80113d20
80104032:	e8 e9 0b 00 00       	call   80104c20 <holding>
80104037:	83 c4 10             	add    $0x10,%esp
8010403a:	85 c0                	test   %eax,%eax
8010403c:	74 4f                	je     8010408d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
8010403e:	e8 0d fb ff ff       	call   80103b50 <mycpu>
80104043:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010404a:	75 68                	jne    801040b4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010404c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104050:	74 55                	je     801040a7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104052:	9c                   	pushf  
80104053:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80104054:	f6 c4 02             	test   $0x2,%ah
80104057:	75 41                	jne    8010409a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80104059:	e8 f2 fa ff ff       	call   80103b50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010405e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80104061:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104067:	e8 e4 fa ff ff       	call   80103b50 <mycpu>
8010406c:	83 ec 08             	sub    $0x8,%esp
8010406f:	ff 70 04             	pushl  0x4(%eax)
80104072:	53                   	push   %ebx
80104073:	e8 33 0f 00 00       	call   80104fab <swtch>
  mycpu()->intena = intena;
80104078:	e8 d3 fa ff ff       	call   80103b50 <mycpu>
}
8010407d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104080:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104086:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
8010408c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010408d:	83 ec 0c             	sub    $0xc,%esp
80104090:	68 70 80 10 80       	push   $0x80108070
80104095:	e8 d6 c2 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 9c 80 10 80       	push   $0x8010809c
801040a2:	e8 c9 c2 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
801040a7:	83 ec 0c             	sub    $0xc,%esp
801040aa:	68 8e 80 10 80       	push   $0x8010808e
801040af:	e8 bc c2 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 82 80 10 80       	push   $0x80108082
801040bc:	e8 af c2 ff ff       	call   80100370 <panic>
801040c1:	eb 0d                	jmp    801040d0 <exit>
801040c3:	90                   	nop
801040c4:	90                   	nop
801040c5:	90                   	nop
801040c6:	90                   	nop
801040c7:	90                   	nop
801040c8:	90                   	nop
801040c9:	90                   	nop
801040ca:	90                   	nop
801040cb:	90                   	nop
801040cc:	90                   	nop
801040cd:	90                   	nop
801040ce:	90                   	nop
801040cf:	90                   	nop

801040d0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	53                   	push   %ebx
801040d6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040d9:	e8 92 0a 00 00       	call   80104b70 <pushcli>
  c = mycpu();
801040de:	e8 6d fa ff ff       	call   80103b50 <mycpu>
  p = c->proc;
801040e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040e9:	e8 c2 0a 00 00       	call   80104bb0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
801040ee:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801040f4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040f7:	8d 7e 68             	lea    0x68(%esi),%edi
801040fa:	0f 84 f1 00 00 00    	je     801041f1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104100:	8b 03                	mov    (%ebx),%eax
80104102:	85 c0                	test   %eax,%eax
80104104:	74 12                	je     80104118 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	50                   	push   %eax
8010410a:	e8 51 d1 ff ff       	call   80101260 <fileclose>
      curproc->ofile[fd] = 0;
8010410f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104115:	83 c4 10             	add    $0x10,%esp
80104118:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010411b:	39 df                	cmp    %ebx,%edi
8010411d:	75 e1                	jne    80104100 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010411f:	e8 4c ee ff ff       	call   80102f70 <begin_op>
  iput(curproc->cwd);
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	ff 76 68             	pushl  0x68(%esi)
8010412a:	e8 91 da ff ff       	call   80101bc0 <iput>
  end_op();
8010412f:	e8 ac ee ff ff       	call   80102fe0 <end_op>
  curproc->cwd = 0;
80104134:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010413b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104142:	e8 09 0b 00 00       	call   80104c50 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104147:	8b 56 14             	mov    0x14(%esi),%edx
8010414a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104152:	eb 10                	jmp    80104164 <exit+0x94>
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104158:	05 9c 00 00 00       	add    $0x9c,%eax
8010415d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104162:	74 1e                	je     80104182 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104164:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104168:	75 ee                	jne    80104158 <exit+0x88>
8010416a:	3b 50 20             	cmp    0x20(%eax),%edx
8010416d:	75 e9                	jne    80104158 <exit+0x88>
      p->state = RUNNABLE;
8010416f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104176:	05 9c 00 00 00       	add    $0x9c,%eax
8010417b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104180:	75 e2                	jne    80104164 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104182:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104188:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010418d:	eb 0f                	jmp    8010419e <exit+0xce>
8010418f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104190:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80104196:	81 fa 54 64 11 80    	cmp    $0x80116454,%edx
8010419c:	74 3a                	je     801041d8 <exit+0x108>
    if(p->parent == curproc){
8010419e:	39 72 14             	cmp    %esi,0x14(%edx)
801041a1:	75 ed                	jne    80104190 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801041a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801041a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041aa:	75 e4                	jne    80104190 <exit+0xc0>
801041ac:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041b1:	eb 11                	jmp    801041c4 <exit+0xf4>
801041b3:	90                   	nop
801041b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b8:	05 9c 00 00 00       	add    $0x9c,%eax
801041bd:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801041c2:	74 cc                	je     80104190 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801041c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041c8:	75 ee                	jne    801041b8 <exit+0xe8>
801041ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801041cd:	75 e9                	jne    801041b8 <exit+0xe8>
      p->state = RUNNABLE;
801041cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041d6:	eb e0                	jmp    801041b8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801041d8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801041df:	e8 2c fe ff ff       	call   80104010 <sched>
  panic("zombie exit");
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	68 bd 80 10 80       	push   $0x801080bd
801041ec:	e8 7f c1 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
801041f1:	83 ec 0c             	sub    $0xc,%esp
801041f4:	68 b0 80 10 80       	push   $0x801080b0
801041f9:	e8 72 c1 ff ff       	call   80100370 <panic>
801041fe:	66 90                	xchg   %ax,%ax

80104200 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104207:	68 20 3d 11 80       	push   $0x80113d20
8010420c:	e8 3f 0a 00 00       	call   80104c50 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104211:	e8 5a 09 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80104216:	e8 35 f9 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010421b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104221:	e8 8a 09 00 00       	call   80104bb0 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
80104226:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010422d:	e8 de fd ff ff       	call   80104010 <sched>
  release(&ptable.lock);
80104232:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104239:	e8 c2 0a 00 00       	call   80104d00 <release>
}
8010423e:	83 c4 10             	add    $0x10,%esp
80104241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104244:	c9                   	leave  
80104245:	c3                   	ret    
80104246:	8d 76 00             	lea    0x0(%esi),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <getlev>:

int             
getlev(void)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104257:	e8 14 09 00 00       	call   80104b70 <pushcli>
  c = mycpu();
8010425c:	e8 ef f8 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104261:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104267:	e8 44 09 00 00       	call   80104bb0 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
8010426c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104272:	83 c4 04             	add    $0x4,%esp
80104275:	5b                   	pop    %ebx
80104276:	5d                   	pop    %ebp
80104277:	c3                   	ret    
80104278:	90                   	nop
80104279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104280 <getadmin>:

int
getadmin(char *password)
{
80104280:	55                   	push   %ebp
  char my_number[10] = "2016025823";
80104281:	b8 32 33 00 00       	mov    $0x3332,%eax
  int flag = 0;
80104286:	31 d2                	xor    %edx,%edx
  return myproc()->queuelevel;
}

int
getadmin(char *password)
{
80104288:	89 e5                	mov    %esp,%ebp
8010428a:	53                   	push   %ebx
8010428b:	83 ec 14             	sub    $0x14,%esp
8010428e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char my_number[10] = "2016025823";
80104291:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80104295:	c7 45 ee 32 30 31 36 	movl   $0x36313032,-0x12(%ebp)
8010429c:	c7 45 f2 30 32 35 38 	movl   $0x38353230,-0xe(%ebp)
  int flag = 0;
  for(int i=0;i<10;i++){
801042a3:	31 c0                	xor    %eax,%eax
801042a5:	8d 76 00             	lea    0x0(%esi),%esi
    if(my_number[i] == password[i]) flag++;
801042a8:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
801042ac:	38 4c 05 ee          	cmp    %cl,-0x12(%ebp,%eax,1)
801042b0:	0f 94 c1             	sete   %cl
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801042b3:	83 c0 01             	add    $0x1,%eax
    if(my_number[i] == password[i]) flag++;
801042b6:	0f b6 c9             	movzbl %cl,%ecx
801042b9:	01 ca                	add    %ecx,%edx
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
801042bb:	83 f8 0a             	cmp    $0xa,%eax
801042be:	75 e8                	jne    801042a8 <getadmin+0x28>
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
801042c0:	83 fa 0a             	cmp    $0xa,%edx
801042c3:	75 2b                	jne    801042f0 <getadmin+0x70>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801042c5:	e8 a6 08 00 00       	call   80104b70 <pushcli>
  c = mycpu();
801042ca:	e8 81 f8 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
801042cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d5:	e8 d6 08 00 00       	call   80104bb0 <popcli>
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
801042da:	31 c0                	xor    %eax,%eax
  int flag = 0;
  for(int i=0;i<10;i++){
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
801042dc:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801042e3:	00 00 00 
    return 0;
  }
  else{
    return -1;
  }
}
801042e6:	83 c4 14             	add    $0x14,%esp
801042e9:	5b                   	pop    %ebx
801042ea:	5d                   	pop    %ebp
801042eb:	c3                   	ret    
801042ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f0:	83 c4 14             	add    $0x14,%esp
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
  }
  else{
    return -1;
801042f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801042f8:	5b                   	pop    %ebx
801042f9:	5d                   	pop    %ebp
801042fa:	c3                   	ret    
801042fb:	90                   	nop
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <setmemorylimit>:

int 
setmemorylimit(int pid, int limit)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	53                   	push   %ebx
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	8b 7d 08             	mov    0x8(%ebp),%edi
8010430c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010430f:	e8 5c 08 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80104314:	e8 37 f8 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104319:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010431f:	e8 8c 08 00 00       	call   80104bb0 <popcli>

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
80104324:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010432a:	85 c0                	test   %eax,%eax
8010432c:	74 5c                	je     8010438a <setmemorylimit+0x8a>
8010432e:	89 f0                	mov    %esi,%eax
80104330:	c1 e8 1f             	shr    $0x1f,%eax
80104333:	84 c0                	test   %al,%al
80104335:	75 53                	jne    8010438a <setmemorylimit+0x8a>
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
80104337:	83 ec 0c             	sub    $0xc,%esp
int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
8010433a:	31 db                	xor    %ebx,%ebx
  struct proc *p;
  acquire(&ptable.lock);
8010433c:	68 20 3d 11 80       	push   $0x80113d20
80104341:	e8 0a 09 00 00       	call   80104c50 <acquire>
80104346:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104349:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010434e:	66 90                	xchg   %ax,%ax
    if(p->pid == pid) target = p;
80104350:	39 78 10             	cmp    %edi,0x10(%eax)
80104353:	0f 44 d8             	cmove  %eax,%ebx
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104356:	05 9c 00 00 00       	add    $0x9c,%eax
8010435b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104360:	75 ee                	jne    80104350 <setmemorylimit+0x50>
    if(p->pid == pid) target = p;
  }
	release(&ptable.lock);
80104362:	83 ec 0c             	sub    $0xc,%esp
80104365:	68 20 3d 11 80       	push   $0x80113d20
8010436a:	e8 91 09 00 00       	call   80104d00 <release>
  //해당 pid가 없을 때
  if(target==0) return -1;
8010436f:	83 c4 10             	add    $0x10,%esp
80104372:	85 db                	test   %ebx,%ebx
80104374:	74 14                	je     8010438a <setmemorylimit+0x8a>

  //기존 사이즈보다 더 작은 Limit을 주려고 할때

  if(target->sz > limit) return -1;
80104376:	39 33                	cmp    %esi,(%ebx)
80104378:	77 10                	ja     8010438a <setmemorylimit+0x8a>
  target->limit_sz = limit;
8010437a:	89 b3 90 00 00 00    	mov    %esi,0x90(%ebx)
  return 0;
80104380:	31 c0                	xor    %eax,%eax
}
80104382:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104385:	5b                   	pop    %ebx
80104386:	5e                   	pop    %esi
80104387:	5f                   	pop    %edi
80104388:	5d                   	pop    %ebp
80104389:	c3                   	ret    

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
8010438a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010438f:	eb f1                	jmp    80104382 <setmemorylimit+0x82>
80104391:	eb 0d                	jmp    801043a0 <getshmem>
80104393:	90                   	nop
80104394:	90                   	nop
80104395:	90                   	nop
80104396:	90                   	nop
80104397:	90                   	nop
80104398:	90                   	nop
80104399:	90                   	nop
8010439a:	90                   	nop
8010439b:	90                   	nop
8010439c:	90                   	nop
8010439d:	90                   	nop
8010439e:	90                   	nop
8010439f:	90                   	nop

801043a0 <getshmem>:
  return 0;
}

char*
getshmem(int pid)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
  struct proc *p;
  char * return_address = 0;
801043a6:	31 ff                	xor    %edi,%edi
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a8:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  return 0;
}

char*
getshmem(int pid)
{
801043ad:	83 ec 28             	sub    $0x28,%esp
801043b0:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
801043b3:	68 20 3d 11 80       	push   $0x80113d20
801043b8:	e8 93 08 00 00       	call   80104c50 <acquire>
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	eb 14                	jmp    801043d6 <getshmem+0x36>
801043c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801043ce:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801043d4:	74 7b                	je     80104451 <getshmem+0xb1>
    if(p->pid == pid) {
801043d6:	39 73 10             	cmp    %esi,0x10(%ebx)
801043d9:	75 ed                	jne    801043c8 <getshmem+0x28>
      return_address = p->shared_memory_address;
801043db:	8b bb 98 00 00 00    	mov    0x98(%ebx),%edi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043e1:	e8 8a 07 00 00       	call   80104b70 <pushcli>
  c = mycpu();
801043e6:	e8 65 f7 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
801043eb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801043f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
801043f4:	e8 b7 07 00 00       	call   80104bb0 <popcli>
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid) {
      return_address = p->shared_memory_address;
      //본인 프로세스의 접근할 때 - 읽기, 쓰기
      if(p->pid == myproc()->pid){
801043f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043fc:	3b 70 10             	cmp    0x10(%eax),%esi
801043ff:	74 6f                	je     80104470 <getshmem+0xd0>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104401:	e8 6a 07 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80104406:	e8 45 f7 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010440b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104411:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
80104417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
8010441a:	e8 91 07 00 00       	call   80104bb0 <popcli>
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
      }
      //다른 프로세스에 접근 할 때 - 읽기
      else{
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
8010441f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104422:	89 fa                	mov    %edi,%edx
80104424:	83 ec 04             	sub    $0x4,%esp
80104427:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010442d:	6a 01                	push   $0x1
8010442f:	52                   	push   %edx
80104430:	ff 70 04             	pushl  0x4(%eax)
80104433:	e8 e8 2d 00 00       	call   80107220 <walkpgdir>
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
80104438:	8b 4b fc             	mov    -0x4(%ebx),%ecx
8010443b:	83 c4 10             	add    $0x10,%esp
8010443e:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80104444:	83 ca 05             	or     $0x5,%edx
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104447:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
      }
      //다른 프로세스에 접근 할 때 - 읽기
      else{
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
8010444d:	89 10                	mov    %edx,(%eax)
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010444f:	75 85                	jne    801043d6 <getshmem+0x36>
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
      }
    }
  }
  release(&ptable.lock);
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	68 20 3d 11 80       	push   $0x80113d20
80104459:	e8 a2 08 00 00       	call   80104d00 <release>
  return return_address;
}
8010445e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104461:	89 f8                	mov    %edi,%eax
80104463:	5b                   	pop    %ebx
80104464:	5e                   	pop    %esi
80104465:	5f                   	pop    %edi
80104466:	5d                   	pop    %ebp
80104467:	c3                   	ret    
80104468:	90                   	nop
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104470:	e8 fb 06 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80104475:	e8 d6 f6 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010447a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80104483:	e8 28 07 00 00       	call   80104bb0 <popcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid) {
      return_address = p->shared_memory_address;
      //본인 프로세스의 접근할 때 - 읽기, 쓰기
      if(p->pid == myproc()->pid){
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
80104488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010448b:	89 fa                	mov    %edi,%edx
8010448d:	83 ec 04             	sub    $0x4,%esp
80104490:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80104496:	6a 01                	push   $0x1
80104498:	52                   	push   %edx
80104499:	ff 70 04             	pushl  0x4(%eax)
8010449c:	e8 7f 2d 00 00       	call   80107220 <walkpgdir>
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
801044a1:	8b 8b 98 00 00 00    	mov    0x98(%ebx),%ecx
801044a7:	83 c4 10             	add    $0x10,%esp
801044aa:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
801044b0:	83 ca 07             	or     $0x7,%edx
801044b3:	89 10                	mov    %edx,(%eax)
801044b5:	e9 0e ff ff ff       	jmp    801043c8 <getshmem+0x28>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <list>:
}


int
list()
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801044c9:	83 ec 10             	sub    $0x10,%esp
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
801044cc:	68 6c 81 10 80       	push   $0x8010816c
801044d1:	e8 8a c1 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  acquire(&ptable.lock);
801044d6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801044dd:	e8 6e 07 00 00       	call   80104c50 <acquire>
801044e2:	83 c4 10             	add    $0x10,%esp
801044e5:	eb 17                	jmp    801044fe <list+0x3e>
801044e7:	89 f6                	mov    %esi,%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801044f0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f6:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
801044fc:	74 49                	je     80104547 <list+0x87>
   if(p->pid != 0){
801044fe:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80104501:	85 c0                	test   %eax,%eax
80104503:	74 eb                	je     801044f0 <list+0x30>
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
80104505:	83 ec 0c             	sub    $0xc,%esp
80104508:	53                   	push   %ebx
80104509:	e8 82 0a 00 00       	call   80104f90 <strlen>
8010450e:	83 c4 10             	add    $0x10,%esp
80104511:	83 f8 06             	cmp    $0x6,%eax
80104514:	7e 4a                	jle    80104560 <list+0xa0>
80104516:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
8010451b:	2b 43 28             	sub    0x28(%ebx),%eax
8010451e:	83 ec 08             	sub    $0x8,%esp
80104521:	ff 73 24             	pushl  0x24(%ebx)
80104524:	ff 73 94             	pushl  -0x6c(%ebx)
80104527:	50                   	push   %eax
80104528:	ff 73 a4             	pushl  -0x5c(%ebx)
8010452b:	53                   	push   %ebx
8010452c:	68 c9 80 10 80       	push   $0x801080c9
80104531:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104537:	e8 24 c1 ff ff       	call   80100660 <cprintf>
8010453c:	83 c4 20             	add    $0x20,%esp
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453f:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
80104545:	75 b7                	jne    801044fe <list+0x3e>
   if(p->pid != 0){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
    }
  }
	release(&ptable.lock);
80104547:	83 ec 0c             	sub    $0xc,%esp
8010454a:	68 20 3d 11 80       	push   $0x80113d20
8010454f:	e8 ac 07 00 00       	call   80104d00 <release>
  return 0;
}
80104554:	31 c0                	xor    %eax,%eax
80104556:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104559:	c9                   	leave  
8010455a:	c3                   	ret    
8010455b:	90                   	nop
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   if(p->pid != 0){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
80104560:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80104565:	2b 43 28             	sub    0x28(%ebx),%eax
80104568:	83 ec 08             	sub    $0x8,%esp
8010456b:	ff 73 24             	pushl  0x24(%ebx)
8010456e:	ff 73 94             	pushl  -0x6c(%ebx)
80104571:	50                   	push   %eax
80104572:	ff 73 a4             	pushl  -0x5c(%ebx)
80104575:	53                   	push   %ebx
80104576:	68 df 80 10 80       	push   $0x801080df
8010457b:	e8 e0 c0 ff ff       	call   80100660 <cprintf>
80104580:	83 c4 20             	add    $0x20,%esp
80104583:	e9 68 ff ff ff       	jmp    801044f0 <list+0x30>
80104588:	90                   	nop
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104590 <setpriority>:
}


int             
setpriority(int pid, int priority)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	53                   	push   %ebx
80104596:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104599:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
}


int             
setpriority(int pid, int priority)
{
8010459d:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
801045a0:	0f 87 97 00 00 00    	ja     8010463d <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801045a6:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801045a9:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
801045ae:	68 20 3d 11 80       	push   $0x80113d20
801045b3:	e8 98 06 00 00       	call   80104c50 <acquire>
801045b8:	83 c4 10             	add    $0x10,%esp
801045bb:	eb 11                	jmp    801045ce <setpriority+0x3e>
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
801045c0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801045c6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801045cc:	74 52                	je     80104620 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
801045ce:	39 73 10             	cmp    %esi,0x10(%ebx)
801045d1:	75 ed                	jne    801045c0 <setpriority+0x30>
801045d3:	8b 43 14             	mov    0x14(%ebx),%eax
801045d6:	8b 50 10             	mov    0x10(%eax),%edx
801045d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801045dc:	e8 8f 05 00 00       	call   80104b70 <pushcli>
  c = mycpu();
801045e1:	e8 6a f5 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
801045e6:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801045ec:	e8 bf 05 00 00       	call   80104bb0 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
801045f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045f4:	3b 57 10             	cmp    0x10(%edi),%edx
801045f7:	75 c7                	jne    801045c0 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
801045f9:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
801045fc:	83 ec 0c             	sub    $0xc,%esp
801045ff:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
80104604:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
80104607:	e8 f4 06 00 00       	call   80104d00 <release>

      return 0;
8010460c:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
8010460f:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
80104612:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
80104614:	5b                   	pop    %ebx
80104615:	5e                   	pop    %esi
80104616:	5f                   	pop    %edi
80104617:	5d                   	pop    %ebp
80104618:	c3                   	ret    
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
80104620:	83 ec 0c             	sub    $0xc,%esp
80104623:	68 20 3d 11 80       	push   $0x80113d20
80104628:	e8 d3 06 00 00       	call   80104d00 <release>
  return -1;
8010462d:	83 c4 10             	add    $0x10,%esp
80104630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104638:	5b                   	pop    %ebx
80104639:	5e                   	pop    %esi
8010463a:	5f                   	pop    %edi
8010463b:	5d                   	pop    %ebp
8010463c:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
8010463d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104642:	eb f1                	jmp    80104635 <setpriority+0xa5>
80104644:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010464a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104650 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	53                   	push   %ebx
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	8b 7d 08             	mov    0x8(%ebp),%edi
8010465c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010465f:	e8 0c 05 00 00       	call   80104b70 <pushcli>
  c = mycpu();
80104664:	e8 e7 f4 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
80104669:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010466f:	e8 3c 05 00 00       	call   80104bb0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104674:	85 db                	test   %ebx,%ebx
80104676:	0f 84 87 00 00 00    	je     80104703 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010467c:	85 f6                	test   %esi,%esi
8010467e:	74 76                	je     801046f6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104680:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104686:	74 50                	je     801046d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 20 3d 11 80       	push   $0x80113d20
80104690:	e8 bb 05 00 00       	call   80104c50 <acquire>
    release(lk);
80104695:	89 34 24             	mov    %esi,(%esp)
80104698:	e8 63 06 00 00       	call   80104d00 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010469d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046a7:	e8 64 f9 ff ff       	call   80104010 <sched>
  // Tidy up.
  p->chan = 0;
801046ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801046b3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801046ba:	e8 41 06 00 00       	call   80104d00 <release>
    acquire(lk);
801046bf:	89 75 08             	mov    %esi,0x8(%ebp)
801046c2:	83 c4 10             	add    $0x10,%esp
  }
}
801046c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046c8:	5b                   	pop    %ebx
801046c9:	5e                   	pop    %esi
801046ca:	5f                   	pop    %edi
801046cb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801046cc:	e9 7f 05 00 00       	jmp    80104c50 <acquire>
801046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801046d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046e2:	e8 29 f9 ff ff       	call   80104010 <sched>
  // Tidy up.
  p->chan = 0;
801046e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801046ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046f1:	5b                   	pop    %ebx
801046f2:	5e                   	pop    %esi
801046f3:	5f                   	pop    %edi
801046f4:	5d                   	pop    %ebp
801046f5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
801046f6:	83 ec 0c             	sub    $0xc,%esp
801046f9:	68 fc 80 10 80       	push   $0x801080fc
801046fe:	e8 6d bc ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104703:	83 ec 0c             	sub    $0xc,%esp
80104706:	68 f6 80 10 80       	push   $0x801080f6
8010470b:	e8 60 bc ff ff       	call   80100370 <panic>

80104710 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104715:	e8 56 04 00 00       	call   80104b70 <pushcli>
  c = mycpu();
8010471a:	e8 31 f4 ff ff       	call   80103b50 <mycpu>
  p = c->proc;
8010471f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104725:	e8 86 04 00 00       	call   80104bb0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010472a:	83 ec 0c             	sub    $0xc,%esp
8010472d:	68 20 3d 11 80       	push   $0x80113d20
80104732:	e8 19 05 00 00       	call   80104c50 <acquire>
80104737:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010473a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010473c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104741:	eb 13                	jmp    80104756 <wait+0x46>
80104743:	90                   	nop
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104748:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010474e:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104754:	74 22                	je     80104778 <wait+0x68>
      if(p->parent != curproc)
80104756:	39 73 14             	cmp    %esi,0x14(%ebx)
80104759:	75 ed                	jne    80104748 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010475b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010475f:	74 35                	je     80104796 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104761:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104767:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010476c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104772:	75 e2                	jne    80104756 <wait+0x46>
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104778:	85 c0                	test   %eax,%eax
8010477a:	74 70                	je     801047ec <wait+0xdc>
8010477c:	8b 46 24             	mov    0x24(%esi),%eax
8010477f:	85 c0                	test   %eax,%eax
80104781:	75 69                	jne    801047ec <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104783:	83 ec 08             	sub    $0x8,%esp
80104786:	68 20 3d 11 80       	push   $0x80113d20
8010478b:	56                   	push   %esi
8010478c:	e8 bf fe ff ff       	call   80104650 <sleep>
  }
80104791:	83 c4 10             	add    $0x10,%esp
80104794:	eb a4                	jmp    8010473a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104796:	83 ec 0c             	sub    $0xc,%esp
80104799:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010479c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010479f:	e8 5c df ff ff       	call   80102700 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801047a4:	5a                   	pop    %edx
801047a5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801047a8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801047af:	e8 dc 2f 00 00       	call   80107790 <freevm>
        p->pid = 0;
801047b4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801047bb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047c2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801047c6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047cd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801047d4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801047db:	e8 20 05 00 00       	call   80104d00 <release>
        return pid;
801047e0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
801047e6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047e8:	5b                   	pop    %ebx
801047e9:	5e                   	pop    %esi
801047ea:	5d                   	pop    %ebp
801047eb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	68 20 3d 11 80       	push   $0x80113d20
801047f4:	e8 07 05 00 00       	call   80104d00 <release>
      return -1;
801047f9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
801047ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104804:	5b                   	pop    %ebx
80104805:	5e                   	pop    %esi
80104806:	5d                   	pop    %ebp
80104807:	c3                   	ret    
80104808:	90                   	nop
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104810 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 10             	sub    $0x10,%esp
80104817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010481a:	68 20 3d 11 80       	push   $0x80113d20
8010481f:	e8 2c 04 00 00       	call   80104c50 <acquire>
80104824:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104827:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010482c:	eb 0e                	jmp    8010483c <wakeup+0x2c>
8010482e:	66 90                	xchg   %ax,%ax
80104830:	05 9c 00 00 00       	add    $0x9c,%eax
80104835:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010483a:	74 1e                	je     8010485a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010483c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104840:	75 ee                	jne    80104830 <wakeup+0x20>
80104842:	3b 58 20             	cmp    0x20(%eax),%ebx
80104845:	75 e9                	jne    80104830 <wakeup+0x20>
      p->state = RUNNABLE;
80104847:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010484e:	05 9c 00 00 00       	add    $0x9c,%eax
80104853:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104858:	75 e2                	jne    8010483c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010485a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104861:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104864:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104865:	e9 96 04 00 00       	jmp    80104d00 <release>
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104870 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 10             	sub    $0x10,%esp
80104877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010487a:	68 20 3d 11 80       	push   $0x80113d20
8010487f:	e8 cc 03 00 00       	call   80104c50 <acquire>
80104884:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104887:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010488c:	eb 0e                	jmp    8010489c <kill+0x2c>
8010488e:	66 90                	xchg   %ax,%ax
80104890:	05 9c 00 00 00       	add    $0x9c,%eax
80104895:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010489a:	74 3c                	je     801048d8 <kill+0x68>
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
8010489c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010489f:	75 ef                	jne    80104890 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801048a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
801048a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801048ac:	74 1a                	je     801048c8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801048ae:	83 ec 0c             	sub    $0xc,%esp
801048b1:	68 20 3d 11 80       	push   $0x80113d20
801048b6:	e8 45 04 00 00       	call   80104d00 <release>
      return 0;
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801048c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c3:	c9                   	leave  
801048c4:	c3                   	ret    
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801048c8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048cf:	eb dd                	jmp    801048ae <kill+0x3e>
801048d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	68 20 3d 11 80       	push   $0x80113d20
801048e0:	e8 1b 04 00 00       	call   80104d00 <release>
  return -1;
801048e5:	83 c4 10             	add    $0x10,%esp
801048e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f0:	c9                   	leave  
801048f1:	c3                   	ret    
801048f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	56                   	push   %esi
80104905:	53                   	push   %ebx
80104906:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104909:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010490e:	83 ec 3c             	sub    $0x3c,%esp
80104911:	eb 27                	jmp    8010493a <procdump+0x3a>
80104913:	90                   	nop
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	68 d7 84 10 80       	push   $0x801084d7
80104920:	e8 3b bd ff ff       	call   80100660 <cprintf>
80104925:	83 c4 10             	add    $0x10,%esp
80104928:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010492e:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
80104934:	0f 84 7e 00 00 00    	je     801049b8 <procdump+0xb8>
    if(p->state == UNUSED)
8010493a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010493d:	85 c0                	test   %eax,%eax
8010493f:	74 e7                	je     80104928 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104941:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104944:	ba 0d 81 10 80       	mov    $0x8010810d,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104949:	77 11                	ja     8010495c <procdump+0x5c>
8010494b:	8b 14 85 a0 81 10 80 	mov    -0x7fef7e60(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104952:	b8 0d 81 10 80       	mov    $0x8010810d,%eax
80104957:	85 d2                	test   %edx,%edx
80104959:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010495c:	53                   	push   %ebx
8010495d:	52                   	push   %edx
8010495e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104961:	68 11 81 10 80       	push   $0x80108111
80104966:	e8 f5 bc ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010496b:	83 c4 10             	add    $0x10,%esp
8010496e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104972:	75 a4                	jne    80104918 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104974:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104977:	83 ec 08             	sub    $0x8,%esp
8010497a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010497d:	50                   	push   %eax
8010497e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104981:	8b 40 0c             	mov    0xc(%eax),%eax
80104984:	83 c0 08             	add    $0x8,%eax
80104987:	50                   	push   %eax
80104988:	e8 83 01 00 00       	call   80104b10 <getcallerpcs>
8010498d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104990:	8b 17                	mov    (%edi),%edx
80104992:	85 d2                	test   %edx,%edx
80104994:	74 82                	je     80104918 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104996:	83 ec 08             	sub    $0x8,%esp
80104999:	83 c7 04             	add    $0x4,%edi
8010499c:	52                   	push   %edx
8010499d:	68 01 7b 10 80       	push   $0x80107b01
801049a2:	e8 b9 bc ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801049a7:	83 c4 10             	add    $0x10,%esp
801049aa:	39 f7                	cmp    %esi,%edi
801049ac:	75 e2                	jne    80104990 <procdump+0x90>
801049ae:	e9 65 ff ff ff       	jmp    80104918 <procdump+0x18>
801049b3:	90                   	nop
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801049b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049bb:	5b                   	pop    %ebx
801049bc:	5e                   	pop    %esi
801049bd:	5f                   	pop    %edi
801049be:	5d                   	pop    %ebp
801049bf:	c3                   	ret    

801049c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 0c             	sub    $0xc,%esp
801049c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049ca:	68 b8 81 10 80       	push   $0x801081b8
801049cf:	8d 43 04             	lea    0x4(%ebx),%eax
801049d2:	50                   	push   %eax
801049d3:	e8 18 01 00 00       	call   80104af0 <initlock>
  lk->name = name;
801049d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049e1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801049e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801049eb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801049ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f1:	c9                   	leave  
801049f2:	c3                   	ret    
801049f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
80104a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a0e:	56                   	push   %esi
80104a0f:	e8 3c 02 00 00       	call   80104c50 <acquire>
  while (lk->locked) {
80104a14:	8b 13                	mov    (%ebx),%edx
80104a16:	83 c4 10             	add    $0x10,%esp
80104a19:	85 d2                	test   %edx,%edx
80104a1b:	74 16                	je     80104a33 <acquiresleep+0x33>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104a20:	83 ec 08             	sub    $0x8,%esp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	e8 26 fc ff ff       	call   80104650 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104a2a:	8b 03                	mov    (%ebx),%eax
80104a2c:	83 c4 10             	add    $0x10,%esp
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	75 ed                	jne    80104a20 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104a33:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a39:	e8 b2 f1 ff ff       	call   80103bf0 <myproc>
80104a3e:	8b 40 10             	mov    0x10(%eax),%eax
80104a41:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a44:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a4a:	5b                   	pop    %ebx
80104a4b:	5e                   	pop    %esi
80104a4c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104a4d:	e9 ae 02 00 00       	jmp    80104d00 <release>
80104a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
80104a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a6e:	56                   	push   %esi
80104a6f:	e8 dc 01 00 00       	call   80104c50 <acquire>
  lk->locked = 0;
80104a74:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a7a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a81:	89 1c 24             	mov    %ebx,(%esp)
80104a84:	e8 87 fd ff ff       	call   80104810 <wakeup>
  release(&lk->lk);
80104a89:	89 75 08             	mov    %esi,0x8(%ebp)
80104a8c:	83 c4 10             	add    $0x10,%esp
}
80104a8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a92:	5b                   	pop    %ebx
80104a93:	5e                   	pop    %esi
80104a94:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104a95:	e9 66 02 00 00       	jmp    80104d00 <release>
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	31 ff                	xor    %edi,%edi
80104aa8:	83 ec 18             	sub    $0x18,%esp
80104aab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104aae:	8d 73 04             	lea    0x4(%ebx),%esi
80104ab1:	56                   	push   %esi
80104ab2:	e8 99 01 00 00       	call   80104c50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104ab7:	8b 03                	mov    (%ebx),%eax
80104ab9:	83 c4 10             	add    $0x10,%esp
80104abc:	85 c0                	test   %eax,%eax
80104abe:	74 13                	je     80104ad3 <holdingsleep+0x33>
80104ac0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ac3:	e8 28 f1 ff ff       	call   80103bf0 <myproc>
80104ac8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104acb:	0f 94 c0             	sete   %al
80104ace:	0f b6 c0             	movzbl %al,%eax
80104ad1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ad3:	83 ec 0c             	sub    $0xc,%esp
80104ad6:	56                   	push   %esi
80104ad7:	e8 24 02 00 00       	call   80104d00 <release>
  return r;
}
80104adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104adf:	89 f8                	mov    %edi,%eax
80104ae1:	5b                   	pop    %ebx
80104ae2:	5e                   	pop    %esi
80104ae3:	5f                   	pop    %edi
80104ae4:	5d                   	pop    %ebp
80104ae5:	c3                   	ret    
80104ae6:	66 90                	xchg   %ax,%ax
80104ae8:	66 90                	xchg   %ax,%ax
80104aea:	66 90                	xchg   %ax,%ax
80104aec:	66 90                	xchg   %ax,%ax
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104aff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104b02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b09:	5d                   	pop    %ebp
80104b0a:	c3                   	ret    
80104b0b:	90                   	nop
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b14:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b1a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104b1d:	31 c0                	xor    %eax,%eax
80104b1f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b20:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b26:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b2c:	77 1a                	ja     80104b48 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b2e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b31:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b34:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104b37:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b39:	83 f8 0a             	cmp    $0xa,%eax
80104b3c:	75 e2                	jne    80104b20 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b3e:	5b                   	pop    %ebx
80104b3f:	5d                   	pop    %ebp
80104b40:	c3                   	ret    
80104b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104b48:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b4f:	83 c0 01             	add    $0x1,%eax
80104b52:	83 f8 0a             	cmp    $0xa,%eax
80104b55:	74 e7                	je     80104b3e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104b57:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b5e:	83 c0 01             	add    $0x1,%eax
80104b61:	83 f8 0a             	cmp    $0xa,%eax
80104b64:	75 e2                	jne    80104b48 <getcallerpcs+0x38>
80104b66:	eb d6                	jmp    80104b3e <getcallerpcs+0x2e>
80104b68:	90                   	nop
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
80104b77:	9c                   	pushf  
80104b78:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104b79:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b7a:	e8 d1 ef ff ff       	call   80103b50 <mycpu>
80104b7f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b85:	85 c0                	test   %eax,%eax
80104b87:	75 11                	jne    80104b9a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b89:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b8f:	e8 bc ef ff ff       	call   80103b50 <mycpu>
80104b94:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b9a:	e8 b1 ef ff ff       	call   80103b50 <mycpu>
80104b9f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ba6:	83 c4 04             	add    $0x4,%esp
80104ba9:	5b                   	pop    %ebx
80104baa:	5d                   	pop    %ebp
80104bab:	c3                   	ret    
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <popcli>:

void
popcli(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bb6:	9c                   	pushf  
80104bb7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bb8:	f6 c4 02             	test   $0x2,%ah
80104bbb:	75 52                	jne    80104c0f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104bbd:	e8 8e ef ff ff       	call   80103b50 <mycpu>
80104bc2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104bc8:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104bcb:	85 d2                	test   %edx,%edx
80104bcd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104bd3:	78 2d                	js     80104c02 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bd5:	e8 76 ef ff ff       	call   80103b50 <mycpu>
80104bda:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104be0:	85 d2                	test   %edx,%edx
80104be2:	74 0c                	je     80104bf0 <popcli+0x40>
    sti();
}
80104be4:	c9                   	leave  
80104be5:	c3                   	ret    
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bf0:	e8 5b ef ff ff       	call   80103b50 <mycpu>
80104bf5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bfb:	85 c0                	test   %eax,%eax
80104bfd:	74 e5                	je     80104be4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104bff:	fb                   	sti    
    sti();
}
80104c00:	c9                   	leave  
80104c01:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104c02:	83 ec 0c             	sub    $0xc,%esp
80104c05:	68 da 81 10 80       	push   $0x801081da
80104c0a:	e8 61 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104c0f:	83 ec 0c             	sub    $0xc,%esp
80104c12:	68 c3 81 10 80       	push   $0x801081c3
80104c17:	e8 54 b7 ff ff       	call   80100370 <panic>
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 75 08             	mov    0x8(%ebp),%esi
80104c28:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104c2a:	e8 41 ff ff ff       	call   80104b70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c2f:	8b 06                	mov    (%esi),%eax
80104c31:	85 c0                	test   %eax,%eax
80104c33:	74 10                	je     80104c45 <holding+0x25>
80104c35:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c38:	e8 13 ef ff ff       	call   80103b50 <mycpu>
80104c3d:	39 c3                	cmp    %eax,%ebx
80104c3f:	0f 94 c3             	sete   %bl
80104c42:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104c45:	e8 66 ff ff ff       	call   80104bb0 <popcli>
  return r;
}
80104c4a:	89 d8                	mov    %ebx,%eax
80104c4c:	5b                   	pop    %ebx
80104c4d:	5e                   	pop    %esi
80104c4e:	5d                   	pop    %ebp
80104c4f:	c3                   	ret    

80104c50 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c57:	e8 14 ff ff ff       	call   80104b70 <pushcli>
  if(holding(lk))
80104c5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c5f:	83 ec 0c             	sub    $0xc,%esp
80104c62:	53                   	push   %ebx
80104c63:	e8 b8 ff ff ff       	call   80104c20 <holding>
80104c68:	83 c4 10             	add    $0x10,%esp
80104c6b:	85 c0                	test   %eax,%eax
80104c6d:	0f 85 7d 00 00 00    	jne    80104cf0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c73:	ba 01 00 00 00       	mov    $0x1,%edx
80104c78:	eb 09                	jmp    80104c83 <acquire+0x33>
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c83:	89 d0                	mov    %edx,%eax
80104c85:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104c88:	85 c0                	test   %eax,%eax
80104c8a:	75 f4                	jne    80104c80 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104c8c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c94:	e8 b7 ee ff ff       	call   80103b50 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104c99:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104c9b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104c9e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ca1:	31 c0                	xor    %eax,%eax
80104ca3:	90                   	nop
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104cae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cb4:	77 1a                	ja     80104cd0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cb6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104cb9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cbc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104cbf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cc1:	83 f8 0a             	cmp    $0xa,%eax
80104cc4:	75 e2                	jne    80104ca8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc9:	c9                   	leave  
80104cca:	c3                   	ret    
80104ccb:	90                   	nop
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104cd0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104cd7:	83 c0 01             	add    $0x1,%eax
80104cda:	83 f8 0a             	cmp    $0xa,%eax
80104cdd:	74 e7                	je     80104cc6 <acquire+0x76>
    pcs[i] = 0;
80104cdf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ce6:	83 c0 01             	add    $0x1,%eax
80104ce9:	83 f8 0a             	cmp    $0xa,%eax
80104cec:	75 e2                	jne    80104cd0 <acquire+0x80>
80104cee:	eb d6                	jmp    80104cc6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104cf0:	83 ec 0c             	sub    $0xc,%esp
80104cf3:	68 e1 81 10 80       	push   $0x801081e1
80104cf8:	e8 73 b6 ff ff       	call   80100370 <panic>
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 10             	sub    $0x10,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d0a:	53                   	push   %ebx
80104d0b:	e8 10 ff ff ff       	call   80104c20 <holding>
80104d10:	83 c4 10             	add    $0x10,%esp
80104d13:	85 c0                	test   %eax,%eax
80104d15:	74 22                	je     80104d39 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104d17:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d1e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104d25:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104d30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d33:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104d34:	e9 77 fe ff ff       	jmp    80104bb0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104d39:	83 ec 0c             	sub    $0xc,%esp
80104d3c:	68 e9 81 10 80       	push   $0x801081e9
80104d41:	e8 2a b6 ff ff       	call   80100370 <panic>
80104d46:	66 90                	xchg   %ax,%ax
80104d48:	66 90                	xchg   %ax,%ax
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	53                   	push   %ebx
80104d55:	8b 55 08             	mov    0x8(%ebp),%edx
80104d58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d5b:	f6 c2 03             	test   $0x3,%dl
80104d5e:	75 05                	jne    80104d65 <memset+0x15>
80104d60:	f6 c1 03             	test   $0x3,%cl
80104d63:	74 13                	je     80104d78 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104d65:	89 d7                	mov    %edx,%edi
80104d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d6a:	fc                   	cld    
80104d6b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d6d:	5b                   	pop    %ebx
80104d6e:	89 d0                	mov    %edx,%eax
80104d70:	5f                   	pop    %edi
80104d71:	5d                   	pop    %ebp
80104d72:	c3                   	ret    
80104d73:	90                   	nop
80104d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104d78:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104d7c:	c1 e9 02             	shr    $0x2,%ecx
80104d7f:	89 fb                	mov    %edi,%ebx
80104d81:	89 f8                	mov    %edi,%eax
80104d83:	c1 e3 18             	shl    $0x18,%ebx
80104d86:	c1 e0 10             	shl    $0x10,%eax
80104d89:	09 d8                	or     %ebx,%eax
80104d8b:	09 f8                	or     %edi,%eax
80104d8d:	c1 e7 08             	shl    $0x8,%edi
80104d90:	09 f8                	or     %edi,%eax
80104d92:	89 d7                	mov    %edx,%edi
80104d94:	fc                   	cld    
80104d95:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d97:	5b                   	pop    %ebx
80104d98:	89 d0                	mov    %edx,%eax
80104d9a:	5f                   	pop    %edi
80104d9b:	5d                   	pop    %ebp
80104d9c:	c3                   	ret    
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi

80104da0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	8b 45 10             	mov    0x10(%ebp),%eax
80104da8:	53                   	push   %ebx
80104da9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104dac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104daf:	85 c0                	test   %eax,%eax
80104db1:	74 29                	je     80104ddc <memcmp+0x3c>
    if(*s1 != *s2)
80104db3:	0f b6 13             	movzbl (%ebx),%edx
80104db6:	0f b6 0e             	movzbl (%esi),%ecx
80104db9:	38 d1                	cmp    %dl,%cl
80104dbb:	75 2b                	jne    80104de8 <memcmp+0x48>
80104dbd:	8d 78 ff             	lea    -0x1(%eax),%edi
80104dc0:	31 c0                	xor    %eax,%eax
80104dc2:	eb 14                	jmp    80104dd8 <memcmp+0x38>
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104dcd:	83 c0 01             	add    $0x1,%eax
80104dd0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104dd4:	38 ca                	cmp    %cl,%dl
80104dd6:	75 10                	jne    80104de8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104dd8:	39 f8                	cmp    %edi,%eax
80104dda:	75 ec                	jne    80104dc8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104ddc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104ddd:	31 c0                	xor    %eax,%eax
}
80104ddf:	5e                   	pop    %esi
80104de0:	5f                   	pop    %edi
80104de1:	5d                   	pop    %ebp
80104de2:	c3                   	ret    
80104de3:	90                   	nop
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104de8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104deb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104dec:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104dee:	5e                   	pop    %esi
80104def:	5f                   	pop    %edi
80104df0:	5d                   	pop    %ebp
80104df1:	c3                   	ret    
80104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 45 08             	mov    0x8(%ebp),%eax
80104e08:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e0e:	39 c6                	cmp    %eax,%esi
80104e10:	73 2e                	jae    80104e40 <memmove+0x40>
80104e12:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104e15:	39 c8                	cmp    %ecx,%eax
80104e17:	73 27                	jae    80104e40 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104e19:	85 db                	test   %ebx,%ebx
80104e1b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104e1e:	74 17                	je     80104e37 <memmove+0x37>
      *--d = *--s;
80104e20:	29 d9                	sub    %ebx,%ecx
80104e22:	89 cb                	mov    %ecx,%ebx
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e28:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104e2c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104e2f:	83 ea 01             	sub    $0x1,%edx
80104e32:	83 fa ff             	cmp    $0xffffffff,%edx
80104e35:	75 f1                	jne    80104e28 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e37:	5b                   	pop    %ebx
80104e38:	5e                   	pop    %esi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e40:	31 d2                	xor    %edx,%edx
80104e42:	85 db                	test   %ebx,%ebx
80104e44:	74 f1                	je     80104e37 <memmove+0x37>
80104e46:	8d 76 00             	lea    0x0(%esi),%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104e50:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104e54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e57:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e5a:	39 d3                	cmp    %edx,%ebx
80104e5c:	75 f2                	jne    80104e50 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104e5e:	5b                   	pop    %ebx
80104e5f:	5e                   	pop    %esi
80104e60:	5d                   	pop    %ebp
80104e61:	c3                   	ret    
80104e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e73:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e74:	eb 8a                	jmp    80104e00 <memmove>
80104e76:	8d 76 00             	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e88:	53                   	push   %ebx
80104e89:	8b 7d 08             	mov    0x8(%ebp),%edi
80104e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e8f:	85 c9                	test   %ecx,%ecx
80104e91:	74 37                	je     80104eca <strncmp+0x4a>
80104e93:	0f b6 17             	movzbl (%edi),%edx
80104e96:	0f b6 1e             	movzbl (%esi),%ebx
80104e99:	84 d2                	test   %dl,%dl
80104e9b:	74 3f                	je     80104edc <strncmp+0x5c>
80104e9d:	38 d3                	cmp    %dl,%bl
80104e9f:	75 3b                	jne    80104edc <strncmp+0x5c>
80104ea1:	8d 47 01             	lea    0x1(%edi),%eax
80104ea4:	01 cf                	add    %ecx,%edi
80104ea6:	eb 1b                	jmp    80104ec3 <strncmp+0x43>
80104ea8:	90                   	nop
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb0:	0f b6 10             	movzbl (%eax),%edx
80104eb3:	84 d2                	test   %dl,%dl
80104eb5:	74 21                	je     80104ed8 <strncmp+0x58>
80104eb7:	0f b6 19             	movzbl (%ecx),%ebx
80104eba:	83 c0 01             	add    $0x1,%eax
80104ebd:	89 ce                	mov    %ecx,%esi
80104ebf:	38 da                	cmp    %bl,%dl
80104ec1:	75 19                	jne    80104edc <strncmp+0x5c>
80104ec3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104ec5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104ec8:	75 e6                	jne    80104eb0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104eca:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104ecb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104ecd:	5e                   	pop    %esi
80104ece:	5f                   	pop    %edi
80104ecf:	5d                   	pop    %ebp
80104ed0:	c3                   	ret    
80104ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104edc:	0f b6 c2             	movzbl %dl,%eax
80104edf:	29 d8                	sub    %ebx,%eax
}
80104ee1:	5b                   	pop    %ebx
80104ee2:	5e                   	pop    %esi
80104ee3:	5f                   	pop    %edi
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    
80104ee6:	8d 76 00             	lea    0x0(%esi),%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
80104ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104efb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104efe:	89 c2                	mov    %eax,%edx
80104f00:	eb 19                	jmp    80104f1b <strncpy+0x2b>
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f08:	83 c3 01             	add    $0x1,%ebx
80104f0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104f0f:	83 c2 01             	add    $0x1,%edx
80104f12:	84 c9                	test   %cl,%cl
80104f14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f17:	74 09                	je     80104f22 <strncpy+0x32>
80104f19:	89 f1                	mov    %esi,%ecx
80104f1b:	85 c9                	test   %ecx,%ecx
80104f1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104f20:	7f e6                	jg     80104f08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f22:	31 c9                	xor    %ecx,%ecx
80104f24:	85 f6                	test   %esi,%esi
80104f26:	7e 17                	jle    80104f3f <strncpy+0x4f>
80104f28:	90                   	nop
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104f34:	89 f3                	mov    %esi,%ebx
80104f36:	83 c1 01             	add    $0x1,%ecx
80104f39:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104f3b:	85 db                	test   %ebx,%ebx
80104f3d:	7f f1                	jg     80104f30 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104f3f:	5b                   	pop    %ebx
80104f40:	5e                   	pop    %esi
80104f41:	5d                   	pop    %ebp
80104f42:	c3                   	ret    
80104f43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
80104f55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f58:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f5e:	85 c9                	test   %ecx,%ecx
80104f60:	7e 26                	jle    80104f88 <safestrcpy+0x38>
80104f62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f66:	89 c1                	mov    %eax,%ecx
80104f68:	eb 17                	jmp    80104f81 <safestrcpy+0x31>
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f70:	83 c2 01             	add    $0x1,%edx
80104f73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f77:	83 c1 01             	add    $0x1,%ecx
80104f7a:	84 db                	test   %bl,%bl
80104f7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f7f:	74 04                	je     80104f85 <safestrcpy+0x35>
80104f81:	39 f2                	cmp    %esi,%edx
80104f83:	75 eb                	jne    80104f70 <safestrcpy+0x20>
    ;
  *s = 0;
80104f85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f88:	5b                   	pop    %ebx
80104f89:	5e                   	pop    %esi
80104f8a:	5d                   	pop    %ebp
80104f8b:	c3                   	ret    
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f90 <strlen>:

int
strlen(const char *s)
{
80104f90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f91:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104f98:	80 3a 00             	cmpb   $0x0,(%edx)
80104f9b:	74 0c                	je     80104fa9 <strlen+0x19>
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
80104fa0:	83 c0 01             	add    $0x1,%eax
80104fa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104fa7:	75 f7                	jne    80104fa0 <strlen+0x10>
    ;
  return n;
}
80104fa9:	5d                   	pop    %ebp
80104faa:	c3                   	ret    

80104fab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104faf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104fb3:	55                   	push   %ebp
  pushl %ebx
80104fb4:	53                   	push   %ebx
  pushl %esi
80104fb5:	56                   	push   %esi
  pushl %edi
80104fb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fb9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104fbb:	5f                   	pop    %edi
  popl %esi
80104fbc:	5e                   	pop    %esi
  popl %ebx
80104fbd:	5b                   	pop    %ebx
  popl %ebp
80104fbe:	5d                   	pop    %ebp
  ret
80104fbf:	c3                   	ret    

80104fc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	53                   	push   %ebx
80104fc4:	83 ec 04             	sub    $0x4,%esp
80104fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104fca:	e8 21 ec ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fcf:	8b 00                	mov    (%eax),%eax
80104fd1:	39 d8                	cmp    %ebx,%eax
80104fd3:	76 1b                	jbe    80104ff0 <fetchint+0x30>
80104fd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104fd8:	39 d0                	cmp    %edx,%eax
80104fda:	72 14                	jb     80104ff0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fdf:	8b 13                	mov    (%ebx),%edx
80104fe1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe3:	31 c0                	xor    %eax,%eax
}
80104fe5:	83 c4 04             	add    $0x4,%esp
80104fe8:	5b                   	pop    %ebx
80104fe9:	5d                   	pop    %ebp
80104fea:	c3                   	ret    
80104feb:	90                   	nop
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ff5:	eb ee                	jmp    80104fe5 <fetchint+0x25>
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	53                   	push   %ebx
80105004:	83 ec 04             	sub    $0x4,%esp
80105007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010500a:	e8 e1 eb ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz)
8010500f:	39 18                	cmp    %ebx,(%eax)
80105011:	76 29                	jbe    8010503c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105016:	89 da                	mov    %ebx,%edx
80105018:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010501a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010501c:	39 c3                	cmp    %eax,%ebx
8010501e:	73 1c                	jae    8010503c <fetchstr+0x3c>
    if(*s == 0)
80105020:	80 3b 00             	cmpb   $0x0,(%ebx)
80105023:	75 10                	jne    80105035 <fetchstr+0x35>
80105025:	eb 29                	jmp    80105050 <fetchstr+0x50>
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105030:	80 3a 00             	cmpb   $0x0,(%edx)
80105033:	74 1b                	je     80105050 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105035:	83 c2 01             	add    $0x1,%edx
80105038:	39 d0                	cmp    %edx,%eax
8010503a:	77 f4                	ja     80105030 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010503c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010503f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80105044:	5b                   	pop    %ebx
80105045:	5d                   	pop    %ebp
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105050:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80105053:	89 d0                	mov    %edx,%eax
80105055:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105057:	5b                   	pop    %ebx
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret    
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105060 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105065:	e8 86 eb ff ff       	call   80103bf0 <myproc>
8010506a:	8b 40 18             	mov    0x18(%eax),%eax
8010506d:	8b 55 08             	mov    0x8(%ebp),%edx
80105070:	8b 40 44             	mov    0x44(%eax),%eax
80105073:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80105076:	e8 75 eb ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010507b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010507d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105080:	39 c6                	cmp    %eax,%esi
80105082:	73 1c                	jae    801050a0 <argint+0x40>
80105084:	8d 53 08             	lea    0x8(%ebx),%edx
80105087:	39 d0                	cmp    %edx,%eax
80105089:	72 15                	jb     801050a0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010508b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508e:	8b 53 04             	mov    0x4(%ebx),%edx
80105091:	89 10                	mov    %edx,(%eax)
  return 0;
80105093:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80105095:	5b                   	pop    %ebx
80105096:	5e                   	pop    %esi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ee                	jmp    80105095 <argint+0x35>
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
801050b5:	83 ec 10             	sub    $0x10,%esp
801050b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050bb:	e8 30 eb ff ff       	call   80103bf0 <myproc>
801050c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801050c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050c5:	83 ec 08             	sub    $0x8,%esp
801050c8:	50                   	push   %eax
801050c9:	ff 75 08             	pushl  0x8(%ebp)
801050cc:	e8 8f ff ff ff       	call   80105060 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050d1:	c1 e8 1f             	shr    $0x1f,%eax
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	84 c0                	test   %al,%al
801050d9:	75 2d                	jne    80105108 <argptr+0x58>
801050db:	89 d8                	mov    %ebx,%eax
801050dd:	c1 e8 1f             	shr    $0x1f,%eax
801050e0:	84 c0                	test   %al,%al
801050e2:	75 24                	jne    80105108 <argptr+0x58>
801050e4:	8b 16                	mov    (%esi),%edx
801050e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e9:	39 c2                	cmp    %eax,%edx
801050eb:	76 1b                	jbe    80105108 <argptr+0x58>
801050ed:	01 c3                	add    %eax,%ebx
801050ef:	39 da                	cmp    %ebx,%edx
801050f1:	72 15                	jb     80105108 <argptr+0x58>
    return -1;
  *pp = (char*)i;
801050f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050f6:	89 02                	mov    %eax,(%edx)
  return 0;
801050f8:	31 c0                	xor    %eax,%eax
}
801050fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050fd:	5b                   	pop    %ebx
801050fe:	5e                   	pop    %esi
801050ff:	5d                   	pop    %ebp
80105100:	c3                   	ret    
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510d:	eb eb                	jmp    801050fa <argptr+0x4a>
8010510f:	90                   	nop

80105110 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105116:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105119:	50                   	push   %eax
8010511a:	ff 75 08             	pushl  0x8(%ebp)
8010511d:	e8 3e ff ff ff       	call   80105060 <argint>
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	85 c0                	test   %eax,%eax
80105127:	78 17                	js     80105140 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105129:	83 ec 08             	sub    $0x8,%esp
8010512c:	ff 75 0c             	pushl  0xc(%ebp)
8010512f:	ff 75 f4             	pushl  -0xc(%ebp)
80105132:	e8 c9 fe ff ff       	call   80105000 <fetchstr>
80105137:	83 c4 10             	add    $0x10,%esp
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105150 <syscall>:
[SYS_getshmem] sys_getshmem,
};

void
syscall(void)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105155:	e8 96 ea ff ff       	call   80103bf0 <myproc>

  num = curproc->tf->eax;
8010515a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010515d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010515f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105162:	8d 50 ff             	lea    -0x1(%eax),%edx
80105165:	83 fa 1c             	cmp    $0x1c,%edx
80105168:	77 1e                	ja     80105188 <syscall+0x38>
8010516a:	8b 14 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%edx
80105171:	85 d2                	test   %edx,%edx
80105173:	74 13                	je     80105188 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105175:	ff d2                	call   *%edx
80105177:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010517a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010517d:	5b                   	pop    %ebx
8010517e:	5e                   	pop    %esi
8010517f:	5d                   	pop    %ebp
80105180:	c3                   	ret    
80105181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105188:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105189:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010518c:	50                   	push   %eax
8010518d:	ff 73 10             	pushl  0x10(%ebx)
80105190:	68 f1 81 10 80       	push   $0x801081f1
80105195:	e8 c6 b4 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010519a:	8b 43 18             	mov    0x18(%ebx),%eax
8010519d:	83 c4 10             	add    $0x10,%esp
801051a0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801051a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051aa:	5b                   	pop    %ebx
801051ab:	5e                   	pop    %esi
801051ac:	5d                   	pop    %ebp
801051ad:	c3                   	ret    
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051b6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051b9:	83 ec 34             	sub    $0x34,%esp
801051bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051c2:	56                   	push   %esi
801051c3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051ca:	e8 31 d1 ff ff       	call   80102300 <nameiparent>
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	85 c0                	test   %eax,%eax
801051d4:	0f 84 f6 00 00 00    	je     801052d0 <create+0x120>
    return 0;
  ilock(dp);
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	89 c7                	mov    %eax,%edi
801051df:	50                   	push   %eax
801051e0:	e8 ab c8 ff ff       	call   80101a90 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051e5:	83 c4 0c             	add    $0xc,%esp
801051e8:	6a 00                	push   $0x0
801051ea:	56                   	push   %esi
801051eb:	57                   	push   %edi
801051ec:	e8 cf cd ff ff       	call   80101fc0 <dirlookup>
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	85 c0                	test   %eax,%eax
801051f6:	89 c3                	mov    %eax,%ebx
801051f8:	74 56                	je     80105250 <create+0xa0>
    iunlockput(dp);
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	57                   	push   %edi
801051fe:	e8 1d cb ff ff       	call   80101d20 <iunlockput>
    ilock(ip);
80105203:	89 1c 24             	mov    %ebx,(%esp)
80105206:	e8 85 c8 ff ff       	call   80101a90 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010520b:	83 c4 10             	add    $0x10,%esp
8010520e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105213:	75 1b                	jne    80105230 <create+0x80>
80105215:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010521a:	89 d8                	mov    %ebx,%eax
8010521c:	75 12                	jne    80105230 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010521e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105221:	5b                   	pop    %ebx
80105222:	5e                   	pop    %esi
80105223:	5f                   	pop    %edi
80105224:	5d                   	pop    %ebp
80105225:	c3                   	ret    
80105226:	8d 76 00             	lea    0x0(%esi),%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105230:	83 ec 0c             	sub    $0xc,%esp
80105233:	53                   	push   %ebx
80105234:	e8 e7 ca ff ff       	call   80101d20 <iunlockput>
    return 0;
80105239:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010523c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010523f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105241:	5b                   	pop    %ebx
80105242:	5e                   	pop    %esi
80105243:	5f                   	pop    %edi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105250:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105254:	83 ec 08             	sub    $0x8,%esp
80105257:	50                   	push   %eax
80105258:	ff 37                	pushl  (%edi)
8010525a:	e8 c1 c6 ff ff       	call   80101920 <ialloc>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	85 c0                	test   %eax,%eax
80105264:	89 c3                	mov    %eax,%ebx
80105266:	0f 84 cc 00 00 00    	je     80105338 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	50                   	push   %eax
80105270:	e8 1b c8 ff ff       	call   80101a90 <ilock>
  ip->major = major;
80105275:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105279:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010527d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105281:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105285:	b8 01 00 00 00       	mov    $0x1,%eax
8010528a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010528e:	89 1c 24             	mov    %ebx,(%esp)
80105291:	e8 4a c7 ff ff       	call   801019e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105296:	83 c4 10             	add    $0x10,%esp
80105299:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010529e:	74 40                	je     801052e0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801052a0:	83 ec 04             	sub    $0x4,%esp
801052a3:	ff 73 04             	pushl  0x4(%ebx)
801052a6:	56                   	push   %esi
801052a7:	57                   	push   %edi
801052a8:	e8 73 cf ff ff       	call   80102220 <dirlink>
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	85 c0                	test   %eax,%eax
801052b2:	78 77                	js     8010532b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801052b4:	83 ec 0c             	sub    $0xc,%esp
801052b7:	57                   	push   %edi
801052b8:	e8 63 ca ff ff       	call   80101d20 <iunlockput>

  return ip;
801052bd:	83 c4 10             	add    $0x10,%esp
}
801052c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801052c3:	89 d8                	mov    %ebx,%eax
}
801052c5:	5b                   	pop    %ebx
801052c6:	5e                   	pop    %esi
801052c7:	5f                   	pop    %edi
801052c8:	5d                   	pop    %ebp
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801052d0:	31 c0                	xor    %eax,%eax
801052d2:	e9 47 ff ff ff       	jmp    8010521e <create+0x6e>
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801052e0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801052e5:	83 ec 0c             	sub    $0xc,%esp
801052e8:	57                   	push   %edi
801052e9:	e8 f2 c6 ff ff       	call   801019e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052ee:	83 c4 0c             	add    $0xc,%esp
801052f1:	ff 73 04             	pushl  0x4(%ebx)
801052f4:	68 b4 82 10 80       	push   $0x801082b4
801052f9:	53                   	push   %ebx
801052fa:	e8 21 cf ff ff       	call   80102220 <dirlink>
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	85 c0                	test   %eax,%eax
80105304:	78 18                	js     8010531e <create+0x16e>
80105306:	83 ec 04             	sub    $0x4,%esp
80105309:	ff 77 04             	pushl  0x4(%edi)
8010530c:	68 b3 82 10 80       	push   $0x801082b3
80105311:	53                   	push   %ebx
80105312:	e8 09 cf ff ff       	call   80102220 <dirlink>
80105317:	83 c4 10             	add    $0x10,%esp
8010531a:	85 c0                	test   %eax,%eax
8010531c:	79 82                	jns    801052a0 <create+0xf0>
      panic("create dots");
8010531e:	83 ec 0c             	sub    $0xc,%esp
80105321:	68 a7 82 10 80       	push   $0x801082a7
80105326:	e8 45 b0 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010532b:	83 ec 0c             	sub    $0xc,%esp
8010532e:	68 b6 82 10 80       	push   $0x801082b6
80105333:	e8 38 b0 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	68 98 82 10 80       	push   $0x80108298
80105340:	e8 2b b0 ff ff       	call   80100370 <panic>
80105345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105357:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010535a:	89 d3                	mov    %edx,%ebx
8010535c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010535f:	50                   	push   %eax
80105360:	6a 00                	push   $0x0
80105362:	e8 f9 fc ff ff       	call   80105060 <argint>
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	85 c0                	test   %eax,%eax
8010536c:	78 32                	js     801053a0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010536e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105372:	77 2c                	ja     801053a0 <argfd.constprop.0+0x50>
80105374:	e8 77 e8 ff ff       	call   80103bf0 <myproc>
80105379:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010537c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105380:	85 c0                	test   %eax,%eax
80105382:	74 1c                	je     801053a0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105384:	85 f6                	test   %esi,%esi
80105386:	74 02                	je     8010538a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105388:	89 16                	mov    %edx,(%esi)
  if(pf)
8010538a:	85 db                	test   %ebx,%ebx
8010538c:	74 22                	je     801053b0 <argfd.constprop.0+0x60>
    *pf = f;
8010538e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105390:	31 c0                	xor    %eax,%eax
}
80105392:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105395:	5b                   	pop    %ebx
80105396:	5e                   	pop    %esi
80105397:	5d                   	pop    %ebp
80105398:	c3                   	ret    
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801053a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801053a8:	5b                   	pop    %ebx
801053a9:	5e                   	pop    %esi
801053aa:	5d                   	pop    %ebp
801053ab:	c3                   	ret    
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801053b0:	31 c0                	xor    %eax,%eax
801053b2:	eb de                	jmp    80105392 <argfd.constprop.0+0x42>
801053b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801053c0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801053c0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053c1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801053c3:	89 e5                	mov    %esp,%ebp
801053c5:	56                   	push   %esi
801053c6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801053ca:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053cd:	e8 7e ff ff ff       	call   80105350 <argfd.constprop.0>
801053d2:	85 c0                	test   %eax,%eax
801053d4:	78 1a                	js     801053f0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053d6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801053d8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801053db:	e8 10 e8 ff ff       	call   80103bf0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801053e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053e4:	85 d2                	test   %edx,%edx
801053e6:	74 18                	je     80105400 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053e8:	83 c3 01             	add    $0x1,%ebx
801053eb:	83 fb 10             	cmp    $0x10,%ebx
801053ee:	75 f0                	jne    801053e0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801053f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801053f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801053f8:	5b                   	pop    %ebx
801053f9:	5e                   	pop    %esi
801053fa:	5d                   	pop    %ebp
801053fb:	c3                   	ret    
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105400:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	ff 75 f4             	pushl  -0xc(%ebp)
8010540a:	e8 01 be ff ff       	call   80101210 <filedup>
  return fd;
8010540f:	83 c4 10             	add    $0x10,%esp
}
80105412:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105415:	89 d8                	mov    %ebx,%eax
}
80105417:	5b                   	pop    %ebx
80105418:	5e                   	pop    %esi
80105419:	5d                   	pop    %ebp
8010541a:	c3                   	ret    
8010541b:	90                   	nop
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_read>:

int
sys_read(void)
{
80105420:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105421:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105428:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010542b:	e8 20 ff ff ff       	call   80105350 <argfd.constprop.0>
80105430:	85 c0                	test   %eax,%eax
80105432:	78 4c                	js     80105480 <sys_read+0x60>
80105434:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105437:	83 ec 08             	sub    $0x8,%esp
8010543a:	50                   	push   %eax
8010543b:	6a 02                	push   $0x2
8010543d:	e8 1e fc ff ff       	call   80105060 <argint>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	78 37                	js     80105480 <sys_read+0x60>
80105449:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544c:	83 ec 04             	sub    $0x4,%esp
8010544f:	ff 75 f0             	pushl  -0x10(%ebp)
80105452:	50                   	push   %eax
80105453:	6a 01                	push   $0x1
80105455:	e8 56 fc ff ff       	call   801050b0 <argptr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	78 1f                	js     80105480 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105461:	83 ec 04             	sub    $0x4,%esp
80105464:	ff 75 f0             	pushl  -0x10(%ebp)
80105467:	ff 75 f4             	pushl  -0xc(%ebp)
8010546a:	ff 75 ec             	pushl  -0x14(%ebp)
8010546d:	e8 0e bf ff ff       	call   80101380 <fileread>
80105472:	83 c4 10             	add    $0x10,%esp
}
80105475:	c9                   	leave  
80105476:	c3                   	ret    
80105477:	89 f6                	mov    %esi,%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_write>:

int
sys_write(void)
{
80105490:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105491:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105493:	89 e5                	mov    %esp,%ebp
80105495:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105498:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010549b:	e8 b0 fe ff ff       	call   80105350 <argfd.constprop.0>
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 4c                	js     801054f0 <sys_write+0x60>
801054a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054a7:	83 ec 08             	sub    $0x8,%esp
801054aa:	50                   	push   %eax
801054ab:	6a 02                	push   $0x2
801054ad:	e8 ae fb ff ff       	call   80105060 <argint>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 37                	js     801054f0 <sys_write+0x60>
801054b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054bc:	83 ec 04             	sub    $0x4,%esp
801054bf:	ff 75 f0             	pushl  -0x10(%ebp)
801054c2:	50                   	push   %eax
801054c3:	6a 01                	push   $0x1
801054c5:	e8 e6 fb ff ff       	call   801050b0 <argptr>
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	85 c0                	test   %eax,%eax
801054cf:	78 1f                	js     801054f0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801054d1:	83 ec 04             	sub    $0x4,%esp
801054d4:	ff 75 f0             	pushl  -0x10(%ebp)
801054d7:	ff 75 f4             	pushl  -0xc(%ebp)
801054da:	ff 75 ec             	pushl  -0x14(%ebp)
801054dd:	e8 2e bf ff ff       	call   80101410 <filewrite>
801054e2:	83 c4 10             	add    $0x10,%esp
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801054f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_close>:

int
sys_close(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105506:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105509:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010550c:	e8 3f fe ff ff       	call   80105350 <argfd.constprop.0>
80105511:	85 c0                	test   %eax,%eax
80105513:	78 2b                	js     80105540 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105515:	e8 d6 e6 ff ff       	call   80103bf0 <myproc>
8010551a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010551d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105520:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105527:	00 
  fileclose(f);
80105528:	ff 75 f4             	pushl  -0xc(%ebp)
8010552b:	e8 30 bd ff ff       	call   80101260 <fileclose>
  return 0;
80105530:	83 c4 10             	add    $0x10,%esp
80105533:	31 c0                	xor    %eax,%eax
}
80105535:	c9                   	leave  
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <sys_fstat>:

int
sys_fstat(void)
{
80105550:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105551:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105553:	89 e5                	mov    %esp,%ebp
80105555:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105558:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010555b:	e8 f0 fd ff ff       	call   80105350 <argfd.constprop.0>
80105560:	85 c0                	test   %eax,%eax
80105562:	78 2c                	js     80105590 <sys_fstat+0x40>
80105564:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105567:	83 ec 04             	sub    $0x4,%esp
8010556a:	6a 14                	push   $0x14
8010556c:	50                   	push   %eax
8010556d:	6a 01                	push   $0x1
8010556f:	e8 3c fb ff ff       	call   801050b0 <argptr>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	85 c0                	test   %eax,%eax
80105579:	78 15                	js     80105590 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010557b:	83 ec 08             	sub    $0x8,%esp
8010557e:	ff 75 f4             	pushl  -0xc(%ebp)
80105581:	ff 75 f0             	pushl  -0x10(%ebp)
80105584:	e8 a7 bd ff ff       	call   80101330 <filestat>
80105589:	83 c4 10             	add    $0x10,%esp
}
8010558c:	c9                   	leave  
8010558d:	c3                   	ret    
8010558e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105595:	c9                   	leave  
80105596:	c3                   	ret    
80105597:	89 f6                	mov    %esi,%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
801055a5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055a9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055ac:	50                   	push   %eax
801055ad:	6a 00                	push   $0x0
801055af:	e8 5c fb ff ff       	call   80105110 <argstr>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 88 fb 00 00 00    	js     801056ba <sys_link+0x11a>
801055bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055c2:	83 ec 08             	sub    $0x8,%esp
801055c5:	50                   	push   %eax
801055c6:	6a 01                	push   $0x1
801055c8:	e8 43 fb ff ff       	call   80105110 <argstr>
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	85 c0                	test   %eax,%eax
801055d2:	0f 88 e2 00 00 00    	js     801056ba <sys_link+0x11a>
    return -1;

  begin_op();
801055d8:	e8 93 d9 ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801055e3:	e8 f8 cc ff ff       	call   801022e0 <namei>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	89 c3                	mov    %eax,%ebx
801055ef:	0f 84 f3 00 00 00    	je     801056e8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	50                   	push   %eax
801055f9:	e8 92 c4 ff ff       	call   80101a90 <ilock>
  if(ip->type == T_DIR){
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105606:	0f 84 c4 00 00 00    	je     801056d0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010560c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105611:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105614:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105617:	53                   	push   %ebx
80105618:	e8 c3 c3 ff ff       	call   801019e0 <iupdate>
  iunlock(ip);
8010561d:	89 1c 24             	mov    %ebx,(%esp)
80105620:	e8 4b c5 ff ff       	call   80101b70 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105625:	58                   	pop    %eax
80105626:	5a                   	pop    %edx
80105627:	57                   	push   %edi
80105628:	ff 75 d0             	pushl  -0x30(%ebp)
8010562b:	e8 d0 cc ff ff       	call   80102300 <nameiparent>
80105630:	83 c4 10             	add    $0x10,%esp
80105633:	85 c0                	test   %eax,%eax
80105635:	89 c6                	mov    %eax,%esi
80105637:	74 5b                	je     80105694 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	50                   	push   %eax
8010563d:	e8 4e c4 ff ff       	call   80101a90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	8b 03                	mov    (%ebx),%eax
80105647:	39 06                	cmp    %eax,(%esi)
80105649:	75 3d                	jne    80105688 <sys_link+0xe8>
8010564b:	83 ec 04             	sub    $0x4,%esp
8010564e:	ff 73 04             	pushl  0x4(%ebx)
80105651:	57                   	push   %edi
80105652:	56                   	push   %esi
80105653:	e8 c8 cb ff ff       	call   80102220 <dirlink>
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	85 c0                	test   %eax,%eax
8010565d:	78 29                	js     80105688 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010565f:	83 ec 0c             	sub    $0xc,%esp
80105662:	56                   	push   %esi
80105663:	e8 b8 c6 ff ff       	call   80101d20 <iunlockput>
  iput(ip);
80105668:	89 1c 24             	mov    %ebx,(%esp)
8010566b:	e8 50 c5 ff ff       	call   80101bc0 <iput>

  end_op();
80105670:	e8 6b d9 ff ff       	call   80102fe0 <end_op>

  return 0;
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010567a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010567d:	5b                   	pop    %ebx
8010567e:	5e                   	pop    %esi
8010567f:	5f                   	pop    %edi
80105680:	5d                   	pop    %ebp
80105681:	c3                   	ret    
80105682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105688:	83 ec 0c             	sub    $0xc,%esp
8010568b:	56                   	push   %esi
8010568c:	e8 8f c6 ff ff       	call   80101d20 <iunlockput>
    goto bad;
80105691:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105694:	83 ec 0c             	sub    $0xc,%esp
80105697:	53                   	push   %ebx
80105698:	e8 f3 c3 ff ff       	call   80101a90 <ilock>
  ip->nlink--;
8010569d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056a2:	89 1c 24             	mov    %ebx,(%esp)
801056a5:	e8 36 c3 ff ff       	call   801019e0 <iupdate>
  iunlockput(ip);
801056aa:	89 1c 24             	mov    %ebx,(%esp)
801056ad:	e8 6e c6 ff ff       	call   80101d20 <iunlockput>
  end_op();
801056b2:	e8 29 d9 ff ff       	call   80102fe0 <end_op>
  return -1;
801056b7:	83 c4 10             	add    $0x10,%esp
}
801056ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801056bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5f                   	pop    %edi
801056c5:	5d                   	pop    %ebp
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 47 c6 ff ff       	call   80101d20 <iunlockput>
    end_op();
801056d9:	e8 02 d9 ff ff       	call   80102fe0 <end_op>
    return -1;
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e6:	eb 92                	jmp    8010567a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801056e8:	e8 f3 d8 ff ff       	call   80102fe0 <end_op>
    return -1;
801056ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f2:	eb 86                	jmp    8010567a <sys_link+0xda>
801056f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105700 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
80105705:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105706:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105709:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 fc f9 ff ff       	call   80105110 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 82 01 00 00    	js     801058a1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010571f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105722:	e8 49 d8 ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	53                   	push   %ebx
8010572b:	ff 75 c0             	pushl  -0x40(%ebp)
8010572e:	e8 cd cb ff ff       	call   80102300 <nameiparent>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010573b:	0f 84 6a 01 00 00    	je     801058ab <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105741:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	56                   	push   %esi
80105748:	e8 43 c3 ff ff       	call   80101a90 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010574d:	58                   	pop    %eax
8010574e:	5a                   	pop    %edx
8010574f:	68 b4 82 10 80       	push   $0x801082b4
80105754:	53                   	push   %ebx
80105755:	e8 46 c8 ff ff       	call   80101fa0 <namecmp>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 84 fc 00 00 00    	je     80105861 <sys_unlink+0x161>
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	68 b3 82 10 80       	push   $0x801082b3
8010576d:	53                   	push   %ebx
8010576e:	e8 2d c8 ff ff       	call   80101fa0 <namecmp>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	0f 84 e3 00 00 00    	je     80105861 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010577e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105781:	83 ec 04             	sub    $0x4,%esp
80105784:	50                   	push   %eax
80105785:	53                   	push   %ebx
80105786:	56                   	push   %esi
80105787:	e8 34 c8 ff ff       	call   80101fc0 <dirlookup>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	85 c0                	test   %eax,%eax
80105791:	89 c3                	mov    %eax,%ebx
80105793:	0f 84 c8 00 00 00    	je     80105861 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 ee c2 ff ff       	call   80101a90 <ilock>

  if(ip->nlink < 1)
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057aa:	0f 8e 24 01 00 00    	jle    801058d4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801057b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057b5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801057b8:	74 66                	je     80105820 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801057ba:	83 ec 04             	sub    $0x4,%esp
801057bd:	6a 10                	push   $0x10
801057bf:	6a 00                	push   $0x0
801057c1:	56                   	push   %esi
801057c2:	e8 89 f5 ff ff       	call   80104d50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057c7:	6a 10                	push   $0x10
801057c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057cc:	56                   	push   %esi
801057cd:	ff 75 b4             	pushl  -0x4c(%ebp)
801057d0:	e8 9b c6 ff ff       	call   80101e70 <writei>
801057d5:	83 c4 20             	add    $0x20,%esp
801057d8:	83 f8 10             	cmp    $0x10,%eax
801057db:	0f 85 e6 00 00 00    	jne    801058c7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801057e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e6:	0f 84 9c 00 00 00    	je     80105888 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801057ec:	83 ec 0c             	sub    $0xc,%esp
801057ef:	ff 75 b4             	pushl  -0x4c(%ebp)
801057f2:	e8 29 c5 ff ff       	call   80101d20 <iunlockput>

  ip->nlink--;
801057f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057fc:	89 1c 24             	mov    %ebx,(%esp)
801057ff:	e8 dc c1 ff ff       	call   801019e0 <iupdate>
  iunlockput(ip);
80105804:	89 1c 24             	mov    %ebx,(%esp)
80105807:	e8 14 c5 ff ff       	call   80101d20 <iunlockput>

  end_op();
8010580c:	e8 cf d7 ff ff       	call   80102fe0 <end_op>

  return 0;
80105811:	83 c4 10             	add    $0x10,%esp
80105814:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105816:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105819:	5b                   	pop    %ebx
8010581a:	5e                   	pop    %esi
8010581b:	5f                   	pop    %edi
8010581c:	5d                   	pop    %ebp
8010581d:	c3                   	ret    
8010581e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105820:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105824:	76 94                	jbe    801057ba <sys_unlink+0xba>
80105826:	bf 20 00 00 00       	mov    $0x20,%edi
8010582b:	eb 0f                	jmp    8010583c <sys_unlink+0x13c>
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
80105830:	83 c7 10             	add    $0x10,%edi
80105833:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105836:	0f 83 7e ff ff ff    	jae    801057ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010583c:	6a 10                	push   $0x10
8010583e:	57                   	push   %edi
8010583f:	56                   	push   %esi
80105840:	53                   	push   %ebx
80105841:	e8 2a c5 ff ff       	call   80101d70 <readi>
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	83 f8 10             	cmp    $0x10,%eax
8010584c:	75 6c                	jne    801058ba <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010584e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105853:	74 db                	je     80105830 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105855:	83 ec 0c             	sub    $0xc,%esp
80105858:	53                   	push   %ebx
80105859:	e8 c2 c4 ff ff       	call   80101d20 <iunlockput>
    goto bad;
8010585e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105861:	83 ec 0c             	sub    $0xc,%esp
80105864:	ff 75 b4             	pushl  -0x4c(%ebp)
80105867:	e8 b4 c4 ff ff       	call   80101d20 <iunlockput>
  end_op();
8010586c:	e8 6f d7 ff ff       	call   80102fe0 <end_op>
  return -1;
80105871:	83 c4 10             	add    $0x10,%esp
}
80105874:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010587c:	5b                   	pop    %ebx
8010587d:	5e                   	pop    %esi
8010587e:	5f                   	pop    %edi
8010587f:	5d                   	pop    %ebp
80105880:	c3                   	ret    
80105881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105888:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010588b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010588e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105893:	50                   	push   %eax
80105894:	e8 47 c1 ff ff       	call   801019e0 <iupdate>
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	e9 4b ff ff ff       	jmp    801057ec <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801058a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a6:	e9 6b ff ff ff       	jmp    80105816 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801058ab:	e8 30 d7 ff ff       	call   80102fe0 <end_op>
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	e9 5c ff ff ff       	jmp    80105816 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801058ba:	83 ec 0c             	sub    $0xc,%esp
801058bd:	68 d8 82 10 80       	push   $0x801082d8
801058c2:	e8 a9 aa ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801058c7:	83 ec 0c             	sub    $0xc,%esp
801058ca:	68 ea 82 10 80       	push   $0x801082ea
801058cf:	e8 9c aa ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801058d4:	83 ec 0c             	sub    $0xc,%esp
801058d7:	68 c6 82 10 80       	push   $0x801082c6
801058dc:	e8 8f aa ff ff       	call   80100370 <panic>
801058e1:	eb 0d                	jmp    801058f0 <sys_open>
801058e3:	90                   	nop
801058e4:	90                   	nop
801058e5:	90                   	nop
801058e6:	90                   	nop
801058e7:	90                   	nop
801058e8:	90                   	nop
801058e9:	90                   	nop
801058ea:	90                   	nop
801058eb:	90                   	nop
801058ec:	90                   	nop
801058ed:	90                   	nop
801058ee:	90                   	nop
801058ef:	90                   	nop

801058f0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
801058f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801058f9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058fc:	50                   	push   %eax
801058fd:	6a 00                	push   $0x0
801058ff:	e8 0c f8 ff ff       	call   80105110 <argstr>
80105904:	83 c4 10             	add    $0x10,%esp
80105907:	85 c0                	test   %eax,%eax
80105909:	0f 88 9e 00 00 00    	js     801059ad <sys_open+0xbd>
8010590f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105912:	83 ec 08             	sub    $0x8,%esp
80105915:	50                   	push   %eax
80105916:	6a 01                	push   $0x1
80105918:	e8 43 f7 ff ff       	call   80105060 <argint>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	0f 88 85 00 00 00    	js     801059ad <sys_open+0xbd>
    return -1;

  begin_op();
80105928:	e8 43 d6 ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
8010592d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105931:	0f 85 89 00 00 00    	jne    801059c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105937:	83 ec 0c             	sub    $0xc,%esp
8010593a:	ff 75 e0             	pushl  -0x20(%ebp)
8010593d:	e8 9e c9 ff ff       	call   801022e0 <namei>
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	85 c0                	test   %eax,%eax
80105947:	89 c6                	mov    %eax,%esi
80105949:	0f 84 8e 00 00 00    	je     801059dd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010594f:	83 ec 0c             	sub    $0xc,%esp
80105952:	50                   	push   %eax
80105953:	e8 38 c1 ff ff       	call   80101a90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105958:	83 c4 10             	add    $0x10,%esp
8010595b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105960:	0f 84 d2 00 00 00    	je     80105a38 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105966:	e8 35 b8 ff ff       	call   801011a0 <filealloc>
8010596b:	85 c0                	test   %eax,%eax
8010596d:	89 c7                	mov    %eax,%edi
8010596f:	74 2b                	je     8010599c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105971:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105973:	e8 78 e2 ff ff       	call   80103bf0 <myproc>
80105978:	90                   	nop
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105980:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105984:	85 d2                	test   %edx,%edx
80105986:	74 68                	je     801059f0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105988:	83 c3 01             	add    $0x1,%ebx
8010598b:	83 fb 10             	cmp    $0x10,%ebx
8010598e:	75 f0                	jne    80105980 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	57                   	push   %edi
80105994:	e8 c7 b8 ff ff       	call   80101260 <fileclose>
80105999:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	56                   	push   %esi
801059a0:	e8 7b c3 ff ff       	call   80101d20 <iunlockput>
    end_op();
801059a5:	e8 36 d6 ff ff       	call   80102fe0 <end_op>
    return -1;
801059aa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801059ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801059b5:	5b                   	pop    %ebx
801059b6:	5e                   	pop    %esi
801059b7:	5f                   	pop    %edi
801059b8:	5d                   	pop    %ebp
801059b9:	c3                   	ret    
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059c6:	31 c9                	xor    %ecx,%ecx
801059c8:	6a 00                	push   $0x0
801059ca:	ba 02 00 00 00       	mov    $0x2,%edx
801059cf:	e8 dc f7 ff ff       	call   801051b0 <create>
    if(ip == 0){
801059d4:	83 c4 10             	add    $0x10,%esp
801059d7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801059d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059db:	75 89                	jne    80105966 <sys_open+0x76>
      end_op();
801059dd:	e8 fe d5 ff ff       	call   80102fe0 <end_op>
      return -1;
801059e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e7:	eb 43                	jmp    80105a2c <sys_open+0x13c>
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059f0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801059f3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059f7:	56                   	push   %esi
801059f8:	e8 73 c1 ff ff       	call   80101b70 <iunlock>
  end_op();
801059fd:	e8 de d5 ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
80105a02:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a0b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105a0e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105a11:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105a18:	89 d0                	mov    %edx,%eax
80105a1a:	83 e0 01             	and    $0x1,%eax
80105a1d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a20:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a23:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a26:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105a2a:	89 d8                	mov    %ebx,%eax
}
80105a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2f:	5b                   	pop    %ebx
80105a30:	5e                   	pop    %esi
80105a31:	5f                   	pop    %edi
80105a32:	5d                   	pop    %ebp
80105a33:	c3                   	ret    
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a3b:	85 c9                	test   %ecx,%ecx
80105a3d:	0f 84 23 ff ff ff    	je     80105966 <sys_open+0x76>
80105a43:	e9 54 ff ff ff       	jmp    8010599c <sys_open+0xac>
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a56:	e8 15 d5 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a5e:	83 ec 08             	sub    $0x8,%esp
80105a61:	50                   	push   %eax
80105a62:	6a 00                	push   $0x0
80105a64:	e8 a7 f6 ff ff       	call   80105110 <argstr>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	78 30                	js     80105aa0 <sys_mkdir+0x50>
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a76:	31 c9                	xor    %ecx,%ecx
80105a78:	6a 00                	push   $0x0
80105a7a:	ba 01 00 00 00       	mov    $0x1,%edx
80105a7f:	e8 2c f7 ff ff       	call   801051b0 <create>
80105a84:	83 c4 10             	add    $0x10,%esp
80105a87:	85 c0                	test   %eax,%eax
80105a89:	74 15                	je     80105aa0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a8b:	83 ec 0c             	sub    $0xc,%esp
80105a8e:	50                   	push   %eax
80105a8f:	e8 8c c2 ff ff       	call   80101d20 <iunlockput>
  end_op();
80105a94:	e8 47 d5 ff ff       	call   80102fe0 <end_op>
  return 0;
80105a99:	83 c4 10             	add    $0x10,%esp
80105a9c:	31 c0                	xor    %eax,%eax
}
80105a9e:	c9                   	leave  
80105a9f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105aa0:	e8 3b d5 ff ff       	call   80102fe0 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_mknod>:

int
sys_mknod(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ab6:	e8 b5 d4 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105abb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105abe:	83 ec 08             	sub    $0x8,%esp
80105ac1:	50                   	push   %eax
80105ac2:	6a 00                	push   $0x0
80105ac4:	e8 47 f6 ff ff       	call   80105110 <argstr>
80105ac9:	83 c4 10             	add    $0x10,%esp
80105acc:	85 c0                	test   %eax,%eax
80105ace:	78 60                	js     80105b30 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad3:	83 ec 08             	sub    $0x8,%esp
80105ad6:	50                   	push   %eax
80105ad7:	6a 01                	push   $0x1
80105ad9:	e8 82 f5 ff ff       	call   80105060 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	85 c0                	test   %eax,%eax
80105ae3:	78 4b                	js     80105b30 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105ae5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae8:	83 ec 08             	sub    $0x8,%esp
80105aeb:	50                   	push   %eax
80105aec:	6a 02                	push   $0x2
80105aee:	e8 6d f5 ff ff       	call   80105060 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	78 36                	js     80105b30 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105afa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105afe:	83 ec 0c             	sub    $0xc,%esp
80105b01:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b05:	ba 03 00 00 00       	mov    $0x3,%edx
80105b0a:	50                   	push   %eax
80105b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105b0e:	e8 9d f6 ff ff       	call   801051b0 <create>
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	85 c0                	test   %eax,%eax
80105b18:	74 16                	je     80105b30 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b1a:	83 ec 0c             	sub    $0xc,%esp
80105b1d:	50                   	push   %eax
80105b1e:	e8 fd c1 ff ff       	call   80101d20 <iunlockput>
  end_op();
80105b23:	e8 b8 d4 ff ff       	call   80102fe0 <end_op>
  return 0;
80105b28:	83 c4 10             	add    $0x10,%esp
80105b2b:	31 c0                	xor    %eax,%eax
}
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    
80105b2f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105b30:	e8 ab d4 ff ff       	call   80102fe0 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105b3a:	c9                   	leave  
80105b3b:	c3                   	ret    
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_chdir>:

int
sys_chdir(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	56                   	push   %esi
80105b44:	53                   	push   %ebx
80105b45:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b48:	e8 a3 e0 ff ff       	call   80103bf0 <myproc>
80105b4d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b4f:	e8 1c d4 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b57:	83 ec 08             	sub    $0x8,%esp
80105b5a:	50                   	push   %eax
80105b5b:	6a 00                	push   $0x0
80105b5d:	e8 ae f5 ff ff       	call   80105110 <argstr>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 77                	js     80105be0 <sys_chdir+0xa0>
80105b69:	83 ec 0c             	sub    $0xc,%esp
80105b6c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b6f:	e8 6c c7 ff ff       	call   801022e0 <namei>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	85 c0                	test   %eax,%eax
80105b79:	89 c3                	mov    %eax,%ebx
80105b7b:	74 63                	je     80105be0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	50                   	push   %eax
80105b81:	e8 0a bf ff ff       	call   80101a90 <ilock>
  if(ip->type != T_DIR){
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b8e:	75 30                	jne    80105bc0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	53                   	push   %ebx
80105b94:	e8 d7 bf ff ff       	call   80101b70 <iunlock>
  iput(curproc->cwd);
80105b99:	58                   	pop    %eax
80105b9a:	ff 76 68             	pushl  0x68(%esi)
80105b9d:	e8 1e c0 ff ff       	call   80101bc0 <iput>
  end_op();
80105ba2:	e8 39 d4 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
80105ba7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	31 c0                	xor    %eax,%eax
}
80105baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bb2:	5b                   	pop    %ebx
80105bb3:	5e                   	pop    %esi
80105bb4:	5d                   	pop    %ebp
80105bb5:	c3                   	ret    
80105bb6:	8d 76 00             	lea    0x0(%esi),%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	53                   	push   %ebx
80105bc4:	e8 57 c1 ff ff       	call   80101d20 <iunlockput>
    end_op();
80105bc9:	e8 12 d4 ff ff       	call   80102fe0 <end_op>
    return -1;
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd6:	eb d7                	jmp    80105baf <sys_chdir+0x6f>
80105bd8:	90                   	nop
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105be0:	e8 fb d3 ff ff       	call   80102fe0 <end_op>
    return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bea:	eb c3                	jmp    80105baf <sys_chdir+0x6f>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bf6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105bfc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c02:	50                   	push   %eax
80105c03:	6a 00                	push   $0x0
80105c05:	e8 06 f5 ff ff       	call   80105110 <argstr>
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	85 c0                	test   %eax,%eax
80105c0f:	78 7f                	js     80105c90 <sys_exec+0xa0>
80105c11:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c17:	83 ec 08             	sub    $0x8,%esp
80105c1a:	50                   	push   %eax
80105c1b:	6a 01                	push   $0x1
80105c1d:	e8 3e f4 ff ff       	call   80105060 <argint>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 67                	js     80105c90 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c29:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c2f:	83 ec 04             	sub    $0x4,%esp
80105c32:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105c38:	68 80 00 00 00       	push   $0x80
80105c3d:	6a 00                	push   $0x0
80105c3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c45:	50                   	push   %eax
80105c46:	31 db                	xor    %ebx,%ebx
80105c48:	e8 03 f1 ff ff       	call   80104d50 <memset>
80105c4d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c50:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c56:	83 ec 08             	sub    $0x8,%esp
80105c59:	57                   	push   %edi
80105c5a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105c5d:	50                   	push   %eax
80105c5e:	e8 5d f3 ff ff       	call   80104fc0 <fetchint>
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	85 c0                	test   %eax,%eax
80105c68:	78 26                	js     80105c90 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105c6a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c70:	85 c0                	test   %eax,%eax
80105c72:	74 2c                	je     80105ca0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	56                   	push   %esi
80105c78:	50                   	push   %eax
80105c79:	e8 82 f3 ff ff       	call   80105000 <fetchstr>
80105c7e:	83 c4 10             	add    $0x10,%esp
80105c81:	85 c0                	test   %eax,%eax
80105c83:	78 0b                	js     80105c90 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105c85:	83 c3 01             	add    $0x1,%ebx
80105c88:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105c8b:	83 fb 20             	cmp    $0x20,%ebx
80105c8e:	75 c0                	jne    80105c50 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105c93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105c98:	5b                   	pop    %ebx
80105c99:	5e                   	pop    %esi
80105c9a:	5f                   	pop    %edi
80105c9b:	5d                   	pop    %ebp
80105c9c:	c3                   	ret    
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105ca0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ca6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105ca9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cb0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105cb4:	50                   	push   %eax
80105cb5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105cbb:	e8 30 ad ff ff       	call   801009f0 <exec>
80105cc0:	83 c4 10             	add    $0x10,%esp
}
80105cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cc6:	5b                   	pop    %ebx
80105cc7:	5e                   	pop    %esi
80105cc8:	5f                   	pop    %edi
80105cc9:	5d                   	pop    %ebp
80105cca:	c3                   	ret    
80105ccb:	90                   	nop
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_exec2>:


int
sys_exec2(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	56                   	push   %esi
80105cd5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cd6:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
80105cdc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ce2:	50                   	push   %eax
80105ce3:	6a 00                	push   $0x0
80105ce5:	e8 26 f4 ff ff       	call   80105110 <argstr>
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	85 c0                	test   %eax,%eax
80105cef:	78 7f                	js     80105d70 <sys_exec2+0xa0>
80105cf1:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105cf7:	83 ec 08             	sub    $0x8,%esp
80105cfa:	50                   	push   %eax
80105cfb:	6a 01                	push   $0x1
80105cfd:	e8 5e f3 ff ff       	call   80105060 <argint>
80105d02:	83 c4 10             	add    $0x10,%esp
80105d05:	85 c0                	test   %eax,%eax
80105d07:	78 67                	js     80105d70 <sys_exec2+0xa0>
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
80105d09:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d0f:	83 ec 04             	sub    $0x4,%esp
80105d12:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105d18:	68 80 00 00 00       	push   $0x80
80105d1d:	6a 00                	push   $0x0
80105d1f:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105d25:	50                   	push   %eax
80105d26:	31 db                	xor    %ebx,%ebx
80105d28:	e8 23 f0 ff ff       	call   80104d50 <memset>
80105d2d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d30:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105d36:	83 ec 08             	sub    $0x8,%esp
80105d39:	57                   	push   %edi
80105d3a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105d3d:	50                   	push   %eax
80105d3e:	e8 7d f2 ff ff       	call   80104fc0 <fetchint>
80105d43:	83 c4 10             	add    $0x10,%esp
80105d46:	85 c0                	test   %eax,%eax
80105d48:	78 26                	js     80105d70 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
80105d4a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d50:	85 c0                	test   %eax,%eax
80105d52:	74 2c                	je     80105d80 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d54:	83 ec 08             	sub    $0x8,%esp
80105d57:	56                   	push   %esi
80105d58:	50                   	push   %eax
80105d59:	e8 a2 f2 ff ff       	call   80105000 <fetchstr>
80105d5e:	83 c4 10             	add    $0x10,%esp
80105d61:	85 c0                	test   %eax,%eax
80105d63:	78 0b                	js     80105d70 <sys_exec2+0xa0>
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105d65:	83 c3 01             	add    $0x1,%ebx
80105d68:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105d6b:	83 fb 20             	cmp    $0x20,%ebx
80105d6e:	75 c0                	jne    80105d30 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105d73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105d78:	5b                   	pop    %ebx
80105d79:	5e                   	pop    %esi
80105d7a:	5f                   	pop    %edi
80105d7b:	5d                   	pop    %ebp
80105d7c:	c3                   	ret    
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105d80:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d86:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105d89:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d90:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105d94:	50                   	push   %eax
80105d95:	6a 02                	push   $0x2
80105d97:	e8 c4 f2 ff ff       	call   80105060 <argint>
80105d9c:	83 c4 10             	add    $0x10,%esp
80105d9f:	85 c0                	test   %eax,%eax
80105da1:	78 cd                	js     80105d70 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105da3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105da9:	83 ec 04             	sub    $0x4,%esp
80105dac:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105db2:	50                   	push   %eax
80105db3:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105db9:	e8 d2 af ff ff       	call   80100d90 <exec2>
80105dbe:	83 c4 10             	add    $0x10,%esp
}
80105dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc4:	5b                   	pop    %ebx
80105dc5:	5e                   	pop    %esi
80105dc6:	5f                   	pop    %edi
80105dc7:	5d                   	pop    %ebp
80105dc8:	c3                   	ret    
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <sys_pipe>:

int
sys_pipe(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dd6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105dd9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ddc:	6a 08                	push   $0x8
80105dde:	50                   	push   %eax
80105ddf:	6a 00                	push   $0x0
80105de1:	e8 ca f2 ff ff       	call   801050b0 <argptr>
80105de6:	83 c4 10             	add    $0x10,%esp
80105de9:	85 c0                	test   %eax,%eax
80105deb:	78 4a                	js     80105e37 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ded:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df0:	83 ec 08             	sub    $0x8,%esp
80105df3:	50                   	push   %eax
80105df4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105df7:	50                   	push   %eax
80105df8:	e8 13 d8 ff ff       	call   80103610 <pipealloc>
80105dfd:	83 c4 10             	add    $0x10,%esp
80105e00:	85 c0                	test   %eax,%eax
80105e02:	78 33                	js     80105e37 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e04:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e06:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e09:	e8 e2 dd ff ff       	call   80103bf0 <myproc>
80105e0e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105e10:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e14:	85 f6                	test   %esi,%esi
80105e16:	74 30                	je     80105e48 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e18:	83 c3 01             	add    $0x1,%ebx
80105e1b:	83 fb 10             	cmp    $0x10,%ebx
80105e1e:	75 f0                	jne    80105e10 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e20:	83 ec 0c             	sub    $0xc,%esp
80105e23:	ff 75 e0             	pushl  -0x20(%ebp)
80105e26:	e8 35 b4 ff ff       	call   80101260 <fileclose>
    fileclose(wf);
80105e2b:	58                   	pop    %eax
80105e2c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e2f:	e8 2c b4 ff ff       	call   80101260 <fileclose>
    return -1;
80105e34:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105e3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e3f:	5b                   	pop    %ebx
80105e40:	5e                   	pop    %esi
80105e41:	5f                   	pop    %edi
80105e42:	5d                   	pop    %ebp
80105e43:	c3                   	ret    
80105e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e48:	8d 73 08             	lea    0x8(%ebx),%esi
80105e4b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e4f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e52:	e8 99 dd ff ff       	call   80103bf0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105e57:	31 d2                	xor    %edx,%edx
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e64:	85 c9                	test   %ecx,%ecx
80105e66:	74 18                	je     80105e80 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e68:	83 c2 01             	add    $0x1,%edx
80105e6b:	83 fa 10             	cmp    $0x10,%edx
80105e6e:	75 f0                	jne    80105e60 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105e70:	e8 7b dd ff ff       	call   80103bf0 <myproc>
80105e75:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e7c:	00 
80105e7d:	eb a1                	jmp    80105e20 <sys_pipe+0x50>
80105e7f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e80:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105e84:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e87:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e8c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105e92:	31 c0                	xor    %eax,%eax
}
80105e94:	5b                   	pop    %ebx
80105e95:	5e                   	pop    %esi
80105e96:	5f                   	pop    %edi
80105e97:	5d                   	pop    %ebp
80105e98:	c3                   	ret    
80105e99:	66 90                	xchg   %ax,%ax
80105e9b:	66 90                	xchg   %ax,%ax
80105e9d:	66 90                	xchg   %ax,%ax
80105e9f:	90                   	nop

80105ea0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ea3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ea4:	e9 f7 de ff ff       	jmp    80103da0 <fork>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_exit>:
}

int
sys_exit(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105eb6:	e8 15 e2 ff ff       	call   801040d0 <exit>
  return 0;  // not reached
}
80105ebb:	31 c0                	xor    %eax,%eax
80105ebd:	c9                   	leave  
80105ebe:	c3                   	ret    
80105ebf:	90                   	nop

80105ec0 <sys_wait>:

int
sys_wait(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ec3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105ec4:	e9 47 e8 ff ff       	jmp    80104710 <wait>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <sys_kill>:
}

int
sys_kill(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ed6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed9:	50                   	push   %eax
80105eda:	6a 00                	push   $0x0
80105edc:	e8 7f f1 ff ff       	call   80105060 <argint>
80105ee1:	83 c4 10             	add    $0x10,%esp
80105ee4:	85 c0                	test   %eax,%eax
80105ee6:	78 18                	js     80105f00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ee8:	83 ec 0c             	sub    $0xc,%esp
80105eeb:	ff 75 f4             	pushl  -0xc(%ebp)
80105eee:	e8 7d e9 ff ff       	call   80104870 <kill>
80105ef3:	83 c4 10             	add    $0x10,%esp
}
80105ef6:	c9                   	leave  
80105ef7:	c3                   	ret    
80105ef8:	90                   	nop
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105f05:	c9                   	leave  
80105f06:	c3                   	ret    
80105f07:	89 f6                	mov    %esi,%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f10 <sys_getpid>:

int
sys_getpid(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f16:	e8 d5 dc ff ff       	call   80103bf0 <myproc>
80105f1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f1e:	c9                   	leave  
80105f1f:	c3                   	ret    

80105f20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105f27:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f2a:	50                   	push   %eax
80105f2b:	6a 00                	push   $0x0
80105f2d:	e8 2e f1 ff ff       	call   80105060 <argint>
80105f32:	83 c4 10             	add    $0x10,%esp
80105f35:	85 c0                	test   %eax,%eax
80105f37:	78 27                	js     80105f60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f39:	e8 b2 dc ff ff       	call   80103bf0 <myproc>
  if(growproc(n) < 0)
80105f3e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105f41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f43:	ff 75 f4             	pushl  -0xc(%ebp)
80105f46:	e8 c5 dd ff ff       	call   80103d10 <growproc>
80105f4b:	83 c4 10             	add    $0x10,%esp
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	78 0e                	js     80105f60 <sys_sbrk+0x40>
    return -1;
  return addr;
80105f52:	89 d8                	mov    %ebx,%eax
}
80105f54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f57:	c9                   	leave  
80105f58:	c3                   	ret    
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f65:	eb ed                	jmp    80105f54 <sys_sbrk+0x34>
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	53                   	push   %ebx
80105f74:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105f77:	e8 74 dc ff ff       	call   80103bf0 <myproc>
80105f7c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105f83:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105f86:	e8 65 dc ff ff       	call   80103bf0 <myproc>
80105f8b:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105f92:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f98:	83 ec 08             	sub    $0x8,%esp
80105f9b:	50                   	push   %eax
80105f9c:	6a 00                	push   $0x0
80105f9e:	e8 bd f0 ff ff       	call   80105060 <argint>
80105fa3:	83 c4 10             	add    $0x10,%esp
80105fa6:	85 c0                	test   %eax,%eax
80105fa8:	0f 88 89 00 00 00    	js     80106037 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105fae:	83 ec 0c             	sub    $0xc,%esp
80105fb1:	68 60 64 11 80       	push   $0x80116460
80105fb6:	e8 95 ec ff ff       	call   80104c50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fbe:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105fc1:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105fc7:	85 d2                	test   %edx,%edx
80105fc9:	75 26                	jne    80105ff1 <sys_sleep+0x81>
80105fcb:	eb 53                	jmp    80106020 <sys_sleep+0xb0>
80105fcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fd0:	83 ec 08             	sub    $0x8,%esp
80105fd3:	68 60 64 11 80       	push   $0x80116460
80105fd8:	68 a0 6c 11 80       	push   $0x80116ca0
80105fdd:	e8 6e e6 ff ff       	call   80104650 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fe2:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80105fe7:	83 c4 10             	add    $0x10,%esp
80105fea:	29 d8                	sub    %ebx,%eax
80105fec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fef:	73 2f                	jae    80106020 <sys_sleep+0xb0>
    if(myproc()->killed){
80105ff1:	e8 fa db ff ff       	call   80103bf0 <myproc>
80105ff6:	8b 40 24             	mov    0x24(%eax),%eax
80105ff9:	85 c0                	test   %eax,%eax
80105ffb:	74 d3                	je     80105fd0 <sys_sleep+0x60>
      release(&tickslock);
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	68 60 64 11 80       	push   $0x80116460
80106005:	e8 f6 ec ff ff       	call   80104d00 <release>
      return -1;
8010600a:	83 c4 10             	add    $0x10,%esp
8010600d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80106012:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106015:	c9                   	leave  
80106016:	c3                   	ret    
80106017:	89 f6                	mov    %esi,%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106020:	83 ec 0c             	sub    $0xc,%esp
80106023:	68 60 64 11 80       	push   $0x80116460
80106028:	e8 d3 ec ff ff       	call   80104d00 <release>
  return 0;
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	31 c0                	xor    %eax,%eax
}
80106032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106035:	c9                   	leave  
80106036:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80106037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603c:	eb d4                	jmp    80106012 <sys_sleep+0xa2>
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	53                   	push   %ebx
80106044:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106047:	68 60 64 11 80       	push   $0x80116460
8010604c:	e8 ff eb ff ff       	call   80104c50 <acquire>
  xticks = ticks;
80106051:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80106057:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
8010605e:	e8 9d ec ff ff       	call   80104d00 <release>
  return xticks;
}
80106063:	89 d8                	mov    %ebx,%eax
80106065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106068:	c9                   	leave  
80106069:	c3                   	ret    
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106070 <sys_yield>:

void 
sys_yield()
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80106076:	e8 75 db ff ff       	call   80103bf0 <myproc>
8010607b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106082:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
80106085:	e8 66 db ff ff       	call   80103bf0 <myproc>
8010608a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80106091:	00 00 00 
  yield();
}
80106094:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
80106095:	e9 66 e1 ff ff       	jmp    80104200 <yield>
8010609a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060a0 <sys_getlev>:
}

int             
sys_getlev(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
  return getlev();
}
801060a3:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
801060a4:	e9 a7 e1 ff ff       	jmp    80104250 <getlev>
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
801060b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060b9:	50                   	push   %eax
801060ba:	6a 00                	push   $0x0
801060bc:	e8 9f ef ff ff       	call   80105060 <argint>
801060c1:	83 c4 10             	add    $0x10,%esp
801060c4:	85 c0                	test   %eax,%eax
801060c6:	78 28                	js     801060f0 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
801060c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060cb:	83 ec 08             	sub    $0x8,%esp
801060ce:	50                   	push   %eax
801060cf:	6a 01                	push   $0x1
801060d1:	e8 8a ef ff ff       	call   80105060 <argint>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	78 23                	js     80106100 <sys_setpriority+0x50>
	return setpriority(pid,priority);
801060dd:	83 ec 08             	sub    $0x8,%esp
801060e0:	ff 75 f4             	pushl  -0xc(%ebp)
801060e3:	ff 75 f0             	pushl  -0x10(%ebp)
801060e6:	e8 a5 e4 ff ff       	call   80104590 <setpriority>
801060eb:	83 c4 10             	add    $0x10,%esp
}
801060ee:	c9                   	leave  
801060ef:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
801060f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
801060f5:	c9                   	leave  
801060f6:	c3                   	ret    
801060f7:	89 f6                	mov    %esi,%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
80106100:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
80106105:	c9                   	leave  
80106106:	c3                   	ret    
80106107:	89 f6                	mov    %esi,%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106110 <sys_getadmin>:


int
sys_getadmin(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80106116:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106119:	50                   	push   %eax
8010611a:	6a 00                	push   $0x0
8010611c:	e8 ef ef ff ff       	call   80105110 <argstr>
80106121:	83 c4 10             	add    $0x10,%esp
80106124:	85 c0                	test   %eax,%eax
80106126:	78 18                	js     80106140 <sys_getadmin+0x30>
  return getadmin(student_number);
80106128:	83 ec 0c             	sub    $0xc,%esp
8010612b:	ff 75 f4             	pushl  -0xc(%ebp)
8010612e:	e8 4d e1 ff ff       	call   80104280 <getadmin>
80106133:	83 c4 10             	add    $0x10,%esp
}
80106136:	c9                   	leave  
80106137:	c3                   	ret    
80106138:	90                   	nop
80106139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106150 <sys_setmemorylimit>:

int
sys_setmemorylimit(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 20             	sub    $0x20,%esp
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80106156:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106159:	50                   	push   %eax
8010615a:	6a 00                	push   $0x0
8010615c:	e8 ff ee ff ff       	call   80105060 <argint>
80106161:	83 c4 10             	add    $0x10,%esp
80106164:	85 c0                	test   %eax,%eax
80106166:	78 28                	js     80106190 <sys_setmemorylimit+0x40>
80106168:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010616b:	83 ec 08             	sub    $0x8,%esp
8010616e:	50                   	push   %eax
8010616f:	6a 01                	push   $0x1
80106171:	e8 ea ee ff ff       	call   80105060 <argint>
80106176:	83 c4 10             	add    $0x10,%esp
80106179:	85 c0                	test   %eax,%eax
8010617b:	78 13                	js     80106190 <sys_setmemorylimit+0x40>
  return setmemorylimit(pid,limit);
8010617d:	83 ec 08             	sub    $0x8,%esp
80106180:	ff 75 f4             	pushl  -0xc(%ebp)
80106183:	ff 75 f0             	pushl  -0x10(%ebp)
80106186:	e8 75 e1 ff ff       	call   80104300 <setmemorylimit>
8010618b:	83 c4 10             	add    $0x10,%esp
}
8010618e:	c9                   	leave  
8010618f:	c3                   	ret    

int
sys_setmemorylimit(void)
{
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80106190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return setmemorylimit(pid,limit);
}
80106195:	c9                   	leave  
80106196:	c3                   	ret    
80106197:	89 f6                	mov    %esi,%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061a0 <sys_list>:

int
sys_list(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
  return list();
}
801061a3:	5d                   	pop    %ebp
}

int
sys_list(void)
{
  return list();
801061a4:	e9 17 e3 ff ff       	jmp    801044c0 <list>
801061a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061b0 <sys_getshmem>:
}

char*
sys_getshmem(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0,&pid)<0) return 0;
801061b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061b9:	50                   	push   %eax
801061ba:	6a 00                	push   $0x0
801061bc:	e8 9f ee ff ff       	call   80105060 <argint>
801061c1:	83 c4 10             	add    $0x10,%esp
801061c4:	85 c0                	test   %eax,%eax
801061c6:	78 18                	js     801061e0 <sys_getshmem+0x30>
  return getshmem(pid);
801061c8:	83 ec 0c             	sub    $0xc,%esp
801061cb:	ff 75 f4             	pushl  -0xc(%ebp)
801061ce:	e8 cd e1 ff ff       	call   801043a0 <getshmem>
801061d3:	83 c4 10             	add    $0x10,%esp
}
801061d6:	c9                   	leave  
801061d7:	c3                   	ret    
801061d8:	90                   	nop
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char*
sys_getshmem(void)
{
  int pid;
  if(argint(0,&pid)<0) return 0;
801061e0:	31 c0                	xor    %eax,%eax
  return getshmem(pid);
}
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    

801061e4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801061e4:	1e                   	push   %ds
  pushl %es
801061e5:	06                   	push   %es
  pushl %fs
801061e6:	0f a0                	push   %fs
  pushl %gs
801061e8:	0f a8                	push   %gs
  pushal
801061ea:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061eb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061ef:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061f1:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061f3:	54                   	push   %esp
  call trap
801061f4:	e8 e7 00 00 00       	call   801062e0 <trap>
  addl $4, %esp
801061f9:	83 c4 04             	add    $0x4,%esp

801061fc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061fc:	61                   	popa   
  popl %gs
801061fd:	0f a9                	pop    %gs
  popl %fs
801061ff:	0f a1                	pop    %fs
  popl %es
80106201:	07                   	pop    %es
  popl %ds
80106202:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106203:	83 c4 08             	add    $0x8,%esp
  iret
80106206:	cf                   	iret   
80106207:	66 90                	xchg   %ax,%ax
80106209:	66 90                	xchg   %ax,%ax
8010620b:	66 90                	xchg   %ax,%ax
8010620d:	66 90                	xchg   %ax,%ax
8010620f:	90                   	nop

80106210 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106210:	31 c0                	xor    %eax,%eax
80106212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106218:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
8010621f:	b9 08 00 00 00       	mov    $0x8,%ecx
80106224:	c6 04 c5 a4 64 11 80 	movb   $0x0,-0x7fee9b5c(,%eax,8)
8010622b:	00 
8010622c:	66 89 0c c5 a2 64 11 	mov    %cx,-0x7fee9b5e(,%eax,8)
80106233:	80 
80106234:	c6 04 c5 a5 64 11 80 	movb   $0x8e,-0x7fee9b5b(,%eax,8)
8010623b:	8e 
8010623c:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
80106243:	80 
80106244:	c1 ea 10             	shr    $0x10,%edx
80106247:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
8010624e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010624f:	83 c0 01             	add    $0x1,%eax
80106252:	3d 00 01 00 00       	cmp    $0x100,%eax
80106257:	75 bf                	jne    80106218 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106259:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010625a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010625f:	89 e5                	mov    %esp,%ebp
80106261:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106264:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106269:	68 f9 82 10 80       	push   $0x801082f9
8010626e:	68 60 64 11 80       	push   $0x80116460
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106273:	66 89 15 a2 66 11 80 	mov    %dx,0x801166a2
8010627a:	c6 05 a4 66 11 80 00 	movb   $0x0,0x801166a4
80106281:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
80106287:	c1 e8 10             	shr    $0x10,%eax
8010628a:	c6 05 a5 66 11 80 ef 	movb   $0xef,0x801166a5
80106291:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6

  initlock(&tickslock, "time");
80106297:	e8 54 e8 ff ff       	call   80104af0 <initlock>
}
8010629c:	83 c4 10             	add    $0x10,%esp
8010629f:	c9                   	leave  
801062a0:	c3                   	ret    
801062a1:	eb 0d                	jmp    801062b0 <idtinit>
801062a3:	90                   	nop
801062a4:	90                   	nop
801062a5:	90                   	nop
801062a6:	90                   	nop
801062a7:	90                   	nop
801062a8:	90                   	nop
801062a9:	90                   	nop
801062aa:	90                   	nop
801062ab:	90                   	nop
801062ac:	90                   	nop
801062ad:	90                   	nop
801062ae:	90                   	nop
801062af:	90                   	nop

801062b0 <idtinit>:

void
idtinit(void)
{
801062b0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801062b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062b6:	89 e5                	mov    %esp,%ebp
801062b8:	83 ec 10             	sub    $0x10,%esp
801062bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801062bf:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
801062c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062c8:	c1 e8 10             	shr    $0x10,%eax
801062cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801062cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062d5:	c9                   	leave  
801062d6:	c3                   	ret    
801062d7:	89 f6                	mov    %esi,%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	57                   	push   %edi
801062e4:	56                   	push   %esi
801062e5:	53                   	push   %ebx
801062e6:	83 ec 1c             	sub    $0x1c,%esp
801062e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801062ec:	8b 47 30             	mov    0x30(%edi),%eax
801062ef:	83 f8 40             	cmp    $0x40,%eax
801062f2:	0f 84 88 01 00 00    	je     80106480 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062f8:	83 e8 20             	sub    $0x20,%eax
801062fb:	83 f8 1f             	cmp    $0x1f,%eax
801062fe:	77 10                	ja     80106310 <trap+0x30>
80106300:	ff 24 85 a0 83 10 80 	jmp    *-0x7fef7c60(,%eax,4)
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106310:	e8 db d8 ff ff       	call   80103bf0 <myproc>
80106315:	85 c0                	test   %eax,%eax
80106317:	0f 84 d7 01 00 00    	je     801064f4 <trap+0x214>
8010631d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106321:	0f 84 cd 01 00 00    	je     801064f4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106327:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010632a:	8b 57 38             	mov    0x38(%edi),%edx
8010632d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106330:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106333:	e8 98 d8 ff ff       	call   80103bd0 <cpuid>
80106338:	8b 77 34             	mov    0x34(%edi),%esi
8010633b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010633e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106341:	e8 aa d8 ff ff       	call   80103bf0 <myproc>
80106346:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106349:	e8 a2 d8 ff ff       	call   80103bf0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010634e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106351:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106354:	51                   	push   %ecx
80106355:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106356:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106359:	ff 75 e4             	pushl  -0x1c(%ebp)
8010635c:	56                   	push   %esi
8010635d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010635e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106361:	52                   	push   %edx
80106362:	ff 70 10             	pushl  0x10(%eax)
80106365:	68 5c 83 10 80       	push   $0x8010835c
8010636a:	e8 f1 a2 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010636f:	83 c4 20             	add    $0x20,%esp
80106372:	e8 79 d8 ff ff       	call   80103bf0 <myproc>
80106377:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010637e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106380:	e8 6b d8 ff ff       	call   80103bf0 <myproc>
80106385:	85 c0                	test   %eax,%eax
80106387:	74 0c                	je     80106395 <trap+0xb5>
80106389:	e8 62 d8 ff ff       	call   80103bf0 <myproc>
8010638e:	8b 50 24             	mov    0x24(%eax),%edx
80106391:	85 d2                	test   %edx,%edx
80106393:	75 4b                	jne    801063e0 <trap+0x100>
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
80106395:	e8 56 d8 ff ff       	call   80103bf0 <myproc>
8010639a:	85 c0                	test   %eax,%eax
8010639c:	74 0b                	je     801063a9 <trap+0xc9>
8010639e:	e8 4d d8 ff ff       	call   80103bf0 <myproc>
801063a3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801063a7:	74 4f                	je     801063f8 <trap+0x118>
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063a9:	e8 42 d8 ff ff       	call   80103bf0 <myproc>
801063ae:	85 c0                	test   %eax,%eax
801063b0:	74 1d                	je     801063cf <trap+0xef>
801063b2:	e8 39 d8 ff ff       	call   80103bf0 <myproc>
801063b7:	8b 40 24             	mov    0x24(%eax),%eax
801063ba:	85 c0                	test   %eax,%eax
801063bc:	74 11                	je     801063cf <trap+0xef>
801063be:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063c2:	83 e0 03             	and    $0x3,%eax
801063c5:	66 83 f8 03          	cmp    $0x3,%ax
801063c9:	0f 84 da 00 00 00    	je     801064a9 <trap+0x1c9>
    exit();
}
801063cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063d2:	5b                   	pop    %ebx
801063d3:	5e                   	pop    %esi
801063d4:	5f                   	pop    %edi
801063d5:	5d                   	pop    %ebp
801063d6:	c3                   	ret    
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063e0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063e4:	83 e0 03             	and    $0x3,%eax
801063e7:	66 83 f8 03          	cmp    $0x3,%ax
801063eb:	75 a8                	jne    80106395 <trap+0xb5>
    exit();
801063ed:	e8 de dc ff ff       	call   801040d0 <exit>
801063f2:	eb a1                	jmp    80106395 <trap+0xb5>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
801063f8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801063fc:	75 ab                	jne    801063a9 <trap+0xc9>
801063fe:	e8 fd dd ff ff       	call   80104200 <yield>
80106403:	eb a4                	jmp    801063a9 <trap+0xc9>
80106405:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106408:	e8 c3 d7 ff ff       	call   80103bd0 <cpuid>
8010640d:	85 c0                	test   %eax,%eax
8010640f:	0f 84 ab 00 00 00    	je     801064c0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106415:	e8 16 c7 ff ff       	call   80102b30 <lapiceoi>
    break;
8010641a:	e9 61 ff ff ff       	jmp    80106380 <trap+0xa0>
8010641f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106420:	e8 cb c5 ff ff       	call   801029f0 <kbdintr>
    lapiceoi();
80106425:	e8 06 c7 ff ff       	call   80102b30 <lapiceoi>
    break;
8010642a:	e9 51 ff ff ff       	jmp    80106380 <trap+0xa0>
8010642f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106430:	e8 5b 02 00 00       	call   80106690 <uartintr>
    lapiceoi();
80106435:	e8 f6 c6 ff ff       	call   80102b30 <lapiceoi>
    break;
8010643a:	e9 41 ff ff ff       	jmp    80106380 <trap+0xa0>
8010643f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106440:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106444:	8b 77 38             	mov    0x38(%edi),%esi
80106447:	e8 84 d7 ff ff       	call   80103bd0 <cpuid>
8010644c:	56                   	push   %esi
8010644d:	53                   	push   %ebx
8010644e:	50                   	push   %eax
8010644f:	68 04 83 10 80       	push   $0x80108304
80106454:	e8 07 a2 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106459:	e8 d2 c6 ff ff       	call   80102b30 <lapiceoi>
    break;
8010645e:	83 c4 10             	add    $0x10,%esp
80106461:	e9 1a ff ff ff       	jmp    80106380 <trap+0xa0>
80106466:	8d 76 00             	lea    0x0(%esi),%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106470:	e8 fb bf ff ff       	call   80102470 <ideintr>
80106475:	eb 9e                	jmp    80106415 <trap+0x135>
80106477:	89 f6                	mov    %esi,%esi
80106479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106480:	e8 6b d7 ff ff       	call   80103bf0 <myproc>
80106485:	8b 58 24             	mov    0x24(%eax),%ebx
80106488:	85 db                	test   %ebx,%ebx
8010648a:	75 2c                	jne    801064b8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010648c:	e8 5f d7 ff ff       	call   80103bf0 <myproc>
80106491:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106494:	e8 b7 ec ff ff       	call   80105150 <syscall>
    if(myproc()->killed)
80106499:	e8 52 d7 ff ff       	call   80103bf0 <myproc>
8010649e:	8b 48 24             	mov    0x24(%eax),%ecx
801064a1:	85 c9                	test   %ecx,%ecx
801064a3:	0f 84 26 ff ff ff    	je     801063cf <trap+0xef>
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801064a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064ac:	5b                   	pop    %ebx
801064ad:	5e                   	pop    %esi
801064ae:	5f                   	pop    %edi
801064af:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801064b0:	e9 1b dc ff ff       	jmp    801040d0 <exit>
801064b5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801064b8:	e8 13 dc ff ff       	call   801040d0 <exit>
801064bd:	eb cd                	jmp    8010648c <trap+0x1ac>
801064bf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	68 60 64 11 80       	push   $0x80116460
801064c8:	e8 83 e7 ff ff       	call   80104c50 <acquire>
      ticks++;
      wakeup(&ticks);
801064cd:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801064d4:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      wakeup(&ticks);
801064db:	e8 30 e3 ff ff       	call   80104810 <wakeup>
      release(&tickslock);
801064e0:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
801064e7:	e8 14 e8 ff ff       	call   80104d00 <release>
801064ec:	83 c4 10             	add    $0x10,%esp
801064ef:	e9 21 ff ff ff       	jmp    80106415 <trap+0x135>
801064f4:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064f7:	8b 5f 38             	mov    0x38(%edi),%ebx
801064fa:	e8 d1 d6 ff ff       	call   80103bd0 <cpuid>
801064ff:	83 ec 0c             	sub    $0xc,%esp
80106502:	56                   	push   %esi
80106503:	53                   	push   %ebx
80106504:	50                   	push   %eax
80106505:	ff 77 30             	pushl  0x30(%edi)
80106508:	68 28 83 10 80       	push   $0x80108328
8010650d:	e8 4e a1 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106512:	83 c4 14             	add    $0x14,%esp
80106515:	68 fe 82 10 80       	push   $0x801082fe
8010651a:	e8 51 9e ff ff       	call   80100370 <panic>
8010651f:	90                   	nop

80106520 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106520:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106525:	55                   	push   %ebp
80106526:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106528:	85 c0                	test   %eax,%eax
8010652a:	74 1c                	je     80106548 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010652c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106531:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106532:	a8 01                	test   $0x1,%al
80106534:	74 12                	je     80106548 <uartgetc+0x28>
80106536:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010653b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010653c:	0f b6 c0             	movzbl %al,%eax
}
8010653f:	5d                   	pop    %ebp
80106540:	c3                   	ret    
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010654d:	5d                   	pop    %ebp
8010654e:	c3                   	ret    
8010654f:	90                   	nop

80106550 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	57                   	push   %edi
80106554:	56                   	push   %esi
80106555:	53                   	push   %ebx
80106556:	89 c7                	mov    %eax,%edi
80106558:	bb 80 00 00 00       	mov    $0x80,%ebx
8010655d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106562:	83 ec 0c             	sub    $0xc,%esp
80106565:	eb 1b                	jmp    80106582 <uartputc.part.0+0x32>
80106567:	89 f6                	mov    %esi,%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106570:	83 ec 0c             	sub    $0xc,%esp
80106573:	6a 0a                	push   $0xa
80106575:	e8 d6 c5 ff ff       	call   80102b50 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010657a:	83 c4 10             	add    $0x10,%esp
8010657d:	83 eb 01             	sub    $0x1,%ebx
80106580:	74 07                	je     80106589 <uartputc.part.0+0x39>
80106582:	89 f2                	mov    %esi,%edx
80106584:	ec                   	in     (%dx),%al
80106585:	a8 20                	test   $0x20,%al
80106587:	74 e7                	je     80106570 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106589:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658e:	89 f8                	mov    %edi,%eax
80106590:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106594:	5b                   	pop    %ebx
80106595:	5e                   	pop    %esi
80106596:	5f                   	pop    %edi
80106597:	5d                   	pop    %ebp
80106598:	c3                   	ret    
80106599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065a0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801065a0:	55                   	push   %ebp
801065a1:	31 c9                	xor    %ecx,%ecx
801065a3:	89 c8                	mov    %ecx,%eax
801065a5:	89 e5                	mov    %esp,%ebp
801065a7:	57                   	push   %edi
801065a8:	56                   	push   %esi
801065a9:	53                   	push   %ebx
801065aa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801065af:	89 da                	mov    %ebx,%edx
801065b1:	83 ec 0c             	sub    $0xc,%esp
801065b4:	ee                   	out    %al,(%dx)
801065b5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065bf:	89 fa                	mov    %edi,%edx
801065c1:	ee                   	out    %al,(%dx)
801065c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065cc:	ee                   	out    %al,(%dx)
801065cd:	be f9 03 00 00       	mov    $0x3f9,%esi
801065d2:	89 c8                	mov    %ecx,%eax
801065d4:	89 f2                	mov    %esi,%edx
801065d6:	ee                   	out    %al,(%dx)
801065d7:	b8 03 00 00 00       	mov    $0x3,%eax
801065dc:	89 fa                	mov    %edi,%edx
801065de:	ee                   	out    %al,(%dx)
801065df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065e4:	89 c8                	mov    %ecx,%eax
801065e6:	ee                   	out    %al,(%dx)
801065e7:	b8 01 00 00 00       	mov    $0x1,%eax
801065ec:	89 f2                	mov    %esi,%edx
801065ee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065f4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801065f5:	3c ff                	cmp    $0xff,%al
801065f7:	74 5a                	je     80106653 <uartinit+0xb3>
    return;
  uart = 1;
801065f9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106600:	00 00 00 
80106603:	89 da                	mov    %ebx,%edx
80106605:	ec                   	in     (%dx),%al
80106606:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010660b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010660c:	83 ec 08             	sub    $0x8,%esp
8010660f:	bb 20 84 10 80       	mov    $0x80108420,%ebx
80106614:	6a 00                	push   $0x0
80106616:	6a 04                	push   $0x4
80106618:	e8 a3 c0 ff ff       	call   801026c0 <ioapicenable>
8010661d:	83 c4 10             	add    $0x10,%esp
80106620:	b8 78 00 00 00       	mov    $0x78,%eax
80106625:	eb 13                	jmp    8010663a <uartinit+0x9a>
80106627:	89 f6                	mov    %esi,%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106630:	83 c3 01             	add    $0x1,%ebx
80106633:	0f be 03             	movsbl (%ebx),%eax
80106636:	84 c0                	test   %al,%al
80106638:	74 19                	je     80106653 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010663a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106640:	85 d2                	test   %edx,%edx
80106642:	74 ec                	je     80106630 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106644:	83 c3 01             	add    $0x1,%ebx
80106647:	e8 04 ff ff ff       	call   80106550 <uartputc.part.0>
8010664c:	0f be 03             	movsbl (%ebx),%eax
8010664f:	84 c0                	test   %al,%al
80106651:	75 e7                	jne    8010663a <uartinit+0x9a>
    uartputc(*p);
}
80106653:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106656:	5b                   	pop    %ebx
80106657:	5e                   	pop    %esi
80106658:	5f                   	pop    %edi
80106659:	5d                   	pop    %ebp
8010665a:	c3                   	ret    
8010665b:	90                   	nop
8010665c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106660 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106660:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106666:	55                   	push   %ebp
80106667:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106669:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010666b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010666e:	74 10                	je     80106680 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106670:	5d                   	pop    %ebp
80106671:	e9 da fe ff ff       	jmp    80106550 <uartputc.part.0>
80106676:	8d 76 00             	lea    0x0(%esi),%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106680:	5d                   	pop    %ebp
80106681:	c3                   	ret    
80106682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106690 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106696:	68 20 65 10 80       	push   $0x80106520
8010669b:	e8 50 a1 ff ff       	call   801007f0 <consoleintr>
}
801066a0:	83 c4 10             	add    $0x10,%esp
801066a3:	c9                   	leave  
801066a4:	c3                   	ret    

801066a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $0
801066a7:	6a 00                	push   $0x0
  jmp alltraps
801066a9:	e9 36 fb ff ff       	jmp    801061e4 <alltraps>

801066ae <vector1>:
.globl vector1
vector1:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $1
801066b0:	6a 01                	push   $0x1
  jmp alltraps
801066b2:	e9 2d fb ff ff       	jmp    801061e4 <alltraps>

801066b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $2
801066b9:	6a 02                	push   $0x2
  jmp alltraps
801066bb:	e9 24 fb ff ff       	jmp    801061e4 <alltraps>

801066c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $3
801066c2:	6a 03                	push   $0x3
  jmp alltraps
801066c4:	e9 1b fb ff ff       	jmp    801061e4 <alltraps>

801066c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $4
801066cb:	6a 04                	push   $0x4
  jmp alltraps
801066cd:	e9 12 fb ff ff       	jmp    801061e4 <alltraps>

801066d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $5
801066d4:	6a 05                	push   $0x5
  jmp alltraps
801066d6:	e9 09 fb ff ff       	jmp    801061e4 <alltraps>

801066db <vector6>:
.globl vector6
vector6:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $6
801066dd:	6a 06                	push   $0x6
  jmp alltraps
801066df:	e9 00 fb ff ff       	jmp    801061e4 <alltraps>

801066e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $7
801066e6:	6a 07                	push   $0x7
  jmp alltraps
801066e8:	e9 f7 fa ff ff       	jmp    801061e4 <alltraps>

801066ed <vector8>:
.globl vector8
vector8:
  pushl $8
801066ed:	6a 08                	push   $0x8
  jmp alltraps
801066ef:	e9 f0 fa ff ff       	jmp    801061e4 <alltraps>

801066f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $9
801066f6:	6a 09                	push   $0x9
  jmp alltraps
801066f8:	e9 e7 fa ff ff       	jmp    801061e4 <alltraps>

801066fd <vector10>:
.globl vector10
vector10:
  pushl $10
801066fd:	6a 0a                	push   $0xa
  jmp alltraps
801066ff:	e9 e0 fa ff ff       	jmp    801061e4 <alltraps>

80106704 <vector11>:
.globl vector11
vector11:
  pushl $11
80106704:	6a 0b                	push   $0xb
  jmp alltraps
80106706:	e9 d9 fa ff ff       	jmp    801061e4 <alltraps>

8010670b <vector12>:
.globl vector12
vector12:
  pushl $12
8010670b:	6a 0c                	push   $0xc
  jmp alltraps
8010670d:	e9 d2 fa ff ff       	jmp    801061e4 <alltraps>

80106712 <vector13>:
.globl vector13
vector13:
  pushl $13
80106712:	6a 0d                	push   $0xd
  jmp alltraps
80106714:	e9 cb fa ff ff       	jmp    801061e4 <alltraps>

80106719 <vector14>:
.globl vector14
vector14:
  pushl $14
80106719:	6a 0e                	push   $0xe
  jmp alltraps
8010671b:	e9 c4 fa ff ff       	jmp    801061e4 <alltraps>

80106720 <vector15>:
.globl vector15
vector15:
  pushl $0
80106720:	6a 00                	push   $0x0
  pushl $15
80106722:	6a 0f                	push   $0xf
  jmp alltraps
80106724:	e9 bb fa ff ff       	jmp    801061e4 <alltraps>

80106729 <vector16>:
.globl vector16
vector16:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $16
8010672b:	6a 10                	push   $0x10
  jmp alltraps
8010672d:	e9 b2 fa ff ff       	jmp    801061e4 <alltraps>

80106732 <vector17>:
.globl vector17
vector17:
  pushl $17
80106732:	6a 11                	push   $0x11
  jmp alltraps
80106734:	e9 ab fa ff ff       	jmp    801061e4 <alltraps>

80106739 <vector18>:
.globl vector18
vector18:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $18
8010673b:	6a 12                	push   $0x12
  jmp alltraps
8010673d:	e9 a2 fa ff ff       	jmp    801061e4 <alltraps>

80106742 <vector19>:
.globl vector19
vector19:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $19
80106744:	6a 13                	push   $0x13
  jmp alltraps
80106746:	e9 99 fa ff ff       	jmp    801061e4 <alltraps>

8010674b <vector20>:
.globl vector20
vector20:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $20
8010674d:	6a 14                	push   $0x14
  jmp alltraps
8010674f:	e9 90 fa ff ff       	jmp    801061e4 <alltraps>

80106754 <vector21>:
.globl vector21
vector21:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $21
80106756:	6a 15                	push   $0x15
  jmp alltraps
80106758:	e9 87 fa ff ff       	jmp    801061e4 <alltraps>

8010675d <vector22>:
.globl vector22
vector22:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $22
8010675f:	6a 16                	push   $0x16
  jmp alltraps
80106761:	e9 7e fa ff ff       	jmp    801061e4 <alltraps>

80106766 <vector23>:
.globl vector23
vector23:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $23
80106768:	6a 17                	push   $0x17
  jmp alltraps
8010676a:	e9 75 fa ff ff       	jmp    801061e4 <alltraps>

8010676f <vector24>:
.globl vector24
vector24:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $24
80106771:	6a 18                	push   $0x18
  jmp alltraps
80106773:	e9 6c fa ff ff       	jmp    801061e4 <alltraps>

80106778 <vector25>:
.globl vector25
vector25:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $25
8010677a:	6a 19                	push   $0x19
  jmp alltraps
8010677c:	e9 63 fa ff ff       	jmp    801061e4 <alltraps>

80106781 <vector26>:
.globl vector26
vector26:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $26
80106783:	6a 1a                	push   $0x1a
  jmp alltraps
80106785:	e9 5a fa ff ff       	jmp    801061e4 <alltraps>

8010678a <vector27>:
.globl vector27
vector27:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $27
8010678c:	6a 1b                	push   $0x1b
  jmp alltraps
8010678e:	e9 51 fa ff ff       	jmp    801061e4 <alltraps>

80106793 <vector28>:
.globl vector28
vector28:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $28
80106795:	6a 1c                	push   $0x1c
  jmp alltraps
80106797:	e9 48 fa ff ff       	jmp    801061e4 <alltraps>

8010679c <vector29>:
.globl vector29
vector29:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $29
8010679e:	6a 1d                	push   $0x1d
  jmp alltraps
801067a0:	e9 3f fa ff ff       	jmp    801061e4 <alltraps>

801067a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $30
801067a7:	6a 1e                	push   $0x1e
  jmp alltraps
801067a9:	e9 36 fa ff ff       	jmp    801061e4 <alltraps>

801067ae <vector31>:
.globl vector31
vector31:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $31
801067b0:	6a 1f                	push   $0x1f
  jmp alltraps
801067b2:	e9 2d fa ff ff       	jmp    801061e4 <alltraps>

801067b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $32
801067b9:	6a 20                	push   $0x20
  jmp alltraps
801067bb:	e9 24 fa ff ff       	jmp    801061e4 <alltraps>

801067c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $33
801067c2:	6a 21                	push   $0x21
  jmp alltraps
801067c4:	e9 1b fa ff ff       	jmp    801061e4 <alltraps>

801067c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $34
801067cb:	6a 22                	push   $0x22
  jmp alltraps
801067cd:	e9 12 fa ff ff       	jmp    801061e4 <alltraps>

801067d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $35
801067d4:	6a 23                	push   $0x23
  jmp alltraps
801067d6:	e9 09 fa ff ff       	jmp    801061e4 <alltraps>

801067db <vector36>:
.globl vector36
vector36:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $36
801067dd:	6a 24                	push   $0x24
  jmp alltraps
801067df:	e9 00 fa ff ff       	jmp    801061e4 <alltraps>

801067e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $37
801067e6:	6a 25                	push   $0x25
  jmp alltraps
801067e8:	e9 f7 f9 ff ff       	jmp    801061e4 <alltraps>

801067ed <vector38>:
.globl vector38
vector38:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $38
801067ef:	6a 26                	push   $0x26
  jmp alltraps
801067f1:	e9 ee f9 ff ff       	jmp    801061e4 <alltraps>

801067f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $39
801067f8:	6a 27                	push   $0x27
  jmp alltraps
801067fa:	e9 e5 f9 ff ff       	jmp    801061e4 <alltraps>

801067ff <vector40>:
.globl vector40
vector40:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $40
80106801:	6a 28                	push   $0x28
  jmp alltraps
80106803:	e9 dc f9 ff ff       	jmp    801061e4 <alltraps>

80106808 <vector41>:
.globl vector41
vector41:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $41
8010680a:	6a 29                	push   $0x29
  jmp alltraps
8010680c:	e9 d3 f9 ff ff       	jmp    801061e4 <alltraps>

80106811 <vector42>:
.globl vector42
vector42:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $42
80106813:	6a 2a                	push   $0x2a
  jmp alltraps
80106815:	e9 ca f9 ff ff       	jmp    801061e4 <alltraps>

8010681a <vector43>:
.globl vector43
vector43:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $43
8010681c:	6a 2b                	push   $0x2b
  jmp alltraps
8010681e:	e9 c1 f9 ff ff       	jmp    801061e4 <alltraps>

80106823 <vector44>:
.globl vector44
vector44:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $44
80106825:	6a 2c                	push   $0x2c
  jmp alltraps
80106827:	e9 b8 f9 ff ff       	jmp    801061e4 <alltraps>

8010682c <vector45>:
.globl vector45
vector45:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $45
8010682e:	6a 2d                	push   $0x2d
  jmp alltraps
80106830:	e9 af f9 ff ff       	jmp    801061e4 <alltraps>

80106835 <vector46>:
.globl vector46
vector46:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $46
80106837:	6a 2e                	push   $0x2e
  jmp alltraps
80106839:	e9 a6 f9 ff ff       	jmp    801061e4 <alltraps>

8010683e <vector47>:
.globl vector47
vector47:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $47
80106840:	6a 2f                	push   $0x2f
  jmp alltraps
80106842:	e9 9d f9 ff ff       	jmp    801061e4 <alltraps>

80106847 <vector48>:
.globl vector48
vector48:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $48
80106849:	6a 30                	push   $0x30
  jmp alltraps
8010684b:	e9 94 f9 ff ff       	jmp    801061e4 <alltraps>

80106850 <vector49>:
.globl vector49
vector49:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $49
80106852:	6a 31                	push   $0x31
  jmp alltraps
80106854:	e9 8b f9 ff ff       	jmp    801061e4 <alltraps>

80106859 <vector50>:
.globl vector50
vector50:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $50
8010685b:	6a 32                	push   $0x32
  jmp alltraps
8010685d:	e9 82 f9 ff ff       	jmp    801061e4 <alltraps>

80106862 <vector51>:
.globl vector51
vector51:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $51
80106864:	6a 33                	push   $0x33
  jmp alltraps
80106866:	e9 79 f9 ff ff       	jmp    801061e4 <alltraps>

8010686b <vector52>:
.globl vector52
vector52:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $52
8010686d:	6a 34                	push   $0x34
  jmp alltraps
8010686f:	e9 70 f9 ff ff       	jmp    801061e4 <alltraps>

80106874 <vector53>:
.globl vector53
vector53:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $53
80106876:	6a 35                	push   $0x35
  jmp alltraps
80106878:	e9 67 f9 ff ff       	jmp    801061e4 <alltraps>

8010687d <vector54>:
.globl vector54
vector54:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $54
8010687f:	6a 36                	push   $0x36
  jmp alltraps
80106881:	e9 5e f9 ff ff       	jmp    801061e4 <alltraps>

80106886 <vector55>:
.globl vector55
vector55:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $55
80106888:	6a 37                	push   $0x37
  jmp alltraps
8010688a:	e9 55 f9 ff ff       	jmp    801061e4 <alltraps>

8010688f <vector56>:
.globl vector56
vector56:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $56
80106891:	6a 38                	push   $0x38
  jmp alltraps
80106893:	e9 4c f9 ff ff       	jmp    801061e4 <alltraps>

80106898 <vector57>:
.globl vector57
vector57:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $57
8010689a:	6a 39                	push   $0x39
  jmp alltraps
8010689c:	e9 43 f9 ff ff       	jmp    801061e4 <alltraps>

801068a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $58
801068a3:	6a 3a                	push   $0x3a
  jmp alltraps
801068a5:	e9 3a f9 ff ff       	jmp    801061e4 <alltraps>

801068aa <vector59>:
.globl vector59
vector59:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $59
801068ac:	6a 3b                	push   $0x3b
  jmp alltraps
801068ae:	e9 31 f9 ff ff       	jmp    801061e4 <alltraps>

801068b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $60
801068b5:	6a 3c                	push   $0x3c
  jmp alltraps
801068b7:	e9 28 f9 ff ff       	jmp    801061e4 <alltraps>

801068bc <vector61>:
.globl vector61
vector61:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $61
801068be:	6a 3d                	push   $0x3d
  jmp alltraps
801068c0:	e9 1f f9 ff ff       	jmp    801061e4 <alltraps>

801068c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $62
801068c7:	6a 3e                	push   $0x3e
  jmp alltraps
801068c9:	e9 16 f9 ff ff       	jmp    801061e4 <alltraps>

801068ce <vector63>:
.globl vector63
vector63:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $63
801068d0:	6a 3f                	push   $0x3f
  jmp alltraps
801068d2:	e9 0d f9 ff ff       	jmp    801061e4 <alltraps>

801068d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $64
801068d9:	6a 40                	push   $0x40
  jmp alltraps
801068db:	e9 04 f9 ff ff       	jmp    801061e4 <alltraps>

801068e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $65
801068e2:	6a 41                	push   $0x41
  jmp alltraps
801068e4:	e9 fb f8 ff ff       	jmp    801061e4 <alltraps>

801068e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $66
801068eb:	6a 42                	push   $0x42
  jmp alltraps
801068ed:	e9 f2 f8 ff ff       	jmp    801061e4 <alltraps>

801068f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $67
801068f4:	6a 43                	push   $0x43
  jmp alltraps
801068f6:	e9 e9 f8 ff ff       	jmp    801061e4 <alltraps>

801068fb <vector68>:
.globl vector68
vector68:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $68
801068fd:	6a 44                	push   $0x44
  jmp alltraps
801068ff:	e9 e0 f8 ff ff       	jmp    801061e4 <alltraps>

80106904 <vector69>:
.globl vector69
vector69:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $69
80106906:	6a 45                	push   $0x45
  jmp alltraps
80106908:	e9 d7 f8 ff ff       	jmp    801061e4 <alltraps>

8010690d <vector70>:
.globl vector70
vector70:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $70
8010690f:	6a 46                	push   $0x46
  jmp alltraps
80106911:	e9 ce f8 ff ff       	jmp    801061e4 <alltraps>

80106916 <vector71>:
.globl vector71
vector71:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $71
80106918:	6a 47                	push   $0x47
  jmp alltraps
8010691a:	e9 c5 f8 ff ff       	jmp    801061e4 <alltraps>

8010691f <vector72>:
.globl vector72
vector72:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $72
80106921:	6a 48                	push   $0x48
  jmp alltraps
80106923:	e9 bc f8 ff ff       	jmp    801061e4 <alltraps>

80106928 <vector73>:
.globl vector73
vector73:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $73
8010692a:	6a 49                	push   $0x49
  jmp alltraps
8010692c:	e9 b3 f8 ff ff       	jmp    801061e4 <alltraps>

80106931 <vector74>:
.globl vector74
vector74:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $74
80106933:	6a 4a                	push   $0x4a
  jmp alltraps
80106935:	e9 aa f8 ff ff       	jmp    801061e4 <alltraps>

8010693a <vector75>:
.globl vector75
vector75:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $75
8010693c:	6a 4b                	push   $0x4b
  jmp alltraps
8010693e:	e9 a1 f8 ff ff       	jmp    801061e4 <alltraps>

80106943 <vector76>:
.globl vector76
vector76:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $76
80106945:	6a 4c                	push   $0x4c
  jmp alltraps
80106947:	e9 98 f8 ff ff       	jmp    801061e4 <alltraps>

8010694c <vector77>:
.globl vector77
vector77:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $77
8010694e:	6a 4d                	push   $0x4d
  jmp alltraps
80106950:	e9 8f f8 ff ff       	jmp    801061e4 <alltraps>

80106955 <vector78>:
.globl vector78
vector78:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $78
80106957:	6a 4e                	push   $0x4e
  jmp alltraps
80106959:	e9 86 f8 ff ff       	jmp    801061e4 <alltraps>

8010695e <vector79>:
.globl vector79
vector79:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $79
80106960:	6a 4f                	push   $0x4f
  jmp alltraps
80106962:	e9 7d f8 ff ff       	jmp    801061e4 <alltraps>

80106967 <vector80>:
.globl vector80
vector80:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $80
80106969:	6a 50                	push   $0x50
  jmp alltraps
8010696b:	e9 74 f8 ff ff       	jmp    801061e4 <alltraps>

80106970 <vector81>:
.globl vector81
vector81:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $81
80106972:	6a 51                	push   $0x51
  jmp alltraps
80106974:	e9 6b f8 ff ff       	jmp    801061e4 <alltraps>

80106979 <vector82>:
.globl vector82
vector82:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $82
8010697b:	6a 52                	push   $0x52
  jmp alltraps
8010697d:	e9 62 f8 ff ff       	jmp    801061e4 <alltraps>

80106982 <vector83>:
.globl vector83
vector83:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $83
80106984:	6a 53                	push   $0x53
  jmp alltraps
80106986:	e9 59 f8 ff ff       	jmp    801061e4 <alltraps>

8010698b <vector84>:
.globl vector84
vector84:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $84
8010698d:	6a 54                	push   $0x54
  jmp alltraps
8010698f:	e9 50 f8 ff ff       	jmp    801061e4 <alltraps>

80106994 <vector85>:
.globl vector85
vector85:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $85
80106996:	6a 55                	push   $0x55
  jmp alltraps
80106998:	e9 47 f8 ff ff       	jmp    801061e4 <alltraps>

8010699d <vector86>:
.globl vector86
vector86:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $86
8010699f:	6a 56                	push   $0x56
  jmp alltraps
801069a1:	e9 3e f8 ff ff       	jmp    801061e4 <alltraps>

801069a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $87
801069a8:	6a 57                	push   $0x57
  jmp alltraps
801069aa:	e9 35 f8 ff ff       	jmp    801061e4 <alltraps>

801069af <vector88>:
.globl vector88
vector88:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $88
801069b1:	6a 58                	push   $0x58
  jmp alltraps
801069b3:	e9 2c f8 ff ff       	jmp    801061e4 <alltraps>

801069b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $89
801069ba:	6a 59                	push   $0x59
  jmp alltraps
801069bc:	e9 23 f8 ff ff       	jmp    801061e4 <alltraps>

801069c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $90
801069c3:	6a 5a                	push   $0x5a
  jmp alltraps
801069c5:	e9 1a f8 ff ff       	jmp    801061e4 <alltraps>

801069ca <vector91>:
.globl vector91
vector91:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $91
801069cc:	6a 5b                	push   $0x5b
  jmp alltraps
801069ce:	e9 11 f8 ff ff       	jmp    801061e4 <alltraps>

801069d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $92
801069d5:	6a 5c                	push   $0x5c
  jmp alltraps
801069d7:	e9 08 f8 ff ff       	jmp    801061e4 <alltraps>

801069dc <vector93>:
.globl vector93
vector93:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $93
801069de:	6a 5d                	push   $0x5d
  jmp alltraps
801069e0:	e9 ff f7 ff ff       	jmp    801061e4 <alltraps>

801069e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $94
801069e7:	6a 5e                	push   $0x5e
  jmp alltraps
801069e9:	e9 f6 f7 ff ff       	jmp    801061e4 <alltraps>

801069ee <vector95>:
.globl vector95
vector95:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $95
801069f0:	6a 5f                	push   $0x5f
  jmp alltraps
801069f2:	e9 ed f7 ff ff       	jmp    801061e4 <alltraps>

801069f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $96
801069f9:	6a 60                	push   $0x60
  jmp alltraps
801069fb:	e9 e4 f7 ff ff       	jmp    801061e4 <alltraps>

80106a00 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $97
80106a02:	6a 61                	push   $0x61
  jmp alltraps
80106a04:	e9 db f7 ff ff       	jmp    801061e4 <alltraps>

80106a09 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $98
80106a0b:	6a 62                	push   $0x62
  jmp alltraps
80106a0d:	e9 d2 f7 ff ff       	jmp    801061e4 <alltraps>

80106a12 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $99
80106a14:	6a 63                	push   $0x63
  jmp alltraps
80106a16:	e9 c9 f7 ff ff       	jmp    801061e4 <alltraps>

80106a1b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $100
80106a1d:	6a 64                	push   $0x64
  jmp alltraps
80106a1f:	e9 c0 f7 ff ff       	jmp    801061e4 <alltraps>

80106a24 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $101
80106a26:	6a 65                	push   $0x65
  jmp alltraps
80106a28:	e9 b7 f7 ff ff       	jmp    801061e4 <alltraps>

80106a2d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $102
80106a2f:	6a 66                	push   $0x66
  jmp alltraps
80106a31:	e9 ae f7 ff ff       	jmp    801061e4 <alltraps>

80106a36 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $103
80106a38:	6a 67                	push   $0x67
  jmp alltraps
80106a3a:	e9 a5 f7 ff ff       	jmp    801061e4 <alltraps>

80106a3f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $104
80106a41:	6a 68                	push   $0x68
  jmp alltraps
80106a43:	e9 9c f7 ff ff       	jmp    801061e4 <alltraps>

80106a48 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $105
80106a4a:	6a 69                	push   $0x69
  jmp alltraps
80106a4c:	e9 93 f7 ff ff       	jmp    801061e4 <alltraps>

80106a51 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a51:	6a 00                	push   $0x0
  pushl $106
80106a53:	6a 6a                	push   $0x6a
  jmp alltraps
80106a55:	e9 8a f7 ff ff       	jmp    801061e4 <alltraps>

80106a5a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a5a:	6a 00                	push   $0x0
  pushl $107
80106a5c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a5e:	e9 81 f7 ff ff       	jmp    801061e4 <alltraps>

80106a63 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $108
80106a65:	6a 6c                	push   $0x6c
  jmp alltraps
80106a67:	e9 78 f7 ff ff       	jmp    801061e4 <alltraps>

80106a6c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a6c:	6a 00                	push   $0x0
  pushl $109
80106a6e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a70:	e9 6f f7 ff ff       	jmp    801061e4 <alltraps>

80106a75 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a75:	6a 00                	push   $0x0
  pushl $110
80106a77:	6a 6e                	push   $0x6e
  jmp alltraps
80106a79:	e9 66 f7 ff ff       	jmp    801061e4 <alltraps>

80106a7e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $111
80106a80:	6a 6f                	push   $0x6f
  jmp alltraps
80106a82:	e9 5d f7 ff ff       	jmp    801061e4 <alltraps>

80106a87 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $112
80106a89:	6a 70                	push   $0x70
  jmp alltraps
80106a8b:	e9 54 f7 ff ff       	jmp    801061e4 <alltraps>

80106a90 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $113
80106a92:	6a 71                	push   $0x71
  jmp alltraps
80106a94:	e9 4b f7 ff ff       	jmp    801061e4 <alltraps>

80106a99 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $114
80106a9b:	6a 72                	push   $0x72
  jmp alltraps
80106a9d:	e9 42 f7 ff ff       	jmp    801061e4 <alltraps>

80106aa2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $115
80106aa4:	6a 73                	push   $0x73
  jmp alltraps
80106aa6:	e9 39 f7 ff ff       	jmp    801061e4 <alltraps>

80106aab <vector116>:
.globl vector116
vector116:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $116
80106aad:	6a 74                	push   $0x74
  jmp alltraps
80106aaf:	e9 30 f7 ff ff       	jmp    801061e4 <alltraps>

80106ab4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $117
80106ab6:	6a 75                	push   $0x75
  jmp alltraps
80106ab8:	e9 27 f7 ff ff       	jmp    801061e4 <alltraps>

80106abd <vector118>:
.globl vector118
vector118:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $118
80106abf:	6a 76                	push   $0x76
  jmp alltraps
80106ac1:	e9 1e f7 ff ff       	jmp    801061e4 <alltraps>

80106ac6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $119
80106ac8:	6a 77                	push   $0x77
  jmp alltraps
80106aca:	e9 15 f7 ff ff       	jmp    801061e4 <alltraps>

80106acf <vector120>:
.globl vector120
vector120:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $120
80106ad1:	6a 78                	push   $0x78
  jmp alltraps
80106ad3:	e9 0c f7 ff ff       	jmp    801061e4 <alltraps>

80106ad8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $121
80106ada:	6a 79                	push   $0x79
  jmp alltraps
80106adc:	e9 03 f7 ff ff       	jmp    801061e4 <alltraps>

80106ae1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $122
80106ae3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ae5:	e9 fa f6 ff ff       	jmp    801061e4 <alltraps>

80106aea <vector123>:
.globl vector123
vector123:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $123
80106aec:	6a 7b                	push   $0x7b
  jmp alltraps
80106aee:	e9 f1 f6 ff ff       	jmp    801061e4 <alltraps>

80106af3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $124
80106af5:	6a 7c                	push   $0x7c
  jmp alltraps
80106af7:	e9 e8 f6 ff ff       	jmp    801061e4 <alltraps>

80106afc <vector125>:
.globl vector125
vector125:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $125
80106afe:	6a 7d                	push   $0x7d
  jmp alltraps
80106b00:	e9 df f6 ff ff       	jmp    801061e4 <alltraps>

80106b05 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $126
80106b07:	6a 7e                	push   $0x7e
  jmp alltraps
80106b09:	e9 d6 f6 ff ff       	jmp    801061e4 <alltraps>

80106b0e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $127
80106b10:	6a 7f                	push   $0x7f
  jmp alltraps
80106b12:	e9 cd f6 ff ff       	jmp    801061e4 <alltraps>

80106b17 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $128
80106b19:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b1e:	e9 c1 f6 ff ff       	jmp    801061e4 <alltraps>

80106b23 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $129
80106b25:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b2a:	e9 b5 f6 ff ff       	jmp    801061e4 <alltraps>

80106b2f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $130
80106b31:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b36:	e9 a9 f6 ff ff       	jmp    801061e4 <alltraps>

80106b3b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $131
80106b3d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b42:	e9 9d f6 ff ff       	jmp    801061e4 <alltraps>

80106b47 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $132
80106b49:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b4e:	e9 91 f6 ff ff       	jmp    801061e4 <alltraps>

80106b53 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $133
80106b55:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b5a:	e9 85 f6 ff ff       	jmp    801061e4 <alltraps>

80106b5f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $134
80106b61:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b66:	e9 79 f6 ff ff       	jmp    801061e4 <alltraps>

80106b6b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $135
80106b6d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b72:	e9 6d f6 ff ff       	jmp    801061e4 <alltraps>

80106b77 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $136
80106b79:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b7e:	e9 61 f6 ff ff       	jmp    801061e4 <alltraps>

80106b83 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $137
80106b85:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b8a:	e9 55 f6 ff ff       	jmp    801061e4 <alltraps>

80106b8f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $138
80106b91:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b96:	e9 49 f6 ff ff       	jmp    801061e4 <alltraps>

80106b9b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $139
80106b9d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ba2:	e9 3d f6 ff ff       	jmp    801061e4 <alltraps>

80106ba7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $140
80106ba9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106bae:	e9 31 f6 ff ff       	jmp    801061e4 <alltraps>

80106bb3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $141
80106bb5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106bba:	e9 25 f6 ff ff       	jmp    801061e4 <alltraps>

80106bbf <vector142>:
.globl vector142
vector142:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $142
80106bc1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106bc6:	e9 19 f6 ff ff       	jmp    801061e4 <alltraps>

80106bcb <vector143>:
.globl vector143
vector143:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $143
80106bcd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bd2:	e9 0d f6 ff ff       	jmp    801061e4 <alltraps>

80106bd7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $144
80106bd9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bde:	e9 01 f6 ff ff       	jmp    801061e4 <alltraps>

80106be3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $145
80106be5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bea:	e9 f5 f5 ff ff       	jmp    801061e4 <alltraps>

80106bef <vector146>:
.globl vector146
vector146:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $146
80106bf1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bf6:	e9 e9 f5 ff ff       	jmp    801061e4 <alltraps>

80106bfb <vector147>:
.globl vector147
vector147:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $147
80106bfd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c02:	e9 dd f5 ff ff       	jmp    801061e4 <alltraps>

80106c07 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $148
80106c09:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c0e:	e9 d1 f5 ff ff       	jmp    801061e4 <alltraps>

80106c13 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $149
80106c15:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c1a:	e9 c5 f5 ff ff       	jmp    801061e4 <alltraps>

80106c1f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $150
80106c21:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c26:	e9 b9 f5 ff ff       	jmp    801061e4 <alltraps>

80106c2b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $151
80106c2d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c32:	e9 ad f5 ff ff       	jmp    801061e4 <alltraps>

80106c37 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $152
80106c39:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c3e:	e9 a1 f5 ff ff       	jmp    801061e4 <alltraps>

80106c43 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $153
80106c45:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c4a:	e9 95 f5 ff ff       	jmp    801061e4 <alltraps>

80106c4f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $154
80106c51:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c56:	e9 89 f5 ff ff       	jmp    801061e4 <alltraps>

80106c5b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $155
80106c5d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c62:	e9 7d f5 ff ff       	jmp    801061e4 <alltraps>

80106c67 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $156
80106c69:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c6e:	e9 71 f5 ff ff       	jmp    801061e4 <alltraps>

80106c73 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $157
80106c75:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c7a:	e9 65 f5 ff ff       	jmp    801061e4 <alltraps>

80106c7f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $158
80106c81:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c86:	e9 59 f5 ff ff       	jmp    801061e4 <alltraps>

80106c8b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $159
80106c8d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c92:	e9 4d f5 ff ff       	jmp    801061e4 <alltraps>

80106c97 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $160
80106c99:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c9e:	e9 41 f5 ff ff       	jmp    801061e4 <alltraps>

80106ca3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $161
80106ca5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106caa:	e9 35 f5 ff ff       	jmp    801061e4 <alltraps>

80106caf <vector162>:
.globl vector162
vector162:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $162
80106cb1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106cb6:	e9 29 f5 ff ff       	jmp    801061e4 <alltraps>

80106cbb <vector163>:
.globl vector163
vector163:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $163
80106cbd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106cc2:	e9 1d f5 ff ff       	jmp    801061e4 <alltraps>

80106cc7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $164
80106cc9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cce:	e9 11 f5 ff ff       	jmp    801061e4 <alltraps>

80106cd3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $165
80106cd5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cda:	e9 05 f5 ff ff       	jmp    801061e4 <alltraps>

80106cdf <vector166>:
.globl vector166
vector166:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $166
80106ce1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ce6:	e9 f9 f4 ff ff       	jmp    801061e4 <alltraps>

80106ceb <vector167>:
.globl vector167
vector167:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $167
80106ced:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cf2:	e9 ed f4 ff ff       	jmp    801061e4 <alltraps>

80106cf7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $168
80106cf9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cfe:	e9 e1 f4 ff ff       	jmp    801061e4 <alltraps>

80106d03 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $169
80106d05:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d0a:	e9 d5 f4 ff ff       	jmp    801061e4 <alltraps>

80106d0f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $170
80106d11:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d16:	e9 c9 f4 ff ff       	jmp    801061e4 <alltraps>

80106d1b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $171
80106d1d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d22:	e9 bd f4 ff ff       	jmp    801061e4 <alltraps>

80106d27 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $172
80106d29:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d2e:	e9 b1 f4 ff ff       	jmp    801061e4 <alltraps>

80106d33 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $173
80106d35:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d3a:	e9 a5 f4 ff ff       	jmp    801061e4 <alltraps>

80106d3f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $174
80106d41:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d46:	e9 99 f4 ff ff       	jmp    801061e4 <alltraps>

80106d4b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $175
80106d4d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d52:	e9 8d f4 ff ff       	jmp    801061e4 <alltraps>

80106d57 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $176
80106d59:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d5e:	e9 81 f4 ff ff       	jmp    801061e4 <alltraps>

80106d63 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $177
80106d65:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d6a:	e9 75 f4 ff ff       	jmp    801061e4 <alltraps>

80106d6f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $178
80106d71:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d76:	e9 69 f4 ff ff       	jmp    801061e4 <alltraps>

80106d7b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $179
80106d7d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d82:	e9 5d f4 ff ff       	jmp    801061e4 <alltraps>

80106d87 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $180
80106d89:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d8e:	e9 51 f4 ff ff       	jmp    801061e4 <alltraps>

80106d93 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $181
80106d95:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d9a:	e9 45 f4 ff ff       	jmp    801061e4 <alltraps>

80106d9f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $182
80106da1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106da6:	e9 39 f4 ff ff       	jmp    801061e4 <alltraps>

80106dab <vector183>:
.globl vector183
vector183:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $183
80106dad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106db2:	e9 2d f4 ff ff       	jmp    801061e4 <alltraps>

80106db7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $184
80106db9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dbe:	e9 21 f4 ff ff       	jmp    801061e4 <alltraps>

80106dc3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $185
80106dc5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dca:	e9 15 f4 ff ff       	jmp    801061e4 <alltraps>

80106dcf <vector186>:
.globl vector186
vector186:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $186
80106dd1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106dd6:	e9 09 f4 ff ff       	jmp    801061e4 <alltraps>

80106ddb <vector187>:
.globl vector187
vector187:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $187
80106ddd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106de2:	e9 fd f3 ff ff       	jmp    801061e4 <alltraps>

80106de7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $188
80106de9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dee:	e9 f1 f3 ff ff       	jmp    801061e4 <alltraps>

80106df3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $189
80106df5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dfa:	e9 e5 f3 ff ff       	jmp    801061e4 <alltraps>

80106dff <vector190>:
.globl vector190
vector190:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $190
80106e01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e06:	e9 d9 f3 ff ff       	jmp    801061e4 <alltraps>

80106e0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $191
80106e0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e12:	e9 cd f3 ff ff       	jmp    801061e4 <alltraps>

80106e17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $192
80106e19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e1e:	e9 c1 f3 ff ff       	jmp    801061e4 <alltraps>

80106e23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $193
80106e25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e2a:	e9 b5 f3 ff ff       	jmp    801061e4 <alltraps>

80106e2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $194
80106e31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e36:	e9 a9 f3 ff ff       	jmp    801061e4 <alltraps>

80106e3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $195
80106e3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e42:	e9 9d f3 ff ff       	jmp    801061e4 <alltraps>

80106e47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $196
80106e49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e4e:	e9 91 f3 ff ff       	jmp    801061e4 <alltraps>

80106e53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $197
80106e55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e5a:	e9 85 f3 ff ff       	jmp    801061e4 <alltraps>

80106e5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $198
80106e61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e66:	e9 79 f3 ff ff       	jmp    801061e4 <alltraps>

80106e6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $199
80106e6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e72:	e9 6d f3 ff ff       	jmp    801061e4 <alltraps>

80106e77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $200
80106e79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e7e:	e9 61 f3 ff ff       	jmp    801061e4 <alltraps>

80106e83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $201
80106e85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e8a:	e9 55 f3 ff ff       	jmp    801061e4 <alltraps>

80106e8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $202
80106e91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e96:	e9 49 f3 ff ff       	jmp    801061e4 <alltraps>

80106e9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $203
80106e9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ea2:	e9 3d f3 ff ff       	jmp    801061e4 <alltraps>

80106ea7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $204
80106ea9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106eae:	e9 31 f3 ff ff       	jmp    801061e4 <alltraps>

80106eb3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $205
80106eb5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106eba:	e9 25 f3 ff ff       	jmp    801061e4 <alltraps>

80106ebf <vector206>:
.globl vector206
vector206:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $206
80106ec1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ec6:	e9 19 f3 ff ff       	jmp    801061e4 <alltraps>

80106ecb <vector207>:
.globl vector207
vector207:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $207
80106ecd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ed2:	e9 0d f3 ff ff       	jmp    801061e4 <alltraps>

80106ed7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $208
80106ed9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ede:	e9 01 f3 ff ff       	jmp    801061e4 <alltraps>

80106ee3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $209
80106ee5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eea:	e9 f5 f2 ff ff       	jmp    801061e4 <alltraps>

80106eef <vector210>:
.globl vector210
vector210:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $210
80106ef1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ef6:	e9 e9 f2 ff ff       	jmp    801061e4 <alltraps>

80106efb <vector211>:
.globl vector211
vector211:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $211
80106efd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f02:	e9 dd f2 ff ff       	jmp    801061e4 <alltraps>

80106f07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $212
80106f09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f0e:	e9 d1 f2 ff ff       	jmp    801061e4 <alltraps>

80106f13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $213
80106f15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f1a:	e9 c5 f2 ff ff       	jmp    801061e4 <alltraps>

80106f1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $214
80106f21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f26:	e9 b9 f2 ff ff       	jmp    801061e4 <alltraps>

80106f2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $215
80106f2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f32:	e9 ad f2 ff ff       	jmp    801061e4 <alltraps>

80106f37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $216
80106f39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f3e:	e9 a1 f2 ff ff       	jmp    801061e4 <alltraps>

80106f43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $217
80106f45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f4a:	e9 95 f2 ff ff       	jmp    801061e4 <alltraps>

80106f4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $218
80106f51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f56:	e9 89 f2 ff ff       	jmp    801061e4 <alltraps>

80106f5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $219
80106f5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f62:	e9 7d f2 ff ff       	jmp    801061e4 <alltraps>

80106f67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $220
80106f69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f6e:	e9 71 f2 ff ff       	jmp    801061e4 <alltraps>

80106f73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $221
80106f75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f7a:	e9 65 f2 ff ff       	jmp    801061e4 <alltraps>

80106f7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $222
80106f81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f86:	e9 59 f2 ff ff       	jmp    801061e4 <alltraps>

80106f8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $223
80106f8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f92:	e9 4d f2 ff ff       	jmp    801061e4 <alltraps>

80106f97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $224
80106f99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f9e:	e9 41 f2 ff ff       	jmp    801061e4 <alltraps>

80106fa3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $225
80106fa5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106faa:	e9 35 f2 ff ff       	jmp    801061e4 <alltraps>

80106faf <vector226>:
.globl vector226
vector226:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $226
80106fb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fb6:	e9 29 f2 ff ff       	jmp    801061e4 <alltraps>

80106fbb <vector227>:
.globl vector227
vector227:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $227
80106fbd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fc2:	e9 1d f2 ff ff       	jmp    801061e4 <alltraps>

80106fc7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $228
80106fc9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fce:	e9 11 f2 ff ff       	jmp    801061e4 <alltraps>

80106fd3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $229
80106fd5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fda:	e9 05 f2 ff ff       	jmp    801061e4 <alltraps>

80106fdf <vector230>:
.globl vector230
vector230:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $230
80106fe1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fe6:	e9 f9 f1 ff ff       	jmp    801061e4 <alltraps>

80106feb <vector231>:
.globl vector231
vector231:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $231
80106fed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ff2:	e9 ed f1 ff ff       	jmp    801061e4 <alltraps>

80106ff7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $232
80106ff9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ffe:	e9 e1 f1 ff ff       	jmp    801061e4 <alltraps>

80107003 <vector233>:
.globl vector233
vector233:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $233
80107005:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010700a:	e9 d5 f1 ff ff       	jmp    801061e4 <alltraps>

8010700f <vector234>:
.globl vector234
vector234:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $234
80107011:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107016:	e9 c9 f1 ff ff       	jmp    801061e4 <alltraps>

8010701b <vector235>:
.globl vector235
vector235:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $235
8010701d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107022:	e9 bd f1 ff ff       	jmp    801061e4 <alltraps>

80107027 <vector236>:
.globl vector236
vector236:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $236
80107029:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010702e:	e9 b1 f1 ff ff       	jmp    801061e4 <alltraps>

80107033 <vector237>:
.globl vector237
vector237:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $237
80107035:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010703a:	e9 a5 f1 ff ff       	jmp    801061e4 <alltraps>

8010703f <vector238>:
.globl vector238
vector238:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $238
80107041:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107046:	e9 99 f1 ff ff       	jmp    801061e4 <alltraps>

8010704b <vector239>:
.globl vector239
vector239:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $239
8010704d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107052:	e9 8d f1 ff ff       	jmp    801061e4 <alltraps>

80107057 <vector240>:
.globl vector240
vector240:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $240
80107059:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010705e:	e9 81 f1 ff ff       	jmp    801061e4 <alltraps>

80107063 <vector241>:
.globl vector241
vector241:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $241
80107065:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010706a:	e9 75 f1 ff ff       	jmp    801061e4 <alltraps>

8010706f <vector242>:
.globl vector242
vector242:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $242
80107071:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107076:	e9 69 f1 ff ff       	jmp    801061e4 <alltraps>

8010707b <vector243>:
.globl vector243
vector243:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $243
8010707d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107082:	e9 5d f1 ff ff       	jmp    801061e4 <alltraps>

80107087 <vector244>:
.globl vector244
vector244:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $244
80107089:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010708e:	e9 51 f1 ff ff       	jmp    801061e4 <alltraps>

80107093 <vector245>:
.globl vector245
vector245:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $245
80107095:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010709a:	e9 45 f1 ff ff       	jmp    801061e4 <alltraps>

8010709f <vector246>:
.globl vector246
vector246:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $246
801070a1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801070a6:	e9 39 f1 ff ff       	jmp    801061e4 <alltraps>

801070ab <vector247>:
.globl vector247
vector247:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $247
801070ad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070b2:	e9 2d f1 ff ff       	jmp    801061e4 <alltraps>

801070b7 <vector248>:
.globl vector248
vector248:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $248
801070b9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070be:	e9 21 f1 ff ff       	jmp    801061e4 <alltraps>

801070c3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $249
801070c5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070ca:	e9 15 f1 ff ff       	jmp    801061e4 <alltraps>

801070cf <vector250>:
.globl vector250
vector250:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $250
801070d1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070d6:	e9 09 f1 ff ff       	jmp    801061e4 <alltraps>

801070db <vector251>:
.globl vector251
vector251:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $251
801070dd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070e2:	e9 fd f0 ff ff       	jmp    801061e4 <alltraps>

801070e7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $252
801070e9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070ee:	e9 f1 f0 ff ff       	jmp    801061e4 <alltraps>

801070f3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $253
801070f5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070fa:	e9 e5 f0 ff ff       	jmp    801061e4 <alltraps>

801070ff <vector254>:
.globl vector254
vector254:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $254
80107101:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107106:	e9 d9 f0 ff ff       	jmp    801061e4 <alltraps>

8010710b <vector255>:
.globl vector255
vector255:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $255
8010710d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107112:	e9 cd f0 ff ff       	jmp    801061e4 <alltraps>
80107117:	66 90                	xchg   %ax,%ax
80107119:	66 90                	xchg   %ax,%ax
8010711b:	66 90                	xchg   %ax,%ax
8010711d:	66 90                	xchg   %ax,%ax
8010711f:	90                   	nop

80107120 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107126:	e8 a5 ca ff ff       	call   80103bd0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010712b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107131:	31 c9                	xor    %ecx,%ecx
80107133:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107138:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
8010713f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107146:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010714b:	31 c9                	xor    %ecx,%ecx
8010714d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107154:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107159:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107160:	31 c9                	xor    %ecx,%ecx
80107162:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80107169:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107170:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107175:	31 c9                	xor    %ecx,%ecx
80107177:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010717e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107185:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010718a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80107191:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80107198:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010719f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
801071a6:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
801071ad:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
801071b4:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071bb:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
801071c2:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
801071c9:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
801071d0:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071d7:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
801071de:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
801071e5:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
801071ec:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
801071f3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801071fa:	05 f0 37 11 80       	add    $0x801137f0,%eax
801071ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107203:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107207:	c1 e8 10             	shr    $0x10,%eax
8010720a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010720e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107211:	0f 01 10             	lgdtl  (%eax)
}
80107214:	c9                   	leave  
80107215:	c3                   	ret    
80107216:	8d 76 00             	lea    0x0(%esi),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 0c             	sub    $0xc,%esp
80107229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010722c:	8b 55 08             	mov    0x8(%ebp),%edx
8010722f:	89 df                	mov    %ebx,%edi
80107231:	c1 ef 16             	shr    $0x16,%edi
80107234:	8d 3c ba             	lea    (%edx,%edi,4),%edi
  if(*pde & PTE_P){
80107237:	8b 07                	mov    (%edi),%eax
80107239:	a8 01                	test   $0x1,%al
8010723b:	74 23                	je     80107260 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010723d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107242:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107248:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010724b:	c1 eb 0a             	shr    $0xa,%ebx
8010724e:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80107254:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107257:	5b                   	pop    %ebx
80107258:	5e                   	pop    %esi
80107259:	5f                   	pop    %edi
8010725a:	5d                   	pop    %ebp
8010725b:	c3                   	ret    
8010725c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107260:	8b 45 10             	mov    0x10(%ebp),%eax
80107263:	85 c0                	test   %eax,%eax
80107265:	74 31                	je     80107298 <walkpgdir+0x78>
80107267:	e8 44 b6 ff ff       	call   801028b0 <kalloc>
8010726c:	85 c0                	test   %eax,%eax
8010726e:	89 c6                	mov    %eax,%esi
80107270:	74 26                	je     80107298 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107272:	83 ec 04             	sub    $0x4,%esp
80107275:	68 00 10 00 00       	push   $0x1000
8010727a:	6a 00                	push   $0x0
8010727c:	50                   	push   %eax
8010727d:	e8 ce da ff ff       	call   80104d50 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107282:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107288:	83 c4 10             	add    $0x10,%esp
8010728b:	83 c8 07             	or     $0x7,%eax
8010728e:	89 07                	mov    %eax,(%edi)
80107290:	eb b6                	jmp    80107248 <walkpgdir+0x28>
80107292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  return &pgtab[PTX(va)];
}
80107298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010729b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010729d:	5b                   	pop    %ebx
8010729e:	5e                   	pop    %esi
8010729f:	5f                   	pop    %edi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret    
801072a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072ba:	56                   	push   %esi
801072bb:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801072bc:	89 d6                	mov    %edx,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072c3:	83 ec 1c             	sub    $0x1c,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801072c6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072cf:	8b 45 08             	mov    0x8(%ebp),%eax
801072d2:	29 f0                	sub    %esi,%eax
801072d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801072d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801072da:	83 c8 01             	or     $0x1,%eax
801072dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801072e0:	eb 1b                	jmp    801072fd <mappages+0x4d>
801072e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072e8:	f6 00 01             	testb  $0x1,(%eax)
801072eb:	75 45                	jne    80107332 <mappages+0x82>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072ed:	0b 5d dc             	or     -0x24(%ebp),%ebx
    if(a == last)
801072f0:	3b 75 e0             	cmp    -0x20(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801072f3:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072f5:	74 31                	je     80107328 <mappages+0x78>
      break;
    a += PGSIZE;
801072f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801072fd:	83 ec 04             	sub    $0x4,%esp
80107300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107303:	6a 01                	push   $0x1
80107305:	56                   	push   %esi
80107306:	57                   	push   %edi
80107307:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
8010730a:	e8 11 ff ff ff       	call   80107220 <walkpgdir>
8010730f:	83 c4 10             	add    $0x10,%esp
80107312:	85 c0                	test   %eax,%eax
80107314:	75 d2                	jne    801072e8 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107316:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80107319:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010731e:	5b                   	pop    %ebx
8010731f:	5e                   	pop    %esi
80107320:	5f                   	pop    %edi
80107321:	5d                   	pop    %ebp
80107322:	c3                   	ret    
80107323:	90                   	nop
80107324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107328:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010732b:	31 c0                	xor    %eax,%eax
}
8010732d:	5b                   	pop    %ebx
8010732e:	5e                   	pop    %esi
8010732f:	5f                   	pop    %edi
80107330:	5d                   	pop    %ebp
80107331:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80107332:	83 ec 0c             	sub    $0xc,%esp
80107335:	68 28 84 10 80       	push   $0x80108428
8010733a:	e8 31 90 ff ff       	call   80100370 <panic>
8010733f:	90                   	nop

80107340 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107348:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010734e:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107350:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107356:	83 ec 1c             	sub    $0x1c,%esp
80107359:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010735c:	39 da                	cmp    %ebx,%edx
8010735e:	73 6a                	jae    801073ca <deallocuvm.part.0+0x8a>
80107360:	89 d7                	mov    %edx,%edi
80107362:	eb 3b                	jmp    8010739f <deallocuvm.part.0+0x5f>
80107364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107368:	8b 08                	mov    (%eax),%ecx
8010736a:	f6 c1 01             	test   $0x1,%cl
8010736d:	74 26                	je     80107395 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010736f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107375:	74 5e                	je     801073d5 <deallocuvm.part.0+0x95>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107377:	83 ec 0c             	sub    $0xc,%esp
8010737a:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107383:	51                   	push   %ecx
80107384:	e8 77 b3 ff ff       	call   80102700 <kfree>
      *pte = 0;
80107389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010738c:	83 c4 10             	add    $0x10,%esp
8010738f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107395:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010739b:	39 df                	cmp    %ebx,%edi
8010739d:	73 2b                	jae    801073ca <deallocuvm.part.0+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010739f:	83 ec 04             	sub    $0x4,%esp
801073a2:	6a 00                	push   $0x0
801073a4:	57                   	push   %edi
801073a5:	56                   	push   %esi
801073a6:	e8 75 fe ff ff       	call   80107220 <walkpgdir>
    if(!pte)
801073ab:	83 c4 10             	add    $0x10,%esp
801073ae:	85 c0                	test   %eax,%eax
801073b0:	75 b6                	jne    80107368 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073b2:	89 fa                	mov    %edi,%edx
801073b4:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801073ba:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801073c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073c6:	39 df                	cmp    %ebx,%edi
801073c8:	72 d5                	jb     8010739f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801073ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d0:	5b                   	pop    %ebx
801073d1:	5e                   	pop    %esi
801073d2:	5f                   	pop    %edi
801073d3:	5d                   	pop    %ebp
801073d4:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801073d5:	83 ec 0c             	sub    $0xc,%esp
801073d8:	68 3a 7d 10 80       	push   $0x80107d3a
801073dd:	e8 8e 8f ff ff       	call   80100370 <panic>
801073e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073f0:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801073f5:	55                   	push   %ebp
801073f6:	89 e5                	mov    %esp,%ebp
801073f8:	05 00 00 00 80       	add    $0x80000000,%eax
801073fd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107400:	5d                   	pop    %ebp
80107401:	c3                   	ret    
80107402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010741c:	85 f6                	test   %esi,%esi
8010741e:	0f 84 cd 00 00 00    	je     801074f1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107424:	8b 46 08             	mov    0x8(%esi),%eax
80107427:	85 c0                	test   %eax,%eax
80107429:	0f 84 dc 00 00 00    	je     8010750b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010742f:	8b 7e 04             	mov    0x4(%esi),%edi
80107432:	85 ff                	test   %edi,%edi
80107434:	0f 84 c4 00 00 00    	je     801074fe <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010743a:	e8 31 d7 ff ff       	call   80104b70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010743f:	e8 0c c7 ff ff       	call   80103b50 <mycpu>
80107444:	89 c3                	mov    %eax,%ebx
80107446:	e8 05 c7 ff ff       	call   80103b50 <mycpu>
8010744b:	89 c7                	mov    %eax,%edi
8010744d:	e8 fe c6 ff ff       	call   80103b50 <mycpu>
80107452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107455:	83 c7 08             	add    $0x8,%edi
80107458:	e8 f3 c6 ff ff       	call   80103b50 <mycpu>
8010745d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107460:	83 c0 08             	add    $0x8,%eax
80107463:	ba 67 00 00 00       	mov    $0x67,%edx
80107468:	c1 e8 18             	shr    $0x18,%eax
8010746b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107472:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107479:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107480:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107487:	83 c1 08             	add    $0x8,%ecx
8010748a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107490:	c1 e9 10             	shr    $0x10,%ecx
80107493:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107499:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010749e:	e8 ad c6 ff ff       	call   80103b50 <mycpu>
801074a3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801074aa:	e8 a1 c6 ff ff       	call   80103b50 <mycpu>
801074af:	b9 10 00 00 00       	mov    $0x10,%ecx
801074b4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074b8:	e8 93 c6 ff ff       	call   80103b50 <mycpu>
801074bd:	8b 56 08             	mov    0x8(%esi),%edx
801074c0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801074c6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074c9:	e8 82 c6 ff ff       	call   80103b50 <mycpu>
801074ce:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801074d2:	b8 28 00 00 00       	mov    $0x28,%eax
801074d7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074da:	8b 46 04             	mov    0x4(%esi),%eax
801074dd:	05 00 00 00 80       	add    $0x80000000,%eax
801074e2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801074e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e8:	5b                   	pop    %ebx
801074e9:	5e                   	pop    %esi
801074ea:	5f                   	pop    %edi
801074eb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801074ec:	e9 bf d6 ff ff       	jmp    80104bb0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801074f1:	83 ec 0c             	sub    $0xc,%esp
801074f4:	68 2e 84 10 80       	push   $0x8010842e
801074f9:	e8 72 8e ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801074fe:	83 ec 0c             	sub    $0xc,%esp
80107501:	68 59 84 10 80       	push   $0x80108459
80107506:	e8 65 8e ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010750b:	83 ec 0c             	sub    $0xc,%esp
8010750e:	68 44 84 10 80       	push   $0x80108444
80107513:	e8 58 8e ff ff       	call   80100370 <panic>
80107518:	90                   	nop
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107520 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 1c             	sub    $0x1c,%esp
80107529:	8b 75 10             	mov    0x10(%ebp),%esi
8010752c:	8b 45 08             	mov    0x8(%ebp),%eax
8010752f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107532:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010753b:	77 49                	ja     80107586 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010753d:	e8 6e b3 ff ff       	call   801028b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107542:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107545:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107547:	68 00 10 00 00       	push   $0x1000
8010754c:	6a 00                	push   $0x0
8010754e:	50                   	push   %eax
8010754f:	e8 fc d7 ff ff       	call   80104d50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107554:	58                   	pop    %eax
80107555:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010755b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107560:	5a                   	pop    %edx
80107561:	6a 06                	push   $0x6
80107563:	50                   	push   %eax
80107564:	31 d2                	xor    %edx,%edx
80107566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107569:	e8 42 fd ff ff       	call   801072b0 <mappages>
  memmove(mem, init, sz);
8010756e:	89 75 10             	mov    %esi,0x10(%ebp)
80107571:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107574:	83 c4 10             	add    $0x10,%esp
80107577:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010757a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010757d:	5b                   	pop    %ebx
8010757e:	5e                   	pop    %esi
8010757f:	5f                   	pop    %edi
80107580:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107581:	e9 7a d8 ff ff       	jmp    80104e00 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	68 6d 84 10 80       	push   $0x8010846d
8010758e:	e8 dd 8d ff ff       	call   80100370 <panic>
80107593:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075a0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801075a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801075b0:	0f 85 99 00 00 00    	jne    8010764f <loaduvm+0xaf>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801075b6:	8b 5d 18             	mov    0x18(%ebp),%ebx
801075b9:	31 ff                	xor    %edi,%edi
801075bb:	85 db                	test   %ebx,%ebx
801075bd:	75 1a                	jne    801075d9 <loaduvm+0x39>
801075bf:	eb 77                	jmp    80107638 <loaduvm+0x98>
801075c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075c8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075ce:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801075d4:	39 7d 18             	cmp    %edi,0x18(%ebp)
801075d7:	76 5f                	jbe    80107638 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801075d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801075dc:	83 ec 04             	sub    $0x4,%esp
801075df:	6a 00                	push   $0x0
801075e1:	01 f8                	add    %edi,%eax
801075e3:	50                   	push   %eax
801075e4:	ff 75 08             	pushl  0x8(%ebp)
801075e7:	e8 34 fc ff ff       	call   80107220 <walkpgdir>
801075ec:	83 c4 10             	add    $0x10,%esp
801075ef:	85 c0                	test   %eax,%eax
801075f1:	74 4f                	je     80107642 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801075f3:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801075f8:	be 00 10 00 00       	mov    $0x1000,%esi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801075fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107602:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107608:	0f 46 f3             	cmovbe %ebx,%esi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010760b:	01 f9                	add    %edi,%ecx
8010760d:	05 00 00 00 80       	add    $0x80000000,%eax
80107612:	56                   	push   %esi
80107613:	51                   	push   %ecx
80107614:	50                   	push   %eax
80107615:	ff 75 10             	pushl  0x10(%ebp)
80107618:	e8 53 a7 ff ff       	call   80101d70 <readi>
8010761d:	83 c4 10             	add    $0x10,%esp
80107620:	39 c6                	cmp    %eax,%esi
80107622:	74 a4                	je     801075c8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107624:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010762c:	5b                   	pop    %ebx
8010762d:	5e                   	pop    %esi
8010762e:	5f                   	pop    %edi
8010762f:	5d                   	pop    %ebp
80107630:	c3                   	ret    
80107631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107638:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010763b:	31 c0                	xor    %eax,%eax
}
8010763d:	5b                   	pop    %ebx
8010763e:	5e                   	pop    %esi
8010763f:	5f                   	pop    %edi
80107640:	5d                   	pop    %ebp
80107641:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107642:	83 ec 0c             	sub    $0xc,%esp
80107645:	68 87 84 10 80       	push   $0x80108487
8010764a:	e8 21 8d ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010764f:	83 ec 0c             	sub    $0xc,%esp
80107652:	68 28 85 10 80       	push   $0x80108528
80107657:	e8 14 8d ff ff       	call   80100370 <panic>
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107660 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 0c             	sub    $0xc,%esp
80107669:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010766c:	85 ff                	test   %edi,%edi
8010766e:	0f 88 ca 00 00 00    	js     8010773e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107674:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107677:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010767a:	0f 82 82 00 00 00    	jb     80107702 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107680:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107686:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010768c:	39 df                	cmp    %ebx,%edi
8010768e:	77 43                	ja     801076d3 <allocuvm+0x73>
80107690:	e9 bb 00 00 00       	jmp    80107750 <allocuvm+0xf0>
80107695:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107698:	83 ec 04             	sub    $0x4,%esp
8010769b:	68 00 10 00 00       	push   $0x1000
801076a0:	6a 00                	push   $0x0
801076a2:	50                   	push   %eax
801076a3:	e8 a8 d6 ff ff       	call   80104d50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801076a8:	58                   	pop    %eax
801076a9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076af:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076b4:	5a                   	pop    %edx
801076b5:	6a 06                	push   $0x6
801076b7:	50                   	push   %eax
801076b8:	89 da                	mov    %ebx,%edx
801076ba:	8b 45 08             	mov    0x8(%ebp),%eax
801076bd:	e8 ee fb ff ff       	call   801072b0 <mappages>
801076c2:	83 c4 10             	add    $0x10,%esp
801076c5:	85 c0                	test   %eax,%eax
801076c7:	78 47                	js     80107710 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801076c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076cf:	39 df                	cmp    %ebx,%edi
801076d1:	76 7d                	jbe    80107750 <allocuvm+0xf0>
    mem = kalloc();
801076d3:	e8 d8 b1 ff ff       	call   801028b0 <kalloc>
    if(mem == 0){
801076d8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801076da:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801076dc:	75 ba                	jne    80107698 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801076de:	83 ec 0c             	sub    $0xc,%esp
801076e1:	68 a5 84 10 80       	push   $0x801084a5
801076e6:	e8 75 8f ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801076eb:	83 c4 10             	add    $0x10,%esp
801076ee:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801076f1:	76 4b                	jbe    8010773e <allocuvm+0xde>
801076f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076f6:	8b 45 08             	mov    0x8(%ebp),%eax
801076f9:	89 fa                	mov    %edi,%edx
801076fb:	e8 40 fc ff ff       	call   80107340 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107700:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107702:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107705:	5b                   	pop    %ebx
80107706:	5e                   	pop    %esi
80107707:	5f                   	pop    %edi
80107708:	5d                   	pop    %ebp
80107709:	c3                   	ret    
8010770a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	68 bd 84 10 80       	push   $0x801084bd
80107718:	e8 43 8f ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010771d:	83 c4 10             	add    $0x10,%esp
80107720:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107723:	76 0d                	jbe    80107732 <allocuvm+0xd2>
80107725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107728:	8b 45 08             	mov    0x8(%ebp),%eax
8010772b:	89 fa                	mov    %edi,%edx
8010772d:	e8 0e fc ff ff       	call   80107340 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107732:	83 ec 0c             	sub    $0xc,%esp
80107735:	56                   	push   %esi
80107736:	e8 c5 af ff ff       	call   80102700 <kfree>
      return 0;
8010773b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010773e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107741:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107743:	5b                   	pop    %ebx
80107744:	5e                   	pop    %esi
80107745:	5f                   	pop    %edi
80107746:	5d                   	pop    %ebp
80107747:	c3                   	ret    
80107748:	90                   	nop
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107750:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107753:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107755:	5b                   	pop    %ebx
80107756:	5e                   	pop    %esi
80107757:	5f                   	pop    %edi
80107758:	5d                   	pop    %ebp
80107759:	c3                   	ret    
8010775a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107760 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	8b 55 0c             	mov    0xc(%ebp),%edx
80107766:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107769:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010776c:	39 d1                	cmp    %edx,%ecx
8010776e:	73 10                	jae    80107780 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107770:	5d                   	pop    %ebp
80107771:	e9 ca fb ff ff       	jmp    80107340 <deallocuvm.part.0>
80107776:	8d 76 00             	lea    0x0(%esi),%esi
80107779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107780:	89 d0                	mov    %edx,%eax
80107782:	5d                   	pop    %ebp
80107783:	c3                   	ret    
80107784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010778a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107790 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 0c             	sub    $0xc,%esp
80107799:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010779c:	85 f6                	test   %esi,%esi
8010779e:	74 59                	je     801077f9 <freevm+0x69>
801077a0:	31 c9                	xor    %ecx,%ecx
801077a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801077a7:	89 f0                	mov    %esi,%eax
801077a9:	e8 92 fb ff ff       	call   80107340 <deallocuvm.part.0>
801077ae:	89 f3                	mov    %esi,%ebx
801077b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077b6:	eb 0f                	jmp    801077c7 <freevm+0x37>
801077b8:	90                   	nop
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077c0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077c3:	39 fb                	cmp    %edi,%ebx
801077c5:	74 23                	je     801077ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077c7:	8b 03                	mov    (%ebx),%eax
801077c9:	a8 01                	test   $0x1,%al
801077cb:	74 f3                	je     801077c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801077cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077d2:	83 ec 0c             	sub    $0xc,%esp
801077d5:	83 c3 04             	add    $0x4,%ebx
801077d8:	05 00 00 00 80       	add    $0x80000000,%eax
801077dd:	50                   	push   %eax
801077de:	e8 1d af ff ff       	call   80102700 <kfree>
801077e3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077e6:	39 fb                	cmp    %edi,%ebx
801077e8:	75 dd                	jne    801077c7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801077ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077f0:	5b                   	pop    %ebx
801077f1:	5e                   	pop    %esi
801077f2:	5f                   	pop    %edi
801077f3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801077f4:	e9 07 af ff ff       	jmp    80102700 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801077f9:	83 ec 0c             	sub    $0xc,%esp
801077fc:	68 d9 84 10 80       	push   $0x801084d9
80107801:	e8 6a 8b ff ff       	call   80100370 <panic>
80107806:	8d 76 00             	lea    0x0(%esi),%esi
80107809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107810 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	56                   	push   %esi
80107814:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107815:	e8 96 b0 ff ff       	call   801028b0 <kalloc>
8010781a:	85 c0                	test   %eax,%eax
8010781c:	74 6a                	je     80107888 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010781e:	83 ec 04             	sub    $0x4,%esp
80107821:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107823:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107828:	68 00 10 00 00       	push   $0x1000
8010782d:	6a 00                	push   $0x0
8010782f:	50                   	push   %eax
80107830:	e8 1b d5 ff ff       	call   80104d50 <memset>
80107835:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107838:	8b 43 04             	mov    0x4(%ebx),%eax
8010783b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010783e:	83 ec 08             	sub    $0x8,%esp
80107841:	8b 13                	mov    (%ebx),%edx
80107843:	ff 73 0c             	pushl  0xc(%ebx)
80107846:	50                   	push   %eax
80107847:	29 c1                	sub    %eax,%ecx
80107849:	89 f0                	mov    %esi,%eax
8010784b:	e8 60 fa ff ff       	call   801072b0 <mappages>
80107850:	83 c4 10             	add    $0x10,%esp
80107853:	85 c0                	test   %eax,%eax
80107855:	78 19                	js     80107870 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107857:	83 c3 10             	add    $0x10,%ebx
8010785a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107860:	75 d6                	jne    80107838 <setupkvm+0x28>
80107862:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107864:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107867:	5b                   	pop    %ebx
80107868:	5e                   	pop    %esi
80107869:	5d                   	pop    %ebp
8010786a:	c3                   	ret    
8010786b:	90                   	nop
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107870:	83 ec 0c             	sub    $0xc,%esp
80107873:	56                   	push   %esi
80107874:	e8 17 ff ff ff       	call   80107790 <freevm>
      return 0;
80107879:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010787c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010787f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107881:	5b                   	pop    %ebx
80107882:	5e                   	pop    %esi
80107883:	5d                   	pop    %ebp
80107884:	c3                   	ret    
80107885:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107888:	31 c0                	xor    %eax,%eax
8010788a:	eb d8                	jmp    80107864 <setupkvm+0x54>
8010788c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107890 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107896:	e8 75 ff ff ff       	call   80107810 <setupkvm>
8010789b:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
801078a0:	05 00 00 00 80       	add    $0x80000000,%eax
801078a5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801078a8:	c9                   	leave  
801078a9:	c3                   	ret    
801078aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078b6:	6a 00                	push   $0x0
801078b8:	ff 75 0c             	pushl  0xc(%ebp)
801078bb:	ff 75 08             	pushl  0x8(%ebp)
801078be:	e8 5d f9 ff ff       	call   80107220 <walkpgdir>
  if(pte == 0)
801078c3:	83 c4 10             	add    $0x10,%esp
801078c6:	85 c0                	test   %eax,%eax
801078c8:	74 05                	je     801078cf <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801078ca:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078cd:	c9                   	leave  
801078ce:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801078cf:	83 ec 0c             	sub    $0xc,%esp
801078d2:	68 ea 84 10 80       	push   $0x801084ea
801078d7:	e8 94 8a ff ff       	call   80100370 <panic>
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801078e9:	e8 22 ff ff ff       	call   80107810 <setupkvm>
801078ee:	85 c0                	test   %eax,%eax
801078f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078f3:	0f 84 c5 00 00 00    	je     801079be <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078fc:	85 c9                	test   %ecx,%ecx
801078fe:	0f 84 9c 00 00 00    	je     801079a0 <copyuvm+0xc0>
80107904:	31 ff                	xor    %edi,%edi
80107906:	eb 4a                	jmp    80107952 <copyuvm+0x72>
80107908:	90                   	nop
80107909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107910:	83 ec 04             	sub    $0x4,%esp
80107913:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107919:	68 00 10 00 00       	push   $0x1000
8010791e:	53                   	push   %ebx
8010791f:	50                   	push   %eax
80107920:	e8 db d4 ff ff       	call   80104e00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107925:	58                   	pop    %eax
80107926:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010792c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107931:	5a                   	pop    %edx
80107932:	ff 75 e4             	pushl  -0x1c(%ebp)
80107935:	50                   	push   %eax
80107936:	89 fa                	mov    %edi,%edx
80107938:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010793b:	e8 70 f9 ff ff       	call   801072b0 <mappages>
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	85 c0                	test   %eax,%eax
80107945:	78 69                	js     801079b0 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107947:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010794d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107950:	76 4e                	jbe    801079a0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107952:	83 ec 04             	sub    $0x4,%esp
80107955:	6a 00                	push   $0x0
80107957:	57                   	push   %edi
80107958:	ff 75 08             	pushl  0x8(%ebp)
8010795b:	e8 c0 f8 ff ff       	call   80107220 <walkpgdir>
80107960:	83 c4 10             	add    $0x10,%esp
80107963:	85 c0                	test   %eax,%eax
80107965:	74 68                	je     801079cf <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107967:	8b 00                	mov    (%eax),%eax
80107969:	a8 01                	test   $0x1,%al
8010796b:	74 55                	je     801079c2 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010796d:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010796f:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107974:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
8010797a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010797d:	e8 2e af ff ff       	call   801028b0 <kalloc>
80107982:	85 c0                	test   %eax,%eax
80107984:	89 c6                	mov    %eax,%esi
80107986:	75 88                	jne    80107910 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107988:	83 ec 0c             	sub    $0xc,%esp
8010798b:	ff 75 e0             	pushl  -0x20(%ebp)
8010798e:	e8 fd fd ff ff       	call   80107790 <freevm>
  return 0;
80107993:	83 c4 10             	add    $0x10,%esp
80107996:	31 c0                	xor    %eax,%eax
}
80107998:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010799b:	5b                   	pop    %ebx
8010799c:	5e                   	pop    %esi
8010799d:	5f                   	pop    %edi
8010799e:	5d                   	pop    %ebp
8010799f:	c3                   	ret    
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801079a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079a6:	5b                   	pop    %ebx
801079a7:	5e                   	pop    %esi
801079a8:	5f                   	pop    %edi
801079a9:	5d                   	pop    %ebp
801079aa:	c3                   	ret    
801079ab:	90                   	nop
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
801079b0:	83 ec 0c             	sub    $0xc,%esp
801079b3:	56                   	push   %esi
801079b4:	e8 47 ad ff ff       	call   80102700 <kfree>
      goto bad;
801079b9:	83 c4 10             	add    $0x10,%esp
801079bc:	eb ca                	jmp    80107988 <copyuvm+0xa8>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801079be:	31 c0                	xor    %eax,%eax
801079c0:	eb d6                	jmp    80107998 <copyuvm+0xb8>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801079c2:	83 ec 0c             	sub    $0xc,%esp
801079c5:	68 0e 85 10 80       	push   $0x8010850e
801079ca:	e8 a1 89 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801079cf:	83 ec 0c             	sub    $0xc,%esp
801079d2:	68 f4 84 10 80       	push   $0x801084f4
801079d7:	e8 94 89 ff ff       	call   80100370 <panic>
801079dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801079e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079e6:	6a 00                	push   $0x0
801079e8:	ff 75 0c             	pushl  0xc(%ebp)
801079eb:	ff 75 08             	pushl  0x8(%ebp)
801079ee:	e8 2d f8 ff ff       	call   80107220 <walkpgdir>
  if((*pte & PTE_P) == 0)
801079f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801079f5:	83 c4 10             	add    $0x10,%esp
801079f8:	89 c2                	mov    %eax,%edx
801079fa:	83 e2 05             	and    $0x5,%edx
801079fd:	83 fa 05             	cmp    $0x5,%edx
80107a00:	75 0e                	jne    80107a10 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107a07:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107a08:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107a0d:	c3                   	ret    
80107a0e:	66 90                	xchg   %ax,%ax

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107a10:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a12:	c9                   	leave  
80107a13:	c3                   	ret    
80107a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a20 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 1c             	sub    $0x1c,%esp
80107a29:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a32:	85 db                	test   %ebx,%ebx
80107a34:	75 40                	jne    80107a76 <copyout+0x56>
80107a36:	eb 70                	jmp    80107aa8 <copyout+0x88>
80107a38:	90                   	nop
80107a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a43:	89 f1                	mov    %esi,%ecx
80107a45:	29 d1                	sub    %edx,%ecx
80107a47:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107a4d:	39 d9                	cmp    %ebx,%ecx
80107a4f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a52:	29 f2                	sub    %esi,%edx
80107a54:	83 ec 04             	sub    $0x4,%esp
80107a57:	01 d0                	add    %edx,%eax
80107a59:	51                   	push   %ecx
80107a5a:	57                   	push   %edi
80107a5b:	50                   	push   %eax
80107a5c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107a5f:	e8 9c d3 ff ff       	call   80104e00 <memmove>
    len -= n;
    buf += n;
80107a64:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a67:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107a6a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107a70:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a72:	29 cb                	sub    %ecx,%ebx
80107a74:	74 32                	je     80107aa8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107a76:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a78:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107a7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107a7e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a84:	56                   	push   %esi
80107a85:	ff 75 08             	pushl  0x8(%ebp)
80107a88:	e8 53 ff ff ff       	call   801079e0 <uva2ka>
    if(pa0 == 0)
80107a8d:	83 c4 10             	add    $0x10,%esp
80107a90:	85 c0                	test   %eax,%eax
80107a92:	75 ac                	jne    80107a40 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107a94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107a9c:	5b                   	pop    %ebx
80107a9d:	5e                   	pop    %esi
80107a9e:	5f                   	pop    %edi
80107a9f:	5d                   	pop    %ebp
80107aa0:	c3                   	ret    
80107aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107aab:	31 c0                	xor    %eax,%eax
}
80107aad:	5b                   	pop    %ebx
80107aae:	5e                   	pop    %esi
80107aaf:	5f                   	pop    %edi
80107ab0:	5d                   	pop    %ebp
80107ab1:	c3                   	ret    
