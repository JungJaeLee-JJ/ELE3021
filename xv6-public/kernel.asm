
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
8010004c:	68 a0 7a 10 80       	push   $0x80107aa0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 75 4a 00 00       	call   80104ad0 <initlock>

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
80100092:	68 a7 7a 10 80       	push   $0x80107aa7
80100097:	50                   	push   %eax
80100098:	e8 03 49 00 00       	call   801049a0 <initsleeplock>
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
801000e4:	e8 47 4b 00 00       	call   80104c30 <acquire>

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
80100162:	e8 79 4b 00 00       	call   80104ce0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 48 00 00       	call   801049e0 <acquiresleep>
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
80100193:	68 ae 7a 10 80       	push   $0x80107aae
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
801001ae:	e8 cd 48 00 00       	call   80104a80 <holdingsleep>
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
801001cc:	68 bf 7a 10 80       	push   $0x80107abf
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
801001ef:	e8 8c 48 00 00       	call   80104a80 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 48 00 00       	call   80104a40 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 20 4a 00 00       	call   80104c30 <acquire>
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
8010025c:	e9 7f 4a 00 00       	jmp    80104ce0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 7a 10 80       	push   $0x80107ac6
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
8010028c:	e8 9f 49 00 00       	call   80104c30 <acquire>
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
801002bd:	e8 5e 43 00 00       	call   80104620 <sleep>

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
801002e6:	e8 f5 49 00 00       	call   80104ce0 <release>
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
80100346:	e8 95 49 00 00       	call   80104ce0 <release>
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
80100392:	68 cd 7a 10 80       	push   $0x80107acd
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 97 84 10 80 	movl   $0x80108497,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 33 47 00 00       	call   80104af0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 e1 7a 10 80       	push   $0x80107ae1
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
8010041a:	e8 21 62 00 00       	call   80106640 <uartputc>
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
801004d3:	e8 68 61 00 00       	call   80106640 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 5c 61 00 00       	call   80106640 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 50 61 00 00       	call   80106640 <uartputc>
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
80100514:	e8 c7 48 00 00       	call   80104de0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 02 48 00 00       	call   80104d30 <memset>
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
80100540:	68 e5 7a 10 80       	push   $0x80107ae5
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
801005b1:	0f b6 92 10 7b 10 80 	movzbl -0x7fef84f0(%edx),%edx
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
8010061b:	e8 10 46 00 00       	call   80104c30 <acquire>
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
80100647:	e8 94 46 00 00       	call   80104ce0 <release>
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
8010070d:	e8 ce 45 00 00       	call   80104ce0 <release>
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
80100788:	b8 f8 7a 10 80       	mov    $0x80107af8,%eax
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
801007c8:	e8 63 44 00 00       	call   80104c30 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 ff 7a 10 80       	push   $0x80107aff
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
80100803:	e8 28 44 00 00       	call   80104c30 <acquire>
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
80100868:	e8 73 44 00 00       	call   80104ce0 <release>
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
801008f6:	e8 f5 3e 00 00       	call   801047f0 <wakeup>
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
80100977:	e9 64 3f 00 00       	jmp    801048e0 <procdump>
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
801009a6:	68 08 7b 10 80       	push   $0x80107b08
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 1b 41 00 00       	call   80104ad0 <initlock>

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
80100a01:	89 c6                	mov    %eax,%esi

  //cprintf("%s , %s \n",path,*argv);

  //for shard memory
  curproc->shared_memory_address = kalloc();
80100a03:	e8 78 1e 00 00       	call   80102880 <kalloc>
80100a08:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)

  begin_op();
80100a0e:	e8 2d 25 00 00       	call   80102f40 <begin_op>

  if((ip = namei(path)) == 0){
80100a13:	83 ec 0c             	sub    $0xc,%esp
80100a16:	ff 75 08             	pushl  0x8(%ebp)
80100a19:	e8 92 18 00 00       	call   801022b0 <namei>
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
80100a2f:	e8 2c 10 00 00       	call   80101a60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a34:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a3a:	6a 34                	push   $0x34
80100a3c:	6a 00                	push   $0x0
80100a3e:	50                   	push   %eax
80100a3f:	53                   	push   %ebx
80100a40:	e8 fb 12 00 00       	call   80101d40 <readi>
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
80100a51:	e8 9a 12 00 00       	call   80101cf0 <iunlockput>
    end_op();
80100a56:	e8 55 25 00 00       	call   80102fb0 <end_op>
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
80100a7c:	e8 6f 6d 00 00       	call   801077f0 <setupkvm>
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
80100ad8:	e8 63 12 00 00       	call   80101d40 <readi>
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
80100b14:	e8 27 6b 00 00       	call   80107640 <allocuvm>
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
80100b4a:	e8 31 6a 00 00       	call   80107580 <loaduvm>
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
80100b69:	e8 02 6c 00 00       	call   80107770 <freevm>
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
80100b80:	e8 6b 11 00 00       	call   80101cf0 <iunlockput>
  end_op();
80100b85:	e8 26 24 00 00       	call   80102fb0 <end_op>
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
80100bab:	e8 90 6a 00 00       	call   80107640 <allocuvm>
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
80100bc6:	e8 a5 6b 00 00       	call   80107770 <freevm>
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
80100bd8:	e8 d3 23 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100bdd:	83 ec 0c             	sub    $0xc,%esp
80100be0:	68 21 7b 10 80       	push   $0x80107b21
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
80100c10:	e8 7b 6c 00 00       	call   80107890 <clearpteu>
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
80100c41:	e8 2a 43 00 00       	call   80104f70 <strlen>
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
80100c54:	e8 17 43 00 00       	call   80104f70 <strlen>
80100c59:	83 c0 01             	add    $0x1,%eax
80100c5c:	50                   	push   %eax
80100c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c60:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c63:	53                   	push   %ebx
80100c64:	56                   	push   %esi
80100c65:	e8 96 6d 00 00       	call   80107a00 <copyout>
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
80100ccf:	e8 2c 6d 00 00       	call   80107a00 <copyout>
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
80100d0c:	e8 1f 42 00 00       	call   80104f30 <safestrcpy>

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
80100d5e:	e8 8d 66 00 00       	call   801073f0 <switchuvm>
  freevm(oldpgdir);
80100d63:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d69:	89 04 24             	mov    %eax,(%esp)
80100d6c:	e8 ff 69 00 00       	call   80107770 <freevm>
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
80100d9c:	e8 1f 2e 00 00       	call   80103bc0 <myproc>
80100da1:	89 c6                	mov    %eax,%esi

  //for shard memory
  curproc->shared_memory_address = kalloc();
80100da3:	e8 d8 1a 00 00       	call   80102880 <kalloc>

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
80100dbc:	e8 7f 21 00 00       	call   80102f40 <begin_op>

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	ff 75 08             	pushl  0x8(%ebp)
80100dc7:	e8 e4 14 00 00       	call   801022b0 <namei>
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
80100ddd:	e8 7e 0c 00 00       	call   80101a60 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100de2:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100de8:	6a 34                	push   $0x34
80100dea:	6a 00                	push   $0x0
80100dec:	50                   	push   %eax
80100ded:	53                   	push   %ebx
80100dee:	e8 4d 0f 00 00       	call   80101d40 <readi>
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
80100e03:	e8 e8 0e 00 00       	call   80101cf0 <iunlockput>
    end_op();
80100e08:	e8 a3 21 00 00       	call   80102fb0 <end_op>
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
80100e27:	e8 c4 0e 00 00       	call   80101cf0 <iunlockput>
  end_op();
80100e2c:	e8 7f 21 00 00       	call   80102fb0 <end_op>
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
80100e58:	e8 e3 67 00 00       	call   80107640 <allocuvm>
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
80100e77:	e8 f4 68 00 00       	call   80107770 <freevm>
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
80100ea0:	e8 4b 69 00 00       	call   801077f0 <setupkvm>
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
80100f00:	e8 3b 0e 00 00       	call   80101d40 <readi>
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
80100f3c:	e8 ff 66 00 00       	call   80107640 <allocuvm>
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
80100f72:	e8 09 66 00 00       	call   80107580 <loaduvm>
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
80100f91:	e8 da 67 00 00       	call   80107770 <freevm>
80100f96:	83 c4 10             	add    $0x10,%esp
80100f99:	e9 61 fe ff ff       	jmp    80100dff <exec2+0x6f>
  begin_op();

 	//cprintf("path : %s\n",path);

  if((ip = namei(path)) == 0){
    end_op();
80100f9e:	e8 0d 20 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100fa3:	83 ec 0c             	sub    $0xc,%esp
80100fa6:	68 21 7b 10 80       	push   $0x80107b21
80100fab:	e8 b0 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100fb0:	83 c4 10             	add    $0x10,%esp
80100fb3:	e9 c7 fe ff ff       	jmp    80100e7f <exec2+0xef>

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
80100fb8:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100fbe:	83 ec 08             	sub    $0x8,%esp
80100fc1:	89 f8                	mov    %edi,%eax
80100fc3:	29 d8                	sub    %ebx,%eax
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100fc5:	89 fb                	mov    %edi,%ebx
80100fc7:	31 ff                	xor    %edi,%edi

  //cprintf("sz before\n");
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + (stacksize+1)*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
80100fc9:	50                   	push   %eax
80100fca:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fd0:	e8 bb 68 00 00       	call   80107890 <clearpteu>
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fd8:	83 c4 10             	add    $0x10,%esp
80100fdb:	8b 00                	mov    (%eax),%eax
80100fdd:	85 c0                	test   %eax,%eax
80100fdf:	0f 84 5a 01 00 00    	je     8010113f <exec2+0x3af>
80100fe5:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100feb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ff1:	eb 0e                	jmp    80101001 <exec2+0x271>
80100ff3:	90                   	nop
80100ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  //cprintf("%s\n",argv[argc]);
    if(argc >= MAXARG)
80100ff8:	83 ff 20             	cmp    $0x20,%edi
80100ffb:	0f 84 6d fe ff ff    	je     80100e6e <exec2+0xde>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101001:	83 ec 0c             	sub    $0xc,%esp
80101004:	50                   	push   %eax
80101005:	e8 66 3f 00 00       	call   80104f70 <strlen>
8010100a:	f7 d0                	not    %eax
8010100c:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010100e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101011:	5a                   	pop    %edx
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
	  //cprintf("%s\n",argv[argc]);
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101012:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101015:	ff 34 b8             	pushl  (%eax,%edi,4)
80101018:	e8 53 3f 00 00       	call   80104f70 <strlen>
8010101d:	83 c0 01             	add    $0x1,%eax
80101020:	50                   	push   %eax
80101021:	8b 45 0c             	mov    0xc(%ebp),%eax
80101024:	ff 34 b8             	pushl  (%eax,%edi,4)
80101027:	53                   	push   %ebx
80101028:	56                   	push   %esi
80101029:	e8 d2 69 00 00       	call   80107a00 <copyout>
8010102e:	83 c4 20             	add    $0x20,%esp
80101031:	85 c0                	test   %eax,%eax
80101033:	0f 88 35 fe ff ff    	js     80100e6e <exec2+0xde>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101039:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
8010103c:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80101043:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80101046:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010104c:	8b 04 b8             	mov    (%eax,%edi,4),%eax
8010104f:	85 c0                	test   %eax,%eax
80101051:	75 a5                	jne    80100ff8 <exec2+0x268>
80101053:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101059:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101060:	89 da                	mov    %ebx,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80101062:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101069:	00 00 00 00 

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
8010106d:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101074:	ff ff ff 
  ustack[1] = argc;
80101077:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010107d:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
8010107f:	83 c0 0c             	add    $0xc,%eax
80101082:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101084:	50                   	push   %eax
80101085:	51                   	push   %ecx
80101086:	53                   	push   %ebx
80101087:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)

  //cprintf("argv push done \n");

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010108d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101093:	e8 68 69 00 00       	call   80107a00 <copyout>
80101098:	83 c4 10             	add    $0x10,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	0f 88 cb fd ff ff    	js     80100e6e <exec2+0xde>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010a3:	8b 45 08             	mov    0x8(%ebp),%eax
801010a6:	0f b6 10             	movzbl (%eax),%edx
801010a9:	84 d2                	test   %dl,%dl
801010ab:	74 1a                	je     801010c7 <exec2+0x337>
801010ad:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
801010b0:	80 fa 2f             	cmp    $0x2f,%dl
801010b3:	89 c2                	mov    %eax,%edx
801010b5:	0f 45 55 08          	cmovne 0x8(%ebp),%edx
801010b9:	83 c0 01             	add    $0x1,%eax
801010bc:	89 55 08             	mov    %edx,0x8(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
801010bf:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
801010c3:	84 d2                	test   %dl,%dl
801010c5:	75 e9                	jne    801010b0 <exec2+0x320>
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010c7:	50                   	push   %eax
801010c8:	8d 46 6c             	lea    0x6c(%esi),%eax
801010cb:	6a 10                	push   $0x10
801010cd:	ff 75 08             	pushl  0x8(%ebp)
801010d0:	50                   	push   %eax
801010d1:	e8 5a 3e 00 00       	call   80104f30 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010d6:	8b 46 04             	mov    0x4(%esi),%eax
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
801010d9:	8b 56 18             	mov    0x18(%esi),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
801010dc:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
801010e2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801010e8:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
801010eb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010f1:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
801010f3:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  curproc->tf->esp = sp;

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
  curproc->limit_sz = 0;
  curproc->custom_stack_size = stacksize;
801010f9:	8b 45 10             	mov    0x10(%ebp),%eax

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
801010fc:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
801010ff:	8b 56 18             	mov    0x18(%esi),%edx
80101102:	89 5a 44             	mov    %ebx,0x44(%edx)

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
  curproc->limit_sz = 0;
  curproc->custom_stack_size = stacksize;
80101105:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;

  //Admin,stacksize,memory limit initailize
  curproc->admin_mode = 0;
8010110b:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101112:	00 00 00 
  curproc->limit_sz = 0;
80101115:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
8010111c:	00 00 00 
  curproc->custom_stack_size = stacksize;

  //cprintf("initailizing done\n");

  switchuvm(curproc);
8010111f:	89 34 24             	mov    %esi,(%esp)
80101122:	e8 c9 62 00 00       	call   801073f0 <switchuvm>
  freevm(oldpgdir);
80101127:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
8010112d:	89 04 24             	mov    %eax,(%esp)
80101130:	e8 3b 66 00 00       	call   80107770 <freevm>
  return 0;
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	31 c0                	xor    %eax,%eax
8010113a:	e9 d6 fc ff ff       	jmp    80100e15 <exec2+0x85>
  clearpteu(pgdir, (char*)(sz - (stacksize+1)*PGSIZE));
  sp = sz;
  //cprintf("sz after\n");

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
8010113f:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80101145:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
8010114b:	e9 09 ff ff ff       	jmp    80101059 <exec2+0x2c9>

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
80101156:	68 2d 7b 10 80       	push   $0x80107b2d
8010115b:	68 c0 0f 11 80       	push   $0x80110fc0
80101160:	e8 6b 39 00 00       	call   80104ad0 <initlock>
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
80101181:	e8 aa 3a 00 00       	call   80104c30 <acquire>
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
801011b1:	e8 2a 3b 00 00       	call   80104ce0 <release>
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
801011c8:	e8 13 3b 00 00       	call   80104ce0 <release>
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
801011ef:	e8 3c 3a 00 00       	call   80104c30 <acquire>
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
8010120c:	e8 cf 3a 00 00       	call   80104ce0 <release>
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
8010121b:	68 34 7b 10 80       	push   $0x80107b34
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
80101241:	e8 ea 39 00 00       	call   80104c30 <acquire>
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
8010126c:	e9 6f 3a 00 00       	jmp    80104ce0 <release>
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
80101298:	e8 43 3a 00 00       	call   80104ce0 <release>

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
801012f2:	68 3c 7b 10 80       	push   $0x80107b3c
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
801013d2:	68 46 7b 10 80       	push   $0x80107b46
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
801014e4:	68 4f 7b 10 80       	push   $0x80107b4f
801014e9:	e8 82 ee ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801014ee:	83 ec 0c             	sub    $0xc,%esp
801014f1:	68 55 7b 10 80       	push   $0x80107b55
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
80101565:	68 5f 7b 10 80       	push   $0x80107b5f
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
80101612:	68 72 7b 10 80       	push   $0x80107b72
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
80101655:	e8 d6 36 00 00       	call   80104d30 <memset>
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
8010169a:	e8 91 35 00 00       	call   80104c30 <acquire>
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
801016e2:	e8 f9 35 00 00       	call   80104ce0 <release>
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
8010172f:	e8 ac 35 00 00       	call   80104ce0 <release>

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
80101744:	68 88 7b 10 80       	push   $0x80107b88
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
8010180a:	68 98 7b 10 80       	push   $0x80107b98
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
80101841:	e8 9a 35 00 00       	call   80104de0 <memmove>
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
8010186c:	68 ab 7b 10 80       	push   $0x80107bab
80101871:	68 e0 19 11 80       	push   $0x801119e0
80101876:	e8 55 32 00 00       	call   80104ad0 <initlock>
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101880:	83 ec 08             	sub    $0x8,%esp
80101883:	68 b2 7b 10 80       	push   $0x80107bb2
80101888:	53                   	push   %ebx
80101889:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010188f:	e8 0c 31 00 00       	call   801049a0 <initsleeplock>
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
801018d9:	68 18 7c 10 80       	push   $0x80107c18
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
8010196e:	e8 bd 33 00 00       	call   80104d30 <memset>
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
801019a3:	68 b8 7b 10 80       	push   $0x80107bb8
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
80101a11:	e8 ca 33 00 00       	call   80104de0 <memmove>
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
80101a3f:	e8 ec 31 00 00       	call   80104c30 <acquire>
  ip->ref++;
80101a44:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a48:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a4f:	e8 8c 32 00 00       	call   80104ce0 <release>
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
80101a82:	e8 59 2f 00 00       	call   801049e0 <acquiresleep>

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
80101af8:	e8 e3 32 00 00       	call   80104de0 <memmove>
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
80101b1d:	68 d0 7b 10 80       	push   $0x80107bd0
80101b22:	e8 49 e8 ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101b27:	83 ec 0c             	sub    $0xc,%esp
80101b2a:	68 ca 7b 10 80       	push   $0x80107bca
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
80101b53:	e8 28 2f 00 00       	call   80104a80 <holdingsleep>
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
80101b6f:	e9 cc 2e 00 00       	jmp    80104a40 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101b74:	83 ec 0c             	sub    $0xc,%esp
80101b77:	68 df 7b 10 80       	push   $0x80107bdf
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
80101ba0:	e8 3b 2e 00 00       	call   801049e0 <acquiresleep>
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
80101bba:	e8 81 2e 00 00       	call   80104a40 <releasesleep>

  acquire(&icache.lock);
80101bbf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bc6:	e8 65 30 00 00       	call   80104c30 <acquire>
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
80101be0:	e9 fb 30 00 00       	jmp    80104ce0 <release>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101be8:	83 ec 0c             	sub    $0xc,%esp
80101beb:	68 e0 19 11 80       	push   $0x801119e0
80101bf0:	e8 3b 30 00 00       	call   80104c30 <acquire>
    int r = ip->ref;
80101bf5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101bf8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101bff:	e8 dc 30 00 00       	call   80104ce0 <release>
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
80101de8:	e8 f3 2f 00 00       	call   80104de0 <memmove>
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
80101ee4:	e8 f7 2e 00 00       	call   80104de0 <memmove>
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
80101f7e:	e8 dd 2e 00 00       	call   80104e60 <strncmp>
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
80101fe5:	e8 76 2e 00 00       	call   80104e60 <strncmp>
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
8010201d:	68 f9 7b 10 80       	push   $0x80107bf9
80102022:	e8 49 e3 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80102027:	83 ec 0c             	sub    $0xc,%esp
8010202a:	68 e7 7b 10 80       	push   $0x80107be7
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
80102069:	e8 c2 2b 00 00       	call   80104c30 <acquire>
  ip->ref++;
8010206e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102072:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80102079:	e8 62 2c 00 00       	call   80104ce0 <release>
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
801020d5:	e8 06 2d 00 00       	call   80104de0 <memmove>
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
80102164:	e8 77 2c 00 00       	call   80104de0 <memmove>
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
8010224d:	e8 7e 2c 00 00       	call   80104ed0 <strncpy>
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
8010228b:	68 08 7c 10 80       	push   $0x80107c08
80102290:	e8 db e0 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102295:	83 ec 0c             	sub    $0xc,%esp
80102298:	68 7e 82 10 80       	push   $0x8010827e
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
801023a0:	68 74 7c 10 80       	push   $0x80107c74
801023a5:	e8 c6 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801023aa:	83 ec 0c             	sub    $0xc,%esp
801023ad:	68 6b 7c 10 80       	push   $0x80107c6b
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
801023c6:	68 86 7c 10 80       	push   $0x80107c86
801023cb:	68 80 b5 10 80       	push   $0x8010b580
801023d0:	e8 fb 26 00 00       	call   80104ad0 <initlock>
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
8010244e:	e8 dd 27 00 00       	call   80104c30 <acquire>

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
8010247e:	e8 6d 23 00 00       	call   801047f0 <wakeup>

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
8010249c:	e8 3f 28 00 00       	call   80104ce0 <release>
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
801024ee:	e8 8d 25 00 00       	call   80104a80 <holdingsleep>
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
80102528:	e8 03 27 00 00       	call   80104c30 <acquire>

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
80102579:	e8 a2 20 00 00       	call   80104620 <sleep>
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
80102596:	e9 45 27 00 00       	jmp    80104ce0 <release>

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
801025ae:	68 8a 7c 10 80       	push   $0x80107c8a
801025b3:	e8 b8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	68 b5 7c 10 80       	push   $0x80107cb5
801025c0:	e8 ab dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025c5:	83 ec 0c             	sub    $0xc,%esp
801025c8:	68 a0 7c 10 80       	push   $0x80107ca0
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
8010262a:	68 d4 7c 10 80       	push   $0x80107cd4
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
80102702:	e8 29 26 00 00       	call   80104d30 <memset>

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
8010273b:	e9 a0 25 00 00       	jmp    80104ce0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 40 36 11 80       	push   $0x80113640
80102748:	e8 e3 24 00 00       	call   80104c30 <acquire>
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	eb c2                	jmp    80102714 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102752:	83 ec 0c             	sub    $0xc,%esp
80102755:	68 06 7d 10 80       	push   $0x80107d06
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
801027bb:	68 0c 7d 10 80       	push   $0x80107d0c
801027c0:	68 40 36 11 80       	push   $0x80113640
801027c5:	e8 06 23 00 00       	call   80104ad0 <initlock>

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
801028ae:	e8 2d 24 00 00       	call   80104ce0 <release>
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
801028c8:	e8 63 23 00 00       	call   80104c30 <acquire>
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
80102926:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
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
8010294e:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
80102955:	09 c1                	or     %eax,%ecx
80102957:	0f b6 82 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%eax
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
8010296e:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
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
80102cd4:	e8 a7 20 00 00       	call   80104d80 <memcmp>
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
80102e04:	e8 d7 1f 00 00       	call   80104de0 <memmove>
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
80102eaa:	68 40 7f 10 80       	push   $0x80107f40
80102eaf:	68 80 36 11 80       	push   $0x80113680
80102eb4:	e8 17 1c 00 00       	call   80104ad0 <initlock>
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
80102f4b:	e8 e0 1c 00 00       	call   80104c30 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 80 36 11 80       	push   $0x80113680
80102f60:	68 80 36 11 80       	push   $0x80113680
80102f65:	e8 b6 16 00 00       	call   80104620 <sleep>
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
80102f9c:	e8 3f 1d 00 00       	call   80104ce0 <release>
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
80102fbe:	e8 6d 1c 00 00       	call   80104c30 <acquire>
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
80102ffd:	e8 de 1c 00 00       	call   80104ce0 <release>
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
8010305c:	e8 7f 1d 00 00       	call   80104de0 <memmove>
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
801030a5:	e8 86 1b 00 00       	call   80104c30 <acquire>
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
801030bb:	e8 30 17 00 00       	call   801047f0 <wakeup>
    release(&log.lock);
801030c0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030c7:	e8 14 1c 00 00       	call   80104ce0 <release>
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
801030e8:	e8 03 17 00 00       	call   801047f0 <wakeup>
  }
  release(&log.lock);
801030ed:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030f4:	e8 e7 1b 00 00       	call   80104ce0 <release>
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
80103107:	68 44 7f 10 80       	push   $0x80107f44
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
8010315e:	e8 cd 1a 00 00       	call   80104c30 <acquire>
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
801031ae:	e9 2d 1b 00 00       	jmp    80104ce0 <release>
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
801031d3:	68 53 7f 10 80       	push   $0x80107f53
801031d8:	e8 93 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
801031dd:	83 ec 0c             	sub    $0xc,%esp
801031e0:	68 69 7f 10 80       	push   $0x80107f69
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
80103208:	68 84 7f 10 80       	push   $0x80107f84
8010320d:	e8 4e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103212:	e8 79 30 00 00       	call   80106290 <idtinit>
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
8010322a:	e8 f1 0c 00 00       	call   80103f20 <scheduler>
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
80103236:	e8 95 41 00 00       	call   801073d0 <switchkvm>
  seginit();
8010323b:	e8 c0 3e 00 00       	call   80107100 <seginit>
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
80103276:	e8 f5 45 00 00       	call   80107870 <kvmalloc>
  mpinit();        // detect other processors
8010327b:	e8 70 01 00 00       	call   801033f0 <mpinit>
  lapicinit();     // interrupt controller
80103280:	e8 5b f7 ff ff       	call   801029e0 <lapicinit>
  seginit();       // segment descriptors
80103285:	e8 76 3e 00 00       	call   80107100 <seginit>
  picinit();       // disable pic
8010328a:	e8 31 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010328f:	e8 4c f3 ff ff       	call   801025e0 <ioapicinit>
  consoleinit();   // console hardware
80103294:	e8 07 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103299:	e8 e2 32 00 00       	call   80106580 <uartinit>
  pinit();         // process table
8010329e:	e8 5d 08 00 00       	call   80103b00 <pinit>
  tvinit();        // trap vectors
801032a3:	e8 48 2f 00 00       	call   801061f0 <tvinit>
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
801032c9:	e8 12 1b 00 00       	call   80104de0 <memmove>

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
80103398:	68 98 7f 10 80       	push   $0x80107f98
8010339d:	56                   	push   %esi
8010339e:	e8 dd 19 00 00       	call   80104d80 <memcmp>
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
8010345c:	68 9d 7f 10 80       	push   $0x80107f9d
80103461:	56                   	push   %esi
80103462:	e8 19 19 00 00       	call   80104d80 <memcmp>
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
801034f0:	ff 24 95 dc 7f 10 80 	jmp    *-0x7fef8024(,%edx,4)
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
80103597:	68 a2 7f 10 80       	push   $0x80107fa2
8010359c:	e8 cf cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801035a1:	83 ec 0c             	sub    $0xc,%esp
801035a4:	68 bc 7f 10 80       	push   $0x80107fbc
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
80103653:	68 f0 7f 10 80       	push   $0x80107ff0
80103658:	50                   	push   %eax
80103659:	e8 72 14 00 00       	call   80104ad0 <initlock>
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
801036ef:	e8 3c 15 00 00       	call   80104c30 <acquire>
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
8010370f:	e8 dc 10 00 00       	call   801047f0 <wakeup>
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
80103734:	e9 a7 15 00 00       	jmp    80104ce0 <release>
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
80103754:	e8 97 10 00 00       	call   801047f0 <wakeup>
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	eb b9                	jmp    80103717 <pipeclose+0x37>
8010375e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	53                   	push   %ebx
80103764:	e8 77 15 00 00       	call   80104ce0 <release>
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
8010378d:	e8 9e 14 00 00       	call   80104c30 <acquire>
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
801037e0:	e8 0b 10 00 00       	call   801047f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e5:	58                   	pop    %eax
801037e6:	5a                   	pop    %edx
801037e7:	53                   	push   %ebx
801037e8:	56                   	push   %esi
801037e9:	e8 32 0e 00 00       	call   80104620 <sleep>
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
80103814:	e8 c7 14 00 00       	call   80104ce0 <release>
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
80103863:	e8 88 0f 00 00       	call   801047f0 <wakeup>
  release(&p->lock);
80103868:	89 1c 24             	mov    %ebx,(%esp)
8010386b:	e8 70 14 00 00       	call   80104ce0 <release>
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
80103890:	e8 9b 13 00 00       	call   80104c30 <acquire>
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
801038c5:	e8 56 0d 00 00       	call   80104620 <sleep>
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
801038f9:	e8 e2 13 00 00       	call   80104ce0 <release>
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
8010395e:	e8 8d 0e 00 00       	call   801047f0 <wakeup>
  release(&p->lock);
80103963:	89 1c 24             	mov    %ebx,(%esp)
80103966:	e8 75 13 00 00       	call   80104ce0 <release>
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
801039b1:	e8 7a 12 00 00       	call   80104c30 <acquire>
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
80103a3d:	e8 9e 12 00 00       	call   80104ce0 <release>

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
80103a62:	c7 40 14 dc 61 10 80 	movl   $0x801061dc,0x14(%eax)

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
80103a71:	e8 ba 12 00 00       	call   80104d30 <memset>
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
80103a98:	e8 43 12 00 00       	call   80104ce0 <release>
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
80103abb:	e8 20 12 00 00       	call   80104ce0 <release>

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
80103b06:	68 f5 7f 10 80       	push   $0x80107ff5
80103b0b:	68 20 3d 11 80       	push   $0x80113d20
80103b10:	e8 bb 0f 00 00       	call   80104ad0 <initlock>
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
80103b7d:	68 fc 7f 10 80       	push   $0x80107ffc
80103b82:	e8 e9 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b87:	83 ec 0c             	sub    $0xc,%esp
80103b8a:	68 04 81 10 80       	push   $0x80108104
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
80103bc7:	e8 84 0f 00 00       	call   80104b50 <pushcli>
  c = mycpu();
80103bcc:	e8 4f ff ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103bd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd7:	e8 b4 0f 00 00       	call   80104b90 <popcli>
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
80103c03:	e8 e8 3b 00 00       	call   801077f0 <setupkvm>
80103c08:	85 c0                	test   %eax,%eax
80103c0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c0d:	0f 84 bd 00 00 00    	je     80103cd0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c13:	83 ec 04             	sub    $0x4,%esp
80103c16:	68 2c 00 00 00       	push   $0x2c
80103c1b:	68 60 b4 10 80       	push   $0x8010b460
80103c20:	50                   	push   %eax
80103c21:	e8 da 38 00 00       	call   80107500 <inituvm>
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
80103c36:	e8 f5 10 00 00       	call   80104d30 <memset>
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
80103c8f:	68 25 80 10 80       	push   $0x80108025
80103c94:	50                   	push   %eax
80103c95:	e8 96 12 00 00       	call   80104f30 <safestrcpy>
  p->cwd = namei("/");
80103c9a:	c7 04 24 2e 80 10 80 	movl   $0x8010802e,(%esp)
80103ca1:	e8 0a e6 ff ff       	call   801022b0 <namei>
80103ca6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ca9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cb0:	e8 7b 0f 00 00       	call   80104c30 <acquire>

  p->state = RUNNABLE;
80103cb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103cbc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cc3:	e8 18 10 00 00       	call   80104ce0 <release>
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
80103cd3:	68 0c 80 10 80       	push   $0x8010800c
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
80103ce8:	e8 63 0e 00 00       	call   80104b50 <pushcli>
  c = mycpu();
80103ced:	e8 2e fe ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103cf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf8:	e8 93 0e 00 00       	call   80104b90 <popcli>
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
80103d1f:	e8 1c 39 00 00       	call   80107640 <allocuvm>
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
80103d31:	e8 ba 36 00 00       	call   801073f0 <switchuvm>
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
80103d54:	e8 e7 39 00 00       	call   80107740 <deallocuvm>
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
80103d79:	e8 d2 0d 00 00       	call   80104b50 <pushcli>
  c = mycpu();
80103d7e:	e8 9d fd ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103d83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d89:	e8 02 0e 00 00       	call   80104b90 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103d8e:	e8 0d fc ff ff       	call   801039a0 <allocproc>
80103d93:	85 c0                	test   %eax,%eax
80103d95:	89 c7                	mov    %eax,%edi
80103d97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d9a:	0f 84 e5 00 00 00    	je     80103e85 <fork+0x115>
    return -1;
  }

  //새 페이지 할당 및  주소 저장
  np->shared_memory_address = kalloc();
