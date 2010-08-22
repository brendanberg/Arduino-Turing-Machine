#ifndef _TURING_H_
#define _TURING_H_
  
// State
typedef struct {
  char *name;
} state;

// Transition
typedef struct {
  state *initial;
  char symbol;
  char replacement;
  char direction;
  state *next;
} transition;

// Machine
typedef struct {
  state *initial;
  transition **transitions;
  state *final;

  char *inputSymbols;
  char blank;

} machine;

// Head
typedef struct {
  char *tape;
  int position;
  state *current;
} head;

#ifdef __cplusplus
extern "C"{
#endif

machine * machine_alloc();
void machine_create(machine **m);
void machine_destroy(machine *m);

int machine_step(machine *m, head *h);

void transition_create(transition **t);
void transition_destroy(transition *t);
void transition_init(transition *t, state *s, char c, char f, char d, state *q);

void state_create(state **s, char *c);
void state_destroy(state *s);

head * head_alloc();
void head_create(head **h);
void head_destroy(head *h);

#ifdef __cplusplus
} // extern "C"
#endif

#endif
