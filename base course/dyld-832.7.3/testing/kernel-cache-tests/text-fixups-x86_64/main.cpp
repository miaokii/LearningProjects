
int g = 0;

static int func() {
	return g;
}

struct S {
	__typeof(&func) funcPtr;
	__typeof(&func) funcPtr2;
	int *p1;
	__attribute__((aligned((16384)))) __typeof(&func) funcPtr3;
	int *p2;
};

S s = { &func, &func, &g, &func, &g };

struct __attribute__((packed)) PackedS {
	int i;
	__typeof(&func) funcPtr;	// aligned to 4
	__typeof(&func) funcPtr2;	// aligned to 4
	int j;
	int *p1;					// aligned to 8
	char k;
	int *p2;					// aligned to 1
};

__attribute__((aligned((16384))))
PackedS ps = { 0, &func, &func, 0, &g, 0, &g };

__asm(".code32; .text; .section __HIB, __text; .globl _foo; _foo: movl _foo, %esp; ret");

__attribute__((section(("__HIB, __text"))))
extern "C" int _start() {
	return s.funcPtr() + s.funcPtr2() + s.funcPtr3() + ps.funcPtr();
}