80103da0:	e8 db ea ff ff       	call   80102880 <kalloc>


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103da5:	83 ec 08             	sub    $0x8,%esp
  if((np = allocproc()) == 0){
    return -1;
  }

  //새 페이지 할당 및  주소 저장
  np->shared_memory_address = kalloc();
80103da8:	89 87 98 00 00 00    	mov    %eax,0x98(%edi)


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dae:	ff 33                	pushl  (%ebx)
80103db0:	ff 73 04             	pushl  0x4(%ebx)
80103db3:	e8 08 3b 00 00       	call   801078c0 <copyuvm>
80103db8:	83 c4 10             	add    $0x10,%esp
80103dbb:	85 c0                	test   %eax,%eax
80103dbd:	89 47 04             	mov    %eax,0x4(%edi)
80103dc0:	0f 84 c6 00 00 00    	je     80103e8c <fork+0x11c>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103dc6:	8b 03                	mov    (%ebx),%eax
80103dc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103dcb:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103dd0:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103dd2:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103dd5:	8b 7a 18             	mov    0x18(%edx),%edi
80103dd8:	8b 73 18             	mov    0x18(%ebx),%esi
80103ddb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103ddd:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  //부모 프로세스와 같은 값으로 설정해준다.
  np->admin_mode = curproc->admin_mode;
80103ddf:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103de5:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  np->limit_sz = curproc->limit_sz;
80103deb:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80103df1:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
  np->custom_stack_size = curproc->custom_stack_size;
80103df7:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103dfd:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103e03:	8b 42 18             	mov    0x18(%edx),%eax
80103e06:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103e10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 13                	je     80103e2b <fork+0xbb>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	50                   	push   %eax
80103e1c:	e8 bf d3 ff ff       	call   801011e0 <filedup>
80103e21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e24:	83 c4 10             	add    $0x10,%esp
80103e27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  np->custom_stack_size = curproc->custom_stack_size;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103e2b:	83 c6 01             	add    $0x1,%esi
80103e2e:	83 fe 10             	cmp    $0x10,%esi
80103e31:	75 dd                	jne    80103e10 <fork+0xa0>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e39:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e3c:	e8 ef db ff ff       	call   80101a30 <idup>
80103e41:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e44:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e47:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e4d:	6a 10                	push   $0x10
80103e4f:	53                   	push   %ebx
80103e50:	50                   	push   %eax
80103e51:	e8 da 10 00 00       	call   80104f30 <safestrcpy>

  pid = np->pid;
80103e56:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103e59:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e60:	e8 cb 0d 00 00       	call   80104c30 <acquire>

  np->state = RUNNABLE;
80103e65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103e6c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e73:	e8 68 0e 00 00       	call   80104ce0 <release>

  return pid;
80103e78:	83 c4 10             	add    $0x10,%esp
80103e7b:	89 d8                	mov    %ebx,%eax
}
80103e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e80:	5b                   	pop    %ebx
80103e81:	5e                   	pop    %esi
80103e82:	5f                   	pop    %edi
80103e83:	5d                   	pop    %ebp
80103e84:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8a:	eb f1                	jmp    80103e7d <fork+0x10d>
  np->shared_memory_address = kalloc();


  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103e8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	ff 73 08             	pushl  0x8(%ebx)
80103e95:	e8 36 e8 ff ff       	call   801026d0 <kfree>
    np->kstack = 0;
80103e9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ea1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ea8:	83 c4 10             	add    $0x10,%esp
80103eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103eb0:	eb cb                	jmp    80103e7d <fork+0x10d>
80103eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <priority_boosting>:
//      via swtch back to the scheduler.


void 
priority_boosting(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	83 ec 14             	sub    $0x14,%esp
	struct proc *p;
	acquire(&ptable.lock);
80103ec6:	68 20 3d 11 80       	push   $0x80113d20
80103ecb:	e8 60 0d 00 00       	call   80104c30 <acquire>
80103ed0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed3:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ed8:	90                   	nop
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->queuelevel=0;
80103ee0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103ee7:	00 00 00 
        p->tickleft=4;
80103eea:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80103ef1:	00 00 00 
void 
priority_boosting(void)
{
	struct proc *p;
	acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef4:	05 9c 00 00 00       	add    $0x9c,%eax
80103ef9:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103efe:	75 e0                	jne    80103ee0 <priority_boosting+0x20>
        p->queuelevel=0;
        p->tickleft=4;
  }
	release(&ptable.lock);
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	68 20 3d 11 80       	push   $0x80113d20
80103f08:	e8 d3 0d 00 00       	call   80104ce0 <release>
}
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	c9                   	leave  
80103f11:	c3                   	ret    
80103f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <scheduler>:
*/


void
scheduler(void)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103f29:	e8 f2 fb ff ff       	call   80103b20 <mycpu>
80103f2e:	8d 78 04             	lea    0x4(%eax),%edi
80103f31:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f33:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f3a:	00 00 00 
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103f40:	fb                   	sti    

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f44:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx

  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103f49:	68 20 3d 11 80       	push   $0x80113d20
80103f4e:	e8 dd 0c 00 00       	call   80104c30 <acquire>
80103f53:	83 c4 10             	add    $0x10,%esp
80103f56:	eb 16                	jmp    80103f6e <scheduler+0x4e>
80103f58:	90                   	nop
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f60:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103f66:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80103f6c:	74 52                	je     80103fc0 <scheduler+0xa0>
      if(p->state != RUNNABLE) continue;
80103f6e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f72:	75 ec                	jne    80103f60 <scheduler+0x40>
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103f74:	83 ec 0c             	sub    $0xc,%esp
      if(p->state != RUNNABLE) continue;
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103f77:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f7d:	53                   	push   %ebx
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7e:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
	 // cprintf("i'm in normal\n");
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103f84:	e8 67 34 00 00       	call   801073f0 <switchuvm>
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
80103f89:	58                   	pop    %eax
80103f8a:	5a                   	pop    %edx
80103f8b:	ff 73 80             	pushl  -0x80(%ebx)
80103f8e:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103f8f:	c7 83 70 ff ff ff 04 	movl   $0x4,-0x90(%ebx)
80103f96:	00 00 00 
      swtch(&(c->scheduler), p->context);
80103f99:	e8 ed 0f 00 00       	call   80104f8b <swtch>
      switchkvm();
80103f9e:	e8 2d 34 00 00       	call   801073d0 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103fa3:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103fac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fb3:	00 00 00 
      release(&ptable.lock);
      priority_boosting();
    }

    #else
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb6:	75 b6                	jne    80103f6e <scheduler+0x4e>
80103fb8:	90                   	nop
80103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103fc0:	83 ec 0c             	sub    $0xc,%esp
80103fc3:	68 20 3d 11 80       	push   $0x80113d20
80103fc8:	e8 13 0d 00 00       	call   80104ce0 <release>
    #endif
  }
80103fcd:	83 c4 10             	add    $0x10,%esp
80103fd0:	e9 6b ff ff ff       	jmp    80103f40 <scheduler+0x20>
80103fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fe0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103fe5:	e8 66 0b 00 00       	call   80104b50 <pushcli>
  c = mycpu();
80103fea:	e8 31 fb ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103fef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff5:	e8 96 0b 00 00       	call   80104b90 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 20 3d 11 80       	push   $0x80113d20
80104002:	e8 f9 0b 00 00       	call   80104c00 <holding>
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	85 c0                	test   %eax,%eax
8010400c:	74 4f                	je     8010405d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
8010400e:	e8 0d fb ff ff       	call   80103b20 <mycpu>
80104013:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010401a:	75 68                	jne    80104084 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010401c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104020:	74 55                	je     80104077 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104022:	9c                   	pushf  
80104023:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80104024:	f6 c4 02             	test   $0x2,%ah
80104027:	75 41                	jne    8010406a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80104029:	e8 f2 fa ff ff       	call   80103b20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010402e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80104031:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104037:	e8 e4 fa ff ff       	call   80103b20 <mycpu>
8010403c:	83 ec 08             	sub    $0x8,%esp
8010403f:	ff 70 04             	pushl  0x4(%eax)
80104042:	53                   	push   %ebx
80104043:	e8 43 0f 00 00       	call   80104f8b <swtch>
  mycpu()->intena = intena;
80104048:	e8 d3 fa ff ff       	call   80103b20 <mycpu>
}
8010404d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104050:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104056:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104059:	5b                   	pop    %ebx
8010405a:	5e                   	pop    %esi
8010405b:	5d                   	pop    %ebp
8010405c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010405d:	83 ec 0c             	sub    $0xc,%esp
80104060:	68 30 80 10 80       	push   $0x80108030
80104065:	e8 06 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010406a:	83 ec 0c             	sub    $0xc,%esp
8010406d:	68 5c 80 10 80       	push   $0x8010805c
80104072:	e8 f9 c2 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80104077:	83 ec 0c             	sub    $0xc,%esp
8010407a:	68 4e 80 10 80       	push   $0x8010804e
8010407f:	e8 ec c2 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	68 42 80 10 80       	push   $0x80108042
8010408c:	e8 df c2 ff ff       	call   80100370 <panic>
80104091:	eb 0d                	jmp    801040a0 <exit>
80104093:	90                   	nop
80104094:	90                   	nop
80104095:	90                   	nop
80104096:	90                   	nop
80104097:	90                   	nop
80104098:	90                   	nop
80104099:	90                   	nop
8010409a:	90                   	nop
8010409b:	90                   	nop
8010409c:	90                   	nop
8010409d:	90                   	nop
8010409e:	90                   	nop
8010409f:	90                   	nop

801040a0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040a9:	e8 a2 0a 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801040ae:	e8 6d fa ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801040b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040b9:	e8 d2 0a 00 00       	call   80104b90 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
801040be:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801040c4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040c7:	8d 7e 68             	lea    0x68(%esi),%edi
801040ca:	0f 84 f1 00 00 00    	je     801041c1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
801040d0:	8b 03                	mov    (%ebx),%eax
801040d2:	85 c0                	test   %eax,%eax
801040d4:	74 12                	je     801040e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040d6:	83 ec 0c             	sub    $0xc,%esp
801040d9:	50                   	push   %eax
801040da:	e8 51 d1 ff ff       	call   80101230 <fileclose>
      curproc->ofile[fd] = 0;
801040df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040e5:	83 c4 10             	add    $0x10,%esp
801040e8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801040eb:	39 df                	cmp    %ebx,%edi
801040ed:	75 e1                	jne    801040d0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801040ef:	e8 4c ee ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	ff 76 68             	pushl  0x68(%esi)
801040fa:	e8 91 da ff ff       	call   80101b90 <iput>
  end_op();
801040ff:	e8 ac ee ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
80104104:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010410b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104112:	e8 19 0b 00 00       	call   80104c30 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104117:	8b 56 14             	mov    0x14(%esi),%edx
8010411a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104122:	eb 10                	jmp    80104134 <exit+0x94>
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104128:	05 9c 00 00 00       	add    $0x9c,%eax
8010412d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104132:	74 1e                	je     80104152 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104134:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104138:	75 ee                	jne    80104128 <exit+0x88>
8010413a:	3b 50 20             	cmp    0x20(%eax),%edx
8010413d:	75 e9                	jne    80104128 <exit+0x88>
      p->state = RUNNABLE;
8010413f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104146:	05 9c 00 00 00       	add    $0x9c,%eax
8010414b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104150:	75 e2                	jne    80104134 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104152:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104158:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010415d:	eb 0f                	jmp    8010416e <exit+0xce>
8010415f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104160:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80104166:	81 fa 54 64 11 80    	cmp    $0x80116454,%edx
8010416c:	74 3a                	je     801041a8 <exit+0x108>
    if(p->parent == curproc){
8010416e:	39 72 14             	cmp    %esi,0x14(%edx)
80104171:	75 ed                	jne    80104160 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104173:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104177:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010417a:	75 e4                	jne    80104160 <exit+0xc0>
8010417c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104181:	eb 11                	jmp    80104194 <exit+0xf4>
80104183:	90                   	nop
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104188:	05 9c 00 00 00       	add    $0x9c,%eax
8010418d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104192:	74 cc                	je     80104160 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104194:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104198:	75 ee                	jne    80104188 <exit+0xe8>
8010419a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010419d:	75 e9                	jne    80104188 <exit+0xe8>
      p->state = RUNNABLE;
8010419f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041a6:	eb e0                	jmp    80104188 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801041a8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801041af:	e8 2c fe ff ff       	call   80103fe0 <sched>
  panic("zombie exit");
801041b4:	83 ec 0c             	sub    $0xc,%esp
801041b7:	68 7d 80 10 80       	push   $0x8010807d
801041bc:	e8 af c1 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
801041c1:	83 ec 0c             	sub    $0xc,%esp
801041c4:	68 70 80 10 80       	push   $0x80108070
801041c9:	e8 a2 c1 ff ff       	call   80100370 <panic>
801041ce:	66 90                	xchg   %ax,%ax

801041d0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041d7:	68 20 3d 11 80       	push   $0x80113d20
801041dc:	e8 4f 0a 00 00       	call   80104c30 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041e1:	e8 6a 09 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801041e6:	e8 35 f9 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801041eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f1:	e8 9a 09 00 00       	call   80104b90 <popcli>
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  struct proc *now_p = myproc();
  now_p->state = RUNNABLE;
801041f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041fd:	e8 de fd ff ff       	call   80103fe0 <sched>
  release(&ptable.lock);
80104202:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104209:	e8 d2 0a 00 00       	call   80104ce0 <release>
}
8010420e:	83 c4 10             	add    $0x10,%esp
80104211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	8d 76 00             	lea    0x0(%esi),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <getlev>:

int             
getlev(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 04             	sub    $0x4,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104227:	e8 24 09 00 00       	call   80104b50 <pushcli>
  c = mycpu();
8010422c:	e8 ef f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104231:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104237:	e8 54 09 00 00       	call   80104b90 <popcli>
}

int             
getlev(void)
{
  return myproc()->queuelevel;
8010423c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104242:	83 c4 04             	add    $0x4,%esp
80104245:	5b                   	pop    %ebx
80104246:	5d                   	pop    %ebp
80104247:	c3                   	ret    
80104248:	90                   	nop
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <getadmin>:

int
getadmin(char *password)
{
80104250:	55                   	push   %ebp
  char my_number[10] = "2016025823";
80104251:	b8 32 33 00 00       	mov    $0x3332,%eax
  int flag = 0;
80104256:	31 d2                	xor    %edx,%edx
  return myproc()->queuelevel;
}

int
getadmin(char *password)
{
80104258:	89 e5                	mov    %esp,%ebp
8010425a:	53                   	push   %ebx
8010425b:	83 ec 14             	sub    $0x14,%esp
8010425e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char my_number[10] = "2016025823";
80104261:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80104265:	c7 45 ee 32 30 31 36 	movl   $0x36313032,-0x12(%ebp)
8010426c:	c7 45 f2 30 32 35 38 	movl   $0x38353230,-0xe(%ebp)
  int flag = 0;
  for(int i=0;i<10;i++){
80104273:	31 c0                	xor    %eax,%eax
80104275:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
80104278:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
8010427c:	38 4c 05 ee          	cmp    %cl,-0x12(%ebp,%eax,1)
80104280:	0f 94 c1             	sete   %cl
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
80104283:	83 c0 01             	add    $0x1,%eax
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
80104286:	0f b6 c9             	movzbl %cl,%ecx
80104289:	01 ca                	add    %ecx,%edx
int
getadmin(char *password)
{
  char my_number[10] = "2016025823";
  int flag = 0;
  for(int i=0;i<10;i++){
8010428b:	83 f8 0a             	cmp    $0xa,%eax
8010428e:	75 e8                	jne    80104278 <getadmin+0x28>
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
80104290:	83 fa 0a             	cmp    $0xa,%edx
80104293:	75 2b                	jne    801042c0 <getadmin+0x70>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104295:	e8 b6 08 00 00       	call   80104b50 <pushcli>
  c = mycpu();
8010429a:	e8 81 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010429f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a5:	e8 e6 08 00 00       	call   80104b90 <popcli>
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
801042aa:	31 c0                	xor    %eax,%eax
  for(int i=0;i<10;i++){
	  //cprintf("%c , %c \n",my_number[i],password[i]);
    if(my_number[i] == password[i]) flag++;
  }
  if(flag == 10){
    myproc()->admin_mode = 1;
801042ac:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
801042b3:	00 00 00 
    return 0;
  }
  else{
    return -1;
  }
}
801042b6:	83 c4 14             	add    $0x14,%esp
801042b9:	5b                   	pop    %ebx
801042ba:	5d                   	pop    %ebp
801042bb:	c3                   	ret    
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c0:	83 c4 14             	add    $0x14,%esp
  if(flag == 10){
    myproc()->admin_mode = 1;
    return 0;
  }
  else{
    return -1;
801042c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801042c8:	5b                   	pop    %ebx
801042c9:	5d                   	pop    %ebp
801042ca:	c3                   	ret    
801042cb:	90                   	nop
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042d0 <setmemorylimit>:

int 
setmemorylimit(int pid, int limit)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	57                   	push   %edi
801042d4:	56                   	push   %esi
801042d5:	53                   	push   %ebx
801042d6:	83 ec 0c             	sub    $0xc,%esp
801042d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042dc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801042df:	e8 6c 08 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801042e4:	e8 37 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801042e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042ef:	e8 9c 08 00 00       	call   80104b90 <popcli>

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
801042f4:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801042fa:	85 c0                	test   %eax,%eax
801042fc:	74 5c                	je     8010435a <setmemorylimit+0x8a>
801042fe:	89 f0                	mov    %esi,%eax
80104300:	c1 e8 1f             	shr    $0x1f,%eax
80104303:	84 c0                	test   %al,%al
80104305:	75 53                	jne    8010435a <setmemorylimit+0x8a>
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
80104307:	83 ec 0c             	sub    $0xc,%esp
int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
8010430a:	31 db                	xor    %ebx,%ebx
  struct proc *p;
  acquire(&ptable.lock);
8010430c:	68 20 3d 11 80       	push   $0x80113d20
80104311:	e8 1a 09 00 00       	call   80104c30 <acquire>
80104316:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104319:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010431e:	66 90                	xchg   %ax,%ax
    if(p->pid == pid) target = p;
80104320:	39 78 10             	cmp    %edi,0x10(%eax)
80104323:	0f 44 d8             	cmove  %eax,%ebx
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
  struct proc *target = 0;
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104326:	05 9c 00 00 00       	add    $0x9c,%eax
8010432b:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104330:	75 ee                	jne    80104320 <setmemorylimit+0x50>
    if(p->pid == pid) target = p;
  }
	release(&ptable.lock);
80104332:	83 ec 0c             	sub    $0xc,%esp
80104335:	68 20 3d 11 80       	push   $0x80113d20
8010433a:	e8 a1 09 00 00       	call   80104ce0 <release>
  //해당 pid가 없을 때
  if(target==0) return -1;
8010433f:	83 c4 10             	add    $0x10,%esp
80104342:	85 db                	test   %ebx,%ebx
80104344:	74 14                	je     8010435a <setmemorylimit+0x8a>

  //기존 사이즈보다 더 작은 Limit을 주려고 할때

  if(target->sz > limit) return -1;
80104346:	39 33                	cmp    %esi,(%ebx)
80104348:	77 10                	ja     8010435a <setmemorylimit+0x8a>
  target->limit_sz = limit;
8010434a:	89 b3 90 00 00 00    	mov    %esi,0x90(%ebx)
  return 0;
80104350:	31 c0                	xor    %eax,%eax
}
80104352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104355:	5b                   	pop    %ebx
80104356:	5e                   	pop    %esi
80104357:	5f                   	pop    %edi
80104358:	5d                   	pop    %ebp
80104359:	c3                   	ret    

int 
setmemorylimit(int pid, int limit)
{
  //admin mode가 아니거나, limit가 음수인 경우 
  if(myproc()->admin_mode == 0 || limit < 0) return -1;
8010435a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435f:	eb f1                	jmp    80104352 <setmemorylimit+0x82>
80104361:	eb 0d                	jmp    80104370 <getshmem>
80104363:	90                   	nop
80104364:	90                   	nop
80104365:	90                   	nop
80104366:	90                   	nop
80104367:	90                   	nop
80104368:	90                   	nop
80104369:	90                   	nop
8010436a:	90                   	nop
8010436b:	90                   	nop
8010436c:	90                   	nop
8010436d:	90                   	nop
8010436e:	90                   	nop
8010436f:	90                   	nop

80104370 <getshmem>:
  return 0;
}

char*
getshmem(int pid)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	56                   	push   %esi
80104375:	53                   	push   %ebx
  struct proc *p;
  char * return_address = 0;
80104376:	31 ff                	xor    %edi,%edi
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104378:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  return 0;
}

char*
getshmem(int pid)
{
8010437d:	83 ec 28             	sub    $0x28,%esp
80104380:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
80104383:	68 20 3d 11 80       	push   $0x80113d20
80104388:	e8 a3 08 00 00       	call   80104c30 <acquire>
8010438d:	83 c4 10             	add    $0x10,%esp
80104390:	eb 14                	jmp    801043a6 <getshmem+0x36>
80104392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104398:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010439e:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801043a4:	74 7b                	je     80104421 <getshmem+0xb1>
    if(p->pid == pid) {
801043a6:	39 73 10             	cmp    %esi,0x10(%ebx)
801043a9:	75 ed                	jne    80104398 <getshmem+0x28>
      return_address = p->shared_memory_address;
801043ab:	8b bb 98 00 00 00    	mov    0x98(%ebx),%edi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043b1:	e8 9a 07 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801043b6:	e8 65 f7 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801043bb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801043c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
801043c4:	e8 c7 07 00 00       	call   80104b90 <popcli>
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid) {
      return_address = p->shared_memory_address;
      //본인 프로세스의 접근할 때 - 읽기, 쓰기
      if(p->pid == myproc()->pid){
801043c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043cc:	3b 70 10             	cmp    0x10(%eax),%esi
801043cf:	74 6f                	je     80104440 <getshmem+0xd0>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043d1:	e8 7a 07 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801043d6:	e8 45 f7 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801043db:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e1:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
801043e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
801043ea:	e8 a1 07 00 00       	call   80104b90 <popcli>
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
      }
      //다른 프로세스에 접근 할 때 - 읽기
      else{
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
801043ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043f2:	89 fa                	mov    %edi,%edx
801043f4:	83 ec 04             	sub    $0x4,%esp
801043f7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801043fd:	6a 01                	push   $0x1
801043ff:	52                   	push   %edx
80104400:	ff 70 04             	pushl  0x4(%eax)
80104403:	e8 f8 2d 00 00       	call   80107200 <walkpgdir>
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
80104408:	8b 4b fc             	mov    -0x4(%ebx),%ecx
8010440b:	83 c4 10             	add    $0x10,%esp
8010440e:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80104414:	83 ca 05             	or     $0x5,%edx
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104417:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
      }
      //다른 프로세스에 접근 할 때 - 읽기
      else{
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
8010441d:	89 10                	mov    %edx,(%eax)
{
  struct proc *p;
  char * return_address = 0;
  uint * a;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010441f:	75 85                	jne    801043a6 <getshmem+0x36>
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U ;
      }
    }
  }
  release(&ptable.lock);
80104421:	83 ec 0c             	sub    $0xc,%esp
80104424:	68 20 3d 11 80       	push   $0x80113d20
80104429:	e8 b2 08 00 00       	call   80104ce0 <release>
  return return_address;
}
8010442e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104431:	89 f8                	mov    %edi,%eax
80104433:	5b                   	pop    %ebx
80104434:	5e                   	pop    %esi
80104435:	5f                   	pop    %edi
80104436:	5d                   	pop    %ebp
80104437:	c3                   	ret    
80104438:	90                   	nop
80104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104440:	e8 0b 07 00 00       	call   80104b50 <pushcli>
  c = mycpu();
80104445:	e8 d6 f6 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010444a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
80104453:	e8 38 07 00 00       	call   80104b90 <popcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid) {
      return_address = p->shared_memory_address;
      //본인 프로세스의 접근할 때 - 읽기, 쓰기
      if(p->pid == myproc()->pid){
        a = walkpgdir(myproc()->pgdir, (char*)PGROUNDDOWN((uint)return_address),1);
80104458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010445b:	89 fa                	mov    %edi,%edx
8010445d:	83 ec 04             	sub    $0x4,%esp
80104460:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80104466:	6a 01                	push   $0x1
80104468:	52                   	push   %edx
80104469:	ff 70 04             	pushl  0x4(%eax)
8010446c:	e8 8f 2d 00 00       	call   80107200 <walkpgdir>
        *a = V2P(p->shared_memory_address) | PTE_P | PTE_U | PTE_W ;
80104471:	8b 8b 98 00 00 00    	mov    0x98(%ebx),%ecx
80104477:	83 c4 10             	add    $0x10,%esp
8010447a:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80104480:	83 ca 07             	or     $0x7,%edx
80104483:	89 10                	mov    %edx,(%eax)
80104485:	e9 0e ff ff ff       	jmp    80104398 <getshmem+0x28>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <list>:
}


int
list()
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104499:	83 ec 10             	sub    $0x10,%esp
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
8010449c:	68 2c 81 10 80       	push   $0x8010812c
801044a1:	e8 ba c1 ff ff       	call   80100660 <cprintf>
  struct proc *p;
  acquire(&ptable.lock);
801044a6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801044ad:	e8 7e 07 00 00       	call   80104c30 <acquire>
801044b2:	83 c4 10             	add    $0x10,%esp
801044b5:	eb 3a                	jmp    801044f1 <list+0x61>
801044b7:	89 f6                	mov    %esi,%esi
801044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   if(p->pid != 0 || p->state !=UNUSED){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
801044c0:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
801044c5:	2b 43 28             	sub    0x28(%ebx),%eax
801044c8:	83 ec 08             	sub    $0x8,%esp
801044cb:	ff 73 24             	pushl  0x24(%ebx)
801044ce:	ff 73 94             	pushl  -0x6c(%ebx)
801044d1:	50                   	push   %eax
801044d2:	ff 73 a4             	pushl  -0x5c(%ebx)
801044d5:	53                   	push   %ebx
801044d6:	68 89 80 10 80       	push   $0x80108089
801044db:	e8 80 c1 ff ff       	call   80100660 <cprintf>
801044e0:	83 c4 20             	add    $0x20,%esp
801044e3:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044e9:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
801044ef:	74 50                	je     80104541 <list+0xb1>
   if(p->pid != 0 || p->state !=UNUSED){
801044f1:	8b 53 a4             	mov    -0x5c(%ebx),%edx
801044f4:	85 d2                	test   %edx,%edx
801044f6:	75 07                	jne    801044ff <list+0x6f>
801044f8:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044fb:	85 c0                	test   %eax,%eax
801044fd:	74 e4                	je     801044e3 <list+0x53>
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
801044ff:	83 ec 0c             	sub    $0xc,%esp
80104502:	53                   	push   %ebx
80104503:	e8 68 0a 00 00       	call   80104f70 <strlen>
80104508:	83 c4 10             	add    $0x10,%esp
8010450b:	83 f8 06             	cmp    $0x6,%eax
8010450e:	7f b0                	jg     801044c0 <list+0x30>
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
80104510:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80104515:	2b 43 28             	sub    0x28(%ebx),%eax
80104518:	83 ec 08             	sub    $0x8,%esp
8010451b:	ff 73 24             	pushl  0x24(%ebx)
8010451e:	ff 73 94             	pushl  -0x6c(%ebx)
80104521:	50                   	push   %eax
80104522:	ff 73 a4             	pushl  -0x5c(%ebx)
80104525:	53                   	push   %ebx
80104526:	68 9f 80 10 80       	push   $0x8010809f
8010452b:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104531:	e8 2a c1 ff ff       	call   80100660 <cprintf>
80104536:	83 c4 20             	add    $0x20,%esp
list()
{
  cprintf("NAME\t\t|PID\t|TIME(ms)\t|MEMORY(bytes)\t|MEMLIM(bytes)\n");
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104539:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
8010453f:	75 b0                	jne    801044f1 <list+0x61>
   if(p->pid != 0 || p->state !=UNUSED){
	   if(strlen(p->name)>6) cprintf("%s\t|%d\t|%d\t\t|%d\t\t|%d\n",p->name,p->pid,ticks-p->start_time_tick,p->sz,p->limit_sz);
	   else cprintf("%s\t\t|%d\t|%d\t\t|%d\t\t|%d\n", p->name,p->pid,ticks - p->start_time_tick,p->sz,p->limit_sz );
    }
  }
	release(&ptable.lock);
80104541:	83 ec 0c             	sub    $0xc,%esp
80104544:	68 20 3d 11 80       	push   $0x80113d20
80104549:	e8 92 07 00 00       	call   80104ce0 <release>
  return 0;
}
8010454e:	31 c0                	xor    %eax,%eax
80104550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104553:	c9                   	leave  
80104554:	c3                   	ret    
80104555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <setpriority>:


int             
setpriority(int pid, int priority)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	57                   	push   %edi
80104564:	56                   	push   %esi
80104565:	53                   	push   %ebx
80104566:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104569:	83 7d 0c 0a          	cmpl   $0xa,0xc(%ebp)
}


int             
setpriority(int pid, int priority)
{
8010456d:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *child;
  if(priority<0 || priority>10) return -2;
80104570:	0f 87 97 00 00 00    	ja     8010460d <setpriority+0xad>
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
80104576:	83 ec 0c             	sub    $0xc,%esp
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104579:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  struct proc *child;
  if(priority<0 || priority>10) return -2;
  //cli();
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
8010457e:	68 20 3d 11 80       	push   $0x80113d20
80104583:	e8 a8 06 00 00       	call   80104c30 <acquire>
80104588:	83 c4 10             	add    $0x10,%esp
8010458b:	eb 11                	jmp    8010459e <setpriority+0x3e>
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
80104590:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104596:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010459c:	74 52                	je     801045f0 <setpriority+0x90>
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
8010459e:	39 73 10             	cmp    %esi,0x10(%ebx)
801045a1:	75 ed                	jne    80104590 <setpriority+0x30>
801045a3:	8b 43 14             	mov    0x14(%ebx),%eax
801045a6:	8b 50 10             	mov    0x10(%eax),%edx
801045a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801045ac:	e8 9f 05 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801045b1:	e8 6a f5 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801045b6:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801045bc:	e8 cf 05 00 00       	call   80104b90 <popcli>
 //struct proc *parent = mycpu()->proc;
  //sti();
  acquire(&ptable.lock);
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
801045c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045c4:	3b 57 10             	cmp    0x10(%edi),%edx
801045c7:	75 c7                	jne    80104590 <setpriority+0x30>
			pid == myproc()->pid) )
    {
      child->priority=priority;
801045c9:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
801045cc:	83 ec 0c             	sub    $0xc,%esp
801045cf:	68 20 3d 11 80       	push   $0x80113d20
  for(child = ptable.proc; child < &ptable.proc[NPROC]; child++){
	  //cprintf("pid : %d ppid : %d 찾고있는 자식 pid : %d now pid : %d \n", child->pid, child->parent->pid, parent->pid ,pid);
    if((child->pid == pid) &&( child->parent->
			pid == myproc()->pid) )
    {
      child->priority=priority;
801045d4:	89 43 7c             	mov    %eax,0x7c(%ebx)
      release(&ptable.lock);
801045d7:	e8 04 07 00 00       	call   80104ce0 <release>

      return 0;
801045dc:	83 c4 10             	add    $0x10,%esp
    }
	}
  release(&ptable.lock);
  return -1;
}
801045df:	8d 65 f4             	lea    -0xc(%ebp),%esp
			pid == myproc()->pid) )
    {
      child->priority=priority;
      release(&ptable.lock);

      return 0;
801045e2:	31 c0                	xor    %eax,%eax
    }
	}
  release(&ptable.lock);
  return -1;
}
801045e4:	5b                   	pop    %ebx
801045e5:	5e                   	pop    %esi
801045e6:	5f                   	pop    %edi
801045e7:	5d                   	pop    %ebp
801045e8:	c3                   	ret    
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);

      return 0;
    }
	}
  release(&ptable.lock);
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	68 20 3d 11 80       	push   $0x80113d20
801045f8:	e8 e3 06 00 00       	call   80104ce0 <release>
  return -1;
