#define get_seg_byte(seg,addr) \
({ \
register char __res; \          // 定义了一个寄存器变量__res。
__asm__("push %%fs; \           // 首先保存 fs 寄存器原值（段选择符）。
mov %%ax,%%fs; \                // 然后用 seg 设置 fs。
movb %%fs:%2,%%al; \            // 取 seg:addr 处 1 字节内容到 al 寄存器中。
pop %%fs" \                     // 恢复 fs 寄存器原内容。
:"=a" (__res) \                 // 输出寄存器列表。
:"0" (seg),"m" (*(addr))); \    // 输入寄存器列表。
__res;})