801045fd:	83 c4 10             	add    $0x10,%esp
80104600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104605:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104608:	5b                   	pop    %ebx
80104609:	5e                   	pop    %esi
8010460a:	5f                   	pop    %edi
8010460b:	5d                   	pop    %ebp
8010460c:	c3                   	ret    

int             
setpriority(int pid, int priority)
{
  struct proc *child;
  if(priority<0 || priority>10) return -2;
8010460d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104612:	eb f1                	jmp    80104605 <setpriority+0xa5>
80104614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010461a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104620 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	8b 7d 08             	mov    0x8(%ebp),%edi
8010462c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010462f:	e8 1c 05 00 00       	call   80104b50 <pushcli>
  c = mycpu();
80104634:	e8 e7 f4 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104639:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010463f:	e8 4c 05 00 00       	call   80104b90 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104644:	85 db                	test   %ebx,%ebx
80104646:	0f 84 87 00 00 00    	je     801046d3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010464c:	85 f6                	test   %esi,%esi
8010464e:	74 76                	je     801046c6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104650:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104656:	74 50                	je     801046a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	68 20 3d 11 80       	push   $0x80113d20
80104660:	e8 cb 05 00 00       	call   80104c30 <acquire>
    release(lk);
80104665:	89 34 24             	mov    %esi,(%esp)
80104668:	e8 73 06 00 00       	call   80104ce0 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010466d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104670:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104677:	e8 64 f9 ff ff       	call   80103fe0 <sched>
  // Tidy up.
  p->chan = 0;
8010467c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104683:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010468a:	e8 51 06 00 00       	call   80104ce0 <release>
    acquire(lk);
8010468f:	89 75 08             	mov    %esi,0x8(%ebp)
80104692:	83 c4 10             	add    $0x10,%esp
  }
}
80104695:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104698:	5b                   	pop    %ebx
80104699:	5e                   	pop    %esi
8010469a:	5f                   	pop    %edi
8010469b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010469c:	e9 8f 05 00 00       	jmp    80104c30 <acquire>
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801046a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801046ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046b2:	e8 29 f9 ff ff       	call   80103fe0 <sched>
  // Tidy up.
  p->chan = 0;
801046b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801046be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046c1:	5b                   	pop    %ebx
801046c2:	5e                   	pop    %esi
801046c3:	5f                   	pop    %edi
801046c4:	5d                   	pop    %ebp
801046c5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
801046c6:	83 ec 0c             	sub    $0xc,%esp
801046c9:	68 bc 80 10 80       	push   $0x801080bc
801046ce:	e8 9d bc ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
801046d3:	83 ec 0c             	sub    $0xc,%esp
801046d6:	68 b6 80 10 80       	push   $0x801080b6
801046db:	e8 90 bc ff ff       	call   80100370 <panic>

801046e0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801046e5:	e8 66 04 00 00       	call   80104b50 <pushcli>
  c = mycpu();
801046ea:	e8 31 f4 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
801046ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046f5:	e8 96 04 00 00       	call   80104b90 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
801046fa:	83 ec 0c             	sub    $0xc,%esp
801046fd:	68 20 3d 11 80       	push   $0x80113d20
80104702:	e8 29 05 00 00       	call   80104c30 <acquire>
80104707:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010470a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010470c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104711:	eb 13                	jmp    80104726 <wait+0x46>
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104718:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010471e:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104724:	74 22                	je     80104748 <wait+0x68>
      if(p->parent != curproc)
80104726:	39 73 14             	cmp    %esi,0x14(%ebx)
80104729:	75 ed                	jne    80104718 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010472b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010472f:	74 35                	je     80104766 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104731:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104737:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010473c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104742:	75 e2                	jne    80104726 <wait+0x46>
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104748:	85 c0                	test   %eax,%eax
8010474a:	74 7c                	je     801047c8 <wait+0xe8>
8010474c:	8b 46 24             	mov    0x24(%esi),%eax
8010474f:	85 c0                	test   %eax,%eax
80104751:	75 75                	jne    801047c8 <wait+0xe8>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104753:	83 ec 08             	sub    $0x8,%esp
80104756:	68 20 3d 11 80       	push   $0x80113d20
8010475b:	56                   	push   %esi
8010475c:	e8 bf fe ff ff       	call   80104620 <sleep>
  }
80104761:	83 c4 10             	add    $0x10,%esp
80104764:	eb a4                	jmp    8010470a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80104766:	83 ec 0c             	sub    $0xc,%esp
80104769:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
8010476c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010476f:	e8 5c df ff ff       	call   801026d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104774:	5a                   	pop    %edx
80104775:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104778:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010477f:	e8 ec 2f 00 00       	call   80107770 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
		kfree(p->shared_memory_address);
80104784:	59                   	pop    %ecx
80104785:	ff b3 98 00 00 00    	pushl  0x98(%ebx)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
8010478b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104792:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104799:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010479d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047a4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		kfree(p->shared_memory_address);
801047ab:	e8 20 df ff ff       	call   801026d0 <kfree>
        release(&ptable.lock);
801047b0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801047b7:	e8 24 05 00 00       	call   80104ce0 <release>
        return pid;
801047bc:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
		kfree(p->shared_memory_address);
        release(&ptable.lock);
        return pid;
801047c2:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047c4:	5b                   	pop    %ebx
801047c5:	5e                   	pop    %esi
801047c6:	5d                   	pop    %ebp
801047c7:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
801047c8:	83 ec 0c             	sub    $0xc,%esp
801047cb:	68 20 3d 11 80       	push   $0x80113d20
801047d0:	e8 0b 05 00 00       	call   80104ce0 <release>
      return -1;
801047d5:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
801047db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
801047e0:	5b                   	pop    %ebx
801047e1:	5e                   	pop    %esi
801047e2:	5d                   	pop    %ebp
801047e3:	c3                   	ret    
801047e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 10             	sub    $0x10,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801047fa:	68 20 3d 11 80       	push   $0x80113d20
801047ff:	e8 2c 04 00 00       	call   80104c30 <acquire>
80104804:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104807:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010480c:	eb 0e                	jmp    8010481c <wakeup+0x2c>
8010480e:	66 90                	xchg   %ax,%ax
80104810:	05 9c 00 00 00       	add    $0x9c,%eax
80104815:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010481a:	74 1e                	je     8010483a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010481c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104820:	75 ee                	jne    80104810 <wakeup+0x20>
80104822:	3b 58 20             	cmp    0x20(%eax),%ebx
80104825:	75 e9                	jne    80104810 <wakeup+0x20>
      p->state = RUNNABLE;
80104827:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010482e:	05 9c 00 00 00       	add    $0x9c,%eax
80104833:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104838:	75 e2                	jne    8010481c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010483a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104841:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104844:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104845:	e9 96 04 00 00       	jmp    80104ce0 <release>
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 10             	sub    $0x10,%esp
80104857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010485a:	68 20 3d 11 80       	push   $0x80113d20
8010485f:	e8 cc 03 00 00       	call   80104c30 <acquire>
80104864:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104867:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010486c:	eb 0e                	jmp    8010487c <kill+0x2c>
8010486e:	66 90                	xchg   %ax,%ax
80104870:	05 9c 00 00 00       	add    $0x9c,%eax
80104875:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010487a:	74 3c                	je     801048b8 <kill+0x68>
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
8010487c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010487f:	75 ef                	jne    80104870 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104881:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
80104885:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010488c:	74 1a                	je     801048a8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	68 20 3d 11 80       	push   $0x80113d20
80104896:	e8 45 04 00 00       	call   80104ce0 <release>
      return 0;
8010489b:	83 c4 10             	add    $0x10,%esp
8010489e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801048a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048a3:	c9                   	leave  
801048a4:	c3                   	ret    
801048a5:	8d 76 00             	lea    0x0(%esi),%esi
	  //cprintf("%d %d\n",pid,p->pid);
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801048a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048af:	eb dd                	jmp    8010488e <kill+0x3e>
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	68 20 3d 11 80       	push   $0x80113d20
801048c0:	e8 1b 04 00 00       	call   80104ce0 <release>
  return -1;
801048c5:	83 c4 10             	add    $0x10,%esp
801048c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d0:	c9                   	leave  
801048d1:	c3                   	ret    
801048d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
801048e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801048e9:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801048ee:	83 ec 3c             	sub    $0x3c,%esp
801048f1:	eb 27                	jmp    8010491a <procdump+0x3a>
801048f3:	90                   	nop
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	68 97 84 10 80       	push   $0x80108497
80104900:	e8 5b bd ff ff       	call   80100660 <cprintf>
80104905:	83 c4 10             	add    $0x10,%esp
80104908:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010490e:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
80104914:	0f 84 7e 00 00 00    	je     80104998 <procdump+0xb8>
    if(p->state == UNUSED)
8010491a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010491d:	85 c0                	test   %eax,%eax
8010491f:	74 e7                	je     80104908 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104921:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104924:	ba cd 80 10 80       	mov    $0x801080cd,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104929:	77 11                	ja     8010493c <procdump+0x5c>
8010492b:	8b 14 85 60 81 10 80 	mov    -0x7fef7ea0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104932:	b8 cd 80 10 80       	mov    $0x801080cd,%eax
80104937:	85 d2                	test   %edx,%edx
80104939:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010493c:	53                   	push   %ebx
8010493d:	52                   	push   %edx
8010493e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104941:	68 d1 80 10 80       	push   $0x801080d1
80104946:	e8 15 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010494b:	83 c4 10             	add    $0x10,%esp
8010494e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104952:	75 a4                	jne    801048f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104954:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104957:	83 ec 08             	sub    $0x8,%esp
8010495a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010495d:	50                   	push   %eax
8010495e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104961:	8b 40 0c             	mov    0xc(%eax),%eax
80104964:	83 c0 08             	add    $0x8,%eax
80104967:	50                   	push   %eax
80104968:	e8 83 01 00 00       	call   80104af0 <getcallerpcs>
8010496d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104970:	8b 17                	mov    (%edi),%edx
80104972:	85 d2                	test   %edx,%edx
80104974:	74 82                	je     801048f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104976:	83 ec 08             	sub    $0x8,%esp
80104979:	83 c7 04             	add    $0x4,%edi
8010497c:	52                   	push   %edx
8010497d:	68 e1 7a 10 80       	push   $0x80107ae1
80104982:	e8 d9 bc ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104987:	83 c4 10             	add    $0x10,%esp
8010498a:	39 f7                	cmp    %esi,%edi
8010498c:	75 e2                	jne    80104970 <procdump+0x90>
8010498e:	e9 65 ff ff ff       	jmp    801048f8 <procdump+0x18>
80104993:	90                   	nop
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104998:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010499b:	5b                   	pop    %ebx
8010499c:	5e                   	pop    %esi
8010499d:	5f                   	pop    %edi
8010499e:	5d                   	pop    %ebp
8010499f:	c3                   	ret    

801049a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 0c             	sub    $0xc,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049aa:	68 78 81 10 80       	push   $0x80108178
801049af:	8d 43 04             	lea    0x4(%ebx),%eax
801049b2:	50                   	push   %eax
801049b3:	e8 18 01 00 00       	call   80104ad0 <initlock>
  lk->name = name;
801049b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049c1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801049c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801049cb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801049ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d1:	c9                   	leave  
801049d2:	c3                   	ret    
801049d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ee:	56                   	push   %esi
801049ef:	e8 3c 02 00 00       	call   80104c30 <acquire>
  while (lk->locked) {
801049f4:	8b 13                	mov    (%ebx),%edx
801049f6:	83 c4 10             	add    $0x10,%esp
801049f9:	85 d2                	test   %edx,%edx
801049fb:	74 16                	je     80104a13 <acquiresleep+0x33>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104a00:	83 ec 08             	sub    $0x8,%esp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
80104a05:	e8 16 fc ff ff       	call   80104620 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104a0a:	8b 03                	mov    (%ebx),%eax
80104a0c:	83 c4 10             	add    $0x10,%esp
80104a0f:	85 c0                	test   %eax,%eax
80104a11:	75 ed                	jne    80104a00 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104a13:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a19:	e8 a2 f1 ff ff       	call   80103bc0 <myproc>
80104a1e:	8b 40 10             	mov    0x10(%eax),%eax
80104a21:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a24:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a27:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a2a:	5b                   	pop    %ebx
80104a2b:	5e                   	pop    %esi
80104a2c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104a2d:	e9 ae 02 00 00       	jmp    80104ce0 <release>
80104a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a4e:	56                   	push   %esi
80104a4f:	e8 dc 01 00 00       	call   80104c30 <acquire>
  lk->locked = 0;
80104a54:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a5a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a61:	89 1c 24             	mov    %ebx,(%esp)
80104a64:	e8 87 fd ff ff       	call   801047f0 <wakeup>
  release(&lk->lk);
80104a69:	89 75 08             	mov    %esi,0x8(%ebp)
80104a6c:	83 c4 10             	add    $0x10,%esp
}
80104a6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a72:	5b                   	pop    %ebx
80104a73:	5e                   	pop    %esi
80104a74:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104a75:	e9 66 02 00 00       	jmp    80104ce0 <release>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a80 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	57                   	push   %edi
80104a84:	56                   	push   %esi
80104a85:	53                   	push   %ebx
80104a86:	31 ff                	xor    %edi,%edi
80104a88:	83 ec 18             	sub    $0x18,%esp
80104a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a8e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a91:	56                   	push   %esi
80104a92:	e8 99 01 00 00       	call   80104c30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a97:	8b 03                	mov    (%ebx),%eax
80104a99:	83 c4 10             	add    $0x10,%esp
80104a9c:	85 c0                	test   %eax,%eax
80104a9e:	74 13                	je     80104ab3 <holdingsleep+0x33>
80104aa0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104aa3:	e8 18 f1 ff ff       	call   80103bc0 <myproc>
80104aa8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aab:	0f 94 c0             	sete   %al
80104aae:	0f b6 c0             	movzbl %al,%eax
80104ab1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104ab3:	83 ec 0c             	sub    $0xc,%esp
80104ab6:	56                   	push   %esi
80104ab7:	e8 24 02 00 00       	call   80104ce0 <release>
  return r;
}
80104abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104abf:	89 f8                	mov    %edi,%eax
80104ac1:	5b                   	pop    %ebx
80104ac2:	5e                   	pop    %esi
80104ac3:	5f                   	pop    %edi
80104ac4:	5d                   	pop    %ebp
80104ac5:	c3                   	ret    
80104ac6:	66 90                	xchg   %ax,%ax
80104ac8:	66 90                	xchg   %ax,%ax
80104aca:	66 90                	xchg   %ax,%ax
80104acc:	66 90                	xchg   %ax,%ax
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104adf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104ae2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    
80104aeb:	90                   	nop
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104af4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104af7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104afa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104afd:	31 c0                	xor    %eax,%eax
80104aff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b00:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b06:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b0c:	77 1a                	ja     80104b28 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b0e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b11:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b14:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104b17:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b19:	83 f8 0a             	cmp    $0xa,%eax
80104b1c:	75 e2                	jne    80104b00 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b1e:	5b                   	pop    %ebx
80104b1f:	5d                   	pop    %ebp
80104b20:	c3                   	ret    
80104b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104b28:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b2f:	83 c0 01             	add    $0x1,%eax
80104b32:	83 f8 0a             	cmp    $0xa,%eax
80104b35:	74 e7                	je     80104b1e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104b37:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b3e:	83 c0 01             	add    $0x1,%eax
80104b41:	83 f8 0a             	cmp    $0xa,%eax
80104b44:	75 e2                	jne    80104b28 <getcallerpcs+0x38>
80104b46:	eb d6                	jmp    80104b1e <getcallerpcs+0x2e>
80104b48:	90                   	nop
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b50 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 04             	sub    $0x4,%esp
80104b57:	9c                   	pushf  
80104b58:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104b59:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b5a:	e8 c1 ef ff ff       	call   80103b20 <mycpu>
80104b5f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b65:	85 c0                	test   %eax,%eax
80104b67:	75 11                	jne    80104b7a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b69:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b6f:	e8 ac ef ff ff       	call   80103b20 <mycpu>
80104b74:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b7a:	e8 a1 ef ff ff       	call   80103b20 <mycpu>
80104b7f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b86:	83 c4 04             	add    $0x4,%esp
80104b89:	5b                   	pop    %ebx
80104b8a:	5d                   	pop    %ebp
80104b8b:	c3                   	ret    
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <popcli>:

void
popcli(void)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b96:	9c                   	pushf  
80104b97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b98:	f6 c4 02             	test   $0x2,%ah
80104b9b:	75 52                	jne    80104bef <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b9d:	e8 7e ef ff ff       	call   80103b20 <mycpu>
80104ba2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104ba8:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104bab:	85 d2                	test   %edx,%edx
80104bad:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104bb3:	78 2d                	js     80104be2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bb5:	e8 66 ef ff ff       	call   80103b20 <mycpu>
80104bba:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104bc0:	85 d2                	test   %edx,%edx
80104bc2:	74 0c                	je     80104bd0 <popcli+0x40>
    sti();
}
80104bc4:	c9                   	leave  
80104bc5:	c3                   	ret    
80104bc6:	8d 76 00             	lea    0x0(%esi),%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bd0:	e8 4b ef ff ff       	call   80103b20 <mycpu>
80104bd5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bdb:	85 c0                	test   %eax,%eax
80104bdd:	74 e5                	je     80104bc4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104bdf:	fb                   	sti    
    sti();
}
80104be0:	c9                   	leave  
80104be1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104be2:	83 ec 0c             	sub    $0xc,%esp
80104be5:	68 9a 81 10 80       	push   $0x8010819a
80104bea:	e8 81 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104bef:	83 ec 0c             	sub    $0xc,%esp
80104bf2:	68 83 81 10 80       	push   $0x80108183
80104bf7:	e8 74 b7 ff ff       	call   80100370 <panic>
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c00 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 75 08             	mov    0x8(%ebp),%esi
80104c08:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
80104c0a:	e8 41 ff ff ff       	call   80104b50 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c0f:	8b 06                	mov    (%esi),%eax
80104c11:	85 c0                	test   %eax,%eax
80104c13:	74 10                	je     80104c25 <holding+0x25>
80104c15:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c18:	e8 03 ef ff ff       	call   80103b20 <mycpu>
80104c1d:	39 c3                	cmp    %eax,%ebx
80104c1f:	0f 94 c3             	sete   %bl
80104c22:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104c25:	e8 66 ff ff ff       	call   80104b90 <popcli>
  return r;
}
80104c2a:	89 d8                	mov    %ebx,%eax
80104c2c:	5b                   	pop    %ebx
80104c2d:	5e                   	pop    %esi
80104c2e:	5d                   	pop    %ebp
80104c2f:	c3                   	ret    

80104c30 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104c37:	e8 14 ff ff ff       	call   80104b50 <pushcli>
  if(holding(lk))
80104c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	53                   	push   %ebx
80104c43:	e8 b8 ff ff ff       	call   80104c00 <holding>
80104c48:	83 c4 10             	add    $0x10,%esp
80104c4b:	85 c0                	test   %eax,%eax
80104c4d:	0f 85 7d 00 00 00    	jne    80104cd0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104c53:	ba 01 00 00 00       	mov    $0x1,%edx
80104c58:	eb 09                	jmp    80104c63 <acquire+0x33>
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c63:	89 d0                	mov    %edx,%eax
80104c65:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104c68:	85 c0                	test   %eax,%eax
80104c6a:	75 f4                	jne    80104c60 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104c6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104c71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c74:	e8 a7 ee ff ff       	call   80103b20 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104c79:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104c7b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104c7e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c81:	31 c0                	xor    %eax,%eax
80104c83:	90                   	nop
80104c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c88:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104c8e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c94:	77 1a                	ja     80104cb0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c96:	8b 5a 04             	mov    0x4(%edx),%ebx
80104c99:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c9c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104c9f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ca1:	83 f8 0a             	cmp    $0xa,%eax
80104ca4:	75 e2                	jne    80104c88 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104ca6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca9:	c9                   	leave  
80104caa:	c3                   	ret    
80104cab:	90                   	nop
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104cb0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104cb7:	83 c0 01             	add    $0x1,%eax
80104cba:	83 f8 0a             	cmp    $0xa,%eax
80104cbd:	74 e7                	je     80104ca6 <acquire+0x76>
    pcs[i] = 0;
80104cbf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104cc6:	83 c0 01             	add    $0x1,%eax
80104cc9:	83 f8 0a             	cmp    $0xa,%eax
80104ccc:	75 e2                	jne    80104cb0 <acquire+0x80>
80104cce:	eb d6                	jmp    80104ca6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104cd0:	83 ec 0c             	sub    $0xc,%esp
80104cd3:	68 a1 81 10 80       	push   $0x801081a1
80104cd8:	e8 93 b6 ff ff       	call   80100370 <panic>
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi

80104ce0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 10             	sub    $0x10,%esp
80104ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104cea:	53                   	push   %ebx
80104ceb:	e8 10 ff ff ff       	call   80104c00 <holding>
80104cf0:	83 c4 10             	add    $0x10,%esp
80104cf3:	85 c0                	test   %eax,%eax
80104cf5:	74 22                	je     80104d19 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104cf7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cfe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104d05:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d0a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d13:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104d14:	e9 77 fe ff ff       	jmp    80104b90 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104d19:	83 ec 0c             	sub    $0xc,%esp
80104d1c:	68 a9 81 10 80       	push   $0x801081a9
80104d21:	e8 4a b6 ff ff       	call   80100370 <panic>
80104d26:	66 90                	xchg   %ax,%ax
80104d28:	66 90                	xchg   %ax,%ax
80104d2a:	66 90                	xchg   %ax,%ax
80104d2c:	66 90                	xchg   %ax,%ax
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	53                   	push   %ebx
80104d35:	8b 55 08             	mov    0x8(%ebp),%edx
80104d38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d3b:	f6 c2 03             	test   $0x3,%dl
80104d3e:	75 05                	jne    80104d45 <memset+0x15>
80104d40:	f6 c1 03             	test   $0x3,%cl
80104d43:	74 13                	je     80104d58 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104d45:	89 d7                	mov    %edx,%edi
80104d47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d4a:	fc                   	cld    
80104d4b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d4d:	5b                   	pop    %ebx
80104d4e:	89 d0                	mov    %edx,%eax
80104d50:	5f                   	pop    %edi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	90                   	nop
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104d58:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104d5c:	c1 e9 02             	shr    $0x2,%ecx
80104d5f:	89 fb                	mov    %edi,%ebx
80104d61:	89 f8                	mov    %edi,%eax
80104d63:	c1 e3 18             	shl    $0x18,%ebx
80104d66:	c1 e0 10             	shl    $0x10,%eax
80104d69:	09 d8                	or     %ebx,%eax
80104d6b:	09 f8                	or     %edi,%eax
80104d6d:	c1 e7 08             	shl    $0x8,%edi
80104d70:	09 f8                	or     %edi,%eax
80104d72:	89 d7                	mov    %edx,%edi
80104d74:	fc                   	cld    
80104d75:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d77:	5b                   	pop    %ebx
80104d78:	89 d0                	mov    %edx,%eax
80104d7a:	5f                   	pop    %edi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret    
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi

80104d80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	8b 45 10             	mov    0x10(%ebp),%eax
80104d88:	53                   	push   %ebx
80104d89:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	74 29                	je     80104dbc <memcmp+0x3c>
    if(*s1 != *s2)
80104d93:	0f b6 13             	movzbl (%ebx),%edx
80104d96:	0f b6 0e             	movzbl (%esi),%ecx
80104d99:	38 d1                	cmp    %dl,%cl
80104d9b:	75 2b                	jne    80104dc8 <memcmp+0x48>
80104d9d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104da0:	31 c0                	xor    %eax,%eax
80104da2:	eb 14                	jmp    80104db8 <memcmp+0x38>
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104da8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104dad:	83 c0 01             	add    $0x1,%eax
80104db0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104db4:	38 ca                	cmp    %cl,%dl
80104db6:	75 10                	jne    80104dc8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104db8:	39 f8                	cmp    %edi,%eax
80104dba:	75 ec                	jne    80104da8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104dbc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104dbd:	31 c0                	xor    %eax,%eax
}
80104dbf:	5e                   	pop    %esi
80104dc0:	5f                   	pop    %edi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	90                   	nop
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104dc8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104dcb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104dcc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104dce:	5e                   	pop    %esi
80104dcf:	5f                   	pop    %edi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	8b 45 08             	mov    0x8(%ebp),%eax
80104de8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dee:	39 c6                	cmp    %eax,%esi
80104df0:	73 2e                	jae    80104e20 <memmove+0x40>
80104df2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104df5:	39 c8                	cmp    %ecx,%eax
80104df7:	73 27                	jae    80104e20 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104df9:	85 db                	test   %ebx,%ebx
80104dfb:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104dfe:	74 17                	je     80104e17 <memmove+0x37>
      *--d = *--s;
80104e00:	29 d9                	sub    %ebx,%ecx
80104e02:	89 cb                	mov    %ecx,%ebx
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e08:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104e0c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104e0f:	83 ea 01             	sub    $0x1,%edx
80104e12:	83 fa ff             	cmp    $0xffffffff,%edx
80104e15:	75 f1                	jne    80104e08 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e17:	5b                   	pop    %ebx
80104e18:	5e                   	pop    %esi
80104e19:	5d                   	pop    %ebp
80104e1a:	c3                   	ret    
80104e1b:	90                   	nop
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e20:	31 d2                	xor    %edx,%edx
80104e22:	85 db                	test   %ebx,%ebx
80104e24:	74 f1                	je     80104e17 <memmove+0x37>
80104e26:	8d 76 00             	lea    0x0(%esi),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104e30:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104e34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e37:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e3a:	39 d3                	cmp    %edx,%ebx
80104e3c:	75 f2                	jne    80104e30 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104e3e:	5b                   	pop    %ebx
80104e3f:	5e                   	pop    %esi
80104e40:	5d                   	pop    %ebp
80104e41:	c3                   	ret    
80104e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e53:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e54:	eb 8a                	jmp    80104de0 <memmove>
80104e56:	8d 76 00             	lea    0x0(%esi),%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
80104e65:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e68:	53                   	push   %ebx
80104e69:	8b 7d 08             	mov    0x8(%ebp),%edi
80104e6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e6f:	85 c9                	test   %ecx,%ecx
80104e71:	74 37                	je     80104eaa <strncmp+0x4a>
80104e73:	0f b6 17             	movzbl (%edi),%edx
80104e76:	0f b6 1e             	movzbl (%esi),%ebx
80104e79:	84 d2                	test   %dl,%dl
80104e7b:	74 3f                	je     80104ebc <strncmp+0x5c>
80104e7d:	38 d3                	cmp    %dl,%bl
80104e7f:	75 3b                	jne    80104ebc <strncmp+0x5c>
80104e81:	8d 47 01             	lea    0x1(%edi),%eax
80104e84:	01 cf                	add    %ecx,%edi
80104e86:	eb 1b                	jmp    80104ea3 <strncmp+0x43>
80104e88:	90                   	nop
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e90:	0f b6 10             	movzbl (%eax),%edx
80104e93:	84 d2                	test   %dl,%dl
80104e95:	74 21                	je     80104eb8 <strncmp+0x58>
80104e97:	0f b6 19             	movzbl (%ecx),%ebx
80104e9a:	83 c0 01             	add    $0x1,%eax
80104e9d:	89 ce                	mov    %ecx,%esi
80104e9f:	38 da                	cmp    %bl,%dl
80104ea1:	75 19                	jne    80104ebc <strncmp+0x5c>
80104ea3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104ea5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104ea8:	75 e6                	jne    80104e90 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104eaa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104eab:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104ead:	5e                   	pop    %esi
80104eae:	5f                   	pop    %edi
80104eaf:	5d                   	pop    %ebp
80104eb0:	c3                   	ret    
80104eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ebc:	0f b6 c2             	movzbl %dl,%eax
80104ebf:	29 d8                	sub    %ebx,%eax
}
80104ec1:	5b                   	pop    %ebx
80104ec2:	5e                   	pop    %esi
80104ec3:	5f                   	pop    %edi
80104ec4:	5d                   	pop    %ebp
80104ec5:	c3                   	ret    
80104ec6:	8d 76 00             	lea    0x0(%esi),%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
80104ed5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104edb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ede:	89 c2                	mov    %eax,%edx
80104ee0:	eb 19                	jmp    80104efb <strncpy+0x2b>
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee8:	83 c3 01             	add    $0x1,%ebx
80104eeb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104eef:	83 c2 01             	add    $0x1,%edx
80104ef2:	84 c9                	test   %cl,%cl
80104ef4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ef7:	74 09                	je     80104f02 <strncpy+0x32>
80104ef9:	89 f1                	mov    %esi,%ecx
80104efb:	85 c9                	test   %ecx,%ecx
80104efd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104f00:	7f e6                	jg     80104ee8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f02:	31 c9                	xor    %ecx,%ecx
80104f04:	85 f6                	test   %esi,%esi
80104f06:	7e 17                	jle    80104f1f <strncpy+0x4f>
80104f08:	90                   	nop
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f10:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104f14:	89 f3                	mov    %esi,%ebx
80104f16:	83 c1 01             	add    $0x1,%ecx
80104f19:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104f1b:	85 db                	test   %ebx,%ebx
80104f1d:	7f f1                	jg     80104f10 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104f1f:	5b                   	pop    %ebx
80104f20:	5e                   	pop    %esi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	56                   	push   %esi
80104f34:	53                   	push   %ebx
80104f35:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f38:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f3e:	85 c9                	test   %ecx,%ecx
80104f40:	7e 26                	jle    80104f68 <safestrcpy+0x38>
80104f42:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f46:	89 c1                	mov    %eax,%ecx
80104f48:	eb 17                	jmp    80104f61 <safestrcpy+0x31>
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f50:	83 c2 01             	add    $0x1,%edx
80104f53:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f57:	83 c1 01             	add    $0x1,%ecx
80104f5a:	84 db                	test   %bl,%bl
80104f5c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f5f:	74 04                	je     80104f65 <safestrcpy+0x35>
80104f61:	39 f2                	cmp    %esi,%edx
80104f63:	75 eb                	jne    80104f50 <safestrcpy+0x20>
    ;
  *s = 0;
80104f65:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f68:	5b                   	pop    %ebx
80104f69:	5e                   	pop    %esi
80104f6a:	5d                   	pop    %ebp
80104f6b:	c3                   	ret    
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f70 <strlen>:

int
strlen(const char *s)
{
80104f70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f71:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104f78:	80 3a 00             	cmpb   $0x0,(%edx)
80104f7b:	74 0c                	je     80104f89 <strlen+0x19>
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
80104f80:	83 c0 01             	add    $0x1,%eax
80104f83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f87:	75 f7                	jne    80104f80 <strlen+0x10>
    ;
  return n;
}
80104f89:	5d                   	pop    %ebp
80104f8a:	c3                   	ret    

80104f8b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f8f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f93:	55                   	push   %ebp
  pushl %ebx
80104f94:	53                   	push   %ebx
  pushl %esi
80104f95:	56                   	push   %esi
  pushl %edi
80104f96:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f97:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f99:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f9b:	5f                   	pop    %edi
  popl %esi
80104f9c:	5e                   	pop    %esi
  popl %ebx
80104f9d:	5b                   	pop    %ebx
  popl %ebp
80104f9e:	5d                   	pop    %ebp
  ret
80104f9f:	c3                   	ret    

80104fa0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	53                   	push   %ebx
80104fa4:	83 ec 04             	sub    $0x4,%esp
80104fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104faa:	e8 11 ec ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104faf:	8b 00                	mov    (%eax),%eax
80104fb1:	39 d8                	cmp    %ebx,%eax
80104fb3:	76 1b                	jbe    80104fd0 <fetchint+0x30>
80104fb5:	8d 53 04             	lea    0x4(%ebx),%edx
80104fb8:	39 d0                	cmp    %edx,%eax
80104fba:	72 14                	jb     80104fd0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fbf:	8b 13                	mov    (%ebx),%edx
80104fc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fc3:	31 c0                	xor    %eax,%eax
}
80104fc5:	83 c4 04             	add    $0x4,%esp
80104fc8:	5b                   	pop    %ebx
80104fc9:	5d                   	pop    %ebp
80104fca:	c3                   	ret    
80104fcb:	90                   	nop
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd5:	eb ee                	jmp    80104fc5 <fetchint+0x25>
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	53                   	push   %ebx
80104fe4:	83 ec 04             	sub    $0x4,%esp
80104fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104fea:	e8 d1 eb ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz)
80104fef:	39 18                	cmp    %ebx,(%eax)
80104ff1:	76 29                	jbe    8010501c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ff3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ff6:	89 da                	mov    %ebx,%edx
80104ff8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104ffa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104ffc:	39 c3                	cmp    %eax,%ebx
80104ffe:	73 1c                	jae    8010501c <fetchstr+0x3c>
    if(*s == 0)
80105000:	80 3b 00             	cmpb   $0x0,(%ebx)
80105003:	75 10                	jne    80105015 <fetchstr+0x35>
80105005:	eb 29                	jmp    80105030 <fetchstr+0x50>
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105010:	80 3a 00             	cmpb   $0x0,(%edx)
80105013:	74 1b                	je     80105030 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105015:	83 c2 01             	add    $0x1,%edx
80105018:	39 d0                	cmp    %edx,%eax
8010501a:	77 f4                	ja     80105010 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010501c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010501f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80105024:	5b                   	pop    %ebx
80105025:	5d                   	pop    %ebp
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105030:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80105033:	89 d0                	mov    %edx,%eax
80105035:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105037:	5b                   	pop    %ebx
80105038:	5d                   	pop    %ebp
80105039:	c3                   	ret    
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105040 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105045:	e8 76 eb ff ff       	call   80103bc0 <myproc>
8010504a:	8b 40 18             	mov    0x18(%eax),%eax
8010504d:	8b 55 08             	mov    0x8(%ebp),%edx
80105050:	8b 40 44             	mov    0x44(%eax),%eax
80105053:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80105056:	e8 65 eb ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010505b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010505d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105060:	39 c6                	cmp    %eax,%esi
80105062:	73 1c                	jae    80105080 <argint+0x40>
80105064:	8d 53 08             	lea    0x8(%ebx),%edx
80105067:	39 d0                	cmp    %edx,%eax
80105069:	72 15                	jb     80105080 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010506b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506e:	8b 53 04             	mov    0x4(%ebx),%edx
80105071:	89 10                	mov    %edx,(%eax)
  return 0;
80105073:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80105075:	5b                   	pop    %ebx
80105076:	5e                   	pop    %esi
80105077:	5d                   	pop    %ebp
80105078:	c3                   	ret    
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105085:	eb ee                	jmp    80105075 <argint+0x35>
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
80105095:	83 ec 10             	sub    $0x10,%esp
80105098:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010509b:	e8 20 eb ff ff       	call   80103bc0 <myproc>
801050a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801050a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050a5:	83 ec 08             	sub    $0x8,%esp
801050a8:	50                   	push   %eax
801050a9:	ff 75 08             	pushl  0x8(%ebp)
801050ac:	e8 8f ff ff ff       	call   80105040 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050b1:	c1 e8 1f             	shr    $0x1f,%eax
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	84 c0                	test   %al,%al
801050b9:	75 2d                	jne    801050e8 <argptr+0x58>
801050bb:	89 d8                	mov    %ebx,%eax
801050bd:	c1 e8 1f             	shr    $0x1f,%eax
801050c0:	84 c0                	test   %al,%al
801050c2:	75 24                	jne    801050e8 <argptr+0x58>
801050c4:	8b 16                	mov    (%esi),%edx
801050c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c9:	39 c2                	cmp    %eax,%edx
801050cb:	76 1b                	jbe    801050e8 <argptr+0x58>
801050cd:	01 c3                	add    %eax,%ebx
801050cf:	39 da                	cmp    %ebx,%edx
801050d1:	72 15                	jb     801050e8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
801050d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050d6:	89 02                	mov    %eax,(%edx)
  return 0;
801050d8:	31 c0                	xor    %eax,%eax
}
801050da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050dd:	5b                   	pop    %ebx
801050de:	5e                   	pop    %esi
801050df:	5d                   	pop    %ebp
801050e0:	c3                   	ret    
801050e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb eb                	jmp    801050da <argptr+0x4a>
801050ef:	90                   	nop

801050f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050f9:	50                   	push   %eax
801050fa:	ff 75 08             	pushl  0x8(%ebp)
801050fd:	e8 3e ff ff ff       	call   80105040 <argint>
80105102:	83 c4 10             	add    $0x10,%esp
80105105:	85 c0                	test   %eax,%eax
80105107:	78 17                	js     80105120 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105109:	83 ec 08             	sub    $0x8,%esp
8010510c:	ff 75 0c             	pushl  0xc(%ebp)
8010510f:	ff 75 f4             	pushl  -0xc(%ebp)
80105112:	e8 c9 fe ff ff       	call   80104fe0 <fetchstr>
80105117:	83 c4 10             	add    $0x10,%esp
}
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <syscall>:
[SYS_getshmem] sys_getshmem,
};

void
syscall(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105135:	e8 86 ea ff ff       	call   80103bc0 <myproc>

  num = curproc->tf->eax;
8010513a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010513d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010513f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105142:	8d 50 ff             	lea    -0x1(%eax),%edx
80105145:	83 fa 1c             	cmp    $0x1c,%edx
80105148:	77 1e                	ja     80105168 <syscall+0x38>
8010514a:	8b 14 85 e0 81 10 80 	mov    -0x7fef7e20(,%eax,4),%edx
80105151:	85 d2                	test   %edx,%edx
80105153:	74 13                	je     80105168 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105155:	ff d2                	call   *%edx
80105157:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010515a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010515d:	5b                   	pop    %ebx
8010515e:	5e                   	pop    %esi
8010515f:	5d                   	pop    %ebp
80105160:	c3                   	ret    
80105161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105168:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105169:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010516c:	50                   	push   %eax
8010516d:	ff 73 10             	pushl  0x10(%ebx)
80105170:	68 b1 81 10 80       	push   $0x801081b1
80105175:	e8 e6 b4 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010517a:	8b 43 18             	mov    0x18(%ebx),%eax
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105187:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010518a:	5b                   	pop    %ebx
8010518b:	5e                   	pop    %esi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax

80105190 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105196:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105199:	83 ec 34             	sub    $0x34,%esp
8010519c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010519f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051a2:	56                   	push   %esi
801051a3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051a7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051aa:	e8 21 d1 ff ff       	call   801022d0 <nameiparent>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	0f 84 f6 00 00 00    	je     801052b0 <create+0x120>
    return 0;
  ilock(dp);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	89 c7                	mov    %eax,%edi
801051bf:	50                   	push   %eax
801051c0:	e8 9b c8 ff ff       	call   80101a60 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801051c5:	83 c4 0c             	add    $0xc,%esp
801051c8:	6a 00                	push   $0x0
801051ca:	56                   	push   %esi
801051cb:	57                   	push   %edi
801051cc:	e8 bf cd ff ff       	call   80101f90 <dirlookup>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	85 c0                	test   %eax,%eax
801051d6:	89 c3                	mov    %eax,%ebx
801051d8:	74 56                	je     80105230 <create+0xa0>
    iunlockput(dp);
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	57                   	push   %edi
801051de:	e8 0d cb ff ff       	call   80101cf0 <iunlockput>
    ilock(ip);
801051e3:	89 1c 24             	mov    %ebx,(%esp)
801051e6:	e8 75 c8 ff ff       	call   80101a60 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051eb:	83 c4 10             	add    $0x10,%esp
801051ee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801051f3:	75 1b                	jne    80105210 <create+0x80>
801051f5:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801051fa:	89 d8                	mov    %ebx,%eax
801051fc:	75 12                	jne    80105210 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105201:	5b                   	pop    %ebx
80105202:	5e                   	pop    %esi
80105203:	5f                   	pop    %edi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    
80105206:	8d 76 00             	lea    0x0(%esi),%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	53                   	push   %ebx
80105214:	e8 d7 ca ff ff       	call   80101cf0 <iunlockput>
    return 0;
80105219:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010521c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010521f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105221:	5b                   	pop    %ebx
80105222:	5e                   	pop    %esi
80105223:	5f                   	pop    %edi
80105224:	5d                   	pop    %ebp
80105225:	c3                   	ret    
80105226:	8d 76 00             	lea    0x0(%esi),%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105230:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105234:	83 ec 08             	sub    $0x8,%esp
80105237:	50                   	push   %eax
80105238:	ff 37                	pushl  (%edi)
8010523a:	e8 b1 c6 ff ff       	call   801018f0 <ialloc>
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	85 c0                	test   %eax,%eax
80105244:	89 c3                	mov    %eax,%ebx
80105246:	0f 84 cc 00 00 00    	je     80105318 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010524c:	83 ec 0c             	sub    $0xc,%esp
8010524f:	50                   	push   %eax
80105250:	e8 0b c8 ff ff       	call   80101a60 <ilock>
  ip->major = major;
80105255:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105259:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010525d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105261:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105265:	b8 01 00 00 00       	mov    $0x1,%eax
8010526a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010526e:	89 1c 24             	mov    %ebx,(%esp)
80105271:	e8 3a c7 ff ff       	call   801019b0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010527e:	74 40                	je     801052c0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105280:	83 ec 04             	sub    $0x4,%esp
80105283:	ff 73 04             	pushl  0x4(%ebx)
80105286:	56                   	push   %esi
80105287:	57                   	push   %edi
80105288:	e8 63 cf ff ff       	call   801021f0 <dirlink>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	78 77                	js     8010530b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	57                   	push   %edi
80105298:	e8 53 ca ff ff       	call   80101cf0 <iunlockput>

  return ip;
8010529d:	83 c4 10             	add    $0x10,%esp
}
801052a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801052a3:	89 d8                	mov    %ebx,%eax
}
801052a5:	5b                   	pop    %ebx
801052a6:	5e                   	pop    %esi
801052a7:	5f                   	pop    %edi
801052a8:	5d                   	pop    %ebp
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801052b0:	31 c0                	xor    %eax,%eax
801052b2:	e9 47 ff ff ff       	jmp    801051fe <create+0x6e>
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801052c0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801052c5:	83 ec 0c             	sub    $0xc,%esp
801052c8:	57                   	push   %edi
801052c9:	e8 e2 c6 ff ff       	call   801019b0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052ce:	83 c4 0c             	add    $0xc,%esp
801052d1:	ff 73 04             	pushl  0x4(%ebx)
801052d4:	68 74 82 10 80       	push   $0x80108274
801052d9:	53                   	push   %ebx
801052da:	e8 11 cf ff ff       	call   801021f0 <dirlink>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	78 18                	js     801052fe <create+0x16e>
801052e6:	83 ec 04             	sub    $0x4,%esp
801052e9:	ff 77 04             	pushl  0x4(%edi)
801052ec:	68 73 82 10 80       	push   $0x80108273
801052f1:	53                   	push   %ebx
801052f2:	e8 f9 ce ff ff       	call   801021f0 <dirlink>
801052f7:	83 c4 10             	add    $0x10,%esp
801052fa:	85 c0                	test   %eax,%eax
801052fc:	79 82                	jns    80105280 <create+0xf0>
      panic("create dots");
801052fe:	83 ec 0c             	sub    $0xc,%esp
80105301:	68 67 82 10 80       	push   $0x80108267
80105306:	e8 65 b0 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010530b:	83 ec 0c             	sub    $0xc,%esp
8010530e:	68 76 82 10 80       	push   $0x80108276
80105313:	e8 58 b0 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	68 58 82 10 80       	push   $0x80108258
80105320:	e8 4b b0 ff ff       	call   80100370 <panic>
80105325:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
80105335:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010533a:	89 d3                	mov    %edx,%ebx
8010533c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010533f:	50                   	push   %eax
80105340:	6a 00                	push   $0x0
80105342:	e8 f9 fc ff ff       	call   80105040 <argint>
80105347:	83 c4 10             	add    $0x10,%esp
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 32                	js     80105380 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010534e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105352:	77 2c                	ja     80105380 <argfd.constprop.0+0x50>
80105354:	e8 67 e8 ff ff       	call   80103bc0 <myproc>
80105359:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010535c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105360:	85 c0                	test   %eax,%eax
80105362:	74 1c                	je     80105380 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105364:	85 f6                	test   %esi,%esi
80105366:	74 02                	je     8010536a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105368:	89 16                	mov    %edx,(%esi)
  if(pf)
8010536a:	85 db                	test   %ebx,%ebx
8010536c:	74 22                	je     80105390 <argfd.constprop.0+0x60>
    *pf = f;
8010536e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105370:	31 c0                	xor    %eax,%eax
}
80105372:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105375:	5b                   	pop    %ebx
80105376:	5e                   	pop    %esi
80105377:	5d                   	pop    %ebp
80105378:	c3                   	ret    
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105380:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105388:	5b                   	pop    %ebx
80105389:	5e                   	pop    %esi
8010538a:	5d                   	pop    %ebp
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105390:	31 c0                	xor    %eax,%eax
80105392:	eb de                	jmp    80105372 <argfd.constprop.0+0x42>
80105394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010539a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801053a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801053a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053a1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801053a3:	89 e5                	mov    %esp,%ebp
801053a5:	56                   	push   %esi
801053a6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801053aa:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053ad:	e8 7e ff ff ff       	call   80105330 <argfd.constprop.0>
801053b2:	85 c0                	test   %eax,%eax
801053b4:	78 1a                	js     801053d0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053b6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801053b8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801053bb:	e8 00 e8 ff ff       	call   80103bc0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801053c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053c4:	85 d2                	test   %edx,%edx
801053c6:	74 18                	je     801053e0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053c8:	83 c3 01             	add    $0x1,%ebx
801053cb:	83 fb 10             	cmp    $0x10,%ebx
801053ce:	75 f0                	jne    801053c0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801053d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801053d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801053d8:	5b                   	pop    %ebx
801053d9:	5e                   	pop    %esi
801053da:	5d                   	pop    %ebp
801053db:	c3                   	ret    
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801053e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	ff 75 f4             	pushl  -0xc(%ebp)
801053ea:	e8 f1 bd ff ff       	call   801011e0 <filedup>
  return fd;
801053ef:	83 c4 10             	add    $0x10,%esp
}
801053f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801053f5:	89 d8                	mov    %ebx,%eax
}
801053f7:	5b                   	pop    %ebx
801053f8:	5e                   	pop    %esi
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	90                   	nop
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_read>:

int
sys_read(void)
{
80105400:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105401:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105403:	89 e5                	mov    %esp,%ebp
80105405:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105408:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010540b:	e8 20 ff ff ff       	call   80105330 <argfd.constprop.0>
80105410:	85 c0                	test   %eax,%eax
80105412:	78 4c                	js     80105460 <sys_read+0x60>
80105414:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	50                   	push   %eax
8010541b:	6a 02                	push   $0x2
8010541d:	e8 1e fc ff ff       	call   80105040 <argint>
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	85 c0                	test   %eax,%eax
80105427:	78 37                	js     80105460 <sys_read+0x60>
80105429:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542c:	83 ec 04             	sub    $0x4,%esp
8010542f:	ff 75 f0             	pushl  -0x10(%ebp)
80105432:	50                   	push   %eax
80105433:	6a 01                	push   $0x1
80105435:	e8 56 fc ff ff       	call   80105090 <argptr>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	85 c0                	test   %eax,%eax
8010543f:	78 1f                	js     80105460 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105441:	83 ec 04             	sub    $0x4,%esp
80105444:	ff 75 f0             	pushl  -0x10(%ebp)
80105447:	ff 75 f4             	pushl  -0xc(%ebp)
8010544a:	ff 75 ec             	pushl  -0x14(%ebp)
8010544d:	e8 fe be ff ff       	call   80101350 <fileread>
80105452:	83 c4 10             	add    $0x10,%esp
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_write>:

int
sys_write(void)
{
80105470:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105471:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105473:	89 e5                	mov    %esp,%ebp
80105475:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105478:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010547b:	e8 b0 fe ff ff       	call   80105330 <argfd.constprop.0>
80105480:	85 c0                	test   %eax,%eax
80105482:	78 4c                	js     801054d0 <sys_write+0x60>
80105484:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105487:	83 ec 08             	sub    $0x8,%esp
8010548a:	50                   	push   %eax
8010548b:	6a 02                	push   $0x2
8010548d:	e8 ae fb ff ff       	call   80105040 <argint>
80105492:	83 c4 10             	add    $0x10,%esp
80105495:	85 c0                	test   %eax,%eax
80105497:	78 37                	js     801054d0 <sys_write+0x60>
80105499:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549c:	83 ec 04             	sub    $0x4,%esp
8010549f:	ff 75 f0             	pushl  -0x10(%ebp)
801054a2:	50                   	push   %eax
801054a3:	6a 01                	push   $0x1
801054a5:	e8 e6 fb ff ff       	call   80105090 <argptr>
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	85 c0                	test   %eax,%eax
801054af:	78 1f                	js     801054d0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801054b1:	83 ec 04             	sub    $0x4,%esp
801054b4:	ff 75 f0             	pushl  -0x10(%ebp)
801054b7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ba:	ff 75 ec             	pushl  -0x14(%ebp)
801054bd:	e8 1e bf ff ff       	call   801013e0 <filewrite>
801054c2:	83 c4 10             	add    $0x10,%esp
}
801054c5:	c9                   	leave  
801054c6:	c3                   	ret    
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_close>:

int
sys_close(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801054e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ec:	e8 3f fe ff ff       	call   80105330 <argfd.constprop.0>
801054f1:	85 c0                	test   %eax,%eax
801054f3:	78 2b                	js     80105520 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801054f5:	e8 c6 e6 ff ff       	call   80103bc0 <myproc>
801054fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054fd:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105500:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105507:	00 
  fileclose(f);
80105508:	ff 75 f4             	pushl  -0xc(%ebp)
8010550b:	e8 20 bd ff ff       	call   80101230 <fileclose>
  return 0;
80105510:	83 c4 10             	add    $0x10,%esp
80105513:	31 c0                	xor    %eax,%eax
}
80105515:	c9                   	leave  
80105516:	c3                   	ret    
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_fstat>:

int
sys_fstat(void)
{
80105530:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105531:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105533:	89 e5                	mov    %esp,%ebp
80105535:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105538:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010553b:	e8 f0 fd ff ff       	call   80105330 <argfd.constprop.0>
80105540:	85 c0                	test   %eax,%eax
80105542:	78 2c                	js     80105570 <sys_fstat+0x40>
80105544:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105547:	83 ec 04             	sub    $0x4,%esp
8010554a:	6a 14                	push   $0x14
8010554c:	50                   	push   %eax
8010554d:	6a 01                	push   $0x1
8010554f:	e8 3c fb ff ff       	call   80105090 <argptr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	78 15                	js     80105570 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010555b:	83 ec 08             	sub    $0x8,%esp
8010555e:	ff 75 f4             	pushl  -0xc(%ebp)
80105561:	ff 75 f0             	pushl  -0x10(%ebp)
80105564:	e8 97 bd ff ff       	call   80101300 <filestat>
80105569:	83 c4 10             	add    $0x10,%esp
}
8010556c:	c9                   	leave  
8010556d:	c3                   	ret    
8010556e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105575:	c9                   	leave  
80105576:	c3                   	ret    
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105586:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105589:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010558c:	50                   	push   %eax
8010558d:	6a 00                	push   $0x0
8010558f:	e8 5c fb ff ff       	call   801050f0 <argstr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	0f 88 fb 00 00 00    	js     8010569a <sys_link+0x11a>
8010559f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055a2:	83 ec 08             	sub    $0x8,%esp
801055a5:	50                   	push   %eax
801055a6:	6a 01                	push   $0x1
801055a8:	e8 43 fb ff ff       	call   801050f0 <argstr>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	0f 88 e2 00 00 00    	js     8010569a <sys_link+0x11a>
    return -1;

  begin_op();
801055b8:	e8 83 d9 ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
801055bd:	83 ec 0c             	sub    $0xc,%esp
801055c0:	ff 75 d4             	pushl  -0x2c(%ebp)
801055c3:	e8 e8 cc ff ff       	call   801022b0 <namei>
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	85 c0                	test   %eax,%eax
801055cd:	89 c3                	mov    %eax,%ebx
801055cf:	0f 84 f3 00 00 00    	je     801056c8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	50                   	push   %eax
801055d9:	e8 82 c4 ff ff       	call   80101a60 <ilock>
  if(ip->type == T_DIR){
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055e6:	0f 84 c4 00 00 00    	je     801056b0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801055ec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055f1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801055f4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801055f7:	53                   	push   %ebx
801055f8:	e8 b3 c3 ff ff       	call   801019b0 <iupdate>
  iunlock(ip);
801055fd:	89 1c 24             	mov    %ebx,(%esp)
80105600:	e8 3b c5 ff ff       	call   80101b40 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105605:	58                   	pop    %eax
80105606:	5a                   	pop    %edx
80105607:	57                   	push   %edi
80105608:	ff 75 d0             	pushl  -0x30(%ebp)
8010560b:	e8 c0 cc ff ff       	call   801022d0 <nameiparent>
80105610:	83 c4 10             	add    $0x10,%esp
80105613:	85 c0                	test   %eax,%eax
80105615:	89 c6                	mov    %eax,%esi
80105617:	74 5b                	je     80105674 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	50                   	push   %eax
8010561d:	e8 3e c4 ff ff       	call   80101a60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	8b 03                	mov    (%ebx),%eax
80105627:	39 06                	cmp    %eax,(%esi)
80105629:	75 3d                	jne    80105668 <sys_link+0xe8>
8010562b:	83 ec 04             	sub    $0x4,%esp
8010562e:	ff 73 04             	pushl  0x4(%ebx)
80105631:	57                   	push   %edi
80105632:	56                   	push   %esi
80105633:	e8 b8 cb ff ff       	call   801021f0 <dirlink>
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	85 c0                	test   %eax,%eax
8010563d:	78 29                	js     80105668 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010563f:	83 ec 0c             	sub    $0xc,%esp
80105642:	56                   	push   %esi
80105643:	e8 a8 c6 ff ff       	call   80101cf0 <iunlockput>
  iput(ip);
80105648:	89 1c 24             	mov    %ebx,(%esp)
8010564b:	e8 40 c5 ff ff       	call   80101b90 <iput>

  end_op();
80105650:	e8 5b d9 ff ff       	call   80102fb0 <end_op>

  return 0;
80105655:	83 c4 10             	add    $0x10,%esp
80105658:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010565a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010565d:	5b                   	pop    %ebx
8010565e:	5e                   	pop    %esi
8010565f:	5f                   	pop    %edi
80105660:	5d                   	pop    %ebp
80105661:	c3                   	ret    
80105662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	56                   	push   %esi
8010566c:	e8 7f c6 ff ff       	call   80101cf0 <iunlockput>
    goto bad;
80105671:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105674:	83 ec 0c             	sub    $0xc,%esp
80105677:	53                   	push   %ebx
80105678:	e8 e3 c3 ff ff       	call   80101a60 <ilock>
  ip->nlink--;
8010567d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105682:	89 1c 24             	mov    %ebx,(%esp)
80105685:	e8 26 c3 ff ff       	call   801019b0 <iupdate>
  iunlockput(ip);
8010568a:	89 1c 24             	mov    %ebx,(%esp)
8010568d:	e8 5e c6 ff ff       	call   80101cf0 <iunlockput>
  end_op();
80105692:	e8 19 d9 ff ff       	call   80102fb0 <end_op>
  return -1;
80105697:	83 c4 10             	add    $0x10,%esp
}
8010569a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010569d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056a2:	5b                   	pop    %ebx
801056a3:	5e                   	pop    %esi
801056a4:	5f                   	pop    %edi
801056a5:	5d                   	pop    %ebp
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	53                   	push   %ebx
801056b4:	e8 37 c6 ff ff       	call   80101cf0 <iunlockput>
    end_op();
801056b9:	e8 f2 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c6:	eb 92                	jmp    8010565a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801056c8:	e8 e3 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
801056cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d2:	eb 86                	jmp    8010565a <sys_link+0xda>
801056d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801056e0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056e6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801056e9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056ec:	50                   	push   %eax
801056ed:	6a 00                	push   $0x0
801056ef:	e8 fc f9 ff ff       	call   801050f0 <argstr>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	0f 88 82 01 00 00    	js     80105881 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801056ff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105702:	e8 39 d8 ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105707:	83 ec 08             	sub    $0x8,%esp
8010570a:	53                   	push   %ebx
8010570b:	ff 75 c0             	pushl  -0x40(%ebp)
8010570e:	e8 bd cb ff ff       	call   801022d0 <nameiparent>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010571b:	0f 84 6a 01 00 00    	je     8010588b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105721:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105724:	83 ec 0c             	sub    $0xc,%esp
80105727:	56                   	push   %esi
80105728:	e8 33 c3 ff ff       	call   80101a60 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010572d:	58                   	pop    %eax
8010572e:	5a                   	pop    %edx
8010572f:	68 74 82 10 80       	push   $0x80108274
80105734:	53                   	push   %ebx
80105735:	e8 36 c8 ff ff       	call   80101f70 <namecmp>
8010573a:	83 c4 10             	add    $0x10,%esp
8010573d:	85 c0                	test   %eax,%eax
8010573f:	0f 84 fc 00 00 00    	je     80105841 <sys_unlink+0x161>
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	68 73 82 10 80       	push   $0x80108273
8010574d:	53                   	push   %ebx
8010574e:	e8 1d c8 ff ff       	call   80101f70 <namecmp>
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	0f 84 e3 00 00 00    	je     80105841 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010575e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105761:	83 ec 04             	sub    $0x4,%esp
80105764:	50                   	push   %eax
80105765:	53                   	push   %ebx
80105766:	56                   	push   %esi
80105767:	e8 24 c8 ff ff       	call   80101f90 <dirlookup>
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	85 c0                	test   %eax,%eax
80105771:	89 c3                	mov    %eax,%ebx
80105773:	0f 84 c8 00 00 00    	je     80105841 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105779:	83 ec 0c             	sub    $0xc,%esp
8010577c:	50                   	push   %eax
8010577d:	e8 de c2 ff ff       	call   80101a60 <ilock>

  if(ip->nlink < 1)
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010578a:	0f 8e 24 01 00 00    	jle    801058b4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105790:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105795:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105798:	74 66                	je     80105800 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010579a:	83 ec 04             	sub    $0x4,%esp
8010579d:	6a 10                	push   $0x10
8010579f:	6a 00                	push   $0x0
801057a1:	56                   	push   %esi
801057a2:	e8 89 f5 ff ff       	call   80104d30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057a7:	6a 10                	push   $0x10
801057a9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057ac:	56                   	push   %esi
801057ad:	ff 75 b4             	pushl  -0x4c(%ebp)
801057b0:	e8 8b c6 ff ff       	call   80101e40 <writei>
801057b5:	83 c4 20             	add    $0x20,%esp
801057b8:	83 f8 10             	cmp    $0x10,%eax
801057bb:	0f 85 e6 00 00 00    	jne    801058a7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801057c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057c6:	0f 84 9c 00 00 00    	je     80105868 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	ff 75 b4             	pushl  -0x4c(%ebp)
801057d2:	e8 19 c5 ff ff       	call   80101cf0 <iunlockput>

  ip->nlink--;
801057d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057dc:	89 1c 24             	mov    %ebx,(%esp)
801057df:	e8 cc c1 ff ff       	call   801019b0 <iupdate>
  iunlockput(ip);
801057e4:	89 1c 24             	mov    %ebx,(%esp)
801057e7:	e8 04 c5 ff ff       	call   80101cf0 <iunlockput>

  end_op();
801057ec:	e8 bf d7 ff ff       	call   80102fb0 <end_op>

  return 0;
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801057f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f9:	5b                   	pop    %ebx
801057fa:	5e                   	pop    %esi
801057fb:	5f                   	pop    %edi
801057fc:	5d                   	pop    %ebp
801057fd:	c3                   	ret    
801057fe:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105800:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105804:	76 94                	jbe    8010579a <sys_unlink+0xba>
80105806:	bf 20 00 00 00       	mov    $0x20,%edi
8010580b:	eb 0f                	jmp    8010581c <sys_unlink+0x13c>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
80105810:	83 c7 10             	add    $0x10,%edi
80105813:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105816:	0f 83 7e ff ff ff    	jae    8010579a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010581c:	6a 10                	push   $0x10
8010581e:	57                   	push   %edi
8010581f:	56                   	push   %esi
80105820:	53                   	push   %ebx
80105821:	e8 1a c5 ff ff       	call   80101d40 <readi>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	83 f8 10             	cmp    $0x10,%eax
8010582c:	75 6c                	jne    8010589a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010582e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105833:	74 db                	je     80105810 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105835:	83 ec 0c             	sub    $0xc,%esp
80105838:	53                   	push   %ebx
80105839:	e8 b2 c4 ff ff       	call   80101cf0 <iunlockput>
    goto bad;
8010583e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	ff 75 b4             	pushl  -0x4c(%ebp)
80105847:	e8 a4 c4 ff ff       	call   80101cf0 <iunlockput>
  end_op();
8010584c:	e8 5f d7 ff ff       	call   80102fb0 <end_op>
  return -1;
80105851:	83 c4 10             	add    $0x10,%esp
}
80105854:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010585c:	5b                   	pop    %ebx
8010585d:	5e                   	pop    %esi
8010585e:	5f                   	pop    %edi
8010585f:	5d                   	pop    %ebp
80105860:	c3                   	ret    
80105861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105868:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010586b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010586e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105873:	50                   	push   %eax
80105874:	e8 37 c1 ff ff       	call   801019b0 <iupdate>
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	e9 4b ff ff ff       	jmp    801057cc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105886:	e9 6b ff ff ff       	jmp    801057f6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010588b:	e8 20 d7 ff ff       	call   80102fb0 <end_op>
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	e9 5c ff ff ff       	jmp    801057f6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010589a:	83 ec 0c             	sub    $0xc,%esp
8010589d:	68 98 82 10 80       	push   $0x80108298
801058a2:	e8 c9 aa ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	68 aa 82 10 80       	push   $0x801082aa
801058af:	e8 bc aa ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801058b4:	83 ec 0c             	sub    $0xc,%esp
801058b7:	68 86 82 10 80       	push   $0x80108286
801058bc:	e8 af aa ff ff       	call   80100370 <panic>
801058c1:	eb 0d                	jmp    801058d0 <sys_open>
801058c3:	90                   	nop
801058c4:	90                   	nop
801058c5:	90                   	nop
801058c6:	90                   	nop
801058c7:	90                   	nop
801058c8:	90                   	nop
801058c9:	90                   	nop
801058ca:	90                   	nop
801058cb:	90                   	nop
801058cc:	90                   	nop
801058cd:	90                   	nop
801058ce:	90                   	nop
801058cf:	90                   	nop

801058d0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801058d9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058dc:	50                   	push   %eax
801058dd:	6a 00                	push   $0x0
801058df:	e8 0c f8 ff ff       	call   801050f0 <argstr>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	85 c0                	test   %eax,%eax
801058e9:	0f 88 9e 00 00 00    	js     8010598d <sys_open+0xbd>
801058ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058f2:	83 ec 08             	sub    $0x8,%esp
801058f5:	50                   	push   %eax
801058f6:	6a 01                	push   $0x1
801058f8:	e8 43 f7 ff ff       	call   80105040 <argint>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	0f 88 85 00 00 00    	js     8010598d <sys_open+0xbd>
    return -1;

  begin_op();
80105908:	e8 33 d6 ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
8010590d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105911:	0f 85 89 00 00 00    	jne    801059a0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105917:	83 ec 0c             	sub    $0xc,%esp
8010591a:	ff 75 e0             	pushl  -0x20(%ebp)
8010591d:	e8 8e c9 ff ff       	call   801022b0 <namei>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	89 c6                	mov    %eax,%esi
80105929:	0f 84 8e 00 00 00    	je     801059bd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010592f:	83 ec 0c             	sub    $0xc,%esp
80105932:	50                   	push   %eax
80105933:	e8 28 c1 ff ff       	call   80101a60 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105938:	83 c4 10             	add    $0x10,%esp
8010593b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105940:	0f 84 d2 00 00 00    	je     80105a18 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105946:	e8 25 b8 ff ff       	call   80101170 <filealloc>
8010594b:	85 c0                	test   %eax,%eax
8010594d:	89 c7                	mov    %eax,%edi
8010594f:	74 2b                	je     8010597c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105951:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105953:	e8 68 e2 ff ff       	call   80103bc0 <myproc>
80105958:	90                   	nop
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105960:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105964:	85 d2                	test   %edx,%edx
80105966:	74 68                	je     801059d0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105968:	83 c3 01             	add    $0x1,%ebx
8010596b:	83 fb 10             	cmp    $0x10,%ebx
8010596e:	75 f0                	jne    80105960 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	57                   	push   %edi
80105974:	e8 b7 b8 ff ff       	call   80101230 <fileclose>
80105979:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010597c:	83 ec 0c             	sub    $0xc,%esp
8010597f:	56                   	push   %esi
80105980:	e8 6b c3 ff ff       	call   80101cf0 <iunlockput>
    end_op();
80105985:	e8 26 d6 ff ff       	call   80102fb0 <end_op>
    return -1;
8010598a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010598d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105995:	5b                   	pop    %ebx
80105996:	5e                   	pop    %esi
80105997:	5f                   	pop    %edi
80105998:	5d                   	pop    %ebp
80105999:	c3                   	ret    
8010599a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059a6:	31 c9                	xor    %ecx,%ecx
801059a8:	6a 00                	push   $0x0
801059aa:	ba 02 00 00 00       	mov    $0x2,%edx
801059af:	e8 dc f7 ff ff       	call   80105190 <create>
    if(ip == 0){
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801059b9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059bb:	75 89                	jne    80105946 <sys_open+0x76>
      end_op();
801059bd:	e8 ee d5 ff ff       	call   80102fb0 <end_op>
      return -1;
801059c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c7:	eb 43                	jmp    80105a0c <sys_open+0x13c>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059d0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801059d3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059d7:	56                   	push   %esi
801059d8:	e8 63 c1 ff ff       	call   80101b40 <iunlock>
  end_op();
801059dd:	e8 ce d5 ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
801059e2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059eb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801059ee:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801059f1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059f8:	89 d0                	mov    %edx,%eax
801059fa:	83 e0 01             	and    $0x1,%eax
801059fd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a00:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a03:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a06:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105a0a:	89 d8                	mov    %ebx,%eax
}
80105a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a0f:	5b                   	pop    %ebx
80105a10:	5e                   	pop    %esi
80105a11:	5f                   	pop    %edi
80105a12:	5d                   	pop    %ebp
80105a13:	c3                   	ret    
80105a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a1b:	85 c9                	test   %ecx,%ecx
80105a1d:	0f 84 23 ff ff ff    	je     80105946 <sys_open+0x76>
80105a23:	e9 54 ff ff ff       	jmp    8010597c <sys_open+0xac>
80105a28:	90                   	nop
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a36:	e8 05 d5 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a3e:	83 ec 08             	sub    $0x8,%esp
80105a41:	50                   	push   %eax
80105a42:	6a 00                	push   $0x0
80105a44:	e8 a7 f6 ff ff       	call   801050f0 <argstr>
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	85 c0                	test   %eax,%eax
80105a4e:	78 30                	js     80105a80 <sys_mkdir+0x50>
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a56:	31 c9                	xor    %ecx,%ecx
80105a58:	6a 00                	push   $0x0
80105a5a:	ba 01 00 00 00       	mov    $0x1,%edx
80105a5f:	e8 2c f7 ff ff       	call   80105190 <create>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	74 15                	je     80105a80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a6b:	83 ec 0c             	sub    $0xc,%esp
80105a6e:	50                   	push   %eax
80105a6f:	e8 7c c2 ff ff       	call   80101cf0 <iunlockput>
  end_op();
80105a74:	e8 37 d5 ff ff       	call   80102fb0 <end_op>
  return 0;
80105a79:	83 c4 10             	add    $0x10,%esp
80105a7c:	31 c0                	xor    %eax,%eax
}
80105a7e:	c9                   	leave  
80105a7f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105a80:	e8 2b d5 ff ff       	call   80102fb0 <end_op>
    return -1;
80105a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105a8a:	c9                   	leave  
80105a8b:	c3                   	ret    
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_mknod>:

int
sys_mknod(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a96:	e8 a5 d4 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a9e:	83 ec 08             	sub    $0x8,%esp
80105aa1:	50                   	push   %eax
80105aa2:	6a 00                	push   $0x0
80105aa4:	e8 47 f6 ff ff       	call   801050f0 <argstr>
80105aa9:	83 c4 10             	add    $0x10,%esp
80105aac:	85 c0                	test   %eax,%eax
80105aae:	78 60                	js     80105b10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ab0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ab3:	83 ec 08             	sub    $0x8,%esp
80105ab6:	50                   	push   %eax
80105ab7:	6a 01                	push   $0x1
80105ab9:	e8 82 f5 ff ff       	call   80105040 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105abe:	83 c4 10             	add    $0x10,%esp
80105ac1:	85 c0                	test   %eax,%eax
80105ac3:	78 4b                	js     80105b10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105ac5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac8:	83 ec 08             	sub    $0x8,%esp
80105acb:	50                   	push   %eax
80105acc:	6a 02                	push   $0x2
80105ace:	e8 6d f5 ff ff       	call   80105040 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105ad3:	83 c4 10             	add    $0x10,%esp
80105ad6:	85 c0                	test   %eax,%eax
80105ad8:	78 36                	js     80105b10 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105ada:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105ade:	83 ec 0c             	sub    $0xc,%esp
80105ae1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ae5:	ba 03 00 00 00       	mov    $0x3,%edx
80105aea:	50                   	push   %eax
80105aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105aee:	e8 9d f6 ff ff       	call   80105190 <create>
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	74 16                	je     80105b10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105afa:	83 ec 0c             	sub    $0xc,%esp
80105afd:	50                   	push   %eax
80105afe:	e8 ed c1 ff ff       	call   80101cf0 <iunlockput>
  end_op();
80105b03:	e8 a8 d4 ff ff       	call   80102fb0 <end_op>
  return 0;
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	31 c0                	xor    %eax,%eax
}
80105b0d:	c9                   	leave  
80105b0e:	c3                   	ret    
80105b0f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105b10:	e8 9b d4 ff ff       	call   80102fb0 <end_op>
    return -1;
80105b15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105b1a:	c9                   	leave  
80105b1b:	c3                   	ret    
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_chdir>:

int
sys_chdir(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	56                   	push   %esi
80105b24:	53                   	push   %ebx
80105b25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b28:	e8 93 e0 ff ff       	call   80103bc0 <myproc>
80105b2d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b2f:	e8 0c d4 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b37:	83 ec 08             	sub    $0x8,%esp
80105b3a:	50                   	push   %eax
80105b3b:	6a 00                	push   $0x0
80105b3d:	e8 ae f5 ff ff       	call   801050f0 <argstr>
80105b42:	83 c4 10             	add    $0x10,%esp
80105b45:	85 c0                	test   %eax,%eax
80105b47:	78 77                	js     80105bc0 <sys_chdir+0xa0>
80105b49:	83 ec 0c             	sub    $0xc,%esp
80105b4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b4f:	e8 5c c7 ff ff       	call   801022b0 <namei>
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	85 c0                	test   %eax,%eax
80105b59:	89 c3                	mov    %eax,%ebx
80105b5b:	74 63                	je     80105bc0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	50                   	push   %eax
80105b61:	e8 fa be ff ff       	call   80101a60 <ilock>
  if(ip->type != T_DIR){
80105b66:	83 c4 10             	add    $0x10,%esp
80105b69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b6e:	75 30                	jne    80105ba0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	53                   	push   %ebx
80105b74:	e8 c7 bf ff ff       	call   80101b40 <iunlock>
  iput(curproc->cwd);
80105b79:	58                   	pop    %eax
80105b7a:	ff 76 68             	pushl  0x68(%esi)
80105b7d:	e8 0e c0 ff ff       	call   80101b90 <iput>
  end_op();
80105b82:	e8 29 d4 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105b87:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	31 c0                	xor    %eax,%eax
}
80105b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b92:	5b                   	pop    %ebx
80105b93:	5e                   	pop    %esi
80105b94:	5d                   	pop    %ebp
80105b95:	c3                   	ret    
80105b96:	8d 76 00             	lea    0x0(%esi),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	53                   	push   %ebx
80105ba4:	e8 47 c1 ff ff       	call   80101cf0 <iunlockput>
    end_op();
80105ba9:	e8 02 d4 ff ff       	call   80102fb0 <end_op>
    return -1;
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb6:	eb d7                	jmp    80105b8f <sys_chdir+0x6f>
80105bb8:	90                   	nop
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105bc0:	e8 eb d3 ff ff       	call   80102fb0 <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bca:	eb c3                	jmp    80105b8f <sys_chdir+0x6f>
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bd6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105bdc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105be2:	50                   	push   %eax
80105be3:	6a 00                	push   $0x0
80105be5:	e8 06 f5 ff ff       	call   801050f0 <argstr>
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	85 c0                	test   %eax,%eax
80105bef:	78 7f                	js     80105c70 <sys_exec+0xa0>
80105bf1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bf7:	83 ec 08             	sub    $0x8,%esp
80105bfa:	50                   	push   %eax
80105bfb:	6a 01                	push   $0x1
80105bfd:	e8 3e f4 ff ff       	call   80105040 <argint>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	78 67                	js     80105c70 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c09:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c0f:	83 ec 04             	sub    $0x4,%esp
80105c12:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105c18:	68 80 00 00 00       	push   $0x80
80105c1d:	6a 00                	push   $0x0
80105c1f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c25:	50                   	push   %eax
80105c26:	31 db                	xor    %ebx,%ebx
80105c28:	e8 03 f1 ff ff       	call   80104d30 <memset>
80105c2d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c30:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c36:	83 ec 08             	sub    $0x8,%esp
80105c39:	57                   	push   %edi
80105c3a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105c3d:	50                   	push   %eax
80105c3e:	e8 5d f3 ff ff       	call   80104fa0 <fetchint>
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	85 c0                	test   %eax,%eax
80105c48:	78 26                	js     80105c70 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105c4a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c50:	85 c0                	test   %eax,%eax
80105c52:	74 2c                	je     80105c80 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c54:	83 ec 08             	sub    $0x8,%esp
80105c57:	56                   	push   %esi
80105c58:	50                   	push   %eax
80105c59:	e8 82 f3 ff ff       	call   80104fe0 <fetchstr>
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	85 c0                	test   %eax,%eax
80105c63:	78 0b                	js     80105c70 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105c65:	83 c3 01             	add    $0x1,%ebx
80105c68:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105c6b:	83 fb 20             	cmp    $0x20,%ebx
80105c6e:	75 c0                	jne    80105c30 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105c73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105c78:	5b                   	pop    %ebx
80105c79:	5e                   	pop    %esi
80105c7a:	5f                   	pop    %edi
80105c7b:	5d                   	pop    %ebp
80105c7c:	c3                   	ret    
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c80:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c86:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105c89:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c90:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105c94:	50                   	push   %eax
80105c95:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c9b:	e8 50 ad ff ff       	call   801009f0 <exec>
80105ca0:	83 c4 10             	add    $0x10,%esp
}
80105ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca6:	5b                   	pop    %ebx
80105ca7:	5e                   	pop    %esi
80105ca8:	5f                   	pop    %edi
80105ca9:	5d                   	pop    %ebp
80105caa:	c3                   	ret    
80105cab:	90                   	nop
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_exec2>:


int
sys_exec2(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	57                   	push   %edi
80105cb4:	56                   	push   %esi
80105cb5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cb6:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
}


int
sys_exec2(void)
{
80105cbc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cc2:	50                   	push   %eax
80105cc3:	6a 00                	push   $0x0
80105cc5:	e8 26 f4 ff ff       	call   801050f0 <argstr>
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	78 7f                	js     80105d50 <sys_exec2+0xa0>
80105cd1:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105cd7:	83 ec 08             	sub    $0x8,%esp
80105cda:	50                   	push   %eax
80105cdb:	6a 01                	push   $0x1
80105cdd:	e8 5e f3 ff ff       	call   80105040 <argint>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 67                	js     80105d50 <sys_exec2+0xa0>
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
80105ce9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105cef:	83 ec 04             	sub    $0x4,%esp
80105cf2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105cf8:	68 80 00 00 00       	push   $0x80
80105cfd:	6a 00                	push   $0x0
80105cff:	8d bd 60 ff ff ff    	lea    -0xa0(%ebp),%edi
80105d05:	50                   	push   %eax
80105d06:	31 db                	xor    %ebx,%ebx
80105d08:	e8 23 f0 ff ff       	call   80104d30 <memset>
80105d0d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d10:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105d16:	83 ec 08             	sub    $0x8,%esp
80105d19:	57                   	push   %edi
80105d1a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105d1d:	50                   	push   %eax
80105d1e:	e8 7d f2 ff ff       	call   80104fa0 <fetchint>
80105d23:	83 c4 10             	add    $0x10,%esp
80105d26:	85 c0                	test   %eax,%eax
80105d28:	78 26                	js     80105d50 <sys_exec2+0xa0>
      return -1;
    if(uarg == 0){
80105d2a:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d30:	85 c0                	test   %eax,%eax
80105d32:	74 2c                	je     80105d60 <sys_exec2+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d34:	83 ec 08             	sub    $0x8,%esp
80105d37:	56                   	push   %esi
80105d38:	50                   	push   %eax
80105d39:	e8 a2 f2 ff ff       	call   80104fe0 <fetchstr>
80105d3e:	83 c4 10             	add    $0x10,%esp
80105d41:	85 c0                	test   %eax,%eax
80105d43:	78 0b                	js     80105d50 <sys_exec2+0xa0>
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  //cprintf("sys exec : %s %d\n",path,uargv);
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105d45:	83 c3 01             	add    $0x1,%ebx
80105d48:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105d4b:	83 fb 20             	cmp    $0x20,%ebx
80105d4e:	75 c0                	jne    80105d10 <sys_exec2+0x60>
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  int i;
  uint uargv, uarg;

  //cprintf("sysexec2 !\n");
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
  return exec2(path, argv, stacksize);
}
80105d58:	5b                   	pop    %ebx
80105d59:	5e                   	pop    %esi
80105d5a:	5f                   	pop    %edi
80105d5b:	5d                   	pop    %ebp
80105d5c:	c3                   	ret    
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105d60:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d66:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105d69:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d70:	00 00 00 00 
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }

  int stacksize;
  if(argint(2,&stacksize) < 0) return -1;
80105d74:	50                   	push   %eax
80105d75:	6a 02                	push   $0x2
80105d77:	e8 c4 f2 ff ff       	call   80105040 <argint>
80105d7c:	83 c4 10             	add    $0x10,%esp
80105d7f:	85 c0                	test   %eax,%eax
80105d81:	78 cd                	js     80105d50 <sys_exec2+0xa0>
  return exec2(path, argv, stacksize);
80105d83:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d89:	83 ec 04             	sub    $0x4,%esp
80105d8c:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
80105d92:	50                   	push   %eax
80105d93:	ff b5 58 ff ff ff    	pushl  -0xa8(%ebp)
80105d99:	e8 f2 af ff ff       	call   80100d90 <exec2>
80105d9e:	83 c4 10             	add    $0x10,%esp
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_pipe>:

int
sys_pipe(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
80105db5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105db6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec2(path, argv, stacksize);
}

int
sys_pipe(void)
{
80105db9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dbc:	6a 08                	push   $0x8
80105dbe:	50                   	push   %eax
80105dbf:	6a 00                	push   $0x0
80105dc1:	e8 ca f2 ff ff       	call   80105090 <argptr>
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	78 4a                	js     80105e17 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105dcd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dd0:	83 ec 08             	sub    $0x8,%esp
80105dd3:	50                   	push   %eax
80105dd4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dd7:	50                   	push   %eax
80105dd8:	e8 03 d8 ff ff       	call   801035e0 <pipealloc>
80105ddd:	83 c4 10             	add    $0x10,%esp
80105de0:	85 c0                	test   %eax,%eax
80105de2:	78 33                	js     80105e17 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105de4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105de6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105de9:	e8 d2 dd ff ff       	call   80103bc0 <myproc>
80105dee:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105df0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105df4:	85 f6                	test   %esi,%esi
80105df6:	74 30                	je     80105e28 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105df8:	83 c3 01             	add    $0x1,%ebx
80105dfb:	83 fb 10             	cmp    $0x10,%ebx
80105dfe:	75 f0                	jne    80105df0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	ff 75 e0             	pushl  -0x20(%ebp)
80105e06:	e8 25 b4 ff ff       	call   80101230 <fileclose>
    fileclose(wf);
80105e0b:	58                   	pop    %eax
80105e0c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e0f:	e8 1c b4 ff ff       	call   80101230 <fileclose>
    return -1;
80105e14:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e1f:	5b                   	pop    %ebx
80105e20:	5e                   	pop    %esi
80105e21:	5f                   	pop    %edi
80105e22:	5d                   	pop    %ebp
80105e23:	c3                   	ret    
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e28:	8d 73 08             	lea    0x8(%ebx),%esi
80105e2b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e32:	e8 89 dd ff ff       	call   80103bc0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105e37:	31 d2                	xor    %edx,%edx
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e40:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e44:	85 c9                	test   %ecx,%ecx
80105e46:	74 18                	je     80105e60 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e48:	83 c2 01             	add    $0x1,%edx
80105e4b:	83 fa 10             	cmp    $0x10,%edx
80105e4e:	75 f0                	jne    80105e40 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105e50:	e8 6b dd ff ff       	call   80103bc0 <myproc>
80105e55:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e5c:	00 
80105e5d:	eb a1                	jmp    80105e00 <sys_pipe+0x50>
80105e5f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e60:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105e64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105e72:	31 c0                	xor    %eax,%eax
}
80105e74:	5b                   	pop    %ebx
80105e75:	5e                   	pop    %esi
80105e76:	5f                   	pop    %edi
80105e77:	5d                   	pop    %ebp
80105e78:	c3                   	ret    
80105e79:	66 90                	xchg   %ax,%ax
80105e7b:	66 90                	xchg   %ax,%ax
80105e7d:	66 90                	xchg   %ax,%ax
80105e7f:	90                   	nop

80105e80 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105e83:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e84:	e9 e7 de ff ff       	jmp    80103d70 <fork>
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_exit>:
}

int
sys_exit(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e96:	e8 05 e2 ff ff       	call   801040a0 <exit>
  return 0;  // not reached
}
80105e9b:	31 c0                	xor    %eax,%eax
80105e9d:	c9                   	leave  
80105e9e:	c3                   	ret    
80105e9f:	90                   	nop

80105ea0 <sys_wait>:

int
sys_wait(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ea3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105ea4:	e9 37 e8 ff ff       	jmp    801046e0 <wait>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_kill>:
}

int
sys_kill(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105eb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	6a 00                	push   $0x0
80105ebc:	e8 7f f1 ff ff       	call   80105040 <argint>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	78 18                	js     80105ee0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ece:	e8 7d e9 ff ff       	call   80104850 <kill>
80105ed3:	83 c4 10             	add    $0x10,%esp
}
80105ed6:	c9                   	leave  
80105ed7:	c3                   	ret    
80105ed8:	90                   	nop
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ef0 <sys_getpid>:

int
sys_getpid(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ef6:	e8 c5 dc ff ff       	call   80103bc0 <myproc>
80105efb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105efe:	c9                   	leave  
80105eff:	c3                   	ret    

80105f00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105f07:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f0a:	50                   	push   %eax
80105f0b:	6a 00                	push   $0x0
80105f0d:	e8 2e f1 ff ff       	call   80105040 <argint>
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	85 c0                	test   %eax,%eax
80105f17:	78 27                	js     80105f40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f19:	e8 a2 dc ff ff       	call   80103bc0 <myproc>
  if(growproc(n) < 0)
80105f1e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105f21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f23:	ff 75 f4             	pushl  -0xc(%ebp)
80105f26:	e8 b5 dd ff ff       	call   80103ce0 <growproc>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	85 c0                	test   %eax,%eax
80105f30:	78 0e                	js     80105f40 <sys_sbrk+0x40>
    return -1;
  return addr;
80105f32:	89 d8                	mov    %ebx,%eax
}
80105f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f37:	c9                   	leave  
80105f38:	c3                   	ret    
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f45:	eb ed                	jmp    80105f34 <sys_sbrk+0x34>
80105f47:	89 f6                	mov    %esi,%esi
80105f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f50 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
80105f54:	83 ec 14             	sub    $0x14,%esp
  int n;
  uint ticks0;

  /////////////////////////////////////////
  //sleep때는 초기화
  myproc()->queuelevel = 0;
80105f57:	e8 64 dc ff ff       	call   80103bc0 <myproc>
80105f5c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105f63:	00 00 00 
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
80105f66:	e8 55 dc ff ff       	call   80103bc0 <myproc>
80105f6b:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80105f72:	00 00 00 
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
80105f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f78:	83 ec 08             	sub    $0x8,%esp
80105f7b:	50                   	push   %eax
80105f7c:	6a 00                	push   $0x0
80105f7e:	e8 bd f0 ff ff       	call   80105040 <argint>
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	85 c0                	test   %eax,%eax
80105f88:	0f 88 89 00 00 00    	js     80106017 <sys_sleep+0xc7>
    return -1;
  acquire(&tickslock);
80105f8e:	83 ec 0c             	sub    $0xc,%esp
80105f91:	68 60 64 11 80       	push   $0x80116460
80105f96:	e8 95 ec ff ff       	call   80104c30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f9e:	83 c4 10             	add    $0x10,%esp
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105fa1:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105fa7:	85 d2                	test   %edx,%edx
80105fa9:	75 26                	jne    80105fd1 <sys_sleep+0x81>
80105fab:	eb 53                	jmp    80106000 <sys_sleep+0xb0>
80105fad:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fb0:	83 ec 08             	sub    $0x8,%esp
80105fb3:	68 60 64 11 80       	push   $0x80116460
80105fb8:	68 a0 6c 11 80       	push   $0x80116ca0
80105fbd:	e8 5e e6 ff ff       	call   80104620 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fc2:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80105fc7:	83 c4 10             	add    $0x10,%esp
80105fca:	29 d8                	sub    %ebx,%eax
80105fcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fcf:	73 2f                	jae    80106000 <sys_sleep+0xb0>
    if(myproc()->killed){
80105fd1:	e8 ea db ff ff       	call   80103bc0 <myproc>
80105fd6:	8b 40 24             	mov    0x24(%eax),%eax
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	74 d3                	je     80105fb0 <sys_sleep+0x60>
      release(&tickslock);
80105fdd:	83 ec 0c             	sub    $0xc,%esp
80105fe0:	68 60 64 11 80       	push   $0x80116460
80105fe5:	e8 f6 ec ff ff       	call   80104ce0 <release>
      return -1;
80105fea:	83 c4 10             	add    $0x10,%esp
80105fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105ff2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff5:	c9                   	leave  
80105ff6:	c3                   	ret    
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106000:	83 ec 0c             	sub    $0xc,%esp
80106003:	68 60 64 11 80       	push   $0x80116460
80106008:	e8 d3 ec ff ff       	call   80104ce0 <release>
  return 0;
8010600d:	83 c4 10             	add    $0x10,%esp
80106010:	31 c0                	xor    %eax,%eax
}
80106012:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106015:	c9                   	leave  
80106016:	c3                   	ret    
 // myproc()->priority = 0;
  myproc()->tickleft = 4;
  //////////////////////////////////////////

  if(argint(0, &n) < 0)
    return -1;
80106017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010601c:	eb d4                	jmp    80105ff2 <sys_sleep+0xa2>
8010601e:	66 90                	xchg   %ax,%ax

80106020 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	53                   	push   %ebx
80106024:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106027:	68 60 64 11 80       	push   $0x80116460
8010602c:	e8 ff eb ff ff       	call   80104c30 <acquire>
  xticks = ticks;
80106031:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80106037:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
8010603e:	e8 9d ec ff ff       	call   80104ce0 <release>
  return xticks;
}
80106043:	89 d8                	mov    %ebx,%eax
80106045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106048:	c9                   	leave  
80106049:	c3                   	ret    
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106050 <sys_yield>:

void 
sys_yield()
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	83 ec 08             	sub    $0x8,%esp
  myproc()->queuelevel = 0;
80106056:	e8 65 db ff ff       	call   80103bc0 <myproc>
8010605b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106062:	00 00 00 
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
80106065:	e8 56 db ff ff       	call   80103bc0 <myproc>
8010606a:	c7 80 84 00 00 00 04 	movl   $0x4,0x84(%eax)
80106071:	00 00 00 
  yield();
}
80106074:	c9                   	leave  
sys_yield()
{
  myproc()->queuelevel = 0;
  //myproc()->priority = 0;
  myproc()->tickleft = 4;
  yield();
80106075:	e9 56 e1 ff ff       	jmp    801041d0 <yield>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106080 <sys_getlev>:
}

int             
sys_getlev(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
  return getlev();
}
80106083:	5d                   	pop    %ebp
}

int             
sys_getlev(void)
{
  return getlev();
80106084:	e9 97 e1 ff ff       	jmp    80104220 <getlev>
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106090 <sys_setpriority>:
}

int             
sys_setpriority(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	83 ec 20             	sub    $0x20,%esp
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
80106096:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106099:	50                   	push   %eax
8010609a:	6a 00                	push   $0x0
8010609c:	e8 9f ef ff ff       	call   80105040 <argint>
801060a1:	83 c4 10             	add    $0x10,%esp
801060a4:	85 c0                	test   %eax,%eax
801060a6:	78 28                	js     801060d0 <sys_setpriority+0x40>
	if(argint(1,&priority)<0) return -2;
801060a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060ab:	83 ec 08             	sub    $0x8,%esp
801060ae:	50                   	push   %eax
801060af:	6a 01                	push   $0x1
801060b1:	e8 8a ef ff ff       	call   80105040 <argint>
801060b6:	83 c4 10             	add    $0x10,%esp
801060b9:	85 c0                	test   %eax,%eax
801060bb:	78 23                	js     801060e0 <sys_setpriority+0x50>
	return setpriority(pid,priority);
801060bd:	83 ec 08             	sub    $0x8,%esp
801060c0:	ff 75 f4             	pushl  -0xc(%ebp)
801060c3:	ff 75 f0             	pushl  -0x10(%ebp)
801060c6:	e8 95 e4 ff ff       	call   80104560 <setpriority>
801060cb:	83 c4 10             	add    $0x10,%esp
}
801060ce:	c9                   	leave  
801060cf:	c3                   	ret    

int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
801060d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	if(argint(1,&priority)<0) return -2;
	return setpriority(pid,priority);
}
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    
801060d7:	89 f6                	mov    %esi,%esi
801060d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
int             
sys_setpriority(void)
{
	int pid,priority;
	if(argint(0,&pid)<0) return -1;
	if(argint(1,&priority)<0) return -2;
801060e0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	return setpriority(pid,priority);
}
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
801060e7:	89 f6                	mov    %esi,%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060f0 <sys_getadmin>:


int
sys_getadmin(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 20             	sub    $0x20,%esp
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
801060f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060f9:	50                   	push   %eax
801060fa:	6a 00                	push   $0x0
801060fc:	e8 ef ef ff ff       	call   801050f0 <argstr>
80106101:	83 c4 10             	add    $0x10,%esp
80106104:	85 c0                	test   %eax,%eax
80106106:	78 18                	js     80106120 <sys_getadmin+0x30>
  return getadmin(student_number);
80106108:	83 ec 0c             	sub    $0xc,%esp
8010610b:	ff 75 f4             	pushl  -0xc(%ebp)
8010610e:	e8 3d e1 ff ff       	call   80104250 <getadmin>
80106113:	83 c4 10             	add    $0x10,%esp
}
80106116:	c9                   	leave  
80106117:	c3                   	ret    
80106118:	90                   	nop
80106119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int
sys_getadmin(void)
{
  char *student_number;
  if( argstr(0,&student_number) < 0) return -1;
80106120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return getadmin(student_number);
}
80106125:	c9                   	leave  
80106126:	c3                   	ret    
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106130 <sys_setmemorylimit>:

int
sys_setmemorylimit(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 20             	sub    $0x20,%esp
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80106136:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106139:	50                   	push   %eax
8010613a:	6a 00                	push   $0x0
8010613c:	e8 ff ee ff ff       	call   80105040 <argint>
80106141:	83 c4 10             	add    $0x10,%esp
80106144:	85 c0                	test   %eax,%eax
80106146:	78 28                	js     80106170 <sys_setmemorylimit+0x40>
80106148:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010614b:	83 ec 08             	sub    $0x8,%esp
8010614e:	50                   	push   %eax
8010614f:	6a 01                	push   $0x1
80106151:	e8 ea ee ff ff       	call   80105040 <argint>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	78 13                	js     80106170 <sys_setmemorylimit+0x40>
  return setmemorylimit(pid,limit);
8010615d:	83 ec 08             	sub    $0x8,%esp
80106160:	ff 75 f4             	pushl  -0xc(%ebp)
80106163:	ff 75 f0             	pushl  -0x10(%ebp)
80106166:	e8 65 e1 ff ff       	call   801042d0 <setmemorylimit>
8010616b:	83 c4 10             	add    $0x10,%esp
}
8010616e:	c9                   	leave  
8010616f:	c3                   	ret    

int
sys_setmemorylimit(void)
{
  int pid,limit;
  if(argint(0,&pid)<0 || argint(1,&limit) < 0) return -1;
80106170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return setmemorylimit(pid,limit);
}
80106175:	c9                   	leave  
80106176:	c3                   	ret    
80106177:	89 f6                	mov    %esi,%esi
80106179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106180 <sys_list>:

int
sys_list(void)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
  return list();
}
80106183:	5d                   	pop    %ebp
}

int
sys_list(void)
{
  return list();
80106184:	e9 07 e3 ff ff       	jmp    80104490 <list>
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <sys_getshmem>:
}

char*
sys_getshmem(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0,&pid)<0) return 0;
80106196:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106199:	50                   	push   %eax
8010619a:	6a 00                	push   $0x0
8010619c:	e8 9f ee ff ff       	call   80105040 <argint>
801061a1:	83 c4 10             	add    $0x10,%esp
801061a4:	85 c0                	test   %eax,%eax
801061a6:	78 18                	js     801061c0 <sys_getshmem+0x30>
  return getshmem(pid);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	ff 75 f4             	pushl  -0xc(%ebp)
801061ae:	e8 bd e1 ff ff       	call   80104370 <getshmem>
801061b3:	83 c4 10             	add    $0x10,%esp
}
801061b6:	c9                   	leave  
801061b7:	c3                   	ret    
801061b8:	90                   	nop
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char*
sys_getshmem(void)
{
  int pid;
  if(argint(0,&pid)<0) return 0;
801061c0:	31 c0                	xor    %eax,%eax
  return getshmem(pid);
}
801061c2:	c9                   	leave  
801061c3:	c3                   	ret    

801061c4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801061c4:	1e                   	push   %ds
  pushl %es
801061c5:	06                   	push   %es
  pushl %fs
801061c6:	0f a0                	push   %fs
  pushl %gs
801061c8:	0f a8                	push   %gs
  pushal
801061ca:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061cb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061cf:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061d1:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061d3:	54                   	push   %esp
  call trap
801061d4:	e8 e7 00 00 00       	call   801062c0 <trap>
  addl $4, %esp
801061d9:	83 c4 04             	add    $0x4,%esp

801061dc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061dc:	61                   	popa   
  popl %gs
801061dd:	0f a9                	pop    %gs
  popl %fs
801061df:	0f a1                	pop    %fs
  popl %es
801061e1:	07                   	pop    %es
  popl %ds
801061e2:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801061e3:	83 c4 08             	add    $0x8,%esp
  iret
801061e6:	cf                   	iret   
801061e7:	66 90                	xchg   %ax,%ax
801061e9:	66 90                	xchg   %ax,%ax
801061eb:	66 90                	xchg   %ax,%ax
801061ed:	66 90                	xchg   %ax,%ax
801061ef:	90                   	nop

801061f0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801061f0:	31 c0                	xor    %eax,%eax
801061f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061f8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801061ff:	b9 08 00 00 00       	mov    $0x8,%ecx
80106204:	c6 04 c5 a4 64 11 80 	movb   $0x0,-0x7fee9b5c(,%eax,8)
8010620b:	00 
8010620c:	66 89 0c c5 a2 64 11 	mov    %cx,-0x7fee9b5e(,%eax,8)
80106213:	80 
80106214:	c6 04 c5 a5 64 11 80 	movb   $0x8e,-0x7fee9b5b(,%eax,8)
8010621b:	8e 
8010621c:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
80106223:	80 
80106224:	c1 ea 10             	shr    $0x10,%edx
80106227:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
8010622e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010622f:	83 c0 01             	add    $0x1,%eax
80106232:	3d 00 01 00 00       	cmp    $0x100,%eax
80106237:	75 bf                	jne    801061f8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106239:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010623a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010623f:	89 e5                	mov    %esp,%ebp
80106241:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106244:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106249:	68 b9 82 10 80       	push   $0x801082b9
8010624e:	68 60 64 11 80       	push   $0x80116460
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106253:	66 89 15 a2 66 11 80 	mov    %dx,0x801166a2
8010625a:	c6 05 a4 66 11 80 00 	movb   $0x0,0x801166a4
80106261:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
80106267:	c1 e8 10             	shr    $0x10,%eax
8010626a:	c6 05 a5 66 11 80 ef 	movb   $0xef,0x801166a5
80106271:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6

  initlock(&tickslock, "time");
80106277:	e8 54 e8 ff ff       	call   80104ad0 <initlock>
}
8010627c:	83 c4 10             	add    $0x10,%esp
8010627f:	c9                   	leave  
80106280:	c3                   	ret    
80106281:	eb 0d                	jmp    80106290 <idtinit>
80106283:	90                   	nop
80106284:	90                   	nop
80106285:	90                   	nop
80106286:	90                   	nop
80106287:	90                   	nop
80106288:	90                   	nop
80106289:	90                   	nop
8010628a:	90                   	nop
8010628b:	90                   	nop
8010628c:	90                   	nop
8010628d:	90                   	nop
8010628e:	90                   	nop
8010628f:	90                   	nop

80106290 <idtinit>:

void
idtinit(void)
{
80106290:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106291:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106296:	89 e5                	mov    %esp,%ebp
80106298:	83 ec 10             	sub    $0x10,%esp
8010629b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010629f:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
801062a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801062a8:	c1 e8 10             	shr    $0x10,%eax
801062ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801062af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    
801062b7:	89 f6                	mov    %esi,%esi
801062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
801062c6:	83 ec 1c             	sub    $0x1c,%esp
801062c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801062cc:	8b 47 30             	mov    0x30(%edi),%eax
801062cf:	83 f8 40             	cmp    $0x40,%eax
801062d2:	0f 84 88 01 00 00    	je     80106460 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062d8:	83 e8 20             	sub    $0x20,%eax
801062db:	83 f8 1f             	cmp    $0x1f,%eax
801062de:	77 10                	ja     801062f0 <trap+0x30>
801062e0:	ff 24 85 60 83 10 80 	jmp    *-0x7fef7ca0(,%eax,4)
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062f0:	e8 cb d8 ff ff       	call   80103bc0 <myproc>
801062f5:	85 c0                	test   %eax,%eax
801062f7:	0f 84 d7 01 00 00    	je     801064d4 <trap+0x214>
801062fd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106301:	0f 84 cd 01 00 00    	je     801064d4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106307:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010630a:	8b 57 38             	mov    0x38(%edi),%edx
8010630d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106310:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106313:	e8 88 d8 ff ff       	call   80103ba0 <cpuid>
80106318:	8b 77 34             	mov    0x34(%edi),%esi
8010631b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010631e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106321:	e8 9a d8 ff ff       	call   80103bc0 <myproc>
80106326:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106329:	e8 92 d8 ff ff       	call   80103bc0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010632e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106331:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106334:	51                   	push   %ecx
80106335:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106336:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106339:	ff 75 e4             	pushl  -0x1c(%ebp)
8010633c:	56                   	push   %esi
8010633d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010633e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106341:	52                   	push   %edx
80106342:	ff 70 10             	pushl  0x10(%eax)
80106345:	68 1c 83 10 80       	push   $0x8010831c
8010634a:	e8 11 a3 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010634f:	83 c4 20             	add    $0x20,%esp
80106352:	e8 69 d8 ff ff       	call   80103bc0 <myproc>
80106357:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010635e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106360:	e8 5b d8 ff ff       	call   80103bc0 <myproc>
80106365:	85 c0                	test   %eax,%eax
80106367:	74 0c                	je     80106375 <trap+0xb5>
80106369:	e8 52 d8 ff ff       	call   80103bc0 <myproc>
8010636e:	8b 50 24             	mov    0x24(%eax),%edx
80106371:	85 d2                	test   %edx,%edx
80106373:	75 4b                	jne    801063c0 <trap+0x100>
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
80106375:	e8 46 d8 ff ff       	call   80103bc0 <myproc>
8010637a:	85 c0                	test   %eax,%eax
8010637c:	74 0b                	je     80106389 <trap+0xc9>
8010637e:	e8 3d d8 ff ff       	call   80103bc0 <myproc>
80106383:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106387:	74 4f                	je     801063d8 <trap+0x118>
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106389:	e8 32 d8 ff ff       	call   80103bc0 <myproc>
8010638e:	85 c0                	test   %eax,%eax
80106390:	74 1d                	je     801063af <trap+0xef>
80106392:	e8 29 d8 ff ff       	call   80103bc0 <myproc>
80106397:	8b 40 24             	mov    0x24(%eax),%eax
8010639a:	85 c0                	test   %eax,%eax
8010639c:	74 11                	je     801063af <trap+0xef>
8010639e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063a2:	83 e0 03             	and    $0x3,%eax
801063a5:	66 83 f8 03          	cmp    $0x3,%ax
801063a9:	0f 84 da 00 00 00    	je     80106489 <trap+0x1c9>
    exit();
}
801063af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b2:	5b                   	pop    %ebx
801063b3:	5e                   	pop    %esi
801063b4:	5f                   	pop    %edi
801063b5:	5d                   	pop    %ebp
801063b6:	c3                   	ret    
801063b7:	89 f6                	mov    %esi,%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063c0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801063c4:	83 e0 03             	and    $0x3,%eax
801063c7:	66 83 f8 03          	cmp    $0x3,%ax
801063cb:	75 a8                	jne    80106375 <trap+0xb5>
    exit();
801063cd:	e8 ce dc ff ff       	call   801040a0 <exit>
801063d2:	eb a1                	jmp    80106375 <trap+0xb5>
801063d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  if(ticks%100 == 0) priority_boosting();

  #else
  //myproc()->tick++;
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
801063d8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801063dc:	75 ab                	jne    80106389 <trap+0xc9>
801063de:	e8 ed dd ff ff       	call   801041d0 <yield>
801063e3:	eb a4                	jmp    80106389 <trap+0xc9>
801063e5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801063e8:	e8 b3 d7 ff ff       	call   80103ba0 <cpuid>
801063ed:	85 c0                	test   %eax,%eax
801063ef:	0f 84 ab 00 00 00    	je     801064a0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801063f5:	e8 06 c7 ff ff       	call   80102b00 <lapiceoi>
    break;
801063fa:	e9 61 ff ff ff       	jmp    80106360 <trap+0xa0>
801063ff:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106400:	e8 bb c5 ff ff       	call   801029c0 <kbdintr>
    lapiceoi();
80106405:	e8 f6 c6 ff ff       	call   80102b00 <lapiceoi>
    break;
8010640a:	e9 51 ff ff ff       	jmp    80106360 <trap+0xa0>
8010640f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106410:	e8 5b 02 00 00       	call   80106670 <uartintr>
    lapiceoi();
80106415:	e8 e6 c6 ff ff       	call   80102b00 <lapiceoi>
    break;
8010641a:	e9 41 ff ff ff       	jmp    80106360 <trap+0xa0>
8010641f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106420:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106424:	8b 77 38             	mov    0x38(%edi),%esi
80106427:	e8 74 d7 ff ff       	call   80103ba0 <cpuid>
8010642c:	56                   	push   %esi
8010642d:	53                   	push   %ebx
8010642e:	50                   	push   %eax
8010642f:	68 c4 82 10 80       	push   $0x801082c4
80106434:	e8 27 a2 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106439:	e8 c2 c6 ff ff       	call   80102b00 <lapiceoi>
    break;
8010643e:	83 c4 10             	add    $0x10,%esp
80106441:	e9 1a ff ff ff       	jmp    80106360 <trap+0xa0>
80106446:	8d 76 00             	lea    0x0(%esi),%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106450:	e8 eb bf ff ff       	call   80102440 <ideintr>
80106455:	eb 9e                	jmp    801063f5 <trap+0x135>
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106460:	e8 5b d7 ff ff       	call   80103bc0 <myproc>
80106465:	8b 58 24             	mov    0x24(%eax),%ebx
80106468:	85 db                	test   %ebx,%ebx
8010646a:	75 2c                	jne    80106498 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010646c:	e8 4f d7 ff ff       	call   80103bc0 <myproc>
80106471:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106474:	e8 b7 ec ff ff       	call   80105130 <syscall>
    if(myproc()->killed)
80106479:	e8 42 d7 ff ff       	call   80103bc0 <myproc>
8010647e:	8b 48 24             	mov    0x24(%eax),%ecx
80106481:	85 c9                	test   %ecx,%ecx
80106483:	0f 84 26 ff ff ff    	je     801063af <trap+0xef>
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) yield();
  #endif
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106489:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010648c:	5b                   	pop    %ebx
8010648d:	5e                   	pop    %esi
8010648e:	5f                   	pop    %edi
8010648f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106490:	e9 0b dc ff ff       	jmp    801040a0 <exit>
80106495:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106498:	e8 03 dc ff ff       	call   801040a0 <exit>
8010649d:	eb cd                	jmp    8010646c <trap+0x1ac>
8010649f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	68 60 64 11 80       	push   $0x80116460
801064a8:	e8 83 e7 ff ff       	call   80104c30 <acquire>
      ticks++;
      wakeup(&ticks);
801064ad:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801064b4:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      wakeup(&ticks);
801064bb:	e8 30 e3 ff ff       	call   801047f0 <wakeup>
      release(&tickslock);
801064c0:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
801064c7:	e8 14 e8 ff ff       	call   80104ce0 <release>
801064cc:	83 c4 10             	add    $0x10,%esp
801064cf:	e9 21 ff ff ff       	jmp    801063f5 <trap+0x135>
801064d4:	0f 20 d6             	mov    %cr2,%esi
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      //cprintf("에러탐지용 :  %d\n",myproc());
	  // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064d7:	8b 5f 38             	mov    0x38(%edi),%ebx
801064da:	e8 c1 d6 ff ff       	call   80103ba0 <cpuid>
801064df:	83 ec 0c             	sub    $0xc,%esp
801064e2:	56                   	push   %esi
801064e3:	53                   	push   %ebx
801064e4:	50                   	push   %eax
801064e5:	ff 77 30             	pushl  0x30(%edi)
801064e8:	68 e8 82 10 80       	push   $0x801082e8
801064ed:	e8 6e a1 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801064f2:	83 c4 14             	add    $0x14,%esp
801064f5:	68 be 82 10 80       	push   $0x801082be
801064fa:	e8 71 9e ff ff       	call   80100370 <panic>
801064ff:	90                   	nop

80106500 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106500:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106505:	55                   	push   %ebp
80106506:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106508:	85 c0                	test   %eax,%eax
8010650a:	74 1c                	je     80106528 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010650c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106511:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106512:	a8 01                	test   $0x1,%al
80106514:	74 12                	je     80106528 <uartgetc+0x28>
80106516:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010651b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010651c:	0f b6 c0             	movzbl %al,%eax
}
8010651f:	5d                   	pop    %ebp
80106520:	c3                   	ret    
80106521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010652d:	5d                   	pop    %ebp
8010652e:	c3                   	ret    
8010652f:	90                   	nop

80106530 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	57                   	push   %edi
80106534:	56                   	push   %esi
80106535:	53                   	push   %ebx
80106536:	89 c7                	mov    %eax,%edi
80106538:	bb 80 00 00 00       	mov    $0x80,%ebx
8010653d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106542:	83 ec 0c             	sub    $0xc,%esp
80106545:	eb 1b                	jmp    80106562 <uartputc.part.0+0x32>
80106547:	89 f6                	mov    %esi,%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106550:	83 ec 0c             	sub    $0xc,%esp
80106553:	6a 0a                	push   $0xa
80106555:	e8 c6 c5 ff ff       	call   80102b20 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010655a:	83 c4 10             	add    $0x10,%esp
8010655d:	83 eb 01             	sub    $0x1,%ebx
80106560:	74 07                	je     80106569 <uartputc.part.0+0x39>
80106562:	89 f2                	mov    %esi,%edx
80106564:	ec                   	in     (%dx),%al
80106565:	a8 20                	test   $0x20,%al
80106567:	74 e7                	je     80106550 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106569:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010656e:	89 f8                	mov    %edi,%eax
80106570:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106574:	5b                   	pop    %ebx
80106575:	5e                   	pop    %esi
80106576:	5f                   	pop    %edi
80106577:	5d                   	pop    %ebp
80106578:	c3                   	ret    
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106580 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106580:	55                   	push   %ebp
80106581:	31 c9                	xor    %ecx,%ecx
80106583:	89 c8                	mov    %ecx,%eax
80106585:	89 e5                	mov    %esp,%ebp
80106587:	57                   	push   %edi
80106588:	56                   	push   %esi
80106589:	53                   	push   %ebx
8010658a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010658f:	89 da                	mov    %ebx,%edx
80106591:	83 ec 0c             	sub    $0xc,%esp
80106594:	ee                   	out    %al,(%dx)
80106595:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010659a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010659f:	89 fa                	mov    %edi,%edx
801065a1:	ee                   	out    %al,(%dx)
801065a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065ac:	ee                   	out    %al,(%dx)
801065ad:	be f9 03 00 00       	mov    $0x3f9,%esi
801065b2:	89 c8                	mov    %ecx,%eax
801065b4:	89 f2                	mov    %esi,%edx
801065b6:	ee                   	out    %al,(%dx)
801065b7:	b8 03 00 00 00       	mov    $0x3,%eax
801065bc:	89 fa                	mov    %edi,%edx
801065be:	ee                   	out    %al,(%dx)
801065bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065c4:	89 c8                	mov    %ecx,%eax
801065c6:	ee                   	out    %al,(%dx)
801065c7:	b8 01 00 00 00       	mov    $0x1,%eax
801065cc:	89 f2                	mov    %esi,%edx
801065ce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065d4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801065d5:	3c ff                	cmp    $0xff,%al
801065d7:	74 5a                	je     80106633 <uartinit+0xb3>
    return;
  uart = 1;
801065d9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801065e0:	00 00 00 
801065e3:	89 da                	mov    %ebx,%edx
801065e5:	ec                   	in     (%dx),%al
801065e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065eb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801065ec:	83 ec 08             	sub    $0x8,%esp
801065ef:	bb e0 83 10 80       	mov    $0x801083e0,%ebx
801065f4:	6a 00                	push   $0x0
801065f6:	6a 04                	push   $0x4
801065f8:	e8 93 c0 ff ff       	call   80102690 <ioapicenable>
801065fd:	83 c4 10             	add    $0x10,%esp
80106600:	b8 78 00 00 00       	mov    $0x78,%eax
80106605:	eb 13                	jmp    8010661a <uartinit+0x9a>
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106610:	83 c3 01             	add    $0x1,%ebx
80106613:	0f be 03             	movsbl (%ebx),%eax
80106616:	84 c0                	test   %al,%al
80106618:	74 19                	je     80106633 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010661a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106620:	85 d2                	test   %edx,%edx
80106622:	74 ec                	je     80106610 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106624:	83 c3 01             	add    $0x1,%ebx
80106627:	e8 04 ff ff ff       	call   80106530 <uartputc.part.0>
8010662c:	0f be 03             	movsbl (%ebx),%eax
8010662f:	84 c0                	test   %al,%al
80106631:	75 e7                	jne    8010661a <uartinit+0x9a>
    uartputc(*p);
}
80106633:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106636:	5b                   	pop    %ebx
80106637:	5e                   	pop    %esi
80106638:	5f                   	pop    %edi
80106639:	5d                   	pop    %ebp
8010663a:	c3                   	ret    
8010663b:	90                   	nop
8010663c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106640 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106640:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106646:	55                   	push   %ebp
80106647:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106649:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010664b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010664e:	74 10                	je     80106660 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106650:	5d                   	pop    %ebp
80106651:	e9 da fe ff ff       	jmp    80106530 <uartputc.part.0>
80106656:	8d 76 00             	lea    0x0(%esi),%esi
80106659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106660:	5d                   	pop    %ebp
80106661:	c3                   	ret    
80106662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106670 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106676:	68 00 65 10 80       	push   $0x80106500
8010667b:	e8 70 a1 ff ff       	call   801007f0 <consoleintr>
}
80106680:	83 c4 10             	add    $0x10,%esp
80106683:	c9                   	leave  
80106684:	c3                   	ret    

80106685 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $0
80106687:	6a 00                	push   $0x0
  jmp alltraps
80106689:	e9 36 fb ff ff       	jmp    801061c4 <alltraps>

8010668e <vector1>:
.globl vector1
vector1:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $1
80106690:	6a 01                	push   $0x1
  jmp alltraps
80106692:	e9 2d fb ff ff       	jmp    801061c4 <alltraps>

80106697 <vector2>:
.globl vector2
vector2:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $2
80106699:	6a 02                	push   $0x2
  jmp alltraps
8010669b:	e9 24 fb ff ff       	jmp    801061c4 <alltraps>

801066a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $3
801066a2:	6a 03                	push   $0x3
  jmp alltraps
801066a4:	e9 1b fb ff ff       	jmp    801061c4 <alltraps>

801066a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $4
801066ab:	6a 04                	push   $0x4
  jmp alltraps
801066ad:	e9 12 fb ff ff       	jmp    801061c4 <alltraps>

801066b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $5
801066b4:	6a 05                	push   $0x5
  jmp alltraps
801066b6:	e9 09 fb ff ff       	jmp    801061c4 <alltraps>

801066bb <vector6>:
.globl vector6
vector6:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $6
801066bd:	6a 06                	push   $0x6
  jmp alltraps
801066bf:	e9 00 fb ff ff       	jmp    801061c4 <alltraps>

801066c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $7
801066c6:	6a 07                	push   $0x7
  jmp alltraps
801066c8:	e9 f7 fa ff ff       	jmp    801061c4 <alltraps>

801066cd <vector8>:
.globl vector8
vector8:
  pushl $8
801066cd:	6a 08                	push   $0x8
  jmp alltraps
801066cf:	e9 f0 fa ff ff       	jmp    801061c4 <alltraps>

801066d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $9
801066d6:	6a 09                	push   $0x9
  jmp alltraps
801066d8:	e9 e7 fa ff ff       	jmp    801061c4 <alltraps>

801066dd <vector10>:
.globl vector10
vector10:
  pushl $10
801066dd:	6a 0a                	push   $0xa
  jmp alltraps
801066df:	e9 e0 fa ff ff       	jmp    801061c4 <alltraps>

801066e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066e4:	6a 0b                	push   $0xb
  jmp alltraps
801066e6:	e9 d9 fa ff ff       	jmp    801061c4 <alltraps>

801066eb <vector12>:
.globl vector12
vector12:
  pushl $12
801066eb:	6a 0c                	push   $0xc
  jmp alltraps
801066ed:	e9 d2 fa ff ff       	jmp    801061c4 <alltraps>

801066f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066f2:	6a 0d                	push   $0xd
  jmp alltraps
801066f4:	e9 cb fa ff ff       	jmp    801061c4 <alltraps>

801066f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066f9:	6a 0e                	push   $0xe
  jmp alltraps
801066fb:	e9 c4 fa ff ff       	jmp    801061c4 <alltraps>

80106700 <vector15>:
.globl vector15
vector15:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $15
80106702:	6a 0f                	push   $0xf
  jmp alltraps
80106704:	e9 bb fa ff ff       	jmp    801061c4 <alltraps>

80106709 <vector16>:
.globl vector16
vector16:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $16
8010670b:	6a 10                	push   $0x10
  jmp alltraps
8010670d:	e9 b2 fa ff ff       	jmp    801061c4 <alltraps>

80106712 <vector17>:
.globl vector17
vector17:
  pushl $17
80106712:	6a 11                	push   $0x11
  jmp alltraps
80106714:	e9 ab fa ff ff       	jmp    801061c4 <alltraps>

80106719 <vector18>:
.globl vector18
vector18:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $18
8010671b:	6a 12                	push   $0x12
  jmp alltraps
8010671d:	e9 a2 fa ff ff       	jmp    801061c4 <alltraps>

80106722 <vector19>:
.globl vector19
vector19:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $19
80106724:	6a 13                	push   $0x13
  jmp alltraps
80106726:	e9 99 fa ff ff       	jmp    801061c4 <alltraps>

8010672b <vector20>:
.globl vector20
vector20:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $20
8010672d:	6a 14                	push   $0x14
  jmp alltraps
8010672f:	e9 90 fa ff ff       	jmp    801061c4 <alltraps>

80106734 <vector21>:
.globl vector21
vector21:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $21
80106736:	6a 15                	push   $0x15
  jmp alltraps
80106738:	e9 87 fa ff ff       	jmp    801061c4 <alltraps>

8010673d <vector22>:
.globl vector22
vector22:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $22
8010673f:	6a 16                	push   $0x16
  jmp alltraps
80106741:	e9 7e fa ff ff       	jmp    801061c4 <alltraps>

80106746 <vector23>:
.globl vector23
vector23:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $23
80106748:	6a 17                	push   $0x17
  jmp alltraps
8010674a:	e9 75 fa ff ff       	jmp    801061c4 <alltraps>

8010674f <vector24>:
.globl vector24
vector24:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $24
80106751:	6a 18                	push   $0x18
  jmp alltraps
80106753:	e9 6c fa ff ff       	jmp    801061c4 <alltraps>

80106758 <vector25>:
.globl vector25
vector25:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $25
8010675a:	6a 19                	push   $0x19
  jmp alltraps
8010675c:	e9 63 fa ff ff       	jmp    801061c4 <alltraps>

80106761 <vector26>:
.globl vector26
vector26:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $26
80106763:	6a 1a                	push   $0x1a
  jmp alltraps
80106765:	e9 5a fa ff ff       	jmp    801061c4 <alltraps>

8010676a <vector27>:
.globl vector27
vector27:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $27
8010676c:	6a 1b                	push   $0x1b
  jmp alltraps
8010676e:	e9 51 fa ff ff       	jmp    801061c4 <alltraps>

80106773 <vector28>:
.globl vector28
vector28:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $28
80106775:	6a 1c                	push   $0x1c
  jmp alltraps
80106777:	e9 48 fa ff ff       	jmp    801061c4 <alltraps>

8010677c <vector29>:
.globl vector29
vector29:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $29
8010677e:	6a 1d                	push   $0x1d
  jmp alltraps
80106780:	e9 3f fa ff ff       	jmp    801061c4 <alltraps>

80106785 <vector30>:
.globl vector30
vector30:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $30
80106787:	6a 1e                	push   $0x1e
  jmp alltraps
80106789:	e9 36 fa ff ff       	jmp    801061c4 <alltraps>

8010678e <vector31>:
.globl vector31
vector31:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $31
80106790:	6a 1f                	push   $0x1f
  jmp alltraps
80106792:	e9 2d fa ff ff       	jmp    801061c4 <alltraps>

80106797 <vector32>:
.globl vector32
vector32:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $32
80106799:	6a 20                	push   $0x20
  jmp alltraps
8010679b:	e9 24 fa ff ff       	jmp    801061c4 <alltraps>

801067a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $33
801067a2:	6a 21                	push   $0x21
  jmp alltraps
801067a4:	e9 1b fa ff ff       	jmp    801061c4 <alltraps>

801067a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $34
801067ab:	6a 22                	push   $0x22
  jmp alltraps
801067ad:	e9 12 fa ff ff       	jmp    801061c4 <alltraps>

801067b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $35
801067b4:	6a 23                	push   $0x23
  jmp alltraps
801067b6:	e9 09 fa ff ff       	jmp    801061c4 <alltraps>

801067bb <vector36>:
.globl vector36
vector36:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $36
801067bd:	6a 24                	push   $0x24
  jmp alltraps
801067bf:	e9 00 fa ff ff       	jmp    801061c4 <alltraps>

801067c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $37
801067c6:	6a 25                	push   $0x25
  jmp alltraps
801067c8:	e9 f7 f9 ff ff       	jmp    801061c4 <alltraps>

801067cd <vector38>:
.globl vector38
vector38:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $38
801067cf:	6a 26                	push   $0x26
  jmp alltraps
801067d1:	e9 ee f9 ff ff       	jmp    801061c4 <alltraps>

801067d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $39
801067d8:	6a 27                	push   $0x27
  jmp alltraps
801067da:	e9 e5 f9 ff ff       	jmp    801061c4 <alltraps>

801067df <vector40>:
.globl vector40
vector40:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $40
801067e1:	6a 28                	push   $0x28
  jmp alltraps
801067e3:	e9 dc f9 ff ff       	jmp    801061c4 <alltraps>

801067e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $41
801067ea:	6a 29                	push   $0x29
  jmp alltraps
801067ec:	e9 d3 f9 ff ff       	jmp    801061c4 <alltraps>

801067f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $42
801067f3:	6a 2a                	push   $0x2a
  jmp alltraps
801067f5:	e9 ca f9 ff ff       	jmp    801061c4 <alltraps>

801067fa <vector43>:
.globl vector43
vector43:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $43
801067fc:	6a 2b                	push   $0x2b
  jmp alltraps
801067fe:	e9 c1 f9 ff ff       	jmp    801061c4 <alltraps>

80106803 <vector44>:
.globl vector44
vector44:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $44
80106805:	6a 2c                	push   $0x2c
  jmp alltraps
80106807:	e9 b8 f9 ff ff       	jmp    801061c4 <alltraps>

8010680c <vector45>:
.globl vector45
vector45:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $45
8010680e:	6a 2d                	push   $0x2d
  jmp alltraps
80106810:	e9 af f9 ff ff       	jmp    801061c4 <alltraps>

80106815 <vector46>:
.globl vector46
vector46:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $46
80106817:	6a 2e                	push   $0x2e
  jmp alltraps
80106819:	e9 a6 f9 ff ff       	jmp    801061c4 <alltraps>

8010681e <vector47>:
.globl vector47
vector47:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $47
80106820:	6a 2f                	push   $0x2f
  jmp alltraps
80106822:	e9 9d f9 ff ff       	jmp    801061c4 <alltraps>

80106827 <vector48>:
.globl vector48
vector48:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $48
80106829:	6a 30                	push   $0x30
  jmp alltraps
8010682b:	e9 94 f9 ff ff       	jmp    801061c4 <alltraps>

80106830 <vector49>:
.globl vector49
vector49:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $49
80106832:	6a 31                	push   $0x31
  jmp alltraps
80106834:	e9 8b f9 ff ff       	jmp    801061c4 <alltraps>

80106839 <vector50>:
.globl vector50
vector50:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $50
8010683b:	6a 32                	push   $0x32
  jmp alltraps
8010683d:	e9 82 f9 ff ff       	jmp    801061c4 <alltraps>

80106842 <vector51>:
.globl vector51
vector51:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $51
80106844:	6a 33                	push   $0x33
  jmp alltraps
80106846:	e9 79 f9 ff ff       	jmp    801061c4 <alltraps>

8010684b <vector52>:
.globl vector52
vector52:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $52
8010684d:	6a 34                	push   $0x34
  jmp alltraps
8010684f:	e9 70 f9 ff ff       	jmp    801061c4 <alltraps>

80106854 <vector53>:
.globl vector53
vector53:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $53
80106856:	6a 35                	push   $0x35
  jmp alltraps
80106858:	e9 67 f9 ff ff       	jmp    801061c4 <alltraps>

8010685d <vector54>:
.globl vector54
vector54:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $54
8010685f:	6a 36                	push   $0x36
  jmp alltraps
80106861:	e9 5e f9 ff ff       	jmp    801061c4 <alltraps>

80106866 <vector55>:
.globl vector55
vector55:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $55
80106868:	6a 37                	push   $0x37
  jmp alltraps
8010686a:	e9 55 f9 ff ff       	jmp    801061c4 <alltraps>

8010686f <vector56>:
.globl vector56
vector56:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $56
80106871:	6a 38                	push   $0x38
  jmp alltraps
80106873:	e9 4c f9 ff ff       	jmp    801061c4 <alltraps>

80106878 <vector57>:
.globl vector57
vector57:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $57
8010687a:	6a 39                	push   $0x39
  jmp alltraps
8010687c:	e9 43 f9 ff ff       	jmp    801061c4 <alltraps>

80106881 <vector58>:
.globl vector58
vector58:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $58
80106883:	6a 3a                	push   $0x3a
  jmp alltraps
80106885:	e9 3a f9 ff ff       	jmp    801061c4 <alltraps>

8010688a <vector59>:
.globl vector59
vector59:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $59
8010688c:	6a 3b                	push   $0x3b
  jmp alltraps
8010688e:	e9 31 f9 ff ff       	jmp    801061c4 <alltraps>

80106893 <vector60>:
.globl vector60
vector60:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $60
80106895:	6a 3c                	push   $0x3c
  jmp alltraps
80106897:	e9 28 f9 ff ff       	jmp    801061c4 <alltraps>

8010689c <vector61>:
.globl vector61
vector61:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $61
8010689e:	6a 3d                	push   $0x3d
  jmp alltraps
801068a0:	e9 1f f9 ff ff       	jmp    801061c4 <alltraps>

801068a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $62
801068a7:	6a 3e                	push   $0x3e
  jmp alltraps
801068a9:	e9 16 f9 ff ff       	jmp    801061c4 <alltraps>

801068ae <vector63>:
.globl vector63
vector63:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $63
801068b0:	6a 3f                	push   $0x3f
  jmp alltraps
801068b2:	e9 0d f9 ff ff       	jmp    801061c4 <alltraps>

801068b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $64
801068b9:	6a 40                	push   $0x40
  jmp alltraps
801068bb:	e9 04 f9 ff ff       	jmp    801061c4 <alltraps>

801068c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $65
801068c2:	6a 41                	push   $0x41
  jmp alltraps
801068c4:	e9 fb f8 ff ff       	jmp    801061c4 <alltraps>

801068c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $66
801068cb:	6a 42                	push   $0x42
  jmp alltraps
801068cd:	e9 f2 f8 ff ff       	jmp    801061c4 <alltraps>

801068d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $67
801068d4:	6a 43                	push   $0x43
  jmp alltraps
801068d6:	e9 e9 f8 ff ff       	jmp    801061c4 <alltraps>

801068db <vector68>:
.globl vector68
vector68:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $68
801068dd:	6a 44                	push   $0x44
  jmp alltraps
801068df:	e9 e0 f8 ff ff       	jmp    801061c4 <alltraps>

801068e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $69
801068e6:	6a 45                	push   $0x45
  jmp alltraps
801068e8:	e9 d7 f8 ff ff       	jmp    801061c4 <alltraps>

801068ed <vector70>:
.globl vector70
vector70:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $70
801068ef:	6a 46                	push   $0x46
  jmp alltraps
801068f1:	e9 ce f8 ff ff       	jmp    801061c4 <alltraps>

801068f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $71
801068f8:	6a 47                	push   $0x47
  jmp alltraps
801068fa:	e9 c5 f8 ff ff       	jmp    801061c4 <alltraps>

801068ff <vector72>:
.globl vector72
vector72:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $72
80106901:	6a 48                	push   $0x48
  jmp alltraps
80106903:	e9 bc f8 ff ff       	jmp    801061c4 <alltraps>

80106908 <vector73>:
.globl vector73
vector73:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $73
8010690a:	6a 49                	push   $0x49
  jmp alltraps
8010690c:	e9 b3 f8 ff ff       	jmp    801061c4 <alltraps>

80106911 <vector74>:
.globl vector74
vector74:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $74
80106913:	6a 4a                	push   $0x4a
  jmp alltraps
80106915:	e9 aa f8 ff ff       	jmp    801061c4 <alltraps>

8010691a <vector75>:
.globl vector75
vector75:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $75
8010691c:	6a 4b                	push   $0x4b
  jmp alltraps
8010691e:	e9 a1 f8 ff ff       	jmp    801061c4 <alltraps>

80106923 <vector76>:
.globl vector76
vector76:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $76
80106925:	6a 4c                	push   $0x4c
  jmp alltraps
80106927:	e9 98 f8 ff ff       	jmp    801061c4 <alltraps>

8010692c <vector77>:
.globl vector77
vector77:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $77
8010692e:	6a 4d                	push   $0x4d
  jmp alltraps
80106930:	e9 8f f8 ff ff       	jmp    801061c4 <alltraps>

80106935 <vector78>:
.globl vector78
vector78:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $78
80106937:	6a 4e                	push   $0x4e
  jmp alltraps
80106939:	e9 86 f8 ff ff       	jmp    801061c4 <alltraps>

8010693e <vector79>:
.globl vector79
vector79:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $79
80106940:	6a 4f                	push   $0x4f
  jmp alltraps
80106942:	e9 7d f8 ff ff       	jmp    801061c4 <alltraps>

80106947 <vector80>:
.globl vector80
vector80:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $80
80106949:	6a 50                	push   $0x50
  jmp alltraps
8010694b:	e9 74 f8 ff ff       	jmp    801061c4 <alltraps>

80106950 <vector81>:
.globl vector81
vector81:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $81
80106952:	6a 51                	push   $0x51
  jmp alltraps
80106954:	e9 6b f8 ff ff       	jmp    801061c4 <alltraps>

80106959 <vector82>:
.globl vector82
vector82:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $82
8010695b:	6a 52                	push   $0x52
  jmp alltraps
8010695d:	e9 62 f8 ff ff       	jmp    801061c4 <alltraps>

80106962 <vector83>:
.globl vector83
vector83:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $83
80106964:	6a 53                	push   $0x53
  jmp alltraps
80106966:	e9 59 f8 ff ff       	jmp    801061c4 <alltraps>

8010696b <vector84>:
.globl vector84
vector84:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $84
8010696d:	6a 54                	push   $0x54
  jmp alltraps
8010696f:	e9 50 f8 ff ff       	jmp    801061c4 <alltraps>

80106974 <vector85>:
.globl vector85
vector85:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $85
80106976:	6a 55                	push   $0x55
  jmp alltraps
80106978:	e9 47 f8 ff ff       	jmp    801061c4 <alltraps>

8010697d <vector86>:
.globl vector86
vector86:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $86
8010697f:	6a 56                	push   $0x56
  jmp alltraps
80106981:	e9 3e f8 ff ff       	jmp    801061c4 <alltraps>

80106986 <vector87>:
.globl vector87
vector87:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $87
80106988:	6a 57                	push   $0x57
  jmp alltraps
8010698a:	e9 35 f8 ff ff       	jmp    801061c4 <alltraps>

8010698f <vector88>:
.globl vector88
vector88:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $88
80106991:	6a 58                	push   $0x58
  jmp alltraps
80106993:	e9 2c f8 ff ff       	jmp    801061c4 <alltraps>

80106998 <vector89>:
.globl vector89
vector89:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $89
8010699a:	6a 59                	push   $0x59
  jmp alltraps
8010699c:	e9 23 f8 ff ff       	jmp    801061c4 <alltraps>

801069a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $90
801069a3:	6a 5a                	push   $0x5a
  jmp alltraps
801069a5:	e9 1a f8 ff ff       	jmp    801061c4 <alltraps>

801069aa <vector91>:
.globl vector91
vector91:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $91
801069ac:	6a 5b                	push   $0x5b
  jmp alltraps
801069ae:	e9 11 f8 ff ff       	jmp    801061c4 <alltraps>

801069b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $92
801069b5:	6a 5c                	push   $0x5c
  jmp alltraps
801069b7:	e9 08 f8 ff ff       	jmp    801061c4 <alltraps>

801069bc <vector93>:
.globl vector93
vector93:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $93
801069be:	6a 5d                	push   $0x5d
  jmp alltraps
801069c0:	e9 ff f7 ff ff       	jmp    801061c4 <alltraps>

801069c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $94
801069c7:	6a 5e                	push   $0x5e
  jmp alltraps
801069c9:	e9 f6 f7 ff ff       	jmp    801061c4 <alltraps>

801069ce <vector95>:
.globl vector95
vector95:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $95
801069d0:	6a 5f                	push   $0x5f
  jmp alltraps
801069d2:	e9 ed f7 ff ff       	jmp    801061c4 <alltraps>

801069d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $96
801069d9:	6a 60                	push   $0x60
  jmp alltraps
801069db:	e9 e4 f7 ff ff       	jmp    801061c4 <alltraps>

801069e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $97
801069e2:	6a 61                	push   $0x61
  jmp alltraps
801069e4:	e9 db f7 ff ff       	jmp    801061c4 <alltraps>

801069e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $98
801069eb:	6a 62                	push   $0x62
  jmp alltraps
801069ed:	e9 d2 f7 ff ff       	jmp    801061c4 <alltraps>

801069f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $99
801069f4:	6a 63                	push   $0x63
  jmp alltraps
801069f6:	e9 c9 f7 ff ff       	jmp    801061c4 <alltraps>

801069fb <vector100>:
.globl vector100
vector100:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $100
801069fd:	6a 64                	push   $0x64
  jmp alltraps
801069ff:	e9 c0 f7 ff ff       	jmp    801061c4 <alltraps>

80106a04 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $101
80106a06:	6a 65                	push   $0x65
  jmp alltraps
80106a08:	e9 b7 f7 ff ff       	jmp    801061c4 <alltraps>

80106a0d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $102
80106a0f:	6a 66                	push   $0x66
  jmp alltraps
80106a11:	e9 ae f7 ff ff       	jmp    801061c4 <alltraps>

80106a16 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $103
80106a18:	6a 67                	push   $0x67
  jmp alltraps
80106a1a:	e9 a5 f7 ff ff       	jmp    801061c4 <alltraps>

80106a1f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $104
80106a21:	6a 68                	push   $0x68
  jmp alltraps
80106a23:	e9 9c f7 ff ff       	jmp    801061c4 <alltraps>

80106a28 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $105
80106a2a:	6a 69                	push   $0x69
  jmp alltraps
80106a2c:	e9 93 f7 ff ff       	jmp    801061c4 <alltraps>

80106a31 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $106
80106a33:	6a 6a                	push   $0x6a
  jmp alltraps
80106a35:	e9 8a f7 ff ff       	jmp    801061c4 <alltraps>

80106a3a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $107
80106a3c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a3e:	e9 81 f7 ff ff       	jmp    801061c4 <alltraps>

80106a43 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $108
80106a45:	6a 6c                	push   $0x6c
  jmp alltraps
80106a47:	e9 78 f7 ff ff       	jmp    801061c4 <alltraps>

80106a4c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $109
80106a4e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a50:	e9 6f f7 ff ff       	jmp    801061c4 <alltraps>

80106a55 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $110
80106a57:	6a 6e                	push   $0x6e
  jmp alltraps
80106a59:	e9 66 f7 ff ff       	jmp    801061c4 <alltraps>

80106a5e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $111
80106a60:	6a 6f                	push   $0x6f
  jmp alltraps
80106a62:	e9 5d f7 ff ff       	jmp    801061c4 <alltraps>

80106a67 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $112
80106a69:	6a 70                	push   $0x70
  jmp alltraps
80106a6b:	e9 54 f7 ff ff       	jmp    801061c4 <alltraps>

80106a70 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $113
80106a72:	6a 71                	push   $0x71
  jmp alltraps
80106a74:	e9 4b f7 ff ff       	jmp    801061c4 <alltraps>

80106a79 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $114
80106a7b:	6a 72                	push   $0x72
  jmp alltraps
80106a7d:	e9 42 f7 ff ff       	jmp    801061c4 <alltraps>

80106a82 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $115
80106a84:	6a 73                	push   $0x73
  jmp alltraps
80106a86:	e9 39 f7 ff ff       	jmp    801061c4 <alltraps>

80106a8b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $116
80106a8d:	6a 74                	push   $0x74
  jmp alltraps
80106a8f:	e9 30 f7 ff ff       	jmp    801061c4 <alltraps>

80106a94 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $117
80106a96:	6a 75                	push   $0x75
  jmp alltraps
80106a98:	e9 27 f7 ff ff       	jmp    801061c4 <alltraps>

80106a9d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $118
80106a9f:	6a 76                	push   $0x76
  jmp alltraps
80106aa1:	e9 1e f7 ff ff       	jmp    801061c4 <alltraps>

80106aa6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $119
80106aa8:	6a 77                	push   $0x77
  jmp alltraps
80106aaa:	e9 15 f7 ff ff       	jmp    801061c4 <alltraps>

80106aaf <vector120>:
.globl vector120
vector120:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $120
80106ab1:	6a 78                	push   $0x78
  jmp alltraps
80106ab3:	e9 0c f7 ff ff       	jmp    801061c4 <alltraps>

80106ab8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $121
80106aba:	6a 79                	push   $0x79
  jmp alltraps
80106abc:	e9 03 f7 ff ff       	jmp    801061c4 <alltraps>

80106ac1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $122
80106ac3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ac5:	e9 fa f6 ff ff       	jmp    801061c4 <alltraps>

80106aca <vector123>:
.globl vector123
vector123:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $123
80106acc:	6a 7b                	push   $0x7b
  jmp alltraps
80106ace:	e9 f1 f6 ff ff       	jmp    801061c4 <alltraps>

80106ad3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $124
80106ad5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ad7:	e9 e8 f6 ff ff       	jmp    801061c4 <alltraps>

80106adc <vector125>:
.globl vector125
vector125:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $125
80106ade:	6a 7d                	push   $0x7d
  jmp alltraps
80106ae0:	e9 df f6 ff ff       	jmp    801061c4 <alltraps>

80106ae5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $126
80106ae7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ae9:	e9 d6 f6 ff ff       	jmp    801061c4 <alltraps>

80106aee <vector127>:
.globl vector127
vector127:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $127
80106af0:	6a 7f                	push   $0x7f
  jmp alltraps
80106af2:	e9 cd f6 ff ff       	jmp    801061c4 <alltraps>

80106af7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $128
80106af9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106afe:	e9 c1 f6 ff ff       	jmp    801061c4 <alltraps>

80106b03 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $129
80106b05:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b0a:	e9 b5 f6 ff ff       	jmp    801061c4 <alltraps>

80106b0f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $130
80106b11:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b16:	e9 a9 f6 ff ff       	jmp    801061c4 <alltraps>

80106b1b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $131
80106b1d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b22:	e9 9d f6 ff ff       	jmp    801061c4 <alltraps>

80106b27 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $132
80106b29:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b2e:	e9 91 f6 ff ff       	jmp    801061c4 <alltraps>

80106b33 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $133
80106b35:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b3a:	e9 85 f6 ff ff       	jmp    801061c4 <alltraps>

80106b3f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $134
80106b41:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b46:	e9 79 f6 ff ff       	jmp    801061c4 <alltraps>

80106b4b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $135
80106b4d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b52:	e9 6d f6 ff ff       	jmp    801061c4 <alltraps>

80106b57 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $136
80106b59:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b5e:	e9 61 f6 ff ff       	jmp    801061c4 <alltraps>

80106b63 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $137
80106b65:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b6a:	e9 55 f6 ff ff       	jmp    801061c4 <alltraps>

80106b6f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $138
80106b71:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b76:	e9 49 f6 ff ff       	jmp    801061c4 <alltraps>

80106b7b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $139
80106b7d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b82:	e9 3d f6 ff ff       	jmp    801061c4 <alltraps>

80106b87 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $140
80106b89:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b8e:	e9 31 f6 ff ff       	jmp    801061c4 <alltraps>

80106b93 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $141
80106b95:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b9a:	e9 25 f6 ff ff       	jmp    801061c4 <alltraps>

80106b9f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $142
80106ba1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ba6:	e9 19 f6 ff ff       	jmp    801061c4 <alltraps>

80106bab <vector143>:
.globl vector143
vector143:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $143
80106bad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bb2:	e9 0d f6 ff ff       	jmp    801061c4 <alltraps>

80106bb7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $144
80106bb9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bbe:	e9 01 f6 ff ff       	jmp    801061c4 <alltraps>

80106bc3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $145
80106bc5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bca:	e9 f5 f5 ff ff       	jmp    801061c4 <alltraps>

80106bcf <vector146>:
.globl vector146
vector146:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $146
80106bd1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bd6:	e9 e9 f5 ff ff       	jmp    801061c4 <alltraps>

80106bdb <vector147>:
.globl vector147
vector147:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $147
80106bdd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106be2:	e9 dd f5 ff ff       	jmp    801061c4 <alltraps>

80106be7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $148
80106be9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bee:	e9 d1 f5 ff ff       	jmp    801061c4 <alltraps>

80106bf3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $149
80106bf5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bfa:	e9 c5 f5 ff ff       	jmp    801061c4 <alltraps>

80106bff <vector150>:
.globl vector150
vector150:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $150
80106c01:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c06:	e9 b9 f5 ff ff       	jmp    801061c4 <alltraps>

80106c0b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $151
80106c0d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c12:	e9 ad f5 ff ff       	jmp    801061c4 <alltraps>

80106c17 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $152
80106c19:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c1e:	e9 a1 f5 ff ff       	jmp    801061c4 <alltraps>

80106c23 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $153
80106c25:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c2a:	e9 95 f5 ff ff       	jmp    801061c4 <alltraps>

80106c2f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $154
80106c31:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c36:	e9 89 f5 ff ff       	jmp    801061c4 <alltraps>

80106c3b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $155
80106c3d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c42:	e9 7d f5 ff ff       	jmp    801061c4 <alltraps>

80106c47 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $156
80106c49:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c4e:	e9 71 f5 ff ff       	jmp    801061c4 <alltraps>

80106c53 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $157
80106c55:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c5a:	e9 65 f5 ff ff       	jmp    801061c4 <alltraps>

80106c5f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $158
80106c61:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c66:	e9 59 f5 ff ff       	jmp    801061c4 <alltraps>

80106c6b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $159
80106c6d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c72:	e9 4d f5 ff ff       	jmp    801061c4 <alltraps>

80106c77 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $160
80106c79:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c7e:	e9 41 f5 ff ff       	jmp    801061c4 <alltraps>

80106c83 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $161
80106c85:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c8a:	e9 35 f5 ff ff       	jmp    801061c4 <alltraps>

80106c8f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $162
80106c91:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c96:	e9 29 f5 ff ff       	jmp    801061c4 <alltraps>

80106c9b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $163
80106c9d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ca2:	e9 1d f5 ff ff       	jmp    801061c4 <alltraps>

80106ca7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $164
80106ca9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cae:	e9 11 f5 ff ff       	jmp    801061c4 <alltraps>

80106cb3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $165
80106cb5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cba:	e9 05 f5 ff ff       	jmp    801061c4 <alltraps>

80106cbf <vector166>:
.globl vector166
vector166:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $166
80106cc1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cc6:	e9 f9 f4 ff ff       	jmp    801061c4 <alltraps>

80106ccb <vector167>:
.globl vector167
vector167:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $167
80106ccd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cd2:	e9 ed f4 ff ff       	jmp    801061c4 <alltraps>

80106cd7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $168
80106cd9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cde:	e9 e1 f4 ff ff       	jmp    801061c4 <alltraps>

80106ce3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $169
80106ce5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cea:	e9 d5 f4 ff ff       	jmp    801061c4 <alltraps>

80106cef <vector170>:
.globl vector170
vector170:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $170
80106cf1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106cf6:	e9 c9 f4 ff ff       	jmp    801061c4 <alltraps>

80106cfb <vector171>:
.globl vector171
vector171:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $171
80106cfd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d02:	e9 bd f4 ff ff       	jmp    801061c4 <alltraps>

80106d07 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $172
80106d09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d0e:	e9 b1 f4 ff ff       	jmp    801061c4 <alltraps>

80106d13 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $173
80106d15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d1a:	e9 a5 f4 ff ff       	jmp    801061c4 <alltraps>

80106d1f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $174
80106d21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d26:	e9 99 f4 ff ff       	jmp    801061c4 <alltraps>

80106d2b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $175
80106d2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d32:	e9 8d f4 ff ff       	jmp    801061c4 <alltraps>

80106d37 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $176
80106d39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d3e:	e9 81 f4 ff ff       	jmp    801061c4 <alltraps>

80106d43 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $177
80106d45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d4a:	e9 75 f4 ff ff       	jmp    801061c4 <alltraps>

80106d4f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $178
80106d51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d56:	e9 69 f4 ff ff       	jmp    801061c4 <alltraps>

80106d5b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $179
80106d5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d62:	e9 5d f4 ff ff       	jmp    801061c4 <alltraps>

80106d67 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $180
80106d69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d6e:	e9 51 f4 ff ff       	jmp    801061c4 <alltraps>

80106d73 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $181
80106d75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d7a:	e9 45 f4 ff ff       	jmp    801061c4 <alltraps>

80106d7f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $182
80106d81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d86:	e9 39 f4 ff ff       	jmp    801061c4 <alltraps>

80106d8b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $183
80106d8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d92:	e9 2d f4 ff ff       	jmp    801061c4 <alltraps>

80106d97 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $184
80106d99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d9e:	e9 21 f4 ff ff       	jmp    801061c4 <alltraps>

80106da3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $185
80106da5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106daa:	e9 15 f4 ff ff       	jmp    801061c4 <alltraps>

80106daf <vector186>:
.globl vector186
vector186:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $186
80106db1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106db6:	e9 09 f4 ff ff       	jmp    801061c4 <alltraps>

80106dbb <vector187>:
.globl vector187
vector187:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $187
80106dbd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106dc2:	e9 fd f3 ff ff       	jmp    801061c4 <alltraps>

80106dc7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $188
80106dc9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dce:	e9 f1 f3 ff ff       	jmp    801061c4 <alltraps>

80106dd3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $189
80106dd5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dda:	e9 e5 f3 ff ff       	jmp    801061c4 <alltraps>

80106ddf <vector190>:
.globl vector190
vector190:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $190
80106de1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106de6:	e9 d9 f3 ff ff       	jmp    801061c4 <alltraps>

80106deb <vector191>:
.globl vector191
vector191:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $191
80106ded:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106df2:	e9 cd f3 ff ff       	jmp    801061c4 <alltraps>

80106df7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $192
80106df9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dfe:	e9 c1 f3 ff ff       	jmp    801061c4 <alltraps>

80106e03 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $193
80106e05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e0a:	e9 b5 f3 ff ff       	jmp    801061c4 <alltraps>

80106e0f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $194
80106e11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e16:	e9 a9 f3 ff ff       	jmp    801061c4 <alltraps>

80106e1b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $195
80106e1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e22:	e9 9d f3 ff ff       	jmp    801061c4 <alltraps>

80106e27 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $196
80106e29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e2e:	e9 91 f3 ff ff       	jmp    801061c4 <alltraps>

80106e33 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $197
80106e35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e3a:	e9 85 f3 ff ff       	jmp    801061c4 <alltraps>

80106e3f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $198
80106e41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e46:	e9 79 f3 ff ff       	jmp    801061c4 <alltraps>

80106e4b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $199
80106e4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e52:	e9 6d f3 ff ff       	jmp    801061c4 <alltraps>

80106e57 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $200
80106e59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e5e:	e9 61 f3 ff ff       	jmp    801061c4 <alltraps>

80106e63 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $201
80106e65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e6a:	e9 55 f3 ff ff       	jmp    801061c4 <alltraps>

80106e6f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $202
80106e71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e76:	e9 49 f3 ff ff       	jmp    801061c4 <alltraps>

80106e7b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $203
80106e7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e82:	e9 3d f3 ff ff       	jmp    801061c4 <alltraps>

80106e87 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $204
80106e89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e8e:	e9 31 f3 ff ff       	jmp    801061c4 <alltraps>

80106e93 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $205
80106e95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e9a:	e9 25 f3 ff ff       	jmp    801061c4 <alltraps>

80106e9f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $206
80106ea1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ea6:	e9 19 f3 ff ff       	jmp    801061c4 <alltraps>

80106eab <vector207>:
.globl vector207
vector207:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $207
80106ead:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106eb2:	e9 0d f3 ff ff       	jmp    801061c4 <alltraps>

80106eb7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $208
80106eb9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ebe:	e9 01 f3 ff ff       	jmp    801061c4 <alltraps>

80106ec3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $209
80106ec5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eca:	e9 f5 f2 ff ff       	jmp    801061c4 <alltraps>

80106ecf <vector210>:
.globl vector210
vector210:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $210
80106ed1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ed6:	e9 e9 f2 ff ff       	jmp    801061c4 <alltraps>

80106edb <vector211>:
.globl vector211
vector211:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $211
80106edd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ee2:	e9 dd f2 ff ff       	jmp    801061c4 <alltraps>

80106ee7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $212
80106ee9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106eee:	e9 d1 f2 ff ff       	jmp    801061c4 <alltraps>

80106ef3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $213
80106ef5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106efa:	e9 c5 f2 ff ff       	jmp    801061c4 <alltraps>

80106eff <vector214>:
.globl vector214
vector214:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $214
80106f01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f06:	e9 b9 f2 ff ff       	jmp    801061c4 <alltraps>

80106f0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $215
80106f0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f12:	e9 ad f2 ff ff       	jmp    801061c4 <alltraps>

80106f17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $216
80106f19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f1e:	e9 a1 f2 ff ff       	jmp    801061c4 <alltraps>

80106f23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $217
80106f25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f2a:	e9 95 f2 ff ff       	jmp    801061c4 <alltraps>

80106f2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $218
80106f31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f36:	e9 89 f2 ff ff       	jmp    801061c4 <alltraps>

80106f3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $219
80106f3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f42:	e9 7d f2 ff ff       	jmp    801061c4 <alltraps>

80106f47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $220
80106f49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f4e:	e9 71 f2 ff ff       	jmp    801061c4 <alltraps>

80106f53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $221
80106f55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f5a:	e9 65 f2 ff ff       	jmp    801061c4 <alltraps>

80106f5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $222
80106f61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f66:	e9 59 f2 ff ff       	jmp    801061c4 <alltraps>

80106f6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $223
80106f6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f72:	e9 4d f2 ff ff       	jmp    801061c4 <alltraps>

80106f77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $224
80106f79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f7e:	e9 41 f2 ff ff       	jmp    801061c4 <alltraps>

80106f83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $225
80106f85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f8a:	e9 35 f2 ff ff       	jmp    801061c4 <alltraps>

80106f8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $226
80106f91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f96:	e9 29 f2 ff ff       	jmp    801061c4 <alltraps>

80106f9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $227
80106f9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fa2:	e9 1d f2 ff ff       	jmp    801061c4 <alltraps>

80106fa7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $228
80106fa9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fae:	e9 11 f2 ff ff       	jmp    801061c4 <alltraps>

80106fb3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $229
80106fb5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fba:	e9 05 f2 ff ff       	jmp    801061c4 <alltraps>

80106fbf <vector230>:
.globl vector230
vector230:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $230
80106fc1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fc6:	e9 f9 f1 ff ff       	jmp    801061c4 <alltraps>

80106fcb <vector231>:
.globl vector231
vector231:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $231
80106fcd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fd2:	e9 ed f1 ff ff       	jmp    801061c4 <alltraps>

80106fd7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $232
80106fd9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fde:	e9 e1 f1 ff ff       	jmp    801061c4 <alltraps>

80106fe3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $233
80106fe5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fea:	e9 d5 f1 ff ff       	jmp    801061c4 <alltraps>

80106fef <vector234>:
.globl vector234
vector234:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $234
80106ff1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ff6:	e9 c9 f1 ff ff       	jmp    801061c4 <alltraps>

80106ffb <vector235>:
.globl vector235
vector235:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $235
80106ffd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107002:	e9 bd f1 ff ff       	jmp    801061c4 <alltraps>

80107007 <vector236>:
.globl vector236
vector236:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $236
80107009:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010700e:	e9 b1 f1 ff ff       	jmp    801061c4 <alltraps>

80107013 <vector237>:
.globl vector237
vector237:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $237
80107015:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010701a:	e9 a5 f1 ff ff       	jmp    801061c4 <alltraps>

8010701f <vector238>:
.globl vector238
vector238:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $238
80107021:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107026:	e9 99 f1 ff ff       	jmp    801061c4 <alltraps>

8010702b <vector239>:
.globl vector239
vector239:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $239
8010702d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107032:	e9 8d f1 ff ff       	jmp    801061c4 <alltraps>

80107037 <vector240>:
.globl vector240
vector240:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $240
80107039:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010703e:	e9 81 f1 ff ff       	jmp    801061c4 <alltraps>

80107043 <vector241>:
.globl vector241
vector241:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $241
80107045:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010704a:	e9 75 f1 ff ff       	jmp    801061c4 <alltraps>

8010704f <vector242>:
.globl vector242
vector242:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $242
80107051:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107056:	e9 69 f1 ff ff       	jmp    801061c4 <alltraps>

8010705b <vector243>:
.globl vector243
vector243:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $243
8010705d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107062:	e9 5d f1 ff ff       	jmp    801061c4 <alltraps>

80107067 <vector244>:
.globl vector244
vector244:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $244
80107069:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010706e:	e9 51 f1 ff ff       	jmp    801061c4 <alltraps>

80107073 <vector245>:
.globl vector245
vector245:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $245
80107075:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010707a:	e9 45 f1 ff ff       	jmp    801061c4 <alltraps>

8010707f <vector246>:
.globl vector246
vector246:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $246
80107081:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107086:	e9 39 f1 ff ff       	jmp    801061c4 <alltraps>

8010708b <vector247>:
.globl vector247
vector247:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $247
8010708d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107092:	e9 2d f1 ff ff       	jmp    801061c4 <alltraps>

80107097 <vector248>:
.globl vector248
vector248:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $248
80107099:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010709e:	e9 21 f1 ff ff       	jmp    801061c4 <alltraps>

801070a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $249
801070a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070aa:	e9 15 f1 ff ff       	jmp    801061c4 <alltraps>

801070af <vector250>:
.globl vector250
vector250:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $250
801070b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070b6:	e9 09 f1 ff ff       	jmp    801061c4 <alltraps>

801070bb <vector251>:
.globl vector251
vector251:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $251
801070bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070c2:	e9 fd f0 ff ff       	jmp    801061c4 <alltraps>

801070c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $252
801070c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070ce:	e9 f1 f0 ff ff       	jmp    801061c4 <alltraps>

801070d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $253
801070d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070da:	e9 e5 f0 ff ff       	jmp    801061c4 <alltraps>

801070df <vector254>:
.globl vector254
vector254:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $254
801070e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070e6:	e9 d9 f0 ff ff       	jmp    801061c4 <alltraps>

801070eb <vector255>:
.globl vector255
vector255:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $255
801070ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070f2:	e9 cd f0 ff ff       	jmp    801061c4 <alltraps>
801070f7:	66 90                	xchg   %ax,%ax
801070f9:	66 90                	xchg   %ax,%ax
801070fb:	66 90                	xchg   %ax,%ax
801070fd:	66 90                	xchg   %ax,%ax
801070ff:	90                   	nop

80107100 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107106:	e8 95 ca ff ff       	call   80103ba0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010710b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107111:	31 c9                	xor    %ecx,%ecx
80107113:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107118:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
8010711f:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107126:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010712b:	31 c9                	xor    %ecx,%ecx
8010712d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107134:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107139:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107140:	31 c9                	xor    %ecx,%ecx
80107142:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80107149:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107150:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107155:	31 c9                	xor    %ecx,%ecx
80107157:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010715e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107165:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010716a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80107171:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80107178:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010717f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80107186:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
8010718d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80107194:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010719b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
801071a2:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
801071a9:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
801071b0:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071b7:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
801071be:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
801071c5:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
801071cc:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
801071d3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801071da:	05 f0 37 11 80       	add    $0x801137f0,%eax
801071df:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801071e3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071e7:	c1 e8 10             	shr    $0x10,%eax
801071ea:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801071ee:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071f1:	0f 01 10             	lgdtl  (%eax)
}
801071f4:	c9                   	leave  
801071f5:	c3                   	ret    
801071f6:	8d 76 00             	lea    0x0(%esi),%esi
801071f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107200 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010720c:	8b 55 08             	mov    0x8(%ebp),%edx
8010720f:	89 df                	mov    %ebx,%edi
80107211:	c1 ef 16             	shr    $0x16,%edi
80107214:	8d 3c ba             	lea    (%edx,%edi,4),%edi
  if(*pde & PTE_P){
80107217:	8b 07                	mov    (%edi),%eax
80107219:	a8 01                	test   $0x1,%al
8010721b:	74 23                	je     80107240 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010721d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107222:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107228:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010722b:	c1 eb 0a             	shr    $0xa,%ebx
8010722e:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80107234:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107237:	5b                   	pop    %ebx
80107238:	5e                   	pop    %esi
80107239:	5f                   	pop    %edi
8010723a:	5d                   	pop    %ebp
8010723b:	c3                   	ret    
8010723c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107240:	8b 45 10             	mov    0x10(%ebp),%eax
80107243:	85 c0                	test   %eax,%eax
80107245:	74 31                	je     80107278 <walkpgdir+0x78>
80107247:	e8 34 b6 ff ff       	call   80102880 <kalloc>
8010724c:	85 c0                	test   %eax,%eax
8010724e:	89 c6                	mov    %eax,%esi
80107250:	74 26                	je     80107278 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107252:	83 ec 04             	sub    $0x4,%esp
80107255:	68 00 10 00 00       	push   $0x1000
8010725a:	6a 00                	push   $0x0
8010725c:	50                   	push   %eax
8010725d:	e8 ce da ff ff       	call   80104d30 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107262:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107268:	83 c4 10             	add    $0x10,%esp
8010726b:	83 c8 07             	or     $0x7,%eax
8010726e:	89 07                	mov    %eax,(%edi)
80107270:	eb b6                	jmp    80107228 <walkpgdir+0x28>
80107272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  return &pgtab[PTX(va)];
}
80107278:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010727b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010727d:	5b                   	pop    %ebx
8010727e:	5e                   	pop    %esi
8010727f:	5f                   	pop    %edi
80107280:	5d                   	pop    %ebp
80107281:	c3                   	ret    
80107282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107296:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010729a:	56                   	push   %esi
8010729b:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010729c:	89 d6                	mov    %edx,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010729e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072a3:	83 ec 1c             	sub    $0x1c,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801072a6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072af:	8b 45 08             	mov    0x8(%ebp),%eax
801072b2:	29 f0                	sub    %esi,%eax
801072b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801072b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ba:	83 c8 01             	or     $0x1,%eax
801072bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801072c0:	eb 1b                	jmp    801072dd <mappages+0x4d>
801072c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072c8:	f6 00 01             	testb  $0x1,(%eax)
801072cb:	75 45                	jne    80107312 <mappages+0x82>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072cd:	0b 5d dc             	or     -0x24(%ebp),%ebx
    if(a == last)
801072d0:	3b 75 e0             	cmp    -0x20(%ebp),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801072d3:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072d5:	74 31                	je     80107308 <mappages+0x78>
      break;
    a += PGSIZE;
801072d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801072dd:	83 ec 04             	sub    $0x4,%esp
801072e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e3:	6a 01                	push   $0x1
801072e5:	56                   	push   %esi
801072e6:	57                   	push   %edi
801072e7:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801072ea:	e8 11 ff ff ff       	call   80107200 <walkpgdir>
801072ef:	83 c4 10             	add    $0x10,%esp
801072f2:	85 c0                	test   %eax,%eax
801072f4:	75 d2                	jne    801072c8 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801072f6:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801072f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801072fe:	5b                   	pop    %ebx
801072ff:	5e                   	pop    %esi
80107300:	5f                   	pop    %edi
80107301:	5d                   	pop    %ebp
80107302:	c3                   	ret    
80107303:	90                   	nop
80107304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107308:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010730b:	31 c0                	xor    %eax,%eax
}
8010730d:	5b                   	pop    %ebx
8010730e:	5e                   	pop    %esi
8010730f:	5f                   	pop    %edi
80107310:	5d                   	pop    %ebp
80107311:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80107312:	83 ec 0c             	sub    $0xc,%esp
80107315:	68 e8 83 10 80       	push   $0x801083e8
8010731a:	e8 51 90 ff ff       	call   80100370 <panic>
8010731f:	90                   	nop

80107320 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107328:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010732e:	89 c6                	mov    %eax,%esi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107330:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010733c:	39 da                	cmp    %ebx,%edx
8010733e:	73 6a                	jae    801073aa <deallocuvm.part.0+0x8a>
80107340:	89 d7                	mov    %edx,%edi
80107342:	eb 3b                	jmp    8010737f <deallocuvm.part.0+0x5f>
80107344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107348:	8b 08                	mov    (%eax),%ecx
8010734a:	f6 c1 01             	test   $0x1,%cl
8010734d:	74 26                	je     80107375 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010734f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107355:	74 5e                	je     801073b5 <deallocuvm.part.0+0x95>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107357:	83 ec 0c             	sub    $0xc,%esp
8010735a:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107363:	51                   	push   %ecx
80107364:	e8 67 b3 ff ff       	call   801026d0 <kfree>
      *pte = 0;
80107369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010736c:	83 c4 10             	add    $0x10,%esp
8010736f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107375:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010737b:	39 df                	cmp    %ebx,%edi
8010737d:	73 2b                	jae    801073aa <deallocuvm.part.0+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010737f:	83 ec 04             	sub    $0x4,%esp
80107382:	6a 00                	push   $0x0
80107384:	57                   	push   %edi
80107385:	56                   	push   %esi
80107386:	e8 75 fe ff ff       	call   80107200 <walkpgdir>
    if(!pte)
8010738b:	83 c4 10             	add    $0x10,%esp
8010738e:	85 c0                	test   %eax,%eax
80107390:	75 b6                	jne    80107348 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107392:	89 fa                	mov    %edi,%edx
80107394:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
8010739a:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801073a0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073a6:	39 df                	cmp    %ebx,%edi
801073a8:	72 d5                	jb     8010737f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801073aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073b0:	5b                   	pop    %ebx
801073b1:	5e                   	pop    %esi
801073b2:	5f                   	pop    %edi
801073b3:	5d                   	pop    %ebp
801073b4:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801073b5:	83 ec 0c             	sub    $0xc,%esp
801073b8:	68 06 7d 10 80       	push   $0x80107d06
801073bd:	e8 ae 8f ff ff       	call   80100370 <panic>
801073c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073d0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073d0:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801073d5:	55                   	push   %ebp
801073d6:	89 e5                	mov    %esp,%ebp
801073d8:	05 00 00 00 80       	add    $0x80000000,%eax
801073dd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801073e0:	5d                   	pop    %ebp
801073e1:	c3                   	ret    
801073e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
801073f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801073fc:	85 f6                	test   %esi,%esi
801073fe:	0f 84 cd 00 00 00    	je     801074d1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107404:	8b 46 08             	mov    0x8(%esi),%eax
80107407:	85 c0                	test   %eax,%eax
80107409:	0f 84 dc 00 00 00    	je     801074eb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010740f:	8b 7e 04             	mov    0x4(%esi),%edi
80107412:	85 ff                	test   %edi,%edi
80107414:	0f 84 c4 00 00 00    	je     801074de <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010741a:	e8 31 d7 ff ff       	call   80104b50 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010741f:	e8 fc c6 ff ff       	call   80103b20 <mycpu>
80107424:	89 c3                	mov    %eax,%ebx
80107426:	e8 f5 c6 ff ff       	call   80103b20 <mycpu>
8010742b:	89 c7                	mov    %eax,%edi
8010742d:	e8 ee c6 ff ff       	call   80103b20 <mycpu>
80107432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107435:	83 c7 08             	add    $0x8,%edi
80107438:	e8 e3 c6 ff ff       	call   80103b20 <mycpu>
8010743d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107440:	83 c0 08             	add    $0x8,%eax
80107443:	ba 67 00 00 00       	mov    $0x67,%edx
80107448:	c1 e8 18             	shr    $0x18,%eax
8010744b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107452:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107459:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107460:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107467:	83 c1 08             	add    $0x8,%ecx
8010746a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107470:	c1 e9 10             	shr    $0x10,%ecx
80107473:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107479:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010747e:	e8 9d c6 ff ff       	call   80103b20 <mycpu>
80107483:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010748a:	e8 91 c6 ff ff       	call   80103b20 <mycpu>
8010748f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107494:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107498:	e8 83 c6 ff ff       	call   80103b20 <mycpu>
8010749d:	8b 56 08             	mov    0x8(%esi),%edx
801074a0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801074a6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074a9:	e8 72 c6 ff ff       	call   80103b20 <mycpu>
801074ae:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801074b2:	b8 28 00 00 00       	mov    $0x28,%eax
801074b7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074ba:	8b 46 04             	mov    0x4(%esi),%eax
801074bd:	05 00 00 00 80       	add    $0x80000000,%eax
801074c2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801074c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074c8:	5b                   	pop    %ebx
801074c9:	5e                   	pop    %esi
801074ca:	5f                   	pop    %edi
801074cb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801074cc:	e9 bf d6 ff ff       	jmp    80104b90 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801074d1:	83 ec 0c             	sub    $0xc,%esp
801074d4:	68 ee 83 10 80       	push   $0x801083ee
801074d9:	e8 92 8e ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801074de:	83 ec 0c             	sub    $0xc,%esp
801074e1:	68 19 84 10 80       	push   $0x80108419
801074e6:	e8 85 8e ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801074eb:	83 ec 0c             	sub    $0xc,%esp
801074ee:	68 04 84 10 80       	push   $0x80108404
801074f3:	e8 78 8e ff ff       	call   80100370 <panic>
801074f8:	90                   	nop
801074f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107500 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	57                   	push   %edi
80107504:	56                   	push   %esi
80107505:	53                   	push   %ebx
80107506:	83 ec 1c             	sub    $0x1c,%esp
80107509:	8b 75 10             	mov    0x10(%ebp),%esi
8010750c:	8b 45 08             	mov    0x8(%ebp),%eax
8010750f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107512:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010751b:	77 49                	ja     80107566 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010751d:	e8 5e b3 ff ff       	call   80102880 <kalloc>
  memset(mem, 0, PGSIZE);
80107522:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107525:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107527:	68 00 10 00 00       	push   $0x1000
8010752c:	6a 00                	push   $0x0
8010752e:	50                   	push   %eax
8010752f:	e8 fc d7 ff ff       	call   80104d30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107534:	58                   	pop    %eax
80107535:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010753b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107540:	5a                   	pop    %edx
80107541:	6a 06                	push   $0x6
80107543:	50                   	push   %eax
80107544:	31 d2                	xor    %edx,%edx
80107546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107549:	e8 42 fd ff ff       	call   80107290 <mappages>
  memmove(mem, init, sz);
8010754e:	89 75 10             	mov    %esi,0x10(%ebp)
80107551:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107554:	83 c4 10             	add    $0x10,%esp
80107557:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010755a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010755d:	5b                   	pop    %ebx
8010755e:	5e                   	pop    %esi
8010755f:	5f                   	pop    %edi
80107560:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107561:	e9 7a d8 ff ff       	jmp    80104de0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107566:	83 ec 0c             	sub    $0xc,%esp
80107569:	68 2d 84 10 80       	push   $0x8010842d
8010756e:	e8 fd 8d ff ff       	call   80100370 <panic>
80107573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107580 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107589:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107590:	0f 85 99 00 00 00    	jne    8010762f <loaduvm+0xaf>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107596:	8b 5d 18             	mov    0x18(%ebp),%ebx
80107599:	31 ff                	xor    %edi,%edi
8010759b:	85 db                	test   %ebx,%ebx
8010759d:	75 1a                	jne    801075b9 <loaduvm+0x39>
8010759f:	eb 77                	jmp    80107618 <loaduvm+0x98>
801075a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a8:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075ae:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801075b4:	39 7d 18             	cmp    %edi,0x18(%ebp)
801075b7:	76 5f                	jbe    80107618 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801075b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801075bc:	83 ec 04             	sub    $0x4,%esp
801075bf:	6a 00                	push   $0x0
801075c1:	01 f8                	add    %edi,%eax
801075c3:	50                   	push   %eax
801075c4:	ff 75 08             	pushl  0x8(%ebp)
801075c7:	e8 34 fc ff ff       	call   80107200 <walkpgdir>
801075cc:	83 c4 10             	add    $0x10,%esp
801075cf:	85 c0                	test   %eax,%eax
801075d1:	74 4f                	je     80107622 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801075d3:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801075d8:	be 00 10 00 00       	mov    $0x1000,%esi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801075dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075e2:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801075e8:	0f 46 f3             	cmovbe %ebx,%esi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075eb:	01 f9                	add    %edi,%ecx
801075ed:	05 00 00 00 80       	add    $0x80000000,%eax
801075f2:	56                   	push   %esi
801075f3:	51                   	push   %ecx
801075f4:	50                   	push   %eax
801075f5:	ff 75 10             	pushl  0x10(%ebp)
801075f8:	e8 43 a7 ff ff       	call   80101d40 <readi>
801075fd:	83 c4 10             	add    $0x10,%esp
80107600:	39 c6                	cmp    %eax,%esi
80107602:	74 a4                	je     801075a8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107604:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010760c:	5b                   	pop    %ebx
8010760d:	5e                   	pop    %esi
8010760e:	5f                   	pop    %edi
8010760f:	5d                   	pop    %ebp
80107610:	c3                   	ret    
80107611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107618:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010761b:	31 c0                	xor    %eax,%eax
}
8010761d:	5b                   	pop    %ebx
8010761e:	5e                   	pop    %esi
8010761f:	5f                   	pop    %edi
80107620:	5d                   	pop    %ebp
80107621:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107622:	83 ec 0c             	sub    $0xc,%esp
80107625:	68 47 84 10 80       	push   $0x80108447
8010762a:	e8 41 8d ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010762f:	83 ec 0c             	sub    $0xc,%esp
80107632:	68 e8 84 10 80       	push   $0x801084e8
80107637:	e8 34 8d ff ff       	call   80100370 <panic>
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107640 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 0c             	sub    $0xc,%esp
80107649:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010764c:	85 ff                	test   %edi,%edi
8010764e:	0f 88 ca 00 00 00    	js     8010771e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107654:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107657:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010765a:	0f 82 82 00 00 00    	jb     801076e2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107660:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107666:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010766c:	39 df                	cmp    %ebx,%edi
8010766e:	77 43                	ja     801076b3 <allocuvm+0x73>
80107670:	e9 bb 00 00 00       	jmp    80107730 <allocuvm+0xf0>
80107675:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107678:	83 ec 04             	sub    $0x4,%esp
8010767b:	68 00 10 00 00       	push   $0x1000
80107680:	6a 00                	push   $0x0
80107682:	50                   	push   %eax
80107683:	e8 a8 d6 ff ff       	call   80104d30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107688:	58                   	pop    %eax
80107689:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010768f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107694:	5a                   	pop    %edx
80107695:	6a 06                	push   $0x6
80107697:	50                   	push   %eax
80107698:	89 da                	mov    %ebx,%edx
8010769a:	8b 45 08             	mov    0x8(%ebp),%eax
8010769d:	e8 ee fb ff ff       	call   80107290 <mappages>
801076a2:	83 c4 10             	add    $0x10,%esp
801076a5:	85 c0                	test   %eax,%eax
801076a7:	78 47                	js     801076f0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801076a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076af:	39 df                	cmp    %ebx,%edi
801076b1:	76 7d                	jbe    80107730 <allocuvm+0xf0>
    mem = kalloc();
801076b3:	e8 c8 b1 ff ff       	call   80102880 <kalloc>
    if(mem == 0){
801076b8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801076ba:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801076bc:	75 ba                	jne    80107678 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801076be:	83 ec 0c             	sub    $0xc,%esp
801076c1:	68 65 84 10 80       	push   $0x80108465
801076c6:	e8 95 8f ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801076cb:	83 c4 10             	add    $0x10,%esp
801076ce:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801076d1:	76 4b                	jbe    8010771e <allocuvm+0xde>
801076d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076d6:	8b 45 08             	mov    0x8(%ebp),%eax
801076d9:	89 fa                	mov    %edi,%edx
801076db:	e8 40 fc ff ff       	call   80107320 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801076e0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801076e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e5:	5b                   	pop    %ebx
801076e6:	5e                   	pop    %esi
801076e7:	5f                   	pop    %edi
801076e8:	5d                   	pop    %ebp
801076e9:	c3                   	ret    
801076ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801076f0:	83 ec 0c             	sub    $0xc,%esp
801076f3:	68 7d 84 10 80       	push   $0x8010847d
801076f8:	e8 63 8f ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801076fd:	83 c4 10             	add    $0x10,%esp
80107700:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107703:	76 0d                	jbe    80107712 <allocuvm+0xd2>
80107705:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107708:	8b 45 08             	mov    0x8(%ebp),%eax
8010770b:	89 fa                	mov    %edi,%edx
8010770d:	e8 0e fc ff ff       	call   80107320 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107712:	83 ec 0c             	sub    $0xc,%esp
80107715:	56                   	push   %esi
80107716:	e8 b5 af ff ff       	call   801026d0 <kfree>
      return 0;
8010771b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010771e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107721:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107723:	5b                   	pop    %ebx
80107724:	5e                   	pop    %esi
80107725:	5f                   	pop    %edi
80107726:	5d                   	pop    %ebp
80107727:	c3                   	ret    
80107728:	90                   	nop
80107729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107730:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107733:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107735:	5b                   	pop    %ebx
80107736:	5e                   	pop    %esi
80107737:	5f                   	pop    %edi
80107738:	5d                   	pop    %ebp
80107739:	c3                   	ret    
8010773a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107740 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	8b 55 0c             	mov    0xc(%ebp),%edx
80107746:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107749:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010774c:	39 d1                	cmp    %edx,%ecx
8010774e:	73 10                	jae    80107760 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107750:	5d                   	pop    %ebp
80107751:	e9 ca fb ff ff       	jmp    80107320 <deallocuvm.part.0>
80107756:	8d 76 00             	lea    0x0(%esi),%esi
80107759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107760:	89 d0                	mov    %edx,%eax
80107762:	5d                   	pop    %ebp
80107763:	c3                   	ret    
80107764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010776a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107770 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	57                   	push   %edi
80107774:	56                   	push   %esi
80107775:	53                   	push   %ebx
80107776:	83 ec 0c             	sub    $0xc,%esp
80107779:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010777c:	85 f6                	test   %esi,%esi
8010777e:	74 59                	je     801077d9 <freevm+0x69>
80107780:	31 c9                	xor    %ecx,%ecx
80107782:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107787:	89 f0                	mov    %esi,%eax
80107789:	e8 92 fb ff ff       	call   80107320 <deallocuvm.part.0>
8010778e:	89 f3                	mov    %esi,%ebx
80107790:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107796:	eb 0f                	jmp    801077a7 <freevm+0x37>
80107798:	90                   	nop
80107799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077a0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077a3:	39 fb                	cmp    %edi,%ebx
801077a5:	74 23                	je     801077ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077a7:	8b 03                	mov    (%ebx),%eax
801077a9:	a8 01                	test   $0x1,%al
801077ab:	74 f3                	je     801077a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801077ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077b2:	83 ec 0c             	sub    $0xc,%esp
801077b5:	83 c3 04             	add    $0x4,%ebx
801077b8:	05 00 00 00 80       	add    $0x80000000,%eax
801077bd:	50                   	push   %eax
801077be:	e8 0d af ff ff       	call   801026d0 <kfree>
801077c3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077c6:	39 fb                	cmp    %edi,%ebx
801077c8:	75 dd                	jne    801077a7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801077ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d0:	5b                   	pop    %ebx
801077d1:	5e                   	pop    %esi
801077d2:	5f                   	pop    %edi
801077d3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801077d4:	e9 f7 ae ff ff       	jmp    801026d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801077d9:	83 ec 0c             	sub    $0xc,%esp
801077dc:	68 99 84 10 80       	push   $0x80108499
801077e1:	e8 8a 8b ff ff       	call   80100370 <panic>
801077e6:	8d 76 00             	lea    0x0(%esi),%esi
801077e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077f0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	56                   	push   %esi
801077f4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801077f5:	e8 86 b0 ff ff       	call   80102880 <kalloc>
801077fa:	85 c0                	test   %eax,%eax
801077fc:	74 6a                	je     80107868 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801077fe:	83 ec 04             	sub    $0x4,%esp
80107801:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107803:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107808:	68 00 10 00 00       	push   $0x1000
8010780d:	6a 00                	push   $0x0
8010780f:	50                   	push   %eax
80107810:	e8 1b d5 ff ff       	call   80104d30 <memset>
80107815:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107818:	8b 43 04             	mov    0x4(%ebx),%eax
8010781b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010781e:	83 ec 08             	sub    $0x8,%esp
80107821:	8b 13                	mov    (%ebx),%edx
80107823:	ff 73 0c             	pushl  0xc(%ebx)
80107826:	50                   	push   %eax
80107827:	29 c1                	sub    %eax,%ecx
80107829:	89 f0                	mov    %esi,%eax
8010782b:	e8 60 fa ff ff       	call   80107290 <mappages>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	78 19                	js     80107850 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107837:	83 c3 10             	add    $0x10,%ebx
8010783a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107840:	75 d6                	jne    80107818 <setupkvm+0x28>
80107842:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107844:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107847:	5b                   	pop    %ebx
80107848:	5e                   	pop    %esi
80107849:	5d                   	pop    %ebp
8010784a:	c3                   	ret    
8010784b:	90                   	nop
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107850:	83 ec 0c             	sub    $0xc,%esp
80107853:	56                   	push   %esi
80107854:	e8 17 ff ff ff       	call   80107770 <freevm>
      return 0;
80107859:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010785c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010785f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107861:	5b                   	pop    %ebx
80107862:	5e                   	pop    %esi
80107863:	5d                   	pop    %ebp
80107864:	c3                   	ret    
80107865:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107868:	31 c0                	xor    %eax,%eax
8010786a:	eb d8                	jmp    80107844 <setupkvm+0x54>
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107870 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107876:	e8 75 ff ff ff       	call   801077f0 <setupkvm>
8010787b:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
80107880:	05 00 00 00 80       	add    $0x80000000,%eax
80107885:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107888:	c9                   	leave  
80107889:	c3                   	ret    
8010788a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107890 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107896:	6a 00                	push   $0x0
80107898:	ff 75 0c             	pushl  0xc(%ebp)
8010789b:	ff 75 08             	pushl  0x8(%ebp)
8010789e:	e8 5d f9 ff ff       	call   80107200 <walkpgdir>
  if(pte == 0)
801078a3:	83 c4 10             	add    $0x10,%esp
801078a6:	85 c0                	test   %eax,%eax
801078a8:	74 05                	je     801078af <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801078aa:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078ad:	c9                   	leave  
801078ae:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801078af:	83 ec 0c             	sub    $0xc,%esp
801078b2:	68 aa 84 10 80       	push   $0x801084aa
801078b7:	e8 b4 8a ff ff       	call   80100370 <panic>
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	57                   	push   %edi
801078c4:	56                   	push   %esi
801078c5:	53                   	push   %ebx
801078c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801078c9:	e8 22 ff ff ff       	call   801077f0 <setupkvm>
801078ce:	85 c0                	test   %eax,%eax
801078d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078d3:	0f 84 c5 00 00 00    	je     8010799e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801078d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801078dc:	85 c9                	test   %ecx,%ecx
801078de:	0f 84 9c 00 00 00    	je     80107980 <copyuvm+0xc0>
801078e4:	31 ff                	xor    %edi,%edi
801078e6:	eb 4a                	jmp    80107932 <copyuvm+0x72>
801078e8:	90                   	nop
801078e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078f0:	83 ec 04             	sub    $0x4,%esp
801078f3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801078f9:	68 00 10 00 00       	push   $0x1000
801078fe:	53                   	push   %ebx
801078ff:	50                   	push   %eax
80107900:	e8 db d4 ff ff       	call   80104de0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107905:	58                   	pop    %eax
80107906:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010790c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107911:	5a                   	pop    %edx
80107912:	ff 75 e4             	pushl  -0x1c(%ebp)
80107915:	50                   	push   %eax
80107916:	89 fa                	mov    %edi,%edx
80107918:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010791b:	e8 70 f9 ff ff       	call   80107290 <mappages>
80107920:	83 c4 10             	add    $0x10,%esp
80107923:	85 c0                	test   %eax,%eax
80107925:	78 69                	js     80107990 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107927:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010792d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107930:	76 4e                	jbe    80107980 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107932:	83 ec 04             	sub    $0x4,%esp
80107935:	6a 00                	push   $0x0
80107937:	57                   	push   %edi
80107938:	ff 75 08             	pushl  0x8(%ebp)
8010793b:	e8 c0 f8 ff ff       	call   80107200 <walkpgdir>
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	85 c0                	test   %eax,%eax
80107945:	74 68                	je     801079af <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107947:	8b 00                	mov    (%eax),%eax
80107949:	a8 01                	test   $0x1,%al
8010794b:	74 55                	je     801079a2 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010794d:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010794f:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107954:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
8010795a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010795d:	e8 1e af ff ff       	call   80102880 <kalloc>
80107962:	85 c0                	test   %eax,%eax
80107964:	89 c6                	mov    %eax,%esi
80107966:	75 88                	jne    801078f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	ff 75 e0             	pushl  -0x20(%ebp)
8010796e:	e8 fd fd ff ff       	call   80107770 <freevm>
  return 0;
80107973:	83 c4 10             	add    $0x10,%esp
80107976:	31 c0                	xor    %eax,%eax
}
80107978:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010797b:	5b                   	pop    %ebx
8010797c:	5e                   	pop    %esi
8010797d:	5f                   	pop    %edi
8010797e:	5d                   	pop    %ebp
8010797f:	c3                   	ret    
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107983:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107986:	5b                   	pop    %ebx
80107987:	5e                   	pop    %esi
80107988:	5f                   	pop    %edi
80107989:	5d                   	pop    %ebp
8010798a:	c3                   	ret    
8010798b:	90                   	nop
8010798c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80107990:	83 ec 0c             	sub    $0xc,%esp
80107993:	56                   	push   %esi
80107994:	e8 37 ad ff ff       	call   801026d0 <kfree>
      goto bad;
80107999:	83 c4 10             	add    $0x10,%esp
8010799c:	eb ca                	jmp    80107968 <copyuvm+0xa8>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010799e:	31 c0                	xor    %eax,%eax
801079a0:	eb d6                	jmp    80107978 <copyuvm+0xb8>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801079a2:	83 ec 0c             	sub    $0xc,%esp
801079a5:	68 ce 84 10 80       	push   $0x801084ce
801079aa:	e8 c1 89 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801079af:	83 ec 0c             	sub    $0xc,%esp
801079b2:	68 b4 84 10 80       	push   $0x801084b4
801079b7:	e8 b4 89 ff ff       	call   80100370 <panic>
801079bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801079c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079c6:	6a 00                	push   $0x0
801079c8:	ff 75 0c             	pushl  0xc(%ebp)
801079cb:	ff 75 08             	pushl  0x8(%ebp)
801079ce:	e8 2d f8 ff ff       	call   80107200 <walkpgdir>
  if((*pte & PTE_P) == 0)
801079d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801079d5:	83 c4 10             	add    $0x10,%esp
801079d8:	89 c2                	mov    %eax,%edx
801079da:	83 e2 05             	and    $0x5,%edx
801079dd:	83 fa 05             	cmp    $0x5,%edx
801079e0:	75 0e                	jne    801079f0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801079e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801079e7:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801079e8:	05 00 00 00 80       	add    $0x80000000,%eax
}
801079ed:	c3                   	ret    
801079ee:	66 90                	xchg   %ax,%ax

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801079f0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801079f2:	c9                   	leave  
801079f3:	c3                   	ret    
801079f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 1c             	sub    $0x1c,%esp
80107a09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a12:	85 db                	test   %ebx,%ebx
80107a14:	75 40                	jne    80107a56 <copyout+0x56>
80107a16:	eb 70                	jmp    80107a88 <copyout+0x88>
80107a18:	90                   	nop
80107a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107a20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a23:	89 f1                	mov    %esi,%ecx
80107a25:	29 d1                	sub    %edx,%ecx
80107a27:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107a2d:	39 d9                	cmp    %ebx,%ecx
80107a2f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a32:	29 f2                	sub    %esi,%edx
80107a34:	83 ec 04             	sub    $0x4,%esp
80107a37:	01 d0                	add    %edx,%eax
80107a39:	51                   	push   %ecx
80107a3a:	57                   	push   %edi
80107a3b:	50                   	push   %eax
80107a3c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107a3f:	e8 9c d3 ff ff       	call   80104de0 <memmove>
    len -= n;
    buf += n;
80107a44:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a47:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107a4a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107a50:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a52:	29 cb                	sub    %ecx,%ebx
80107a54:	74 32                	je     80107a88 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107a56:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a58:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107a5b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107a5e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a64:	56                   	push   %esi
80107a65:	ff 75 08             	pushl  0x8(%ebp)
80107a68:	e8 53 ff ff ff       	call   801079c0 <uva2ka>
    if(pa0 == 0)
80107a6d:	83 c4 10             	add    $0x10,%esp
80107a70:	85 c0                	test   %eax,%eax
80107a72:	75 ac                	jne    80107a20 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107a7c:	5b                   	pop    %ebx
80107a7d:	5e                   	pop    %esi
80107a7e:	5f                   	pop    %edi
80107a7f:	5d                   	pop    %ebp
80107a80:	c3                   	ret    
80107a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107a8b:	31 c0                	xor    %eax,%eax
}
80107a8d:	5b                   	pop    %ebx
80107a8e:	5e                   	pop    %esi
80107a8f:	5f                   	pop    %edi
80107a90:	5d                   	pop    %ebp
80107a91:	c3                   	ret    
